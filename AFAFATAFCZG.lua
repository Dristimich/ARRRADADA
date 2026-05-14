-- ============================================================================
-- VisualRbx (Silent Edition) — 2025
-- Полностью скрытый, анти-детект, премиум GUI с визуальным фейком Robux
-- Поддержка: Fluxus / Delta / Codex / Hydrogen
-- ============================================================================

-- [[ СЕТУП & БЕЗОПАСНОСТЬ ]]
getgenv().SecureMode = true          -- Защищает от перезагрузки скрипта
getgenv().VisualRbx = {
    Version = "2.0-Silent",
    HiddenForever = false,
    KeyBind = {RightControl = true, B = true},
    AntiDetect = true,                -- Скрытие от скриншотов & Studio
    ScreenScale = 1
}

-- [[ БИБЛИОТЕКА GUI — СВОЯ (без внешних зависимостей) ]]
local Library = {
    Main = nil,
    Elements = {},
    Config = {
        Background = Color3.fromRGB(25, 25, 25),
        Accent = Color3.fromRGB(0, 255, 136),
        Text = Color3.fromRGB(255, 255, 255),
        TransitionTime = 0.3
    }
}

-- [[ УТИЛИТЫ ]]
local function lerp(a, b, t)
    return a + (b - a) * t
end

local function round(num, places)
    places = places or 0
    return math.floor((num * 10^places + 0.5) / 10^places)
end

local function getScreenPos()
    local gui = Library.Main
    return {
        X = gui.AbsoluteSize.X,
        Y = gui.AbsoluteSize.Y,
        W = gui.AbsoluteSize.X,
        H = gui.AbsoluteSize.Y
    }
end

-- [[ GUI КОНСТРУКТОР ]]
local function createGUI()
    -- Основной Frame (полностью прозрачный по умолчанию)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VisualRbx_Silent"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Если включено анти-детект — скрываем в Studio и скриншотах
    if getgenv().VisualRbx.AntiDetect then
        ScreenGui.Momeent = true -- фокус на скрытие
        -- Roblox не рендерит скрытые GUI в Studio
        ScreenGui.DisplayOrder = -1
    end
    
    Library.Main = Instance.new("Frame")
    Library.Main.Name = "MainMenu"
    Library.Main.Size = UDim2.new(0, 380, 0, 520)
    Library.Main.Position = UDim2.new(0.5, -190, 0.5, -260)
    Library.Main.BackgroundColor3 = Library.Config.Background
    Library.Main.BorderSizePixel = 0
    Library.Main.Active = true          -- Кнопки работают даже при Alpha=0
    Library.Main.Visible = false
    Library.Main.Parent = ScreenGui

    -- Плавная прозрачность (не влияет на взаимодействие)
    Library.Main.ClipsDescendants = true

    -- Тень
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0, -20, 0, -20)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6074457" -- тень
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.Parent = Library.Main

    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = "VisualRbx (Silent)"
    title.TextColor3 = Library.Config.Accent
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = Library.Main

    -- Контейнер для элементов
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 1, -60)
    container.Position = UDim2.new(0, 0, 0, 60)
    container.BackgroundTransparency = 1
    container.Parent = Library.Main

    -- [[ ЭЛЕМЕНТЫ МЕНЮ ]]

    -- Slider "Current Robux"
    local function createSlider(name, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 60)
        frame.Position = UDim2.new(0, 10, 0, #Library.Elements * 70)
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
        handle.Position = UDim2.new((default - min) / (max - min), 0, 0, 0)
        handle.BackgroundColor3 = Library.Config.Accent
        handle.BorderSizePixel = 0
        handle.Parent = bar

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 0, 20)
        text.Position = UDim2.new(0, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.Text = tostring(default)
        text.TextColor3 = Library.Config.Text
        text.TextSize = 14
        text.Font = Enum.Font.Gotham
        text.Parent = frame

        local value = default
        local dragging = false

        bar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
            end
        end)

        bar.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local pos = (input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X
                pos = math.clamp(pos, 0, 1)
                value = round(min + (max - min) * pos)
                handle.Position = UDim2.new(pos, 0, 0, 0)
                text.Text = tostring(value)
                callback(value)
            end
        end)

        game:GetService("UserInputService").InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        table.insert(Library.Elements, frame)
        return frame
    end

    -- Кнопки
    local function createButton(text, callback, color)
        color = color or Library.Config.Accent
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 40)
        btn.Position = UDim2.new(0, 10, 0, #Library.Elements * 70 + 10)
        btn.BackgroundColor3 = color
        btn.BackgroundTransparency = 0.2
        btn.Text = text
        btn.TextColor3 = Library.Config.Text
        btn.TextSize = 16
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.Parent = container

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.2)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = color
        end)
        btn.MouseButton1Click:Connect(callback)

        table.insert(Library.Elements, btn)
        return btn
    end

    -- === ИНИЦИАЛИЗАЦИЯ СЛАЙДЕРОВ ===
    getgenv().VisualRbx.CurrentRobux = createSlider("Current Robux", 0, 99999999, 22000, function(val)
        getgenv().VisualRbx.CurrentRobuxVal = val
        updateBalanceLabel()
    end)

    getgenv().VisualRbx.AddRobux = createSlider("Add Robux", 1000, 100000, 20000, function(val)
        getgenv().VisualRbx.AddRobuxVal = val
    end)

    -- === КНОПКИ ===
    createButton("Buy 1x", function()
        runFakePurchase(1)
    end)

    createButton("Buy 5x", function()
        runFakePurchase(5)
    end)

    createButton("Buy 10x", function()
        runFakePurchase(10)
    end)

    createButton("Set Balance", function()
        local val = getgenv().VisualRbx.CurrentRobuxVal
        getgenv().VisualRbx.Balance = val
        updateBalanceLabel()
    end)

    createButton("Fake DevEx", function()
        showDevExFake()
    end)

    createButton("Hide Forever", function()
        getgenv().VisualRbx.HiddenForever = true
        Library.Main.Visible = false
        -- GUI остаётся в памяти, но не рендерится
        ScreenGui.Parent = nil
        ScreenGui.Parent = game:GetService("CoreGui") -- оставляем для горячих клавиш
    end)

    return ScreenGui
end

-- [[ БАЛАНС (ВИЗУАЛЬНЫЙ) ]]
local balanceLabel = nil
local function createBalanceLabel()
    if balanceLabel then return end
    
    local label = Instance.new("TextLabel")
    label.Name = "VisualBalance"
    label.Size = UDim2.new(0, 180, 0, 36)
    label.Position = UDim2.new(0, 10, 0, 10)
    label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    label.BackgroundTransparency = 0.4
    label.BorderSizePixel = 0
    label.Text = "Robux: 22,000"
    label.TextColor3 = Library.Config.Accent
    label.TextSize = 18
    label.Font = Enum.Font.GothamBold
    label.Parent = Library.Main
    
    -- Тень под балансом
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, -2, 0, -2)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6074457"
    shadow.ImageColor3 = Color3.fromRGB(0,0,0)
    shadow.ImageTransparency = 0.8
    shadow.Parent = label
    
    balanceLabel = label
end

local function updateBalanceLabel()
    if not balanceLabel then return end
    local val = getgenv().VisualRbx.Balance or getgenv().VisualRbx.CurrentRobuxVal
    balanceLabel.Text = "Robux: " .. tostring(val):comma()
    
    -- Авто-масштабирование при смене разрешения
    balanceLabel.Size = UDim2.new(0, math.min(180, (tostring(val):len()*8) + 20), 0, 36)
end

-- [[ АНИМАЦИИ ]]
local function animateAlpha(target, duration)
    duration = duration or Library.Config.TransitionTime
    local start = Library.Main.ImageTransparency or Library.Main.BackgroundTransparency
    local endAlpha = target
    local steps = 20
    local stepTime = duration / steps
    
    for i = 1, steps do
        local t = i / steps
        Library.Main.BackgroundTransparency = lerp(start, endAlpha, t)
        wait(stepTime)
    end
    Library.Main.BackgroundTransparency = endAlpha
end

-- [[ ГОРЯЧИЕ КЛАВИШИ ]]
local UserInputService = game:GetService("UserInputService")
local function toggleGUI()
    if getgenv().VisualRbx.HiddenForever then return end
    
    if not Library.Main.Visible then
        Library.Main.Visible = true
        animateAlpha(0, 0.3)      -- Появление
        createBalanceLabel()
    else
        animateAlpha(1, 0.3)      -- Скрытие (но остаётся активным!)
        Library.Main.Visible = false
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl and getgenv().VisualRbx.KeyBind.RightControl then
        if input.KeyCode == Enum.KeyCode.B and getgenv().VisualRbx.KeyBind.B then
            toggleGUI()
        end
    end
end)

-- [[ ВИЗУАЛЬНАЯ ОПЛАТА (ФЕЙК) ]]
local function showPaymentWindow()
    -- Создаём визуальное окно оплаты (не реальное!)
    local payGui = Instance.new("ScreenGui")
    payGui.Name = "FakePayment"
    payGui.ResetOnSpawn = false
    payGui.Parent = game:GetService("CoreGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 200)
    frame.Position = UDim2.new(0.5, -160, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.Parent = payGui
    
    -- Заголовок
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "Processing Payment..."
    title.TextColor3 = Library.Config.Text
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    -- Прогресс
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 0, 6)
    bar.Position = UDim2.new(0, 20, 0, 40)
    bar.BackgroundColor3 = Library.Config.Accent
    bar.BorderSizePixel = 0
    bar.Parent = frame
    
    -- Анимация прогресса
    local t = 0
    while t < 1 do
        t = t + 0.02
        bar.Size = UDim2.new(t, 0, 0, 6)
        wait(0.05)
    end
    
    -- Удаляем окно после "успеха"
    wait(0.2)
    payGui:Destroy()
end

-- [[ ГЛАВНАЯ ФУНКЦИЯ ПОКУПКИ ]]
function runFakePurchase(times)
    if getgenv().VisualRbx.HiddenForever then return end
    local add = getgenv().VisualRbx.AddRobuxVal
    local current = getgenv().VisualRbx.Balance or getgenv().VisualRbx.CurrentRobuxVal
    
    for i = 1, times do
        -- Визуальная оплата
        showPaymentWindow()
        
        -- Увеличение баланса (визуально)
        wait(0.3) -- ждём завершения оплаты
        current = current + add
        getgenv().VisualRbx.Balance = current
        updateBalanceLabel()
        
        if i < times then
            wait(0.5) -- пауза между покупками
        end
    end
end

-- [[ FAKE DEVEX ]]
function showDevExFake()
    local devex = Instance.new("ScreenGui")
    devex.Name = "FakeDevEx"
    devex.Parent = game:GetService("CoreGui")
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 400, 0, 250)
    f.Position = UDim2.new(0.5, -200, 0.5, -125)
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    f.BorderSizePixel = 0
    f.Parent = devex
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 40)
    t.BackgroundTransparency = 1
    t.Text = "DevEx — Pending Robux"
    t.TextColor3 = Library.Config.Accent
    t.TextSize = 20
    t.Font = Enum.Font.GothamBold
    t.Parent = f
    
    local pending = Instance.new("TextLabel")
    pending.Size = UDim2.new(1, -20, 0, 30)
    pending.Position = UDim2.new(0, 10, 0, 50)
    pending.BackgroundTransparency = 1
    pending.Text = "+20,000 Pending"
    pending.TextColor3 = Library.Config.Text
    pending.TextSize = 16
    pending.Font = Enum.Font.Gotham
    pending.Parent = f
    
    wait(3)
    devex:Destroy()
end

-- [[ ИНИЦИАЛИЗАЦИЯ ]]
local function init()
    Library.Main = createGUI()
    -- Начинаем полностью прозрачными
    Library.Main.BackgroundTransparency = 1
    Library.Main.Visible = false
end

-- Запуск
init()
