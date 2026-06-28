-- [[ Luna Interface Suite - Premium Override with Profile Display ]]
local success, result = pcall(function()
    -- 🔗 ดึงจากไฟล์ source.lua ท้องถิ่นโดยตรงเพื่อความถูกต้อง
    local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/source.lua"))()
    
    local CustomLuna = {}
    for k, v in pairs(Luna) do
        CustomLuna[k] = v
    end

    local originalCreateWindow = Luna.CreateWindow
    CustomLuna.CreateWindow = function(self, options)
        options = options or {}
        options.Name = "COMPKILLER"
        options.Subtitle = "NEVER"
        
        options.Color = Color3.fromRGB(0, 220, 255)         
        options.TabColor = Color3.fromRGB(34, 49, 63)       
        options.Background = Color3.fromRGB(19, 20, 24)     
        options.CardColor = Color3.fromRGB(27, 28, 34)      
        options.TextColor = Color3.fromRGB(240, 240, 245)    
        options.CornerRadius = 6
        
        local windowObj = originalCreateWindow(self, options)
        
        local CoreGui = game:GetService("CoreGui")
        local ScreenGui = CoreGui:FindFirstChild("LunaUI") or CoreGui:FindFirstChild("Luna")
        
        if ScreenGui then
            task.spawn(function()
                task.wait(0.2)
                
                local Sidebar = nil
                local MainFrame = ScreenGui:FindFirstChild("MainFrame")
                if MainFrame then
                    Sidebar = MainFrame:FindFirstChild("Sidebar")
                end

                if Sidebar then
                    local LocalPlayer = game:GetService("Players").LocalPlayer
                    
                    local ProfileFrame = Instance.new("Frame")
                    ProfileFrame.Name = "ProfileContainer"
                    ProfileFrame.Size = UDim2.new(1, -20, 0, 50)
                    ProfileFrame.Position = UDim2.new(0, 10, 1, -60) 
                    ProfileFrame.BackgroundTransparency = 1 
                    ProfileFrame.ZIndex = 100
                    ProfileFrame.Parent = Sidebar

                    local ProfileImage = Instance.new("ImageLabel")
                    ProfileImage.Name = "ProfileAvatar"
                    ProfileImage.Size = UDim2.new(0, 40, 0, 40)
                    ProfileImage.Position = UDim2.new(0, 5, 0.5, -20)
                    ProfileImage.BackgroundColor3 = Color3.fromRGB(27, 28, 34)
                    local userId = LocalPlayer.UserId
                    ProfileImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=420&height=420&format=png"
                    ProfileImage.ZIndex = 101
                    ProfileImage.Parent = ProfileFrame

                    local ImageCorner = Instance.new("UICorner")
                    ImageCorner.CornerRadius = UDim.new(0, 6)
                    ImageCorner.Parent = ProfileImage

                    local NameLabel = Instance.new("TextLabel")
                    NameLabel.Name = "ProfileName"
                    NameLabel.Size = UDim2.new(1, -55, 0, 20)
                    NameLabel.Position = UDim2.new(0, 52, 0, 3)
                    NameLabel.BackgroundTransparency = 1
                    NameLabel.Text = LocalPlayer.DisplayName 
                    NameLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
                    NameLabel.Font = Enum.Font.SourceSansBold
                    NameLabel.TextSize = 14
                    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                    NameLabel.ZIndex = 101
                    NameLabel.Parent = ProfileFrame

                    local RankLabel = Instance.new("TextLabel")
                    RankLabel.Name = "ProfileRank"
                    RankLabel.Size = UDim2.new(1, -55, 0, 18)
                    RankLabel.Position = UDim2.new(0, 52, 0, 20)
                    RankLabel.BackgroundTransparency = 1
                    RankLabel.Text = "NEVER" 
                    RankLabel.TextColor3 = Color3.fromRGB(140, 145, 155) 
                    RankLabel.Font = Enum.Font.SourceSans
                    RankLabel.TextSize = 12
                    RankLabel.TextXAlignment = Enum.TextXAlignment.Left
                    RankLabel.ZIndex = 101
                    RankLabel.Parent = ProfileFrame
                end
            end)
        end
        
        return windowObj
    end

    return CustomLuna
end)

if success then
    return result
else
    return nil
end                    
                    -- สร้างกล่องขอบเขตโปรไฟล์ (Profile Container Frame)
                    local ProfileFrame = Instance.new("Frame")
                    ProfileFrame.Name = "ProfileContainer"
                    ProfileFrame.Size = UDim2.new(0, 160, 0, 50)
                    ProfileFrame.Position = UDim2.new(0, 12, 1, -62) -- วางไว้มุมล่างสุดของแถบซ้าย
                    ProfileFrame.BackgroundTransparency = 1 -- โปร่งแสงตามรูปภาพต้นฉบับ
                    ProfileFrame.ZIndex = 100
                    ProfileFrame.Parent = Sidebar

                    -- 👤 1. ส่วนรูปภาพโปรไฟล์ (ดึงรูป Avatar ปัจจุบันของผู้เล่นจากระบบ Roblox)
                    local ProfileImage = Instance.new("ImageLabel")
                    ProfileImage.Name = "ProfileAvatar"
                    ProfileImage.Size = UDim2.new(0, 42, 0, 42)
                    ProfileImage.Position = UDim2.new(0, 0, 0.5, -21)
                    ProfileImage.BackgroundColor3 = Color3.fromRGB(27, 28, 34)
                    -- ฟังก์ชันดึงรูปภาพสไตล์ Headshot ของผู้เล่นแบบ HD
                    local userId = LocalPlayer.UserId
                    ProfileImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..userId.."&width=420&height=420&format=png"
                    ProfileImage.ZIndex = 101
                    ProfileImage.Parent = ProfileFrame

                    local ImageCorner = Instance.new("UICorner")
                    ImageCorner.CornerRadius = UDim.new(0, 6) -- ทำมุมโค้งมนที่รูปภาพ
                    ImageCorner.Parent = ProfileImage

                    -- 📝 2. ส่วนแสดงชื่อผู้เล่น (Display Name)
                    local NameLabel = Instance.new("TextLabel")
                    NameLabel.Name = "ProfileName"
                    NameLabel.Size = UDim2.new(0, 110, 0, 20)
                    NameLabel.Position = UDim2.new(0, 50, 0, 4)
                    NameLabel.BackgroundTransparency = 1
                    NameLabel.Text = LocalPlayer.DisplayName -- แสดงชื่อเล่นที่ตั้งไว้
                    NameLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
                    NameLabel.Font = Enum.Font.SourceSansBold
                    NameLabel.TextSize = 15
                    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
                    NameLabel.ZIndex = 101
                    NameLabel.Parent = ProfileFrame

                    -- 🎖️ 3. ส่วนแสดงสถานะ / ยศ (ตามรูปภาพคือคำว่า NEVER)
                    local RankLabel = Instance.new("TextLabel")
                    RankLabel.Name = "ProfileRank"
                    RankLabel.Size = UDim2.new(0, 110, 0, 18)
                    RankLabel.Position = UDim2.new(0, 50, 0, 22)
                    RankLabel.BackgroundTransparency = 1
                    RankLabel.Text = "NEVER" -- ยศเท่ๆ ถอดแบบมาจากตัวอย่างในรูปภาพ
                    RankLabel.TextColor3 = Color3.fromRGB(140, 145, 155) -- สีเทาจางลงมาตามรูปแบบต้นฉบับ
                    RankLabel.Font = Enum.Font.SourceSans
                    RankLabel.TextSize = 13
                    RankLabel.TextXAlignment = Enum.TextXAlignment.Left
                    RankLabel.ZIndex = 101
                    RankLabel.Parent = ProfileFrame
                end

                -- บังคับคุมโทนสีวัตถุภายในอื่นๆ (ปุ่มและสไลเดอร์) ให้กลายเป็นสีฟ้านีออนไซอัน
                for _, child in pairs(ScreenGui:GetDescendants()) do
                    if child:IsA("TextButton") and child.Name == "Button" then
                        child.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
                        child.TextColor3 = Color3.fromRGB(19, 20, 24)
                    end
                    if child:IsA("Frame") and (string.find(string.lower(child.Name), "slider") or string.find(string.lower(child.Name), "fill")) then
                        child.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
                    end
                end
            end)
        end
        
        return windowObj
    end

    return CustomLuna
end)

if success then
    return result
else
    warn("Nexora Profile Error: ไม่สามารถติดตั้งระบบโปรไฟล์ได้: ", result)
end    -- ฟังก์ชัน เปิด-ปิด หน้าจอหลักเมื่อกดปุ่มลอย
    local uiVisible = true
    ToggleButton.MouseButton1Click:Connect(function()
        uiVisible = not uiVisible
        MainFrame.Visible = uiVisible
        
        -- ปรับเอฟเฟกต์สีปุ่มเล็กน้อยเวลาเปิดปิด
        if uiVisible then
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Luna.Properties.Color}):Play()
        else
            TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}):Play()
        end
    end)
    -- =================================================================

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    Topbar.BorderSizePixel = 0
    Topbar.Parent = MainFrame

    local TopbarCorner = Instance.new("UICorner")
    TopbarCorner.CornerRadius = UDim.new(0, 8)
    TopbarCorner.Parent = Topbar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -40, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.Text = windowTitle
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Parent = Topbar

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0, 140, 1, -40)
    Sidebar.Position = UDim2.new(0, 0, 0, 40)
    Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local SidebarLayout = Instance.new("UIListLayout")
    SidebarLayout.Padding = UDim.new(0, 5)
    SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarLayout.Parent = Sidebar

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 10)
    SidebarPadding.Parent = Sidebar

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -150, 1, -50)
    ContentContainer.Position = UDim2.new(0, 145, 0, 45)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local WindowObj = { Tabs = {} }

    function WindowObj:CreateTab(tabOptions)
        tabOptions = tabOptions or {}
        local tabName = tabOptions.Name or "Tab"
        
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(0, 120, 0, 32)
        TabButton.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.Font = Enum.Font.SourceSansSemibold
        TabButton.TextSize = 15
        TabButton.AutoButtonColor = false
        TabButton.Parent = Sidebar

        local TBCorner = Instance.new("UICorner")
        TBCorner.CornerRadius = UDim.new(0, 6)
        TBCorner.Parent = TabButton

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.BorderSizePixel = 0
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 4
        TabPage.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
        TabPage.Parent = ContentContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Parent = TabPage

        local PagePadding = Instance.new("UIPadding")
        PagePadding.PaddingTop = UDim.new(0, 5)
        PagePadding.PaddingBottom = UDim.new(0, 5)
        PagePadding.Parent = TabPage

        PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabPage.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 15)
        end)

        local function ShowTab()
            for _, t in pairs(WindowObj.Tabs) do
                t.Page.Visible = false
                t.Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
                t.Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            end
            TabPage.Visible = true
            TabButton.BackgroundColor3 = Luna.Properties.Color
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        TabButton.MouseButton1Click:Connect(ShowTab)
        local TabObj = { Btn = TabButton, Page = TabPage }
        table.insert(WindowObj.Tabs, TabObj)

        if #WindowObj.Tabs == 1 then ShowTab() end

        function TabObj:CreateButton(btnOptions)
            btnOptions = btnOptions or {}
            local btnName = btnOptions.Name or "Button"
            local callback = btnOptions.Callback or function() end

            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Size = UDim2.new(0, 370, 0, 36)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ButtonFrame.Text = "  " .. btnName
            ButtonFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
            ButtonFrame.Font = Enum.Font.SourceSansSemibold
            ButtonFrame.TextSize = 15
            ButtonFrame.TextXAlignment = Enum.TextXAlignment.Left
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Parent = TabPage

            local BFCorner = Instance.new("UICorner")
            BFCorner.CornerRadius = UDim.new(0, 6)
            BFCorner.Parent = ButtonFrame

            ButtonFrame.MouseButton1Down:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
            end)
            ButtonFrame.MouseButton1Up:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                callback()
            end)
        end

        function TabObj:CreateToggle(toggleOptions)
            toggleOptions = toggleOptions or {}
            local toggleName = toggleOptions.Name or "Toggle"
            local current = toggleOptions.CurrentValue or false
            local callback = toggleOptions.Callback or function() end

            local ToggleFrame = Instance.new("TextButton")
            ToggleFrame.Size = UDim2.new(0, 370, 0, 38)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            ToggleFrame.Text = "  " .. toggleName
            ToggleFrame.TextColor3 = Color3.fromRGB(230, 230, 230)
            ToggleFrame.Font = Enum.Font.SourceSansSemibold
            ToggleFrame.TextSize = 15
            ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
            ToggleFrame.AutoButtonColor = false
            ToggleFrame.Parent = TabPage

            local TFCorner = Instance.new("UICorner")
            TFCorner.CornerRadius = UDim.new(0, 6)
            TFCorner.Parent = ToggleFrame

            local Switch = Instance.new("Frame")
            Switch.Size = UDim2.new(0, 34, 0, 18)
            Switch.Position = UDim2.new(1, -45, 0.5, -9)
            Switch.BackgroundColor3 = current and Luna.Properties.Color or Color3.fromRGB(50, 50, 50)
            Switch.Parent = ToggleFrame

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = Switch

            local Indicator = Instance.new("Frame")
            Indicator.Size = UDim2.new(0, 14, 0, 14)
            Indicator.Position = current and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            Indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Indicator.Parent = Switch

            local IndCorner = Instance.new("UICorner")
            IndCorner.CornerRadius = UDim.new(1, 0)
            IndCorner.Parent = Indicator

            ToggleFrame.MouseButton1Click:Connect(function()
                current = not current
                local targetPos = current and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                local targetColor = current and Luna.Properties.Color or Color3.fromRGB(50, 50, 50)
                TweenService:Create(Indicator, TweenInfo.new(0.15), {Position = targetPos}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.15), {BackgroundColor3 = targetColor}):Play()
                callback(current)
            end)
        end

        function TabObj:CreateSlider(sliderOptions)
            sliderOptions = sliderOptions or {}
            local sliderName = sliderOptions.Name or "Slider"
            local min = sliderOptions.Range[1] or 0
            local max = sliderOptions.Range[2] or 100
            local current = sliderOptions.CurrentValue or min
            local callback = sliderOptions.Callback or function() end

            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(0, 370, 0, 45)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SliderFrame.Parent = TabPage

            local SFCorner = Instance.new("UICorner")
            SFCorner.CornerRadius = UDim.new(0, 6)
            SFCorner.Parent = SliderFrame

            local NameLabel = Instance.new("TextLabel")
            NameLabel.Size = UDim2.new(0.5, 0, 0, 25)
            NameLabel.Position = UDim2.new(0, 12, 0, 2)
            NameLabel.Text = sliderName
            NameLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
            NameLabel.Font = Enum.Font.SourceSansSemibold
            NameLabel.TextSize = 15
            NameLabel.TextXAlignment = Enum.TextXAlignment.Left
            NameLabel.BackgroundTransparency = 1
            NameLabel.Parent = SliderFrame

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Size = UDim2.new(0.4, 0, 0, 25)
            ValueLabel.Position = UDim2.new(1, -162, 0, 2)
            ValueLabel.Text = tostring(current)
            ValueLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
            ValueLabel.Font = Enum.Font.SourceSans
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Parent = SliderFrame

            local SliderTrack = Instance.new("TextButton")
            SliderTrack.Size = UDim2.new(0, 346, 0, 6)
            SliderTrack.Position = UDim2.new(0, 12, 1, -12)
            SliderTrack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            SliderTrack.Text = ""
            SliderTrack.AutoButtonColor = false
            SliderTrack.Parent = SliderFrame

            local STCorner = Instance.new("UICorner")
            STCorner.CornerRadius = UDim.new(1, 0)
            STCorner.Parent = SliderTrack

            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((current - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = Luna.Properties.Color
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderTrack

            local SFCorner2 = Instance.new("UICorner")
            SFCorner2.CornerRadius = UDim.new(1, 0)
            SFCorner2.Parent = SliderFill

            local dragging = false
            local function updateSlider(input)
                local percent = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                local val = math.floor(min + (max - min) * percent)
                ValueLabel.Text = tostring(val)
                SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                callback(val)
            end

            SliderTrack.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true updateSlider(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateSlider(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
        end
        return TabObj
    end

    function WindowObj:Destroy()
        ScreenGui:Destroy()
    end
    return WindowObj
end

return Luna
