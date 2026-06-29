-- =================================================================
-- Nexora Hub - Dynamic ID Hunter (Full Script)
-- =================================================================

-- ระบบจดจำสถานะ (Persistence)
getgenv().NexoraData = getgenv().NexoraData or {
    AutoPickup = false,
    AutoBuy = false,
    AutoSpin = false,
    AutoClaim = false
}

-- เริ่มต้นที่เลข 1619
getgenv().CurrentCubeID = 1619

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
-- TAB 1: FARM (Dynamic ID Hunter)
-- =================================================================
local FarmTab = Window:CreateTab({ Name = "Farm" })

FarmTab:CreateToggle({
    Name = "Auto Hunter (Auto Increment ID)",
    CurrentValue = getgenv().NexoraData.AutoPickup,
    Callback = function(Value)
        getgenv().NexoraData.AutoPickup = Value
        if Value then
            task.spawn(function()
                while getgenv().NexoraData.AutoPickup do
                    -- สร้างชื่อเป้าหมายตาม ID ปัจจุบัน
                    local targetName = "Meshes/ enchantment extractor_Cube." .. tostring(getgenv().CurrentCubeID)
                    local targetCube = workspace:FindFirstChild(targetName, true)
                    
                    if targetCube then
                        -- ส่งค่า ID ปัจจุบันไปที่ Event
                        local args = { tostring(getgenv().CurrentCubeID) }
                        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PickupCrateEvent"):FireServer(unpack(args))
                        
                        print("Nexora: พบกล่องเลข " .. getgenv().CurrentCubeID .. " ทำการเก็บเรียบร้อย")
                        getgenv().CurrentCubeID = getgenv().CurrentCubeID + 1
                    else
                        -- ไม่เจอเลขนี้ ขยับเลขถัดไป
                        getgenv().CurrentCubeID = getgenv().CurrentCubeID + 1
                    end
                    
                    task.wait(0.5) -- หน่วงเวลาสแกน 0.5 วินาที
                end
            end)
        end
    end
})

-- =================================================================
-- TAB 2: SHOP (Auto Buy - 15 Min)
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
-- TAB 3: REWARDS
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
-- TAB 4: SYSTEM
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
