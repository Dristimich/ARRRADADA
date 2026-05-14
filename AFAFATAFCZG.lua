--[[
    VisualRbx (Silent Edition) v2 - Fixed
    Полностью самостоятельный скрипт (без внешних библиотек)
]]

getgenv().VisualRbx = getgenv().VisualRbx or {}
local Settings = getgenv().VisualRbx

Settings.CurrentFake = Settings.CurrentFake or 0
Settings.AddAmount = Settings.AddAmount or 10000
Settings.HiddenForever = false

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VisualRbx_Silent"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = gethui and gethui() or game:GetService("CoreGui")

-- ===================== FAKE ROBUX OVERLAY =====================
local FakeRobux = Instance.new("TextLabel")
FakeRobux.Name = "FakeBalance"
FakeRobux.Size = UDim2.new(0, 120, 0, 28)
FakeRobux.Position = UDim2.new(0, 85, 0, 5)
FakeRobux.BackgroundTransparency = 1
FakeRobux.Text = tostring(Settings.CurrentFake)
FakeRobux.TextColor3 = Color3.fromRGB(255, 220, 100)
FakeRobux.Font = Enum.Font.GothamBold
FakeRobux.TextSize = 20
FakeRobux.TextStrokeTransparency = 0.6
FakeRobux.ZIndex = 999999
FakeRobux.Parent = ScreenGui

-- ===================== MAIN GUI =====================
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 380, 0, 280)
Main.Position = UDim2.new(0.5, -190, 0.5, -140)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner", Main)
Corner.CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(70, 140, 255)
Stroke.Thickness = 1.5
Stroke.Transparency = 1

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -20, 0, 35)
Title.Position = UDim2.new(0, 15, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "VisualRbx <font color='#4d9eff'>(Silent)</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ===================== CONTROLS =====================
local function CreateButton(text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 160, 0, 32)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = Main
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Current Robux (TextBox)
local CurrentBox = Instance.new("TextBox", Main)
CurrentBox.Size = UDim2.new(0, 160, 0, 30)
CurrentBox.Position = UDim2.new(0, 200, 0, 50)
CurrentBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
CurrentBox.Text = tostring(Settings.CurrentFake)
CurrentBox.TextColor3 = Color3.fromRGB(255,255,255)
CurrentBox.Font = Enum.Font.Gotham
CurrentBox.TextSize = 14
CurrentBox.PlaceholderText = "Current Robux"
Instance.new("UICorner", CurrentBox).CornerRadius = UDim.new(0, 6)

CurrentBox.FocusLost:Connect(function()
    local num = tonumber(CurrentBox.Text)
    if num then
        Settings.CurrentFake = num
        FakeRobux.Text = tostring(num)
    end
end)

-- Add Amount
local AddBox = Instance.new("TextBox", Main)
AddBox.Size = UDim2.new(0, 160, 0, 30)
AddBox.Position = UDim2.new(0, 200, 0, 90)
AddBox.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
AddBox.Text = tostring(Settings.AddAmount)
AddBox.TextColor3 = Color3.fromRGB(255,255,255)
AddBox.Font = Enum.Font.Gotham
AddBox.TextSize = 14
AddBox.PlaceholderText = "Add Amount"
Instance.new("UICorner", AddBox).CornerRadius = UDim.new(0, 6)

AddBox.FocusLost:Connect(function()
    local num = tonumber(AddBox.Text)
    if num then Settings.AddAmount = num end
end)

-- Buttons
CreateButton("Buy 1x", 130, function()
    Settings.CurrentFake += Settings.AddAmount
    FakeRobux.Text = tostring(Settings.CurrentFake)
end)

CreateButton("Buy 5x", 170, function()
    for i = 1, 5 do
        Settings.CurrentFake += Settings.AddAmount
        FakeRobux.Text = tostring(Settings.CurrentFake)
        task.wait(0.15)
    end
end)

CreateButton("Buy 10x", 210, function()
    for i = 1, 10 do
        Settings.CurrentFake += Settings.AddAmount
        FakeRobux.Text = tostring(Settings.CurrentFake)
        task.wait(0.1)
    end
end)

CreateButton("Hide Forever", 250, function()
    Settings.HiddenForever = true
    TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    task.wait(0.35)
    ScreenGui.Enabled = false
end)

-- ===================== TOGGLE (RightControl + B) =====================
local isOpen = false

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        Settings.ControlHeld = true
    elseif Settings.ControlHeld and input.KeyCode == Enum.KeyCode.B then
        if Settings.HiddenForever then return end
        
        isOpen = not isOpen
        
        local targetTransparency = isOpen and 0.05 or 1
        local strokeTransparency = isOpen and 0.65 or 1
        
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
            BackgroundTransparency = targetTransparency
        }):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {
            Transparency = strokeTransparency
        }):Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        Settings.ControlHeld = false
    end
end)

-- ===================== INIT =====================
Main.BackgroundTransparency = 1
Stroke.Transparency = 1
FakeRobux.Text = tostring(Settings.CurrentFake)

print("VisualRbx Silent Edition loaded. Press RightControl + B")
