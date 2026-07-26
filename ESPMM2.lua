-- ==================== КУСОК 1 (ЗАПУСТИТЬ ПЕРВЫМ) ====================
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
getgenv().localPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("ZoykaHub") then CoreGui["ZoykaHub"]:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZoykaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

getgenv().MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 310)
MainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 9)
MainCorner.Parent = MainFrame

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 35)
Logo.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
Logo.Text = "  ZoykaHub v3 (MM2 Ultimate)"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.SourceSansBold
Logo.TextSize = 14
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.BorderSizePixel = 0
Logo.Parent = MainFrame

Instance.new("UICorner", Logo).CornerRadius = UDim.new(0, 9)

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
    MainFrame.Size = isCollapsed and UDim2.new(0, 250, 0, 35) or UDim2.new(0, 250, 0, 310)
    CollapseButton.Text = isCollapsed and "+" or "_"
end)

local dragging, dragInput, dragStart, startPos
Logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
Logo.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

getgenv().ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -10, 1, -45)
ScrollFrame.Position = UDim2.new(0, 5, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 360)
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.Parent = ScrollFrame

getgenv().createButton = function(text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 220, 0, 35)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 13
    b.Parent = ScrollFrame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

getgenv().ZH_States = {playerTrans = 1, itemTrans = 1, speedActive = false, farmActive = false, aimActive = false, notifyActive = false}

local BtnPlayers = createButton("ESP Ролей: ВЫКЛ", Color3.fromRGB(180, 40, 40))
BtnPlayers.MouseButton1Click:Connect(function()
    local t = ZH_States.playerTrans
    ZH_States.playerTrans = t == 1 and 0 or t == 0 and 0.4 or t == 0.4 and 0.7 or 1
    local nt = ZH_States.playerTrans
    BtnPlayers.Text = nt == 1 and "ESP Ролей: ВЫКЛ" or "Роли: Видимость " .. math.round((1 - nt) * 100) .. "%"
    BtnPlayers.BackgroundColor3 = nt == 1 and Color3.fromRGB(180, 40, 40) or Color3.fromRGB(40, 150, 70)
end)
-- ==================== КУСОК 2 (ЗАПУСТИТЬ ВТОРЫМ) ====================
local BtnItems = createButton("ESP Предметов: ВЫКЛ", Color3.fromRGB(180, 40, 40))
BtnItems.MouseButton1Click:Connect(function()
    local t = ZH_States.itemTrans
    ZH_States.itemTrans = t == 1 and 0 or t == 0 and 0.4 or t == 0.4 and 0.7 or 1
    local nt = ZH_States.itemTrans
    BtnItems.Text = nt == 1 and "ESP Предметов: ВЫКЛ" or "Предметы: Видимость " .. math.round((1 - nt) * 100) .. "%"
    BtnItems.BackgroundColor3 = nt == 1 and Color3.fromRGB(180, 40, 40) or Color3.fromRGB(40, 150, 70)
end)

local BtnSpeed = createButton("Ускорение: ВЫКЛ (16)", Color3.fromRGB(40, 40, 45))
local function updateSpeed()
    local chr = localPlayer.Character
    local hum = chr and chr:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = ZH_States.speedActive and 35 or 16 end
end
BtnSpeed.MouseButton1Click:Connect(function()
    ZH_States.speedActive = not ZH_States.speedActive
    BtnSpeed.Text = ZH_States.speedActive and "Ускорение: ВКЛ (35)" or "Ускорение: ВЫКЛ (16)"
    BtnSpeed.BackgroundColor3 = ZH_States.speedActive and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(40, 40, 45)
    updateSpeed()
end)
localPlayer.CharacterAdded:Connect(function() task.wait(1) updateSpeed() end)

local BtnFarm = createButton("Авто-Фарм Монет: ВЫКЛ", Color3.fromRGB(40, 40, 45))
BtnFarm.MouseButton1Click:Connect(function()
    ZH_States.farmActive = not ZH_States.farmActive
    BtnFarm.Text = ZH_States.farmActive and "Авто-Фарм Монет: ВКЛ" or "Авто-Фарм Монет: ВЫКЛ"
    BtnFarm.BackgroundColor3 = ZH_States.farmActive and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(40, 40, 45)
end)

local BtnSilent = createButton("Silent Aim (Шериф): ВЫКЛ", Color3.fromRGB(40, 40, 45))
BtnSilent.MouseButton1Click:Connect(function()
    ZH_States.aimActive = not ZH_States.aimActive
    BtnSilent.Text = ZH_States.aimActive and "Silent Aim: ВКЛ" or "Silent Aim (Шериф): ВЫКЛ"
    BtnSilent.BackgroundColor3 = ZH_States.aimActive and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(40, 40, 45)
end)

local BtnNotify = createButton("Чат-Трекер Ролей: ВЫКЛ", Color3.fromRGB(40, 40, 45))
BtnNotify.MouseButton1Click:Connect(function()
    ZH_States.notifyActive = not ZH_States.notifyActive
    BtnNotify.Text = ZH_States.notifyActive and "Чат-Трекер Ролей: ВКЛ" or "Чат-Трекер Ролей: ВЫКЛ"
    BtnNotify.BackgroundColor3 = ZH_States.notifyActive and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(40, 40, 45)
end)
-- ==================== КУСОК 3 (ЗАПУСТИТЬ ТРЕТЬИМ) ====================
local Players = game:GetService("Players")

getgenv().getZH_Role = function(p)
    local bp = p:FindFirstChild("Backpack")
    local char = p.Character
    if (bp and bp:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife")) then return "Murder"
    elseif (bp and bp:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun")) then return "Sheriff" end
    return "Innocent"
end

local announced = {}
task.spawn(function()
    while task.wait(2) do
        if ZH_States.notifyActive then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= localPlayer and p.Character then
                    local r = getZH_Role(p)
                    if r ~= "Innocent" and not announced[p.Name] then
                        announced[p.Name] = true
                        local isM = (r == "Murder")
                        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                            Text = isM and "⚠️ ["..p.Name.."] — МАНЬЯК!" or "🛡️ ["..p.Name.."] — ШЕРИФ!",
                            Color = isM and Color3.new(1,0,0) or Color3.new(0,0.5,1),
                            Font = Enum.Font.SourceSansBold
                        })
                    end
                end
            end
        else table.clear(announced) end
    end
end)

local oldNc
oldNc = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if ZH_States.aimActive and method == "FireServer" and tostring(self) == "ShootGun" then
        for _, p in ipairs(Players:GetPlayers()) do
            if getZH_Role(p) == "Murder" and p.Character and p.Character:FindFirstChild("Head") then
                args = p.Character.Head.Position
                return oldNc(self, unpack(args))
            end
        end
    end
    return oldNc(self, ...)
end)
-- ==================== КУСОК 4 (ЗАПУСТИТЬ ЧЕТВЕРТЫМ) ====================
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

task.spawn(function()
    while true do
        task.wait(0.2)
        local coinContainers = {Workspace:FindFirstChild("NormalCoins"), Workspace:FindFirstChild("CoinContainer")}
        
        if ZH_States.farmActive and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, container in ipairs(coinContainers) do
                if container and #container:GetChildren() > 0 then
                    for _, coin in ipairs(container:GetChildren()) do
                        local target = coin:IsA("Model") and (coin:FindFirstChildOfClass("BasePart") or coin.PrimaryPart) or coin
                        if target then
                            localPlayer.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, -2, 0)
                            task.wait(0.12)
                            break
                        end
                    end
                end
            end
        end

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character then
                local hl = p.Character:FindFirstChild("ZHL")
                if ZH_States.playerTrans < 1 then
                    if not hl then
                        hl = Instance.new("Highlight", p.Character)
                        hl.Name = "ZHL"
                        hl.OutlineColor = Color3.new(1, 1, 1)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    hl.FillTransparency = ZH_States.playerTrans
                    local r = getZH_Role(p)
                    hl.FillColor = r == "Murder" and Color3.new(1,0,0) or r == "Sheriff" and Color3.new(0,0.4,1) or Color3.new(0,1,0.4)
                else if hl then hl:Destroy() end end
            end
        end

        local gd = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
        if gd then
            local target = gd:IsA("BasePart") and gd or gd:FindFirstChildOfClass("MeshPart") or gd:FindFirstChildOfClass("BasePart")
            if target then
                local g = target:FindFirstChild("ZI")
                if ZH_States.itemTrans < 1 then
                    if not g then
                        g = Instance.new("Highlight", target)
                        g.Name = "ZI"
                        g.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    end
                    g.FillColor = Color3.fromRGB(0, 255, 255)
                    g.FillTransparency = ZH_States.itemTrans
                else if g then g:Destroy() end end
            end
        end

        for _, container in ipairs(coinContainers) do
            if container then
                for _, c in ipairs(container:GetChildren()) do
                    local h = c:FindFirstChild("ZI")
                    if ZH_States.itemTrans < 1 then
                        if not h then
                            h = Instance.new("Highlight", c)
                            h.Name = "ZI"
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        end
                        h.FillColor = Color3.fromRGB(255, 215, 0)
                        h.FillTransparency = ZH_States.itemTrans
                    else if h then h:Destroy() end end
                end
            end
        end

        if ZH_States.itemTrans == 1 then
            if gd then for _, ch in ipairs(gd:GetDescendants()) do if ch.Name == "ZI" then ch:Destroy() end end end
            for _, container in ipairs(coinContainers) do
                if container then
                    for _, c in ipairs(container:GetChildren()) do
                        local h = c:FindFirstChild("ZI") if h then h:Destroy() end
                    end
                end
            end
        end
    end
end)
-- ==================== КУСОК 5 (ЗАПУСТИТЬ ПЯТЫМ) ====================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Интегрируем новые настройки в глобальную таблицу состояний
if ZH_States then
    ZH_States.killAuraActive = false
    ZH_States.killAuraRange = 50 -- Радиус по умолчанию
end

-- 1. Создаем кнопку включения/выключения Kill Aura
local BtnAura = createButton("Kill Aura (Маньяк): ВЫКЛ", Color3.fromRGB(40, 40, 45))

-- 2. Создаем контейнер для слайдера (регулятора радиуса)
local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(0, 220, 0, 30)
SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 33)
SliderFrame.Parent = ScrollFrame
Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 1, 0)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "Радиус атаки: 50"
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.Font = Enum.Font.SourceSansBold
SliderLabel.TextSize = 12
SliderLabel.Parent = SliderFrame

-- Логика переключения кнопки Kill Aura
BtnAura.MouseButton1Click:Connect(function()
    ZH_States.killAuraActive = not ZH_States.killAuraActive
    BtnAura.Text = ZH_States.killAuraActive and "Kill Aura: ВКЛ" or "Kill Aura (Маньяк): ВЫКЛ"
    BtnAura.BackgroundColor3 = ZH_States.killAuraActive and Color3.fromRGB(150, 40, 40) or Color3.fromRGB(40, 40, 45)
end)

-- Простой клик/зажатие по слайдеру для регулировки радиуса от 0 до 150
SliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local function updateSlider()
            local mousePos = game:GetService("UserInputService"):GetMouseLocation().X
            local frameLeft = SliderFrame.AbsolutePosition.X
            local frameWidth = SliderFrame.AbsoluteSize.X
            local percentage = math.clamp((mousePos - frameLeft) / frameWidth, 0, 1)
            
            local newRange = math.round(percentage * 150) -- диапазон от 0 до 150
            ZH_States.killAuraRange = newRange
            SliderLabel.Text = "Радиус атаки: " .. newRange
        end
        updateSlider()
        local moveCon
        moveCon = game:GetService("UserInputService").InputChanged:Connect(function(moveInput)
            if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                updateSlider()
            end
        end)
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                if moveCon then moveCon:Disconnect() end
            end
        end)
    end
end)

-- 3. Бесконечный цикл обработки Kill Aura
task.spawn(function()
    while true do
        task.wait(0.1) -- Быстрая проверка дистанции для атаки
        
        -- Проверяем, включена ли функция, есть ли персонаж и держит ли он нож
        if ZH_States and ZH_States.killAuraActive and localPlayer.Character then
            local myRoot = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            local knife = localPlayer.Character:FindFirstChild("Knife") or (localPlayer:FindFirstChild("Backpack") and localPlayer.Backpack:FindFirstChild("Knife"))
            
            if myRoot and knife then
                -- Автоматически берем нож в руку, если он в рюкзаке
                if knife.Parent == localPlayer.Backpack then
                    knife.Parent = localPlayer.Character
                end
                
                -- Ищем цели вокруг
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= localPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local enemyRoot = p.Character.HumanoidRootPart
                        local distance = (myRoot.Position - enemyRoot.Position).Magnitude
                        
                        -- Если игрок живой и вошел в радиус регулятора
                        if distance <= ZH_States.killAuraRange and p.Character:FindFirstChildOfClass("Humanoid") and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                            -- Триггерим атаку ножа через вызов его серверного метода
                            local stabServer = knife:FindFirstChild("Stab") or knife:FindFirstChildOfClass("RemoteEvent")
                            if stabServer and stabServer:IsA("RemoteEvent") then
                                stabServer:FireServer("Stab")
                            end
                        end
                    end
                end
            end
        end
    end
end)
-- ==================== КУСОК 6 (ЗАПУСТИТЬ СЛЕДУЮЩИМ) ====================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- Добавляем новые состояния в общую таблицу
if ZH_States then
    ZH_States.farmActive = false -- Перезапишем старый автофарм новым методом
    ZH_States.invisibilityActive = false
    ZH_States.hideWeaponActive = false
end

-- 1. Создаем кнопку для нового автофарма (взамен старого, кнопка перезапишет логику)
local BtnNewFarm = createButton("Плавный Авто-Фарм: ВЫКЛ", Color3.fromRGB(40, 40, 45))
BtnNewFarm.MouseButton1Click:Connect(function()
    ZH_States.farmActive = not ZH_States.farmActive
    BtnNewFarm.Text = ZH_States.farmActive and "Плавный Авто-Фарм: ВКЛ" or "Плавный Авто-Фарм: ВЫКЛ"
    BtnNewFarm.BackgroundColor3 = ZH_States.farmActive and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(40, 40, 45)
end)

-- 2. Создаем кнопку Невидимости (для твоего скина)
local BtnInvis = createButton("Невидимость Скина: ВЫКЛ", Color3.fromRGB(40, 40, 45))
BtnInvis.MouseButton1Click:Connect(function()
    ZH_States.invisibilityActive = not ZH_States.invisibilityActive
    BtnInvis.Text = ZH_States.invisibilityActive and "Невидимость Скина: ВКЛ" or "Невидимость Скина: ВЫКЛ"
    BtnInvis.BackgroundColor3 = ZH_States.invisibilityActive and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(40, 40, 45)
end)

-- 3. Создаем кнопку Скрытия Оружия (для всех игроков в лобби)
local BtnHideWeapon = createButton("Скрывать Оружие: ВЫКЛ", Color3.fromRGB(40, 40, 45))
BtnHideWeapon.MouseButton1Click:Connect(function()
    ZH_States.hideWeaponActive = not ZH_States.hideWeaponActive
    BtnHideWeapon.Text = ZH_States.hideWeaponActive and "Скрывать Оружие: ВКЛ" or "Скрывать Оружие: ВЫКЛ"
    BtnHideWeapon.BackgroundColor3 = ZH_States.hideWeaponActive and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(40, 40, 45)
end)


-- ==================== СИСТЕМНАЯ ЛОГИКА НОВЫХ ФУНКЦИЙ ====================

-- Фоновый поток для нового ПЛАВНОГО автофарма (персонаж сам летит/идет к монетам)
task.spawn(function()
    while true do
        task.wait(0.5)
        
        if ZH_States and ZH_States.farmActive and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local myRoot = localPlayer.Character.HumanoidRootPart
            local coinContainers = {Workspace:FindFirstChild("NormalCoins"), Workspace:FindFirstChild("CoinContainer")}
            local currentTarget = nil
            local minDistance = math.huge
            
            -- Ищем ближайшую монету на карте
            for _, container in ipairs(coinContainers) do
                if container then
                    for _, coin in ipairs(container:GetChildren()) do
                        local p = coin:IsA("Model") and (coin:FindFirstChildOfClass("BasePart") or coin.PrimaryPart) or coin
                        if p then
                            local dist = (myRoot.Position - p.Position).Magnitude
                            if dist < minDistance then
                                minDistance = dist
                                currentTarget = p
                            end
                        end
                    end
                end
            end
            
            -- Если монета найдена, плавно двигаем персонажа к ней (обход античита)
            if currentTarget and currentTarget.Parent then
                local distance = (myRoot.Position - currentTarget.Position).Magnitude
                local speed = 45 -- Оптимальная скорость перемещения без кика (в секунду)
                local duration = distance / speed
                
                -- Отключаем гравитацию на время полета к монете, чтобы не падать
                local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.PlatformStand = true end
                
                local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
                local tween = TweenService:Create(myRoot, tweenInfo, {CFrame = currentTarget.CFrame})
                tween:Play()
                
                -- Ждем пока долетим или пока автофарм не выключат
                local elapsed = 0
                while elapsed < duration and ZH_States.farmActive and currentTarget.Parent do
                    task.wait(0.1)
                    elapsed = elapsed + 0.1
                end
                
                tween:Cancel()
                if hum then hum.PlatformStand = false end
            end
        end
    end
end)

-- Фоновый поток для Невидимости твоего скина и Скрытия Оружия
task.spawn(function()
    while true do
        task.wait(0.3)
        
        -- Логика Невидимости Скина
        if localPlayer.Character then
            for _, part in ipairs(localPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    if part.Name ~= "HumanoidRootPart" then
                        -- Если включено, делаем прозрачным, если выключено — возвращаем видимость
                        part.Transparency = ZH_States.invisibilityActive and 1 or 0
                    end
                end
            end
        end
        
        -- Логика Полного скрытия Ножа и Пистолета в руке у себя (для остальных игроков)
        if ZH_States and ZH_States.hideWeaponActive and localPlayer.Character then
            -- Проверяем оружие в руке (внутри Character)
            local weapon = localPlayer.Character:FindFirstChild("Knife") or localPlayer.Character:FindFirstChild("Gun")
            if weapon then
                for _, part in ipairs(weapon:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("MeshPart") then
                        part.Transparency = 1 -- Полностью убираем видимость модели меча/песта у всех
                    end
                end
            end
        end
        
    end
    
end)
-- ==================== КУСОК 7 (ЗАПУСТИТЬ СЛЕДУЮЩИМ) ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

-- 1. Исправление прокрутки: увеличиваем CanvasSize до 550, чтобы влезли абсолютно все кнопки
if getgenv().ScrollFrame then
    getgenv().ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 550)
end

-- Добавляем состояние Anti-Fling в общую таблицу
if ZH_States then
    ZH_States.antiFlingActive = false
end

-- 2. Создаем кнопку для Anti-Fling в меню
local BtnAntiFling = createButton("Anti-Fling (Защита): ВЫКЛ", Color3.fromRGB(40, 40, 45))
BtnAntiFling.MouseButton1Click:Connect(function()
    ZH_States.antiFlingActive = not ZH_States.antiFlingActive
    BtnAntiFling.Text = ZH_States.antiFlingActive and "Anti-Fling: ВКЛ" or "Anti-Fling (Защита): ВЫКЛ"
    BtnAntiFling.BackgroundColor3 = ZH_States.antiFlingActive and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(40, 40, 45)
end)

-- 3. Системная логика Anti-Fling (из Infinite Yield)
-- Скрипт отключает коллизию с другими игроками и обнуляет их угловую скорость рядом с тобой
task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        
        if ZH_States and ZH_States.antiFlingActive and localPlayer.Character then
            local myChar = localPlayer.Character
            
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= localPlayer and p.Character then
                    local enemyChar = p.Character
                    
                    -- Отключаем физическое столкновение деталей персонажей
                    for _, myPart in ipairs(myChar:GetDescendants()) do
                        if myPart:IsA("BasePart") then
                            for _, enemyPart in ipairs(enemyChar:GetDescendants()) do
                                if enemyPart:IsA("BasePart") then
                                    local cc = Instance.new("NoCollisionConstraint")
                                    cc.Part0 = myPart
                                    cc.Part1 = enemyPart
                                    cc.Parent = myPart
                                    -- Быстро удаляем, чтобы не засорять память, коллизия всё равно блокируется на тик
                                    game:GetService("Debris"):AddItem(cc, 0.05)
                                end
                            end
                        end
                    end
                    
                    -- Если чужой персонаж начинает бешено крутиться (Fling), обнуляем его скорость локально
                    local enemyRoot = enemyChar:FindFirstChild("HumanoidRootPart")
                    if enemyRoot then
                        if enemyRoot.Velocity.Magnitude > 100 or enemyRoot.RotVelocity.Magnitude > 100 then
                            enemyRoot.Velocity = Vector3.new(0, 0, 0)
                            enemyRoot.RotVelocity = Vector3.new(0, 0, 0)
                        end
                    end
                    
                end
            end
        end
    end
end)
