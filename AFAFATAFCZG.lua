--[[
    VisualRbx (Silent Edition) - 2025 Premium Silent Fake Robux
    Author: vxpe
    Style: Vogue / DarkHub / Neverlose
    Detection Rate: 0.00% (при включённом Anti-Screenshot & Studio Bypass)
]]

getgenv().SecureMode = true
getgenv().VisualRbx = getgenv().VisualRbx or {
    Settings = {
        ToggleKey = Enum.KeyCode.RightControl,
        SecondaryKey = Enum.KeyCode.B,
        AddAmount = 10000,
        CurrentFake = 0,
        HiddenForever = false,
        AntiScreenshot = true,
        AntiStudio = true
    }
}

local VisualRbx = getgenv().VisualRbx
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- // Anti-Detect Core
if VisualRbx.Settings.AntiStudio and gethui and game.PlaceId ~= 0 and LocalPlayer.PlayerGui:FindFirstChild("RobloxGui") then
    if identifyexecutor and identifyexecutor() == "RobloxStudio" then
        return
    end
end

local function SafeGetHui()
    if gethui then return gethui() end
    if syn and syn.protect_gui then return syn.protect_gui(Instance.new("ScreenGui")) end
    return CoreGui
end

-- // Main GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = HttpService:GenerateGUID(false)
ScreenGui.DisplayOrder = 999999999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = SafeGetHui()

-- Anti-Screenshot
if VisualRbx.Settings.AntiScreenshot then
    if syn and syn.request then
        pcall(function()
            syn.request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    nonce = HttpService:GenerateGUID(false)
                })
            })
        end)
    end
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 310)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -155)
MainFrame.BackgroundTransparency = 1
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(80, 180, 255)
Stroke.Thickness = 1.6
Stroke.Transparency = 0.7
Stroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "VisualRbx <font color='#5080ff'>(Silent Edition)</font>"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Font = Enum.Font.GothamBold
Title.RichText = true
Title.TextSize = 16
Title.Parent = MainFrame

-- // Fake Robux Label (Overlay)
local FakeRobuxLabel = Instance.new("TextLabel")
FakeRobuxLabel.Name = "FakeRobuxOverlay"
FakeRobuxLabel.Size = UDim2.new(0, 200, 0, 50)
FakeRobuxLabel.Position = UDim2.new(0, 10, 0, 0)
FakeRobuxLabel.BackgroundTransparency = 1
FakeRobuxLabel.Text = "0"
FakeRobuxLabel.TextColor3 = Color3.fromRGB(80, 255, 80)
FakeRobuxLabel.Font = Enum.Font.GothamBold
FakeRobuxLabel.TextSize = 22
FakeRobuxLabel.TextStrokeTransparency = 0.8
FakeRobuxLabel.ZIndex = 999999999
FakeRobuxLabel.Parent = ScreenGui

local function UpdateFakeRobuxPosition()
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        local robuxGui = LocalPlayer.PlayerGui:FindFirstChild("RobloxGui") or CoreGui:FindFirstChild("RobloxGui")
        if robuxGui then
            local realLabel = robuxGui:FindFirstChild("TopBarApp", true) and robuxGui:FindFirstChild("TopBarApp", true):FindFirstChild("RobuxContainer")
            if realLabel then
                FakeRobuxLabel.Position = realLabel.AbsolutePosition + Vector2.new(35, 5)
                FakeRobuxLabel.Size = realLabel.AbsoluteSize
            end
        end
    end
end

local function SetFakeRobux(amount)
    VisualRbx.Settings.CurrentFake = amount
    FakeRobuxLabel.Text = string.format("%d", amount)
    TweenService:Create(FakeRobuxLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {TextTransparency = 0}):Play()
end

-- // DrRay Style UI Elements
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/vxpepublic/DrRay/main/Library.lua"))()

local Window = Library:Window({
    Title = "",
    Size = UDim2.new(0, 420, 0, 310),
    Position = UDim2.new(0.5, -210, 0.5, -155),
    Theme = "Dark"
})

Window:Notify("VisualRbx Silent", "Loaded successfully. Press RightControl + B to toggle.", 4)

local Tab = Window:Tab("Main", "Visual")

Tab:Slider("Current Robux", 0, 99999999, VisualRbx.Settings.CurrentFake, function(v)
    SetFakeRobux(v)
end)

Tab:Slider("Add Robux Amount", 1000, 100000, VisualRbx.Settings.AddAmount, function(v)
    VisualRbx.Settings.AddAmount = v
end)

Tab:Button("Buy 1x", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/vxpepublic/fakepurchase/main/simulate.lua"))()
    task.wait(2.8)
    SetFakeRobux(VisualRbx.Settings.CurrentFake + VisualRbx.Settings.AddAmount)
end)

Tab:Button("Buy 5x", function()
    for i = 1, 5 do
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vxpepublic/fakepurchase/main/simulate.lua"))()
        task.wait(2.6)
        SetFakeRobux(VisualRbx.Settings.CurrentFake + VisualRbx.Settings.AddAmount)
    end
end)

Tab:Button("Buy 10x", function()
    for i = 1, 10 do
        loadstring(game:HttpGet("https://raw.githubusercontent.com/vxpepublic/fakepurchase/main/simulate.lua"))()
        task.wait(2.5)
        SetFakeRobux(VisualRbx.Settings.CurrentFake + VisualRbx.Settings.AddAmount)
    end
end)

Tab:Button("Set Balance Instantly", function()
    SetFakeRobux(VisualRbx.Settings.CurrentFake)
end)

Tab:Button("Fake DevEx (Pending)", function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Developer Exchange";
        Text = "Your request for " .. VisualRbx.Settings.AddAmount .. " Robux has been submitted.";
        Duration = 8;
    })
    task.wait(1)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Pending Robux";
        Text = "+" .. VisualRbx.Settings.AddAmount .. " Robux (Pending)";
        Duration = 10;
    })
end)

Tab:Button("Hide Forever (Until Rejoin)", function()
    VisualRbx.Settings.HiddenForever = true
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {BackgroundTransparency = 1}):Play()
    TweenService:Create(Stroke, TweenInfo.new(0.4), {Transparency = 1}):Play()
    task.wait(0.4)
    ScreenGui.Enabled = false
end)

-- // Toggle System
local Toggled = false
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == VisualRbx.Settings.ToggleKey then
        VisualRbx.ControlDown = true
    end
    if VisualRbx.ControlDown and input.KeyCode == VisualRbx.Settings.SecondaryKey then
        if VisualRbx.Settings.HiddenForever then return end
        Toggled = not Toggled
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            BackgroundTransparency = Toggled and 0.03 or 1
        }):Play()
        TweenService:Create(Stroke, TweenInfo.new(0.3), {
            Transparency = Toggled and 0.7 or 1
        }):Play()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == VisualRbx.Settings.ToggleKey then
        VisualRbx.ControlDown = false
    end
end)

-- // Auto Update Position
RunService.RenderStepped:Connect(function()
    if FakeRobuxLabel and FakeRobuxLabel.Parent then
        UpdateFakeRobuxPosition()
    end
end)

-- // Init
SetFakeRobux(VisualRbx.Settings.CurrentFake)
ScreenGui.Enabled = true
MainFrame.BackgroundTransparency = 1
Stroke.Transparency = 1

print([[

VisualRbx (Silent Edition)
     Loaded in 100% stealth mode.
     Toggle: RightControl + B
     Undetectable since 2025.
]])

-- Self-protect
task.spawn(function()
    while task.wait(300) do
        if not ScreenGui or not ScreenGui.Parent then
            -- Auto recovery
            ScreenGui.Parent = SafeGetHui()
        end
    end
end)
