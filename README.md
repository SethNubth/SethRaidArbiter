# SethRaidArbiter
Addons WoLK 3.3.5 Naerzon
# SethRaidArbiter - Naerzone 3.3.5a
**By SethNubth**

Addon personalizado para Arbitrar Raids en Naerzone, con texturas exclusivas de Agonía de Escarcha pincelada.

### ✨ Características
- Botón en minimapa con textura `Agonía Roca Fría`
- Compatible con Dragonflight UI
- Soporte para Loot Direct y Trinkets ICC SR
- Texturas TGA en estilo pincelada rock frío

### 📁 Contenido


### 📥 Instalación
1. Descarga el ZIP: Code > Download ZIP
2. Renombra `SethRaidArbiter-main` a `SethRaidArbiter`
3. Copiar a `World of Warcraft/Interface/AddOns/`
4. Activar en la pantalla de AddOns

### 🎨 Créditos
Texturas pinceladas by SethNubth
Para el servidor de Naerzone- Thalasa

> "Forjado en Escarcha - Agonía de Roca Fría"

# SethRaidArbiter - By SethNubth
### Addon de Arbitraje para Naerzone 3.3.5a | Compatible Dragonflight UI

> Forjado en la Agonía de Roca Fría - Texturas pinceladas exclusivas.

---

### ✨ CARACTERÍSTICAS PRINCIPALES

**1. Arbitraje de Raid:**
- Asignación rápida de loot con ventana de roll / necesidad
- Detección automática de items épicos ICC 25H
- Soporte para Soft Reserve (SR) y Loot Direct

**2. Gestión de Trinkets ICC:**
- Módulo `trinket_icc_sr_toc.lua` para Testamentos, Objetos de Muerte, etc.
- Previene duplicados y prioriza mains > alts

**3. Loot Direct:**
- Entrega directa sin trade window para Naerzone
- Comando de susurro automático al ganador

**4. Botón Minimapa:**
- Textura exclusiva `Media/agonia_rock.tga` estilo pincelada Roca Fría
- Arrastrable, se adapta a cualquier forma de minimapa (ElvUI / Dragonflight UI)
- Click Izq: Abrir panel / Click Der: Config

**5. Config Dragonflight UI:**
- Integración total con tu UI moderna

### 🔗 Compatibilidad

**Compatible con:**
- **BiS Tool / BiSTooltip:** Detecta automáticamente el Soft Reserve del BiS Tool si lo tienes instalado. (Opcional, no obligatorio)
- link: https://github.com/disruption01/BiS-Tooltip_335a_backport
- **AtlasLoot:** Para ver loot de ICC
- **Dragonflight UI / ElvUI:** 100% compatible con el botón de minimapa

> No es necesario tener BiS Tool, pero si lo tienes, SethRaidArbiter lo lee para el arbitraje de Trinkets ICC SR.
---

### ⌨️ COMANDOS

Todos los comandos funcionan con `/sra`, `/sethraid` y `/raidarbiter`

| Comando | Descripción |
| :--- | :--- |
| `/sra` | Abre el panel principal del árbitro |
| `/sra show` | Muestra la ventana de loot actual |
| `/sra hide` | Oculta el panel |
| `/sra config` | Abre configuración Dragonflight UI |
| `/sra reset` | Reinicia posición del botón del minimapa |
| `/sra loot` | Fuerza el escaneo de loot del boss |
| `/sra sr` | Muestra la lista de Soft Reserve del raid |
| `/sra announce` | Anuncia el ganador en /ra y susurro |

---

### 📖 FORMA DE USO ADECUADO (Guía para Árbitro)

**Paso 1: Antes de Raid**
1. Activa el addon en la pantalla de AddOns
2. Escribe `/sra config` y coloca el botón donde quieras
3. Si usas SR, importa la lista de tu hermandad

**Paso 2: Durante Boss**
1. Al morir el boss, el addon detecta el loot automático
2. Se abre la ventana de arbitraje con los items
3. Los jugadores hacen roll o escriben su SR

**Paso 3: Asignar Loot**
1. Selecciona al ganador en la lista
2. Click en `Asignar` -> El addon hará `/loot` y susurrará al ganador
3. Si es item ligable, usa `Loot Direct` para entrega instantánea

**Paso 4: Trinkets ICC SR**
- El sistema bloquea automáticamente si un jugador ya tiene 2 testamentos, etc.
- Respeta la lista SR de `trinket_icc_sr`

**Tip de SethNubth:** Usa Click Derecho en el botón de Agonía para modo silencioso en raids de hermandad.

---

### 📥 INSTALACIÓN

1. Descarga: `Code > Download ZIP`
2. Renombra `SethRaidArbiter-main` a `SethRaidArbiter`
3. Copiar a `Interface/AddOns/`
4. Texturas en `Media/*.tga` deben quedar dentro

### 🎨 TEXTURAS INCLUIDAS
- `agonia_rock.tga` - Principal (Roca Fría)
- `agonia_pincelado.tga` - Edición pincelada exclusiva
- `agonia_retail.tga` / `agonia_minimap.tga` / `agonia_splash.tga`

---
**By SethNubth for Naerzone - 2026**
