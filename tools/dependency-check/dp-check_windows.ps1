# Script: install-dependency-check.ps1

#UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Get-InstalledVersion {
    $dependencyCheckPath = "dependency-check"
    if (Test-Path $dependencyCheckPath) {
        $versionOutput = & $dependencyCheckPath --version
        $versionPattern = "Dependency-Check Core version ([\d\.]+)"
        if ($versionOutput -match $versionPattern) {
            return $matches[1]
        }
    }
    return $null
}


$VERSION_DPCHECK = Invoke-RestMethod -Uri "https://jeremylong.github.io/DependencyCheck/current.txt"

$installedVersion = Get-InstalledVersion

if ($installedVersion) {
    Write-Output "Versão instalada: $installedVersion"
}
else {
    Write-Output "Nenhuma versão instalada encontrada."
}

Write-Output "Versão disponível: $VERSION_DPCHECK"


if (-not $installedVersion -or [version]$VERSION_DPCHECK -gt [version]$installedVersion) {
    Write-Output "A versão instalada está desatualizada ou não foi encontrada. Atualizando para a versão $VERSION_DPCHECK..."
    
    
    $url = "https://github.com/jeremylong/DependencyCheck/releases/download/v$VERSION_DPCHECK/dependency-check-$VERSION_DPCHECK-release.zip"
    Invoke-WebRequest -Uri $url -OutFile "dependency-check.zip"
    
    
    Expand-Archive -Path "dependency-check.zip" -DestinationPath "$HOMEPATH\.dependency-check" -Force
    
    # Adicionar o caminho do binário ao PATH
    $env:PATH += ";C:\$HOMEPATH\.dependency-check\bin"
    
    
    Remove-Item -Path "dependency-check.zip"
    
    Write-Output "Atualização concluída. Nova versão instalada: $VERSION_DPCHECK"
}
else {
    Write-Output "A versão instalada ($installedVersion) já está atualizada."
}

dependency-check -v
