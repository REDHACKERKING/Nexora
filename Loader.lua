-- =================================================================
-- COMPKILLER LOADER | NEXORA HUB INTEGRATED
-- =================================================================
local CoreGui = game:GetService("CoreGui")

-- 1. สร้างหน้า Loading Screen แบบด่วน (0.5 วินาที)
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
Text.Parent = Frame

-- 2. ดึง Library และไฟล์หลัก (โหลดก่อน)
local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/main/source.lua"))()
local NexoraContent = loadstring(game:HttpGet("https://raw.githubusercontent.com/REDHACKERKING/Nexora/refs/heads/main/NexoraHub.lua"))()

-- 3. โชว์หน้าโหลด 0.5 วินาที แล้วลบทิ้ง
task.wait(0.5)
LoadGui:Destroy()

-- 4. เรียกใช้ Custom Profile Wrapper
local CustomLuna = {}
for k, v in pairs(Luna) do CustomLuna[k] = v end

CustomLuna.CreateWindow = function(self, configs)
    local options = configs or {}
    options.Name = "COMPKILLER"
    options.Subtitle = "NEVER"
    options.Color = Color3.fromRGB(0, 220, 255)
    options.Background = Color3.fromRGB(15, 16, 20)
    options.CornerRadius = 8
    
    local windowObj = Luna:CreateWindow(options)
    
    task.spawn(function()
        task.wait(0.3)
        local Sidebar = CoreGui:FindFirstChild("LunaUI") and CoreGui.LunaUI:FindFirstChild("MainFrame") and CoreGui.LunaUI.MainFrame:FindFirstChild("Sidebar")
        if Sidebar then
            -- [ใส่โค้ดสร้าง ProfileFrame แบบเดิมของคุณที่นี่]
            -- (นาฬิกาและชื่อแมพจะทำงานในนี้)
        end
    end)
    return windowObj
end

-- 5. สร้าง Window และ Load สคริปต์หลัก
local Window = CustomLuna:CreateWindow()
NexoraContent(Window) -- รันฟังก์ชันจากไฟล์ NexoraHub.lua ของคุณ
