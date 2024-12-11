local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local plr = Players.LocalPlayer
local ESPenabled = false


local function getRoot(character)
    return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
end


local function removeESP()
    for _, c in pairs(CoreGui:GetChildren()) do
        if string.sub(c.Name, -4) == '_ESP' then
            c:Destroy()
        end
    end
end


local function ESP(targetPlayer)
    task.spawn(function()
        
        for _, v in pairs(CoreGui:GetChildren()) do
            if v.Name == targetPlayer.Name .. '_ESP' then
                v:Destroy()
            end
        end

        
        repeat task.wait(1) until targetPlayer.Character and getRoot(targetPlayer.Character) and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not targetPlayer.Character then return end

        
        local ESPholder = Instance.new("Folder")
        ESPholder.Name = targetPlayer.Name .. '_ESP'
        ESPholder.Parent = CoreGui

        
        local highlight = Instance.new("Highlight")
        highlight.Name = targetPlayer.Name
        highlight.Parent = ESPholder
        highlight.Adornee = targetPlayer.Character
        highlight.FillTransparency = 0.45
        highlight.FillColor = Color3.fromRGB(0, 255, 0)

        
        if targetPlayer.Character:FindFirstChild("Head") then
            local BillboardGui = Instance.new("BillboardGui")
            local TextLabel = Instance.new("TextLabel")
            BillboardGui.Adornee = targetPlayer.Character.Head
            BillboardGui.Name = targetPlayer.Name
            BillboardGui.Parent = ESPholder
            BillboardGui.Size = UDim2.new(0, 100, 0, 150)
            BillboardGui.StudsOffset = Vector3.new(0, 1, 0)
            BillboardGui.AlwaysOnTop = true

            TextLabel.Parent = BillboardGui
            TextLabel.BackgroundTransparency = 1
            TextLabel.Position = UDim2.new(0, 0, 0, -50)
            TextLabel.Size = UDim2.new(0, 100, 0, 100)
            TextLabel.Font = Enum.Font.SourceSansSemibold
            TextLabel.TextSize = 17
            TextLabel.TextColor3 = Color3.new(12 / 255, 4 / 255, 20 / 255) 
            TextLabel.TextStrokeTransparency = 0.3
            TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom
            TextLabel.Text = '@' .. targetPlayer.Name .. ' | ' .. targetPlayer.DisplayName
            TextLabel.ZIndex = 10

            
            local function espLoop()
                if CoreGui:FindFirstChild(targetPlayer.Name .. '_ESP') then
                    if targetPlayer.Character and getRoot(targetPlayer.Character) and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
                        and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character)
                        and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then

                        local distance = math.floor((getRoot(Players.LocalPlayer.Character).Position - getRoot(targetPlayer.Character).Position).magnitude)
                        TextLabel.Text = '@' .. targetPlayer.Name .. ' | ' .. targetPlayer.DisplayName .. ' | Studs: ' .. distance
                        highlight.Adornee = targetPlayer.Character
                    end
                end
            end

            RunService.RenderStepped:Connect(espLoop)
        end
    end)
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimbotUI"
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 300) 
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(177, 252, 3)
mainFrame.BorderSizePixel = 1
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 3)
mainFrameCorner.Parent = mainFrame

local titleBar = Instance.new("TextLabel")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, -0.1)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleBar.BorderSizePixel = 0
titleBar.Text = "DioHubs Simple ESP"
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextColor3 = Color3.fromRGB(0, 0, 0)
titleBar.TextSize = 20
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 3)
titleBarCorner.Parent = titleBar

local function createButton(name, posY, toggleFunc)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, posY)
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.TextColor3 = Color3.fromRGB(0, 0, 0)
    button.Text = name
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 24
    button.Parent = mainFrame

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        toggleFunc(button)
    end)
end


createButton("ESP", 50, function(button)
    ESPenabled = not ESPenabled
    if ESPenabled then
        button.Text = "ESP: ON"
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= plr then
                ESP(player)
            end
        end
        Players.PlayerAdded:Connect(function(player)
            if ESPenabled then
                ESP(player)
            end
        end)
    else
        button.Text = "ESP: OFF"
        removeESP()
    end
end)


local usernameTextBox = Instance.new("TextBox")
usernameTextBox.Name = "UsernameTextBox"
usernameTextBox.Size = UDim2.new(1, -20, 0, 30)
usernameTextBox.Position = UDim2.new(0, 10, 0, 100)
usernameTextBox.PlaceholderText = "Enter Username"
usernameTextBox.Font = Enum.Font.SourceSans
usernameTextBox.TextColor3 = Color3.fromRGB(0, 0, 0)
usernameTextBox.TextSize = 20
usernameTextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
usernameTextBox.Text = ""
usernameTextBox.ClearTextOnFocus = false
usernameTextBox.Parent = mainFrame


createButton("Teleport", 140, function(button)
    local targetUsername = usernameTextBox.Text
    local targetPlayer = Players:FindFirstChild(targetUsername)

    if targetPlayer and targetPlayer.Character then
        local targetRoot = getRoot(targetPlayer.Character)
        local playerRoot = getRoot(Players.LocalPlayer.Character)

        if targetRoot and playerRoot then
            playerRoot.CFrame = targetRoot.CFrame + Vector3.new(2, 0, 2) 
            print("Teleported to", targetUsername)
        else
            print("Error: Could not find root parts.")
        end
    else
        print("Player not found or character not loaded.")
    end
end)


createButton("Close", 190, function(button)
    screenGui:Destroy()
end)
