# Changelog - SethRaidArbiter | Naerzone Edition

## [6.2] - 2026-10-19 - Shadowmourne Control + Trilingüe
### Added
- README trilingüe CurseForge: ES / EN / BR
- Control Agonía / Shadowmourne: Solo cuenta MAIN lootea Fragmento [45038] y Agonía [50274]
- Comando `/sra alt [name]` y `/sra main [name]` para marcar ALT/MAIN
- Detección auto ALT -> Bloqueo + RAID_WARNING /BANDA /RAIDE
- Direct Loot: Detección épica instantánea + Anti-mute 11s

### Fixed
- Fix `Menu.lua` sin acentos - 0 LUA Errors
- Fix permisos `RAID_WARNING` con `pcall` wrapper para cliente ES / BR / EN
- Fix mensaje `/BANDA` vs `/RAID` vs `/RAIDE` según cliente
- Balance: 3 Brujos (Warlocks), 2 DKs, 1 Demo Lock Obligatorio - Validación pre-pull

### Changed
- Comando principal `/sra` unificado para 3 idiomas
- Mensajes de loot directo ahora en idioma del cliente

## [6.1] - 2026-10-18 - SR + Direct Loot
### Added
- SR Automático con detección de ganadores
- Loot Direct: Mensaje auto en /BANDA al lootear épico
- Anti-mute 11s para evitar flood
- ICC Trinkets control

## [6.0] - 2026-10-17 - Balance 3W 2DK
### Added
- Validación raid: 3 Warlocks, 2 DKs, 1 Demo Lock mandatory
- Aviso si falta balance antes de LK

## [5.0] - 2026-10-15 - Initial Naerzone Edition
- Fork para Naerzone
- Base Arbiter WotLK 3.3.5a
