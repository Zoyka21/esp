-- Инициализация сервисов
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer

-- Создание ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_ESP_ProMenu"
ScreenGui.ResetOnSpawn = false
if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
ScreenGui.Parent = CoreGui

-- Главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 160) -- Увеличили высоту под слайдер
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true -- Нужно для корректного сворачивания
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Заголовок окна
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "  MM2 ESP Pro"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.BorderSizePixel = 0
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Кнопка Свернуть/Развернуть (_)
local CollapseButton = Instance.new("TextButton")
CollapseButton.Size = UDim2.new(0, 30, 0, 30)
CollapseButton.Position = UDim2.new(1, -30, 0, 0)
CollapseButton.BackgroundTransparency = 1
CollapseButton.Text = "_"
CollapseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CollapseButton.Font = Enum.Font.SourceSansBold
CollapseButton.TextSize = 18
CollapseButton.Parent = MainFrame

-- Контейнер для элементов (чтобы скрывать их при сворачивании)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Кнопка переключения ESP
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 170, 0, 35)
ToggleButton.Position = UDim2.new(0, 15, 0, 15)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Text = "ESP: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 15
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = ContentFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

-- Текст для слайдера прозрачности
local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(0, 170, 0, 20)
SliderLabel.Position = UDim2.new(0, 15, 0, 60)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Прозрачность стены: 40%"
SliderLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SliderLabel.Font = Enum.Font.SourceSans
SliderLabel.TextSize = 14
SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
SliderLabel.Parent = ContentFrame

-- Задний фон слайдера (Полоса)
local SliderTrack = Instance.new("Frame")
SliderTrack.Size = UDim2.new(0, 170, 0, 6)
SliderTrack.Position = UDim2.new(0, 15, 0, 85)
SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderTrack.BorderSizePixel = 0
SliderTrack.Parent = ContentFrame

local TrackCorner = Instance.new("UICorner")
TrackCorner.CornerRadius = UDim.new(0, 3)
TrackCorner.Parent = SliderTrack

-- Ползунок слайдера
local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 14, 0, 14)
SliderButton.Position = UDim2.new(0.4, -7, 0, -4) -- Дефолт 40% (0.4)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.Text = ""
SliderButton.BorderSizePixel = 0
SliderButton.Parent = SliderTrack

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(1, 0)
SliderCorner.Parent = SliderButton

-- Плавное перетаскивание Главного Окна
local dragging, dragInput, dragStart, startPos
local function updateMain(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
MainFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UserInputService:GetFocusedTextBox() == nil then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then updateMain(input) end
end)

-- Логика Сворачивания окна
local isCollapsed = false
CollapseButton.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        MainFrame.Size = UDim2.new(0, 200, 0, 30) -- Сжимаем до размеров заголовка
        CollapseButton.Text = "+"
        ContentFrame.Visible = false
    else
        MainFrame.Size = UDim2.new(0, 200, 0, 160) -- Возвращаем исходный размер
        CollapseButton.Text = "_"
        ContentFrame.Visible = true
    end
end)

-- Настройки ESP
local espEnabled = false
local fillTransparency = 0.4 -- Начальное значение (40%)

-- Логика Ползунка (Слайдера)
local sliderDragging = false
SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.X
        local trackLeft = SliderTrack.AbsolutePosition.X
        local trackWidth = SliderTrack.AbsoluteSize.X
        
        -- Вычисление процента (от 0 до 1)
        local percentage = math.clamp((mousePos - trackLeft) / trackWidth, 0, 1)
        SliderButton.Position = UDim2.new(percentage, -7, 0, -4)
        
        -- Обновляем прозрачность
        fillTransparency = percentage
        SliderLabel.Text = "Прозрачность стены: " .. math.round(percentage * 100) .. "%"
    end
end)

-- Функции отрисовки ESP
local function removeESP(character)
    local oldEsp = character:FindFirstChild("MM2_HighlightPro")
    if oldEsp then oldEsp:Destroy() end
end

local function applyESP(player, color)
    local character = player.Character
    if not character then return end
    
    local highlight = character:FindFirstChild("MM2_HighlightPro")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "MM2_HighlightPro"
        highlight.Parent = character
    end
    
    highlight.Adornee = character
    highlight.FillColor = color
    highlight.FillTransparency = fillTransparency -- Динамически берется из ползунка
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.OutlineTransparency = 0
end

-- Поток постоянного обновления ESP ролей
task.spawn(function()
    while true do
        task.wait(0.2)
        
        if espEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local backpack = player:FindFirstChild("Backpack")
                    local char = player.Character
                    
                    local hasKnife = (backpack and backpack:FindFirstChild("Knife")) or char:FindFirstChild("Knife")
                    local hasGun = (backpack and backpack:FindFirstChild("Gun")) or char:FindFirstChild("Gun")
                    
                    if hasKnife then
                        applyESP(player, Color3.fromRGB(255, 0, 50)) -- Мардер
                    elseif hasGun then
                        applyESP(player, Color3.fromRGB(0, 120, 255)) -- Шериф
                    else
                        applyESP(player, Color3.fromRGB(0, 255, 120)) -- Мирный
                    end
                end
            end
        else
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then removeESP(player.Character) end
            end
        end
    end
end)

-- Переключатель кнопки активации
ToggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ToggleButton.Text = "ESP: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 170, 85)
    else
        ToggleButton.Text = "ESP: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)
