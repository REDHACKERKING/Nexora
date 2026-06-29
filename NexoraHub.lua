-- =================================================================
-- Nexora Hub - Final Full Version (Safe Farm & Buy)
-- =================================================================

-- ระบบจดจำสถานะ (Persistence)
getgenv().NexoraData = getgenv().NexoraData or {
    AutoPickup = false,
    AutoBuy = false,
    AutoSpin = false
}

-- โหลด Library
local url = "https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/LunaLib.lua"
local success, Luna = pcall(function() return loadstring(game:HttpGet(url .. "?nocache=" .. tostring(tick())))() end)

if not success then
    warn("Nexora Error: ไม่สามารถโหลด LunaLib ได้")
    return
end

local Window = Luna:CreateWindow()

-- ฟังก์ชันส่ง Event แบบปลอดภัย (มีหน่วงเวลาสุ่มเพื่อความเนียน)
local function SafeFireServer(eventName, ...)
    task.wait(math.random(0.1, 0.3)) 
    local event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):FindFirstChild(eventName)
    if event then
        event:FireServer(...)
    else
        warn("Nexora Warning: ไม่พบ Event ชื่อ " .. eventName)
    end
end

-- =================================================================
-- TAB 1: FARM
-- =================================================================
local FarmTab = Window:CreateTab({ Name = "Farm" })

FarmTab:CreateToggle({
    Name = "Auto Pickup Cubes (Every 1 Min)",
    CurrentValue = getgenv().NexoraData.AutoPickup,
    Callback = function(Value)
        getgenv().NexoraData.AutoPickup = Value
        if Value then
            task.spawn(function()
                while getgenv().NexoraData.AutoPickup do
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not getgenv().NexoraData.AutoPickup then break end
                        if obj:IsA("BasePart") and string.find(obj.Name, "enchantment extractor") then
                            SafeFireServer("PickupCrateEvent", obj.Name)
                            task.wait(math.random(0.3, 0.5))
                        end
                    end
                    task.wait(60) -- รอบละ 1 นาที
                end
            end)
        end
    end
})

-- =================================================================
-- TAB 2: SHOP
-- =================================================================
local ShopTab = Window:CreateTab({ Name = "Shop" })

ShopTab:CreateToggle({
    Name = "Auto Buy Frostbound (Every 15 Min)",
    CurrentValue = getgenv().NexoraData.AutoBuy,
    Callback = function(Value)
        getgenv().NexoraData.AutoBuy = Value
        if Value then
            task.spawn(function()
                while getgenv().NexoraData.AutoBuy do
                    SafeFireServer("TotemShopPurchaseEvent", "Frostbound")
                    task.wait(900) -- รอบละ 15 นาที
                end
            end)
        end
    end
})

-- =================================================================
-- TAB 3: SPINS
-- =================================================================
local SpinTab = Window:CreateTab({ Name = "Spins" })
SpinTab:CreateToggle({
    Name = "Auto Spin Wheel",
    CurrentValue = getgenv().NexoraData.AutoSpin,
    Callback = function(Value)
        getgenv().NexoraData.AutoSpin = Value
        task.spawn(function()
            while getgenv().NexoraData.AutoSpin do
                SafeFireServer("AdminAbuseSpinWheelEvent", "Spin")
                task.wait(0.1)
                SafeFireServer("AdminAbuseSpinWheelEvent", "SpinComplete")
                task.wait(5)
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
    Name = "Server Hop (Safe)",
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

SystemTab:CreateToggle({
    Name = "Auto Hide GUI",
    CurrentValue = false,
    Callback = function(Value)
        getgenv().HideGUI = Value
        task.spawn(function()
            while getgenv().HideGUI do
                local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui then
                    for _, gui in pairs(playerGui:GetChildren()) do
                        if gui:IsA("ScreenGui") and (string.find(string.lower(gui.Name), "egg") or string.find(string.lower(gui.Name), "spin")) then
                            if gui.Name ~= "LunaUI" then gui.Enabled = false end
                        end
                    end
                end
                task.wait(2)
            end
        end)
    end
})        if AutoFarmEnabled then
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
