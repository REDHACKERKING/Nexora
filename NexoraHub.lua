-- =================================================================
-- Nexora Hub - Full Version (Fixed)
-- =================================================================

local url = "https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/LunaLib.lua"
local success, Luna = pcall(function() return loadstring(game:HttpGet(url .. "?nocache=" .. tostring(tick())))() end)

if not success then
    warn("Nexora Error: ไม่สามารถโหลด LunaLib ได้")
    return
end

local Window = Luna:CreateWindow()

local function SafeFireServer(eventName, ...)
    local event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):FindFirstChild(eventName)
    if event then
        event:FireServer(...)
    else
        warn("Nexora Warning: ไม่พบ Event ชื่อ " .. eventName)
    end
end

-- Tab 1: Shop
local ShopTab = Window:CreateTab({ Name = "Shop" })
local AutoBuyTotem = false
ShopTab:CreateToggle({
    Name = "Auto Buy Frostbound Totem",
    CurrentValue = false,
    Callback = function(Value)
        AutoBuyTotem = Value
        task.spawn(function()
            while AutoBuyTotem do
                SafeFireServer("TotemShopPurchaseEvent", "Frostbound")
                task.wait(0.5)
            end
        end)
    end
})

-- Tab 2: Farm
local AutoFarmEnabled = false -- ตัวแปรควบคุมการทำงาน
local Events = game:GetService("ReplicatedStorage"):WaitForChild("Events")
local PickupEvent = Events:WaitForChild("PickupCrateEvent")

-- ฟังก์ชันที่ใช้ดักจับ
local function OnDescendantAdded(obj)
    if AutoFarmEnabled and tonumber(obj.Name) then
        task.wait(0.5) -- รอให้กล่องเกิดสมบูรณ์ก่อนเก็บ
        PickupEvent:FireServer(obj.Name)
        print("Auto Pickup:", obj.Name)
    end
end

-- เชื่อมต่อกับเหตุการณ์ของ Workspace
workspace.DescendantAdded:Connect(OnDescendantAdded)

-- ส่วนของ UI (ใส่ไว้ใน Tab)
FarmTab:CreateToggle({
    Name = "Auto Pickup (Real-time)",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarmEnabled = Value
        if AutoFarmEnabled then
            -- เมื่อเปิดใช้งาน ให้ลองสแกนของที่มีอยู่ก่อนแล้วรอบหนึ่ง
            for _, obj in pairs(workspace:GetDescendants()) do
                if tonumber(obj.Name) then
                    PickupEvent:FireServer(obj.Name)
                    task.wait(0.1)
                end
            end
        end
    end
})

local AutoClaimRewards = false
FarmTab:CreateToggle({
    Name = "Auto Claim Playtime Rewards",
    CurrentValue = false,
    Callback = function(Value)
        AutoClaimRewards = Value
        task.spawn(function()
            while AutoClaimRewards do
                for i = 1, 10 do
                    if not AutoClaimRewards then break end
                    SafeFireServer("PlaytimeRewardUpdateEvent", tostring(i))
                end
                task.wait(5)
            end
        end)
    end
})

-- Tab 3: Spins
local SpinTab = Window:CreateTab({ Name = "Spins" })
local AutoSpinWheel = false
SpinTab:CreateToggle({
    Name = "Auto Spin Wheel",
    CurrentValue = false,
    Callback = function(Value)
        AutoSpinWheel = Value
        task.spawn(function()
            while AutoSpinWheel do
                SafeFireServer("AdminAbuseSpinWheelEvent", "Spin")
                task.wait(0.1)
                SafeFireServer("AdminAbuseSpinWheelEvent", "SpinComplete")
                task.wait(0.5)
            end
        end)
    end
})

-- Tab 4: Player
local PlayerTab = Window:CreateTab({ Name = "Player" })
PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    CurrentValue = 16,
    Callback = function(Value)
        local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = Value end
    end
})

-- Tab 5: System
local SystemTab = Window:CreateTab({ Name = "System" })
SystemTab:CreateButton({
    Name = "FPS Boost",
    Callback = function()
        game:GetService("Lighting").GlobalShadows = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then v.CastShadow = false end
        end
    end
})

local HideSpinAndEggGUI = false
SystemTab:CreateToggle({
    Name = "Auto Hide GUI",
    CurrentValue = false,
    Callback = function(Value)
        HideSpinAndEggGUI = Value
        task.spawn(function()
            while HideSpinAndEggGUI do
                local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in pairs(playerGui:GetChildren()) do
                        if gui:IsA("ScreenGui") and (string.find(string.lower(gui.Name), "egg") or string.find(string.lower(gui.Name), "spin")) then
                            if gui.Name ~= "LunaUI" then gui.Enabled = false end
                        end
                    end
                end
                task.wait(0.05)
            end
        end)
    end
})
