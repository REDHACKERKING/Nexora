-- =================================================================
-- 🔗 ดึงจากไลเบอรีพรีเมียมผ่าน GitHub ของคุณ
-- =================================================================
local url = "https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/LunaLib.lua"
local freshUrl = url .. "?nocache=" .. tostring(tick())
local Luna = loadstring(game:HttpGet(freshUrl))()

-- สร้างหน้าต่างโปรแกรมหลัก
local Window = Luna:CreateWindow()

-- =================================================================
-- 🛒 TAB 1: SHOP AUTO BUY (ระบบซื้อสินค้าอัตโนมัติ)
-- =================================================================
local ShopTab = Window:CreateTab({ Name = "Shop Auto Buy" })

local AutoBuyTotem = false
ShopTab:CreateToggle({
    Name = "Auto Buy Frostbound Totem",
    CurrentValue = false,
    Callback = function(Value)
        AutoBuyTotem = Value
        if AutoBuyTotem then
            task.spawn(function()
                while AutoBuyTotem do
                    -- 🛠️ ปรับเป็นโครงสร้าง local args และ unpackตามสั่ง
                    local args = {
                        "Frostbound"
                    }
                    local shopEvent = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("TotemShopPurchaseEvent")
                    if shopEvent then
                        shopEvent:FireServer(unpack(args))
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- =================================================================
-- 📦 TAB 2: FARM & DROPS (ระบบรับกล่องก็อปปี้อัตโนมัติ)
-- =================================================================
local FarmTab = Window:CreateTab({ Name = "Farm & Drops" })

local AutoFarmCrates = false
FarmTab:CreateToggle({
    Name = "รับกล่องก็อปปี้อัตโนมัติ (Auto Pickup via Args)",
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
                                
                                -- 🛠️ ปรับโครงสร้างรับค่าจากกล่องทุกใบผ่าน Unpack Args
                                local args = {
                                    finalID
                                }
                                local pickupEvent = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PickupCrateEvent")
                                if pickupEvent then
                                    pickupEvent:FireServer(unpack(args))
                                end
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
    Name = "Auto Claim Playtime Rewards",
    CurrentValue = false,
    Callback = function(Value)
        AutoClaimRewards = Value
        if AutoClaimRewards then
            task.spawn(function()
                while AutoClaimRewards do
                    local rewardEvent = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("PlaytimeRewardUpdateEvent")
                    if rewardEvent then
                        for i = 1, 10 do
                            if not AutoClaimRewards then break end
                            -- 🛠️ ปรับโครงสร้างรับรางวัลรายชิ้นผ่าน Unpack Args
                            local args = {
                                tostring(i)
                            }
                            rewardEvent:FireServer(unpack(args))
                        end
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
    Name = "Open Backpack Eggs (All)",
    Callback = function()
        local eggIDs = {"1623", "1137"}
        for _, id in pairs(eggIDs) do
            -- 🛠️ ปรับสคริปต์สุ่มไข่ผ่าน Unpack Args
            local args = {
                id
            }
            local eggEvent = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("OpenBackpackEggEvent")
            if eggEvent then
                eggEvent:FireServer(unpack(args))
            end
            task.wait(0.02)
        end
    end
})

local AutoSpinWheel = false
EggTab:CreateToggle({
    Name = "Auto Spin Wheel (หมุนสปินออโต้)",
    CurrentValue = false,
    Callback = function(Value)
        AutoSpinWheel = Value
        if AutoSpinWheel then
            task.spawn(function()
                while AutoSpinWheel do
                    local spinEvent = game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("AdminAbuseSpinWheelEvent")
                    if spinEvent then
                        -- 🛠️ ปรับสคริปต์หมุนวงล้อรอบเริ่มผ่าน Unpack Args
                        local args1 = { "Spin" }
                        spinEvent:FireServer(unpack(args1))
                        task.wait(0.1)
                        
                        -- 🛠️ ปรับสคริปต์รับรางวัลวงล้อรอบจบผ่าน Unpack Args
                        local args2 = { "SpinComplete" }
                        spinEvent:FireServer(unpack(args2))
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- =================================================================
-- 👤 TAB 4: PLAYER MOD (ตัวปรับแต่งความสามารถผู้เล่น)
-- =================================================================
local PlayerTab = Window:CreateTab({ Name = "Player Mod" })

PlayerTab:CreateSlider({
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

PlayerTab:CreateSlider({
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
-- ⚙️ TAB 5: SYSTEM & SETTINGS (ตั้งค่าความเสถียรและปิดโปรแกรม)
-- =================================================================
local SystemTab = Window:CreateTab({ Name = "System & Settings" })

local HideSpinAndEggGUI = false
SystemTab:CreateToggle({
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
                                    if gui.Name ~= "LunaUI" and gui.Name ~= "Luna" then
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

-- ระบบป้องกันการหลุดจากการยืนนิ่ง (Anti-AFK)
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
    Name = "Server Hop (ย้ายเซิร์ฟเวอร์)",
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
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

SystemTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        AntiAFKEnabled = false
        Window:Destroy()
    end
})                                SafeFireServer("PickupCrateEvent", finalID)
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
    Name = "Auto Claim Playtime Rewards",
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
-- 🥚 TAB 3: EGGS & SPINS
-- =================================================================
local EggTab = Window:CreateTab({ Name = "Eggs & Spins" })

EggTab:CreateButton({
    Name = "Open Backpack Eggs (All)",
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

-- =================================================================
-- 👤 TAB 4: PLAYER MOD
-- =================================================================
local PlayerTab = Window:CreateTab({ Name = "Player Mod" })

PlayerTab:CreateSlider({
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

PlayerTab:CreateSlider({
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
-- ⚙️ TAB 5: SYSTEM & SETTINGS
-- =================================================================
local SystemTab = Window:CreateTab({ Name = "System & Settings" })

local HideSpinAndEggGUI = false
SystemTab:CreateToggle({
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
                                    if gui.Name ~= "LunaUI" and gui.Name ~= "Luna" then
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
    Name = "Server Hop (ย้ายเซิร์ฟเวอร์)",
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
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

SystemTab:CreateButton({
    Name = "Destroy GUI",
    Callback = function()
        AntiAFKEnabled = false
        Window:Destroy()
    end
})
