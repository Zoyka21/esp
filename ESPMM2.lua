local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZoykaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 200)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Logo = Instance.new("TextLabel")
Logo.Size = UDim2.new(1, 0, 0, 35)
Logo.BackgroundColor3 = Color3.fromRGB(15, 15, 17)
Logo.Text = "  ZoykaHub v1 (MM2)"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.Font = Enum.Font.SourceSansBold
Logo.TextSize = 16
Logo.TextXAlignment = Enum.TextXAlignment.Left
Logo.BorderSizePixel = 0
Logo.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 9)
MainCorner.Parent = MainFrame

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 9)
LogoCorner.Parent = Logo

local dragging, dragInput, dragStart, startPos
Logo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Logo.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local espPlayers = false
local BtnPlayers = Instance.new("TextButton")
BtnPlayers.Size = UDim2.new(0, 310, 0, 35)
BtnPlayers.Position = UDim2.new(0, 20, 0, 50)
BtnPlayers.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
BtnPlayers.Text = "ESP Roles: OFF"
BtnPlayers.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnPlayers.Font = Enum.Font.SourceSansBold
BtnPlayers.Parent = MainFrame
Instance.new("UICorner", BtnPlayers).CornerRadius = UDim.new(0, 6)

BtnPlayers.MouseButton1Click:Connect(function()
    espPlayers = not espPlayers
    BtnPlayers.Text = espPlayers and "ESP Roles: ON" or "ESP Roles: OFF"
    BtnPlayers.BackgroundColor3 = espPlayers and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(180, 40, 40)
end)

local espItems = false
local BtnItems = Instance.new("TextButton")
BtnItems.Size = UDim2.new(0, 310, 0, 35)
BtnItems.Position = UDim2.new(0, 20, 0, 95)
BtnItems.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
BtnItems.Text = "ESP Gun & Coins: OFF"
BtnItems.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnItems.Font = Enum.Font.SourceSansBold
BtnItems.Parent = MainFrame
Instance.new("UICorner", BtnItems).CornerRadius = UDim.new(0, 6)

BtnItems.MouseButton1Click:Connect(function()
    espItems = not espItems
    BtnItems.Text = espItems and "ESP Gun & Coins: ON" or "ESP Gun & Coins: OFF"
    BtnItems.BackgroundColor3 = espItems and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(180, 40, 40)
end)

local speedActive = false
local BtnSpeed = Instance.new("TextButton")
BtnSpeed.Size = UDim2.new(0, 310, 0, 35)
BtnSpeed.Position = UDim2.new(0, 20, 0, 140)
BtnSpeed.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
BtnSpeed.Text = "Speed Boost: OFF (16)"
BtnSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
BtnSpeed.Font = Enum.Font.SourceSansBold
BtnSpeed.Parent = MainFrame
Instance.new("UICorner", BtnSpeed).CornerRadius = UDim.new(0, 6)

local function updateSpeed()
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speedActive and 35 or 16
    end
end

BtnSpeed.MouseButton1Click:Connect(function()
    speedActive = not speedActive
    BtnSpeed.Text = speedActive and "Speed Boost: ON (35)" or "Speed Boost: OFF (16)"
    BtnSpeed.BackgroundColor3 = speedActive and Color3.fromRGB(40, 150, 70) or Color3.fromRGB(40, 40, 45)
    updateSpeed()
end)

localPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    updateSpeed()
end)

task.spawn(function()
    while true do
        task.wait(0.3)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= localPlayer and p.Character then
                local hl = p.Character:FindFirstChild("ZHL")
                if espPlayers then
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "ZHL"
                        hl.OutlineColor = Color3.new(1, 1, 1)
                        hl.Parent = p.Character
                    end
                    hl.FillTransparency = 0.4
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
        if espItems then
            local gd = Workspace:FindFirstChild("GunDrop")
            if gd and not gd:FindFirstChild("ZI") then
                local g = Instance.new("Highlight")
                g.Name = "ZI"
                g.FillColor = Color3.fromRGB(255, 215, 0)
                g.Parent = gd
            end
            local nc = Workspace:FindFirstChild("NormalCoins")
            if nc then
                for _, c in ipairs(nc:GetChildren()) do
                    if (c:IsA("BasePart") or c:IsA("Model")) and not c:FindFirstChild("ZI") then
                        local h = Instance.new("Highlight")
                        h.Name = "ZI"
                        h.FillColor = Color3.fromRGB(235, 190, 30)
                        h.FillTransparency = 0.5
                        h.Parent = c
                    end
                end
            end
        else
            local gd = Workspace:FindFirstChild("GunDrop")
            if gd and gd:FindFirstChild("ZI") then gd.ZI:Destroy() end
            local nc = Workspace:FindFirstChild("NormalCoins")
            if nc then
                for _, c in ipairs(nc:GetChildren()) do
                    if c:FindFirstChild("ZI") then c.ZI:Destroy() end
                end
            end
        end
    end
end)
