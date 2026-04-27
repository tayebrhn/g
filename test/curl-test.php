<?php
echo "<h2>Final cURL Diagnostic</h2>";

// Test 1: Extension loaded?
echo "<h3>Test 1: extension_loaded('curl')</h3>";
if (extension_loaded('curl')) {
    echo "✅ PASS: curl extension loaded<br>";
} else {
    echo "❌ FAIL: curl extension NOT loaded<br>";
}

// Test 2: Function exists?
echo "<h3>Test 2: function_exists('curl_init')</h3>";
if (function_exists('curl_init')) {
    echo "✅ PASS: curl_init() exists<br>";
} else {
    echo "❌ FAIL: curl_init() missing<br>";
}

// Test 3: Constants defined?
echo "<h3>Test 3: cURL Constants</h3>";
$constants = [
    'CURLOPT_CONNECTTIMEOUT',
    'CURLOPT_TIMEOUT',
    'CURLOPT_RETURNTRANSFER',
    'CURLOPT_URL'
];

foreach ($constants as $const) {
    if (defined($const)) {
        echo "✅ $const = " . constant($const) . "<br>";
    } else {
        echo "❌ $const is UNDEFINED<br>";
    }
}

// Test 4: Try to use cURL
echo "<h3>Test 4: Live cURL Test</h3>";
if (function_exists('curl_init')) {
    $ch = @curl_init('https://example.com');
    if ($ch) {
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_TIMEOUT, 5);
        $response = curl_exec($ch);
        if ($response) {
            echo "✅ cURL executed successfully<br>";
        } else {
            echo "❌ cURL execution failed: " . curl_error($ch) . "<br>";
        }
        curl_close($ch);
    } else {
        echo "❌ Failed to initialize cURL<br>";
    }
} else {
    echo "Skipping - curl_init missing<br>";
}

// Test 5: PHP Info summary
echo "<h3>Test 5: PHP Configuration</h3>";
echo "PHP Version: " . phpversion() . "<br>";
echo "Server API: " . php_sapi_name() . "<br>";
echo "extension_dir: " . ini_get('extension_dir') . "<br>";
?>
