#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 Juan Carlos Isaza
#
# Instalador universal de usuario de fenrir-host (Linux y macOS), SIN root.
# Descarga el binario correcto para tu plataforma de la ultima Release, lo deja en
# ~/.local/bin, y registra el manifiesto de native messaging para que Firefox pueda
# lanzar el puente. En Windows usa install.ps1.
#
#   curl -fsSL https://raw.githubusercontent.com/isazajuancarlos/fenrir/master/install.sh | sh
set -eu

REPO="isazajuancarlos/fenrir"
EXT_ID="fenrir@xiliux.com"

os=$(uname -s)
arch=$(uname -m)
case "$os" in
  Linux)  plat="linux";  nmdir="$HOME/.mozilla/native-messaging-hosts" ;;
  Darwin) plat="macos";  nmdir="$HOME/Library/Application Support/Mozilla/NativeMessagingHosts" ;;
  *) echo "SO no soportado por este instalador: $os (en Windows usa install.ps1)"; exit 1 ;;
esac
case "$arch" in
  x86_64|amd64)  a="x86_64" ;;
  aarch64|arm64) a="aarch64" ;;
  *) echo "Arquitectura no soportada: $arch"; exit 1 ;;
esac

asset="fenrir-host-${plat}-${a}"
bindir="$HOME/.local/bin"
bin="$bindir/fenrir-host"
mkdir -p "$bindir"

echo "Descargando ${asset} de la ultima Release…"
curl -fsSL "https://github.com/${REPO}/releases/latest/download/${asset}" -o "$bin"
chmod +x "$bin"

mkdir -p "$nmdir"
cat > "${nmdir}/com.xiliux.fenrir.json" <<JSON
{
  "name": "com.xiliux.fenrir",
  "description": "Host de native messaging de Fenrir",
  "path": "${bin}",
  "type": "stdio",
  "allowed_extensions": ["${EXT_ID}"]
}
JSON
chmod 600 "${nmdir}/com.xiliux.fenrir.json"

echo "OK  fenrir-host    -> ${bin}"
echo "OK  manifiesto FF  -> ${nmdir}/com.xiliux.fenrir.json"
case ":${PATH}:" in
  *":${bindir}:"*) ;;
  *) echo "AVISO: anade ${bindir} a tu PATH (p. ej. en ~/.profile) para que el conector lo encuentre." ;;
esac
echo ""
echo "Siguiente:"
echo "  1) En Claude Code:  claude plugin marketplace add ${REPO} && claude plugin install fenrir@fenrir"
echo "  2) En Firefox:      instala el .xpi de https://github.com/${REPO}/releases/latest"
