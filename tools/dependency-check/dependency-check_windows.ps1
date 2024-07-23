# dependency-check_windows.ps1
#Testado em: Dependency-Check Core version 10.0.3

# Definir a codificação do console para UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Definir o caminho de destino
$destinationPath = "$HOME\.dependency-check"

# Função para obter a versão instalada
function Get-InstalledVersion {
    $dependencyCheckPath = "$destinationPath\bin\dependency-check.bat"
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
    
    # Criar o diretório de destino se não existir
    if (-not (Test-Path -Path $destinationPath)) {
        New-Item -Path $destinationPath -ItemType Directory
    }
    
    # Descompactar o arquivo ZIP para o diretório de destino
    Expand-Archive -Path "dependency-check.zip" -DestinationPath . -Force
    Move-Item -Path ".\dependency-check\*" -Destination $destinationPath -Force
    Remove-Item -Path ".\dependency-check" -Recurse -Force
    
    # Adicionar o caminho do binário ao PATH
    $env:PATH += ";$destinationPath\bin"



    
    # Limpar arquivos temporários
    Remove-Item -Path "dependency-check.zip"
    
    Write-Output "Atualização concluída. Nova versão instalada: $VERSION_DPCHECK"
}
else {
    Write-Output "A versão instalada ($installedVersion) já está atualizada."
}


# Verifica se o arquivo de perfil do PowerShell existe
if (-Not (Test-Path -Path $PROFILE)) {
    # Cria o diretório do perfil se não existir
    $profileDir = Split-Path -Parent $PROFILE
    if (-Not (Test-Path -Path $profileDir)) {
        New-Item -Path $profileDir -ItemType Directory -Force
    }

    # Cria o arquivo de perfil
    New-Item -Path $PROFILE -ItemType File -Force

    # Adiciona as linhas de configuração ao arquivo de perfil
    Add-Content -Path $PROFILE -Value '$env:PATH += ";$destinationPath\bin"'
}

# Caso o arquivo já exista, adiciona as linhas de configuração ao final do arquivo
else {
    # Leia o conteúdo do arquivo
    $content = Get-Content -Path $PROFILE

    # Defina a linha que precisa ser verificada
    $lineToCheck = '$env:PATH += ";$destinationPath\bin"'

    # Verifique se a linha já está presente no arquivo
    if ($content -notcontains $lineToCheck) {
        # Adicione a linha ao final do arquivo
        Add-Content -Path $PROFILE -Value $lineToCheck
        Write-Output "Linha adicionada ao perfil: $lineToCheck"
    } 
    else {
        Write-Output "Linha já está presente no perfil."
    }   
}
# Exibe mensagem de confirmação
Write-Output "Configuração do dependency-checK adicionada ao perfil do PowerShell."