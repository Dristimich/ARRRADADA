getgenv().SecureMode = true

getgenv().VisualRbx = {
    HiddenForever = false,
    Balance = 22000,
    AddRobuxVal = 20000
}

-- Создаём GUI
local gui = Instance.new("ScreenGui")
gui.Name = "VisualRbx_Silent"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

-- === ПЛАВАЮЩАЯ КНОПКА ДЛЯ ТЕЛЕФОНА ===
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleButton"
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0, 25, 0, 180)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
toggleBtn.Text = "VR"
toggleBtn.TextColor3 = Color3.new(0, 0, 0)
toggleBtn.TextSize = 20
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Active = true
toggleBtn.Draggable = true
toggleBtn.Parent = gui

-- Главное меню
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 360, 0, 480)
main.Position = UDim2.new(0.5, -180, 0.5, -240)
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

-- Функция открытия/закрытия
local function toggleMenu()
    if getgenv().VisualRbx.HiddenForever then return end
    
    if not main.Visible then
        main.Visible = true
        for i = 1, 12 do
            main.BackgroundTransparency = 1 - (i / 12)
            wait(0.025)
        end
    else
        for i = 1, 12 do
            main.BackgroundTransparency = i / 12
            wait(0.025)
        end
        main.Visible = false
    end
end

toggleBtn.MouseButton1Click:Connect(toggleMenu)

-- Кнопки меню
local function addButton(text, y, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -40, 0, 42)
    btn.Position = UDim2.new(0, 20, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = main
    btn.MouseButton1Click:Connect(func)
end

addButton("Buy 1x", 60, function()
    getgenv().VisualRbx.Balance += getgenv().VisualRbx.AddRobuxVal
    print("Куплено! Баланс: " .. getgenv().VisualRbx.Balance)
end)

addButton("Buy 5x", 110, function()
    getgenv().VisualRbx.Balance += getgenv().VisualRbx.AddRobuxVal * 5
    print("Куплено 5x! Баланс: " .. getgenv().VisualRbx.Balance)
end)

addButton("Buy 10x", 160, function()
    getgenv().VisualRbx.Balance += getgenv().VisualRbx.AddRobuxVal * 10
    print("Куплено 10x! Баланс: " .. getgenv().VisualRbx.Balance)
end)

addButton("Hide Forever", 220, function()
    getgenv().VisualRbx.HiddenForever = true
    main.Visible = false
end)

-- Горячая клавиша (ПК)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleMenu()
    end
end)

print("VisualRbx загружен. Зелёный квадратик 'VR' должен быть виден.")
