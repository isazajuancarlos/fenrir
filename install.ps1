# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 Juan Carlos Isaza
#
# Instalador de usuario de fenrir-host para Windows, SIN privilegios de administrador.
# Descarga el binario de la ultima Release, lo deja en %LOCALAPPDATA%\fenrir, registra
# el host de native messaging (archivo JSON + clave HKCU) y anade el binario al PATH.
#
#   irm https://raw.githubusercontent.com/isazajuancarlos/fenrir/master/install.ps1 | iex

$ErrorActionPreference = "Stop"

# El transporte por named pipe en Windows está endurecido (nombre per-usuario
# fenrir-<USERNAME>.sock + FILE_FLAG_FIRST_PIPE_INSTANCE + DACL solo-owner, y
# autenticación del servidor por challenge-response HMAC-SHA256 con token
# solo-usuario). Probado en Windows real con el binario 0.1.6. install.sh cubre
# Linux/macOS.

$repo  = "isazajuancarlos/fenrir"
$extId = "fenrir@xiliux.com"

$arch = if ($env:PROCESSOR_ARCHITECTURE -eq "ARM64") { "aarch64" } else { "x86_64" }
$asset = "fenrir-host-windows-$arch.exe"

$dir = Join-Path $env:LOCALAPPDATA "fenrir"
$bin = Join-Path $dir "fenrir-host.exe"
New-Item -ItemType Directory -Force -Path $dir | Out-Null

Write-Host "Descargando $asset ..."
Invoke-WebRequest -Uri "https://github.com/$repo/releases/latest/download/$asset" -OutFile $bin

# Manifiesto de native messaging (archivo + clave de registro HKCU, sin admin)
$manifest = Join-Path $dir "com.xiliux.fenrir.json"
$obj = [ordered]@{
  name               = "com.xiliux.fenrir"
  description        = "Host de native messaging de Fenrir"
  path               = $bin
  type               = "stdio"
  allowed_extensions = @($extId)
}
($obj | ConvertTo-Json) | Set-Content -Path $manifest -Encoding UTF8

$key = "HKCU:\Software\Mozilla\NativeMessagingHosts\com.xiliux.fenrir"
New-Item -Path $key -Force | Out-Null
Set-ItemProperty -Path $key -Name "(Default)" -Value $manifest

# Anadir el binario al PATH de usuario para que el conector lo encuentre
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$dir*") {
  [Environment]::SetEnvironmentVariable("Path", "$userPath;$dir", "User")
  Write-Host "Anadido $dir al PATH de usuario (reinicia la terminal)."
}

Write-Host "OK  fenrir-host   -> $bin"
Write-Host "OK  manifiesto FF -> $manifest (+ HKCU)"
Write-Host ""
Write-Host "Siguiente:"
Write-Host "  1) En Claude Code:  claude plugin marketplace add $repo ; claude plugin install fenrir@fenrir"
Write-Host "  2) En Firefox:      instala el .xpi de https://github.com/$repo/releases/latest"
