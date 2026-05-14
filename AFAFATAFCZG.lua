getgenv().VisualRbx = getgenv().VisualRbx or {}
local Settings = getgenv().VisualRbx

Settings.CurrentFake = Settings.CurrentFake or 0
Settings.AddAmount = Settings.AddAmount or 10000
Settings.HiddenForever = false

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VisualRbx"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

-- Fake Robux Overlay
local FakeBalance = Instance.new("TextLabel")
FakeBalance.Size = UDim2.new(0, 130, 0, 26)
FakeBalance.Position = UDim2.new(0, 80, 0, 6)
FakeBalance.BackgroundTransparency = 1
FakeBalance.Text = tostring(Settings.CurrentFake)
FakeBalance.TextColor3 = Color3.fromRGB(255, 215, 80)
FakeBalance.Font = Enum.Font.GothamBold
FakeBalance.TextSize = 20
FakeBalance.TextStrokeTransparency = 0.5
FakeBalance.Parent = ScreenGui

-- Main GUI Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 360, 0, 260)
Main.Position = UDim2.new(0.5, -180, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Main.BackgroundTransparency = 1
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 8)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(80, 150, 255)
Stroke.Thickness = 1.2
Stroke.Transparency = 1

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -20, 0, 32)
Title.Position = UDim2.new(0, 15, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "VisualRbx (Silent Edition)"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15

-- Current Robux
local CurrentBox = Instance.new("TextBox", Main)
CurrentBox.Size = UDim2.new(0, 150, 0, 28)
CurrentBox.Position = UDim2.new(0, 190, 0, 50)
CurrentBox.PlaceholderText = "Current Robux"
CurrentBox.Text = tostring(Settings.CurrentFake)
CurrentBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
CurrentBox.TextColor3 = Color3.fromRGB(255,255,255)
CurrentBox.Font = Enum.Font.Gotham
CurrentBox.TextSize = 14
Instance.new("UICorner", CurrentBox).CornerRadius = UDim.new(0, 5)

CurrentBox.FocusLost:Connect(function()
    local num = tonumber(CurrentBox.Text)
    if num then
        Settings.CurrentFake = num
        FakeBalance.Text = tostring(num)
    end
end)

-- Add Amount
local AddBox = Instance.new("TextBox", Main)
AddBox.Size = UDim2.new(0, 150, 0, 28)
AddBox.Position = UDim2.new(0, 190, 0, 85)
AddBox.PlaceholderText = "Add Amount"
AddBox.Text = tostring(Settings.AddAmount)
AddBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
AddBox.TextColor3 = Color3.fromRGB(255,255,255)
AddBox.Font = Enum.Font.Gotham
AddBox.TextSize = 14
Instance.new("UICorner", AddBox).CornerRadius = UDim.new(0, 5)

AddBox.FocusLost:Connect(function()
    local num = tonumber(AddBox.Text)
    if num then Settings.AddAmount = num end
end)

-- Buttons
local function MakeButton(text, y, func)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 150, 0, 30)
    b.Position = UDim2.new(0, 20, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255,255,255)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Parent = Main
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    b.MouseButton1Click:Connect(func)
end

MakeButton("Buy 1x", 125, function()
    Settings.CurrentFake += Settings.AddAmount
    FakeBalance.Text = tostring(Settings.CurrentFake)
end)

MakeButton("Buy 5x", 162, function()
    for i = 1, 5 do
        Settings.CurrentFake += Settings.AddAmount
        FakeBalance.Text = tostring(Settings.CurrentFake)
        task.wait(0.12)
    end
end)

MakeButton("Buy 10x", 199, function()
    for i = 1, 10 do
        Settings.CurrentFake += Settings.AddAmount
        FakeBalance.Text = tostring(Settings.CurrentFake)
        task.wait(0.08)
    end
end)

MakeButton("Hide Forever", 236, function()
    Settings.HiddenForever = true
    TweenService:Create(Main, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Stroke, TweenInfo.new(0.25), {Transparency = 1}):Play()
    task.wait(0.3)
    ScreenGui.Enabled = false
end)

-- Toggle (RightControl + B)
local Open = false

UserInputService.InputBegan:Connect(function(input, g)
    if g then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Settings.Ctrl = true
    elseif Settings.Ctrl and input.KeyCode == Enum.KeyCode.B then
        if Settings.HiddenForever then return end
        Open = not Open
        
        local t = Open and 0.08 or 1
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundTransparency = t
        }):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {
            Transparency = Open and 0.6 or 1
        }):Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        Settings.Ctrl = false
    end
end)

-- Init
Main.BackgroundTransparency = 1
Stroke.Transparency = 1
FakeBalance.Text = tostring(Settings.CurrentFake)

print("VisualRbx loaded. Press RightControl + B")
