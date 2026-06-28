-- =================================================================
-- Nexora Hub - Full Version
-- =================================================================

-- 1. โหลด Library (เพิ่ม pcall เพื่อป้องกันสคริปต์หยุดทำงาน)
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
-- 🛒 TAB 1: SHOP
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
-- 📦 TAB 2: FARM
-- =================================================================
local FarmTab = Window:CreateTab({ Name = "Farm" })
local AutoFarmCrates = false
FarmTab:CreateToggle({
    Name = "Auto Pickup All Crates",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarmCrates = Value
        task.spawn(function()
            while AutoFarmCrates do
                local folder = workspace:FindFirstChild("Crates") or workspace:FindFirstChild("Drops")
                if folder then
                    for _, obj in pairs(folder:GetChildren()) do
                        if not AutoFarmCrates then break end
                        if tonumber(obj.Name) then
                            SafeFireServer("PickupCrateEvent", obj.Name)
                            task.wait(0.05)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
})

-- =================================================================
-- 🥚 TAB 3: EGGS & SPINS
-- =================================================================
local EggTab = Window:CreateTab({ Name = "Eggs" })
local AutoSpinWheel = false
EggTab:CreateToggle({
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
-- 👤 TAB 4: PLAYER
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
-- ⚙️ TAB 5: SYSTEM
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
        local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in pairs(servers.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
            end
        end
    end
})
