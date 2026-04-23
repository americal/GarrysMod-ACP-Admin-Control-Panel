# ACP — Garry's Mod Admin Control Panel

A lightweight admin panel for Garry's Mod focused on quick in-game moderation and server management.

---

## Features

### 👥 Player Management
- Kick / ban selected players
- Kill / respawn / teleport (`goto`, `bring`)
- Toggle god mode, noclip, freeze
- Set health / armor / run speed / jump power
- Strip weapons or give a weapon
- Force exit vehicle, ignite / extinguish
- Change user group (`user`, `admin`, `superadmin`)
- Enable or disable text chat for a selected player

### 🌐 Spawn Menu Access Control
- **Global spawn menu switch** (server-wide)
- **Per-player spawn menu switch**
- Spawn menu status displayed in the player list

### 💬 Chat Control
- **Enable Chat** button to allow selected player to use chat
- **Disable Chat** button to block selected player from using chat

### 🔔 ACP Notifications
- Targeted players always receive their own direct status notification (for example: spawn menu enabled/disabled for them).
- Action notifications can be shown globally or privately:
  - **Global ON**: all players see admin action notifications (except the targeted player for action-summary lines).
  - **Global OFF**: only the admin sees action-summary notifications (target still receives their personal line).
- This behavior applies to ACP actions triggered from both the panel UI and direct console commands.
- Examples: spawn menu toggles, chat toggles, strip/give notifications, kick/ban/rank updates, cleanup actions.

### 🖥️ Server Controls
- Change hostname / password
- Restart / refresh / change map
- Kick all, respawn all, reset all users to `user`
- Door utilities (open/close/lock/unlock/remove)
- Prop utilities (clear/ignite/extinguish)
- Bot utilities (spawn / kick all / mimic)
- Optional Physgun player freeze for admins/superadmins (with unfreeze on next physgun touch)

### ⚙️ Gameplay Settings (ConVar-based)
- God mode / noclip / PvP / fall damage toggles
- Allow clientside Lua
- Spawn with HL2 weapons
- Gravity and noclip speed sliders

### 🧩 UI
- ACP window title shows current addon version
- UI size adapts to screen dimensions
- Tabs for **Server**, **Players**, and **Settings**

---

## Installation

1. Copy this addon into your server/client addons folder:
   - `garrysmod/addons/Gmod-ACP-Admin-Control-Panel`
2. Restart the server (or change map).

---

## Usage

- Open chat and type the configured command:
  - Default: `%acp`
- Access is limited to staff (admin/superadmin checks in server code).

---

## Console Commands

Targeted commands now accept:
- Player name (full or partial, case-insensitive)
- `STEAM_X:Y:Z`
- SteamID64
- UserID / Entity index numeric value

### Core / Server
- `acp_hostname`
- `acp_setpassword`
- `acp_killserver`
- `acp_restart`
- `acp_refresh`
- `acp_changemap`
- `acp_rcon`
- `acp_warnrestart`
- `acp_stopsound`
- `acp_playsirena`

### Player moderation / actions
- `acp_kick`
- `acp_ban`
- `acp_unban`
- `acp_kill`
- `acp_forcerespawn`
- `acp_goto`
- `acp_tp`
- `acp_god_enable`
- `acp_god_disable`
- `acp_noclip`
- `acp_freeze`
- `acp_unfreeze`
- `acp_health`
- `acp_armor`
- `acp_give`
- `acp_strip`
- `acp_ignite`
- `acp_extinguish`
- `acp_exitvehicle`
- `acp_runspeed`
- `acp_jumppower`
- `acp_enablemic`
- `acp_disablemic`
- `acp_chat_enable`
- `acp_chat_disable`
- `acp_say`
- `acp_sendlua`

### Bulk actions
- `acp_kickall`
- `acp_makeallusers`
- `acp_respawnall`
- `acp_maxhp`

### Spawn menu & notifications
- `acp_spawnmenu_global`
- `acp_spawnmenu_player`
- `acp_notifications_global`
- `acp_physgunfreeze_admins`

### Doors
- `acp_opendoors`
- `acp_closedoors`
- `acp_lockdoors`
- `acp_unlockdoors`
- `acp_removedoors`

### Props / cleanup
- `acp_clearallprops`
- `acp_clearalldecals`
- `acp_igniteprops`
- `acp_extinguishprops`

### User groups
- `acp_adduser_superadmin`
- `acp_adduser_admin`
- `acp_removeuser`

### Bots
- `acp_createbot`
- `acp_kickallbots`
- `acp_botmimic`

---

## Configuration

Main config file: `lua/sh_acp_config.lua`

- `CONFIG_ACP.ChatCommand` — chat command to open ACP
- `CONFIG_ACP.Version` — displayed addon version
- `CONFIG_ACP.AllowSpawnMenuGlobal` — default global spawn menu state
- `CONFIG_ACP.AllowSpawnMenuByDefault` — default per-player spawn menu state
- `CONFIG_ACP.EnableGlobalNotifications` — default mode for ACP global action notifications
- `CONFIG_ACP.AllowAdminsPhysgunFreezePlayers` — allow admin/superadmin to freeze players with Physgun

---

## Notes

- This addon relies on standard Garry's Mod admin checks (`IsAdmin`, `IsSuperAdmin`).
- Most actions are implemented via server console commands registered in `sv_acp.lua`.
