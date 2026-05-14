-- ============================================================================
-- VisualRbx (Silent Edition) v2.2 — Полная рабочая версия + Кнопка для телефона
-- ============================================================================

getgenv().SecureMode = true

getgenv().VisualRbx = {
    Version = "2.2-Silent",
    HiddenForever = false,
    KeyBind = {RightControl = true, B = true},
    AntiDetect = true,
    CurrentRobuxVal = 22000,
    AddRobuxVal = 20000,
    Balance = 22000
}

local Library = {
    Main = nil,
    Config = {
        Background = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(0, 255, 136),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

local function formatNumber(n)
    local s = tostring(math.floor(n))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos) .. string.gsub(string.sub(s, pos + 1), "(...)", ",%1")
end

local function createGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VisualRbx_Silent"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = game:GetService("CoreGui")

    if getgenv().VisualRbx.AntiDetect then
        ScreenGui.DisplayOrder = -1
    end

    local Main = Instance.new("Frame")
    Main.Name = "MainMenu"
    Main.Size = UDim2.new(0, 380, 0, 520)
    Main.Position = UDim2.new(0.5, -190, 0.5, -260)
    Main.BackgroundColor3 = Library.Config.Background
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Visible = false
    Main.BackgroundTransparency = 1
    Main.Parent = ScreenGui

    Library.Main = Main

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "VisualRbx (Silent)"
    title.TextColor3 = Library.Config.Accent
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = Main

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, -60)
    container.Position = UDim2.new(0, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = Main

    -- Слайдеры
    local function createSlider(name, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 60)
        frame.Position = UDim2.new(0, 10, 0, #container:GetChildren() * 70)
        frame.BackgroundTransparency = 1
        frame.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Library.Config.Text
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.Parent = frame

        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, 6)
        bar.Position = UDim2.new(0, 0, 0, 25)
        bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        bar.BorderSizePixel = 0
        bar.Parent = frame

        local handle = Instance.new("Frame")
        handle.Size = UDim2.new(0, 12, 1, 0)
        handle.BackgroundColor3 = Library.Config.Accent
        handle.BorderSizePixel = 0
        handle.Parent = bar

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 0, 20)
        textLabel.Position = UDim2.new(0, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = tostring(default)
        textLabel.TextColor3 = Library.Config.Text
        textLabel.TextSize = 14
        textLabel.Font = Enum.Font.Gotham
        textLabel.Parent = frame

        local value = default
        local dragging = false

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)

        bar.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                value = math.floor(min + (max - min) * pos)
                handle.Position = UDim2.new(pos, 0, 0, 0)
                textLabel.Text = tostring(value)
                callback(value)
            end
        end)

        game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    createSlider("Current Robux", 0, 99999999, 22000, function(val)
        getgenv().VisualRbx.CurrentRobuxVal = val
        getgenv().VisualRbx.Balance = val
    end)

    createSlider("Add Robux", 1000, 100000, 20000, function(val)
        getgenv().VisualRbx.AddRobuxVal = val
    end)

    -- Кнопки
    local function createButton(text, callback, color)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, #container:GetChildren() * 70 + 10)
        btn.BackgroundColor3 = color or Library.Config.Accent
        btn.BackgroundTransparency = 0.2
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 16
        btn.Font = Enum.Font.GothamBold
        btn.Parent = container
        btn.MouseButton1Click:Connect(callback)
    end

    createButton("Buy 1x", function() runFakePurchase(1) end)
    createButton("Buy 5x", function() runFakePurchase(5) end)
    createButton("Buy 10x", function() runFakePurchase(10) end)
    createButton("Set Balance", function()
        getgenv().VisualRbx.Balance = getgenv().VisualRbx.CurrentRobuxVal
    end)
    createButton("Fake DevEx", function() showDevExFake() end)
    createButton("Hide Forever", function()
        getgenv().VisualRbx.HiddenForever = true
        Main.Visible = false
    end)

    return ScreenGui
end

-- Визуальный баланс
local balanceLabel
local function updateBalanceLabel()
    if not balanceLabel then return end
    balanceLabel.Text = "Robux: " .. formatNumber(getgenv().VisualRbx.Balance)
end

local function createBalanceLabel()
    if balanceLabel then return end
    balanceLabel = Instance.new("TextLabel")
    balanceLabel.Size = UDim2.new(0, 180, 0, 36)
    balanceLabel.Position = UDim2.new(0, 10, 0, 10)
    balanceLabel.BackgroundTransparency = 0.4
    balanceLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    balanceLabel.Text = "Robux: 22,000"
    balanceLabel.TextColor3 = Library.Config.Accent
    balanceLabel.TextSize = 18
    balanceLabel.Font = Enum.Font.GothamBold
    balanceLabel.Parent = Library.Main
end

-- Плавное открытие/закрытие
local function toggleGUI()
    if getgenv().VisualRbx.HiddenForever then return end
    local main = Library.Main
    if not main.Visible then
        main.Visible = true
        for i = 1, 15 do
            main.BackgroundTransparency = 1 - (i / 15)
            wait(0.02)
        end
        createBalanceLabel()
    else
        for i = 1, 15 do
            main.BackgroundTransparency = i / 15
            wait(0.02)
        end
        main.Visible = false
    end
end

-- Горячие клавиши
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        toggleGUI()
    end
end)

-- === КВАДРАТИК ДЛЯ ТЕЛЕФОНА (плавающая кнопка) ===
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0, 200)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
toggleButton.Text = "VR"
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Active = true
toggleButton.Draggable = true
toggleButton.Parent = game:GetService("CoreGui")

toggleButton.MouseButton1Click:Connect(function()
    toggleGUI()
end)

-- Долгий тап (дополнительно)
local touchTime = 0
game:GetService("UserInputService").TouchStarted:Connect(function()
    touchTime = tick()
end)
game:GetService("UserInputService").TouchEnded:Connect(function()
    if tick() - touchTime > 2.5 and not getgenv().VisualRbx.HiddenForever then
        toggleGUI()
    end
end)

-- Функции покупки
function runFakePurchase(times)
    if getgenv().VisualRbx.HiddenForever then return end
    local add = getgenv().VisualRbx.AddRobuxVal or 20000

    for i = 1, times do
        local pay = Instance.new("ScreenGui")
        pay.Parent = game:GetService("CoreGui")
        local f = Instance.new("Frame", pay)
        f.Size = UDim2.new(0, 300, 0, 160)
        f.Position = UDim2.new(0.5, -150, 0.5, -80)
        f.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

        local txt = Instance.new("TextLabel", f)
        txt.Size = UDim2.new(1, 0, 0, 40)
        txt.Text = "Processing Payment..."
        txt.TextColor3 = Color3.new(1, 1, 1)
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = 18
        txt.BackgroundTransparency = 1

        wait(1.2)
        pay:Destroy()

        getgenv().VisualRbx.Balance = (getgenv().VisualRbx.Balance or 0) + add
        updateBalanceLabel()
        wait(0.4)
    end
end

function showDevExFake()
    local dev = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local f = Instance.new("Frame", dev)
    f.Size = UDim2.new(0, 380, 0, 200)
    f.Position = UDim2.new(0.5, -190, 0.5, -100)
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, 0, 0, 40)
    t.Text = "DevEx — Pending Robux"
    t.TextColor3 = Library.Config.Accent
    t.Font = Enum.Font.GothamBold
    t.TextSize = 20
    t.BackgroundTransparency = 1

    wait(2.5)
    dev:Destroy()
end

-- Запуск
createGUI()
print("VisualRbx загружен. Зелёный квадратик 'VR' — открыть меню.")
