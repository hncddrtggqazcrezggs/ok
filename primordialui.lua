--[[
    Primordial UI Library
    Modern, sleek design with smooth animations
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Library = {}

-- Theme
local Theme = {
    Background = Color3.fromRGB(18, 18, 24),
    Secondary = Color3.fromRGB(24, 24, 32),
    Tertiary = Color3.fromRGB(30, 30, 40),
    Primary = Color3.fromRGB(138, 43, 226),
    PrimaryDark = Color3.fromRGB(118, 33, 206),
    PrimaryLight = Color3.fromRGB(158, 63, 246),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 160),
    Success = Color3.fromRGB(46, 213, 115),
    Danger = Color3.fromRGB(255, 71, 87),
    Warning = Color3.fromRGB(255, 184, 0),
    Border = Color3.fromRGB(40, 40, 52)
}

-- Utilities
local function Tween(obj, props, duration, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    TweenService:Create(obj, TweenInfo.new(duration or 0.2, style, direction), props):Play()
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = radius or UDim.new(0, 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Border
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function MakeDraggable(frame, dragFrame)
    dragFrame = dragFrame or frame
    local dragging, dragInput, dragStart, startPos
    
    dragFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            Tween(frame, {
                Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Create Window
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Primordial"
    local windowSize = config.Size or UDim2.new(0, 550, 0, 600)
    
    local player = Players.LocalPlayer
    
    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "PrimordialUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    
    if not ScreenGui.Parent then
        ScreenGui.Parent = player:WaitForChild("PlayerGui")
    end
    
    -- Main Container
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = windowSize
    Main.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui
    
    CreateCorner(Main, UDim.new(0, 12))
    CreateStroke(Main, Theme.Border, 1)
    
    -- Add shadow effect
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://5554236805"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.7
    Shadow.ZIndex = -1
    Shadow.Parent = Main
    
    -- Animated gradient background
    local Gradient = Instance.new("Frame")
    Gradient.Name = "Gradient"
    Gradient.Size = UDim2.new(1, 0, 0, 3)
    Gradient.BackgroundColor3 = Theme.Primary
    Gradient.BorderSizePixel = 0
    Gradient.Parent = Main
    
    local GradientEffect = Instance.new("UIGradient")
    GradientEffect.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Primary),
        ColorSequenceKeypoint.new(0.5, Theme.PrimaryLight),
        ColorSequenceKeypoint.new(1, Theme.Primary)
    }
    GradientEffect.Parent = Gradient
    
    -- Animate gradient
    spawn(function()
        while wait() do
            Tween(GradientEffect, {Offset = Vector2.new(1, 0)}, 2, Enum.EasingStyle.Linear)
            wait(2)
            GradientEffect.Offset = Vector2.new(-1, 0)
        end
    end)
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.Position = UDim2.new(0, 0, 0, 3)
    Header.BackgroundTransparency = 1
    Header.Parent = Main
    
    MakeDraggable(Main, Header)
    
    -- Logo/Icon
    local Icon = Instance.new("Frame")
    Icon.Size = UDim2.new(0, 35, 0, 35)
    Icon.Position = UDim2.new(0, 15, 0.5, -17)
    Icon.BackgroundColor3 = Theme.Primary
    Icon.BorderSizePixel = 0
    Icon.Parent = Header
    
    CreateCorner(Icon, UDim.new(0, 8))
    
    local IconGradient = Instance.new("UIGradient")
    IconGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Primary),
        ColorSequenceKeypoint.new(1, Theme.PrimaryLight)
    }
    IconGradient.Rotation = 45
    IconGradient.Parent = Icon
    
    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 60, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = windowName
    Title.TextColor3 = Theme.Text
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 35, 0, 35)
    CloseBtn.Position = UDim2.new(1, -50, 0.5, -17)
    CloseBtn.BackgroundColor3 = Theme.Tertiary
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Text = "×"
    CloseBtn.TextColor3 = Theme.Text
    CloseBtn.TextSize = 24
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = Header
    
    CreateCorner(CloseBtn, UDim.new(0, 8))
    
    CloseBtn.MouseButton1Click:Connect(function()
        Tween(Main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    CloseBtn.MouseEnter:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.Danger}, 0.2)
    end)
    
    CloseBtn.MouseLeave:Connect(function()
        Tween(CloseBtn, {BackgroundColor3 = Theme.Tertiary}, 0.2)
    end)
    
    -- Navigation Bar
    local NavBar = Instance.new("Frame")
    NavBar.Name = "NavBar"
    NavBar.Size = UDim2.new(0, 60, 1, -53)
    NavBar.Position = UDim2.new(0, 0, 0, 53)
    NavBar.BackgroundColor3 = Theme.Secondary
    NavBar.BorderSizePixel = 0
    NavBar.Parent = Main
    
    local NavList = Instance.new("UIListLayout")
    NavList.Padding = UDim.new(0, 8)
    NavList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    NavList.Parent = NavBar
    
    local NavPadding = Instance.new("UIPadding")
    NavPadding.PaddingTop = UDim.new(0, 10)
    NavPadding.Parent = NavBar
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "Content"
    ContentContainer.Size = UDim2.new(1, -70, 1, -63)
    ContentContainer.Position = UDim2.new(0, 65, 0, 58)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Main
    
    local Window = {Tabs = {}, CurrentTab = nil}
    
    -- Create Tab
    function Window:CreateTab(config)
        config = config or {}
        local tabName = config.Name or "Tab"
        local tabIcon = config.Icon or "rbxassetid://7733960981"
        
        local Tab = {Name = tabName}
        
        -- Nav Button
        local NavButton = Instance.new("TextButton")
        NavButton.Name = tabName
        NavButton.Size = UDim2.new(0, 45, 0, 45)
        NavButton.BackgroundColor3 = Theme.Tertiary
        NavButton.BorderSizePixel = 0
        NavButton.AutoButtonColor = false
        NavButton.Text = ""
        NavButton.Parent = NavBar
        
        CreateCorner(NavButton, UDim.new(0, 10))
        
        local NavIcon = Instance.new("ImageLabel")
        NavIcon.Size = UDim2.new(0, 24, 0, 24)
        NavIcon.Position = UDim2.new(0.5, -12, 0.5, -12)
        NavIcon.BackgroundTransparency = 1
        NavIcon.Image = tabIcon
        NavIcon.ImageColor3 = Theme.TextDark
        NavIcon.Parent = NavButton
        
        local NavIndicator = Instance.new("Frame")
        NavIndicator.Size = UDim2.new(0, 3, 0, 0)
        NavIndicator.Position = UDim2.new(0, -8, 0.5, 0)
        NavIndicator.AnchorPoint = Vector2.new(0, 0.5)
        NavIndicator.BackgroundColor3 = Theme.Primary
        NavIndicator.BorderSizePixel = 0
        NavIndicator.Parent = NavButton
        
        CreateCorner(NavIndicator, UDim.new(1, 0))
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Theme.Primary
        TabContent.Visible = false
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 12)
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 5)
        ContentPadding.PaddingRight = UDim.new(0, 5)
        ContentPadding.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        -- Tab Button Click
        NavButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                Tween(tab.Icon, {ImageColor3 = Theme.TextDark}, 0.2)
                Tween(tab.Indicator, {Size = UDim2.new(0, 3, 0, 0)}, 0.2)
                tab.Content.Visible = false
            end
            
            Tween(NavButton, {BackgroundColor3 = Theme.Primary}, 0.2)
            Tween(NavIcon, {ImageColor3 = Theme.Text}, 0.2)
            Tween(NavIndicator, {Size = UDim2.new(0, 3, 0, 30)}, 0.2)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end)
        
        NavButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(NavButton, {BackgroundColor3 = Theme.Border}, 0.2)
            end
        end)
        
        NavButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(NavButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
            end
        end)
        
        Tab.Button = NavButton
        Tab.Icon = NavIcon
        Tab.Indicator = NavIndicator
        Tab.Content = TabContent
        
        table.insert(Window.Tabs, Tab)
        
        -- Section
        function Tab:CreateSection(sectionName)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = sectionName
            SectionFrame.Size = UDim2.new(1, 0, 0, 0)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.Parent = TabContent
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, 0, 0, 30)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = sectionName
            SectionLabel.TextColor3 = Theme.Text
            SectionLabel.TextSize = 16
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = SectionFrame
            
            local SectionList = Instance.new("UIListLayout")
            SectionList.Padding = UDim.new(0, 8)
            SectionList.Parent = SectionFrame
            
            SectionList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(1, 0, 0, SectionList.AbsoluteContentSize.Y)
            end)
            
            local Section = {Frame = SectionFrame, List = SectionList}
            
            -- Toggle
            function Section:CreateToggle(config)
                config = config or {}
                local name = config.Name or "Toggle"
                local default = config.Default or false
                local callback = config.Callback or function() end
                
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
                ToggleFrame.BackgroundColor3 = Theme.Secondary
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Parent = SectionFrame
                
                CreateCorner(ToggleFrame, UDim.new(0, 8))
                
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
                ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Text = name
                ToggleLabel.TextColor3 = Theme.Text
                ToggleLabel.TextSize = 14
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame
                
                local ToggleSwitch = Instance.new("Frame")
                ToggleSwitch.Size = UDim2.new(0, 45, 0, 24)
                ToggleSwitch.Position = UDim2.new(1, -60, 0.5, -12)
                ToggleSwitch.BackgroundColor3 = default and Theme.Success or Theme.Border
                ToggleSwitch.BorderSizePixel = 0
                ToggleSwitch.Parent = ToggleFrame
                
                CreateCorner(ToggleSwitch, UDim.new(1, 0))
                
                local ToggleCircle = Instance.new("Frame")
                ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
                ToggleCircle.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                ToggleCircle.BackgroundColor3 = Theme.Text
                ToggleCircle.BorderSizePixel = 0
                ToggleCircle.Parent = ToggleSwitch
                
                CreateCorner(ToggleCircle, UDim.new(1, 0))
                
                local toggled = default
                
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.Size = UDim2.new(1, 0, 1, 0)
                ToggleButton.BackgroundTransparency = 1
                ToggleButton.Text = ""
                ToggleButton.Parent = ToggleFrame
                
                ToggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    Tween(ToggleSwitch, {BackgroundColor3 = toggled and Theme.Success or Theme.Border}, 0.2)
                    Tween(ToggleCircle, {
                        Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                    }, 0.2, Enum.EasingStyle.Back)
                    callback(toggled)
                end)
                
                ToggleFrame.MouseEnter:Connect(function()
                    Tween(ToggleFrame, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                end)
                
                ToggleFrame.MouseLeave:Connect(function()
                    Tween(ToggleFrame, {BackgroundColor3 = Theme.Secondary}, 0.2)
                end)
                
                return ToggleFrame
            end
            
            -- Button
            function Section:CreateButton(config)
                config = config or {}
                local name = config.Name or "Button"
                local callback = config.Callback or function() end
                
                local ButtonFrame = Instance.new("TextButton")
                ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
                ButtonFrame.BackgroundColor3 = Theme.Primary
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.AutoButtonColor = false
                ButtonFrame.Text = ""
                ButtonFrame.Parent = SectionFrame
                
                CreateCorner(ButtonFrame, UDim.new(0, 8))
                
                local ButtonGradient = Instance.new("UIGradient")
                ButtonGradient.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Theme.Primary),
                    ColorSequenceKeypoint.new(1, Theme.PrimaryDark)
                }
                ButtonGradient.Rotation = 90
                ButtonGradient.Parent = ButtonFrame
                
                local ButtonLabel = Instance.new("TextLabel")
                ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
                ButtonLabel.BackgroundTransparency = 1
                ButtonLabel.Text = name
                ButtonLabel.TextColor3 = Theme.Text
                ButtonLabel.TextSize = 14
                ButtonLabel.Font = Enum.Font.GothamBold
                ButtonLabel.Parent = ButtonFrame
                
                ButtonFrame.MouseButton1Click:Connect(function()
                    Tween(ButtonFrame, {Size = UDim2.new(1, -4, 0, 38)}, 0.1)
                    wait(0.1)
                    Tween(ButtonFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.1)
                    callback()
                end)
                
                ButtonFrame.MouseEnter:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Theme.PrimaryLight}, 0.2)
                end)
                
                ButtonFrame.MouseLeave:Connect(function()
                    Tween(ButtonFrame, {BackgroundColor3 = Theme.Primary}, 0.2)
                end)
                
                return ButtonFrame
            end
            
            -- Slider
            function Section:CreateSlider(config)
                config = config or {}
                local name = config.Name or "Slider"
                local min = config.Min or 0
                local max = config.Max or 100
                local default = config.Default or min
                local callback = config.Callback or function() end
                
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Size = UDim2.new(1, 0, 0, 55)
                SliderFrame.BackgroundColor3 = Theme.Secondary
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Parent = SectionFrame
                
                CreateCorner(SliderFrame, UDim.new(0, 8))
                
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Size = UDim2.new(1, -80, 0, 20)
                SliderLabel.Position = UDim2.new(0, 15, 0, 10)
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Text = name
                SliderLabel.TextColor3 = Theme.Text
                SliderLabel.TextSize = 14
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame
                
                local SliderValue = Instance.new("TextLabel")
                SliderValue.Size = UDim2.new(0, 60, 0, 20)
                SliderValue.Position = UDim2.new(1, -75, 0, 10)
                SliderValue.BackgroundTransparency = 1
                SliderValue.Text = tostring(default)
                SliderValue.TextColor3 = Theme.Primary
                SliderValue.TextSize = 14
                SliderValue.Font = Enum.Font.GothamBold
                SliderValue.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue.Parent = SliderFrame
                
                local SliderBar = Instance.new("Frame")
                SliderBar.Size = UDim2.new(1, -30, 0, 6)
                SliderBar.Position = UDim2.new(0, 15, 1, -20)
                SliderBar.BackgroundColor3 = Theme.Tertiary
                SliderBar.BorderSizePixel = 0
                SliderBar.Parent = SliderFrame
                
                CreateCorner(SliderBar, UDim.new(1, 0))
                
                local SliderFill = Instance.new("Frame")
                SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                SliderFill.BackgroundColor3 = Theme.Primary
                SliderFill.BorderSizePixel = 0
                SliderFill.Parent = SliderBar
                
                CreateCorner(SliderFill, UDim.new(1, 0))
                
                local SliderButton = Instance.new("Frame")
                SliderButton.Size = UDim2.new(0, 14, 0, 14)
                SliderButton.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
                SliderButton.BackgroundColor3 = Theme.Text
                SliderButton.BorderSizePixel = 0
                SliderButton.Parent = SliderBar
                
                CreateCorner(SliderButton, UDim.new(1, 0))
                CreateStroke(SliderButton, Theme.Primary, 2)
                
                local dragging = false
                
                SliderBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        Tween(SliderButton, {Size = UDim2.new(0, 18, 0, 18)}, 0.1)
                    end
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                        Tween(SliderButton, {Size = UDim2.new(0, 14, 0, 14)}, 0.1)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                        local value = math.floor(min + (max - min) * pos)
                        
                        Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
                        Tween(SliderButton, {Position = UDim2.new(pos, -7, 0.5, -7)}, 0.1)
                        SliderValue.Text = tostring(value)
                        callback(value)
                    end
                end)
                
                SliderFrame.MouseEnter:Connect(function()
                    Tween(SliderFrame, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                end)
                
                SliderFrame.MouseLeave:Connect(function()
                    Tween(SliderFrame, {BackgroundColor3 = Theme.Secondary}, 0.2)
                end)
                
                return SliderFrame
            end
            
            -- Dropdown
            function Section:CreateDropdown(config)
                config = config or {}
                local name = config.Name or "Dropdown"
                local options = config.Options or {"Option 1", "Option 2", "Option 3"}
                local default = config.Default or options[1]
                local callback = config.Callback or function() end
                
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
                DropdownFrame.BackgroundColor3 = Theme.Secondary
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.ClipsDescendants = true
                DropdownFrame.Parent = SectionFrame
                
                CreateCorner(DropdownFrame, UDim.new(0, 8))
                
                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Size = UDim2.new(1, -40, 0, 40)
                DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Text = name .. ": " .. default
                DropdownLabel.TextColor3 = Theme.Text
                DropdownLabel.TextSize = 14
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame
                
                local DropdownArrow = Instance.new("TextLabel")
                DropdownArrow.Size = UDim2.new(0, 30, 0, 40)
                DropdownArrow.Position = UDim2.new(1, -40, 0, 0)
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Text = "▼"
                DropdownArrow.TextColor3 = Theme.TextDark
                DropdownArrow.TextSize = 12
                DropdownArrow.Font = Enum.Font.Gotham
                DropdownArrow.Parent = DropdownFrame
                
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Size = UDim2.new(1, 0, 0, 40)
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Text = ""
                DropdownButton.ZIndex = 2
                DropdownButton.Parent = DropdownFrame
                
                local OptionsList = Instance.new("Frame")
                OptionsList.Size = UDim2.new(1, 0, 0, 0)
                OptionsList.Position = UDim2.new(0, 0, 0, 40)
                OptionsList.BackgroundTransparency = 1
                OptionsList.Parent = DropdownFrame
                
                local OptionsLayout = Instance.new("UIListLayout")
                OptionsLayout.Padding = UDim.new(0, 2)
                OptionsLayout.Parent = OptionsList
                
                local isOpen = false
                local currentValue = default
                
                for i, option in ipairs(options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Size = UDim2.new(1, 0, 0, 35)
                    OptionButton.BackgroundColor3 = Theme.Tertiary
                    OptionButton.BorderSizePixel = 0
                    OptionButton.AutoButtonColor = false
                    OptionButton.Text = option
                    OptionButton.TextColor3 = Theme.Text
                    OptionButton.TextSize = 13
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Parent = OptionsList
                    
                    if i == #options then
                        CreateCorner(OptionButton, UDim.new(0, 8))
                    end
                    
                    OptionButton.MouseButton1Click:Connect(function()
                        currentValue = option
                        DropdownLabel.Text = name .. ": " .. option
                        isOpen = false
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 0}, 0.2)
                        callback(option)
                    end)
                    
                    OptionButton.MouseEnter:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = Theme.Primary}, 0.2)
                    end)
                    
                    OptionButton.MouseLeave:Connect(function()
                        Tween(OptionButton, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                    end)
                end
                
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        local newSize = 40 + (#options * 37)
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, newSize)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 180}, 0.2)
                    else
                        Tween(DropdownFrame, {Size = UDim2.new(1, 0, 0, 40)}, 0.2)
                        Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    end
                end)
                
                DropdownFrame.MouseEnter:Connect(function()
                    if not isOpen then
                        Tween(DropdownFrame, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                    end
                end)
                
                DropdownFrame.MouseLeave:Connect(function()
                    if not isOpen then
                        Tween(DropdownFrame, {BackgroundColor3 = Theme.Secondary}, 0.2)
                    end
                end)
                
                return DropdownFrame
            end
            
            -- Input
            function Section:CreateInput(config)
                config = config or {}
                local name = config.Name or "Input"
                local placeholder = config.Placeholder or "Enter text..."
                local callback = config.Callback or function() end
                
                local InputFrame = Instance.new("Frame")
                InputFrame.Size = UDim2.new(1, 0, 0, 65)
                InputFrame.BackgroundColor3 = Theme.Secondary
                InputFrame.BorderSizePixel = 0
                InputFrame.Parent = SectionFrame
                
                CreateCorner(InputFrame, UDim.new(0, 8))
                
                local InputLabel = Instance.new("TextLabel")
                InputLabel.Size = UDim2.new(1, -30, 0, 20)
                InputLabel.Position = UDim2.new(0, 15, 0, 10)
                InputLabel.BackgroundTransparency = 1
                InputLabel.Text = name
                InputLabel.TextColor3 = Theme.Text
                InputLabel.TextSize = 14
                InputLabel.Font = Enum.Font.Gotham
                InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                InputLabel.Parent = InputFrame
                
                local TextBox = Instance.new("TextBox")
                TextBox.Size = UDim2.new(1, -30, 0, 30)
                TextBox.Position = UDim2.new(0, 15, 0, 30)
                TextBox.BackgroundColor3 = Theme.Tertiary
                TextBox.BorderSizePixel = 0
                TextBox.PlaceholderText = placeholder
                TextBox.PlaceholderColor3 = Theme.TextDark
                TextBox.Text = ""
                TextBox.TextColor3 = Theme.Text
                TextBox.TextSize = 13
                TextBox.Font = Enum.Font.Gotham
                TextBox.TextXAlignment = Enum.TextXAlignment.Left
                TextBox.ClearTextOnFocus = false
                TextBox.Parent = InputFrame
                
                CreateCorner(TextBox, UDim.new(0, 6))
                CreateStroke(TextBox, Theme.Border, 1)
                
                local BoxPadding = Instance.new("UIPadding")
                BoxPadding.PaddingLeft = UDim.new(0, 10)
                BoxPadding.PaddingRight = UDim.new(0, 10)
                BoxPadding.Parent = TextBox
                
                TextBox.Focused:Connect(function()
                    Tween(TextBox:FindFirstChildOfClass("UIStroke"), {Color = Theme.Primary}, 0.2)
                end)
                
                TextBox.FocusLost:Connect(function(enterPressed)
                    Tween(TextBox:FindFirstChildOfClass("UIStroke"), {Color = Theme.Border}, 0.2)
                    if enterPressed then
                        callback(TextBox.Text)
                    end
                end)
                
                InputFrame.MouseEnter:Connect(function()
                    Tween(InputFrame, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                end)
                
                InputFrame.MouseLeave:Connect(function()
                    Tween(InputFrame, {BackgroundColor3 = Theme.Secondary}, 0.2)
                end)
                
                return InputFrame
            end
            
            -- ColorPicker
            function Section:CreateColorPicker(config)
                config = config or {}
                local name = config.Name or "Color"
                local default = config.Default or Color3.fromRGB(138, 43, 226)
                local callback = config.Callback or function() end
                
                local ColorFrame = Instance.new("Frame")
                ColorFrame.Size = UDim2.new(1, 0, 0, 40)
                ColorFrame.BackgroundColor3 = Theme.Secondary
                ColorFrame.BorderSizePixel = 0
                ColorFrame.Parent = SectionFrame
                
                CreateCorner(ColorFrame, UDim.new(0, 8))
                
                local ColorLabel = Instance.new("TextLabel")
                ColorLabel.Size = UDim2.new(1, -90, 1, 0)
                ColorLabel.Position = UDim2.new(0, 15, 0, 0)
                ColorLabel.BackgroundTransparency = 1
                ColorLabel.Text = name
                ColorLabel.TextColor3 = Theme.Text
                ColorLabel.TextSize = 14
                ColorLabel.Font = Enum.Font.Gotham
                ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
                ColorLabel.Parent = ColorFrame
                
                local ColorPreview = Instance.new("Frame")
                ColorPreview.Size = UDim2.new(0, 70, 0, 26)
                ColorPreview.Position = UDim2.new(1, -85, 0.5, -13)
                ColorPreview.BackgroundColor3 = default
                ColorPreview.BorderSizePixel = 0
                ColorPreview.Parent = ColorFrame
                
                CreateCorner(ColorPreview, UDim.new(0, 6))
                CreateStroke(ColorPreview, Theme.Border, 2)
                
                local ColorButton = Instance.new("TextButton")
                ColorButton.Size = UDim2.new(1, 0, 1, 0)
                ColorButton.BackgroundTransparency = 1
                ColorButton.Text = ""
                ColorButton.Parent = ColorPreview
                
                -- Simple color picker (cycles through colors)
                local colors = {
                    Color3.fromRGB(138, 43, 226),
                    Color3.fromRGB(255, 71, 87),
                    Color3.fromRGB(46, 213, 115),
                    Color3.fromRGB(255, 184, 0),
                    Color3.fromRGB(0, 184, 255),
                    Color3.fromRGB(255, 121, 198),
                    Color3.fromRGB(255, 255, 255),
                    Color3.fromRGB(0, 0, 0)
                }
                local currentIndex = 1
                
                ColorButton.MouseButton1Click:Connect(function()
                    currentIndex = (currentIndex % #colors) + 1
                    local newColor = colors[currentIndex]
                    Tween(ColorPreview, {BackgroundColor3 = newColor}, 0.2)
                    callback(newColor)
                end)
                
                ColorFrame.MouseEnter:Connect(function()
                    Tween(ColorFrame, {BackgroundColor3 = Theme.Tertiary}, 0.2)
                    Tween(ColorPreview, {Size = UDim2.new(0, 75, 0, 28)}, 0.2)
                end)
                
                ColorFrame.MouseLeave:Connect(function()
                    Tween(ColorFrame, {BackgroundColor3 = Theme.Secondary}, 0.2)
                    Tween(ColorPreview, {Size = UDim2.new(0, 70, 0, 26)}, 0.2)
                end)
                
                return ColorFrame
            end
            
            -- Label
            function Section:CreateLabel(text)
                local LabelFrame = Instance.new("Frame")
                LabelFrame.Size = UDim2.new(1, 0, 0, 30)
                LabelFrame.BackgroundTransparency = 1
                LabelFrame.Parent = SectionFrame
                
                local Label = Instance.new("TextLabel")
                Label.Size = UDim2.new(1, 0, 1, 0)
                Label.BackgroundTransparency = 1
                Label.Text = text
                Label.TextColor3 = Theme.TextDark
                Label.TextSize = 13
                Label.Font = Enum.Font.Gotham
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.TextWrapped = true
                Label.Parent = LabelFrame
                
                return LabelFrame
            end
            
            return Section
        end
        
        -- First tab auto-select
        if #Window.Tabs == 0 then
            Tween(NavButton, {BackgroundColor3 = Theme.Primary}, 0.2)
            Tween(NavIcon, {ImageColor3 = Theme.Text}, 0.2)
            Tween(NavIndicator, {Size = UDim2.new(0, 3, 0, 30)}, 0.2)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end
        
        return Tab
    end
    
    -- Animate window entrance
    Main.Size = UDim2.new(0, 0, 0, 0)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Tween(Main, {
        Size = windowSize,
        Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    return Window
end

return Library