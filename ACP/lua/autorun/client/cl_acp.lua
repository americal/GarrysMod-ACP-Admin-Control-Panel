include("sh_acp_config.lua")

function ACP()
local ACPMenu = vgui.Create( "DFrame" )
ACPMenu:SetSize( math.min(ScrW() - 40, 800), math.min(ScrH() - 40, 750) )
ACPMenu:Center()
ACPMenu:SetTitle( "ACP - Admin Control Panel " .. CONFIG_ACP.Version   )

ACPMenu:SetDeleteOnClose(true)
ACPMenu:SetDraggable( true )
ACPMenu:ShowCloseButton( true )
ACPMenu:MakePopup()
ACPMenu.Paint = function( self, w, h ) 
	draw.RoundedBox( 5, 0, 0, w, h, Color( 0, 0, 0)) 
	draw.RoundedBox( 5, 2, 2, w-4, h-4, Color( 72, 72, 72)) 
end

local MadeBy = vgui.Create("DLabel", ACPMenu)
MadeBy:SetText("Made by:")
MadeBy:SetPos(690, 24)
MadeBy:SetTextColor(Color(0,0,0))

local americal = vgui.Create("DButton", ACPMenu)
americal:SetText("americal")
americal:SetPos(740, 24)
americal:SetSize(50,20)
americal.DoClick = function ()
gui.OpenURL("http://steamcommunity.com/id/americal/")
end

// players
local sheet = vgui.Create( "DPropertySheet", ACPMenu )
sheet:SetPos( 5, 30 )
sheet:SetSize( ACPMenu:GetWide() - 10, ACPMenu:GetTall() - 35 )

local panel1 = vgui.Create( "DPanel", sheet )
panel1.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 191, 255 ) ) end
sheet:AddSheet( "Server", panel1, "icon16/server.png" )
--[[
local panel2 = vgui.Create( "DPanel", sheet )
panel2.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 128, 0 ) ) end
sheet:AddSheet( "Server", panel2, "icon16/tick.png" )
--]]
local panel3 = vgui.Create( "DPanel", sheet )
--panel3.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 128, 0 ) ) end
sheet:AddSheet( "Players", panel3, "icon16/user_edit.png" )

local panel2 = vgui.Create( "DPanel", sheet )
panel2.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 191, 255 ) ) end
sheet:AddSheet( "Settings", panel2, "icon16/cog.png" )





local PlayerList = vgui.Create("DListView")
PlayerList:SetParent(panel3)
PlayerList:SetPos(10, 20)
PlayerList:SetSize(750, 300)
PlayerList:SetMultiSelect(false)
PlayerList:AddColumn("Name")
PlayerList:AddColumn("SteamID")
PlayerList:AddColumn("Group")
PlayerList:AddColumn("ConnectID")
PlayerList:AddColumn("EntID")
PlayerList:AddColumn("Health")
PlayerList:AddColumn("SpawnMenu")
for k,v in pairs(player.GetAll()) do
	PlayerList:AddLine(v:Nick(), v:SteamID(), v:GetUserGroup(), v:UserID(), v:EntIndex(), v:Health(), v:GetNWBool("acp_spawnmenu_personal_allow", true) and "1" or "0")
end

local RefreshListButton = vgui.Create( "DButton", panel3 )
RefreshListButton:SetText( "Refresh" )
RefreshListButton:SetPos( 10, 5 )
RefreshListButton:SetSize( 750, 15 )
RefreshListButton.DoClick = function ()
PlayerList:Clear()
for k,v in pairs(player.GetAll()) do
	PlayerList:AddLine(v:Nick(), v:SteamID(), v:GetUserGroup(), v:UserID(), v:EntIndex(), v:Health(), v:GetNWBool("acp_spawnmenu_personal_allow", true) and "1" or "0")
end
end

local BanButton = vgui.Create( "DButton", panel3 )
BanButton:SetText( "Ban" )
BanButton:SetPos( 10, 330 )
BanButton:SetSize( 100, 50 )
BanButton.DoClick = function ()
RunConsoleCommand("acp_ban", BanTime:GetValue(), PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(4), PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(1))
end

BanTime = vgui.Create( "DTextEntry", panel3 )
BanTime:SetPos( 40,385 )
BanTime:SetTall( 20 )
BanTime:SetWide( 60 )
BanTime:SetNumeric(true)

BanTimeText = vgui.Create( "DLabel", panel3 )
BanTimeText:SetPos( 10,385 )
BanTimeText:SetText("Time:")
BanTimeText:SetTextColor(Color(0,0,0))


local KickButton = vgui.Create( "DButton", panel3 )
KickButton:SetText( "Kick" )
KickButton:SetPos( 135, 330 )
KickButton:SetSize( 100, 50 )
KickButton.DoClick = function ()
RunConsoleCommand("acp_kick", KickReason:GetValue(), PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(4), PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(1))
end

KickReason = vgui.Create( "DTextEntry", panel3 )
KickReason:SetPos( 175,385 )
KickReason:SetTall( 20 )
KickReason:SetWide( 60 )

KickReasonText = vgui.Create( "DLabel", panel3 )
KickReasonText:SetPos( 130,385 )
KickReasonText:SetText("Reason:")
KickReasonText:SetTextColor(Color(0,0,0))

local KillButton = vgui.Create( "DButton", panel3 )
KillButton:SetText( "Kill" )
KillButton:SetPos( 260, 330 )
KillButton:SetSize( 100, 50 )
KillButton.DoClick = function ()
RunConsoleCommand("acp_kill", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local NoTargetButton = vgui.Create( "DButton", panel3 )
NoTargetButton:SetText( "NPC NoTarget" )
NoTargetButton:SetPos( 385, 330 )
NoTargetButton:SetSize( 100, 25 )
NoTargetButton.DoClick = function ()
RunConsoleCommand("acp_setnotarget", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local TargetButton = vgui.Create( "DButton", panel3 )
TargetButton:SetText( "NPC Target" )
TargetButton:SetPos( 385, 355 )
TargetButton:SetSize( 100, 25 )
TargetButton.DoClick = function ()
RunConsoleCommand("acp_settarget", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local RespawnButton = vgui.Create( "DButton", panel3 )
RespawnButton:SetText( "Respawn" )
RespawnButton:SetPos( 510, 330 )
RespawnButton:SetSize( 100, 50 )
RespawnButton.DoClick = function ()
RunConsoleCommand("acp_forcerespawn", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local StripButton = vgui.Create( "DButton", panel3 )
StripButton:SetText( "Strip" )
StripButton:SetPos( 635, 330 )
StripButton:SetSize( 100, 50 )
StripButton.DoClick = function ()
RunConsoleCommand("acp_strip", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local TpButton = vgui.Create( "DButton", panel3 )
TpButton:SetText( "Tp" )
TpButton:SetPos( 10, 420 )
TpButton:SetSize( 100, 50 )
TpButton.DoClick = function ()
RunConsoleCommand("acp_tp", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local GotoButton = vgui.Create( "DButton", panel3 )
GotoButton:SetText( "Goto" )
GotoButton:SetPos( 135, 420 )
GotoButton:SetSize( 100, 50 )
GotoButton.DoClick = function ()
RunConsoleCommand("acp_goto", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local GodButton = vgui.Create( "DButton", panel3 )
GodButton:SetText( "God" )
GodButton:SetPos( 260, 420 )
GodButton:SetSize( 100, 25 )
GodButton.DoClick = function ()
RunConsoleCommand("acp_god_enable", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local UnGodButton = vgui.Create( "DButton", panel3 )
UnGodButton:SetText( "UnGod" )
UnGodButton:SetPos( 260, 445 )
UnGodButton:SetSize( 100, 25 )
UnGodButton.DoClick = function ()
RunConsoleCommand("acp_god_disable", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local ExitVehicleButton = vgui.Create( "DButton", panel3 )
ExitVehicleButton:SetText( "Force Exit Vehicle" )
ExitVehicleButton:SetPos( 385, 420 )
ExitVehicleButton:SetSize( 100, 50 )
ExitVehicleButton.DoClick = function ()
RunConsoleCommand("acp_exitvehicle", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local GiveButton = vgui.Create( "DButton", panel3 )
GiveButton:SetText( "Give" )
GiveButton:SetPos( 510, 420 )
GiveButton:SetSize( 100, 50 )
GiveButton.DoClick = function ()
RunConsoleCommand("acp_give", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5), Weapon:GetValue())
end

WeaponText = vgui.Create( "DLabel", panel3 )
WeaponText:SetPos( 505,475 )
WeaponText:SetText("Weapon:")
WeaponText:SetTextColor(Color(0,0,0))

Weapon = vgui.Create( "DTextEntry", panel3 )
Weapon:SetPos( 550,475 )
Weapon:SetTall( 20 )
Weapon:SetWide( 60 )

local IgniteButton = vgui.Create( "DButton", panel3 )
IgniteButton:SetText( "Ignite" )
IgniteButton:SetPos( 635, 420 )
IgniteButton:SetSize( 100, 25 )
IgniteButton.DoClick = function ()
RunConsoleCommand("acp_ignite", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local ExtinguishButton = vgui.Create( "DButton", panel3 )
ExtinguishButton:SetText( "Extinguish" )
ExtinguishButton:SetPos( 635, 445 )
ExtinguishButton:SetSize( 100, 25 )
ExtinguishButton.DoClick = function ()
RunConsoleCommand("acp_extinguish", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local NoclipButton = vgui.Create( "DButton", panel3 )
NoclipButton:SetText( "Noclip" )
NoclipButton:SetPos( 10, 510 )
NoclipButton:SetSize( 100, 50 )
NoclipButton.DoClick = function ()
RunConsoleCommand("acp_noclip", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end


local HealthButton = vgui.Create( "DButton", panel3 )
HealthButton:SetText( "Health" )
HealthButton:SetPos( 135, 510 )
HealthButton:SetSize( 100, 50 )
HealthButton.DoClick = function ()
RunConsoleCommand("acp_health", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5), Health:GetValue())
end

HealthText = vgui.Create( "DLabel", panel3 )
HealthText:SetPos( 145,565 )
HealthText:SetText("HP:")
HealthText:SetTextColor(Color(0,0,0))

Health = vgui.Create( "DTextEntry", panel3 )
Health:SetPos( 170,565 )
Health:SetTall( 20 )
Health:SetWide( 60 )
Health:SetNumeric(true)

local ArmorButton = vgui.Create( "DButton", panel3 )
ArmorButton:SetText( "Armor" )
ArmorButton:SetPos( 260, 510 )
ArmorButton:SetSize( 100, 50 )
ArmorButton.DoClick = function ()
RunConsoleCommand("acp_armor", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5), Armor:GetValue())
end

ArmorText = vgui.Create( "DLabel", panel3 )
ArmorText:SetPos( 260,565 )
ArmorText:SetText("Armor:")
ArmorText:SetTextColor(Color(0,0,0))

Armor = vgui.Create( "DTextEntry", panel3 )
Armor:SetPos( 295,565 )
Armor:SetTall( 20 )
Armor:SetWide( 60 )
Armor:SetNumeric(true)

local FreezeButton = vgui.Create( "DButton", panel3 )
FreezeButton:SetText( "Freeze" )
FreezeButton:SetPos( 385, 510 )
FreezeButton:SetSize( 100, 25 )
FreezeButton.DoClick = function ()
RunConsoleCommand("acp_freeze", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local UnFreezeButton = vgui.Create( "DButton", panel3 )
UnFreezeButton:SetText( "UnFreeze" )
UnFreezeButton:SetPos( 385, 535 )
UnFreezeButton:SetSize( 100, 25 )
UnFreezeButton.DoClick = function ()
RunConsoleCommand("acp_unfreeze", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local EnableMicButton = vgui.Create( "DButton", panel3 )
EnableMicButton:SetText( "Enable Mic" )
EnableMicButton:SetPos( 510, 510 )
EnableMicButton:SetSize( 100, 25 )
EnableMicButton.DoClick = function ()
RunConsoleCommand("acp_enablemic", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local DisableMicButton = vgui.Create( "DButton", panel3 )
DisableMicButton:SetText( "Disable Mic" )
DisableMicButton:SetPos( 510, 535 )
DisableMicButton:SetSize( 100, 25 )
DisableMicButton.DoClick = function ()
RunConsoleCommand("acp_disablemic", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5))
end

local SayButton = vgui.Create( "DButton", panel3 )
SayButton:SetText( "Say" )
SayButton:SetPos( 635, 510 )
SayButton:SetSize( 100, 50 )
SayButton.DoClick = function ()
RunConsoleCommand("acp_say", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5), Say:GetValue())
end

SayText = vgui.Create( "DLabel", panel3 )
SayText:SetPos( 635,565 )
SayText:SetText("Text:")
SayText:SetTextColor(Color(0,0,0))

Say = vgui.Create( "DTextEntry", panel3 )
Say:SetPos( 670,565 )
Say:SetTall( 20 )
Say:SetWide( 60 )

local SetRankButton = vgui.Create("DButton", panel3)
SetRankButton:SetParent( panel3 )
SetRankButton:SetText( "SetRank" )
SetRankButton:SetPos(10, 600)
SetRankButton:SetSize( 100, 50 )
SetRankButton.DoClick = function ( btn )

    local SetRankButtonOptions = DermaMenu()
--	SetRankButtonOptions:AddOption("user*", function() RunConsoleCommand("acp_adduser_root", PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(2)) end )
--    SetRankButtonOptions:AddOption("founder", function() RunConsoleCommand("acp_adduser_founder", PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(2)) end)
--	SetRankButtonOptions:AddOption("headadmin", function() RunConsoleCommand("acp_adduser_headadmin", PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(2)) end)
	SetRankButtonOptions:AddOption("superadmin", function() RunConsoleCommand("acp_adduser_superadmin", PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(5), PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(1)) end )
--	SetRankButtonOptions:AddOption("uberadmin", function() RunConsoleCommand("acp_adduser_uberadmin", PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(2)) end )
	SetRankButtonOptions:AddOption("admin", function() RunConsoleCommand("acp_adduser_admin", PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(5), PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(1)) end )
--	SetRankButtonOptions:AddOption("moderator", function() RunConsoleCommand("acp_adduser_moderator", PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(2)) end )
--    SetRankButtonOptions:AddOption("vip", function() RunConsoleCommand("acp_adduser_vip", PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(2)) end )
	SetRankButtonOptions:AddOption("user", function() RunConsoleCommand("acp_removeuser", PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(5), PlayerList:GetLine( PlayerList:GetSelectedLine()):GetValue(1)) end ) 
    SetRankButtonOptions:Open() 
end -- RunConsoleCommand("ulx", "adduserid", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(2), "")

local SendLuaButton = vgui.Create( "DButton", panel3 )
SendLuaButton:SetText( "SendLua" )
SendLuaButton:SetPos( 135, 600 )
SendLuaButton:SetSize( 100, 50 )
SendLuaButton.DoClick = function ()
RunConsoleCommand("acp_sendlua", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5), SendLua:GetValue())
end

SendLuaText = vgui.Create( "DLabel", panel3 )
SendLuaText:SetPos( 135,655 )
SendLuaText:SetText("Lua:")
SendLuaText:SetTextColor(Color(0,0,0))

SendLua = vgui.Create( "DTextEntry", panel3 )
SendLua:SetPos( 170,655 )
SendLua:SetTall( 20 )
SendLua:SetWide( 60 )

local SpawnMenuOnButton = vgui.Create("DButton", panel3)
SpawnMenuOnButton:SetText("SpawnMenu ON")
SpawnMenuOnButton:SetPos(510, 600)
SpawnMenuOnButton:SetSize(100, 25)
SpawnMenuOnButton.DoClick = function()
	RunConsoleCommand("acp_spawnmenu_player", PlayerList:GetLine(PlayerList:GetSelectedLine()):GetValue(5), "1")
end

local SpawnMenuOffButton = vgui.Create("DButton", panel3)
SpawnMenuOffButton:SetText("SpawnMenu OFF")
SpawnMenuOffButton:SetPos(510, 625)
SpawnMenuOffButton:SetSize(100, 25)
SpawnMenuOffButton.DoClick = function()
	RunConsoleCommand("acp_spawnmenu_player", PlayerList:GetLine(PlayerList:GetSelectedLine()):GetValue(5), "0")
end

local EnableChatButton = vgui.Create("DButton", panel3)
EnableChatButton:SetText("Enable Chat")
EnableChatButton:SetPos(635, 600)
EnableChatButton:SetSize(100, 25)
EnableChatButton.DoClick = function()
	RunConsoleCommand("acp_chat_enable", PlayerList:GetLine(PlayerList:GetSelectedLine()):GetValue(5))
end

local DisableChatButton = vgui.Create("DButton", panel3)
DisableChatButton:SetText("Disable Chat")
DisableChatButton:SetPos(635, 625)
DisableChatButton:SetSize(100, 25)
DisableChatButton.DoClick = function()
	RunConsoleCommand("acp_chat_disable", PlayerList:GetLine(PlayerList:GetSelectedLine()):GetValue(5))
end

local RunSpeedButton = vgui.Create( "DButton", panel3 )
RunSpeedButton:SetText( "Run Speed" )
RunSpeedButton:SetPos( 260, 600 )
RunSpeedButton:SetSize( 100, 50 )
RunSpeedButton.DoClick = function ()
RunConsoleCommand("acp_runspeed", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5), RunSpeed:GetValue())
end

RunSpeedText = vgui.Create( "DLabel", panel3 )
RunSpeedText:SetPos( 260,655 )
RunSpeedText:SetText("Speed:")
RunSpeedText:SetTextColor(Color(0,0,0))

RunSpeed = vgui.Create( "DTextEntry", panel3 )
RunSpeed:SetPos( 295,655 )
RunSpeed:SetTall( 20 )
RunSpeed:SetWide( 60 )
RunSpeed:SetText( "250" )
RunSpeed:SetNumeric(true)

local JumpPowerButton = vgui.Create( "DButton", panel3 )
JumpPowerButton:SetText( "Jump Power" )
JumpPowerButton:SetPos( 385, 600 )
JumpPowerButton:SetSize( 100, 50 )
JumpPowerButton.DoClick = function ()
RunConsoleCommand("acp_jumppower", PlayerList:GetLine( PlayerList:GetSelectedLine() ):GetValue(5), JumpPower:GetValue())
end

JumpPowerText = vgui.Create( "DLabel", panel3 )
JumpPowerText:SetPos( 385,655 )
JumpPowerText:SetText("Power:")
JumpPowerText:SetTextColor(Color(0,0,0))

JumpPower = vgui.Create( "DTextEntry", panel3 )
JumpPower:SetPos( 420,655 )
JumpPower:SetTall( 20 )
JumpPower:SetWide( 60 )
JumpPower:SetText( "200" )
JumpPower:SetNumeric(true)


// Server 
local RconButton = vgui.Create( "DButton", panel1 )
RconButton:SetText( "Send" )
RconButton:SetPos( 700, 650 )
RconButton:SetSize( 65, 25 )
RconButton.DoClick = function ()
RunConsoleCommand("acp_rcon", Rcon1:GetValue(), Rcon2:GetValue(), Rcon3:GetValue(), Rcon4:GetValue(), Rcon5:GetValue())
end

RconText = vgui.Create( "DLabel", panel1 )
RconText:SetPos( 10,655 )
RconText:SetText("Rcon:")
RconText:SetTextColor(Color(0,0,0))

Rcon1 = vgui.Create( "DTextEntry", panel1 )
Rcon1:SetPos( 40,655 )
Rcon1:SetTall( 20 )
Rcon1:SetWide( 120 )

Rcon2 = vgui.Create( "DTextEntry", panel1 )
Rcon2:SetPos( 170,655 )
Rcon2:SetTall( 20 )
Rcon2:SetWide( 120 )

Rcon3 = vgui.Create( "DTextEntry", panel1 )
Rcon3:SetPos( 300,655 )
Rcon3:SetTall( 20 )
Rcon3:SetWide( 120 )

Rcon4 = vgui.Create( "DTextEntry", panel1 )
Rcon4:SetPos( 430,655 )
Rcon4:SetTall( 20 )
Rcon4:SetWide( 120 )

Rcon5 = vgui.Create( "DTextEntry", panel1 )
Rcon5:SetPos( 560,655 )
Rcon5:SetTall( 20 )
Rcon5:SetWide( 120 )

local ControlGround = vgui.Create( "DPanel", panel1 )
ControlGround:SetPos( 245, 15 )
ControlGround:SetSize( 525, 460 )
ControlGround.Paint = function() 
    surface.SetDrawColor( 200, 200, 200, 255 ) 
    surface.DrawRect( 0, 0, ControlGround:GetWide(), ControlGround:GetTall() ) -- Draw the rect
	end

local Control = vgui.Create( "DPanel", panel1 )
Control:SetPos( 250, 20 )
Control:SetSize( 515, 450 )
Control.Paint = function()
    surface.SetDrawColor( 255, 255, 255, 255 ) 
    surface.DrawRect( 0, 0, Control:GetWide(), Control:GetTall() ) -- Draw the rect
end

local ServerControl = vgui.Create("DLabel", panel1)
ServerControl:SetPos(470,20)
ServerControl:SetColor(Color(70,70,70,250))
ServerControl:SetFont("default")
ServerControl:SetText("Server Control")
ServerControl:SizeToContents()

local KillServerButton = vgui.Create( "DButton", panel1 )
KillServerButton:SetText( "ShutDown" )
KillServerButton:SetPos( 258, 40 )
KillServerButton:SetSize( 500, 50 )
KillServerButton.DoClick = function ()
RunConsoleCommand("acp_killserver")
end

local RestartButton = vgui.Create( "DButton", panel1 )
RestartButton:SetText( "Restart" )
RestartButton:SetPos( 258, 95 )
RestartButton:SetSize( 500, 50 )
RestartButton.DoClick = function ()
RunConsoleCommand("acp_restart")
end

local ChangeMapButton = vgui.Create( "DButton", panel1 )
ChangeMapButton:SetText( "Change Map" )
ChangeMapButton:SetPos( 258, 150 )
ChangeMapButton:SetSize( 500, 50 )
ChangeMapButton.DoClick = function ()
RunConsoleCommand("acp_changemap", ChangeMap:GetValue())
end

ChangeMapText = vgui.Create( "DLabel", panel1 )
ChangeMapText:SetPos( 258,205 )
ChangeMapText:SetText("Map:")
ChangeMapText:SetTextColor(Color(0,0,0))

ChangeMap = vgui.Create( "DTextEntry", panel1 )
ChangeMap:SetPos( 285,205 )
ChangeMap:SetTall( 20 )
ChangeMap:SetWide( 450 )

local SetPasswordButton = vgui.Create( "DButton", panel1 )
SetPasswordButton:SetText( "Set Password" )
SetPasswordButton:SetPos( 258, 230 )
SetPasswordButton:SetSize( 500, 50 )
SetPasswordButton.DoClick = function ()
RunConsoleCommand("acp_setpassword", SetPassword:GetValue())
end

SetPasswordText = vgui.Create( "DLabel", panel1 )
SetPasswordText:SetPos( 258,285 )
SetPasswordText:SetText("Password:")
SetPasswordText:SetTextColor(Color(0,0,0))

SetPassword = vgui.Create( "DTextEntry", panel1 )
SetPassword:SetPos( 310,285 )
SetPassword:SetTall( 20 )
SetPassword:SetWide( 425 )

local SetHostNameButton = vgui.Create( "DButton", panel1 )
SetHostNameButton:SetText( "Set HostName" )
SetHostNameButton:SetPos( 258, 310 )
SetHostNameButton:SetSize( 500, 50 )
SetHostNameButton.DoClick = function ()
RunConsoleCommand("acp_hostname", SetHostName:GetValue())
end

SetHostNameText = vgui.Create( "DLabel", panel1 )
SetHostNameText:SetPos( 257,365 )
SetHostNameText:SetText("HostName:")
SetHostNameText:SetTextColor(Color(0,0,0))

SetHostName = vgui.Create( "DTextEntry", panel1 )
SetHostName:SetPos( 310,365 )
SetHostName:SetTall( 20 )
SetHostName:SetWide( 425 )

local PlaySirena = vgui.Create( "DButton", panel1 )
PlaySirena:SetText( "Play Sirena" )
PlaySirena:SetPos( 258, 390 )
PlaySirena:SetSize( 500, 50 )
PlaySirena.DoClick = function ()
RunConsoleCommand("acp_playsirena")
end

local StopSound = vgui.Create( "DButton", panel1 )
StopSound:SetText( "Stop Sounds" )
StopSound:SetPos( 258, 430 )
StopSound:SetSize( 500, 25 )
StopSound.DoClick = function ()
RunConsoleCommand("acp_stopsound")
end

local ServerInfo = vgui.Create( "DPanel", panel1 )
ServerInfo:SetPos( 5, 480 )
ServerInfo:SetSize( 235, 160 )
ServerInfo.Paint = function()
    surface.SetDrawColor( 200, 200, 200, 255 ) 
    surface.DrawRect( 0, 0, ServerInfo:GetWide(), ServerInfo:GetTall() ) 
end

local ServerInfoBackGround= vgui.Create( "DPanel", panel1 )
ServerInfoBackGround:SetPos( 15, 490 )
ServerInfoBackGround:SetSize( 215, 140 )
ServerInfoBackGround.Paint = function()
    surface.SetDrawColor( 255, 255, 255, 255 ) 
    surface.DrawRect( 0, 0, ServerInfoBackGround:GetWide(), ServerInfoBackGround:GetTall() )
end

local ServerInfoText = vgui.Create("DLabel", panel1)
ServerInfoText:SetPos(90,478)
ServerInfoText:SetColor(Color(100,100,100,255))
ServerInfoText:SetFont("default")
ServerInfoText:SetText("Server Info")
ServerInfoText:SizeToContents()

local ServerNameText = vgui.Create("DLabel", panel1)
ServerNameText:SetPos(20,500)
ServerNameText:SetColor(Color(70,70,70,250))
ServerNameText:SetFont("default")
ServerNameText:SetText("Players On Server:")
ServerNameText:SizeToContents()

local PlayersOnline = vgui.Create("DLabel", panel1)
PlayersOnline:SetPos(120,500)
PlayersOnline:SetColor(Color(0,0,0,255))
PlayersOnline:SetFont("default")
function PlayersOnline:Think()
PlayersOnline:SetText(player.GetCount() .. " / " .. game.MaxPlayers())
end
PlayersOnline:SizeToContents()

local ServerMapText = vgui.Create("DLabel", panel1)
ServerMapText:SetPos(20,540)
ServerMapText:SetColor(Color(70,70,70,250))
ServerMapText:SetFont("default")
ServerMapText:SetText("Map:")
ServerMapText:SizeToContents()

local ServerMap = vgui.Create("DLabel", panel1)
ServerMap:SetPos(50,540)
ServerMap:SetColor(Color(0,0,0,255))
ServerMap:SetFont("default")
ServerMap:SetText(game.GetMap())
ServerMap:SizeToContents()

local GameModeText = vgui.Create("DLabel", panel1)
GameModeText:SetPos(20,560)
GameModeText:SetColor(Color(70,70,70,250))
GameModeText:SetFont("default")
GameModeText:SetText("GameMode:")
GameModeText:SizeToContents()

local GameMode = vgui.Create("DLabel", panel1)
GameMode:SetPos(80,560)
GameMode:SetColor(Color(0,0,0,255))
GameMode:SetFont("default")
GameMode:SetText(gmod.GetGamemode().Name)
GameMode:SizeToContents()

local PropsText = vgui.Create("DLabel", panel1)
PropsText:SetPos(20,580)
PropsText:SetColor(Color(70,70,70,250))
PropsText:SetFont("default")
PropsText:SetText("Props On Server:")
PropsText:SizeToContents()

local Props = vgui.Create("DLabel", panel1)
Props:SetPos(110,580)
Props:SetColor(Color(0,0,0,255))
Props:SetFont("default")
function Props:Think()
Props:SetText(#ents.FindByClass( "prop_physics" ))
end
Props:SizeToContents()

local DoorsText = vgui.Create("DLabel", panel1)
DoorsText:SetPos(20,600)
DoorsText:SetColor(Color(70,70,70,250))
DoorsText:SetFont("default")
DoorsText:SetText("Doors On Server:")
DoorsText:SizeToContents()

local Dors = vgui.Create("DLabel", panel1)
Dors:SetPos(110,600)
Dors:SetColor(Color(0,0,0,255))
Dors:SetFont("default")
function Dors:Think()
Dors:SetText(#ents.FindByClass( "prop_door_rotating" ))
end
Dors:SizeToContents()

local TimeText = vgui.Create("DLabel", panel1)
TimeText:SetPos(20,520)
TimeText:SetColor(Color(70,70,70,250))
TimeText:SetFont("default")
TimeText:SetText("Bots On Server:")
TimeText:SizeToContents()

local Time = vgui.Create("DLabel", panel1)
Time:SetPos(110,520)
Time:SetColor(Color(0,0,0,255))
Time:SetFont("default")
function Time:Think()
Time:SetText(#player.GetBots())
end
Time:SizeToContents()
local ServerPropsGround = vgui.Create( "DPanel", panel1 )
ServerPropsGround:SetPos( 5, 15 )
ServerPropsGround:SetSize( 235, 460 )
ServerPropsGround.Paint = function() 
    surface.SetDrawColor( 200, 200, 200, 255 ) 
    surface.DrawRect( 0, 0, ServerPropsGround:GetWide(), ServerPropsGround:GetTall() ) -- Draw the rect
	end

local ServerProps = vgui.Create( "DPanel", panel1 )
ServerProps:SetPos( 10, 20 )
ServerProps:SetSize( 225, 450 )
ServerProps.Paint = function()
    surface.SetDrawColor( 255, 255, 255, 255 ) 
    surface.DrawRect( 0, 0, ServerProps:GetWide(), ServerProps:GetTall() ) -- Draw the rect
end

local MakeAllUsersButton = vgui.Create( "DButton", panel1 )
MakeAllUsersButton:SetText( "Make All Users" )
MakeAllUsersButton:SetPos( 20, 340 )
MakeAllUsersButton:SetSize( 200, 25 )
MakeAllUsersButton.DoClick = function ()
RunConsoleCommand("acp_makeallusers")
end

local KickAllButton = vgui.Create( "DButton", panel1 )
KickAllButton:SetText( "KickAll" )
KickAllButton:SetPos( 20, 365 )
KickAllButton:SetSize( 200, 25 )
KickAllButton.DoClick = function ()
RunConsoleCommand("acp_kickall")
end

local MaxHPButton = vgui.Create( "DButton", panel1 )
MaxHPButton:SetText( "Set All 100 HP" )
MaxHPButton:SetPos( 20, 390 )
MaxHPButton:SetSize( 200, 25 )
MaxHPButton.DoClick = function ()
RunConsoleCommand("acp_maxhp")
end

local RespawnAllButton = vgui.Create( "DButton", panel1 )
RespawnAllButton:SetText( "Respawn All" )
RespawnAllButton:SetPos( 20, 415 )
RespawnAllButton:SetSize( 200, 25 )
RespawnAllButton.DoClick = function ()
RunConsoleCommand("acp_respawnall")
end

local WarnAllButton = vgui.Create( "DButton", panel1 )
WarnAllButton:SetText( "Warn All About Restart" )
WarnAllButton:SetPos( 20, 440 )
WarnAllButton:SetSize( 200, 25 )
WarnAllButton.DoClick = function ()
RunConsoleCommand("acp_warnrestart")
end

local DoorControl = vgui.Create("DLabel", panel1)
DoorControl:SetPos(90,20)
DoorControl:SetColor(Color(70,70,70,250))
DoorControl:SetFont("default")
DoorControl:SetText("Doors Control")
DoorControl:SizeToContents()

local OpenDoors = vgui.Create( "DButton", panel1 )
OpenDoors:SetText( "Open Doors" )
OpenDoors:SetPos( 30, 40 )
OpenDoors:SetSize( 80, 40 )
OpenDoors.DoClick = function ()
    RunConsoleCommand( "acp_opendoors" )
end

local CloseDoors = vgui.Create( "DButton", panel1 )
CloseDoors:SetText( "Close Doors" )
CloseDoors:SetPos( 130, 40 )
CloseDoors:SetSize( 80, 40 )
CloseDoors.DoClick = function ()
    RunConsoleCommand( "acp_closedoors" )
end

local UnLockDoors = vgui.Create( "DButton", panel1 )
UnLockDoors:SetText( "UnLock Doors" )
UnLockDoors:SetPos( 30, 90 )
UnLockDoors:SetSize( 80, 40 )
UnLockDoors.DoClick = function ()
    RunConsoleCommand( "acp_unlockdoors" )
end

local LockDoors = vgui.Create( "DButton", panel1 )
LockDoors:SetText( "Lock Doors" )
LockDoors:SetPos( 130, 90 )
LockDoors:SetSize( 80, 40 )
LockDoors.DoClick = function ()
    RunConsoleCommand( "acp_lockdoors" )
end

local RemoveDoors = vgui.Create( "DButton", panel1 )
RemoveDoors:SetText( "Remove Doors" )
RemoveDoors:SetPos( 60, 140 )
RemoveDoors:SetSize( 120, 40 )
RemoveDoors.DoClick = function ()
    RunConsoleCommand( "acp_removedoors" )
end

local PropControl = vgui.Create("DLabel", panel1)
PropControl:SetPos(90,185)
PropControl:SetColor(Color(70,70,70,250))
PropControl:SetFont("default")
PropControl:SetText("Props Control")
PropControl:SizeToContents()

local IgniteProps = vgui.Create( "DButton", panel1 )
IgniteProps:SetText( "Ignite Props" )
IgniteProps:SetPos( 30, 210 )
IgniteProps:SetSize( 80, 40 )
IgniteProps.DoClick = function ()
    RunConsoleCommand( "acp_igniteprops" )
end

local ExtinguishProps = vgui.Create( "DButton", panel1 )
ExtinguishProps:SetText( "Quench Props" )
ExtinguishProps:SetPos( 130, 210 )
ExtinguishProps:SetSize( 80, 40 )
ExtinguishProps.DoClick = function ()
    RunConsoleCommand( "acp_extinguishprops" )
end

local ClaerProps = vgui.Create( "DButton", panel1 )
ClaerProps:SetText( "Clear Props" )
ClaerProps:SetPos( 30, 260 )
ClaerProps:SetSize( 80, 40 )
ClaerProps.DoClick = function ()
    RunConsoleCommand( "acp_clearallprops" )
end

local ClaerDecals = vgui.Create( "DButton", panel1 )
ClaerDecals:SetText( "Clear Decals" )
ClaerDecals:SetPos( 130, 260 )
ClaerDecals:SetSize( 80, 40 )
ClaerDecals.DoClick = function ()
    RunConsoleCommand( "acp_clearalldecals" )
end

local PlayersControl = vgui.Create("DLabel", panel1)
PlayersControl:SetPos(90,310)
PlayersControl:SetColor(Color(70,70,70,250))
PlayersControl:SetFont("default")
PlayersControl:SetText("Player Control")
PlayersControl:SizeToContents()

local BotControl = vgui.Create( "DPanel", panel1 )
BotControl:SetPos( 245, 480 )
BotControl:SetSize( 525, 160 )
BotControl.Paint = function()
    surface.SetDrawColor( 200, 200, 200, 255 ) 
    surface.DrawRect( 0, 0, BotControl:GetWide(), BotControl:GetTall() ) 
end

local BotControlBackGround= vgui.Create( "DPanel", panel1 )
BotControlBackGround:SetPos( 255, 490 )
BotControlBackGround:SetSize( 505, 140 )
BotControlBackGround.Paint = function()
    surface.SetDrawColor( 255, 255, 255, 255 ) 
    surface.DrawRect( 0, 0, BotControlBackGround:GetWide(), BotControlBackGround:GetTall() )
end

local BotControlText = vgui.Create("DLabel", panel1)
BotControlText:SetPos(470,478)
BotControlText:SetColor(Color(100,100,100,255))
BotControlText:SetFont("default")
BotControlText:SetText("Bot Control")
BotControlText:SizeToContents()

local SpawnBotButton = vgui.Create( "DButton", panel1 )
SpawnBotButton:SetText( "Spawn Bot" )
SpawnBotButton:SetPos( 258, 495 )
SpawnBotButton:SetSize( 500, 33 )
SpawnBotButton.DoClick = function ()
RunConsoleCommand("acp_createbot")
end

local KickBotsButton = vgui.Create( "DButton", panel1 )
KickBotsButton:SetText( "Kick Bots" )
KickBotsButton:SetPos( 258, 532 )
KickBotsButton:SetSize( 500, 33 )
KickBotsButton.DoClick = function ()
RunConsoleCommand("acp_kickallbots")
end

local BotMimicButton = vgui.Create( "DButton", panel1 )
BotMimicButton:SetText( "Bot Mimic" )
BotMimicButton:SetPos( 258, 569 )
BotMimicButton:SetSize( 500, 33 )
BotMimicButton.DoClick = function ()
RunConsoleCommand("acp_botmimic", MimicID:GetValue())
end

MimicID = vgui.Create( "DTextEntry", panel1 )
MimicID:SetPos( 315,605 )
MimicID:SetTall( 20 )
MimicID:SetWide( 443 )
MimicID:SetNumeric(true)

local MimicIDText = vgui.Create("DLabel", panel1)
MimicIDText:SetText("ConnectID:")
MimicIDText:SetPos(260, 605)
MimicIDText:SetTextColor(Color(0,0,0))


local Refresh = vgui.Create( "DButton", panel1 )
Refresh:SetText( "Refresh" )
Refresh:SetPos( 17, 614 )
Refresh:SetSize( 210, 15 )
Refresh.DoClick = function ()
ACPMenu:Close()
ACP()
end

-- limits 
local limitsGround = vgui.Create( "DPanel", panel2 )
limitsGround:SetPos( 245, 15 )
limitsGround:SetSize( 525, 530 )
limitsGround.Paint = function() 
    surface.SetDrawColor( 200, 200, 200, 255 ) 
    surface.DrawRect( 0, 0, limitsGround:GetWide(), limitsGround:GetTall() ) -- Draw the rect
	end

local limitspanel = vgui.Create( "DPanel", panel2 )
limitspanel:SetPos( 250, 20 )
limitspanel:SetSize( 515, 520 )
limitspanel.Paint = function()
    surface.SetDrawColor( 255, 255, 255, 255 ) 
    surface.DrawRect( 0, 0, limitspanel:GetWide(), limitspanel:GetTall() ) -- Draw the rect
end

local LimitText = vgui.Create("DLabel", panel2)
LimitText:SetPos(500,20)
LimitText:SetColor(Color(100,100,100,255))
LimitText:SetFont("default")
LimitText:SetText("Limits")
LimitText:SizeToContents()

local MaxPropsText = vgui.Create("DLabel", panel2)
MaxPropsText:SetPos(255,50)
MaxPropsText:SetColor(Color(70,70,70,250))
--NumSliderThingyText:SetFont("default")
MaxPropsText:SetText("Max Props")
MaxPropsText:SizeToContents()

local NumSliderMaxProps = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxProps:SetPos( 10,50 )
NumSliderMaxProps:SetSize( 775, 10 ) 
NumSliderMaxProps:SetText( "" )
NumSliderMaxProps:SetMin( 0 ) 
NumSliderMaxProps:SetMax( 500 ) 
NumSliderMaxProps:SetDecimals( 0 ) 
NumSliderMaxProps:SetConVar( "sbox_maxprops" ) 

local MaxRagdollsText = vgui.Create("DLabel", panel2)
MaxRagdollsText:SetPos(255,80)
MaxRagdollsText:SetColor(Color(70,70,70,250))
MaxRagdollsText:SetText("Max Ragdolls")
MaxRagdollsText:SizeToContents()

local NumSliderMaxRagdolls = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxRagdolls:SetPos( 10,80 )
NumSliderMaxRagdolls:SetSize( 775, 10 ) 
NumSliderMaxRagdolls:SetText( "" )
NumSliderMaxRagdolls:SetMin( 0 ) 
NumSliderMaxRagdolls:SetMax( 500 ) 
NumSliderMaxRagdolls:SetDecimals( 0 ) 
NumSliderMaxRagdolls:SetConVar( "sbox_maxragdolls" )

local MaxNPCText = vgui.Create("DLabel", panel2)
MaxNPCText:SetPos(255,110)
MaxNPCText:SetColor(Color(70,70,70,250))
MaxNPCText:SetText("Max NPC")
MaxNPCText:SizeToContents()

local NumSliderMaxNPC = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxNPC:SetPos( 10,110 )
NumSliderMaxNPC:SetSize( 775, 10 ) 
NumSliderMaxNPC:SetText( "" )
NumSliderMaxNPC:SetMin( 0 ) 
NumSliderMaxNPC:SetMax( 500 ) 
NumSliderMaxNPC:SetDecimals( 0 ) 
NumSliderMaxNPC:SetConVar( "sbox_maxnpcs" )

local MaxBalloonsText = vgui.Create("DLabel", panel2)
MaxBalloonsText:SetPos(255,140)
MaxBalloonsText:SetColor(Color(70,70,70,250))
MaxBalloonsText:SetText("Max Balloons")
MaxBalloonsText:SizeToContents()

local NumSliderMaxBalloons = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxBalloons:SetPos( 10,140 )
NumSliderMaxBalloons:SetSize( 775, 10 ) 
NumSliderMaxBalloons:SetText( "" )
NumSliderMaxBalloons:SetMin( 0 ) 
NumSliderMaxBalloons:SetMax( 500 ) 
NumSliderMaxBalloons:SetDecimals( 0 ) 
NumSliderMaxBalloons:SetConVar( "sbox_maxballoons" )

local MaxBalloonsText = vgui.Create("DLabel", panel2)
MaxBalloonsText:SetPos(255,170)
MaxBalloonsText:SetColor(Color(70,70,70,250))
MaxBalloonsText:SetText("Max Effects")
MaxBalloonsText:SizeToContents()

local NumSliderMaxEffects = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxEffects:SetPos( 10,170 )
NumSliderMaxEffects:SetSize( 775, 10 ) 
NumSliderMaxEffects:SetText( "" )
NumSliderMaxEffects:SetMin( 0 ) 
NumSliderMaxEffects:SetMax( 500 ) 
NumSliderMaxEffects:SetDecimals( 0 ) 
NumSliderMaxEffects:SetConVar( "sbox_maxeffects" )

local MaxDynamiteText = vgui.Create("DLabel", panel2)
MaxDynamiteText:SetPos(255,200)
MaxDynamiteText:SetColor(Color(70,70,70,250))
MaxDynamiteText:SetText("Max Dynamite")
MaxDynamiteText:SizeToContents()

local NumSliderMaxDynamite = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxDynamite:SetPos( 10,200 )
NumSliderMaxDynamite:SetSize( 775, 10 ) 
NumSliderMaxDynamite:SetText( "" )
NumSliderMaxDynamite:SetMin( 0 ) 
NumSliderMaxDynamite:SetMax( 500 ) 
NumSliderMaxDynamite:SetDecimals( 0 ) 
NumSliderMaxDynamite:SetConVar( "sbox_maxdynamite" )

local MaxBalloonsLamps = vgui.Create("DLabel", panel2)
MaxBalloonsLamps:SetPos(255,230)
MaxBalloonsLamps:SetColor(Color(70,70,70,250))
MaxBalloonsLamps:SetText("Max Lamps")
MaxBalloonsLamps:SizeToContents()

local NumSliderMaxLamps = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxLamps:SetPos( 10,230 )
NumSliderMaxLamps:SetSize( 775, 10 ) 
NumSliderMaxLamps:SetText( "" )
NumSliderMaxLamps:SetMin( 0 ) 
NumSliderMaxLamps:SetMax( 500 ) 
NumSliderMaxLamps:SetDecimals( 0 ) 
NumSliderMaxLamps:SetConVar( "sbox_maxlamps" )

local MaxVehiclesText = vgui.Create("DLabel", panel2)
MaxVehiclesText:SetPos(255,260)
MaxVehiclesText:SetColor(Color(70,70,70,250))
MaxVehiclesText:SetText("Max Vehicles")
MaxVehiclesText:SizeToContents()

local NumSliderMaxVehicles = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxVehicles:SetPos( 10,260 )
NumSliderMaxVehicles:SetSize( 775, 10 ) 
NumSliderMaxVehicles:SetText( "" )
NumSliderMaxVehicles:SetMin( 0 ) 
NumSliderMaxVehicles:SetMax( 500 ) 
NumSliderMaxVehicles:SetDecimals( 0 ) 
NumSliderMaxVehicles:SetConVar( "sbox_maxvehicles" )

local NumSliderMaxTLights = vgui.Create("DLabel", panel2)
NumSliderMaxTLights:SetPos(255,290)
NumSliderMaxTLights:SetColor(Color(70,70,70,250))
NumSliderMaxTLights:SetText("Max Lights")
NumSliderMaxTLights:SizeToContents()

local NumSliderMaxLights = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxLights:SetPos( 10,290 )
NumSliderMaxLights:SetSize( 775, 10 ) 
NumSliderMaxLights:SetText( "" )
NumSliderMaxLights:SetMin( 0 ) 
NumSliderMaxLights:SetMax( 500 ) 
NumSliderMaxLights:SetDecimals( 0 ) 
NumSliderMaxLights:SetConVar( "sbox_maxlights" )

local MaxWheelsText = vgui.Create("DLabel", panel2)
MaxWheelsText:SetPos(255,320)
MaxWheelsText:SetColor(Color(70,70,70,250))
MaxWheelsText:SetText("Max Wheels")
MaxWheelsText:SizeToContents()

local NumSliderMaxWheels = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxWheels:SetPos( 10,320 )
NumSliderMaxWheels:SetSize( 775, 10 ) 
NumSliderMaxWheels:SetText( "" )
NumSliderMaxWheels:SetMin( 0 ) 
NumSliderMaxWheels:SetMax( 500 ) 
NumSliderMaxWheels:SetDecimals( 0 ) 
NumSliderMaxWheels:SetConVar( "sbox_maxwheels" )

local MaxHoverballsText = vgui.Create("DLabel", panel2)
MaxHoverballsText:SetPos(255,350)
MaxHoverballsText:SetColor(Color(70,70,70,250))
MaxHoverballsText:SetText("Max Hoverballs")
MaxHoverballsText:SizeToContents()

local NumSliderMaxHoverballs = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxHoverballs:SetPos( 10,350 )
NumSliderMaxHoverballs:SetSize( 775, 10 ) 
NumSliderMaxHoverballs:SetText( "" )
NumSliderMaxHoverballs:SetMin( 0 ) 
NumSliderMaxHoverballs:SetMax( 500 ) 
NumSliderMaxHoverballs:SetDecimals( 0 ) 
NumSliderMaxHoverballs:SetConVar( "sbox_maxhoverballs" )

local MaxButtonsText = vgui.Create("DLabel", panel2)
MaxButtonsText:SetPos(255,380)
MaxButtonsText:SetColor(Color(70,70,70,250))
MaxButtonsText:SetText("Max Buttons")
MaxButtonsText:SizeToContents()

local NumSliderMaxButtons = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxButtons:SetPos( 10,380 )
NumSliderMaxButtons:SetSize( 775, 10 ) 
NumSliderMaxButtons:SetText( "" )
NumSliderMaxButtons:SetMin( 0 ) 
NumSliderMaxButtons:SetMax( 500 ) 
NumSliderMaxButtons:SetDecimals( 0 ) 
NumSliderMaxButtons:SetConVar( "sbox_maxcameras" )

local MaxCamerasText = vgui.Create("DLabel", panel2)
MaxCamerasText:SetPos(255,410)
MaxCamerasText:SetColor(Color(70,70,70,250))
MaxCamerasText:SetText("Max Cameras")
MaxCamerasText:SizeToContents()

local NumSliderMaxCameras = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxCameras:SetPos( 10,410 )
NumSliderMaxCameras:SetSize( 775, 10 ) 
NumSliderMaxCameras:SetText( "" )
NumSliderMaxCameras:SetMin( 0 ) 
NumSliderMaxCameras:SetMax( 500 ) 
NumSliderMaxCameras:SetDecimals( 0 ) 
NumSliderMaxCameras:SetConVar( "sbox_maxcameras" )

local MaxEmittersText = vgui.Create("DLabel", panel2)
MaxEmittersText:SetPos(255,440)
MaxEmittersText:SetColor(Color(70,70,70,250))
MaxEmittersText:SetText("Max Emitters")
MaxEmittersText:SizeToContents()

local NumSliderMaxEmitters = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxEmitters:SetPos( 10,440 )
NumSliderMaxEmitters:SetSize( 775, 10 ) 
NumSliderMaxEmitters:SetText( "" )
NumSliderMaxEmitters:SetMin( 0 ) 
NumSliderMaxEmitters:SetMax( 500 ) 
NumSliderMaxEmitters:SetDecimals( 0 ) 
NumSliderMaxEmitters:SetConVar( "sbox_maxemitters" )

local MaxThrustersText = vgui.Create("DLabel", panel2)
MaxThrustersText:SetPos(255,470)
MaxThrustersText:SetColor(Color(70,70,70,250))
MaxThrustersText:SetText("Max Thrusters")
MaxThrustersText:SizeToContents()

local NumSliderMaxThrusters = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxThrusters:SetPos( 10,470 )
NumSliderMaxThrusters:SetSize( 775, 10 ) 
NumSliderMaxThrusters:SetText( "" )
NumSliderMaxThrusters:SetMin( 0 ) 
NumSliderMaxThrusters:SetMax( 500 ) 
NumSliderMaxThrusters:SetDecimals( 0 ) 
NumSliderMaxThrusters:SetConVar( "sbox_maxthrusters" )

local MaxTextScreensText = vgui.Create("DLabel", panel2)
MaxTextScreensText:SetPos(255,500)
MaxTextScreensText:SetColor(Color(70,70,70,250))
MaxTextScreensText:SetText("Max TextScreen")
MaxTextScreensText:SizeToContents()

local NumSliderMaxTextScreens = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxTextScreens:SetPos( 10,500 )
NumSliderMaxTextScreens:SetSize( 775, 10 ) 
NumSliderMaxTextScreens:SetText( "" )
NumSliderMaxTextScreens:SetMin( 0 ) 
NumSliderMaxTextScreens:SetMax( 500 ) 
NumSliderMaxTextScreens:SetDecimals( 0 ) 
NumSliderMaxTextScreens:SetConVar( "sbox_maxtextscreens" )

local ServerSettingsBackGround = vgui.Create( "DPanel", panel2 )
ServerSettingsBackGround:SetPos( 5, 15 )
ServerSettingsBackGround:SetSize( 235, 655 )
ServerSettingsBackGround.Paint = function() 
    surface.SetDrawColor( 200, 200, 200, 255 ) 
    surface.DrawRect( 0, 0, ServerSettingsBackGround:GetWide(), ServerSettingsBackGround:GetTall() ) -- Draw the rect
	end

local ServerSettings = vgui.Create( "DPanel", panel2 )
ServerSettings:SetPos( 10, 20 )
ServerSettings:SetSize( 225, 645 )
ServerSettings.Paint = function()
    surface.SetDrawColor( 255, 255, 255, 255 ) 
    surface.DrawRect( 0, 0, ServerSettings:GetWide(), ServerSettings:GetTall() ) -- Draw the rect
end

local LimitText = vgui.Create("DLabel", panel2)
LimitText:SetPos(100,20)
LimitText:SetColor(Color(100,100,100,255))
LimitText:SetFont("default")
LimitText:SetText("Settings")
LimitText:SizeToContents()


   local GodModSetting = vgui.Create( "DCheckBoxLabel", panel2 )
    GodModSetting:SetText( "" )
    GodModSetting:SetConVar( "sbox_godmode" )
	GodModSetting:SetPos(25, 50)
    GodModSetting:SizeToContents()
	
local GodModText = vgui.Create("DLabel", panel2)
GodModText:SetPos(45,50)
GodModText:SetColor(Color(70,70,70,250))
GodModText:SetText("Global God Mode")
GodModText:SizeToContents()


   local NoclipSetting = vgui.Create( "DCheckBoxLabel", panel2 )
    NoclipSetting:SetText( "" )
    NoclipSetting:SetConVar( "sbox_noclip" )
	NoclipSetting:SetPos(25, 75)
    NoclipSetting:SizeToContents()
	
local NoclipText = vgui.Create("DLabel", panel2)
NoclipText:SetPos(45,75)
NoclipText:SetColor(Color(70,70,70,250))
NoclipText:SetText("Global Noclip")
NoclipText:SizeToContents()

local CSLuaSetting = vgui.Create( "DCheckBoxLabel", panel2 )
    CSLuaSetting:SetText( "" )
    CSLuaSetting:SetConVar( "sv_allowcslua" )
	CSLuaSetting:SetPos(25, 100)
    CSLuaSetting:SizeToContents()
	
local CSLuaText = vgui.Create("DLabel", panel2)
CSLuaText:SetPos(45,100)
CSLuaText:SetColor(Color(70,70,70,250))
CSLuaText:SetText("Allow Client Side Lua")
CSLuaText:SizeToContents()

local WeaponsSetting = vgui.Create( "DCheckBoxLabel", panel2 )
    WeaponsSetting:SetText( "" )
    WeaponsSetting:SetConVar( "sbox_weapons" )
	WeaponsSetting:SetPos(25, 125)
    WeaponsSetting:SizeToContents()
	
local WeaponsText = vgui.Create("DLabel", panel2)
WeaponsText:SetPos(45,125)
WeaponsText:SetColor(Color(70,70,70,250))
WeaponsText:SetText("HL2 Weapons On Spawn")
WeaponsText:SizeToContents()

local PVPSetting = vgui.Create( "DCheckBoxLabel", panel2 )
    PVPSetting:SetText( "" )
    PVPSetting:SetConVar( "sbox_playershurtplayers" )
	PVPSetting:SetPos(25, 150)
    PVPSetting:SizeToContents()
	
local PVPText = vgui.Create("DLabel", panel2)
PVPText:SetPos(45,150)
PVPText:SetColor(Color(70,70,70,250))
PVPText:SetText("Allow PVP")
PVPText:SizeToContents()


local FallDamageSetting = vgui.Create( "DCheckBoxLabel", panel2 )
    FallDamageSetting:SetText( "" )
    FallDamageSetting:SetConVar( "mp_falldamage" )
	FallDamageSetting:SetPos(25, 175)
    FallDamageSetting:SizeToContents()
	
local FallDamageText = vgui.Create("DLabel", panel2)
FallDamageText:SetPos(45,175)
FallDamageText:SetColor(Color(70,70,70,250))
FallDamageText:SetText("Allow Realistic Fall Damge")
FallDamageText:SizeToContents()

local SpawnMenuGlobalSetting = vgui.Create("DCheckBoxLabel", panel2)
SpawnMenuGlobalSetting:SetText("")
SpawnMenuGlobalSetting:SetPos(25, 200)
SpawnMenuGlobalSetting:SizeToContents()
SpawnMenuGlobalSetting:SetValue(LocalPlayer():GetNWBool("acp_spawnmenu_global_allow", true) and 1 or 0)
SpawnMenuGlobalSetting.OnChange = function(_, value)
	RunConsoleCommand("acp_spawnmenu_global", value and "1" or "0")
end

local SpawnMenuGlobalText = vgui.Create("DLabel", panel2)
SpawnMenuGlobalText:SetPos(45, 200)
SpawnMenuGlobalText:SetColor(Color(70,70,70,250))
SpawnMenuGlobalText:SetText("Allow Spawn Menu (global)")
SpawnMenuGlobalText:SizeToContents()

local ACPGlobalNotificationsSetting = vgui.Create("DCheckBoxLabel", panel2)
ACPGlobalNotificationsSetting:SetText("")
ACPGlobalNotificationsSetting:SetPos(25, 225)
ACPGlobalNotificationsSetting:SizeToContents()
ACPGlobalNotificationsSetting:SetValue(LocalPlayer():GetNWBool("acp_global_notifications_enabled", true) and 1 or 0)
ACPGlobalNotificationsSetting.OnChange = function(_, value)
	RunConsoleCommand("acp_notifications_global", value and "1" or "0")
end

local ACPGlobalNotificationsText = vgui.Create("DLabel", panel2)
ACPGlobalNotificationsText:SetPos(45, 225)
ACPGlobalNotificationsText:SetColor(Color(70,70,70,250))
ACPGlobalNotificationsText:SetText("Enable ACP Global Notification")
ACPGlobalNotificationsText:SizeToContents()

local ACPAdminsPhysgunFreezePlayersSetting = vgui.Create("DCheckBoxLabel", panel2)
ACPAdminsPhysgunFreezePlayersSetting:SetText("")
ACPAdminsPhysgunFreezePlayersSetting:SetPos(25, 250)
ACPAdminsPhysgunFreezePlayersSetting:SizeToContents()
ACPAdminsPhysgunFreezePlayersSetting:SetValue(LocalPlayer():GetNWBool("acp_allow_admins_physgun_freeze_players", true) and 1 or 0)
ACPAdminsPhysgunFreezePlayersSetting.OnChange = function(_, value)
	RunConsoleCommand("acp_physgunfreeze_admins", value and "1" or "0")
end

local ACPAdminsPhysgunFreezePlayersText = vgui.Create("DLabel", panel2)
ACPAdminsPhysgunFreezePlayersText:SetPos(45, 250)
ACPAdminsPhysgunFreezePlayersText:SetColor(Color(70,70,70,250))
ACPAdminsPhysgunFreezePlayersText:SetText("Allow Admins Physgun Freeze Players")
ACPAdminsPhysgunFreezePlayersText:SizeToContents()

local GravityText = vgui.Create("DLabel", panel2)
GravityText:SetPos(15,640)
GravityText:SetColor(Color(70,70,70,250))
GravityText:SetText("Gravity")
GravityText:SizeToContents()

local NumSliderMaxGravity = vgui.Create( "DNumSlider", panel2 )
NumSliderMaxGravity:SetPos( -95,640 )
NumSliderMaxGravity:SetSize( 350, 10 ) 
NumSliderMaxGravity:SetText( "" )
NumSliderMaxGravity:SetMin( 0 ) 
NumSliderMaxGravity:SetMax( 600 ) 
NumSliderMaxGravity:SetDecimals( 0 ) 
NumSliderMaxGravity:SetConVar( "sv_gravity" )

local NoclipText = vgui.Create("DLabel", panel2)
NoclipText:SetPos(15,615)
NoclipText:SetColor(Color(70,70,70,250))
NoclipText:SetText("Noclip Speed")
NoclipText:SizeToContents()

local NumSliderMoclip = vgui.Create( "DNumSlider", panel2 )
NumSliderMoclip:SetPos( -50,615 )
NumSliderMoclip:SetSize( 300, 10 ) 
NumSliderMoclip:SetText( "" )
NumSliderMoclip:SetMin( 0 ) 
NumSliderMoclip:SetMax( 5 ) 
NumSliderMoclip:SetDecimals( 0 ) 
NumSliderMoclip:SetConVar( "sv_noclipspeed" )

local UnbanGround = vgui.Create( "DPanel", panel2 )
UnbanGround:SetPos( 245, 550 )
UnbanGround:SetSize( 525, 120 )
UnbanGround.Paint = function() 
    surface.SetDrawColor( 200, 200, 200, 255 ) 
    surface.DrawRect( 0, 0, UnbanGround:GetWide(), UnbanGround:GetTall() ) -- Draw the rect
	end

local unbanpanel = vgui.Create( "DPanel", panel2 )
unbanpanel:SetPos( 250, 555 )
unbanpanel:SetSize( 515, 110 )
unbanpanel.Paint = function()
    surface.SetDrawColor( 255, 255, 255, 255 ) 
    surface.DrawRect( 0, 0, unbanpanel:GetWide(), unbanpanel:GetTall() ) -- Draw the rect
end


local UnbanText = vgui.Create("DLabel", panel2)
UnbanText:SetPos(500,560)
UnbanText:SetColor(Color(100,100,100,255))
UnbanText:SetFont("default")
UnbanText:SetText("UnBan")
UnbanText:SizeToContents()

local UnBanButton = vgui.Create( "DButton", panel2 )
UnBanButton:SetText( "UnBan" )
UnBanButton:SetPos( 258, 589 )
UnBanButton:SetSize( 500, 33 )
UnBanButton.DoClick = function ()
RunConsoleCommand("acp_unban", UnBanID:GetValue())
end

UnBanID = vgui.Create( "DTextEntry", panel2 )
UnBanID:SetPos( 315,625 )
UnBanID:SetTall( 20 )
UnBanID:SetWide( 443 )
UnBanID:SetNumeric(false)

local UnBanIDText = vgui.Create("DLabel", panel2)
UnBanIDText:SetText("UserID:")
UnBanIDText:SetPos(265, 625)
UnBanIDText:SetTextColor(Color(0,0,0))

end

net.Receive("acp_open", function()
	local senderPos = net.ReadVector()
	local sender = net.ReadEntity()

	ACP(sender)

end)

hook.Add("SpawnMenuOpen", "ACP_BlockSpawnMenu", function()
	if not LocalPlayer():GetNWBool("acp_spawnmenu_global_allow", true) then
		return false
	end

	if not LocalPlayer():GetNWBool("acp_spawnmenu_personal_allow", true) then
		return false
	end
end)
