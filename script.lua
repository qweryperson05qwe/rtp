-- LocalScript in StarterPlayerScripts
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- CHECK FOR MOBILE DEVICE
local isMobile = UserInputService.TouchEnabled

-- UI STYLING HELPER
local function addStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(40, 40, 50)
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyControlGUI_Modern"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- OPEN BUTTON
local openButton = Instance.new("TextButton")
openButton.Name = "OpenMenuButton"
openButton.Size = UDim2.new(0, 80, 0, 35)
openButton.Position = UDim2.new(0, 10, 0.5, 0)
openButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
openButton.Text = "MENU"
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 12
openButton.Visible = false
openButton.Parent = screenGui
Instance.new("UICorner", openButton).CornerRadius = UDim.new(0, 8)
addStroke(openButton)

-- Main container frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 420)
mainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
addStroke(mainFrame, Color3.fromRGB(50, 50, 65), 1.5)

-- Modern gradient effect
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 18, 24)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 8, 12))
})
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local titleFiller = Instance.new("Frame")
titleFiller.Size = UDim2.new(1, 0, 0.5, 0)
titleFiller.Position = UDim2.new(0, 0, 0.5, 0)
titleFiller.BackgroundColor3 = titleBar.BackgroundColor3
titleFiller.BorderSizePixel = 0
titleFiller.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MOVEMENT SYSTEM"
titleLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Separator line
local headerLine = Instance.new("Frame")
headerLine.Size = UDim2.new(1, 0, 0, 1)
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
headerLine.BorderSizePixel = 0
headerLine.Parent = titleBar

-- DRAGGABLE GUI LOGIC
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- CLOSE BUTTON
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -30, 0.5, -12)
closeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
closeButton.Text = ""
closeButton.AutoButtonColor = true
closeButton.Parent = titleBar
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)
addStroke(closeButton)

local closeIcon = Instance.new("ImageLabel")
closeIcon.Size = UDim2.new(0, 12, 0, 12)
closeIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
closeIcon.BackgroundTransparency = 1
closeIcon.Image = "rbxassetid://3926305904"
closeIcon.ImageRectOffset = Vector2.new(284, 4)
closeIcon.ImageRectSize = Vector2.new(24, 24)
closeIcon.ImageColor3 = Color3.fromRGB(150, 150, 160)
closeIcon.Parent = closeButton

-- SCROLLING FRAME
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ContentScroll"
scrollFrame.Size = UDim2.new(1, -10, 1, -45)
scrollFrame.Position = UDim2.new(0, 5, 0, 40)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 2
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollFrame.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollFrame
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 4)
listPadding.PaddingBottom = UDim.new(0, 10)
listPadding.PaddingLeft = UDim.new(0, 5)
listPadding.PaddingRight = UDim.new(0, 5)
listPadding.Parent = scrollFrame

-- HELPER FOR CREATING CONTAINERS
local function createContainer(name, sizeY, order)
    local container = Instance.new("Frame")
    container.Name = name
    container.Size = UDim2.new(1, 0, 0, sizeY)
    container.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    container.LayoutOrder = order
    container.Parent = scrollFrame
    Instance.new("UICorner", container).CornerRadius = UDim.new(0, 8)
    addStroke(container)
    return container
end

-- 1. Status Section
local statusContainer = createContainer("StatusContainer", 45, 1)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.5, -5, 0.5, 0)
statusLabel.Position = UDim2.new(0, 10, 0, 2)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "SYSTEM STATUS:"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
statusLabel.TextSize = 11
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = statusContainer

local statusValue = Instance.new("TextLabel")
statusValue.Size = UDim2.new(0.5, -15, 0.5, 0)
statusValue.Position = UDim2.new(0.5, 0, 0, 2)
statusValue.BackgroundTransparency = 1
statusValue.Text = "STANDBY"
statusValue.TextColor3 = Color3.fromRGB(100, 100, 120)
statusValue.TextSize = 11
statusValue.Font = Enum.Font.GothamBold
statusValue.TextXAlignment = Enum.TextXAlignment.Right
statusValue.Parent = statusContainer

local statusSubLabel = Instance.new("TextLabel")
statusSubLabel.Size = UDim2.new(1, -20, 0.5, 0)
statusSubLabel.Position = UDim2.new(0, 10, 0.5, 0)
statusSubLabel.BackgroundTransparency = 1
statusSubLabel.Text = "Awaiting movement commands"
statusSubLabel.TextColor3 = Color3.fromRGB(100, 100, 120)
statusSubLabel.TextSize = 10
statusSubLabel.Font = Enum.Font.Gotham
statusSubLabel.TextXAlignment = Enum.TextXAlignment.Left
statusSubLabel.Parent = statusContainer

-- 2. Speed Control
local speedContainer = createContainer("SpeedContainer", 55, 2)

local speedHeader = Instance.new("TextLabel")
speedHeader.Size = UDim2.new(1, -20, 0, 20)
speedHeader.Position = UDim2.new(0, 10, 0, 5)
speedHeader.BackgroundTransparency = 1
speedHeader.Text = "MOVEMENT SPEED"
speedHeader.TextColor3 = Color3.fromRGB(150, 150, 170)
speedHeader.TextSize = 11
speedHeader.Font = Enum.Font.GothamBold
speedHeader.TextXAlignment = Enum.TextXAlignment.Left
speedHeader.Parent = speedContainer

local speedInputBox = Instance.new("TextBox")
speedInputBox.Size = UDim2.new(1, -20, 0, 24)
speedInputBox.Position = UDim2.new(0, 10, 0, 25)
speedInputBox.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
speedInputBox.Text = ""
speedInputBox.PlaceholderText = "Speed (Default: 50)"
speedInputBox.PlaceholderColor3 = Color3.fromRGB(80, 80, 90)
speedInputBox.TextColor3 = Color3.fromRGB(0, 200, 255)
speedInputBox.TextSize = 12
speedInputBox.Font = Enum.Font.GothamBold
speedInputBox.Parent = speedContainer
Instance.new("UICorner", speedInputBox).CornerRadius = UDim.new(0, 6)
addStroke(speedInputBox)

-- 3. Hotkey Control
local hotkeyContainer = createContainer("HotkeyContainer", 40, 3)

local hotkeyLabel = Instance.new("TextLabel")
hotkeyLabel.Size = UDim2.new(0.6, 0, 1, 0)
hotkeyLabel.Position = UDim2.new(0, 10, 0, 0)
hotkeyLabel.BackgroundTransparency = 1
hotkeyLabel.Text = "Movement Keybind:"
hotkeyLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
hotkeyLabel.TextSize = 11
hotkeyLabel.Font = Enum.Font.Gotham
hotkeyLabel.TextXAlignment = Enum.TextXAlignment.Left
hotkeyLabel.Parent = hotkeyContainer

local hotkeyButton = Instance.new("TextButton")
hotkeyButton.Size = UDim2.new(0.35, -5, 0, 24)
hotkeyButton.Position = UDim2.new(0.65, -5, 0.5, -12)
hotkeyButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
hotkeyButton.Text = "E"
hotkeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hotkeyButton.TextSize = 12
hotkeyButton.Font = Enum.Font.GothamBold
hotkeyButton.Parent = hotkeyContainer
Instance.new("UICorner", hotkeyButton).CornerRadius = UDim.new(0, 6)
addStroke(hotkeyButton)

if isMobile then
    hotkeyLabel.Text = "Mobile Mode:"
    hotkeyButton.Text = "TOUCH"
    hotkeyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    hotkeyButton.AutoButtonColor = false
end

-- 4. Auto-Track
local trackContainer = createContainer("TrackContainer", 55, 4)

local trackHeader = Instance.new("TextLabel")
trackHeader.Size = UDim2.new(1, -20, 0, 20)
trackHeader.Position = UDim2.new(0, 10, 0, 5)
trackHeader.BackgroundTransparency = 1
trackHeader.Text = "AUTO-TRACK (PLAYERS/LIVE)"
trackHeader.TextColor3 = Color3.fromRGB(150, 150, 170)
trackHeader.TextSize = 11
trackHeader.Font = Enum.Font.GothamBold
trackHeader.TextXAlignment = Enum.TextXAlignment.Left
trackHeader.Parent = trackContainer

local trackLabel = Instance.new("TextLabel")
trackLabel.Size = UDim2.new(0.6, 0, 0, 30)
trackLabel.Position = UDim2.new(0, 10, 0, 20)
trackLabel.BackgroundTransparency = 1
trackLabel.Text = "Follow Nearest:"
trackLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
trackLabel.TextSize = 11
trackLabel.Font = Enum.Font.Gotham
trackLabel.TextXAlignment = Enum.TextXAlignment.Left
trackLabel.Parent = trackContainer

local trackButton = Instance.new("TextButton")
trackButton.Size = UDim2.new(0.35, -5, 0, 24)
trackButton.Position = UDim2.new(0.65, -5, 0, 23)
trackButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
trackButton.Text = "OFF"
trackButton.TextColor3 = Color3.fromRGB(150, 150, 150)
trackButton.TextSize = 11
trackButton.Font = Enum.Font.GothamBold
trackButton.Parent = trackContainer
Instance.new("UICorner", trackButton).CornerRadius = UDim.new(0, 6)
addStroke(trackButton)

-- 5. Player ESP
local espContainer = createContainer("ESPContainer", 40, 5)

local espLabel = Instance.new("TextLabel")
espLabel.Size = UDim2.new(0.6, 0, 1, 0)
espLabel.Position = UDim2.new(0, 10, 0, 0)
espLabel.BackgroundTransparency = 1
espLabel.Text = "Player ESP (Box+Name):"
espLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
espLabel.TextSize = 11
espLabel.Font = Enum.Font.Gotham
espLabel.TextXAlignment = Enum.TextXAlignment.Left
espLabel.Parent = espContainer

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.35, -5, 0, 24)
espButton.Position = UDim2.new(0.65, -5, 0.5, -12)
espButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
espButton.Text = "OFF"
espButton.TextColor3 = Color3.fromRGB(150, 150, 150)
espButton.TextSize = 11
espButton.Font = Enum.Font.GothamBold
espButton.Parent = espContainer
Instance.new("UICorner", espButton).CornerRadius = UDim.new(0, 6)
addStroke(espButton)

-- 6. Mobile Fly
local mobileContainer = createContainer("MobileContainer", 40, 6)

local mobileLabel = Instance.new("TextLabel")
mobileLabel.Size = UDim2.new(0.6, 0, 1, 0)
mobileLabel.Position = UDim2.new(0, 10, 0, 0)
mobileLabel.BackgroundTransparency = 1
mobileLabel.Text = "Mobile Fly (Cam):"
mobileLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
mobileLabel.TextSize = 11
mobileLabel.Font = Enum.Font.Gotham
mobileLabel.TextXAlignment = Enum.TextXAlignment.Left
mobileLabel.Parent = mobileContainer

local mobileButton = Instance.new("TextButton")
mobileButton.Size = UDim2.new(0.35, -5, 0, 24)
mobileButton.Position = UDim2.new(0.65, -5, 0.5, -12)
mobileButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mobileButton.Text = "OFF"
mobileButton.TextColor3 = Color3.fromRGB(150, 150, 150)
mobileButton.TextSize = 11
mobileButton.Font = Enum.Font.GothamBold
mobileButton.Parent = mobileContainer
Instance.new("UICorner", mobileButton).CornerRadius = UDim.new(0, 6)
addStroke(mobileButton)

-- 7. VIP Bypass
local vipContainer = createContainer("VipContainer", 70, 7)

local vipHeader = Instance.new("TextLabel")
vipHeader.Size = UDim2.new(1, -20, 0, 20)
vipHeader.Position = UDim2.new(0, 10, 0, 5)
vipHeader.BackgroundTransparency = 1
vipHeader.Text = "VIP BYPASS (GLITCH)"
vipHeader.TextColor3 = Color3.fromRGB(255, 215, 0)
vipHeader.TextSize = 11
vipHeader.Font = Enum.Font.GothamBold
vipHeader.TextXAlignment = Enum.TextXAlignment.Left
vipHeader.Parent = vipContainer

local vipLabel = Instance.new("TextLabel")
vipLabel.Size = UDim2.new(0.6, 0, 0, 30)
vipLabel.Position = UDim2.new(0, 10, 0, 20)
vipLabel.BackgroundTransparency = 1
vipLabel.Text = "Activate Glitch:"
vipLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
vipLabel.TextSize = 11
vipLabel.Font = Enum.Font.Gotham
vipLabel.TextXAlignment = Enum.TextXAlignment.Left
vipLabel.Parent = vipContainer

local vipButton = Instance.new("TextButton")
vipButton.Size = UDim2.new(0.35, -5, 0, 24)
vipButton.Position = UDim2.new(0.65, -5, 0, 23)
vipButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
vipButton.Text = "OFF"
vipButton.TextColor3 = Color3.fromRGB(150, 150, 150)
vipButton.TextSize = 11
vipButton.Font = Enum.Font.GothamBold
vipButton.Parent = vipContainer
Instance.new("UICorner", vipButton).CornerRadius = UDim.new(0, 6)
addStroke(vipButton)

local vipStatus = Instance.new("TextLabel")
vipStatus.Size = UDim2.new(1, -20, 0, 20)
vipStatus.Position = UDim2.new(0, 10, 0, 48)
vipStatus.BackgroundTransparency = 1
vipStatus.Text = "Ready."
vipStatus.TextColor3 = Color3.fromRGB(120, 120, 140)
vipStatus.TextSize = 10
vipStatus.Font = Enum.Font.Gotham
vipStatus.TextXAlignment = Enum.TextXAlignment.Left
vipStatus.Parent = vipContainer

-- 8. Auto Dodge
local dodgeContainer = createContainer("DodgeContainer", 95, 8)

local dodgeHeader = Instance.new("TextLabel")
dodgeHeader.Size = UDim2.new(1, -20, 0, 20)
dodgeHeader.Position = UDim2.new(0, 10, 0, 5)
dodgeHeader.BackgroundTransparency = 1
dodgeHeader.Text = "AUTO DODGE"
dodgeHeader.TextColor3 = Color3.fromRGB(255, 60, 100)
dodgeHeader.TextSize = 11
dodgeHeader.Font = Enum.Font.GothamBold
dodgeHeader.TextXAlignment = Enum.TextXAlignment.Left
dodgeHeader.Parent = dodgeContainer

local dodgeLabel = Instance.new("TextLabel")
dodgeLabel.Size = UDim2.new(0.6, 0, 0, 30)
dodgeLabel.Position = UDim2.new(0, 10, 0, 20)
dodgeLabel.BackgroundTransparency = 1
dodgeLabel.Text = "Enable Evade:"
dodgeLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
dodgeLabel.TextSize = 11
dodgeLabel.Font = Enum.Font.Gotham
dodgeLabel.TextXAlignment = Enum.TextXAlignment.Left
dodgeLabel.Parent = dodgeContainer

local dodgeButton = Instance.new("TextButton")
dodgeButton.Size = UDim2.new(0.35, -5, 0, 24)
dodgeButton.Position = UDim2.new(0.65, -5, 0, 23)
dodgeButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
dodgeButton.Text = "OFF"
dodgeButton.TextColor3 = Color3.fromRGB(150, 150, 150)
dodgeButton.TextSize = 11
dodgeButton.Font = Enum.Font.GothamBold
dodgeButton.Parent = dodgeContainer
Instance.new("UICorner", dodgeButton).CornerRadius = UDim.new(0, 6)
addStroke(dodgeButton)

local dodgeOptionsFrame = Instance.new("Frame")
dodgeOptionsFrame.Size = UDim2.new(1, -20, 0, 26)
dodgeOptionsFrame.Position = UDim2.new(0, 10, 0, 55)
dodgeOptionsFrame.BackgroundTransparency = 1
dodgeOptionsFrame.Visible = false
dodgeOptionsFrame.Parent = dodgeContainer

local dodgePlayerButton = Instance.new("TextButton")
dodgePlayerButton.Size = UDim2.new(0.48, 0, 1, 0)
dodgePlayerButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
dodgePlayerButton.Text = "Plyr [ON]"
dodgePlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dodgePlayerButton.Font = Enum.Font.GothamBold
dodgePlayerButton.TextSize = 11
dodgePlayerButton.Parent = dodgeOptionsFrame
Instance.new("UICorner", dodgePlayerButton).CornerRadius = UDim.new(0, 5)
addStroke(dodgePlayerButton)

local dodgeBulletButton = Instance.new("TextButton")
dodgeBulletButton.Size = UDim2.new(0.48, 0, 1, 0)
dodgeBulletButton.Position = UDim2.new(0.52, 0, 0, 0)
dodgeBulletButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
dodgeBulletButton.Text = "Obj [ON]"
dodgeBulletButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dodgeBulletButton.Font = Enum.Font.GothamBold
dodgeBulletButton.TextSize = 11
dodgeBulletButton.Parent = dodgeOptionsFrame
Instance.new("UICorner", dodgeBulletButton).CornerRadius = UDim.new(0, 5)
addStroke(dodgeBulletButton)

-- 9. Food Automation
local foodContainer = createContainer("FoodContainer", 60, 9)

local foodHeader = Instance.new("TextLabel")
foodHeader.Size = UDim2.new(1, -20, 0, 20)
foodHeader.Position = UDim2.new(0, 10, 0, 5)
foodHeader.BackgroundTransparency = 1
foodHeader.Text = "FOOD AUTOMATION"
foodHeader.TextColor3 = Color3.fromRGB(0, 255, 150)
foodHeader.TextSize = 11
foodHeader.Font = Enum.Font.GothamBold
foodHeader.TextXAlignment = Enum.TextXAlignment.Left
foodHeader.Parent = foodContainer

local foodFarmLabel = Instance.new("TextLabel")
foodFarmLabel.Size = UDim2.new(0.6, 0, 0, 30)
foodFarmLabel.Position = UDim2.new(0, 10, 0, 25)
foodFarmLabel.BackgroundTransparency = 1
foodFarmLabel.Text = "Auto Farm Food:"
foodFarmLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
foodFarmLabel.TextSize = 11
foodFarmLabel.Font = Enum.Font.Gotham
foodFarmLabel.TextXAlignment = Enum.TextXAlignment.Left
foodFarmLabel.Parent = foodContainer

local foodFarmButton = Instance.new("TextButton")
foodFarmButton.Size = UDim2.new(0.35, -5, 0, 24)
foodFarmButton.Position = UDim2.new(0.65, -5, 0, 28)
foodFarmButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
foodFarmButton.Text = "OFF"
foodFarmButton.TextColor3 = Color3.fromRGB(150, 150, 150)
foodFarmButton.TextSize = 11
foodFarmButton.Font = Enum.Font.GothamBold
foodFarmButton.Parent = foodContainer
Instance.new("UICorner", foodFarmButton).CornerRadius = UDim.new(0, 6)
addStroke(foodFarmButton)

mainFrame.Parent = screenGui

-- -------------------------------------------------------------
-- LOGIC
-- -------------------------------------------------------------

local character, humanoid, rootPart
local isMoving = false
local moveSpeed = 50
local currentHotkey = Enum.KeyCode.E

-- Generic BodyVelocity System for all ground movement
local function getMovementBV()
    if not rootPart then return nil end
    local bv = rootPart:FindFirstChild("GenericMovementBV")
    if not bv then
        bv = Instance.new("BodyVelocity")
        bv.Name = "GenericMovementBV"
        bv.MaxForce = Vector3.new(100000, 0, 100000) 
        bv.P = 1500
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = rootPart
    end
    return bv
end

local function stopMovementBV()
    if rootPart then
        local bv = rootPart:FindFirstChild("GenericMovementBV")
        if bv then bv:Destroy() end
    end
end

-- Variables
local autoTrackEnabled = false
local targetModel = nil
local timeAtTarget = 0
local reachedTarget = false
local TARGET_REACH_DISTANCE = 3 
local TARGET_STAY_TIME = 2
local autoTrackConnection = nil
local currentPath, waypoints = nil, {}
local currentWaypointIndex = 1
local MAX_VERTICAL_TRACK_DIST = 20

local espEnabled = false
local espConnections, espBoxes = {}, {} 

local mobileFlyEnabled = false
local mobileFlyConnection, bodyGyro, bodyVelocity = nil, nil, nil

local vipBypassEnabled = false
local vipConnection, vipPart1, vipPart2, vipBodyVelocity, vipBodyPosition, vipSpin, noclipConnection = nil, nil, nil, nil, nil, nil, nil
local vipTimer, vipStage = 0, 0 

local dodgeEnabled = false
local dodgePlayersEnabled, dodgeBulletsEnabled = true, true 
local dodgeConnection, dodgeBodyVelocity = nil, nil
local DODGE_RANGE, DODGE_FORCE_POWER = 20, 30 

local foodFarmEnabled, foodFarmConnection = false, nil
local currentFoodTarget, foodPath, foodWaypoints = nil, nil, {}
local foodWaypointIndex = 1

-- BLACKLIST SYSTEM: Stores items that cannot be reached to ignore them
local blacklistedTargets = {} 

local VIP_CFRAME_1 = CFrame.new(-607.340271, 1.1017642, -46.8191528, -0.694649816, 0, 0.719348073, 0, 1, 0, -0.719348073, 0, -0.694649816)
local VIP_CFRAME_2 = CFrame.new(-625.340271, 1.1017642, -46.8191528, -0.694649816, 0, 0.719348073, 0, 1, 0, -0.719348073, 0, -0.694649816)
local VIP_SPEED = 44

local function updateGUI()
    if isMoving then
        statusValue.Text = "ACTIVE"
        statusValue.TextColor3 = Color3.fromRGB(0, 200, 255)
    else
        statusValue.Text = "STANDBY"
        statusValue.TextColor3 = Color3.fromRGB(100, 100, 120)
    end
    
    local function setBtn(btn, state)
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        if state then
            btn.Text = "ON"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) 
            if stroke then stroke.Color = Color3.fromRGB(0, 160, 255) end
        else
            btn.Text = "OFF"
            btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            if stroke then stroke.Color = Color3.fromRGB(45, 45, 55) end
        end
    end

    setBtn(trackButton, autoTrackEnabled)
    setBtn(espButton, espEnabled)
    setBtn(mobileButton, mobileFlyEnabled)
    setBtn(foodFarmButton, foodFarmEnabled)
    
    if vipBypassEnabled then
        setBtn(vipButton, true)
        if vipStage == 0 then vipStatus.Text = "Go to Green Part..."
        elseif vipStage == 1 then vipStatus.Text = "Stay there..."
        elseif vipStage == 2 then vipStatus.Text = "SPINNING & MOVING..."
        elseif vipStage == 3 then vipStatus.Text = "HOLDING POSITION..."
        end
    else
        setBtn(vipButton, false)
        vipStatus.Text = "Glitch through VIP walls"
    end

    if dodgeEnabled then
        setBtn(dodgeButton, true)
        dodgeOptionsFrame.Visible = true
    else
        setBtn(dodgeButton, false)
        dodgeOptionsFrame.Visible = false
    end

    local function setSubBtn(btn, state, textOn, textOff)
        local stroke = btn:FindFirstChildOfClass("UIStroke")
        if state then
            btn.Text = textOn
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            if stroke then stroke.Color = Color3.fromRGB(0, 160, 255) end
        else
            btn.Text = textOff
            btn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            if stroke then stroke.Color = Color3.fromRGB(45, 45, 55) end
        end
    end

    setSubBtn(dodgePlayerButton, dodgePlayersEnabled, "Plyr [ON]", "Plyr [OFF]")
    setSubBtn(dodgeBulletButton, dodgeBulletsEnabled, "Obj [ON]", "Obj [OFF]")
end

-- --- BOX ESP FUNCTIONS ---
local function createBoxESP(playerCharacter)
    if not playerCharacter then return end
    if playerCharacter:FindFirstChild("ESP_Box") then playerCharacter.ESP_Box:Destroy() end
    if playerCharacter:FindFirstChild("ESP_NameTag") then playerCharacter.ESP_NameTag:Destroy() end
    
    local root = playerCharacter:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_Box"
    box.Adornee = root
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(4, 5, 4) 
    box.Transparency = 0.5
    box.Color3 = Color3.fromRGB(255, 0, 0)
    box.Parent = playerCharacter
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_NameTag"
    billboard.Adornee = root
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 4.5, 0) 
    billboard.AlwaysOnTop = true
    billboard.Parent = playerCharacter
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = playerCharacter.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 13
    nameLabel.Parent = billboard
    
    espBoxes[playerCharacter] = box 
end

local function enableESPForPlayer(player)
    if player == Players.LocalPlayer then return end
    local function setupESP()
        if player.Character then createBoxESP(player.Character) end
        espConnections[player] = player.CharacterAdded:Connect(function(character)
            local start = tick()
            while tick() - start < 5 do
                if character:FindFirstChild("HumanoidRootPart") then
                    createBoxESP(character)
                    break
                end
                wait(0.5)
            end
        end)
    end
    setupESP()
end

local function disableESPForPlayer(player)
    if espConnections[player] then espConnections[player]:Disconnect() espConnections[player] = nil end
    if player.Character then
        if player.Character:FindFirstChild("ESP_Box") then player.Character.ESP_Box:Destroy() end
        if player.Character:FindFirstChild("ESP_NameTag") then player.Character.ESP_NameTag:Destroy() end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do enableESPForPlayer(otherPlayer) end
        espConnections.playerAdded = Players.PlayerAdded:Connect(function(newPlayer) enableESPForPlayer(newPlayer) end)
    else
        for _, otherPlayer in ipairs(Players:GetPlayers()) do disableESPForPlayer(otherPlayer) end
        if espConnections.playerAdded then espConnections.playerAdded:Disconnect() espConnections.playerAdded = nil end
    end
    updateGUI()
end


-- --- VIP BYPASS FUNCTIONS ---
local function startNoclip()
    if noclipConnection then noclipConnection:Disconnect() end
    noclipConnection = RunService.Stepped:Connect(function()
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
    end)
end

local function stopNoclip()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
end

local function createSpin()
    if not rootPart then return end
    local spin = Instance.new("BodyAngularVelocity")
    spin.Name = "VipSpin"
    spin.MaxTorque = Vector3.new(0, math.huge, 0)
    spin.AngularVelocity = Vector3.new(0, 1000, 0)
    spin.Parent = rootPart
    return spin
end

local function cleanupVip()
    if vipConnection then vipConnection:Disconnect() vipConnection = nil end
    if vipPart1 then vipPart1:Destroy() vipPart1 = nil end
    if vipPart2 then vipPart2:Destroy() vipPart2 = nil end
    if vipBodyVelocity then vipBodyVelocity:Destroy() vipBodyVelocity = nil end
    if vipBodyPosition then vipBodyPosition:Destroy() vipBodyPosition = nil end
    if vipSpin then vipSpin:Destroy() vipSpin = nil end
    stopNoclip()
    vipStage = 0
    vipTimer = 0
end

local function createVipPart(cframe, color, name)
    local p = Instance.new("Part")
    p.Name = name
    p.Anchored = true
    p.CanCollide = false
    p.CFrame = cframe
    p.Size = Vector3.new(2, 5, 2)
    p.Transparency = 0.5
    p.Color = color
    p.Material = Enum.Material.Neon
    p.Parent = Workspace
    
    local bb = Instance.new("BillboardGui")
    bb.Adornee = p
    bb.Size = UDim2.new(0, 100, 0, 50)
    bb.StudsOffset = Vector3.new(0, 4, 0)
    bb.AlwaysOnTop = true
    bb.Parent = p
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.BackgroundTransparency = 1
    txt.Text = name
    txt.TextColor3 = color
    txt.TextStrokeTransparency = 0
    txt.Font = Enum.Font.GothamBold
    txt.TextSize = 14
    txt.Parent = bb
    return p
end

local function startVipBypass()
    cleanupVip()
    vipBypassEnabled = true
    vipPart1 = createVipPart(VIP_CFRAME_1, Color3.fromRGB(0, 255, 0), "START HERE")
    
    vipConnection = RunService.Heartbeat:Connect(function(dt)
        if not vipBypassEnabled or not rootPart then return end
        
        if vipStage == 0 or vipStage == 1 then
            local dist = (rootPart.Position - VIP_CFRAME_1.Position).Magnitude
            if dist < 5 then
                vipTimer = vipTimer + dt
                vipStage = 1
                if vipTimer > 3 then
                    vipStage = 2
                    vipTimer = 0
                    if humanoid then rootPart.Size = Vector3.new(1, 1, 1) end
                    vipPart2 = createVipPart(VIP_CFRAME_2, Color3.fromRGB(255, 0, 0), "END GOAL")
                    startNoclip()
                    vipSpin = createSpin()
                    vipBodyVelocity = Instance.new("BodyVelocity")
                    vipBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    vipBodyVelocity.Parent = rootPart
                end
            else
                if vipStage == 1 then vipTimer = 0 vipStage = 0 end
            end
        elseif vipStage == 2 then
            if not vipBodyVelocity then return end
            local direction = (VIP_CFRAME_2.Position - rootPart.Position)
            vipBodyVelocity.Velocity = direction.Unit * VIP_SPEED
            
            if direction.Magnitude < 3 then
                vipStage = 3
                vipTimer = 0
                if vipBodyVelocity then vipBodyVelocity:Destroy() vipBodyVelocity = nil end
                vipBodyPosition = Instance.new("BodyPosition")
                vipBodyPosition.Position = VIP_CFRAME_2.Position
                vipBodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                vipBodyPosition.P = 10000
                vipBodyPosition.D = 100
                vipBodyPosition.Parent = rootPart
            end
        elseif vipStage == 3 then
             if vipBodyPosition then vipBodyPosition.Position = VIP_CFRAME_2.Position end
             vipTimer = vipTimer + dt
             vipStatus.Text = "LOCKING: " .. string.format("%.1f", 7 - vipTimer) .. "s"
             if vipTimer >= 7 then
                 vipBypassEnabled = false
                 cleanupVip()
                 updateGUI()
             end
        end
        if math.floor(tick()) % 1 == 0 and vipStage ~= 3 then updateGUI() end
    end)
    updateGUI()
end

local function toggleVipBypass()
    if vipBypassEnabled then
        vipBypassEnabled = false
        cleanupVip()
        updateGUI()
    else 
        startVipBypass() 
    end
end

-- --- AUTO DODGE SYSTEM ---
local function stopDodge()
    if dodgeConnection then dodgeConnection:Disconnect() dodgeConnection = nil end
    if dodgeBodyVelocity then dodgeBodyVelocity:Destroy() dodgeBodyVelocity = nil end
    dodgeEnabled = false
    updateGUI()
end

local function startDodge()
    stopDodge()
    dodgeEnabled = true
    updateGUI()
    
    dodgeConnection = RunService.Heartbeat:Connect(function()
        if not rootPart then return end
        local threatFound = false
        local threatDirection = nil
        
        if dodgePlayersEnabled then
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local enemyRoot = otherPlayer.Character.HumanoidRootPart
                    local dist = (enemyRoot.Position - rootPart.Position).Magnitude
                    if dist < DODGE_RANGE then
                        threatFound = true
                        threatDirection = (rootPart.Position - enemyRoot.Position).Unit
                        break 
                    end
                end
            end
        end
        
        if not threatFound and dodgeBulletsEnabled then
            local debris = Workspace:FindFirstChild("Debris")
            if debris then
                for _, folder in ipairs(debris:GetChildren()) do
                    if folder.Name == "ObjectCache" then
                        for _, obj in ipairs(folder:GetChildren()) do
                             if (obj.Name == "Ball" or obj.Name == "Triangle") and obj:IsA("BasePart") then
                                 local dist = (obj.Position - rootPart.Position).Magnitude
                                 if dist < DODGE_RANGE then
                                     threatFound = true
                                     threatDirection = (rootPart.Position - obj.Position).Unit
                                     break
                                 end
                             end
                        end
                    end
                    if threatFound then break end
                end
            end
        end
        
        if threatFound then
            if not dodgeBodyVelocity or dodgeBodyVelocity.Parent ~= rootPart then
                dodgeBodyVelocity = Instance.new("BodyVelocity")
                dodgeBodyVelocity.Name = "DodgeForce"
                dodgeBodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
                dodgeBodyVelocity.P = 5000 
                dodgeBodyVelocity.Parent = rootPart
            end
            local sideVector = threatDirection:Cross(Vector3.new(0, 1, 0)).Unit
            dodgeBodyVelocity.Velocity = sideVector * DODGE_FORCE_POWER
            statusValue.Text = "DODGING!"
            statusValue.TextColor3 = Color3.fromRGB(255, 60, 100)
        else
            if dodgeBodyVelocity then dodgeBodyVelocity:Destroy() dodgeBodyVelocity = nil end
            if isMoving then statusValue.Text = "ACTIVE" statusValue.TextColor3 = Color3.fromRGB(0, 200, 255)
            elseif not isMoving and dodgeEnabled then statusValue.Text = "WATCHING" statusValue.TextColor3 = Color3.fromRGB(200, 200, 255)
            end
        end
    end)
end

local function toggleDodge()
    if dodgeEnabled then stopDodge() else startDodge() end
end

-- --- MOVEMENT TARGETING & VISION ---
local function getLiveModels()
    local models = {}
    local liveFolder = Workspace:FindFirstChild("Live")
    if liveFolder then
        for _, model in ipairs(liveFolder:GetChildren()) do
            if model == character then continue end
            if model:IsA("Model") then
                local validRoot = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if validRoot then
                    table.insert(models, {Model = model, Root = validRoot})
                end
            end
        end
    end
    return models
end

local function findClosestModel()
    if not rootPart then return nil end
    local closestModel = nil
    local closestDistance = math.huge
    local currentPos = rootPart.Position

    for _, targetData in ipairs(getLiveModels()) do
        -- Skip temporarily blacklisted models (ignored for 15 seconds)
        if blacklistedTargets[targetData.Model] and (tick() - blacklistedTargets[targetData.Model] < 15) then
            continue
        end

        local targetPos = targetData.Root.Position
        local verticalDiff = math.abs(targetPos.Y - currentPos.Y)
        if verticalDiff <= MAX_VERTICAL_TRACK_DIST then
            local distance = (targetPos - currentPos).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestModel = targetData.Model
            end
        end
    end
    return closestModel
end

local function findClosestItem(folderName)
    if not rootPart then return nil end
    local itemFolder = Workspace:FindFirstChild(folderName)
    if not itemFolder then return nil end
    
    local closestItem = nil
    local closestDistance = math.huge
    local currentPos = rootPart.Position
    
    for _, item in ipairs(itemFolder:GetChildren()) do
        if item:IsA("Model") then
            -- Skip items that Pathfinding failed to reach (blacklisted for 15s)
            if blacklistedTargets[item] and (tick() - blacklistedTargets[item] < 15) then
                continue
            end

            local root = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
            if root then
                local dist = (root.Position - currentPos).Magnitude
                if dist < closestDistance then
                    closestDistance = dist
                    closestItem = item
                end
            end
        end
    end
    return closestItem
end

-- --- RAYCAST VISION SYSTEM ---
-- Checks if there is a clear, uninterrupted straight line to the target.
local function hasLineOfSight(pos1, pos2, ignoreInstances)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = ignoreInstances
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.IgnoreWater = true
    
    local direction = pos2 - pos1
    local raycastResult = Workspace:Raycast(pos1, direction, params)
    
    if raycastResult then
        -- We hit something! Check if it's a solid physical wall/object
        if raycastResult.Instance.CanCollide then
            return false -- Vision is blocked
        end
    end
    return true -- Clear path
end

-- --- UNIFIED BODYVELOCITY MOVEMENT ---

local function manualMove()
    if not rootPart then return end
    local mouseHit = mouse.Hit
    local targetPosition = Vector3.new(mouseHit.X, rootPart.Position.Y, mouseHit.Z)
    local direction = (targetPosition - rootPart.Position)

    if direction.Magnitude > 2 then
        local bv = getMovementBV()
        bv.Velocity = direction.Unit * moveSpeed
    else
        stopMovementBV()
    end
end

-- Returns: Status (0 = Moving, 1 = Reached/Find New, 2 = Unattainable), Path, Waypoints, Index
local function executePathfinding(targetModelRef, pathVar, waypointsVar, indexVar, targetReachedDist, onReachedCallback)
    if not rootPart then return 1, nil, {}, 1 end

    if not targetModelRef or not targetModelRef.Parent then
        stopMovementBV()
        return 1, nil, {}, 1 
    end

    local targetRoot = targetModelRef:FindFirstChild("HumanoidRootPart") or targetModelRef.PrimaryPart or targetModelRef:FindFirstChildWhichIsA("BasePart")
    if not targetRoot then
        stopMovementBV()
        return 1, nil, {}, 1
    end

    local targetPos = targetRoot.Position
    local distToTarget = (targetPos - rootPart.Position).Magnitude

    if distToTarget <= targetReachedDist then
        stopMovementBV()
        if onReachedCallback then onReachedCallback() end
        return 0, pathVar, waypointsVar, indexVar
    end

    local ignoreList = {character, targetModelRef}
    local canSeeTarget = hasLineOfSight(rootPart.Position, targetPos, ignoreList)

    -- If target is close AND we have clear vision (no walls blocking), walk straight
    if distToTarget < 20 and canSeeTarget then
        local direction = (Vector3.new(targetPos.X, rootPart.Position.Y, targetPos.Z) - rootPart.Position).Unit
        local bv = getMovementBV()
        bv.Velocity = direction * moveSpeed
        return 0, pathVar, waypointsVar, indexVar
    end

    -- Pathfinding Fallback: Required if target is far, or if vision is blocked by a wall
    if not pathVar or #waypointsVar == 0 or indexVar > #waypointsVar then
        local pathParams = { AgentCanJump = false, AgentRadius = 2, AgentHeight = 5 }
        local path = PathfindingService:CreatePath(pathParams)
        local success, _ = pcall(function() path:ComputeAsync(rootPart.Position, targetPos) end)
        
        if success and path.Status == Enum.PathStatus.Success then
            waypointsVar = path:GetWaypoints()
            indexVar = 2
            pathVar = path
        else
            -- Pathfinding failed OR Status is NoPath. This means the item is inside a wall/locked room.
            stopMovementBV()
            return 2, nil, {}, 1 -- Status 2 = Unattainable
        end
    end
    
    if pathVar and waypointsVar and indexVar <= #waypointsVar then
        local waypointPos = waypointsVar[indexVar].Position
        
        -- Double-check vision to the NEXT waypoint to ensure a door hasn't closed, etc.
        if not hasLineOfSight(rootPart.Position, waypointPos, ignoreList) then
            return 1, nil, {}, 1 -- Path obstructed mid-way, force recalculate next frame
        end
        
        local direction = (Vector3.new(waypointPos.X, rootPart.Position.Y, waypointPos.Z) - rootPart.Position).Unit
        
        local bv = getMovementBV()
        bv.Velocity = direction * moveSpeed
        
        local distToWaypoint = (Vector3.new(waypointPos.X, rootPart.Position.Y, waypointPos.Z) - rootPart.Position).Magnitude
        if distToWaypoint < 4 then
            indexVar = indexVar + 1
        end
    else
        pathVar = nil
    end

    return 0, pathVar, waypointsVar, indexVar
end

-- Tracker Implementations
local function autoTrackMove()
    local status, path, wp, idx = executePathfinding(
        targetModel, currentPath, waypoints, currentWaypointIndex, TARGET_REACH_DISTANCE,
        function()
            if not reachedTarget then reachedTarget = true timeAtTarget = 0 end
            timeAtTarget = timeAtTarget + RunService.Heartbeat:Wait()
            if timeAtTarget >= TARGET_STAY_TIME then
                targetModel = nil 
            end
        end
    )
    
    if status == 2 then 
        -- Target unreachable (inside wall/box). Blacklist for 15s.
        if targetModel then blacklistedTargets[targetModel] = tick() end
        targetModel = nil
    elseif status == 1 or not targetModel then
        targetModel = findClosestModel()
        reachedTarget = false
        timeAtTarget = 0
        currentPath = nil
        waypoints = {}
        currentWaypointIndex = 1
    else
        currentPath, waypoints, currentWaypointIndex = path, wp, idx
    end
end

local function foodFarmMove()
    local status, path, wp, idx = executePathfinding(
        currentFoodTarget, foodPath, foodWaypoints, foodWaypointIndex, 4,
        function() currentFoodTarget = nil end
    )
    
    if status == 2 then
        -- Food is unreachable/glitched inside a wall. Blacklist it for 15s and skip.
        if currentFoodTarget then blacklistedTargets[currentFoodTarget] = tick() end
        currentFoodTarget = nil
    elseif status == 1 or not currentFoodTarget then
        currentFoodTarget = findClosestItem("Food")
        foodPath = nil
        foodWaypoints = {}
        foodWaypointIndex = 1
    else
        foodPath, foodWaypoints, foodWaypointIndex = path, wp, idx
    end
end

-- --- ACTIVATORS ---
local function startMobileFly()
    if not rootPart then return end
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 10000
    bodyGyro.D = 1000
    bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
    bodyGyro.CFrame = Workspace.CurrentCamera.CFrame
    bodyGyro.Parent = rootPart
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000) * 10
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    mobileFlyConnection = RunService.Heartbeat:Connect(function()
        if not rootPart or not mobileFlyEnabled then stopMobileFly() return end
        if bodyGyro then bodyGyro.CFrame = Workspace.CurrentCamera.CFrame end
        local currentFlySpeed = moveSpeed * 0.84
        if bodyVelocity then bodyVelocity.Velocity = Workspace.CurrentCamera.CFrame.LookVector * currentFlySpeed end
    end)
end

function stopMobileFly()
    if mobileFlyConnection then mobileFlyConnection:Disconnect() mobileFlyConnection = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
end

local function toggleMobileFly()
    mobileFlyEnabled = not mobileFlyEnabled
    if mobileFlyEnabled then startMobileFly() else stopMobileFly() end
    updateGUI()
end

-- Control Loop Binders
local function createLoopBinder(toggleRef, moveFunc, stopFunc)
    local connection = nil
    return function(start)
        if connection then connection:Disconnect() connection = nil end
        if start then
            connection = RunService.Heartbeat:Connect(function()
                if toggleRef() and rootPart and rootPart.Parent then moveFunc()
                else 
                    if connection then connection:Disconnect() connection = nil end 
                    stopFunc() 
                end
            end)
        else
            stopFunc()
        end
    end
end

local bindAutoTrack = createLoopBinder(function() return autoTrackEnabled end, autoTrackMove, function() stopMovementBV() targetModel = nil end)
local bindFoodFarm = createLoopBinder(function() return foodFarmEnabled end, foodFarmMove, function() stopMovementBV() currentFoodTarget = nil end)

local function startMoving()
    if isMoving or not rootPart then return end
    isMoving = true
    updateGUI()
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not isMoving or not rootPart or not rootPart.Parent then 
            connection:Disconnect() 
            stopMovementBV()
            return 
        end
        manualMove()
    end)
end

local function stopMoving() 
    isMoving = false 
    stopMovementBV()
    updateGUI() 
end

if not isMobile then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == currentHotkey then startMoving() end
    end)
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if input.KeyCode == currentHotkey then stopMoving() end
    end)
end

-- GUI Interactivity
closeButton.MouseButton1Click:Connect(function() mainFrame.Visible = false openButton.Visible = true end)
openButton.MouseButton1Click:Connect(function() mainFrame.Visible = true openButton.Visible = false end)

speedInputBox.FocusLost:Connect(function()
    local num = tonumber(speedInputBox.Text)
    if num then moveSpeed = num speedInputBox.Text = tostring(num) else speedInputBox.Text = "" end
end)

local waitingForHotkey = false
hotkeyButton.MouseButton1Click:Connect(function()
    if isMobile or waitingForHotkey then return end
    waitingForHotkey = true
    hotkeyButton.Text = "..."
    hotkeyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            currentHotkey = input.KeyCode
            hotkeyButton.Text = input.KeyCode.Name
            hotkeyButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            waitingForHotkey = false
            connection:Disconnect()
        end
    end)
end)

trackButton.MouseButton1Click:Connect(function()
    autoTrackEnabled = not autoTrackEnabled
    bindAutoTrack(autoTrackEnabled)
    updateGUI()
end)

foodFarmButton.MouseButton1Click:Connect(function()
    foodFarmEnabled = not foodFarmEnabled
    bindFoodFarm(foodFarmEnabled)
    updateGUI()
end)

dodgePlayerButton.MouseButton1Click:Connect(function() dodgePlayersEnabled = not dodgePlayersEnabled updateGUI() end)
dodgeBulletButton.MouseButton1Click:Connect(function() dodgeBulletsEnabled = not dodgeBulletsEnabled updateGUI() end)

espButton.MouseButton1Click:Connect(toggleESP)
mobileButton.MouseButton1Click:Connect(toggleMobileFly)
vipButton.MouseButton1Click:Connect(toggleVipBypass)
dodgeButton.MouseButton1Click:Connect(toggleDodge)

local function setupCharacter(newCharacter)
    character = newCharacter
    local success = pcall(function()
        humanoid = character:WaitForChild("Humanoid")
        rootPart = character:WaitForChild("HumanoidRootPart")
    end)
    if not success then wait(0.5) humanoid = character:WaitForChild("Humanoid") rootPart = character:WaitForChild("HumanoidRootPart") end
    isMoving = false
    updateGUI()
    if autoTrackEnabled then bindAutoTrack(true) end
    if mobileFlyEnabled then startMobileFly() end
    if vipBypassEnabled then startVipBypass() end
    if dodgeEnabled then startDodge() end
    if foodFarmEnabled then bindFoodFarm(true) end
end

if player.Character then setupCharacter(player.Character) end
player.CharacterAdded:Connect(setupCharacter)

player.CharacterRemoving:Connect(function()
    isMoving = false
    bindAutoTrack(false)
    bindFoodFarm(false)
    stopMobileFly()
    if vipBypassEnabled then toggleVipBypass() end
    stopDodge()
    updateGUI()
end)

updateGUI()
print("Initialized: Vision Raycasting & Unreachable Food Blacklist Added.")
