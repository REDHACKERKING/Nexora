-- =================================================================
-- COMPKILLER LOADER | INSTANT LOAD + AUTO CLICKER INTEGRATED
-- =================================================================
local CoreGui = game:GetService("CoreGui")

-- 1. ดึง Library และไฟล์หลัก (NexoraHub.lua)
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/source.lua"))()
local NexoraContent = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/refs/heads/main/NexoraHub.lua"))()

-- 2. ตั้งค่า Custom Wrapper
local CustomLuna = {}
for k, v in pairs(Luna) do CustomLuna[k] = v end

CustomLuna.CreateWindow = function(self, configs)
    local options = configs or {}
    options.Name = "COMPKILLER"
    options.Subtitle = "NEVER"
    options.Color = Color3.fromRGB(0, 220, 255)
    options.Background = Color3.fromRGB(15, 16, 20)
    options.CornerRadius = 8
    
    local windowObj = Luna:CreateWindow(options)
    
    -- ใส่ Profile Section ที่ Sidebar
    task.spawn(function()
        task.wait(0.3)
        local Sidebar = CoreGui:FindFirstChild("LunaUI") and CoreGui.LunaUI:FindFirstChild("MainFrame") and CoreGui.LunaUI.MainFrame:FindFirstChild("Sidebar")
        if Sidebar then
            local ProfileFrame = Instance.new("Frame", Sidebar)
            ProfileFrame.Name = "ProfileSection"
            ProfileFrame.Size = UDim2.new(1, 0, 0, 80)
            ProfileFrame.Position = UDim2.new(0, 0, 0, 10)
            ProfileFrame.BackgroundTransparency = 1
            
            local Avatar = Instance.new("ImageLabel", ProfileFrame)
            Avatar.Size = UDim2.new(0, 50, 0, 50)
            Avatar.Position = UDim2.new(0, 10, 0, 0)
            Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..game.Players.LocalPlayer.UserId.."&width=420&height=420&format=png"
            Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)
            
            local Name = Instance.new("TextLabel", ProfileFrame)
            Name.Size = UDim2.new(1, -70, 0, 20)
            Name.Position = UDim2.new(0, 70, 0, 5)
            Name.BackgroundTransparency = 1
            Name.Text = game.Players.LocalPlayer.DisplayName
            Name.TextColor3 = Color3.fromRGB(255, 255, 255)
            Name.Font = Enum.Font.GothamBold
            Name.TextSize = 14
            Name.TextXAlignment = Enum.TextXAlignment.Left
        end
    end)
    return windowObj
end

-- 3. สร้าง Window หลัก
local Window = CustomLuna:CreateWindow()

-- 4. เพิ่มระบบ Auto Clicker ลงใน Window
local ClickTab = Window:CreateTab({ Name = "🎯 Auto Clicker" })
getgenv().SavedX = 0
getgenv().SavedY = 0

local Status = ClickTab:CreateLabel({ Name = "ตำแหน่ง: 0, 0" })

ClickTab:CreateButton({ 
    Name = "จดจำตำแหน่งเมาส์", 
    Callback = function() 
        local m = game.Players.LocalPlayer:GetMouse()
        getgenv().SavedX, getgenv().SavedY = m.X, m.Y
        Status:Update("ตำแหน่ง: " .. m.X .. ", " .. m.Y)
    end
})

ClickTab:CreateToggle({ 
    Name = "Enable Auto Click", 
    Callback = function(v) 
        getgenv().AutoClick = v
        task.spawn(function() 
            while getgenv().AutoClick do 
                pcall(function() mouse1click(getgenv().SavedX, getgenv().SavedY) end)
                task.wait(0.5) 
            end 
        end) 
    end
})

-- 5. รันฟังก์ชันจากไฟล์ NexoraHub.lua ของคุณ
NexoraContent(Window)
