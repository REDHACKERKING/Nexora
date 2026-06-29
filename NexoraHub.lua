-- =================================================================
-- Nexora Hub - Final Full Version (Added Auto Claim)
-- =================================================================

-- ระบบจดจำสถานะ (Persistence)
getgenv().NexoraData = getgenv().NexoraData or {
    AutoPickup = false,
    AutoBuy = false,
    AutoSpin = false,
    AutoClaim = false
}

-- โหลด Library
local url = "https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/LunaLib.lua"
local success, Luna = pcall(function() return loadstring(game:HttpGet(url .. "?nocache=" .. tostring(tick())))() end)

if not success then
    warn("Nexora Error: ไม่สามารถโหลด LunaLib ได้")
    return
end

local Window = Luna:CreateWindow()

-- ฟังก์ชันส่ง Event แบบปลอดภัย
local function SafeFireServer(eventName, ...)
    task.wait(math.random(0.1, 0.3)) 
    local event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):FindFirstChild(eventName)
    if event then
        event:FireServer(...)
    end
end

-- =================================================================
-- TAB 1: FARM (ล็อกเป้าหมายเฉพาะ Duplicator)
-- =================================================================
local FarmTab = Window:CreateTab({ Name = "Farm" })

FarmTab:CreateToggle({
    Name = "Auto Pickup Duplicator Only",
    CurrentValue = getgenv().NexoraData.AutoPickup,
    Callback = function(Value)
        getgenv().NexoraData.AutoPickup = Value
        if Value then
            task.spawn(function()
                while getgenv().NexoraData.AutoPickup do
                    local machine = workspace:FindFirstChild("Duplicator", true)
                    if machine then
                        for _, obj in pairs(machine:GetDescendants()) do
                            if not getgenv().NexoraData.AutoPickup then break end
                            if obj:IsA("BasePart") and string.find(obj.Name, "enchantment extractor") then
                                SafeFireServer("PickupCrateEvent", obj.Name)
                                task.wait(math.random(0.3, 0.5))
                            end
                        end
                    end
                    task.wait(60) 
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
                    task.wait(900)
                end
            end)
        end
    end
})

-- =================================================================
-- TAB 3: REWARDS (New)
-- =================================================================
local RewardTab = Window:CreateTab({ Name = "Rewards" })
RewardTab:CreateToggle({
    Name = "Auto Claim Rewards",
    CurrentValue = getgenv().NexoraData.AutoClaim,
    Callback = function(Value)
        getgenv().NexoraData.AutoClaim = Value
        if Value then
            task.spawn(function()
                while getgenv().NexoraData.AutoClaim do
                    -- หมายเหตุ: หากไม่ได้รับรางวัล ให้ลองเช็คชื่อ Remote ในเกมอีกครั้ง
                    SafeFireServer("PlaytimeRewardUpdateEvent", "Claim")
                    task.wait(5) 
                end
            end)
        end
    end
})

-- =================================================================
-- TAB 4: MISC & SYSTEM
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
