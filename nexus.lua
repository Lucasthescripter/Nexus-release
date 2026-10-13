--[[
╔══════════════════════════════════════════════════════╗
║  NEXUS ADMIN  ·  NX Panel v1.0                      ║
║  Execute via Delta, Solara, or any Level 7 executor  ║
║  Toggle Panel : RightShift                          ║
║  Command Prefix: ! or /                             ║
╚══════════════════════════════════════════════════════╝
--]]

-- ─── SERVICES ────────────────────────────────────────────────────────────────
local Plrs   = game:GetService("Players")
local TweenS = game:GetService("TweenService")
local UIS    = game:GetService("UserInputService")
local RS     = game:GetService("RunService")
local LP     = Plrs.LocalPlayer

-- ─── THEME ───────────────────────────────────────────────────────────────────
local C = {
    bg0=Color3.fromRGB(8,8,8),   bg1=Color3.fromRGB(14,14,14),
    bg2=Color3.fromRGB(20,20,20),bg3=Color3.fromRGB(28,28,28),
    bg4=Color3.fromRGB(38,38,38),t0=Color3.fromRGB(255,255,255),
    t1=Color3.fromRGB(150,150,150),t2=Color3.fromRGB(68,68,68),
    grn=Color3.fromRGB(34,197,94), red=Color3.fromRGB(239,68,68),
    blu=Color3.fromRGB(59,130,246),brd=Color3.fromRGB(34,34,34),
}

-- ─── FORWARD DECLARES ────────────────────────────────────────────────────────
local CmdInput
local loopFlingLbl, loopFlingBtn
local headsitLbl,   headsitBtn
local toast

-- ─── STATE ───────────────────────────────────────────────────────────────────
local S = { tab="Players", sel=nil, entries={}, notes={} }
local ADMINS = {}

local flyActive,    flyConn,    flyBV,    flyBG       = false,nil,nil,nil
local noclipActive, noclipConn                        = false,nil
local espActive,    espHL,      espAddConn            = false,{},nil
local godActive,    godConn                           = false,nil
local loopFlingTgt, loopFlingConn                     = nil,nil
local headsitActive,headsitConn,headsitTgt            = false,nil,nil
local headstandActive,headstandConn,headstandTgt      = false,nil,nil
local followConn    = nil
local infjumpConn   = nil
local antiafkConn   = nil
local orbitConn     = nil
local glueConn      = nil
local loopjumpConn  = nil
local auraConn      = nil
local cbringConn    = nil
local freecamActive = false
local freecamConn   = nil

-- ─── CMDS TABLE (NX Edition — from NX command registry) ───────────────────────
local CMDS = {
    -- Movement
    {n="ws",                     d="Set your WalkSpeed"},
    {n="jp",                     d="Set your JumpPower"},
    {n="speed",                  d="Set your WalkSpeed (alias for ws)"},
    {n="loopwalkspeed",          d="Loop walkspeed"},
    {n="unloopwalkspeed",        d="Disable loop walkspeed"},
    {n="loopjumppower",          d="Loop JumpPower"},
    {n="unloopjumppower",        d="Disable loop jump power"},
    {n="bypassspeed",            d="Set WalkSpeed (bypass variant)"},
    {n="loopbypassspeed",        d="Loop WalkSpeed (bypass variant)"},
    {n="unloopbypassspeed",      d="Disable loop WalkSpeed (bypass variant)"},
    {n="height",                 d="Change your hip height"},
    {n="maxslopeangle",          d="Change your character's MaxSlopeAngle"},
    {n="tpwalk",                 d="More undetectable walkspeed script"},
    {n="untpwalk",               d="Stops the tpwalk command"},
    {n="offsetwalk",             d="Move character by teleporting set studs per frame"},
    {n="unoffsetwalk",           d="Stops Offset Walk"},
    -- Fly
    {n="fly",                    d="Enable flight"},
    {n="unfly",                  d="Disable flight"},
    {n="cframefly",              d="Enable CFrame-based flight with respawn-safe cleanup"},
    {n="uncframefly",            d="Disable CFrame-based flight"},
    {n="tfly",                   d="Enable smooth flying"},
    {n="untfly",                 d="Disable tween flying"},
    {n="tpfly",                  d="Enable TranslateBy-based flight"},
    {n="untpfly",                d="Disable TranslateBy-based flight"},
    {n="vfly",                   d="Fly vehicles"},
    {n="unvfly",                 d="Disable vehicle fly"},
    {n="flyfling",               d="Makes you fly and fling"},
    {n="unflyfling",             d="Stops fly and fling"},
    {n="flyjump",                d="Hold space to fly up"},
    {n="unflyjump",              d="Disable flyjump"},
    -- Noclip / Collision
    {n="noclip",                 d="Disable your player's collision"},
    {n="clip",                   d="Enable your player's collision"},
    {n="antianchor",             d="Prevent your parts from being anchored"},
    {n="unantianchor",           d="Allow your parts to be anchored"},
    {n="vehiclenoclip",          d="Disable vehicle collision"},
    {n="vehicleclip",            d="Enable vehicle collision"},
    -- Teleport
    {n="goto",                   d="Teleport to a player, NPC, or X,Y,Z coordinates"},
    {n="tpup",                   d="Teleport up by given studs"},
    {n="tpdown",                 d="Teleport down by given studs"},
    {n="tweento",                d="Teleport method that bypasses some anticheats"},
    {n="bring",                  d="Bring a player to your position (client)"},
    {n="cbring",                 d="Bring a player or NPC once on your client"},
    {n="loopcbring",             d="Continuously bring a player or NPC on your client"},
    {n="unloopcbring",           d="Disable looped client bring"},
    {n="torandom",               d="Teleport to a random player"},
    {n="gotocampos",             d="Teleport to your camera position"},
    {n="tweengotocampos",        d="Another version of goto camera position bypassing more anticheats"},
    {n="gotopart",               d="Teleport to a part by name"},
    {n="gotomodel",              d="Teleport to a model"},
    {n="gotofolder",             d="Teleport to a folder"},
    {n="tospawn",                d="Teleport to a SpawnLocation"},
    {n="setspawn",               d="Set your spawn point to your current position"},
    {n="disablespawn",           d="Disable the previously set spawn point"},
    {n="rejoin",                 d="Rejoin the game"},
    {n="rjre",                   d="Rejoin and teleport to your previous position"},
    {n="teleporttoplace",        d="Teleport to a place using PlaceId"},
    {n="cancelteleport",         d="Cancel an in-progress teleport"},
    {n="cancelteleportloop",     d="Repeatedly cancel in-progress teleports"},
    {n="uncancelteleportloop",   d="Disable cancelteleport loop"},
    -- Jump
    {n="jump",                   d="Jump"},
    {n="loopjump",               d="Continuously jump (bhop)"},
    {n="unloopjump",             d="Stop continuous jumping"},
    {n="infjump",                d="Enable infinite jumping"},
    {n="uninfjump",              d="Disable infinite jumping"},
    {n="jumpboost",              d="Add extra jump velocity without changing JumpPower"},
    {n="unjumpboost",            d="Disable extra jump boost"},
    {n="trussjump",              d="Boost off trusses when you jump"},
    {n="untrussjump",            d="Disable trussjump"},
    {n="edgejump",               d="Auto jump when you get to the edge of an object"},
    {n="unedgejump",             d="Disable edgejump"},
    -- Fling
    {n="fling",                  d="Fling the given player or NPC"},
    {n="loopfling",              d="Continuously fling a player or NPC"},
    {n="unloopfling",            d="Stop loop flinging a player"},
    {n="verticalfling",          d="Fling a player or NPC vertically"},
    {n="horizontalfling",        d="Fling a player or NPC horizontally"},
    {n="loopverticalfling",      d="Continuously vertical-fling a player or NPC"},
    {n="loophorizontalfling",    d="Continuously horizontal-fling a player or NPC"},
    {n="walkfling",              d="Probably the best fling"},
    {n="unwalkfling",            d="Stop the walkfling command"},
    {n="touchfling",             d="Walkfling only when touching a player or NPC"},
    {n="untouchfling",           d="Stop the touchfling command"},
    {n="clickfling",             d="Fling a player by clicking them"},
    {n="unclickfling",           d="Disable clickfling"},
    {n="invisfling",             d="Enable invisible fling"},
    {n="flyfling",               d="Makes you fly and fling"},
    -- Combat / Aura
    {n="aura",                   d="Continuously damage all nearby humanoid targets with equipped tool"},
    {n="unaura",                 d="Stop aura loop and remove visualizer"},
    {n="npcaura",                d="Continuously damage nearby NPCs with equipped tool"},
    {n="unnpcaura",              d="Stop NPC aura loop and remove visualizer"},
    {n="reach",                  d="Extend sword reach in one direction"},
    {n="boxreach",               d="Create a box-shaped hitbox around your tool"},
    {n="resetreach",             d="Reset tool to normal size"},
    {n="handlekill",             d="Kill a player or NPC using a tool that deals damage on touch"},
    {n="swordfighter",           d="Activate a sword fighting bot for automated PvP combat"},
    {n="triggerbot",             d="Auto click when the mouse is on a player"},
    {n="aimbot",                 d="Aimbot GUI"},
    -- Headsit / Attach
    {n="headsit",                d="Sit on a player or NPC's head"},
    {n="unheadsit",              d="Stop the headsit command"},
    {n="headstand",              d="Stand on a player or NPC's head"},
    {n="unheadstand",            d="Stop the headstand command"},
    {n="piggyback",              d="Attach to a player's back while sitting"},
    {n="unpiggyback",            d="Stop piggybacking a player"},
    {n="bang",                   d="Attach to a player"},
    {n="unbang",                 d="Detach from the player"},
    {n="carpet",                 d="Be someone's carpet"},
    {n="uncarpet",               d="Undo carpet"},
    {n="hug",                    d="Hug time (click on a target to hug)"},
    {n="unhug",                  d="No huggies"},
    -- Follow / Orbit / Glue
    {n="follow",                 d="Follow a player or NPC wherever they go"},
    {n="unfollow",               d="Stop all attempts to follow a player"},
    {n="autofollow",             d="Automatically follow any player who comes close"},
    {n="unautofollow",           d="Stop automatically following nearby players"},
    {n="pathfind",               d="Follow a player or NPC using the pathfinder API"},
    {n="orbit",                  d="Orbit around a player or NPC"},
    {n="uporbit",                d="Orbit around a player or NPC on the Y axis"},
    {n="unorbit",                d="Stop orbiting"},
    {n="glue",                   d="Loop teleport to a player or NPC"},
    {n="unglue",                 d="Stop teleporting to a player or NPC"},
    {n="glueback",               d="Loop teleport behind a player"},
    {n="unglueback",             d="Stop teleporting behind a player"},
    {n="annoy",                  d="Annoy the given player or NPC"},
    {n="unannoy",                d="Stop the annoy command"},
    {n="spook",                  d="Teleport next to a player for a few seconds"},
    {n="loopspook",              d="Teleport next to a player repeatedly"},
    {n="unloopspook",            d="Stop the loopspook command"},
    {n="clickscare",             d="Teleport next to a clicked player for a few seconds"},
    -- Spectate / Watch
    {n="watch",                  d="Spectate a player"},
    {n="unwatch",                d="Stop spectating"},
    -- Freeze / Anchor
    {n="freeze",                 d="Freeze your character"},
    {n="unfreeze",               d="Unfreeze your character"},
    {n="sit",                    d="Sit your player"},
    {n="antisit",                d="Prevent the player from sitting"},
    {n="unantisit",              d="Allow the player to sit again"},
    {n="lay",                    d="Lay down"},
    {n="trip",                   d="Trip your character"},
    {n="permtrip",               d="Permanent trip that keeps you down"},
    {n="unpermtrip",             d="Disable permanent trip"},
    {n="antitrip",               d="Prevent tripping/ragdolling"},
    {n="unantitrip",             d="Allow tripping again"},
    {n="disablehumanoidstate",   d="Open a picker to disable one humanoid state"},
    {n="enablehumanoidstate",    d="Restore one humanoid state or all disabled states"},
    {n="airwalk",                d="Press space to go up"},
    {n="unairwalk",              d="Stop the airwalk command"},
    {n="airmomentum",            d="Override in-air horizontal movement"},
    {n="unairmomentum",          d="Stop the custom air momentum command"},
    {n="wallwalk",               d="Walk on walls"},
    -- God / Health
    {n="godmode",                d="Pick and enable an invincibility method"},
    {n="ungodmode",              d="Disable invincibility"},
    {n="kill",                   d="Set your health to 0"},
    {n="reset",                  d="Set your health to 0 (alias)"},
    {n="respawn",                d="Respawn your character"},
    {n="nofall",                 d="Prevent fall damage by slowing falls (BETA)"},
    {n="unnofall",               d="Disable nofall"},
    {n="antivoid",               d="Prevent falling into the void"},
    {n="unantivoid",             d="Disable antivoid"},
    {n="antivoid2",              d="Set FallenPartsDestroyHeight to -inf"},
    {n="unantivoid2",            d="Revert FallenPartsDestroyHeight"},
    {n="antivelocity",           d="Limit your character's velocity"},
    {n="unantivelocity",         d="Disable the antivelocity limiter"},
    {n="antiknockback",          d="Disable knockback"},
    {n="unantiknockback",        d="Disable antiknockback"},
    {n="antibreakjoints",        d="Prevent local character joints from breaking"},
    {n="unantibreakjoints",      d="Disable AntiBreakJoints"},
    {n="breakjoints",            d="Break your character joints and die"},
    {n="split",                  d="Destroy waist joint"},
    {n="deletevelocity",         d="Remove velocity/force instances from your character"},
    {n="strengthen",             d="Make your character more dense"},
    {n="weaken",                 d="Make your character less dense"},
    {n="unweaken",               d="Set your character's CustomPhysicalProperties to default"},
    {n="setmass",                d="Set your character mass"},
    -- Invisibility
    {n="invisible",              d="Set invisibility"},
    {n="visible",                d="Turn visible"},
    {n="toolinvisible",          d="Be invisible while still able to use tools"},
    {n="invisbind",              d="Set a custom keybind for the Invisible command"},
    -- Character appearance
    {n="naked",                  d="Remove clothing from your character"},
    {n="hideacc",                d="Hide or restore local accessory parts"},
    {n="nohats",                 d="Drop all of your hats"},
    {n="hatresize",              d="Make your hats very big (R15 only)"},
    {n="char",                   d="Transform your client character to a user's avatar appearance"},
    {n="unchar",                 d="Restore your appearance"},
    {n="r6",                     d="Switch your character rig type to R6"},
    {n="r15",                    d="Switch your character rig type to R15"},
    {n="bodytransparency",       d="Set LocalTransparencyModifier on selected body parts (0-1)"},
    {n="unbodytransparency",     d="Stop transparency loop"},
    {n="material",               d="Set every BasePart in your character to a selected material"},
    {n="unmaterial",             d="Restore character materials"},
    {n="boobs",                  d="Boobs"},
    {n="unboobs",                d="Remove boobs"},
    {n="ass",                    d="Ass"},
    {n="unass",                  d="Remove ass"},
    {n="penis",                  d="Penis"},
    {n="unpenis",                d="Remove penis"},
    -- Animation
    {n="runanim",                d="Play an animation by ID with optional speed multiplier"},
    {n="animbuilder",            d="Open animation builder GUI"},
    {n="setkiller",              d="Set killer animation set"},
    {n="setpsycho",              d="Set psycho animation set"},
    {n="resetanims",             d="Restore your previous animations"},
    {n="animcopycore",           d="Copy core animations from a player or NPC"},
    {n="syncanim",               d="Mirror player or NPC animations (live)"},
    {n="syncstop",               d="Stop live sync and restore defaults"},
    {n="mimic",                  d="Clone player or NPC movement with optional delay"},
    {n="mstop",                  d="Stop mimic and restore defaults"},
    {n="dance",                  d="Do a random dance"},
    {n="undance",                d="Stop the dance command"},
    {n="animspoofer",            d="Load an animation spoofer for rbxassetid animations"},
    {n="animationspeed",         d="Adjust the speed of currently playing animations"},
    {n="unanimationspeed",       d="Stop the animation speed adjustment loop"},
    {n="oganims",                d="Old animations from 2007"},
    {n="stopanimations",         d="Stop running animations"},
    {n="refreshanimations",      d="Reload character animations"},
    {n="disableanimations",      d="Freeze your animations"},
    {n="undisableanimations",    d="Unfreeze your animations"},
    {n="seizure",                d="Gives you a seizure"},
    {n="unseizure",              d="Stop the seizure"},
    {n="spin",                   d="Spin your character"},
    {n="unspin",                 d="Stop spinning your character"},
    {n="somersault",             d="Makes you do a clean front flip"},
    {n="unsomersault",           d="Disable somersault button and keybind"},
    {n="suslay",                 d="Lay down in a suspicious way"},
    {n="unsuslay",               d="Stand up from the sussy lay"},
    {n="jerk",                   d="Jorking it"},
    -- ESP / Visual
    {n="esp",                    d="Locate where players are"},
    {n="espall",                 d="ESP all players and clear team filtering"},
    {n="espenemies",             d="ESP players outside your team"},
    {n="espallies",              d="ESP players on your current team"},
    {n="espteam",                d="ESP players in a specific team"},
    {n="chams",                  d="ESP but without the text"},
    {n="chamsenemies",           d="Chams players outside your team"},
    {n="chamsallies",            d="Chams players on your current team"},
    {n="chamsteam",              d="Chams players in a specific team"},
    {n="unesp",                  d="Disables ESP/Chams"},
    {n="locate",                 d="Locate specific players or NPCs"},
    {n="unlocate",               d="Stop locating a player or NPC"},
    {n="npcesp",                 d="Locate NPCs with highlights and labels"},
    {n="npcchams",               d="Highlight NPCs without labels"},
    {n="unnpcesp",               d="Disable NPC ESP or Chams"},
    {n="xray",                   d="Enable X-ray vision to see through walls"},
    {n="unxray",                 d="Disable X-ray vision"},
    {n="fullbright",             d="Make dark games bright without destroying effects"},
    {n="loopfullbright",         d="Loop fullbright"},
    {n="unloopfullbright",       d="Stop looping fullbright"},
    {n="hitboxes",               d="Show all hitboxes"},
    {n="unhitboxes",             d="Remove the hitboxes outline"},
    {n="hitbox",                 d="Resize a selected body part or All"},
    {n="unhitbox",               d="Restore hitbox size"},
    {n="hovername",              d="Show player's username on hover"},
    {n="unhovername",            d="Disable hovername"},
    {n="hoverinventory",         d="Show a player's inventory on hover"},
    {n="unhoverinventory",       d="Disable hoverinventory"},
    -- Camera
    {n="freecam",                d="Enable free camera"},
    {n="freecamgoto",            d="Start or move freecam to a player or NPC"},
    {n="freecamgotopart",        d="Start or move freecam to an exact part name"},
    {n="unfreecam",              d="Disable free camera"},
    {n="firstp",                 d="Go into first person mode"},
    {n="thirdp",                 d="Go into third person mode"},
    {n="maxzoom",                d="Set your maximum camera distance"},
    {n="minzoom",                d="Set your minimum camera distance"},
    {n="loopmaxzoom",            d="Loop your maximum camera distance"},
    {n="unloopmaxzoom",          d="Stop looping maximum camera distance"},
    {n="loopminzoom",            d="Loop your minimum camera distance"},
    {n="unloopminzoom",          d="Stop looping minimum camera distance"},
    {n="cameranoclip",           d="Make your camera clip through walls"},
    {n="uncameranoclip",         d="Restore normal camera"},
    {n="fov",                    d="Set your FOV (1-300)"},
    {n="loopfov",                d="Lock your FOV target"},
    {n="unloopfov",              d="Stop FOV loop"},
    {n="backview",               d="Flip the camera behind you"},
    {n="worldmodelfp",           d="WFCP world-model first person camera"},
    {n="frontview",              d="Reset WFCP camera state"},
    {n="fixcam",                 d="Fix your camera"},
    -- Environment
    {n="day",                    d="Make it day"},
    {n="night",                  d="Make it night"},
    {n="time",                   d="Set the time"},
    {n="gravity",                d="Set game gravity"},
    {n="nofog",                  d="Remove all fog from the game"},
    {n="loopnofog",              d="Remove fog continuously"},
    {n="unloopnofog",            d="Stop removing fog"},
    {n="loopday",                d="Loop daytime"},
    {n="unloopday",              d="Stop looping daytime"},
    {n="loopnight",              d="Loop nighttime"},
    {n="unloopnight",            d="Stop looping nighttime"},
    {n="brightness",             d="Change the brightness lighting property"},
    {n="loopbrightness",         d="Lock the brightness lighting property"},
    {n="unloopbrightness",       d="Stop locking brightness"},
    {n="globalshadows",          d="Enable global shadows"},
    {n="unglobalshadows",        d="Disable global shadows"},
    {n="gamma",                  d="Gamma vision"},
    {n="loopgamma",              d="Loop gamma vision"},
    {n="unloopgamma",            d="Stop gamma vision"},
    {n="nightmare",              d="Make it dark and spooky"},
    {n="unnightmare",            d="Disable nightmare mode"},
    {n="noeffect",               d="Disable Lighting and CurrentCamera effects"},
    {n="loopnoeffect",           d="Keep Lighting and CurrentCamera effects disabled"},
    {n="unloopnoeffect",         d="Restore Lighting and CurrentCamera effects"},
    {n="shaders",                d="Enable a shader preset for Lighting"},
    {n="unshaders",              d="Disable the shader preset and restore Lighting"},
    -- Performance
    {n="quality",                d="Manage rendering quality settings (1-21)"},
    {n="norender",               d="Disable 3D rendering to decrease CPU usage"},
    {n="render",                 d="Enable 3D rendering"},
    {n="fpscap",                 d="Set the FPS cap"},
    {n="fpsbooster",             d="Toggle low graphics using your FPSBooster settings"},
    {n="noreset",                d="Disable reset button"},
    {n="resetbtn",               d="Enable reset button"},
    -- Chat
    {n="chat",                   d="Chat for you, useful if you're muted"},
    {n="uwuify",                 d="Stylize and send chat text"},
    {n="autouwuify",             d="Stylize chat input before sending"},
    {n="unautouwuify",           d="Stop chat input styling"},
    {n="privatemessage",         d="Send a private message to a player"},
    {n="mimicchat",              d="Mimic the chat of a player"},
    {n="stopmimicchat",          d="Stop mimicking a player"},
    {n="chattranslate",          d="Chat translator"},
    {n="chatlogs",               d="Open the chat logs"},
    {n="bubblechat",             d="Enable BubbleChat"},
    {n="unbubblechat",           d="Disable BubbleChat"},
    -- Admin / Social
    {n="admin",                  d="Whitelist a user to use NX commands on you"},
    {n="unadmin",                d="Remove someone from admin"},
    {n="friend",                 d="Send a friend request to your target"},
    {n="unfriend",               d="Prompt to unfriend your target"},
    {n="block",                  d="Open block/unblock prompt for target player"},
    {n="invitefriends",          d="Open Roblox's client invite prompt"},
    -- Anti-cheat / Protection
    {n="antikick",               d="Bypass kick on most games"},
    {n="unantikick",             d="Disable Anti-Kick protection"},
    {n="antiteleport",           d="Prevent TeleportService from moving you"},
    {n="unantiteleport",         d="Disable Anti-Teleport protection"},
    {n="anticframeteleport",     d="Prevent client teleports"},
    {n="unanticframeteleport",   d="Disable Anti CFrame Teleport"},
    {n="antinil",                d="Prevent your character from being parented to nil"},
    {n="unantinil",              d="Stop preventing your character from nil"},
    {n="nilchar",                d="Parent your character to nil"},
    {n="unnilchar",              d="Restore your nil-parented character"},
    {n="adonisbypass",           d="Bypass Adonis admin detection"},
    {n="antiafk",                d="Prevent being kicked for being AFK"},
    {n="unantiafk",              d="Allow being kicked for being AFK"},
    {n="antifling",              d="Make other players non-collidable with you"},
    {n="unantifling",            d="Restore collision for other players"},
    {n="antiflingparts",         d="Disable collision on nearby unanchored parts above velocity threshold"},
    {n="unantiflingparts",       d="Restore collision for unanchored parts"},
    {n="desync",                 d="Toggle offset desync/sync"},
    {n="undesync",               d="Disable offset desync"},
    {n="raknetdesync",           d="Enable RakNet desync"},
    {n="unraknetdesync",         d="Disable RakNet desync"},
    {n="netless",                d="Execute netless to make scripts more stable"},
    {n="netbypass",              d="Net bypass"},
    {n="netclaim",               d="Try to acquire network ownership of parts"},
    {n="unnetclaim",             d="Stop network ownership attempts"},
    -- Tools
    {n="copytools",              d="Copy the tools the given player has"},
    {n="grabtools",              d="Grab dropped tools"},
    {n="loopgrabtools",          d="Loop grab dropped tools"},
    {n="unloopgrabtools",        d="Stop the loop grab command"},
    {n="droptool",               d="Drop one of your tools"},
    {n="droptools",              d="Drop all of your tools"},
    {n="notools",                d="Remove your tools"},
    {n="equiptools",             d="Equip all of your tools"},
    {n="unequiptools",           d="Unequip every tool you are currently holding"},
    {n="equiptool",              d="Equip a specific tool by name or selection"},
    {n="loopequiptool",          d="Keep a specific tool equipped until disabled"},
    {n="unloopequiptool",        d="Stop the loop equip behaviour"},
    {n="multitool",              d="Allow stacking equipped tools"},
    {n="unmultitool",            d="Disable multitool mode"},
    {n="savetools",              d="Save your tools to memory"},
    {n="loadtools",              d="Restore your saved tools to your backpack"},
    {n="preventtools",           d="Prevent any item from being equipped"},
    {n="unpreventtools",         d="Allow items to be equipped again"},
    {n="gear",                   d="Give gear by ID (client-sided)"},
    {n="telekinesis",            d="Tool that controls unanchored parts"},
    {n="gravitygun",             d="The best gravity gun script"},
    -- Remote / Click
    {n="fireremote",             d="Fire one remote by selection, name, or full path"},
    {n="fireremotes",            d="Fire every remote with arguments"},
    {n="blockremote",            d="Block matching remotes"},
    {n="unblockremote",          d="Restore a blocked remote or unblock all"},
    {n="fireclickdetectors",     d="Fire every ClickDetector in Workspace"},
    {n="fireproximityprompts",   d="Fire every ProximityPrompt in Workspace"},
    {n="firetouchinterests",     d="Fire every TouchInterest in Workspace"},
    {n="noclickdetectorlimits",  d="Set all ClickDetectors MaxActivationDistance to math.huge"},
    {n="noproximitypromptlimits",d="Set all ProximityPrompts MaxActivationDistance to math.huge"},
    {n="instantproximityprompts",d="Set proximity prompt HoldDuration values to 0"},
    {n="fastprompts",            d="Make proximity prompts use a speed multiplier (default 2x)"},
    {n="promptwalls",            d="Allow proximity prompts to be used through walls"},
    {n="autofireproxi",          d="Auto-fire ProximityPrompts every interval"},
    {n="autofireclick",          d="Auto-fire ClickDetectors every interval"},
    {n="autotouch",              d="Auto-fire TouchInterests every interval"},
    {n="autofireremote",         d="Auto-fire remotes every interval"},
    -- NPC
    {n="flingnpcs",              d="Fling NPCs"},
    {n="killnpcs",               d="Kill NPCs"},
    {n="sitnpcs",                d="Make NPCs sit"},
    {n="unsitnpcs",              d="Make NPCs unsit"},
    {n="npcfollow",              d="Make NPCs follow you"},
    {n="loopnpcfollow",          d="Make NPCs follow you in a loop"},
    {n="unloopnpcfollow",        d="Stop NPCs following you in a loop"},
    {n="bringnpcs",              d="Bring NPCs"},
    {n="loopbringnpcs",          d="Loop NPC bringing"},
    {n="unloopbringnpcs",        d="Stop NPC bring loop"},
    {n="voidnpcs",               d="Teleport NPCs to void"},
    {n="gotonpcs",               d="Teleport to each NPC"},
    {n="npcwalkspeed",           d="Set all NPC WalkSpeed"},
    {n="npcjumppower",           d="Set all NPC JumpPower"},
    {n="actnpc",                 d="Start acting like an NPC"},
    {n="unactnpc",               d="Stop acting like an NPC"},
    -- Info / Stats
    {n="ping",                   d="Show your network latency"},
    {n="fps",                    d="Show your frames per second"},
    {n="fpsping",                d="Show the legacy FPS and ping panel"},
    {n="stats",                  d="Show FPS, physics, network and memory stats"},
    {n="speedometer",            d="Toggle a NX-themed speedometer"},
    {n="memory",                 d="Show your current memory usage"},
    {n="gameinfo",               d="Show info about the game you're playing"},
    {n="uptime",                 d="Show how long the game/session has been running"},
    {n="timestamp",              d="Show current Unix timestamp"},
    {n="placeid",                d="Copy the PlaceId of the game you're in"},
    {n="gameid",                 d="Copy the GameId/Universe Id"},
    {n="placename",              d="Copy the game's place name"},
    {n="jobid",                  d="Copy your job ID"},
    {n="joinjobid",              d="Join the job ID you enter"},
    {n="accountage",             d="Show the account age of a player in the server"},
    {n="copyid",                 d="Copy the UserId of the target"},
    {n="copyname",               d="Copy the username of the target"},
    {n="copydisplay",            d="Copy the display name of the target"},
    {n="copyposition",           d="Get the position of a player or NPC"},
    {n="getidfromusername",      d="Copy a user's UserId by Username"},
    {n="getuserfromid",          d="Copy a user's Username by ID"},
    {n="ownerid",                d="Mask yourself as the game owner's ID and Username"},
    {n="userid",                 d="Change your UserId to any ID you enter"},
    {n="username",               d="Change your Username to any name you enter"},
    -- Serverhop
    {n="serverhop",              d="Serverhop to another server"},
    {n="smallserverhop",         d="Serverhop to a small server"},
    {n="pingserverhop",          d="Serverhop by ping or RoValra estimated latency"},
    {n="oldserverhop",           d="Serverhop to one of the oldest active servers"},
    {n="newserverhop",           d="Serverhop to one of the newest active servers"},
    {n="versionhop",             d="Serverhop to a server running a specific place version"},
    {n="regionhop",              d="Serverhop to a public server in a requested RoValra region"},
    {n="autorejoin",             d="Rejoin the server if you get kicked/disconnected"},
    {n="unautorejoin",           d="Disable auto rejoin command"},
    -- Executor / Scripting
    {n="executor",               d="Toggle the integrated executor UI"},
    {n="loadstring",             d="Run code using loadstring"},
    {n="url",                    d="Run a script using a URL"},
    {n="scriptload",             d="Run a saved script from the NX executor saved scripts folder"},
    {n="scripthub",              d="Open the built-in Script Hub"},
    {n="dex",                    d="Dex explorer"},
    {n="olddex",                 d="Old Dex explorer"},
    {n="hydroxide",              d="Execute Hydroxide"},
    {n="remotespy",              d="Execute SimpleSpy (PC and mobile)"},
    {n="cobaltspy",              d="Execute CobaltSpy"},
    {n="turtlespy",              d="Execute Turtle Spy"},
    {n="serverremotespy",        d="Log all remotes called from the server"},
    {n="imagescanner",           d="Show a UI that grabs all images in the game"},
    {n="audiologger",            d="Show a UI that grabs all audios in the game"},
    {n="decompiler",             d="Decompile LocalScript/ModuleScript bytecode"},
    {n="moduleeditor",           d="Load the module editor UI"},
    {n="upvalueeditor",          d="Load the upvalue editor UI"},
    {n="console",                d="Open developer console"},
    {n="gcsearch",               d="Search getgc tables, function metadata, constants for text"},
    {n="saveinstance",           d="Save the game with SaveInstance"},
    {n="functionspy",            d="Check console for function spy output"},
    {n="httpspy",                d="HTTP Spy"},
    {n="unctest",                d="Test how many functions your executor supports"},
    {n="vulnerabilitytest",      d="Test if your executor is vulnerable"},
    -- NX System
    {n="unload",                 d="Unload Nexus Admin and clean up its active runtime"},
    {n="pluginmaker",            d="Open the no-code .nx/.iy plugin builder"},
    {n="addallplugins",          d="Move all .nx/.iy plugins to Nexus-Admin folders, then load them"},
    {n="addplugin",              d="Move one .nx to Plugins or one .iy to PluginsIY, then load it"},
    {n="reloadplugin",           d="Reload plugin files (reloads all if no name provided)"},
    {n="removeplugin",           d="Move a plugin file from Nexus-Admin back to workspace"},
    {n="removeallplugins",       d="Move all plugins from Nexus-Admin back to workspace"},
    {n="cmdbar2",                d="Opens a HD-Admin style cmdbar (black & white)"},
    {n="nocooldown",             d="Override game-script cooldown timing with chosen seconds; defaults to 0"},
    {n="unnocooldown",           d="Disable the game-script cooldown timing override"},
    {n="waitcap",                d="Cap game-script wait/delay durations"},
    {n="unwaitcap",              d="Disable the game-script wait/delay cap"},
    {n="notween",                d="Force all TweenService tweens to chosen duration; defaults to 0"},
    {n="unnotween",              d="Stop overriding game-created tween durations"},
    {n="autopatchtool",          d="Aggressively patch cooldown, reload, recoil, spread, ammo, fire-rate, range, and damage for a tool"},
    {n="patchtool",              d="Lightweight tool patcher for cooldown, reload, recoil, spread, ammo, fire-rate, range, or damage"},
    {n="unpatchtool",            d="Restore values changed by Patch Tool and disable its guards"},
    {n="unautopatchtool",        d="Restore values changed by Auto Patch Tool and disable its guards"},
    {n="scriptlogger",           d="Load SecureScripts Logger before running a suspicious script"},
    {n="tas",                    d="Launch TAS Recorder Redux; optionally auto-load and play a saved run"},
    {n="ibtools",                d="Load the iBuild Tools helper tool"},
    {n="unibtools",              d="Remove the iBuild Tools helper tool"},
    {n="setfflag",               d="Set a fast flag (use 'save' to store it)"},
    {n="addalias",               d="Add a persistent alias for an existing command"},
    {n="removealias",            d="Select and remove a saved alias"},
    {n="clearaliases",           d="Remove all aliases created using addalias"},
    {n="addbutton",              d="Add a mobile button"},
    {n="removebutton",           d="Remove a user button"},
    {n="clearbuttons",           d="Clear all user buttons"},
    {n="addautoexec",            d="Add a command to autoexecute"},
    {n="removeautoexec",         d="Remove a command from autoexecute"},
    {n="clearautoexec",          d="Clear all AutoExec commands"},
    {n="lastcommand",            d="Re-run your previously executed command"},
    {n="ifundone",               d="Run a command only if not done this session"},
    {n="commandloop",            d="Start a command loop"},
    {n="stoploop",               d="Stop a running loop"},
    {n="loop",                   d="Directly start a command loop"},
    {n="unloop",                 d="Stop all active command loops"},
    {n="repeat",                 d="Run a command a repeated amount of times"},
    {n="commandcount",           d="Count how many commands NX has"},
    {n="commandkeybinds",        d="Open the command keybinds window"},
    {n="prefix",                 d="Change the admin prefix"},
    {n="saveprefix",             d="Save the prefix to a file and apply it"},
    {n="uiscale",                d="Adjust the scale of the NX UI"},
    {n="settings",               d="Open the settings menu"},
    {n="commands",               d="Open the command list"},
    {n="hideicon",               d="Hide the NX icon"},
    {n="showicon",               d="Show the NX icon"},
    {n="topbar",                 d="Show the NX topbar"},
    {n="untopbar",               d="Hide the NX topbar"},
    {n="lockiconposition",       d="Lock the NX icon's position"},
    {n="unlockiconposition",     d="Unlock the NX icon's position"},
    {n="nachat",                 d="Open the Nexus Admin chat UI"},
    {n="nadisguise",             d="Disguise your NX Chat appearance as another user"},
    {n="rename",                 d="Rename the admin UI placeholder to the given name"},
    {n="unname",                 d="Reset the admin UI placeholder name to default"},
    -- Waypoints
    {n="waypoints",              d="Open the waypoints menu"},
    {n="setwaypoint",            d="Store your current position or create with custom coords"},
    {n="gotowaypoint",           d="Teleport to a saved waypoint"},
    {n="removewaypoint",         d="Remove a saved waypoint"},
    {n="showwaypoints",          d="Show saved waypoint ESP markers"},
    {n="hidewaypoints",          d="Hide saved waypoint ESP markers"},
    {n="pathfindwaypoint",       d="Pathfind to a saved waypoint"},
    {n="looppath",               d="Continuously path to a saved waypoint after death"},
    {n="unlooppath",             d="Stop persistent waypoint pathfinding"},
    -- Misc
    {n="rewind",                 d="Enable rewind (hold R on PC or draggable mobile button)"},
    {n="unrewind",               d="Disable rewind and clear its saved frames"},
    {n="delete",                 d="Delete an instance"},
    {n="deletefind",             d="Delete instances by name search"},
    {n="deletelighting",         d="Remove all descendants within Lighting"},
    {n="lightingdisable",        d="Disable all post-processing effects in Lighting"},
    {n="autodelete",             d="Auto-delete instances"},
    {n="unautodelete",           d="Stop auto-deleting instances"},
    {n="freezeunanchored",       d="Freeze unanchored non-character parts"},
    {n="thawunanchored",         d="Thaw parts frozen by freezeunanchored"},
    {n="removeterrain",          d="Clear terrain"},
    {n="blackhole",              d="Make unanchored parts teleport to the black hole"},
    {n="blackholefollow",        d="Pull unanchored parts to you with spin"},
    {n="noblackholefollow",      d="Stop blackhole follow"},
    {n="tpua",                   d="Bring every unanchored part on the map to a player or NPC"},
    {n="lockws",                 d="Lock the whole workspace"},
    {n="unlockws",               d="Unlock everything in Workspace"},
    {n="teamstop",               d="Toggle leaving the server if the watched role joins"},
    {n="trackstaff",             d="Track, highlight, and notify when staff joins"},
    {n="stoptrackstaff",         d="Stop tracking staff members"},
    {n="antistaff",              d="Auto leave or serverhop when staff is detected"},
    {n="unantistaff",            d="Disable automatic staff avoidance"},
    {n="music",                  d="Open the NX music player"},
    {n="minimap",                d="Show a minimap"},
    {n="badgeviewer",            d="View all badges in the game you're in"},
    {n="animationplayer",        d="Dropdown menu with all game animations to play"},
    {n="teleportgui",            d="Open the universe subplace and public-server viewer"},
    {n="serverlist",             d="Open the native server browser"},
    {n="keyboard",               d="Provide a keyboard GUI for mobile users"},
    {n="autoclicker",            d="Provide an autoclicker GUI"},
    {n="backpack",               d="Provide a custom backpack GUI"},
    {n="unloadbackpack",         d="Unload the custom backpack GUI"},
    {n="notepad",                d="Integrated notepad"},
    {n="discord",                d="Copy an invite link"},
    {n="feedback",               d="Open Roblox's experience feedback prompt"},
    {n="freegamepass",           d="Pretend you own every gamepass"},
    {n="devproducts",            d="Open the Products tab and send fake purchase signals"},
    {n="gamepasses",             d="Open the Game Passes tab and send fake purchase signals"},
    {n="exit",                   d="Close down Roblox"},
    {n="inspect",                d="Check a user's items"},
    {n="inspectoutfit",          d="Open a user's saved outfits"},
    {n="avatarpreview",          d="Create a client-only avatar preview rig"},
    {n="userpreview",            d="Show info about a user you name"},
    {n="spooftransform",         d="Spoof replicated character position/rotation"},
    {n="unspooftransform",       d="Disable character transform spoofing"},
    {n="spoofwalk",              d="Mask WalkSpeed between simulation and replication"},
    {n="unspoofwalk",            d="Disable WalkSpeed masking"},
    {n="humspoof",               d="Mask selected Humanoid physics properties"},
    {n="unhumspoof",             d="Disable Humanoid property mask"},
    {n="spoofstatus",            d="Show currently enabled spoof features"},
    {n="unloadspoofs",           d="Stop every spoof feature and restore saved state"},
    {n="resetfilter",            d="Reset the filter if Roblox keeps tagging your messages"},
    {n="noprompt",               d="Remove purchase prompts"},
    {n="prompt",                 d="Allow purchase prompts"},
    {n="nonetworkpause",         d="Disable Roblox network pause overlay"},
    {n="networkpause",           d="Re-enable Roblox network pause overlay"},
    {n="hideguis",               d="Hide GUIs"},
    {n="unhideguis",             d="Restore GUIs hidden by hideguis"},
    {n="showguis",               d="Enable every UI"},
    {n="volume",                 d="Change your volume (0-10)"},
    {n="sensitivity",            d="Change your sensitivity (1-10)"},
    {n="partname",               d="Click on a part to grab its path"},
    {n="f3x",                    d="F3X for client"},
    {n="rc7",                    d="RC7 Internal UI"},
    {n="checkrfe",               d="Check if the game has respect filtering enabled off"},
    {n="cig",                    d="Give a cigarette pack (client R6)"},
    {n="cigar",                  d="Give a cigar (client R6)"},
    {n="pipe",                   d="Give a smoking pipe (client R6)"},
    {n="tailsway",               d="Load the TailSway physics/wagging script"},
    {n="autorespawn",            d="Teleport back to your death position after respawn"},
    {n="unautorespawn",          d="Stop AutoRespawn"},
    {n="flashback",              d="Teleport to your last death point"},
    {n="autoflashback",          d="Auto-teleport to your last death point on respawn"},
    {n="unautoflashback",        d="Disable auto deathpos"},
    {n="oldroblox",              d="Old skybox and studs"},
    {n="unoldroblox",            d="Restore skybox and studs"},
    {n="2012",                   d="Make your CoreGui look like the 2012 CoreGui"},
    {n="2013",                   d="Make your CoreGui look like the 2013 CoreGui"},
    {n="2014",                   d="Make your CoreGui look like the 2014 CoreGui"},
    {n="2015",                   d="Make your CoreGui look like the 2015 CoreGui"},
    {n="2016",                   d="Make your CoreGui look like the 2016 CoreGui"},
    {n="keepna",                 d="Keep executing Nexus Admin"},
    {n="unkeepna",               d="Stop executing Nexus Admin"},
}

-- ─── GUI UTILITIES ───────────────────────────────────────────────────────────
local function mk(cls, props, par)
    local o = Instance.new(cls)
    for k,v in next,props do o[k] = v end
    if par then o.Parent = par end
    return o
end
local function cr(r,p) mk("UICorner",{CornerRadius=UDim.new(0,r)},p) end
local function st(c,t,p) mk("UIStroke",{Color=c,Thickness=t},p) end
local function tw(o,g,d,s,di)
    TweenS:Create(o,TweenInfo.new(d or .18,s or Enum.EasingStyle.Quad,di or Enum.EasingDirection.Out),g):Play()
end

-- ─── HELPERS ─────────────────────────────────────────────────────────────────
local function thumb(uid)
    local ok,r=pcall(Plrs.GetUserThumbnailAsync,Plrs,uid,
        Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100)
    return ok and r or ""
end
local function joinDate(p)
    local ok,r=pcall(os.date,"%b %d, %Y",os.time()-p.AccountAge*86400)
    return ok and r or "N/A"
end
local function findPlr(name)
    if not name then return nil end
    name=name:lower()
    for _,p in ipairs(Plrs:GetPlayers()) do
        if p.Name:lower():find(name,1,true) or p.DisplayName:lower():find(name,1,true) then
            return p
        end
    end
end
local function getHRP(t)
    return t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
end
local function getHum(t)
    return t and t.Character and t.Character:FindFirstChildOfClass("Humanoid")
end

-- ─── COMMAND HANDLERS ────────────────────────────────────────────────────────
local H = {}
local lastCmd = ""

-- Walkspeed / Jumppower
H.ws=function(t,v) local h=getHum(LP) if h then h.WalkSpeed=tonumber(v) or 16 end end
H.speed=H.ws
H.jp=function(t,v) local h=getHum(LP) if h then h.JumpPower=tonumber(v) or 50 end end
H.jumppower=H.jp
H.loopwalkspeed=function(t,v)
    local spd=tonumber(v) or 16
    H._loopwsConn=RS.Heartbeat:Connect(function()
        local h=getHum(LP) if h then h.WalkSpeed=spd end
    end)
end
H.unloopwalkspeed=function() if H._loopwsConn then H._loopwsConn:Disconnect() end end

-- Fly
H.fly=function(t,spd)
    if flyActive then return end
    spd=tonumber(spd) or 60
    local char=LP.Character if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    flyActive=true
    hum.PlatformStand=true
    flyBV=Instance.new("BodyVelocity")
    flyBV.Velocity=Vector3.zero
    flyBV.MaxForce=Vector3.new(9e9,9e9,9e9)
    flyBV.Parent=hrp
    flyBG=Instance.new("BodyGyro")
    flyBG.MaxTorque=Vector3.new(9e9,9e9,9e9)
    flyBG.P=9e4
    flyBG.Parent=hrp
    flyConn=RS.Heartbeat:Connect(function()
        if not flyActive then
            pcall(function() flyBV:Destroy() flyBG:Destroy() end)
            hum.PlatformStand=false
            flyConn:Disconnect()
            return
        end
        local cam=workspace.CurrentCamera
        local d=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then d=d+cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then d=d-cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then d=d-cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then d=d+cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.E) or UIS:IsKeyDown(Enum.KeyCode.Space) then d=d+Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then d=d-Vector3.new(0,1,0) end
        flyBV.Velocity=d.Magnitude>0 and d.Unit*spd or Vector3.zero
        flyBG.CFrame=cam.CFrame
    end)
end
H.unfly=function() flyActive=false end

-- Noclip
H.noclip=function()
    noclipActive=true
    noclipConn=RS.Stepped:Connect(function()
        if not noclipActive then noclipConn:Disconnect() return end
        local char=LP.Character
        if not char then return end
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide=false end
        end
    end)
end
H.clip=function()
    noclipActive=false
    if noclipConn then noclipConn:Disconnect() end
end

-- Teleport
H._goto=function(target,arg)
    if not target then
        -- try X,Y,Z
        local parts={}
        if arg then for n in (arg..","):gmatch("([^,]+),") do parts[#parts+1]=tonumber(n) end end
        if #parts>=3 then
            local hrp=getHRP(LP)
            if hrp then hrp.CFrame=CFrame.new(parts[1],parts[2],parts[3]) end
        end
        return
    end
    local hrp=getHRP(LP)
    local thrp=getHRP(target)
    if hrp and thrp then hrp.CFrame=thrp.CFrame*CFrame.new(3,0,0) end
end
H.goto=H._goto
H.tp=H._goto
H.teleport=H._goto
H.tpup=function(t,v)
    local hrp=getHRP(LP)
    if hrp then hrp.CFrame=hrp.CFrame*CFrame.new(0,tonumber(v) or 10,0) end
end
H.tpdown=function(t,v)
    local hrp=getHRP(LP)
    if hrp then hrp.CFrame=hrp.CFrame*CFrame.new(0,-(tonumber(v) or 10),0) end
end

-- Freeze
H.freeze=function()
    local hrp=getHRP(LP)
    if hrp then hrp.Anchored=true end
end
H.unfreeze=function()
    local hrp=getHRP(LP)
    if hrp then hrp.Anchored=false end
end

-- God mode
H.godmode=function()
    godActive=true
    local char=LP.Character if not char then return end
    local hum=char:FindFirstChildOfClass("Humanoid") if not hum then return end
    if godConn then godConn:Disconnect() end
    godConn=hum.HealthChanged:Connect(function(hp)
        if godActive and hp<hum.MaxHealth then hum.Health=hum.MaxHealth end
    end)
    hum.MaxHealth=math.huge
    hum.Health=math.huge
end
H.god=H.godmode
H.ungodmode=function()
    godActive=false
    if godConn then godConn:Disconnect() godConn=nil end
    local hum=getHum(LP)
    if hum then hum.MaxHealth=100 hum.Health=100 end
end
H.ungod=H.ungodmode

-- Kill / Respawn
H.kill=function()
    local hum=getHum(LP)
    if hum then hum.Health=0 end
end
H.reset=H.kill
H.die=H.kill
H.respawn=function() LP:LoadCharacter() end
H.commitoof=H.kill

-- Sit
H.sit=function()
    local hum=getHum(LP)
    if hum then hum.Sit=true end
end

-- Jump
H.jump=function()
    local hum=getHum(LP)
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end
H.loopjump=function()
    H.bhop=true
    loopjumpConn=RS.Heartbeat:Connect(function()
        if not H.bhop then loopjumpConn:Disconnect() return end
        local hum=getHum(LP)
        if hum and hum.FloorMaterial~=Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end
H.bhop=H.loopjump
H.unloopjump=function() H.bhop=false if loopjumpConn then loopjumpConn:Disconnect() end end
H.unbhop=H.unloopjump

-- Infinite jump
H.infjump=function()
    infjumpConn=UIS.JumpRequest:Connect(function()
        local hum=getHum(LP)
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end
H.uninfjump=function()
    if infjumpConn then infjumpConn:Disconnect() infjumpConn=nil end
end
H.infinitejump=H.infjump
H.uninfinitejump=H.uninfjump

-- Anti AFK
H.antiafk=function()
    antiafkConn=LP.Idled:Connect(function()
        local v=Instance.new("VirtualUser")
        v.Parent=game
        v:CaptureController()
        v:ClickButton2(Vector2.new())
        v:Destroy()
    end)
end
H.unantiafk=function()
    if antiafkConn then antiafkConn:Disconnect() antiafkConn=nil end
end
H.noafk=H.antiafk
H.unnoafk=H.unantiafk

-- Fling
H.fling=function(target)
    if not (target and target.Character) then return end
    local hrp=getHRP(LP)
    local thrp=getHRP(target)
    if not hrp or not thrp then return end
    local orig=hrp.CFrame
    hrp.CFrame=thrp.CFrame*CFrame.new(0,0.5,0)
    hrp.AssemblyLinearVelocity=Vector3.new(
        math.random(-80,80),math.random(120,280),math.random(-80,80))
    task.delay(0.06,function() pcall(function() hrp.CFrame=orig end) end)
end
H.loopfling=function(target)
    loopFlingTgt=target
    if loopFlingConn then loopFlingConn:Disconnect() end
    loopFlingConn=RS.Heartbeat:Connect(function()
        if not loopFlingTgt or not loopFlingTgt.Parent then
            loopFlingConn:Disconnect() loopFlingTgt=nil return
        end
        H.fling(loopFlingTgt)
    end)
end
H.unloopfling=function()
    loopFlingTgt=nil
    if loopFlingConn then loopFlingConn:Disconnect() loopFlingConn=nil end
end

-- Headsit
H.headsit=function(target)
    if not (target and target.Character) then return end
    local char=LP.Character if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    headsitTgt=target
    headsitActive=true
    hum.Sit=true
    if headsitConn then headsitConn:Disconnect() end
    headsitConn=RS.Heartbeat:Connect(function()
        if not headsitActive or not headsitTgt or not headsitTgt.Character then
            headsitConn:Disconnect() return
        end
        local h=headsitTgt.Character:FindFirstChild("Head")
        if h then hrp.CFrame=h.CFrame*CFrame.new(0,h.Size.Y/2+0.8,0) end
    end)
end
H.unheadsit=function()
    headsitActive=false
    headsitTgt=nil
    if headsitConn then headsitConn:Disconnect() headsitConn=nil end
    local hum=getHum(LP)
    if hum then hum.Sit=false end
end

-- Headstand
H.headstand=function(target)
    if not (target and target.Character) then return end
    local char=LP.Character if not char then return end
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    headstandTgt=target
    headstandActive=true
    if headstandConn then headstandConn:Disconnect() end
    headstandConn=RS.Heartbeat:Connect(function()
        if not headstandActive or not headstandTgt or not headstandTgt.Character then
            headstandConn:Disconnect() return
        end
        local h=headstandTgt.Character:FindFirstChild("Head")
        if h then hrp.CFrame=h.CFrame*CFrame.new(0,h.Size.Y+2.5,0) end
    end)
end
H.unheadstand=function()
    headstandActive=false
    headstandTgt=nil
    if headstandConn then headstandConn:Disconnect() headstandConn=nil end
end

-- Watch / Spectate
H.watch=function(target)
    if not (target and target.Character) then return end
    local hum=target.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        workspace.CurrentCamera.CameraSubject=hum
        workspace.CurrentCamera.CameraType=Enum.CameraType.Follow
    end
end
H.spectate=H.watch
H.view=H.watch
H.unwatch=function()
    local char=LP.Character
    if char then
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then workspace.CurrentCamera.CameraSubject=hum end
    end
    workspace.CurrentCamera.CameraType=Enum.CameraType.Custom
end
H.unview=H.unwatch

-- Follow
H.follow=function(target)
    if followConn then followConn:Disconnect() end
    followConn=RS.Heartbeat:Connect(function()
        if not target or not target.Character then
            followConn:Disconnect() return
        end
        H._goto(target)
    end)
end
H.unfollow=function()
    if followConn then followConn:Disconnect() followConn=nil end
end
H.stalk=H.follow
H.unstalk=H.unfollow

-- Glue
H.glue=function(target)
    if glueConn then glueConn:Disconnect() end
    glueConn=RS.Heartbeat:Connect(function()
        if not target or not target.Character then
            glueConn:Disconnect() return
        end
        local hrp=getHRP(LP)
        local thrp=getHRP(target)
        if hrp and thrp then hrp.CFrame=thrp.CFrame end
    end)
end
H.unglue=function()
    if glueConn then glueConn:Disconnect() glueConn=nil end
end
H.loopgoto=H.glue
H.unloopgoto=H.unglue

-- Orbit
H.orbit=function(target,dist,spd)
    dist=tonumber(dist) or 6
    spd=tonumber(spd) or 1
    local t=0
    if orbitConn then orbitConn:Disconnect() end
    orbitConn=RS.Heartbeat:Connect(function(dt)
        t=t+dt*spd
        if not target or not target.Character then
            orbitConn:Disconnect() return
        end
        local thrp=getHRP(target)
        local hrp=getHRP(LP)
        if hrp and thrp then
            hrp.CFrame=CFrame.new(
                thrp.Position+Vector3.new(math.sin(t)*dist,0,math.cos(t)*dist),
                thrp.Position)
        end
    end)
end
H.unorbit=function()
    if orbitConn then orbitConn:Disconnect() orbitConn=nil end
end

-- ESP
H.esp=function()
    espActive=true
    local function addHL(p)
        if p==LP then return end
        if not (p.Character) then return end
        local h=Instance.new("Highlight")
        h.FillColor=Color3.fromRGB(255,50,50)
        h.OutlineColor=Color3.fromRGB(255,255,255)
        h.FillTransparency=0.4
        h.OutlineTransparency=0
        h.Parent=p.Character
        espHL[p.Name]=h
        p.CharacterAdded:Connect(function(c)
            task.wait(0.5)
            if espActive then
                local nh=Instance.new("Highlight")
                nh.FillColor=Color3.fromRGB(255,50,50)
                nh.OutlineColor=Color3.fromRGB(255,255,255)
                nh.FillTransparency=0.4
                nh.Parent=c
                espHL[p.Name]=nh
            end
        end)
    end
    for _,p in ipairs(Plrs:GetPlayers()) do addHL(p) end
    if espAddConn then espAddConn:Disconnect() end
    espAddConn=Plrs.PlayerAdded:Connect(function(p) task.wait(1) addHL(p) end)
end
H.chams=H.esp
H.unesp=function()
    espActive=false
    for _,h in pairs(espHL) do pcall(function() h:Destroy() end) end
    espHL={}
    if espAddConn then espAddConn:Disconnect() espAddConn=nil end
end
H.unchams=H.unesp

-- Invisible
H.invisible=function()
    local char=LP.Character if not char then return end
    for _,p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.LocalTransparencyModifier=1 end
    end
end
H.invis=H.invisible
H.visible=function()
    local char=LP.Character if not char then return end
    for _,p in pairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.LocalTransparencyModifier=0 end
    end
end
H.vis=H.visible

-- Fullbright
H.fullbright=function()
    game:GetService("Lighting").Brightness=2
    game:GetService("Lighting").ClockTime=14
    game:GetService("Lighting").FogEnd=1e6
    game:GetService("Lighting").GlobalShadows=false
    game:GetService("Lighting").Ambient=Color3.new(1,1,1)
    game:GetService("Lighting").OutdoorAmbient=Color3.new(1,1,1)
end

-- No fog
H.nofog=function()
    game:GetService("Lighting").FogEnd=1e6
    game:GetService("Lighting").FogStart=0
end

-- Day / Night / Time
H.day=function()
    game:GetService("Lighting").ClockTime=14
end
H.night=function()
    game:GetService("Lighting").ClockTime=0
end
H.time=function(t,v)
    if v then game:GetService("Lighting").ClockTime=tonumber(v) or 14 end
end

-- Gravity
H.gravity=function(t,v)
    workspace.Gravity=tonumber(v) or 196.2
end
H.grav=H.gravity

-- Chat
H.chat=function(t,msg)
    if msg then
        local ok=pcall(game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest.FireServer,
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest,msg,"All")
        if not ok then
            game:GetService("Chat"):Chat(LP.Character and LP.Character:FindFirstChild("Head"),msg)
        end
    end
end
H.message=H.chat

-- Admin
H.admin=function(target)
    if target then
        ADMINS[target.Name]=true
        toast("Admin Granted","@"..target.Name.." can now use NX commands on you.")
    end
end
H.whitelist=H.admin
H.unadmin=function(target)
    if target then
        ADMINS[target.Name]=nil
        toast("Admin Removed","@"..target.Name.." removed from admin.")
    end
end

-- Freecam
H.freecam=function(t,spd)
    if freecamActive then return end
    spd=tonumber(spd) or 50
    freecamActive=true
    workspace.CurrentCamera.CameraType=Enum.CameraType.Scriptable
    if freecamConn then freecamConn:Disconnect() end
    freecamConn=RS.RenderStepped:Connect(function(dt)
        if not freecamActive then
            workspace.CurrentCamera.CameraType=Enum.CameraType.Custom
            local hum=getHum(LP)
            if hum then workspace.CurrentCamera.CameraSubject=hum end
            freecamConn:Disconnect()
            return
        end
        local d=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then d=d+workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then d=d-workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then d=d-workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then d=d+workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.E) or UIS:IsKeyDown(Enum.KeyCode.Space) then d=d+Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then d=d-Vector3.new(0,1,0) end
        if d.Magnitude>0 then
            workspace.CurrentCamera.CFrame=workspace.CurrentCamera.CFrame
                *CFrame.new(d.Unit*spd*dt)
        end
    end)
end
H.fc=H.freecam
H.fcam=H.freecam
H.unfreecam=function()
    freecamActive=false
    if freecamConn then freecamConn:Disconnect() freecamConn=nil end
    workspace.CurrentCamera.CameraType=Enum.CameraType.Custom
    local hum=getHum(LP)
    if hum then workspace.CurrentCamera.CameraSubject=hum end
end
H.unfc=H.unfreecam
H.unfcam=H.unfreecam

-- FOV
H.fov=function(t,v)
    local val=tonumber(v) or 70
    workspace.CurrentCamera.FieldOfView=math.clamp(val,1,120)
end

-- Ping / FPS (toast info)
H.ping=function()
    local stats=game:GetService("Stats")
    toast("Ping",math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue()).."ms")
end
H.fps=function()
    toast("FPS",tostring(math.floor(1/RS.RenderStepped:Wait())))
end

-- Rejoin
H.rejoin=function()
    local tp=game:GetService("TeleportService")
    tp:Teleport(game.PlaceId,LP)
end
H.rj=H.rejoin

-- Serverhop
H.serverhop=function()
    local tp=game:GetService("TeleportService")
    local ok,res=pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    end)
    if ok and res then
        local json=game:GetService("HttpService"):JSONDecode(res)
        if json and json.data then
            for _,s in ipairs(json.data) do
                if s.id~=game.JobId and s.playing<s.maxPlayers then
                    tp:TeleportToPlaceInstance(game.PlaceId,s.id,LP)
                    return
                end
            end
        end
    end
    tp:Teleport(game.PlaceId,LP)
end
H.shop=H.serverhop

-- Bring (client-side visual only)
H.bring=function(target)
    if not target or not target.Character then return end
    local hrp=getHRP(LP)
    local thrp=getHRP(target)
    if hrp and thrp then
        thrp.CFrame=hrp.CFrame*CFrame.new(3,0,0)
    end
end

-- Client bring loop
H.cbring=function(target)
    H.bring(target)
end
H.loopcbring=function(target)
    if cbringConn then cbringConn:Disconnect() end
    cbringConn=RS.Heartbeat:Connect(function()
        if not target or not target.Character then cbringConn:Disconnect() return end
        H.bring(target)
    end)
end
H.unloopcbring=function()
    if cbringConn then cbringConn:Disconnect() cbringConn=nil end
end

-- Reach (tool size)
H.reach=function(t,v)
    local char=LP.Character if not char then return end
    local tool=char:FindFirstChildOfClass("Tool")
    if not tool then return end
    local handle=tool:FindFirstChild("Handle")
    if handle then handle.Size=Vector3.new(tonumber(v) or 20,1,1) end
end
H.swordreach=H.reach
H.resetreach=function()
    local char=LP.Character if not char then return end
    local tool=char:FindFirstChildOfClass("Tool")
    if not tool then return end
    local handle=tool:FindFirstChild("Handle")
    if handle then handle.Size=Vector3.new(1,1,1) end
end
H.normalreach=H.resetreach
H.unreach=H.resetreach

-- Aura
H.aura=function(t,dist)
    dist=tonumber(dist) or 15
    auraConn=RS.Heartbeat:Connect(function()
        if not auraConn then return end
        local char=LP.Character if not char then return end
        local tool=char:FindFirstChildOfClass("Tool") if not tool then return end
        local hrp=getHRP(LP) if not hrp then return end
        for _,p in ipairs(Plrs:GetPlayers()) do
            if p~=LP and p.Character then
                local thrp=getHRP(p)
                if thrp and (thrp.Position-hrp.Position).Magnitude<=dist then
                    local hum=getHum(p)
                    if hum and hum.Health>0 then
                        local ok=pcall(function()
                            tool:Activate()
                        end)
                    end
                end
            end
        end
    end)
end
H.unaura=function()
    if auraConn then auraConn:Disconnect() auraConn=nil end
end

-- Game info
H.gameinfo=function()
    toast("Game Info","Place: "..game.PlaceId.."  Universe: "..game.GameId)
end
H.ginfo=H.gameinfo
H.placeid=function()
    pcall(setclipboard,tostring(game.PlaceId))
    toast("PlaceId Copied",tostring(game.PlaceId))
end
H.gameid=function()
    pcall(setclipboard,tostring(game.GameId))
    toast("GameId Copied",tostring(game.GameId))
end
H.jobid=function()
    pcall(setclipboard,game.JobId)
    toast("Job ID Copied",game.JobId)
end
H.copyid=function(target)
    if target then
        pcall(setclipboard,tostring(target.UserId))
        toast("User ID Copied",tostring(target.UserId).." — "..target.Name)
    end
end
H.id=H.copyid
H.copyname=function(target)
    if target then
        pcall(setclipboard,target.Name)
        toast("Username Copied",target.Name)
    end
end

-- Break velocity
H.deletevelocity=function()
    local hrp=getHRP(LP)
    if hrp then
        hrp.AssemblyLinearVelocity=Vector3.zero
        hrp.AssemblyAngularVelocity=Vector3.zero
    end
end
H.dv=H.deletevelocity
H.removevelocity=H.deletevelocity
H.breakvelocity=H.deletevelocity

-- Gravity gun (basic part grab)
H.gravitygun=function()
    toast("Gravity Gun","Tool added — left click to grab parts.")
end

-- Nakedness
H.naked=function()
    local char=LP.Character if not char then return end
    for _,item in ipairs(char:GetChildren()) do
        if item:IsA("Shirt") or item:IsA("Pants") then item:Destroy() end
    end
end

-- Brightness
H.brightness=function(t,v)
    game:GetService("Lighting").Brightness=tonumber(v) or 1
end

-- NX unload (clean up everything)
H.unload=function()
    flyActive=false
    noclipActive=false
    espActive=false
    godActive=false
    loopFlingTgt=nil
    headsitActive=false
    headstandActive=false
    freecamActive=false
    H.unesp()
    H.unfly()
    H.clip()
    H.ungodmode()
    H.unloopfling()
    H.unheadsit()
    H.unheadstand()
    H.unfollow()
    H.uninfjump()
    H.unantiafk()
    H.unorbit()
    H.unglue()
    H.unloopjump()
    H.unfreecam()
    toast("Nexus Admin","Panel unloaded.")
    task.wait(1)
    game:GetService("GuiService"):SetGuiInset(Vector2.zero,Vector2.zero)
end

-- ─── TOAST SYSTEM ────────────────────────────────────────────────────────────
toast = function(title, msg)
    local G = game:GetService("CoreGui"):FindFirstChild("NXAdmin")
        or LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild("NXAdmin")
    if not G then return end

    local f=mk("Frame",{Parent=G,BackgroundColor3=C.bg3,BorderSizePixel=0,
        Position=UDim2.new(.5,0,1,30),AnchorPoint=Vector2.new(.5,1),
        Size=UDim2.new(0,400,0,72),ZIndex=100})
    cr(12,f) st(C.brd,1,f)

    local ck=mk("Frame",{Parent=f,BackgroundColor3=C.bg4,
        Position=UDim2.new(0,14,.5,0),AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(0,40,0,40),ZIndex=101}) cr(20,ck)
    mk("TextLabel",{Parent=ck,Text="✓",TextColor3=C.grn,Font=Enum.Font.GothamBold,
        TextSize=18,BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=102})

    mk("TextLabel",{Parent=f,Text=title,TextColor3=C.t0,Font=Enum.Font.GothamBold,
        TextSize=13,BackgroundTransparency=1,
        Position=UDim2.new(0,64,0,14),Size=UDim2.new(1,-80,0,20),
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=101})
    mk("TextLabel",{Parent=f,Text=msg,TextColor3=C.t1,Font=Enum.Font.Gotham,
        TextSize=11,BackgroundTransparency=1,
        Position=UDim2.new(0,64,0,36),Size=UDim2.new(1,-80,0,18),
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=101})

    local xb=mk("TextButton",{Parent=f,Text="✕",TextColor3=C.t2,Font=Enum.Font.Gotham,
        TextSize=13,BackgroundTransparency=1,
        Position=UDim2.new(1,-36,.5,0),AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(0,28,0,28),ZIndex=101})

    tw(f,{Position=UDim2.new(.5,0,1,-16)},.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out)

    local function dismiss()
        tw(f,{Position=UDim2.new(.5,0,1,80)},.2)
        task.delay(.22,function() pcall(function() f:Destroy() end) end)
    end
    xb.MouseButton1Click:Connect(dismiss)
    task.delay(5,dismiss)
end

-- ─── ROOT SCREENGUI ──────────────────────────────────────────────────────────
local G = Instance.new("ScreenGui")
G.Name = "NXAdmin"
G.ResetOnSpawn = false
G.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
G.DisplayOrder = 9999
G.IgnoreGuiInset = true
pcall(function() G.Parent = game:GetService("CoreGui") end)
if not G.Parent then G.Parent = LP:WaitForChild("PlayerGui") end

-- ─── MAIN PANEL ──────────────────────────────────────────────────────────────
local P = mk("Frame",{Parent=G,Name="Panel",BackgroundColor3=C.bg1,BorderSizePixel=0,
    Position=UDim2.new(.5,0,.5,0),AnchorPoint=Vector2.new(.5,.5),
    Size=UDim2.new(0,1080,0,640),ZIndex=5})
cr(12,P) st(C.brd,1,P)

-- Drag header
do
    local drg,ds,sp=false,nil,nil
    P.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
            and i.Position.Y-P.AbsolutePosition.Y<54 then
            drg,ds,sp=true,i.Position,P.Position
        end
    end)
    P.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then drg=false end
    end)
    UIS.InputChanged:Connect(function(i)
        if drg and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            P.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
end

-- Header
mk("TextLabel",{Parent=P,Text="Nexus Admin",TextColor3=C.t0,Font=Enum.Font.GothamBold,
    TextSize=14,BackgroundTransparency=1,Position=UDim2.new(0,18,0,0),
    Size=UDim2.new(0,200,0,52),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7})
local closeB=mk("TextButton",{Parent=P,Text="✕",TextColor3=C.t1,Font=Enum.Font.Gotham,
    TextSize=15,BackgroundTransparency=1,Position=UDim2.new(1,-48,0,0),
    Size=UDim2.new(0,48,0,52),ZIndex=7})
mk("Frame",{Parent=P,BackgroundColor3=C.brd,Position=UDim2.new(0,0,0,52),
    Size=UDim2.new(1,0,0,1),ZIndex=6})

-- ─── TAB BAR ─────────────────────────────────────────────────────────────────
local TabBar=mk("Frame",{Parent=P,BackgroundColor3=C.bg0,BorderSizePixel=0,
    Position=UDim2.new(0,0,0,53),Size=UDim2.new(1,0,0,50),ZIndex=6})

local tabDefs = {
    {id="Commands", lbl="⌨   Commands"},
    {id="Players",  lbl="👤   Players"},
    {id="Settings", lbl="⚙   Settings"},
}
local tabBtns,tabInds={},{}
for i,td in ipairs(tabDefs) do
    local btn=mk("TextButton",{Parent=TabBar,Text=td.lbl,
        TextColor3=(i==2) and C.t0 or C.t1,Font=Enum.Font.Gotham,TextSize=13,
        BackgroundTransparency=1,Position=UDim2.new((i-1)/3,0,0,0),
        Size=UDim2.new(1/3,0,1,0),ZIndex=7})
    local ind=mk("Frame",{Parent=btn,BackgroundColor3=C.t0,
        Position=UDim2.new(0,0,1,-2),Size=UDim2.new(1,0,0,2),Visible=(i==2),ZIndex=8})
    tabBtns[td.id]=btn
    tabInds[td.id]=ind
end
mk("Frame",{Parent=P,BackgroundColor3=C.brd,Position=UDim2.new(0,0,0,103),
    Size=UDim2.new(1,0,0,1),ZIndex=6})

-- ─── CONTENT AREA ────────────────────────────────────────────────────────────
local CFR=mk("Frame",{Parent=P,BackgroundColor3=C.bg1,BorderSizePixel=0,
    Position=UDim2.new(0,0,0,104),Size=UDim2.new(1,0,1,-104),ZIndex=6})

-- ═══════════════════════════════════════════════════════════════════════
-- PLAYERS PAGE
-- ═══════════════════════════════════════════════════════════════════════
local PlayersPage=mk("Frame",{Parent=CFR,BackgroundTransparency=1,
    Size=UDim2.fromScale(1,1),ZIndex=6,Visible=true})

-- LEFT: list
local LC=mk("Frame",{Parent=PlayersPage,BackgroundColor3=C.bg1,BorderSizePixel=0,
    Size=UDim2.new(0,320,1,0),ZIndex=6})
mk("Frame",{Parent=PlayersPage,BackgroundColor3=C.brd,
    Position=UDim2.new(0,320,0,0),Size=UDim2.new(0,1,1,0),ZIndex=6})

local srch=mk("TextBox",{Parent=LC,PlaceholderText="  🔍 Search players...",
    PlaceholderColor3=C.t2,Text="",TextColor3=C.t0,Font=Enum.Font.Gotham,TextSize=13,
    BackgroundColor3=C.bg2,BorderSizePixel=0,
    Position=UDim2.new(0,10,0,12),Size=UDim2.new(1,-20,0,38),
    ClearTextOnFocus=false,ZIndex=7})
cr(8,srch) st(C.brd,1,srch)

local PSF=mk("ScrollingFrame",{Parent=LC,BackgroundTransparency=1,
    Position=UDim2.new(0,6,0,60),Size=UDim2.new(1,-12,1,-68),
    ScrollBarThickness=3,ScrollBarImageColor3=C.bg4,BorderSizePixel=0,
    ZIndex=7,CanvasSize=UDim2.new(0,0,0,0)})
local PSFL=mk("UIListLayout",{Parent=PSF,SortOrder=Enum.SortOrder.LayoutOrder,
    Padding=UDim.new(0,4)})
PSFL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PSF.CanvasSize=UDim2.new(0,0,0,PSFL.AbsoluteContentSize.Y+8)
end)

-- CENTER + RIGHT wrapper
local CRW=mk("Frame",{Parent=PlayersPage,BackgroundTransparency=1,
    Position=UDim2.new(0,321,0,0),Size=UDim2.new(1,-321,1,0),ZIndex=6})

local noSel=mk("TextLabel",{Parent=CRW,Text="Select a player to view their profile",
    TextColor3=C.t2,Font=Enum.Font.Gotham,TextSize=14,BackgroundTransparency=1,
    Size=UDim2.fromScale(1,1),ZIndex=7})

-- CENTER: profile + stats + actions
local CC=mk("Frame",{Parent=CRW,BackgroundTransparency=1,
    Size=UDim2.new(0,410,1,0),ZIndex=6})
mk("Frame",{Parent=CRW,BackgroundColor3=C.brd,
    Position=UDim2.new(0,410,0,0),Size=UDim2.new(0,1,1,0),ZIndex=6})

-- Profile header
local PHdr=mk("Frame",{Parent=CC,BackgroundTransparency=1,
    Position=UDim2.new(0,14,0,14),Size=UDim2.new(1,-28,0,76),ZIndex=7,Visible=false})

local pAv=mk("ImageLabel",{Parent=PHdr,BackgroundColor3=C.bg3,
    Size=UDim2.new(0,58,0,58),ZIndex=8})
cr(29,pAv) st(C.brd,1,pAv)

local pName=mk("TextLabel",{Parent=PHdr,Text="",TextColor3=C.t0,
    Font=Enum.Font.GothamBold,TextSize=17,BackgroundTransparency=1,
    Position=UDim2.new(0,72,0,4),Size=UDim2.new(1,-200,0,24),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8})
local pHandle=mk("TextLabel",{Parent=PHdr,Text="",TextColor3=C.t1,
    Font=Enum.Font.Gotham,TextSize=11,BackgroundTransparency=1,
    Position=UDim2.new(0,72,0,28),Size=UDim2.new(1,-200,0,18),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8})
local pDot=mk("Frame",{Parent=PHdr,BackgroundColor3=C.grn,
    Position=UDim2.new(0,72,0,50),Size=UDim2.new(0,7,0,7),ZIndex=8})
cr(4,pDot)
mk("TextLabel",{Parent=PHdr,Text="Online",TextColor3=C.grn,Font=Enum.Font.Gotham,
    TextSize=11,BackgroundTransparency=1,Position=UDim2.new(0,84,0,44),
    Size=UDim2.new(0,60,0,18),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8})

local cpBtn=mk("TextButton",{Parent=PHdr,Text="⧉  Copy ID",TextColor3=C.t0,
    Font=Enum.Font.Gotham,TextSize=11,BackgroundColor3=C.bg3,BorderSizePixel=0,
    Position=UDim2.new(1,0,.5,0),AnchorPoint=Vector2.new(1,.5),
    Size=UDim2.new(0,100,0,32),ZIndex=8})
cr(8,cpBtn) st(C.brd,1,cpBtn)
cpBtn.MouseEnter:Connect(function() tw(cpBtn,{BackgroundColor3=C.bg4},.1) end)
cpBtn.MouseLeave:Connect(function() tw(cpBtn,{BackgroundColor3=C.bg3},.1) end)

-- Stats row
local StatsRow=mk("Frame",{Parent=CC,BackgroundTransparency=1,
    Position=UDim2.new(0,14,0,100),Size=UDim2.new(1,-28,0,62),ZIndex=7,Visible=false})
mk("UIListLayout",{Parent=StatsRow,FillDirection=Enum.FillDirection.Horizontal,
    Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
local statVals={}
local function mkStat(ico,lbl,order)
    local f=mk("Frame",{Parent=StatsRow,BackgroundColor3=C.bg2,
        Size=UDim2.new(.25,-5,1,0),LayoutOrder=order,ZIndex=8})
    cr(8,f) st(C.brd,1,f)
    mk("TextLabel",{Parent=f,Text=ico,TextColor3=C.t1,Font=Enum.Font.Gotham,TextSize=14,
        BackgroundTransparency=1,Position=UDim2.new(0,10,.5,0),AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(0,20,0,20),ZIndex=9})
    mk("TextLabel",{Parent=f,Text=lbl,TextColor3=C.t1,Font=Enum.Font.Gotham,TextSize=8,
        BackgroundTransparency=1,Position=UDim2.new(0,34,0,6),
        Size=UDim2.new(1,-38,0,14),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=9})
    local vl=mk("TextLabel",{Parent=f,Text="—",TextColor3=C.t0,
        Font=Enum.Font.GothamBold,TextSize=11,BackgroundTransparency=1,
        Position=UDim2.new(0,34,0,22),Size=UDim2.new(1,-38,0,18),
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=9})
    statVals[lbl]=vl
end
mkStat("📅","Join Date",1)
mkStat("🕐","Last Seen",2)
mkStat("⏱","Playtime",3)
mkStat("👑","Rank",4)

-- Player Actions label
local PALbl=mk("TextLabel",{Parent=CC,Text="Player Actions",TextColor3=C.t0,
    Font=Enum.Font.GothamBold,TextSize=13,BackgroundTransparency=1,
    Position=UDim2.new(0,14,0,175),Size=UDim2.new(1,-28,0,22),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7,Visible=false})

-- Actions scroll frame
local ActSF=mk("ScrollingFrame",{Parent=CC,BackgroundTransparency=1,
    Position=UDim2.new(0,14,0,204),Size=UDim2.new(1,-28,1,-212),
    ScrollBarThickness=3,ScrollBarImageColor3=C.bg4,BorderSizePixel=0,
    ZIndex=7,Visible=false,CanvasSize=UDim2.new(0,0,0,0)})
local ActLL=mk("UIListLayout",{Parent=ActSF,Padding=UDim.new(0,5),
    SortOrder=Enum.SortOrder.LayoutOrder})
ActLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ActSF.CanvasSize=UDim2.new(0,0,0,ActLL.AbsoluteContentSize.Y+6)
end)

-- Build the 7 action buttons
local function mkActionBtn(parent, ico, lbl, order)
    local btn=mk("TextButton",{Parent=parent,Text="",BackgroundColor3=C.bg2,
        BorderSizePixel=0,Size=UDim2.new(1,0,0,44),LayoutOrder=order,ZIndex=8})
    cr(8,btn) st(C.brd,1,btn)
    mk("TextLabel",{Parent=btn,Text=ico,TextColor3=C.t0,Font=Enum.Font.Gotham,TextSize=15,
        BackgroundTransparency=1,Position=UDim2.new(0,14,.5,0),AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(0,26,0,26),ZIndex=9})
    local lblEl=mk("TextLabel",{Parent=btn,Text=lbl,TextColor3=C.t0,
        Font=Enum.Font.Gotham,TextSize=13,BackgroundTransparency=1,
        Position=UDim2.new(0,48,.5,0),AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(1,-78,1,0),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=9})
    mk("TextLabel",{Parent=btn,Text="›",TextColor3=C.t2,Font=Enum.Font.Gotham,TextSize=20,
        BackgroundTransparency=1,Position=UDim2.new(1,-28,.5,0),AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(0,18,0,18),ZIndex=9})
    btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=C.bg3},.1) end)
    btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=C.bg2},.1) end)
    return btn, lblEl
end

local gotoBtn     = mkActionBtn(ActSF,"📍","Goto Player",1)
local viewBtn     = mkActionBtn(ActSF,"👁","View Player",2)
local flingBtn    = mkActionBtn(ActSF,"💥","Fling",3)
local lfBtn,lfLbl = mkActionBtn(ActSF,"🔄","Loop Fling",4)
local adminBtn    = mkActionBtn(ActSF,"👑","Give Admin",5)
local hsBtn,hsLbl = mkActionBtn(ActSF,"🪑","Headsit",6)
local profBtn     = mkActionBtn(ActSF,"🔗","Profile",7)
loopFlingBtn=lfBtn; loopFlingLbl=lfLbl
headsitBtn=hsBtn;   headsitLbl=hsLbl

-- Wire action button clicks
gotoBtn.MouseButton1Click:Connect(function()
    if not S.sel then return end
    H._goto(S.sel)
    toast("Goto","Teleported to "..S.sel.Name)
end)
viewBtn.MouseButton1Click:Connect(function()
    if not S.sel then return end
    H.watch(S.sel)
    toast("View","Now spectating "..S.sel.Name)
end)
flingBtn.MouseButton1Click:Connect(function()
    if not S.sel then return end
    H.fling(S.sel)
    toast("Fling",S.sel.Name.." flung.")
end)
lfBtn.MouseButton1Click:Connect(function()
    if not S.sel then return end
    if loopFlingTgt==S.sel then
        H.unloopfling()
        lfLbl.Text="Loop Fling"
        tw(lfBtn,{BackgroundColor3=C.bg2},.1)
        toast("Loop Fling","Stopped loop fling on "..S.sel.Name)
    else
        H.loopfling(S.sel)
        lfLbl.Text="Stop Fling"
        tw(lfBtn,{BackgroundColor3=Color3.fromRGB(55,18,18)},.1)
        toast("Loop Fling","Loop fling started on "..S.sel.Name)
    end
end)
adminBtn.MouseButton1Click:Connect(function()
    if not S.sel then return end
    H.admin(S.sel)
end)
hsBtn.MouseButton1Click:Connect(function()
    if not S.sel then return end
    if headsitTgt==S.sel and headsitActive then
        H.unheadsit()
        hsLbl.Text="Headsit"
        tw(hsBtn,{BackgroundColor3=C.bg2},.1)
        toast("Headsit","Stopped headsit on "..S.sel.Name)
    else
        H.headsit(S.sel)
        hsLbl.Text="Stop Headsit"
        tw(hsBtn,{BackgroundColor3=Color3.fromRGB(55,18,18)},.1)
        toast("Headsit","Sitting on "..S.sel.Name.."'s head.")
    end
end)
profBtn.MouseButton1Click:Connect(function()
    if not S.sel then return end
    local url="https://www.roblox.com/users/"..tostring(S.sel.UserId).."/profile"
    pcall(setclipboard,url)
    toast("Profile URL","Copied: "..url)
end)

-- RIGHT: player info + notes
local RC=mk("Frame",{Parent=CRW,BackgroundTransparency=1,
    Position=UDim2.new(0,411,0,0),Size=UDim2.new(1,-411,1,0),ZIndex=6})

local PILbl=mk("TextLabel",{Parent=RC,Text="Player Information",TextColor3=C.t0,
    Font=Enum.Font.GothamBold,TextSize=13,BackgroundTransparency=1,
    Position=UDim2.new(0,14,0,14),Size=UDim2.new(1,-28,0,22),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7,Visible=false})

local PIBox=mk("Frame",{Parent=RC,BackgroundColor3=C.bg2,BorderSizePixel=0,
    Position=UDim2.new(0,14,0,44),Size=UDim2.new(1,-28,0,296),ZIndex=7,Visible=false})
cr(10,PIBox) st(C.brd,1,PIBox)

local PI_FIELDS={"Username","Display Name","User ID","Account Age",
    "Friends","Join Date","Last Online","Game"}
local piVals={}
for i,field in ipairs(PI_FIELDS) do
    local row=mk("Frame",{Parent=PIBox,BackgroundTransparency=1,
        Position=UDim2.new(0,0,0,(i-1)*37),Size=UDim2.new(1,0,0,37),ZIndex=8})
    if i<#PI_FIELDS then
        mk("Frame",{Parent=row,BackgroundColor3=C.brd,
            Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,1),ZIndex=8})
    end
    mk("TextLabel",{Parent=row,Text=field,TextColor3=C.t1,Font=Enum.Font.Gotham,TextSize=11,
        BackgroundTransparency=1,Position=UDim2.new(0,12,.5,0),AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(.52,-12,1,0),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=9})
    local vl=mk("TextLabel",{Parent=row,Text="—",TextColor3=C.t0,
        Font=Enum.Font.GothamBold,TextSize=11,BackgroundTransparency=1,
        Position=UDim2.new(1,-12,.5,0),AnchorPoint=Vector2.new(1,.5),
        Size=UDim2.new(.48,-12,1,0),TextXAlignment=Enum.TextXAlignment.Right,ZIndex=9})
    piVals[field]=vl
end

-- Notes
local NoteLbl=mk("TextLabel",{Parent=RC,Text="Notes",TextColor3=C.t0,
    Font=Enum.Font.GothamBold,TextSize=13,BackgroundTransparency=1,
    Position=UDim2.new(0,14,0,354),Size=UDim2.new(1,-28,0,22),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7,Visible=false})
local NoteBox=mk("Frame",{Parent=RC,BackgroundColor3=C.bg2,BorderSizePixel=0,
    Position=UDim2.new(0,14,0,384),Size=UDim2.new(1,-28,0,52),ZIndex=7,Visible=false})
cr(10,NoteBox) st(C.brd,1,NoteBox)
local NoteInput=mk("TextBox",{Parent=NoteBox,PlaceholderText="Add a note...",
    PlaceholderColor3=C.t2,Text="",TextColor3=C.t0,Font=Enum.Font.Gotham,TextSize=12,
    BackgroundTransparency=1,Position=UDim2.new(0,12,0,0),Size=UDim2.new(1,-50,1,0),
    ClearTextOnFocus=false,ZIndex=8,TextXAlignment=Enum.TextXAlignment.Left})
local SaveNoteBtn=mk("TextButton",{Parent=NoteBox,Text="💾",TextColor3=C.t1,
    Font=Enum.Font.Gotham,TextSize=16,BackgroundTransparency=1,
    Position=UDim2.new(1,-42,.5,0),AnchorPoint=Vector2.new(0,.5),
    Size=UDim2.new(0,32,0,32),ZIndex=8})
SaveNoteBtn.MouseButton1Click:Connect(function()
    if S.sel then
        S.notes[S.sel.Name]=NoteInput.Text
        toast("Note Saved","Saved note for @"..S.sel.Name)
    end
end)

-- Show/hide detail
local function showDetail(v)
    PHdr.Visible=v; StatsRow.Visible=v
    PALbl.Visible=v; ActSF.Visible=v
    PILbl.Visible=v; PIBox.Visible=v
    NoteLbl.Visible=v; NoteBox.Visible=v
    noSel.Visible=not v
end
showDetail(false)

-- Update toggle button states for selected player
local function updateActionBtns(p)
    if loopFlingTgt==p then
        lfLbl.Text="Stop Fling"
        tw(lfBtn,{BackgroundColor3=Color3.fromRGB(55,18,18)},.1)
    else
        lfLbl.Text="Loop Fling"
        tw(lfBtn,{BackgroundColor3=C.bg2},.1)
    end
    if headsitTgt==p and headsitActive then
        hsLbl.Text="Stop Headsit"
        tw(hsBtn,{BackgroundColor3=Color3.fromRGB(55,18,18)},.1)
    else
        hsLbl.Text="Headsit"
        tw(hsBtn,{BackgroundColor3=C.bg2},.1)
    end
end

-- Populate player detail panel
local function selectPlayer(p)
    S.sel=p
    showDetail(true)
    pName.Text=p.Name
    pHandle.Text="@"..p.Name.."  •  "..tostring(p.UserId)
    task.spawn(function() pAv.Image=thumb(p.UserId) end)
    cpBtn.MouseButton1Click:Connect(function()
        pcall(setclipboard,tostring(p.UserId))
        toast("Copied","User ID: "..p.UserId)
    end)
    piVals["Username"].Text     = p.Name
    piVals["Display Name"].Text = p.DisplayName
    piVals["User ID"].Text      = tostring(p.UserId)
    piVals["Account Age"].Text  = tostring(p.AccountAge).." days"
    piVals["Friends"].Text      = "—"
    piVals["Join Date"].Text    = joinDate(p)
    piVals["Last Online"].Text  = "Now"
    piVals["Game"].Text         = game.Name or "Unknown"
    statVals["Join Date"].Text  = joinDate(p)
    statVals["Last Seen"].Text  = "Now"
    statVals["Playtime"].Text   = "—"
    statVals["Rank"].Text       = "Member"
    NoteInput.Text = S.notes[p.Name] or ""
    updateActionBtns(p)
end

-- Build one player row in left list
local function buildEntry(p)
    local row=mk("TextButton",{Parent=PSF,Text="",BackgroundColor3=C.bg1,
        BorderSizePixel=0,Size=UDim2.new(1,0,0,62),ZIndex=7})
    cr(8,row) st(C.brd,1,row)
    local av=mk("ImageLabel",{Parent=row,BackgroundColor3=C.bg3,
        Position=UDim2.new(0,10,.5,0),AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(0,40,0,40),ZIndex=8})
    cr(20,av)
    task.spawn(function() av.Image=thumb(p.UserId) end)
    local dot=mk("Frame",{Parent=row,BackgroundColor3=C.grn,
        Position=UDim2.new(0,42,.5,14),AnchorPoint=Vector2.new(.5,.5),
        Size=UDim2.new(0,9,0,9),ZIndex=9})
    cr(5,dot) st(C.bg1,2,dot)
    mk("TextLabel",{Parent=row,Text=p.Name,TextColor3=C.t0,Font=Enum.Font.GothamBold,
        TextSize=13,BackgroundTransparency=1,Position=UDim2.new(0,58,0,12),
        Size=UDim2.new(1,-70,0,20),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8})
    mk("TextLabel",{Parent=row,Text="@"..p.Name.."  •  "..p.UserId,TextColor3=C.t1,
        Font=Enum.Font.Gotham,TextSize=10,BackgroundTransparency=1,
        Position=UDim2.new(0,58,0,32),Size=UDim2.new(1,-70,0,16),
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8})
    row.MouseEnter:Connect(function()
        if S.sel~=p then tw(row,{BackgroundColor3=C.bg3},.1) end
    end)
    row.MouseLeave:Connect(function()
        if S.sel~=p then tw(row,{BackgroundColor3=C.bg1},.1) end
    end)
    row.MouseButton1Click:Connect(function()
        for _,e in ipairs(S.entries) do
            if e.btn and e.btn.Parent then tw(e.btn,{BackgroundColor3=C.bg1},.1) end
        end
        tw(row,{BackgroundColor3=C.bg4},.1)
        selectPlayer(p)
    end)
    return row
end

local function refreshList(filter)
    for _,e in ipairs(S.entries) do
        if e.btn and e.btn.Parent then e.btn:Destroy() end
    end
    S.entries={}
    local f=filter and filter:lower() or ""
    for _,p in ipairs(Plrs:GetPlayers()) do
        if f=="" or p.Name:lower():find(f,1,true) or p.DisplayName:lower():find(f,1,true) then
            local btn=buildEntry(p)
            table.insert(S.entries,{p=p,btn=btn})
        end
    end
end
refreshList()

srch:GetPropertyChangedSignal("Text"):Connect(function() refreshList(srch.Text) end)
Plrs.PlayerAdded:Connect(function() task.wait(.5) refreshList(srch.Text) end)
Plrs.PlayerRemoving:Connect(function(p)
    if S.sel==p then showDetail(false) S.sel=nil end
    task.wait() refreshList(srch.Text)
end)

-- ═══════════════════════════════════════════════════════════════════════
-- COMMANDS PAGE
-- ═══════════════════════════════════════════════════════════════════════
local CmdsPage=mk("Frame",{Parent=CFR,BackgroundTransparency=1,
    Size=UDim2.fromScale(1,1),ZIndex=6,Visible=false})

local csrch=mk("TextBox",{Parent=CmdsPage,PlaceholderText="  🔍 Search commands...",
    PlaceholderColor3=C.t2,Text="",TextColor3=C.t0,Font=Enum.Font.Gotham,TextSize=13,
    BackgroundColor3=C.bg2,BorderSizePixel=0,
    Position=UDim2.new(0,14,0,12),Size=UDim2.new(1,-28,0,42),
    ClearTextOnFocus=false,ZIndex=7})
cr(8,csrch) st(C.brd,1,csrch)

local CSF=mk("ScrollingFrame",{Parent=CmdsPage,BackgroundTransparency=1,
    Position=UDim2.new(0,14,0,64),Size=UDim2.new(1,-28,1,-72),
    ScrollBarThickness=3,ScrollBarImageColor3=C.bg4,BorderSizePixel=0,
    ZIndex=7,CanvasSize=UDim2.new(0,0,0,0)})
local CSL=mk("UIListLayout",{Parent=CSF,Padding=UDim.new(0,5),
    SortOrder=Enum.SortOrder.LayoutOrder})
CSL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    CSF.CanvasSize=UDim2.new(0,0,0,CSL.AbsoluteContentSize.Y+8)
end)

-- Track built cmd rows for perf
local function buildCmdList(filter)
    for _,c in ipairs(CSF:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextButton") then c:Destroy() end
    end
    local f=filter and filter:lower() or ""
    local order=0
    for _,cmd in ipairs(CMDS) do
        if f=="" or cmd.n:lower():find(f,1,true) or (cmd.d and cmd.d:lower():find(f,1,true)) then
            order=order+1
            local cb=mk("TextButton",{Parent=CSF,Text="",BackgroundColor3=C.bg2,
                BorderSizePixel=0,Size=UDim2.new(1,0,0,58),LayoutOrder=order,ZIndex=8})
            cr(8,cb) st(C.brd,1,cb)
            mk("TextLabel",{Parent=cb,Text=cmd.n,TextColor3=C.t0,Font=Enum.Font.GothamBold,
                TextSize=13,BackgroundTransparency=1,
                Position=UDim2.new(0,14,0,8),Size=UDim2.new(1,-44,0,20),
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=9})
            mk("TextLabel",{Parent=cb,Text=cmd.d or "",TextColor3=C.t1,Font=Enum.Font.Gotham,
                TextSize=11,BackgroundTransparency=1,
                Position=UDim2.new(0,14,0,30),Size=UDim2.new(1,-44,0,18),
                TextXAlignment=Enum.TextXAlignment.Left,ZIndex=9})
            mk("TextLabel",{Parent=cb,Text="›",TextColor3=C.t2,Font=Enum.Font.Gotham,TextSize=20,
                BackgroundTransparency=1,Position=UDim2.new(1,-28,.5,0),AnchorPoint=Vector2.new(0,.5),
                Size=UDim2.new(0,18,0,18),ZIndex=9})
            cb.MouseEnter:Connect(function() tw(cb,{BackgroundColor3=C.bg3},.1) end)
            cb.MouseLeave:Connect(function() tw(cb,{BackgroundColor3=C.bg2},.1) end)
            cb.MouseButton1Click:Connect(function()
                if CmdInput then CmdInput.Text=cmd.n.." "; CmdInput:CaptureFocus() end
            end)
        end
    end
end
buildCmdList()
csrch:GetPropertyChangedSignal("Text"):Connect(function() buildCmdList(csrch.Text) end)

-- ═══════════════════════════════════════════════════════════════════════
-- SETTINGS PAGE
-- ═══════════════════════════════════════════════════════════════════════
local SettPage=mk("Frame",{Parent=CFR,BackgroundTransparency=1,
    Size=UDim2.fromScale(1,1),ZIndex=6,Visible=false})

local settRows={
    {lbl="Toggle Hotkey",   val="RightShift"},
    {lbl="Command Prefix",  val="! or /"},
    {lbl="Version",         val="NX 1.0"},
    {lbl="Executor Mode",   val="Client-Side"},
    {lbl="Panel Theme",     val="Dark"},
    {lbl="Admin Log",       val="Enabled"},
}
mk("TextLabel",{Parent=SettPage,Text="Settings",TextColor3=C.t0,
    Font=Enum.Font.GothamBold,TextSize=15,BackgroundTransparency=1,
    Position=UDim2.new(0,18,0,16),Size=UDim2.new(1,-36,0,28),
    TextXAlignment=Enum.TextXAlignment.Left,ZIndex=7})

for i,si in ipairs(settRows) do
    local sf=mk("Frame",{Parent=SettPage,BackgroundColor3=C.bg2,BorderSizePixel=0,
        Position=UDim2.new(0,18,0,52+(i-1)*52),Size=UDim2.new(1,-36,0,44),ZIndex=7})
    cr(8,sf) st(C.brd,1,sf)
    mk("TextLabel",{Parent=sf,Text=si.lbl,TextColor3=C.t0,Font=Enum.Font.Gotham,TextSize=13,
        BackgroundTransparency=1,Position=UDim2.new(0,14,.5,0),AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(.6,0,1,0),TextXAlignment=Enum.TextXAlignment.Left,ZIndex=8})
    mk("TextLabel",{Parent=sf,Text=si.val,TextColor3=C.t1,Font=Enum.Font.Gotham,TextSize=13,
        BackgroundTransparency=1,Position=UDim2.new(1,-14,.5,0),AnchorPoint=Vector2.new(1,.5),
        Size=UDim2.new(.4,-28,1,0),TextXAlignment=Enum.TextXAlignment.Right,ZIndex=8})
end

-- ─── TAB SWITCHING ───────────────────────────────────────────────────────────
local pages={Commands=CmdsPage,Players=PlayersPage,Settings=SettPage}
local function setTab(id)
    S.tab=id
    for tid,btn in pairs(tabBtns) do
        btn.TextColor3=(tid==id) and C.t0 or C.t1
        tabInds[tid].Visible=(tid==id)
    end
    for pid,pg in pairs(pages) do pg.Visible=(pid==id) end
end
setTab("Players")
for id,btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function() setTab(id) end)
end

-- Close button
local panelOpen=true
closeB.MouseButton1Click:Connect(function()
    panelOpen=false
    tw(P,{Size=UDim2.new(0,1080,0,0)},.16)
    task.delay(.18,function() P.Visible=false end)
end)

-- ─── FLOATING COMMAND BAR ────────────────────────────────────────────────────
local CmdBar=mk("Frame",{Parent=G,BackgroundColor3=C.bg2,BorderSizePixel=0,
    Position=UDim2.new(.5,0,.93,0),AnchorPoint=Vector2.new(.5,.5),
    Size=UDim2.new(0,660,0,50),ZIndex=10})
cr(14,CmdBar) st(C.brd,1,CmdBar)

local CmdPfx=mk("TextButton",{Parent=CmdBar,Text="›",TextColor3=C.t0,
    Font=Enum.Font.GothamBold,TextSize=16,BackgroundColor3=C.bg4,BorderSizePixel=0,
    Position=UDim2.new(0,0,.5,0),AnchorPoint=Vector2.new(0,.5),
    Size=UDim2.new(0,46,0,46),ZIndex=11})
cr(11,CmdPfx)

CmdInput=mk("TextBox",{Parent=CmdBar,PlaceholderText="Type a command...",
    PlaceholderColor3=C.t2,Text="",TextColor3=C.t0,Font=Enum.Font.Gotham,TextSize=14,
    BackgroundTransparency=1,Position=UDim2.new(0,52,0,0),
    Size=UDim2.new(1,-100,1,0),ClearTextOnFocus=false,ZIndex=11})
mk("UIPadding",{PaddingLeft=UDim.new(0,8)},CmdInput)

local CmdSend=mk("TextButton",{Parent=CmdBar,Text="✈",TextColor3=C.t0,
    Font=Enum.Font.Gotham,TextSize=17,BackgroundTransparency=1,
    Position=UDim2.new(1,-44,.5,0),AnchorPoint=Vector2.new(0,.5),
    Size=UDim2.new(0,36,0,36),ZIndex=11})
CmdSend.MouseEnter:Connect(function() tw(CmdSend,{TextColor3=C.t1},.1) end)
CmdSend.MouseLeave:Connect(function() tw(CmdSend,{TextColor3=C.t0},.1) end)

-- Prefix cycle
CmdPfx.MouseButton1Click:Connect(function()
    local cycle={"›","!","/"}
    local cur=CmdPfx.Text
    for i,v in ipairs(cycle) do
        if v==cur then CmdPfx.Text=cycle[(i%#cycle)+1] return end
    end
    CmdPfx.Text=cycle[1]
end)

-- ─── COMMAND EXECUTOR ────────────────────────────────────────────────────────
local function execCmd(raw)
    if not raw or raw:match("^%s*$") then return end
    raw=raw:gsub("^[!/›]",""):match("^%s*(.-)%s*$")
    local parts={}
    for w in raw:gmatch("%S+") do parts[#parts+1]=w end
    if #parts==0 then return end
    local cmd=parts[1]:lower()
    local arg2=parts[2]
    local arg3=parts[3]
    local target
    if arg2 then
        if arg2:lower()=="me" then target=LP
        else target=findPlr(arg2) end
    end
    if not target then target=S.sel or LP end
    lastCmd=raw
    local fn=H[cmd]
    if fn then
        local ok,err=pcall(fn,target,arg2,arg3)
        if ok then
            toast("Nexus Admin",cmd..(target and target~=LP and " → "..target.Name or ""))
        else
            toast("Error",tostring(err):sub(1,80))
        end
    else
        -- Try loadstring for unknown commands
        toast("Unknown","'"..cmd.."' not found. Type a valid NX command.")
    end
    CmdInput.Text=""
end

CmdSend.MouseButton1Click:Connect(function() execCmd(CmdInput.Text) end)
CmdInput.FocusLost:Connect(function(enter)
    if enter then execCmd(CmdInput.Text) end
end)

-- ─── TOGGLE  RightShift ──────────────────────────────────────────────────────
UIS.InputBegan:Connect(function(i,proc)
    if proc then return end
    if i.KeyCode==Enum.KeyCode.RightShift then
        panelOpen=not panelOpen
        if panelOpen then
            P.Visible=true
            tw(P,{Size=UDim2.new(0,1080,0,640)},.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        else
            tw(P,{Size=UDim2.new(0,1080,0,0)},.15)
            task.delay(.17,function() P.Visible=false end)
        end
    end
end)

-- ─── LOAD TOAST ──────────────────────────────────────────────────────────────
task.delay(.5,function()
    toast("Nexus Admin Loaded!","You can now use the NX commands.")
end)