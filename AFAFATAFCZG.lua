getgenv().SecureMode = true

getgenv().VisualRbx = {
    HiddenForever = false,
    Balance = 22000,
    AddRobuxVal = 20000
}

local gui = Instance.new("ScreenGui")
gui.Name = "VisualRbx_Silent"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

-- Плавающая кнопка для телефона
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 60, 0, 60)
toggleBtn.Position = UDim2.new(0, 30, 0, 200)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
toggleBtn.Text = "VR"
toggleBtn.TextColor3 = Color3.new(0, 0, 0)
toggleBtn.TextSize = 22
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.ZIndex = 9999
toggleBtn.Parent = gui

-- Главное меню
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 380, 0, 520)
main.Position = UDim2.new(0.5, -190, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Visible = false
main.BackgroundTransparency = 1
main.Active = true
main.Parent = gui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "VisualRbx (Silent)"
title.TextColor3 = Color3.fromRGB(0, 255, 136)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.BackgroundTransparency = 1
title.Parent = main

-- Функция анимации
local function toggleMenu()
    if getgenv().VisualRbx.HiddenForever then return end
    if not main.Visible then
        main.Visible = true
        for i = 1, 15 do
            main.BackgroundTransparency = 1 - (i / 15)
            wait(0.02)
        end
    else
        for i = 1, 15 do
            main.BackgroundTransparency = i / 15
            wait(0.02)
        end
        main.Visible = false
    end
end

toggleBtn.MouseButton1Click:Connect(toggleMenu)

-- Слайдер Current Robux
local currentLabel = Instance.new("TextLabel")
currentLabel.Size = UDim2.new(1, -40, 0, 25)
currentLabel.Position = UDim2.new(0, 20, 0, 55)
currentLabel.Text = "Current Robux: 22000"
currentLabel.TextColor3 = Color3.new(1, 1, 1)
currentLabel.BackgroundTransparency = 1
currentLabel.TextSize = 14
currentLabel.Font = Enum.Font.Gotham
currentLabel.Parent = main

-- Слайдер Add Robux
local addLabel = Instance.new("TextLabel")
addLabel.Size = UDim2.new(1, -40, 0, 25)
addLabel.Position = UDim2.new(0, 20, 0, 120)
addLabel.Text = "Add Robux: 20000"
addLabel.TextColor3 = Color3.new(1, 1, 1)
addLabel.BackgroundTransparency = 1
addLabel.TextSize = 14
addLabel.Font = Enum.Font.Gotham
addLabel.Parent = main

-- Кнопки
local function addButton(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 42)
    btn.Position = UDim2.new(0, 20, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = main
    btn.MouseButton1Click:Connect(callback)
end

addButton("Buy 1x", 175, function()
    getgenv().VisualRbx.Balance += getgenv().VisualRbx.AddRobuxVal
    print("Куплено! Баланс: " .. getgenv().VisualRbx.Balance)
end)

addButton("Buy 5x", 225, function()
    getgenv().VisualRbx.Balance += getgenv().VisualRbx.AddRobuxVal * 5
    print("Куплено 5x! Баланс: " .. getgenv().VisualRbx.Balance)
end)

addButton("Buy 10x", 275, function()
    getgenv().VisualRbx.Balance += getgenv().VisualRbx.AddRobuxVal * 10
    print("Куплено 10x! Баланс: " .. getgenv().VisualRbx.Balance)
end)

addButton("Set Balance", 325, function()
    print("Баланс установлен: " .. getgenv().VisualRbx.Balance)
end)

addButton("Fake DevEx", 375, function()
    print("Fake DevEx activated")
end)

addButton("Hide Forever", 425, function()
    getgenv().VisualRbx.HiddenForever = true
    main.Visible = false
end)

-- Горячая клавиша
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleMenu()
    end
end)

print("VisualRbx загружен. Зелёный квадратик 'VR' на экране.")
