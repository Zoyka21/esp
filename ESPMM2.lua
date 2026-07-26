local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local localPlayer = Players.LocalPlayer

task.spawn(function()
    while true do
        task.wait(0.2) -- Задержка между проверками
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local coinContainers = {Workspace:FindFirstChild("NormalCoins"), Workspace:FindFirstChild("CoinContainer")}
            local grabbed = false
            
            for _, container in ipairs(coinContainers) do
                if container and #container:GetChildren() > 0 then
                    for _, coin in ipairs(container:GetChildren()) do
                        if coin:IsA("BasePart") or coin:IsA("Model") then
                            local targetPart = coin:IsA("Model") and (coin:FindFirstChildOfClass("BasePart") or coin.PrimaryPart) or coin
                            if targetPart then
                                -- Телепортирует персонажа чуть ниже монеты для безопасного сбора
                                localPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame * CFrame.new(0, -2, 0)
                                grabbed = true
                                task.wait(0.15) -- Время на подбор монеты
                                break
                            end
                        end
                    end
                end
                if grabbed then break end
            end
        end
    end
end)
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local function getPlayerRole(p)
    local bp = p:FindFirstChild("Backpack")
    local char = p.Character
    if (bp and bp:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife")) then
        return "Murder"
    elseif (bp and bp:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

local trackedPlayers = {}
task.spawn(function()
    while task.wait(1.5) do
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character then
                local role = getPlayerRole(p)
                if role ~= "Innocent" and not trackedPlayers[p.Name] then
                    trackedPlayers[p.Name] = true
                    local isMurder = (role == "Murder")
                    
                    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                        Text = isMurder and "⚠️ ["..p.Name.."] — МАНЬЯК!" or "🛡️ ["..p.Name.."] — ШЕРИФ!",
                        Color = isMurder and Color3.new(1, 0, 0) or Color3.new(0, 0.5, 1),
                        Font = Enum.Font.SourceSansBold
                    })
                end
            end
        end
        -- Очистка списка между раундами (когда маньяк пропадает)
        local murderFound = false
        for _, p in ipairs(Players:GetPlayers()) do
            if getPlayerRole(p) == "Murder" then murderFound = true end
        end
        if not murderFound then table.clear(trackedPlayers) end
    end
end)
local Players = game:GetService("Players")

local function getMurderer()
    for _, p in ipairs(Players:GetPlayers()) do
        local bp = p:FindFirstChild("Backpack")
        local char = p.Character
        if (bp and bp:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife")) then
            return p
        end
    end
    return nil
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" and tostring(self) == "ShootGun" then
        local target = getMurderer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            args[1] = target.Character.Head.Position -- Подмена координат выстрела
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local function getPlayerRole(p)
    local bp = p:FindFirstChild("Backpack")
    local char = p.Character
    if (bp and bp:FindFirstChild("Knife")) or (char and char:FindFirstChild("Knife")) then
        return "Murder"
    elseif (bp and bp:FindFirstChild("Gun")) or (char and char:FindFirstChild("Gun")) then
        return "Sheriff"
    end
    return "Innocent"
end

task.spawn(function()
    while true do
        task.wait(0.2)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character then
                local hl = p.Character:FindFirstChild("ZHL")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "ZHL"
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = p.Character
                end
                
                hl.FillTransparency = 0.4 -- Прозрачность заливки (0 - яркая, 1 - невидимая)
                
                local role = getPlayerRole(p)
                if role == "Murder" then 
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                elseif role == "Sheriff" then 
                    hl.FillColor = Color3.fromRGB(0, 120, 255)
                else 
                    hl.FillColor = Color3.fromRGB(0, 255, 100) 
                end
            end
        end
    end
end)
local Workspace = game:GetService("Workspace")

task.spawn(function()
    while true do
        task.wait(0.2)
        
        -- 1. Подсветка пистолета (GunDrop)
        local gunDrop = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Gun")
        if gunDrop then
            local targetPart = gunDrop:IsA("BasePart") and gunDrop or gunDrop:FindFirstChildOfClass("MeshPart") or gunDrop:FindFirstChildOfClass("BasePart")
            if targetPart then
                local g = targetPart:FindFirstChild("ZI")
                if not g then
                    g = Instance.new("Highlight")
                    g.Name = "ZI"
                    g.OutlineColor = Color3.new(1, 1, 1)
                    g.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    g.Parent = targetPart
                end
                g.FillColor = Color3.fromRGB(0, 255, 255) -- Бирюзовый цвет для оружия
                g.FillTransparency = 0.3
            end
        end

        -- 2. Подсветка монет
        local coinContainers = {Workspace:FindFirstChild("NormalCoins"), Workspace:FindFirstChild("CoinContainer")}
        for _, container in ipairs(coinContainers) do
            if container then
                for _, c in ipairs(container:GetChildren()) do
                    local h = c:FindFirstChild("ZI")
                    if not h then
                        h = Instance.new("Highlight")
                        h.Name = "ZI"
                        h.OutlineColor = Color3.new(1, 1, 0)
                        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        h.Parent = c
                    end
                    h.FillColor = Color3.fromRGB(255, 215, 0) -- Золотой цвет для монет
                    h.FillTransparency = 0.5
                end
            end
        end
    end
end)
