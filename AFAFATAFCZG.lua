--// Visual Robux Faker + Fake Purchase by xAI (2025)
-- Работает на всех актуальных executor'ах

local Player = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Настройки (меняй тут)
local Settings = {
    AddRobuxAmount = 22222,        -- Сколько прибавлять за одну покупку
    CurrentFakeRobux = 0,          -- Текущее визуальное значение (можно ставить любое)
    Transparency = 0,              -- 0 = полностью скрыто, 1 = видно (по умолчанию скрыто)
    ToggleKey = Enum.KeyCode.Insert -- Клавиша открытия/скрытия меню
}

-- Создаём GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = HttpService:GenerateGUID(false)
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 400)
Frame.Position = UDim2.new(0, 20, 0, 20)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = Settings.Transparency
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

-- Закругления
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

-- Тень/бордер
local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(255, 100, 255)
Stroke.Thickness = 2
Stroke.Transparency = Settings.Transparency
Stroke.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "Visual RB Faker"
Title.TextColor3 = Color3.fromRGB(255, 100, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Frame

-- Поле ввода текущего баланса
local CurrentBox = Instance.new("TextBox")
CurrentBox.Size = UDim2.new(0.9, 0, 0, 40)
CurrentBox.Position = UDim2.new(0.05, 0, 0, 70)
CurrentBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
CurrentBox.TextColor3 = Color3.new(1,1,1)
CurrentBox.PlaceholderText = "Текущий RB (например 1337)"
CurrentBox.Text = tostring(Settings.CurrentFakeRobux)
CurrentBox.Font = Enum.Font.Code
CurrentBox.TextSize = 18
CurrentBox.Parent = Frame
local ccorner = Instance.new("UICorner", CurrentBox); ccorner.CornerRadius = UDim.new(0,8)

-- Поле ввода прибавки
local AddBox = Instance.new("TextBox")
AddBox.Size = UDim2.new(0.9, 0, 0, 40)
AddBox.Position = UDim2.new(0.05, 0, 0, 130)
AddBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
AddBox.TextColor3 = Color3.new(1,1,1)
AddBox.PlaceholderText = "Сколько прибавлять (по умолч. 22222)"
AddBox.Text = tostring(Settings.AddRobuxAmount)
AddBox.Font = Enum.Font.Code
AddBox.TextSize = 18
AddBox.Parent = Frame
local acorner = Instance.new("UICorner", AddBox); acorner.CornerRadius = UDim.new(0,8)

-- Кнопка "Применить сейчас"
local ApplyBtn = Instance.new("TextButton")
ApplyBtn.Size = UDim2.new(0.9, 0, 0, 50)
ApplyBtn.Position = UDim2.new(0.05, 0, 0, 200)
ApplyBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 180)
ApplyBtn.Text = "SET VISUAL ROBUX"
ApplyBtn.TextColor3 = Color3.new(1,1,1)
ApplyBtn.Font = Enum.Font.GothamBold
ApplyBtn.TextSize = 18
ApplyBtn.Parent = Frame
local btncorner = Instance.new("UICorner", ApplyBtn); btncorner.CornerRadius = UDim.new(0,10)

-- Кнопка "Совершить покупку (визуально)"
local BuyBtn = Instance.new("TextButton")
BuyBtn.Size = UDim2.new(0.9, 0, 0, 60)
BuyBtn.Position = UDim2.new(0.05, 0, 0, 270)
BuyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
BuyBtn.Text = "BUY +" .. Settings.AddRobuxAmount .. " ROBUX (FAKE)"
BuyBtn.TextColor3 = Color3.new(0,0,0)
BuyBtn.Font = Enum.Font.GothamBold
BuyBtn.TextSize = 20
BuyBtn.Parent = Frame
local buycorner = Instance.new("UICorner", BuyBtn); buycorner.CornerRadius = UDim.new(0,12)

-- Кнопка скрытия навсегда
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(0.3, 0, 0, 30)
HideBtn.Position = UDim2.new(0.7, 0, 0, 8)
HideBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
HideBtn.Text = "HIDE"
HideBtn.TextColor3 = Color3.new(1,1,1)
HideBtn.Font = Enum.Font.Gotham
HideBtn.Parent = Frame

-- Функция подделки баланса Robux
local function SetVisualRobux(amount)
    if game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
        local robuxLabel = game:GetService("CoreGui").RobloxGui.TopBar.RobuxContainer.RobuxText
        if robuxLabel then
            robuxLabel.Text = string.format("%,d", amount)
        end
    end
    
    -- Также в новом UI (2024-2025)
    pcall(function()
        for _, v in pairs(game:GetService("CoreGui"):GetDescendants()) do
            if v.Name == "RobuxTextLabel" or (v:IsA("TextLabel") and string.find(v.Text, "Robux")) then
                v.Text = string.format("%,d", amount) .. " Robux"
            end
        end
    end)
end

-- Функция визуальной покупки
local function FakePurchase()
    local old = tonumber(CurrentBox.Text) or 0
    local add = tonumber(AddBox.Text) or 22222
    local new = old + add
    
    CurrentBox.Text = tostring(new)
    SetVisualRobux(new)
    
    -- Визуальная анимация покупки
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Roblox";
        Text = "Покупка успешна! +"..add.." R$";
        Duration = 5;
    })
    
    -- Имитация окна оплаты (очень похоже на настоящее)
    spawn(function()
        local purchaseGui = Instance.new("ScreenGui")
        purchaseGui.Parent = CoreGui
        
        local bg = Instance.new("Frame")
        bg.Size = UDim2.new(1,0,1,0)
        bg.BackgroundColor3 = Color3.new(0,0,0)
        bg.BackgroundTransparency = 0.3
        bg.Parent = purchaseGui
        
        local box = Instance.new("Frame")
        box.Size = UDim2.new(0, 400, 0, 250)
        box.Position = UDim2.new(0.5, -200, 0.5, -125)
        box.BackgroundColor3 = Color3.fromRGB(30,30,35)
        box.Parent = purchaseGui
        local bc = Instance.new("UICorner", box); bc.CornerRadius = UDim.new(0,15)
        
        local title = Instance.new("TextLabel")
        title.Text = "Покупка завершена"
        title.TextColor3 = Color3.new(0,1,0)
        title.BackgroundTransparency = 1
        title.Size = UDim2.new(1,0,0.4,0)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 28
        title.Parent = box
        
        local txt = Instance.new("TextLabel")
        txt.Text = "Вы успешно приобрели "..add.." Robux"
        txt.TextColor3 = Color3.new(1,1,1)
        txt.BackgroundTransparency = 1
        txt.Position = UDim2.new(0,0,0.4,0)
        txt.Size = UDim2.new(1,0,0.3,0)
        txt.Font = Enum.Font.Gotham
        txt.TextSize = 20
        txt.Parent = box
        
        wait(2.5)
        purchaseGui:Destroy()
    end)
end

-- Обработчики кнопок
ApplyBtn.MouseButton1Click:Connect(function()
    local num = tonumber(CurrentBox.Text) or 0
    SetVisualRobux(num)
end)

BuyBtn.MouseButton1Click:Connect(FakePurchase)

HideBtn.MouseButton1Click:Connect(function()
    Frame.BackgroundTransparency = 1
    Frame.UIStroke.Transparency = 1
    for _, v in pairs(Frame:GetChildren()) do
        if v:IsA("GuiObject") then
            v.Visible = false
        end
    end
    HideBtn.Visible = true
    HideBtn.Text = "VISIBLE"
    HideBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    
    HideBtn.MouseButton1Click:Connect(function()
        Frame.BackgroundTransparency = 0
        Frame.UIStroke.Transparency = 0
        for _, v in pairs(Frame:GetChildren()) do
            v.Visible = true
        end
        HideBtn.Text = "HIDE"
        HideBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    end)
end)

-- Открытие/закрытие по Insert
local menuOpen = true
game:GetService("UserInputService").InputBegan:Connect(function(key)
    if key.KeyCode == Settings.ToggleKey then
        menuOpen = not menuOpen
        TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = menuOpen and 0 or 1}):Play()
        TweenService:Create(Frame.UIStroke, TweenInfo.new(0.3), {Transparency = menuOpen and 0 or 1}):Play()
    end
end)

-- Автозапуск — сразу ставим нужный баланс
wait(2)
SetVisualRobux(tonumber(CurrentBox.Text) or Settings.CurrentFakeRobux)

print("Visual Robux Faker загружен! Нажми Insert чтобы открыть/скрыть")
