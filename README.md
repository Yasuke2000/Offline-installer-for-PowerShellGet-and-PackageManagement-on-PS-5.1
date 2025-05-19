# Offline-installer-for-PowerShellGet-and-PackageManagement-on-PS-5.1


Description

Install-PSModulesOffline.ps1 is a PowerShell script designed to facilitate the offline installation of the PowerShellGet and PackageManagement modules for Windows PowerShell 5.1. It automates the following tasks:

Cleanup: Removes any existing user-scoped installations of PowerShellGet and PackageManagement from the %USERPROFILE%\Documents\WindowsPowerShell\Modules directory.

Extraction: Unpacks the PowerShellGet module from a pre-downloaded .nupkg file.

Copy: Copies the PackageManagement module from a local offline repository (C:\Temp\OfflineModules).

Repository Registration (optional): Registers the offline folder as a file-based PSRepository for future Install-Module operations.

Verification: Lists available versions of both modules to confirm successful installation.

This script enables administrators to prepare and deploy PowerShell module dependencies in environments without internet connectivity.

Prerequisites

Windows PowerShell 5.1

A downloaded copy of PowerShellGet.<version>.nupkg in C:\Windows\system32 (for example, PowerShellGet.2.2.5.1.nupkg).

An offline repository folder, e.g., C:\Temp\OfflineModules\PackageManagement\<version>, created via Save-Module on a connected machine.

Administrator privileges to run the script.

Usage

Place the script (Install-PSModulesOffline.ps1) on the target server.

Customize the configuration section at the top of the script if your paths or versions differ.

Run PowerShell as Administrator and execute:

& 'C:\Path\To\Install-PSModulesOffline.ps1'

Verify the modules are installed:

Get-Module PowerShellGet, PackageManagement -ListAvailable

Configuration Section

At the top of Install-PSModulesOffline.ps1, you can modify:

$offlineModulesPath: Path to your local offline module store (default: C:\Temp\OfflineModules).

$psGetVersion: Version of the PowerShellGet module (default: 2.2.5.1).

$psGetNupkgPath: Full path to the .nupkg file for PowerShellGet.

Notes

The script uses the .NET System.IO.Compression.ZipFile API to extract .nupkg archives directly, bypassing the need to rename files.

Windows PowerShell 5.1 uses the %USERPROFILE%\Documents\WindowsPowerShell\Modules folder, not the LocalAppData path used by PowerShell 7.

Registering LocalPSRepo is optional but allows future Install-Module operations to point at your offline store.

Troubleshooting

Locked files: Ensure all PowerShell hosts (ISE, VS Code, background jobs) are closed before running.

Missing folders: The script will create required folders if they do not exist.

Version mismatches: Double-check the $psGetVersion and offline repository contents.

License

MIT License.
