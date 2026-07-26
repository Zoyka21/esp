--[[
    ESP SYSTEM FOR MM2
    Полноценная система ESP с плавающим окном
    Поддержка всех типов ролей в MM2
--]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ========== НАСТРОЙКИ ==========
local Settings = {
    ESP = {
        Enabled = false,
        MurdererColor = Color3.fromRGB(255, 0, 0),
        SheriffColor = Color3.fromRGB(0, 150, 255),
        InnocentColor = Color3.fromRGB(0, 255, 100),
        Transparency = 0.3,
        TextSize = 14,
        Distance = 150
    }
}

-- ========== GUI ==========
local function CreateUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "ESP_SYSTEM"
    gui.Parent = lp:WaitForChild("PlayerGui")
    
    -- Главное окно
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 200, 0, 120)
    main.Position = UDim2.new(0.01, 0, 0.3, 0)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    main.BackgroundTransparency = 0.15
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    
    -- Тень
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(1, 0, 1, 0)
    shadow.Position = UDim2.new(0.005, 0, 0.005, 0)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.Parent = main
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    title.BackgroundTransparency = 0.3
    title.BorderSizePixel = 0
    title.Text = "⚡ ESP SYSTEM"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.Parent = main
    
    -- Линия под заголовком
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0, 30)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
    line.Parent = main
    
    -- Кнопка ESP
    local espBtn = Instance.new("TextButton")
    espBtn.Size = UDim2.new(0.85, 0, 0, 30)
    espBtn.Position = UDim2.new(0.075, 0, 0.35, 0)
    espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    espBtn.BackgroundTransparency = 0.3
    espBtn.BorderSizePixel = 0
    espBtn.Text = "◄ ESP: OFF ►"
    espBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    espBtn.TextSize = 13
    espBtn.Font = Enum.Font.Gotham
    espBtn.Parent = main
    
    -- Инфо
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, 0, 0, 20)
    info.Position = UDim2.new(0, 0, 0.7, 0)
    info.BackgroundTransparency = 1
    info.Text = "Status: Disabled"
    info.TextColor3 = Color3.fromRGB(150, 150, 150)
    info.TextSize = 11
    info.Font = Enum.Font.Gotham
    info.Parent = main
    
    -- Счётчик
    local counter = Instance.new("TextLabel")
    counter.Size = UDim2.new(1, 0, 0, 20)
    counter.Position = UDim2.new(0, 0, 0.85, 0)
    counter.BackgroundTransparency = 1
    counter.Text = "Players: 0"
    counter.TextColor3 = Color3.fromRGB(100, 100, 100)
    counter.TextSize = 10
    counter.Font = Enum.Font.Gotham
    counter.Parent = main
    
    return {
        Main = main,
        ESPBtn = espBtn,
        Info = info,
        Counter = counter
    }
end

-- ========== ESP CORE ==========
local ESP = {
    Objects = {},
    Connections = {},
    UI = nil,
    Enabled = false
}

function ESP:GetRole(player)
    -- Проверяем все возможные варианты хранения ролей
    local murder = player:FindFirstChild("Murderer")
    local sheriff = player:FindFirstChild("Sheriff")
    local role = player:FindFirstChild("Role")
    
    if murder then
        if murder:IsA("BoolValue") and murder.Value then
            return "Murderer"
        elseif murder:IsA("IntValue") and murder.Value > 0 then
            return "Murderer"
        elseif murder:IsA("StringValue") and murder.Value == "Murderer" then
            return "Murderer"
        end
    end
    
    if sheriff then
        if sheriff:IsA("BoolValue") and sheriff.Value then
            return "Sheriff"
        elseif sheriff:IsA("IntValue") and sheriff.Value > 0 then
            return "Sheriff"
        elseif sheriff:IsA("StringValue") and sheriff.Value == "Sheriff" then
            return "Sheriff"
        end
    end
    
    if role then
        if role:IsA("StringValue") and role.Value == "Murderer" then
            return "Murderer"
        elseif role:IsA("StringValue") and role.Value == "Sheriff" then
            return "Sheriff"
        end
    end
    
    return "Innocent"
end

function ESP:CreateESP(player)
    if player == lp or self.Objects[player] then return end
    
    local char = player.Character
    if not char then return end
    
    local head = char:FindFirstChild("Head")
    if not head then return end
    
    local role = self:GetRole(player)
    local color = role == "Murderer" and Settings.ESP.MurdererColor or
                  role == "Sheriff" and Settings.ESP.SheriffColor or
                  Settings.ESP.InnocentColor
    
    -- Billboard
    local bill = Instance.new("BillboardGui")
    bill.Size = UDim2.new(0, 100, 0, 32)
    bill.AlwaysOnTop = true
    bill.Adornee = head
    bill.Parent = head
    bill.StudsOffset = Vector3.new(0, 2, 0)
    bill.MaxDistance = Settings.ESP.Distance
    
    -- Фон
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = Settings.ESP.Transparency
    frame.BorderSizePixel = 0
    frame.Parent = bill
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = frame
    
    -- Текст роли
    local roleLabel = Instance.new("TextLabel")
    roleLabel.Size = UDim2.new(1, 0, 0.6, 0)
    roleLabel.Position = UDim2.new(0, 0, 0, 0)
    roleLabel.BackgroundTransparency = 1
    roleLabel.Text = role
    roleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    roleLabel.TextSize = Settings.ESP.TextSize
    roleLabel.Font = Enum.Font.GothamBold
    roleLabel.TextStrokeTransparency = 0.2
    roleLabel.Parent = frame
    
    -- Имя игрока
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
    nameLabel.Position = UDim2.new(0, 0, 0.6, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    nameLabel.TextSize = 10
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.TextStrokeTransparency = 0.3
    nameLabel.Parent = frame
    
    -- Скелет (Box)
    local box = Instance.new("BoxHandleAdornment")
    box.Size = Vector3.new(2, 4.5, 1.5)
    box.Position = Vector3.new(0, 1.5, 0)
    box.Color3 = color
    box.Transparency = 0.6
    box.AlwaysOnTop = true
    box.ZIndex = 0
    box.Adornee = head
    box.Parent = head
    
    self.Objects[player] = {
        Billboard = bill,
        Box = box
    }
end

function ESP:RemoveESP(player)
    local obj = self.Objects[player]
    if obj then
        if obj.Billboard then obj.Billboard:Destroy() end
        if obj.Box then obj.Box:Destroy() end
        self.Objects[player] = nil
    end
end

function ESP:UpdateESP()
    local players = Players:GetPlayers()
    local count = 0
    
    -- Обновляем существующие
    for player, obj in pairs(self.Objects) do
        local char = player.Character
        if not char or not char:FindFirstChild("Head") then
            self:RemoveESP(player)
            continue
        end
        
        -- Обновляем роль
        local role = self:GetRole(player)
        local color = role == "Murderer" and Settings.ESP.MurdererColor or
                      role == "Sheriff" and Settings.ESP.SheriffColor or
                      Settings.ESP.InnocentColor
        
        if obj.Billboard then
            local frame = obj.Billboard:FindFirstChildWhichIsA("Frame")
            if frame then
                frame.BackgroundColor3 = color
                local roleLabel = frame:FindFirstChildWhichIsA("TextLabel")
                if roleLabel then
                    roleLabel.Text = role
                end
            end
        end
        
        if obj.Box then
            obj.Box.Color3 = color
        end
        
        count = count + 1
    end
    
    -- Добавляем новых
    for _, player in ipairs(players) do
        if player ~= lp and not self.Objects[player] then
            self:CreateESP(player)
            count = count + 1
        end
    end
    
    -- Обновляем счётчик
    if self.UI and self.UI.Counter then
        self.UI.Counter.Text = "Players: " .. count
    end
end

function ESP:Toggle()
    self.Enabled = not self.Enabled
    
    if self.Enabled then
        self:Enable()
    else
        self:Disable()
    end
end

function ESP:Enable()
    self.Enabled = true
    
    if self.UI then
        self.UI.ESPBtn.Text = "◄ ESP: ON ►"
        self.UI.ESPBtn.TextColor3 = Color3.fromRGB(0, 255, 100)
        self.UI.Info.Text = "Status: Enabled"
        self.UI.Info.TextColor3 = Color3.fromRGB(0, 255, 100)
    end
    
    -- Создаём ESP для всех
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= lp then
            self:CreateESP(player)
        end
    end
    
    -- Подключаем события
    self.Connections.PlayerAdded = Players.PlayerAdded:Connect(function(player)
        if self.Enabled and player ~= lp then
            self:CreateESP(player)
        end
    end)
    
    self.Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(player)
        if self.Enabled then
            self:RemoveESP(player)
        end
    end)
    
    -- Цикл обновления
    self.Connections.Heartbeat = RunService.Heartbeat:Connect(function()
        if self.Enabled then
            self:UpdateESP()
        end
    end)
end

function ESP:Disable()
    self.Enabled = false
    
    if self.UI then
        self.UI.ESPBtn.Text = "◄ ESP: OFF ►"
        self.UI.ESPBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        self.UI.Info.Text = "Status: Disabled"
        self.UI.Info.TextColor3 = Color3.fromRGB(150, 150, 150)
        self.UI.Counter.Text = "Players: 0"
    end
    
    -- Отключаем события
    for _, conn in pairs(self.Connections) do
        if conn then
            conn:Disconnect()
        end
    end
    self.Connections = {}
    
    -- Удаляем все объекты
    for player in pairs(self.Objects) do
        self:RemoveESP(player)
    end
end

-- ========== ИНИЦИАЛИЗАЦИЯ ==========
print("Loading ESP System...")

-- Создаём UI
ESP.UI = CreateUI()

-- Настройка кнопки
ESP.UI.ESPBtn.MouseButton1Click:Connect(function()
    ESP:Toggle()
end)

-- Чистка при выходе
lp:WaitForChild("PlayerGui").ChildRemoved:Connect(function()
    ESP:Disable()
end)

print("ESP System loaded! Press the button to enable.")
