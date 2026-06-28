-- =================================================================
-- Nexora Hub - Full Version (Optimized & Fixed)
-- =================================================================

local url = "https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/LunaLib.lua"
local success, Luna = pcall(function() return loadstring(game:HttpGet(url .. "?nocache=" .. tostring(tick())))() end)

if not success then
    warn("Nexora Error: ไม่สามารถโหลด LunaLib ได้")
    return
end

local Window = Luna:CreateWindow()

-- ฟังก์ชันส่วนกลางสำหรับการส่ง Event
local function SafeFireServer(eventName, ...)
    local event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):FindFirstChild(eventName)
    if event then
        event:FireServer(...)
    else
        warn("Nexora Warning: ไม่พบ Event ชื่อ " .. eventName)
    end
end

-- =================================================================
-- TAB 1: SHOP
-- =================================================================
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

-- =================================================================
-- TAB 2: FARM (Auto Pickup Real-time)
-- =================================================================
local FarmTab = Window:CreateTab({ Name = "Farm" })
local AutoFarmEnabled = false

-- ระบบดักจับกล่องที่เกิดใหม่
workspace.DescendantAdded:Connect(function(obj)
    if AutoFarmEnabled and tonumber(obj.Name) then
        task.wait(0.5)
        SafeFireServer("PickupCrateEvent", obj.Name)
    end
end)

FarmTab:CreateToggle({
    Name = "Auto Pickup All Crates",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarmEnabled = Value
        if AutoFarmEnabled then
            -- สแกนของที่มีอยู่ก่อนเปิดโหมด
            for _, obj in pairs(workspace:GetDescendants()) do
                if tonumber(obj.Name) then
                    SafeFireServer("PickupCrateEvent", obj.Name)
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

-- =================================================================
-- TAB 3: SPINS
-- =================================================================
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

-- =================================================================
-- TAB 4: PLAYER
-- =================================================================
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

-- =================================================================
-- TAB 5: SYSTEM
-- =================================================================
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

SystemTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local success, servers = pcall(function()
            return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if success and servers then
            for _, s in pairs(servers.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
                end
            end
        end
    end
})

local HideGUI = false
SystemTab:CreateToggle({
    Name = "Auto Hide Egg & Spin GUI",
    CurrentValue = false,
    Callback = function(Value)
        HideGUI = Value
        task.spawn(function()
            while HideGUI do
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
