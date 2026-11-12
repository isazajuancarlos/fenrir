#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 Juan Carlos Isaza
#
# Hook SessionStart del plugin fenrir.
#
# El conector MCP (este plugin) habla con `fenrir-host`, pero fenrir solo CONDUCE
# Firefox cuando la EXTENSIÓN del navegador está cargada y conectada al puente. Al
# instalar el plugin desde Claude, el usuario tiene el conector pero puede no tener
# la extensión; este hook lo detecta y le dice DÓNDE descargarla.
#
# Shell POSIX a propósito: un hook de PLUGIN se distribuye a cualquier plataforma y
# no debe exigir compilar un binario por SO (misma excepción de portabilidad que la
# extensión JS). Sin comillas dobles en el mensaje: se emite como string JSON directo.
#
# Discrimina (pareja D33): con el socket del puente VIVO calla (extensión conectada);
# sin socket avisa con la URL de descarga. El caso rojo falla por la vía real (la
# ausencia del socket que el puente crea), no por un arnés.

RELEASES="https://github.com/isazajuancarlos/fenrir/releases/latest"
GUIA="https://github.com/isazajuancarlos/fenrir#instalacion"
SOCK="${XDG_RUNTIME_DIR:-/run/user/$(id -u 2>/dev/null)}/fenrir.sock"

# Socket vivo = extensión conectada: nada que avisar.
if [ -S "$SOCK" ]; then
  exit 0
fi

if command -v fenrir-host >/dev/null 2>&1; then
  estado="El host (fenrir-host) esta instalado, pero la extension de Firefox no esta cargada ni conectada."
else
  estado="Faltan el host (fenrir-host, por RPM) y la extension de Firefox."
fi

msg="fenrir: el conector MCP esta instalado, pero aun no puede conducir Firefox. ${estado} Descarga e instala la EXTENSION de Firefox (el .xpi firmado) desde ${RELEASES} (y el RPM del host si falta). Guia de instalacion: ${GUIA}. Comunicaselo al usuario con las URLs."

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$msg"
