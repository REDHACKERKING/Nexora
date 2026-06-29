-- =================================================================
-- COMPKILLER LOADER | NEXORA EDITION
-- =================================================================

-- 1. ฟังก์ชันสร้างหน้าจอ Loading
local function ShowLoadingScreen()
    local CoreGui = game:GetService("CoreGui")
    local LoadGui = Instance.new("ScreenGui", CoreGui)
    LoadGui.Name = "NexoraLoading"
    LoadGui.IgnoreGuiInset = true

    local Frame = Instance.new("Frame", LoadGui)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
    Frame.BorderSizePixel = 0

    local Text = Instance.new("TextLabel", Frame)
    Text.Size = UDim2.new(0, 400, 0, 50)
    Text.Position = UDim2.new(0.5, -200, 0.5, -25)
    Text.BackgroundTransparency = 1
    Text.Text = "กำลังโหลด NEXORA..."
    Text.TextColor3 = Color3.fromRGB(0, 220, 255)
    Text.Font = Enum.Font.GothamBold
    Text.TextSize = 30
    Text.TextTransparency = 1

    -- Animation Fade In
    task.spawn(function()
        for i = 1, 0, -0.05 do
            Text.TextTransparency = i
            task.wait(0.03)
        end
    end)
    
    return LoadGui, Frame
end

-- 2. เริ่มทำงาน
local LoadingUI, MainFrame = ShowLoadingScreen()

-- 3. โหลด Library และ ฟังก์ชันแยก (แทนที่ URL ของคุณ)
task.wait(2.5) -- รอช่วงโหลด 2.5 วินาทีให้ดูพรีเมียม

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/source.lua"))()
-- สมมติว่าไฟล์ฟังก์ชันคุณอยู่ที่ Pastebin นี้
local Features = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/refs/heads/main/NexoraHub.lua"))()

-- 4. Fade Out หน้าจอ Loading
task.spawn(function()
    for i = 0, 1, 0.05 do
        MainFrame.BackgroundTransparency = i
        LoadingUI.Enabled = false -- ปิดการมองเห็น
        task.wait(0.02)
    end
    LoadingUI:Destroy()
end)

-- 5. สร้าง UI หลักและโหลดฟังก์ชันจากไฟล์ Features.lua
local Window = Luna:CreateWindow({ Name = "COMPKILLER | NEXORA" })

Features.LoadShop(Window)
Features.LoadRewards(Window)

print("Nexora: โหลดเสร็จสมบูรณ์!")
