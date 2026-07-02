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
-- =================================================================
-- TAB 2: REWARDS (Updated to Auto Loop 1-10)
-- =================================================================
local RewardTab = Window:CreateTab({ Name = "🎁 Rewards" })
RewardTab:CreateSection("AUTO CLAIM 1-10")

RewardTab:CreateToggle({
    Name = "Auto Claim Rewards (1-10)",
    CurrentValue = getgenv().NexoraData.AutoClaim,
    Callback = function(Value)
        getgenv().NexoraData.AutoClaim = Value
        if Value then
            task.spawn(function()
                while getgenv().NexoraData.AutoClaim do
                    -- วนลูปเลข 1 ถึง 10
                    for i = 1, 10 do
                        if not getgenv().NexoraData.AutoClaim then break end
                        
                        local args = { tostring(i) }
                        local event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):FindFirstChild("PlaytimeRewardUpdateEvent")
                        
                        if event then
                            event:FireServer(unpack(args))
                            print("Nexora: Claimed Reward ID: " .. i)
                        end
                        
                        task.wait(1) -- เว้นช่วง 1 วินาทีต่อการกด 1 ครั้ง เพื่อไม่ให้ Spam เกินไป
                    end
                    task.wait(5) -- จบ 1 รอบ 1-10 แล้วรอ 5 วินาทีก่อนเริ่มรอบใหม่
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
    Name = "Auto Hide GUI (100% Block)",
    Callback = function(Value)
        getgenv().HideGUI = Value
        
        if Value then
            local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
            
            -- ฟังก์ชันสั่งตาย (ทำให้หายไปจากหน้าจอแบบถาวร)
            local function killGui(gui)
                if getgenv().HideGUI and gui:IsA("ScreenGui") and gui.Name ~= "LunaUI" then
                    local n = string.lower(gui.Name)
                    -- ตรวจสอบชื่อที่ต้องการซ่อน (ยกเว้น Spin ตามที่คุณต้องการ)
                    if (string.find(n, "egg") or string.find(n, "hatch") or string.find(n, "opening")) 
                       and not string.find(n, "spin") then
                        
                        gui.Enabled = false -- ปิดการแสดงผล
                        gui.Visible = false -- ซ่อนแบบ 100%
                        
                        -- ดักทุกการเปลี่ยนแปลงไม่ให้กลับมาโชว์
                        gui:GetPropertyChangedSignal("Enabled"):Connect(function()
                            if getgenv().HideGUI then gui.Enabled = false end
                        end)
                        gui:GetPropertyChangedSignal("Visible"):Connect(function()
                            if getgenv().HideGUI then gui.Visible = false end
                        end)
                    end
                end
            end
            
            -- ดักฟังตลอดไป
            getgenv().HideConnection = playerGui.DescendantAdded:Connect(killGui)
            
            -- กวาดล้างของเก่า
            for _, gui in pairs(playerGui:GetChildren()) do
                killGui(gui)
            end
        else
            -- ยกเลิกการดักฟัง
            if getgenv().HideConnection then
                getgenv().HideConnection:Disconnect()
                getgenv().HideConnection = nil
            end
        end
    end
})
