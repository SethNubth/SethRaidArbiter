# SethRaidArbiter | Naerzone Edition v6.2

Arbitraje de Raid WotLK 3.3.5a para Naerzone - SR + Loot Direct + Trinkets ICC + Balance 3W 2DK + Agonía Rock.

### Features v6.2
**1. Arbitraje SR (Soft Reserve)**
- `/sra` para abrir menú
- `/sra add [item] [jugador]` 
- Detección automática de ganadores SR
- Soporte 1ra cuenta vs ALT: `SRA_IsAlt()` - Agonía solo main

**2. Loot Direct Naerzone**
- Detección épica instantánea `CHAT_MSG_LOOT`
- Anti-mute 11s de Naerzone
- Mensaje automático en /BANDA (`RAID`)

**3. Trinkets ICC + Agonía**
- Control Agonía: Solo 1ra cuenta puede lootear Fragmento de Agonía [45038] y Agonía [50274]
- Bloqueo automático si es ALT + aviso RAID_WARNING
- Lista ICC: Testimonio, Escama, etc.

**4. Balance Raid**
- Config: 3W (Warlock) 2DK 1 Demo Lock Obliterado
- Compensación automática de loot para balance

### Comandos
- `/sra` - Menú principal
- `/sra alt [nombre]` - Marcar como ALT
- `/sra main [nombre]` - Marcar como Main
- `/sra ver` - Ver reservas
- `/sra reset` - Reset raid

### Instalación
1. Descarga el zip
2. Descomprime en `World of Warcraft/Interface/AddOns/`
3. Renombra carpeta a `SethRaidArbiter`
4. `/reload` en juego

### Fix Lua Errors v6.2
- Fix `Menú.lua` -> `Menu.lua` sin acento
- Fix `Config.lua` case-sensitive
- Fix `RAID_WARNING` sin permisos -> usa `RAID`
- `pcall()` en todos los SendChatMessage para 0 errores

### Requisitos
- WoW 3.3.5a (Interface: 30403)
- Naerzone

### Autor
Seth - Naerzone

### Changelog
- **v6.2**: Control Agonía Solo 1ra Cuenta + Fix Banda Español + 0 Lua Errors
- **v6.1**: Balance 3W 2DK Demo
- **v6.0**: Trinkets ICC SR

¡GL en ICC 25H!
