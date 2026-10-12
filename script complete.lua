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
-- ============================================================
-- NEXUS - BATCH 1: MOVEMENT PLUS (FIXED)
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
-- TPWALK (teleport-based movement)
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
local tpJumpConn = nil

_G.Nexus.register("tpjump", {}, "tpjump <number>", "<number>", "Teleport up on jump instead of using JumpPower", function(target, args)
    local n = tonumber(args[1]) or tonumber(target)
    if n then TPJUMP_HEIGHT = n end
    if tpJumpConn then tpJumpConn:Disconnect() end
    tpJumpConn = UserInputService.JumpRequest:Connect(function()
        local hrp = getHRP()
        if hrp then
            hrp.CFrame = hrp.CFrame + Vector3.new(0, TPJUMP_HEIGHT, 0)
        end
    end)
    notify("TpJump", "Enabled with height " .. TPJUMP_HEIGHT)
end)

_G.Nexus.register("untpjump", {}, "untpjump", "", "Stop tpjump", function()
    if tpJumpConn then tpJumpConn:Disconnect() tpJumpConn = nil end
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
-- WALLWALK (REWRITTEN so it actually works)
-- ============================================================
local wallwalkConn = nil

_G.Nexus.register("wallwalk", {}, "wallwalk", "", "Walk on walls", function()
    local hum = getHum()
    if hum then
        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        hum.MaxSlopeAngle = 89
    end
    if wallwalkConn then wallwalkConn:Disconnect() end
    wallwalkConn = RunService.Heartbeat:Connect(function()
        local h = getHum()
        if not h then return end
        h.MaxSlopeAngle = 89
        -- Force climbing state whenever touching any wall so you stick
        local state = h:GetState()
        if state == Enum.HumanoidStateType.Running
            or state == Enum.HumanoidStateType.RunningNoPhysics
            or state == Enum.HumanoidStateType.Freefall
        then
            h:ChangeState(Enum.HumanoidStateType.Climbing)
        end
    end)
    notify("WallWalk", "Enabled.")
end)

_G.Nexus.register("unwallwalk", {}, "unwallwalk", "", "Stop wallwalk", function()
    if wallwalkConn then wallwalkConn:Disconnect() wallwalkConn = nil end
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
    if airMomentumConn then airMomentumConn:Disconnect() end
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
local msaConn = nil

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
    if msaConn then msaConn:Disconnect() end
    msaConn = RunService.Heartbeat:Connect(function()
        local hum = getHum()
        if hum then hum.MaxSlopeAngle = n end
    end)
    notify("MaxSlopeAngle", "Locked to " .. n)
end)

_G.Nexus.register("unloopmaxslopeangle", {"unlmsa"}, "unloopmaxslopeangle", "", "Stop locking MaxSlopeAngle", function()
    if msaConn then msaConn:Disconnect() msaConn = nil end
    notify("MaxSlopeAngle", "Unlocked.")
end)

print("[Nexus] Batch 1 loaded. Movement Plus (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 2: HITBOX / REACH (FIXED)
-- hitbox, unhitbox, boxreach, reach, resetreach, aura,
-- unaura, npcaura, unnpcaura, hitboxes, unhitboxes
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

_G.Nexus.register("unhitbox", {"unhbox"}, "unhitbox [player]", "[player]", "Reset a player's hitbox or all", function(target)
    if not target then
        local count = 0
        for part, size in pairs(originalSizes) do
            if part and part.Parent then
                part.Size = size
                part.Transparency = 0
                part.CanCollide = true
                part.Massless = false
                count = count + 1
            end
            originalSizes[part] = nil
        end
        originalSizes = {}
        notify("Hitbox", "Reset " .. count .. " hitboxes.")
        return
    end
    local plr = findPlayer(target)
    if not plr or not plr.Character then
        notify("Hitbox", "Player not found.")
        return
    end
    local count = 0
    for _, part in ipairs(plr.Character:GetDescendants()) do
        if originalSizes[part] then
            part.Size = originalSizes[part]
            part.Transparency = 0
            part.CanCollide = true
            part.Massless = false
            originalSizes[part] = nil
            count = count + 1
        end
    end
    notify("Hitbox", "Reset " .. count .. " parts for " .. plr.Name)
end)

-- ============================================================
-- REACH (extend your sword reach) - per-tool memory
-- ============================================================
local originalHandleSizes = {}

_G.Nexus.register("reach", {"swordreach"}, "reach [number] [part]", "[number] [part]", "Extend your tool's reach", function(target, args)
    local size = tonumber(args[1]) or tonumber(target) or 30
    local partName = args[2] or "Handle"
    local char = LocalPlayer.Character
    if not char then return end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local part = tool:FindFirstChild(partName)
            if part then
                originalHandleSizes[part] = originalHandleSizes[part] or part.Size
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
    local count = 0
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local part = tool:FindFirstChild("Handle")
            if part and originalHandleSizes[part] then
                part.Size = originalHandleSizes[part]
                part.Transparency = 0
                part.CanCollide = true
                part.Massless = false
                originalHandleSizes[part] = nil
                count = count + 1
            end
        end
    end
    notify("Reach", "Reset " .. count .. " handles.")
end)

-- ============================================================
-- BOXREACH (box-shaped hitbox around your character)
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
-- AURA (auto-attack with equipped tool) - throttled so it does not crash
-- ============================================================
local auraConn = nil

_G.Nexus.register("aura", {}, "aura [radius]", "[radius]", "Auto-attack nearby players", function(target, args)
    local radius = tonumber(args[1]) or tonumber(target) or 15
    if auraConn then auraConn:Disconnect() end
    auraConn = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local tool = char:FindFirstChildWhichIsA("Tool")
        if not tool then return end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                if tHRP and (tHRP.Position - hrp.Position).Magnitude <= radius then
                    pcall(function() tool:Activate() end)
                end
            end
        end
        task.wait(0.1)
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
local npcAuraConn = nil

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
        task.wait(0.1)
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

print("[Nexus] Batch 2 loaded. Hitbox / Reach (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 3: AIMBOT / TRIGGERBOT (FIXED)
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
-- AIMBOT (smooth camera lock on nearest player)
-- ============================================================
local aimbotConn = nil
local AIMBOT_KEY = Enum.KeyCode.E
local AIMBOT_FOV = 200
local AIMBOT_SMOOTH = 0.25

_G.Nexus.register("aimbot", {"aim"}, "aimbot [fov] [smooth]", "[fov] [smooth]", "Lock camera onto nearest player (hold E)", function(target, args)
    local fov = tonumber(args[1]) or tonumber(target)
    if fov then AIMBOT_FOV = fov end
    local smooth = tonumber(args[2])
    if smooth then AIMBOT_SMOOTH = smooth end

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
            -- Smooth lerp instead of snapping
            local targetCF = CFrame.new(Camera.CFrame.Position, closest.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCF, AIMBOT_SMOOTH)
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
-- TRIGGERBOT (auto-fire on enemy under crosshair)
-- ============================================================
local triggerbotConn = nil
local TRIGGER_FOV = 30
local TRIGGER_COOLDOWN = 0.05

_G.Nexus.register("triggerbot", {"tbot"}, "triggerbot [fov] [cooldown]", "[fov] [cooldown]", "Auto-activate tool when an enemy is under your crosshair", function(target, args)
    local fov = tonumber(args[1]) or tonumber(target) or TRIGGER_FOV
    if fov then TRIGGER_FOV = fov end
    local cd = tonumber(args[2])
    if cd then TRIGGER_COOLDOWN = cd end

    if triggerbotConn then
        notify("Triggerbot", "Already enabled.")
        return
    end

    local lastFire = 0

    triggerbotConn = RunService.RenderStepped:Connect(function()
        local myChar = LocalPlayer.Character
        local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        -- Project the mouse into the camera properly
        local mouse2D = UserInputService:GetMouseLocation()
        local ray = Camera:ViewportPointToRay(mouse2D.X, mouse2D.Y)
        local rayOrigin = ray.Origin
        local rayDir = ray.Direction * 150

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local toTarget = hrp.Position - rayOrigin
                    local proj = toTarget:Dot(rayDir.Unit)
                    if proj > 0 and proj < 150 then
                        local closestPoint = rayOrigin + rayDir.Unit * proj
                        local perpDist = (hrp.Position - closestPoint).Magnitude
                        if perpDist <= TRIGGER_FOV / 10 then
                            if tick() - lastFire >= TRIGGER_COOLDOWN then
                                local tool = myChar:FindFirstChildWhichIsA("Tool")
                                if tool then
                                    pcall(function() tool:Activate() end)
                                    lastFire = tick()
                                end
                            end
                            break
                        end
                    end
                end
            end
        end
    end)

    notify("Triggerbot", "Enabled (fov " .. TRIGGER_FOV .. ").")
end)

_G.Nexus.register("untriggerbot", {"untbot"}, "untriggerbot", "", "Stop triggerbot", function()
    if triggerbotConn then
        triggerbotConn:Disconnect()
        triggerbotConn = nil
    end
    notify("Triggerbot", "Disabled.")
end)

print("[Nexus] Batch 3 loaded. Aimbot / Triggerbot (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 4: PLAYER INTERACTION (FIXED)
-- piggyback, unpiggyback, headsit, unheadsit, headstand,
-- unheadstand, orbit, unorbit, uporbit, unuporbit, follow,
-- unfollow, pathfind, unpathfind, watch, unwatch, spook,
-- glue, unglue
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
local piggybackConn = nil

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
local headsitConn = nil

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
local headstandConn = nil

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
local orbitConn = nil
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
-- UPO RBIT
-- ============================================================
local uporbitConn = nil
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
-- FOLLOW
-- ============================================================
local followConn = nil

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
-- PATHFIND (threaded, not heartbeat, fixed lag)
-- ============================================================
local pathfindThread = nil

_G.Nexus.register("pathfind", {"pf"}, "pathfind <player>", "<player>", "Pathfind to a player with the pathfinding API", function(target)
    if not target then notify("Pathfind", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Pathfind", "Player not found.") return end

    if pathfindThread then
        notify("Pathfind", "Already running.")
        return
    end

    pathfindThread = task.spawn(function()
        while pathfindThread do
            local char = getChar()
            if char and plr.Character then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
                if hum and tHRP then
                    local path = PathfindingService:CreatePath()
                    local ok = pcall(function()
                        path:ComputeAsync(char.HumanoidRootPart.Position, tHRP.Position)
                    end)
                    if ok and path.Status == Enum.PathStatus.Success then
                        local waypoints = path:GetWaypoints()
                        for _, wp in ipairs(waypoints) do
                            if not pathfindThread then return end
                            hum:MoveTo(wp.Position)
                            task.wait(0.4)
                        end
                    end
                end
            end
            task.wait(0.5)
        end
    end)
    notify("Pathfind", "Following " .. plr.Name)
end)

_G.Nexus.register("unpathfind", {}, "unpathfind", "", "Stop pathfinding", function()
    pathfindThread = nil
    notify("Pathfind", "Stopped.")
end)

-- ============================================================
-- WATCH (spectate)
-- ============================================================
local watchConn = nil

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
-- SPOOK
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
-- GLUE
-- ============================================================
local glueConn = nil

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

print("[Nexus] Batch 4 loaded. Player Interaction (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 5: MOVEMENT II (FIXED)
-- tpup, tpdown, tweengoto, tweengotocampos, gotocampos,
-- tponeat, fly2, unfly2, thru
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
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
-- TWEEN TO (safe tween that cancels the last one)
-- ============================================================
local currentTween = nil

local function tweenTo(targetCFrame, duration)
    local hrp = getHRP()
    if not hrp then return end
    if currentTween then
        pcall(function() currentTween:Cancel() end)
        currentTween = nil
    end
    duration = duration or 0.2
    currentTween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), { CFrame = targetCFrame })
    currentTween:Play()
    return currentTween
end

_G.Nexus.register("tweengoto", {"tweento", "tgoto"}, "tweengoto <player> [duration]", "<player> [duration]", "Smoothly tween to a player", function(target, args)
    if not target then notify("TweenGoto", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("TweenGoto", "Player not found.") return end
    local duration = tonumber(args[1]) or 0.2
    local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
    if tHRP then
        tweenTo(tHRP.CFrame + Vector3.new(0, 2, 0), duration)
        notify("TweenGoto", "Tweened to " .. plr.Name)
    end
end)

-- ============================================================
-- TWEEN TO CAMERA POSITION
-- ============================================================
_G.Nexus.register("tweengotocampos", {"tweentcp", "tocampos", "tcp"}, "tweengotocampos [duration]", "[duration]", "Tween to your camera position", function(target, args)
    local duration = tonumber(args[1]) or tonumber(target) or 0.2
    local hrp = getHRP()
    if hrp and Camera then
        tweenTo(CFrame.new(Camera.CFrame.Position), duration)
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
-- TPONEAT (teleport next to a player, not on them)
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
-- FLY V2 (fixed cleanup)
-- ============================================================
local fly2Conn = nil
local fly2BodyVel = nil
local fly2Speed = 100

local function stopFly2()
    if fly2Conn then
        fly2Conn:Disconnect()
        fly2Conn = nil
    end
    if fly2BodyVel then
        fly2BodyVel:Destroy()
        fly2BodyVel = nil
    end
    local char = getChar()
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

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

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end

        if move.Magnitude > 0 then
            fly2BodyVel.Velocity = move.Unit * fly2Speed
        else
            fly2BodyVel.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    notify("Fly2", "Enabled. WASD + Space / LeftCtrl.")
end)

_G.Nexus.register("unfly2", {"unflyv2"}, "unfly2", "", "Stop fly v2", function()
    stopFly2()
    notify("Fly2", "Disabled.")
end)

-- ============================================================
-- THRU (noclip forward, always restores collision)
-- ============================================================
_G.Nexus.register("thru", {}, "thru <distance>", "<distance>", "Move forward ignoring collisions", function(target, args)
    local n = tonumber(args[1]) or tonumber(target) or 5
    local hrp = getHRP()
    local char = getChar()
    if not hrp or not char then return end

    local noCollideParts = {}
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            noCollideParts[part] = part.CanCollide
            part.CanCollide = false
        end
    end

    hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * n

    task.wait(0.1)

    for part, was in pairs(noCollideParts) do
        pcall(function()
            if part and part.Parent then
                part.CanCollide = was
            end
        end)
    end

    notify("Thru", "Moved " .. n .. " studs forward.")
end)

print("[Nexus] Batch 5 loaded. Movement II (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 6: ESP VARIANTS (FIXED)
-- espteam, unespteam, espenemies, unespenemies, chamsteam,
-- chamsenemies, locate, unlocate, esplocator, unesplocator,
-- itemesp, unitemesp
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

-- All ESP store in one table now
local espStore = {
    team = {},
    enemies = {},
    locator = {},
}

-- Single heartbeat loop that only exists once
local espLoopConn = nil

local function startEspLoop()
    if espLoopConn then return end
    espLoopConn = RunService.RenderStepped:Connect(function()
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
end

-- Helper: build highlight + billboard for a player
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
    startEspLoop()
end

local function removeStore(store)
    for plr, data in pairs(store) do
        if data.highlight then data.highlight:Destroy() end
        if data.billboard then data.billboard:Destroy() end
    end
    for plr in pairs(store) do store[plr] = nil end
end

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
-- CHAMS TEAM / ENEMIES
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
-- LOCATE
-- ============================================================
_G.Nexus.register("locate", {}, "locate <player1> <player2> ...", "<player...>", "Track specific players with ESP", function(target, args)
    local list = {}
    if target then table.insert(list, target) end
    for _, a in ipairs(args) do table.insert(list, a) end

    if #list == 0 then notify("Locate", "Provide at least one player.") return end

    for _, name in ipairs(list) do
        local plr = _G.Nexus.findPlayer and _G.Nexus.findPlayer(name)
        if plr then
            buildHighlight(plr, Color3.fromRGB(255, 220, 60), true, true, espStore.locator)
        end
    end
    notify("Locate", "Tracking " .. #list .. " players.")
end)

_G.Nexus.register("unlocate", {}, "unlocate", "", "Stop tracking located players", function()
    removeStore(espStore.locator)
    notify("Locate", "Stopped.")
end)

-- ============================================================
-- ESP LOCATOR
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
-- ITEM ESP
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

print("[Nexus] Batch 6 loaded. ESP Variants (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 7: NPC II (FIXED)
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
-- NPC ESP / CHAMS (single store, no leaks)
-- ============================================================
local npcEspStore = {}

local function clearNpcEsp()
    for npc, hl in pairs(npcEspStore) do
        pcall(function()
            if hl and hl.Parent then hl:Destroy() end
        end)
    end
    npcEspStore = {}
end

local function buildNpcEsp(color)
    for _, npc in ipairs(getNPCs()) do
        if not npcEspStore[npc] then
            local hl = Instance.new("Highlight")
            hl.Name = "NexusNpcEsp"
            hl.Adornee = npc
            hl.FillColor = color
            hl.FillTransparency = 0.6
            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = npc
            npcEspStore[npc] = hl
        else
            npcEspStore[npc].FillColor = color
        end
    end
end

_G.Nexus.register("npcesp", {"espnpc"}, "npcesp", "", "ESP every NPC", function()
    clearNpcEsp()
    buildNpcEsp(Color3.fromRGB(255, 180, 80))
    notify("NpcEsp", "Enabled.")
end)

_G.Nexus.register("npcchams", {"chamsnpc"}, "npcchams", "", "Chams for every NPC", function()
    clearNpcEsp()
    buildNpcEsp(Color3.fromRGB(255, 80, 80))
    notify("NpcChams", "Enabled.")
end)

_G.Nexus.register("unnpcesp", {"unnpcchams", "unespnpc"}, "unnpcesp", "", "Disable NPC ESP / chams", function()
    clearNpcEsp()
    notify("NpcEsp", "Disabled.")
end)

-- ============================================================
-- CLICK KILL NPC / CLICK VOID NPC (shared connection)
-- ============================================================
local clickAction = nil
local clickConn = nil

local function stopClickAction()
    if clickConn then
        clickConn:Disconnect()
        clickConn = nil
    end
    clickAction = nil
end

local function startClickAction(mode)
    if clickAction == mode and clickConn then return end
    stopClickAction()
    clickAction = mode
    clickConn = UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        local mouse = LocalPlayer:GetMouse()
        local target = mouse.Target
        if not target then return end
        local model = target:FindFirstAncestorOfClass("Model")
        if not model or not isNPC(model) then return end
        if mode == "kill" then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum then hum.Health = 0 end
        elseif mode == "void" then
            local hrp = model:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = CFrame.new(0, -100000, 0) end
        end
    end)
end

_G.Nexus.register("clickkillnpc", {"cknpc"}, "clickkillnpc", "", "Click an NPC to kill it", function()
    startClickAction("kill")
    notify("ClickKillNpc", "Enabled.")
end)

_G.Nexus.register("unclickkillnpc", {"uncknpc"}, "unclickkillnpc", "", "Disable click kill NPC", function()
    if clickAction == "kill" then stopClickAction() end
    notify("ClickKillNpc", "Disabled.")
end)

_G.Nexus.register("clickvoidnpc", {"cvnpc"}, "clickvoidnpc", "", "Click an NPC to send it into the void", function()
    startClickAction("void")
    notify("ClickVoidNpc", "Enabled.")
end)

_G.Nexus.register("unclickvoidnpc", {"uncvnpc"}, "unclickvoidnpc", "", "Disable click void NPC", function()
    if clickAction == "void" then stopClickAction() end
    notify("ClickVoidNpc", "Disabled.")
end)

-- ============================================================
-- VOID NPCS
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
-- ACT NPC (freezes movement AND animations)
-- ============================================================
local actNpcConn = nil

_G.Nexus.register("actnpc", {}, "actnpc", "", "Act like an NPC (freeze animations, stand still)", function()
    if actNpcConn then actNpcConn:Disconnect() end
    actNpcConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            hum.UseJumpPower = true
        end
        -- Freeze all playing animation tracks
        local animator = char:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:Stop(0)
            end
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

print("[Nexus] Batch 7 loaded. NPC II (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 8: REMOTES II (FIXED)
-- fireremotefind, autofireremote, unautofireremote,
-- blockremote, unblockremote, serverremotespy, unserverremotespy
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

-- ============================================================
-- FIREREMOTEFIND
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
-- AUTOFIREREMOTE (loop with proper flag)
-- ============================================================
local autoFireActive = false
local autoFireThread = nil

_G.Nexus.register("autofireremote", {"afr"}, "autofireremote <interval> <name>", "<interval> <name>", "Automatically fire a remote on interval", function(target, args)
    local interval = tonumber(args[1]) or tonumber(target)
    local name = args[2]

    if not interval or not name then
        notify("AutoFireRemote", "Usage: autofireremote <interval> <name>")
        return
    end

    autoFireActive = false
    if autoFireThread then
        pcall(function() task.cancel(autoFireThread) end)
        autoFireThread = nil
    end
    task.wait(0.05)

    autoFireActive = true
    local lower = name:lower()

    autoFireThread = task.spawn(function()
        while autoFireActive do
            for _, obj in ipairs(game:GetDescendants()) do
                if not autoFireActive then break end
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
    autoFireActive = false
    if autoFireThread then
        pcall(function() task.cancel(autoFireThread) end)
        autoFireThread = nil
    end
    notify("AutoFireRemote", "Stopped.")
end)

-- ============================================================
-- BLOCKREMOTE (installs hook once)
-- ============================================================
local blockedRemotes = {}
local blockHookInstalled = false

local function installBlockHook()
    if blockHookInstalled then return end
    if not getrawmetatable or not setreadonly or not newcclosure then
        notify("BlockRemote", "Executor does not support hooking.")
        return
    end

    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" and typeof(self) == "Instance" and self:IsA("RemoteEvent") then
            local n = self.Name:lower()
            for blocked in pairs(blockedRemotes) do
                if n:find(blocked, 1, true) then
                    return
                end
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
    blockHookInstalled = true
end

_G.Nexus.register("blockremote", {"br"}, "blockremote <name>", "<name>", "Block a remote from sending to the server", function(target)
    if not target then notify("BlockRemote", "Provide a name.") return end
    installBlockHook()
    blockedRemotes[target:lower()] = true
    notify("BlockRemote", "Blocked remotes matching " .. target)
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
-- SERVERREMOTESPY (filters DescendantAdded properly)
-- ============================================================
local serverRemoteSpyGui = nil
local serverRemoteSpyConn = nil
local spyEntries = {}

local function buildSpyGui()
    if serverRemoteSpyGui then serverRemoteSpyGui:Destroy() end
    spyEntries = {}

    local CoreGui = game:GetService("CoreGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "NexusServerRemoteSpy"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

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

local function addSpyEntry(scroll, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
    lbl.BorderSizePixel = 0
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 220)
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = scroll

    local lc = Instance.new("UICorner")
    lc.CornerRadius = UDim.new(0, 4)
    lc.Parent = lbl

    table.insert(spyEntries, lbl)
end

_G.Nexus.register("serverremotespy", {"srs", "sremotespy"}, "serverremotespy", "", "Log all remote events received from the server", function()
    local scroll = buildSpyGui()

    if serverRemoteSpyConn then
        serverRemoteSpyConn:Disconnect()
        serverRemoteSpyConn = nil
    end

    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            addSpyEntry(scroll, obj:GetFullName())
        end
    end

    serverRemoteSpyConn = game.DescendantAdded:Connect(function(obj)
        if obj:IsA("RemoteEvent") then
            addSpyEntry(scroll, obj:GetFullName())
        end
    end)

    notify("ServerRemoteSpy", "Enabled.")
end)

_G.Nexus.register("unserverremotespy", {"unsrs"}, "unserverremotespy", "", "Stop server remote spy", function()
    if serverRemoteSpyConn then serverRemoteSpyConn:Disconnect() serverRemoteSpyConn = nil end
    if serverRemoteSpyGui then serverRemoteSpyGui:Destroy() serverRemoteSpyGui = nil end
    spyEntries = {}
    notify("ServerRemoteSpy", "Disabled.")
end)

print("[Nexus] Batch 8 loaded. Remotes II (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 9: TOOL II (FIXED)
-- droptool, droptools, loopdroptools, unloopdroptools,
-- toolinvisible, untoolinvisible, preventtools, unpreventtools,
-- copytools, savetools, loadtools, notools, mybackpack, givetool
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
-- DROPTOOL / DROPTOOLS
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

_G.Nexus.register("droptools", {"dropalltools"}, "droptools", "", "Drop every equipped tool", function()
    local char = getChar()
    if not char then return end
    local count = 0
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            obj.Parent = Workspace
            count = count + 1
        end
    end
    notify("DropTools", "Dropped " .. count .. " tools.")
end)

-- ============================================================
-- LOOP DROP TOOLS (proper flag, no thread spam)
-- ============================================================
local loopDropActive = false
local loopDropThread = nil

_G.Nexus.register("loopdroptools", {"ldtools"}, "loopdroptools", "", "Keep dropping your tools", function()
    if loopDropActive then
        notify("LoopDropTools", "Already running.")
        return
    end
    loopDropActive = true

    loopDropThread = task.spawn(function()
        while loopDropActive do
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
    loopDropActive = false
    if loopDropThread then
        pcall(function() task.cancel(loopDropThread) end)
        loopDropThread = nil
    end
    notify("LoopDropTools", "Disabled.")
end)

-- ============================================================
-- TOOL INVISIBLE (safe version, only touches limbs and decals)
-- ============================================================
local toolInvisConn = nil

_G.Nexus.register("toolinvisible", {"tinvis"}, "toolinvisible", "", "Become invisible while keeping your tools usable", function()
    if toolInvisConn then return end
    toolInvisConn = RunService.Heartbeat:Connect(function()
        local char = getChar()
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
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
-- PREVENT TOOLS (blocks current and future)
-- ============================================================
local preventToolsConn = nil
local preventLoop = nil

_G.Nexus.register("preventtools", {"noequip"}, "preventtools", "", "Prevent any tool from being equipped", function()
    if preventToolsConn then
        notify("PreventTools", "Already enabled.")
        return
    end
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

    -- Force all currently equipped tools to unequip right away
    hum:UnequipTools()

    -- And run a loop that constantly keeps it unequipped
    local active = true
    preventLoop = task.spawn(function()
        while active do
            local c = getChar()
            if c then
                local h = c:FindFirstChildOfClass("Humanoid")
                if h then h:UnequipTools() end
            end
            task.wait(0.2)
        end
    end)

    notify("PreventTools", "Enabled.")
end)

_G.Nexus.register("unpreventtools", {"unnoequip"}, "unpreventtools", "", "Allow tools again", function()
    if preventToolsConn then preventToolsConn:Disconnect() preventToolsConn = nil end
    if preventLoop then
        pcall(function() task.cancel(preventLoop) end)
        preventLoop = nil
    end
    notify("PreventTools", "Disabled.")
end)

-- ============================================================
-- COPY TOOLS
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
-- NO TOOLS
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

-- ============================================================
-- BACKPACK VIEWER
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

-- ============================================================
-- GIVE TOOL
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

print("[Nexus] Batch 9 loaded. Tool II (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 10: FLING II (FIXED)
-- flyfling, unflyfling, walkfling, unwalkfling, touchfling,
-- untouchfling, cartornado, uncartornado, blackholefollow,
-- noblackholefollow, tpua
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

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
-- FLY FLING (fixed cleanup)
-- ============================================================
local flyFlingConn = nil
local flyFlingBV = nil

local function stopFlyFling()
    if flyFlingConn then flyFlingConn:Disconnect() flyFlingConn = nil end
    if flyFlingBV then flyFlingBV:Destroy() flyFlingBV = nil end
    local char = getChar()
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

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

    flyFlingBV = Instance.new("BodyVelocity")
    flyFlingBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyFlingBV.Velocity = Vector3.new(0, 0, 0)
    flyFlingBV.P = 1e5
    flyFlingBV.Parent = hrp

    flyFlingConn = RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent then return end
        local move = Vector3.new(0, 0, 0)
        local cf = Camera.CFrame
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0, 1, 0) end
        flyFlingBV.Velocity = move.Magnitude > 0 and move.Unit * speed or Vector3.new(0, 0, 0)

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
    stopFlyFling()
    notify("FlyFling", "Disabled.")
end)

-- ============================================================
-- WALK FLING (fixed cleanup)
-- ============================================================
local walkFlingConn = nil
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
-- TOUCH FLING (fixed cleanup)
-- ============================================================
local touchFlingConn = nil
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
-- CAR TORNADO (fixed spin on primary part only)
-- ============================================================
local carTornadoConn = nil

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
        if car.PrimaryPart then
            car.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 200, 0)
        end
    end)
    notify("CarTornado", "Spinning.")
end)

_G.Nexus.register("uncartornado", {"unctornado"}, "uncartornado", "", "Stop the car tornado", function()
    if carTornadoConn then carTornadoConn:Disconnect() carTornadoConn = nil end
    notify("CarTornado", "Stopped.")
end)

-- ============================================================
-- BLACKHOLE FOLLOW
-- ============================================================
local blackholeFollowActive = false
local blackholeFollowThread = nil

_G.Nexus.register("blackholefollow", {"bhf"}, "blackholefollow", "", "Pull all unanchored parts to you with spin", function()
    if blackholeFollowActive then return end
    blackholeFollowActive = true
    blackholeFollowThread = task.spawn(function()
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
    if blackholeFollowThread then
        pcall(function() task.cancel(blackholeFollowThread) end)
        blackholeFollowThread = nil
    end
    notify("BlackholeFollow", "Disabled.")
end)

-- ============================================================
-- TPUA (teleport all unanchored parts to a player, threaded + delayed)
-- ============================================================
local tpuaActive = false
local tpuaThread = nil

_G.Nexus.register("tpua", {"bringua"}, "tpua <player>", "<player>", "Bring every unanchored part to a player", function(target)
    if not target then notify("Tpua", "Provide a target.") return end
    local plr = findPlayer(target)
    if not plr or not plr.Character then notify("Tpua", "Player not found.") return end

    if tpuaActive then
        notify("Tpua", "Already running.")
        return
    end

    tpuaActive = true
    tpuaThread = task.spawn(function()
        while tpuaActive and plr.Character do
            local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
            if not tHRP then break end
            for _, obj in ipairs(workspace:GetDescendants()) do
                if not tpuaActive then break end
                if obj:IsA("BasePart") and not obj.Anchored then
                    if not Players:GetPlayerFromCharacter(obj.Parent) then
                        pcall(function()
                            obj.CFrame = tHRP.CFrame + Vector3.new(math.random(-5, 5), math.random(2, 8), math.random(-5, 5))
                        end)
                        task.wait(0.02)
                    end
                end
            end
            task.wait(0.5)
        end
        tpuaActive = false
    end)
    notify("Tpua", "Bringing parts to " .. plr.Name)
end)

_G.Nexus.register("untpua", {"unbringua"}, "untpua", "", "Stop tpua", function()
    tpuaActive = false
    if tpuaThread then
        pcall(function() task.cancel(tpuaThread) end)
        tpuaThread = nil
    end
    notify("Tpua", "Stopped.")
end)

print("[Nexus] Batch 10 loaded. Fling II (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 11: MISC I (FIXED)
-- dex, olddex, synapsedex, rc7, moduleeditor, upvalueeditor,
-- decompiler, partname, unpartname, gameinfo, jobid, placeid,
-- gameid, getgenv
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

-- ============================================================
-- Safe script loader
-- ============================================================
local function safeLoad(url, name)
    if not url or url == "" then
        notify(name, "No URL configured.")
        return false
    end
    local ok, err = pcall(function()
        local response = game:HttpGet(url)
        if not response or response == "" then
            error("Empty response from URL")
        end
        loadstring(response)()
    end)
    if ok then
        notify(name, "Loaded.")
        return true
    else
        notify(name, "Failed: " .. tostring(err))
        return false
    end
end

-- ============================================================
-- DEX EXPLORER (working URL)
-- ============================================================
_G.Nexus.register("dex", {}, "dex", "", "Load the Dex explorer", function()
    safeLoad("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua", "Dex")
end)

-- ============================================================
-- OLD DEX
-- ============================================================
_G.Nexus.register("olddex", {}, "olddex", "", "Load the old Dex explorer", function()
    safeLoad("https://raw.githubusercontent.com/peyton2465/Dex/master/out.lua", "OldDex")
end)

-- ============================================================
-- SYNAPSE DEX
-- ============================================================
_G.Nexus.register("synapsedex", {"sdex"}, "synapsedex", "", "Load Synapse's Dex explorer", function()
    safeLoad("https://raw.githubusercontent.com/AhmadV99/SynapseX-Dex/master/out.lua", "SynapseDex")
end)

-- ============================================================
-- RC7
-- ============================================================
_G.Nexus.register("rc7", {}, "rc7", "", "Load RC7 internal UI", function()
    safeLoad("https://raw.githubusercontent.com/78n/RC7/main/rc7.lua", "RC7")
end)

-- ============================================================
-- MODULE EDITOR (prints list)
-- ============================================================
_G.Nexus.register("moduleeditor", {"mtable"}, "moduleeditor", "", "Print every ModuleScript path", function()
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
-- UPVALUE EDITOR (prints upvalues)
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
_G.Nexus.register("decompiler", {}, "decompiler", "", "Print the bytecode size of every LocalScript", function()
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
-- PART NAME (global state, safe disconnect)
-- ============================================================
_G.Nexus.PartNameConn = _G.Nexus.PartNameConn or nil

_G.Nexus.register("partname", {"partpath"}, "partname", "", "Click any part to copy its full path", function()
    if _G.Nexus.PartNameConn then
        notify("PartName", "Already enabled.")
        return
    end
    local UserInputService = game:GetService("UserInputService")
    _G.Nexus.PartNameConn = UserInputService.InputBegan:Connect(function(input, gpe)
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
    if _G.Nexus.PartNameConn then
        _G.Nexus.PartNameConn:Disconnect()
        _G.Nexus.PartNameConn = nil
        notify("PartName", "Disabled.")
    else
        notify("PartName", "Not running.")
    end
end)

-- ============================================================
-- GAME INFO
-- ============================================================
_G.Nexus.register("gameinfo", {"ginfo"}, "gameinfo", "", "Print game info to console", function()
    notify("GameInfo", "PlaceId: " .. game.PlaceId .. " | JobId: " .. game.JobId:sub(1, 8))
    print("[Nexus GameInfo] PlaceId: " .. game.PlaceId)
    print("[Nexus GameInfo] GameId: " .. game.GameId)
    print("[Nexus GameInfo] JobId: " .. game.JobId)
    print("[Nexus GameInfo] Creator: " .. tostring(game.CreatorId))
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
-- GETGENV (limited to 100 entries)
-- ============================================================
_G.Nexus.register("getgenv", {"genv"}, "getgenv", "", "Print the first 100 executor globals", function()
    if getgenv then
        print("[Nexus getgenv] First 100 entries:")
        local count = 0
        for k, v in pairs(getgenv()) do
            count = count + 1
            if count > 100 then
                print("   ... and more (truncated)")
                break
            end
            print("  " .. tostring(k) .. " = " .. tostring(v))
        end
        notify("getgenv", "Printed " .. math.min(count, 100) .. " entries.")
    else
        notify("getgenv", "Not supported.")
    end
end)

print("[Nexus] Batch 11 loaded. Misc I (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 12: MISC II (FIXED)
-- speedometer, closespeedometer, keystroke, unkeystroke,
-- notepad, unnotepad, autoclicker, unautoclicker,
-- minimap, unminimap, animationplayer
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
-- SPEEDOMETER (connection stored, no leak)
-- ============================================================
_G.Nexus.SpeedoGui = _G.Nexus.SpeedoGui or nil
_G.Nexus.SpeedoConn = _G.Nexus.SpeedoConn or nil

_G.Nexus.register("speedometer", {"sps", "speedo"}, "speedometer", "", "Show a speedometer of your character", function()
    if _G.Nexus.SpeedoGui then _G.Nexus.SpeedoGui:Destroy() end
    if _G.Nexus.SpeedoConn then _G.Nexus.SpeedoConn:Disconnect() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "NexusSpeedometer"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui
    _G.Nexus.SpeedoGui = gui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 180, 0, 50)
    frame.Position = UDim2.new(0, 20, 0.5, 0)
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

    _G.Nexus.SpeedoConn = RunService.Heartbeat:Connect(function()
        if not gui or not gui.Parent then return end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            label.Text = math.floor(hrp.AssemblyLinearVelocity.Magnitude) .. " studs/s"
        end
    end)
    notify("Speedometer", "Enabled.")
end)

_G.Nexus.register("closespeedometer", {"nosps", "unspeedo"}, "closespeedometer", "", "Close the speedometer", function()
    if _G.Nexus.SpeedoGui then _G.Nexus.SpeedoGui:Destroy() _G.Nexus.SpeedoGui = nil end
    if _G.Nexus.SpeedoConn then _G.Nexus.SpeedoConn:Disconnect() _G.Nexus.SpeedoConn = nil end
    notify("Speedometer", "Closed.")
end)

-- ============================================================
-- KEYSTROKE (installs one updater)
-- ============================================================
_G.Nexus.KeystrokeGui = _G.Nexus.KeystrokeGui or nil
_G.Nexus.KeystrokeConn = _G.Nexus.KeystrokeConn or nil
_G.Nexus.KeyLabels = _G.Nexus.KeyLabels or {}

local function buildKeystroke()
    if _G.Nexus.KeystrokeGui then _G.Nexus.KeystrokeGui:Destroy() end
    if _G.Nexus.KeystrokeConn then _G.Nexus.KeystrokeConn:Disconnect() end
    _G.Nexus.KeyLabels = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "NexusKeystroke"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui
    _G.Nexus.KeystrokeGui = gui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 50)
    frame.Position = UDim2.new(0.5, -110, 1, -70)
    frame.BackgroundTransparency = 1
    frame.Parent = gui

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

        _G.Nexus.KeyLabels[k] = box
    end
end

_G.Nexus.register("keystroke", {}, "keystroke", "", "Show your pressed keys on screen", function()
    if _G.Nexus.KeystrokeGui then
        notify("Keystroke", "Already enabled.")
        return
    end
    buildKeystroke()

    local map = {
        W = Enum.KeyCode.W,
        A = Enum.KeyCode.A,
        S = Enum.KeyCode.S,
        D = Enum.KeyCode.D,
        Space = Enum.KeyCode.Space,
    }
    _G.Nexus.KeystrokeConn = RunService.RenderStepped:Connect(function()
        for k, code in pairs(map) do
            local box = _G.Nexus.KeyLabels[k]
            if box then
                local down = UserInputService:IsKeyDown(code)
                box.BackgroundColor3 = down and Color3.fromRGB(61, 214, 140) or Color3.fromRGB(24, 24, 29)
                box.TextColor3 = down and Color3.fromRGB(17, 17, 20) or Color3.fromRGB(122, 122, 140)
            end
        end
    end)
    notify("Keystroke", "Enabled.")
end)

_G.Nexus.register("unkeystroke", {}, "unkeystroke", "", "Hide keystrokes", function()
    if _G.Nexus.KeystrokeGui then _G.Nexus.KeystrokeGui:Destroy() _G.Nexus.KeystrokeGui = nil end
    if _G.Nexus.KeystrokeConn then _G.Nexus.KeystrokeConn:Disconnect() _G.Nexus.KeystrokeConn = nil end
    _G.Nexus.KeyLabels = {}
    notify("Keystroke", "Disabled.")
end)

-- ============================================================
-- NOTEPAD
-- ============================================================
_G.Nexus.NotepadGui = _G.Nexus.NotepadGui or nil

_G.Nexus.register("notepad", {"npad"}, "notepad", "", "Open a simple notepad UI", function()
    if _G.Nexus.NotepadGui then _G.Nexus.NotepadGui:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "NexusNotepad"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui
    _G.Nexus.NotepadGui = gui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 300)
    frame.Position = UDim2.new(0.5, -200, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

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
        if _G.Nexus.NotepadGui then _G.Nexus.NotepadGui:Destroy() _G.Nexus.NotepadGui = nil end
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
    if _G.Nexus.NotepadGui then _G.Nexus.NotepadGui:Destroy() _G.Nexus.NotepadGui = nil end
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
-- MINIMAP (proper cleanup, no blip leaks)
-- ============================================================
_G.Nexus.MinimapGui = _G.Nexus.MinimapGui or nil
_G.Nexus.MinimapConn = _G.Nexus.MinimapConn or nil
_G.Nexus.MinimapBlips = _G.Nexus.MinimapBlips or {}

_G.Nexus.register("minimap", {}, "minimap", "", "Open a basic minimap of nearby players", function()
    if _G.Nexus.MinimapGui then _G.Nexus.MinimapGui:Destroy() end
    if _G.Nexus.MinimapConn then _G.Nexus.MinimapConn:Disconnect() end
    _G.Nexus.MinimapBlips = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "NexusMinimap"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui
    _G.Nexus.MinimapGui = gui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 200)
    frame.Position = UDim2.new(0, 20, 0, 200)
    frame.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
    frame.BorderSizePixel = 0
    frame.Parent = gui

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

    local range = 100

    _G.Nexus.MinimapConn = RunService.Heartbeat:Connect(function()
        if not gui or not gui.Parent then return end
        local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHRP then return end

        for plr, blip in pairs(_G.Nexus.MinimapBlips) do
            if not plr.Parent or not plr.Character then
                blip:Destroy()
                _G.Nexus.MinimapBlips[plr] = nil
            end
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not _G.Nexus.MinimapBlips[plr] then
                        local blip = Instance.new("Frame")
                        blip.Size = UDim2.new(0, 8, 0, 8)
                        blip.BackgroundColor3 = Color3.fromRGB(240, 79, 88)
                        blip.BorderSizePixel = 0
                        blip.Parent = frame

                        local bc = Instance.new("UICorner")
                        bc.CornerRadius = UDim.new(1, 0)
                        bc.Parent = blip

                        _G.Nexus.MinimapBlips[plr] = blip
                    end

                    local rel = hrp.Position - myHRP.Position
                    local x = math.clamp(rel.X / range, -1, 1)
                    local z = math.clamp(rel.Z / range, -1, 1)
                    local px = (x + 1) / 2
                    local pz = (z + 1) / 2
                    _G.Nexus.MinimapBlips[plr].Position = UDim2.new(px, -4, pz, -4)
                end
            end
        end
    end)
    notify("Minimap", "Enabled.")
end)

_G.Nexus.register("unminimap", {}, "unminimap", "", "Close the minimap", function()
    if _G.Nexus.MinimapGui then _G.Nexus.MinimapGui:Destroy() _G.Nexus.MinimapGui = nil end
    if _G.Nexus.MinimapConn then _G.Nexus.MinimapConn:Disconnect() _G.Nexus.MinimapConn = nil end
    for plr, b in pairs(_G.Nexus.MinimapBlips) do
        pcall(function() b:Destroy() end)
    end
    _G.Nexus.MinimapBlips = {}
    notify("Minimap", "Closed.")
end)

-- ============================================================
-- ANIMATION PLAYER (actually plays animations now)
-- ============================================================
local currentAnimTrack = nil

_G.Nexus.register("animationplayer", {"animplayer", "playanim"}, "animationplayer <id>", "<id>", "Play an animation by asset ID on your character", function(target, args)
    local id = tonumber(target) or tonumber(args[1])
    if not id then
        -- No id, so print the list of animations found
        local anims = {}
        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("Animation") then
                table.insert(anims, obj.AnimationId)
            end
        end
        notify("AnimationPlayer", "Found " .. #anims .. " animations. Use animationplayer <id> to play one.")
        for _, a in ipairs(anims) do print("[Nexus AnimPlayer] " .. a) end
        return
    end

    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end

    if currentAnimTrack then
        pcall(function() currentAnimTrack:Stop() end)
        currentAnimTrack = nil
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. id
    local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
    if ok and track then
        track:Play()
        currentAnimTrack = track
        notify("AnimationPlayer", "Playing " .. id)
    else
        notify("AnimationPlayer", "Failed to load animation " .. id)
    end
end)

_G.Nexus.register("stopanimations", {"stopanims"}, "stopanimations", "", "Stop the currently playing animation", function()
    if currentAnimTrack then
        pcall(function() currentAnimTrack:Stop() end)
        currentAnimTrack = nil
        notify("AnimationPlayer", "Stopped.")
    else
        notify("AnimationPlayer", "No animation playing.")
    end
end)

print("[Nexus] Batch 12 loaded. Misc II (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 13: SERVER II (FIXED, FINAL)
-- joinjobid, joinserver, joingame, copytptogame,
-- copytptoserver, reserve, teleportgui, unteleportgui,
-- serverlist
-- ============================================================

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local function notify(title, text)
    if _G.Nexus.notify then _G.Nexus.notify(title, text) end
end

-- ============================================================
-- JOINJOBID
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
-- JOINSERVER
-- ============================================================
_G.Nexus.register("joinserver", {"joinjid"}, "joinserver <jobid>", "<jobid>", "Join a server by JobId", function(target)
    if not target then notify("JoinServer", "Provide a JobId.") return end
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, target, LocalPlayer)
    end)
    notify("JoinServer", "Joining...")
end)

-- ============================================================
-- JOINGAME
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
-- COPYTPTOGAME
-- ============================================================
_G.Nexus.register("copytptogame", {"cttg"}, "copytptogame", "", "Copy a script that teleports you to this game", function()
    local str = string.format([[-- Nexus teleport script for game %d
local TeleportService = game:GetService("TeleportService")
TeleportService:Teleport(%d, game.Players.LocalPlayer)]], game.PlaceId, game.PlaceId)
    pcall(function() if setclipboard then setclipboard(str) end end)
    notify("CopyTpToGame", "Script copied (PlaceId " .. game.PlaceId .. ")")
end)

-- ============================================================
-- COPYTPTOSERVER
-- ============================================================
_G.Nexus.register("copytptoserver", {"ctts"}, "copytptoserver", "", "Copy a script that teleports you to this exact server", function()
    local str = string.format([[-- Nexus teleport script for server %s
local TeleportService = game:GetService("TeleportService")
TeleportService:TeleportToPlaceInstance(%d, "%s", game.Players.LocalPlayer)]], game.JobId, game.PlaceId, game.JobId)
    pcall(function() if setclipboard then setclipboard(str) end end)
    notify("CopyTpToServer", "Script copied.")
end)

-- ============================================================
-- RESERVE (reserves and joins the private server)
-- ============================================================
_G.Nexus.register("reserve", {"reserveserver", "rs"}, "reserve", "", "Reserve a private server and teleport into it", function()
    local ok, code, err = pcall(function()
        return TeleportService:ReserveServer(game.PlaceId)
    end)
    if ok and code then
        notify("Reserve", "Reserved. Teleporting...")
        task.wait(1)
        local ok2, err2 = pcall(function()
            TeleportService:TeleportToPrivateServer(game.PlaceId, code, {LocalPlayer})
        end)
        if not ok2 then
            notify("Reserve", "Failed to join: " .. tostring(err2))
        end
    else
        notify("Reserve", "Failed: " .. tostring(code or err))
    end
end)

-- ============================================================
-- TELEPORT GUI
-- ============================================================
_G.Nexus.TeleportGui = _G.Nexus.TeleportGui or nil

local function buildTeleportGui()
    if _G.Nexus.TeleportGui then _G.Nexus.TeleportGui:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "NexusTeleportGui"
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui
    _G.Nexus.TeleportGui = gui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 180)
    frame.Position = UDim2.new(0.5, -200, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(17, 17, 20)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui

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
        if _G.Nexus.TeleportGui then _G.Nexus.TeleportGui:Destroy() _G.Nexus.TeleportGui = nil end
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
end

_G.Nexus.register("teleportgui", {"tpui"}, "teleportgui", "", "Open a UI to teleport to any PlaceId", function()
    buildTeleportGui()
    notify("TeleportGui", "Opened.")
end)

_G.Nexus.register("unteleportgui", {"untpui"}, "unteleportgui", "", "Close the teleport GUI", function()
    if _G.Nexus.TeleportGui then _G.Nexus.TeleportGui:Destroy() _G.Nexus.TeleportGui = nil end
    notify("TeleportGui", "Closed.")
end)

-- ============================================================
-- SERVERLIST
-- ============================================================
_G.Nexus.register("serverlist", {"slist"}, "serverlist", "", "List active servers for this place in the console", function()
    local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if not ok or not res then
        notify("ServerList", "HTTP request failed.")
        return
    end
    local decoded = nil
    pcall(function() decoded = HttpService:JSONDecode(res) end)
    if not decoded then
        notify("ServerList", "Bad JSON response.")
        return
    end
    local list = decoded.data or {}
    print("[Nexus ServerList] " .. #list .. " servers found:")
    for _, s in ipairs(list) do
        print("  JobId: " .. s.id .. " | Playing: " .. s.playing .. "/" .. s.maxPlayers)
    end
    notify("ServerList", #list .. " servers printed to console.")
end)

print("[Nexus] Batch 13 loaded. Server II (fixed, final) ready.")
-- ============================================================
-- NEXUS - BATCH 14: FUN / MISC III (FIXED)
-- hamster, unhamster, cig, uncig, cigar, uncigar, pipe, unpipe,
-- oofspam, unoofspam, firework, unfirework, confetti,
-- unconfetti, seizure, unseizure
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
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
-- HAMSTER
-- ============================================================
_G.Nexus.HamsterBall = _G.Nexus.HamsterBall or nil

_G.Nexus.register("hamster", {"hamsterball"}, "hamster", "", "Roll yourself in a hamster ball", function()
    if _G.Nexus.HamsterBall then
        notify("Hamster", "Already enabled.")
        return
    end
    local hrp = getHRP()
    if not hrp then return end

    local ball = Instance.new("Part")
    ball.Name = "NexusHamsterBall"
    ball.Shape = Enum.PartType.Ball
    ball.Size = Vector3.new(10, 10, 10)
    ball.Anchored = false
    ball.CanCollide = false
    ball.Massless = false
    ball.Material = Enum.Material.ForceField
    ball.Color = Color3.fromRGB(61, 214, 140)
    ball.Transparency = 0.5
    ball.CFrame = hrp.CFrame
    ball.Parent = Workspace

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = hrp
    weld.Part1 = ball
    weld.Parent = ball

    _G.Nexus.HamsterBall = ball
    notify("Hamster", "Enabled.")
end)

_G.Nexus.register("unhamster", {"unhamsterball"}, "unhamster", "", "Stop being a hamster", function()
    if _G.Nexus.HamsterBall then
        pcall(function() _G.Nexus.HamsterBall:Destroy() end)
        _G.Nexus.HamsterBall = nil
    end
    notify("Hamster", "Disabled.")
end)

-- ============================================================
-- CIG / CIGAR / PIPE (single cleanup function each)
-- ============================================================
_G.Nexus.CigPart = _G.Nexus.CigPart or nil
_G.Nexus.CigarPart = _G.Nexus.CigarPart or nil
_G.Nexus.PipeParts = _G.Nexus.PipeParts or {}

local function clearCig()
    if _G.Nexus.CigPart then
        pcall(function() _G.Nexus.CigPart:Destroy() end)
        _G.Nexus.CigPart = nil
    end
end

local function clearCigar()
    if _G.Nexus.CigarPart then
        pcall(function() _G.Nexus.CigarPart:Destroy() end)
        _G.Nexus.CigarPart = nil
    end
end

local function clearPipe()
    for _, p in ipairs(_G.Nexus.PipeParts) do
        pcall(function() p:Destroy() end)
    end
    _G.Nexus.PipeParts = {}
end

_G.Nexus.register("cig", {"cigarette"}, "cig", "", "Give yourself a cigarette", function()
    clearCig()
    local char = getChar()
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local part = Instance.new("Part")
    part.Name = "NexusCig"
    part.Size = Vector3.new(0.2, 0.2, 1.2)
    part.Color = Color3.fromRGB(240, 240, 240)
    part.Material = Enum.Material.SmoothPlastic
    part.CanCollide = false
    part.Massless = true
    part.CFrame = head.CFrame * CFrame.new(0.6, -0.4, -0.6)
    part.Parent = char

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = part
    weld.Parent = part

    local tip = Instance.new("PointLight")
    tip.Brightness = 2
    tip.Range = 5
    tip.Color = Color3.fromRGB(255, 80, 80)
    tip.Parent = part

    _G.Nexus.CigPart = part
    notify("Cig", "Enjoy.")
end)

_G.Nexus.register("uncig", {}, "uncig", "", "Remove the cig", function()
    clearCig()
    notify("Cig", "Removed.")
end)

_G.Nexus.register("cigar", {}, "cigar", "", "Give yourself a fat cigar", function()
    clearCigar()
    local char = getChar()
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local part = Instance.new("Part")
    part.Name = "NexusCigar"
    part.Size = Vector3.new(0.4, 0.4, 1.6)
    part.Color = Color3.fromRGB(80, 50, 30)
    part.Material = Enum.Material.SmoothPlastic
    part.CanCollide = false
    part.Massless = true
    part.CFrame = head.CFrame * CFrame.new(0.6, -0.4, -0.8)
    part.Parent = char

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = head
    weld.Part1 = part
    weld.Parent = part

    _G.Nexus.CigarPart = part
    notify("Cigar", "Boss mode.")
end)

_G.Nexus.register("uncigar", {}, "uncigar", "", "Remove the cigar", function()
    clearCigar()
    notify("Cigar", "Removed.")
end)

_G.Nexus.register("pipe", {}, "pipe", "", "Give yourself a smoking pipe", function()
    clearPipe()
    local char = getChar()
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local pipe = Instance.new("Part")
    pipe.Name = "NexusPipe"
    pipe.Size = Vector3.new(0.3, 0.3, 1)
    pipe.Color = Color3.fromRGB(60, 30, 20)
    pipe.Material = Enum.Material.Wood
    pipe.CanCollide = false
    pipe.Massless = true
    pipe.CFrame = head.CFrame * CFrame.new(0.6, -0.4, -0.8)
    pipe.Parent = char

    local bowl = Instance.new("Part")
    bowl.Name = "NexusPipeBowl"
    bowl.Size = Vector3.new(0.5, 0.5, 0.5)
    bowl.Color = Color3.fromRGB(40, 20, 10)
    bowl.Material = Enum.Material.Wood
    bowl.CanCollide = false
    bowl.Massless = true
    bowl.CFrame = pipe.CFrame * CFrame.new(0, 0.3, -0.5)
    bowl.Parent = char

    local weld1 = Instance.new("WeldConstraint")
    weld1.Part0 = head
    weld1.Part1 = pipe
    weld1.Parent = pipe

    local weld2 = Instance.new("WeldConstraint")
    weld2.Part0 = pipe
    weld2.Part1 = bowl
    weld2.Parent = bowl

    _G.Nexus.PipeParts = { pipe, bowl }
    notify("Pipe", "Chill.")
end)

_G.Nexus.register("unpipe", {}, "unpipe", "", "Remove the pipe", function()
    clearPipe()
    notify("Pipe", "Removed.")
end)

-- ============================================================
-- OOF SPAM (sounds tracked and cleaned on stop)
-- ============================================================
local oofSpamActive = false
local oofSpamThread = nil
local oofSounds = {}

local function clearOofSounds()
    for _, s in ipairs(oofSounds) do
        pcall(function() s:Destroy() end)
    end
    oofSounds = {}
end

_G.Nexus.register("oofspam", {}, "oofspam", "", "Spam the oof sound", function()
    if oofSpamActive then
        notify("OofSpam", "Already enabled.")
        return
    end
    oofSpamActive = true
    local soundId = "rbxassetid://3439874943"

    oofSpamThread = task.spawn(function()
        while oofSpamActive do
            local hrp = getHRP()
            if hrp then
                local s = Instance.new("Sound")
                s.SoundId = soundId
                s.Volume = 2
                s.Parent = hrp
                s:Play()
                table.insert(oofSounds, s)
                task.delay(2, function()
                    pcall(function() s:Destroy() end)
                end)
            end
            task.wait(0.5)
        end
    end)
    notify("OofSpam", "Enabled.")
end)

_G.Nexus.register("unoofspam", {}, "unoofspam", "", "Stop oof spam", function()
    oofSpamActive = false
    if oofSpamThread then
        pcall(function() task.cancel(oofSpamThread) end)
        oofSpamThread = nil
    end
    clearOofSounds()
    notify("OofSpam", "Disabled.")
end)

-- ============================================================
-- FIREWORK (tracked parts)
-- ============================================================
_G.Nexus.FireworkParts = _G.Nexus.FireworkParts or {}

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

    table.insert(_G.Nexus.FireworkParts, part)

    task.delay(0.3, function()
        emitter.Enabled = false
        task.delay(2, function()
            pcall(function() part:Destroy() end)
        end)
    end)
end

_G.Nexus.register("firework", {"fw"}, "firework", "", "Spawn a firework above you", function()
    spawnFirework()
    notify("Firework", "Boom.")
end)

_G.Nexus.register("unfirework", {"unfw"}, "unfirework", "", "Remove all fireworks", function()
    for _, p in ipairs(_G.Nexus.FireworkParts) do
        pcall(function() p:Destroy() end)
    end
    _G.Nexus.FireworkParts = {}
    notify("Firework", "Cleared.")
end)

-- ============================================================
-- CONFETTI (active flag + thread)
-- ============================================================
local confettiActive = false
local confettiThread = nil

_G.Nexus.register("confetti", {"party"}, "confetti", "", "Rain confetti everywhere", function()
    if confettiActive then
        notify("Confetti", "Already enabled.")
        return
    end
    confettiActive = true

    confettiThread = task.spawn(function()
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
    if confettiThread then
        pcall(function() task.cancel(confettiThread) end)
        confettiThread = nil
    end
    notify("Confetti", "Stopped.")
end)

-- ============================================================
-- SEIZURE (saves original and restores it)
-- ============================================================
local seizureConn = nil
local seizureOriginal = nil

_G.Nexus.register("seizure", {}, "seizure", "", "Make the lighting flash rapidly", function()
    if seizureConn then
        notify("Seizure", "Already enabled.")
        return
    end
    if not seizureOriginal then
        seizureOriginal = {
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
        }
    end
    seizureConn = RunService.Heartbeat:Connect(function()
        Lighting.Ambient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        Lighting.OutdoorAmbient = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    end)
    notify("Seizure", "Enabled.")
end)

_G.Nexus.register("unseizure", {}, "unseizure", "", "Stop the seizure", function()
    if seizureConn then
        seizureConn:Disconnect()
        seizureConn = nil
    end
    if seizureOriginal then
        Lighting.Ambient = seizureOriginal.Ambient
        Lighting.OutdoorAmbient = seizureOriginal.OutdoorAmbient
        seizureOriginal = nil
    else
        Lighting.Ambient = Color3.fromRGB(70, 70, 70)
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
    notify("Seizure", "Disabled.")
end)

print("[Nexus] Batch 14 loaded. Fun / Misc III (fixed) ready.")
-- ============================================================
-- NEXUS - BATCH 15: MISC IV (FIXED - FINAL)
-- shaders, unshaders, improvetextures, undotextures,
-- antiflingparts, unantiflingparts, vehiclenoclip, vehicleclip,
-- vehiclespeed, unvehiclespeed, gravity, ungravity,
-- freezeunanchored, thawunanchored
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
-- SHADERS
-- ============================================================
local shaderOriginal = nil

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
        shaderOriginal = nil
    end
    notify("Shaders", "Disabled.")
end)

-- ============================================================
-- IMPROVE TEXTURES (saves originals so it can be undone)
-- ============================================================
_G.Nexus.ImprovedMaterials = _G.Nexus.ImprovedMaterials or nil

_G.Nexus.register("improvetextures", {"hdtextures"}, "improvetextures", "", "Force higher quality textures on every part", function()
    if _G.Nexus.ImprovedMaterials then
        notify("ImproveTextures", "Already applied. Use undotextures first.")
        return
    end
    _G.Nexus.ImprovedMaterials = {}
    local count = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            _G.Nexus.ImprovedMaterials[obj] = obj.Material
            obj.Material = Enum.Material.SmoothPlastic
            count = count + 1
        end
    end
    notify("ImproveTextures", "Applied to " .. count .. " parts.")
end)

_G.Nexus.register("undotextures", {"restoretextures"}, "undotextures", "", "Restore original materials", function()
    if not _G.Nexus.ImprovedMaterials then
        notify("ImproveTextures", "Nothing to restore.")
        return
    end
    local count = 0
    for part, mat in pairs(_G.Nexus.ImprovedMaterials) do
        pcall(function()
            if part and part.Parent then
                part.Material = mat
                count = count + 1
            end
        end)
    end
    _G.Nexus.ImprovedMaterials = nil
    notify("ImproveTextures", "Restored " .. count .. " parts.")
end)

-- ============================================================
-- ANTIFLINGPARTS
-- ============================================================
local antiflingPartsConn = nil

_G.Nexus.register("antiflingparts", {"afparts"}, "antiflingparts", "", "Become uncollidable to fast-moving parts", function()
    if antiflingPartsConn then
        notify("AntiFlingParts", "Already enabled.")
        return
    end
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
    if antiflingPartsConn then
        antiflingPartsConn:Disconnect()
        antiflingPartsConn = nil
    end
    notify("AntiFlingParts", "Disabled.")
end)

-- ============================================================
-- VEHICLE NOCLIP
-- ============================================================
local vehicleNoclipConn = nil

_G.Nexus.register("vehiclenoclip", {"vnoclip"}, "vehiclenoclip", "", "Disable collision on the vehicle you are in", function()
    if vehicleNoclipConn then
        notify("VehicleNoclip", "Already enabled.")
        return
    end
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
    if vehicleNoclipConn then
        vehicleNoclipConn:Disconnect()
        vehicleNoclipConn = nil
    end
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
local vehicleSpeedConn = nil

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
    if vehicleSpeedConn then
        vehicleSpeedConn:Disconnect()
        vehicleSpeedConn = nil
    end
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
-- FREEZE UNANCHORED (only freezes parts that were not already anchored)
-- ============================================================
local frozenParts = nil

_G.Nexus.register("freezeunanchored", {"fua"}, "freezeunanchored", "", "Freeze every unanchored part in the workspace", function()
    if frozenParts then
        notify("FreezeUnanchored", "Already frozen. Use thawunanchored first.")
        return
    end
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
    if not frozenParts then
        notify("FreezeUnanchored", "Nothing to thaw.")
        return
    end
    local count = 0
    for _, obj in ipairs(frozenParts) do
        pcall(function()
            if obj and obj.Parent then
                obj.Anchored = false
                count = count + 1
            end
        end)
    end
    frozenParts = nil
    notify("FreezeUnanchored", "Thawed " .. count .. " parts.")
end)

print("[Nexus] Batch 15 loaded. Misc IV (fixed) ready. ALL BATCHES COMPLETE.")