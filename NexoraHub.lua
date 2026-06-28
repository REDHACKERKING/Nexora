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
    Name = "Nexora Hub",
    Subtitle = "by REDHACKERKING",
    Color = Color3.fromRGB(44, 122, 232),
    CornerRadius = 8
})

-- =================================================================
-- MAIN TAB (หน้าเมนูหลัก - ฟังก์ชันเดิมอยู่ครบ 100%)
-- =================================================================
local Main = Window:CreateTab({ Name = "Main" })

Main:CreateButton({
    Name = "Claim Playtime Reward 1",
    Callback = function()
        SafeFireServer("PlaytimeRewardUpdateEvent", "1")
    end
})

-- 🛒 ปรับปรุงใหม่: สวิตช์เปิด-ปิด ระบบซื้อ Frostbound Totem อัตโนมัติ (Auto Buy)
local AutoBuyTotem = false
Main:CreateToggle({
    Name = "Auto Buy Frostbound Totem",
    CurrentValue = false,
    Callback = function(Value)
        AutoBuyTotem = Value
        if AutoBuyTotem then
            task.spawn(function()
                while AutoBuyTotem do
                    SafeFireServer("TotemShopPurchaseEvent", "Frostbound")
                    task.wait(0.5) -- หน่วงเวลาซื้อทุกๆ 0.5 วินาที (ปรับความเร็วเพิ่ม/ลดได้ตรงนี้)
                end
            end)
        end
    end
})

-- 🥚 ปุ่มกดเปิดไข่ (ดึงค่าจาก OpenBackpackEggEvent เดิมที่มีอยู่)
Main:CreateButton({
    Name = "Open Backpack Eggs (All)",
    Callback = function()
        local eggIDs = {"1623", "1137"}
        for _, id in pairs(eggIDs) do
            SafeFireServer("OpenBackpackEggEvent", id)
            task.wait(0.02)
        end
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
