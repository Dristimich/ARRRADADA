loadstring([[
getgenv().VisualRbx = getgenv().VisualRbx or {}
local s = getgenv().VisualRbx
s.Current = s.Current or 0
s.Add = s.Add or 10000
s.Hidden = false

local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local GUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
GUI.ResetOnSpawn = false
GUI.Name = "VisualRbxSilent"

local Fake = Instance.new("TextLabel", GUI)
Fake.Size = UDim2.new(0, 125, 0, 26)
Fake.Position = UDim2.new(0, 80, 0, 6)
Fake.BackgroundTransparency = 1
Fake.Text = tostring(s.Current)
Fake.TextColor3 = Color3.fromRGB(255, 210, 70)
Fake.Font = Enum.Font.GothamBold
Fake.TextSize = 19
Fake.TextStrokeTransparency = 0.6

local Main = Instance.new("Frame", GUI)
Main.Size = UDim2.new(0, 360, 0, 250)
Main.Position = UDim2.new(0.5, -180, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Main.BackgroundTransparency = 1
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 9)

local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(75, 145, 255)
Stroke.Thickness = 1.4
Stroke.Transparency = 1

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 32)
Title.Position = UDim2.new(0, 14, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "VisualRbx (Silent Edition)"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 15

local function MakeBox(y, placeholder, default)
    local box = Instance.new("TextBox", Main)
    box.Size = UDim2.new(0, 150, 0, 27)
    box.Position = UDim2.new(0, 190, 0, y)
    box.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
    box.Text = tostring(default)
    box.TextColor3 = Color3.fromRGB(255,255,255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.PlaceholderText = placeholder
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
    return box
end

local CurBox = MakeBox(48, "Current Robux", s.Current)
local AddBox = MakeBox(82, "Add Amount", s.Add)

CurBox.FocusLost:Connect(function()
    local n = tonumber(CurBox.Text)
    if n then s.Current = n; Fake.Text = tostring(n) end
end)

AddBox.FocusLost:Connect(function()
    local n = tonumber(AddBox.Text)
    if n then s.Add = n end
end)

local function MakeBtn(y, text, callback)
    local btn = Instance.new("TextButton", Main)
    btn.Size = UDim2.new(0, 150, 0, 29)
    btn.Position = UDim2.new(0, 18, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(42, 42, 50)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
    btn.MouseButton1Click:Connect(callback)
end

MakeBtn(120, "Buy 1x", function() s.Current += s.Add; Fake.Text = s.Current end)
MakeBtn(154, "Buy 5x", function() for i=1,5 do s.Current += s.Add; Fake.Text = s.Current task.wait(0.1) end end)
MakeBtn(188, "Buy 10x", function() for i=1,10 do s.Current += s.Add; Fake.Text = s.Current task.wait(0.07) end end)
MakeBtn(222, "Hide Forever", function()
    s.Hidden = true
    TS:Create(Main, TweenInfo.new(0.25), {BackgroundTransparency=1}):Play()
    TS:Create(Stroke, TweenInfo.new(0.25), {Transparency=1}):Play()
    task.wait(0.3)
    GUI.Enabled = false
end)

-- Toggle RightControl + B
local open = false
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightControl then s.Ctrl = true end
    if s.Ctrl and input.KeyCode == Enum.KeyCode.B and not s.Hidden then
        open = not open
        local t = open and 0.08 or 1
        TS:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {BackgroundTransparency = t}):Play()
        TS:Create(Stroke, TweenInfo.new(0.3), {Transparency = open and 0.6 or 1}):Play()
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then s.Ctrl = false end
end)

Fake.Text = tostring(s.Current)
print("VisualRbx Silent loaded")
]])()
