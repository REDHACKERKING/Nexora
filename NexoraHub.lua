-- =================================================================
-- Nexora Hub - Final Full Version
-- =================================================================

return function(Window)
    -- ระบบจดจำสถานะ (Persistence)
    getgenv().NexoraData = getgenv().NexoraData or {
        AutoBuy = false,
        AutoSpin = false,
        AutoClaim = false
    }

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
    local RewardTab = Window:CreateTab({ Name = "🎁 Rewards" })
    RewardTab:CreateToggle({
        Name = "Auto Claim Rewards (1-10)",
        CurrentValue = getgenv().NexoraData.AutoClaim,
        Callback = function(Value)
            getgenv().NexoraData.AutoClaim = Value
            if Value then
                task.spawn(function()
                    while getgenv().NexoraData.AutoClaim do
                        for i = 1, 10 do
                            if not getgenv().NexoraData.AutoClaim then break end
                            local event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):FindFirstChild("PlaytimeRewardUpdateEvent")
                            if event then event:FireServer(tostring(i)) end
                            task.wait(1)
                        end
                        task.wait(5)
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
    -- TAB 4: AUTO CLICKER (Integration)
    -- =================================================================
    local ClickTab = Window:CreateTab({ Name = "🎯 Auto Clicker" })
    getgenv().SavedX = 0; getgenv().SavedY = 0
    local Status = ClickTab:CreateLabel({ Name = "ตำแหน่ง: 0, 0" })

    ClickTab:CreateButton({ 
        Name = "จดจำตำแหน่งเมาส์", 
        Callback = function() 
            local m = game.Players.LocalPlayer:GetMouse()
            getgenv().SavedX, getgenv().SavedY = m.X, m.Y
            Status:Update("ตำแหน่ง: " .. m.X .. ", " .. m.Y)
        end
    })

    ClickTab:CreateToggle({ 
        Name = "Enable Auto Click", 
        Callback = function(v) 
            getgenv().AutoClick = v
            task.spawn(function() 
                while getgenv().AutoClick do 
                    pcall(function() mouse1click(getgenv().SavedX, getgenv().SavedY) end)
                    task.wait(0.5) 
                end 
            end) 
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
        Callback = function(Value)
            getgenv().HideGUI = Value
            if Value then
                local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
                getgenv().HideConnection = playerGui.ChildAdded:Connect(function(gui)
                    if getgenv().HideGUI and gui:IsA("ScreenGui") and gui.Name ~= "LunaUI" and (string.find(string.lower(gui.Name), "egg") or string.find(string.lower(gui.Name), "spin")) then
                        gui.Enabled = false
                    end
                end)
                for _, gui in pairs(playerGui:GetChildren()) do
                    if gui:IsA("ScreenGui") and gui.Name ~= "LunaUI" and (string.find(string.lower(gui.Name), "egg") or string.find(string.lower(gui.Name), "spin")) then
                        gui.Enabled = false
                    end
                end
            elseif getgenv().HideConnection then
                getgenv().HideConnection:Disconnect()
                getgenv().HideConnection = nil
            end
        end
    })
end
