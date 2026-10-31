-- NeverLose / BloxStrike
-- Standalone NeverLose menu with the PASTAHUB Blox Strike ESP layout and features.
-- Toggle menu: RightShift. Intended for a client environment that permits LocalScript execution.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local CONFIG = {
    Enabled = false,
    Box = true,
    Skeleton = true,
    Names = true,
    Distance = true,
    Health = true,
    Tracers = false,
    HeadDot = false,
    TeamCheck = true,
    MaxDistance = 2500,
    BoxStyle = "Corner", -- Corner / Full
    LineThickness = 2,
    Opacity = 18,
    EnemyColor = Color3.fromRGB(255, 60, 60),
    TeamColor = Color3.fromRGB(60, 160, 255),
    TerroristColor = Color3.fromRGB(255, 170, 60),
    CounterTerroristColor = Color3.fromRGB(80, 150, 255),
    VisibleColor = Color3.fromRGB(90, 255, 120),
    TextColor = Color3.fromRGB(245, 247, 255),
    Accent = Color3.fromRGB(75, 170, 255),
    BoxFill = true,
    Chams = false,
    ChamsOccluded = false,
    ChamsMode = "Glow",
    ChamsFillPercent = 60,
    ShowTeammates = false,
    HealthText = false,
    Armor = true,
    Weapon = true,
    Flags = true,
    Arrows = true,
    ArrowRadius = 220,
    ArrowSize = 14,
    Snaplines = false,
    SnapFrom = "Bottom",
    VisibilityCheck = false,
    Dormant = false,
    DormantTime = 3,
    Fade = 0.18,
    TextSize = 12,
    ColorMode = "Enemy / Teammate",
    -- PASTAHUB shitaro.lol Movement tab settings
    ShBhop = false,
    ShStrafe = false,
    ShEdgeJump = false,
    ShJumpBug = false,
    ShEdgeBug = false,
    ShSlowWalk = false,
    ShPixelSurf = false,
    BulletTracer = false,
    TracerColor = Color3.fromRGB(255, 255, 255),
    TracerWidth = 6,
    TracerLife = 1.2,
    TracerStyle = "Line",
    TracerFrom = "Gun",
    TracerRainbow = false,
    TracerOnlyHits = false,


}

local DEFAULT_CONFIG = table.clone(CONFIG)


local old = CoreGui:FindFirstChild("NeverLose_BloxStrike")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "NeverLose_BloxStrike"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
local guiParent
pcall(function()
    if typeof(gethui) == "function" then
        guiParent = gethui()
    end
end)
if not guiParent then
    pcall(function() guiParent = CoreGui end)
end
if not guiParent then
    guiParent = LocalPlayer:WaitForChild("PlayerGui", 10)
end
if not guiParent then
    error("[NeverLose] Could not find a valid GUI parent (gethui/CoreGui/PlayerGui).")
end
gui.Parent = guiParent

local overlay = Instance.new("Frame")
overlay.Name = "ESP_Overlay"
overlay.BackgroundTransparency = 1
overlay.Size = UDim2.fromScale(1, 1)
overlay.Position = UDim2.fromScale(0, 0)
overlay.Parent = gui

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function corner(parent, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 7)}, parent)
end

local function stroke(parent, color, transparency, thickness)
    return make("UIStroke", {
        Color = color or Color3.new(1,1,1),
        Transparency = transparency or 0,
        Thickness = thickness or 1,
    }, parent)
end

local function label(parent, text, size, color, font)
    return make("TextLabel", {
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or CONFIG.TextColor,
        TextSize = size or 12,
        Font = font or Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        AutomaticSize = Enum.AutomaticSize.None,
    }, parent)
end

local panel = make("Frame", {
    Name = "Menu",
    Size = UDim2.fromOffset(330, 430),
    Position = UDim2.new(0, 28, 0.5, -215),
    BackgroundColor3 = Color3.fromRGB(11, 18, 29),
    BorderSizePixel = 0,
    Visible = true,
}, gui)
corner(panel, 12)
stroke(panel, Color3.fromRGB(65, 125, 175), 0.25, 1)

local top = make("Frame", {
    Size = UDim2.new(1, 0, 0, 58),
    BackgroundColor3 = Color3.fromRGB(17, 29, 45),
    BorderSizePixel = 0,
}, panel)
corner(top, 12)
local topMask = make("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = Color3.fromRGB(17, 29, 45),
    BorderSizePixel = 0,
}, top)
local logo = label(top, "NL", 22, CONFIG.Accent, Enum.Font.GothamBlack)
logo.Position = UDim2.fromOffset(16, 7)
logo.Size = UDim2.fromOffset(40, 25)
local title = label(top, "NeverLose / BloxStrike", 12, Color3.fromRGB(235,238,246), Enum.Font.GothamBold)
title.Position = UDim2.fromOffset(59, 9)
title.Size = UDim2.fromOffset(235, 18)
local subtitle = label(top, "https://t.me/shizukuscripts", 9, Color3.fromRGB(130,137,153))
subtitle.Position = UDim2.fromOffset(60, 27)
subtitle.Size = UDim2.fromOffset(230, 16)

local close = make("TextButton", {
    Size = UDim2.fromOffset(26, 26),
    Position = UDim2.new(1, -38, 0, 15),
    Text = "×",
    TextSize = 20,
    Font = Enum.Font.GothamMedium,
    TextColor3 = Color3.fromRGB(210,214,224),
    BackgroundColor3 = Color3.fromRGB(38,41,52),
    BorderSizePixel = 0,
}, top)
corner(close, 7)
close.MouseButton1Click:Connect(function() panel.Visible = false end)

local tabs = make("Frame", {
    Position = UDim2.fromOffset(14, 70),
    Size = UDim2.new(1, -28, 0, 30),
    BackgroundTransparency = 1,
}, panel)
local tabLayout = make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0, 2),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, tabs)

local content = make("ScrollingFrame", {
    Position = UDim2.fromOffset(14, 110),
    Size = UDim2.new(1, -28, 1, -124),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = CONFIG.Accent,
    CanvasSize = UDim2.fromOffset(0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, panel)
make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, content)

local currentTab = "Movement"
local tabButtons = {}

local function section(text)
    local holder = make("Frame", {
        Size = UDim2.new(1, -2, 0, 24),
        BackgroundTransparency = 1,
    }, content)
    local t = label(holder, string.upper(text), 9, CONFIG.Accent, Enum.Font.GothamBold)
    t.Size = UDim2.new(1, 0, 1, 0)
    return holder
end

local function rowBase(height)
    return make("Frame", {
        Size = UDim2.new(1, -2, 0, height or 34),
        BackgroundColor3 = Color3.fromRGB(20, 34, 51),
        BorderSizePixel = 0,
    }, content)
end

local function toggle(text, key)
    local row = rowBase(34)
    corner(row, 7)
    local name = label(row, text, 11, Color3.fromRGB(224,228,238))
    name.Position = UDim2.fromOffset(11, 0)
    name.Size = UDim2.new(1, -65, 1, 0)
    local button = make("TextButton", {
        Size = UDim2.fromOffset(36, 19),
        Position = UDim2.new(1, -47, 0.5, -9),
        Text = "",
        BackgroundColor3 = CONFIG[key] and CONFIG.Accent or Color3.fromRGB(39, 59, 80),
        BorderSizePixel = 0,
    }, row)
    corner(button, 10)
    local knob = make("Frame", {
        Size = UDim2.fromOffset(13, 13),
        Position = CONFIG[key] and UDim2.new(1, -16, 0.5, -6) or UDim2.fromOffset(3, 3),
        BackgroundColor3 = Color3.fromRGB(245,246,250),
        BorderSizePixel = 0,
    }, button)
    corner(knob, 8)
    local function refresh()
        button.BackgroundColor3 = CONFIG[key] and CONFIG.Accent or Color3.fromRGB(39, 59, 80)
        knob.Position = CONFIG[key] and UDim2.new(1, -16, 0.5, -6) or UDim2.fromOffset(3, 3)
    end
    button.MouseButton1Click:Connect(function()
        CONFIG[key] = not CONFIG[key]
        refresh()
    end)
    return row
end

local function cycle(text, key, values)
    local row = rowBase(36)
    corner(row, 7)
    local name = label(row, text, 11, Color3.fromRGB(224,228,238))
    name.Position = UDim2.fromOffset(11, 0)
    name.Size = UDim2.new(0.52, 0, 1, 0)
    local button = make("TextButton", {
        Size = UDim2.fromOffset(112, 24),
        Position = UDim2.new(1, -122, 0.5, -12),
        Text = tostring(CONFIG[key]),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(245,247,255),
        BackgroundColor3 = Color3.fromRGB(30, 52, 75),
        BorderSizePixel = 0,
    }, row)
    corner(button, 6)
    button.MouseButton1Click:Connect(function()
        local index = table.find(values, CONFIG[key]) or 1
        index = index % #values + 1
        CONFIG[key] = values[index]
        button.Text = tostring(CONFIG[key])
    end)
end

local function slider(text, key, minValue, maxValue, step)
    local row = rowBase(52)
    corner(row, 7)
    local name = label(row, text, 11, Color3.fromRGB(224,228,238))
    name.Position = UDim2.fromOffset(11, 3)
    name.Size = UDim2.new(0.7, 0, 0, 18)
    local value = label(row, tostring(CONFIG[key]), 10, CONFIG.Accent, Enum.Font.GothamBold)
    value.TextXAlignment = Enum.TextXAlignment.Right
    value.Position = UDim2.new(1, -60, 0, 3)
    value.Size = UDim2.fromOffset(48, 18)
    local bar = make("Frame", {
        Position = UDim2.fromOffset(11, 31),
        Size = UDim2.new(1, -22, 0, 5),
        BackgroundColor3 = Color3.fromRGB(39, 59, 80),
        BorderSizePixel = 0,
    }, row)
    corner(bar, 4)
    local fill = make("Frame", {
        Size = UDim2.new((CONFIG[key]-minValue)/(maxValue-minValue), 0, 1, 0),
        BackgroundColor3 = CONFIG.Accent,
        BorderSizePixel = 0,
    }, bar)
    corner(fill, 4)
    local dragging = false
    local function setFromX(x)
        local pct = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local raw = minValue + pct * (maxValue-minValue)
        CONFIG[key] = math.clamp(math.floor(raw / step + 0.5) * step, minValue, maxValue)
        fill.Size = UDim2.new((CONFIG[key]-minValue)/(maxValue-minValue), 0, 1, 0)
        value.Text = tostring(CONFIG[key])
    end
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            setFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

local function colorCycle(text, key, palette)
    local row = rowBase(36)
    corner(row, 7)
    local name = label(row, text, 11, Color3.fromRGB(224,228,238))
    name.Position = UDim2.fromOffset(11, 0)
    name.Size = UDim2.new(1, -75, 1, 0)
    local swatch = make("TextButton", {
        Size = UDim2.fromOffset(44, 20),
        Position = UDim2.new(1, -55, 0.5, -10),
        Text = " ",
        BackgroundColor3 = CONFIG[key],
        BorderSizePixel = 0,
    }, row)
    corner(swatch, 6)
    stroke(swatch, Color3.fromRGB(255,255,255), 0.65, 1)
    swatch.MouseButton1Click:Connect(function()
        local index = 1
        for i, c in ipairs(palette) do
            if c == CONFIG[key] then index = i break end
        end
        index = index % #palette + 1
        CONFIG[key] = palette[index]
        swatch.BackgroundColor3 = CONFIG[key]
    end)
end

local function clearContent()
    for _, child in ipairs(content:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end
end


-- Config persistence. Uses executor file APIs when available; otherwise the tab
-- reports that local config storage is unavailable in this environment.
local CONFIG_FOLDER = "NeverLose"
local configNameBox
local configStatus
local configPickerButton
local selectedConfigName = "default"
local availableConfigs = {"default"}

local function configFile(name)
    name = tostring(name or "default"):gsub("[^%w_%-]", "_")
    if name == "" then name = "default" end
    local folderReady = false
    if type(isfolder) == "function" then
        local ok, exists = pcall(isfolder, CONFIG_FOLDER)
        folderReady = ok and exists == true
    end
    if not folderReady and type(makefolder) == "function" then
        local ok = pcall(makefolder, CONFIG_FOLDER)
        folderReady = ok
    end
    if folderReady then
        return CONFIG_FOLDER .. "/" .. name .. ".json"
    end
    return "NeverLose_" .. name .. ".json"
end

local function packConfig()
    local packed = {}
    for key, value in pairs(CONFIG) do
        if typeof(value) == "Color3" then
            packed[key] = {__color = true, r = value.R, g = value.G, b = value.B}
        else
            packed[key] = value
        end
    end
    return packed
end

local function refreshConfigList()
    local found, seen = {}, {}
    local function addName(path)
        if type(path) ~= "string" then return end
        local file = path:gsub("\\", "/"):match("([^/]+)$") or path
        if not file:lower():match("%.json$") then return end
        local name = file:gsub("%.json$", "")
        if name:match("^NeverLose_") then name = name:gsub("^NeverLose_", "") end
        if name ~= "" and not seen[name] then
            seen[name] = true
            table.insert(found, name)
        end
    end
    if type(listfiles) == "function" then
        pcall(function()
            for _, path in ipairs(listfiles(CONFIG_FOLDER)) do addName(path) end
        end)
        pcall(function()
            for _, path in ipairs(listfiles(".")) do
                local normalized = tostring(path):gsub("\\", "/")
                if normalized:match("^NeverLose_[^/]+%.json$") then addName(normalized) end
            end
        end)
    end
    if selectedConfigName and selectedConfigName ~= "" and not seen[selectedConfigName] then
        table.insert(found, selectedConfigName)
    end
    table.sort(found, function(a, b) return a:lower() < b:lower() end)
    if #found == 0 then found = {"default"} end
    availableConfigs = found
    if not table.find(availableConfigs, selectedConfigName) then
        selectedConfigName = availableConfigs[1]
    end
    if configPickerButton then
        configPickerButton.Text = "‹  " .. selectedConfigName .. "  ›"
    end
    if configNameBox and configNameBox.Parent then
        configNameBox.Text = selectedConfigName
    end
end

local function saveConfig(name)
    if type(writefile) ~= "function" then
        return false, "File API unavailable (writefile)"
    end
    local path = configFile(name)
    local ok, err = pcall(function()
        writefile(path, HttpService:JSONEncode(packConfig()))
    end)
    if not ok then return false, tostring(err) end
    return true, "Saved: " .. tostring(name)
end

local function loadConfig(name)
    if type(readfile) ~= "function" or type(isfile) ~= "function" then
        return false, "File API unavailable (readfile/isfile)"
    end
    local path = configFile(name)
    local exists, found = pcall(isfile, path)
    if not exists or not found then
        local safeName = tostring(name or "default"):gsub("[^%w_%-]", "_")
        local alt = CONFIG_FOLDER .. "/" .. (safeName ~= "" and safeName or "default") .. ".json"
        local altOk, altFound = pcall(isfile, alt)
        if altOk and altFound then path = alt else return false, "Config not found: " .. tostring(name) end
    end
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if not ok or type(decoded) ~= "table" then return false, "Invalid config file" end

    for key, value in pairs(decoded) do
        if CONFIG[key] ~= nil then
            if type(value) == "table" and value.__color then
                CONFIG[key] = Color3.new(
                    math.clamp(tonumber(value.r) or 1, 0, 1),
                    math.clamp(tonumber(value.g) or 1, 0, 1),
                    math.clamp(tonumber(value.b) or 1, 0, 1)
                )
            elseif type(CONFIG[key]) == type(value) then
                CONFIG[key] = value
            end
        end
    end
    return true, "Loaded: " .. tostring(name)
end

local function configButton(parent, text, x, callback)
    local b = make("TextButton", {
        Size = UDim2.new(0.5, -5, 0, 30),
        Position = UDim2.new(x, x == 0 and 0 or 5, 0, 0),
        Text = text,
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(240, 247, 255),
        BackgroundColor3 = CONFIG.Accent,
        BorderSizePixel = 0,
    }, parent)
    corner(b, 6)
    b.MouseButton1Click:Connect(callback)
    return b
end

local buildTab
local cleanup
local function buildVisualsTab()
    section("ESP")
    toggle("Enable ESP", "Enabled")
    toggle("Team Check (hide teammates)", "TeamCheck")
    toggle("Show Teammates (overrides Team Check)", "ShowTeammates")
    toggle("2D Box", "Box")
    toggle("Box Fill", "BoxFill")
    toggle("Names", "Names")
    toggle("Distance", "Distance")
    toggle("Health", "Health")
    toggle("Skeleton", "Skeleton")
    toggle("Head Dot", "HeadDot")
    toggle("Chams", "Chams")
    toggle("Snaplines", "Snaplines")
    colorCycle("Enemy color", "EnemyColor", {Color3.fromRGB(255,60,60), Color3.fromRGB(255,170,60), Color3.fromRGB(255,255,255)})
    colorCycle("Team color", "TeamColor", {Color3.fromRGB(60,160,255), Color3.fromRGB(90,255,140), Color3.fromRGB(255,255,255)})
    section("Bullet tracers")
    toggle("Enable Bullet Tracers", "BulletTracer")
    cycle("Tracer style", "TracerStyle", {"Line", "Beam", "Lightning"})
    cycle("Tracer start", "TracerFrom", {"Gun", "Camera"})
    toggle("Rainbow", "TracerRainbow")
    toggle("Only on hit", "TracerOnlyHits")
    slider("Tracer width", "TracerWidth", 1, 20, 1)
    slider("Tracer lifetime", "TracerLife", 1, 5, 0.1)
    colorCycle("Tracer color", "TracerColor", {Color3.fromRGB(255,255,255), Color3.fromRGB(255,80,80), Color3.fromRGB(80,170,255), Color3.fromRGB(90,255,140)})
end

local function buildConfigTab()
    section("Config manager")
    local pickerRow = rowBase(36)
    corner(pickerRow, 7)
    local pickerLabel = label(pickerRow, "Available configs", 10, Color3.fromRGB(185, 203, 222))
    pickerLabel.Position = UDim2.fromOffset(10, 0)
    pickerLabel.Size = UDim2.new(0.42, 0, 1, 0)
    configPickerButton = make("TextButton", {
        Size = UDim2.fromOffset(132, 24),
        Position = UDim2.new(1, -142, 0.5, -12),
        Text = "‹  " .. selectedConfigName .. "  ›",
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(240, 247, 255),
        BackgroundColor3 = Color3.fromRGB(30, 52, 75),
        BorderSizePixel = 0,
    }, pickerRow)
    corner(configPickerButton, 6)
    configPickerButton.MouseButton1Click:Connect(function()
        refreshConfigList()
        local index = table.find(availableConfigs, selectedConfigName) or 0
        selectedConfigName = availableConfigs[index % #availableConfigs + 1]
        configPickerButton.Text = "‹  " .. selectedConfigName .. "  ›"
        if configNameBox then configNameBox.Text = selectedConfigName end
    end)
    local nameRow = rowBase(54)
    corner(nameRow, 7)
    local caption = label(nameRow, "Config name", 10, Color3.fromRGB(185, 203, 222))
    caption.Position = UDim2.fromOffset(10, 2)
    caption.Size = UDim2.new(1, -20, 0, 17)
    configNameBox = make("TextBox", {
        Position = UDim2.fromOffset(9, 23),
        Size = UDim2.new(1, -18, 0, 24),
        Text = "default",
        PlaceholderText = "Enter config name",
        ClearTextOnFocus = false,
        TextSize = 11,
        Font = Enum.Font.Gotham,
        TextColor3 = Color3.fromRGB(240, 247, 255),
        PlaceholderColor3 = Color3.fromRGB(130, 150, 170),
        BackgroundColor3 = Color3.fromRGB(29, 49, 70),
        BorderSizePixel = 0,
    }, nameRow)
    corner(configNameBox, 5)
    refreshConfigList()

    local actionRow = make("Frame", {
        Size = UDim2.new(1, -2, 0, 30),
        BackgroundTransparency = 1,
    }, content)
    configButton(actionRow, "Save", 0, function()
        local ok, msg = saveConfig(configNameBox.Text)
        if ok then
            selectedConfigName = tostring(configNameBox.Text):gsub("[^%w_%-]", "_")
            refreshConfigList()
        end
        configStatus.Text = msg
        configStatus.TextColor3 = ok and Color3.fromRGB(105, 220, 165) or Color3.fromRGB(255, 145, 145)
    end)
    configButton(actionRow, "Load", 0.5, function()
        local ok, msg = loadConfig(configNameBox.Text)
        if ok then selectedConfigName = tostring(configNameBox.Text) end
        configStatus.Text = msg
        configStatus.TextColor3 = ok and Color3.fromRGB(105, 220, 165) or Color3.fromRGB(255, 145, 145)
        if ok then
            task.defer(function()
                if panel and panel.Parent then buildTab("CFG") end
            end)
        end
    end)

    local refreshRow = make("Frame", {
        Size = UDim2.new(1, -2, 0, 30),
        BackgroundTransparency = 1,
    }, content)
    configButton(refreshRow, "Refresh list", 0, function()
        refreshConfigList()
        configStatus.Text = "Config list refreshed"
        configStatus.TextColor3 = Color3.fromRGB(105, 220, 165)
    end)
    configButton(refreshRow, "Load selected", 0.5, function()
        if configNameBox then configNameBox.Text = selectedConfigName end
        local ok, msg = loadConfig(selectedConfigName)
        configStatus.Text = msg
        configStatus.TextColor3 = ok and Color3.fromRGB(105, 220, 165) or Color3.fromRGB(255, 145, 145)
        if ok then task.defer(function() if panel and panel.Parent then buildTab("CFG") end end) end
    end)

    local resetRow = make("Frame", {
        Size = UDim2.new(1, -2, 0, 30),
        BackgroundTransparency = 1,
    }, content)
    configButton(resetRow, "Reset defaults", 0, function()
        for key, value in pairs(DEFAULT_CONFIG) do CONFIG[key] = value end
        configStatus.Text = "Settings reset"
        configStatus.TextColor3 = Color3.fromRGB(105, 220, 165)
        buildTab("CFG")
    end)
    configStatus = label(content, "Configs are stored locally as NeverLose config JSON files", 9, Color3.fromRGB(160, 180, 200))
    configStatus.Size = UDim2.new(1, -4, 0, 30)
    configStatus.TextWrapped = true
    local note = rowBase(58)
    corner(note, 7)
    local n = label(note, "Save stores current ESP, Movement and color settings.\\nLoad restores them from a local JSON file.", 9, Color3.fromRGB(165, 185, 205))
    n.Position = UDim2.fromOffset(10, 5)
    n.Size = UDim2.new(1, -18, 1, -10)
    n.TextYAlignment = Enum.TextYAlignment.Top

    local unloadButton = make("TextButton", {
        Size = UDim2.new(1, -2, 0, 34),
        Text = "Unload Script",
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(255, 225, 225),
        BackgroundColor3 = Color3.fromRGB(65, 20, 25),
        BorderSizePixel = 0,
    }, content)
    corner(unloadButton, 6)
    stroke(unloadButton, Color3.fromRGB(255, 55, 65), 0, 2)
    unloadButton.MouseButton1Click:Connect(function()
        if cleanup then cleanup() else gui:Destroy() end
    end)
end

buildTab = function(tabName)
    currentTab = tabName
    clearContent()
    if tabName == "Visuals" then
        buildVisualsTab()
    elseif tabName == "Movement" then
        section("shitaro.lol movement")
        toggle("Bhop", "ShBhop")
        toggle("Auto Strafe", "ShStrafe")
        toggle("Edge Jump", "ShEdgeJump")
        toggle("Jump Bug", "ShJumpBug")
        toggle("Edge Bug", "ShEdgeBug")
        toggle("Slow Walk", "ShSlowWalk")
        toggle("Pixel Surf", "ShPixelSurf")
    elseif tabName == "CFG" then
        buildConfigTab()
    end
end

for i, tabName in ipairs({"Visuals", "Movement", "CFG"}) do
    local tabWidths = {Visuals = 48, Movement = 54, CFG = 32}
    local b = make("TextButton", {
        Size = UDim2.fromOffset(tabWidths[tabName] or 44, 28),
        Text = tabName,
        TextSize = 8,
        Font = Enum.Font.GothamBold,
        TextColor3 = Color3.fromRGB(230,233,242),
        BackgroundColor3 = i == 1 and CONFIG.Accent or Color3.fromRGB(25, 43, 63),
        BorderSizePixel = 0,
        LayoutOrder = i,
    }, tabs)
    corner(b, 6)
    tabButtons[tabName] = b
    b.MouseButton1Click:Connect(function()
        for name, button in pairs(tabButtons) do
            button.BackgroundColor3 = name == tabName and CONFIG.Accent or Color3.fromRGB(25, 43, 63)
        end
        buildTab(tabName)
    end)
end

buildTab("Visuals")

-- Drag menu
do
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = panel.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end

UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        panel.Visible = not panel.Visible
    end
end)

-- PASTAHUB ESP: original ESP renderer transplanted from the supplied source.
-- The small adapter below connects its original config/helpers to NeverLose.
local aL = overlay
local at = Workspace.CurrentCamera
local ar = HttpService
local u = Players
local O = RunService
local _ = LocalPlayer
local aU = RaycastParams.new()
aU.FilterType = Enum.RaycastFilterType.Exclude
local espUnloadCallbacks = {}
local espConnections = {}
local aa = {}
function aa.entities()
    return Players:GetPlayers()
end
function aa.connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(espConnections, connection)
    return connection
end
function aa.onUnload(callback)
    table.insert(espUnloadCallbacks, callback)
end
local cameraRefreshConnection = RunService.RenderStepped:Connect(function()
    at = Workspace.CurrentCamera
end)
table.insert(espConnections, cameraRefreshConnection)
local function U()
    local camera = Workspace.CurrentCamera
    return camera and camera.CFrame or CFrame.new()
end
local function k(player)
    if Workspace:FindFirstChild("HordeShells") then return true end
    if Workspace:GetAttribute("Gamemode") == "Deathmatch" then return false end
    local localTeam = LocalPlayer:GetAttribute("Team")
    return localTeam ~= nil and player:GetAttribute("Team") == localTeam
end
local function F(player)
    local character = player and player.Character
    if not character or character:GetAttribute("Dead") or character:GetAttribute("Ragdolled") then return nil end
    local health = character:GetAttribute("Health")
    if type(health) == "number" and health <= 0 then return nil end
    if not character:IsDescendantOf(Workspace) or not character:FindFirstChild("Head") then return nil end
    return character
end
local function t(character)
    if not character then return false end
    if character:GetAttribute("Invincible") == true then return true end
    local owner = Players:GetPlayerFromCharacter(character)
    return owner ~= nil and owner:GetAttribute("Invincible") == true
end

local espConfigMap = {
    esp = "Enabled", espBox = "Box", espBoxStyle = "BoxStyle", espBoxFill = "BoxFill",
    espHealth = "Health", espHealthText = "HealthText", espArmor = "Armor",
    espNames = "Names", espWeapon = "Weapon", espFlags = "Flags", espDistance = "Distance",
    espTextSize = "TextSize", espSkeleton = "Skeleton", espHeadDot = "HeadDot",
    espSnap = "Snaplines", espSnapFrom = "SnapFrom", espArrows = "Arrows",
    espArrowRadius = "ArrowRadius", espArrowSize = "ArrowSize", espVisCheck = "VisibilityCheck",
    espVisColor = "VisibleColor", espTeam = "ShowTeammates", espTeamColor = "TeamColor",
    espDormant = "Dormant", espDormantTime = "DormantTime", espMaxDist = "MaxDistance",
    espChams = "Chams", espChamsMode = "ChamsMode", espChamsOccluded = "ChamsOccluded",
    espColorMode = "ColorMode", espEnemyColor = "EnemyColor", espTColor = "TerroristColor",
    espCTColor = "CounterTerroristColor", espFade = "Fade",
}
local aC = setmetatable({}, {
    __index = function(_, key)
        if key == "espFill" then return (CONFIG.ChamsFillPercent or 60) / 100 end
        local configKey = espConfigMap[key]
        if configKey then return CONFIG[configKey] end
        return nil
    end,
    __newindex = function(_, key, value)
        if key == "espFill" then
            CONFIG.ChamsFillPercent = math.clamp((tonumber(value) or 0.6) * 100, 0, 100)
            return
        end
        local configKey = espConfigMap[key]
        if configKey then CONFIG[configKey] = value end
    end,
})

do
    local bi = Instance.new'Folder'

    bi.Name = 'PastaHubbloxESP'
    bi.Parent = aL

    local bj = Instance.new'Frame'

    bj.Name = 'ESP2D'
    bj.Size = UDim2.fromScale(1, 1)
    bj.BackgroundTransparency = 1
    bj.Parent = aL

    local bk, bl, bm, bn, bo, bp = {}, Color3.new(0, 0, 0), Color3.fromRGB(90, 255, 110), Color3.fromRGB(255, 60, 60), Color3.fromRGB(90, 170, 255), {
        {
            'Head',
            'UpperTorso',
        },
        {
            'UpperTorso',
            'LowerTorso',
        },
        {
            'UpperTorso',
            'LeftUpperArm',
        },
        {
            'LeftUpperArm',
            'LeftLowerArm',
        },
        {
            'LeftLowerArm',
            'LeftHand',
        },
        {
            'UpperTorso',
            'RightUpperArm',
        },
        {
            'RightUpperArm',
            'RightLowerArm',
        },
        {
            'RightLowerArm',
            'RightHand',
        },
        {
            'LowerTorso',
            'LeftUpperLeg',
        },
        {
            'LeftUpperLeg',
            'LeftLowerLeg',
        },
        {
            'LeftLowerLeg',
            'LeftFoot',
        },
        {
            'LowerTorso',
            'RightUpperLeg',
        },
        {
            'RightUpperLeg',
            'RightLowerLeg',
        },
        {
            'RightLowerLeg',
            'RightFoot',
        },
    }

    local function q(bq, br, bs)
        local bt = Instance.new'Frame'

        bt.BorderSizePixel = 0
        bt.BackgroundColor3 = bs or bl
        bt.Visible = false
        bt.ZIndex = br
        bt.Parent = bq

        return bt
    end
    local function v(bq, br)
        local bs = q(bq, br)

        bs.AnchorPoint = Vector2.new(0.5, 0.5)

        return bs
    end
    local function K(bq)
        local br = Instance.new'TextLabel'

        br.BackgroundTransparency = 1
        br.Font = Enum.Font.GothamBold
        br.TextStrokeTransparency = 0.35
        br.TextStrokeColor3 = bl
        br.AnchorPoint = Vector2.new(0.5, 0)
        br.Visible = false
        br.ZIndex = 4
        br.Parent = bq

        return br
    end
    local function N(bq, br, bs, bt, bu)
        bq.Position = UDim2.fromOffset(br, bs)
        bq.Size = UDim2.fromOffset(bt, bu)
        bq.Visible = true
    end
    local function c(bq, br, bs, bt, bu, bv, bw)
        local bx, by = bt - br, bu - bs

        bq.Position = UDim2.fromOffset((br + bt) / 2, (bs + bu) / 2)
        bq.Size = UDim2.fromOffset(math.sqrt(bx * bx + by * by), bv)
        bq.Rotation = math.deg(math.atan2(by, bx))
        bq.BackgroundColor3 = bw
        bq.Visible = true
    end
    local function C(bq)
        local br = bk[bq]

        if br then
            br.highlight:Destroy()
            br.root:Destroy()
            br.outer:Destroy()

            bk[bq] = nil
        end
    end
    local function Q()
        for bq in pairs(bk)do
            C(bq)
        end
    end
    local function b(bq, br)
        C(bq)

        local bs = Instance.new'Highlight'

        bs.OutlineTransparency = 0
        bs.Adornee = br
        bs.Parent = bi

        local bt = Instance.new'Frame'

        bt.Size = UDim2.fromScale(1, 1)
        bt.BackgroundTransparency = 1
        bt.Visible = false
        bt.Parent = bj

        local bu = Instance.new'Frame'

        bu.Size = UDim2.fromScale(1, 1)
        bu.BackgroundTransparency = 1
        bu.Parent = bj

        local bv = {
            highlight = bs,
            root = bt,
            outer = bu,
            char = br,
            vis = false,
            visAt = 0,
        }

        bv.fill = q(bt, 1)
        bv.fill.BackgroundTransparency = 0.82
        bv.boxOut, bv.box = {}, {}

        for bw = 1, 8, 1 do
            bv.boxOut[bw] = q(bt, 2)
            bv.box[bw] = q(bt, 3)
        end

        bv.hpBack, bv.hpBar = q(bt, 2), q(bt, 3)
        bv.arBack, bv.arBar = q(bt, 2), q(bt, 3, bo)
        bv.hpText = K(bt)
        bv.hpText.AnchorPoint = Vector2.new(1, 0.5)
        bv.name, bv.weapon, bv.dist = K(bt), K(bt), K(bt)
        bv.flags = K(bt)
        bv.flags.AnchorPoint = Vector2.new(0, 0)
        bv.flags.RichText = true
        bv.flags.TextXAlignment = Enum.TextXAlignment.Left
        bv.flags.TextYAlignment = Enum.TextYAlignment.Top
        bv.bones = {}

        for bw = 1, #bp, 1 do
            bv.bones[bw] = v(bt, 2)
        end

        bv.headDot = q(bt, 3)
        bv.headDot.AnchorPoint = Vector2.new(0.5, 0.5)
        bv.headDot.BackgroundTransparency = 1
        (Instance.new('UICorner', bv.headDot)).CornerRadius = UDim.new(1, 0)
        bv.headStroke = Instance.new('UIStroke', bv.headDot)
        bv.headStroke.Thickness = 1
        bv.snapOut, bv.snap = v(bu, 1), v(bu, 2)
        bv.arrow = {
            v(bu, 3),
            v(bu, 3),
        }

        local bw = {}

        local function N(bx, by, bz)
            bw[#bw + 1] = {bx, by, bz}
        end

        N(bv.fill, 'BackgroundTransparency', 0.82)

        for bx = 1, 8, 1 do
            N(bv.boxOut[bx], 'BackgroundTransparency', 0)
            N(bv.box[bx], 'BackgroundTransparency', 0)
        end

        for bx, by in ipairs{
            bv.hpBack,
            bv.hpBar,
            bv.arBack,
            bv.arBar,
            bv.snap,
            bv.arrow[1],
            bv.arrow[2],
        }do
            N(by, 'BackgroundTransparency', 0)
        end

        N(bv.snapOut, 'BackgroundTransparency', 0.5)

        for bx, by in ipairs{
            bv.hpText,
            bv.name,
            bv.weapon,
            bv.dist,
            bv.flags,
        }do
            N(by, 'TextTransparency', 0)
            N(by, 'TextStrokeTransparency', 0.35)
        end
        for bx, by in ipairs(bv.bones)do
            N(by, 'BackgroundTransparency', 0)
        end

        N(bv.headStroke, 'Transparency', 0)

        bv.fade, bv.alpha, bv.fadeApplied = bw, 0, -1
        bk[bq] = bv

        return bv
    end
    local function a(bq)
        local br = 1 - bq.alpha

        if br == bq.fadeApplied then
            return
        end

        bq.fadeApplied = br

        for bs, bt in ipairs(bq.fade)do
            bt[1][bt[2] ] = bt[3] + (1 - bt[3]) * br
        end
    end

    aa.connect(u.PlayerRemoving, C)
    aa.onUnload(Q)

    local function T(bq, br)
        local bs = bq:GetAttribute'CurrentEquipped'

        if bs ~= br.eqRaw then
            br.eqRaw = bs

            local bt, bu = pcall(ar.JSONDecode, ar, type(bs) == 'string' and bs or '')

            br.eqName = (bt and (type(bu) == 'table' and type(bu.Name) == 'string')) and bu.Name or nil
        end

        return br.eqName
    end
    local function w(bq, br)
        local bs = bq:GetAttribute'Armor'

        if bs ~= br.arRaw then
            br.arRaw = bs

            local bt, bu = pcall(ar.JSONDecode, ar, type(bs) == 'string' and bs or '')

            br.arValue = bt and (type(bu) == 'table' and tonumber(bu.Health)) or 0
            br.arHelmet = bt and (type(bu) == 'table' and (type(bu.Type) == 'string' and bu.Type:find'Helmet' ~= nil))
        end

        return br.arValue or 0
    end
    local function e(bq, br, bs, bt, bu, bv)
        local bw = aC.espBoxStyle == 'Full' and 0.5 or 0.25
        local bx, by = math.ceil(bt * bw), math.ceil(bu * bw)
        local bz = {
            {
                br,
                bs,
                bx,
                1,
            },
            {
                br,
                bs,
                1,
                by,
            },
            {
                (br + bt) - bx,
                bs,
                bx,
                1,
            },
            {
                (br + bt) - 1,
                bs,
                1,
                by,
            },
            {
                br,
                (bs + bu) - 1,
                bx,
                1,
            },
            {
                br,
                (bs + bu) - by,
                1,
                by,
            },
            {
                (br + bt) - bx,
                (bs + bu) - 1,
                bx,
                1,
            },
            {
                (br + bt) - 1,
                (bs + bu) - by,
                1,
                by,
            },
        }

        for bA = 1, 8, 1 do
            local bB = bz[bA]

            N(bq.boxOut[bA], bB[1] - 1, bB[2] - 1, bB[3] + 2, bB[4] + 2)
            N(bq.box[bA], bB[1], bB[2], bB[3], bB[4])

            bq.box[bA].BackgroundColor3 = bv
        end
    end
    local function o(bq, br, bs, bt, bu, bv, bw)
        local bx = br.Head
        local by = br:FindFirstChild'HumanoidRootPart' or bx
        local bz, bA = bx.Position, by.Position
        local bB = (bz - bu).Magnitude

        if bB > aC.espMaxDist and aC.espMaxDist < 3000 then
            bs.root.Visible, bs.outer.Visible, bs.highlight.Enabled = false, false, false

            return
        end
        if aC.espVisCheck and (not bt and not bs.dormant) then
            if bw - bs.visAt > 0.12 then
                bs.visAt = bw
                aU.FilterDescendantsInstances = {
                    _.Character,
                    at,
                }

                local bC = workspace:Raycast(bu, bz - bu, aU)

                bs.vis = bC == nil or bC.Instance:IsDescendantOf(br)
            end
        else
            bs.vis = false
        end

        local bC

        if aC.espColorMode == 'Team Side' then
            local bD = bq:GetAttribute'Team'

            bC = bD == 'Terrorists' and aC.espTColor or bD == 'Counter-Terrorists' and aC.espCTColor or bt and aC.espTeamColor or aC.espEnemyColor
        elseif aC.espColorMode == 'Player Color' then
            local bD = bq:GetAttribute'CompetitivePlayerColor'

            bC = typeof(bD) == 'Color3' and bD or bt and aC.espTeamColor or aC.espEnemyColor
        else
            bC = bt and aC.espTeamColor or aC.espEnemyColor
        end
        if bs.vis then
            bC = aC.espVisColor
        end
        if bs.dormant then
            bC = Color3.fromRGB(150, 150, 160)
        end

        local bD, bE, bF, bG = bs.highlight, aC.espFill, bC, aC.espChamsMode

        if bG == 'Outline' then
            bE = 1
        elseif bG == 'Solid' then
            bE = 0
        elseif bG == 'Pulse' then
            bE = 0.5 + 0.38 * math.sin(bw * 4.5)
        elseif bG == 'Rainbow' then
            bF = Color3.fromHSV((bw * 0.25) % 1, 0.85, 1)
        elseif bG == 'Health' then
            local bH = math.clamp(tonumber(br:GetAttribute'Health') or 100, 0, 100)

            bF = bn:Lerp(bm, bH / 100)
        end

        local bH = 1 - bs.alpha

        bD.Enabled = aC.espChams and not bs.dormant
        bD.DepthMode = aC.espChamsOccluded and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
        bD.FillColor, bD.OutlineColor = bF, bF
        bD.FillTransparency = bE + (1 - bE) * bH
        bD.OutlineTransparency = bH

        local bI, bJ, bK = bA.Y - 3, br:FindFirstChild'LeftFoot', br:FindFirstChild'RightFoot'

        if bJ and bK then
            bI = math.min(bJ.Position.Y, bK.Position.Y) - bJ.Size.Y / 2
        end

        local bL, bM = at:WorldToViewportPoint(Vector3.new(bA.X, (bz.Y + bx.Size.Y / 2) + 0.25, bA.Z)), at:WorldToViewportPoint(Vector3.new(bA.X, bI, bA.Z))
        local bN = bM.Y - bL.Y
        local bO, bP = bN * 0.52, (bL.X + bM.X) / 2
        local bQ = bL.Z > 0 and (bM.Z > 0 and (bN > 2 and (bP + bO / 2 > 0 and (bP - bO / 2 < bv.X and (bM.Y > 0 and bL.Y < bv.Y)))))

        bs.outer.Visible = true

        local bR = aC.espArrows and not bQ

        bs.arrow[1].Visible, bs.arrow[2].Visible = bR, bR

        if bR then
            local bS = at.CFrame:PointToObjectSpace(bA)
            local bU, bV = bS.X, -bS.Y
            local bW = math.sqrt(bU * bU + bV * bV)

            if bW < 0.001 then
                bU, bV, bW = 0, 1, 1
            end

            local bX = math.atan2(bV / bW, bU / bW)
            local bY, bZ = bv.X / 2 + math.cos(bX) * aC.espArrowRadius, bv.Y / 2 + math.sin(bX) * aC.espArrowRadius

            for b_ = 1, 2, 1 do
                local b0 = (bX + math.pi) + (b_ == 1 and 0.5 or -0.5)

                c(bs.arrow[b_], bY, bZ, bY + math.cos(b0) * aC.espArrowSize, bZ + math.sin(b0) * aC.espArrowSize, 2, bC)
            end
        end

        local bS = aC.espSnap and bQ

        bs.snap.Visible, bs.snapOut.Visible = bS, bS

        if bS then
            local bU = aC.espSnapFrom == 'Top' and 0 or aC.espSnapFrom == 'Center' and bv.Y / 2 or bv.Y

            c(bs.snapOut, bv.X / 2, bU, bP, bM.Y, 3, bl)

            bs.snapOut.BackgroundTransparency = 0.5

            c(bs.snap, bv.X / 2, bU, bP, bM.Y, 1, bC)
        end

        bs.root.Visible = bQ

        if not bQ then
            return
        end

        local bU, bV = math.floor(bP - bO / 2), math.floor(bL.Y)

        bO, bN = math.floor(bO), math.floor(bN)

        if aC.espBox then
            e(bs, bU, bV, bO, bN, bC)
        else
            for bW = 1, 8, 1 do
                bs.boxOut[bW].Visible, bs.box[bW].Visible = false, false
            end
        end

        bs.fill.Visible = aC.espBoxFill

        if aC.espBoxFill then
            N(bs.fill, bU, bV, bO, bN)

            bs.fill.BackgroundColor3 = bC
        end

        local bW = math.clamp(tonumber(br:GetAttribute'Health') or 100, 0, 100)

        bs.hpBack.Visible, bs.hpBar.Visible = aC.espHealth, aC.espHealth
        bs.hpText.Visible = aC.espHealth and (aC.espHealthText and bW < 100)

        if aC.espHealth then
            local bX = math.max(math.floor((bN * bW) / 100), 1)

            N(bs.hpBack, bU - 6, bV - 1, 4, bN + 2)
            N(bs.hpBar, bU - 5, (bV + bN) - bX, 2, bX)

            bs.hpBar.BackgroundColor3 = bn:Lerp(bm, bW / 100)

            if bs.hpText.Visible then
                bs.hpText.Position = UDim2.fromOffset(bU - 8, (bV + bN) - bX)
                bs.hpText.Size = UDim2.fromOffset(30, 10)
                bs.hpText.TextXAlignment = Enum.TextXAlignment.Right
                bs.hpText.TextSize = math.max(aC.espTextSize - 2, 9)
                bs.hpText.TextColor3 = Color3.new(1, 1, 1)
                bs.hpText.Text = tostring(math.floor(bW + 0.5))
            end
        end

        local bX, bY = (bV + bN) + 2, aC.espArmor and w(bq, bs) or 0
        local bZ = aC.espArmor and bY > 0

        bs.arBack.Visible, bs.arBar.Visible = bZ, bZ

        if bZ then
            N(bs.arBack, bU - 1, bX, bO + 2, 4)
            N(bs.arBar, bU, bX + 1, math.max(math.floor((bO * math.clamp(bY, 0, 100)) / 100), 1), 2)

            bX = bX + 5
        end

        local b_ = aC.espTextSize

        bs.name.Visible = aC.espNames

        if aC.espNames then
            bs.name.Position = UDim2.fromOffset(bP, (bV - b_) - 4)
            bs.name.Size = UDim2.fromOffset(200, b_ + 2)
            bs.name.TextSize, bs.name.TextColor3 = b_, bs.dormant and bC or Color3.new(1, 1, 1)
            bs.name.Text = bs.dormant and ('%s  %.0fs ago'):format(bq.DisplayName, bw - (bs.dormantAt or bw)) or bq.DisplayName
        end

        local b0 = aC.espWeapon and T(bq, bs)

        bs.weapon.Visible = b0 ~= nil and b0 ~= false

        if bs.weapon.Visible then
            bs.weapon.Position = UDim2.fromOffset(bP, bX)
            bs.weapon.Size = UDim2.fromOffset(200, b_ + 2)
            bs.weapon.TextSize, bs.weapon.TextColor3, bs.weapon.Text = b_, bC, b0
            bX = (bX + b_) + 1
        end

        bs.dist.Visible = aC.espDistance

        if aC.espDistance then
            bs.dist.Position = UDim2.fromOffset(bP, bX)
            bs.dist.Size = UDim2.fromOffset(200, b_ + 2)
            bs.dist.TextSize, bs.dist.TextColor3 = math.max(b_ - 1, 9), Color3.fromRGB(210, 210, 215)
            bs.dist.Text = math.floor(bB * 0.28) .. 'm'
        end

        bs.flags.Visible = aC.espFlags

        if aC.espFlags then
            local b1, b2 = {}, w(bq, bs)

            if b2 > 0 then
                b1[#b1 + 1] = '<font color="#6FB4FF">' .. ((bs.arHelmet and 'HK' or 'K') .. '</font>')
            end

            local b3 = tonumber(bq:GetAttribute'Money')

            if b3 then
                b1[#b1 + 1] = '<font color="#7CE38B">$' .. (math.floor(b3) .. '</font>')
            end
            if (tonumber(bq:GetAttribute'ScopeIncrement') or 0) > 0 then
                b1[#b1 + 1] = '<font color="#5CE1E6">ZOOM</font>'
            end
            if bq:GetAttribute'HasDefuseKit' == true then
                b1[#b1 + 1] = '<font color="#C9A6FF">KIT</font>'
            end
            if bq:GetAttribute'IsCrouching' == true then
                b1[#b1 + 1] = '<font color="#D0D0D8">DUCK</font>'
            end
            if t(br) then
                b1[#b1 + 1] = '<font color="#FFD35C">IMMUNE</font>'
            end
            if type(bq) == 'table' and bq.IsBot then
                b1[#b1 + 1] = '<font color="#9A9AA5">BOT</font>'
            end

            local b4 = math.max(b_ - 2, 9)

            bs.flags.Position = UDim2.fromOffset((bU + bO) + 4, bV - 1)
            bs.flags.Size = UDim2.fromOffset(90, #b1 * (b4 + 1) + 2)
            bs.flags.TextSize = b4
            bs.flags.TextColor3 = Color3.new(1, 1, 1)
            bs.flags.Text = table.concat(b1, ' ')
        end

        bs.headDot.Visible = aC.espHeadDot

        if aC.espHeadDot then
            local b1, b2 = at:WorldToViewportPoint(bz), math.max(math.floor(bN * 0.13), 4)

            bs.headDot.Position = UDim2.fromOffset(b1.X, b1.Y)
            bs.headDot.Size = UDim2.fromOffset(b2, b2)
            bs.headStroke.Color = bC
        end

        for b1, b2 in ipairs(bp)do
            local b3, b4, b5 = bs.bones[b1], aC.espSkeleton and br:FindFirstChild(b2[1]), aC.espSkeleton and br:FindFirstChild(b2[2])

            if b4 and b5 then
                local b6, b7 = at:WorldToViewportPoint(b4.Position), at:WorldToViewportPoint(b5.Position)

                if b6.Z > 0 and b7.Z > 0 then
                    c(b3, b6.X, b6.Y, b7.X, b7.Y, 1, bC)
                else
                    b3.Visible = false
                end
            else
                b3.Visible = false
            end
        end
    end

    aa.connect(O.RenderStepped, function(bq)
        if not aC.esp then
            if next(bk) then
                Q()
            end

            return
        end

        local br, bs, bt = (U()).Position, at.ViewportSize, os.clock()

        for bu, bv in ipairs(aa.entities())do
            local bw = bv ~= _ and k(bv)
            local bx = bv ~= _ and (not bw or not CONFIG.TeamCheck or aC.espTeam or CONFIG.ShowTeammates)
            local by, bz = bx and F(bv), false

            if not by and (bx and (not bw and aC.espDormant)) then
                local bA, bB = bv.Character, bk[bv]

                if bA and (bB and (bB.char == bA and (not bA:IsDescendantOf(workspace) and (not bA:GetAttribute'Dead' and (bv:GetAttribute'Dead' == false and bA:FindFirstChild'Head'))))) then
                    bB.dormantAt = bB.dormantAt or bt

                    if bt - bB.dormantAt <= aC.espDormantTime then
                        by, bz = bA, true
                    end
                end
            end

            local bA, bB = bk[bv], 1

            if by then
                if not bA or bA.char ~= by then
                    bA = b(bv, by)
                end
                if not bz then
                    bA.dormantAt = nil
                end

                bA.dormant = bz
            elseif bA and (bx and (bA.char and (bA.char:FindFirstChild'Head' and (bA.char:IsDescendantOf(workspace) or (bA.alpha or 0) > 0)))) then
                bA.goneAt = bA.goneAt or bt

                if bt - bA.goneAt > 3 then
                    C(bv)

                    bA = nil
                else
                    by, bB = bA.char, 0
                    bA.dormant = false
                end
            else
                C(bv)

                bA = nil
            end
            if bA and by then
                if bB == 1 then
                    bA.goneAt = nil
                end
                if aC.espFade <= 0 then
                    bA.alpha = bB
                elseif bA.alpha < bB then
                    bA.alpha = math.min(bA.alpha + bq / aC.espFade, bB)
                else
                    bA.alpha = math.max(bA.alpha - bq / aC.espFade, bB)
                end
                if bB == 0 and bA.alpha <= 0 then
                    bA.root.Visible, bA.outer.Visible, bA.highlight.Enabled = false, false, false
                else
                    local bC = pcall(o, bv, by, bA, bw, br, bs, bt)

                    if not bC then
                        bA.root.Visible, bA.outer.Visible = false, false
                    end

                    a(bA)
                end
            end
        end

        local bu = aa.entities()

        for bv in pairs(bk)do
            if not table.find(bu, bv) then
                C(bv)
            end
        end
    end)
end


-- Bullet tracers: standalone visual port of PASTAHUB's Line / Beam / Lightning renderer.
-- This build detects local Tool.Activated events and estimates the shot ray from the camera.
local tracerConnections = {}
local tracerRainbowHue = 0
local tracerFolder = Instance.new("Folder")
tracerFolder.Name = "NeverLose_BulletTracers"
tracerFolder.Parent = Workspace

local function tracerPart(size, cf, color)
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.CastShadow = false
    part.Material = Enum.Material.Neon
    part.Color = color
    part.Size = size
    part.CFrame = cf
    part.Parent = tracerFolder
    local tween = game:GetService("TweenService"):Create(part, TweenInfo.new(CONFIG.TracerLife, Enum.EasingStyle.Quad), {Transparency = 1})
    tween:Play()
    task.delay(CONFIG.TracerLife + 0.12, function()
        if part and part.Parent then part:Destroy() end
    end)
    return part
end

local function drawBulletTracer(origin, finish)
    if not CONFIG.BulletTracer or (finish - origin).Magnitude < 0.5 then return end
    local color = CONFIG.TracerColor
    if CONFIG.TracerRainbow then
        tracerRainbowHue = (tracerRainbowHue + 0.07) % 1
        color = Color3.fromHSV(tracerRainbowHue, 0.85, 1)
    end
    local delta = finish - origin
    local distance = delta.Magnitude
    local width = CONFIG.TracerWidth / 100
    if CONFIG.TracerStyle == "Beam" then
        local holder = Instance.new("Part")
        holder.Anchored, holder.CanCollide, holder.CanQuery, holder.CanTouch = true, false, false, false
        holder.Transparency = 1
        holder.Size = Vector3.new(0.1, 0.1, 0.1)
        holder.CFrame = CFrame.new(origin)
        holder.Parent = tracerFolder
        local a0 = Instance.new("Attachment", holder)
        local a1 = Instance.new("Attachment", holder)
        a1.WorldPosition = finish
        local beam = Instance.new("Beam")
        beam.Attachment0, beam.Attachment1 = a0, a1
        beam.Width0, beam.Width1 = width * 2.5, width * 0.6
        beam.FaceCamera = true
        beam.LightEmission, beam.LightInfluence = 1, 0
        beam.Color = ColorSequence.new(color)
        beam.Parent = holder
        task.spawn(function()
            local started = os.clock()
            while holder.Parent and os.clock() - started < CONFIG.TracerLife do
                local alpha = (os.clock() - started) / math.max(CONFIG.TracerLife, 0.01)
                beam.Transparency = NumberSequence.new(alpha * 0.9, math.min(1, 0.3 + alpha))
                task.wait(0.03)
            end
            if holder.Parent then holder:Destroy() end
        end)
    elseif CONFIG.TracerStyle == "Lightning" then
        local segments = math.clamp(math.floor(distance / 4), 4, 14)
        local direction = delta.Unit
        local side = direction:Cross(Vector3.new(0, 1, 0))
        if side.Magnitude < 0.001 then side = Vector3.new(1, 0, 0) end
        side = side.Unit
        local up = side:Cross(direction).Unit
        local previous = origin
        for i = 1, segments do
            local point = origin + delta * (i / segments)
            if i < segments then
                point = point + side * (math.random() - 0.5) * 0.9 + up * (math.random() - 0.5) * 0.9
            end
            local length = (point - previous).Magnitude
            if length > 0.05 then
                tracerPart(Vector3.new(width, width, length), CFrame.lookAt((previous + point) / 2, point), color)
            end
            previous = point
        end
    else
        tracerPart(Vector3.new(width, width, distance), CFrame.lookAt((origin + finish) / 2, finish), color)
    end
end

local function attachTracerTool(tool)
    if not tool:IsA("Tool") or tracerConnections[tool] then return end
    tracerConnections[tool] = tool.Activated:Connect(function()
        if not CONFIG.BulletTracer then return end
        local camera = Workspace.CurrentCamera
        if not camera then return end
        local origin = camera.CFrame.Position
        if CONFIG.TracerFrom == "Gun" then
            local muzzle = tool:FindFirstChild("Muzzle", true)
            if muzzle and muzzle:IsA("BasePart") then
                origin = muzzle.Position
            elseif muzzle and muzzle:IsA("Attachment") then
                origin = muzzle.WorldPosition
            else
                origin = (camera.CFrame * CFrame.new(0.35, -0.35, -1.2)).Position
            end
        end
        local rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.IgnoreWater = true
        rayParams.FilterDescendantsInstances = {LocalPlayer.Character, tracerFolder}
        local direction = camera.CFrame.LookVector * 1500
        local result = Workspace:Raycast(origin, direction, rayParams)
        if CONFIG.TracerOnlyHits and not result then return end
        local finish = result and result.Position or (origin + direction)
        drawBulletTracer(origin, finish)
    end)
end

local function watchCharacter(character)
    for _, child in ipairs(character:GetChildren()) do attachTracerTool(child) end
    character.ChildAdded:Connect(attachTracerTool)
end
if LocalPlayer.Character then watchCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(watchCharacter)
local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
if backpack then
    for _, child in ipairs(backpack:GetChildren()) do attachTracerTool(child) end
    backpack.ChildAdded:Connect(attachTracerTool)
end


local cleanupShitaro
cleanup = function()
    pcall(cleanupShitaro)
    for tool, connection in pairs(tracerConnections) do
        pcall(function() connection:Disconnect() end)
        tracerConnections[tool] = nil
    end
    if tracerFolder and tracerFolder.Parent then tracerFolder:Destroy() end
    for _, connection in ipairs(espConnections) do pcall(function() connection:Disconnect() end) end
    for _, callback in ipairs(espUnloadCallbacks) do pcall(callback) end
    if gui and gui.Parent then gui:Destroy() end
end

-- `script` can be nil when this file is executed through loadstring.
if script then
    pcall(function()
        script.Destroying:Connect(cleanup)
    end)
end


-- PASTAHUB shitaro.lol Movement adapter.
-- The exact movement simulation adapter is extracted from the supplied PASTAHUB source.
local aa = { unloaded = false, cleanups = {}, shitaro = nil }
function aa.onUnload(fn)
    if type(fn) == "function" then
        aa.cleanups[#aa.cleanups + 1] = fn
    end
end

local shCode = [====[

local aa, L, LP = ...

local function shHookField(tbl, key, wrap)
    local orig = rawget(tbl, key)

    if type(orig) ~= 'function' then
        return nil
    end

    local new = wrap(orig)

    if type(new) ~= 'function' then
        return orig
    end

    local function setField(v)
        local okRO, ro = false, false

        if isreadonly then
            okRO, ro = pcall(isreadonly, tbl)
        end
        if okRO and ro and setreadonly then
            pcall(setreadonly, tbl, false)
        end

        local ok = pcall(function()
            tbl[key] = v
        end)

        if okRO and ro and setreadonly then
            pcall(setreadonly, tbl, true)
        end

        return ok
    end

    if not setField(new) then
        return orig
    end

    aa.onUnload(function()
        if rawget(tbl, key) == new then
            setField(orig)
        end
    end)

    return orig
end

local shOk, shMv = pcall(function()
    return require(L.MovementV2.Client.Runtime)
end)

return (function(shLP, shStorage, shMvRuntime)
    local R = {lp = shLP, storage = shStorage}
    local _ = {
        field = shHookField,
        teardown = function(fn)
            aa.onUnload(fn)

            return fn
        end,
    }
    local N = {mv_runtime = shMvRuntime}
    local h = {apply = function() end}
    local F = {cmd_samples = 0, expires = 0, yaw = 0, pitch = 0, clear = function() end}

    local t,f,l=R.lp,R.storage,math.clamp;
    local g=math.floor;
    local u=math.sqrt;
    local s=math.abs;
    local C=math.cos;
    local z,q=math.sin,3.141592653589793;
    local r=bit32.bor;
    local x=bit32.band;
    local G,a,m,c,n,O,j=bit32.bnot,{bhop=false,strafe=false,edge_jump=false,jump_bug=false,edge_bug=false,slow_walk=false,pixel_surf=false};
    local E,P,T,Y,v,Z,L=false;
    do 
    local o=f:FindFirstChild("MovementV2");
    if o then 
    	local X,Q,S,A,J,y=pcall(function()
    		return require(o.Simulation),require(o.Simulation.State),require(o.Simulation.RuntimeSettings),require(o.Serial),require(o.Buttons);
    	end);
    	if X and type(Q)=="table"then 
    		if type(Q.step)=="function"then 
    			if type(S)=="table"then 
    				if type(A)=="table"then 
    					if type(J)=="table"then 
    						if type(y)=="table"then 
    							local o=true;
    							m,c,n,O,j,E=Q,S,A,J,y,o;
    						else 
    						end;
    					else 
    					end;
    				else 
    				end;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    else 
    end;
    P,T,Y,v,Z,L=m,c,n,O,j,E;end;
    			local m=Z and Z.Jump or 1;
    local c=Z and Z.Duck or 2;
    local n,O,j=Z and Z.Walk or 4,{char=nil,runtime=nil,bug_pending=false,hz=nil,config=nil,strafe_yaw=nil,strafe_side=1,capture=false,world=nil,world_tick=nil,world_owner=nil},{mode=nil,normal=nil,duck=false,wide=false,ticks=0,check=0,away=0,rest=0,jump=false,air=false};
    local E=math.round;
    local o=math.max;
    local X=math.log;
    local Q,S,A,J=math.exp,6.283185307179586,{1,0.5,0},{};
    for y=0,7,1 do 
    	f=y*q/4;
    	J[y+1]=Vector3.new(C(f),0,z(f));
    end;
    local y={};
    y[1]=Vector2.zero;
    for e=0,15,1 do 
    	R=e*q/8;
    	y[#y+1]=Vector2.new(C(R),z(R));
    end;
    local e,M={},{};
    f=N.mv_runtime;
    if type(f)=="table"then 
    	if type(rawget(f,"advance"))=="function"then 
    		_.field(f,"advance",function(I)
    			return function(i,...)
    				O.runtime=i;
    				return I(i,...);
    			end;
    		end);
    	end;
    end;
    if type(f)=="table"then 
    	if type(rawget(f,"_composeWorld"))=="function"then 
    		R=_.field(f,"_composeWorld",function(I)
    			return function(i,k,...)
    				local B,d=I(i,k,...);
    				if B~=nil then 
    					O.world=B;
    					O.world_tick=k;
    					O.world_owner=i;
    				end;
    				return B,d;
    			end;
    		end);
    		O.capture=rawget(f,"_composeWorld")~=R;
    		_.teardown(function()
    			O.capture=false;
    			O.world=nil;
    			O.world_tick=nil;
    			O.world_owner=nil;
    		end);
    	end;
    end;
    local function I(i,k,B)
    	if Z then 
    		if type(Z.with)=="function"then 
    			return Z.with(i,k,B);
    		end;
    	end;
    	if B then 
    		return r(i,k);
    	end;
    	return x(i,G(k));
    end;
    local function Z(i)
    	local k=O.runtime;
    	if type(k)~="table"then 
    		return nil;
    	end;
    	if rawget(k,"_started")~=true then 
    		return nil;
    	end;
    	if type(i)=="table"then 
    		local B=rawget(k,"_mapping");
    		if type(B)~="table"then 
    			return nil;
    		elseif B.Generation~=i.Generation then 
    			return nil;
    		end;
    	end;
    	return k;
    end;
    local function i(k)
    	local B=type(k)=="table"and tonumber(k.SimulationHz)or nil;
    	if not(B)then 
    		return nil;
    	end;
    	if O.hz==B then 
    		if O.config then 
    			return O.config;
    		end;
    	end;
    	local k,d=pcall(Y.getMovementConfig,B);
    	if k then 
    		if type(d)~="table"then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	O.hz=B;
    	O.config=d;
    	return d;
    end;
    local function Y(k,B)
    	if L then 
    		if type(k)~="table"then 
    			return nil;
    		elseif type(B)~="table"then 
    			return nil;
    		elseif type(k.Support)~="table"then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	local L=tonumber(k.ServerTick);
    	if not(L)then 
    		return nil;
    	end;
    	local d=Z(k.Mapping);
    	if not(d)then 
    		return nil;
    	end;
    	local Z=rawget(d,"_commandStream");
    	if type(Z)~="table"then 
    		return nil;
    	end;
    	local b=O.world_owner==d and O.world_tick==L and O.world or nil;
    	if b then 
    	else 
    		if O.capture then 
    		else 
    			local p=rawget(d,"_timeline");
    			if type(p)~="table"then 
    				return nil;
    			end;
    			local D,V=pcall(p.resolve,p,L);
    			if D then 
    				if type(V)~="table"then 
    					return nil;
    				end;
    			else 
    				return nil;
    			end;
    			p,D=pcall(d._composeWorld,d,L,V.Revision,nil,B);
    			b=p and D or nil;
    		end;
    	end;
    	if type(b)~="table"then 
    		return nil;
    	elseif type(b.Composed)~="table"then 
    		return nil;
    	elseif type(b.Composed.Query)~="table"then 
    		return nil;
    	end;
    	L=i(k.Mapping);
    	if not L then 
    		return nil;
    	end;
    	local i,p=pcall(Z.lastSampledCommandNumber,Z);
    	if not(i)then 
    		return nil;
    	end;
    	Z,i=pcall(v.addUInt32,p or 4294967295,1);
    	if not Z then 
    		return nil;
    	end;
    	return{runtime=d,state=B,support=k.Support,world=b,config=L,step=l(tonumber(k.StepSeconds)or 0.015625,0.001,0.05),number=i};
    end;
    local function v(Z)
    	local L,i=pcall(T.clone,Z.state);
    	if L then 
    		if type(i)~="table"then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	local L,k=pcall(T.cloneSupport,Z.support);
    	if L then 
    		if type(k)~="table"then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	return i,k;
    end;
    local function T(Z)
    	local L=E(Z%S/S*65536)%65536/65536*S;
    	if L>=q then 
    		return L-S;
    	end;
    	return L;
    end;
    local function q(Z,L,S,i,k,B,d,b)
    	local p,D=pcall(Z.runtime._resolveSupportMotion,Z.runtime,Z.world,L,S);
    	if not(p)then 
    		return nil;
    	end;
    	local p,V,W,H=pcall(P.step,L,S,{CommandNumber=i,Move=Vector2.new(E(l(k.X,-1,1)*127)/127,E(l(k.Y,-1,1)*127)/127),LookYaw=T(B),VerticalLook=E(l(d,-1,1)*127)/127,Buttons=b},Z.step,Z.world.Composed.Query,D,Z.config,nil);
    	if p then 
    		if type(V)~="table"then 
    			return nil;
    		elseif type(W)~="table"then 
    			return nil;
    		elseif type(H)~="table"then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	return V,W,H;
    end;
    local function E(P,T,Z,L,S)
    	local i,k=v(P);
    	if not(i)then 
    		return nil;
    	end;
    	return q(P,i,k,P.number,T,Z,L,S);
    end;
    local function q(P,T,v,Z)
    	if Z.Landed then 
    		return false;
    	elseif Z.StartSolid then 
    		return false;
    	elseif T.OnGround==true then 
    		return false;
    	elseif v.OnGround==true then 
    		return false;
    	end;
    	local L,S=T.Velocity,v.Velocity;
    	if typeof(L)~="Vector3"then 
    		return false;
    	elseif typeof(S)~="Vector3"then 
    		return false;
    	elseif L.Y>=-4 then 
    		return false;
    	end;
    	Z=s(tonumber(P.config.Gravity)or 60);
    	local i=math.max(1.25,Z*P.step*1.35);
    	if s(S.Y)>i then 
    		return false;
    	elseif S.Y<=L.Y+4 then 
    		return false;
    	end;
    	return v.Position.Y<=T.Position.Y+0.05;
    end;
    local function P(T,v,Z,L,S)
    	local i=I(I(S,m,false),c,false);
    	local k,B,B=E(T,v,Z,L,i);
    	if not(k)then 
    		return nil;
    	end;
    	if q(T,T.state,k,B)then 
    		return v,false;
    	end;
    	if not(B.Landed)then 
    		return nil;
    	end;
    	k=#y+1;
    	for d=0,#y,1 do 
    		S=d+1;
    		e[S]=d;
    		M[S]=((d==0 and v or y[d])-v).Magnitude;
    	end;
    	for d=2,k,1 do 
    		local b,p,D=e[d],M[d],d-1;
    		while D>=1 and M[D]>p do 
    			e[D+1]=e[D];
    			M[D+1]=M[D];
    			D-=1;
    		end;
    		e[D+1]=b;
    		M[D+1]=p;
    	end;
    	local d,b,p;
    	for D=0,1,1 do 
    		B=D==1;
    		local V,W=B and 0.25 or 0,I(i,c,B);
    		for i=1,k,1 do 
    			S=e[i];
    			if D~=0 or S~=0 then 
    				local e=M[i]+V;
    				if d then 
    					if e>=d then 
    						break;
    					end;
    				end;
    				local M=S==0 and v or y[S];
    				local v,S,S=E(T,M,Z,L,W);
    				if v then 
    					if q(T,T.state,v,S)then 
    						d,b,p=e,M,B;
    						break;
    					end;
    				end;
    			end;
    		end;
    	end;
    	return b,p;
    end;
    local function q(T,v)
    	local Z,L=z(v),C(v);
    	local S,y=L*T.X+Z*T.Y,-Z*T.X+L*T.Y;
    	v=S*S+y*y;
    	if v>1 then 
    		T=1/u(v);
    		S,y=S*T,y*T;
    	else 
    	end;
    	return Vector3.new(S,0,y);
    end;
    local function u(T,v)
    	local Z,L=z(v),C(v);
    	return Vector2.new(L*T.X-Z*T.Z,Z*T.X+L*T.Z);
    end;
    local function T(v,Z,L,S)
    	local y=Vector3.new(L.X,0,L.Z);
    	local e,M=y.Magnitude,O.strafe_yaw;
    	O.strafe_yaw=Z;
    	if e<=0.05 then 
    		if v.Magnitude>0.001 then 
    			return v.Magnitude>1 and v.Unit or v;
    		end;
    		L=O.strafe_side or 1;
    		O.strafe_side=L;
    		return Vector2.new(L,0);
    	end;
    	L=y/e;
    	e=Vector3.new(L.Z,0,-L.X);
    	y=q(v,Z):Dot(e);
    	v=nil;
    	if s(y)>0.01 then 
    		v=y>0 and 1 or-1;
    	else 
    		if M~=nil then 
    			L=math.atan2(z(Z-M),C(Z-M));
    			v=if s(L)>1.0E-4 then L>0 and 1 or-1 else v;
    		else 
    		end;
    	end;
    	if v then 
    	else 
    		y=tonumber(S);
    		v=if y then g(y)%2==0 and 1 or-1 else-(O.strafe_side or 1);
    	end;
    	O.strafe_side=v;
    	return u(e*v,Z);
    end;
    local function g(v)
    	if typeof(v)~="Vector3"then 
    		return nil;
    	elseif s(v.Y)>=0.7 then 
    		return nil;
    	end;
    	local Z=Vector3.new(v.X,0,v.Z);
    	if Z.Magnitude<0.3 then 
    		return nil;
    	end;
    	return Z.Unit;
    end;
    local function v(Z)
    	return Z.Stance=="Ducking"and"Ducking"or"Standing";
    end;
    local function Z(L,S)
    	local y=S=="Ducking"and L.PlayerSizeDucking or L.PlayerSizeStanding;
    	return typeof(y)=="Vector3"and y.X*0.5 or 1.2;
    end;
    local function L(S,y)
    	local e=y=="Ducking"and S.PlayerSizeDucking or S.PlayerSizeStanding;
    	return typeof(e)=="Vector3"and e.Y*0.5 or 2.7;
    end;
    local function S(y,e)
    	return e.Position.Y-L(y,v(e));
    end;
    local function y(e)
    	local M,i=e.PlayerSizeStanding,e.PlayerSizeDucking;
    	if typeof(M)~="Vector3"then 
    		return 0.27;
    	elseif typeof(i)~="Vector3"then 
    		return 0.27;
    	end;
    	return(M.Y-i.Y)*(tonumber(e.DuckJumpOriginShiftFraction)or 0.2);
    end;
    local function e(M)
    	local i=tonumber(M.DuckAmount);
    	if i then 
    		if i>=0.999 then 
    			return true;
    		end;
    	end;
    	i=tonumber(M.DuckCooldownSeconds);
    	if i then 
    		if i>0 then 
    			local i=tonumber(M.DuckAmount);
    			if i then 
    				if i<=0.75 then 
    					return false;
    				end;
    			else 
    				return false;
    			end;
    		end;
    	end;
    	return(tonumber(M.DuckSpeed)or 8)>=3.5;
    end;
    local function M(i,k,B,d)
    	local b,p=pcall(i.Sweep,i,k,B,d,nil,1,1);
    	if b then 
    		if type(p)=="table"then 
    			return p;
    		end;
    	end;
    	return nil;
    end;
    local function i(k,B,d,b)
    	local p,D=pcall(k.FindGround,k,B,d,b,1);
    	if p then 
    		if type(D)=="table"then 
    			return D;
    		end;
    	end;
    	return nil;
    end;
    local function k(B,d,b)
    	local p,D=pcall(B.IsClear,B,d,b,1);
    	return p and D==true;
    end;
    local function B(d,b)
    	if b<=0 then 
    		return 0;
    	end;
    	local p=o(tonumber(d.Friction)or 5.2,0.1);
    	local D=(tonumber(d.GroundAccelerate)or 5.5)*o(tonumber(d.DefaultBaseMoveSpeed)or 18.75,1)/p;
    	d=X(1+b/D)/p;
    	return(b+D)/p*(1-Q(-p*d))-D*d;
    end;
    local function X(Q,d,b,p,D)
    	local V=d-Vector3.new(0,0.5,0);
    	d=V+b*(p*2+0.35);
    	if not(k(Q,d,D))then 
    		return b;
    	end;
    	p=M(Q,d,V,D);
    	if p then 
    		if not(p.StartSolid)then 
    			V=tonumber(p.Fraction);
    			if V then 
    				if V<1 then 
    					Q=g(p.Normal);
    					if Q then 
    						if Q:Dot(b)>0.5 then 
    							return Q;
    						end;
    					end;
    				end;
    			end;
    		end;
    	end;
    	return b;
    end;
    local function Q(d)
    	return(tonumber(d.MaxStepHeight)or 1.35)+0.15;
    end;
    local function d(b,p,D,V)
    	return k(b,p,D)and i(b,p,D,V)==nil;
    end;
    local function b(p,D,V)
    	return i(p,D,V,1.5)~=nil;
    end;
    local function p(D)
    	j.mode=nil;
    	j.normal=nil;
    	j.duck=false;
    	j.wide=false;
    	j.ticks=0;
    	j.check=0;
    	j.away=0;
    	if D then 
    		j.rest=10;
    	end;
    end;
    local function D(V,W)
    	local H,w,UQ,KQ=V.world.Composed.Query,V.config,v(W),W.Position;
    	local RQ,_Q,NQ=Z(w,UQ),Q(w),j.mode=="catch"and j.normal or nil;
    	p(false);
    	NQ=NQ and(if d(H,KQ+NQ*(RQ*2+0.6),UQ,_Q)then NQ else nil);
    	if NQ then 
    	else 
    		W,V=RQ*2+0.35,Vector3.zero;
    		for hQ=1,#J,1 do 
    			w=J[hQ];
    			V=if d(H,KQ+w*W,UQ,_Q)then V+w else V;
    		end;
    		NQ=if V.Magnitude>0.3 then X(H,KQ,V.Unit,RQ,UQ)else NQ;
    	end;
    	if not(NQ)then 
    		return;
    	end;
    	j.mode="ride";
    	j.normal=NQ;
    	j.wide=not d(H,KQ-NQ*(RQ*2+0.35),UQ,_Q);
    end;
    local function X(V,W,H,w,UQ,KQ,RQ)
    	local _Q,NQ,hQ=V.world.Composed.Query,V.config,j.normal;
    	local FQ,tQ=Vector3.new(-hQ.Z,0,hQ.X),q(H,w);
    	H=tQ:Dot(hQ);
    	if H>0.7 then 
    		j.away=j.away+1;
    		if j.away>=30 then 
    			p(true);
    			return nil;
    		end;
    	else 
    		j.away=0;
    	end;
    	local fQ=v(W);
    	j.check=j.check+1;
    	if j.check>=8 then 
    		j.check=0;
    		if not(d(_Q,W.Position+hQ*(Z(NQ,fQ)*2+0.6),fQ,Q(NQ)))then 
    			p(false);
    			return nil;
    		end;
    	end;
    	local Q,d,lQ,gQ,uQ=I(I(KQ,m,false),c,false),tQ:Dot(FQ),RQ:Dot(hQ),RQ:Dot(FQ),false;
    	KQ=B(NQ,s(gQ))+0.45;
    	if s(gQ)>0.5 and not b(_Q,W.Position+FQ*(gQ>0 and KQ or-KQ),fQ)then 
    		d,uQ=gQ>0 and-1 or 1,true;
    	else 
    		if s(d)>0.05 and(d*gQ<=0 or s(gQ)<=0.5)then 
    			if b(_Q,W.Position+FQ*(d>0 and KQ or-KQ),fQ)then 
    			else 
    				RQ,tQ=true,0;
    				d,uQ=tQ,RQ;
    			end;
    		else 
    		end;
    	end;
    	fQ=if j.wide then o(lQ,0)*0.9+o(-H,0)else lQ*0.9;
    	for KQ=1,3,1 do 
    		gQ=if KQ==1 then FQ*d-hQ*l(fQ,-1,1)else if KQ==2 then FQ*(d*0.5)-hQ*(lQ>=0 and 1 or-1)else Vector3.zero;
    		gQ=if gQ.Magnitude>1 then gQ.Unit else gQ;
    		W=gQ.Magnitude>0.01 and u(gQ,w)or Vector2.zero;
    		if KQ==1 then 
    			if not(uQ)then 
    				if lQ<=0 then 
    					if gQ:Dot(hQ)<=0 then 
    						return W;
    					end;
    				end;
    			end;
    		end;
    		RQ=E(V,W,w,UQ,Q);
    		if RQ then 
    			if RQ.OnGround==true then 
    				H=RQ.Velocity;
    				tQ=H.X*hQ.X+H.Z*hQ.Z;
    				if tQ<=0.35 then 
    					return W;
    				elseif b(_Q,RQ.Position+hQ*B(NQ,tQ),v(RQ))then 
    					return W;
    				end;
    			end;
    		end;
    	end;
    	p(true);
    	return nil;
    end;
    local function l(Q,B,d,b)
    	local V=Vector3.new(d.X,0,d.Z);
    	local W,H,w,UQ=V.Magnitude>1 and V.Unit or nil,Q.world.Composed.Query,v(B),B.Position;
    	V=if W then b+W*0.6 else b;
    	if V.Magnitude<0.15 then 
    		return nil;
    	end;
    	d=g(B.WallNormal);
    	B,b=d and-V.Unit:Dot(d)or nil,d;
    	for KQ=1,#J,1 do 
    		d=J[KQ];
    		if V:Dot(d)>0.15 then 
    			Q=M(H,UQ,UQ+d*2.6,w);
    			if Q then 
    				if Q.AllSolid then 
    				else 
    					KQ=tonumber(Q.Fraction);
    					if KQ then 
    						if KQ<1 then 
    							W=g(Q.Normal);
    							if W then 
    								local g=-V.Unit:Dot(W);
    								if g>0.25 then 
    									if B then 
    										if g>B then 
    											B,b=g,W;
    										else 
    										end;
    									else 
    										B,b=g,W;
    									end;
    								else 
    								end;
    							else 
    							end;
    						else 
    						end;
    					else 
    					end;
    				end;
    			else 
    			end;
    		else 
    		end;
    	end;
    	return b;
    end;
    local function g(Q,J,M,B)
    	local d,b,V,W=Q.world.Composed.Query,Q.config,J.Position,v(J);
    	local v,H=S(b,J),s(tonumber(b.Gravity)or 60);
    	local S,w,UQ,KQ,RQ=B.Y>0 and B.Y*B.Y/(2*H)or 0,o(0,tonumber(b.AutoJumpLedgeAssistHeight)or 0),L(b,W),(tonumber(J.DuckAmount)or 0)>=0.999,0;
    	if KQ then 
    	else 
    		RQ=y(b);
    		RQ=if W~="Ducking"then RQ+(b.PlayerSizeStanding.Y-b.PlayerSizeDucking.Y)*0.5 else RQ;
    	end;
    	Q=i(d,V,W,14);
    	H,B=Q and Q.Position.Y-UQ or v-14,v+S;
    	Q,v=B+w;
    	for L=1,3,1 do 
    		S=V-M*(L==1 and 0.1 or L==2 and 0.4 or Z(b,W)+0.2);
    		for Z=1,#A,1 do 
    			w=Q+RQ*A[Z]+0.2;
    			L=Vector3.new(S.X,w+UQ,S.Z);
    			if k(d,L,W)then 
    				Z=i(d,L,W,w-H+14);
    				if Z then 
    					v=Z.Position.Y-UQ;
    					break;
    				end;
    			end;
    		end;
    		if v then 
    			break;
    		end;
    	end;
    	if v then 
    		if v<=H+0.6 then 
    			return nil;
    		end;
    	else 
    		return nil;
    	end;
    	if v<=B-0.2 then 
    		return KQ;
    	end;
    	if RQ>0 then 
    		if v<=Q+RQ then 
    			if e(J)then 
    				return true;
    			end;
    		end;
    	end;
    	if v<=Q then 
    		return KQ;
    	end;
    	return nil;
    end;
    local function v(Z,L,o,Q,S,A)
    	local J,y=q(o,Q),j.mode=="catch"and j.normal or nil;
    	if y then 
    		j.ticks=j.ticks+1;
    		if j.ticks>40 then 
    			p(false);
    			y=nil;
    		else 
    			if J:Dot(y)>0.7 then 
    				p(false);
    				y=nil;
    			else 
    			end;
    		end;
    	else 
    	end;
    	o=y;
    	if not o then 
    		y=l(Z,L,S,J);
    		if not(y)then 
    			return nil;
    		end;
    		local l=g(Z,L,y,S);
    		if l==nil then 
    			return nil;
    		end;
    		j.mode="catch";
    		j.normal=y;
    		j.duck=l;
    		j.ticks=0;
    		j.check=0;
    		return u(-y,Q),l or A;
    	end;
    	j.check=j.check+1;
    	if j.check>=3 then 
    		j.check=0;
    		J=g(Z,L,o,S);
    		if J==nil then 
    			p(false);
    			return nil;
    		end;
    		if J then 
    			j.duck=true;
    		end;
    	end;
    	return u(-o,Q),j.duck or A;
    end;
    local function l(g,u,q,Z,L,o,Q,S,A,J,y)
    	if S then 
    		if y then 
    			p(true);
    			return nil;
    		end;
    		if A or j.mode=="catch"then 
    			if j.rest>0 then 
    				p(false);
    				return nil;
    			elseif J then 
    				p(false);
    				return nil;
    			end;
    			D(g,u);
    		end;
    		if j.mode~="ride"then 
    			return nil;
    		end;
    		local S=X(g,u,q,Z,L,o,Q);
    		if S then 
    			return S,false;
    		end;
    		return nil;
    	end;
    	if j.mode=="ride"then 
    		p(false);
    	end;
    	if j.rest>0 then 
    		return nil;
    	end;
    	return v(g,u,q,Z,Q,x(o,c)~=0);
    end;
    local function g(u)
    	O.char=u;
    	O.bug_pending=false;
    	O.hz=nil;
    	O.config=nil;
    	O.strafe_yaw=nil;
    	O.strafe_side=1;
    	j.mode=nil;
    	j.normal=nil;
    	j.duck=false;
    	j.wide=false;
    	j.ticks=0;
    	j.check=0;
    	j.away=0;
    	j.rest=0;
    	j.jump=false;
    	j.air=false;
    end;
    local function u(q,v,Z)
    	local L=v and v.State or q and q.MovementState;
    	if type(L)~="table"then 
    		return nil;
    	end;
    	local o=q and q.Character;
    	if O.char~=o then 
    		g(o);
    	end;
    	local X,Q,S,A,J,y,e,M,i=tonumber(Z.Buttons)or 0,typeof(Z.Move)=="Vector2"and Z.Move or Vector2.zero,tonumber(Z.LookYaw)or tonumber(L.LookYaw)or 0,tonumber(Z.VerticalLook)or tonumber(L.VerticalLook)or 0,typeof(L.Velocity)=="Vector3"and L.Velocity or q and q.GlobalVelocity or Vector3.zero,L.OnGround==true,L.MovementMode==nil or L.MovementMode=="Walking";
    	o=false;
    	if not(a.jump_bug)then 
    		O.bug_pending=false;
    	end;
    	if e and a.strafe then 
    		if y then 
    			O.strafe_yaw=nil;
    		end;
    	else 
    		O.strafe_yaw=nil;
    	end;
    	local k=x(X,m)~=0;
    	local B,d=k and not j.jump,j.air and y;
    	j.jump=k;
    	local b=not y;
    	j.air=b;
    	local D=a.pixel_surf and e;
    	if D then 
    		if j.rest>0 then 
    			j.rest=j.rest-1;
    		end;
    	elseif j.mode~=nil then 
    		p(false);
    	end;
    	local j=if e and a.bhop then if q then if q.JumpInputDown then y else nil else nil else nil;
    	if O.bug_pending then 
    		O.bug_pending=false;
    		if a.jump_bug then 
    			if e then 
    				if y then 
    					local p,V,W=true,false,true;
    					j,M,o=p,V,W;
    				else 
    				end;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    	q=e and(D or a.edge_jump and y or(if y then b else a.jump_bug or a.edge_bug))and Y(v,L)or nil;
    	if q and not o then 
    		if D then 
    			local Y,p=l(q,L,Q,S,A,X,J,y,d,k,B);
    			if Y then 
    				local l,V,W=false,p==true,true;
    				j,M,i,o=l,V,Y,W;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    	if q and not o then 
    		if a.edge_jump then 
    			if y then 
    				B,k,L=E(q,Q,S,A,I(X,m,false));
    				j=if B and L.LeftGround then if L.Jumped then j else if B.OnGround~=true then true else j else j;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    	if q and not o and a.edge_bug and b then 
    		if J.Y<-4 then 
    			d=if j~=nil then(I(X,m,j))else X;
    			d=if M~=nil then(I(d,c,M))else d;
    			L,D=P(q,Q,S,A,d);
    			if typeof(L)=="Vector2"then 
    				local l,P,Y=false,D==true,true;
    				j,M,i,o=l,P,L,Y;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    	if q and not o and a.jump_bug and b then 
    		if J.Y<-4 then 
    			L=I(I(X,m,false),c,true);
    			d,D,B=E(q,Q,S,A,L);
    			if d then 
    				if B.Landed then 
    					O.bug_pending=true;
    					local l,q,O=false,true,true;
    					j,M,o=l,q,O;
    				else 
    				end;
    			else 
    			end;
    		else 
    		end;
    	else 
    	end;
    	i=if(if o then not o else e)and a.strafe then if y then i else T(Q,S,J,v and v.ServerTick)else i;
    	if typeof(i)=="Vector2"then 
    		Z.Move=i;
    	end;
    	X=if j~=nil then(I(X,m,j))else X;
    	X=if M~=nil then(I(X,c,M))else X;
    	Z.Buttons=if a.slow_walk and e then if y then I(X,n,true)else X else X;
    	return M;
    end;
    local function l(q,m,c)
    	if typeof(q.Move)~="Vector2"then 
    		return;
    	end;
    	local n=m-c;
    	if s(n)<=1.0E-6 then 
    		return;
    	end;
    	local s,m,c=C(n),z(n),q.Move;
    	q.Move=Vector2.new(c.X*s-c.Y*m,c.X*m+c.Y*s);
    end;

    return {
        cfg = a,
        sample = function(char, arg, cmd)
            local duck = u(char, arg, cmd)

            if duck ~= nil then
                local b = tonumber(cmd.Buttons) or 0

                if duck then
                    cmd.Buttons = r(b, 2)
                else
                    cmd.Buttons = x(b, G(2))
                end
            end
        end,
        reset = function()
            g(nil)
        end,
    }
end)(LP, L, shOk and shMv or nil)

]====]

if type(loadstring) == "function" then
    local compilerOk, shFn = pcall(loadstring, shCode, "=NeverLose_shitaro_movement")
    if compilerOk and type(shFn) == "function" then
        local runOk, shResult = pcall(shFn, aa, ReplicatedStorage, LocalPlayer)
        if runOk and type(shResult) == "table" then
            aa.shitaro = shResult
        end
    end
end

local function syncShitaroConfig()
    local sh = aa.shitaro
    if not sh or type(sh.cfg) ~= "table" then return end
    sh.cfg.bhop = CONFIG.ShBhop == true
    sh.cfg.strafe = CONFIG.ShStrafe == true
    sh.cfg.edge_jump = CONFIG.ShEdgeJump == true
    sh.cfg.jump_bug = CONFIG.ShJumpBug == true
    sh.cfg.edge_bug = CONFIG.ShEdgeBug == true
    sh.cfg.slow_walk = CONFIG.ShSlowWalk == true
    sh.cfg.pixel_surf = CONFIG.ShPixelSurf == true
end

-- Hook the same Character.SampleInput pipeline used by PASTAHUB so the original
-- Shitaro movement sample can modify the game's MovementV2 command.
do
    local classesFolder = ReplicatedStorage:FindFirstChild("Classes")
    local characterModuleScript = classesFolder and classesFolder:FindFirstChild("Character")
    if characterModuleScript and characterModuleScript:IsA("ModuleScript")
        and type(hookfunction) == "function" then
        local okRequire, characterModule = pcall(require, characterModuleScript)
        local sampleTarget = okRequire and type(characterModule) == "table" and characterModule.SampleInput
        if type(sampleTarget) == "function" then
            local originalSample
            local hookOk, hookResult = pcall(function()
                originalSample = hookfunction(sampleTarget, function(state, ...)
                    local args = table.pack(...)
                    local result = originalSample(state, table.unpack(args, 1, args.n))
                    local sh = aa.shitaro
                    if sh and not aa.unloaded then
                        pcall(sh.sample, state, args[1], result)
                    end
                    return result
                end)
            end)
            if hookOk and type(originalSample) == "function" then
                aa.onUnload(function()
                    if type(restorefunction) == "function" then
                        pcall(restorefunction, sampleTarget)
                    elseif type(hookfunction) == "function" then
                        pcall(hookfunction, sampleTarget, originalSample)
                    end
                end)
            end
        end
    end
end

syncShitaroConfig()
local shitaroConfigSyncConnection = RunService.Heartbeat:Connect(syncShitaroConfig)
aa.onUnload(function()
    if shitaroConfigSyncConnection then pcall(function() shitaroConfigSyncConnection:Disconnect() end) end
end)

cleanupShitaro = function()
    if aa.unloaded then return end
    aa.unloaded = true
    for i = #aa.cleanups, 1, -1 do
        pcall(aa.cleanups[i])
    end
    aa.cleanups = {}
    if aa.shitaro and type(aa.shitaro.reset) == "function" then
        pcall(aa.shitaro.reset)
    end
end

print("[NeverLose / BloxStrike] loaded. RightShift opens/closes the menu.")
