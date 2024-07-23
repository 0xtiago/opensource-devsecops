# Script: install-dependency-check.ps1

# Função para obter a versão instalada
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

# Obter a versão mais recente do Dependency Check
$VERSION_DPCHECK = Invoke-RestMethod -Uri "https://jeremylong.github.io/DependencyCheck/current.txt"

# Obter a versão instalada
$installedVersion = Get-InstalledVersion

if ($installedVersion) {
    Write-Output "Versão instalada: $installedVersion"
}
else {
    Write-Output "Nenhuma versão instalada encontrada."
}

Write-Output "Versão disponível: $VERSION_DPCHECK"

# Comparar versões e baixar se a versão disponível for mais nova
if (-not $installedVersion -or [version]$VERSION_DPCHECK -gt [version]$installedVersion) {
    Write-Output "A versão instalada está desatualizada ou não foi encontrada. Atualizando para a versão $VERSION_DPCHECK..."
    
    # Baixar o arquivo ZIP da versão mais recente
    $url = "https://github.com/jeremylong/DependencyCheck/releases/download/v$VERSION_DPCHECK/dependency-check-$VERSION_DPCHECK-release.zip"
    Invoke-WebRequest -Uri $url -OutFile "dependency-check.zip"
    
    # Descompactar o arquivo ZIP para um diretório de destino
    Expand-Archive -Path "dependency-check.zip" -DestinationPath "C:\$HOMEPATH\.dependency-check" -Force
    
    # Adicionar o caminho do binário ao PATH
    $env:PATH += ";C:\$HOMEPATH\.dependency-check\bin"
    
    # Limpar arquivos temporários
    Remove-Item -Path "dependency-check.zip"
    
    Write-Output "Atualização concluída. Nova versão instalada: $VERSION_DPCHECK"
}
else {
    Write-Output "A versão instalada ($installedVersion) já está atualizada."
}

dependency-check
