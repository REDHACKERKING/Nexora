-- =================================================================
-- COMPKILLER LOADER | NEXORA EDITION (FINAL STABLE)
-- =================================================================
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- 1. ฟังก์ชันสร้างหน้าจอ Loading
local function ShowLoadingScreen()
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
    Text.Parent = Frame

    -- Fade In
    TweenService:Create(Text, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    
    return LoadGui, Frame, Text
end

-- 2. เริ่มทำงาน
local LoadingUI, MainFrame, TextLabel = ShowLoadingScreen()

-- 3. โหลด Library และ ฟังก์ชัน (ใส่อันนี้ไว้ใน task.spawn เพื่อไม่ให้ค้างหน้าจอก่อนโหลดเสร็จ)
task.spawn(function()
    local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/source.lua"))()
    -- เปลี่ยนลิงก์ด้านล่างเป็น Raw Pastebin ของคุณ
    local Features = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/refs/heads/main/NexoraHub.lua"))()

    task.wait(1.5) -- รอให้ดูพรีเมียมเล็กน้อย

    -- 4. Fade Out หน้าจอ Loading แบบสมบูรณ์
    local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    local fadeFrame = TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 1})
    local fadeText = TweenService:Create(TextLabel, tweenInfo, {TextTransparency = 1})
    
    fadeFrame:Play()
    fadeText:Play()
    
    fadeFrame.Completed:Connect(function()
        LoadingUI:Destroy()
    end)

    -- 5. สร้าง UI หลักและเรียกฟังก์ชัน
    local Window = Luna:CreateWindow({ Name = "COMPKILLER | NEXORA" })
    Features.LoadShop(Window)
    Features.LoadRewards(Window)
    
    print("Nexora: โหลดเสร็จสมบูรณ์!")
end)
