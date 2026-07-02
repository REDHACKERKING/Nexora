function Features.LoadSmartClicker(Window)
    local ClickTab = Window:CreateTab({ Name = "🎯 Auto Clicker" })

    getgenv().SavedX = 0
    getgenv().SavedY = 0
    
    local StatusLabel = ClickTab:CreateLabel({ Name = "พิกัดล่าสุด: 0, 0" })

    -- ฟังก์ชันจดจำพิกัดเมาส์ที่วางอยู่ปัจจุบัน
    ClickTab:CreateButton({
        Name = "จดจำตำแหน่งเมาส์ (คลิกตรงนี้)",
        Callback = function()
            local mouse = game:GetService("Players").LocalPlayer:GetMouse()
            getgenv().SavedX = mouse.X
            getgenv().SavedY = mouse.Y
            StatusLabel:Update("พิกัดล่าสุด: " .. mouse.X .. ", " .. mouse.Y)
        end
    })

    ClickTab:CreateToggle({
        Name = "Enable Auto Click",
        Callback = function(v)
            getgenv().AutoClick = v
            task.spawn(function()
                while getgenv().AutoClick do
                    pcall(function()
                        -- ใช้ตำแหน่งที่จดจำไว้
                        mouse1click(getgenv().SavedX, getgenv().SavedY)
                    end)
                    task.wait(0.5)
                end
            end)
        end
    })
end
