# Enable TLS 1.2 for secure downloads (if connected)
[Net.ServicePointManager]::SecurityProtocol = 
    [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# Paths
$offlineModulesPath = 'C:\Temp\OfflineModules'
$docs               = [Environment]::GetFolderPath('MyDocuments')
$ps5ModulePath      = Join-Path $docs 'WindowsPowerShell\Modules'

# Ensure offline modules folder exists
if (!(Test-Path $offlineModulesPath)) {
    New-Item -ItemType Directory -Path $offlineModulesPath -Force | Out-Null
}

# Remove any existing installations in PS 5.1 module path
t$modulesToRemove = @('PowerShellGet','PackageManagement')
foreach ($mod in $modulesToRemove) {
    $moduleDir = Join-Path $ps5ModulePath $mod
    if (Test-Path $moduleDir) {
        Write-Host "Removing existing module path: $moduleDir"
        Remove-Item $moduleDir -Recurse -Force
    }
}

# Extract PowerShellGet
$psGetVersion = '2.2.5.1'
$psGetNupkg   = "C:\Windows\system32\PowerShellGet.$psGetVersion.nupkg"
$psGetDest    = Join-Path $ps5ModulePath "PowerShellGet\$psGetVersion"
New-Item -ItemType Directory -Path $psGetDest -Force | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($psGetNupkg, $psGetDest)

# Extract PackageManagement
t$pmOfflineDir = Join-Path $offlineModulesPath 'PackageManagement'
$pmVersion    = (Get-ChildItem $pmOfflineDir | Select-Object -First 1).Name
$pmNupkg      = Join-Path $pmOfflineDir "$pmVersion\$pmVersion.nupkg"
$pmDest       = Join-Path $ps5ModulePath "PackageManagement\$pmVersion"
New-Item -ItemType Directory -Path $pmDest -Force | Out-Null
[System.IO.Compression.ZipFile]::ExtractToDirectory($pmNupkg, $pmDest)

# Optionally register a local PSRepository for future offline installs
try {
    Register-PSRepository -Name LocalPSRepo -SourceLocation $offlineModulesPath -InstallationPolicy Trusted -ErrorAction Stop
    Write-Host "LocalPSRepo registered."
} catch {
    Write-Host "LocalPSRepo already registered or could not be added."
}

# Final verification
Write-Host "Installation complete. Available modules:" -ForegroundColor Green
Get-Module PowerShellGet,PackageManagement -ListAvailable
