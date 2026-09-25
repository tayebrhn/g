<#
.SYNOPSIS
    Installs or reconfigures a TCExam production node (Windows + Nginx + php-cgi).

.DESCRIPTION
    Creates the C:\tcexam release layout, provisions the per-deployment
    configuration from the config.default templates, generates the nginx
    configuration, registers the php-cgi and nginx Windows services (NSSM),
    and opens the firewall. Run once per node; see DEPLOYMENT.md.

.PARAMETER Mode
    standalone   - one server, TLS terminated by nginx on this node.
    backend      - application node behind the load balancer (plain HTTP).
    loadbalancer - nginx load-balancer node in front of the backend nodes.

.EXAMPLE
    # single server with TLS
    .\install-node.ps1 -SourceDir C:\build\tcexam -NssmExe C:\tools\nssm.exe `
        -Mode standalone -PublicUrl https://exam.example.org `
        -DbUser tcexam -DbPassword 'secret' -SslCert C:\tls\fullchain.pem -SslKey C:\tls\privkey.pem

.EXAMPLE
    # application node of an HA cluster
    .\install-node.ps1 -SourceDir C:\build\tcexam -NssmExe C:\tools\nssm.exe `
        -Mode backend -PublicUrl https://exam.example.org `
        -DbHost db01 -DbUser tcexam -DbPassword 'secret' `
        -MediaShare \\filesrv\tcexam-media -AllowedCidr 10.0.0.10
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$SourceDir,

    [string]$TcexamHome = 'C:\tcexam',
    [string]$Tag = 'initial',
    [string]$PhpDir = 'C:\php',
    [string]$NginxDir = 'C:\nginx',
    [Parameter(Mandatory = $true)][string]$NssmExe,

    [ValidateSet('standalone', 'backend', 'loadbalancer')]
    [string]$Mode = 'standalone',

    # TCExam configuration values (applied to shared/config)
    [string]$PublicUrl = 'https://exam.example.org',
    [string]$DbHost = 'localhost',
    [string]$DbPort = '3306',
    [string]$DbName = 'tcexam',
    [string]$DbUser = 'tcexam',
    [string]$DbPassword = '',
    [string]$RandomSecurity = '',

    # HA options
    [string]$MediaShare = '',
    [int]$ListenPort = 0,
    [string[]]$AllowedCidr = @(),
    [string[]]$AppNodes = @(),

    # TLS (standalone and loadbalancer modes)
    [string]$SslCert = '',
    [string]$SslKey = ''
)

$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------------------
# helpers
# ---------------------------------------------------------------------------
function Write-Step([string]$Message) {
    Write-Host ('==> ' + $Message) -ForegroundColor Cyan
}

function Assert-Condition([bool]$Condition, [string]$Message) {
    if (-not $Condition) {
        throw $Message
    }
}

function Invoke-Robocopy {
    param([string]$Source, [string]$Destination, [string[]]$ExtraArgs = @())
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    $null = robocopy $Source $Destination /E /R:2 /W:2 @ExtraArgs
    if ($LASTEXITCODE -ge 8) {
        throw "robocopy failed (exit $LASTEXITCODE): $Source -> $Destination"
    }
    return $LASTEXITCODE
}

function Set-DefineValue {
    param([string]$Path, [string]$Constant, [string]$Value)
    Assert-Condition (Test-Path -LiteralPath $Path) "missing configuration file: $Path"
    Assert-Condition ($Value -notmatch "'") "the value of $Constant must not contain single quotes"
    $content = Get-Content -LiteralPath $Path -Raw
    $pattern = "(?m)(define\(\s*'" + [regex]::Escape($Constant) + "',\s*)'[^']*'(\s*\))"
    Assert-Condition ($content -match $pattern) "constant $Constant not found in $Path"
    # a MatchEvaluator builds the replacement literally, so values may
    # contain '$', '#', '\' or any other regex-replacement metacharacter
    $content = [regex]::Replace($content, $pattern, { param($m) $m.Groups[1].Value + "'" + $Value + "'" + $m.Groups[2].Value })
    Set-Content -LiteralPath $Path -Value $content -NoNewline -Encoding UTF8
    Write-Host ("    {0,-32} = {1}" -f $Constant, $(if ($Constant -like '*PASSWORD') { '********' } else { $Value }))
}

function New-Junction([string]$Link, [string]$Target) {
    if (Test-Path -LiteralPath $Link) {
        return
    }

    $null = cmd /c mklink /J "$Link" "$Target"
    Assert-Condition ($LASTEXITCODE -eq 0) "could not create junction $Link -> $Target"
}

function Get-Template([string]$TemplatePath) {
    Assert-Condition (Test-Path -LiteralPath $TemplatePath) "missing template: $TemplatePath"
    return (Get-Content -LiteralPath $TemplatePath -Raw)
}

function Set-TemplateToken {
    param([string]$Content, [string]$Token, [string]$Value)
    return $Content.Replace($Token, $Value)
}

# ---------------------------------------------------------------------------
# 0. prerequisites
# ---------------------------------------------------------------------------
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Assert-Condition $isAdmin 'run this script from an elevated PowerShell session'

Assert-Condition (Test-Path -LiteralPath $SourceDir) "source directory not found: $SourceDir"
Assert-Condition (Test-Path -LiteralPath "$PhpDir\php-cgi.exe") "php-cgi.exe not found in $PhpDir (install the PHP NTS build first)"
Assert-Condition (Test-Path -LiteralPath "$NginxDir\nginx.exe") "nginx.exe not found in $NginxDir (extract the nginx Windows zip first)"
Assert-Condition (Test-Path -LiteralPath $NssmExe) "nssm.exe not found: $NssmExe"

if ($Mode -ne 'loadbalancer') {
    Assert-Condition ($DbUser -ne '') 'provide -DbUser (a dedicated MySQL account for TCExam)'
}

if ($Mode -eq 'standalone') {
    Assert-Condition (($SslCert -ne '') -and ($SslKey -ne '')) 'standalone mode requires -SslCert and -SslKey'
}

if ($Mode -eq 'loadbalancer') {
    Assert-Condition (($SslCert -ne '') -and ($SslKey -ne '')) 'loadbalancer mode requires -SslCert and -SslKey'
    Assert-Condition ($AppNodes.Count -ge 2) 'loadbalancer mode requires -AppNodes with at least two "host:port" entries'
}

if ($RandomSecurity -eq '') {
    # generated once per installation: must be identical on every node
    $chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnopqrstuvwxyz23456789'
    $rng = New-Object System.Security.Cryptography.RNGCryptoServiceProvider
    $bytes = New-Object byte[] 48
    $rng.GetBytes($bytes)
    $RandomSecurity = -join ($bytes | ForEach-Object { $chars[$_ % $chars.Length] })
    Write-Host "generated K_RANDOM_SECURITY (save it! it must be identical on every node):" -ForegroundColor Yellow
    Write-Host "    $RandomSecurity"
}

if ($ListenPort -eq 0) {
    $ListenPort = 80
}

# ---------------------------------------------------------------------------
# 1. release layout
# ---------------------------------------------------------------------------
Write-Step 'creating the release layout'

$releaseDir = Join-Path $TcexamHome ('releases\' + $Tag)
Invoke-Robocopy $SourceDir $releaseDir @('/XD', '.git') | Out-Null

# the installer must never be reachable over HTTP (UPGRADE.TXT step 5)
if (Test-Path -LiteralPath (Join-Path $releaseDir 'install')) {
    Remove-Item -LiteralPath (Join-Path $releaseDir 'install') -Recurse -Force
    Write-Host '    install/ removed from the release'
}

foreach ($dir in @('logs', 'tmp')) {
    New-Item -ItemType Directory -Path (Join-Path $TcexamHome $dir) -Force | Out-Null
}

# ---------------------------------------------------------------------------
# 2. per-deployment configuration from the config.default templates
# ---------------------------------------------------------------------------
Write-Step 'provisioning the configuration from config.default (only missing files)'

if ($Mode -ne 'loadbalancer') {
    foreach ($area in @('admin', 'public', 'shared')) {
        $defaultDir = Join-Path $releaseDir ($area + '\config.default')
        $configDir = Join-Path $releaseDir ($area + '\config')
        if (Test-Path -LiteralPath $defaultDir) {
            # /XC /XN /XO: copy only the files that do not exist yet,
            # so a re-run never overwrites an already provisioned node
            Invoke-Robocopy $defaultDir $configDir @('/XC', '/XN', '/XO') | Out-Null
        }
    }

    Write-Step 'applying the deployment values to the configuration'
    $pathsFile = Join-Path $releaseDir 'shared\config\tce_paths.php'
    $dbFile = Join-Path $releaseDir 'shared\config\tce_db_config.php'
    $constFile = Join-Path $releaseDir 'shared\config\tce_general_constants.php'

    # K_PATH_MAIN points at the "current" junction so that the carried-over
    # configuration stays valid on every future release switch
    $mainPath = (($TcexamHome -replace '\\', '/').TrimEnd('/') + '/current/')
    Set-DefineValue $pathsFile 'K_PATH_MAIN' $mainPath
    Set-DefineValue $pathsFile 'K_PATH_HOST' $PublicUrl
    Set-DefineValue $pathsFile 'K_PATH_TCEXAM' '/'
    Set-DefineValue $dbFile 'K_DATABASE_TYPE' 'MYSQL'
    Set-DefineValue $dbFile 'K_DATABASE_HOST' $DbHost
    Set-DefineValue $dbFile 'K_DATABASE_PORT' $DbPort
    Set-DefineValue $dbFile 'K_DATABASE_NAME' $DbName
    Set-DefineValue $dbFile 'K_DATABASE_USER_NAME' $DbUser
    Set-DefineValue $dbFile 'K_DATABASE_USER_PASSWORD' $DbPassword
    Set-DefineValue $constFile 'K_RANDOM_SECURITY' $RandomSecurity
    Write-Host '    (K_COOKIE_SECURE is already enabled by the production templates; verify tce_config.php)'
}

# ---------------------------------------------------------------------------
# 3. shared media (HA backend nodes)
# ---------------------------------------------------------------------------
if ($Mode -ne 'loadbalancer' -and $MediaShare -ne '') {
    Write-Step 'mounting the shared media and backup folders'
    foreach ($sub in @('uid', 'backup')) {
        $unc = (Join-Path $MediaShare $sub) -replace '/', '\'
        New-Item -ItemType Directory -Path $unc -Force | Out-Null
        New-Junction (Join-Path $releaseDir ('cache\' + $sub)) $unc
        Write-Host "    cache\$sub -> $unc"
    }
}

# ---------------------------------------------------------------------------
# 4. php.ini production overrides
# ---------------------------------------------------------------------------
if ($Mode -ne 'loadbalancer') {
    Write-Step 'applying the PHP production settings'
    $phpIni = Join-Path $PhpDir 'php.ini'
    if (-not (Test-Path -LiteralPath $phpIni)) {
        Copy-Item -LiteralPath (Join-Path $PhpDir 'php.ini-production') -Destination $phpIni
        Write-Host '    php.ini created from php.ini-production'
    }

    $marker = '; --- TCExam production overrides (deploy\install-node.ps1) ---'
    if (-not (Select-String -LiteralPath $phpIni -Pattern ([regex]::Escape($marker)) -Quiet)) {
        $tune = Get-Template (Join-Path $releaseDir 'deploy\php\php-production.ini')
        $homeFwd = $TcexamHome -replace '\\', '/'
        $append = @(
            '',
            $marker,
            'error_log = "' + $homeFwd + '/logs/php-error.log"',
            'upload_tmp_dir = "' + $homeFwd + '/tmp"',
            'sys_temp_dir = "' + $homeFwd + '/tmp"',
            'session.save_path = "' + $homeFwd + '/tmp"',
            $tune
        ) -join [Environment]::NewLine
        Add-Content -LiteralPath $phpIni -Value $append -Encoding ASCII
        Write-Host '    production overrides appended (opcache validate_timestamps=0: run deploy-release.ps1 after each code change, it restarts the services)'
    }
}

# ---------------------------------------------------------------------------
# 5. nginx configuration
# ---------------------------------------------------------------------------
Write-Step 'generating the nginx configuration'

$confTarget = Join-Path $NginxDir 'conf\nginx.conf'
$confBackup = $confTarget + '.bak-' + (Get-Date -Format 'yyyyMMdd-HHmmss')
if (Test-Path -LiteralPath $confTarget) {
    Copy-Item -LiteralPath $confTarget -Destination $confBackup
    Write-Host "    previous nginx.conf saved as $(Split-Path -Leaf $confBackup)"
}

$serverName = ([uri]$PublicUrl).Host
if ($serverName -eq '') { $serverName = '_' }

if ($Mode -eq 'loadbalancer') {
    $conf = Get-Template (Join-Path $releaseDir 'deploy\nginx\lb-node.conf')
    $conf = Set-TemplateToken $conf '__SERVER_NAME__' $serverName
    $conf = Set-TemplateToken $conf '__SSL_CERT__' ($SslCert -replace '\\', '/')
    $conf = Set-TemplateToken $conf '__SSL_KEY__' ($SslKey -replace '\\', '/')
    $nodes = @($AppNodes)
    $conf = Set-TemplateToken $conf '__APP1_HOST__' ($nodes[0].Split(':')[0])
    $conf = Set-TemplateToken $conf '__APP1_PORT__' ($(if ($nodes[0].Contains(':')) { $nodes[0].Split(':')[1] } else { '80' }))
    $conf = Set-TemplateToken $conf '__APP2_HOST__' ($nodes[1].Split(':')[0])
    $conf = Set-TemplateToken $conf '__APP2_PORT__' ($(if ($nodes[1].Contains(':')) { $nodes[1].Split(':')[1] } else { '80' }))
} else {
    $conf = Get-Template (Join-Path $releaseDir 'deploy\nginx\app-node.conf')
    $conf = Set-TemplateToken $conf '__TCEXAM_ROOT__' (($releaseDir -replace '\\', '/'))
    $conf = Set-TemplateToken $conf '__SERVER_NAME__' $serverName

    if ($Mode -eq 'standalone') {
        $redirect = @(
            '    server {',
            '        listen 80;',
            '        server_name ' + $serverName + ';',
            '        return 301 https://$host$request_uri;',
            '    }'
        ) -join [Environment]::NewLine
        $conf = Set-TemplateToken $conf '__HTTP_REDIRECT_BLOCK__' $redirect
        $conf = Set-TemplateToken $conf '__LISTEN_BLOCK__' '443 ssl http2'
        $ssl = @(
            '        ssl_certificate      ' + ($SslCert -replace '\\', '/') + ';',
            '        ssl_certificate_key  ' + ($SslKey -replace '\\', '/') + ';',
            '        ssl_protocols        TLSv1.2 TLSv1.3;'
        ) -join [Environment]::NewLine
        $conf = Set-TemplateToken $conf '__SSL_DIRECTIVES__' $ssl
        $conf = Set-TemplateToken $conf '__FASTCGI_HTTPS__' '$https'
        $conf = Set-TemplateToken $conf '__REAL_IP_BLOCK__' ''
        $ListenPort = 443
    } else {
        $conf = Set-TemplateToken $conf '__HTTP_REDIRECT_BLOCK__' ''
        $conf = Set-TemplateToken $conf '__LISTEN_BLOCK__' ([string]$ListenPort)
        $conf = Set-TemplateToken $conf '__SSL_DIRECTIVES__' ''
        # behind the TLS-terminating load balancer PHP must see the real scheme
        $conf = Set-TemplateToken $conf '__FASTCGI_HTTPS__' '$http_x_forwarded_proto'
        if ($AllowedCidr.Count -gt 0) {
            $realIp = @(
                '        set_real_ip_from ' + ($AllowedCidr -join '; set_real_ip_from ') + ';',
                '        real_ip_header X-Forwarded-For;'
            ) -join [Environment]::NewLine
            $conf = Set-TemplateToken $conf '__REAL_IP_BLOCK__' $realIp
        } else {
            $conf = Set-TemplateToken $conf '__REAL_IP_BLOCK__' ''
        }
    }
}

Set-Content -LiteralPath $confTarget -Value $conf -Encoding ASCII
Write-Host "    nginx.conf written to $confTarget"

Push-Location $NginxDir
try {
    $null = & "$NginxDir\nginx.exe" -t 2>&1
    Assert-Condition ($LASTEXITCODE -eq 0) 'nginx -t rejected the configuration (see the error above)'
    Write-Host '    nginx -t passed'
} finally {
    Pop-Location
}

# ---------------------------------------------------------------------------
# 6. current junction
# ---------------------------------------------------------------------------
Write-Step 'activating the release'
$currentLink = Join-Path $TcexamHome 'current'
if (Test-Path -LiteralPath $currentLink) {
    $null = cmd /c rmdir "$currentLink"
}
New-Junction $currentLink $releaseDir
Write-Host "    current -> $releaseDir"

# ---------------------------------------------------------------------------
# 7. Windows services (NSSM)
# ---------------------------------------------------------------------------
Write-Step 'registering the Windows services'
$phpOut = Join-Path $TcexamHome 'logs\php-service.out.log'
$phpErr = Join-Path $TcexamHome 'logs\php-service.err.log'
$ngxOut = Join-Path $TcexamHome 'logs\nginx-service.out.log'
$ngxErr = Join-Path $TcexamHome 'logs\nginx-service.err.log'

if ($Mode -ne 'loadbalancer') {
    & $NssmExe stop TCexamPHP 2>$null
    & $NssmExe remove TCexamPHP confirm 2>$null
    & $NssmExe install TCexamPHP "$PhpDir\php-cgi.exe" '-b 127.0.0.1:9000'
    & $NssmExe set TCexamPHP AppDirectory $PhpDir | Out-Null
    & $NssmExe set TCexamPHP AppEnvironmentExtra 'PHP_FCGI_CHILDREN=16' 'PHP_FCGI_MAX_REQUESTS=500' | Out-Null
    & $NssmExe set TCexamPHP AppStdout $phpOut | Out-Null
    & $NssmExe set TCexamPHP AppStderr $phpErr | Out-Null
    & $NssmExe set TCexamPHP AppExit Default Restart | Out-Null
    & $NssmExe set TCexamPHP AppRestartDelay 5000 | Out-Null
    & $NssmExe set TCexamPHP Start SERVICE_AUTO_START | Out-Null
    Write-Host '    TCexamPHP  (php-cgi.exe -b 127.0.0.1:9000)'
}

& $NssmExe stop TCexamNGINX 2>$null
& $NssmExe remove TCexamNGINX confirm 2>$null
& $NssmExe install TCexamNGINX "$NginxDir\nginx.exe"
& $NssmExe set TCexamNGINX AppDirectory $NginxDir | Out-Null
& $NssmExe set TCexamNGINX AppStdout $ngxOut | Out-Null
& $NssmExe set TCexamNGINX AppStderr $ngxErr | Out-Null
& $NssmExe set TCexamNGINX AppExit Default Restart | Out-Null
& $NssmExe set TCexamNGINX AppRestartDelay 5000 | Out-Null
& $NssmExe set TCexamNGINX Start SERVICE_AUTO_START | Out-Null
Write-Host '    TCexamNGINX (nginx.exe)'

# ---------------------------------------------------------------------------
# 8. firewall
# ---------------------------------------------------------------------------
Write-Step 'configuring the firewall'
$ports = @()
if ($Mode -eq 'loadbalancer') {
    $ports = @(80, 443)
} elseif ($Mode -eq 'standalone') {
    $ports = @(80, 443)
} else {
    $ports = @($ListenPort)
}

foreach ($port in $ports) {
    $ruleName = 'TCExam ' + $Mode + ' ' + $port
    Remove-NetFirewallRule -DisplayName $ruleName -ErrorAction SilentlyContinue
    if ($AllowedCidr.Count -gt 0) {
        New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Action Allow -Protocol TCP -LocalPort $port -RemoteAddress $AllowedCidr | Out-Null
        Write-Host ("    {0}: TCP/{1} from {2}" -f $ruleName, $port, ($AllowedCidr -join ', '))
    } else {
        New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -Action Allow -Protocol TCP -LocalPort $port | Out-Null
        Write-Host ("    {0}: TCP/{1} from any host" -f $ruleName, $port)
    }
}

# ---------------------------------------------------------------------------
# 9. start and health check
# ---------------------------------------------------------------------------
Write-Step 'starting the services'
if ($Mode -ne 'loadbalancer') {
    & $NssmExe start TCexamPHP | Out-Null
}
& $NssmExe start TCexamNGINX | Out-Null
Start-Sleep -Seconds 3

if ($Mode -ne 'loadbalancer') {
    Write-Step 'checking the health endpoint'
    $scheme = $(if ($Mode -eq 'standalone') { 'https' } else { 'http' })
    $healthUrl = $scheme + '://127.0.0.1:' + $ListenPort + '/health.txt'
    $ok = $false
    for ($i = 0; $i -lt 10; ++$i) {
        try {
            $resp = Invoke-WebRequest -Uri $healthUrl -UseBasicParsing -TimeoutSec 5
            if ($resp.StatusCode -eq 200) { $ok = $true; break }
        } catch { Start-Sleep -Seconds 2 }
    }
    Assert-Condition $ok "health check failed on $healthUrl (inspect $($ngxErr) and $($phpErr))"
    Write-Host "    $healthUrl -> 200 OK"
}

# ---------------------------------------------------------------------------
# 10. next steps
# ---------------------------------------------------------------------------
Write-Host ''
Write-Host 'INSTALLATION COMPLETE' -ForegroundColor Green
Write-Host ('    release : {0}' -f $releaseDir)
Write-Host ('    url     : {0}' -f $PublicUrl)
if ($Mode -ne 'loadbalancer') {
    Write-Host ''
    Write-Host 'NEXT STEPS' -ForegroundColor Yellow
    Write-Host '  1. create the database and account (see DEPLOYMENT.md section 5), then apply the'
    Write-Host '     schema or run the upgrade script from the release:'
    Write-Host ('       mysql --host {0} -u <admin> -p {1} < "{2}\install\upgrade\mysql\mysql_db_upgrade_16to17.sql"' -f $DbHost, $DbName, $releaseDir)
    Write-Host '  2. verify the node:'
    Write-Host ('       powershell -File {0}\deploy\verify-deployment.ps1 -BaseUrl {1}' -f $releaseDir, $PublicUrl)
    Write-Host '  3. change the seeded admin password immediately (its hash ships in the repository).'
    if ($Mode -eq 'backend') {
        Write-Host '  4. this node is an HA backend: register it on the load balancer and keep the same'
        Write-Host '     K_RANDOM_SECURITY on every node.'
    }
}
