-- =================================================================
-- COMPKILLER UI | FULL INTEGRATED VERSION
-- =================================================================

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/source.lua"))()

-- [Custom UI Wrapper]
local CustomLuna = {}
for k, v in pairs(Luna) do CustomLuna[k] = v end

CustomLuna.CreateWindow = function(self, configs)
    local options = configs or {}
    options.Name = "COMPKILLER"
    options.Subtitle = "NEVER"
    options.Color = Color3.fromRGB(0, 220, 255)         
    options.TabColor = Color3.fromRGB(34, 49, 63)       
    options.Background = Color3.fromRGB(15, 16, 20)     
    options.CardColor = Color3.fromRGB(22, 23, 28)      
    options.TextColor = Color3.fromRGB(240, 240, 245)    
    options.CornerRadius = 8
    
    local windowObj = Luna:CreateWindow(options)
    
    -- [Profile Sidebar Construction]
    task.spawn(function()
        task.wait(0.5)
        local CoreGui = game:GetService("CoreGui")
        local ScreenGui = CoreGui:FindFirstChild("LunaUI")
        if ScreenGui and ScreenGui:FindFirstChild("MainFrame") then
            local Sidebar = ScreenGui.MainFrame:FindFirstChild("Sidebar")
            if Sidebar then
                local Player = game:GetService("Players").LocalPlayer
                
                local ProfileFrame = Instance.new("Frame", Sidebar)
                ProfileFrame.Name = "ProfileContainer"
                ProfileFrame.Size = UDim2.new(1, -20, 0, 60)
                ProfileFrame.Position = UDim2.new(0, 10, 1, -70)
                ProfileFrame.BackgroundColor3 = Color3.fromRGB(35, 36, 42)
                ProfileFrame.BorderSizePixel = 0
                Instance.new("UICorner", ProfileFrame).CornerRadius = UDim.new(0, 8)

                local ProfileImage = Instance.new("ImageLabel", ProfileFrame)
                ProfileImage.Size = UDim2.new(0, 40, 0, 40)
                ProfileImage.Position = UDim2.new(0, 10, 0.5, -20)
                ProfileImage.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..Player.UserId.."&width=420&height=420&format=png"
                Instance.new("UICorner", ProfileImage).CornerRadius = UDim.new(1, 0)

                local NameLabel = Instance.new("TextLabel", ProfileFrame)
                NameLabel.Size = UDim2.new(1, -60, 0, 20)
                NameLabel.Position = UDim2.new(0, 55, 0, 10)
                NameLabel.BackgroundTransparency = 1
                NameLabel.Text = Player.DisplayName
                NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                NameLabel.Font = Enum.Font.GothamBold
                NameLabel.TextSize = 14
                NameLabel.TextXAlignment = Enum.TextXAlignment.Left

                local StatusLabel = Instance.new("TextLabel", ProfileFrame)
                StatusLabel.Size = UDim2.new(1, -60, 0, 18)
                StatusLabel.Position = UDim2.new(0, 55, 0, 28)
                StatusLabel.BackgroundTransparency = 1
                StatusLabel.TextColor3 = Color3.fromRGB(0, 220, 255)
                StatusLabel.Font = Enum.Font.Gotham
                StatusLabel.TextSize = 10
                StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

                task.spawn(function()
                    while task.wait(1) do
                        local gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
                        if #gameName > 15 then gameName = string.sub(gameName, 1, 12).."..." end
                        StatusLabel.Text = os.date("%H:%M:%S") .. " | " .. gameName
                    end
                end)
            end
        end
    end)
    
    return windowObj
end

-- =================================================================
-- MAIN SCRIPT LOGIC
-- =================================================================
local Window = CustomLuna:CreateWindow()
local function SafeFire(e, ...) local ev = game:GetService("ReplicatedStorage"):WaitForChild("Events"):FindFirstChild(e) if ev then ev:FireServer(...) end end

-- SHOP
local ShopTab = Window:CreateTab({ Name = "🛒 Shop" })
ShopTab:CreateToggle({ Name = "Auto Buy Frostbound", Callback = function(v) 
    getgenv().AutoBuy = v 
    task.spawn(function() while getgenv().AutoBuy do SafeFire("TotemShopPurchaseEvent", "Frostbound") task.wait(900) end end) 
end})

-- REWARDS
local RewardTab = Window:CreateTab({ Name = "🎁 Rewards" })
RewardTab:CreateToggle({ Name = "Auto Claim 1-10", Callback = function(v) 
    getgenv().AutoClaim = v 
    task.spawn(function() while getgenv().AutoClaim do for i=1,10 do if not getgenv().AutoClaim then break end SafeFire("PlaytimeRewardUpdateEvent", tostring(i)) task.wait(1) end task.wait(5) end end) 
end})

-- SYSTEM
local SystemTab = Window:CreateTab({ Name = "⚙️ System" })
SystemTab:CreateToggle({ Name = "Auto Spin Wheel", Callback = function(v) 
    getgenv().AutoSpin = v 
    task.spawn(function() while getgenv().AutoSpin do SafeFire("AdminAbuseSpinWheelEvent", "Spin") task.wait(0.1) SafeFire("AdminAbuseSpinWheelEvent", "SpinComplete") task.wait(5) end end) 
end})

SystemTab:CreateToggle({ Name = "Auto Hide GUI", Callback = function(v) 
    getgenv().HideGUI = v 
    task.spawn(function() while getgenv().HideGUI do for _,g in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do if g:IsA("ScreenGui") and (string.find(string.lower(g.Name), "egg") or string.find(string.lower(g.Name), "spin")) and g.Name ~= "LunaUI" then g.Enabled = false end end task.wait(2) end end) 
end})

SystemTab:CreateButton({ Name = "Server Hop", Callback = function() 
    local s = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _,serv in pairs(s.data) do if serv.playing < serv.maxPlayers and serv.id ~= game.JobId then game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, serv.id) end end
end})
