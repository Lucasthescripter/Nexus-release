-- ============================================================
-- NEXUS - LAYER 2 PART 1: COMMAND ENGINE
-- Registry, parser, alias system, chat listener, runCommand
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.Nexus = _G.Nexus or {}
_G.Nexus.Commands = _G.Nexus.Commands or {}
_G.Nexus.Aliases = _G.Nexus.Aliases or {}
_G.Nexus.Prefix = _G.Nexus.Prefix or ";"

-- ============================================================
-- REGISTER COMMAND
-- ============================================================
function _G.Nexus.register(name, aliases, usage, args, desc, fn)
    if type(name) ~= "string" or name == "" then
        warn("[Nexus] register: name must be a non-empty string")
        return
    end
    name = name:lower()

    local entry = {
        name = name,
        aliases = aliases or {},
        usage = usage or name,
        args = args or "",
        desc = desc or "",
        fn = fn,
    }

    _G.Nexus.Commands[name] = entry

    for _, alias in ipairs(entry.aliases) do
        _G.Nexus.Aliases[alias:lower()] = name
    end

    if _G.Nexus.addCommandEntry then
        pcall(_G.Nexus.addCommandEntry, name, desc)
    end
end

-- ============================================================
-- LOOKUP COMMAND (name or alias)
-- ============================================================
function _G.Nexus.lookup(name)
    if not name then return nil end
    name = name:lower()
    if _G.Nexus.Commands[name] then
        return _G.Nexus.Commands[name]
    end
    local canonical = _G.Nexus.Aliases[name]
    if canonical and _G.Nexus.Commands[canonical] then
        return _G.Nexus.Commands[canonical]
    end
    return nil
end

-- ============================================================
-- TOKENIZER
-- ============================================================
local function tokenize(str)
    local tokens = {}
    local i = 1
    local len = #str
    while i <= len do
        local c = str:sub(i, i)
        if c:match("%s") then
            i = i + 1
        elseif c == '"' or c == "'" then
            local quote = c
            local start = i + 1
            local j = start
            while j <= len and str:sub(j, j) ~= quote do
                j = j + 1
            end
            table.insert(tokens, str:sub(start, j - 1))
            i = j + 1
        else
            local start = i
            while i <= len and not str:sub(i, i):match("%s") do
                i = i + 1
            end
            table.insert(tokens, str:sub(start, i - 1))
        end
    end
    return tokens
end
_G.Nexus.tokenize = tokenize

-- ============================================================
-- RUN COMMAND
-- ============================================================
function _G.Nexus.runCommand(raw)
    if type(raw) ~= "string" then return end
    raw = raw:gsub("^%s+", ""):gsub("%s+$", "")
    if raw == "" then return end

    local tokens = tokenize(raw)
    if #tokens == 0 then return end

    local name = tokens[1]:lower()
    local cmd = _G.Nexus.lookup(name)

    if not cmd then
        if _G.Nexus.notify then
            _G.Nexus.notify("Unknown Command", name .. " is not a valid command.")
        end
        return
    end

    local target = tokens[2]
    local restArgs = {}
    for i = 3, #tokens do
        table.insert(restArgs, tokens[i])
    end

    local rawArgs = raw:sub(#tokens[1] + 2)

    local ok, err = pcall(cmd.fn, target, restArgs, rawArgs)
    if not ok then
        warn("[Nexus] Command " .. name .. " errored: " .. tostring(err))
        if _G.Nexus.notify then
            _G.Nexus.notify("Command Error", tostring(err))
        end
    end
end

-- ============================================================
-- CHAT LISTENER
-- ============================================================
local function hookChat()
    local function onMessage(message)
        if not message or type(message) ~= "string" then return end
        local prefix = _G.Nexus.Prefix or ";"
        if prefix == "" then return end
        if message:sub(1, #prefix) ~= prefix then return end
        local raw = message:sub(#prefix + 1)
        _G.Nexus.runCommand(raw)
    end

    pcall(function()
        game:GetService("ReplicatedStorage")
            :WaitForChild("DefaultChatSystemChatEvents", 5)
            :WaitForChild("OnMessageDoneFiltering", 5)
            .OnClientEvent:Connect(function(data)
                if data and data.Message then
                    onMessage(data.Message)
                end
            end)
    end)

    pcall(function()
        local TextChatService = game:GetService("TextChatService")
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            TextChatService.MessageReceived:Connect(function(msg)
                if msg and msg.Text then
                    onMessage(msg.Text)
                end
            end)
        end
    end)
end

hookChat()

-- ============================================================
-- TEST COMMANDS
-- ============================================================
_G.Nexus.register(
    "cmds",
    { "commands", "help" },
    "cmds",
    "",
    "List a few commands and open the menu",
    function()
        if _G.Nexus.openMenu then
            _G.Nexus.openMenu()
        end
        if _G.Nexus.notify then
            _G.Nexus.notify("Nexus", "Type in the chat with the prefix " .. (_G.Nexus.Prefix or ";"))
        end
    end
)

_G.Nexus.register(
    "ping",
    { "latency" },
    "ping",
    "",
    "Show your current latency",
    function()
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        if _G.Nexus.notify then
            _G.Nexus.notify("Ping", ping .. " ms")
        end
    end
)

_G.Nexus.register(
    "echo",
    {},
    "echo <text>",
    "<text>",
    "Echo text back as a notification",
    function(target, args, rawArgs)
        if _G.Nexus.notify then
            _G.Nexus.notify("Echo", rawArgs ~= "" and rawArgs or "(empty)")
        end
    end
)

print("[Nexus] Layer 2 Part 1 loaded. Command engine online.")
-- ============================================================
-- NEXUS - LAYER 2 PART 2: MOVEMENT / CHARACTER COMMANDS
-- walkspeed, jumppower, fly, noclip, infjump, loopjump,
-- godmode, fullbright, unfly, ungodmode, etc.
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local function getChar()
    return LocalPlayer.Character
end

local function getHum()
    local char = getChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
    local char = getChar()
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function notify(title, text)
    if _G.Nexus.notify then
        _G.Nexus.notify(title, text)
    end
end

-- ============================================================
-- WALKSPEED
-- ============================================================
_G.Nexus.register("walkspeed", {"ws", "speed"}, "walkspeed <number>", "<number>", "Set your walkspeed", function(target, args)
    local speed = tonumber(args[1]) or tonumber(target)
    if not speed then
        notify("Walkspeed", "Provide a number.")
        return
    end
    local hum = getHum()
    if hum then
        hum.WalkSpeed = speed
        notify("Walkspeed", "Set to " .. speed)
    end
end)

-- ============================================================
-- JUMPPOWER
-- ============================================================
_G.Nexus.register("jumppower", {"jp", "jump"}, "jumppower <number>", "<number>", "Set your jumppower", function(target, args)
    local power = tonumber(args[1]) or tonumber(target)
    if not power then
        notify("JumpPower", "Provide a number.")
        return
    end
    local hum = getHum()
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = power
        notify("JumpPower", "Set to " .. power)
    end
end)

-- ============================================================
-- FLY
-- ============================================================
local flyConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil
local FLY_SPEED = 80

local function startFly()
    if flyConnection then return end
    local char = getChar()
    local hrp = getHRP()
    if not char or not hrp then return end

    local hum = getHum()
    if hum then hum.PlatformStand = true end

    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.P = 1250
    flyBodyVelocity.Parent = hrp

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBodyGyro.P = 10000
    flyBodyGyro.D = 500
    flyBodyGyro.CFrame = hrp.CFrame
    flyBodyGyro.Parent = hrp

    flyConnection = RunService.RenderStepped:Connect(function()
        local move = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        local cf = camera.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end

        if move.Magnitude > 0 then
            move = move.Unit * FLY_SPEED
        end

        if flyBodyVelocity then flyBodyVelocity.Velocity = move end
        if flyBodyGyro then flyBodyGyro.CFrame = cf end
    end)

    notify("Fly", "Enabled. W/A/S/D + Space/Ctrl.")
end

local function stopFly()
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    local hum = getHum()
    if hum then hum.PlatformStand = false end
    notify("Fly", "Disabled.")
end

_G.Nexus.register("fly", {}, "fly [speed]", "[speed]", "Enable flight", function(target, args)
    local speed = tonumber(args[1]) or tonumber(target)
    if speed then FLY_SPEED = speed end
    startFly()
end)

_G.Nexus.register("unfly", {"nofly"}, "unfly", "", "Disable flight", function()
    stopFly()
end)

-- ============================================================
-- NOCLIP
-- ============================================================
local noclipConn = nil

local function startNoclip()
    if noclipConn then return end
    noclipConn = RunService.Stepped:Connect(function()
        local char = getChar()
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
    notify("Noclip", "Enabled.")
end

local function stopNoclip()
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    local char = getChar()
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = true
            end
        end
    end
    notify("Noclip", "Disabled.")
end

_G.Nexus.register("noclip", {"nc", "clip"}, "noclip", "", "Toggle noclip", function()
    if noclipConn then stopNoclip() else startNoclip() end
end)

_G.Nexus.register("unnoclip", {"unclip"}, "unnoclip", "", "Force disable noclip", function()
    stopNoclip()
end)

-- ============================================================
-- INFINITE JUMP
-- ============================================================
local infJumpConn = nil

local function startInfJump()
    if infJumpConn then return end
    infJumpConn = UserInputService.JumpRequest:Connect(function()
        local hum = getHum()
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
    notify("Infinite Jump", "Enabled.")
end

local function stopInfJump()
    if infJumpConn then
        infJumpConn:Disconnect()
        infJumpConn = nil
    end
    notify("Infinite Jump", "Disabled.")
end

_G.Nexus.register("infjump", {"infinitejump"}, "infjump", "", "Toggle infinite jump", function()
    if infJumpConn then stopInfJump() else startInfJump() end
end)

_G.Nexus.register("uninfjump", {"uninfinitejump"}, "uninfjump", "", "Disable infinite jump", function()
    stopInfJump()
end)

-- ============================================================
-- LOOP JUMP
-- ============================================================
local loopJumpThread = nil

_G.Nexus.register("loopjump", {"autojump", "bhop"}, "loopjump", "", "Auto jump forever", function()
    if loopJumpThread then
        notify("Loop Jump", "Already running.")
        return
    end
    loopJumpThread = task.spawn(function()
        while loopJumpThread do
            local hum = getHum()
            if hum then hum.Jump = true end
            task.wait(0.1)
        end
    end)
    notify("Loop Jump", "Enabled.")
end)

_G.Nexus.register("unloopjump", {"unautojump", "unbhop"}, "unloopjump", "", "Stop loop jump", function()
    loopJumpThread = nil
    notify("Loop Jump", "Disabled.")
end)

-- ============================================================
-- GODMODE (basic client-side health lock)
-- ============================================================
local godConn = nil

local function startGod()
    if godConn then return end
    godConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end)
    notify("Godmode", "Enabled (client).")
end

local function stopGod()
    if godConn then
        godConn:Disconnect()
        godConn = nil
    end
    local hum = getHum()
    if hum then
        hum.MaxHealth = 100
        hum.Health = 100
    end
    notify("Godmode", "Disabled.")
end

_G.Nexus.register("godmode", {"god"}, "godmode", "", "Toggle godmode", function()
    if godConn then stopGod() else startGod() end
end)

_G.Nexus.register("ungodmode", {"ungod"}, "ungodmode", "", "Disable godmode", function()
    stopGod()
end)

-- ============================================================
-- FULLBRIGHT
-- ============================================================
local fullbrightOriginals = nil

_G.Nexus.register("fullbright", {"fb", "bright"}, "fullbright", "", "Make the game bright", function()
    if not fullbrightOriginals then
        fullbrightOriginals = {
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            GlobalShadows = Lighting.GlobalShadows,
        }
    end
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 3
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e6
    notify("Fullbright", "Enabled.")
end)

_G.Nexus.register("unfullbright", {"unfb", "unbright"}, "unfullbright", "", "Restore lighting", function()
    if fullbrightOriginals then
        Lighting.Ambient = fullbrightOriginals.Ambient
        Lighting.OutdoorAmbient = fullbrightOriginals.OutdoorAmbient
        Lighting.Brightness = fullbrightOriginals.Brightness
        Lighting.ClockTime = fullbrightOriginals.ClockTime
        Lighting.GlobalShadows = fullbrightOriginals.GlobalShadows
    end
    notify("Fullbright", "Disabled.")
end)

-- ============================================================
-- RESET / RESPAWN
-- ============================================================
_G.Nexus.register("reset", {"die", "respawn"}, "reset", "", "Reset your character", function()
    local hum = getHum()
    if hum then hum.Health = 0 end
end)

-- ============================================================
-- GOTO / TELEPORT
-- ============================================================
_G.Nexus.register("goto", {"tp", "to"}, "goto <player|me|x,y,z>", "<player|x,y,z>", "Teleport to a player or coordinate", function(target, args)
    if not target then
        notify("Goto", "Provide a target.")
        return
    end
    local hrp = getHRP()
    if not hrp then
        notify("Goto", "You have no character.")
        return
    end

    local lower = target:lower()
    if lower == "me" or lower == "self" then
        notify("Goto", "You are already there.")
        return
    end

    -- Coordinates x,y,z
    local x, y, z = target:match("([%-%d%.]+),([%-%d%.]+),([%-%d%.]+)")
    if x and y and z then
        hrp.CFrame = CFrame.new(tonumber(x), tonumber(y), tonumber(z))
        notify("Goto", "Teleported to " .. target)
        return
    end

    -- Player
    local plr = _G.Nexus.findPlayer and _G.Nexus.findPlayer(target)
    if plr and plr.Character then
        local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
        if tHRP then
            hrp.CFrame = tHRP.CFrame + Vector3.new(0, 2, 0)
            notify("Goto", "Teleported to " .. plr.Name)
        end
    else
        notify("Goto", "Player not found: " .. tostring(target))
    end
end)

-- ============================================================
-- BRING
-- ============================================================
_G.Nexus.register("bring", {}, "bring <player>", "<player>", "Bring a player to you", function(target)
    if not target then
        notify("Bring", "Provide a target.")
        return
    end
    local plr = _G.Nexus.findPlayer and _G.Nexus.findPlayer(target)
    if not plr or not plr.Character then
        notify("Bring", "Player not found.")
        return
    end
    local hrp = getHRP()
    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp and tHRP then
        tHRP.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 3
        notify("Bring", "Brought " .. plr.Name)
    end
end)

print("[Nexus] Layer 2 Part 2 loaded. Movement commands ready.")
-- ============================================================
-- NEXUS - LAYER 2 PART 3: VISUALS / ESP COMMANDS
-- esp, chams, fullbright, nightmare, fov, firstp, thirdp,
-- shiftlock, cameratype, unesp
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function notify(title, text)
    if _G.Nexus.notify then
        _G.Nexus.notify(title, text)
    end
end

-- ============================================================
-- ESP / CHAMS
-- ============================================================
local espInstances = {}

local function clearESP()
    for _, obj in pairs(espInstances) do
        if obj.highlight and obj.highlight.Parent then
            obj.highlight:Destroy()
        end
        if obj.billboard and obj.billboard.Parent then
            obj.billboard:Destroy()
        end
        if obj.connection then
            obj.connection:Disconnect()
        end
    end
    espInstances = {}
end

local function buildESP(player, showName, showDistance, color)
    local char = player.Character
    if not char then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "NexusESP"
    highlight.Adornee = char
    highlight.FillColor = color or Color3.fromRGB(61, 214, 140)
    highlight.FillTransparency = 0.6
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "NexusESPTag"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Visible = showName
    nameLabel.Parent = billboard

    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "DistLabel"
    distLabel.Size = UDim2.new(1, 0, 0, 16)
    distLabel.Position = UDim2.new(0, 0, 0, 20)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = ""
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 12
    distLabel.Visible = showDistance
    distLabel.Parent = billboard

    local connection
    if showDistance then
        connection = RunService.RenderStepped:Connect(function()
            if not char or not char.Parent then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and myHRP then
                local dist = (hrp.Position - myHRP.Position).Magnitude
                distLabel.Text = math.floor(dist) .. " studs"
            end
        end)
    end

    espInstances[player] = {
        highlight = highlight,
        billboard = billboard,
        connection = connection,
    }
end

local function refreshESP(showName, showDistance, color)
    clearESP()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            buildESP(plr, showName, showDistance, color)
        end
    end
end

local espPlayersConn
local espAddedConn
local espRemovingConn

local function startESP(showName, showDistance, color)
    refreshESP(showName, showDistance, color)
    if espPlayersConn then espPlayersConn:Disconnect() end
    if espAddedConn then espAddedConn:Disconnect() end
    if espRemovingConn then espRemovingConn:Disconnect() end
    espAddedConn = Players.PlayerAdded:Connect(function(plr)
        task.wait(1)
        if plr ~= LocalPlayer then
            buildESP(plr, showName, showDistance, color)
        end
    end)
    espRemovingConn = Players.PlayerRemoving:Connect(function(plr)
        if espInstances[plr] then
            if espInstances[plr].highlight then espInstances[plr].highlight:Destroy() end
            if espInstances[plr].billboard then espInstances[plr].billboard:Destroy() end
            if espInstances[plr].connection then espInstances[plr].connection:Disconnect() end
            espInstances[plr] = nil
        end
    end)
    notify("ESP", "Enabled.")
end

local function stopESP()
    clearESP()
    if espPlayersConn then espPlayersConn:Disconnect() espPlayersConn = nil end
    if espAddedConn then espAddedConn:Disconnect() espAddedConn = nil end
    if espRemovingConn then espRemovingConn:Disconnect() espRemovingConn = nil end
    notify("ESP", "Disabled.")
end

_G.Nexus.register("esp", {"espplayers"}, "esp", "", "ESP all players with names + distance", function()
    startESP(true, true, Color3.fromRGB(61, 214, 140))
end)

_G.Nexus.register("chams", {}, "chams", "", "ESP without text", function()
    startESP(false, false, Color3.fromRGB(255, 60, 60))
end)

_G.Nexus.register("unesp", {"unchams", "esp off"}, "unesp", "", "Disable ESP / chams", function()
    stopESP()
end)

-- ============================================================
-- FULLBRIGHT (visual)
-- ============================================================
local fullbrightOriginals

_G.Nexus.register("fullbright", {"fb", "bright"}, "fullbright", "", "Make the game bright", function()
    if not fullbrightOriginals then
        fullbrightOriginals = {
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            GlobalShadows = Lighting.GlobalShadows,
            FogEnd = Lighting.FogEnd,
        }
    end
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 3
    Lighting.ClockTime = 14
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e6
    notify("Fullbright", "Enabled.")
end)

_G.Nexus.register("unfullbright", {"unfb", "unbright"}, "unfullbright", "", "Restore lighting", function()
    if fullbrightOriginals then
        for k, v in pairs(fullbrightOriginals) do
            Lighting[k] = v
        end
    end
    notify("Fullbright", "Disabled.")
end)

-- ============================================================
-- NIGHTMARE
-- ============================================================
_G.Nexus.register("nightmare", {"nm"}, "nightmare", "", "Make it dark and spooky", function()
    Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
    Lighting.Brightness = 0
    Lighting.ClockTime = 0
    Lighting.GlobalShadows = true
    Lighting.FogColor = Color3.fromRGB(0, 0, 0)
    Lighting.FogStart = 0
    Lighting.FogEnd = 40
    notify("Nightmare", "Enabled.")
end)

_G.Nexus.register("unnightmare", {"unnm"}, "unnightmare", "", "Disable nightmare mode", function()
    if fullbrightOriginals then
        for k, v in pairs(fullbrightOriginals) do
            Lighting[k] = v
        end
    else
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 1e6
    end
    notify("Nightmare", "Disabled.")
end)

-- ============================================================
-- DAY / NIGHT / TIME
-- ============================================================
_G.Nexus.register("day", {}, "day", "", "Set time to day", function()
    Lighting.ClockTime = 14
    notify("Time", "Day.")
end)

_G.Nexus.register("night", {}, "night", "", "Set time to night", function()
    Lighting.ClockTime = 0
    notify("Time", "Night.")
end)

_G.Nexus.register("time", {}, "time <0-24>", "<number>", "Set time of day", function(target, args)
    local t = tonumber(args[1]) or tonumber(target)
    if t then Lighting.ClockTime = t notify("Time", "Set to " .. t) end
end)

-- ============================================================
-- FOV
-- ============================================================
_G.Nexus.register("fov", {}, "fov <number>", "<number>", "Set camera FOV", function(target, args)
    local n = tonumber(args[1]) or tonumber(target)
    if n then
        Camera.FieldOfView = n
        notify("FOV", "Set to " .. n)
    end
end)

-- ============================================================
-- FIRST / THIRD PERSON
-- ============================================================
_G.Nexus.register("firstp", {"fp", "firstperson"}, "firstp", "", "First person mode", function()
    LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    notify("Camera", "First person.")
end)

_G.Nexus.register("thirdp", {"tp", "thirdperson"}, "thirdp", "", "Third person mode", function()
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
    notify("Camera", "Third person.")
end)

-- ============================================================
-- SHIFTLOCK
-- ============================================================
local shiftLockConn

_G.Nexus.register("shiftlock", {"sl"}, "shiftlock", "", "Toggle shiftlock", function()
    if shiftLockConn then
        shiftLockConn:Disconnect()
        shiftLockConn = nil
        LocalPlayer.DevEnableMouseLock = false
        notify("Shiftlock", "Disabled.")
        return
    end
    LocalPlayer.DevEnableMouseLock = true
    shiftLockConn = RunService.RenderStepped:Connect(function()
        LocalPlayer.DevEnableMouseLock = true
    end)
    notify("Shiftlock", "Enabled.")
end)

_G.Nexus.register("unshiftlock", {"unsl"}, "unshiftlock", "", "Disable shiftlock", function()
    if shiftLockConn then shiftLockConn:Disconnect() shiftLockConn = nil end
    LocalPlayer.DevEnableMouseLock = false
    notify("Shiftlock", "Disabled.")
end)

-- ============================================================
-- X-RAY
-- ============================================================
_G.Nexus.register("xray", {}, "xray", "", "See through walls", function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Transparency > 0 then
            obj.LocalTransparencyModifier = 0.9
        end
    end
    notify("X-Ray", "Enabled.")
end)

_G.Nexus.register("unxray", {}, "unxray", "", "Disable x-ray", function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.LocalTransparencyModifier = 0
        end
    end
    notify("X-Ray", "Disabled.")
end)

print("[Nexus] Layer 2 Part 3 loaded. Visual commands ready.")
-- ============================================================
-- NEXUS - LAYER 2 PART 4: FLING / DAMAGE COMMANDS
-- fling, loopfling, vfling, hfling, punch, aura, kill,
-- loopbring, vehicle fling kick
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function findPlayer(q)
    if _G.Nexus.findPlayer then return _G.Nexus.findPlayer(q) end
    return nil
end

-- ============================================================
-- FLING (touch-based basic fling)
-- ============================================================
local function doFling(targetChar, mode)
    local hrp = getHRP()
    if not hrp or not targetChar then return end
    local tHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not tHRP then return end

    local oldCFrame = hrp.CFrame
    for i = 1, 4 do
        if mode == "v" then
            hrp.CFrame = tHRP.CFrame + Vector3.new(0, 5, 0)
            RunService.Heartbeat:Wait()
            hrp.CFrame = tHRP.CFrame - Vector3.new(0, 5, 0)
        elseif mode == "h" then
            hrp.CFrame = tHRP.CFrame + tHRP.CFrame.RightVector * 5
            RunService.Heartbeat:Wait()
            hrp.CFrame = tHRP.CFrame - tHRP.CFrame.RightVector * 5
        else
            hrp.CFrame = tHRP.CFrame + Vector3.new(0, 3, 0)
            RunService.Heartbeat:Wait()
            hrp.CFrame = tHRP.CFrame
        end
        RunService.Heartbeat:Wait()
    end
    hrp.CFrame = oldCFrame
end

_G.Nexus.register("fling", {}, "fling <player>", "<player>", "Fling a player", function(target)
    if not target then notify("Fling", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Fling", "Player not found.") return end
    doFling(plr.Character, "normal")
    notify("Fling", "Flinged " .. plr.Name)
end)

_G.Nexus.register("vfling", {"verticalfling"}, "vfling <player>", "<player>", "Vertical fling", function(target)
    if not target then notify("Vfling", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Vfling", "Player not found.") return end
    doFling(plr.Character, "v")
    notify("Vfling", "Flinged " .. plr.Name)
end)

_G.Nexus.register("hfling", {"horizontalfling"}, "hfling <player>", "<player>", "Horizontal fling", function(target)
    if not target then notify("Hfling", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Hfling", "Player not found.") return end
    doFling(plr.Character, "h")
    notify("Hfling", "Flinged " .. plr.Name)
end)

-- ============================================================
-- LOOP FLING
-- ============================================================
local loopFlingThreads = {}

local function startLoopFling(plr, mode)
    if loopFlingThreads[plr] then return end
    loopFlingThreads[plr] = true
    task.spawn(function()
        while loopFlingThreads[plr] do
            if plr.Character then
                doFling(plr.Character, mode)
            end
            task.wait(0.05)
        end
    end)
end

local function stopLoopFling(plr)
    loopFlingThreads[plr] = nil
end

_G.Nexus.register("loopfling", {"lfling"}, "loopfling <player>", "<player>", "Loop fling a player", function(target)
    if not target then notify("LoopFling", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr then notify("LoopFling", "Player not found.") return end
    startLoopFling(plr, "normal")
    notify("LoopFling", "Started on " .. plr.Name)
end)

_G.Nexus.register("unloopfling", {"unlfling"}, "unloopfling <player>", "<player>", "Stop loop fling", function(target)
    if not target then
        for plr in pairs(loopFlingThreads) do loopFlingThreads[plr] = nil end
        notify("LoopFling", "Stopped all.")
        return
    end
    local plr = findPlayer(target)
    if plr then stopLoopFling(plr) notify("LoopFling", "Stopped on " .. plr.Name) end
end)

-- ============================================================
-- PUNCH TOOL (simple)
-- ============================================================
local function givePunch()
    local char = getChar()
    if not char then return end
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    if not backpack then return end

    local tool = Instance.new("Tool")
    tool.Name = "NexusPunch"
    tool.RequiresHandle = false
    tool.CanBeDropped = false

    tool.Activated:Connect(function()
        local hrp = getHRP()
        if not hrp then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                if tHRP and (tHRP.Position - hrp.Position).Magnitude < 8 then
                    doFling(plr.Character, "normal")
                end
            end
        end
    end)

    tool.Parent = backpack
end

_G.Nexus.register("punch", {}, "punch", "", "Get a punch tool that flings on click", function()
    givePunch()
    notify("Punch", "Tool added to backpack.")
end)

-- ============================================================
-- AURA (auto-fling nearby players)
-- ============================================================
local auraConn

_G.Nexus.register("aura", {}, "aura [radius]", "[radius]", "Auto fling nearby players", function(target, args)
    local radius = tonumber(args[1]) or tonumber(target) or 10
    if auraConn then auraConn:Disconnect() end
    auraConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if not hrp then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                if tHRP and (tHRP.Position - hrp.Position).Magnitude < radius then
                    doFling(plr.Character, "normal")
                end
            end
        end
    end)
    notify("Aura", "Enabled (radius " .. radius .. ")")
end)

_G.Nexus.register("unaura", {}, "unaura", "", "Stop aura", function()
    if auraConn then auraConn:Disconnect() auraConn = nil end
    notify("Aura", "Disabled.")
end)

-- ============================================================
-- KILL
-- ============================================================
_G.Nexus.register("kill", {}, "kill <player>", "<player>", "Set a player's health to 0", function(target)
    if not target then notify("KKill", "Provide a target.") returnick end
    local plr = findPlayer(target",)
    if not plr or not pl "r.Character then notify("Kill", "PlayerPlayer not found.") return end
    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Health = 0 end
    notify("Kill", "Killed " .. plr.Name)
end)

-- ============================================================
-- LOOP BRING
-- ============================================================
local loopBringThreads = {}

_G.Nexus.register("loopbring", {"lbring"}, "loopbring <player>", "<player>", "Loop bring a player", function(target)
    if not target then notify("LoopBring", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr then notify("LoopBring", "Player not found.") return end
    if loopBringThreads[plr] then return end
    loopBringThreads[plr] = true
    task.spawn(function()
        while loopBringThreads[plr] do
            local hrp = getHRP()
            if hrp and plr.Character then
                local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                if tHRP then
                    tHRP.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 3
                end
            end
            task.wait(0.05)
        end
    end)
    notify("LoopBring", "Started on " .. plr.Name)
end)

_G.Nexus.register("unloopbring", {"unlbring"}, "unloopbring", "", "Stop all loop brings", function()
    for plr in pairs(loopBringThreads) do loopBringThreads[plr] = nil end
    notify("LoopBring", "Stopped.")
end)

-- ============================================================
-- VEHICLE FLING KICK (the one from the beginning)
-- ============================================================
local FLING_SPEED = 5000
local TP_OFFSET = 3

local function findNearestCar(maxDist)
    local hrp = getHRP()
    if not hrp then return nil end
    local myPos = hrp.Position
    local closest, closestDist = nil, maxDist or 30
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("VehicleSeat") then
            local car = obj:FindFirstAncestorOfClass("Model")
            if car and car.PrimaryPart then
                local dist = (car.PrimaryPart.Position - myPos).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = car
                end
            end
        end
    end
    return closest
end

_G.Nexus.register("flingkick", {"vflingkick", "fk"}, "flingkick <player>", "<player>", "Vehicle fling kick (gets target kicked by anti-cheat)", function(target)
    if not target then notify("FlingKick", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Fling not found.") return end
    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
    if not tHRP then return end

    local car = findNearestCar(40)
    if not car then notify("FlingKick", "No vehicle within 40 studs.") return end

    -- Sit in the car
    local seat
    for _, d in ipairs(car:GetDescendants()) do
        if d:IsA("VehicleSeat") then seat = d break end
    end
    if not seat then notify("FlingKick", "No seat found.") return end

    local hrp = getHRP()
    hrp.CFrame = seat.CFrame
    task.wait(0.1)
    seat:Sit(LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
    task.wait(0.2)

    -- Unseat and fling the car at the target
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Sit = false end
    task.wait(0.1)

    if car.PrimaryPart then
        car:PivotTo(CFrame.new((tHRP.CFrame + tHRP.CFrame.LookVector * -TP_OFFSET).Position, tHRP.Position))
    end
    task.wait(0.05)

    for _, part in ipairs(car:GetDescendants()) do
        if part:IsA("BasePart") then
            part.AssemblyLinearVelocity = (tHRP.Position - part.Position).Unit * FLING_SPEED
            part.AssemblyAngularVelocity = Vector3.new(FLING_SPEED, FLING_SPEED, FLING_SPEED)
        end
    end

    notify("FlingKick", "Launched vehicle at " .. plr.Name)
end)

print("[Nexus] Layer 2 Part 4 loaded. Fling / damage commands ready.")
-- ============================================================
-- NEXUS - LAYER 2 PART 5: REMOTES / EXPLOITATION
-- fireremote, fireremotes, remotespy, fireclickdetectors,
-- fireproximityprompts, placeid, jobid, gameid
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function findPlayer(q)
    if _G.Nexus.findPlayer then return _G.Nexus.findPlayer(q) end
end

-- ============================================================
-- GATHER REMOTES
-- ============================================================
local function getAllRemotes()
    local remotes = {}
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("BindableEvent") then
            table.insert(remotes, obj)
        end
    end
    return remotes
end

-- ============================================================
-- FIREREMOTES (fire everything)
-- ============================================================
_G.Nexus.register("fireremotes", {"fremotes"}, "fireremotes", "", "Fire every remote event in the game", function()
    local remotes = getAllRemotes()
    local count = 0
    for _, remote in ipairs(remotes) do
        if remote:IsA("RemoteEvent") then
            pcall(function()
                remote:FireServer()
                count = count + 1
            end)
        end
    end
    notify("Fireremotes", "Fired " .. count .. " remote events.")
end)

-- ============================================================
-- FIREREMOTE (fire a specific one by name)
-- ============================================================
_G.Nexus.register("fireremote", {"fremote"}, "fireremote <name>", "<name>", "Fire a specific remote by name", function(target)
    if not target then notify("Fireremote", "Provide a remote name.") return end
    local lower = target:lower()
    local count = 0
    for _, obj in ipairs(game:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and obj.Name:lower():find(lower, 1, true) then
            pcall(function()
                if obj:IsA("RemoteEvent") then
                    obj:FireServer()
                end
                count = count + 1
            end)
        end
    end
    notify("Fireremote", "Fired " .. count .. " matching remotes.")
end)

-- ============================================================
-- FIRECLICKDETECTORS
-- ============================================================
_G.Nexus.register("fireclickdetectors", {"fcd"}, "fireclickdetectors", "", "Fire every ClickDetector", function()
    local count = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ClickDetector") then
            pcall(function()
                fireclickdetector(obj)
                count = count + 1
            end)
        end
    end
    notify("FireClickDetectors", "Fired " .. count .. " click detectors.")
end)

-- ============================================================
-- FIREPROXIMITYPROMPTS
-- ============================================================
_G.Nexus.register("fireproximityprompts", {"fpp", "fireprompts"}, "fireproximityprompts", "", "Fire every ProximityPrompt", function()
    local count = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            pcall(function()
                fireproximityprompt(obj)
                count = count + 1
            end)
        end
    end
    notify("FirePrompts", "Fired " .. count .. " proximity prompts.")
end)

-- ============================================================
-- REMOTESPY (basic)
-- ============================================================
local spyConnections = {}

_G.Nexus.register("remotespy", {"rspy"}, "remotespy", "", "Log all remote events being fired", function()
    if #spyConnections > 0 then
        notify("RemoteSpy", "Already running.")
        return
    end
    local remoteCache = {}
    local function hookRemote(remote)
        if remoteCache[remote] then return end
        remoteCache[remote] = true
        local orig = remote.FireServer
        -- Best effort, only works on some executors with hookfunction
        if hookfunction then
            hookfunction(remote.FireServer, function(self, ...)
                print("[Nexus RemoteSpy] " .. self:GetFullName(), ...)
                return orig(self, ...)
            end)
        end
    end
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then hookRemote(obj) end
    end
    local addConn = game.DescendantAdded:Connect(function(obj)
        if obj:IsA("RemoteEvent") then hookRemote(obj) end
    end)
    table.insert(spyConnections, addConn)
    notify("RemoteSpy", "Started. Check the console.")
end)

_G.Nexus.register("unremotespy", {"unrspy"}, "unremotespy", "", "Stop remote spy", function()
    for _, c in ipairs(spyConnections) do c:Disconnect() end
    spyConnections = {}
    notify("RemoteSpy", "Stopped.")
end)

-- ============================================================
-- INFO COMMANDS
-- ============================================================
_G.Nexus.register("placeid", {"pid"}, "placeid", "", "Copy the PlaceId to clipboard", function()
    pcall(function()
        if setclipboard then setclipboard(tostring(game.PlaceId)) end
    end)
    notify("PlaceId", tostring(game.PlaceId))
end)

_G.Nexus.register("gameid", {"universeid", "gid"}, "gameid", "", "Copy the GameId to clipboard", function()
    pcall(function()
        if setclipboard then setclipboard(tostring(game.GameId)) end
    end)
    notify("GameId", tostring(game.GameId))
end)

_G.Nexus.register("jobid", {"jid"}, "jobid", "", "Copy the JobId to clipboard", function()
    pcall(function()
        if setclipboard then setclipboard(game.JobId) end
    end)
    notify("JobId", game.JobId)
end)

_G.Nexus.register("gameinfo", {"ginfo"}, "gameinfo", "", "Show basic game info", function()
    notify("Game Info", "Place: " .. game.PlaceId .. " | Job: " .. game.JobId:sub(1, 8) .. "...")
end)

_G.Nexus.register("playerinfo", {"pinfo"}, "playerinfo <player>", "<player>", "Show info about a player", function(target)
    if not target then notify("PlayerInfo", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr then notify("PlayerInfo", "Player not found.") return end
    notify(plr.Name, "ID: " .. plr.UserId .. " | Display: " .. plr.DisplayName)
end)

_G.Nexus.register("getgenv", {"genv"}, "getgenv", "", "Print executor globals", function()
    if getgenv then
        print("[Nexus] getgenv:", getgenv())
        notify("getgenv", "Printed to console.")
    else
        notify("getgenv", "Not available in this executor.")
    end
end)

-- ============================================================
-- COPY PLAYER INFO
-- ============================================================
_G.Nexus.register("copyname", {"cname"}, "copyname <player>", "<player>", "Copy a player's username", function(target)
    if not target then return end
    local plr = findPlayer(target)
    if not plr then return end
    pcall(function() if setclipboard then setclipboard(plr.Name) end end)
    notify("Copied", plr.Name)
end)

_G.Nexus.register("copyid", {"cid"}, "copyid <player>", "<player>", "Copy a player's user id", function(target)
    if not target then return end
    local plr = findPlayer(target)
    if not plr then return end
    pcall(function() if setclipboard then setclipboard(tostring(plr.UserId)) end end)
    notify("Copied", tostring(plr.UserId))
end)

_G.Nexus.register("copydisplay", {"cdisplay"}, "copydisplay <player>", "<player>", "Copy a player's display name", function(target)
    if not target then return end
    local plr = findPlayer(target)
    if not plr then return end
    pcall(function() if setclipboard then setclipboard(plr.DisplayName) end end)
    notify("Copied", plr.DisplayName)
end)

-- ============================================================
-- LOADSTRING / URL
-- ============================================================
_G.Nexus.register("loadstring", {"ls", "execute"}, "loadstring <code>", "<code>", "Run a loadstring", function(target, args, rawArgs)
    if not rawArgs or rawArgs == "" then notify("Loadstring", "Provide code.") return end
    local fn, err = loadstring(rawArgs)
    if fn then
        pcall(fn)
        notify("Loadstring", "Executed.")
    else
        notify("Loadstring", "Error: " .. tostring(err))
    end
end)

_G.Nexus.register("url", {}, "url <link>", "<link>", "Run a script from a URL", function(target, args, rawArgs)
    if not rawArgs or rawArgs == "" then notify("URL", "Provide a link.") return end
    pcall(function()
        loadstring(game:HttpGet(rawArgs))()
        notify("URL", "Executed.")
    end)
end)

print("[Nexus] Layer 2 Part 5 loaded. Remotes / exploitation commands ready.")
-- ============================================================
-- NEXUS - LAYER 2 PART 6: TOOLS / INVENTORY COMMANDS
-- tools, grabtools, droptool, droptools, equiptool,
-- equiptools, unequiptools, savetools, loadtools, notools,
-- copytools, givetool
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function findPlayer(q)
    if _G.Nexus.findPlayer then return _G.Nexus.findPlayer(q) end
end

local function getBackpack()
    return LocalPlayer:FindFirstChildOfClass("Backpack")
end

local function getChar()
    return LocalPlayer.Character
end

-- ============================================================
-- TOOLS (list everything in the game)
-- ============================================================
_G.Nexus.register("tools", {"alltools"}, "tools", "", "List every tool in the game", function()
    local names = {}
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("Tool") then
            table.insert(names, obj.Name)
        end
    end
    notify("Tools", "Found " .. #names .. " tools in the game.")
    for _, n in ipairs(names) do print("[Nexus Tools] " .. n) end
end)

-- ============================================================
-- GRAB TOOLS (grab dropped tools in workspace)
-- ============================================================
local function grabTool(tool)
    local backpack = getBackpack()
    if not backpack then return end
    local char = getChar()
    if not char then return end
    -- Already equipped?
    if tool.Parent == char then return end
    tool.Parent = backpack
end

_G.Nexus.register("grabtools", {"grab"}, "grabtools [filter] [range]", "[filter] [range]", "Grab nearby dropped tools", function(target, args)
    local filter = args[1] or target
    local range = tonumber(args[2]) or 50
    local char = getChar()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local count = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") then
            local handle = obj:FindFirstChild("Handle")
            if handle then
                local dist = (handle.Position - hrp.Position).Magnitude
                if dist <= range then
                    if not filter or obj.Name:lower():find(filter:lower(), 1, true) then
                        grabTool(obj)
                        count = count + 1
                    end
                end
            end
        end
    end
    notify("GrabTools", "Grabbed " .. count .. " tools.")
end)

-- ============================================================
-- DROP TOOL
-- ============================================================
local function dropAllTools()
    local char = getChar()
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            obj.Parent = Workspace
        end
    end
end

_G.Nexus.register("droptool", {"dtool"}, "droptool", "", "Drop a random equipped tool", function()
    local char = getChar()
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            obj.Parent = Workspace
            notify("DropTool", "Dropped " .. obj.Name)
            return
        end
    end
end)

_G.Nexus.register("droptools", {"dropalltools"}, "droptools", "", "Drop all equipped tools", function()
    dropAllTools()
    notify("DropTools", "Dropped all equipped tools.")
end)

-- ============================================================
-- EQUIP TOOLS
-- ============================================================
_G.Nexus.register("equiptools", {"equipall"}, "equiptools", "", "Equip every tool in your backpack", function()
    local char = getChar()
    local backpack = getBackpack()
    if not char or not backpack then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local count = 0
    for _, obj in ipairs(backpack:GetChildren()) do
        if obj:IsA("Tool") then
            hum:EquipTool(obj)
            count = count + 1
        end
    end
    notify("EquipTools", "Equipped " .. count .. " tools.")
end)

_G.Nexus.register("unequiptools", {"unequipall"}, "unequiptools", "", "Unequip every tool you are holding", function()
    local char = getChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum:UnequipTools() end
    notify("UnequipTools", "Unequipped all.")
end)

_G.Nexus.register("equiptool", {"etool"}, "equiptool <name>", "<name>", "Equip a specific tool by name", function(target)
    if not target then notify("EquipTool", "Provide a tool name.") return end
    local char = getChar()
    local backpack = getBackpack()
    if not char or not backpack then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    for _, obj in ipairs(backpack:GetChildren()) do
        if obj:IsA("Tool") and obj.Name:lower():find(target:lower(), 1, true) then
            hum:EquipTool(obj)
            notify("EquipTool", "Equipped " .. obj.Name)
            return
        end
    end
    notify("EquipTool", "Tool not found: " .. target)
end)

-- ============================================================
-- SAVE / LOAD TOOLS
-- ============================================================
_G.Nexus.SavedTools = _G.Nexus.SavedTools or {}

_G.Nexus.register("savetools", {"stools"}, "savetools", "", "Save all current tools to memory", function()
    local char = getChar()
    local backpack = getBackpack()
    if not char or not backpack then return end

    _G.Nexus.SavedTools = {}

    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            table.insert(_G.Nexus.SavedTools, obj)
        end
    end
    for _, obj in ipairs(backpack:GetChildren()) do
        if obj:IsA("Tool") then
            table.insert(_G.Nexus.SavedTools, obj)
        end
    end
    notify("SaveTools", "Saved " .. #_G.Nexus.SavedTools .. " tools.")
end)

_G.Nexus.register("loadtools", {"ltools"}, "loadtools", "", "Restore saved tools", function()
    local backpack = getBackpack()
    if not backpack then return end
    local count = 0
    for _, tool in ipairs(_G.Nexus.SavedTools) do
        if tool and tool.Parent == nil then
            tool.Parent = backpack
            count = count + 1
        end
    end
    notify("LoadTools", "Restored " .. count .. " tools.")
end)

-- ============================================================
-- NO TOOLS (remove every tool you have)
-- ============================================================
_G.Nexus.register("notools", {}, "notools", "", "Remove all your tools", function()
    local char = getChar()
    local backpack = getBackpack()
    if char then
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Tool") then obj:Destroy() end
        end
    end
    if backpack then
        for _, obj in ipairs(backpack:GetChildren()) do
            if obj:IsA("Tool") then obj:Destroy() end
        end
    end
    notify("NoTools", "All tools removed.")
end)

-- ============================================================
-- COPY TOOLS (copy from another player)
-- ============================================================
_G.Nexus.register("copytools", {"ctools"}, "copytools <player>", "<player>", "Copy a player's tools", function(target)
    if not target then notify("CopyTools", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("CopyTools", "Player not found.") return end

    local backpack = getBackpack()
    if not backpack then return end

    local count = 0
    for _, obj in ipairs(plr.Character:GetChildren()) do
        if obj:IsA("Tool") then
            local clone = obj:Clone()
            clone.Parent = backpack
            count = count + 1
        end
    end
    notify("CopyTools", "Copied " .. count .. " tools from " .. plr.Name)
end)

-- ============================================================
-- GIVE TOOL (spawn a copy of a tool by name from the game)
-- ============================================================
_G.Nexus.register("givetool", {"gtool", "get"}, "givetool <name>", "<name>", "Find a tool by name anywhere and give it to yourself", function(target)
    if not target then notify("GiveTool", "Provide a tool name.") return end
    local backpack = getBackpack()
    if not backpack then return end

    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("Tool") and obj.Name:lower():find(target:lower(), 1, true) then
            local clone = obj:Clone()
            clone.Parent = backpack
            notify("GiveTool", "Gave " .. clone.Name)
            return
        end
    end
    notify("GiveTool", "Tool not found: " .. target)
end)

-- ============================================================
-- BACKPACK VIEWER (list your tools)
-- ============================================================
_G.Nexus.register("mybackpack", {"backpack"}, "mybackpack", "", "List every tool in your backpack", function()
    local backpack = getBackpack()
    if not backpack then return end
    local names = {}
    for _, obj in ipairs(backpack:GetChildren()) do
        if obj:IsA("Tool") then table.insert(names, obj.Name) end
    end
    notify("Backpack", #names .. " tools: " .. table.concat(names, ", "))
end)

print("[Nexus] Layer 2 Part 6 loaded. Tools / inventory commands ready.")
-- ============================================================
-- NEXUS - LAYER 2 PART 7: NPC COMMANDS
-- killnpcs, flingnpcs, bringnpcs, loopbringnpcs,
-- npcfollow, gotonpcs, sitnpcs, voidnpcs, npcesp, npcws
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function getHRP()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ============================================================
-- NPC detection
-- ============================================================
local function isNPC(model)
    if not model:IsA("Model") then return false end
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    -- Real players have a Player object
    local plr = Players:GetPlayerFromCharacter(model)
    if plr then return false end
    return true
end

local function getNPCs()
    local out = {}
    for _, obj in ipairs(Workspace:GetChildren()) do
        if isNPC(obj) then
            table.insert(out, obj)
        end
    end
    return out
end

-- ============================================================
-- KILL NPCS
-- ============================================================
_G.Nexus.register("killnpcs", {"knpcs"}, "killnpcs", "", "Kill every NPC in the workspace", function()
    local count = 0
    for _, npc in ipairs(getNPCs()) do
        local hum = npc:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
            count = count + 1
        end
    end
    notify("KillNPCs", "Killed " .. count .. " NPCs.")
end)

-- ============================================================
-- FLING NPCS
-- ============================================================
local function flingNPCModel(npc)
    local hrp = getHRP()
    if not hrp then return end
    local nHRP = npc:FindFirstChild("HumanoidRootPart")
    if not nHRP then return end
    local old = hrp.CFrame
    for i = 1, 3 do
        hrp.CFrame = nHRP.CFrame + Vector3.new(0, 3, 0)
        RunService.Heartbeat:Wait()
        hrp.CFrame = nHRP.CFrame
        RunService.Heartbeat:Wait()
    end
    hrp.CFrame = old
end

_G.Nexus.register("flingnpcs", {"fnpcs"}, "flingnpcs", "", "Fling every NPC", function()
    local count = 0
    for _, npc in ipairs(getNPCs()) do
        flingNPCModel(npc)
        count = count + 1
    end
    notify("FlingNPCs", "Flinged " .. count .. " NPCs.")
end)

-- ============================================================
-- BRING NPCS
-- ============================================================
_G.Nexus.register("bringnpcs", {"bnpcs"}, "bringnpcs [distance]", "[distance]", "Bring every NPC to you", function(target, args)
    local dist = tonumber(args[1]) or tonumber(target) or 5
    local hrp = getHRP()
    if not hrp then return end
    local count = 0
    for _, npc in ipairs(getNPCs()) do
        local nHRP = npc:FindFirstChild("HumanoidRootPart")
        if nHRP then
            nHRP.CFrame = hrp.CFrame + hrp.CFrame.LookVector * dist
            count = count + 1
        end
    end
    notify("BringNPCs", "Brought " .. count .. " NPCs.")
end)

-- ============================================================
-- LOOP BRING NPCS
-- ============================================================
local loopBringNPCsActive = false

_G.Nexus.register("loopbringnpcs", {"lbnpcs"}, "loopbringnpcs [distance]", "[distance]", "Keep bringing NPCs to you", function(target, args)
    if loopBringNPCsActive then return end
    loopBringNPCsActive = true
    local dist = tonumber(args[1]) or tonumber(target) or 5
    task.spawn(function()
        while loopBringNPCsActive do
            local hrp = getHRP()
            if hrp then
                for _, npc in ipairs(getNPCs()) do
                    local nHRP = npc:FindFirstChild("HumanoidRootPart")
                    if nHRP then
                        nHRP.CFrame = hrp.CFrame + hrp.CFrame.LookVector * dist
                    end
                end
            end
            task.wait(0.05)
        end
    end)
    notify("LoopBringNPCs", "Started.")
end)

_G.Nexus.register("unloopbringnpcs", {"unlbnpcs"}, "unloopbringnpcs", "", "Stop bringing NPCs", function()
    loopBringNPCsActive = false
    notify("LoopBringNPCs", "Stopped.")
end)

-- ============================================================
-- NPC FOLLOW
-- ============================================================
local npcFollowConn

_G.Nexus.register("npcfollow", {}, "npcfollow", "", "Make NPCs follow you", function()
    if npcFollowConn then npcFollowConn:Disconnect() end
    npcFollowConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if not hrp then return end
        for _, npc in ipairs(getNPCs()) do
            local hum = npc:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:MoveTo(hrp.Position)
            end
        end
    end)
    notify("NPCFollow", "NPCs follow you.")
end)

_G.Nexus.register("unnpcfollow", {"stopnpcfollow"}, "unnpcfollow", "", "Stop NPCs from following", function()
    if npcFollowConn then npcFollowConn:Disconnect() npcFollowConn = nil end
    notify("NPCFollow", "Stopped.")
end)

-- ============================================================
-- GOTO NPCS
-- ============================================================
_G.Nexus.register("gotonpcs", {"gnpcs"}, "gotonpcs", "", "Teleport to each NPC", function()
    local hrp = getHRP()
    if not hrp then return end
    task.spawn(function()
        for _, npc in ipairs(getNPCs()) do
            local nHRP = npc:FindFirstChild("HumanoidRootPart")
            if nHRP then
                hrp.CFrame = nHRP.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.4)
            end
        end
    end)
    notify("GotoNPCs", "Teleporting...")
end)

-- ============================================================
-- SIT NPCS
-- ============================================================
_G.Nexus.register("sitnpcs", {}, "sitnpcs", "", "Make all NPCs sit", function()
    for _, npc in ipairs(getNPCs()) do
        local hum = npc:FindFirstChildOfClass("Humanoid")
        if hum then hum.Sit = true end
    end
    notify("SitNPCs", "Done.")
end)

_G.Nexus.register("unsitnpcs", {}, "unsitnpcs", "", "Make all NPCs stand", function()
    for _, npc in ipairs(getNPCs()) do
        local hum = npc:FindFirstChildOfClass("Humanoid")
        if hum then hum.Sit = false end
    end
    notify("SitNPCs", "Stood up.")
end)

-- ============================================================
-- VOID NPCS
-- ============================================================
_G.Nexus.register("voidnpcs", {"vnpcs"}, "voidnpcs", "", "Send NPCs to the void", function()
    local count = 0
    for _, npc in ipairs(getNPCs()) do
        local nHRP = npc:FindFirstChild("HumanoidRootPart")
        if nHRP then
            nHRP.CFrame = CFrame.new(0, -100000, 0)
            count = count + 1
        end
    end
    notify("VoidNPCs", "Sent " .. count .. " NPCs to the void.")
end)

-- ============================================================
-- NPC WALKSPEED / JUMPPOWER
-- ============================================================
_G.Nexus.register("npcws", {"npcwalkspeed"}, "npcws <number>", "<number>", "Set every NPC's walkspeed", function(target, args)
    local n = tonumber(args[1]) or tonumber(target)
    if not n then return end
    for _, npc in ipairs(getNPCs()) do
        local hum = npc:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = n end
    end
    notify("NPCWalkspeed", "Set to " .. n)
end)

_G.Nexus.register("npcjp", {"npcjumppower"}, "npcjp <number>", "<number>", "Set every NPC's jump power", function(target, args)
    local n = tonumber(args[1]) or tonumber(target)
    if not n then return end
    for _, npc in ipairs(getNPCs()) do
        local hum = npc:FindFirstChildOfClass("Humanoid")
        if hum then hum.UseJumpPower = true hum.JumpPower = n end
    end
    notify("NPCJumpPower", "Set to " .. n)
end)

-- ============================================================
-- NPC ESP
-- ============================================================
local npcHighlights = {}

_G.Nexus.register("npcesp", {"espnpc"}, "npcesp", "", "Highlight every NPC", function()
    for _, npc in ipairs(getNPCs()) do
        if not npcHighlights[npc] then
            local hl = Instance.new("Highlight")
            hl.Name = "NexusNPCEsp"
            hl.Adornee = npc
            hl.FillColor = Color3.fromRGB(240, 180, 79)
            hl.FillTransparency = 0.6
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = npc
            npcHighlights[npc] = hl
        end
    end
    notify("NPCEsp", "Enabled.")
end)

_G.Nexus.register("unnpcesp", {"unespnpc"}, "unnpcesp", "", "Remove NPC highlights", function()
    for npc, hl in pairs(npcHighlights) do
        if hl then hl:Destroy() end
    end
    npcHighlights = {}
    notify("NPCEsp", "Disabled.")
end)

print("[Nexus] Layer 2 Part 7 loaded. NPC commands ready.")
-- ============================================================
-- NEXUS - LAYER 2 PART 8: LIGHTING / EFFECTS / MISC
-- gamma, nofog, globalshadows, dance, seizure, firework,
-- blackhole, rename, prefix, rejoin, serverhop, fps, ping
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ============================================================
-- GAMMA
-- ============================================================
_G.Nexus.register("gamma", {"exposure"}, "gamma", "", "Brighten everything with gamma", function()
    Lighting.Ambient = Color3.fromRGB(180, 180, 180)
    Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    Lighting.Brightness = 3
    Lighting.ExposureCompensation = 1
    Lighting.GlobalShadows = false
    notify("Gamma", "Enabled.")
end)

-- ============================================================
-- NOFOG
-- ============================================================
local oldFog
_G.Nexus.register("nofog", {"nf"}, "nofog", "", "Remove fog", function()
    if not oldFog then
        oldFog = { End = Lighting.FogEnd, Start = Lighting.FogStart, Color = Lighting.FogColor }
    end
    Lighting.FogEnd = 1e6
    Lighting.FogStart = 1e6
    notify("NoFog", "Enabled.")
end)

_G.Nexus.register("unnofog", {"unnf"}, "unnofog", "", "Restore fog", function()
    if oldFog then
        Lighting.FogEnd = oldFog.End
        Lighting.FogStart = oldFog.Start
        Lighting.FogColor = oldFog.Color
    end
    notify("NoFog", "Disabled.")
end)

-- ============================================================
-- GLOBAL SHADOWS
-- ============================================================
_G.Nexus.register("globalshadows", {"gshadows"}, "globalshadows", "", "Enable global shadows", function()
    Lighting.GlobalShadows = true
    notify("GlobalShadows", "Enabled.")
end)

_G.Nexus.register("unglobalshadows", {"nogshadows"}, "unglobalshadows", "", "Disable global shadows", function()
    Lighting.GlobalShadows = false
    notify("GlobalShadows", "Disabled.")
end)

-- ============================================================
-- DANCE (simple animation via tool)
-- ============================================================
local danceTrack
_G.Nexus.register("dance", {}, "dance", "", "Play a random dance animation", function()
    local char = getChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    -- Random popular dance ids
    local ids = {
        "rbxassetid://182435998",  -- default dance
        "rbxassetid://507771019",  -- dance2
        "rbxassetid://507776043",  -- dance3
    }
    local id = ids[math.random(1, #ids)]

    local anim = Instance.new("Animation")
    anim.AnimationId = id
    local track = animator:LoadAnimation(anim)
    track:Play()
    danceTrack = track
    notify("Dance", "Started.")
end)

_G.Nexus.register("undance", {}, "undance", "", "Stop the dance", function()
    if danceTrack then
        danceTrack:Stop()
        danceTrack = nil
    end
    notify("Dance", "Stopped.")
end)

-- ============================================================
-- SEIZURE
-- ============================================================
local seizureConn

_G.Nexus.register("seizure", {"flashinglights"}, "seizure", "", "Epilepsy warning - rapid color change", function()
    if seizureConn then seizureConn:Disconnect() end
    seizureConn = RunService.Heartbeat:Connect(function()
        Lighting.Ambient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        Lighting.OutdoorAmbient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    end)
    notify("Seizure", "Enabled.")
end)

_G.Nexus.register("unseizure", {"stopseizure"}, "unseizure", "", "Stop the seizure effect", function()
    if seizureConn then seizureConn:Disconnect() seizureConn = nil end
    Lighting.Ambient = Color3.fromRGB(70, 70, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    notify("Seizure", "Disabled.")
end)

-- ============================================================
-- FIREWORK
-- ============================================================
_G.Nexus.register("firework", {"fw"}, "firework", "", "Spawn a firework above you", function()
    local hrp = getHRP()
    if not hrp then return end

    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 2, 2)
    part.Position = hrp.Position + Vector3.new(0, 50, 0)
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    part.Parent = workspace

    local att = Instance.new("Attachment")
    att.Parent = part

    local emitter = Instance.new("ParticleEmitter")
    emitter.Rate = 500
    emitter.Lifetime = NumberRange.new(1, 2)
    emitter.Speed = NumberRange.new(30, 60)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.Color = ColorSequence.new(Color3.fromRGB(255, 200, 50))
    emitter.Parent = att

    task.delay(0.2, function()
        emitter.Enabled = false
        task.delay(2, function() part:Destroy() end)
    end)
    notify("Firework", "Boom.")
end)

-- ============================================================
-- BLACKHOLE
-- ============================================================
local blackholeActive = false
local blackholePart

_G.Nexus.register("blackhole", {"bh"}, "blackhole", "", "Pull unanchored parts to a black hole", function()
    if blackholeActive then return end
    blackholeActive = true

    local hrp = getHRP()
    if not hrp then return end

    blackholePart = Instance.new("Part")
    blackholePart.Size = Vector3.new(4, 4, 4)
    blackholePart.Position = hrp.Position + Vector3.new(0, 5, 0)
    blackholePart.Anchored = true
    blackholePart.CanCollide = false
    blackholePart.Material = Enum.Material.Neon
    blackholePart.Color = Color3.fromRGB(0, 0, 0)
    blackholePart.Shape = Enum.PartType.Ball
    blackholePart.Parent = workspace

    task.spawn(function()
        while blackholeActive and blackholePart and blackholePart.Parent do
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and not obj.Anchored and obj ~= blackholePart then
                    local plr = Players:GetPlayerFromCharacter(obj.Parent)
                    if not plr then
                        local dir = (blackholePart.Position - obj.Position)
                        if dir.Magnitude < 200 then
                            obj.AssemblyLinearVelocity = dir.Unit * 200
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
    notify("Blackhole", "Enabled.")
end)

_G.Nexus.register("unblackhole", {"unbh"}, "unblackhole", "", "Stop the blackhole", function()
    blackholeActive = false
    if blackholePart then blackholePart:Destroy() blackholePart = nil end
    notify("Blackhole", "Disabled.")
end)

-- ============================================================
-- RENAME / PREFIX
-- ============================================================
_G.Nexus.register("rename", {}, "rename <text>", "<text>", "Rename the Nexus title", function(target, args, rawArgs)
    if not rawArgs or rawArgs == "" then return end
    if _G.Nexus.Main then
        local title = _G.Nexus.Main:FindFirstChild("TitleBar")
        if title then
            local lbl = title:FindFirstChildWhichIsA("TextLabel")
            if lbl then lbl.Text = rawArgs end
        end
    end
    notify("Rename", "Title changed.")
end)

_G.Nexus.register("prefix", {}, "prefix <symbol>", "<symbol>", "Change the chat prefix", function(target)
    if not target or target == "" then return end
    _G.Nexus.Prefix = target:sub(1, 1)
    if _G.Nexus.refreshPrefixVisual then _G.Nexus.refreshPrefixVisual() end
    notify("Prefix", "Set to " .. _G.Nexus.Prefix)
end)

-- ============================================================
-- REJOIN / SERVERHOP
-- ============================================================
_G.Nexus.register("rejoin", {"rj"}, "rejoin", "", "Rejoin the current server", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    notify("Rejoin", "Rejoining...")
end)

_G.Nexus.register("serverhop", {"hop"}, "serverhop", "", "Hop to a random server", function()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if not ok or not res then notify("ServerHop", "Request failed.") return end

    local data = HttpService:JSONDecode(res)
    local servers = {}
    for _, s in ipairs(data.data or {}) do
        if s.id ~= game.JobId and s.playing < s.maxPlayers then
            table.insert(servers, s.id)
        end
    end
    if #servers == 0 then notify("ServerHop", "No servers found.") return end
    local chosen = servers[math.random(1, #servers)]
    TeleportService:TeleportToPlaceInstance(game.PlaceId, chosen, LocalPlayer)
    notify("ServerHop", "Hopping...")
end)

-- ============================================================
-- FPS / PING
-- ============================================================
local fpsGui
_G.Nexus.register("fps", {}, "fps", "", "Show FPS counter", function()
    if fpsGui then fpsGui:Destroy() end
    fpsGui = Instance.new("ScreenGui")
    fpsGui.Name = "NexusFPS"
    fpsGui.ResetOnSpawn = false
    fpsGui.Parent = game:GetService("CoreGui")

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 200, 0, 30)
    lbl.Position = UDim2.new(0, 10, 0, 10)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextStrokeTransparency = 0
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = fpsGui

    local frames = 0
    local time = tick()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        if tick() - time >= 1 then
            lbl.Text = "FPS: " .. frames
            frames = 0
            time = tick()
        end
    end)
    notify("FPS", "Counter created.")
end)

_G.Nexus.register("ping", {"latency"}, "ping", "", "Show your ping", function()
    local p = math.floor(LocalPlayer:GetNetworkPing() * 1000)
    notify("Ping", p .. " ms")
end)

-- ============================================================
-- LOOP / REPEAT (run any command repeatedly)
-- ============================================================
local activeLoops = {}
_G.Nexus.register("loop", {}, "loop [delay] <command...>", "[delay] <command...>", "Run a command repeatedly", function(target, args, rawArgs)
    if not rawArgs or rawArgs == "" then notify("Loop", "Provide a command.") return end
    local delay = 0.1
    local cmd = rawArgs
    local firstNum = rawArgs:match("^(%d+%.?%d*)%s+(.+)$")
    if firstNum then
        delay = tonumber(firstNum)
        cmd = rawArgs:sub(#firstNum + 2)
    end
    local id = tostring(tick())
    activeLoops[id] = true
    task.spawn(function()
        while activeLoops[id] do
            _G.Nexus.runCommand(cmd)
            task.wait(delay)
        end
    end)
    notify("Loop", "Started loop: " .. cmd)
end)

_G.Nexus.register("unloop", {"stoploop"}, "unloop", "", "Stop every loop", function()
    activeLoops = {}
    notify("Loop", "Stopped all loops.")
end)

print("[Nexus] Layer 2 Part 8 loaded. Lighting / misc / utility commands ready.")
-- ============================================================
-- NEXUS - LAYER 2 PART 9: PROTECTION / SPOOFING / FUN
-- antifling, antivoid, antikick, antiafk, antiteleport,
-- username spoof, userid spoof, seat, sit, lay, trip,
-- headbang, commitoof, uwuify
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function getHum()
    local c = getChar()
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function findPlayer(q)
    if _G.Nexus.findPlayer then return _G.Nexus.findPlayer(q) end
end

-- ============================================================
-- ANTI-FLING
-- ============================================================
local antiflingConn
_G.Nexus.register("antifling", {"afling"}, "antifling", "", "Prevent other players from colliding with you", function()
    if antiflingConn then return end
    antiflingConn = RunService.Heartbeat:Connect(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end)
    notify("AntiFling", "Enabled.")
end)

_G.Nexus.register("unantifling", {"unafling"}, "unantifling", "", "Disable antifling", function()
    if antiflingConn then antiflingConn:Disconnect() antiflingConn = nil end
    notify("AntiFling", "Disabled.")
end)

-- ============================================================
-- ANTI-VOID
-- ============================================================
local antivoidConn
_G.Nexus.register("antivoid", {}, "antivoid", "", "Save yourself from falling into the void", function()
    if antivoidConn then return end
    antivoidConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if hrp and hrp.Position.Y < -50 then
            hrp.CFrame = CFrame.new(hrp.Position.X, 500, hrp.Position.Z)
        end
    end)
    notify("AntiVoid", "Enabled.")
end)

_G.Nexus.register("unantivoid", {}, "unantivoid", "", "Disable antivoid", function()
    if antivoidConn then antivoidConn:Disconnect() antivoidConn = nil end
    notify("AntiVoid", "Disabled.")
end)

-- ============================================================
-- ANTI-KICK
-- ============================================================
local antikickActive = false
_G.Nexus.register("antikick", {"nokick"}, "antikick", "", "Try to block server kicks", function()
    if antikickActive then return end
    antikickActive = true
    if hookmetamethod then
        pcall(function()
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" then
                    return
                end
                return oldNamecall(self, ...)
            end)
        end)
    end
    notify("AntiKick", "Enabled (may not work on all games).")
end)

_G.Nexus.register("unantikick", {"unnokick"}, "unantikick", "", "Disable antikick", function()
    antikickActive = false
    notify("AntiKick", "Disabled.")
end)

-- ============================================================
-- ANTI-AFK
-- ============================================================
local afkConn
_G.Nexus.register("antiafk", {"noafk"}, "antiafk", "", "Prevent being kicked for being idle", function()
    if afkConn then return end
    afkConn = LocalPlayer.Idled:Connect(function()
        if VirtualUser then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
    notify("AntiAFK", "Enabled.")
end)

_G.Nexus.register("unantiafk", {"unnoafk"}, "unantiafk", "", "Disable antiafk", function()
    if afkConn then afkConn:Disconnect() afkConn = nil end
    notify("AntiAFK", "Disabled.")
end)

-- ============================================================
-- ANTI-TELEPORT
-- ============================================================
local originalCF
local antiteleportConn
_G.Nexus.register("antiteleport", {"noteleport"}, "antiteleport", "", "Lock your CFrame to prevent being teleported", function()
    if antiteleportConn then return end
    local hrp = getHRP()
    if not hrp then return end
    originalCF = hrp.CFrame
    antiteleportConn = RunService.Heartbeat:Connect(function()
        local h = getHRP()
        if h and originalCF then
            if (h.Position - originalCF.Position).Magnitude > 15 then
                h.CFrame = originalCF
            end
        end
    end)
    notify("AntiTeleport", "Enabled.")
end)

_G.Nexus.register("unantiteleport", {"unnoteleport"}, "unantiteleport", "", "Disable antiteleport", function()
    if antiteleportConn then antiteleportConn:Disconnect() antiteleportConn = nil end
    originalCF = nil
    notify("AntiTeleport", "Disabled.")
end)

-- ============================================================
-- USERNAME / USERID SPOOF (client-side illusion)
-- ============================================================
_G.Nexus.SpoofedName = nil
_G.Nexus.SpoofedUserId = nil

_G.Nexus.register("username", {"spoofname"}, "username <name>", "<name>", "Spoof your username (client only)", function(target)
    if not target or target == "" then return end
    _G.Nexus.SpoofedName = target
    local char = getChar()
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.DisplayName = target end
        local head = char:FindFirstChild("Head")
        if head then
            local bb = head:FindFirstChild("NexusSpoof")
            if not bb then
                bb = Instance.new("BillboardGui")
                bb.Name = "NexusSpoof"
                bb.Size = UDim2.new(0, 200, 0, 50)
                bb.StudsOffset = Vector3.new(0, 2, 0)
                bb.Parent = head
                local lbl = Instance.new("TextLabel")
                lbl.Name = "Name"
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                lbl.TextStrokeTransparency = 0
                lbl.Font = Enum.Font.GothamBold
                lbl.TextSize = 14
                lbl.Parent = bb
            end
            bb.Name = "NexusSpoof"
            bb.Name = "NexusSpoof"
            bb.Name = "NexusSpoof"
            bb.Name = "NexusSpoof"
            bb.Name = "NexusSpoof"
            bb.Name = "NexusSpoof"
            bb.Name = "NexusSpoof"
            bb.Name = "NexusSpoof"
            bb:FindFirstChild("Name").Text = target
        end
    end
    notify("Username", "Spoofed as " .. target)
end)

_G.Nexus.register("unusername", {"unspoofname"}, "unusername", "", "Remove username spoof", function()
    _G.Nexus.SpoofedName = nil
    local char = getChar()
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            local bb = head:FindFirstChild("NexusSpoof")
            if bb then bb:Destroy() end
        end
    end
    notify("Username", "Spoof removed.")
end)

_G.Nexus.register("userid", {"spoofuserid"}, "userid <id>", "<id>", "Spoof your UserId (client only)", function(target)
    local id = tonumber(target)
    if not id then return end
    _G.Nexus.SpoofedUserId = id
    notify("UserId", "Spoofed as " .. id)
end)

_G.Nexus.register("unuserid", {"unspoofuserid"}, "unuserid", "", "Remove UserId spoof", function()
    _G.Nexus.SpoofedUserId = nil
    notify("UserId", "Spoof removed.")
end)

-- ============================================================
-- SEAT / SIT / LAY / TRIP
-- ============================================================
_G.Nexus.register("sit", {}, "sit", "", "Sit your character", function()
    local hum = getHum()
    if hum then hum.Sit = true end
    notify("Sit", "Sat down.")
end)

_G.Nexus.register("unsit", {"stand"}, "unsit", "", "Stand up", function()
    local hum = getHum()
    if hum then hum.Sit = false end
    notify("Sit", "Stood up.")
end)

_G.Nexus.register("seat", {}, "seat", "", "Find a seat and sit on it", function()
    local hrp = getHRP()
    if not hrp then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
            local hum = getHum()
            if hum then
                hrp.CFrame = obj.CFrame
                task.wait(0.1)
                obj:Sit(hum)
                notify("Seat", "Sat on " .. obj.Name)
                return
            end
        end
    end
    notify("Seat", "No seat found.")
end)

_G.Nexus.register("lay", {"laydown"}, "lay", "", "Lay down on the floor", function()
    local char = getChar()
    local hrp = getHRP()
    if not char or not hrp then return end
    local hum = getHum()
    if hum then
        hum.PlatformStand = true
        hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(90), 0, 0)
    end
    notify("Lay", "Laying down.")
end)

_G.Nexus.register("unlay", {"standup"}, "unlay", "", "Stand up from laying", function()
    local hum = getHum()
    if hum then hum.PlatformStand = false end
    notify("Lay", "Stood up.")
end)

_G.Nexus.register("trip", {"ragdoll"}, "trip", "", "Ragdoll yourself", function()
    local hum = getHum()
    if hum then
        hum.PlatformStand = true
        task.delay(2, function() hum.PlatformStand = false end)
    end
    notify("Trip", "Tripped.")
end)

-- ============================================================
-- COMMIT OOF
-- ============================================================
_G.Nexus.register("commitoof", {"oof", "kys"}, "commitoof", "", "Dramatic oof", function()
    local hum = getHum()
    if hum then hum.Health = 0 end
    notify("CommitOof", "Oof.")
end)

-- ============================================================
-- UwUify
-- ============================================================
local function uwuify(text)
    local replacements = {
        ["r"] = "w",
        ["l"] = "w",
        ["R"] = "W",
        ["L"] = "W",
        ["n"] = "ny",
        ["N"] = "Ny",
    }
    local out = text
    for a, b in pairs(replacements) do
        out = out:gsub(a, b)
    end
    return out .. " uwu"
end

_G.Nexus.register("uwuify", {"uwu"}, "uwuify <text>", "<text>", "Send a cute message", function(target, args, rawArgs)
    if not rawArgs or rawArgs == "" then return end
    local msg = uwuify(rawArgs)
    pcall(function()
        game:GetService("ReplicatedStorage")
            :FindFirstChild("DefaultChatSystemChatEvents")
            :FindFirstChild("SayMessageRequest")
            :FireServer(msg, "All")
    end)
    notify("UwUify", msg)
end)

-- ============================================================
-- UNLOAD EVERYTHING
-- ============================================================
_G.Nexus.register("unload", {"exit"}, "unload", "", "Unload Nexus completely", function()
    if _G.Nexus.ScreenGui then _G.Nexus.ScreenGui:Destroy() end
    local CoreGui = game:GetService("CoreGui")
    if CoreGui:FindFirstChild("NexusCommandBar") then CoreGui.NexusCommandBar:Destroy() end
    if CoreGui:FindFirstChild("NexusToast") then CoreGui.NexusToast:Destroy() end
    if CoreGui:FindFirstChild("NexusFPS") then CoreGui.NexusFPS:Destroy() end
    _G.Nexus = nil
    print("[Nexus] Unloaded.")
end)

print("[Nexus] Layer 2 Part 9 loaded. Protection / spoofing / fun commands ready.")
-- ============================================================
-- NEXUS - LAYER 2 PART 9: PROTECTION / SPOOFING / MISC
-- antifling, antivoid, antikick, antiafk, antiteleport,
-- godmode lock, username/uid spoof, unload
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ============================================================
-- ANTIFLING (turn off your collision for other players)
-- ============================================================
local antiflingConn

_G.Nexus.register("antifling", {"nofling"}, "antifling", "", "Prevent being flung", function()
    if antiflingConn then return end
    antiflingConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 1, 1)
            end
        end
    end)
    notify("AntiFling", "Enabled.")
end)

_G.Nexus.register("unantifling", {"unnfling"}, "unantifling", "", "Disable anti-fling", function()
    if antiflingConn then antiflingConn:Disconnect() antiflingConn = nil end
    local char = getChar()
    if char then
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.CustomPhysicalProperties = nil
            end
        end
    end
    notify("AntiFling", "Disabled.")
end)

-- ============================================================
-- ANTIVOID
-- ============================================================
local antivoidConn

_G.Nexus.register("antivoid", {"novoid"}, "antivoid", "", "Prevent falling into the void", function()
    if antivoidConn then return end
    antivoidConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if not hrp then return end
        if hrp.Position.Y < -100 then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, 500, hrp.Velocity.Z)
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 200, 0)
        end
    end)
    notify("AntiVoid", "Enabled.")
end)

_G.Nexus.register("unantivoid", {"unnvoid"}, "unantivoid", "", "Disable anti-void", function()
    if antivoidConn then antivoidConn:Disconnect() antivoidConn = nil end
    notify("AntiVoid", "Disabled.")
end)

-- ============================================================
-- ANTIKICK (only works with executor metatable hooks)
-- ============================================================
local antikickActive = false
local originalKick

_G.Nexus.register("antikick", {"nokick", "bk"}, "antikick", "", "Prevent yourself from being kicked (executor-dependent)", function()
    if antikickActive then return end
    local ok = pcall(function()
        -- Only works on executors with hookmetamethod or getrawmetatable
        if hookmetamethod then
            local oldNamecall
            oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if not checkcaller() and method == "Kick" and self == LocalPlayer then
                    return
                end
                return oldNamecall(self, ...)
            end))
        elseif getrawmetatable then
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if not checkcaller() and method == "Kick" and self == LocalPlayer then
                    return
                end
                return oldNamecall(self, ...)
            end)
            setreadonly(mt, true)
        else
            error("No hook function available")
        end
    end)
    if ok then
        antikickActive = true
        notify("AntiKick", "Enabled.")
    else
        notify("AntiKick", "Not supported by this executor.")
    end
end)

_G.Nexus.register("unantikick", {"unnokick", "unbk"}, "unantikick", "", "Disable anti-kick", function()
    antikickActive = false
    notify("AntiKick", "Disabled (restart to fully undo).")
end)

-- ============================================================
-- ANTIAFK
-- ============================================================
local antiafkConn

_G.Nexus.register("antiafk", {"noafk"}, "antiafk", "", "Prevent being kicked for being AFK", function()
    if antiafkConn then return end
    local VirtualUser = game:GetService("VirtualUser")
    antiafkConn = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    notify("AntiAFK", "Enabled.")
end)

_G.Nexus.register("unantiafk", {"unnoafk"}, "unantiafk", "", "Disable anti-afk", function()
    if antiafkConn then antiafkConn:Disconnect() antiafkConn = nil end
    notify("AntiAFK", "Disabled.")
end)

-- ============================================================
-- ANTITELEPORT
-- ============================================================
local antiteleportActive = false

_G.Nexus.register("antiteleport", {"noteleport"}, "antiteleport", "", "Prevent being teleported by others", function()
    if antiteleportActive then return end
    local ok = pcall(function()
        local mt = getrawmetatable and getrawmetatable(game)
        if not mt then error("no metatable") end
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if not checkcaller() and (method == "Teleport" or method == "TeleportToPlaceInstance") then
                return
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)
    if ok then
        antiteleportActive = true
        notify("AntiTeleport", "Enabled.")
    else
        notify("AntiTeleport", "Not supported.")
    end
end)

_G.Nexus.register("unantiteleport", {"unnoteleport"}, "unantiteleport", "", "Disable anti-teleport", function()
    antiteleportActive = false
    notify("AntiTeleport", "Disabled.")
end)

-- ============================================================
-- ANTITRIP (anti ragdoll)
-- ============================================================
local antitripConn

_G.Nexus.register("antitrip", {"antiragdoll"}, "antitrip", "", "Prevent ragdoll / tripping", function()
    if antitripConn then return end
    antitripConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum:GetState() == Enum.HumanoidStateType.Physics then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
    notify("AntiTrip", "Enabled.")
end)

_G.Nexus.register("unantitrip", {"unantiragdoll"}, "unantitrip", "", "Disable anti-trip", function()
    if antitripConn then antitripConn:Disconnect() antitripConn = nil end
    notify("AntiTrip", "Disabled.")
end)

-- ============================================================
-- USERNAME SPOOF (client-side)
-- ============================================================
local originalName = LocalPlayer.Name
local originalDisplayName = LocalPlayer.DisplayName

_G.Nexus.register("username", {"name"}, "username <text>", "<text>", "Spoof your own username (client-side)", function(target, args, rawArgs)
    if not rawArgs or rawArgs == "" then notify("Username", "Provide a new name.") return end
    pcall(function()
        LocalPlayer.Name = rawArgs
        LocalPlayer.DisplayName = rawArgs
    end)
    notify("Username", "Set to " .. rawArgs)
end)

_G.Nexus.register("unusername", {"unname"}, "unusername", "", "Reset your name", function()
    pcall(function()
        LocalPlayer.Name = originalName
        LocalPlayer.DisplayName = originalDisplayName
    end)
    notify("Username", "Reset.")
end)

-- ============================================================
-- USERID SPOOF (client-side, needs executor)
-- ============================================================
_G.Nexus.register("userid", {"uid"}, "userid <number>", "<number>", "Spoof your own UserId", function(target, args, rawArgs)
    local id = tonumber(rawArgs)
    if not id then notify("UserId", "Provide a number.") return end
    local ok = pcall(function()
        if sethiddenproperty then
            sethiddenproperty(LocalPlayer, "UserId", id)
        else
            error("sethiddenproperty not available")
        end
    end)
    if ok then
        notify("UserId", "Set to " .. id)
    else
        notify("UserId", "Not supported by this executor.")
    end
end)

-- ============================================================
-- UNLOAD (destroy Nexus)
-- ============================================================
_G.Nexus.register("unload", {"exit", "close"}, "unload", "", "Remove Nexus from this game", function()
    if _G.Nexus.stopAll then _G.Nexus.stopAll() end
    if _G.Nexus.ScreenGui then _G.Nexus.ScreenGui:Destroy() end
    local CoreGui = game:GetService("CoreGui")
    for _, name in ipairs({"NexusCommandBar", "NexusToast"}) do
        local obj = CoreGui:FindFirstChild(name)
        if obj then obj:Destroy() end
    end
    notify("Nexus", "Unloaded.")
    _G.Nexus = nil
end)

-- ============================================================
-- STOP ALL (utility for unload)
-- ============================================================
_G.Nexus.stopAll = function()
    for _, conn in pairs(_G.Nexus.Commands or {}) do
        -- no-op; commands do not hold connections
    end
end

print("[Nexus] Layer 2 Part 9 loaded. Protection and spoofing commands ready.")