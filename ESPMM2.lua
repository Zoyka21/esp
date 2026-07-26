--[[
    ESP для MM2 (Murder Mystery 2)
    Роли определяются по BoolValue "Murderer" или "Sheriff" внутри игрока.
    Цвета: красный (убийца), синий (шериф), зелёный (невиновный).
    Метки полупрозрачные, не бросаются в глаза.
    Плавающее окно с кнопкой включения/выключения.
--]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- ========== СОЗДАНИЕ GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_GUI"
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 90)
mainFrame.Position = UDim2.new(0.5, -90, 0.5, -45)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.4
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 20)
title.BackgroundTransparency = 1
title.Text = "ESP Control"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 14
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

-- Кнопка включения
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.Text = "ESP: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.SourceSans
toggleBtn.Parent = mainFrame

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 0.7, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Disabled"
statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
statusLabel.TextSize = 12
statusLabel.Parent = mainFrame

-- ========== ПЕРЕТАСКИВАНИЕ ОКНА ==========
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ========== ESP ЛОГИКА ==========
local espEnabled = false
local espObjects = {} -- player -> BillboardGui

-- Определение роли
local function getRole(player)
    if player:FindFirstChild("Murderer") and player.Murderer.Value == true then
        return "Murderer"
    elseif player:FindFirstChild("Sheriff") and player.Sheriff.Value == true then
        return "Sheriff"
    else
        return "Innocent"
    end
end

-- Создание метки для одного игрока
local function createESP(player)
    if player == localPlayer or espObjects[player] then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local role = getRole(player)
    local color = role == "Murderer" and Color3.fromRGB(255, 50, 50)
                or role == "Sheriff" and Color3.fromRGB(50, 100, 255)
                or Color3.fromRGB(50, 255, 50)

    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 80, 0, 30)
    bill.AlwaysOnTop = true
    bill.Adornee = head
    bill.Parent = head

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.5   -- полупрозрачный фон
    frame.Parent = bill

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = role
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextStrokeTransparency = 0.5
    label.Font = Enum.Font.SourceSansBold
    label.Parent = frame

    espObjects[player] = bill
end

-- Удаление метки
local function removeESP(player)
    local obj = espObjects[player]
    if obj then
        obj:Destroy()
        espObjects[player] = nil
    end
end

-- Обновление всех меток (цвет, текст, привязка)
local function refreshESP()
    for player, obj in pairs(espObjects) do
        local char = player.Character
        if not char then
            removeESP(player)
            continue
        end
        local head = char:FindFirstChild("Head")
        if not head then
            removeESP(player)
            continue
        end
        if obj.Adornee ~= head then
            obj.Adornee = head
        end

        local role = getRole(player)
        local color = role == "Murderer" and Color3.fromRGB(255, 50, 50)
                    or role == "Sheriff" and Color3.fromRGB(50, 100, 255)
                    or Color3.fromRGB(50, 255, 50)

        local frame = obj:FindFirstChildWhichIsA("Frame")
        if frame then
            frame.BackgroundColor3 = color
            local label = frame:FindFirstChildWhichIsA("TextLabel")
            if label then
                label.Text = role
            end
        end
    end

    -- Добавить новых игроков (пропуская уже существующих)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer and not espObjects[plr] then
            createESP(plr)
        end
    end
end

-- Включить ESP
local function enableESP()
    if espEnabled then return end
    espEnabled = true
    toggleBtn.Text = "ESP: ON"
    statusLabel.Text = "Status: Enabled"

    -- Создать для всех
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            createESP(plr)
        end
    end

    -- События добавления/удаления игроков
    Players.PlayerAdded:Connect(function(plr)
        if espEnabled and plr ~= localPlayer then
            createESP(plr)
        end
    end)
    Players.PlayerRemoving:Connect(function(plr)
        if espEnabled then
            removeESP(plr)
        end
    end)

    -- Цикл обновления (каждые 0.5 сек)
    spawn(function()
        while espEnabled do
            refreshESP()
            wait(0.5)
        end
    end)
end

-- Выключить ESP
local function disableESP()
    if not espEnabled then return end
    espEnabled = false
    toggleBtn.Text = "ESP: OFF"
    statusLabel.Text = "Status: Disabled"

    for _, obj in pairs(espObjects) do
        obj:Destroy()
    end
    espObjects = {}
end

-- Кнопка переключения
toggleBtn.MouseButton1Click:Connect(function()
    if espEnabled then disableESP() else enableESP() end
end)

-- По умолчанию выключено
disableESP()
