local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Função para criar o ícone ninja na tela
local function CreateNinjaIcon()
    local screenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    screenGui.Name = "NinjaHubGUI"
    local image = Instance.new("ImageButton", screenGui)
    image.Name = "NinjaIcon"
    image.Size = UDim2.new(0, 60, 0, 60)
    image.Position = UDim2.new(0, 10, 0, 10)
    image.Image = "rbxassetid://10471137141" -- Ícone ninja (pode trocar)
    image.BackgroundTransparency = 1
    return image
end

local ninjaIcon = CreateNinjaIcon()

-- Tabela para armazenar o menu
local menuVisible = false
local menuFrame

-- Função para criar o menu de funções
local function ToggleMenu()
    if menuFrame then
        menuFrame.Visible = not menuFrame.Visible
        return
    end
    menuFrame = Instance.new("Frame", ninjaIcon.Parent)
    menuFrame.Size = UDim2.new(0, 200, 0, 150)
    menuFrame.Position = UDim2.new(0, 80, 0, 10)
    menuFrame.BackgroundColor3 = Color3.fromRGB(31,31,31)
    menuFrame.BorderSizePixel = 0

    local function createButton(name, y, callback)
        local btn = Instance.new("TextButton", menuFrame)
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, 10 + y*45)
        btn.Text = name
        btn.BackgroundColor3 = Color3.fromRGB(49,49,49)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    createButton("Aimbot Universal", 0, function()
        loadstring([[
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local Mouse = LocalPlayer:GetMouse()
            local RunService = game:GetService("RunService")
            getgenv().AIMBOT_ENABLED = not getgenv().AIMBOT_ENABLED
            if getgenv().AIMBOT_CONNECTION then getgenv().AIMBOT_CONNECTION:Disconnect() end
            if getgenv().AIMBOT_ENABLED then
                getgenv().AIMBOT_CONNECTION = RunService.RenderStepped:Connect(function()
                    local closest, minDist = nil, math.huge
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                            local pos = workspace.CurrentCamera:WorldToScreenPoint(player.Character.Head.Position)
                            local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                            if dist < minDist and pos.Z > 0 then
                                minDist = dist
                                closest = player
                            end
                        end
                    end
                    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
                        Mouse.Target = closest.Character.Head
                    end
                end)
            end
        ]])()
    end)

    createButton("ESP Jogadores", 1, function()
        loadstring([[
            getgenv().ESP_ENABLED = not getgenv().ESP_ENABLED
            if getgenv().ESP_CONNECTION then getgenv().ESP_CONNECTION:Disconnect() end
            if getgenv().ESP_ENABLED then
                getgenv().ESP_CONNECTION = game:GetService("RunService").RenderStepped:Connect(function()
                    for _,v in pairs(game:GetService("Players"):GetPlayers()) do
                        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") then
                            if not v.Character.Head:FindFirstChild("NinjaESP") then
                                local billboard = Instance.new("BillboardGui", v.Character.Head)
                                billboard.Name = "NinjaESP"
                                billboard.Size = UDim2.new(0,100,0,40)
                                billboard.AlwaysOnTop = true
                                local label = Instance.new("TextLabel", billboard)
                                label.Size = UDim2.new(1,0,1,0)
                                label.BackgroundTransparency = 1
                                label.Text = v.Name
                                label.TextColor3 = Color3.new(1,0,0)
                                label.TextScaled = true
                            end
                        end
                    end
                end)
            else
                for _,v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v.Character and v.Character:FindFirstChild("Head") then
                        local esp = v.Character.Head:FindFirstChild("NinjaESP")
                        if esp then esp:Destroy() end
                    end
                end
            end
        ]])()
    end)

    createButton("Auto Subir Nível (Blox Fruits)", 2, function()
        loadstring([[
            getgenv().AUTO_FARM = not getgenv().AUTO_FARM
            if getgenv().AUTO_FARM_CONNECTION then getgenv().AUTO_FARM_CONNECTION:Disconnect() end
            local function getNearestMob()
                local minDist, mob = math.huge
                for _,v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        local dist = (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            mob = v
                        end
                    end
                end
                return mob
            end
            if getgenv().AUTO_FARM then
                getgenv().AUTO_FARM_CONNECTION = game:GetService("RunService").Heartbeat:Connect(function()
                    local mob = getNearestMob()
                    if mob then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,3,0)
                        if mob:FindFirstChildOfClass("Humanoid") then
                            for _,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                                if v:IsA("Tool") then
                                    v.Parent = game.Players.LocalPlayer.Character
                                    v:Activate()
                                end
                            end
                        end
                    end
                end)
            end
        ]])()
    end)
end

ninjaIcon.MouseButton1Click:Connect(ToggleMenu)
