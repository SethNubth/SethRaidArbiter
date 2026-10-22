Aquí tienes el README GOD nivel CurseForge - Profesional, con badges y todo para que lo aprueben de una.

Copia y pega esto como `README.md` en tu GitHub:

---
SethRaidArbiter - Spam Builder

![Version](https://img.shields.io/badge/Version-v8.4.1-blue)
![WoW](https://img.shields.io/badge/WoW-3.3.5a%20WotLK-orange)
![Server](https://img.shields.io/badge/Server-Naerzone%20%2F%20Warmane-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

**The ultimate raid spam builder for WotLK 3.3.5a - Optimized for Naerzone Taberna.**

Tú escribes lo que deseas armar. 100% configurable. Con botón ON/OFF para evitar spam accidental.

✨ Features v8.4.1

- **📝 Full Custom Spam:** Tú mismo escribes Raid, Modo, Mele, Caster, Heal, Tank, GS. No hay presets fijos.
- **🔘 ON/OFF Button:** `ENVIAR SPAM: OFF` por defecto = 0 spam. Solo spamea cuando le das ON. Anti-trol.
- **🎯 Auto Taberna Detection:** Detecta automáticamente `/join taberna` sea `/5` hoy o `/8` en 3 días. Soluciona el bug de Naerzone.
- **🛡️ Anti-Mute Naerzone:** Delay de 11 segundos automático para evitar mute del servidor.
- **📋 Smart Flex:** Si pones `0` en Mele, no sale "0 Meles" en el spam. Solo muestra lo que necesitas.
- **🖥️ Menu Integration:** Botón `[SPAM BUILDER]` directo en el menú principal de SRA (`/sra`).
- **👁️ Live Preview:** Ves el spam final antes de enviarlo.

🚀 Installation

1. Descarga el addon
2. Extrae en `World of Warcraft/Interface/AddOns/`
3. `/reload` en juego
4. Listo

🎮 How to Use

**Desde Menú (Nuevo v8.4.1):**
1. `/sra` -> Click en botón `[SPAM BUILDER]` abajo a la izquierda
2. Escribe lo que deseas armar
3. Click `ENVIAR SPAM: OFF` -> Cambia a `ON` y empieza a spamear

**Desde Comando:**
- `/spambuilder` - Abre el builder
- `/sraarmar` - Alias

**Ejemplo de uso:**
Raid: ICC
Modo: 25N
Mele: 5
Caster: 4
Heal: 3
Tank: 2
GS: 5.5
Genera:
> `Se arma ICC25N: Need: 5 Meles 4 Caster 3 Heal 2 Tanke GS: 5.5 12/25`

Si pones:
Raid: Archavon
Modo: 10
Mele: 0
Caster: 2
Genera:
> `Se arma Archavon10: Need: 2 Caster GS: 5k`

**¡Tú escribes lo que quieras armar!** SR 25N, TOC 25H, SEMPITERNAL, lo que sea.

⚙️ Why Taberna is /5 today and /8 tomorrow?

Naerzone assigns channel numbers by join order. This addon scans channels 1-20 and finds `taberna` automatically with `GetChannelName()`. No more manual `/5` or `/8`.

```lua
function SRA_GetTabernaChannel()
  for i=1,20 do
    local _, name = GetChannelName(i)
    if name and name:lower():find("taberna") then return i end
  end
end
📦 Changelog

*v8.4.1 - Menu Integration*
- Botón SPAM BUILDER agregado al menú principal SRA
- Auto-inject con C_Timer para compatibilidad

*v8.4 - ON/OFF GOD*
- Botón gigante ENVIAR SPAM: OFF/ON
- Estado APAGADO por defecto = 0 spam si no deseas armar
- Status visual ● APAGADO / ● ENVIADO

*v8.3 - Auto Taberna*
- Auto-detección de canal Taberna /5-8
- Fix para Naerzone random join

🤝 Support

- Server: Naerzone - Sethraliss
- Guild: Sempiternal
- Issues: Abre un ticket en GitHub

📜 License

MIT - Úsalo libre, GOD.

---
*Made by Seth - For raiders who are tired of typing the same spam.*

Para CurseForge GOD, agrega esto en la descripción corta:

> **Short Description:**
> Custom raid spam builder for WotLK 3.3.5a with ON/OFF toggle, auto Taberna /5-/8 detection and anti-mute. You write what you want to build.
