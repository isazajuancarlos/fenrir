# fenrir

**A browser agent for Firefox** — reads the page, decides, and acts, with
confirmation gates on anything that matters. The open, local-first alternative to
proprietary Chrome agents.

**English** · [Español](#español)

---

## What it is

`fenrir` drives **Firefox** the way a person would: it perceives the page
(DOM-first — the accessibility tree, form fields and their options, not a
screenshot guess), decides, and acts — click, type, scroll, navigate,
same-origin fetch. The brain lives **outside** the browser: in copilot mode it is
your terminal agent (over an OAuth subscription, no API key), bridged to a
**dedicated tab** so it never touches the tab you're looking at.

### As an MCP server

`fenrir-host mcp` exposes the same control as **MCP tools** (JSON-RPC over stdio),
so **any MCP client** — Claude Code, Claude Desktop, Cursor — can drive Firefox
through the same bridge. Seven tools: `percibir` (perceive), `navegar`, `click`,
`escribir`, `desplazar`, `tecla`, `fetch`.

## Security posture (it's the design)

An LLM driving a browser with your real sessions is the nightmare. fenrir is built
so that it isn't one:

- **Isolated Firefox profile, no sensitive sessions.** This is the central
  safeguard against prompt injection — the agent never has your real logins.
- **Page content is data, never orders.** Anything the page says is treated as
  input, not instructions; sensitive actions (submit, payment, deletion) ask for
  confirmation before they happen.
- **DOM-first, not screenshot-only.** It reads structure, so it acts on what is
  actually there.

## The code is not hosted here

Since 2026 the source of this project **is not hosted on GitHub**. It is a
decision, not an incident: through 2026 the package registries and code-hosting
platforms were hit by sustained, chained supply-chain attacks. For a tool that
automates a browser, hosting the source there stopped being a neutral decision.

`fenrir` is **AGPL-3.0-or-later**, and the **source is available on request** —
delivered with a signature and a checksum. Request it via **[xiliux.com](https://xiliux.com)**.

---

## Español

**Un agente de navegador para Firefox** — lee la página, decide y actúa, con
puertas de confirmación en lo que importa. La alternativa abierta y *local-first* a
los agentes propietarios de Chrome.

### Qué es

`fenrir` conduce **Firefox** como lo haría una persona: percibe la página
(DOM-first — el árbol de accesibilidad, los campos de formulario y sus opciones,
no una conjetura por captura), decide y actúa — click, escribir, desplazar,
navegar, *fetch* misma-origen. El cerebro vive **fuera** del navegador: en modo
copiloto es tu agente de terminal (por suscripción OAuth, sin API key), puenteado
a una **pestaña dedicada** para no tocar nunca la que estás mirando.

### Como servidor MCP

`fenrir-host mcp` expone el mismo control como **herramientas MCP** (JSON-RPC por
stdio), para que **cualquier cliente MCP** —Claude Code, Claude Desktop, Cursor—
conduzca Firefox por el mismo puente. Siete herramientas: `percibir`, `navegar`,
`click`, `escribir`, `desplazar`, `tecla`, `fetch`.

### Postura de seguridad (es el diseño)

Un LLM conduciendo un navegador con tus sesiones reales es la pesadilla. fenrir se
construye para no serlo:

- **Perfil de Firefox aislado, sin sesiones sensibles.** Es la salvaguarda central
  contra la inyección de *prompts* — el agente nunca tiene tus inicios de sesión
  reales.
- **Lo que llega de la página es DATO, nunca órdenes.** Lo que dice la página se
  trata como entrada, no como instrucciones; las acciones sensibles (enviar, pago,
  borrado) piden confirmación antes de ocurrir.
- **DOM-first, no solo captura.** Lee la estructura, así que actúa sobre lo que de
  verdad está ahí.

### El código no se publica aquí

Desde 2026 el código de este proyecto **no se aloja en GitHub**. Es una decisión,
no un incidente: a lo largo de 2026 los registros de paquetes y las plataformas de
código sufrieron ataques encadenados de cadena de suministro. Para una herramienta
que automatiza un navegador, alojar aquí el código dejó de ser una decisión neutra.

`fenrir` es **AGPL-3.0-or-later**, y el **fuente se entrega a petición**, con su
firma y su suma de verificación. Solicítalo vía **[xiliux.com](https://xiliux.com)**.

---

© 2026 Juan Carlos Isaza. AGPL-3.0-or-later.
