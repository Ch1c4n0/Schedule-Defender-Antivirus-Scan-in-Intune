# filepath: c:\Users\Chicano\OneDrive\Assessament\Get-ScanDefender.ps1
# Authenticate to Microsoft Graph
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All","DeviceManagementConfiguration.Read.All"

# Get all devices managed by Intune
$devices = Get-MgDeviceManagementManagedDevice

# Create a list to store the results
$results = @()

foreach ($device in $devices) {
    # Defender scan info is NOT available via Microsoft Graph PowerShell
    $lastQuickScan = "N/A"
    $lastFullScan  = "N/A"

    $results += [PSCustomObject]@{
        DeviceName      = $device.DeviceName
        LastQuickScan   = $lastQuickScan
        LastFullScan    = $lastFullScan
    }
}

# Generate HTML
$html = @"
<html>
<head>
    <title>Defender for Endpoint Report</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>Defender for Endpoint Report</h2>
    <table>
        <tr>
            <th>Device Name</th>
            <th>Last Quick Scan</th>
            <th>Last Full Scan</th>
        </tr>
"@

foreach ($item in $results) {
    $html += "<tr>
        <td>$($item.DeviceName)</td>
        <td>$($item.LastQuickScan)</td>
        <td>$($item.LastFullScan)</td>
    </tr>"
}

$html += @"
    </table>
</body>
</html>
"@

# Save the HTML
$html | Out-File -Encoding utf8 "DefenderReport.html"
