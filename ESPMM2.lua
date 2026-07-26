--[[
    ESP для MM2 (Murder Mystery 2) - РАБОЧАЯ ВЕРСИЯ
    Роли определяются по IntValue "Murderer" (значение > 0) или "Sheriff" (значение > 0)
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- ========== СОЗДАНИЕ GUI ==========
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_GUI"
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 160, 0, 80)
mainFrame.Position = UDim2.new(0.5, -80, 0.5, -40)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true  -- Встроенная функция Roblox
mainFrame.Selectable = true
mainFrame.Parent = screenGui

-- Заголовок (для перетаскивания)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 22)
title.BackgroundTransparency = 1
title.Text = "⚡ ESP Control"
title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.TextSize = 13
title.Font = Enum.Font.SourceSansBold
title.Parent = mainFrame

-- Кнопка включения
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.7, 0, 0, 28)
toggleBtn.Position = UDim2.new(0.15, 0, 0.35, 0)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.Text = "▶ ESP: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 13
toggleBtn.Font = Enum.Font.SourceSans
toggleBtn.Parent = mainFrame

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 18)
statusLabel.Position = UDim2.new(0, 0, 0.7, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "● Disabled"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.SourceSans
statusLabel.Parent = mainFrame

-- ========== ESP ЛОГИКА ==========
local espEnabled = false
local espObjects = {}
local refreshConnection

-- Правильное определение роли
local function getRole(player)
    local murderer = player:FindFirstChild("Murderer")
    local sheriff = player:FindFirstChild("Sheriff")
    
    if murderer and murderer:IsA("IntValue") and murderer.Value > 0 then
        return "Murderer"
    elseif sheriff and sheriff:IsA("IntValue") and sheriff.Value > 0 then
        return "Sheriff"
    else
        return "Innocent"
    end
end

-- Создание метки
local function createESP(player)
    if player == localPlayer or espObjects[player] then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local role = getRole(player)
    local color = role == "Murderer" and Color3.fromRGB(255, 60, 60)
                or role == "Sheriff" and Color3.fromRGB(60, 120, 255)
                or Color3.fromRGB(60, 255, 60)

    -- Создаём BillboardGui
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 70, 0, 25)
    bill.AlwaysOnTop = true
    bill.Adornee = head
    bill.Parent = head
    bill.StudsOffset = Vector3.new(0, 1.5, 0)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.4  -- Полупрозрачный
    frame.BorderSizePixel = 0
    frame.Parent = bill

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = role
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.TextStrokeTransparency = 0.3
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

-- Обновление всех меток
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
        
        -- Обновляем привязку если голова изменилась
        if obj.Adornee ~= head then
            obj.Adornee = head
        end

        -- Обновляем цвет и текст
        local role = getRole(player)
        local color = role == "Murderer" and Color3.fromRGB(255, 60, 60)
                    or role == "Sheriff" and Color3.fromRGB(60, 120, 255)
                    or Color3.fromRGB(60, 255, 60)

        local frame = obj:FindFirstChildWhichIsA("Frame")
        if frame then
            frame.BackgroundColor3 = color
            local label = frame:FindFirstChildWhichIsA("TextLabel")
            if label then
                label.Text = role
            end
        end
    end

    -- Добавляем новых игроков
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer and not espObjects[plr] then
            createESP(plr)
        end
    end
end

-- Включение ESP
local function enableESP()
    if espEnabled then return end
    espEnabled = true
    toggleBtn.Text = "⏹ ESP: ON"
    statusLabel.Text = "● Enabled"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)

    -- Создаём метки для всех
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer then
            createESP(plr)
        end
    end

    -- Подписка на события
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

    -- Обновление каждые 0.3 секунды (быстрее реакция)
    if refreshConnection then refreshConnection:Disconnect() end
    refreshConnection = RunService.Heartbeat:Connect(function()
        if espEnabled then
            refreshESP()
        end
    end)
end

-- Выключение ESP
local function disableESP()
    if not espEnabled then return end
    espEnabled = false
    toggleBtn.Text = "▶ ESP: OFF"
    statusLabel.Text = "● Disabled"
    statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)

    if refreshConnection then
        refreshConnection:Disconnect()
        refreshConnection = nil
    end

    for _, obj in pairs(espObjects) do
        obj:Destroy()
    end
    espObjects = {}
end

-- Кнопка переключения
toggleBtn.MouseButton1Click:Connect(function()
    if espEnabled then 
        disableESP() 
    else 
        enableESP() 
    end
end)

-- Очистка при выходе
localPlayer:WaitForChild("PlayerGui").ChildRemoved:Connect(function()
    disableESP()
end)

-- По умолчанию выключено
disableESP()

print("ESP скрипт загружен! Нажмите кнопку в окне для включения.")
