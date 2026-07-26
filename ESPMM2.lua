local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

-- Удаление старой копии GUI, если она существовала (чтобы не дублировалось при перезапусках)
local oldGui = CoreGui:FindFirstChild("ZoykaHub")
if oldGui then oldGui:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZoykaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 200)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 35)
Logo.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
Logo.Text = "  ZoykaHub v1 (MM2)"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.SourceSansBold
Logo.TextSize = 14
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.BorderSizePixel = 0
Logo.Parent = MainFrame

local CollapseButton = Instance.new("TextButton")
CollapseButton.Size = UDim2.new(0, 30, 0, 35)
CollapseButton.Position = UDim2.new(1, -35, 0, 0)
CollapseButton.BackgroundTransparency = 1
CollapseButton.Text = "_"
CollapseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CollapseButton.Font = Enum.Font.SourceSansBold
CollapseButton.TextSize = 18
CollapseButton.Parent = MainFrame

local isCollapsed = false
CollapseButton.MouseButton1Click:Connect(function()
    isCollapsed = not isCollapsed
    if isCollapsed then
        MainFrame.Size = UDim2.new(0, 240, 0, 35)
        CollapseButton.Text = "+"
    else
        MainFrame.Size = UDim2.new(0, 240, 0, 200)
        CollapseButton.Text = "_"
    end
end)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 9)
MainCorner.Parent = MainFrame

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 9)
LogoCorner.Parent = Logo

-- Плавный и стабильный Dragging (перетаскивание меню)
local dragging, dragInput, dragStart, startPos
Logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Logo.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local playerTrans = 1 
local coinTrans = 1

local BtnPlayers = Instance.new("TextButton")
BtnPlayers.Size = UDim2.new(0, 200, 0, 35)
BtnPlayers.Position = UDim2.new(0, 20, 0, 50)
BtnPlayers.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
BtnPlayers.Text = "ESP Ролей: ВЫКЛ"
BtnPlayers.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnPlayers.Font = Enum.Font.SourceSansBold
BtnPlayers.TextSize = 13
BtnPlayers.Parent = MainFrame
Instance.new("UICorner", BtnPlayers).CornerRadius = UDim.new(0, 6)

BtnPlayers.MouseButton1Click:Connect(function()
    if playerTrans == 1 then playerTrans = 0
    elseif playerTrans == 0 then playerTrans = 0.3
    elseif playerTrans == 0.3 then playerTrans = 0.6
    elseif playerTrans == 0.6 then playerTrans = 0.9
    else playerTrans = 1 end
    
    if playerTrans == 1 then
        BtnPlayers.Text = "ESP Ролей: ВЫКЛ"
        BtnPlayers.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    else
        BtnPlayers.Text = "Роли: Видимость " .. math.round((1 - playerTrans) * 100) .. "%"
        BtnPlayers.BackgroundColor3 = Color3.fromRGB(40, 150, 70)
    end
end)

local BtnItems = Instance.new("TextButton")
BtnItems.Size = UDim2.new(0, 200, 0, 35)
BtnItems.Position = UDim2.new(0, 20, 0, 95)
BtnItems.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
BtnItems.Text = "ESP Предметов: ВЫКЛ"
BtnItems.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnItems.Font = Enum.Font.SourceSansBold
BtnItems.TextSize = 13
BtnItems.Parent = MainFrame
Instance.new("UICorner", BtnItems).CornerRadius = UDim.new(0, 6)

BtnItems.MouseButton1Click:Connect(function()
    if coinTrans == 1 then coinTrans = 0
    elseif coinTrans == 0 then coinTrans = 0.3
    elseif coinTrans == 0.3 then coinTrans = 0.6
    elseif coinTrans == 0.6 then coinTrans = 0.9
    else coinTrans = 1 end
    
    if coinTrans == 1 then
        BtnItems.Text = "ESP Предметов: ВЫКЛ"
        BtnItems.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    else
        BtnItems.Text = "Предметы: Видимость " .. math.round((1 - coinTrans) * 100) .. "%"
        BtnItems.BackgroundColor3 = Color3.fromRGB(40, 150, 70)
    end
end)

local speedActive = false
local BtnSpeed = Instance.new("TextButton")
BtnSpeed.Size = UDim2.new(0, 200, 0, 35)
BtnSpeed.Position = UDim2.new(0, 20, 0, 140)
BtnSpeed.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
BtnSpeed.Text = "Ускорение: ВЫКЛ (16)"
BtnSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnSpeed.Font = Enum.Font.SourceSansBold
BtnSpeed.TextSize = 13
BtnSpeed.Parent = MainFrame
Instance.new("UICorner", BtnSpeed).CornerRadius = UDim.new(0, 6)

local function updateSpeed()
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = speedActive and 35 or 16 end
end

BtnSpeed.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    BtnSpeed.Text = speedActive and "Ускорение: ВКЛ (35)" or "Ускорение: ВЫКЛ (16)"
    BtnSpeed.BackgroundColor3 = speedActive and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(40, 40, 45)
    updateSpeed()
end)

localPlayer.CharacterAdded:Connect(function() task.wait(1) updateSpeed() end)

-- Главный цикл обработки ESP
task.spawn(function()
    while true do
        task.wait(0.2) -- Чуть быстрее обновление для отзывчивости
        
        -- 1. Отработка ESP Игроков (Ролей)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character then
                local hl = p.Character:FindFirstChild("ZHL")
                if playerTrans < 1 then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "ZHL"
                        hl.OutlineColor = Color3.new(1, 1, 1)
                        hl.OutlineTransparency = 0
                        hl.Parent = p.Character
                    end
                    hl.FillTransparency = playerTrans
                    
                    local bp = p:FindFirstChild("Backpack")
                    local char = p.Character
                    local isMurder = (bp and bp:FindFirstChild("Knife")) or char:FindFirstChild("Knife")
                    local isSheriff = (bp and bp:FindFirstChild("Gun")) or char:FindFirstChild("Gun")
                    
                    if isMurder then 
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                    elseif isSheriff then 
                        hl.FillColor = Color3.fromRGB(0, 120, 255)
                    else 
                        hl.FillColor = Color3.fromRGB(0, 255, 100) 
                    end
                else
                    if hl then hl:Destroy() end
                end
            end
        end
        
        -- 2. Отработка ESP Предметов (Дропнутый пистолет Шерифа)
        local gd = Workspace:FindFirstChild("GunDrop")
        if gd then
            local g = gd:FindFirstChild("ZI")
            if coinTrans < 1 then
                if not g then
                    g = Instance.new("Highlight")
                    g.Name = "ZI"
                    g.OutlineColor = Color3.new(1, 1, 1)
                    g.Parent = gd
                end
                g.FillColor = Color3.fromRGB(255, 0, 0) -- Пистолет подсветим ярким красным/золотым
                g.FillTransparency = coinTrans
            else
                if g then g:Destroy() end
            end
        end
        
        -- 3. Отработка ESP Предметов (Монеты на карте)
        -- MM2 может рендерить монеты в разных контейнерах в зависимости от карты. Проверяем все возможные:
        local coinContainers = {Workspace:FindFirstChild("NormalCoins"), Workspace:FindFirstChild("CoinContainer")}
        
        for _, container in ipairs(coinContainers) do
            if container then
                for _, c in ipairs(container:GetChildren()) do
                    local h = c:FindFirstChild("ZI")
                    if coinTrans < 1 then
                        if not h then
                            h = Instance.new("Highlight")
                            h.Name = "ZI"
                            h.OutlineColor = Color3.new(1, 1, 0)
                            h.Parent = c
                        end
                        h.FillColor = Color3.fromRGB(255, 215, 0) -- Золотой цвет монет
                        h.FillTransparency = coinTrans
                    else
                        if h then h:Destroy() end
                    end
                end
            end
        end

        -- Очистка подсветки монет, если ESP предметов было выключено (на случай, если контейнеры изменились)
        if coinTrans == 1 then
            for _, container in ipairs(coinContainers) do
                if container then
                        for _, c in ipairs(container:GetChildren()) do
                            local h = c:FindFirstChild("ZI")
                            if h then h:Destroy() end
                        end
                    end
                end
                if gd then
                    local g = gd:FindFirstChild("ZI")
                    if g then g:Destroy() end
                end
            end
        end
    end)
