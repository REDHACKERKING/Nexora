-- [[ Luna Interface Suite - Direct Premium Loader ]]
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/source.lua"))()

local CustomLuna = {}
for k, v in pairs(Luna) do
    CustomLuna[k] = v
end

CustomLuna.CreateWindow = function(self, configs)
    local options = configs or {}
    options.Name = "COMPKILLER"
    options.Subtitle = "NEVER"
    options.Color = Color3.fromRGB(0, 220, 255)         
    options.TabColor = Color3.fromRGB(34, 49, 63)       
    options.Background = Color3.fromRGB(19, 20, 24)     
    options.CardColor = Color3.fromRGB(27, 28, 34)      
    options.TextColor = Color3.fromRGB(240, 240, 245)    
    options.CornerRadius = 6
    
    local windowObj = Luna:CreateWindow(options)
    
    -- ทำการสร้างกล่อง Profile ติดตั้งไว้ทางด้านซ้ายล่างทันทีหลังโหลดหน้าต่าง
    task.spawn(function()
        task.wait(0.3)
        local CoreGui = game:GetService("CoreGui")
        local ScreenGui = CoreGui:FindFirstChild("LunaUI")
        
        if ScreenGui and ScreenGui:FindFirstChild("MainFrame") then
            local Sidebar = ScreenGui.MainFrame:FindFirstChild("Sidebar")
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
                ProfileImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..LocalPlayer.UserId.."&width=420&height=420&format=png"
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
        end
    end)
    
    return windowObj
end

return CustomLuna
