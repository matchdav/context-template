# Install dependencies for Windows using Chocolatey
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey not found. Please install Chocolatey first: https://chocolatey.org/install"
    exit 1
}

# Ensure yq is available to parse dependencies.yml
if (!(Get-Command yq -ErrorAction SilentlyContinue)) {
    Write-Host "Installing yq for YAML parsing..."
    choco install yq -y
}

$deps = yq ".cli[]" "$PSScriptRoot\dependencies.yml"
foreach ($dep in $deps) {
    if (!(Get-Command $dep -ErrorAction SilentlyContinue)) {
        Write-Host "Installing $dep..."
        choco install $dep -y
    } else {
        Write-Host "$dep already installed."
    }
}
