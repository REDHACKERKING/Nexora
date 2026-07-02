-- =================================================================
-- NEXORA HUB - INTEGRATED FINAL VERSION
-- =================================================================
local CoreGui = game:GetService("CoreGui")

-- 1. โหลด Library
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/source.lua"))()

-- 2. สร้าง Window
local Window = Luna:CreateWindow({
    Name = "COMPKILLER",
    Subtitle = "NEVER",
    Color = Color3.fromRGB(0, 220, 255),
    Background = Color3.fromRGB(15, 16, 20),
    CornerRadius = 8
})

-- ใส่ Profile Section
task.spawn(function()
    task.wait(0.3)
    local Sidebar = CoreGui:FindFirstChild("LunaUI") and CoreGui.LunaUI:FindFirstChild("MainFrame") and CoreGui.LunaUI.MainFrame:FindFirstChild("Sidebar")
    if Sidebar then
        local ProfileFrame = Instance.new("Frame", Sidebar)
        ProfileFrame.Size = UDim2.new(1, 0, 0, 80); ProfileFrame.Position = UDim2.new(0, 0, 0, 10); ProfileFrame.BackgroundTransparency = 1
        local Avatar = Instance.new("ImageLabel", ProfileFrame)
        Avatar.Size = UDim2.new(0, 50, 0, 50); Avatar.Position = UDim2.new(0, 10, 0, 0)
        Avatar.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..game.Players.LocalPlayer.UserId.."&width=420&height=420&format=png"
        Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)
        local Name = Instance.new("TextLabel", ProfileFrame)
        Name.Size = UDim2.new(1, -70, 0, 20); Name.Position = UDim2.new(0, 70, 0, 5); Name.BackgroundTransparency = 1
        Name.Text = game.Players.LocalPlayer.DisplayName; Name.TextColor3 = Color3.fromRGB(255, 255, 255); Name.Font = Enum.Font.GothamBold; Name.TextSize = 14; Name.TextXAlignment = Enum.TextXAlignment.Left
    end
end)

-- ฟังก์ชัน Helper
local function SafeFire(eventName, ...)
    local event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):FindFirstChild(eventName)
    if event then event:FireServer(...) end
end

-- TAB: SHOP
local Shop = Window:CreateTab({ Name = "Shop" })
Shop:CreateToggle({ Name = "Auto Buy Frostbound", Callback = function(v)
    getgenv().AutoBuy = v
    task.spawn(function() while getgenv().AutoBuy do SafeFire("TotemShopPurchaseEvent", "Frostbound"); task.wait(900) end end)
end})

-- TAB: REWARDS
local Rewards = Window:CreateTab({ Name = "🎁 Rewards" })
Rewards:CreateToggle({ Name = "Auto Claim 1-10", Callback = function(v)
    getgenv().AutoClaim = v
    task.spawn(function() while getgenv().AutoClaim do for i=1,10 do if not getgenv().AutoClaim then break end; SafeFire("PlaytimeRewardUpdateEvent", tostring(i)); task.wait(1) end; task.wait(5) end end)
end})

-- TAB: SPINS
local Spins = Window:CreateTab({ Name = "Spins" })
Spins:CreateToggle({ Name = "Auto Spin Wheel", Callback = function(v)
    getgenv().AutoSpin = v
    task.spawn(function() while getgenv().AutoSpin do SafeFire("AdminAbuseSpinWheelEvent", "Spin"); task.wait(0.1); SafeFire("AdminAbuseSpinWheelEvent", "SpinComplete"); task.wait(5) end end)
end})

-- TAB: AUTO CLICKER
local Clicker = Window:CreateTab({ Name = "🎯 Auto Clicker" })
getgenv().SX = 0; getgenv().SY = 0
local Status = Clicker:CreateLabel({ Name = "ตำแหน่ง: 0, 0" })
Clicker:CreateButton({ Name = "จดจำตำแหน่งเมาส์", Callback = function()
    local m = game.Players.LocalPlayer:GetMouse(); getgenv().SX, getgenv().SY = m.X, m.Y
    Status:Update("ตำแหน่ง: " .. m.X .. ", " .. m.Y)
end})
Clicker:CreateToggle({ Name = "Enable Auto Click", Callback = function(v)
    getgenv().AutoClick = v
    task.spawn(function() while getgenv().AutoClick do pcall(function() mouse1click(getgenv().SX, getgenv().SY) end); task.wait(0.5) end end)
end})

-- TAB: SYSTEM
local System = Window:CreateTab({ Name = "System" })
System:CreateToggle({ Name = "Auto Hide Eggs", Callback = function(v)
    getgenv().HideGUI = v
    if v then
        local pg = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        getgenv().Conn = pg.ChildAdded:Connect(function(g)
            if getgenv().HideGUI and g:IsA("ScreenGui") and g.Name ~= "LunaUI" and (string.find(string.lower(g.Name), "egg") or string.find(string.lower(g.Name), "hatch")) and not string.find(string.lower(g.Name), "spin") then g.Enabled = false end
        end)
    elseif getgenv().Conn then getgenv().Conn:Disconnect() end
end})
