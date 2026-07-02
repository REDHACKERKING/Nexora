-- =================================================================
-- NexoraHub.lua - Final Full Version (Combined & Optimized)
-- =================================================================

return function(Window)
    -- ระบบข้อมูล
    getgenv().NexoraData = getgenv().NexoraData or { AutoBuy = false, AutoSpin = false, AutoClaim = false }
    
    local function SafeFireServer(eventName, ...)
        local event = game:GetService("ReplicatedStorage"):WaitForChild("Events"):FindFirstChild(eventName)
        if event then event:FireServer(...) end
    end

    -- TAB 1: SHOP
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

    -- TAB 2: REWARDS
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
                            SafeFireServer("PlaytimeRewardUpdateEvent", tostring(i))
                            task.wait(1)
                        end
                        task.wait(5)
                    end
                end)
            end
        end
    })

    -- TAB 3: SPINS
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

    -- TAB 4: AUTO CLICKER
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

    -- TAB 5: SYSTEM
    local SystemTab = Window:CreateTab({ Name = "System" })
    SystemTab:CreateButton({ Name = "Server Hop (Safe)", Callback = function()
        local s = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in pairs(s.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end})

    SystemTab:CreateToggle({
        Name = "Auto Hide Eggs (Keep Spins Visible)",
        Callback = function(Value)
            getgenv().HideGUI = Value
            if Value then
                local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
                local function checkAndHide(gui)
                    if gui:IsA("ScreenGui") and gui.Name ~= "LunaUI" then
                        local n = string.lower(gui.Name)
                        if (string.find(n, "egg") or string.find(n, "hatch") or string.find(n, "opening")) 
                           and not string.find(n, "spin") then
                            gui.Enabled = false
                        end
                    end
                end
                getgenv().HideConnection = playerGui.ChildAdded:Connect(checkAndHide)
                for _, gui in pairs(playerGui:GetChildren()) do checkAndHide(gui) end
            elseif getgenv().HideConnection then
                getgenv().HideConnection:Disconnect()
                getgenv().HideConnection = nil
            end
        end
    })
end
