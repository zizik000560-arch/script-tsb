-- THE STRONGEST BATTLEGROUNDS MEGA SCRIPT
-- ПОЛНАЯ ВЕРСИЯ БЕЗ ЗАГРУЗКИ ИЗ ИНТЕРНЕТА
-- РАБОТАЕТ НА XENO
-- РАЗРАБОТЧИК: ECLIPSE HAB | MEVWO

-- ПРОВЕРКА НА XENO
local isXeno = false
if getexecutorname and getexecutorname() == "Xeno" then
    isXeno = true
    print("[TSB] ОБНАРУЖЕН XENO! ЗАПУСК...")
end

if not isXeno then
    print("[TSB] ЭТОТ СКРИПТ РАБОТАЕТ ТОЛЬКО НА XENO!")
    return
end

print("ЗАГРУЗКА СКРИПТА... ПОДОЖДИТЕ 5 СЕКУНД")
wait(5)
print("СКРИПТ ЗАГРУЖЕН! НАЖМИТЕ RIGHT SHIFT ДЛЯ ОТКРЫТИЯ МЕНЮ")

-- ПОДКЛЮЧЕНИЕ СЛУЖБ
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- ===== ПЕРЕМЕННЫЕ =====
local menuOpen = false
local espEnabled = false
local espBoxes = {}
local espLines = {}
local espNames = {}
local espHealth = {}
local espColor = Color3.new(0, 1, 0)
local showNames = true
local showHealth = true
local showDistance = true

-- ФУНКЦИИ
local autoTech = false
local autoDash = false
local autoBlock = false
local autoHeal = false
local speedHack = false
local flyMode = false
local noClip = false
local infHealth = false
local infStamina = false

-- ===== СОЗДАНИЕ GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TSB_Menu"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 600)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- ЗАГОЛОВОК
local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 50)
titleFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
titleFrame.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "ECLIPSE HAB | MEVWO"
titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 22
titleText.Parent = titleFrame

local versionText = Instance.new("TextLabel")
versionText.Size = UDim2.new(1, 0, 0, 20)
versionText.Position = UDim2.new(0, 0, 1, -20)
versionText.BackgroundTransparency = 1
versionText.Text = "v2.5 | THE STRONGEST BATTLEGROUNDS"
versionText.TextColor3 = Color3.new(0.6, 0.6, 0.6)
versionText.Font = Enum.Font.Gotham
versionText.TextSize = 12
versionText.Parent = titleFrame

-- КОНТЕЙНЕР ДЛЯ ВКЛАДОК
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 50)
tabContainer.Position = UDim2.new(0, 0, 1, -50)
tabContainer.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
tabContainer.Parent = mainFrame

local function createTabButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = tabContainer
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -100)
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local currentContent = nil

local function clearContent()
    if currentContent then
        currentContent:Destroy()
        currentContent = nil
    end
end

-- ===== ВКЛАДКА ESP =====
local function createESPTab()
    clearContent()
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.CanvasSize = UDim2.new(0, 0, 0, 400)
    frame.ScrollBarThickness = 8
    frame.Parent = contentFrame
    currentContent = frame

    local y = 10

    local function createToggle(text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        btn.Text = text .. " [ВЫКЛ]"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = frame
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text .. (state and " [ВКЛ]" or " [ВЫКЛ]")
            btn.BackgroundColor3 = state and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.3, 0.3, 0.3)
            callback(state)
        end)
        return btn
    end

    createToggle("ESP (ВКЛ/ВЫКЛ)", y, function(state)
        espEnabled = state
        if not state then
            for _, v in pairs(espBoxes) do v:Destroy() end
            for _, v in pairs(espLines) do v:Destroy() end
            for _, v in pairs(espNames) do v:Destroy() end
            for _, v in pairs(espHealth) do v:Destroy() end
            espBoxes = {}
            espLines = {}
            espNames = {}
            espHealth = {}
        end
    end)
    y = y + 45

    createToggle("Показывать имена", y, function(state) showNames = state end)
    y = y + 45
    createToggle("Показывать здоровье", y, function(state) showHealth = state end)
    y = y + 45
    createToggle("Показывать дистанцию", y, function(state) showDistance = state end)
end

-- ===== ВКЛАДКА TECH =====
local function createTechTab()
    clearContent()
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.CanvasSize = UDim2.new(0, 0, 0, 500)
    frame.ScrollBarThickness = 8
    frame.Parent = contentFrame
    currentContent = frame

    local y = 10

    local function createToggle(text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Position = UDim2.new(0.05, 0, 0, yPos)
        btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
        btn.Text = text .. " [ВЫКЛ]"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = frame
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text .. (state and " [ВКЛ]" or " [ВЫКЛ]")
            btn.BackgroundColor3 = state and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.3, 0.3, 0.3)
            callback(state)
        end)
        return btn
    end

    createToggle("AUTO TECH", y, function(state) autoTech = state end)
    y = y + 45
    createToggle("AUTO DASH", y, function(state) autoDash = state end)
    y = y + 45
    createToggle("AUTO BLOCK", y, function(state) autoBlock = state end)
    y = y + 45
    createToggle("AUTO HEAL", y, function(state) autoHeal = state end)
    y = y + 45
    createToggle("SPEED HACK", y, function(state) speedHack = state end)
    y = y + 45
    createToggle("FLY MODE", y, function(state) flyMode = state end)
    y = y + 45
    createToggle("NO CLIP", y, function(state) noClip = state end)
    y = y + 45
    createToggle("INF HEALTH", y, function(state) infHealth = state end)
    y = y + 45
    createToggle("INF STAMINA", y, function(state) infStamina = state end)
end

-- ===== СОЗДАНИЕ ВКЛАДОК =====
createTabButton("ESP", createESPTab)
createTabButton("TECH", createTechTab)
createTabButton("MISC", function()
    clearContent()
    local frame = Instance.new("ScrollingFrame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.CanvasSize = UDim2.new(0, 0, 0, 200)
    frame.ScrollBarThickness = 8
    frame.Parent = contentFrame
    currentContent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, 10)
    btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    btn.Text = "ТЕЛЕПОРТ К СПАВНУ"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 10, 0)
    end)
end)

-- ЗАГРУЗКА ВКЛАДКИ ПО УМОЛЧАНИЮ
createESPTab()

-- ===== ФУНКЦИИ ESP =====
local function createESP(player)
    if player == LocalPlayer then return end
    if not player.Character or not player.Character:FindFirstChild("Head") then return end

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 40, 0, 80)
    box.BackgroundTransparency = 0.6
    box.BorderSizePixel = 2
    box.BorderColor3 = espColor
    box.BackgroundColor3 = espColor
    box.Parent = screenGui
    table.insert(espBoxes, box)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 150, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = espColor
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Parent = screenGui
    table.insert(espNames, nameLabel)
end

local function updateESP()
    if not espEnabled then return end

    local index = 1
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen and humanoid then
                local distance = (head.Position - Camera.CFrame.Position).Magnitude
                local scale = 100 / distance

                if espBoxes[index] then
                    espBoxes[index].Position = UDim2.new(0, screenPos.X - 20 * scale, 0, screenPos.Y - 40 * scale)
                    espBoxes[index].Size = UDim2.new(0, 40 * scale, 0, 80 * scale)
                end

                if espNames[index] then
                    local nameText = player.Name
                    if showDistance then
                        nameText = nameText .. " [" .. math.floor(distance) .. "m]"
                    end
                    espNames[index].Text = nameText
                    espNames[index].Position = UDim2.new(0, screenPos.X - 75, 0, screenPos.Y - 80 * scale - 25)
                end
                index = index + 1
            end
        end
    end

    while #espBoxes > index do
        local box = table.remove(espBoxes)
        if box then box:Destroy() end
    end
    while #espNames > index do
        local name = table.remove(espNames)
        if name then name:Destroy() end
    end
end

-- ===== ЛОГИКА TECH =====
local function techLogic()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end

    if autoTech then
        local abilities = {"Q", "E", "R", "F", "Z", "X", "C"}
        for _, ability in pairs(abilities) do
            local key = Enum.KeyCode[ability]
            if key then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
                wait(0.1)
                game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
            end
        end
    end

    if autoDash then
        local key = Enum.KeyCode.LeftShift
        game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
        wait(0.05)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
    end

    if autoBlock then
        local key = Enum.KeyCode.F
        game:GetService("VirtualInputManager"):SendKeyEvent(true, key, false, game)
        wait(0.05)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, key, false, game)
    end

    if autoHeal and humanoid.Health < humanoid.MaxHealth * 0.5 then
        humanoid.Health = humanoid.MaxHealth
    end

    if infHealth then
        humanoid.Health = humanoid.MaxHealth
        humanoid.MaxHealth = 999999
    end

    if infStamina and humanoid:FindFirstChild("Stamina") then
        humanoid.Stamina.Value = 999999
    end

    if speedHack then
        humanoid.WalkSpeed = 100
        humanoid.JumpPower = 100
    else
        humanoid.WalkSpeed = 16
        humanoid.JumpPower = 50
    end

    if flyMode then
        root.Velocity = root.Velocity + Vector3.new(0, 10, 0)
    end

    if noClip then
        root.CanCollide = false
    else
        root.CanCollide = true
    end
end

-- ===== ОСНОВНОЙ ЦИКЛ =====
RunService.RenderStepped:Connect(function()
    if espEnabled then updateESP() end
    techLogic()
end)

-- ===== УПРАВЛЕНИЕ МЕНЮ =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        menuOpen = not menuOpen
        mainFrame.Visible = menuOpen
    end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        menuOpen = false
        mainFrame.Visible = false
    end
end)

-- ===== ОБХОД ДЛЯ XENO =====
getgenv().XenoMode = true
game:GetService("TelemetryService"):SetEnabled(false)

print("[TSB] СКРИПТ УСПЕШНО ЗАГРУЖЕН НА XENO!")
print("[TSB] НАЖМИТЕ RIGHT SHIFT ДЛЯ ОТКРЫТИЯ МЕНЮ")
