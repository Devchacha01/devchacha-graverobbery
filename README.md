# 🪦 devchacha-graverobbery

A grave robbery script for RedM using **ox_lib**, **ox_target** (Third Eye), and **rsg-core**.

## Features

- **Third Eye Interaction** — Look at any grave/gravestone prop and use ox_target to rob it
- **Digging Animation** — Full gravedigger animation with an attached shovel prop (`p_shovel02x`)
- **Skill Check** — ox_lib skill check before digging begins
- **Weighted Loot System** — Configurable weighted random rewards (coins, rings, gems, gold bars, etc.)
- **Cash Rewards** — Random cash found alongside items
- **Civilian Snitching** — Nearby NPCs may report you to the law
- **Police Alerts** — Law enforcement players receive notifications + a map blip with GPS route to the crime
- **Cooldowns** — Per-player, per-grave cooldown (configurable, default 30 min)
- **Night Only Mode** — Optionally restrict grave robbing to nighttime (22:00 - 05:00)
- **100+ Grave Models** — Supports all gravestone, grave mound, grave marker, and story character grave props

## Dependencies

- [rsg-core](https://github.com/Starter-Framework/rsg-core)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [oxmysql](https://github.com/overextended/oxmysql)

## Installation

1. Place `devchacha-graverobbery` in your `resources` folder
2. Add `ensure devchacha-graverobbery` to your `server.cfg`
3. Configure `config.lua` to your liking

## Configuration Highlights

| Setting | Default | Description |
|---|---|---|
| `Config.NightOnly` | `true` | Only allow grave robbing at night |
| `Config.Cooldown` | `1800` (30 min) | Per-grave cooldown in seconds |
| `Config.Police.AlertChance` | `40%` | Chance a nearby NPC reports you |
| `Config.Police.BlipDuration` | `300` (5 min) | How long the police blip stays on map |
| `Config.Digging.Duration` | `15000` (15 sec) | How long the digging progress bar takes |
| `Config.RequiredItem` | `nil` | Set to `'shovel'` to require an item |
| `Config.Loot.chance` | `75%` | Chance to find anything in the grave |

## How It Works

1. Player approaches any grave prop in the world
2. **Third Eye** (ox_target) shows "Rob Grave" option
3. Player passes a **skill check**
4. **Digging animation** plays with a shovel attached to the player's hand
5. On success, player receives **random loot** (weighted) and possibly **cash**
6. If a nearby NPC civilian sees you, there's a chance they **snitch to the law**
7. Law enforcement players get a **notification**, **map blip**, and **GPS route** to the grave

## Credits

- **Author**: devchacha
- **Framework**: RSG-Core
