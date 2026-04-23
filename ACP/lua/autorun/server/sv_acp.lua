AddCSLuaFile("autorun/client/cl_acp.lua")
AddCSLuaFile("sh_acp_config.lua")
include("sh_acp_config.lua")

util.AddNetworkString("acp_open")

local version = CONFIG_ACP.Version
print("ACP " .. version .. " has loaded")

local function IsAdminStaff(ply)
	return IsValid(ply) and (ply:IsAdmin() or ply:IsSuperAdmin())
end

local function IsSuperAdminStaff(ply)
	return IsValid(ply) and ply:IsSuperAdmin()
end

local function FindTargetPlayer(identifier)
	if not identifier then return nil end
	local raw = tostring(identifier)
	local lowered = string.lower(raw)

	local numeric = tonumber(raw)
	if numeric then
		local entityTarget = Entity(numeric)
		if IsValid(entityTarget) and entityTarget:IsPlayer() then
			return entityTarget
		end

		for _, currentPlayer in ipairs(player.GetAll()) do
			if currentPlayer:UserID() == numeric or currentPlayer:EntIndex() == numeric then
				return currentPlayer
			end
		end
	end

	for _, currentPlayer in ipairs(player.GetAll()) do
		if string.lower(currentPlayer:SteamID()) == lowered or string.lower(currentPlayer:SteamID64()) == lowered then
			return currentPlayer
		end
	end

	for _, currentPlayer in ipairs(player.GetAll()) do
		local nickLower = string.lower(currentPlayer:Nick())
		if nickLower == lowered or string.find(nickLower, lowered, 1, true) then
			return currentPlayer
		end
	end

	return nil
end

local function GetPlayerByEntID(entId)
	return FindTargetPlayer(entId)
end

local function ResolveTargetOrNotify(ply, identifier)
	local target = FindTargetPlayer(identifier)
	if IsValid(target) then return target end
	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTTALK, "[ACP] Target player not found.")
	end
	return nil
end

local function NotifyNoAccess(ply, level)
	if not IsValid(ply) then return end
	ply:PrintMessage(HUD_PRINTTALK, "You Don't Have Access to this command(" .. level .. " only)!")
end

local spawnMenuStateBySteamId64 = {}
local spawnMenuGlobalAllowed = CONFIG_ACP.AllowSpawnMenuGlobal ~= false
local chatDisabledBySteamId64 = {}
local globalNotificationsEnabled = CONFIG_ACP.EnableGlobalNotifications ~= false
local allowAdminsPhysgunFreezePlayers = CONFIG_ACP.AllowAdminsPhysgunFreezePlayers ~= false
local physgunFrozenPlayersBySteamId64 = {}

local function IsSpawnMenuAllowedForPlayer(ply)
	if not IsValid(ply) then return false end
	if not spawnMenuGlobalAllowed then return false end
	local steamId64 = ply:SteamID64()
	local personalSetting = spawnMenuStateBySteamId64[steamId64]
	if personalSetting == nil then
		return CONFIG_ACP.AllowSpawnMenuByDefault ~= false
	end
	return personalSetting
end

local function SyncSpawnMenuState(ply)
	if not IsValid(ply) then return end
	ply:SetNWBool("acp_spawnmenu_global_allow", spawnMenuGlobalAllowed)
	ply:SetNWBool("acp_spawnmenu_personal_allow", IsSpawnMenuAllowedForPlayer(ply))
	ply:SetNWBool("acp_global_notifications_enabled", globalNotificationsEnabled)
	ply:SetNWBool("acp_allow_admins_physgun_freeze_players", allowAdminsPhysgunFreezePlayers)
end

local function NotifyACPAction(actor, target, text)
	if globalNotificationsEnabled then
		for _, currentPlayer in ipairs(player.GetAll()) do
			if IsValid(target) and currentPlayer == target then
				continue
			end
			currentPlayer:PrintMessage(HUD_PRINTTALK, text)
		end
		return
	end

	if IsValid(actor) then
		actor:PrintMessage(HUD_PRINTTALK, text)
	end
end

function SetPassword(ply, command, args, public)
	if ply:IsSuperAdmin() then
			RunConsoleCommand("sv_password", args[1]);
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function SetHostName(ply, command, args, public)
	if ply:IsSuperAdmin() then
			RunConsoleCommand("hostname", args[1]);
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function KillServer(ply, public)
	if ply:IsAdmin() then
			RunConsoleCommand("killserver");
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Restart(ply, public)
	if ply:IsAdmin() then
			RunConsoleCommand("changelevel", game.GetMap());
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Refresh(ply, public)
	if ply:IsAdmin() then
			RunConsoleCommand("map", game.GetMap());
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function RespawnAll(ply, command, args, public)
	if ply:IsSuperAdmin() then
		for k,v in pairs(player.GetAll()) do v:Spawn() end;
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function KickAll(ply, command, args, public)
	if ply:IsSuperAdmin() then
		RunConsoleCommand("kickall");
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function MakeAllUsers(ply, command, args, public)
	if ply:IsSuperAdmin() then
		for k,v in pairs(player.GetAll()) do v:SetUserGroup("user") end;
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function MaxHP(ply, command, args, public)
	if ply:IsSuperAdmin() then
		for k,v in pairs(player.GetAll()) do v:SetHealth(100) end;
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function Kick(ply, command, args, public)
	if ply:IsAdmin() then
		RunConsoleCommand("kickid", args[2], args[1])
		NotifyACPAction(ply, nil, "[ACP] Player " .. args[3] .. " was kicked for reason: " .. args[1])
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Ban(ply, command, args, public)
	if ply:IsAdmin() then
		RunConsoleCommand("banid", args[1], args[2]);
		RunConsoleCommand("kickid", args[2], "Banned for "..args[1].." minute(s)");
		RunConsoleCommand("writeid");
		NotifyACPAction(ply, nil, "[ACP] Player " .. args[3] .. " was banned for " .. args[1] .. " minute(s)")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function ChangeMap(ply, command, args, public)
	if ply:IsSuperAdmin() then
		RunConsoleCommand("changelevel", args[1]);
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function EnableGod(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:GodEnable()
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function DisableGod(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:GodDisable()
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function ForceRespawn(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:Spawn()
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Kill(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:Kill()
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function SetNoTarget(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SetNoTarget(true)
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function SetTarget(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SetNoTarget(false)
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end


function Goto(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply:SetPos(ply_target:GetPos())
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Tp(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SetPos(ply:GetPos())
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Give(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:Give(args[2])
		ply_target:PrintMessage(HUD_PRINTTALK, "[ACP] You were given: " .. tostring(args[2]))
		NotifyACPAction(ply, ply_target, "[ACP] Gave " .. tostring(args[2]) .. " to " .. ply_target:Nick())
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Strip(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:StripWeapons()
		ply_target:PrintMessage(HUD_PRINTTALK, "[ACP] Your weapons were stripped.")
		NotifyACPAction(ply, ply_target, "[ACP] Stripped weapons for " .. ply_target:Nick())
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Ignite(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:Ignite(100)
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Extinguish(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:Extinguish()
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Health(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SetHealth(args[2])
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Armor(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SetArmor(args[2])
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Freeze(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:Lock()
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function UnFreeze(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:UnLock()
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Say(ply, command, args, public)
	if ply:IsSuperAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:Say(args[2])
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

--[[
function SetVIP(ply, command, args, public)
	if ply:IsAdmin() then
		RunConsoleCommand("ulx", "adduserid", args[1], "vip")
		print(args[1])
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function SetModerator(ply, command, args, public)
	if ply:IsAdmin() then
		RunConsoleCommand("ulx", "adduserid", args[1], "moderator")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end
--]]

--[[
function SetUberAdmin(ply, command, args, public)
	if ply:IsAdmin() then
		RunConsoleCommand("ulx", "adduserid", args[1], "uberadmin")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end
--]]
if SERVER then
function SetSuperAdmin(ply, command, args, public)
	if ply:IsSuperAdmin() then
	local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SetUserGroup("superadmin")
		NotifyACPAction(ply, ply_target, "[ACP] Player " .. args[2] .. " was added to SuperAdmin group")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function SetAdmin(ply, command, args, public)
	if ply:IsSuperAdmin() then
	local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SetUserGroup("admin")
		NotifyACPAction(ply, ply_target, "[ACP] Player " .. args[2] .. " was added to Admin group")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function SetUser(ply, command, args, public)
	if ply:IsSuperAdmin() then
	local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SetUserGroup("user")
		NotifyACPAction(ply, ply_target, "[ACP] Player " .. args[2] .. " was added to User group")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end
end
--[[
function SetSuperUser(ply, command, args, public)
	if ply:IsAdmin() then
		RunConsoleCommand("ulx", "adduserid", args[1], "user*")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function SetHeadAdmin(ply, command, args, public)
	if ply:IsUserGroup("headadmin") then
		RunConsoleCommand("ulx", "adduserid", args[1], "headadmin")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end
--]]

function SendLua(ply, command, args, public)
	if ply:IsSuperAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SendLua(args[2])
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function Rcon(ply, command, args, public)
	if ply:IsSuperAdmin() then
	if SERVER then
		RunConsoleCommand(args[1], args[2], args[3], args[4], args[5]);
		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function Crash(ply, command, args, public)
	if ply:IsSuperAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SendLua("cam.End3D()")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function Vac(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:Kick("You cannot connect to the selected server, because it is running in VAC (Valve Anti-Cheat) secure mode.\n\nThis Steam account has been banned from secure servers due to a cheating infraction.")
		NotifyACPAction(ply, nil, "[ACP] Player " .. args[2] .. " was VAC banned due using cheats!")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function RunSpeed(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SetRunSpeed(args[2])
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function JumpPower(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SetJumpPower(args[2])
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function ExitVehicle(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:ExitVehicle()
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function Noclip(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		if ply_target:GetMoveType() == MOVETYPE_WALK then ply_target:SetMoveType( MOVETYPE_NOCLIP )
		elseif ply_target:GetMoveType() == MOVETYPE_NOCLIP then
				ply_target:SetMoveType( MOVETYPE_WALK )
				end

	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function EnableMic(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SendLua("LocalPlayer():ConCommand('+voicerecord')")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function DisableMic(ply, command, args, public)
	if ply:IsAdmin() then
		local ply_target = ResolveTargetOrNotify(ply, args[1])
		if not IsValid(ply_target) then return end
		ply_target:SendLua("LocalPlayer():ConCommand('-voicerecord')")
	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function EnableChat(ply, command, args, public)
	if not IsAdminStaff(ply) then
		NotifyNoAccess(ply, "Admin")
		return
	end

	local ply_target = GetPlayerByEntID(args[1])
	if not IsValid(ply_target) then
		ply:PrintMessage(HUD_PRINTTALK, "[ACP] Target player not found.")
		return
	end

	chatDisabledBySteamId64[ply_target:SteamID64()] = nil
	ply_target:PrintMessage(HUD_PRINTTALK, "[ACP] Your chat has been enabled.")
	NotifyACPAction(ply, ply_target, "[ACP] Chat enabled for " .. ply_target:Nick() .. ".")
end

function DisableChat(ply, command, args, public)
	if not IsAdminStaff(ply) then
		NotifyNoAccess(ply, "Admin")
		return
	end

	local ply_target = GetPlayerByEntID(args[1])
	if not IsValid(ply_target) then
		ply:PrintMessage(HUD_PRINTTALK, "[ACP] Target player not found.")
		return
	end

	chatDisabledBySteamId64[ply_target:SteamID64()] = true
	ply_target:PrintMessage(HUD_PRINTTALK, "[ACP] Your chat has been disabled.")
	NotifyACPAction(ply, ply_target, "[ACP] Chat disabled for " .. ply_target:Nick() .. ".")
end

function WarnRestart(ply, command, args, public)
	if ply:IsAdmin() then
		NotifyACPAction(ply, nil, "[ACP] Warning! Now server will be restarted!")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function CleanAllProps(ply, command, args, public)
	if ply:IsAdmin() then
    for k,v in ipairs(ents.FindByClass("prop_physics")) do v:Remove() end
	NotifyACPAction(ply, nil, "[ACP] All props were removed!")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function CleanAllDecals(ply, command, args, public)
	if ply:IsAdmin() then
   for k,v in pairs ( player.GetAll() ) do
	
		v:ConCommand( "r_cleardecals" )
		v:SendLua( "game.RemoveRagdolls()" )
	
	end
	NotifyACPAction(ply, nil, "[ACP] All decals were removed!")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function OpenDoors(ply, command, args, public)
	if ply:IsAdmin() then
    for k,v in ipairs(ents.FindByClass("prop_door_rotating")) do v:Fire("open") end
	NotifyACPAction(ply, nil, "[ACP] All doors were opened!")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function CloseDoors(ply, command, args, public)
	if ply:IsAdmin() then
    for k,v in ipairs(ents.FindByClass("prop_door_rotating")) do v:Fire("close") end
	NotifyACPAction(ply, nil, "[ACP] All doors were closed!")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function LockDoors(ply, command, args, public)
	if ply:IsAdmin() then
    for k,v in ipairs(ents.FindByClass("prop_door_rotating")) do v:Fire("lock") end
	NotifyACPAction(ply, nil, "[ACP] All doors were locked!")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function UnLockDoors(ply, command, args, public)
	if ply:IsAdmin() then
    for k,v in ipairs(ents.FindByClass("prop_door_rotating")) do v:Fire("unlock") end
	NotifyACPAction(ply, nil, "[ACP] All doors were unlocked!")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function RemoveDoors(ply, command, args, public)
	if ply:IsSuperAdmin() then
    for k,v in ipairs(ents.FindByClass("prop_door_rotating")) do v:Remove() end
	NotifyACPAction(ply, nil, "[ACP] All doors were removed!")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function IgniteProps(ply, command, args, public)
	if ply:IsAdmin() then
    for k,v in ipairs(ents.FindByClass("prop_physics")) do v:Ignite(100) end
	NotifyACPAction(ply, nil, "[ACP] All props were ignited!")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function ExtinguishProps(ply, command, args, public)
	if ply:IsAdmin() then
    for k,v in ipairs(ents.FindByClass("prop_physics")) do v:Extinguish() end
	NotifyACPAction(ply, nil, "[ACP] All props were quenched!")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function PlaySirena(ply, command, args, public)
	if ply:IsAdmin() then
for k,v in pairs(player.GetAll()) do
v:SendLua("sound.PlayURL ( 'https://americal.000webhostapp.com/siren.wav', 'mono', function( station ) if ( IsValid( station ) ) then station:SetPos( LocalPlayer():GetPos() ) station:Play() else LocalPlayer():ChatPrint( 'Invalid URL!' ) end end)")
end
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function StopSound(ply, command, args, public)
	if ply:IsAdmin() then
for k,v in pairs(player.GetAll()) do
v:SendLua("LocalPlayer():ConCommand('stopsound')")
end
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function CreateBot(ply, command, args, public)
	if ply:IsSuperAdmin() then
    RunConsoleCommand("Bot")
	NotifyACPAction(ply, nil, "[ACP] Bot was created")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function KickAllBots(ply, command, args, public)
	if ply:IsAdmin() then
    for k,v in pairs(player.GetBots()) do v:Kick() end
	NotifyACPAction(ply, nil, "[ACP] All bots were kicked")
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function BotMimic(ply, command, args, public)
	if ply:IsSuperAdmin() then
    RunConsoleCommand("bot_mimic", args[1])
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(SuperAdmin only)!")
	end
end

function UnBan(ply, command, args, public)
	if ply:IsAdmin() then
    RunConsoleCommand("removeid", args[1])
	print(args[1])
 	else
		ply:PrintMessage( HUD_PRINTTALK, "You Don't Have Access to this command(Admin only)!")
	end
end

function SetSpawnMenuGlobal(ply, command, args)
	if not IsSuperAdminStaff(ply) then
		NotifyNoAccess(ply, "SuperAdmin")
		return
	end

	local enabled = tobool(args[1])
	spawnMenuGlobalAllowed = enabled

	for _, target in ipairs(player.GetAll()) do
		SyncSpawnMenuState(target)
	end

	NotifyACPAction(ply, nil, "[ACP] Spawn menu global access: " .. (enabled and "enabled" or "disabled"))
end

function SetSpawnMenuForPlayer(ply, command, args)
	if not IsAdminStaff(ply) then
		NotifyNoAccess(ply, "Admin")
		return
	end

	local target = GetPlayerByEntID(args[1])
	if not IsValid(target) then
		ply:PrintMessage(HUD_PRINTTALK, "[ACP] Target player not found.")
		return
	end

	local enabled = tobool(args[2])
	spawnMenuStateBySteamId64[target:SteamID64()] = enabled
	SyncSpawnMenuState(target)
	target:PrintMessage(HUD_PRINTTALK, "[ACP] Your spawn menu access was " .. (enabled and "enabled." or "disabled."))
	NotifyACPAction(ply, target, "[ACP] Spawn menu access for " .. target:Nick() .. ": " .. (enabled and "enabled" or "disabled"))
end

function SetGlobalNotifications(ply, command, args)
	if not IsSuperAdminStaff(ply) then
		NotifyNoAccess(ply, "SuperAdmin")
		return
	end

	globalNotificationsEnabled = tobool(args[1])
	for _, target in ipairs(player.GetAll()) do
		SyncSpawnMenuState(target)
	end

	NotifyACPAction(ply, nil, "[ACP] Global ACP notifications: " .. (globalNotificationsEnabled and "enabled" or "disabled"))
end

function SetAllowAdminsPhysgunFreezePlayers(ply, command, args)
	if not IsSuperAdminStaff(ply) then
		NotifyNoAccess(ply, "SuperAdmin")
		return
	end

	allowAdminsPhysgunFreezePlayers = tobool(args[1])
	for _, target in ipairs(player.GetAll()) do
		SyncSpawnMenuState(target)
	end

	NotifyACPAction(ply, nil, "[ACP] Allow Admins Physgun Freeze Players: " .. (allowAdminsPhysgunFreezePlayers and "enabled" or "disabled"))
end

function PlayerPickup( ply, ent )
	if not allowAdminsPhysgunFreezePlayers then
		return
	end

	if IsValid(ent) and ent:IsPlayer() and IsAdminStaff(ply) then
		local steamId64 = ent:SteamID64()
		if physgunFrozenPlayersBySteamId64[steamId64] then
			physgunFrozenPlayersBySteamId64[steamId64] = nil
			ent:Freeze(false)
			if ent:GetMoveType() == MOVETYPE_NONE then
				ent:SetMoveType(MOVETYPE_WALK)
			end
			ent:PrintMessage(HUD_PRINTTALK, "[ACP] You were unfrozen by Physgun touch.")
			NotifyACPAction(ply, ent, "[ACP] " .. ent:Nick() .. " was unfrozen by Physgun touch.")
		end
	end

	if ( ply:IsAdmin() or ply:IsSuperAdmin() and ent:GetClass():lower() == "player" ) then
		return true
	end
end
hook.Add( "PhysgunPickup", "Allow Player Pickup", PlayerPickup )

hook.Add("OnPhysgunFreeze", "ACP_AdminPhysgunFreezePlayers", function(weapon, physobj, ent, ply)
	if not allowAdminsPhysgunFreezePlayers then return end
	if not IsValid(ply) or not IsAdminStaff(ply) then return end
	if not IsValid(ent) or not ent:IsPlayer() then return end

	physgunFrozenPlayersBySteamId64[ent:SteamID64()] = true
	ent:Freeze(true)
	ent:SetMoveType(MOVETYPE_NONE)
	ent:PrintMessage(HUD_PRINTTALK, "[ACP] You were frozen by an admin using Physgun.")
	NotifyACPAction(ply, ent, "[ACP] " .. ent:Nick() .. " was frozen with Physgun.")

	return true
end)

hook.Add("PlayerInitialSpawn", "ACP_SpawnMenuSync", function(ply)
	timer.Simple(1, function()
		SyncSpawnMenuState(ply)
	end)
end)




// Commands
concommand.Add( "acp_stopsound", StopSound)
concommand.Add( "acp_playsirena", PlaySirena)
concommand.Add( "acp_hostname", SetHostName)
concommand.Add( "acp_setpassword", SetPassword)
concommand.Add( "acp_killserver", KillServer)
concommand.Add( "acp_restart", Restart)
concommand.Add( "acp_refresh", Refresh)
concommand.Add( "acp_kickall", KickAll)
concommand.Add( "acp_makeallusers", MakeAllUsers)
concommand.Add( "acp_respawnall", RespawnAll)
concommand.Add( "acp_maxhp", MaxHP)
concommand.Add( "acp_rcon", Rcon)
concommand.Add( "acp_say", Say)
concommand.Add( "acp_enablemic", EnableMic)
concommand.Add( "acp_disablemic", DisableMic)
concommand.Add( "acp_chat_enable", EnableChat)
concommand.Add( "acp_chat_disable", DisableChat)
concommand.Add( "acp_noclip", Noclip)
concommand.Add( "acp_runspeed", RunSpeed)
concommand.Add( "acp_jumppower", JumpPower)
concommand.Add( "acp_sendlua", SendLua)
concommand.Add( "acp_extinguish", Extinguish)
concommand.Add( "acp_ignite", Ignite)
concommand.Add( "acp_exitvehicle", ExitVehicle)
concommand.Add( "acp_unfreeze", UnFreeze)
concommand.Add( "acp_freeze", Freeze)
concommand.Add( "acp_health", Health)
concommand.Add( "acp_armor", Armor)
concommand.Add( "acp_kick", Kick)
concommand.Add( "acp_ban", Ban)
concommand.Add( "acp_changemap", ChangeMap)
concommand.Add( "acp_god_enable", EnableGod)
concommand.Add( "acp_god_disable", DisableGod)
concommand.Add( "acp_give", Give)
concommand.Add( "acp_strip", Strip)
concommand.Add( "acp_forcerespawn", ForceRespawn)
concommand.Add( "acp_kill", Kill)
concommand.Add( "acp_settarget", SetTarget)
concommand.Add( "acp_setnotarget", SetNoTarget)
concommand.Add( "acp_goto", Goto)
concommand.Add( "acp_tp", Tp)
concommand.Add( "acp_warnrestart", WarnRestart)

//doors
concommand.Add( "acp_opendoors", OpenDoors )
concommand.Add( "acp_closedoors", CloseDoors)
concommand.Add( "acp_lockdoors", LockDoors)
concommand.Add( "acp_unlockdoors", UnLockDoors)
concommand.Add( "acp_removedoors", RemoveDoors)

//props
concommand.Add( "acp_clearalldecals", CleanAllDecals)
concommand.Add( "acp_clearallprops", CleanAllProps)
concommand.Add( "acp_igniteprops", IgniteProps)
concommand.Add( "acp_extinguishprops", ExtinguishProps)

// Ranks
concommand.Add( "acp_adduser_superadmin", SetSuperAdmin)
concommand.Add( "acp_adduser_admin", SetAdmin)
concommand.Add( "acp_removeuser", SetUser)

// Bots
concommand.Add("acp_createbot", CreateBot)
concommand.Add("acp_kickallbots", KickAllBots)
concommand.Add("acp_botmimic", BotMimic)

// UnBan
concommand.Add("acp_unban", UnBan)
concommand.Add("acp_spawnmenu_global", SetSpawnMenuGlobal)
concommand.Add("acp_spawnmenu_player", SetSpawnMenuForPlayer)
concommand.Add("acp_notifications_global", SetGlobalNotifications)
concommand.Add("acp_physgunfreeze_admins", SetAllowAdminsPhysgunFreezePlayers)


hook.Add("PlayerSay", "acp", function(sender, text, teamchat)
	if IsValid(sender) and chatDisabledBySteamId64[sender:SteamID64()] then
		sender:PrintMessage(HUD_PRINTTALK, "[ACP] Chat is disabled for you.")
		return ""
	end

	if text == CONFIG_ACP.ChatCommand then
 if sender:IsAdmin() then

	local senderPos = sender:GetPos()
	net.Start("acp_open")
	net.WriteVector(senderPos)
	net.WriteEntity(sender)
	net.Send(sender)
	else
	sender:PrintMessage( HUD_PRINTTALK, "ACP is allowed only for the server staff!")
	end
	end
end)
