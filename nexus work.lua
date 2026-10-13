--[[
    ═══════════════════════════════════════════
    ADMIN COMMANDS PANEL  ·  No Actions Build
    Toggle  : RightShift
    ═══════════════════════════════════════════
--]]

local Plrs   = game:GetService("Players")
local TweenS = game:GetService("TweenService")
local UIS    = game:GetService("UserInputService")
local LP     = Plrs.LocalPlayer

-- ─── THEME ───────────────────────────────────────────────────────────────────
local C = {
    bg0 = Color3.fromRGB( 8,  8,  8),
    bg1 = Color3.fromRGB(14, 14, 14),
    bg2 = Color3.fromRGB(20, 20, 20),
    bg3 = Color3.fromRGB(28, 28, 28),
    bg4 = Color3.fromRGB(38, 38, 38),
    t0  = Color3.fromRGB(255,255,255),
    t1  = Color3.fromRGB(150,150,150),
    t2  = Color3.fromRGB(68,  68,  68),
    grn = Color3.fromRGB(34, 197, 94),
    brd = Color3.fromRGB(34,  34,  34),
}

-- ─── COMMANDS LIST (send yours and I'll wire the handlers) ───────────────────
local CMDS = {
    {n="unload",                    d="Unload Nameless Admin and clean up its active runtime"},
    {n="pluginmaker",               d="Open the no-code .na/.iy plugin builder"},
    {n="addallplugins",             d="Move all .na/.iy plugins to Nameless-Admin folders, then load them"},
    {n="addplugin",                 d="Move one .na to Plugins or one .iy to PluginsIY, then load it"},
    {n="reloadplugin",              d="Reload plugin files (reloads all if no name provided)"},
    {n="removeplugin",              d="Move a plugin file from Nameless-Admin back to workspace"},
    {n="removeallplugins",          d="Move all plugins from Nameless-Admin back to workspace"},
    {n="cmdbar2",                   d="Opens a HD-Admin style cmdbar (black & white)"},
    {n="url",                       d="Run a script using a URL"},
    {n="loadstring",                d="Run code using loadstring"},
    {n="nocooldown",                d="Override game-script cooldown timing with chosen seconds; defaults to 0"},
    {n="unnocooldown",              d="Disable the game-script cooldown timing override"},
    {n="waitcap",                   d="Cap game-script wait/delay durations without shortening waits below the cap"},
    {n="unwaitcap",                 d="Disable the game-script wait/delay cap"},
    {n="notween",                   d="Force all TweenService tweens to chosen duration; defaults to 0"},
    {n="unnotween",                 d="Stop overriding game-created tween durations"},
    {n="gcsearch",                  d="Search getgc tables, function metadata, constants, and upvalues for text"},
    {n="autopatchtool",             d="Aggressively patch cooldown, reload, recoil, spread, ammo, fire-rate, range, and damage for a tool"},
    {n="patchtool",                 d="Lightweight tool patcher for cooldown, reload, recoil, spread, ammo, fire-rate, range, or damage"},
    {n="unpatchtool",               d="Restore values changed by Patch Tool and disable its guards"},
    {n="unautopatchtool",           d="Restore values changed by Auto Patch Tool and disable its guards"},
    {n="tailsway",                  d="Load the TailSway physics/wagging script"},
    {n="scriptlogger",              d="Load SecureScripts Logger before running a suspicious script"},
    {n="tas",                       d="Launch TAS Recorder Redux; optionally auto-load and play a saved run"},
    {n="scriptload",                d="Run a saved script from the NA executor saved scripts folder"},
    {n="shaders",                   d="Enable a shader preset for Lighting"},
    {n="unshaders",                 d="Disable the shader preset and restore Lighting"},
    {n="ibtools",                   d="Load the iBuild Tools helper tool"},
    {n="unibtools",                 d="Remove the iBuild Tools helper tool"},
    {n="setfflag",                  d="Set a fast flag (use 'save' to store it)"},
    {n="addalias",                  d="Add a persistent alias for an existing command"},
    {n="removealias",               d="Select and remove a saved alias"},
    {n="clearaliases",              d="Remove all aliases created using addalias"},
    {n="addbutton",                 d="Add a mobile button"},
    {n="removebutton",              d="Remove a user button"},
    {n="clearbuttons",              d="Clear all user buttons"},
    {n="addautoexec",               d="Add a command to autoexecute"},
    {n="removeautoexec",            d="Remove a command from autoexecute"},
    {n="clearautoexec",             d="Clear all AutoExec commands"},
    {n="executor",                  d="Toggle the integrated executor UI"},
    {n="lastcommand",               d="Re-run your previously executed command"},
    {n="ifundone",                  d="Run a command only if that exact command has not been done this session"},
    {n="commandloop",               d="Start a command loop"},
    {n="stoploop",                  d="Stop a running loop"},
    {n="scripthub",                 d="Open the built-in Script Hub"},
    {n="gamescripts",               d="Show scripts listed for the current game"},
    {n="uiscale",                   d="Adjust the scale of the UI"},
    {n="prefix",                    d="Change the admin prefix"},
    {n="saveprefix",                d="Save the prefix to a file and apply it"},
    {n="chatlogs",                  d="Open the chat logs"},
    {n="music",                     d="Open the NA music player"},
    {n="gotocampos",                d="Teleport to your camera position (works with free cam but freezes you)"},
    {n="teleportgui",               d="Open the universe subplace and public-server viewer"},
    {n="imagescanner",              d="Show a UI that grabs all images in the game"},
    {n="audiologger",               d="Show a UI that grabs all audios in the game"},
    {n="serverremotespy",           d="Show a UI that logs all remotes called from the server"},
    {n="cig",                       d="Give a cigarette pack (client R6)"},
    {n="cigar",                     d="Give a cigar (client R6)"},
    {n="pipe",                      d="Give a smoking pipe (client R6)"},
    {n="discord",                   d="Copy an invite link"},
    {n="clickfling",                d="Fling a player by clicking them"},
    {n="unclickfling",              d="Disable clickfling"},
    {n="offset",                    d="Offset and rotate your character for others"},
    {n="upsidedown",                d="Flip your character upside down for others"},
    {n="unoffset",                  d="Disable offset customization and restore your character"},
    {n="unupsidedown",              d="Disable upside down replication and restore your character"},
    {n="clickscare",                d="Teleport next to a clicked player for a few seconds"},
    {n="unclickscare",              d="Disable clickscare"},
    {n="hovername",                 d="Show player's username on hover"},
    {n="unhovername",               d="Disable hovername"},
    {n="hoverinventory",            d="Show a player's inventory on hover"},
    {n="unhoverinventory",          d="Disable hoverinventory"},
    {n="resetfilter",               d="Reset the filter if Roblox keeps tagging your messages"},
    {n="ping",                      d="Show your network latency"},
    {n="fps",                       d="Show your frames per second"},
    {n="fpsping",                   d="Show the legacy FPS and ping panel"},
    {n="stats",                     d="Show FPS, physics, network and memory stats"},
    {n="speedometer",               d="Toggle a NA-themed speedometer"},
    {n="closespeedometer",          d="Close the speedometer"},
    {n="commands",                  d="Open the command list"},
    {n="settings",                  d="Open the settings menu"},
    {n="commandkeybinds",           d="Open the command keybinds window"},
    {n="inspectoutfit",             d="Open a user's saved outfits and inspect a selected outfit"},
    {n="avatarpreview",             d="Create a client-only avatar preview rig"},
    {n="char",                      d="Transform your client character to a user's avatar appearance"},
    {n="unchar",                    d="Restore your appearance"},
    {n="clearavatarpreview",        d="Remove the client-only avatar preview rig"},
    {n="waypoints",                 d="Open the waypoints menu"},
    {n="binders",                   d="Open the event binder menu"},
    {n="showwaypoints",             d="Show saved waypoint ESP markers for this place"},
    {n="hidewaypoints",             d="Hide saved waypoint ESP markers"},
    {n="showpathwaypoint",          d="Show PathfindingService route nodes to a saved waypoint"},
    {n="hidepathwaypoint",          d="Hide waypoint path route nodes and stop pathfinding"},
    {n="pathfindwaypoint",          d="Pathfind to a saved waypoint and show the route nodes"},
    {n="looppath",                  d="Continuously path to a saved waypoint after death or respawn"},
    {n="looptweenpath",             d="Loop path to a waypoint using tween movement"},
    {n="loopteleportpath",          d="Loop path to a waypoint by teleporting between route nodes"},
    {n="loopwalkpath",              d="Loop path to a waypoint using walking movement"},
    {n="unlooppath",                d="Stop persistent waypoint pathfinding"},
    {n="looppathtweenspeed",        d="Set loop path tween speed in studs per second"},
    {n="looppathteleportdelay",     d="Set loop path teleport delay between route nodes"},
    {n="setwaypoint",               d="Store your current position or create/update with custom coords"},
    {n="setwaypointpos",            d="Create or edit a waypoint using custom coordinates"},
    {n="gotowaypoint",              d="Teleport to a saved waypoint"},
    {n="removewaypoint",            d="Remove a saved waypoint"},
    {n="chardebug",                 d="Debug your character"},
    {n="unchardebug",               d="Disable character debug"},
    {n="naked",                     d="Remove clothing from your character"},
    {n="somersault",                d="Makes you do a clean front flip"},
    {n="unsomersault",              d="Disable somersault button and keybind"},
    {n="rolewatch",                 d="Notify if someone from a watched group joins with a specific role"},
    {n="rolewatchstop",             d="Disable Rolewatch monitoring"},
    {n="rolewatchleave",            d="Toggle leaving the server if the watched role joins"},
    {n="joingroup",                 d="Open the join prompt for a group"},
    {n="trackstaff",                d="Track, highlight, and notify when a staff member joins"},
    {n="stoptrackstaff",            d="Stop tracking staff members"},
    {n="antistaff",                 d="Automatically leave or serverhop when staff is detected"},
    {n="unantistaff",               d="Disable automatic staff avoidance"},
    {n="rewind",                    d="Enable rewind with hold-R on PC or a draggable mobile button"},
    {n="unrewind",                  d="Disable rewind and clear its saved frames"},
    {n="rewindspeed",               d="Set rewind frames skipped per heartbeat"},
    {n="rewindtime",                d="Set how many seconds rewind stores"},
    {n="freemouse",                 d="Toggle cursor unlock while world model first person is active"},
    {n="hideacc",                   d="Hide or restore local accessory parts"},
    {n="backview",                  d="Flip the camera behind you and invert movement controls"},
    {n="worldmodelfp",              d="WFCP world-model first person camera"},
    {n="frontview",                 d="Reset WFCP camera state and return to a normal front view"},
    {n="deletevelocity",            d="Remove any velocity/force instances on your character"},
    {n="screenorientation",         d="Manage ScreenOrientation"},
    {n="sensorrotationscreen",      d="Change ScreenOrientation to Sensor"},
    {n="landscaperotationscreen",   d="Change ScreenOrientation to Landscape Sensor"},
    {n="portraitrotationscreen",    d="Change ScreenOrientation to Portrait"},
    {n="defaultrotationscreen",     d="Change ScreenOrientation to Default"},
    {n="commandcount",              d="Count how many commands NA has"},
    {n="flyfling",                  d="Makes you fly and fling"},
    {n="unflyfling",                d="Stops fly and fling"},
    {n="walkfling",                 d="Probably the best fling"},
    {n="unwalkfling",               d="Stop the walkfling command"},
    {n="touchfling",                d="Walkfling only when touching a player or NPC"},
    {n="untouchfling",              d="Stop the touchfling command"},
    {n="rjre",                      d="Rejoin and teleport to your previous position"},
    {n="cancelteleport",            d="Cancel an in-progress teleport and dismiss the teleport UI"},
    {n="cancelteleportloop",        d="Repeatedly cancel in-progress teleports"},
    {n="uncancelteleportloop",      d="Disable cancelteleport loop"},
    {n="rejoin",                    d="Rejoin the game"},
    {n="teleporttoplace",           d="Teleport to a place using PlaceId"},
    {n="adonisbypass",              d="Bypass Adonis admin detection"},
    {n="antinil",                   d="Prevent your character from being parented to nil"},
    {n="unantinil",                 d="Stop preventing your character from being parented to nil"},
    {n="nilchar",                   d="Parent your character to nil"},
    {n="unnilchar",                 d="Restore your nil-parented character"},
    {n="accountage",                d="Show the account age of a player in the server"},
    {n="hitboxes",                  d="Show all hitboxes"},
    {n="unhitboxes",                d="Remove the hitboxes outline"},
    {n="vfly",                      d="Fly vehicles"},
    {n="unvfly",                    d="Disable vehicle fly"},
    {n="equiptools",                d="Equip all of your tools"},
    {n="usetools",                  d="Equip all tools, use them, then unequip them"},
    {n="settweenspeed",             d="Set how long tween teleport commands take"},
    {n="tpup",                      d="Teleport up by the given amount of studs"},
    {n="tpdown",                    d="Teleport down by the given amount of studs"},
    {n="tweento",                   d="Teleport method that bypasses some anticheats"},
    {n="reach",                     d="Extend sword reach in one direction"},
    {n="boxreach",                  d="Create a box-shaped hitbox around your tool"},
    {n="resetreach",                d="Reset tool to normal size"},
    {n="aura",                      d="Continuously damage all nearby humanoid targets with equipped tool"},
    {n="unaura",                    d="Stop aura loop and remove visualizer"},
    {n="npcaura",                   d="Continuously damage nearby NPCs with equipped tool"},
    {n="unnpcaura",                 d="Stop NPC aura loop and remove visualizer"},
    {n="antivoid",                  d="Prevent falling into the void by launching you upwards"},
    {n="unantivoid",                d="Disable antivoid"},
    {n="nofall",                    d="Prevent fall damage by slowing falls (BETA)"},
    {n="unnofall",                  d="Disable nofall"},
    {n="fakeout",                   d="Teleport to void and back"},
    {n="invisfling",                d="Enable invisible fling"},
    {n="split",                     d="Destroy waist joint"},
    {n="antivoid2",                 d="Set FallenPartsDestroyHeight to -inf"},
    {n="unantivoid2",               d="Revert FallenPartsDestroyHeight"},
    {n="antivelocity",              d="Limit your character's velocity to the provided value"},
    {n="unantivelocity",            d="Disable the antivelocity limiter"},
    {n="antivelocityinstances",     d="Continuously destroy force/velocity mover instances inside your character"},
    {n="unantivelocityinstances",   d="Stop removing force and velocity mover instances from your character"},
    {n="antiknockback",             d="Disable knockback"},
    {n="unantiknockback",           d="Disable antiknockback"},
    {n="showcom",                   d="Create a glass sphere with a Highlight at your center of mass"},
    {n="predict",                   d="Visualize predicted player movement"},
    {n="unpredict",                 d="Remove prediction orb"},
    {n="hidecom",                   d="Remove COM tracker"},
    {n="droptool",                  d="Drop one of your tools"},
    {n="droptools",                 d="Drop all of your tools"},
    {n="loopdroptools",             d="Loop drop your tools"},
    {n="unloopdroptools",           d="Stop loop dropping tools"},
    {n="notools",                   d="Remove your tools"},
    {n="fpsbooster",                d="Toggle low graphics using your FPSBooster settings"},
    {n="annoy",                     d="Annoy the given player or NPC"},
    {n="unannoy",                   d="Stop the annoy command"},
    {n="deleteinvisparts",          d="Delete invisible parts"},
    {n="invisibleparts",            d="Show invisible parts"},
    {n="uninvisibleparts",          d="Make parts affected by invisparts return to normal"},
    {n="datalimit",                 d="Set outgoing bandwidth limit in KBps"},
    {n="removeads",                 d="Remove billboard advertisements as they appear"},
    {n="unremoveads",               d="Stop removing billboard advertisements"},
    {n="reloadassets",              d="Set RenderSettings.ReloadAssets"},
    {n="enginesettingsinfo",        d="Show Roblox settings service diagnostics"},
    {n="replicationlag",            d="Set IncomingReplicationLag"},
    {n="animdata",                  d="Show information about your current animations"},
    {n="unanimdata",                d="Disable animdata"},
    {n="sleepon",                   d="Enable AllowSleep"},
    {n="unsleepon",                 d="Disable AllowSleep"},
    {n="throttle",                  d="Set PhysicsEnvironmentalThrottle (1=default, 2=disabled)"},
    {n="quality",                   d="Manage rendering quality settings (1-21)"},
    {n="logphysics",                d="Enable Physics Error Logging"},
    {n="nologphysics",              d="Disable Physics Error Logging"},
    {n="norender",                  d="Disable 3D rendering to decrease CPU usage"},
    {n="render",                    d="Enable 3D rendering"},
    {n="noreset",                   d="Disable reset button"},
    {n="resetbtn",                  d="Enable reset button"},
    {n="loopoof",                   d="Loop everyone's character sounds (everyone can hear)"},
    {n="unloopoof",                 d="Stop the oof chaos"},
    {n="strengthen",                d="Make your character more dense (CustomPhysicalProperties)"},
    {n="unweaken",                  d="Set your character's CustomPhysicalProperties to default"},
    {n="weaken",                    d="Make your character less dense"},
    {n="setmass",                   d="Set your character mass as close as Roblox allows"},
    {n="seat",                      d="Find a seat and automatically sit on it"},
    {n="vehicleseat",               d="Sit in a vehicle seat"},
    {n="copytools",                 d="Copy the tools the given player has"},
    {n="localtime",                 d="Show your current time"},
    {n="localdate",                 d="Show your current date"},
    {n="servertime",                d="Show the server's current time"},
    {n="serverdate",                d="Show the server's current date"},
    {n="datetime",                  d="Show your full local date and time"},
    {n="uptime",                    d="Show how long the game/session has been running"},
    {n="timestamp",                 d="Show current Unix timestamp"},
    {n="cartornado",                d="Tornado a car — just sit in it"},
    {n="unspam",                    d="Stop all attempts to lag/spam"},
    {n="unctest",                   d="Test how many functions your executor supports"},
    {n="vulnerabilitytest",         d="Test if your executor is vulnerable"},
    {n="respawn",                   d="Respawn your character"},
    {n="antisit",                   d="Prevent the player from sitting"},
    {n="unantisit",                 d="Allow the player to sit again"},
    {n="antikick",                  d="Bypass kick on most games"},
    {n="antiteleport",              d="Prevent TeleportService from moving you to another place"},
    {n="unantikick",                d="Disable Anti-Kick protection"},
    {n="unantiteleport",            d="Disable Anti-Teleport protection"},
    {n="anticframeteleport",        d="Prevent client teleports"},
    {n="unanticframeteleport",      d="Disable Anti CFrame Teleport"},
    {n="lay",                       d="Lay down"},
    {n="trip",                      d="Trip your character"},
    {n="permtrip",                  d="Permanent trip that keeps you down"},
    {n="unpermtrip",                d="Disable permanent trip"},
    {n="antitrip",                  d="Prevent tripping/ragdolling"},
    {n="unantitrip",                d="Allow tripping again"},
    {n="disablehumanoidstate",      d="Open a picker to disable one humanoid state"},
    {n="enablehumanoidstate",       d="Restore one humanoid state or all disabled states"},
    {n="checkrfe",                  d="Check if the game has respect filtering enabled off"},
    {n="sit",                       d="Sit your player"},
    {n="oldroblox",                 d="Old skybox and studs"},
    {n="unoldroblox",               d="Restore skybox and studs"},
    {n="2012",                      d="Make your CoreGui look like the 2012 CoreGui"},
    {n="2013",                      d="Make your CoreGui look like the 2013 CoreGui"},
    {n="2014",                      d="Make your CoreGui look like the 2014 CoreGui"},
    {n="2015",                      d="Make your CoreGui look like the 2015 CoreGui"},
    {n="2016",                      d="Make your CoreGui look like the 2016 CoreGui"},
    {n="f3x",                       d="F3X for client"},
    {n="telekinesis",               d="Tool that controls unanchored parts"},
    {n="triggerbot",                d="Automatically click when the mouse is on a player"},
    {n="setspawn",                  d="Set your spawn point to your current position"},
    {n="disablespawn",              d="Disable the previously set spawn point"},
    {n="autoflashback",             d="Auto-teleport to your last death point on respawn"},
    {n="unautoflashback",           d="Disable auto deathpos"},
    {n="flashback",                 d="Teleport to your last death point"},
    {n="flashbackalt",              d="Teleport to the 0 HP flashback point"},
    {n="autoflashbackalt",          d="Auto-teleport to the 0 HP flashback point on respawn"},
    {n="unautoflashbackalt",        d="Disable auto flashback alt"},
    {n="tospawn",                   d="Teleport to a SpawnLocation"},
    {n="hamster",                   d="Hamster ball"},
    {n="unhamster",                 d="Disable hamster ball"},
    {n="antiafk",                   d="Prevent being kicked for being AFK"},
    {n="unantiafk",                 d="Allow being kicked for being AFK"},
    {n="tptool",                    d="Create click/tween teleport buttons or backpack tools"},
    {n="unclicktptool",             d="Remove teleport buttons or tools"},
    {n="clickteleport",             d="Bind-only click teleport (hold bind + left click)"},
    {n="clickdelete",               d="Bind-only click delete (hold bind + left click)"},
    {n="thru",                      d="Move forward by distance"},
    {n="olddex",                    d="View parts, GUIs, scripts and more"},
    {n="dex",                       d="Better version of Dex explorer"},
    {n="minimap",                   d="Show a minimap"},
    {n="animationplayer",           d="Dropdown menu with all game animations to play"},
    {n="decompiler",                d="Choose lua.expert or Luacid to decompile script bytecode"},
    {n="getidfromusername",         d="Copy a user's UserId by Username"},
    {n="getuserfromid",             d="Copy a user's Username by ID"},
    {n="ownerid",                   d="Mask yourself as the game owner's ID and Username"},
    {n="userid",                    d="Change your UserId to any ID you enter"},
    {n="username",                  d="Change your Username to any name you enter"},
    {n="spoofclientid",             d="Spoof GetClientId() to the value you provide"},
    {n="unspoofclientid",           d="Restore normal GetClientId() behavior"},
    {n="synapsedex",                d="Load SynapseX's Dex explorer"},
    {n="antifling",                 d="Make other players non-collidable with you"},
    {n="unantifling",               d="Restore collision for other players"},
    {n="antiflingparts",            d="Disable collision on nearby unanchored parts above velocity threshold"},
    {n="unantiflingparts",          d="Restore collision for unanchored parts changed by antiflingparts"},
    {n="gravitygun",                d="The best gravity gun script that's FE"},
    {n="lockws",                    d="Lock the whole workspace"},
    {n="unlockws",                  d="Unlock everything in Workspace"},
    {n="vehiclespeed",              d="Change the vehicle speed"},
    {n="unvehiclespeed",            d="Stop the vehiclespeed command"},
    {n="shiftlock",                 d="Toggle shiftlock"},
    {n="unshiftlock",               d="Disable shiftlock"},
    {n="enable",                    d="Enable a specific CoreGui"},
    {n="disable",                   d="Disable a specific CoreGui"},
    {n="reverb",                    d="Manage sound reverb settings"},
    {n="forcereverb",               d="Lock ambient reverb and auto-restore if changed"},
    {n="unforcereverb",             d="Stop forcing ambient reverb"},
    {n="cam",                       d="Manage camera type settings"},
    {n="forcecam",                  d="Lock camera type and auto-restore if changed"},
    {n="unforcecam",                d="Stop forcing camera type"},
    {n="alignmentkeys",             d="Enable alignment keys"},
    {n="disablealignmentkeys",      d="Disable alignment keys"},
    {n="esp",                       d="Locate where players are"},
    {n="espall",                    d="ESP all players and clear team filtering"},
    {n="espenemies",                d="ESP players outside your team"},
    {n="espallies",                 d="ESP players on your current team"},
    {n="espteam",                   d="ESP players in a specific team"},
    {n="chams",                     d="ESP but without the text"},
    {n="chamsenemies",              d="Chams players outside your team"},
    {n="chamsallies",               d="Chams players on your current team"},
    {n="chamsteam",                 d="Chams players in a specific team"},
    {n="locate",                    d="Locate specific players or NPCs"},
    {n="npcesp",                    d="Locate NPCs with highlights and labels"},
    {n="npcchams",                  d="Highlight NPCs without labels"},
    {n="unnpcesp",                  d="Disable NPC ESP or NPC Chams without changing player ESP"},
    {n="unesp",                     d="Disable ESP/Chams"},
    {n="unlocate",                  d="Stop locating a player or NPC"},
    {n="vehiclenoclip",             d="Disable vehicle collision"},
    {n="vehicleclip",               d="Enable vehicle collision"},
    {n="handlekill",                d="Kill a player or NPC using a tool that deals damage on touch"},
    {n="creep",                     d="Teleport behind a player or NPC from under the floor"},
    {n="netless",                   d="Execute netless to make scripts more stable"},
    {n="reset",                     d="Set your health to 0"},
    {n="gethealth",                 d="Show your current health"},
    {n="antibreakjoints",           d="Prevent local character joints from breaking"},
    {n="unantibreakjoints",         d="Disable AntiBreakJoints"},
    {n="breakjoints",               d="Break your character joints and die"},
    {n="desync",                    d="Toggle offset desync/sync"},
    {n="undesync",                  d="Disable offset desync"},
    {n="raknetdesync",              d="Enable RakNet desync"},
    {n="unraknetdesync",            d="Disable RakNet desync"},
    {n="runanim",                   d="Play an animation by ID with optional speed multiplier"},
    {n="animbuilder",               d="Open animation builder GUI"},
    {n="setkiller",                 d="Set killer animation set"},
    {n="setpsycho",                 d="Set psycho animation set"},
    {n="resetanims",                d="Restore your previous animations"},
    {n="animcopycore",              d="Copy core animations from a player or NPC"},
    {n="syncanim",                  d="Mirror player or NPC animations (live)"},
    {n="syncstop",                  d="Stop live sync and restore defaults"},
    {n="animresetcore",             d="Reset core animations to saved"},
    {n="unsyncreset",               d="Stop sync and reset saved"},
    {n="mimic",                     d="Clone player or NPC movement with optional delay"},
    {n="mstop",                     d="Stop mimic and restore defaults"},
    {n="bubblechat",                d="Enable BubbleChat"},
    {n="unbubblechat",              d="Disable BubbleChat"},
    {n="hideicon",                  d="Hide the NA icon"},
    {n="showicon",                  d="Show the NA icon"},
    {n="topbar",                    d="Show the NA topbar"},
    {n="untopbar",                  d="Hide the NA topbar"},
    {n="lockiconposition",          d="Lock the NA icon's position (can't be dragged)"},
    {n="unlockiconposition",        d="Unlock the NA icon's position (can be dragged again)"},
    {n="saveinstance",              d="Save the game with SaveInstance 420 Edition"},
    {n="admin",                     d="Whitelist a user to have access to your client-side commands"},
    {n="unadmin",                   d="Remove someone from admin"},
    {n="partname",                  d="Click on a part to grab its path"},
    {n="jobid",                     d="Copy your job ID"},
    {n="joinjobid",                 d="Join the job ID you enter"},
    {n="copyteleport",              d="Copy a script that teleports you to your coordinates"},
    {n="copytween",                 d="Copy a TweenService script that moves you to your coordinates"},
    {n="copymoveto",                d="Copy a Humanoid:MoveTo script that moves you to your coordinates"},
    {n="copylerp",                  d="Copy a CFrame:Lerp script that moves you to your coordinates"},
    {n="copytptogame",              d="Copy a script for teleporting to the game you are currently in"},
    {n="copytptoserver",            d="Copy a script for teleporting to your current game server"},
    {n="serverhop",                 d="Serverhop using Roblox's default or NA's advanced method"},
    {n="smallserverhop",            d="Serverhop to a small server"},
    {n="pingserverhop",             d="Serverhop by ping or RoValra estimated latency"},
    {n="oldserverhop",              d="Serverhop to one of the oldest active servers"},
    {n="newserverhop",              d="Serverhop to one of the newest active servers"},
    {n="versionhop",                d="Serverhop to a server running a specific place version"},
    {n="oldversionhop",             d="Serverhop to the oldest currently active place version"},
    {n="regionhop",                 d="Serverhop to a public server in a requested RoValra region"},
    {n="autorejoin",                d="Rejoin the server if you get kicked/disconnected"},
    {n="unautorejoin",              d="Disable auto rejoin command"},
    {n="functionspy",               d="Check console for function spy output"},
    {n="fly",                       d="Enable flight"},
    {n="unfly",                     d="Disable flight"},
    {n="cframefly",                 d="Enable CFrame-based flight with respawn-safe cleanup"},
    {n="uncframefly",               d="Disable CFrame-based flight"},
    {n="tfly",                      d="Enable smooth flying"},
    {n="untfly",                    d="Disable tween flying"},
    {n="tpfly",                     d="Enable TranslateBy-based flight without forcing PlatformStand"},
    {n="untpfly",                   d="Disable TranslateBy-based flight"},
    {n="noclip",                    d="Disable your player's collision"},
    {n="clip",                      d="Enable your player's collision"},
    {n="antianchor",                d="Prevent your parts from being anchored"},
    {n="unantianchor",              d="Allow your parts to be anchored"},
    {n="antibang",                  d="Prevent users from banging you (WIP)"},
    {n="unantibang",                d="Disable antibang"},
    {n="orbit",                     d="Orbit around a player or NPC"},
    {n="uporbit",                   d="Orbit around a player or NPC on the Y axis"},
    {n="unorbit",                   d="Stop orbiting"},
    {n="freecam",                   d="Enable free camera"},
    {n="freecamgoto",               d="Start or move freecam to a player or NPC"},
    {n="freecamgotopart",           d="Start or move freecam to an exact part name"},
    {n="unfreecam",                 d="Disable free camera"},
    {n="nohats",                    d="Drop all of your hats"},
    {n="instantrespawn",            d="Respawn instantly"},
    {n="circlemath",                d="Circle math — Modes: a,b,c,d,e"},
    {n="grippos",                   d="Open a UI to manually input grip offset and rotation"},
    {n="seizure",                   d="Gives you a seizure"},
    {n="unseizure",                 d="Stop the seizure"},
    {n="fakelag",                   d="Fake lag"},
    {n="unfakelag",                 d="Stop the fake lag command"},
    {n="hide",                      d="Place the selected player in Lighting"},
    {n="unhide",                    d="Place the selected player back in Workspace"},
    {n="aimbot",                    d="Aimbot GUI"},
    {n="grabtools",                 d="Grab dropped tools, optionally filtering by name"},
    {n="grabtoolsfind",             d="Grab dropped tools whose names contain the given text"},
    {n="loopgrabtools",             d="Loop grab dropped tools without changing your equipped tool"},
    {n="unloopgrabtools",           d="Stop the loop grab command"},
    {n="dance",                     d="Do a random dance"},
    {n="undance",                   d="Stop the dance command"},
    {n="animspoofer",               d="Load an animation spoofer for rbxassetid animations"},
    {n="badgeviewer",               d="View all badges in the game you're in"},
    {n="bodytransparency",          d="Set LocalTransparencyModifier on selected body parts (0-1)"},
    {n="unbodytransparency",        d="Stop transparency loop"},
    {n="material",                  d="Set every BasePart in your character to a selected material"},
    {n="unmaterial",                d="Restore character materials changed by material"},
    {n="animationspeed",            d="Adjust the speed of currently playing animations"},
    {n="unanimationspeed",          d="Stop the animation speed adjustment loop"},
    {n="placeid",                   d="Copy the PlaceId of the game you're in"},
    {n="gameid",                    d="Copy the GameId/Universe Id of the game you're in"},
    {n="firework",                  d="Pop a firework"},
    {n="placename",                 d="Copy the game's place name to your clipboard"},
    {n="gameinfo",                  d="Show info about the game you're playing"},
    {n="userpreview",               d="Show info about a user you name"},
    {n="copyname",                  d="Copy the username of the target"},
    {n="copydisplay",               d="Copy the display name of the target"},
    {n="copyid",                    d="Copy the UserId of the target"},
    {n="antitouch",                 d="Disable touchable parts"},
    {n="loopantitouch",             d="Enable AntiTouch live tracking without opening the method popup"},
    {n="unantitouch",               d="Re-enable touchable parts"},
    {n="height",                    d="Change your hip height"},
    {n="netbypass",                 d="Net bypass"},
    {n="day",                       d="Make it day"},
    {n="night",                     d="Make it night"},
    {n="time",                      d="Set the time"},
    {n="chat",                      d="Chat for you, useful if you're muted"},
    {n="uwuify",                    d="Stylize and send chat text"},
    {n="autouwuify",                d="Stylize chat input before sending"},
    {n="unautouwuify",              d="Stop chat input styling"},
    {n="uwustutter",                d="Enable stutter styling"},
    {n="unuwustutter",              d="Disable stutter styling"},
    {n="uwuaffix",                  d="Enable suffix styling"},
    {n="unuwuaffix",                d="Disable suffix styling"},
    {n="privatemessage",            d="Send a private message to a player"},
    {n="mimicchat",                 d="Mimic the chat of a player"},
    {n="stopmimicchat",             d="Stop mimicking a player"},
    {n="fixcam",                    d="Fix your camera"},
    {n="fling",                     d="Fling the given player or NPC"},
    {n="verticalfling",             d="Fling a player or NPC vertically"},
    {n="horizontalfling",           d="Fling a player or NPC horizontally"},
    {n="commitoof",                 d="Trigger a dramatic oof sequence"},
    {n="volume",                    d="Change your volume (0-10)"},
    {n="perfstats",                 d="Show or hide performance stats"},
    {n="preftransparency",          d="Set preferred UI transparency (0-15)"},
    {n="sensitivity",               d="Change your sensitivity (1-10)"},
    {n="torandom",                  d="Teleport to a random player"},
    {n="timestop",                  d="Freeze all players (ZA WARUDO)"},
    {n="untimestop",                d="Unfreeze all players"},
    {n="team",                      d="Change your team (client-side)"},
    {n="reselectchar",              d="Re-open the character picker"},
    {n="goto",                      d="Teleport to a player, NPC, or X,Y,Z coordinates"},
    {n="lookat",                    d="Stare at a player or NPC"},
    {n="unlookat",                  d="Stop staring"},
    {n="starenear",                 d="Stare at the closest player"},
    {n="unstarenear",               d="Stop staring at closest player"},
    {n="watch",                     d="Spectate a player"},
    {n="unwatch",                   d="Stop spectating"},
    {n="stealaudio",                d="Save sounds playing from a player or NPC to a file"},
    {n="follow",                    d="Follow a player or NPC wherever they go"},
    {n="unfollow",                  d="Stop all attempts to follow a player"},
    {n="autofollow",                d="Automatically follow any player who comes close"},
    {n="unautofollow",              d="Stop automatically following nearby players"},
    {n="pathfind",                  d="Follow a player or NPC using the pathfinder API"},
    {n="freeze",                    d="Freeze your character"},
    {n="unfreeze",                  d="Unfreeze your character"},
    {n="blackhole",                 d="Make unanchored parts teleport to the black hole"},
    {n="disableanimations",         d="Freeze your animations"},
    {n="undisableanimations",       d="Unfreeze your animations"},
    {n="hatresize",                 d="Make your hats very big (R15 only)"},
    {n="exit",                      d="Close down Roblox"},
    {n="firekey",                   d="Fire a keybind using VirtualInputManager"},
    {n="loopfling",                 d="Continuously fling a player or NPC"},
    {n="unloopfling",               d="Stop loop flinging a player"},
    {n="loopverticalfling",         d="Continuously vertical-fling a player or NPC"},
    {n="unloopverticalfling",       d="Stop loop vertical fling"},
    {n="loophorizontalfling",       d="Continuously horizontal-fling a player or NPC"},
    {n="unloophorizontalfling",     d="Stop loop horizontal fling"},
    {n="freegamepass",              d="Pretend you own every gamepass and fire product purchase signals"},
    {n="devproducts",               d="Open the Products tab and send fake purchase completion signals"},
    {n="gamepasses",                d="Open the Game Passes tab and send fake purchase completion signals"},
    {n="listen",                    d="Listen to your target's voice chat"},
    {n="vcworld",                   d="Toggle default spatial voice routing"},
    {n="unlisten",                  d="Stop listening"},
    {n="gear",                      d="Give gear by ID (client-sided)"},
    {n="lockmouse",                 d="Default mouse behaviour"},
    {n="unlockmouse",               d="Unlock your mouse"},
    {n="lockmouse2",                d="Lock your mouse in the center"},
    {n="unlockmouse2",              d="Unlock your mouse"},
    {n="cursorvisible",             d="Force the mouse cursor to remain visible"},
    {n="cursorfree",                d="Force the mouse cursor to remain visible and unlocked"},
    {n="cursorreset",               d="Force Roblox's default visible and unlocked cursor"},
    {n="cursorrestore",             d="Stop cursor enforcement and restore the saved game cursor state"},
    {n="headsit",                   d="Sit on a player or NPC's head"},
    {n="unheadsit",                 d="Stop the headsit command"},
    {n="piggyback",                 d="Attach to a player's back while sitting"},
    {n="unpiggyback",               d="Stop piggybacking a player"},
    {n="walltp",                    d="Toggle wall top teleport (BETA)"},
    {n="unwalltp",                  d="Disable wall top teleport"},
    {n="wallhop",                   d="Wallhop helper"},
    {n="unwallhop",                 d="Disable wallhop helper"},
    {n="joinvoice",                 d="Use VC if you were suspended"},
    {n="jump",                      d="Jump"},
    {n="loopjump",                  d="Continuously jump"},
    {n="unloopjump",                d="Stop continuous jumping"},
    {n="jumpboost",                 d="Add extra jump velocity without changing JumpPower"},
    {n="unjumpboost",               d="Disable extra jump boost"},
    {n="trussjump",                 d="Boost off trusses when you jump"},
    {n="untrussjump",               d="Disable trussjump"},
    {n="chattranslate",             d="Chat translator"},
    {n="headstand",                 d="Stand on a player or NPC's head"},
    {n="unheadstand",               d="Stop the headstand command"},
    {n="loopwalkspeed",             d="Loop walkspeed"},
    {n="unloopwalkspeed",           d="Disable loop walkspeed"},
    {n="loopjumppower",             d="Loop JumpPower"},
    {n="unloopjumppower",           d="Disable loop jump power"},
    {n="stopanimations",            d="Stop running animations"},
    {n="refreshanimations",         d="Reload character animations"},
    {n="loopwaveat",                d="Wave to a player or NPC in a loop"},
    {n="unloopwaveat",              d="Stop the loopwaveat command"},
    {n="tools",                     d="Copy tools from ReplicatedStorage and Lighting"},
    {n="toolview",                  d="3D tool viewer above a player's head"},
    {n="untoolview",                d="Remove the tool viewer above a player's head"},
    {n="toolview2",                 d="Live-updating tool viewer"},
    {n="waveat",                    d="Wave to a player or NPC"},
    {n="headbang",                  d="Bang them in the mouth"},
    {n="unheadbang",                d="Stop headbang"},
    {n="jerkuser",                  d="Lay under them and vibe"},
    {n="unjerkuser",                d="Stop the jerk user action"},
    {n="suck",                      d="Suck it"},
    {n="unsuck",                    d="No more fun"},
    {n="improvetextures",           d="Switch textures to improved version"},
    {n="undotextures",              d="Restore original textures"},
    {n="serverlist",                d="Open the native server browser"},
    {n="keyboard",                  d="Provide a keyboard GUI for mobile users"},
    {n="autoclicker",               d="Provide an autoclicker GUI"},
    {n="backpack",                  d="Provide a custom backpack GUI"},
    {n="unloadbackpack",            d="Unload the custom backpack GUI"},
    {n="edgejump",                  d="Automatically jump when you get to the edge of an object"},
    {n="unedgejump",                d="Disable edgejump"},
    {n="unequiptools",              d="Unequip every tool you are currently holding"},
    {n="equiptool",                 d="Equip a specific tool by name or selection"},
    {n="loopequiptool",             d="Keep a specific tool equipped until disabled"},
    {n="unloopequiptool",           d="Stop the loop equip behaviour"},
    {n="multitool",                 d="Allow stacking equipped tools from your inventory"},
    {n="unmultitool",               d="Disable multitool mode"},
    {n="bang",                      d="Attach to a player"},
    {n="unbang",                    d="Detach from the player"},
    {n="carpet",                    d="Be someone's carpet"},
    {n="uncarpet",                  d="Undo carpet"},
    {n="climb",                     d="Allow climbing while in air"},
    {n="unclimb",                   d="Disable climb"},
    {n="inversebang",               d="You're the one getting it"},
    {n="uninversebang",             d="No more fun"},
    {n="suslay",                    d="Lay down in a suspicious way"},
    {n="unsuslay",                  d="Stand up from the sussy lay"},
    {n="jerk",                      d="Jorking it"},
    {n="hug",                       d="Hug time (click on a target to hug)"},
    {n="unhug",                     d="No huggies"},
    {n="glue",                      d="Loop teleport to a player or NPC"},
    {n="unglue",                    d="Stop teleporting to a player or NPC"},
    {n="glueback",                  d="Loop teleport behind a player"},
    {n="unglueback",                d="Stop teleporting behind a player"},
    {n="spook",                     d="Teleport next to a player or NPC for a few seconds"},
    {n="loopspook",                 d="Teleport next to a player repeatedly"},
    {n="unloopspook",               d="Stop the loopspook command"},
    {n="airwalk",                   d="Press space to go up, unairwalk to stop"},
    {n="unairwalk",                 d="Stop the airwalk command"},
    {n="airmomentum",               d="Override in-air horizontal movement with custom air control"},
    {n="unairmomentum",             d="Stop the custom air momentum command"},
    {n="cbring",                    d="Bring a player or NPC once on your client"},
    {n="loopcbring",                d="Continuously bring a player or NPC on your client"},
    {n="unloopcbring",              d="Disable looped client bring"},
    {n="mute",                      d="Mute sounds from a player or NPC"},
    {n="offsetwalk",                d="Move the character by teleporting a set studs per frame"},
    {n="unoffsetwalk",              d="Stop Offset Walk"},
    {n="tpwalk",                    d="More undetectable walkspeed script"},
    {n="untpwalk",                  d="Stop the tpwalk command"},
    {n="tpjump",                    d="TP jump command"},
    {n="untpjump",                  d="Stop the tpjump command"},
    {n="loopmute",                  d="Loop mute sounds from a player or NPC"},
    {n="unloopmute",                d="Stop loop muting a player or NPC"},
    {n="getmass",                   d="Get a player or NPC root mass"},
    {n="copyposition",              d="Get the position of a player or NPC"},
    {n="removeterrain",             d="Clear terrain"},
    {n="memory",                    d="Show your current memory usage"},
    {n="clearnilinstances",         d="Remove nil instances"},
    {n="inspect",                   d="Check a user's items"},
    {n="noprompt",                  d="Remove purchase prompts"},
    {n="prompt",                    d="Allow purchase prompts"},
    {n="nonetworkpause",            d="Disable Roblox network pause overlay"},
    {n="networkpause",              d="Re-enable Roblox network pause overlay"},
    {n="wallwalk",                  d="Walk on walls"},
    {n="hideguis",                  d="Hide GUIs"},
    {n="unhideguis",                d="Restore GUIs hidden by hideguis"},
    {n="hidecurrentguis",           d="Hide only currently visible GUIs"},
    {n="unhidecurrentguis",         d="Restore GUIs hidden by hidecurrentguis"},
    {n="showguis",                  d="Enable every UI"},
    {n="unshowguis",                d="Restore UI states set by showguis"},
    {n="hidetargetgui",             d="Hide a specific GUI by name"},
    {n="unhidetargetgui",           d="Restore GUIs hidden by hidetargetgui"},
    {n="showtargetgui",             d="Show only a specific GUI by name"},
    {n="unshowtargetgui",           d="Restore GUI states changed by showtargetgui"},
    {n="spin",                      d="Spin your character"},
    {n="unspin",                    d="Stop spinning your character"},
    {n="notepad",                   d="Integrated notepad"},
    {n="rc7",                       d="RC7 Internal UI"},
    {n="scriptviewer",              d="View scripts made by 0866"},
    {n="moduleeditor",              d="Load the module editor UI"},
    {n="upvalueeditor",             d="Load the upvalue editor UI"},
    {n="hydroxide",                 d="Execute Hydroxide"},
    {n="remotespy",                 d="Execute SimpleSpy (supports PC and mobile)"},
    {n="cobaltspy",                 d="Execute CobaltSpy"},
    {n="turtlespy",                 d="Execute Turtle Spy (supports PC and mobile)"},
    {n="gravity",                   d="Set game gravity to whatever you want"},
    {n="fireclickdetectors",        d="Fire every ClickDetector in Workspace"},
    {n="fireclickdetectorsfind",    d="Fire ClickDetectors matching [target] in Workspace"},
    {n="fireproximityprompts",      d="Fire every ProximityPrompt in Workspace"},
    {n="fireproximitypromptsfind",  d="Fire ProximityPrompts matching [target] in Workspace"},
    {n="firetouchinterests",        d="Fire every TouchInterest in Workspace"},
    {n="firetouchinterestsfind",    d="Fire TouchInterests matching [target] in Workspace"},
    {n="proximitypromptgoto",       d="Teleport to the nearest ProximityPrompt part"},
    {n="clickdetectorgoto",         d="Teleport to the nearest ClickDetector part"},
    {n="touchinterestgoto",         d="Teleport to the nearest TouchInterest part"},
    {n="autofireproxi",             d="Auto-fire ProximityPrompts matching [target] every interval"},
    {n="autofireproxifind",         d="Auto-fire ProximityPrompts using substring matching"},
    {n="autofireclick",             d="Auto-fire ClickDetectors matching [target] every interval"},
    {n="autofireclickfind",         d="Auto-fire ClickDetectors using substring matching"},
    {n="autotouch",                 d="Auto-fire TouchInterests on parts matching [target]"},
    {n="autotouchfind",             d="Auto-fire TouchInterests using substring matching"},
    {n="autofireremote",            d="Auto-fire remotes matching [target] every interval"},
    {n="autofireremotefind",        d="Auto-fire remotes using substring matching"},
    {n="unautofireproxi",           d="Stop all AutoFireProxi loops"},
    {n="unautofireclick",           d="Stop all AutoFireClick loops"},
    {n="unautotouch",               d="Stop all AutoTouch loops"},
    {n="unautofireremote",          d="Stop all AutoFireRemote loops"},
    {n="noclickdetectorlimits",     d="Set all ClickDetectors MaxActivationDistance to math.huge"},
    {n="noproximitypromptlimits",   d="Set all ProximityPrompts MaxActivationDistance to math.huge"},
    {n="instantproximityprompts",   d="Set proximity prompt HoldDuration values to 0"},
    {n="uninstantproximityprompts", d="Restore tracked proximity prompt HoldDuration values"},
    {n="fastprompts",               d="Make proximity prompts use a speed multiplier (default 2x)"},
    {n="unfastprompts",             d="Restore tracked proximity prompt HoldDuration values"},
    {n="promptwalls",               d="Allow proximity prompts to be used through walls"},
    {n="unpromptwalls",             d="Restore original proximity prompt wall checks"},
    {n="enableproximitypromptservice", d="Enable proximity prompt buttons"},
    {n="disableproximitypromptservice",d="Disable proximity prompt buttons"},
    {n="enableproximityprompts",    d="Enable ProximityPrompts (all or matching)"},
    {n="disableproximityprompts",   d="Disable ProximityPrompts (all or matching)"},
    {n="loopenableproximityprompts",d="Continuously enable ProximityPrompts (all or matching)"},
    {n="unloopenableproximityprompts",d="Stop enabling loop"},
    {n="r6",                        d="Switch your character rig type to R6"},
    {n="r15",                       d="Switch your character rig type to R15"},
    {n="breakvelocity",             d="Set your character's velocity to zero momentarily"},
    {n="maxslopeangle",             d="Change your character's MaxSlopeAngle"},
    {n="loopmaxslopeangle",         d="Loop MaxSlopeAngle"},
    {n="unloopmaxslopeangle",       d="Disable loop MaxSlopeAngle"},
    {n="godmode",                   d="Pick and enable an invincibility method"},
    {n="ungodmode",                 d="Disable invincibility"},
    {n="controllock",               d="Set Shiftlock keys to Control for this session"},
    {n="uncontrollock",             d="Restore Shiftlock keys to default (Shift)"},
    {n="resetlock",                 d="Reset your Shiftlock keybinds to default (LeftShift)"},
    {n="flashlight",                d="Give yourself a flashlight tool"},
    {n="light",                     d="Give your player dynamic light"},
    {n="unlight",                   d="Remove dynamic light from your player"},
    {n="lighting",                  d="Manage lighting technology settings"},
    {n="friend",                    d="Send a friend request to your target"},
    {n="unfriend",                  d="Prompt to unfriend your target"},
    {n="block",                     d="Open block/unblock prompt for target player"},
    {n="unblock",                   d="Open unblock prompt for target player"},
    {n="invitefriends",             d="Open Roblox's client invite prompt"},
    {n="experienceevents",          d="Show upcoming experience events"},
    {n="eventinfo",                 d="Show an experience event by ID"},
    {n="rsvpevent",                 d="Open Roblox's RSVP prompt for an experience event"},
    {n="feedback",                  d="Open Roblox's experience feedback prompt"},
    {n="friendweb",                 d="Find friend circles in the current server"},
    {n="massfollowedinto",          d="Show everyone in the server who followed someone into the game"},
    {n="tweengotocampos",           d="Another version of goto camera position bypassing more anticheats"},
    {n="delete",                    d="Delete an instance"},
    {n="deletefind",                d="Delete instances by name search"},
    {n="deletelighting",            d="Remove all descendants within Lighting"},
    {n="lightingdisable",           d="Disable all post-processing effects in Lighting"},
    {n="autodelete",                d="Auto-delete instances"},
    {n="unautodelete",              d="Stop auto-deleting instances"},
    {n="autodeletefind",            d="Auto-delete instances by name search"},
    {n="unautodeletefind",          d="Stop autodeletefind"},
    {n="deleteclass",               d="Delete instances by class"},
    {n="autodeleteclass",           d="Auto-delete instances by class"},
    {n="unautodeleteclass",         d="Stop auto-delete by class"},
    {n="chardelete",                d="Delete parts from your character"},
    {n="chardeletefind",            d="Delete character parts by name search"},
    {n="chardeleteclass",           d="Delete character parts by class"},
    {n="gotopartnext",              d="Teleport sequentially to parts with optional prefix"},
    {n="gotomodelnext",             d="Teleport sequentially to models with optional prefix"},
    {n="gotofoldernext",            d="Teleport sequentially through folder contents"},
    {n="gotobreak",                 d="Stop the active goto sequence"},
    {n="gotopart",                  d="Teleport to a part by name"},
    {n="tweengotopart",             d="Tween to each matching part by name"},
    {n="gotopartfind",              d="Teleport to parts by partial name search"},
    {n="tweengotopartfind",         d="Tween to parts by partial name search"},
    {n="gotopartclass",             d="Teleport to parts by class"},
    {n="bringpart",                 d="Bring a part to you"},
    {n="bringpartfind",             d="Bring parts by partial name search"},
    {n="bringmodel",                d="Bring a model to you"},
    {n="bringmodelfind",            d="Bring models by partial name search"},
    {n="bringfolder",               d="Bring folder contents to you"},
    {n="gotomodel",                 d="Teleport to a model"},
    {n="gotomodelfind",             d="Teleport to models by partial name search"},
    {n="gotofolder",                d="Teleport to a folder"},
    {n="swim",                      d="Swim script"},
    {n="unswim",                    d="Stop the swim script"},
    {n="punch",                     d="Punch tool that flings"},
    {n="tpua",                      d="Bring every unanchored part on the map to a player or NPC"},
    {n="blackholefollow",           d="Pull unanchored parts to you with spin"},
    {n="noblackholefollow",         d="Stop blackhole follow and clear constraints"},
    {n="swordfighter",              d="Activate a sword fighting bot for automated PvP combat"},
    {n="touchesp",                  d="ESP for TouchInterest parts"},
    {n="untouchesp",                d="Disable touch ESP"},
    {n="proximityesp",              d="ESP for ProximityPrompt parts"},
    {n="unproximityesp",            d="Disable proximity ESP"},
    {n="clickesp",                  d="ESP for ClickDetector parts"},
    {n="unclickesp",                d="Disable click ESP"},
    {n="itemesp",                   d="Highlight dropped in-game tools/items"},
    {n="unitemesp",                 d="Disable dropped item ESP"},
    {n="sitesp",                    d="Seat ESP"},
    {n="unsitesp",                  d="Disable seat ESP"},
    {n="vehiclesitesp",             d="Vehicle seat ESP"},
    {n="unvehiclesitesp",           d="Disable vehicle seat ESP"},
    {n="pesp",                      d="Part ESP by exact name"},
    {n="unpesp",                    d="Remove exact-name part ESP"},
    {n="pespfind",                  d="Part ESP by partial name"},
    {n="unpespfind",                d="Remove partial-name part ESP"},
    {n="unanchored",                d="ESP for unanchored parts"},
    {n="ununanchored",              d="Disable unanchored ESP"},
    {n="collisionesp",              d="ESP for collidable parts"},
    {n="uncollisionesp",            d="Disable collision ESP"},
    {n="nocollisionesp",            d="ESP for non-collidable parts"},
    {n="unnocollisionesp",          d="Disable no-collision ESP"},
    {n="propertyesp",               d="ESP instances with a matching readable property value"},
    {n="unpropertyesp",             d="Disable property ESP entries"},
    {n="shapeesp",                  d="ESP Part instances with the selected Shape"},
    {n="unshapeesp",                d="Disable Shape ESP entries"},
    {n="esplocator",                d="ESP locator/tracker"},
    {n="unesplocator",              d="Disable ESP locator"},
    {n="folderesp",                 d="ESP for folder contents"},
    {n="unfolderesp",               d="Disable folder ESP"},
    {n="viewpart",                  d="View/spectate a part"},
    {n="unviewpart",                d="Reset camera to local humanoid"},
    {n="viewpartfind",              d="View/spectate a part by partial name"},
    {n="console",                   d="Open developer console"},
    {n="oldconsole",                d="Open old version of the developer console"},
    {n="exportconsole",             d="Export the current NA Console records"},
    {n="hitbox",                    d="Resize a selected body part or All"},
    {n="unhitbox",                  d="Restore hitbox size"},
    {n="partsize",                  d="Resize a part by name"},
    {n="partsizefind",              d="Resize parts by partial name"},
    {n="unpartsize",                d="Restore parts resized by partsize"},
    {n="unpartsizefind",            d="Restore parts resized by partsizefind"},
    {n="breakcars",                 d="Break any car"},
    {n="netclaim",                  d="Try to acquire network ownership of parts"},
    {n="unnetclaim",                d="Stop network ownership attempts"},
    {n="setsimradius",              d="Set sim radius using available methods"},
    {n="infjump",                   d="Enable infinite jumping"},
    {n="uninfjump",                 d="Disable infinite jumping"},
    {n="flyjump",                   d="Hold space to fly up"},
    {n="unflyjump",                 d="Disable flyjump"},
    {n="xray",                      d="Enable X-ray vision to see through walls"},
    {n="unxray",                    d="Disable X-ray vision"},
    {n="echolocation",              d="[BETA] Darken the world and reveal geometry from movement and sounds"},
    {n="unecholocation",            d="Disable echolocation and restore Lighting"},
    {n="echoping",                  d="Emit a strong manual echolocation ping"},
    {n="fullbright",                d="Make dark games bright without destroying effects"},
    {n="loopday",                   d="Loop daytime"},
    {n="unloopday",                 d="Stop looping daytime"},
    {n="loopfullbright",            d="Loop fullbright"},
    {n="unloopfullbright",          d="Stop looping fullbright"},
    {n="loopnight",                 d="Loop nighttime"},
    {n="unloopnight",               d="Stop looping nighttime"},
    {n="loopnoeffect",              d="Keep Lighting and CurrentCamera effects disabled"},
    {n="unloopnoeffect",            d="Restore Lighting and CurrentCamera effects"},
    {n="noeffect",                  d="Disable Lighting and CurrentCamera effects"},
    {n="loopnofog",                 d="Remove fog continuously"},
    {n="unloopnofog",               d="Stop removing fog"},
    {n="nofog",                     d="Remove all fog from the game"},
    {n="nightmare",                 d="Make it dark and spooky"},
    {n="unnightmare",               d="Disable nightmare mode"},
    {n="brightness",                d="Change the brightness lighting property"},
    {n="loopbrightness",            d="Lock the brightness lighting property"},
    {n="unloopbrightness",          d="Stop locking brightness"},
    {n="globalshadows",             d="Enable global shadows"},
    {n="unglobalshadows",           d="Disable global shadows"},
    {n="gamma",                     d="Gamma vision"},
    {n="loopgamma",                 d="Loop gamma vision"},
    {n="unloopgamma",               d="Stop gamma vision"},
    {n="firstp",                    d="Go into first person mode"},
    {n="thirdp",                    d="Go into third person mode"},
    {n="maxzoom",                   d="Set your maximum camera distance"},
    {n="minzoom",                   d="Set your minimum camera distance"},
    {n="loopmaxzoom",               d="Loop your maximum camera distance and restore if changed"},
    {n="unloopmaxzoom",             d="Stop looping maximum camera distance"},
    {n="loopminzoom",               d="Loop your minimum camera distance and restore if changed"},
    {n="unloopminzoom",             d="Stop looping minimum camera distance"},
    {n="cameranoclip",              d="Make your camera clip through walls"},
    {n="uncameranoclip",            d="Restore normal camera"},
    {n="oganims",                   d="Old animations from 2007"},
    {n="fakechat",                  d="Fake a chat GUI"},
    {n="fpscap",                    d="Set the FPS cap"},
    {n="toolinvisible",             d="Be invisible while still able to use tools"},
    {n="invisible",                 d="Set invisibility"},
    {n="visible",                   d="Turn visible"},
    {n="invisbind",                 d="Set a custom keybind for the Invisible command"},
    {n="fireremote",                d="Fire one remote by selection, name, or full path"},
    {n="fireremotes",               d="Fire every remote with arguments"},
    {n="keepna",                    d="Keep executing NA"},
    {n="unkeepna",                  d="Stop executing NA"},
    {n="fov",                       d="Set your FOV to a custom value (1-300)"},
    {n="loopfov",                   d="Lock your FOV target (1-300)"},
    {n="unloopfov",                 d="Stop FOV loop"},
    {n="savetools",                 d="Save your tools to memory"},
    {n="loadtools",                 d="Restore your saved tools to your backpack"},
    {n="preventtools",              d="Prevent any item from being equipped"},
    {n="unpreventtools",            d="Allow items to be equipped again"},
    {n="ws",                        d="Set your WalkSpeed"},
    {n="jp",                        d="Set your JumpPower"},
    {n="blockremote",               d="Block matching remotes with Hooks, Signals, or Both"},
    {n="unblockremote",             d="Restore a blocked remote or unblock all"},
    {n="bypassspeed",               d="Set WalkSpeed (bypass variant)"},
    {n="loopbypassspeed",           d="Loop WalkSpeed (bypass variant)"},
    {n="unloopbypassspeed",         d="Disable loop WalkSpeed (bypass variant)"},
    {n="oofspam",                   d="Spam oof"},
    {n="httpspy",                   d="HTTP Spy"},
    {n="keystroke",                 d="Execute a keystroke UI script"},
    {n="errorchat",                 d="Make the chat error appear when Roblox chat is slow"},
    {n="clearerror",                d="Clear any current error or disconnected UI immediately"},
    {n="antierror",                 d="Continuously block and clear any future error UI"},
    {n="unantierror",               d="Disable Anti Error"},
    {n="boobs",                     d="Boobs"},
    {n="unboobs",                   d="Remove boobs"},
    {n="ass",                       d="Ass"},
    {n="unass",                     d="Remove ass"},
    {n="penis",                     d="Penis"},
    {n="unpenis",                   d="Remove penis"},
    {n="flingnpcs",                 d="Fling NPCs"},
    {n="npcfollow",                 d="Make NPCs follow you"},
    {n="loopnpcfollow",             d="Make NPCs follow you in a loop"},
    {n="unloopnpcfollow",           d="Stop NPCs following you in a loop"},
    {n="sitnpcs",                   d="Make NPCs sit"},
    {n="unsitnpcs",                 d="Make NPCs unsit"},
    {n="killnpcs",                  d="Kill NPCs"},
    {n="npcwalkspeed",              d="Set all NPC WalkSpeed"},
    {n="npcjumppower",              d="Set all NPC JumpPower"},
    {n="bringnpcs",                 d="Bring NPCs"},
    {n="loopbringnpcs",             d="Loop NPC bringing"},
    {n="unloopbringnpcs",           d="Stop NPC bring loop"},
    {n="gotonpcs",                  d="Teleport to each NPC"},
    {n="actnpc",                    d="Start acting like an NPC"},
    {n="unactnpc",                  d="Stop acting like an NPC"},
    {n="clicktouch",                d="Click a TouchTransmitter part to fire a touch"},
    {n="unclicktouch",              d="Disable clicktouch"},
    {n="clickkillnpc",              d="Click on an NPC to kill it"},
    {n="unclickkillnpc",            d="Disable clickkillnpc"},
    {n="voidnpcs",                  d="Teleport NPCs to void"},
    {n="clickvoidnpc",              d="Click to void NPCs"},
    {n="unclickvoidnpc",            d="Disable click-void"},
    {n="clicknpcws",                d="Click on an NPC to set its WalkSpeed"},
    {n="unclicknpcws",              d="Disable clicknpcws"},
    {n="clicknpcjp",                d="Click on an NPC to set its JumpPower"},
    {n="unclicknpcjp",              d="Disable clicknpcjp"},
    {n="rename",                    d="Rename the admin UI placeholder to the given name"},
    {n="unname",                    d="Reset the admin UI placeholder name to default"},
    {n="autorespawn",               d="Teleport back to your death position after respawn"},
    {n="unautorespawn",             d="Stop AutoRespawn"},
    {n="guidelete",                 d="Delete GUI under mouse with Backspace/Delete"},
    {n="unguidelete",               d="Disable GUI delete"},
    {n="deleteselectedtool",        d="Delete currently equipped tools"},
    {n="removespecifictool",        d="Automatically remove a specific tool from backpack/character"},
    {n="unremovespecifictool",      d="Stop removing a specific tool"},
    {n="clearremovespecifictool",   d="Stop all specific tool removal loops"},
    {n="propertychanged",           d="Run a command when an instance property changes"},
    {n="unpropertychanged",         d="Stop propertychanged listeners"},
    {n="loop",                      d="Directly start a command loop without the popup"},
    {n="unloop",                    d="Stop all active command loops"},
    {n="repeat",                    d="Run a command a repeated amount of times"},
    {n="freezeunanchored",          d="Freeze unanchored non-character parts"},
    {n="thawunanchored",            d="Thaw parts frozen by freezeunanchored"},
    {n="modelesp",                  d="ESP for models by exact name"},
    {n="modelespfind",              d="ESP for models by partial name"},
    {n="unmodelespfind",            d="Stop partial-name model ESP tracking rules"},
    {n="unmodelesp",                d="Stop a model ESP tracking rule or all rules"},
    {n="spooftransform",            d="Spoof replicated character position/rotation"},
    {n="unspooftransform",          d="Disable character transform spoofing"},
    {n="spoofwalk",                 d="Use one WalkSpeed locally while exposing another for replication"},
    {n="unspoofwalk",               d="Disable WalkSpeed masking and restore original value"},
    {n="spoofvelocity",             d="Preserve local simulation velocity while masking assembly velocity"},
    {n="unspoofvelocity",           d="Disable linear/angular velocity spoofing"},
    {n="spoofpart",                 d="Spoof the unanchored assembly under your cursor"},
    {n="unspoofpart",               d="Disable the current part/vehicle transform spoof"},
    {n="posesplit",                 d="Freeze locally rendered Motor6D pose while animations continue"},
    {n="unposesplit",               d="Disable the local pose split"},
    {n="humspoof",                  d="Mask selected Humanoid physics properties between simulation and replication"},
    {n="unhumspoof",                d="Disable one Humanoid property mask or all masks"},
    {n="spoofstatus",               d="Show currently enabled spoof features"},
    {n="unloadspoofs",              d="Stop every spoof feature and restore saved state"},
    {n="chat",                    d="Open the Nameless Admin chat UI"},
    {n="disguise",                d="Disguise your NA Chat appearance as another Roblox user"},
    -- Patched commands
    {n="breaklayeredclothing",      d="[PATCHED] Stretch your layered clothing"},
    {n="reserveserver",             d="[PATCHED] Teleport to a reserved server or create one"},
}


-- ─── UTIL ────────────────────────────────────────────────────────────────────
local function mk(cls, props, par)
    local o = Instance.new(cls)
    for k, v in next, props do o[k] = v end
    if par then o.Parent = par end
    return o
end

local function cr(r, p)   mk("UICorner",{CornerRadius=UDim.new(0,r)}, p) end
local function st(c, t, p) mk("UIStroke",{Color=c, Thickness=t}, p) end

local function tw(o, g, d, s, di)
    TweenS:Create(o, TweenInfo.new(
        d or .2, s or Enum.EasingStyle.Quad, di or Enum.EasingDirection.Out), g):Play()
end

local function thumb(uid)
    local ok, r = pcall(Plrs.GetUserThumbnailAsync, Plrs, uid,
        Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    return ok and r or ""
end

local function joinDateStr(p)
    local ok, r = pcall(os.date, "%b %d, %Y", os.time() - p.AccountAge * 86400)
    return ok and r or "N/A"
end

local function findPlr(name)
    if not name then return end
    name = name:lower()
    for _, p in ipairs(Plrs:GetPlayers()) do
        if p.Name:lower():find(name, 1, true) or
           p.DisplayName:lower():find(name, 1, true) then
            return p
        end
    end
end

-- ─── STATE ───────────────────────────────────────────────────────────────────
local S = { tab = "Players", sel = nil, entries = {}, notes = {} }
local CmdInput

-- ─── ROOT GUI ────────────────────────────────────────────────────────────────
local G = mk("ScreenGui",{
    Name="AdminPanel", ResetOnSpawn=false,
    ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
    DisplayOrder=9999, IgnoreGuiInset=true,
})
pcall(function() G.Parent = game:GetService("CoreGui") end)
if not G.Parent then G.Parent = LP:WaitForChild("PlayerGui") end

-- ─── TOAST ───────────────────────────────────────────────────────────────────
local function toast(title, msg)
    local f = mk("Frame",{Parent=G, BackgroundColor3=C.bg3, BorderSizePixel=0,
        Position=UDim2.new(.5,0,1,30), AnchorPoint=Vector2.new(.5,1),
        Size=UDim2.new(0,420,0,76), ZIndex=50})
    cr(14, f) st(C.brd, 1, f)
    local ck = mk("Frame",{Parent=f, BackgroundColor3=C.bg4,
        Position=UDim2.new(0,16,.5,0), AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(0,42,0,42), ZIndex=51}) cr(21, ck)
    mk("TextLabel",{Parent=ck, Text="✓", TextColor3=C.t0,
        Font=Enum.Font.GothamBold, TextSize=20, BackgroundTransparency=1,
        Size=UDim2.fromScale(1,1), ZIndex=52})
    mk("TextLabel",{Parent=f, Text=title, TextColor3=C.t0,
        Font=Enum.Font.GothamBold, TextSize=14, BackgroundTransparency=1,
        Position=UDim2.new(0,72,0,18), Size=UDim2.new(1,-110,0,20),
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=51})
    mk("TextLabel",{Parent=f, Text=msg, TextColor3=C.t1,
        Font=Enum.Font.Gotham, TextSize=12, BackgroundTransparency=1,
        Position=UDim2.new(0,72,0,40), Size=UDim2.new(1,-110,0,18),
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=51})
    local xb = mk("TextButton",{Parent=f, Text="✕", TextColor3=C.t1,
        Font=Enum.Font.Gotham, TextSize=14, BackgroundTransparency=1,
        Position=UDim2.new(1,-44,.5,0), AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(0,36,0,36), ZIndex=51})
    tw(f,{Position=UDim2.new(.5,0,1,-20)},.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
    local function dm()
        tw(f,{Position=UDim2.new(.5,0,1,100)},.3)
        task.delay(.35,function() if f then f:Destroy() end end)
    end
    xb.MouseButton1Click:Connect(dm)
    task.delay(5, dm)
end

-- ─── MAIN PANEL ──────────────────────────────────────────────────────────────
local P = mk("Frame",{Parent=G, Name="Panel", BackgroundColor3=C.bg1,
    BorderSizePixel=0, Position=UDim2.new(.5,0,.5,0), AnchorPoint=Vector2.new(.5,.5),
    Size=UDim2.new(0,1100,0,660), ZIndex=5})
cr(12, P) st(C.brd, 1, P)

-- drag
do
    local drg, ds, sp = false, nil, nil
    P.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            and i.Position.Y - P.AbsolutePosition.Y < 55 then
            drg=true; ds=i.Position; sp=P.Position
        end
    end)
    P.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then drg=false end
    end)
    UIS.InputChanged:Connect(function(i)
        if drg and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            P.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
        end
    end)
end

-- header
mk("TextLabel",{Parent=P, Text="Admin Commands", TextColor3=C.t0,
    Font=Enum.Font.GothamBold, TextSize=15, BackgroundTransparency=1,
    Position=UDim2.new(0,20,0,0), Size=UDim2.new(0,220,0,54),
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7})
local closeB = mk("TextButton",{Parent=P, Text="✕", TextColor3=C.t1,
    Font=Enum.Font.Gotham, TextSize=16, BackgroundTransparency=1,
    Position=UDim2.new(1,-50,0,0), Size=UDim2.new(0,50,0,54), ZIndex=7})
mk("Frame",{Parent=P, BackgroundColor3=C.brd,
    Position=UDim2.new(0,0,0,54), Size=UDim2.new(1,0,0,1), ZIndex=6})

-- ─── TAB BAR ─────────────────────────────────────────────────────────────────
local TabBar = mk("Frame",{Parent=P, BackgroundColor3=C.bg0, BorderSizePixel=0,
    Position=UDim2.new(0,0,0,55), Size=UDim2.new(1,0,0,54), ZIndex=6})

local tabDefs = {
    {id="Commands", lbl="⌨   Commands"},
    {id="Players",  lbl="👤   Players"},
    {id="Settings", lbl="⚙   Settings"},
}
local tabBtns, tabInds = {}, {}
for i, td in ipairs(tabDefs) do
    local btn = mk("TextButton",{Parent=TabBar,
        Text=td.lbl, TextColor3=(i==2) and C.t0 or C.t1,
        Font=Enum.Font.Gotham, TextSize=13, BackgroundTransparency=1,
        Position=UDim2.new((i-1)/3,0,0,0), Size=UDim2.new(1/3,0,1,0), ZIndex=7})
    local ind = mk("Frame",{Parent=btn, BackgroundColor3=C.t0,
        Position=UDim2.new(0,0,1,-2), Size=UDim2.new(1,0,0,2),
        Visible=(i==2), ZIndex=8})
    tabBtns[td.id] = btn
    tabInds[td.id] = ind
end
mk("Frame",{Parent=P, BackgroundColor3=C.brd,
    Position=UDim2.new(0,0,0,109), Size=UDim2.new(1,0,0,1), ZIndex=6})

-- ─── CONTENT AREA ────────────────────────────────────────────────────────────
local CFR = mk("Frame",{Parent=P, BackgroundColor3=C.bg1, BorderSizePixel=0,
    Position=UDim2.new(0,0,0,110), Size=UDim2.new(1,0,1,-110), ZIndex=6})

-- ═══════════════════════════════════════════════════════════
-- PLAYERS PAGE
-- ═══════════════════════════════════════════════════════════
local PlayersPage = mk("Frame",{Parent=CFR, BackgroundTransparency=1,
    Size=UDim2.fromScale(1,1), ZIndex=6, Visible=true})

-- LEFT: player list
local LC = mk("Frame",{Parent=PlayersPage, BackgroundColor3=C.bg1,
    BorderSizePixel=0, Size=UDim2.new(0,340,1,0), ZIndex=6})
mk("Frame",{Parent=PlayersPage, BackgroundColor3=C.brd,
    Position=UDim2.new(0,340,0,0), Size=UDim2.new(0,1,1,0), ZIndex=6})

local srch = mk("TextBox",{Parent=LC, PlaceholderText="   🔍  Search players...",
    PlaceholderColor3=C.t2, Text="", TextColor3=C.t0,
    Font=Enum.Font.Gotham, TextSize=13, BackgroundColor3=C.bg2,
    BorderSizePixel=0, Position=UDim2.new(0,12,0,14),
    Size=UDim2.new(1,-24,0,40), ClearTextOnFocus=false, ZIndex=7})
cr(8, srch) st(C.brd, 1, srch)

local PSF = mk("ScrollingFrame",{Parent=LC, BackgroundTransparency=1,
    Position=UDim2.new(0,8,0,66), Size=UDim2.new(1,-16,1,-74),
    ScrollBarThickness=3, ScrollBarImageColor3=C.bg4,
    BorderSizePixel=0, ZIndex=7, CanvasSize=UDim2.new(0,0,0,0)})
local PSFL = mk("UIListLayout",{Parent=PSF, SortOrder=Enum.SortOrder.LayoutOrder,
    Padding=UDim.new(0,4)})
PSFL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PSF.CanvasSize = UDim2.new(0,0,0, PSFL.AbsoluteContentSize.Y+8)
end)

-- CENTER + RIGHT wrapper
local CRW = mk("Frame",{Parent=PlayersPage, BackgroundTransparency=1,
    Position=UDim2.new(0,341,0,0), Size=UDim2.new(1,-341,1,0), ZIndex=6})

local noSel = mk("TextLabel",{Parent=CRW,
    Text="Select a player to view details", TextColor3=C.t2,
    Font=Enum.Font.Gotham, TextSize=14, BackgroundTransparency=1,
    Size=UDim2.fromScale(1,1), ZIndex=7})

-- CENTER: profile + stats
local CC = mk("Frame",{Parent=CRW, BackgroundTransparency=1,
    Size=UDim2.new(0,430,1,0), ZIndex=6})
mk("Frame",{Parent=CRW, BackgroundColor3=C.brd,
    Position=UDim2.new(0,430,0,0), Size=UDim2.new(0,1,1,0), ZIndex=6})

-- Player header card
local PHdr = mk("Frame",{Parent=CC, BackgroundTransparency=1,
    Position=UDim2.new(0,16,0,16), Size=UDim2.new(1,-32,0,80),
    ZIndex=7, Visible=false})

local pAvatar = mk("ImageLabel",{Parent=PHdr, BackgroundColor3=C.bg3,
    Size=UDim2.new(0,64,0,64), ZIndex=8})
cr(32, pAvatar) st(C.brd, 1, pAvatar)

local pName = mk("TextLabel",{Parent=PHdr, Text="", TextColor3=C.t0,
    Font=Enum.Font.GothamBold, TextSize=18, BackgroundTransparency=1,
    Position=UDim2.new(0,80,0,4), Size=UDim2.new(1,-220,0,26),
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8})
local pHandle = mk("TextLabel",{Parent=PHdr, Text="", TextColor3=C.t1,
    Font=Enum.Font.Gotham, TextSize=12, BackgroundTransparency=1,
    Position=UDim2.new(0,80,0,30), Size=UDim2.new(1,-220,0,18),
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8})

local pDot = mk("Frame",{Parent=PHdr, BackgroundColor3=C.grn,
    Position=UDim2.new(0,80,0,54), Size=UDim2.new(0,8,0,8), ZIndex=8})
cr(4, pDot)
mk("TextLabel",{Parent=PHdr, Text="Online", TextColor3=C.grn,
    Font=Enum.Font.Gotham, TextSize=12, BackgroundTransparency=1,
    Position=UDim2.new(0,94,0,48), Size=UDim2.new(0,80,0,18),
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8})

local cpBtn = mk("TextButton",{Parent=PHdr, Text="⧉  Copy User ID",
    TextColor3=C.t0, Font=Enum.Font.Gotham, TextSize=12,
    BackgroundColor3=C.bg3, BorderSizePixel=0,
    Position=UDim2.new(1,0,.5,0), AnchorPoint=Vector2.new(1,.5),
    Size=UDim2.new(0,136,0,36), ZIndex=8})
cr(8, cpBtn) st(C.brd, 1, cpBtn)
cpBtn.MouseEnter:Connect(function() tw(cpBtn,{BackgroundColor3=C.bg4},.1) end)
cpBtn.MouseLeave:Connect(function() tw(cpBtn,{BackgroundColor3=C.bg3},.1) end)
cpBtn.MouseButton1Click:Connect(function()
    if S.sel then
        pcall(setclipboard, tostring(S.sel.UserId))
        toast("Copied","User ID "..tostring(S.sel.UserId).." copied.")
    end
end)

-- Stats row (4 cards)
local StatsRow = mk("Frame",{Parent=CC, BackgroundTransparency=1,
    Position=UDim2.new(0,16,0,108), Size=UDim2.new(1,-32,0,68),
    ZIndex=7, Visible=false})
mk("UIListLayout",{Parent=StatsRow, FillDirection=Enum.FillDirection.Horizontal,
    Padding=UDim.new(0,8), SortOrder=Enum.SortOrder.LayoutOrder})

local statVals = {}
local function mkStatCard(ico, lbl, order)
    local f = mk("Frame",{Parent=StatsRow, BackgroundColor3=C.bg2,
        Size=UDim2.new(.25,-6,1,0), LayoutOrder=order, ZIndex=8})
    cr(8,f) st(C.brd,1,f)
    mk("TextLabel",{Parent=f, Text=ico, TextColor3=C.t1,
        Font=Enum.Font.Gotham, TextSize=16, BackgroundTransparency=1,
        Position=UDim2.new(0,12,.5,0), AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(0,22,0,22), ZIndex=9})
    mk("TextLabel",{Parent=f, Text=lbl, TextColor3=C.t1,
        Font=Enum.Font.Gotham, TextSize=9, BackgroundTransparency=1,
        Position=UDim2.new(0,38,0,8), Size=UDim2.new(1,-42,0,14),
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=9})
    local vl = mk("TextLabel",{Parent=f, Text="—", TextColor3=C.t0,
        Font=Enum.Font.GothamBold, TextSize=12, BackgroundTransparency=1,
        Position=UDim2.new(0,38,0,26), Size=UDim2.new(1,-42,0,18),
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=9})
    statVals[lbl] = vl
end
mkStatCard("📅","Join Date",1)
mkStatCard("🕐","Last Seen",2)
mkStatCard("⏱","Playtime",3)
mkStatCard("👑","Rank",4)

-- RIGHT: player info + notes
local RC = mk("Frame",{Parent=CRW, BackgroundTransparency=1,
    Position=UDim2.new(0,431,0,0), Size=UDim2.new(1,-431,1,0), ZIndex=6})

local PILbl = mk("TextLabel",{Parent=RC, Text="Player Information", TextColor3=C.t0,
    Font=Enum.Font.GothamBold, TextSize=14, BackgroundTransparency=1,
    Position=UDim2.new(0,16,0,16), Size=UDim2.new(1,-32,0,24),
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7, Visible=false})

local PIBox = mk("Frame",{Parent=RC, BackgroundColor3=C.bg2, BorderSizePixel=0,
    Position=UDim2.new(0,16,0,48), Size=UDim2.new(1,-32,0,300),
    ZIndex=7, Visible=false})
cr(10, PIBox) st(C.brd, 1, PIBox)

local PI_FIELDS = {
    "Username","Display Name","User ID","Account Age",
    "Friends","Roblox Join Date","Last Online","Game"
}
local piVals = {}
for i, field in ipairs(PI_FIELDS) do
    local row = mk("Frame",{Parent=PIBox, BackgroundTransparency=1,
        Position=UDim2.new(0,0,0,(i-1)*37), Size=UDim2.new(1,0,0,37), ZIndex=8})
    if i < #PI_FIELDS then
        mk("Frame",{Parent=row, BackgroundColor3=C.brd,
            Position=UDim2.new(0,0,1,0), Size=UDim2.new(1,0,0,1), ZIndex=8})
    end
    mk("TextLabel",{Parent=row, Text=field, TextColor3=C.t1,
        Font=Enum.Font.Gotham, TextSize=12, BackgroundTransparency=1,
        Position=UDim2.new(0,14,.5,0), AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(.52,-14,1,0), TextXAlignment=Enum.TextXAlignment.Left, ZIndex=9})
    local vl = mk("TextLabel",{Parent=row, Text="—", TextColor3=C.t0,
        Font=Enum.Font.GothamBold, TextSize=12, BackgroundTransparency=1,
        Position=UDim2.new(1,-14,.5,0), AnchorPoint=Vector2.new(1,.5),
        Size=UDim2.new(.48,-14,1,0), TextXAlignment=Enum.TextXAlignment.Right, ZIndex=9})
    piVals[field] = vl
end

-- Notes
local NoteLbl = mk("TextLabel",{Parent=RC, Text="Notes", TextColor3=C.t0,
    Font=Enum.Font.GothamBold, TextSize=14, BackgroundTransparency=1,
    Position=UDim2.new(0,16,0,362), Size=UDim2.new(1,-32,0,24),
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7, Visible=false})
local NoteBox = mk("Frame",{Parent=RC, BackgroundColor3=C.bg2, BorderSizePixel=0,
    Position=UDim2.new(0,16,0,394), Size=UDim2.new(1,-32,0,56),
    ZIndex=7, Visible=false})
cr(10, NoteBox) st(C.brd, 1, NoteBox)
local NoteInput = mk("TextBox",{Parent=NoteBox, PlaceholderText="Add a note...",
    PlaceholderColor3=C.t2, Text="", TextColor3=C.t0,
    Font=Enum.Font.Gotham, TextSize=13, BackgroundTransparency=1,
    Position=UDim2.new(0,14,0,0), Size=UDim2.new(1,-56,1,0),
    ClearTextOnFocus=false, ZIndex=8, TextXAlignment=Enum.TextXAlignment.Left})
local SaveNote = mk("TextButton",{Parent=NoteBox, Text="💾", TextColor3=C.t1,
    Font=Enum.Font.Gotham, TextSize=18, BackgroundTransparency=1,
    Position=UDim2.new(1,-46,.5,0), AnchorPoint=Vector2.new(0,.5),
    Size=UDim2.new(0,36,0,36), ZIndex=8})
SaveNote.MouseButton1Click:Connect(function()
    if S.sel then
        S.notes[S.sel.Name] = NoteInput.Text
        toast("Note Saved","Saved for "..S.sel.Name)
    end
end)

-- show/hide detail
local function showDetail(v)
    PHdr.Visible=v; StatsRow.Visible=v
    PILbl.Visible=v; PIBox.Visible=v
    NoteLbl.Visible=v; NoteBox.Visible=v
    noSel.Visible=not v
end
showDetail(false)

-- populate detail
local function selectPlayer(p)
    S.sel = p
    showDetail(true)
    pName.Text    = p.Name
    pHandle.Text  = "@"..p.Name.."  •  "..tostring(p.UserId)
    task.spawn(function() pAvatar.Image = thumb(p.UserId) end)
    piVals["Username"].Text       = p.Name
    piVals["Display Name"].Text   = p.DisplayName
    piVals["User ID"].Text        = tostring(p.UserId)
    piVals["Account Age"].Text    = tostring(p.AccountAge).." days"
    piVals["Roblox Join Date"].Text = joinDateStr(p)
    piVals["Friends"].Text        = "—"
    piVals["Last Online"].Text    = "Now"
    piVals["Game"].Text           = game.Name or "Unknown"
    statVals["Join Date"].Text    = joinDateStr(p)
    statVals["Last Seen"].Text    = "Now"
    statVals["Playtime"].Text     = "—"
    statVals["Rank"].Text         = "Member"
    NoteInput.Text = S.notes[p.Name] or ""
end

-- player list entry
local function buildEntry(p)
    local row = mk("TextButton",{Parent=PSF, Text="", BackgroundColor3=C.bg1,
        BorderSizePixel=0, Size=UDim2.new(1,0,0,68), ZIndex=7})
    cr(10, row) st(C.brd, 1, row)
    local av = mk("ImageLabel",{Parent=row, BackgroundColor3=C.bg3,
        Position=UDim2.new(0,12,.5,0), AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(0,44,0,44), ZIndex=8})
    cr(22, av)
    task.spawn(function() av.Image = thumb(p.UserId) end)
    local dot = mk("Frame",{Parent=row, BackgroundColor3=C.grn,
        Position=UDim2.new(0,46,.5,16), AnchorPoint=Vector2.new(.5,.5),
        Size=UDim2.new(0,10,0,10), ZIndex=9})
    cr(5, dot) st(C.bg1, 2, dot)
    mk("TextLabel",{Parent=row, Text=p.Name, TextColor3=C.t0,
        Font=Enum.Font.GothamBold, TextSize=14, BackgroundTransparency=1,
        Position=UDim2.new(0,66,0,14), Size=UDim2.new(1,-78,0,22),
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8})
    mk("TextLabel",{Parent=row, Text="@"..p.Name.."  •  "..tostring(p.UserId),
        TextColor3=C.t1, Font=Enum.Font.Gotham, TextSize=11, BackgroundTransparency=1,
        Position=UDim2.new(0,66,0,36), Size=UDim2.new(1,-78,0,18),
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8})
    row.MouseEnter:Connect(function()
        if S.sel ~= p then tw(row,{BackgroundColor3=C.bg3},.1) end
    end)
    row.MouseLeave:Connect(function()
        if S.sel ~= p then tw(row,{BackgroundColor3=C.bg1},.1) end
    end)
    row.MouseButton1Click:Connect(function()
        for _, e in ipairs(S.entries) do
            if e.btn and e.btn.Parent then
                tw(e.btn,{BackgroundColor3=C.bg1},.1)
            end
        end
        tw(row,{BackgroundColor3=C.bg4},.1)
        selectPlayer(p)
    end)
    return row
end

local function refreshList(filter)
    for _, e in ipairs(S.entries) do
        if e.btn and e.btn.Parent then e.btn:Destroy() end
    end
    S.entries = {}
    local f = filter and filter:lower() or ""
    for _, p in ipairs(Plrs:GetPlayers()) do
        if f=="" or p.Name:lower():find(f,1,true)
                 or p.DisplayName:lower():find(f,1,true) then
            local btn = buildEntry(p)
            table.insert(S.entries,{p=p, btn=btn})
        end
    end
end
refreshList()

srch:GetPropertyChangedSignal("Text"):Connect(function() refreshList(srch.Text) end)
Plrs.PlayerAdded:Connect(function() task.wait(.5) refreshList(srch.Text) end)
Plrs.PlayerRemoving:Connect(function(p)
    if S.sel == p then showDetail(false) S.sel=nil end
    task.wait() refreshList(srch.Text)
end)

-- ═══════════════════════════════════════════════════════════
-- COMMANDS PAGE
-- ═══════════════════════════════════════════════════════════
local CmdsPage = mk("Frame",{Parent=CFR, BackgroundTransparency=1,
    Size=UDim2.fromScale(1,1), ZIndex=6, Visible=false})

local csrch = mk("TextBox",{Parent=CmdsPage, PlaceholderText="   🔍  Search commands...",
    PlaceholderColor3=C.t2, Text="", TextColor3=C.t0,
    Font=Enum.Font.Gotham, TextSize=13, BackgroundColor3=C.bg2,
    BorderSizePixel=0, Position=UDim2.new(0,16,0,14),
    Size=UDim2.new(1,-32,0,44), ClearTextOnFocus=false, ZIndex=7})
cr(8, csrch) st(C.brd, 1, csrch)

local CSF = mk("ScrollingFrame",{Parent=CmdsPage, BackgroundTransparency=1,
    Position=UDim2.new(0,16,0,70), Size=UDim2.new(1,-32,1,-78),
    ScrollBarThickness=3, ScrollBarImageColor3=C.bg4,
    BorderSizePixel=0, ZIndex=7, CanvasSize=UDim2.new(0,0,0,0)})
local CSL = mk("UIListLayout",{Parent=CSF, Padding=UDim.new(0,6),
    SortOrder=Enum.SortOrder.LayoutOrder})
CSL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    CSF.CanvasSize = UDim2.new(0,0,0, CSL.AbsoluteContentSize.Y+8)
end)

local function buildCmdList(filter)
    for _, c in ipairs(CSF:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
    end
    local f = filter and filter:lower() or ""
    local order = 0
    for _, cmd in ipairs(CMDS) do
        if f=="" or cmd.n:lower():find(f,1,true) or cmd.d:lower():find(f,1,true) then
            order = order+1
            local cb = mk("TextButton",{Parent=CSF, Text="",
                BackgroundColor3=C.bg2, BorderSizePixel=0,
                Size=UDim2.new(1,0,0,62), LayoutOrder=order, ZIndex=8})
            cr(8,cb) st(C.brd,1,cb)
            mk("TextLabel",{Parent=cb, Text=cmd.n, TextColor3=C.t0,
                Font=Enum.Font.GothamBold, TextSize=13, BackgroundTransparency=1,
                Position=UDim2.new(0,16,0,10), Size=UDim2.new(1,-48,0,22),
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=9})
            mk("TextLabel",{Parent=cb, Text=cmd.d, TextColor3=C.t1,
                Font=Enum.Font.Gotham, TextSize=12, BackgroundTransparency=1,
                Position=UDim2.new(0,16,0,34), Size=UDim2.new(1,-48,0,18),
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=9})
            mk("TextLabel",{Parent=cb, Text="›", TextColor3=C.t2,
                Font=Enum.Font.Gotham, TextSize=22, BackgroundTransparency=1,
                Position=UDim2.new(1,-32,.5,0), AnchorPoint=Vector2.new(0,.5),
                Size=UDim2.new(0,20,0,20), ZIndex=9})
            cb.MouseEnter:Connect(function() tw(cb,{BackgroundColor3=C.bg3},.1) end)
            cb.MouseLeave:Connect(function() tw(cb,{BackgroundColor3=C.bg2},.1) end)
            cb.MouseButton1Click:Connect(function()
                CmdInput.Text = cmd.n.." "
                CmdInput:CaptureFocus()
            end)
        end
    end
end
buildCmdList()
csrch:GetPropertyChangedSignal("Text"):Connect(function() buildCmdList(csrch.Text) end)

-- ═══════════════════════════════════════════════════════════
-- SETTINGS PAGE
-- ═══════════════════════════════════════════════════════════
local SettPage = mk("Frame",{Parent=CFR, BackgroundTransparency=1,
    Size=UDim2.fromScale(1,1), ZIndex=6, Visible=false})
mk("TextLabel",{Parent=SettPage, Text="Settings", TextColor3=C.t0,
    Font=Enum.Font.GothamBold, TextSize=16, BackgroundTransparency=1,
    Position=UDim2.new(0,20,0,20), Size=UDim2.new(1,-40,0,30),
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=7})
local SETT = {
    {lbl="Toggle Hotkey",  val="RightShift"},
    {lbl="Command Prefix", val="! or /"},
    {lbl="Admin Log",      val="Enabled"},
    {lbl="Version",        val="1.0.0"},
}
for i, si in ipairs(SETT) do
    local sf = mk("Frame",{Parent=SettPage, BackgroundColor3=C.bg2,
        BorderSizePixel=0, Position=UDim2.new(0,20,0,60+(i-1)*58),
        Size=UDim2.new(1,-40,0,48), ZIndex=7})
    cr(8,sf) st(C.brd,1,sf)
    mk("TextLabel",{Parent=sf, Text=si.lbl, TextColor3=C.t0,
        Font=Enum.Font.Gotham, TextSize=13, BackgroundTransparency=1,
        Position=UDim2.new(0,16,.5,0), AnchorPoint=Vector2.new(0,.5),
        Size=UDim2.new(.6,0,1,0), TextXAlignment=Enum.TextXAlignment.Left, ZIndex=8})
    mk("TextLabel",{Parent=sf, Text=si.val, TextColor3=C.t1,
        Font=Enum.Font.Gotham, TextSize=13, BackgroundTransparency=1,
        Position=UDim2.new(1,-16,.5,0), AnchorPoint=Vector2.new(1,.5),
        Size=UDim2.new(.4,-32,1,0), TextXAlignment=Enum.TextXAlignment.Right, ZIndex=8})
end

-- ═══════════════════════════════════════════════════════════
-- TAB SWITCHING
-- ═══════════════════════════════════════════════════════════
local pages = {Commands=CmdsPage, Players=PlayersPage, Settings=SettPage}
local function setTab(id)
    S.tab = id
    for tid, btn in pairs(tabBtns) do
        btn.TextColor3   = (tid==id) and C.t0 or C.t1
        tabInds[tid].Visible = (tid==id)
    end
    for pid, pg in pairs(pages) do pg.Visible = (pid==id) end
end
setTab("Players")
for id, btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function() setTab(id) end)
end

-- ═══════════════════════════════════════════════════════════
-- FLOATING COMMAND BAR
-- ═══════════════════════════════════════════════════════════
local CmdBar = mk("Frame",{Parent=G, BackgroundColor3=C.bg2, BorderSizePixel=0,
    Position=UDim2.new(.5,0,.93,0), AnchorPoint=Vector2.new(.5,.5),
    Size=UDim2.new(0,680,0,54), ZIndex=10})
cr(14, CmdBar) st(C.brd, 1, CmdBar)

local CmdPfx = mk("TextButton",{Parent=CmdBar, Text=">", TextColor3=C.t0,
    Font=Enum.Font.GothamBold, TextSize=16, BackgroundColor3=C.bg4,
    BorderSizePixel=0, Position=UDim2.new(0,0,.5,0), AnchorPoint=Vector2.new(0,.5),
    Size=UDim2.new(0,50,0,50), ZIndex=11})
cr(12, CmdPfx)

CmdInput = mk("TextBox",{Parent=CmdBar, PlaceholderText="Type a command...",
    PlaceholderColor3=C.t2, Text="", TextColor3=C.t0,
    Font=Enum.Font.Gotham, TextSize=14, BackgroundTransparency=1,
    Position=UDim2.new(0,58,0,0), Size=UDim2.new(1,-110,1,0),
    ClearTextOnFocus=false, ZIndex=11})
mk("UIPadding",{PaddingLeft=UDim.new(0,8)}, CmdInput)

local CmdSend = mk("TextButton",{Parent=CmdBar, Text="✈", TextColor3=C.t0,
    Font=Enum.Font.Gotham, TextSize=18, BackgroundTransparency=1,
    Position=UDim2.new(1,-48,.5,0), AnchorPoint=Vector2.new(0,.5),
    Size=UDim2.new(0,40,0,40), ZIndex=11})
CmdSend.MouseEnter:Connect(function() tw(CmdSend,{TextColor3=C.t1},.1) end)
CmdSend.MouseLeave:Connect(function() tw(CmdSend,{TextColor3=C.t0},.1) end)

CmdPfx.MouseButton1Click:Connect(function()
    local cycle = {">","!","/"}
    local cur = CmdPfx.Text
    local nxt = cycle[1]
    for i, v in ipairs(cycle) do if v==cur then nxt=cycle[(i%#cycle)+1] break end end
    CmdPfx.Text = nxt
end)

-- ─── COMMAND EXECUTOR (handlers wired when you send the list) ─────────────────
local H = {}

local function execCmd(raw)
    if not raw or raw:match("^%s*$") then return end
    raw = raw:gsub("^[!/]",""):match("^%s*(.-)%s*$")
    local parts = {}
    for w in raw:gmatch("%S+") do table.insert(parts, w) end
    if #parts == 0 then return end
    local cmd    = parts[1]:lower()
    local arg2   = parts[2]
    local arg3   = parts[3]
    local target = arg2 and (arg2=="me" and LP or findPlr(arg2)) or S.sel or LP
    local fn = H[cmd]
    if fn then
        local ok, err = pcall(fn, target, arg3)
        toast(ok and "Executed" or "Error",
              ok and cmd.." → "..(target and target.Name or "?")
                 or tostring(err):sub(1,80))
    else
        toast("Unknown","'"..cmd.."' — not wired yet.")
    end
    CmdInput.Text = ""
end

CmdSend.MouseButton1Click:Connect(function() execCmd(CmdInput.Text) end)
CmdInput.FocusLost:Connect(function(enter)
    if enter then execCmd(CmdInput.Text) end
end)

-- ═══════════════════════════════════════════════════════════
-- TOGGLE  RightShift
-- ═══════════════════════════════════════════════════════════
local panelOpen = true
UIS.InputBegan:Connect(function(i, proc)
    if proc then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        panelOpen = not panelOpen
        if panelOpen then
            P.Visible = true
            tw(P,{Size=UDim2.new(0,1100,0,660)},.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out)
        else
            tw(P,{Size=UDim2.new(0,1100,0,0)},.18)
            task.delay(.22,function() P.Visible=false end)
        end
    end
end)
closeB.MouseButton1Click:Connect(function()
    panelOpen = false
    tw(P,{Size=UDim2.new(0,1100,0,0)},.18)
    task.delay(.2,function() P.Visible=false end)
end)

-- ═══════════════════════════════════════════════════════════
-- LOAD TOAST
-- ═══════════════════════════════════════════════════════════
task.delay(.6,function()
    toast("Admin Commands Loaded!","You can now use the admin commands.")
end)
