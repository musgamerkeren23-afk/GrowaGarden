-- // ================================================
-- //   MUSTAFA HUB - Grow a Garden
-- //   Fitur: Visual/ESP Tanaman
-- // ================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local ESPEnabled = false
local ESPLabels = {}

local function GetChar() return LocalPlayer.Character end
local function GetHRP() local c = GetChar() return c and c:FindFirstChild("HumanoidRootPart") end

local function Notify(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title, Text = text, Duration = 3
        })
    end)
end

-- Warna tiap jenis tanaman
local PlantColors = {
    ["Carrot"]     = Color3.fromRGB(255, 140, 0),
    ["Strawberry"] = Color3.fromRGB(255, 60, 80),
    ["Blueberry"]  = Color3.fromRGB(80, 80, 255),
    ["Tomato"]     = Color3.fromRGB(220, 50, 50),
    ["Corn"]       = Color3.fromRGB(255, 220, 0),
    ["Watermelon"] = Color3.fromRGB(80, 200, 80),
    ["Pumpkin"]    = Color3.fromRGB(255, 120, 30),
    ["Grape"]      = Color3.fromRGB(160, 80, 200),
    ["Sunflower"]  = Color3.fromRGB(255, 230, 0),
    ["Rose"]       = Color3.fromRGB(255, 80, 120),
    ["Daffodil"]   = Color3.fromRGB(255, 240, 80),
    ["Cactus"]     = Color3.fromRGB(60, 180, 60),
    ["Mushroom"]   = Color3.fromRGB(180, 100, 60),
    ["Bamboo"]     = Color3.fromRGB(100, 200, 80),
    ["Apple"]      = Color3.fromRGB(220, 60, 60),
    ["Mango"]      = Color3.fromRGB(255, 180, 0),
    ["Coconut"]    = Color3.fromRGB(180, 140, 80),
    ["Default"]    = Color3.fromRGB(150, 220, 150),
}

local function GetPlantColor(name)
    for k, v in pairs(PlantColors) do
        if name:lower():find(k:lower()) then return v end
    end
    return PlantColors["Default"]
end

local function GetDistance(part)
    local hrp = GetHRP()
    if hrp and part then
        return math.floor((hrp.Position - part.Position).Magnitude)
    end
    return 0
end

local function ClearESP()
    for _, label in pairs(ESPLabels) do
        if label and label.Parent then label:Destroy() end
    end
    ESPLabels = {}
end

local function CreateESPLabel(part, name)
    local bill = Instance.new("BillboardGui")
    bill.Name = "ESP_" .. name
    bill.Size = UDim2.new(0, 120, 0, 40)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    bill.Parent = part

    local bg = Instance.new("Frame", bill)
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
    bg.BackgroundTransparency = 0.3
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 6)
    local bgStroke = Instance.new("UIStroke", bg)
    bgStroke.Color = GetPlantColor(name)
    bgStroke.Thickness = 1.2
    bgStroke.Transparency = 0.2

    local nameLabel = Instance.new("TextLabel", bg)
    nameLabel.Size = UDim2.new(1, 0, 0.6, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "🌱 " .. name
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 11
    nameLabel.TextColor3 = GetPlantColor(name)
    nameLabel.TextScaled = false

    local distLabel = Instance.new("TextLabel", bg)
    distLabel.Name = "Dist"
    distLabel.Size = UDim2.new(1, 0, 0.4, 0)
    distLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 9
    distLabel.TextColor3 = Color3.fromRGB(180, 180, 200)

    table.insert(ESPLabels, bill)
    return distLabel
end

local function ScanPlants()
    ClearESP()
    if not ESPEnabled then return end

    -- Scan workspace untuk tanaman
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") or obj:IsA("BasePart") then
            local name = obj.Name
            -- Cek nama yang mengandung kata tanaman/plant
            if name:lower():find("plant") or name:lower():find("crop") or name:lower():find("seed")
                or name:lower():find("carrot") or name:lower():find("strawberry")
                or name:lower():find("tomato") or name:lower():find("corn")
                or name:lower():find("blueberry") or name:lower():find("watermelon")
                or name:lower():find("pumpkin") or name:lower():find("grape")
                or name:lower():find("sunflower") or name:lower():find("rose")
                or name:lower():find("apple") or name:lower():find("mango")
                or name:lower():find("mushroom") or name:lower():find("bamboo")
                or name:lower():find("flower") or name:lower():find("fruit")
                or name:lower():find("tree") or name:lower():find("bush") then

                local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if part then
                    CreateESPLabel(part, name)
                end
            end
        end
    end
end

-- Update jarak tiap frame
RunService.RenderStepped:Connect(function()
    if not ESPEnabled then return end
    for _, bill in pairs(ESPLabels) do
        if bill and bill.Parent then
            local dist = bill.Parent
            local distLabel = bill:FindFirstChild("Frame") and bill.Frame:FindFirstChild("Dist")
            if distLabel then
                distLabel.Text = GetDistance(bill.Parent) .. " studs"
            end
        end
    end
end)

-- ================================================
-- GUI
-- ================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GrowGardenESP"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = game.CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer.PlayerGui end

local Window = Instance.new("Frame", ScreenGui)
Window.Size = UDim2.new(0, 520, 0, 360)
Window.Position = UDim2.new(0.5, -260, 0.5, -180)
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
TopTitle.Text = "🌱  Grow a Garden  |  Visual ESP"
TopTitle.Font = Enum.Font.GothamBold
TopTitle.TextSize = 13
TopTitle.TextColor3 = Color3.fromRGB(150, 255, 150)
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
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", page)
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 12)
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

local function ToggleRow(page, icon, title, subtitle, color, callback)
    local Row = Instance.new("Frame", page)
    Row.Size = UDim2.new(1, 0, 0, subtitle and 54 or 44)
    Row.BackgroundColor3 = Color3.fromRGB(18, 24, 18)
    Row.BackgroundTransparency = 0.2
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)

    local IconL = Instance.new("TextLabel", Row)
    IconL.Size = UDim2.new(0, 30, 1, 0)
    IconL.Position = UDim2.new(0, 10, 0, 0)
    IconL.BackgroundTransparency = 1
    IconL.Text = icon
    IconL.TextSize = 18
    IconL.Font = Enum.Font.GothamBold
    IconL.TextColor3 = Color3.fromRGB(255,255,255)

    local TitleL = Instance.new("TextLabel", Row)
    TitleL.Size = UDim2.new(1, -90, 0, 22)
    TitleL.Position = UDim2.new(0, 44, 0, subtitle and 8 or 11)
    TitleL.BackgroundTransparency = 1
    TitleL.Text = title
    TitleL.Font = Enum.Font.GothamSemibold
    TitleL.TextSize = 13
    TitleL.TextColor3 = Color3.fromRGB(210, 240, 210)
    TitleL.TextXAlignment = Enum.TextXAlignment.Left

    if subtitle then
        local SubL = Instance.new("TextLabel", Row)
        SubL.Size = UDim2.new(1, -90, 0, 16)
        SubL.Position = UDim2.new(0, 44, 0, 28)
        SubL.BackgroundTransparency = 1
        SubL.Text = subtitle
        SubL.Font = Enum.Font.Gotham
        SubL.TextSize = 10
        SubL.TextColor3 = Color3.fromRGB(100, 140, 100)
        SubL.TextXAlignment = Enum.TextXAlignment.Left
    end

    local PillBG = Instance.new("Frame", Row)
    PillBG.Size = UDim2.new(0, 44, 0, 24)
    PillBG.Position = UDim2.new(1, -56, 0.5, -12)
    PillBG.BackgroundColor3 = Color3.fromRGB(40, 50, 40)
    Instance.new("UICorner", PillBG).CornerRadius = UDim.new(1, 0)

    local PillDot = Instance.new("Frame", PillBG)
    PillDot.Size = UDim2.new(0, 18, 0, 18)
    PillDot.Position = UDim2.new(0, 3, 0.5, -9)
    PillDot.BackgroundColor3 = Color3.fromRGB(140, 160, 140)
    Instance.new("UICorner", PillDot).CornerRadius = UDim.new(1, 0)

    local toggled = false
    local function Toggle(state)
        toggled = state
        if state then
            TweenService:Create(PillBG, TweenInfo.new(0.2), {BackgroundColor3 = color or Color3.fromRGB(60,180,60)}):Play()
            TweenService:Create(PillDot, TweenInfo.new(0.2), {Position = UDim2.new(0,23,0.5,-9), BackgroundColor3 = Color3.fromRGB(255,255,255)}):Play()
        else
            TweenService:Create(PillBG, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,50,40)}):Play()
            TweenService:Create(PillDot, TweenInfo.new(0.2), {Position = UDim2.new(0,3,0.5,-9), BackgroundColor3 = Color3.fromRGB(140,160,140)}):Play()
        end
    end

    local ClickArea = Instance.new("TextButton", Row)
    ClickArea.Size = UDim2.new(1, 0, 1, 0)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""
    ClickArea.MouseButton1Click:Connect(function()
        toggled = not toggled
        Toggle(toggled)
        if callback then callback(toggled) end
    end)
end

-- ================================================
-- PAGES
-- ================================================
SideLabel("  VISUAL")
SideBtn("👁️", "ESP Tanaman", "ESP")
SideBtn("🎨", "Warna", "Colors")
SideLabel("  INFO")
SideBtn("ℹ️", "About", "About")

-- ESP PAGE
local ESPPage = NewPage("ESP")
SectionHeader(ESPPage, "  VISUAL / ESP TANAMAN")

ToggleRow(ESPPage, "👁️", "ESP Tanaman", "Tampilkan nama & jarak tanaman", Color3.fromRGB(60,200,60), function(v)
    ESPEnabled = v
    if v then
        ScanPlants()
        Notify("👁️ ESP", "Aktif! Scan " .. #ESPLabels .. " tanaman ditemukan")
    else
        ClearESP()
        Notify("👁️ ESP", "Dimatikan")
    end
end)

-- Scan Button
local ScanBtn = Instance.new("TextButton", ESPPage)
ScanBtn.Size = UDim2.new(1, 0, 0, 40)
ScanBtn.BackgroundColor3 = Color3.fromRGB(30, 70, 30)
ScanBtn.Text = "🔍 Scan Ulang Tanaman"
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 13
ScanBtn.TextColor3 = Color3.fromRGB(150, 255, 150)
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 8)
local ScanStroke = Instance.new("UIStroke", ScanBtn)
ScanStroke.Color = Color3.fromRGB(60, 180, 60) ScanStroke.Thickness = 1 ScanStroke.Transparency = 0.5

ScanBtn.MouseButton1Click:Connect(function()
    if not ESPEnabled then
        Notify("❌", "Aktifkan ESP dulu!")
        return
    end
    ScanPlants()
    Notify("🔍 Scan", #ESPLabels .. " tanaman ditemukan!")
end)

-- Count Label
local CountFrame = Instance.new("Frame", ESPPage)
CountFrame.Size = UDim2.new(1, 0, 0, 50)
CountFrame.BackgroundColor3 = Color3.fromRGB(18, 30, 18)
CountFrame.BackgroundTransparency = 0.2
Instance.new("UICorner", CountFrame).CornerRadius = UDim.new(0, 8)
local CStroke = Instance.new("UIStroke", CountFrame)
CStroke.Color = Color3.fromRGB(60,180,60) CStroke.Thickness = 1 CStroke.Transparency = 0.6

local CountLabel = Instance.new("TextLabel", CountFrame)
CountLabel.Size = UDim2.new(1, -16, 1, 0)
CountLabel.Position = UDim2.new(0, 8, 0, 0)
CountLabel.BackgroundTransparency = 1
CountLabel.Text = "🌱 Tanaman terdeteksi: 0\n📍 Update otomatis setiap 5 detik"
CountLabel.Font = Enum.Font.GothamSemibold
CountLabel.TextSize = 12
CountLabel.TextColor3 = Color3.fromRGB(150, 220, 150)
CountLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Auto rescan every 5 seconds
task.spawn(function()
    while task.wait(5) do
        if ESPEnabled then
            ScanPlants()
            CountLabel.Text = "🌱 Tanaman terdeteksi: " .. #ESPLabels .. "\n📍 Update otomatis setiap 5 detik"
        end
    end
end)

-- COLORS PAGE
local ColorsPage = NewPage("Colors")
SectionHeader(ColorsPage, "  WARNA ESP PER TANAMAN")

local colorList = {
    {"🥕 Carrot", Color3.fromRGB(255,140,0)},
    {"🍓 Strawberry", Color3.fromRGB(255,60,80)},
    {"🫐 Blueberry", Color3.fromRGB(80,80,255)},
    {"🍅 Tomato", Color3.fromRGB(220,50,50)},
    {"🌽 Corn", Color3.fromRGB(255,220,0)},
    {"🍉 Watermelon", Color3.fromRGB(80,200,80)},
    {"🎃 Pumpkin", Color3.fromRGB(255,120,30)},
    {"🍇 Grape", Color3.fromRGB(160,80,200)},
    {"🌻 Sunflower", Color3.fromRGB(255,230,0)},
    {"🌹 Rose", Color3.fromRGB(255,80,120)},
    {"🍎 Apple", Color3.fromRGB(220,60,60)},
    {"🥭 Mango", Color3.fromRGB(255,180,0)},
}

for _, data in pairs(colorList) do
    local Row = Instance.new("Frame", ColorsPage)
    Row.Size = UDim2.new(1, 0, 0, 36)
    Row.BackgroundColor3 = Color3.fromRGB(18, 24, 18)
    Row.BackgroundTransparency = 0.2
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 8)

    local NameL = Instance.new("TextLabel", Row)
    NameL.Size = UDim2.new(1, -50, 1, 0)
    NameL.Position = UDim2.new(0, 12, 0, 0)
    NameL.BackgroundTransparency = 1
    NameL.Text = data[1]
    NameL.Font = Enum.Font.GothamSemibold
    NameL.TextSize = 12
    NameL.TextColor3 = data[2]
    NameL.TextXAlignment = Enum.TextXAlignment.Left

    local ColorDot = Instance.new("Frame", Row)
    ColorDot.Size = UDim2.new(0, 20, 0, 20)
    ColorDot.Position = UDim2.new(1, -30, 0.5, -10)
    ColorDot.BackgroundColor3 = data[2]
    Instance.new("UICorner", ColorDot).CornerRadius = UDim.new(1, 0)
end

-- ABOUT PAGE
local AboutPage = NewPage("About")
local ABox = Instance.new("Frame", AboutPage)
ABox.Size = UDim2.new(1,0,0,130)
ABox.BackgroundColor3 = Color3.fromRGB(18,28,18)
ABox.BackgroundTransparency = 0.2
Instance.new("UICorner", ABox).CornerRadius = UDim.new(0,10)
local AStroke = Instance.new("UIStroke",ABox)
AStroke.Color = Color3.fromRGB(60,180,60) AStroke.Thickness=1 AStroke.Transparency=0.5
local AText = Instance.new("TextLabel",ABox)
AText.Size = UDim2.new(1,-20,1,-20) AText.Position = UDim2.new(0,10,0,10)
AText.BackgroundTransparency = 1
AText.Text = "🌱  Grow a Garden - Visual ESP\nBy: Mustafa Hub\n\nFitur:\n👁️ ESP nama tanaman di atas objek\n📍 Jarak tanaman dari karakter\n🎨 Warna berbeda tiap jenis tanaman\n🔍 Auto scan ulang tiap 5 detik"
AText.Font = Enum.Font.GothamSemibold AText.TextSize = 12
AText.TextColor3 = Color3.fromRGB(150,220,150)
AText.TextXAlignment = Enum.TextXAlignment.Left
AText.TextYAlignment = Enum.TextYAlignment.Top

-- ================================================
-- CLOSE & MINIMIZE
-- ================================================
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0,46,0,46)
OpenBtn.Position = UDim2.new(0,8,0.5,-23)
OpenBtn.BackgroundColor3 = Color3.fromRGB(15,25,15)
OpenBtn.BackgroundTransparency = 0.1
OpenBtn.Text = "🌱"
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
    ClearESP()
    ESPEnabled = false
end)

local Minimized = false
MinBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    TweenService:Create(Window, TweenInfo.new(0.3), {
        Size = Minimized and UDim2.new(0,520,0,36) or UDim2.new(0,520,0,360)
    }):Play()
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Window.Visible = not Window.Visible
        OpenBtn.Visible = not Window.Visible
    end
end)

Pages["ESP"].Visible = true
CurrentPage = "ESP"
if SideBtns["ESP"] then SideBtns["ESP"](true) end

Notify("🌱 Grow a Garden", "Visual ESP siap! Aktifkan ESP di menu.")
