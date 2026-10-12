-- ============================================================
-- NEXUS - BATCH 1: MOVEMENT PLUS
-- tpwalk, tpjump, flyjump, airwalk, wallwalk, climb,
-- airmomentum, breakvelocity, maxslopeangle
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

-- ============================================================
-- TPWALK (teleport-based speed that is hard to detect)
-- ============================================================
local tpwalkConn = nil
local TPWALK_AMOUNT = 2

_G.Nexus.register("tpwalk", {}, "tpwalk <number>", "<number>", "Teleport-based movement (undetectable walkspeed)", function(target, args)
    local n = tonumber(args[1]) or tonumber(target)
    if n then TPWALK_AMOUNT = n end
    if tpwalkConn then
        notify("TpWalk", "Already running.")
        return
    end
    tpwalkConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        local hum = getHum()
        if not hrp or not hum then return end
        if hum.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + hum.MoveDirection * TPWALK_AMOUNT
        end
    end)
    notify("TpWalk", "Enabled with amount " .. TPWALK_AMOUNT)
end)

_G.Nexus.register("untpwalk", {}, "untpwalk", "", "Stop tpwalk", function()
    if tpwalkConn then tpwalkConn:Disconnect() tpwalkConn = nil end
    notify("TpWalk", "Disabled.")
end)

-- ============================================================
-- TPJUMP
-- ============================================================
local TPJUMP_HEIGHT = 5

_G.Nexus.register("tpjump", {}, "tpjump <number>", "<number>", "Teleport up on jump instead of using JumpPower", function(target, args)
    local n = tonumber(args[1]) or tonumber(target)
    if n then TPJUMP_HEIGHT = n end
    if _G.Nexus._tpjumpConn then _G.Nexus._tpjumpConn:Disconnect() end
    _G.Nexus._tpjumpConn = UserInputService.JumpRequest:Connect(function()
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, TPJUMP_HEIGHT, 0)
        end
    end)
    notify("TpJump", "Enabled with height " .. TPJUMP_HEIGHT)
end)

_G.Nexus.register("untpjump", {}, "untpjump", "", "Stop tpjump", function()
    if _G.Nexus._tpjumpConn then _G.Nexus._tpjumpConn:Disconnect() _G.Nexus._tpjumpConn = nil end
    notify("TpJump", "Disabled.")
end)

-- ============================================================
-- FLYJUMP (hold space to fly up)
-- ============================================================
local flyJumpConn = nil

_G.Nexus.register("flyjump", {}, "flyjump [speed]", "[speed]", "Hold space to fly up", function(target, args)
    local speed = tonumber(args[1]) or tonumber(target) or 50
    if flyJumpConn then flyJumpConn:Disconnect() end
    flyJumpConn = RunService.Heartbeat:Connect(function()
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            local hrp = getHRP()
            if hrp then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, speed, hrp.Velocity.Z)
            end
        end
    end)
    notify("FlyJump", "Enabled. Hold space to rise.")
end)

_G.Nexus.register("unflyjump", {"noflyjump"}, "unflyjump", "", "Stop flyjump", function()
    if flyJumpConn then flyJumpConn:Disconnect() flyJumpConn = nil end
    notify("FlyJump", "Disabled.")
end)

-- ============================================================
-- AIRWALK (press space to gain altitude)
-- ============================================================
local airwalkConn = nil

_G.Nexus.register("airwalk", {"float", "aw"}, "airwalk", "", "Press space to go up in the air", function()
    if airwalkConn then return end
    airwalkConn = UserInputService.JumpRequest:Connect(function()
        local hrp = getHRP()
        if hrp then
            local vel = hrp.Velocity
            hrp.Velocity = Vector3.new(vel.X, 30, vel.Z)
        end
    end)
    notify("AirWalk", "Enabled.")
end)

_G.Nexus.register("unairwalk", {"unfloat", "unaw"}, "unairwalk", "", "Stop airwalk", function()
    if airwalkConn then airwalkConn:Disconnect() airwalkConn = nil end
    notify("AirWalk", "Disabled.")
end)

-- ============================================================
-- WALLWALK
-- ============================================================
local wallwalkActive = false

_G.Nexus.register("wallwalk", {}, "wallwalk", "", "Walk on walls", function()
    wallwalkActive = true
    local hum = getHum()
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        hum.MaxSlopeAngle = 89
    end
    notify("WallWalk", "Enabled. Walk into any wall.")
end)

_G.Nexus.register("unwallwalk", {}, "unwallwalk", "", "Stop wallwalk", function()
    wallwalkActive = false
    local hum = getHum()
    if hum then hum.MaxSlopeAngle = 45 end
    notify("WallWalk", "Disabled.")
end)

-- ============================================================
-- CLIMB (climb in mid air)
-- ============================================================
local climbConn = nil

_G.Nexus.register("climb", {}, "climb", "", "Climb in the air", function()
    if climbConn then return end
    climbConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if hum then
            local state = hum:GetState()
            if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
                hum:ChangeState(Enum.HumanoidStateType.Climbing)
            end
        end
    end)
    notify("Climb", "Enabled.")
end)

_G.Nexus.register("unclimb", {}, "unclimb", "", "Stop climb", function()
    if climbConn then climbConn:Disconnect() climbConn = nil end
    notify("Climb", "Disabled.")
end)

-- ============================================================
-- AIR MOMENTUM
-- ============================================================
local airMomentumConn = nil
local AIR_MOMENTUM_SPEED = 5

_G.Nexus.register("airmomentum", {"aircontrol"}, "airmomentum [speed]", "[speed]", "Better air control", function(target, args)
    local speed = tonumber(args[1]) or tonumber(target) or AIR_MOMENTUM_SPEED
    AIR_MOMENTUM_SPEED = speed
    if airMomentumConn then return end
    airMomentumConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        local hrp = getHRP()
        if not hum or not hrp then return end
        if hum:GetState() == Enum.HumanoidStateType.Freefall then
            if hum.MoveDirection.Magnitude > 0 then
                hrp.Velocity = hrp.Velocity + hum.MoveDirection * AIR_MOMENTUM_SPEED
            end
        end
    end)
    notify("AirMomentum", "Enabled.")
end)

_G.Nexus.register("unairmomentum", {"unaircontrol"}, "unairmomentum", "", "Stop air momentum", function()
    if airMomentumConn then airMomentumConn:Disconnect() airMomentumConn = nil end
    notify("AirMomentum", "Disabled.")
end)

-- ============================================================
-- BREAK VELOCITY
-- ============================================================
_G.Nexus.register("breakvelocity", {"bvel", "stopvel"}, "breakvelocity", "", "Zero out your velocity", function()
    local hrp = getHRP()
    if hrp then
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
    notify("BreakVelocity", "Stopped.")
end)

-- ============================================================
-- MAX SLOPE ANGLE
-- ============================================================
_G.Nexus.register("maxslopeangle", {"msa"}, "maxslopeangle <number>", "<number>", "Change your MaxSlopeAngle", function(target, args)
    local n = tonumber(args[1]) or tonumber(target)
    if not n then return end
    local hum = getHum()
    if hum then
        hum.MaxSlopeAngle = n
        notify("MaxSlopeAngle", "Set to " .. n)
    end
end)

_G.Nexus.register("loopmaxslopeangle", {"lmsa"}, "loopmaxslopeangle <number>", "<number>", "Lock MaxSlopeAngle", function(target, args)
    local n = tonumber(args[1]) or tonumber(target)
    if not n then return end
    if _G.Nexus._msaConn then _G.Nexus._msaConn:Disconnect() end
    _G.Nexus._msaConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if hum then hum.MaxSlopeAngle = n end
    end)
    notify("MaxSlopeAngle", "Locked to " .. n)
end)

_G.Nexus.register("unloopmaxslopeangle", {"unlmsa"}, "unloopmaxslopeangle", "", "Stop locking MaxSlopeAngle", function()
    if _G.Nexus._msaConn then _G.Nexus._msaConn:Disconnect() _G.Nexus._msaConn = nil end
    notify("MaxSlopeAngle", "Unlocked.")
end)

print("[Nexus] Batch 1 loaded. Movement Plus ready.")
-- ============================================================
-- NEXUS - BATCH 2: HITBOX / REACH
-- hitbox, unhitbox, boxreach, reach, resetreach, aura, unaura
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function findPlayer(q)
    if _G.Nexus.findPlayer then return _G.Nexus.findPlayer(q) end
end

-- ============================================================
-- HITBOX (expand another player's hitbox)
-- ============================================================
local originalSizes = {}

_G.Nexus.register("hitbox", {"hbox"}, "hitbox <player> [size] [part]", "<player> [size] [part]", "Resize a player's hitbox", function(target, args)
    if not target then notify("Hitbox", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Hitbox", "Player not found.") return end

    local size = tonumber(args[1]) or 10
    local partName = args[2] or "HumanoidRootPart"

    local part = plr.Character:FindFirstChild(partName)
    if not part then notify("Hitbox", "Part not found: " .. partName) return end

    originalSizes[part] = originalSizes[part] or part.Size
    part.Size = Vector3.new(size, size, size)
    part.Transparency = 0.5
    part.CanCollide = false
    part.Massless = true

    notify("Hitbox", "Expanded " .. plr.Name .. "'s " .. partName)
end)

_G.Nexus.register("unhitbox", {"unhbox"}, "unhitbox <player>", "<player>", "Reset a player's hitbox", function(target)
    if not target then
        for part, size in pairs(originalSizes) do
            if part and part.Parent then
                part.Size = size
            end
        end
        originalSizes = {}
        notify("Hitbox", "Reset all.")
        return
    end
    local plr = findPlayer(target)
    if not plr or not plr.Character then return end
    for _, part in ipairs(plr.Character:GetDescendants()) do
        if originalSizes[part] then
            part.Size = originalSizes[part]
            originalSizes[part] = nil
        end
    end
    notify("Hitbox", "Reset for " .. plr.Name)
end)

-- ============================================================
-- REACH (extend your sword reach)
-- ============================================================
local originalReachSize

_G.Nexus.register("reach", {"swordreach"}, "reach [number] [part]", "[number] [part]", "Extend your tool's reach", function(target, args)
    local size = tonumber(args[1]) or tonumber(target) or 30
    local partName = args[2] or "Handle"
    local char = LocalPlayer.Character
    if not char then return end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local part = tool:FindFirstChild(partName)
            if part then
                originalReachSize = originalReachSize or part.Size
                part.Size = Vector3.new(size, size, size)
                part.Transparency = 0.7
                part.CanCollide = false
                part.Massless = true
                notify("Reach", "Extended " .. tool.Name)
                return
            end
        end
    end
    notify("Reach", "Equip a tool first.")
end)

_G.Nexus.register("resetreach", {"unreach", "normalreach"}, "resetreach", "", "Reset your tool reach", function()
    local char = LocalPlayer.Character
    if not char then return end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local part = tool:FindFirstChild("Handle")
            if part and originalReachSize then
                part.Size = originalReachSize
            end
        end
    end
    originalReachSize = nil
    notify("Reach", "Reset.")
end)

-- ============================================================
-- BOXREACH (box-shaped hitbox around your tool)
-- ============================================================
local boxReachInstances = {}

_G.Nexus.register("boxreach", {}, "boxreach [number]", "[number]", "Create a box hitbox around your character", function(target, args)
    local size = tonumber(args[1]) or tonumber(target) or 20
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, inst in ipairs(boxReachInstances) do
        if inst then inst:Destroy() end
    end
    boxReachInstances = {}

    local box = Instance.new("Part")
    box.Size = Vector3.new(size, size, size)
    box.Anchored = false
    box.CanCollide = false
    box.Massless = true
    box.Transparency = 0.7
    box.Material = Enum.Material.ForceField
    box.Parent = workspace

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hrp
    weld.Part1 = box
    weld.Parent = box
    box.CFrame = hrp.CFrame

    table.insert(boxReachInstances, box)
    notify("BoxReach", "Created box hitbox.")
end)

_G.Nexus.register("unboxreach", {}, "unboxreach", "", "Remove box reach", function()
    for _, inst in ipairs(boxReachInstances) do
        if inst then inst:Destroy() end
    end
    boxReachInstances = {}
    notify("BoxReach", "Removed.")
end)

-- ============================================================
-- AURA (constant touch damage with equipped tool)
-- ============================================================
local auraConn

_G.Nexus.register("aura", {}, "aura [radius]", "[radius]", "Auto-attack nearby players", function(target, args)
    local radius = tonumber(args[1]) or tonumber(target) or 15
    if auraConn then auraConn:Disconnect() end
    auraConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                if tHRP and (tHRP.Position - hrp.Position).Magnitude <= radius then
                    local tool = char:FindFirstChildWhichIsA("Tool")
                    if tool then
                        pcall(function() tool:Activate() end)
                    end
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
-- NPC AURA
-- ============================================================
local npcAuraConn

_G.Nexus.register("npcaura", {}, "npcaura [radius]", "[radius]", "Auto-attack nearby NPCs", function(target, args)
    local radius = tonumber(args[1]) or tonumber(target) or 15
    if npcAuraConn then npcAuraConn:Disconnect() end
    npcAuraConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local tool = char:FindFirstChildWhichIsA("Tool")
        if not tool then return end
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
                if not Players:GetPlayerFromCharacter(obj) then
                    local nHRP = obj:FindFirstChild("HumanoidRootPart")
                    if nHRP and (nHRP.Position - hrp.Position).Magnitude <= radius then
                        pcall(function() tool:Activate() end)
                    end
                end
            end
        end
    end)
    notify("NpcAura", "Enabled.")
end)

_G.Nexus.register("unnpcaura", {}, "unnpcaura", "", "Stop NPC aura", function()
    if npcAuraConn then npcAuraConn:Disconnect() npcAuraConn = nil end
    notify("NpcAura", "Disabled.")
end)

-- ============================================================
-- HITBOXES (show all hitboxes)
-- ============================================================
local hitboxParts = {}

_G.Nexus.register("hitboxes", {}, "hitboxes", "", "Show a wireframe of every player's hitbox", function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not hitboxParts[plr] then
                local box = Instance.new("SelectionBox")
                box.Adornee = hrp
                box.Color3 = Color3.fromRGB(0, 255, 100)
                box.LineThickness = 0.05
                box.Parent = hrp
                hitboxParts[plr] = box
            end
        end
    end
    notify("Hitboxes", "Shown.")
end)

_G.Nexus.register("unhitboxes", {}, "unhitboxes", "", "Hide hitbox outlines", function()
    for plr, box in pairs(hitboxParts) do
        if box then box:Destroy() end
    end
    hitboxParts = {}
    notify("Hitboxes", "Hidden.")
end)

print("[Nexus] Batch 2 loaded. Hitbox / Reach ready.")
-- ============================================================
-- NEXUS - BATCH 3: AIMBOT / TRIGGERBOT
-- aimbot, triggerbot
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

-- ============================================================
-- AIMBOT (basic nearest-player camera lock)
-- ============================================================
local aimbotConn = nil
local AIMBOT_KEY = Enum.KeyCode.E
local AIMBOT_FOV = 200

_G.Nexus.register("aimbot", {"aim"}, "aimbot [fov]", "[fov]", "Lock camera onto nearest player (hold E)", function(target, args)
    local fov = tonumber(args[1]) or tonumber(target)
    if fov then AIMBOT_FOV = fov end

    if aimbotConn then
        notify("Aimbot", "Already enabled.")
        return
    end

    aimbotConn = RunService.RenderStepped:Connect(function()
        if not UserInputService:IsKeyDown(AIMBOT_KEY) then return end

        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        local closest, closestDist = nil, AIMBOT_FOV
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closest = hrp
                        end
                    end
                end
            end
        end

        if closest then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Position)
        end
    end)

    notify("Aimbot", "Enabled. Hold E to lock onto the nearest player.")
end)

_G.Nexus.register("unaimbot", {"unaim"}, "unaimbot", "", "Stop aimbot", function()
    if aimbotConn then
        aimbotConn:Disconnect()
        aimbotConn = nil
    end
    notify("Aimbot", "Disabled.")
end)

-- ============================================================
-- TRIGGERBOT (auto-fire when mouse is over an enemy)
-- ============================================================
local triggerbotConn = nil

_G.Nexus.register("triggerbot", {"tbot"}, "triggerbot [fov]", "[fov]", "Auto-activate tool when an enemy is under your crosshair", function(target, args)
    local fov = tonumber(args[1]) or tonumber(target) or 30

    if triggerbotConn then
        notify("Triggerbot", "Already enabled.")
        return
    end

    triggerbotConn = RunService.RenderStepped:Connect(function()
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        local mouse = UserInputService:GetMouseLocation()
        local camera = workspace.CurrentCamera
        local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        local dist = (mouse - center).Magnitude

        if dist > fov then return end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local offset = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
                        if offset < fov then
                            local tool = myChar:FindFirstChildWhichIsA("Tool")
                            if tool then
                                pcall(function() tool:Activate() end)
                            end
                            break
                        end
                    end
                end
            end
        end
    end)

    notify("Triggerbot", "Enabled (fov " .. fov .. ").")
end)

_G.Nexus.register("untriggerbot", {"untbot"}, "untriggerbot", "", "Stop triggerbot", function()
    if triggerbotConn then
        triggerbotConn:Disconnect()
        triggerbotConn = nil
    end
    notify("Triggerbot", "Disabled.")
end)

print("[Nexus] Batch 3 loaded. Aimbot / Triggerbot ready.")
-- ============================================================
-- NEXUS - BATCH 4: PLAYER INTERACTION
-- piggyback, unpiggyback, headsit, unheadsit, headstand,
-- unheadstand, orbit, unorbit, follow, unfollow, pathfind,
-- watch, unwatch, spook, unspook, glue, unglue
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function findPlayer(q)
    if _G.Nexus.findPlayer then return _G.Nexus.findPlayer(q) end
end

local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ============================================================
-- PIGGYBACK
-- ============================================================
local piggybackConn

_G.Nexus.register("piggyback", {"pback"}, "piggyback <player>", "<player>", "Ride on another player's back", function(target)
    if not target then notify("Piggyback", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Piggyback", "Player not found.") return end

    if piggybackConn then piggybackConn:Disconnect() end

    piggybackConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if not hrp or not plr.Character then return end
        local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
        if tHRP then
            hrp.CFrame = tHRP.CFrame * CFrame.new(0, 1, -1)
        end
    end)
    notify("Piggyback", "Riding on " .. plr.Name)
end)

_G.Nexus.register("unpiggyback", {"unpback"}, "unpiggyback", "", "Stop piggybacking", function()
    if piggybackConn then piggybackConn:Disconnect() piggybackConn = nil end
    notify("Piggyback", "Stopped.")
end)

-- ============================================================
-- HEADSIT
-- ============================================================
local headsitConn

_G.Nexus.register("headsit", {}, "headsit <player>", "<player>", "Sit on a player's head", function(target)
    if not target then notify("HeadSit", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("HeadSit", "Player not found.") return end

    if headsitConn then headsitConn:Disconnect() end

    headsitConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if not hrp or not plr.Character then return end
        local head = plr.Character:FindFirstChild("Head")
        if head then
            hrp.CFrame = head.CFrame * CFrame.new(0, 3, 0)
        end
    end)
    notify("HeadSit", "On " .. plr.Name .. "'s head.")
end)

_G.Nexus.register("unheadsit", {}, "unheadsit", "", "Stop headsit", function()
    if headsitConn then headsitConn:Disconnect() headsitConn = nil end
    notify("HeadSit", "Stopped.")
end)

-- ============================================================
-- HEADSTAND
-- ============================================================
local headstandConn

_G.Nexus.register("headstand", {}, "headstand <player>", "<player>", "Stand on a player's head", function(target)
    if not target then notify("HeadStand", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("HeadStand", "Player not found.") return end

    if headstandConn then headstandConn:Disconnect() end

    headstandConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if not hrp or not plr.Character then return end
        local head = plr.Character:FindFirstChild("Head")
        if head then
            hrp.CFrame = head.CFrame * CFrame.new(0, 5, 0)
        end
    end)
    notify("HeadStand", "On " .. plr.Name .. "'s head.")
end)

_G.Nexus.register("unheadstand", {}, "unheadstand", "", "Stop headstand", function()
    if headstandConn then headstandConn:Disconnect() headstandConn = nil end
    notify("HeadStand", "Stopped.")
end)

-- ============================================================
-- ORBIT
-- ============================================================
local orbitConn
local orbitAngle = 0

_G.Nexus.register("orbit", {}, "orbit <player> <distance> [speed]", "<player> <distance> [speed]", "Orbit around a player", function(target, args)
    if not target then notify("Orbit", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Orbit", "Player not found.") return end

    local distance = tonumber(args[1]) or 10
    local speed = tonumber(args[2]) or 2

    if orbitConn then orbitConn:Disconnect() end

    orbitConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if not hrp or not plr.Character then return end
        local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
        if tHRP then
            orbitAngle = orbitAngle + (speed * 0.05)
            local offset = Vector3.new(math.cos(orbitAngle) * distance, 3, math.sin(orbitAngle) * distance)
            hrp.CFrame = CFrame.new(tHRP.Position + offset, tHRP.Position)
        end
    end)
    notify("Orbit", "Orbiting " .. plr.Name)
end)

_G.Nexus.register("unorbit", {}, "unorbit", "", "Stop orbiting", function()
    if orbitConn then orbitConn:Disconnect() orbitConn = nil end
    notify("Orbit", "Stopped.")
end)

-- ============================================================
-- UPO RBIT (orbit on the vertical axis)
-- ============================================================
local uporbitConn
local uporbitAngle = 0

_G.Nexus.register("uporbit", {}, "uporbit <player> <distance> [speed]", "<player> <distance> [speed]", "Orbit around a player vertically", function(target, args)
    if not target then notify("UpOrbit", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("UpOrbit", "Player not found.") return end

    local distance = tonumber(args[1]) or 10
    local speed = tonumber(args[2]) or 2

    if uporbitConn then uporbitConn:Disconnect() end

    uporbitConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if not hrp or not plr.Character then return end
        local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
        if tHRP then
            uporbitAngle = uporbitAngle + (speed * 0.05)
            local offset = Vector3.new(0, math.cos(uporbitAngle) * distance, math.sin(uporbitAngle) * distance)
            hrp.CFrame = CFrame.new(tHRP.Position + offset, tHRP.Position)
        end
    end)
    notify("UpOrbit", "Orbiting " .. plr.Name)
end)

_G.Nexus.register("unuporbit", {}, "unuporbit", "", "Stop up-orbit", function()
    if uporbitConn then uporbitConn:Disconnect() uporbitConn = nil end
    notify("UpOrbit", "Stopped.")
end)

-- ============================================================
-- FOLLOW (simple heartbeat follow)
-- ============================================================
local followConn

_G.Nexus.register("follow", {"stalk"}, "follow <player>", "<player>", "Follow a player", function(target)
    if not target then notify("Follow", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Follow", "Player not found.") return end

    if followConn then followConn:Disconnect() end

    followConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if not hrp or not plr.Character then return end
        local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
        if tHRP then
            local dir = (tHRP.Position - hrp.Position)
            if dir.Magnitude > 5 then
                hrp.CFrame = CFrame.new(hrp.Position + dir.Unit * 2, tHRP.Position)
            end
        end
    end)
    notify("Follow", "Following " .. plr.Name)
end)

_G.Nexus.register("unfollow", {"unstalk"}, "unfollow", "", "Stop following", function()
    if followConn then followConn:Disconnect() followConn = nil end
    notify("Follow", "Stopped.")
end)

-- ============================================================
-- PATHFIND
-- ============================================================
local pathfindConn

_G.Nexus.register("pathfind", {"pf"}, "pathfind <player>", "<player>", "Pathfind to a player with the pathfinding API", function(target)
    if not target then notify("Pathfind", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Pathfind", "Player not found.") return end

    if pathfindConn then pathfindConn:Disconnect() end

    pathfindConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char or not plr.Character then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
        if not hum or not tHRP then return end

        local path = PathfindingService:CreatePath()
        local ok = pcall(function()
            path:ComputeAsync(char.HumanoidRootPart.Position, tHRP.Position)
        end)
        if ok and path.Status == Enum.PathStatus.Success then
            local waypoints = path:GetWaypoints()
            for _, wp in ipairs(waypoints) do
                hum:MoveTo(wp.Position)
                task.wait(0.3)
            end
        end
    end)
    notify("Pathfind", "Following " .. plr.Name)
end)

_G.Nexus.register("unpathfind", {}, "unpathfind", "", "Stop pathfinding", function()
    if pathfindConn then pathfindConn:Disconnect() pathfindConn = nil end
    notify("Pathfind", "Stopped.")
end)

-- ============================================================
-- WATCH (spectate)
-- ============================================================
local watchConn

_G.Nexus.register("watch", {"spec", "spectate"}, "watch <player>", "<player>", "Spectate a player", function(target)
    if not target then notify("Watch", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Watch", "Player not found.") return end

    if watchConn then watchConn:Disconnect() end

    watchConn = RunService.RenderStepped:Connect(function()
        if not plr.Character then return end
        local head = plr.Character:FindFirstChild("Head")
        if head then
            workspace.CurrentCamera.CameraSubject = head
        end
    end)
    notify("Watch", "Spectating " .. plr.Name)
end)

_G.Nexus.register("unwatch", {"unspec", "unspectate"}, "unwatch", "", "Stop spectating", function()
    if watchConn then watchConn:Disconnect() watchConn = nil end
    local char = getChar()
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then workspace.CurrentCamera.CameraSubject = hum end
    end
    notify("Watch", "Stopped.")
end)

-- ============================================================
-- SPOOK (teleport next to a player briefly)
-- ============================================================
_G.Nexus.register("spook", {"scare"}, "spook <player>", "<player>", "Teleport next to a player briefly", function(target)
    if not target then notify("Spook", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Spook", "Player not found.") return end

    local hrp = getHRP()
    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp and tHRP then
        local oldCF = hrp.CFrame
        hrp.CFrame = tHRP.CFrame + tHRP.CFrame.LookVector * 3
        task.wait(0.5)
        hrp.CFrame = oldCF
        notify("Spook", "Spooked " .. plr.Name)
    end
end)

-- ============================================================
-- GLUE (loop teleport to a player)
-- ============================================================
local glueConn

_G.Nexus.register("glue", {"loopgoto"}, "glue <player>", "<player>", "Constantly teleport to a player", function(target)
    if not target then notify("Glue", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr then notify("Glue", "Player not found.") return end

    if glueConn then glueConn:Disconnect() end

    glueConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if not hrp or not plr.Character then return end
        local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
        if tHRP then
            hrp.CFrame = tHRP.CFrame + Vector3.new(0, 2, 0)
        end
    end)
    notify("Glue", "Glued to " .. plr.Name)
end)

_G.Nexus.register("unglue", {"unloopgoto"}, "unglue", "", "Stop glue", function()
    if glueConn then glueConn:Disconnect() glueConn = nil end
    notify("Glue", "Stopped.")
end)

print("[Nexus] Batch 4 loaded. Player Interaction ready.")
-- ============================================================
-- NEXUS - BATCH 5: MOVEMENT II
-- tpup, tpdown, tweenTo, tweenGotToCamPos, tweengoto,
-- tponeat, fly2, unFly2, thrup
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function findPlayer(q)
    if _G.Nexus.findPlayer then return _G.Nexus.findPlayer(q) end
end

local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ============================================================
-- TPUP / TPDOWN
-- ============================================================
_G.Nexus.register("tpup", {"up"}, "tpup <studs>", "<studs>", "Teleport up by studs", function(target, args)
    local n = tonumber(args[1]) or tonumber(target) or 10
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = hrp.CFrame + Vector3.new(0, n, 0)
        notify("TpUp", "Teleported " .. n .. " studs up.")
    end
end)

_G.Nexus.register("tpdown", {"down"}, "tpdown <studs>", "<studs>", "Teleport down by studs", function(target, args)
    local n = tonumber(args[1]) or tonumber(target) or 10
    local hrp = getHRP()
    if hrp then
        hrp.CFrame = hrp.CFrame - Vector3.new(0, n, 0)
        notify("TpDown", "Teleported " .. n .. " studs down.")
    end
end)

-- ============================================================
-- TWEEN TO (smooth teleport that bypasses some anti-cheats)
-- ============================================================
local function tweenTo(targetCFrame, duration)
    local hrp = getHRP()
    if not hrp then return end
    duration = duration or 0.2
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), { CFrame = targetCFrame })
    tween:Play()
    return tween
end

_G.Nexus.register("tweengoto", {"tweento", "tgoto"}, "tweengoto <player>", "<player>", "Smoothly tween to a player", function(target)
    if not target then notify("TweenGoto", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("TweenGoto", "Player not found.") return end
    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
    if tHRP then
        tweenTo(tHRP.CFrame + Vector3.new(0, 2, 0))
        notify("TweenGoto", "Tweened to " .. plr.Name)
    end
end)

-- ============================================================
-- TWEEN TO CAMERA POSITION
-- ============================================================
_G.Nexus.register("tweengotocampos", {"tweentcp", "tocampos", "tcp"}, "tweengotocampos", "", "Tween to your camera position", function()
    local hrp = getHRP()
    if hrp and Camera then
        tweenTo(CFrame.new(Camera.CFrame.Position))
        notify("TweenToCamPos", "Moved to camera position.")
    end
end)

-- ============================================================
-- GOTO CAMERA POSITION (instant)
-- ============================================================
_G.Nexus.register("gotocampos", {"gotcp"}, "gotocampos", "", "Instantly teleport to your camera position", function()
    local hrp = getHRP()
    if hrp and Camera then
        hrp.CFrame = CFrame.new(Camera.CFrame.Position)
        notify("GotoCamPos", "Moved to camera position.")
    end
end)

-- ============================================================
-- TPONEAT (teleport near a player without touching them)
-- ============================================================
_G.Nexus.register("tponeat", {"tpnextto"}, "tponeat <player> [distance]", "<player> [distance]", "Teleport next to a player at a distance", function(target, args)
    if not target then notify("TpOneAt", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("TpOneAt", "Player not found.") return end
    local distance = tonumber(args[1]) or 3
    local hrp = getHRP()
    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp and tHRP then
        hrp.CFrame = tHRP.CFrame + tHRP.CFrame.LookVector * distance
        notify("TpOneAt", "Moved next to " .. plr.Name)
    end
end)

-- ============================================================
-- FLY V2 (camera-relative better fly)
-- ============================================================
local fly2Conn = nil
local fly2BodyVel = nil
local fly2Speed = 100

_G.Nexus.register("fly2", {"flyv2"}, "fly2 [speed]", "[speed]", "Fly v2 (Camera-relative, no gyro)", function(target, args)
    local speed = tonumber(args[1]) or tonumber(target)
    if speed then fly2Speed = speed end

    if fly2Conn then
        notify("Fly2", "Already enabled.")
        return
    end

    local hrp = getHRP()
    if not hrp then return end

    local hum = getChar():FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end

    fly2BodyVel = Instance.new("BodyVelocity")
    fly2BodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    fly2BodyVel.Velocity = Vector3.new(0, 0, 0)
    fly2BodyVel.P = 1e5
    fly2BodyVel.Parent = hrp

    fly2Conn = RunService.RenderStepped:Connect(function()
        local move = Vector3.new(0, 0, 0)
        local cf = Camera.CFrame

        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end

        if move.Magnitude > 0 then
            fly2BodyVel.Velocity = move.Unit * fly2Speed
        else
            fly2BodyVel.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    notify("Fly2", "Enabled. WASD + Space / LeftCtrl.")
end)

_G.Nexus.register("unfly2", {"unflyv2"}, "unfly2", "", "Stop fly v2", function()
    if fly2Conn then fly2Conn:Disconnect() fly2Conn = nil end
    if fly2BodyVel then fly2BodyVel:Destroy() fly2BodyVel = nil end
    local char = getChar()
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
    notify("Fly2", "Disabled.")
end)

-- ============================================================
-- THRU (move forward by distance ignoring walls - gentle version)
-- ============================================================
_G.Nexus.register("thru", {}, "thru <distance>", "<distance>", "Move forward ignoring collisions", function(target, args)
    local n = tonumber(args[1]) or tonumber(target) or 5
    local hrp = getHRP()
    if not hrp then return end
    local noclipBefore = true
    local char = getChar()
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * n
    task.wait(0.1)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.CanCollide = true
        end
    end
    notify("Thru", "Moved " .. n .. " studs forward.")
end)

print("[Nexus] Batch 5 loaded. Movement II ready.")
-- ============================================================
-- NEXUS - BATCH 6: ESP VARIANTS
-- espteam, espenemies, chamsteam, chamsenemies, locate,
-- unlocate, esplocator, unesplocator, itemesp, unitemesp
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

-- Storage for the different ESP types
local espStore = {
    team = {},
    enemies = {},
    locator = {},
    items = {},
}

-- Helper: build a highlight + billboard for a player
local function buildHighlight(player, color, showName, showDist, store)
    if store[player] then return end
    local char = player.Character
    if not char then return end

    local highlight = Instance.new("Highlight")
    highlight.Name = "NexusEsp"
    highlight.Adornee = char
    highlight.FillColor = color
    highlight.FillTransparency = 0.6
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char

    local billboard
    if showName or showDist then
        local head = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if head then
            billboard = Instance.new("BillboardGui")
            billboard.Name = "NexusEspTag"
            billboard.Size = UDim2.new(0, 200, 0, 50)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head

            if showName then
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(1, 0, 0, 20)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = player.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextStrokeTransparency = 0
                nameLabel.Font = Enum.Font.GothamBold
                nameLabel.TextSize = 14
                nameLabel.Parent = billboard
            end

            if showDist then
                local distLabel = Instance.new("TextLabel")
                distLabel.Name = "DistLabel"
                distLabel.Size = UDim2.new(1, 0, 0, 16)
                distLabel.Position = UDim2.new(0, 0, 0, 20)
                distLabel.BackgroundTransparency = 1
                distLabel.Text = ""
                distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                distLabel.TextStrokeTransparency = 0
                distLabel.Font = Enum.Font.Gotham
                distLabel.TextSize = 12
                distLabel.Parent = billboard
            end
        end
    end

    store[player] = { highlight = highlight, billboard = billboard }
end

local function removeStore(store)
    for plr, data in pairs(store) do
        if data.highlight then data.highlight:Destroy() end
        if data.billboard then data.billboard:Destroy() end
    end
    for plr in pairs(store) do store[plr] = nil end
end

-- Distance updater
RunService.RenderStepped:Connect(function()
    local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    for _, store in pairs(espStore) do
        for plr, data in pairs(store) do
            if data.billboard and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                local dl = data.billboard:FindFirstChild("DistLabel")
                if hrp and dl then
                    dl.Text = math.floor((hrp.Position - myHRP.Position).Magnitude) .. " studs"
                end
            end
        end
    end
end)

-- ============================================================
-- ESP TEAM
-- ============================================================
_G.Nexus.register("espteam", {"teamesp"}, "espteam", "", "ESP only your teammates", function()
    removeStore(espStore.team)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team == LocalPlayer.Team then
            buildHighlight(plr, Color3.fromRGB(0, 200, 100), true, true, espStore.team)
        end
    end
    notify("EspTeam", "Enabled.")
end)

_G.Nexus.register("unespteam", {"unteamesp"}, "unespteam", "", "Disable team ESP", function()
    removeStore(espStore.team)
    notify("EspTeam", "Disabled.")
end)

-- ============================================================
-- ESP ENEMIES
-- ============================================================
_G.Nexus.register("espenemies", {"enemyesp"}, "espenemies", "", "ESP only players outside your team", function()
    removeStore(espStore.enemies)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
            buildHighlight(plr, Color3.fromRGB(255, 80, 80), true, true, espStore.enemies)
        end
    end
    notify("EspEnemies", "Enabled.")
end)

_G.Nexus.register("unespenemies", {"unenemyesp"}, "unespenemies", "", "Disable enemy ESP", function()
    removeStore(espStore.enemies)
    notify("EspEnemies", "Disabled.")
end)

-- ============================================================
-- CHAMS TEAM / ENEMIES (same but without names)
-- ============================================================
_G.Nexus.register("chamsteam", {"teamchams"}, "chamsteam", "", "Chams for teammates only", function()
    removeStore(espStore.team)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team == LocalPlayer.Team then
            buildHighlight(plr, Color3.fromRGB(0, 200, 100), false, false, espStore.team)
        end
    end
    notify("ChamsTeam", "Enabled.")
end)

_G.Nexus.register("chamsenemies", {"enemychams"}, "chamsenemies", "", "Chams for players outside your team", function()
    removeStore(espStore.enemies)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Team ~= LocalPlayer.Team then
            buildHighlight(plr, Color3.fromRGB(255, 80, 80), false, false, espStore.enemies)
        end
    end
    notify("ChamsEnemies", "Enabled.")
end)

-- ============================================================
-- LOCATE (track a specific list of players)
-- ============================================================
local located = {}

_G.Nexus.register("locate", {}, "locate <player1> <player2> ...", "<player...>", "Track specific players with ESP", function(target, args)
    local list = {}
    if target then table.insert(list, target) end
    for _, a in ipairs(args) do table.insert(list, a) end

    if #list == 0 then notify("Locate", "Provide at least one player.") return end

    for _, name in ipairs(list) do
        local plr = _G.Nexus.findPlayer and _G.Nexus.findPlayer(name)
        if plr then
            if not located[plr] then
                local char = plr.Character
                if char then
                    local hl = Instance.new("Highlight")
                    hl.Name = "NexusLocate"
                    hl.Adornee = char
                    hl.FillColor = Color3.fromRGB(255, 220, 60)
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = char
                    located[plr] = hl
                end
            end
        end
    end
    notify("Locate", "Tracking " .. #list .. " players.")
end)

_G.Nexus.register("unlocate", {}, "unlocate", "", "Stop tracking located players", function()
    for plr, hl in pairs(located) do
        if hl then hl:Destroy() end
    end
    located = {}
    notify("Locate", "Stopped.")
end)

-- ============================================================
-- ESP LOCATOR (highlight everyone and then let you narrow down)
-- ============================================================
_G.Nexus.register("esplocator", {"locator"}, "esplocator", "", "ESP all players with the locator color", function()
    removeStore(espStore.locator)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            buildHighlight(plr, Color3.fromRGB(255, 220, 60), true, true, espStore.locator)
        end
    end
    notify("EspLocator", "Enabled.")
end)

_G.Nexus.register("unesplocator", {"unlocator"}, "unesplocator", "", "Disable locator ESP", function()
    removeStore(espStore.locator)
    notify("EspLocator", "Disabled.")
end)

-- ============================================================
-- ITEM ESP (highlight dropped tools in workspace)
-- ============================================================
local itemHighlights = {}

_G.Nexus.register("itemesp", {"toolesp"}, "itemesp", "", "Highlight every dropped Tool in Workspace", function()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and not itemHighlights[obj] then
            local hl = Instance.new("Highlight")
            hl.Name = "NexusItemEsp"
            hl.Adornee = obj
            hl.FillColor = Color3.fromRGB(255, 200, 80)
            hl.FillTransparency = 0.5
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = obj
            itemHighlights[obj] = hl
        end
    end
    notify("ItemEsp", "Enabled.")
end)

_G.Nexus.register("unitemesp", {"untoolesp"}, "unitemesp", "", "Disable item ESP", function()
    for obj, hl in pairs(itemHighlights) do
        if hl then hl:Destroy() end
    end
    itemHighlights = {}
    notify("ItemEsp", "Disabled.")
end)

print("[Nexus] Batch 6 loaded. ESP Variants ready.")
-- ============================================================
-- NEXUS - BATCH 7: NPC II
-- npcesp, npcchams, unnpcesp, clickkillnpc, unclickkillnpc,
-- clickvoidnpc, unclickvoidnpc, voidnpcs, actnpc, unactnpc
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

-- ============================================================
-- NPC detection
-- ============================================================
local function isNPC(model)
    if not model:IsA("Model") then return false end
    if not model:FindFirstChildOfClass("Humanoid") then return false end
    if Players:GetPlayerFromCharacter(model) then return false end
    return true
end

local function getNPCs()
    local out = {}
    for _, obj in ipairs(workspace:GetChildren()) do
        if isNPC(obj) then table.insert(out, obj) end
    end
    return out
end

-- ============================================================
-- NPC ESP
-- ============================================================
local npcEspStore = {}

_G.Nexus.register("npcesp", {"espnpc"}, "npcesp", "", "ESP every NPC", function()
    for _, npc in ipairs(getNPCs()) do
        if not npcEspStore[npc] then
            local hl = Instance.new("Highlight")
            hl.Name = "NexusNpcEsp"
            hl.Adornee = npc
            hl.FillColor = Color3.fromRGB(255, 180, 80)
            hl.FillTransparency = 0.6
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = npc
            npcEspStore[npc] = hl
        end
    end
    notify("NpcEsp", "Enabled.")
end)

-- ============================================================
-- NPC CHAMS (same effect but no FillTransparency on click detection - same)
-- ============================================================
_G.Nexus.register("npcchams", {"chamsnpc"}, "npcchams", "", "Chams for every NPC", function()
    for _, npc in ipairs(getNPCs()) do
        if not npcEspStore[npc] then
            local hl = Instance.new("Highlight")
            hl.Name = "NexusNpcEsp"
            hl.Adornee = npc
            hl.FillColor = Color3.fromRGB(255, 80, 80)
            hl.FillTransparency = 0.5
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = npc
            npcEspStore[npc] = hl
        end
    end
    notify("NpcChams", "Enabled.")
end)

_G.Nexus.register("unnpcesp", {"unnpcchams"}, "unnpcesp", "", "Disable NPC ESP / chams", function()
    for npc, hl in pairs(npcEspStore) do
        if hl then hl:Destroy() end
    end
    npcEspStore = {}
    notify("NpcEsp", "Disabled.")
end)

-- ============================================================
-- CLICK KILL NPC (click on an NPC to kill it)
-- ============================================================
local clickKillNpcConn

_G.Nexus.register("clickkillnpc", {"cknpc"}, "clickkillnpc", "", "Click an NPC to kill it", function()
    if clickKillNpcConn then return end
    clickKillNpcConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target then
                local model = target:FindFirstAncestorOfClass("Model")
                if model and isNPC(model) then
                    local hum = model:FindFirstChildOfClass("Humanoid")
                    if hum then hum.Health = 0 end
                end
            end
        end
    end)
    notify("ClickKillNpc", "Enabled.")
end)

_G.Nexus.register("unclickkillnpc", {"uncknpc"}, "unclickkillnpc", "", "Disable click kill NPC", function()
    if clickKillNpcConn then clickKillNpcConn:Disconnect() clickKillNpcConn = nil end
    notify("ClickKillNpc", "Disabled.")
end)

-- ============================================================
-- CLICK VOID NPC (click an NPC to send it to the void)
-- ============================================================
local clickVoidNpcConn

_G.Nexus.register("clickvoidnpc", {"cvnpc"}, "clickvoidnpc", "", "Click an NPC to send it into the void", function()
    if clickVoidNpcConn then return end
    clickVoidNpcConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target then
                local model = target:FindFirstAncestorOfClass("Model")
                if model and isNPC(model) then
                    local hrp = model:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = CFrame.new(0, -100000, 0)
                    end
                end
            end
        end
    end)
    notify("ClickVoidNpc", "Enabled.")
end)

_G.Nexus.register("unclickvoidnpc", {"uncvnpc"}, "unclickvoidnpc", "", "Disable click void NPC", function()
    if clickVoidNpcConn then clickVoidNpcConn:Disconnect() clickVoidNpcConn = nil end
    notify("ClickVoidNpc", "Disabled.")
end)

-- ============================================================
-- VOID NPCS (send every NPC to the void - advanced version)
-- ============================================================
_G.Nexus.register("voidnpcs", {"vnpcs"}, "voidnpcs", "", "Send every NPC to the void", function()
    local count = 0
    for _, npc in ipairs(getNPCs()) do
        local hrp = npc:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(0, -100000, 0)
            count = count + 1
        end
    end
    notify("VoidNPCs", "Sent " .. count .. " NPCs to the void.")
end)

-- ============================================================
-- ACT NPC (act like an NPC yourself - freeze animations)
-- ============================================================
local actNpcConn

_G.Nexus.register("actnpc", {}, "actnpc", "", "Act like an NPC (freeze animations, stand still)", function()
    if actNpcConn then return end
    actNpcConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            hum.UseJumpPower = true
        end
    end)
    notify("ActNpc", "Enabled.")
end)

_G.Nexus.register("unactnpc", {"stopnpc"}, "unactnpc", "", "Stop acting like an NPC", function()
    if actNpcConn then actNpcConn:Disconnect() actNpcConn = nil end
    local char = getChar()
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
    notify("ActNpc", "Disabled.")
end)

print("[Nexus] Batch 7 loaded. NPC II ready.")
-- ============================================================
-- NEXUS - BATCH 8: REMOTES II
-- fireremotefind, autofireremote, unautofireremote,
-- blockremote, unblockremote, serverremotespy, unserverremotespy
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

-- ============================================================
-- FIREREMOTEFIND (fire only matching remotes)
-- ============================================================
_G.Nexus.register("fireremotefind", {"fremotefind"}, "fireremotefind <name>", "<name>", "Fire every remote whose name contains <name>", function(target)
    if not target then notify("FireremoteFind", "Provide a name.") return end
    local lower = target:lower()
    local count = 0
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Name:lower():find(lower, 1, true) then
            pcall(function()
                obj:FireServer()
                count = count + 1
            end)
        end
    end
    notify("FireremoteFind", "Fired " .. count .. " remotes matching " .. target)
end)

-- ============================================================
-- AUTOFIREREMOTE (keep firing a remote on interval)
-- ============================================================
local autoFireConn

_G.Nexus.register("autofireremote", {"afr"}, "autofireremote <interval> <name>", "<interval> <name>", "Automatically fire a remote on interval", function(target, args)
    local interval = tonumber(args[1]) or tonumber(target)
    local name = args[2]

    if not interval or not name then
        notify("AutoFireRemote", "Usage: autofireremote <interval> <name>")
        return
    end

    if autoFireConn then autoFireConn:Disconnect() end

    local lower = name:lower()
    autoFireConn = task.spawn(function()
        while true do
            for _, obj in ipairs(game:GetDescendants()) do
                if obj:IsA("RemoteEvent") and obj.Name:lower():find(lower, 1, true) then
                    pcall(function() obj:FireServer() end)
                end
            end
            task.wait(interval)
        end
    end)
    notify("AutoFireRemote", "Firing remotes matching " .. name)
end)

_G.Nexus.register("unautofireremote", {"unafr"}, "unautofireremote", "", "Stop auto firing", function()
    if autoFireConn then
        pcall(function() task.cancel(autoFireConn) end)
        autoFireConn = nil
    end
    notify("AutoFireRemote", "Stopped.")
end)

-- ============================================================
-- BLOCKREMOTE (block specific remotes from reaching the server)
-- ============================================================
local blockedRemotes = {}

_G.Nexus.register("blockremote", {"br"}, "blockremote <name>", "<name>", "Block a remote from sending to the server", function(target)
    if not target then notify("BlockRemote", "Provide a name.") return end
    local lower = target:lower()

    local ok = pcall(function()
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and self:IsA("RemoteEvent") then
                if self.Name:lower():find(lower, 1, true) then
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)

    if ok then
        blockedRemotes[lower] = true
        notify("BlockRemote", "Blocked remotes matching " .. target)
    else
        notify("BlockRemote", "Not supported.")
    end
end)

_G.Nexus.register("unblockremote", {"ubr"}, "unblockremote [name]", "[name]", "Unblock a remote or all", function(target)
    if target then
        blockedRemotes[target:lower()] = nil
        notify("BlockRemote", "Unblocked " .. target)
    else
        blockedRemotes = {}
        notify("BlockRemote", "Unblocked all.")
    end
end)

-- ============================================================
-- SERVERREMOTESPY (log remotes coming from the server)
-- ============================================================
local serverRemoteSpyGui
local serverRemoteSpyConn

local function buildSpyGui()
    if serverRemoteSpyGui then serverRemoteSpyGui:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "NexusServerRemoteSpy"
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 500, 0, 400)
    frame.Position = UDim2.new(0, 20, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 55)
    stroke.Thickness = 1
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Server Remote Spy"
    title.TextColor3 = Color3.fromRGB(232, 232, 238)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 24, 0, 24)
    close.Position = UDim2.new(1, -30, 0, 4)
    close.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
    close.BorderSizePixel = 0
    close.Text = "×"
    close.TextColor3 = Color3.fromRGB(232, 232, 238)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 16
    close.Parent = frame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = close

    close.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -40)
    scroll.Position = UDim2.new(0, 10, 0, 36)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Color3.fromRGB(122, 122, 140)
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = frame

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 4)
    listLayout.Parent = scroll

    serverRemoteSpyGui = gui
    return scroll
end

_G.Nexus.register("serverremotespy", {"srs", "sremotespy"}, "serverremotespy", "", "Log all remote events received from the server", function()
    local scroll = buildSpyGui()

    if serverRemoteSpyConn then
        serverRemoteSpyConn:Disconnect()
    end

    serverRemoteSpyConn = game.DescendantAdded:Connect(function(obj)
        if obj:IsA("RemoteEvent") then
            -- Some games fire named remotes; we cannot fully hook them without hookfunction
            -- But we can log them being added and prefixed
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 22)
            lbl.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
            lbl.BorderSizePixel = 0
            lbl.Text = "  " .. obj:GetFullName()
            lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
            lbl.Font = Enum.Font.Code
            lbl.TextSize = 11
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = scroll

            local lc = Instance.new("UICorner")
            lc.CornerRadius = UDim.new(0, 4)
            lc.Parent = lbl
        end
    end)

    notify("ServerRemoteSpy", "Enabled. UI opened.")
end)

_G.Nexus.register("unserverremotespy", {"unsrs"}, "unserverremotespy", "", "Stop server remote spy", function()
    if serverRemoteSpyConn then serverRemoteSpyConn:Disconnect() serverRemoteSpyConn = nil end
    if serverRemoteSpyGui then serverRemoteSpyGui:Destroy() serverRemoteSpyGui = nil end
    notify("ServerRemoteSpy", "Disabled.")
end)

print("[Nexus] Batch 8 loaded. Remotes II ready.")
-- ============================================================
-- NEXUS - BATCH 9: TOOL II
-- droptool, droptools, toolinvisible, preventtools,
-- unpreventtools, loopdroptools, unloopdroptools, copytools,
-- savetools, loadtools
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function getChar() return LocalPlayer.Character end
local function getBackpack()
    return LocalPlayer:FindFirstChildOfClass("Backpack")
end

-- ============================================================
-- DROPTOOL (single)
-- ============================================================
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
    notify("DropTool", "No equipped tools.")
end)

-- ============================================================
-- DROPTOOLS (all equipped)
-- ============================================================
_G.Nexus.register("droptools", {"dropalltools"}, "droptools", "", "Drop every equipped tool", function()
    local char = getChar()
    if not char then return end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            obj.Parent = Workspace
        end
    end
    notify("DropTools", "Dropped all equipped tools.")
end)

-- ============================================================
-- LOOP DROP TOOLS
-- ============================================================
local loopDropToolsActive = false

_G.Nexus.register("loopdroptools", {"ldtools"}, "loopdroptools", "", "Keep dropping your tools", function()
    if loopDropToolsActive then return end
    loopDropToolsActive = true
    task.spawn(function()
        while loopDropToolsActive do
            local char = getChar()
            if char then
                for _, obj in ipairs(char:GetChildren()) do
                    if obj:IsA("Tool") then
                        obj.Parent = Workspace
                    end
                end
            end
            task.wait(0.1)
        end
    end)
    notify("LoopDropTools", "Enabled.")
end)

_G.Nexus.register("unloopdroptools", {"unldtools"}, "unloopdroptools", "", "Stop loop dropping tools", function()
    loopDropToolsActive = false
    notify("LoopDropTools", "Disabled.")
end)

-- ============================================================
-- TOOL INVISIBLE (be invisible while still using tools)
-- ============================================================
local toolInvisConn

_G.Nexus.register("toolinvisible", {"tinvis"}, "toolinvisible", "", "Become invisible while keeping your tools usable", function()
    if toolInvisConn then return end
    toolInvisConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.LocalTransparencyModifier = 1
            end
            if part:IsA("Decal") then
                part.Transparency = 1
            end
        end
    end)
    notify("ToolInvisible", "Enabled.")
end)

_G.Nexus.register("untoolinvisible", {"untinvis"}, "untoolinvisible", "", "Stop tool invisible", function()
    if toolInvisConn then toolInvisConn:Disconnect() toolInvisConn = nil end
    local char = getChar()
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
            if part:IsA("Decal") then
                part.Transparency = 0
            end
        end
    end
    notify("ToolInvisible", "Disabled.")
end)

-- ============================================================
-- PREVENT TOOLS (block equipping)
-- ============================================================
local preventToolsConn

_G.Nexus.register("preventtools", {"noequip"}, "preventtools", "", "Prevent any tool from being equipped", function()
    if preventToolsConn then return end
    local char = getChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    preventToolsConn = hum.ChildAdded:Connect(function(obj)
        if obj:IsA("Tool") then
            task.wait(0.01)
            hum:UnequipTools()
        end
    end)
    notify("PreventTools", "Enabled.")
end)

_G.Nexus.register("unpreventtools", {"unnoequip"}, "unpreventtools", "", "Allow tools again", function()
    if preventToolsConn then preventToolsConn:Disconnect() preventToolsConn = nil end
    notify("PreventTools", "Disabled.")
end)

-- ============================================================
-- COPY TOOLS (copy from another player)
-- ============================================================
_G.Nexus.register("copytools", {"ctools"}, "copytools <player>", "<player>", "Copy all of another player's tools", function(target)
    if not target then notify("CopyTools", "Provide a target.") return end
    local plr = _G.Nexus.findPlayer and _G.Nexus.findPlayer(target)
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
-- SAVE / LOAD TOOLS
-- ============================================================
_G.Nexus.SavedTools = _G.Nexus.SavedTools or {}

_G.Nexus.register("savetools", {"stools"}, "savetools", "", "Save your current tools", function()
    local char = getChar()
    local backpack = getBackpack()
    if not char or not backpack then return end

    _G.Nexus.SavedTools = {}

    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then table.insert(_G.Nexus.SavedTools, obj) end
    end
    for _, obj in ipairs(backpack:GetChildren()) do
        if obj:IsA("Tool") then table.insert(_G.Nexus.SavedTools, obj) end
    end

    notify("SaveTools", "Saved " .. #_G.Nexus.SavedTools .. " tools.")
end)

_G.Nexus.register("loadtools", {"ltools"}, "loadtools", "", "Restore your saved tools", function()
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
-- NO TOOLS (delete every tool you own)
-- ============================================================
_G.Nexus.register("notools", {"removetools"}, "notools", "", "Remove every tool from your character", function()
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

print("[Nexus] Batch 9 loaded. Tool II ready.")
-- ============================================================
-- NEXUS - BATCH 10: FLING II
-- flyfling, unflyfling, walkfling, unwalkfling,
-- touchfling, untouchfling, cartornado, uncartornado,
-- blackholefollow, noblackholefollow, tpua
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function findPlayer(q)
    if _G.Nexus.findPlayer then return _G.Nexus.findPlayer(q) end
end

-- ============================================================
-- FLY FLING (fly and fling everything you touch)
-- ============================================================
local flyFlingConn

_G.Nexus.register("flyfling", {"ff"}, "flyfling [speed]", "[speed]", "Fly and fling anything you touch", function(target, args)
    local speed = tonumber(args[1]) or tonumber(target) or 200

    if flyFlingConn then
        notify("FlyFling", "Already enabled.")
        return
    end

    local hrp = getHRP()
    if not hrp then return end

    local hum = getChar():FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = true end

    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.P = 1e5
    bv.Parent = hrp

    local UIS = game:GetService("UserInputService")
    local Camera = workspace.CurrentCamera

    flyFlingConn = RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent then return end
        local move = Vector3.new(0, 0, 0)
        local cf = Camera.CFrame
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        bv.Velocity = move.Magnitude > 0 and move.Unit * speed or Vector3.new(0, 0, 0)

        -- Fling anyone close
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                if tHRP and (tHRP.Position - hrp.Position).Magnitude < 5 then
                    tHRP.Velocity = Vector3.new(500, 500, 500)
                end
            end
        end
    end)
    notify("FlyFling", "Enabled.")
end)

_G.Nexus.register("unflyfling", {"unff"}, "unflyfling", "", "Stop fly fling", function()
    if flyFlingConn then flyFlingConn:Disconnect() flyFlingConn = nil end
    local hrp = getHRP()
    if hrp then
        for _, obj in ipairs(hrp:GetChildren()) do
            if obj:IsA("BodyVelocity") then obj:Destroy() end
        end
    end
    local hum = getChar() and getChar():FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
    notify("FlyFling", "Disabled.")
end)

-- ============================================================
-- WALK FLING (walk around and fling everyone you touch)
-- ============================================================
local walkFlingConn
local WALKFLING_SPEED = 200

_G.Nexus.register("walkfling", {"wfling", "wf"}, "walkfling [speed]", "[speed]", "Fling people just by walking into them", function(target, args)
    local speed = tonumber(args[1]) or tonumber(target)
    if speed then WALKFLING_SPEED = speed end

    if walkFlingConn then
        notify("WalkFling", "Already enabled.")
        return
    end

    walkFlingConn = RunService.Heartbeat:Connect(function()
        local hrp = getHRP()
        if not hrp then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                if tHRP and (tHRP.Position - hrp.Position).Magnitude < 4 then
                    tHRP.Velocity = Vector3.new(WALKFLING_SPEED, WALKFLING_SPEED, WALKFLING_SPEED)
                end
            end
        end
    end)
    notify("WalkFling", "Enabled.")
end)

_G.Nexus.register("unwalkfling", {"unwfling", "unwf"}, "unwalkfling", "", "Stop walk fling", function()
    if walkFlingConn then walkFlingConn:Disconnect() walkFlingConn = nil end
    notify("WalkFling", "Disabled.")
end)

-- ============================================================
-- TOUCH FLING (only fling when you touch them)
-- ============================================================
local touchFlingConn
local TOUCHFLING_SPEED = 500

_G.Nexus.register("touchfling", {"tfling", "tf"}, "touchfling [speed]", "[speed]", "Fling anyone your character touches", function(target, args)
    local speed = tonumber(args[1]) or tonumber(target)
    if speed then TOUCHFLING_SPEED = speed end

    if touchFlingConn then
        notify("TouchFling", "Already enabled.")
        return
    end

    touchFlingConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                for _, part in ipairs(plr.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        for _, myPart in ipairs(char:GetDescendants()) do
                            if myPart:IsA("BasePart") then
                                if (part.Position - myPart.Position).Magnitude < 2 then
                                    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                                    if tHRP then
                                        tHRP.Velocity = Vector3.new(TOUCHFLING_SPEED, TOUCHFLING_SPEED, TOUCHFLING_SPEED)
                                    end
                                    return
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
    notify("TouchFling", "Enabled.")
end)

_G.Nexus.register("untouchfling", {"untfling", "untf"}, "untouchfling", "", "Stop touch fling", function()
    if touchFlingConn then touchFlingConn:Disconnect() touchFlingConn = nil end
    notify("TouchFling", "Disabled.")
end)

-- ============================================================
-- CARTORNADO (spins a car into a tornado - sit in a car first)
-- ============================================================
local carTornadoConn

_G.Nexus.register("cartornado", {"ctornado"}, "cartornado", "", "Spin the car you are sitting in into a tornado", function()
    if carTornadoConn then return end
    local char = getChar()
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local seat = hum and hum.SeatPart
    if not seat then notify("CarTornado", "Sit in a car first.") return end

    local car = seat:FindFirstAncestorOfClass("Model")
    if not car then notify("CarTornado", "No car found.") return end

    carTornadoConn = RunService.Heartbeat:Connect(function()
        if not car or not car.Parent then return end
        for _, part in ipairs(car:GetDescendants()) do
            if part:IsA("BasePart") then
                part.AssemblyAngularVelocity = Vector3.new(0, 200, 0)
            end
        end
    end)
    notify("CarTornado", "Spinning.")
end)

_G.Nexus.register("uncartornado", {"unctornado"}, "uncartornado", "", "Stop the car tornado", function()
    if carTornadoConn then carTornadoConn:Disconnect() carTornadoConn = nil end
    notify("CarTornado", "Stopped.")
end)

-- ============================================================
-- BLACKHOLE FOLLOW (pull every unanchored part to you)
-- ============================================================
local blackholeFollowActive = false

_G.Nexus.register("blackholefollow", {"bhf"}, "blackholefollow", "", "Pull all unanchored parts to you with spin", function()
    if blackholeFollowActive then return end
    blackholeFollowActive = true
    task.spawn(function()
        while blackholeFollowActive do
            local hrp = getHRP()
            if hrp then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and not obj.Anchored then
                        if not Players:GetPlayerFromCharacter(obj.Parent) then
                            local dir = (hrp.Position - obj.Position)
                            if dir.Magnitude < 200 then
                                obj.AssemblyLinearVelocity = dir.Unit * 250
                                obj.AssemblyAngularVelocity = Vector3.new(50, 50, 50)
                            end
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end)
    notify("BlackholeFollow", "Enabled.")
end)

_G.Nexus.register("noblackholefollow", {"nobhf"}, "noblackholefollow", "", "Stop blackhole follow", function()
    blackholeFollowActive = false
    notify("BlackholeFollow", "Disabled.")
end)

-- ============================================================
-- TPUA (bring every unanchored part to a player)
-- ============================================================
_G.Nexus.register("tpua", {"bringua"}, "tpua <player>", "<player>", "Bring every unanchored part to a player", function(target)
    if not target then notify("Tpua", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Tpua", "Player not found.") return end
    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
    if not tHRP then return end

    local count = 0
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored and not Players:GetPlayerFromCharacter(obj.Parent) then
            obj.CFrame = tHRP.CFrame + Vector3.new(math.random(-5, 5), math.random(2, 8), math.random(-5, 5))
            count = count + 1
        end
    end
    notify("Tpua", "Brought " .. count .. " parts to " .. plr.Name)
end)

print("[Nexus] Batch 10 loaded. Fling II ready.")
-- ============================================================
-- NEXUS - BATCH 11: MISC I
-- dex, olddex, synapsedex, rc7, moduleeditor, upvalueeditor,
-- decompiler, partname, gameinfo, jobid, getgenv
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

-- ============================================================
-- DEX EXPLORER (loader by Moon)
-- ============================================================
_G.Nexus.register("dex", {}, "dex", "", "Load the Dex explorer", function()
    local url = "https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"
    local ok, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if ok then
        notify("Dex", "Loaded.")
    else
        notify("Dex", "Failed: " .. tostring(err))
    end
end)

-- ============================================================
-- OLD DEX (lighter version)
-- ============================================================
_G.Nexus.register("olddex", {}, "olddex", "", "Load the old Dex explorer", function()
    local url = "https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua"
    pcall(function() loadstring(game:HttpGet(url))() end)
    notify("OldDex", "Loaded (fallback).")
end)

-- ============================================================
-- SYNAPSE DEX
-- ============================================================
_G.Nexus.register("synapsedex", {"sdex"}, "synapsedex", "", "Load Synapse's Dex explorer", function()
    local url = "https://raw.githubusercontent.com/AhmadV99/SynapseX-Dex/master/out.lua"
    local ok, err = pcall(function() loadstring(game:HttpGet(url))() end)
    if ok then notify("SynapseDex", "Loaded.") else notify("SynapseDex", "Failed.") end
end)

-- ============================================================
-- RC7
-- ============================================================
_G.Nexus.register("rc7", {}, "rc7", "", "Load RC7 internal UI", function()
    local url = "https://raw.githubusercontent.com/78n/RC7/main/rc7.lua"
    local ok = pcall(function() loadstring(game:HttpGet(url))() end)
    notify("RC7", ok and "Loaded." or "Failed.")
end)

-- ============================================================
-- MODULE EDITOR (simple table walker)
-- ============================================================
_G.Nexus.register("moduleeditor", {"mtable"}, "moduleeditor", "", "Open a ModuleScript picker with editable tables", function()
    local modules = {}
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("ModuleScript") then table.insert(modules, obj) end
    end
    notify("ModuleEditor", "Found " .. #modules .. " modules.")
    for _, m in ipairs(modules) do
        print("[Nexus ModuleEditor] " .. m:GetFullName())
    end
end)

-- ============================================================
-- UPVALUE EDITOR (prints upvalues of a script)
-- ============================================================
_G.Nexus.register("upvalueeditor", {"uveditor"}, "upvalueeditor", "", "Print the upvalues of every LocalScript", function()
    if not getupvalues or not getscriptclosure then
        notify("UpvalueEditor", "Not supported by this executor.")
        return
    end
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") then
            pcall(function()
                local f = getscriptclosure(obj)
                local ups = getupvalues(f)
                print("[Nexus UpvalueEditor] " .. obj:GetFullName())
                for i, up in ipairs(ups) do
                    print("   [" .. i .. "] " .. tostring(up))
                end
            end)
        end
    end
    notify("UpvalueEditor", "Printed to console.")
end)

-- ============================================================
-- DECOMPILER
-- ============================================================
_G.Nexus.register("decompiler", {}, "decompiler", "", "Print the bytecode of a LocalScript (executor-dependent)", function()
    if not getscriptbytecode then
        notify("Decompiler", "Not supported by this executor.")
        return
    end
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
            pcall(function()
                local bc = getscriptbytecode(obj)
                print("[Nexus Decompiler] " .. obj:GetFullName() .. " (" .. #bc .. " bytes)")
            end)
        end
    end
    notify("Decompiler", "Printed to console.")
end)

-- ============================================================
-- PART NAME (click to grab full path)
-- ============================================================
local partNameConn
local partNameGui

_G.Nexus.register("partname", {"partpath"}, "partname", "", "Click any part to copy its full path", function()
    if partNameConn then return end
    local UserInputService = game:GetService("UserInputService")
    partNameConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target then
                local path = target:GetFullName()
                pcall(function() if setclipboard then setclipboard(path) end end)
                notify("PartName", path)
            end
        end
    end)
    notify("PartName", "Enabled. Click a part.")
end)

_G.Nexus.register("unpartname", {"unpartpath"}, "unpartname", "", "Stop part name clicker", function()
    if partNameConn then partNameConn:Disconnect() partNameConn = nil end
    notify("PartName", "Disabled.")
end)

-- ============================================================
-- GAME INFO
-- ============================================================
_G.Nexus.register("gameinfo", {"ginfo"}, "gameinfo", "", "Print game info to console", function()
    notify("GameInfo", "PlaceId: " .. game.PlaceId .. " | JobId: " .. game.JobId:sub(1, 8))
    print("[Nexus GameInfo] PlaceId: " .. game.PlaceId)
    print("[Nexus GameInfo] GameId: " .. game.GameId)
    print("[Nexus GameInfo] JobId: " .. game.JobId)
    print("[Nexus GameInfo] PlaceName: " .. tostring(game.PlaceId))
end)

-- ============================================================
-- JOBID / PLACEID / GAMEID
-- ============================================================
_G.Nexus.register("jobid", {"jid"}, "jobid", "", "Copy the JobId", function()
    pcall(function() if setclipboard then setclipboard(game.JobId) end end)
    notify("JobId", game.JobId)
end)

_G.Nexus.register("placeid", {"pid"}, "placeid", "", "Copy the PlaceId", function()
    pcall(function() if setclipboard then setclipboard(tostring(game.PlaceId)) end end)
    notify("PlaceId", tostring(game.PlaceId))
end)

_G.Nexus.register("gameid", {"gid"}, "gameid", "", "Copy the GameId", function()
    pcall(function() if setclipboard then setclipboard(tostring(game.GameId)) end end)
    notify("GameId", tostring(game.GameId))
end)

-- ============================================================
-- GETGENV
-- ============================================================
_G.Nexus.register("getgenv", {"genv"}, "getgenv", "", "Print the executor's globals table", function()
    if getgenv then
        print("[Nexus getgenv]")
        for k, v in pairs(getgenv()) do
            print("  " .. tostring(k) .. " = " .. tostring(v))
        end
        notify("getgenv", "Printed to console.")
    else
        notify("getgenv", "Not supported.")
    end
end)

print("[Nexus] Batch 11 loaded. Misc I ready.")
-- ============================================================
-- NEXUS - BATCH 12: MISC II
-- minimap, animationplayer, speedometer, keystroke, notepad,
-- backpack, autoclicker, keyboard
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

-- ============================================================
-- SPEEDOMETER
-- ============================================================
local speedoGui

_G.Nexus.register("speedometer", {"sps", "speedo"}, "speedometer", "", "Show a speedometer of your character", function()
    if speedoGui then speedoGui:Destroy() end

    speedoGui = Instance.new("ScreenGui")
    speedoGui.Name = "NexusSpeedometer"
    speedoGui.ResetOnSpawn = false
    speedoGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 180, 0, 50)
    frame.Position = UDim2.new(0, 20, 0.5, 0)
    frame.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
    frame.BorderSizePixel = 0
    frame.Parent = speedoGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 55)
    stroke.Thickness = 1
    stroke.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = "0 studs/s"
    label.TextColor3 = Color3.fromRGB(232, 232, 238)
    label.Font = Enum.Font.Code
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not speedoGui or not speedoGui.Parent then conn:Disconnect() return end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local speed = hrp.AssemblyLinearVelocity.Magnitude
            label.Text = math.floor(speed) .. " studs/s"
        end
    end)
    notify("Speedometer", "Enabled.")
end)

_G.Nexus.register("closespeedometer", {"nosps", "unspeedo"}, "closespeedometer", "", "Close the speedometer", function()
    if speedoGui then speedoGui:Destroy() speedoGui = nil end
    notify("Speedometer", "Closed.")
end)

-- ============================================================
-- KEYSTROKE (shows the keys you are pressing)
-- ============================================================
local keystrokeGui
local keyLabels = {}

local function buildKeystroke()
    if keystrokeGui then keystrokeGui:Destroy() end
    keystrokeGui = Instance.new("ScreenGui")
    keystrokeGui.Name = "NexusKeystroke"
    keystrokeGui.ResetOnSpawn = false
    keystrokeGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 50)
    frame.Position = UDim2.new(0.5, -110, 1, -70)
    frame.BackgroundTransparency = 1
    frame.Parent = keystrokeGui

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = frame

    local keys = {"W", "A", "S", "D", "Space"}
    for _, k in ipairs(keys) do
        local box = Instance.new("TextLabel")
        box.Size = UDim2.new(0, 36, 1, 0)
        box.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
        box.BorderSizePixel = 0
        box.Text = k
        box.TextColor3 = Color3.fromRGB(122, 122, 140)
        box.Font = Enum.Font.GothamBold
        box.TextSize = 12
        box.Parent = frame

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = box

        keyLabels[k] = box
    end
end

_G.Nexus.register("keystroke", {}, "keystroke", "", "Show your pressed keys on screen", function()
    buildKeystroke()
    notify("Keystroke", "Enabled.")
end)

_G.Nexus.register("unkeystroke", {}, "unkeystroke", "", "Hide keystrokes", function()
    if keystrokeGui then keystrokeGui:Destroy() keystrokeGui = nil end
    keyLabels = {}
    notify("Keystroke", "Disabled.")
end)

RunService.RenderStepped:Connect(function()
    if not keystrokeGui then return end
    local map = {
        W = Enum.KeyCode.W,
        A = Enum.KeyCode.A,
        S = Enum.KeyCode.S,
        D = Enum.KeyCode.D,
        Space = Enum.KeyCode.Space,
    }
    for k, code in pairs(map) do
        local box = keyLabels[k]
        if box then
            local down = UserInputService:IsKeyDown(code)
            box.BackgroundColor3 = down and Color3.fromRGB(61, 214, 140) or Color3.fromRGB(24, 24, 29)
            box.TextColor3 = down and Color3.fromRGB(17, 17, 20) or Color3.fromRGB(122, 122, 140)
        end
    end
end)

-- ============================================================
-- NOTEPAD
-- ============================================================
local notepadGui

_G.Nexus.register("notepad", {"npad"}, "notepad", "", "Open a simple notepad UI", function()
    if notepadGui then notepadGui:Destroy() end

    notepadGui = Instance.new("ScreenGui")
    notepadGui.Name = "NexusNotepad"
    notepadGui.ResetOnSpawn = false
    notepadGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = notepadGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 55)
    stroke.Thickness = 1
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0, 34)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Notepad"
    title.TextColor3 = Color3.fromRGB(232, 232, 238)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 24, 0, 24)
    close.Position = UDim2.new(1, -32, 0, 5)
    close.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
    close.BorderSizePixel = 0
    close.Text = "×"
    close.TextColor3 = Color3.fromRGB(232, 232, 238)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 16
    close.Parent = frame

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 5)
    cc.Parent = close

    close.MouseButton1Click:Connect(function()
        notepadGui:Destroy()
        notepadGui = nil
    end)

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -32, 1, -60)
    box.Position = UDim2.new(0, 16, 0, 40)
    box.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
    box.BorderSizePixel = 0
    box.Text = ""
    box.PlaceholderText = "Type your notes here..."
    box.PlaceholderColor3 = Color3.fromRGB(74, 74, 90)
    box.TextColor3 = Color3.fromRGB(232, 232, 238)
    box.Font = Enum.Font.Code
    box.TextSize = 12
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.TextYAlignment = Enum.TextYAlignment.Top
    box.TextWrapped = true
    box.MultiLine = true
    box.ClearTextOnFocus = false
    box.Parent = frame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = box

    local bp = Instance.new("UIPadding")
    bp.PaddingTop = UDim.new(0, 8)
    bp.PaddingLeft = UDim.new(0, 8)
    bp.PaddingRight = UDim.new(0, 8)
    bp.PaddingBottom = UDim.new(0, 8)
    bp.Parent = box

    notify("Notepad", "Opened.")
end)

_G.Nexus.register("unnotepad", {}, "unnotepad", "", "Close the notepad", function()
    if notepadGui then notepadGui:Destroy() notepadGui = nil end
    notify("Notepad", "Closed.")
end)

-- ============================================================
-- AUTOCLICKER
-- ============================================================
local autoClickerActive = false
local AUTO_CLICK_DELAY = 0.1

_G.Nexus.register("autoclicker", {"ac"}, "autoclicker [delay]", "[delay]", "Auto click the mouse on interval", function(target, args)
    local delay = tonumber(args[1]) or tonumber(target) or 0.1
    AUTO_CLICK_DELAY = delay

    if autoClickerActive then
        notify("AutoClicker", "Already enabled.")
        return
    end

    autoClickerActive = true
    task.spawn(function()
        local VirtualUser = game:GetService("VirtualUser")
        while autoClickerActive do
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton1(Vector2.new())
            end)
            task.wait(AUTO_CLICK_DELAY)
        end
    end)
    notify("AutoClicker", "Enabled (delay " .. AUTO_CLICK_DELAY .. ")")
end)

_G.Nexus.register("unautoclicker", {"unac"}, "unautoclicker", "", "Stop autoclicker", function()
    autoClickerActive = false
    notify("AutoClicker", "Disabled.")
end)

-- ============================================================
-- MINIMAP (small view of nearby players)
-- ============================================================
local minimapGui
local minimapBlips = {}

_G.Nexus.register("minimap", {}, "minimap", "", "Open a basic minimap of nearby players", function()
    if minimapGui then minimapGui:Destroy() end

    minimapGui = Instance.new("ScreenGui")
    minimapGui.Name = "NexusMinimap"
    minimapGui.ResetOnSpawn = false
    minimapGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 200)
    frame.Position = UDim2.new(0, 20, 0, 200)
    frame.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
    frame.BorderSizePixel = 0
    frame.Parent = minimapGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 55)
    stroke.Thickness = 1
    stroke.Parent = frame

    local center = Instance.new("Frame")
    center.Size = UDim2.new(0, 6, 0, 6)
    center.Position = UDim2.new(0.5, -3, 0.5, -3)
    center.BackgroundColor3 = Color3.fromRGB(61, 214, 140)
    center.BorderSizePixel = 0
    center.Parent = frame

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(1, 0)
    cc.Parent = center

    local range = 100 -- studs from center to edge

    RunService.Heartbeat:Connect(function()
        if not minimapGui or not minimapGui.Parent then return end
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        for plr, blip in pairs(minimapBlips) do
            if not plr.Parent or not plr.Character then
                blip:Destroy()
                minimapBlips[plr] = nil
            end
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not minimapBlips[plr] then
                        local blip = Instance.new("Frame")
                        blip.Size = UDim2.new(0, 8, 0, 8)
                        blip.BackgroundColor3 = Color3.fromRGB(240, 79, 88)
                        blip.BorderSizePixel = 0
                        blip.Parent = frame

                        local bc = Instance.new("UICorner")
                        bc.CornerRadius = UDim.new(1, 0)
                        bc.Parent = blip

                        minimapBlips[plr] = blip
                    end

                    local rel = hrp.Position - myHRP.Position
                    local x = math.clamp(rel.X / range, -1, 1)
                    local z = math.clamp(rel.Z / range, -1, 1)
                    local px = (x + 1) / 2
                    local pz = (z + 1) / 2
                    minimapBlips[plr].Position = UDim2.new(px, -4, pz, -4)
                end
            end
        end
    end)
    notify("Minimap", "Enabled.")
end)

_G.Nexus.register("unminimap", {}, "unminimap", "", "Close the minimap", function()
    if minimapGui then minimapGui:Destroy() minimapGui = nil end
    for plr, b in pairs(minimapBlips) do b:Destroy() end
    minimapBlips = {}
    notify("Minimap", "Closed.")
end)

-- ============================================================
-- ANIMATION PLAYER (plays a list of game animations)
-- ============================================================
_G.Nexus.register("animationplayer", {"animplayer"}, "animationplayer", "", "Print all animations found in the game", function()
    local anims = {}
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("Animation") then
            table.insert(anims, obj.AnimationId)
        end
    end
    notify("AnimationPlayer", "Found " .. #anims .. " animations.")
    for _, id in ipairs(anims) do print("[Nexus AnimPlayer] " .. id) end
end)

print("[Nexus] Batch 12 loaded. Misc II ready.")
-- ============================================================
-- NEXUS - BATCH 13: SERVER II
-- joinjobid, joinserver, joingame, copytptogame,
-- copytptoserver, reserve, teleportgui
-- ============================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

-- ============================================================
-- JOINJOBID (join a specific job id in the current place)
-- ============================================================
_G.Nexus.register("joinjobid", {"jjid"}, "joinjobid <jobid>", "<jobid>", "Join a specific server by JobId", function(target)
    if not target then notify("JoinJobId", "Provide a JobId.") return end
    local ok, err = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, target, LocalPlayer)
    end)
    if ok then
        notify("JoinJobId", "Joining " .. target:sub(1, 8) .. "...")
    else
        notify("JoinJobId", "Failed: " .. tostring(err))
    end
end)

-- ============================================================
-- JOINSERVER (same as joinjobid, just an alias)
-- ============================================================
_G.Nexus.register("joinserver", {"joinjid"}, "joinserver <jobid>", "<jobid>", "Join a server by JobId", function(target)
    if not target then notify("JoinServer", "Provide a JobId.") return end
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, target, LocalPlayer)
    end)
    notify("JoinServer", "Joining...")
end)

-- ============================================================
-- JOINGAME (join a game by PlaceId)
-- ============================================================
_G.Nexus.register("joingame", {"joinplace"}, "joingame <placeId>", "<placeId>", "Join a game by PlaceId", function(target)
    local id = tonumber(target)
    if not id then notify("JoinGame", "Provide a PlaceId.") return end
    local ok, err = pcall(function()
        TeleportService:Teleport(id, LocalPlayer)
    end)
    if ok then
        notify("JoinGame", "Joining place " .. id)
    else
        notify("JoinGame", "Failed: " .. tostring(err))
    end
end)

-- ============================================================
-- COPYTPTOGAME (copy a script that teleports to the current place)
-- ============================================================
_G.Nexus.register("copytptogame", {"cttg"}, "copytptogame", "", "Copy a script that teleports you to this game", function()
    local script = string.format([[loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSERNAME/nexus/main/nexus.lua"))()
game:GetService("TeleportService"):Teleport(%d)]], game.PlaceId)
    pcall(function() if setclipboard then setclipboard(script) end end)
    notify("CopyTpToGame", "Script copied (PlaceId " .. game.PlaceId .. ")")
end)

-- ============================================================
-- COPYTPTOSERVER (copy a script that teleports you to this server)
-- ============================================================
_G.Nexus.register("copytptoserver", {"ctts"}, "copytptoserver", "", "Copy a script that teleports you to this exact server", function()
    local script = string.format([[loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSERNAME/nexus/main/nexus.lua"))()
game:GetService("TeleportService"):TeleportToPlaceInstance(%d, "%s")]], game.PlaceId, game.JobId)
    pcall(function() if setclipboard then setclipboard(script) end end)
    notify("CopyTpToServer", "Script copied.")
end)

-- ============================================================
-- RESERVE (reserve a server and teleport)
-- ============================================================
_G.Nexus.register("reserve", {"reserveserver", "rs"}, "reserve", "", "Reserve a private server and teleport into it", function()
    local ok = pcall(function()
        TeleportService:ReserveServer(game.PlaceId)
    end)
    if ok then
        notify("Reserve", "Server reserved.")
    else
        notify("Reserve", "Failed (needs more context to work properly).")
    end
end)

-- ============================================================
-- TELEPORT GUI (select a place to teleport to)
-- ============================================================
local teleportGui

_G.Nexus.register("teleportgui", {"tpui"}, "teleportgui", "", "Open a UI to teleport to any PlaceId", function()
    if teleportGui then teleportGui:Destroy() end
    local CoreGui = game:GetService("CoreGui")

    teleportGui = Instance.new("ScreenGui")
    teleportGui.Name = "NexusTeleportGui"
    teleportGui.ResetOnSpawn = false
    teleportGui.Parent = CoreGui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 180)
    frame.Position = UDim2.new(0.5, -200, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = teleportGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 55)
    stroke.Thickness = 1
    stroke.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 0, 34)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Teleport to Place"
    title.TextColor3 = Color3.fromRGB(232, 232, 238)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 24, 0, 24)
    close.Position = UDim2.new(1, -32, 0, 5)
    close.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
    close.BorderSizePixel = 0
    close.Text = "×"
    close.TextColor3 = Color3.fromRGB(232, 232, 238)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 16
    close.Parent = frame

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 5)
    cc.Parent = close

    close.MouseButton1Click:Connect(function()
        teleportGui:Destroy()
        teleportGui = nil
    end)

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -32, 0, 40)
    input.Position = UDim2.new(0, 16, 0, 50)
    input.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
    input.BorderSizePixel = 0
    input.Text = ""
    input.PlaceholderText = "PlaceId"
    input.PlaceholderColor3 = Color3.fromRGB(74, 74, 90)
    input.TextColor3 = Color3.fromRGB(232, 232, 238)
    input.Font = Enum.Font.Gotham
    input.TextSize = 13
    input.Parent = frame

    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 8)
    ic.Parent = input

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -32, 0, 40)
    button.Position = UDim2.new(0, 16, 0, 105)
    button.BackgroundColor3 = Color3.fromRGB(61, 214, 140)
    button.BorderSizePixel = 0
    button.Text = "Teleport"
    button.TextColor3 = Color3.fromRGB(17, 17, 20)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 13
    button.Parent = frame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = button

    button.MouseButton1Click:Connect(function()
        local id = tonumber(input.Text)
        if not id then notify("TeleportGui", "Invalid PlaceId.") return end
        pcall(function() TeleportService:Teleport(id, LocalPlayer) end)
        notify("TeleportGui", "Teleporting to " .. id)
    end)

    notify("TeleportGui", "Opened.")
end)

_G.Nexus.register("unteleportgui", {"untpui"}, "unteleportgui", "", "Close the teleport GUI", function()
    if teleportGui then teleportGui:Destroy() teleportGui = nil end
    notify("TeleportGui", "Closed.")
end)

-- ============================================================
-- SERVERLIST (quick browser of active servers)
-- ============================================================
_G.Nexus.register("serverlist", {"slist"}, "serverlist", "", "List active servers for this place in the console", function()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if not ok or not res then
        notify("ServerList", "HTTP request failed.")
        return
    end
    local data = HttpService:JSONDecode(res)
    local list = data.data or {}
    print("[Nexus ServerList] " .. #list .. " servers found:")
    for _, s in ipairs(list) do
        print("  JobId: " .. s.id .. " | Playing: " .. s.playing .. "/" .. s.maxPlayers)
    end
    notify("ServerList", #list .. " servers printed to console.")
end)

print("[Nexus] Batch 13 loaded. Server II ready.")
-- ============================================================
-- NEXUS - BATCH 14: FUN / MISC III
-- hamster, unhamster, cig, cigar, pipe, oofspam, unoofspam,
-- firework, unfirework, seizure, unseizure, confetti
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

local function getChar() return LocalPlayer.Character end
local function getHRP()
    local c = getChar()
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ============================================================
-- HAMSTER (hamster ball around your character)
-- ============================================================
local hamsterBall

_G.Nexus.register("hamster", {"hamsterball"}, "hamster", "", "Roll yourself in a hamster ball", function()
    if hamsterBall then return end
    local hrp = getHRP()
    if not hrp then return end

    hamsterBall = Instance.new("Part")
    hamsterBall.Name = "NexusHamsterBall"
    hamsterBall.Shape = Enum.PartType.Ball
    hamsterBall.Size = Vector3.new(10, 10, 10)
    hamsterBall.Anchored = false
    hamsterBall.CanCollide = false
    hamsterBall.Massless = false
    hamsterBall.Material = Enum.Material.ForceField
    hamsterBall.Color = Color3.fromRGB(61, 214, 140)
    hamsterBall.Transparency = 0.5
    hamsterBall.CFrame = hrp.CFrame
    hamsterBall.Parent = Workspace

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hrp
    weld.Part1 = hamsterBall
    weld.Parent = hamsterBall

    notify("Hamster", "Enabled.")
end)

_G.Nexus.register("unhamster", {"unhamsterball"}, "unhamster", "", "Stop being a hamster", function()
    if hamsterBall then hamsterBall:Destroy() hamsterBall = nil end
    notify("Hamster", "Disabled.")
end)

-- ============================================================
-- CIG (small cig on your head)
-- ============================================================
local cigPart

_G.Nexus.register("cig", {"cigarette"}, "cig", "", "Give yourself a cigarette", function()
    if cigPart then cigPart:Destroy() cigPart = nil end
    local char = getChar()
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    cigPart = Instance.new("Part")
    cigPart.Name = "NexusCig"
    cigPart.Size = Vector3.new(0.2, 0.2, 1.2)
    cigPart.Color = Color3.fromRGB(240, 240, 240)
    cigPart.Material = Enum.Material.SmoothPlastic
    cigPart.CanCollide = false
    cigPart.Massless = true
    cigPart.CFrame = head.CFrame * CFrame.new(0.6, -0.4, -0.6)
    cigPart.Parent = char

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = cigPart
    weld.Parent = cigPart

    local tip = Instance.new("PointLight")
    tip.Brightness = 2
    tip.Range = 5
    tip.Color = Color3.fromRGB(255, 80, 80)
    tip.Parent = cigPart

    notify("Cig", "Enjoy.")
end)

_G.Nexus.register("uncig", {}, "uncig", "", "Remove the cig", function()
    if cigPart then cigPart:Destroy() cigPart = nil end
    notify("Cig", "Removed.")
end)

-- ============================================================
-- CIGAR (bigger version)
-- ============================================================
local cigarPart

_G.Nexus.register("cigar", {}, "cigar", "", "Give yourself a fat cigar", function()
    if cigarPart then cigarPart:Destroy() cigarPart = nil end
    local char = getChar()
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    cigarPart = Instance.new("Part")
    cigarPart.Name = "NexusCigar"
    cigarPart.Size = Vector3.new(0.4, 0.4, 1.6)
    cigarPart.Color = Color3.fromRGB(80, 50, 30)
    cigarPart.Material = Enum.Material.SmoothPlastic
    cigarPart.CanCollide = false
    cigarPart.Massless = true
    cigarPart.CFrame = head.CFrame * CFrame.new(0.6, -0.4, -0.8)
    cigarPart.Parent = char

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = cigarPart
    weld.Parent = cigarPart

    notify("Cigar", "Boss mode.")
end)

_G.Nexus.register("uncigar", {}, "uncigar", "", "Remove the cigar", function()
    if cigarPart then cigarPart:Destroy() cigarPart = nil end
    notify("Cigar", "Removed.")
end)

-- ============================================================
-- PIPE
-- ============================================================
local pipePart

_G.Nexus.register("pipe", {}, "pipe", "", "Give yourself a smoking pipe", function()
    if pipePart then pipePart:Destroy() pipePart = nil end
    local char = getChar()
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    pipePart = Instance.new("Part")
    pipePart.Name = "NexusPipe"
    pipePart.Size = Vector3.new(0.3, 0.3, 1)
    pipePart.Color = Color3.fromRGB(60, 30, 20)
    pipePart.Material = Enum.Material.Wood
    pipePart.CanCollide = false
    pipePart.Massless = true
    pipePart.CFrame = head.CFrame * CFrame.new(0.6, -0.4, -0.8)
    pipePart.Parent = char

    local bowl = Instance.new("Part")
    bowl.Size = Vector3.new(0.5, 0.5, 0.5)
    bowl.Color = Color3.fromRGB(40, 20, 10)
    bowl.Material = Enum.Material.Wood
    bowl.CanCollide = false
    bowl.Massless = true
    bowl.CFrame = pipePart.CFrame * CFrame.new(0, 0.3, -0.5)
    bowl.Parent = char

    local weld1 = Instance.new("WeldConstraint")
    weld1.Part0 = head
    weld1.Part1 = pipePart
    weld1.Parent = pipePart

    local weld2 = Instance.new("WeldConstraint")
    weld2.Part0 = pipePart
    weld2.Part1 = bowl
    weld2.Parent = bowl

    pipePart:SetAttribute("BowlPart", bowl.Name)
    bowl:SetAttribute("ParentPipe", pipePart.Name)

    pipePart.Name = "NexusPipe"

    local cleanup = function()
        if pipePart then pipePart:Destroy() pipePart = nil end
        if bowl and bowl.Parent then bowl:Destroy() end
    end
    _G.Nexus._pipeCleanup = cleanup

    notify("Pipe", "Chill.")
end)

_G.Nexus.register("unpipe", {}, "unpipe", "", "Remove the pipe", function()
    if _G.Nexus._pipeCleanup then _G.Nexus._pipeCleanup() end
    pipePart = nil
    notify("Pipe", "Removed.")
end)

-- ============================================================
-- OOF SPAM
-- ============================================================
local oofSpamActive = false

_G.Nexus.register("oofspam", {}, "oofspam", "", "Spam the oof sound", function()
    if oofSpamActive then return end
    oofSpamActive = true
    task.spawn(function()
        local soundId = "rbxassetid://3439874943"
        while oofSpamActive do
            local char = getChar()
            local hrp = getHRP()
            if hrp then
                local s = Instance.new("Sound")
                s.SoundId = soundId
                s.Volume = 2
                s.Parent = hrp
                s:Play()
                game:GetService("Debris"):AddItem(s, 2)
            end
            task.wait(0.5)
        end
    end)
    notify("OofSpam", "Enabled.")
end)

_G.Nexus.register("unoofspam", {}, "unoofspam", "", "Stop oof spam", function()
    oofSpamActive = false
    notify("OofSpam", "Disabled.")
end)

-- ============================================================
-- FIREWORK (spawn a firework above you)
-- ============================================================
local fireworkParts = {}

local function spawnFirework()
    local hrp = getHRP()
    if not hrp then return end

    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 2, 2)
    part.Position = hrp.Position + Vector3.new(0, 60, 0)
    part.Anchored = true
    part.CanCollide = false
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
    part.Parent = Workspace

    local att = Instance.new("Attachment")
    att.Parent = part

    local emitter = Instance.new("ParticleEmitter")
    emitter.Rate = 500
    emitter.Lifetime = NumberRange.new(1, 2)
    emitter.Speed = NumberRange.new(40, 80)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.Color = ColorSequence.new(part.Color)
    emitter.Parent = att

    task.delay(0.3, function()
        emitter.Enabled = false
        task.delay(2, function() part:Destroy() end)
    end)

    table.insert(fireworkParts, part)
end

_G.Nexus.register("firework", {"fw"}, "firework", "", "Spawn a firework above you", function()
    spawnFirework()
    notify("Firework", "Boom.")
end)

_G.Nexus.register("unfirework", {"unfw"}, "unfirework", "", "Remove all fireworks", function()
    for _, p in ipairs(fireworkParts) do
        if p and p.Parent then p:Destroy() end
    end
    fireworkParts = {}
    notify("Firework", "Cleared.")
end)

-- ============================================================
-- CONFETTI (party mode)
-- ============================================================
local confettiActive = false

_G.Nexus.register("confetti", {"party"}, "confetti", "", "Rain confetti everywhere", function()
    if confettiActive then return end
    confettiActive = true
    task.spawn(function()
        while confettiActive do
            local hrp = getHRP()
            if hrp then
                for i = 1, 5 do
                    local p = Instance.new("Part")
                    p.Size = Vector3.new(0.5, 0.1, 0.5)
                    p.Position = hrp.Position + Vector3.new(math.random(-20, 20), 20, math.random(-20, 20))
                    p.Anchored = false
                    p.CanCollide = false
                    p.Material = Enum.Material.Neon
                    p.Color = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
                    p.Parent = Workspace
                    game:GetService("Debris"):AddItem(p, 4)
                end
            end
            task.wait(0.2)
        end
    end)
    notify("Confetti", "Party time.")
end)

_G.Nexus.register("unconfetti", {"unparty"}, "unconfetti", "", "Stop confetti", function()
    confettiActive = false
    notify("Confetti", "Stopped.")
end)

-- ============================================================
-- SEIZURE (flashing colors)
-- ============================================================
local seizureConn

_G.Nexus.register("seizure", {}, "seizure", "", "Make the lighting flash rapidly", function()
    if seizureConn then return end
    local Lighting = game:GetService("Lighting")
    seizureConn = RunService.Heartbeat:Connect(function()
        Lighting.Ambient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        Lighting.OutdoorAmbient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    end)
    notify("Seizure", "Enabled.")
end)

_G.Nexus.register("unseizure", {}, "unseizure", "", "Stop the seizure", function()
    if seizureConn then seizureConn:Disconnect() seizureConn = nil end
    local Lighting = game:GetService("Lighting")
    Lighting.Ambient = Color3.fromRGB(70, 70, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    notify("Seizure", "Disabled.")
end)

print("[Nexus] Batch 14 loaded. Fun / Misc III ready.")
-- ============================================================
-- NEXUS - BATCH 15: MISC IV (FINAL)
-- shaders, unshaders, improvetextures, undotextures,
-- antiflingparts, unantiflingparts, vehiclenoclip, vehicleclip,
-- vehiclespeed, unvehiclespeed, gravity, ungimmegravity
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
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
-- SHADERS (a nicer preset of Lighting properties)
-- ============================================================
local shaderOriginal

_G.Nexus.register("shaders", {"rtx", "hd"}, "shaders", "", "Apply a shader preset to Lighting", function()
    if not shaderOriginal then
        shaderOriginal = {
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            Brightness = Lighting.Brightness,
            ClockTime = Lighting.ClockTime,
            ColorShift_Top = Lighting.ColorShift_Top,
            ColorShift_Bottom = Lighting.ColorShift_Bottom,
            EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
            EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
            ExposureCompensation = Lighting.ExposureCompensation,
            GlobalShadows = Lighting.GlobalShadows,
            ShadowSoftness = Lighting.ShadowSoftness,
        }
    end
    Lighting.Ambient = Color3.fromRGB(70, 70, 70)
    Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 140)
    Lighting.Brightness = 2.5
    Lighting.ClockTime = 14
    Lighting.ColorShift_Top = Color3.fromRGB(255, 240, 210)
    Lighting.ColorShift_Bottom = Color3.fromRGB(40, 40, 60)
    Lighting.EnvironmentDiffuseScale = 0.5
    Lighting.EnvironmentSpecularScale = 0.7
    Lighting.ExposureCompensation = 0.2
    Lighting.GlobalShadows = true
    Lighting.ShadowSoftness = 0.3
    notify("Shaders", "Enabled.")
end)

_G.Nexus.register("unshaders", {"shadersoff"}, "unshaders", "", "Restore the original Lighting", function()
    if shaderOriginal then
        for k, v in pairs(shaderOriginal) do
            Lighting[k] = v
        end
    end
    notify("Shaders", "Disabled.")
end)

-- ============================================================
-- IMPROVE TEXTURES (bump up material quality)
-- ============================================================
_G.Nexus.register("improvetextures", {"hdtextures"}, "improvetextures", "", "Force higher quality textures on every part", function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
        end
    end
    notify("ImproveTextures", "Applied. (Client-side only.)")
end)

_G.Nexus.register("undotextures", {"restoretextures"}, "undotextures", "", "Restore original textures (rough pass)", function()
    notify("ImproveTextures", "Restore is best done by re-joining. (Roblox does not expose originals after change.)")
end)

-- ============================================================
-- ANTIFLINGPARTS (ignore unanchored parts with crazy velocity)
-- ============================================================
local antiflingPartsConn

_G.Nexus.register("antiflingparts", {"afparts"}, "antiflingparts", "", "Become uncollidable to fast-moving parts", function()
    if antiflingPartsConn then return end
    antiflingPartsConn = RunService.Heartbeat:Connect(function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj.Anchored then
                if Players:GetPlayerFromCharacter(obj.Parent) == nil then
                    local v = obj.AssemblyLinearVelocity.Magnitude
                    if v > 500 then
                        obj.CanCollide = false
                    end
                end
            end
        end
    end)
    notify("AntiFlingParts", "Enabled.")
end)

_G.Nexus.register("unantiflingparts", {"unafparts"}, "unantiflingparts", "", "Restore collision to unanchored parts", function()
    if antiflingPartsConn then antiflingPartsConn:Disconnect() antiflingPartsConn = nil end
    notify("AntiFlingParts", "Disabled.")
end)

-- ============================================================
-- VEHICLE NOCLIP
-- ============================================================
local vehicleNoclipConn

_G.Nexus.register("vehiclenoclip", {"vnoclip"}, "vehiclenoclip", "", "Disable collision on the vehicle you are in", function()
    if vehicleNoclipConn then return end
    vehicleNoclipConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if not seat then return end
        local car = seat:FindFirstAncestorOfClass("Model")
        if not car then return end
        for _, part in ipairs(car:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    notify("VehicleNoclip", "Enabled.")
end)

_G.Nexus.register("vehicleclip", {"vclip", "unvnoclip"}, "vehicleclip", "", "Re-enable vehicle collision", function()
    if vehicleNoclipConn then vehicleNoclipConn:Disconnect() vehicleNoclipConn = nil end
    local char = getChar()
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if seat then
            local car = seat:FindFirstAncestorOfClass("Model")
            if car then
                for _, part in ipairs(car:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
    notify("VehicleNoclip", "Disabled.")
end)

-- ============================================================
-- VEHICLE SPEED
-- ============================================================
local vehicleSpeedConn

_G.Nexus.register("vehiclespeed", {"vspeed"}, "vehiclespeed <number>", "<number>", "Change the torque of the vehicle you are driving", function(target, args)
    local n = tonumber(args[1]) or tonumber(target)
    if not n then notify("VehicleSpeed", "Provide a number.") return end

    if vehicleSpeedConn then vehicleSpeedConn:Disconnect() end

    vehicleSpeedConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local seat = hum and hum.SeatPart
        if not seat then return end
        local car = seat:FindFirstAncestorOfClass("Model")
        if not car then return end
        for _, obj in ipairs(car:GetDescendants()) do
            if obj:IsA("VehicleSeat") then
                obj.Torque = n
                obj.MaxSpeed = n
            end
        end
    end)
    notify("VehicleSpeed", "Set to " .. n)
end)

_G.Nexus.register("unvehiclespeed", {"unvspeed"}, "unvehiclespeed", "", "Stop modifying vehicle speed", function()
    if vehicleSpeedConn then vehicleSpeedConn:Disconnect() vehicleSpeedConn = nil end
    notify("VehicleSpeed", "Reset.")
end)

-- ============================================================
-- GRAVITY
-- ============================================================
local gravityOriginal = Workspace.Gravity

_G.Nexus.register("gravity", {"grav"}, "gravity <number>", "<number>", "Change the gravity in the current game", function(target, args)
    local n = tonumber(args[1]) or tonumber(target)
    if not n then return end
    Workspace.Gravity = n
    notify("Gravity", "Set to " .. n)
end)

_G.Nexus.register("ungravity", {"ungrav"}, "ungravity", "", "Restore the original gravity", function()
    Workspace.Gravity = gravityOriginal
    notify("Gravity", "Restored to " .. gravityOriginal)
end)

-- ============================================================
-- FREEZE UNANCHORED (freeze all unanchored parts)
-- ============================================================
local frozenParts = {}

_G.Nexus.register("freezeunanchored", {"fua"}, "freezeunanchored", "", "Freeze every unanchored part in the workspace", function()
    frozenParts = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj.Anchored then
            if Players:GetPlayerFromCharacter(obj.Parent) == nil then
                obj.Anchored = true
                table.insert(frozenParts, obj)
            end
        end
    end
    notify("FreezeUnanchored", "Froze " .. #frozenParts .. " parts.")
end)

_G.Nexus.register("thawunanchored", {"tua"}, "thawunanchored", "", "Thaw everything freezeunanchored froze", function()
    for _, obj in ipairs(frozenParts) do
        if obj and obj.Parent then obj.Anchored = false end
    end
    frozenParts = {}
    notify("FreezeUnanchored", "Thawed.")
end)

print("[Nexus] Batch 15 loaded. Misc IV ready. ALL BATCHES COMPLETE.")