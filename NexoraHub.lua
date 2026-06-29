-- =================================================================
-- Nexora Hub - Final Full Version (No Farm)
-- =================================================================

-- ระบบจดจำสถานะ (Persistence)
getgenv().NexoraData = getgenv().NexoraData or {
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

-- ฟังก์ชันส่ง Event
local function SafeFireServer(eventName, ...)
    local event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):FindFirstChild(eventName)
    if event then
        event:FireServer(...)
    end
end

-- =================================================================
-- TAB 1: SHOP
-- =================================================================
local ShopTab = Window:CreateTab({ Name = "Shop" })
ShopTab:CreateToggle({
    Name = "Auto Buy Frostbound (15 Min)",
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
-- TAB 2: REWARDS
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
                    SafeFireServer("PlaytimeRewardUpdateEvent", "Claim")
                    task.wait(5) 
                end
            end)
        end
    end
})

-- =================================================================
-- TAB 3: SPINS & SYSTEM
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
})
