-- // ================================================
-- //   MOON HUB - Grow a Garden
-- //   Dummy Item Spawner (Visual Only / Local)
-- //   ⚠️ Hanya terlihat di layar sendiri
-- // ================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function GetChar() return LocalPlayer.Character end
local function GetHRP() local c = GetChar() return c and c:FindFirstChild("HumanoidRootPart") end

local function Notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title, Text = text, Duration = 3
        })
    end)
end

local SpawnedItems = {}

-- Item Data
local Items = {
    Seeds = {
        {name = "Carrot Seed", color = Color3.fromRGB(255,140,0), icon = "🥕", shape = "ball"},
        {name = "Strawberry Seed", color = Color3.fromRGB(255,60,80), icon = "🍓", shape = "ball"},
        {name = "Blueberry Seed", color = Color3.fromRGB(80,80,255), icon = "🫐", shape = "ball"},
        {name = "Tomato Seed", color = Color3.fromRGB(220,50,50), icon = "🍅", shape = "ball"},
        {name = "Corn Seed", color = Color3.fromRGB(255,220,0), icon = "🌽", shape = "ball"},
        {name = "Watermelon Seed", color = Color3.fromRGB(80,200,80), icon = "🍉", shape = "ball"},
        {name = "Pumpkin Seed", color = Color3.fromRGB(255,120,30), icon = "🎃", shape = "ball"},
        {name = "Grape Seed", color = Color3.fromRGB(160,80,200), icon = "🍇", shape = "ball"},
        {name = "Sunflower Seed", color = Color3.fromRGB(255,230,0), icon = "🌻", shape = "ball"},
        {name = "Rose Seed", color = Color3.fromRGB(255,80,120), icon = "🌹", shape = "ball"},
    },
    Eggs = {
        {name = "Common Egg", color = Color3.fromRGB(200,200,200), icon = "🥚", shape = "egg"},
        {name = "Rare Egg", color = Color3.fromRGB(80,120,255), icon = "🥚", shape = "egg"},
        {name = "Epic Egg", color = Color3.fromRGB(180,80,255), icon = "🥚", shape = "egg"},
        {name = "Legendary Egg", color = Color3.fromRGB(255,200,0), icon = "🥚", shape = "egg"},
        {name = "Mythical Egg", color = Color3.fromRGB(255,80,80), icon = "🥚", shape = "egg"},
        {name = "Divine Egg", color = Color3.fromRGB(255,255,255), icon = "🥚", shape = "egg"},
    },
    Sprinklers = {
        {name = "Basic Sprinkler", color = Color3.fromRGB(100,180,255), icon = "💧", shape = "box"},
        {name = "Advanced Sprinkler", color = Color3.fromRGB(0,120,255), icon = "💦", shape = "box"},
        {name = "Golden Sprinkler", color = Color3.fromRGB(255,200,0), icon = "✨", shape = "box"},
        {name = "Master Sprinkler", color = Color3.fromRGB(255,80,80), icon = "🌊", shape = "box"},
    },
}

-- Spawn dummy item di depan karakter
local function SpawnDummyItem(itemData)
    local hrp = GetHRP()
    if not hrp then return end

    local part = Instance.new("Part")
    part.Name = "DummyItem_" .. itemData.name
    part.Anchored = false
    part.CanCollide = false
    part.Material = Enum.Material.SmoothPlastic
    part.BrickColor = BrickColor.new(itemData.color)
    part.Color = itemData.color

    if itemData.shape == "ball" then
        part.Shape = Enum.PartType.Ball
        part.Size = Vector3.new(0.8, 0.8, 0.8)
    elseif itemData.shape == "egg" then
        part.Shape = Enum.PartType.Ball
        part.Size = Vector3.new(0.7, 0.9, 0.7)
    else
        part.Shape = Enum.PartType.Block
        part.Size = Vector3.new(0.8, 0.6, 0.8)
    end

    -- Spawn di depan karakter
    local spawnPos = hrp.CFrame * CFrame.new(0, 1, -3)
    part.CFrame = spawnPos
    part.Parent = workspace

    -- Label nama
    local bill = Instance.new("BillboardGui", part)
    bill.Size = UDim2.new(0, 100, 0, 30)
    bill.StudsOffset = Vector3.new(0, 1.2, 0)
    bill.AlwaysOnTop = true

    local bg = Instance.new("Frame", bill)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(10,10,16)
    bg.BackgroundTransparency = 0.3
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
    local bgStroke = Instance.new("UIStroke", bg)
    bgStroke.Color = itemData.color
    bgStroke.Thickness = 1

    local label = Instance.new("TextLabel", bg)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = itemData.icon .. " " .. itemData.name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 9
    label.TextColor3 = itemData.color
    label.TextScaled = false

    -- Glow effect
    local light = Instance.new("PointLight", part)
    light.Color = itemData.color
    light.Brightness = 2
    light.Range = 5

    -- Float animation
    local float = Instance.new("BodyPosition", part)
    float.MaxForce = Vector3.new(0, 5000, 0)
    float.D = 500

    local baseY = part.Position.Y
    local t = 0
    local conn
    conn = game:GetService("RunService").Heartbeat:Connect(function(dt)
        t = t + dt
        if part and part.Parent then
            float.Position = Vector3.new(part.Position.X, baseY + math.sin(t * 2) * 0.3, part.Position.Z)
        else
            conn:Disconnect()
        end
    end)

    table.insert(SpawnedItems, part)
    Notify(itemData.icon .. " Spawned", itemData.name .. " muncul di depanmu!")
    return part
end

local function ClearAllItems()
    for _, item in pairs(SpawnedItems) do
        if item and item.Parent then item:Destroy() end
    end
    SpawnedItems = {}
    Notify("🗑️ Clear", "Semua item dihapus!")
end

-- ================================================
-- GUI
-- ================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoonHubSpawner"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

local Window = Instance.new("Frame", ScreenGui)
Window.Size = UDim2.new(0, 540, 0, 400)
Window.Position = UDim2.new(0.5, -270, 0.5, -200)
Window.BackgroundColor3 = Color3.fromRGB(13, 13, 18)
Window.BorderSizePixel = 0
Window.Active = true
Window.Draggable = true
Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 12)
local WStroke = Instance.new("UIStroke", Window)
WStroke.Color = Color3.fromRGB(60, 180, 80)
WStroke.Thickness = 1.2

-- Top Bar
local TopBar = Instance.new("Frame", Window)
TopBar.Size = UDim2.new(1, 0, 0, 36)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
TopBar.BorderSizePixel = 0
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local TopTitle = Instance.new("TextLabel", TopBar)
TopTitle.Size = UDim2.new(1, -80, 1, 0)
TopTitle.Position = UDim2.new(0, 14, 0, 0)
TopTitle.BackgroundTransparency = 1
TopTitle.Text = "🌕  Moon Hub  |  Item Spawner  ⚠️ Visual Only"
TopTitle.Font = Enum.Font.GothamBold
TopTitle.TextSize = 12
TopTitle.TextColor3 = Color3.fromRGB(200, 255, 180)
TopTitle.TextXAlignment = Enum.TextXAlignment.Left

local function MakeTopBtn(pos, color, txt)
    local b = Instance.new("TextButton", TopBar)
    b.Size = UDim2.new(0, 18, 0, 18)
    b.Position = UDim2.new(1, pos, 0.5, -9)
    b.BackgroundColor3 = color
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextSize = 10
    b.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    return b
end
local CloseBtn = MakeTopBtn(-12, Color3.fromRGB(255,60,60), "✕")
local MinBtn = MakeTopBtn(-36, Color3.fromRGB(255,180,0), "−")

-- Sidebar
local Sidebar = Instance.new("Frame", Window)
Sidebar.Size = UDim2.new(0, 135, 1, -36)
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)
local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 3)
SideLayout.SortOrder = Enum.SortOrder.LayoutOrder
local SidePad = Instance.new("UIPadding", Sidebar)
SidePad.PaddingTop = UDim.new(0, 10)
SidePad.PaddingLeft = UDim.new(0, 8)
SidePad.PaddingRight = UDim.new(0, 8)

-- Content
local Content = Instance.new("Frame", Window)
Content.Size = UDim2.new(1, -143, 1, -44)
Content.Position = UDim2.new(0, 139, 0, 40)
Content.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
Content.BorderSizePixel = 0
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

local Pages = {}
local SideBtns = {}
local CurrentPage = nil

local function NewPage(name)
    local page = Instance.new("ScrollingFrame", Content)
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = Color3.fromRGB(60, 180, 80)
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    local layout = Instance.new("UIListLayout", page)
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 10)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20)
    end)
    Pages[name] = page
    return page
end

local function SideLabel(txt)
    local l = Instance.new("TextLabel", Sidebar)
    l.Size = UDim2.new(1, 0, 0, 20)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.Font = Enum.Font.GothamBold
    l.TextSize = 9
    l.TextColor3 = Color3.fromRGB(60, 140, 60)
    l.TextXAlignment = Enum.TextXAlignment.Left
end

local function SideBtn(icon, label, pageName)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    local IconL = Instance.new("TextLabel", Btn)
    IconL.Size = UDim2.new(0, 24, 1, 0)
    IconL.Position = UDim2.new(0, 4, 0, 0)
    IconL.BackgroundTransparency = 1
    IconL.Text = icon
    IconL.TextSize = 15
    IconL.Font = Enum.Font.GothamBold
    IconL.TextColor3 = Color3.fromRGB(100, 180, 100)

    local NameL = Instance.new("TextLabel", Btn)
    NameL.Size = UDim2.new(1, -32, 1, 0)
    NameL.Position = UDim2.new(0, 30, 0, 0)
    NameL.BackgroundTransparency = 1
    NameL.Text = label
    NameL.Font = Enum.Font.GothamSemibold
    NameL.TextSize = 11
    NameL.TextColor3 = Color3.fromRGB(160, 200, 160)
    NameL.TextXAlignment = Enum.TextXAlignment.Left

    local Dot = Instance.new("Frame", Btn)
    Dot.Size = UDim2.new(0, 3, 0.5, 0)
    Dot.Position = UDim2.new(0, -8, 0.25, 0)
    Dot.BackgroundColor3 = Color3.fromRGB(80, 200, 80)
    Dot.Visible = false
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local function SetActive(v)
        if v then
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(20,35,20)}):Play()
            NameL.TextColor3 = Color3.fromRGB(150,255,150)
            IconL.TextColor3 = Color3.fromRGB(100,220,100)
            Dot.Visible = true
        else
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
            NameL.TextColor3 = Color3.fromRGB(160,200,160)
            IconL.TextColor3 = Color3.fromRGB(100,180,100)
            Dot.Visible = false
        end
    end

    SideBtns[pageName] = SetActive
    Btn.MouseButton1Click:Connect(function()
        if CurrentPage then
            Pages[CurrentPage].Visible = false
            if SideBtns[CurrentPage] then SideBtns[CurrentPage](false) end
        end
        CurrentPage = pageName
        Pages[pageName].Visible = true
        SetActive(true)
    end)
    Btn.MouseEnter:Connect(function()
        if CurrentPage ~= pageName then
            Btn.BackgroundTransparency = 0.6
            Btn.BackgroundColor3 = Color3.fromRGB(20,35,20)
        end
    end)
    Btn.MouseLeave:Connect(function()
        if CurrentPage ~= pageName then Btn.BackgroundTransparency = 1 end
    end)
end

local function SectionHeader(page, txt)
    local L = Instance.new("TextLabel", page)
    L.Size = UDim2.new(1, 0, 0, 20)
    L.BackgroundTransparency = 1
    L.Text = txt
    L.Font = Enum.Font.GothamBold
    L.TextSize = 10
    L.TextColor3 = Color3.fromRGB(60, 160, 60)
    L.TextXAlignment = Enum.TextXAlignment.Left
end

-- Item Button
local function ItemBtn(page, itemData)
    local Row = Instance.new("TextButton", page)
    Row.Size = UDim2.new(1, 0, 0, 44)
    Row.BackgroundColor3 = Color3.fromRGB(18, 24, 18)
    Row.BackgroundTransparency = 0.2
    Row.Text = ""
    Row.AutoButtonColor = false
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)
    local RStroke = Instance.new("UIStroke", Row)
    RStroke.Color = itemData.color
    RStroke.Thickness = 1
    RStroke.Transparency = 0.7

    local IconL = Instance.new("TextLabel", Row)
    IconL.Size = UDim2.new(0, 34, 1, 0)
    IconL.Position = UDim2.new(0, 8, 0, 0)
    IconL.BackgroundTransparency = 1
    IconL.Text = itemData.icon
    IconL.TextSize = 20
    IconL.Font = Enum.Font.GothamBold
    IconL.TextColor3 = Color3.fromRGB(255,255,255)

    local NameL = Instance.new("TextLabel", Row)
    NameL.Size = UDim2.new(1, -100, 1, 0)
    NameL.Position = UDim2.new(0, 46, 0, 0)
    NameL.BackgroundTransparency = 1
    NameL.Text = itemData.name
    NameL.Font = Enum.Font.GothamSemibold
    NameL.TextSize = 13
    NameL.TextColor3 = itemData.color
    NameL.TextXAlignment = Enum.TextXAlignment.Left

    local SpawnBtn = Instance.new("TextButton", Row)
    SpawnBtn.Size = UDim2.new(0, 65, 0, 26)
    SpawnBtn.Position = UDim2.new(1, -74, 0.5, -13)
    SpawnBtn.BackgroundColor3 = itemData.color
    SpawnBtn.Text = "SPAWN"
    SpawnBtn.Font = Enum.Font.GothamBold
    SpawnBtn.TextSize = 11
    SpawnBtn.TextColor3 = Color3.fromRGB(0,0,0)
    Instance.new("UICorner", SpawnBtn).CornerRadius = UDim.new(0, 6)

    Row.MouseEnter:Connect(function()
        TweenService:Create(Row, TweenInfo.new(0.15), {BackgroundTransparency = 0.05, BackgroundColor3 = Color3.fromRGB(25,35,25)}):Play()
        TweenService:Create(RStroke, TweenInfo.new(0.15), {Transparency = 0.3}):Play()
    end)
    Row.MouseLeave:Connect(function()
        TweenService:Create(Row, TweenInfo.new(0.15), {BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(18,24,18)}):Play()
        TweenService:Create(RStroke, TweenInfo.new(0.15), {Transparency = 0.7}):Play()
    end)

    local function DoSpawn()
        SpawnDummyItem(itemData)
        SpawnBtn.Text = "✓"
        task.wait(1)
        SpawnBtn.Text = "SPAWN"
    end

    Row.MouseButton1Click:Connect(DoSpawn)
    SpawnBtn.MouseButton1Click:Connect(DoSpawn)
end

-- ================================================
-- PAGES
-- ================================================
SideLabel("  SPAWNER")
SideBtn("🌱", "Seed", "Seeds")
SideBtn("🥚", "Egg", "Eggs")
SideBtn("💧", "Sprinkler", "Sprinklers")
SideLabel("  TOOLS")
SideBtn("🗑️", "Clear All", "Clear")
SideBtn("ℹ️", "Info", "Info")

-- SEEDS PAGE
local SeedsPage = NewPage("Seeds")
SectionHeader(SeedsPage, "  🌱 SEED SPAWNER")
for _, item in pairs(Items.Seeds) do
    ItemBtn(SeedsPage, item)
end

-- EGGS PAGE
local EggsPage = NewPage("Eggs")
SectionHeader(EggsPage, "  🥚 EGG SPAWNER")
for _, item in pairs(Items.Eggs) do
    ItemBtn(EggsPage, item)
end

-- SPRINKLERS PAGE
local SprinklersPage = NewPage("Sprinklers")
SectionHeader(SprinklersPage, "  💧 SPRINKLER SPAWNER")
for _, item in pairs(Items.Sprinklers) do
    ItemBtn(SprinklersPage, item)
end

-- CLEAR PAGE
local ClearPage = NewPage("Clear")
SectionHeader(ClearPage, "  🗑️ CLEAR ITEMS")

local WarningBox = Instance.new("Frame", ClearPage)
WarningBox.Size = UDim2.new(1, 0, 0, 60)
WarningBox.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
WarningBox.BackgroundTransparency = 0.3
Instance.new("UICorner", WarningBox).CornerRadius = UDim.new(0, 8)
local WStroke2 = Instance.new("UIStroke", WarningBox)
WStroke2.Color = Color3.fromRGB(255,80,80) WStroke2.Thickness = 1 WStroke2.Transparency = 0.5
local WarnText = Instance.new("TextLabel", WarningBox)
WarnText.Size = UDim2.new(1,-16,1,-16) WarnText.Position = UDim2.new(0,8,0,8)
WarnText.BackgroundTransparency = 1
WarnText.Text = "⚠️ Semua item visual yang sudah di-spawn\nakan dihapus dari workspace!"
WarnText.Font = Enum.Font.GothamSemibold WarnText.TextSize = 12
WarnText.TextColor3 = Color3.fromRGB(255,150,150)
WarnText.TextXAlignment = Enum.TextXAlignment.Left WarnText.TextYAlignment = Enum.TextYAlignment.Top

local ClearAllBtn = Instance.new("TextButton", ClearPage)
ClearAllBtn.Size = UDim2.new(1, 0, 0, 44)
ClearAllBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
ClearAllBtn.Text = "🗑️ Hapus Semua Item Visual"
ClearAllBtn.Font = Enum.Font.GothamBold
ClearAllBtn.TextSize = 13
ClearAllBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", ClearAllBtn).CornerRadius = UDim.new(0, 8)
ClearAllBtn.MouseButton1Click:Connect(function()
    ClearAllItems()
end)

local CountLabel = Instance.new("TextLabel", ClearPage)
CountLabel.Size = UDim2.new(1, 0, 0, 30)
CountLabel.BackgroundTransparency = 1
CountLabel.Font = Enum.Font.GothamSemibold
CountLabel.TextSize = 12
CountLabel.TextColor3 = Color3.fromRGB(150, 200, 150)
CountLabel.TextXAlignment = Enum.TextXAlignment.Left

game:GetService("RunService").Heartbeat:Connect(function()
    local count = 0
    for _, item in pairs(SpawnedItems) do
        if item and item.Parent then count = count + 1 end
    end
    CountLabel.Text = "  📦 Item aktif: " .. count
end)

-- INFO PAGE
local InfoPage = NewPage("Info")
local IBox = Instance.new("Frame", InfoPage)
IBox.Size = UDim2.new(1,0,0,160)
IBox.BackgroundColor3 = Color3.fromRGB(18,28,18)
IBox.BackgroundTransparency = 0.2
Instance.new("UICorner", IBox).CornerRadius = UDim.new(0,10)
local IStroke = Instance.new("UIStroke",IBox)
IStroke.Color = Color3.fromRGB(60,180,60) IStroke.Thickness=1 IStroke.Transparency=0.5
local IText = Instance.new("TextLabel",IBox)
IText.Size = UDim2.new(1,-20,1,-20) IText.Position = UDim2.new(0,10,0,10)
IText.BackgroundTransparency = 1
IText.Text = "🌕  Moon Hub - Item Spawner\nBy: Mustafa\n\n⚠️ PENTING:\nItem yang di-spawn HANYA VISUAL!\nHanya terlihat di layar kamu sendiri.\nTidak mempengaruhi game server.\n\n✅ Seed, Egg, Sprinkler tersedia\n🌊 Item float & glowing effect\n🗑️ Bisa dihapus kapan saja"
IText.Font = Enum.Font.GothamSemibold IText.TextSize = 11
IText.TextColor3 = Color3.fromRGB(150,220,150)
IText.TextXAlignment = Enum.TextXAlignment.Left
IText.TextYAlignment = Enum.TextYAlignment.Top

-- ================================================
-- OPEN BUTTON & CONTROLS
-- ================================================
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0,46,0,46)
OpenBtn.Position = UDim2.new(0,8,0.5,-23)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15,25,15)
OpenBtn.BackgroundTransparency = 0.1
OpenBtn.Text = "🌕"
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 22
OpenBtn.TextColor3 = Color3.fromRGB(100,220,100)
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(1,0)
local OStroke = Instance.new("UIStroke", OpenBtn)
OStroke.Color = Color3.fromRGB(60,180,60) OStroke.Thickness = 1.5

OpenBtn.MouseButton1Click:Connect(function()
    Window.Visible = true OpenBtn.Visible = false
end)
CloseBtn.MouseButton1Click:Connect(function()
    Window.Visible = false OpenBtn.Visible = true
end)

local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    TweenService:Create(Window, TweenInfo.new(0.3), {
        Size = Minimized and UDim2.new(0,540,0,36) or UDim2.new(0,540,0,400)
    }):Play()
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Window.Visible = not Window.Visible
        OpenBtn.Visible = not Window.Visible
    end
end)

Pages["Seeds"].Visible = true
CurrentPage = "Seeds"
if SideBtns["Seeds"] then SideBtns["Seeds"](true) end

Notify("🌕 Moon Hub", "Item Spawner siap! ⚠️ Visual Only")
