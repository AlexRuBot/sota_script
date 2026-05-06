# Sota VLESS Updater — PowerShell Installer
# Usage: iwr -useb https://raw.githubusercontent.com/YOUR_USERNAME/sota-vless-updater/main/scripts/install.ps1 | iex

$Repo = "AlexRuBot/sota_script"
$BinaryName = "sota_vless_updater"
$OS = "windows"
$Arch = "amd64"

# Detect architecture
if ($env:PROCESSOR_ARCHITECTURE -eq "AMD64") {
    $Arch = "amd64"
} elseif ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") {
    $Arch = "arm64"
} else {
    Write-Host "❌ Unsupported architecture: $($env:PROCESSOR_ARCHITECTURE)" -ForegroundColor Red
    exit 1
}

$Asset = "${BinaryName}_${OS}_${Arch}.exe"

# Get latest release
$releasesUrl = "https://api.github.com/repos/$Repo/releases/latest"
try {
    $release = Invoke-RestMethod -Uri $releasesUrl -TimeoutSec 10
    $latestTag = $release.tag_name
} catch {
    Write-Host "⚠ Could not detect latest release. Using fallback..." -ForegroundColor Yellow
    $latestTag = "v1.0.0"
}

$downloadUrl = "https://github.com/$Repo/releases/download/$latestTag/$Asset"

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "Sota VLESS Updater — Installer" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "OS:        $OS"
Write-Host "Arch:      $Arch"
Write-Host "Version:   $latestTag"
Write-Host "Download:  $downloadUrl"
Write-Host ""

$tmpDir = [System.IO.Path]::GetTempPath()
$tmpFile = Join-Path $tmpDir $Asset

# Download
Write-Host "[1/3] Downloading binary..." -ForegroundColor Green
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tmpFile -TimeoutSec 30
} catch {
    Write-Host "❌ Download failed: $_" -ForegroundColor Red
    exit 1
}

# Install
$installDir = "$env:LOCALAPPDATA\Programs"
if (!(Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}
$installPath = Join-Path $installDir "$BinaryName.exe"
Move-Item -Path $tmpFile -Destination $installPath -Force

Write-Host "[2/3] Installed to: $installPath" -ForegroundColor Green

# Run
Write-Host "[3/3] Starting updater..." -ForegroundColor Green
Write-Host ""
& $installPath
