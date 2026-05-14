getgenv().SecureMode = true

getgenv().VisualRbx = {
    HiddenForever = false,
    Balance = 22000,
    AddAmount = 20000
}

local gui = Instance.new("ScreenGui")
gui.Name = "VisualRbx_Silent"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- Плавающая кнопка
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 55, 0, 55)
btn.Position = UDim2.new(0, 25, 0, 180)
btn.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
btn.Text = "VR"
btn.TextColor3 = Color3.new(0, 0, 0)
btn.TextSize = 20
btn.Font = Enum.Font.GothamBold
btn.Draggable = true
btn.Parent = gui

-- Меню
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 360, 0, 420)
menu.Position = UDim2.new(0.5, -180, 0.5, -210)
menu.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
menu.Visible = false
menu.BackgroundTransparency = 1
menu.Parent = gui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "VisualRbx (Silent)"
title.TextColor3 = Color3.fromRGB(0, 255, 136)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.Parent = menu

-- Баланс (визуальный)
local balanceLabel = Instance.new("TextLabel")
balanceLabel.Size = UDim2.new(1, -30, 0, 30)
balanceLabel.Position = UDim2.new(0, 15, 0, 45)
balanceLabel.Text = "Robux: 22,000"
balanceLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
balanceLabel.TextSize = 18
balanceLabel.Font = Enum.Font.GothamBold
balanceLabel.BackgroundTransparency = 1
balanceLabel.Parent = menu

-- Функция обновления баланса
local function updateBalance()
    balanceLabel.Text = "Robux: " .. tostring(getgenv().VisualRbx.Balance)
end

-- Функция открытия меню
local function toggle()
    if getgenv().VisualRbx.HiddenForever then return end
    if not menu.Visible then
        menu.Visible = true
        for i = 1, 12 do
            menu.BackgroundTransparency = 1 - (i / 12)
            wait(0.02)
        end
    else
        for i = 1, 12 do
            menu.BackgroundTransparency = i / 12
            wait(0.02)
        end
        menu.Visible = false
    end
end

btn.MouseButton1Click:Connect(toggle)

-- Кнопки
local function makeButton(text, y, action)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -40, 0, 42)
    b.Position = UDim2.new(0, 20, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 16
    b.Font = Enum.Font.GothamBold
    b.Parent = menu
    b.MouseButton1Click:Connect(action)
end

makeButton("Buy 1x", 90, function()
    getgenv().VisualRbx.Balance += getgenv().VisualRbx.AddAmount
    updateBalance()
end)

makeButton("Buy 5x", 140, function()
    getgenv().VisualRbx.Balance += getgenv().VisualRbx.AddAmount * 5
    updateBalance()
end)

makeButton("Buy 10x", 190, function()
    getgenv().VisualRbx.Balance += getgenv().VisualRbx.AddAmount * 10
    updateBalance()
end)

makeButton("Set Balance", 250, function()
    updateBalance()
end)

makeButton("Fake DevEx", 300, function()
    print("DevEx activated")
end)

makeButton("Hide Forever", 350, function()
    getgenv().VisualRbx.HiddenForever = true
    menu.Visible = false
end)

-- Горячая клавиша
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggle()
    end
end)

updateBalance()
print("VisualRbx загружен. Нажимай на зелёный квадратик.")
