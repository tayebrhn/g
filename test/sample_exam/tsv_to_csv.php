<?php

//============================================================+
// File name   : tsv_to_csv.php
// Description : Standalone TSV-to-CSV converter.
//============================================================+

/**
 * Convert a TSV file to CSV format (RFC 4180).
 *
 * Usage (CLI):
 *   php tsv_to_csv.php input.tsv [output.csv]
 *
 * If output is omitted, prints to stdout.
 */

declare(strict_types=1);

// Inline the conversion function (avoids pulling in the full TCExam stack).
function F_text_to_tsv($str)
{
    if ($str === '' || $str === null) {
        return '';
    }
    $replaceTable = [
        "\0" => '',
        "\t" => '\t',
        "\n" => '\n',
        "\r" => '\r',
    ];
    return strtr($str, $replaceTable);
}

function F_tsv_to_text($str)
{
    if ($str === '' || $str === null) {
        return '';
    }
    $replaceTable = [
        '\t' => "\t",
        '\n' => "\n",
        '\r' => "\r",
    ];
    return strtr($str, $replaceTable);
}

function F_tsv_to_csv($tsv)
{
    if ($tsv === '' || $tsv === null) {
        return '';
    }
    $lines = explode("\n", $tsv);
    $csv_lines = [];
    foreach ($lines as $line) {
        $line = rtrim($line, "\r");
        if ($line === '') {
            $csv_lines[] = '';
            continue;
        }
        $had_trailing_tab = substr($line, -1) === "\t";
        $fields = explode("\t", $line);
        $csv_fields = [];
        foreach ($fields as $idx => $field) {
            $field = F_tsv_to_text($field);
            if ($field === '' && $had_trailing_tab && $idx === count($fields) - 1) {
                $field = '"';
            } elseif (strpbrk($field, ',"' . "\n") !== false) {
                $field = '"' . str_replace('"', '""', $field) . '"';
            }
            $csv_fields[] = $field;
        }
        $csv_lines[] = implode(',', $csv_fields);
    }
    return implode("\n", $csv_lines);
}

// --- Main -------------------------------------------------------

if (PHP_SAPI === 'cli') {
    // CLI mode
    if ($argc < 2) {
        fwrite(STDERR, "Usage: php tsv_to_csv.php <input.tsv> [output.csv]\n");
        exit(1);
    }
    $input = $argv[1];
    $output = $argv[2] ?? null;
} else {
    // Browser mode: show a simple upload form
    if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['tsvfile'])) {
        $tsv = file_get_contents($_FILES['tsvfile']['tmp_name']);
        $csv = F_tsv_to_csv($tsv);
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="' . pathinfo($_FILES['tsvfile']['name'], PATHINFO_FILENAME) . '.csv"');
        echo $csv;
        exit;
    }
    echo '<!DOCTYPE html><html><head><title>TSV to CSV</title></head><body>';
    echo '<h2>TSV to CSV Converter</h2>';
    echo '<form method="post" enctype="multipart/form-data">';
    echo '<input type="file" name="tsvfile" accept=".tsv,.tab" /> ';
    echo '<input type="submit" value="Convert to CSV" />';
    echo '</form></body></html>';
    exit;
}

if (! file_exists($input)) {
    fwrite(STDERR, "Error: file not found: $input\n");
    exit(1);
}

$tsv = file_get_contents($input);
if ($tsv === false) {
    fwrite(STDERR, "Error: could not read: $input\n");
    exit(1);
}

$csv = F_tsv_to_csv($tsv);

if ($output !== null) {
    file_put_contents($output, $csv);
    echo "Converted: $input -> $output\n";
} else {
    echo $csv;
}
