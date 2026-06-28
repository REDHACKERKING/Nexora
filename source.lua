-- [[ COMPKILLER UI Engine - Core Source ]]
local LunaCore = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

function LunaCore:CreateWindow(configs)
    configs = configs or {}
    local Theme = {
        Color = configs.Color or Color3.fromRGB(0, 220, 255),
        TabColor = configs.TabColor or Color3.fromRGB(34, 49, 63),
        Background = configs.Background or Color3.fromRGB(19, 20, 24),
        CardColor = configs.CardColor or Color3.fromRGB(27, 28, 34),
        TextColor = configs.TextColor or Color3.fromRGB(240, 240, 245),
        CornerRadius = configs.CornerRadius or 6
    }

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LunaUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local oldUI = game:GetService("CoreGui"):FindFirstChild(ScreenGui.Name)
    if oldUI then oldUI:Destroy() end
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 560, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -280, 0.5, -200)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, Theme.CornerRadius)
    MainCorner.Parent = MainFrame

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 170, 1, 0)
    Sidebar.BackgroundColor3 = Theme.TabColor
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SideCorner = Instance.new("UICorner")
    SideCorner.CornerRadius = UDim.new(0, Theme.CornerRadius)
    SideCorner.Parent = Sidebar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -20, 0, 40)
    Title.Position = UDim2.new(0, 15, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Text = configs.Name or "UI Library"
    Title.TextColor3 = Theme.Color
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Sidebar

    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Name = "TabHolder"
    TabHolder.Size = UDim2.new(1, -10, 1, -120)
    TabHolder.Position = UDim2.new(0, 5, 0, 50)
    TabHolder.BackgroundTransparency = 1
    TabHolder.BorderSizePixel = 0
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.ScrollBarThickness = 0
    TabHolder.Parent = Sidebar

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Parent = TabHolder

    local ContentHolder = Instance.new("Frame")
    ContentHolder.Name = "ContentHolder"
    ContentHolder.Size = UDim2.new(1, -185, 1, -20)
    ContentHolder.Position = UDim2.new(0, 180, 0, 10)
    ContentHolder.BackgroundTransparency = 1
    ContentHolder.Parent = MainFrame

    local dragging, dragInput, dragStart, startPos
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == (configs.ToggleKey or Enum.KeyCode.RightControl) then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    local WindowMethods = {}
    local firstTab = true

    function WindowMethods:CreateTab(tabConfigs)
        tabConfigs = tabConfigs or {}
        local tabName = tabConfigs.Name or "Tab"

        local TabButton = Instance.new("TextButton")
        TabButton.Name = "TabButton"
        TabButton.Size = UDim2.new(1, -10, 0, 32)
        TabButton.BackgroundColor3 = Theme.CardColor
        TabButton.BackgroundTransparency = 1
        TabButton.Text = "  " .. tabName
        TabButton.TextColor3 = Color3.fromRGB(150, 155, 165)
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.TextSize = 15
        TabButton.TextXAlignment = Enum.TextXAlignment.Left
        TabButton.Parent = TabHolder

        local TabBtnCorner = Instance.new("UICorner")
        TabBtnCorner.CornerRadius = UDim.new(0, 4)
        TabBtnCorner.Parent = TabButton

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = "TabPage_" .. tabName
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.ScrollBarThickness = 2
        TabPage.ScrollBarImageColor3 = Theme.Color
        TabPage.Visible = false
        TabPage.Parent = ContentHolder

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 6)
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = TabPage

        PageLayout.Changed:Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 10)
        end)

        if firstTab then
            firstTab = false
            TabPage.Visible = true
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Theme.Color
        end

        TabButton.MouseButton1Click:Connect(function()
            for _, page in pairs(ContentHolder:GetChildren()) do
                if page:IsA("ScrollingFrame") then page.Visible = false end
            end
            for _, btn in pairs(TabHolder:GetChildren()) do
                if btn:IsA("TextButton") then 
                    btn.BackgroundTransparency = 1 
                    btn.TextColor3 = Color3.fromRGB(150, 155, 165)
                end
            end
            TabPage.Visible = true
            TabButton.BackgroundTransparency = 0
            TabButton.TextColor3 = Theme.Color
        end)

        local TabMethods = {}

        function TabMethods:CreateButton(btnConfigs)
            local btnName = btnConfigs.Name or "Button"
            local callback = btnConfigs.Callback or function() end

            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = "Button"
            ButtonFrame.Size = UDim2.new(1, -10, 0, 36)
            ButtonFrame.BackgroundColor3 = Theme.Color
            ButtonFrame.Font = Enum.Font.SourceSansBold
            ButtonFrame.Text = btnName
            ButtonFrame.TextColor3 = Color3.fromRGB(19, 20, 24)
            ButtonFrame.TextSize = 14
            ButtonFrame.Parent = TabPage

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 5)
            BtnCorner.Parent = ButtonFrame

            ButtonFrame.MouseButton1Click:Connect(function()
                pcall(callback)
            end)
        end

        function TabMethods:CreateToggle(toggleConfigs)
            local toggleName = toggleConfigs.Name or "Toggle"
            local toggled = toggleConfigs.CurrentValue or false
            local callback = toggleConfigs.Callback or function() end

            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = "ToggleFrame"
            ToggleFrame.Size = UDim2.new(1, -10, 0, 38)
            ToggleFrame.BackgroundColor3 = Theme.CardColor
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabPage

            local TglCorner = Instance.new("UICorner")
            TglCorner.CornerRadius = UDim.new(0, 5)
            TglCorner.Parent = ToggleFrame

            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleName
            ToggleLabel.TextColor3 = Theme.TextColor
            ToggleLabel.Font = Enum.Font.SourceSans
            ToggleLabel.TextSize = 14
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame

            local Switch = Instance.new("TextButton")
            Switch.Name = "Switch"
            Switch.Size = UDim2.new(0, 34, 0, 18)
            Switch.Position = UDim2.new(1, -46, 0.5, -9)
            Switch.BackgroundColor3 = toggled and Theme.Color or Color3.fromRGB(50, 55, 65)
            Switch.Text = ""
            Switch.Parent = ToggleFrame

            local SwCorner = Instance.new("UICorner")
            SwCorner.CornerRadius = UDim.new(1, 0)
            SwCorner.Parent = Switch

            local Dot = Instance.new("Frame")
            Dot.Size = UDim2.new(0, 14, 0, 14)
            Dot.Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Dot.Parent = Switch

            local DotCorner = Instance.new("UICorner")
            DotCorner.CornerRadius = UDim.new(1, 0)
            DotCorner.Parent = Dot

            Switch.MouseButton1Click:Connect(function()
                toggled = not toggled
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Theme.Color or Color3.fromRGB(50, 55, 65)}):Play()
                TweenService:Create(Dot, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                pcall(callback, toggled)
            end)
        end

        function TabMethods:CreateSlider(sliderConfigs)
            local sliderName = sliderConfigs.Name or "Slider"
            local min = sliderConfigs.Range[1] or 0
            local max = sliderConfigs.Range[2] or 100
            local current = sliderConfigs.CurrentValue or min
            local callback = sliderConfigs.Callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = "SliderFrame"
            SliderFrame.Size = UDim2.new(1, -10, 0, 45)
            SliderFrame.BackgroundColor3 = Theme.CardColor
            SliderFrame.Parent = TabPage

            local SldCorner = Instance.new("UICorner")
            SldCorner.CornerRadius = UDim.new(0, 5)
            SldCorner.Parent = SliderFrame

            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -80, 0, 22)
            SliderLabel.Position = UDim2.new(0, 12, 0, 2)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderName
            SliderLabel.TextColor3 = Theme.TextColor
            SliderLabel.Font = Enum.Font.SourceSans
            SliderLabel.TextSize = 14
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0, 60, 0, 22)
            ValueLabel.Position = UDim2.new(1, -72, 0, 2)
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Text = tostring(current)
            ValueLabel.TextColor3 = Theme.Color
            ValueLabel.Font = Enum.Font.SourceSansBold
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame

            local SlideBar = Instance.new("TextButton")
            SlideBar.Name = "SlideBar"
            SlideBar.Size = UDim2.new(1, -24, 0, 5)
            SlideBar.Position = UDim2.new(0, 12, 0, 28)
            SlideBar.BackgroundColor3 = Color3.fromRGB(45, 48, 55)
            SlideBar.Text = ""
            SlideBar.Parent = SlideBar.Parent

            local Fill = Instance.new("Frame")
            Fill.Name = "Fill"
            Fill.Size = UDim2.new((current - min)/(max - min), 0, 1, 0)
            Fill.BackgroundColor3 = Theme.Color
            Fill.BorderSizePixel = 0
            Fill.Parent = SlideBar
            SlideBar.Parent = SliderFrame

            local function updateSlider(input)
                local percent = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * percent)
                ValueLabel.Text = tostring(value)
                Fill.Size = UDim2.new(percent, 0, 1, 0)
                pcall(callback, value)
            end

            local sliding = false
            SlideBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = true
                    updateSlider(input)
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)
        end

        return TabMethods
    end

    function WindowMethods:Destroy()
        ScreenGui:Destroy()
    end

    return WindowMethods
end

return LunaCore
