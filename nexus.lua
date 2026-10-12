-- ============================================================
-- NEXUS - LAYER 1 PART 1: MAIN MENU SHELL
-- Title bar, tabs, content container
-- ============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Colors
local COLORS = {
    BG_MAIN = Color3.fromRGB(10, 10, 12),
    BG_PANEL = Color3.fromRGB(17, 17, 20),
    BG_CARD = Color3.fromRGB(24, 24, 29),
    BG_HOVER = Color3.fromRGB(31, 31, 38),
    BG_ACTIVE = Color3.fromRGB(36, 36, 45),
    BORDER = Color3.fromRGB(45, 45, 55),
    FG = Color3.fromRGB(232, 232, 238),
    FG_MUTED = Color3.fromRGB(122, 122, 140),
    FG_DIM = Color3.fromRGB(74, 74, 90),
    GREEN = Color3.fromRGB(61, 214, 140),
    RED = Color3.fromRGB(240, 79, 88),
}

-- Clean previous UI
if CoreGui:FindFirstChild("NexusUI") then
    CoreGui.NexusUI:Destroy()
end

-- Root ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Enabled = false
ScreenGui.Parent = CoreGui

-- Main window frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 820, 0, 540)
Main.Position = UDim2.new(0.5, -410, 0.5, -270)
Main.BackgroundColor3 = COLORS.BG_PANEL
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COLORS.BORDER
MainStroke.Thickness = 1
MainStroke.Parent = Main

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = Main

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 400, 1, 0)
TitleLabel.Position = UDim2.new(0, 20, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Nexus"
TitleLabel.TextColor3 = COLORS.FG
TitleLabel.Font = Enum.Font.GothamMedium
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -40, 0, 11)
CloseBtn.BackgroundColor3 = COLORS.BG_PANEL
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "×"
CloseBtn.TextColor3 = COLORS.FG_MUTED
CloseBtn.Font = Enum.Font.Gotham
CloseBtn.TextSize = 22
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    CloseBtn.BackgroundColor3 = COLORS.BG_HOVER
    CloseBtn.TextColor3 = COLORS.FG
end)
CloseBtn.MouseLeave:Connect(function()
    CloseBtn.BackgroundColor3 = COLORS.BG_PANEL
    CloseBtn.TextColor3 = COLORS.FG_MUTED
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)

-- Tab bar
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -40, 0, 40)
TabBar.Position = UDim2.new(0, 20, 0, 56)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Main

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 6)
TabLayout.Parent = TabBar

local tabs = {}
local pages = {}
local currentTab = "Players"

local function setTab(name)
    currentTab = name
    for tabName, tabBtn in pairs(tabs) do
        if tabName == name then
            tabBtn.BackgroundColor3 = COLORS.BG_ACTIVE
            tabBtn.TextColor3 = COLORS.FG
        else
            tabBtn.BackgroundColor3 = COLORS.BG_PANEL
            tabBtn.TextColor3 = COLORS.FG_MUTED
        end
    end
    for pageName, pageFrame in pairs(pages) do
        pageFrame.Visible = (pageName == name)
    end
end

local function makeTab(name)
    local Tab = Instance.new("TextButton")
    Tab.Name = name .. "Tab"
    Tab.Size = UDim2.new(0, 250, 1, 0)
    Tab.BackgroundColor3 = COLORS.BG_PANEL
    Tab.BorderSizePixel = 0
    Tab.Text = name
    Tab.TextColor3 = COLORS.FG_MUTED
    Tab.Font = Enum.Font.GothamMedium
    Tab.TextSize = 13
    Tab.AutoButtonColor = false
    Tab.Parent = TabBar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 10)
    TabCorner.Parent = Tab

    Tab.MouseEnter:Connect(function()
        if currentTab ~= name then
            Tab.BackgroundColor3 = COLORS.BG_HOVER
        end
    end)
    Tab.MouseLeave:Connect(function()
        if currentTab ~= name then
            Tab.BackgroundColor3 = COLORS.BG_PANEL
        end
    end)
    Tab.MouseButton1Click:Connect(function()
        setTab(name)
    end)

    tabs[name] = Tab
    return Tab
end

makeTab("Commands")
makeTab("Players")
makeTab("Settings")

-- Divider line under tabs
local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -40, 0, 1)
Divider.Position = UDim2.new(0, 20, 0, 108)
Divider.BackgroundColor3 = COLORS.BORDER
Divider.BorderSizePixel = 0
Divider.Parent = Main

-- Content container
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -40, 1, -130)
Content.Position = UDim2.new(0, 20, 0, 120)
Content.BackgroundTransparency = 1
Content.Parent = Main

-- Expose to global state
_G.Nexus = _G.Nexus or {}
_G.Nexus.ScreenGui = ScreenGui
_G.Nexus.Main = Main
_G.Nexus.Content = Content
_G.Nexus.tabs = tabs
_G.Nexus.pages = pages
_G.Nexus.setTab = setTab
_G.Nexus.COLORS = COLORS
_G.Nexus.openMenu = function()
    ScreenGui.Enabled = true
end
_G.Nexus.closeMenu = function()
    ScreenGui.Enabled = false
end
_G.Nexus.toggleMenu = function()
    ScreenGui.Enabled = not ScreenGui.Enabled
end

print("[Nexus] Layer 1 Part 1 loaded. Menu shell ready.")
-- ============================================================
-- NEXUS - LAYER 1 PART 2: COMMANDS PAGE
-- Search bar, scrolling command list, addCommandEntry API
-- ============================================================

local COLORS = _G.Nexus.COLORS
local Content = _G.Nexus.Content

-- Commands page frame
local CommandsPage = Instance.new("Frame")
CommandsPage.Name = "CommandsPage"
CommandsPage.Size = UDim2.new(1, 0, 1, 0)
CommandsPage.BackgroundTransparency = 1
CommandsPage.Visible = false
CommandsPage.Parent = Content
_G.Nexus.pages["Commands"] = CommandsPage

-- Search bar
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, 0, 0, 40)
SearchFrame.BackgroundColor3 = COLORS.BG_CARD
SearchFrame.BorderSizePixel = 0
SearchFrame.Parent = CommandsPage

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchFrame

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Color = COLORS.BORDER
SearchStroke.Thickness = 1
SearchStroke.Parent = SearchFrame

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 36, 1, 0)
SearchIcon.Position = UDim2.new(0, 4, 0, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "🔍"
SearchIcon.TextColor3 = COLORS.FG_MUTED
SearchIcon.Font = Enum.Font.Gotham
SearchIcon.TextSize = 13
SearchIcon.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -46, 1, 0)
SearchBox.Position = UDim2.new(0, 42, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Search commands..."
SearchBox.PlaceholderColor3 = COLORS.FG_DIM
SearchBox.TextColor3 = COLORS.FG
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 13
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchFrame

-- Scrolling list of commands
local CmdList = Instance.new("ScrollingFrame")
CmdList.Name = "CmdList"
CmdList.Size = UDim2.new(1, 0, 1, -50)
CmdList.Position = UDim2.new(0, 0, 0, 50)
CmdList.BackgroundTransparency = 1
CmdList.BorderSizePixel = 0
CmdList.ScrollBarThickness = 4
CmdList.ScrollBarImageColor3 = COLORS.FG_MUTED
CmdList.CanvasSize = UDim2.new(0, 0, 0, 0)
CmdList.AutomaticCanvasSize = Enum.AutomaticSize.Y
CmdList.Parent = CommandsPage

local CmdLayout = Instance.new("UIListLayout")
CmdLayout.SortOrder = Enum.SortOrder.LayoutOrder
CmdLayout.Padding = UDim.new(0, 6)
CmdLayout.Parent = CmdList

local CmdPadding = Instance.new("UIPadding")
CmdPadding.PaddingRight = UDim.new(0, 6)
CmdPadding.Parent = CmdList

-- Storage for search filtering
local commandEntries = {}

-- addCommandEntry: called by later parts to register a command in the UI
function _G.Nexus.addCommandEntry(name, desc)
    local Entry = Instance.new("TextButton")
    Entry.Name = name .. "Entry"
    Entry.Size = UDim2.new(1, 0, 0, 56)
    Entry.BackgroundColor3 = COLORS.BG_CARD
    Entry.BorderSizePixel = 0
    Entry.Text = ""
    Entry.AutoButtonColor = false
    Entry.LayoutOrder = #commandEntries + 1
    Entry.Parent = CmdList

    local EntryCorner = Instance.new("UICorner")
    EntryCorner.CornerRadius = UDim.new(0, 8)
    EntryCorner.Parent = Entry

    local EntryStroke = Instance.new("UIStroke")
    EntryStroke.Color = COLORS.BORDER
    EntryStroke.Thickness = 1
    EntryStroke.Parent = Entry

    local CmdName = Instance.new("TextLabel")
    CmdName.Size = UDim2.new(1, -50, 0, 22)
    CmdName.Position = UDim2.new(0, 16, 0, 8)
    CmdName.BackgroundTransparency = 1
    CmdName.Text = name
    CmdName.TextColor3 = COLORS.FG
    CmdName.Font = Enum.Font.GothamMedium
    CmdName.TextSize = 13
    CmdName.TextXAlignment = Enum.TextXAlignment.Left
    CmdName.Parent = Entry

    local CmdDesc = Instance.new("TextLabel")
    CmdDesc.Size = UDim2.new(1, -50, 0, 16)
    CmdDesc.Position = UDim2.new(0, 16, 0, 30)
    CmdDesc.BackgroundTransparency = 1
    CmdDesc.Text = desc or ""
    CmdDesc.TextColor3 = COLORS.FG_MUTED
    CmdDesc.Font = Enum.Font.Gotham
    CmdDesc.TextSize = 11
    CmdDesc.TextXAlignment = Enum.TextXAlignment.Left
    CmdDesc.Parent = Entry

    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 20, 1, 0)
    Arrow.Position = UDim2.new(1, -30, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "›"
    Arrow.TextColor3 = COLORS.FG_DIM
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextSize = 16
    Arrow.Parent = Entry

    Entry.MouseEnter:Connect(function()
        Entry.BackgroundColor3 = COLORS.BG_HOVER
    end)
    Entry.MouseLeave:Connect(function()
        Entry.BackgroundColor3 = COLORS.BG_CARD
    end)
    Entry.MouseButton1Click:Connect(function()
        if _G.Nexus.CmdBar and _G.Nexus.CmdBar.insert then
            _G.Nexus.CmdBar.insert(name .. " ")
        end
    end)

    table.insert(commandEntries, {
        frame = Entry,
        name = name:lower(),
        desc = (desc or ""):lower(),
    })
end

-- Search filtering
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchBox.Text:lower()
    for _, data in ipairs(commandEntries) do
        if q == "" or data.name:find(q, 1, true) or data.desc:find(q, 1, true) then
            data.frame.Visible = true
        else
            data.frame.Visible = false
        end
    end
end)

print("[Nexus] Layer 1 Part 2 loaded. Commands page ready.")
-- ============================================================
-- NEXUS - LAYER 1 PART 3 (FIXED): PLAYERS PAGE
-- Full-width player list with View buttons
-- Profile panel opens as an overlay when View is clicked
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local COLORS = _G.Nexus.COLORS
local Content = _G.Nexus.Content

-- Players page
local PlayersPage = Instance.new("Frame")
PlayersPage.Name = "PlayersPage"
PlayersPage.Size = UDim2.new(1, 0, 1, 0)
PlayersPage.BackgroundTransparency = 1
PlayersPage.Visible = false
PlayersPage.Parent = Content
_G.Nexus.pages["Players"] = PlayersPage

-- Search box at the top
local SideSearch = Instance.new("Frame")
SideSearch.Size = UDim2.new(1, 0, 0, 40)
SideSearch.BackgroundColor3 = COLORS.BG_CARD
SideSearch.BorderSizePixel = 0
SideSearch.Parent = PlayersPage

local SideSearchCorner = Instance.new("UICorner")
SideSearchCorner.CornerRadius = UDim.new(0, 8)
SideSearchCorner.Parent = SideSearch

local SideSearchStroke = Instance.new("UIStroke")
SideSearchStroke.Color = COLORS.BORDER
SideSearchStroke.Thickness = 1
SideSearchStroke.Parent = SideSearch

local SideSearchIcon = Instance.new("TextLabel")
SideSearchIcon.Size = UDim2.new(0, 36, 1, 0)
SideSearchIcon.Position = UDim2.new(0, 4, 0, 0)
SideSearchIcon.BackgroundTransparency = 1
SideSearchIcon.Text = "🔍"
SideSearchIcon.TextColor3 = COLORS.FG_MUTED
SideSearchIcon.Font = Enum.Font.Gotham
SideSearchIcon.TextSize = 13
SideSearchIcon.Parent = SideSearch

local SideSearchBox = Instance.new("TextBox")
SideSearchBox.Size = UDim2.new(1, -44, 1, 0)
SideSearchBox.Position = UDim2.new(0, 42, 0, 0)
SideSearchBox.BackgroundTransparency = 1
SideSearchBox.Text = ""
SideSearchBox.PlaceholderText = "Search players..."
SideSearchBox.PlaceholderColor3 = COLORS.FG_DIM
SideSearchBox.TextColor3 = COLORS.FG
SideSearchBox.Font = Enum.Font.Gotham
SideSearchBox.TextSize = 13
SideSearchBox.TextXAlignment = Enum.TextXAlignment.Left
SideSearchBox.ClearTextOnFocus = false
SideSearchBox.Parent = SideSearch

-- Full-width player list
local PlayerList = Instance.new("ScrollingFrame")
PlayerList.Name = "PlayerList"
PlayerList.Size = UDim2.new(1, 0, 1, -50)
PlayerList.Position = UDim2.new(0, 0, 0, 50)
PlayerList.BackgroundTransparency = 1
PlayerList.BorderSizePixel = 0
PlayerList.ScrollBarThickness = 4
PlayerList.ScrollBarImageColor3 = COLORS.FG_MUTED
PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
PlayerList.Parent = PlayersPage

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 6)
PlayerListLayout.Parent = PlayerList

local PlayerListPadding = Instance.new("UIPadding")
PlayerListPadding.PaddingRight = UDim.new(0, 6)
PlayerListPadding.Parent = PlayerList

-- Overlay profile panel (hidden until View is clicked)
local ProfileOverlay = Instance.new("Frame")
ProfileOverlay.Name = "ProfileOverlay"
ProfileOverlay.Size = UDim2.new(1, 0, 1, 0)
ProfileOverlay.BackgroundColor3 = COLORS.BG_PANEL
ProfileOverlay.BorderSizePixel = 0
ProfileOverlay.Visible = false
ProfileOverlay.ZIndex = 10
ProfileOverlay.Parent = PlayersPage

local ProfileOverlayCorner = Instance.new("UICorner")
ProfileOverlayCorner.CornerRadius = UDim.new(0, 10)
ProfileOverlayCorner.Parent = ProfileOverlay

local ProfileOverlayStroke = Instance.new("UIStroke")
ProfileOverlayStroke.Color = COLORS.BORDER
ProfileOverlayStroke.Thickness = 1
ProfileOverlayStroke.Parent = ProfileOverlay

-- Profile overlay header with Back button
local ProfileHeader = Instance.new("Frame")
ProfileHeader.Size = UDim2.new(1, 0, 0, 46)
ProfileHeader.BackgroundTransparency = 1
ProfileHeader.Parent = ProfileOverlay

local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 80, 0, 30)
BackBtn.Position = UDim2.new(0, 12, 0, 8)
BackBtn.BackgroundColor3 = COLORS.BG_CARD
BackBtn.BorderSizePixel = 0
BackBtn.Text = "‹  Back"
BackBtn.TextColor3 = COLORS.FG
BackBtn.Font = Enum.Font.GothamMedium
BackBtn.TextSize = 12
BackBtn.AutoButtonColor = false
BackBtn.Parent = ProfileHeader

local BackCorner = Instance.new("UICorner")
BackCorner.CornerRadius = UDim.new(0, 6)
BackCorner.Parent = BackBtn

local BackStroke = Instance.new("UIStroke")
BackStroke.Color = COLORS.BORDER
BackStroke.Thickness = 1
BackStroke.Parent = BackBtn

BackBtn.MouseEnter:Connect(function()
    BackBtn.BackgroundColor3 = COLORS.BG_HOVER
end)
BackBtn.MouseLeave:Connect(function()
    BackBtn.BackgroundColor3 = COLORS.BG_CARD
end)

local ProfileTitle = Instance.new("TextLabel")
ProfileTitle.Size = UDim2.new(1, -110, 1, 0)
ProfileTitle.Position = UDim2.new(0, 100, 0, 0)
ProfileTitle.BackgroundTransparency = 1
ProfileTitle.Text = "Player Details"
ProfileTitle.TextColor3 = COLORS.FG
ProfileTitle.Font = Enum.Font.GothamMedium
ProfileTitle.TextSize = 13
ProfileTitle.TextXAlignment = Enum.TextXAlignment.Left
ProfileTitle.Parent = ProfileHeader

-- Profile body (scrollable)
local ProfileBody = Instance.new("ScrollingFrame")
ProfileBody.Name = "ProfileBody"
ProfileBody.Size = UDim2.new(1, -16, 1, -58)
ProfileBody.Position = UDim2.new(0, 8, 0, 50)
ProfileBody.BackgroundTransparency = 1
ProfileBody.BorderSizePixel = 0
ProfileBody.ScrollBarThickness = 4
ProfileBody.ScrollBarImageColor3 = COLORS.FG_MUTED
ProfileBody.CanvasSize = UDim2.new(0, 0, 0, 0)
ProfileBody.AutomaticCanvasSize = Enum.AutomaticSize.Y
ProfileBody.Parent = ProfileOverlay

local ProfileLayout = Instance.new("UIListLayout")
ProfileLayout.SortOrder = Enum.SortOrder.LayoutOrder
ProfileLayout.Padding = UDim.new(0, 12)
ProfileLayout.Parent = ProfileBody

local ProfilePadding = Instance.new("UIPadding")
ProfilePadding.PaddingRight = UDim.new(0, 8)
ProfilePadding.PaddingTop = UDim.new(0, 4)
ProfilePadding.PaddingBottom = UDim.new(0, 8)
ProfilePadding.Parent = ProfileBody

-- Close the overlay
BackBtn.MouseButton1Click:Connect(function()
    ProfileOverlay.Visible = false
end)

-- Player list storage
local playerItems = {}

-- Add player row
local function addPlayerItem(player)
    local Item = Instance.new("Frame")
    Item.Name = player.Name .. "Item"
    Item.Size = UDim2.new(1, 0, 0, 64)
    Item.BackgroundColor3 = COLORS.BG_CARD
    Item.BorderSizePixel = 0
    Item.Parent = PlayerList

    local ItemCorner = Instance.new("UICorner")
    ItemCorner.CornerRadius = UDim.new(0, 8)
    ItemCorner.Parent = Item

    local ItemStroke = Instance.new("UIStroke")
    ItemStroke.Color = COLORS.BORDER
    ItemStroke.Thickness = 1
    ItemStroke.Parent = Item

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 44, 0, 44)
    Avatar.Position = UDim2.new(0, 10, 0, 10)
    Avatar.BackgroundColor3 = COLORS.BG_PANEL
    Avatar.BorderSizePixel = 0
    Avatar.Image = ""
    Avatar.Parent = Item

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = Avatar

    pcall(function()
        Avatar.Image = Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size100x100
        )
    end)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 11, 0, 11)
    Dot.Position = UDim2.new(0, 44, 0, 44)
    Dot.BackgroundColor3 = COLORS.GREEN
    Dot.BorderSizePixel = 0
    Dot.Parent = Item

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local DotStroke = Instance.new("UIStroke")
    DotStroke.Color = COLORS.BG_CARD
    DotStroke.Thickness = 2
    DotStroke.Parent = Dot

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -200, 0, 20)
    NameLabel.Position = UDim2.new(0, 66, 0, 14)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = player.DisplayName
    NameLabel.TextColor3 = COLORS.FG
    NameLabel.Font = Enum.Font.GothamMedium
    NameLabel.TextSize = 14
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = Item

    local HandleLabel = Instance.new("TextLabel")
    HandleLabel.Size = UDim2.new(1, -200, 0, 16)
    HandleLabel.Position = UDim2.new(0, 66, 0, 36)
    HandleLabel.BackgroundTransparency = 1
    HandleLabel.Text = "@" .. player.Name .. " · " .. player.UserId
    HandleLabel.TextColor3 = COLORS.FG_MUTED
    HandleLabel.Font = Enum.Font.Gotham
    HandleLabel.TextSize = 11
    HandleLabel.TextXAlignment = Enum.TextXAlignment.Left
    HandleLabel.Parent = Item

    local ViewBtn = Instance.new("TextButton")
    ViewBtn.Size = UDim2.new(0, 78, 0, 32)
    ViewBtn.Position = UDim2.new(1, -152, 0, 16)
    ViewBtn.BackgroundColor3 = COLORS.BG_HOVER
    ViewBtn.BorderSizePixel = 0
    ViewBtn.Text = "View"
    ViewBtn.TextColor3 = COLORS.FG
    ViewBtn.Font = Enum.Font.GothamMedium
    ViewBtn.TextSize = 12
    ViewBtn.AutoButtonColor = false
    ViewBtn.Parent = Item

    local ViewCorner = Instance.new("UICorner")
    ViewCorner.CornerRadius = UDim.new(0, 6)
    ViewCorner.Parent = ViewBtn

    local ViewStroke = Instance.new("UIStroke")
    ViewStroke.Color = COLORS.BORDER
    ViewStroke.Thickness = 1
    ViewStroke.Parent = ViewBtn

    ViewBtn.MouseEnter:Connect(function()
        ViewBtn.BackgroundColor3 = COLORS.BG_ACTIVE
    end)
    ViewBtn.MouseLeave:Connect(function()
        ViewBtn.BackgroundColor3 = COLORS.BG_HOVER
    end)

    local Arrow = Instance.new("TextLabel")
    Arrow.Size = UDim2.new(0, 24, 1, 0)
    Arrow.Position = UDim2.new(1, -30, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "›"
    Arrow.TextColor3 = COLORS.FG_DIM
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextSize = 18
    Arrow.Parent = Item

    ViewBtn.MouseButton1Click:Connect(function()
        if _G.Nexus.renderProfile then
            _G.Nexus.renderProfile(player)
        end
        ProfileOverlay.Visible = true
    end)

    playerItems[player] = Item
end

local function removePlayerItem(player)
    if playerItems[player] then
        playerItems[player]:Destroy()
        playerItems[player] = nil
    end
end

for _, plr in ipairs(Players:GetPlayers()) do
    addPlayerItem(plr)
end

Players.PlayerAdded:Connect(addPlayerItem)
Players.PlayerRemoving:Connect(removePlayerItem)

SideSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SideSearchBox.Text:lower()
    for plr, item in pairs(playerItems) do
        if q == "" or plr.Name:lower():find(q, 1, true) or plr.DisplayName:lower():find(q, 1, true) then
            item.Visible = true
        else
            item.Visible = false
        end
    end
end)

-- Placeholder render (Part 3b replaces this)
_G.Nexus.renderProfile = function(player)
    for _, child in ipairs(ProfileBody:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    if not player then return end

    local Placeholder = Instance.new("TextLabel")
    Placeholder.Size = UDim2.new(1, 0, 0, 60)
    Placeholder.BackgroundTransparency = 1
    Placeholder.Text = "Loading profile for " .. player.Name .. "..."
    Placeholder.TextColor3 = COLORS.FG_MUTED
    Placeholder.Font = Enum.Font.Gotham
    Placeholder.TextSize = 13
    Placeholder.Parent = ProfileBody
end

print("[Nexus] Layer 1 Part 3 (fixed) loaded. Players page ready.")
-- ============================================================
-- NEXUS - LAYER 1 PART 3b (REBUILT): FULL PROFILE UI
-- Correct actions: Admin, Fling, View, Goto, Avatar,
-- Roblox Profile, Join Date, Friends, Followers, Groups
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local COLORS = _G.Nexus.COLORS
local PlayersPage = _G.Nexus.pages["Players"]

local ProfileOverlay = PlayersPage:FindFirstChild("ProfileOverlay")
local ProfileBody = ProfileOverlay and ProfileOverlay:FindFirstChild("ProfileBody")

if not ProfileBody then
    warn("[Nexus] Part 3b: ProfileBody not found. Load Part 3 first.")
    return
end

for _, child in ipairs(ProfileBody:GetChildren()) do
    if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
        child:Destroy()
    end
end

-- Admin list (player userId -> true)
_G.Nexus.Admins = _G.Nexus.Admins or {}

local function isAdmin(player)
    return _G.Nexus.Admins[player.UserId] == true
end

local function setAdmin(player, state)
    _G.Nexus.Admins[player.UserId] = state and true or nil
end

local function notify(title, text)
    if _G.Nexus.notify then
        _G.Nexus.notify(title, text)
    else
        print(("[Nexus] %s: %s"):format(title, text))
    end
end

local function clearProfile()
    for _, child in ipairs(ProfileBody:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

local function makeCard(order, height)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, height)
    Card.BackgroundColor3 = COLORS.BG_CARD
    Card.BorderSizePixel = 0
    Card.LayoutOrder = order
    Card.Parent = ProfileBody

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 10)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = COLORS.BORDER
    CardStroke.Thickness = 1
    CardStroke.Parent = Card

    return Card
end

_G.Nexus.renderProfile = function(player)
    clearProfile()

    if not player then
        local Empty = Instance.new("TextLabel")
        Empty.Size = UDim2.new(1, 0, 0, 40)
        Empty.BackgroundTransparency = 1
        Empty.Text = "No player selected."
        Empty.TextColor3 = COLORS.FG_MUTED
        Empty.Font = Enum.Font.Gotham
        Empty.TextSize = 13
        Empty.Parent = ProfileBody
        return
    end

    -- HERO
    local Hero = makeCard(1, 100)

    local Avatar = Instance.new("ImageLabel")
    Avatar.Size = UDim2.new(0, 68, 0, 68)
    Avatar.Position = UDim2.new(0, 16, 0, 16)
    Avatar.BackgroundColor3 = COLORS.BG_PANEL
    Avatar.BorderSizePixel = 0
    Avatar.Image = ""
    Avatar.Parent = Hero

    local AvatarCorner = Instance.new("UICorner")
    AvatarCorner.CornerRadius = UDim.new(1, 0)
    AvatarCorner.Parent = Avatar

    pcall(function()
        Avatar.Image = Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
    end)

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -260, 0, 24)
    NameLabel.Position = UDim2.new(0, 96, 0, 18)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = player.DisplayName
    NameLabel.TextColor3 = COLORS.FG
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.TextSize = 18
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Parent = Hero

    local HandleLabel = Instance.new("TextLabel")
    HandleLabel.Size = UDim2.new(1, -260, 0, 16)
    HandleLabel.Position = UDim2.new(0, 96, 0, 44)
    HandleLabel.BackgroundTransparency = 1
    HandleLabel.Text = "@" .. player.Name .. " · " .. tostring(player.UserId)
    HandleLabel.TextColor3 = COLORS.FG_MUTED
    HandleLabel.Font = Enum.Font.Gotham
    HandleLabel.TextSize = 12
    HandleLabel.TextXAlignment = Enum.TextXAlignment.Left
    HandleLabel.Parent = Hero

    local OnlineDot = Instance.new("Frame")
    OnlineDot.Size = UDim2.new(0, 8, 0, 8)
    OnlineDot.Position = UDim2.new(0, 96, 0, 70)
    OnlineDot.BackgroundColor3 = COLORS.GREEN
    OnlineDot.BorderSizePixel = 0
    OnlineDot.Parent = Hero

    local OnlineDotCorner = Instance.new("UICorner")
    OnlineDotCorner.CornerRadius = UDim.new(1, 0)
    OnlineDotCorner.Parent = OnlineDot

    local OnlineLabel = Instance.new("TextLabel")
    OnlineLabel.Size = UDim2.new(0, 100, 0, 14)
    OnlineLabel.Position = UDim2.new(0, 110, 0, 67)
    OnlineLabel.BackgroundTransparency = 1
    OnlineLabel.Text = "Online"
    OnlineLabel.TextColor3 = COLORS.GREEN
    OnlineLabel.Font = Enum.Font.GothamMedium
    OnlineLabel.TextSize = 11
    OnlineLabel.TextXAlignment = Enum.TextXAlignment.Left
    OnlineLabel.Parent = Hero

    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0, 120, 0, 32)
    CopyBtn.Position = UDim2.new(1, -136, 0, 20)
    CopyBtn.BackgroundColor3 = COLORS.BG_PANEL
    CopyBtn.BorderSizePixel = 0
    CopyBtn.Text = "📋  Copy User ID"
    CopyBtn.TextColor3 = COLORS.FG
    CopyBtn.Font = Enum.Font.GothamMedium
    CopyBtn.TextSize = 11
    CopyBtn.AutoButtonColor = false
    CopyBtn.Parent = Hero

    local CopyCorner = Instance.new("UICorner")
    CopyCorner.CornerRadius = UDim.new(0, 6)
    CopyCorner.Parent = CopyBtn

    local CopyStroke = Instance.new("UIStroke")
    CopyStroke.Color = COLORS.BORDER
    CopyStroke.Thickness = 1
    CopyStroke.Parent = CopyBtn

    CopyBtn.MouseEnter:Connect(function() CopyBtn.BackgroundColor3 = COLORS.BG_HOVER end)
    CopyBtn.MouseLeave:Connect(function() CopyBtn.BackgroundColor3 = COLORS.BG_PANEL end)
    CopyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then setclipboard(tostring(player.UserId)) end
        end)
        notify("Copied", "User ID " .. tostring(player.UserId))
    end)

    -- STAT ROW
    local StatsRow = Instance.new("Frame")
    StatsRow.Size = UDim2.new(1, 0, 0, 72)
    StatsRow.BackgroundTransparency = 1
    StatsRow.LayoutOrder = 2
    StatsRow.Parent = ProfileBody

    local StatsLayout = Instance.new("UIListLayout")
    StatsLayout.FillDirection = Enum.FillDirection.Horizontal
    StatsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    StatsLayout.Padding = UDim.new(0, 8)
    StatsLayout.Parent = StatsRow

    local function statCard(title, value, order)
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(0.25, -6, 1, 0)
        Card.BackgroundColor3 = COLORS.BG_CARD
        Card.BorderSizePixel = 0
        Card.LayoutOrder = order
        Card.Parent = StatsRow

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 8)
        CardCorner.Parent = Card

        local CardStroke = Instance.new("UIStroke")
        CardStroke.Color = COLORS.BORDER
        CardStroke.Thickness = 1
        CardStroke.Parent = Card

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -16, 0, 14)
        Title.Position = UDim2.new(0, 12, 0, 10)
        Title.BackgroundTransparency = 1
        Title.Text = title
        Title.TextColor3 = COLORS.FG_MUTED
        Title.Font = Enum.Font.Gotham
        Title.TextSize = 10
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Card

        local Value = Instance.new("TextLabel")
        Value.Size = UDim2.new(1, -16, 0, 22)
        Value.Position = UDim2.new(0, 12, 0, 32)
        Value.BackgroundTransparency = 1
        Value.Text = value
        Value.TextColor3 = COLORS.FG
        Value.Font = Enum.Font.GothamMedium
        Value.TextSize = 12
        Value.TextXAlignment = Enum.TextXAlignment.Left
        Value.Parent = Card

        return Card
    end

    statCard("Join Date",     "See info ↓", 1)
    statCard("Last Seen",     "Now",        2)
    statCard("Total Playtime","N/A",        3)
    statCard("Rank",          "Member",     4)

    -- LOWER ROW
    local LowerRow = Instance.new("Frame")
    LowerRow.Size = UDim2.new(1, 0, 0, 420)
    LowerRow.BackgroundTransparency = 1
    LowerRow.LayoutOrder = 3
    LowerRow.Parent = ProfileBody

    -- ACTIONS CARD
    local ActionsCard = Instance.new("Frame")
    ActionsCard.Size = UDim2.new(0.5, -6, 1, 0)
    ActionsCard.BackgroundColor3 = COLORS.BG_CARD
    ActionsCard.BorderSizePixel = 0
    ActionsCard.Parent = LowerRow

    local ActionsCorner = Instance.new("UICorner")
    ActionsCorner.CornerRadius = UDim.new(0, 10)
    ActionsCorner.Parent = ActionsCard

    local ActionsStroke = Instance.new("UIStroke")
    ActionsStroke.Color = COLORS.BORDER
    ActionsStroke.Thickness = 1
    ActionsStroke.Parent = ActionsCard

    local ActionsTitle = Instance.new("TextLabel")
    ActionsTitle.Size = UDim2.new(1, -24, 0, 24)
    ActionsTitle.Position = UDim2.new(0, 16, 0, 12)
    ActionsTitle.BackgroundTransparency = 1
    ActionsTitle.Text = "Player Actions"
    ActionsTitle.TextColor3 = COLORS.FG
    ActionsTitle.Font = Enum.Font.GothamMedium
    ActionsTitle.TextSize = 13
    ActionsTitle.TextXAlignment = Enum.TextXAlignment.Left
    ActionsTitle.Parent = ActionsCard

    local ActionsList = Instance.new("ScrollingFrame")
    ActionsList.Size = UDim2.new(1, -16, 1, -56)
    ActionsList.Position = UDim2.new(0, 8, 0, 46)
    ActionsList.BackgroundTransparency = 1
    ActionsList.BorderSizePixel = 0
    ActionsList.ScrollBarThickness = 3
    ActionsList.ScrollBarImageColor3 = COLORS.FG_MUTED
    ActionsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    ActionsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ActionsList.Parent = ActionsCard

    local ActionsLayout = Instance.new("UIListLayout")
    ActionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ActionsLayout.Padding = UDim.new(0, 4)
    ActionsLayout.Parent = ActionsList

    local function actionBtn(order, icon, label, color, onClick)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 34)
        Btn.BackgroundColor3 = COLORS.BG_PANEL
        Btn.BorderSizePixel = 0
        Btn.Text = ""
        Btn.AutoButtonColor = false
        Btn.LayoutOrder = order
        Btn.Parent = ActionsList

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 6)
        BtnCorner.Parent = Btn

        local IconLabel = Instance.new("TextLabel")
        IconLabel.Size = UDim2.new(0, 30, 1, 0)
        IconLabel.Position = UDim2.new(0, 8, 0, 0)
        IconLabel.BackgroundTransparency = 1
        IconLabel.Text = icon
        IconLabel.TextColor3 = color or COLORS.FG
        IconLabel.Font = Enum.Font.Gotham
        IconLabel.TextSize = 13
        IconLabel.Parent = Btn

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -60, 1, 0)
        Label.Position = UDim2.new(0, 40, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = label
        Label.TextColor3 = COLORS.FG
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Btn

        local Arrow = Instance.new("TextLabel")
        Arrow.Size = UDim2.new(0, 20, 1, 0)
        Arrow.Position = UDim2.new(1, -26, 0, 0)
        Arrow.BackgroundTransparency = 1
        Arrow.Text = "›"
        Arrow.TextColor3 = COLORS.FG_DIM
        Arrow.Font = Enum.Font.GothamBold
        Arrow.TextSize = 14
        Arrow.Parent = Btn

        Btn.MouseEnter:Connect(function() Btn.BackgroundColor3 = COLORS.BG_HOVER end)
        Btn.MouseLeave:Connect(function() Btn.BackgroundColor3 = COLORS.BG_PANEL end)
        Btn.MouseButton1Click:Connect(onClick)

        return Btn
    end

    -- Admin
    local AdminBtn = actionBtn(1, "👑", "Admin", COLORS.YELLOW or Color3.fromRGB(240, 200, 90), function()
        local newState = not isAdmin(player)
        setAdmin(player, newState)
        if newState then
            notify("Admin Granted", player.Name .. " is now an admin.")
        else
            notify("Admin Removed", player.Name .. " is no longer an admin.")
        end
    end)

    local AdminStatus = Instance.new("TextLabel")
    AdminStatus.Name = "AdminStatus"
    AdminStatus.Size = UDim2.new(0, 50, 1, 0)
    AdminStatus.Position = UDim2.new(1, -80, 0, 0)
    AdminStatus.BackgroundTransparency = 1
    AdminStatus.Text = isAdmin(player) and "ON" or "OFF"
    AdminStatus.TextColor3 = isAdmin(player) and COLORS.GREEN or COLORS.FG_MUTED
    AdminStatus.Font = Enum.Font.GothamBold
    AdminStatus.TextSize = 10
    AdminStatus.Parent = AdminBtn

    AdminBtn.MouseButton1Click:Connect(function()
        task.wait(0.05)
        AdminStatus.Text = isAdmin(player) and "ON" or "OFF"
        AdminStatus.TextColor3 = isAdmin(player) and COLORS.GREEN or COLORS.FG_MUTED
    end)

    -- Fling
    actionBtn(2, "🌀", "Fling", COLORS.RED, function()
        if _G.Nexus.Fling then
            _G.Nexus.Fling(player)
        else
            notify("Fling", "Not loaded yet (Layer 2 will hook this).")
        end
    end)

    -- View
    actionBtn(3, "👁", "View", COLORS.FG, function()
        if _G.Nexus.View then
            _G.Nexus.View(player)
        else
            notify("View", "Watching " .. player.Name)
        end
    end)

    -- Goto
    actionBtn(4, "📍", "Goto", COLORS.FG, function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local target = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp and target then
            hrp.CFrame = target.CFrame + Vector3.new(0, 2, 0)
            notify("Goto", "Teleported to " .. player.Name)
        else
            notify("Goto", "Target or you has no character.")
        end
    end)

    -- Avatar
    actionBtn(5, "🧍", "Avatar", COLORS.FG, function()
        pcall(function()
            if setclipboard then
                setclipboard("https://www.roblox.com/users/" .. player.UserId .. "/profile")
            end
        end)
        notify("Avatar", "Avatar link for " .. player.Name .. " copied.")
    end)

    -- Roblox Profile
    actionBtn(6, "🌐", "Roblox Profile", COLORS.FG, function()
        pcall(function()
            if setclipboard then
                setclipboard("https://www.roblox.com/users/" .. player.UserId .. "/profile")
            end
        end)
        notify("Roblox Profile", "Profile link copied for " .. player.Name)
    end)

    -- Join Date
    actionBtn(7, "📅", "Join Date", COLORS.FG, function()
        notify("Join Date", player.Name .. "'s join date is not available client-side.")
    end)

    -- Friends
    actionBtn(8, "👥", "Friends", COLORS.FG, function()
        pcall(function()
            if setclipboard then
                setclipboard("https://www.roblox.com/users/" .. player.UserId .. "/friends")
            end
        end)
        notify("Friends", "Friends link copied for " .. player.Name)
    end)

    -- Followers
    actionBtn(9, "📣", "Followers", COLORS.FG, function()
        pcall(function()
            if setclipboard then
                setclipboard("https://www.roblox.com/users/" .. player.UserId .. "/followers")
            end
        end)
        notify("Followers", "Followers link copied for " .. player.Name)
    end)

    -- Groups
    actionBtn(10, "🏛", "Groups", COLORS.FG, function()
        pcall(function()
            if setclipboard then
                setclipboard("https://www.roblox.com/users/" .. player.UserId .. "/groups")
            end
        end)
        notify("Groups", "Groups link copied for " .. player.Name)
    end)

    -- INFO CARD
    local InfoCard = Instance.new("Frame")
    InfoCard.Size = UDim2.new(0.5, -6, 1, 0)
    InfoCard.Position = UDim2.new(0.5, 6, 0, 0)
    InfoCard.BackgroundColor3 = COLORS.BG_CARD
    InfoCard.BorderSizePixel = 0
    InfoCard.Parent = LowerRow

    local InfoCorner = Instance.new("UICorner")
    InfoCorner.CornerRadius = UDim.new(0, 10)
    InfoCorner.Parent = InfoCard

    local InfoStroke = Instance.new("UIStroke")
    InfoStroke.Color = COLORS.BORDER
    InfoStroke.Thickness = 1
    InfoStroke.Parent = InfoCard

    local InfoTitle = Instance.new("TextLabel")
    InfoTitle.Size = UDim2.new(1, -24, 0, 24)
    InfoTitle.Position = UDim2.new(0, 16, 0, 12)
    InfoTitle.BackgroundTransparency = 1
    InfoTitle.Text = "Player Information"
    InfoTitle.TextColor3 = COLORS.FG
    InfoTitle.Font = Enum.Font.GothamMedium
    InfoTitle.TextSize = 13
    InfoTitle.TextXAlignment = Enum.TextXAlignment.Left
    InfoTitle.Parent = InfoCard

    local InfoList = Instance.new("Frame")
    InfoList.Size = UDim2.new(1, -32, 1, -56)
    InfoList.Position = UDim2.new(0, 16, 0, 46)
    InfoList.BackgroundTransparency = 1
    InfoList.Parent = InfoCard

    local InfoListLayout = Instance.new("UIListLayout")
    InfoListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    InfoListLayout.Padding = UDim.new(0, 4)
    InfoListLayout.Parent = InfoList

    local function infoRow(order, key, value)
        local Row = Instance.new("Frame")
        Row.Size = UDim2.new(1, 0, 0, 26)
        Row.BackgroundTransparency = 1
        Row.LayoutOrder = order
        Row.Parent = InfoList

        local K = Instance.new("TextLabel")
        K.Size = UDim2.new(0.5, -4, 1, 0)
        K.BackgroundTransparency = 1
        K.Text = key
        K.TextColor3 = COLORS.FG_MUTED
        K.Font = Enum.Font.Gotham
        K.TextSize = 11
        K.TextXAlignment = Enum.TextXAlignment.Left
        K.Parent = Row

        local V = Instance.new("TextLabel")
        V.Size = UDim2.new(0.5, -4, 1, 0)
        V.Position = UDim2.new(0.5, 4, 0, 0)
        V.BackgroundTransparency = 1
        V.Text = value
        V.TextColor3 = COLORS.FG
        V.Font = Enum.Font.GothamMedium
        V.TextSize = 11
        V.TextXAlignment = Enum.TextXAlignment.Right
        V.TextTruncate = Enum.TextTruncate.AtEnd
        V.Parent = Row

        return Row
    end

    infoRow(1, "Username",      player.Name)
    infoRow(2, "Display Name",  player.DisplayName)
    infoRow(3, "User ID",       tostring(player.UserId))
    infoRow(4, "Account Age",   "Unknown (needs web API)")
    infoRow(5, "Friends",       "Unknown (needs web API)")
    infoRow(6, "Followers",     "Unknown (needs web API)")
    infoRow(7, "Groups",        "Unknown (needs web API)")
    infoRow(8, "Join Date",     "Unknown (needs web API)")
    infoRow(9, "Last Online",   "Now")
    infoRow(10,"Game",          game.PlaceId and game.Name or "Unknown")

    -- NOTES
    local NotesLabel = Instance.new("TextLabel")
    NotesLabel.Size = UDim2.new(1, -32, 0, 16)
    NotesLabel.Position = UDim2.new(0, 16, 1, -70)
    NotesLabel.BackgroundTransparency = 1
    NotesLabel.Text = "Notes"
    NotesLabel.TextColor3 = COLORS.FG_MUTED
    NotesLabel.Font = Enum.Font.GothamMedium
    NotesLabel.TextSize = 11
    NotesLabel.TextXAlignment = Enum.TextXAlignment.Left
    NotesLabel.Parent = InfoCard

    local NotesBox = Instance.new("Frame")
    NotesBox.Size = UDim2.new(1, -32, 0, 34)
    NotesBox.Position = UDim2.new(0, 16, 1, -50)
    NotesBox.BackgroundColor3 = COLORS.BG_PANEL
    NotesBox.BorderSizePixel = 0
    NotesBox.Parent = InfoCard

    local NotesCorner = Instance.new("UICorner")
    NotesCorner.CornerRadius = UDim.new(0, 6)
    NotesCorner.Parent = NotesBox

    local NotesStroke = Instance.new("UIStroke")
    NotesStroke.Color = COLORS.BORDER
    NotesStroke.Thickness = 1
    NotesStroke.Parent = NotesBox

    local NotesInput = Instance.new("TextBox")
    NotesInput.Size = UDim2.new(1, -46, 1, 0)
    NotesInput.Position = UDim2.new(0, 10, 0, 0)
    NotesInput.BackgroundTransparency = 1
    NotesInput.Text = ""
    NotesInput.PlaceholderText = "Add a note..."
    NotesInput.PlaceholderColor3 = COLORS.FG_DIM
    NotesInput.TextColor3 = COLORS.FG
    NotesInput.Font = Enum.Font.Gotham
    NotesInput.TextSize = 12
    NotesInput.TextXAlignment = Enum.TextXAlignment.Left
    NotesInput.ClearTextOnFocus = false
    NotesInput.Parent = NotesBox

    local NotesSave = Instance.new("TextButton")
    NotesSave.Size = UDim2.new(0, 28, 0, 28)
    NotesSave.Position = UDim2.new(1, -34, 0, 3)
    NotesSave.BackgroundColor3 = COLORS.BG_CARD
    NotesSave.BorderSizePixel = 0
    NotesSave.Text = "💾"
    NotesSave.TextColor3 = COLORS.FG_MUTED
    NotesSave.Font = Enum.Font.Gotham
    NotesSave.TextSize = 13
    NotesSave.AutoButtonColor = false
    NotesSave.Parent = NotesBox

    local NotesSaveCorner = Instance.new("UICorner")
    NotesSaveCorner.CornerRadius = UDim.new(0, 5)
    NotesSaveCorner.Parent = NotesSave

    NotesSave.MouseEnter:Connect(function() NotesSave.BackgroundColor3 = COLORS.BG_HOVER end)
    NotesSave.MouseLeave:Connect(function() NotesSave.BackgroundColor3 = COLORS.BG_CARD end)
    NotesSave.MouseButton1Click:Connect(function()
        notify("Note Saved", "Note saved for " .. player.Name)
    end)
end

print("[Nexus] Layer 1 Part 3b loaded. Full profile UI ready.")
-- ============================================================
-- NEXUS - LAYER 1 PART 4: SETTINGS PAGE
-- General, Display and Access sections
-- ============================================================

local COLORS = _G.Nexus.COLORS
local Content = _G.Nexus.Content

-- Settings page
local SettingsPage = Instance.new("Frame")
SettingsPage.Name = "SettingsPage"
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = Content
_G.Nexus.pages["Settings"] = SettingsPage

-- Scroll for the whole settings page
local SettingsScroll = Instance.new("ScrollingFrame")
SettingsScroll.Size = UDim2.new(1, 0, 1, 0)
SettingsScroll.BackgroundTransparency = 1
SettingsScroll.BorderSizePixel = 0
SettingsScroll.ScrollBarThickness = 4
SettingsScroll.ScrollBarImageColor3 = COLORS.FG_MUTED
SettingsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
SettingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsScroll.Parent = SettingsPage

local SettingsLayout = Instance.new("UIListLayout")
SettingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
SettingsLayout.Padding = UDim.new(0, 16)
SettingsLayout.Parent = SettingsScroll

local SettingsPadding = Instance.new("UIPadding")
SettingsPadding.PaddingRight = UDim.new(0, 8)
SettingsPadding.PaddingTop = UDim.new(0, 4)
SettingsPadding.PaddingBottom = UDim.new(0, 8)
SettingsPadding.Parent = SettingsScroll

-- Settings state
_G.Nexus.Settings = _G.Nexus.Settings or {
    showNotifications = true,
    autoCloseOnAction = false,
    confirmDestructive = true,
    compactMode = false,
    showPlayerIds = true,
    adminKey = "",
}

-- Helper: section group
local function makeSection(order, title)
    local Section = Instance.new("Frame")
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.BackgroundTransparency = 1
    Section.LayoutOrder = order
    Section.AutomaticSize = Enum.AutomaticSize.Y
    Section.Parent = SettingsScroll

    local SectionLayout = Instance.new("UIListLayout")
    SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SectionLayout.Padding = UDim.new(0, 4)
    SectionLayout.Parent = Section

    local SectionTitle = Instance.new("TextLabel")
    SectionTitle.Size = UDim2.new(1, 0, 0, 20)
    SectionTitle.BackgroundTransparency = 1
    SectionTitle.Text = title
    SectionTitle.TextColor3 = COLORS.FG_MUTED
    SectionTitle.Font = Enum.Font.GothamBold
    SectionTitle.TextSize = 11
    SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    SectionTitle.LayoutOrder = 0
    SectionTitle.Parent = Section

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, 0, 0, 1)
    Divider.BackgroundColor3 = COLORS.BORDER
    Divider.BorderSizePixel = 0
    Divider.LayoutOrder = 1
    Divider.Parent = Section

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 0)
    Container.BackgroundTransparency = 1
    Container.AutomaticSize = Enum.AutomaticSize.Y
    Container.LayoutOrder = 2
    Container.Parent = Section

    local ContainerLayout = Instance.new("UIListLayout")
    ContainerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContainerLayout.Padding = UDim.new(0, 2)
    ContainerLayout.Parent = Container

    return Container
end

-- Helper: toggle row
local function makeToggleRow(container, order, label, sub, key)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 46)
    Row.BackgroundTransparency = 1
    Row.LayoutOrder = order
    Row.Parent = container

    local LabelBox = Instance.new("Frame")
    LabelBox.Size = UDim2.new(1, -80, 1, 0)
    LabelBox.BackgroundTransparency = 1
    LabelBox.Parent = Row

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.Position = UDim2.new(0, 0, 0, 4)
    Title.BackgroundTransparency = 1
    Title.Text = label
    Title.TextColor3 = COLORS.FG
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = LabelBox

    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(1, 0, 0, 16)
    Sub.Position = UDim2.new(0, 0, 0, 24)
    Sub.BackgroundTransparency = 1
    Sub.Text = sub or ""
    Sub.TextColor3 = COLORS.FG_MUTED
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 11
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.Parent = LabelBox

    local Toggle = Instance.new("TextButton")
    Toggle.Name = key .. "Toggle"
    Toggle.Size = UDim2.new(0, 38, 0, 22)
    Toggle.Position = UDim2.new(1, -50, 0, 12)
    Toggle.BackgroundColor3 = _G.Nexus.Settings[key] and COLORS.GREEN or COLORS.BG_HOVER
    Toggle.BorderSizePixel = 0
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.Parent = Row

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = Toggle

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = _G.Nexus.Settings[key]
        and UDim2.new(1, -18, 0, 3)
        or UDim2.new(0, 3, 0, 3)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = Toggle

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local function refresh()
        local on = _G.Nexus.Settings[key]
        Toggle.BackgroundColor3 = on and COLORS.GREEN or COLORS.BG_HOVER
        if on then
            Knob.Position = UDim2.new(1, -18, 0, 3)
        else
            Knob.Position = UDim2.new(0, 3, 0, 3)
        end
    end

    Toggle.MouseButton1Click:Connect(function()
        _G.Nexus.Settings[key] = not _G.Nexus.Settings[key]
        refresh()
    end)

    return Row
end

-- Helper: text input row
local function makeInputRow(container, order, label, sub, placeholder, isPassword, onChange)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 50)
    Row.BackgroundTransparency = 1
    Row.LayoutOrder = order
    Row.Parent = container

    local LabelBox = Instance.new("Frame")
    LabelBox.Size = UDim2.new(1, -180, 1, 0)
    LabelBox.BackgroundTransparency = 1
    LabelBox.Parent = Row

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 20)
    Title.Position = UDim2.new(0, 0, 0, 6)
    Title.BackgroundTransparency = 1
    Title.Text = label
    Title.TextColor3 = COLORS.FG
    Title.Font = Enum.Font.GothamMedium
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = LabelBox

    local Sub = Instance.new("TextLabel")
    Sub.Size = UDim2.new(1, 0, 0, 16)
    Sub.Position = UDim2.new(0, 0, 0, 26)
    Sub.BackgroundTransparency = 1
    Sub.Text = sub or ""
    Sub.TextColor3 = COLORS.FG_MUTED
    Sub.Font = Enum.Font.Gotham
    Sub.TextSize = 11
    Sub.TextXAlignment = Enum.TextXAlignment.Left
    Sub.Parent = LabelBox

    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(0, 160, 0, 30)
    InputFrame.Position = UDim2.new(1, -170, 0, 10)
    InputFrame.BackgroundColor3 = COLORS.BG_CARD
    InputFrame.BorderSizePixel = 0
    InputFrame.Parent = Row

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 6)
    InputCorner.Parent = InputFrame

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = COLORS.BORDER
    InputStroke.Thickness = 1
    InputStroke.Parent = InputFrame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -16, 1, 0)
    Input.Position = UDim2.new(0, 8, 0, 0)
    Input.BackgroundTransparency = 1
    Input.Text = ""
    Input.PlaceholderText = placeholder or ""
    Input.PlaceholderColor3 = COLORS.FG_DIM
    Input.TextColor3 = COLORS.FG
    Input.Font = Enum.Font.Gotham
    Input.TextSize = 12
    Input.ClearTextOnFocus = false
    Input.Parent = InputFrame

    if isPassword then
        Input.Text = "••••••••••"
    end

    if onChange then
        Input.FocusLost:Connect(function()
            onChange(Input.Text)
        end)
    end

    return Row
end

-- GENERAL
local GeneralSection = makeSection(1, "GENERAL")
makeToggleRow(GeneralSection, 1, "Show Notifications", "Display toast notifications for actions", "showNotifications")
makeToggleRow(GeneralSection, 2, "Auto-Close on Action", "Close panel after executing a command", "autoCloseOnAction")
makeToggleRow(GeneralSection, 3, "Confirm Destructive Actions", "Ask before kick/ban", "confirmDestructive")

-- DISPLAY
local DisplaySection = makeSection(2, "DISPLAY")
makeToggleRow(DisplaySection, 1, "Compact Mode", "Reduce padding and font sizes", "compactMode")
makeToggleRow(DisplaySection, 2, "Show Player IDs", "Display numeric user IDs in list", "showPlayerIds")

-- ACCESS
local AccessSection = makeSection(3, "ACCESS")
makeInputRow(AccessSection, 1, "Admin Key", "Secret key for admin access", "Enter key...", true, function(text)
    _G.Nexus.Settings.adminKey = text
end)

print("[Nexus] Layer 1 Part 4 loaded. Settings page ready.")
-- ============================================================
-- NEXUS - LAYER 1 PART 4 ADDENDUM: PREFIX SETTING
-- Adds a "Command Prefix" input row to the Access section
-- ============================================================

local COLORS = _G.Nexus.COLORS

-- Initialize default prefix on the global state
_G.Nexus.Prefix = _G.Nexus.Prefix or ";"

-- Find the Settings scroll
local SettingsScroll = _G.Nexus.pages["Settings"]:FindFirstChildOfClass("ScrollingFrame")

if not SettingsScroll then
    warn("[Nexus] Prefix addendum: Settings scroll not found. Load Part 4 first.")
    return
end

-- Find the Access section (LayoutOrder 3 in the scroll)
local AccessSection = nil
for _, child in ipairs(SettingsScroll:GetChildren()) do
    if child:IsA("Frame") and child.LayoutOrder == 3 then
        AccessSection = child
        break
    end
end

if not AccessSection then
    warn("[Nexus] Prefix addendum: Access section not found.")
    return
end

-- Get the container inside the Access section (LayoutOrder 2)
local Container = nil
for _, child in ipairs(AccessSection:GetChildren()) do
    if child:IsA("Frame") and child.LayoutOrder == 2 then
        Container = child
        break
    end
end

if not Container then
    warn("[Nexus] Prefix addendum: Access container not found.")
    return
end

-- Create the Prefix row at the top of the container (LayoutOrder 0)
local PrefixRow = Instance.new("Frame")
PrefixRow.Size = UDim2.new(1, 0, 0, 50)
PrefixRow.BackgroundTransparency = 1
PrefixRow.LayoutOrder = 0
PrefixRow.Parent = Container

local LabelBox = Instance.new("Frame")
LabelBox.Size = UDim2.new(1, -180, 1, 0)
LabelBox.BackgroundTransparency = 1
LabelBox.Parent = PrefixRow

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Position = UDim2.new(0, 0, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "Command Prefix"
Title.TextColor3 = COLORS.FG
Title.Font = Enum.Font.GothamMedium
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = LabelBox

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(1, 0, 0, 16)
Sub.Position = UDim2.new(0, 0, 0, 26)
Sub.BackgroundTransparency = 1
Sub.Text = "Symbol used before commands in chat"
Sub.TextColor3 = COLORS.FG_MUTED
Sub.Font = Enum.Font.Gotham
Sub.TextSize = 11
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = LabelBox

local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(0, 160, 0, 30)
InputFrame.Position = UDim2.new(1, -170, 0, 10)
InputFrame.BackgroundColor3 = COLORS.BG_CARD
InputFrame.BorderSizePixel = 0
InputFrame.Parent = PrefixRow

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = InputFrame

local InputStroke = Instance.new("UIStroke")
InputStroke.Color = COLORS.BORDER
InputStroke.Thickness = 1
InputStroke.Parent = InputFrame

local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -16, 1, 0)
Input.Position = UDim2.new(0, 8, 0, 0)
Input.BackgroundTransparency = 1
Input.Text = _G.Nexus.Prefix
Input.PlaceholderText = ";"
Input.PlaceholderColor3 = COLORS.FG_DIM
Input.TextColor3 = COLORS.FG
Input.Font = Enum.Font.Code
Input.TextSize = 13
Input.ClearTextOnFocus = false
Input.Parent = InputFrame

Input:GetPropertyChangedSignal("Text"):Connect(function()
    local text = Input.Text
    if text == "" then
        _G.Nexus.Prefix = ""
    else
        _G.Nexus.Prefix = text:sub(1, 1)
    end
    if _G.Nexus.refreshPrefixVisual then
        _G.Nexus.refreshPrefixVisual()
    end
end)

Input.FocusLost:Connect(function()
    Input.Text = _G.Nexus.Prefix
end)

print("[Nexus] Prefix addendum loaded. Current prefix: " .. tostring(_G.Nexus.Prefix))
-- ============================================================
-- NEXUS - LAYER 1 PART 5 (FIXED): FLOATING COMMAND BAR
-- No prefix in the bar. Just input + send arrow.
-- Prefix is used only in the Roblox chat.
-- ============================================================

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local COLORS = _G.Nexus.COLORS

if CoreGui:FindFirstChild("NexusCommandBar") then
    CoreGui.NexusCommandBar:Destroy()
end

local BarGui = Instance.new("ScreenGui")
BarGui.Name = "NexusCommandBar"
BarGui.ResetOnSpawn = false
BarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BarGui.IgnoreGuiInset = true
BarGui.Parent = CoreGui

local BarWrapper = Instance.new("Frame")
BarWrapper.Name = "BarWrapper"
BarWrapper.AnchorPoint = Vector2.new(0.5, 0.5)
BarWrapper.Position = UDim2.new(0.5, 0, 0.5, 0)
BarWrapper.Size = UDim2.new(0, 560, 0, 50)
BarWrapper.BackgroundTransparency = 1
BarWrapper.Visible = false
BarWrapper.Parent = BarGui

local BarBG = Instance.new("Frame")
BarBG.Name = "BarBG"
BarBG.Size = UDim2.new(1, 0, 1, 0)
BarBG.BackgroundColor3 = COLORS.BG_PANEL
BarBG.BorderSizePixel = 0
BarBG.Parent = BarWrapper

local BarBGCorner = Instance.new("UICorner")
BarBGCorner.CornerRadius = UDim.new(1, 0)
BarBGCorner.Parent = BarBG

local BarBGStroke = Instance.new("UIStroke")
BarBGStroke.Color = COLORS.BORDER
BarBGStroke.Thickness = 1
BarBGStroke.Parent = BarBG

local PrefixBox = Instance.new("TextLabel")
PrefixBox.Name = "PrefixBox"
PrefixBox.Size = UDim2.new(0, 38, 0, 38)
PrefixBox.Position = UDim2.new(0, 6, 0.5, -19)
PrefixBox.BackgroundColor3 = COLORS.BG_CARD
PrefixBox.BorderSizePixel = 0
PrefixBox.Text = _G.Nexus.Prefix or ";"
PrefixBox.TextColor3 = COLORS.FG
PrefixBox.Font = Enum.Font.Code
PrefixBox.TextSize = 18
PrefixBox.Parent = BarBG

local PrefixCorner = Instance.new("UICorner")
PrefixCorner.CornerRadius = UDim.new(0, 8)
PrefixCorner.Parent = PrefixBox

local PrefixStroke = Instance.new("UIStroke")
PrefixStroke.Color = COLORS.BORDER
PrefixStroke.Thickness = 1
PrefixStroke.Parent = PrefixBox

local function refreshPrefixVisual()
    PrefixBox.Text = _G.Nexus.Prefix or ";"
end
_G.Nexus.refreshPrefixVisual = refreshPrefixVisual

local BarInput = Instance.new("TextBox")
BarInput.Name = "BarInput"
BarInput.Size = UDim2.new(1, -102, 1, -12)
BarInput.Position = UDim2.new(0, 52, 0, 6)
BarInput.BackgroundTransparency = 1
BarInput.Text = ""
BarInput.PlaceholderText = "Type a command..."
BarInput.PlaceholderColor3 = COLORS.FG_DIM
BarInput.TextColor3 = COLORS.FG
BarInput.Font = Enum.Font.Gotham
BarInput.TextSize = 14
BarInput.TextXAlignment = Enum.TextXAlignment.Left
BarInput.ClearTextOnFocus = false
BarInput.Parent = BarBG

local SendBtn = Instance.new("TextButton")
SendBtn.Name = "SendBtn"
SendBtn.Size = UDim2.new(0, 36, 0, 36)
SendBtn.Position = UDim2.new(1, -44, 0.5, -18)
SendBtn.BackgroundColor3 = COLORS.BG_CARD
SendBtn.BorderSizePixel = 0
SendBtn.Text = "➤"
SendBtn.TextColor3 = COLORS.FG
SendBtn.Font = Enum.Font.GothamBold
SendBtn.TextSize = 16
SendBtn.AutoButtonColor = false
SendBtn.Parent = BarBG

local SendCorner = Instance.new("UICorner")
SendCorner.CornerRadius = UDim.new(0, 8)
SendCorner.Parent = SendBtn

local SendStroke = Instance.new("UIStroke")
SendStroke.Color = COLORS.BORDER
SendStroke.Thickness = 1
SendStroke.Parent = SendBtn

SendBtn.MouseEnter:Connect(function()
    SendBtn.BackgroundColor3 = COLORS.BG_HOVER
end)
SendBtn.MouseLeave:Connect(function()
    SendBtn.BackgroundColor3 = COLORS.BG_CARD
end)

local isOpen = false

local function openBar()
    if isOpen then return end
    isOpen = true
    BarWrapper.Visible = true
    refreshPrefixVisual()

    BarBG.BackgroundTransparency = 1
    BarInput.TextTransparency = 1
    PrefixBox.TextTransparency = 1
    SendBtn.TextTransparency = 1
    BarBGStroke.Transparency = 1

    TweenService:Create(BarBG, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
    TweenService:Create(BarInput, TweenInfo.new(0.15), { TextTransparency = 0 }):Play()
    TweenService:Create(PrefixBox, TweenInfo.new(0.15), { TextTransparency = 0 }):Play()
    TweenService:Create(SendBtn, TweenInfo.new(0.15), { TextTransparency = 0 }):Play()
    TweenService:Create(BarBGStroke, TweenInfo.new(0.15), { Transparency = 0 }):Play()

    task.wait(0.05)
    BarInput:CaptureFocus()
end

local function closeBar()
    if not isOpen then return end
    isOpen = false

    local t = TweenService:Create(BarBG, TweenInfo.new(0.15), { BackgroundTransparency = 1 })
    TweenService:Create(BarInput, TweenInfo.new(0.15), { TextTransparency = 1 }):Play()
    TweenService:Create(PrefixBox, TweenInfo.new(0.15), { TextTransparency = 1 }):Play()
    TweenService:Create(SendBtn, TweenInfo.new(0.15), { TextTransparency = 1 }):Play()
    TweenService:Create(BarBGStroke, TweenInfo.new(0.15), { Transparency = 1 }):Play()
    t:Play()
    t.Completed:Connect(function()
        BarWrapper.Visible = false
    end)

    BarInput:ReleaseFocus()
    BarInput.Text = ""
end

local function runInput()
    local text = BarInput.Text
    if text == nil then return end
    text = text:gsub("^%s+", ""):gsub("%s+$", "")
    if text == "" then return end

    local lower = text:lower()

    if lower == "menu" or lower == "admin" or lower == "nexus" then
        if _G.Nexus.openMenu then
            _G.Nexus.openMenu()
        end
        closeBar()
        return
    end

    if lower == "close" or lower == "exit" then
        closeBar()
        return
    end

    if _G.Nexus and _G.Nexus.runCommand then
        pcall(_G.Nexus.runCommand, text)
    else
        if _G.Nexus.notify then
            _G.Nexus.notify("Command", "Parser not loaded yet: " .. text)
        else
            print("[Nexus] Would run: " .. text)
        end
    end

    BarInput.Text = ""
end

SendBtn.MouseButton1Click:Connect(runInput)

BarInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        runInput()
    else
        closeBar()
    end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if isOpen then
            closeBar()
        else
            openBar()
        end
    end
end)

_G.Nexus.CmdBar = {
    insert = function(text)
        if not isOpen then openBar() end
        BarInput.Text = text or ""
        task.wait(0.05)
        BarInput:CaptureFocus()
    end,
    open = openBar,
    close = closeBar,
    isOpen = function() return isOpen end,
}

print("[Nexus] Layer 1 Part 5 (fixed) loaded. Floating command bar ready. Right Shift to open.")
-- ============================================================
-- NEXUS - LAYER 1 PART 6: TOAST NOTIFICATION
-- Bottom-center popup with check icon, title, sub, X
-- ============================================================

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local COLORS = _G.Nexus.COLORS

if CoreGui:FindFirstChild("NexusToast") then
    CoreGui.NexusToast:Destroy()
end

local ToastGui = Instance.new("ScreenGui")
ToastGui.Name = "NexusToast"
ToastGui.ResetOnSpawn = false
ToastGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ToastGui.IgnoreGuiInset = true
ToastGui.Parent = CoreGui

local Toast = Instance.new("Frame")
Toast.Name = "Toast"
Toast.AnchorPoint = Vector2.new(0.5, 1)
Toast.Position = UDim2.new(0.5, 0, 1, -30)
Toast.Size = UDim2.new(0, 420, 0, 70)
Toast.BackgroundColor3 = COLORS.BG_PANEL
Toast.BorderSizePixel = 0
Toast.Visible = false
Toast.Parent = ToastGui

local ToastCorner = Instance.new("UICorner")
ToastCorner.CornerRadius = UDim.new(0, 12)
ToastCorner.Parent = Toast

local ToastStroke = Instance.new("UIStroke")
ToastStroke.Color = COLORS.BORDER
ToastStroke.Thickness = 1
ToastStroke.Parent = Toast

local IconCircle = Instance.new("Frame")
IconCircle.Name = "IconCircle"
IconCircle.Size = UDim2.new(0, 40, 0, 40)
IconCircle.Position = UDim2.new(0, 14, 0.5, -20)
IconCircle.BackgroundColor3 = COLORS.GREEN
IconCircle.BackgroundTransparency = 0.8
IconCircle.BorderSizePixel = 0
IconCircle.Parent = Toast

local IconCircleCorner = Instance.new("UICorner")
IconCircleCorner.CornerRadius = UDim.new(1, 0)
IconCircleCorner.Parent = IconCircle

local CheckLabel = Instance.new("TextLabel")
CheckLabel.Size = UDim2.new(1, 0, 1, 0)
CheckLabel.BackgroundTransparency = 1
CheckLabel.Text = "✓"
CheckLabel.TextColor3 = COLORS.GREEN
CheckLabel.Font = Enum.Font.GothamBold
CheckLabel.TextSize = 22
CheckLabel.Parent = IconCircle

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, -140, 0, 22)
TitleLabel.Position = UDim2.new(0, 66, 0, 14)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Nexus Loaded!"
TitleLabel.TextColor3 = COLORS.FG
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Toast

local SubLabel = Instance.new("TextLabel")
SubLabel.Name = "SubLabel"
SubLabel.Size = UDim2.new(1, -140, 0, 16)
SubLabel.Position = UDim2.new(0, 66, 0, 36)
SubLabel.BackgroundTransparency = 1
SubLabel.Text = "You can now use the admin commands."
SubLabel.TextColor3 = COLORS.FG_MUTED
SubLabel.Font = Enum.Font.Gotham
SubLabel.TextSize = 11
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Parent = Toast

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -13)
CloseBtn.BackgroundColor3 = COLORS.BG_CARD
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "×"
CloseBtn.TextColor3 = COLORS.FG_MUTED
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Toast

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    CloseBtn.BackgroundColor3 = COLORS.BG_HOVER
    CloseBtn.TextColor3 = COLORS.FG
end)
CloseBtn.MouseLeave:Connect(function()
    CloseBtn.BackgroundColor3 = COLORS.BG_CARD
    CloseBtn.TextColor3 = COLORS.FG_MUTED
end)

local hideToken = 0

local function showToast(title, sub, color)
    hideToken = hideToken + 1
    local myToken = hideToken

    TitleLabel.Text = title or "Nexus"
    SubLabel.Text = sub or ""

    if color then
        IconCircle.BackgroundColor3 = color
        CheckLabel.TextColor3 = color
    else
        IconCircle.BackgroundColor3 = COLORS.GREEN
        CheckLabel.TextColor3 = COLORS.GREEN
    end

    Toast.Visible = true
    Toast.BackgroundTransparency = 1
    TitleLabel.TextTransparency = 1
    SubLabel.TextTransparency = 1
    IconCircle.BackgroundTransparency = 1
    CheckLabel.TextTransparency = 1

    TweenService:Create(Toast, TweenInfo.new(0.2), { BackgroundTransparency = 0 }):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
    TweenService:Create(SubLabel, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
    TweenService:Create(IconCircle, TweenInfo.new(0.2), { BackgroundTransparency = 0.8 }):Play()
    TweenService:Create(CheckLabel, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()

    task.delay(3, function()
        if hideToken ~= myToken then return end
        local t = TweenService:Create(Toast, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
        TweenService:Create(TitleLabel, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
        TweenService:Create(SubLabel, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
        TweenService:Create(IconCircle, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(CheckLabel, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
        t:Play()
        t.Completed:Connect(function()
            Toast.Visible = false
        end)
    end)
end

CloseBtn.MouseButton1Click:Connect(function()
    hideToken = hideToken + 1
    Toast.Visible = false
end)

_G.Nexus.notify = showToast
_G.Nexus.showToast = showToast

task.wait(0.5)
showToast("Nexus Loaded!", "You can now use the admin commands.", COLORS.GREEN)

print("[Nexus] Layer 1 Part 6 loaded. Toast notification ready.")
