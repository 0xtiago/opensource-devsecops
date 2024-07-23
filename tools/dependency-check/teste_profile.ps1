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
    Add-Content -Path $PROFILE -Value '$env:PATH += ";$HOME\.dependency-check\bin"'
}

# Caso o arquivo já exista, adiciona as linhas de configuração ao final do arquivo
else {
    # Leia o conteúdo do arquivo
    $content = Get-Content -Path $PROFILE

    # Defina a linha que precisa ser verificada
    $lineToCheck = '$env:PATH += ";$HOME\.dependency-check\bin"'

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
