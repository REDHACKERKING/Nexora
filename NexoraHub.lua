-- 🔗 ดึงไลเบอรีส่วนตัวตามปกติ (ไม่แก้ไขโครงสร้างไลเบอรีใดๆ)
local url = "https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/LunaLib.lua"
local freshUrl = url .. "?nocache=" .. tostring(tick())
local Luna = loadstring(game:HttpGet(freshUrl))()

-- ฟังก์ชั่นส่งข้อมูลเบื้องหลัง
local function SafeFireServer(eventName, ...)
    local eventsFolder = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
    if eventsFolder then
        local event = eventsFolder:FindFirstChild(eventName)
        if event and event:IsA("RemoteEvent") then
            event:FireServer(...)
        end
    end
end

-- เปิดใช้งาน UI ตัวเต็มโดยใช้ฟังก์ชันจาก source ของคุณ
local Window = Luna:CreateWindow({
    Name = "COMPKILLER",
    Subtitle = "Nexora Hub Premium v2.5",
    Color = Color3.fromRGB(0, 220, 255),
    CornerRadius = 6
})

-- =================================================================
-- 🛒 TAB 1: SHOP AUTO BUY (ระบบซื้อสินค้าอัตโนมัติ)
-- =================================================================
local ShopTab = Window:CreateTab({ Name = "Shop Auto Buy" })

local AutoBuyTotem = false
ShopTab:CreateToggle({
    Name = "Auto Buy Frostbound Totem (เปิด/ปิด)",
    CurrentValue = false,
    Callback = function(Value)
        AutoBuyTotem = Value
        if AutoBuyTotem then
            task.spawn(function()
                while AutoBuyTotem do
                    SafeFireServer("TotemShopPurchaseEvent", "Frostbound")
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- =================================================================
-- 📦 TAB 2: FARM & DROPS (ระบบฟาร์มของและไอเทมตกพื้น)
-- =================================================================
local FarmTab = Window:CreateTab({ Name = "Farm & Drops" })

local AutoFarmCrates = false
FarmTab:CreateToggle({
    Name = "Auto Pickup ALL Crates (ดูดกล่องทั้งหมด)",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarmCrates = Value
        if AutoFarmCrates then
            task.spawn(function()
                while AutoFarmCrates do
                    local cratesFolder = workspace:FindFirstChild("Crates") or workspace:FindFirstChild("Drops") or workspace
                    if cratesFolder then
                        for _, crate in pairs(cratesFolder:GetChildren()) do
                            if not AutoFarmCrates then break end
                            local crateID = tonumber(crate.Name) or crate:GetAttribute("ID") or crate:GetAttribute("CrateID")
                            if crateID or string.find(string.lower(crate.Name), "crate") or string.find(string.lower(crate.Name), "drop") then
                                local finalID = tostring(crateID or crate.Name)
                                SafeFireServer("PickupCrateEvent", finalID)
                                task.wait(0.01)
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

local AutoClaimRewards = false
FarmTab:CreateToggle({
    Name = "Auto Claim Playtime Rewards (รับรางวัลเวลาออนไลน์)",
    CurrentValue = false,
    Callback = function(Value)
        AutoClaimRewards = Value
        if AutoClaimRewards then
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
    end
})

-- =================================================================
-- 🥚 TAB 3: EGGS & SPINS (ระบบเปิดไข่และสุ่มวงล้อ)
-- =================================================================
local EggTab = Window:CreateTab({ Name = "Eggs & Spins" })

EggTab:CreateButton({
    Name = "Open Backpack Eggs (เปิดไข่ทั้งหมดในกระเป๋า)",
    Callback = function()
        local eggIDs = {"1623", "1137"}
        for _, id in pairs(eggIDs) do
            SafeFireServer("OpenBackpackEggEvent", id)
            task.wait(0.02)
        end
    end
})

local AutoSpinWheel = false
EggTab:CreateToggle({
    Name = "Auto Spin Wheel (หมุนวงล้อออโต้)",
    CurrentValue = false,
    Callback = function(Value)
        AutoSpinWheel = Value
        if AutoSpinWheel then
            task.spawn(function()
                while AutoSpinWheel do
                    SafeFireServer("AdminAbuseSpinWheelEvent", "Spin")
                    task.wait(0.1)
                    SafeFireServer("AdminAbuseSpinWheelEvent", "SpinComplete")
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- =================================================================
-- 👤 TAB 4: PLAYER MOD (ปรับแต่งค่าตัวละคร)
-- =================================================================
local PlayerTab = Window:CreateTab({ Name = "Player Mod" })

PlayerTab:CreateSlider({
    Name = "WalkSpeed (ความเร็วการเดิน)",
    Range = {16, 100},
    CurrentValue = 16,
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = Value
        end
    end
})

PlayerTab:CreateSlider({
    Name = "JumpPower (แรงกระโดด)",
    Range = {50, 200},
    CurrentValue = 50,
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.UseJumpPower = true
            character.Humanoid.JumpPower = Value
        end
    end
})

-- =================================================================
-- ⚙️ TAB 5: SYSTEM & PROTECTION (ระบบเสถียรภาพและตั้งค่า UI)
-- =================================================================
local SystemTab = Window:CreateTab({ Name = "System & Settings" })

local HideSpinAndEggGUI = false
SystemTab:CreateToggle({
    Name = "Auto Hide Egg & Spin GUI (ซ่อนหน้าต่างสุ่มของเกม)",
    CurrentValue = false,
    Callback = function(Value)
        HideSpinAndEggGUI = Value
        if HideSpinAndEggGUI then
            task.spawn(function()
                while HideSpinAndEggGUI do
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        for _, gui in pairs(playerGui:GetChildren()) do
                            if gui:IsA("ScreenGui") then
                                local nameLower = string.lower(gui.Name)
                                if string.find(nameLower, "egg") or string.find(nameLower, "spin") or string.find(nameLower, "wheel") or string.find(nameLower, "open") or string.find(nameLower, "anim") then
                                    if gui.Name ~= "Luna" and gui.Name ~= "LunaUI" and gui.Name ~= "LunaInterface" then
                                        if gui.Enabled == true then
                                            gui.Enabled = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)
        else
            local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, gui in pairs(playerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        local nameLower = string.lower(gui.Name)
                        if string.find(nameLower, "egg") or string.find(nameLower, "spin") or string.find(nameLower, "wheel") or string.find(nameLower, "open") or string.find(nameLower, "anim") then
                            gui.Enabled = true
                        end
                    end
                end
            end
        end
    end
})

SystemTab:CreateButton({
    Name = "FPS Boost (ลดกราฟิกแก้กระตุก)",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = false
        for _, effect in pairs(lighting:GetChildren()) do
            if effect:IsA("PostEffect") or effect:IsA("BloomEffect") or effect:IsA("BlurEffect") then
                effect.Enabled = false
            end
        end
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(game.Players.LocalPlayer.Character) then
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
            end
        end
    end
})

-- ระบบป้องกันเตะออกเมื่อยืนนิ่งนาน (Anti-AFK)
local AntiAFKEnabled = true
local vu = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if AntiAFKEnabled then
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

SystemTab:CreateButton({
    Name = "Server Hop (ย้ายเซิร์ฟเวอร์หาห้องใหม่)",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local success, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if success and servers and servers.data then
            for _, server in pairs(servers.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(PlaceId, server.id, game.Players.LocalPlayer)
                    break
                end
            end
        end
    end
})

SystemTab:CreateButton({
    Name = "Rejoin Server (รีเซ็ตกลับเข้าเซิร์ฟเดิม)",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

SystemTab:CreateButton({
    Name = "Destroy GUI (ปิดการทำงานของโปรแกรม)",
    Callback = function()
        AntiAFKEnabled = false
        Window:Destroy()
    end
})        end
    end
})

-- 🔄 ปุ่มสวิตช์เปิด-ปิดระบบ "หมุนวงล้อสปินอัตโนมัติ"
local AutoSpinWheel = false
Main:CreateToggle({
    Name = "Auto Spin Wheel (หมุนสปินออโต้)",
    CurrentValue = false,
    Callback = function(Value)
        AutoSpinWheel = Value
        if AutoSpinWheel then
            task.spawn(function()
                while AutoSpinWheel do
                    SafeFireServer("AdminAbuseSpinWheelEvent", "Spin")
                    task.wait(0.1)
                    SafeFireServer("AdminAbuseSpinWheelEvent", "SpinComplete")
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- 🚫 ปุ่มสวิตช์เปิด-ปิด: ซ่อนเฉพาะหน้าต่างเปิดไข่หรือหน้าต่างสปินของเกม
local HideSpinAndEggGUI = false
Main:CreateToggle({
    Name = "Auto Hide Egg & Spin GUI",
    CurrentValue = false,
    Callback = function(Value)
        HideSpinAndEggGUI = Value
        if HideSpinAndEggGUI then
            task.spawn(function()
                while HideSpinAndEggGUI do
                    local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
                    if playerGui then
                        for _, gui in pairs(playerGui:GetChildren()) do
                            if gui:IsA("ScreenGui") then
                                local nameLower = string.lower(gui.Name)
                                if string.find(nameLower, "egg") or string.find(nameLower, "spin") or string.find(nameLower, "wheel") or string.find(nameLower, "open") or string.find(nameLower, "anim") then
                                    if gui.Name ~= "Luna" and gui.Name ~= "LunaUI" and gui.Name ~= "LunaInterface" then
                                        if gui.Enabled == true then
                                            gui.Enabled = false
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.05)
                end
            end)
        else
            local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if playerGui then
                for _, gui in pairs(playerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") then
                        local nameLower = string.lower(gui.Name)
                        if string.find(nameLower, "egg") or string.find(nameLower, "spin") or string.find(nameLower, "wheel") or string.find(nameLower, "open") or string.find(nameLower, "anim") then
                            gui.Enabled = true
                        end
                    end
                end
            end
        end
    end
})

-- ระบบออโต้ฟาร์มดูดกล่องทั้งหมด (สแกนอัตโนมัติ ไม่ต้องใส่เลข ID)
local AutoFarmCrates = false
Main:CreateToggle({
    Name = "Auto Pickup ALL Crates",
    CurrentValue = false,
    Callback = function(Value)
        AutoFarmCrates = Value
        if AutoFarmCrates then
            task.spawn(function()
                while AutoFarmCrates do
                    local cratesFolder = workspace:FindFirstChild("Crates") or workspace:FindFirstChild("Drops") or workspace
                    if cratesFolder then
                        for _, crate in pairs(cratesFolder:GetChildren()) do
                            if not AutoFarmCrates then break end
                            local crateID = tonumber(crate.Name) or crate:GetAttribute("ID") or crate:GetAttribute("CrateID")
                            if crateID or string.find(string.lower(crate.Name), "crate") or string.find(string.lower(crate.Name), "drop") then
                                local finalID = tostring(crateID or crate.Name)
                                SafeFireServer("PickupCrateEvent", finalID)
                                task.wait(0.01)
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

-- =================================================================
-- PLAYER TAB (เมนูผู้เล่นเดิม - อยู่ครบถ้วน)
-- =================================================================
local Player = Window:CreateTab({ Name = "Player" })

Player:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 100},
    CurrentValue = 16,
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = Value
        end
    end
})

Player:CreateSlider({
    Name = "JumpPower",
    Range = {50, 200},
    CurrentValue = 50,
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.UseJumpPower = true
            character.Humanoid.JumpPower = Value
        end
    end
})

-- =================================================================
-- SETTINGS TAB (เมนูตั้งค่าเดิม - อยู่ครบถ้วน)
-- =================================================================
local Settings = Window:CreateTab({ Name = "Settings" })

Settings:CreateButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

Settings:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        Window:Destroy()
    end
})
