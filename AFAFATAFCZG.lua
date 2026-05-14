local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- =========================
-- CONFIG
-- =========================

local KEY_FILE_NAME = "MxzyHub_Key.txt"
local GET_KEY_LINK = "http://mxzy.store/"
local VERIFY_URL = "https://mxzy.store/verify500.php"
local MAX_ATTEMPTS = 5

local attempts = 0

-- =========================
-- UI
-- =========================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MxzyKeySystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 320, 0, 220)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 0

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,12)

local uiStroke = Instance.new("UIStroke")
uiStroke.Parent = mainFrame
uiStroke.Color = Color3.fromRGB(0,255,136)
uiStroke.Thickness = 2

local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "MXZY HUB | KEY SYSTEM"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

local textbox = Instance.new("TextBox")
textbox.Parent = mainFrame
textbox.Size = UDim2.new(0.9,0,0,40)
textbox.Position = UDim2.new(0.05,0,0.28,0)
textbox.BackgroundColor3 = Color3.fromRGB(35,35,35)
textbox.TextColor3 = Color3.new(1,1,1)
textbox.PlaceholderText = "Enter your key here..."
textbox.Font = Enum.Font.Gotham
textbox.TextSize = 14
Instance.new("UICorner", textbox)

local verifyButton = Instance.new("TextButton")
verifyButton.Parent = mainFrame
verifyButton.Size = UDim2.new(0.9,0,0,40)
verifyButton.Position = UDim2.new(0.05,0,0.52,0)
verifyButton.BackgroundColor3 = Color3.fromRGB(0,255,136)
verifyButton.TextColor3 = Color3.new(0,0,0)
verifyButton.Font = Enum.Font.GothamBold
verifyButton.TextSize = 14
verifyButton.Text = "VERIFY KEY"
Instance.new("UICorner", verifyButton)

local getKeyButton = Instance.new("TextButton")
getKeyButton.Parent = mainFrame
getKeyButton.Size = UDim2.new(0.9,0,0,32)
getKeyButton.Position = UDim2.new(0.05,0,0.76,0)
getKeyButton.BackgroundColor3 = Color3.fromRGB(45,45,45)
getKeyButton.TextColor3 = Color3.new(1,1,1)
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextSize = 13
getKeyButton.Text = "GET KEY"
Instance.new("UICorner", getKeyButton)

local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.Size = UDim2.new(1,0,0,20)
statusLabel.Position = UDim2.new(0,0,0.92,0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255,255,255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12

-- =========================
-- FUNCTIONS
-- =========================

local function getHWID()
	return game:GetService("RbxAnalyticsService"):GetClientId()
end

local function notify(t, txt)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = t,
			Text = txt,
			Duration = 5
		})
	end)
end

local function requestPost(url, data)
	local req = (syn and syn.request) or request or http_request
	if not req then return nil end

	local res = req({
		Url = url,
		Method = "POST",
		Headers = {["Content-Type"] = "application/json"},
		Body = HttpService:JSONEncode(data)
	})

	if not res or not res.Body then return nil end
	return HttpService:JSONDecode(res.Body)
end

local function verifyKey(key)
	return requestPost(VERIFY_URL, {
		key = key,
		hwid = getHWID()
	})
end

local function saveKey(key)
	if writefile then
		writefile(KEY_FILE_NAME, key)
	end
end

local function loadKey()
	if isfile and isfile(KEY_FILE_NAME) then
		return readfile(KEY_FILE_NAME)
	end
end

local function deleteKey()
	if delfile and isfile and isfile(KEY_FILE_NAME) then
		delfile(KEY_FILE_NAME)
	end
end

-- =========================
-- RUN SCRIPT FROM SERVER (МОДИФИЦИРОВАННАЯ)
-- =========================

local function runScript(scriptSource)
	screenGui:Destroy()

	if scriptSource and scriptSource ~= "" then
		-- Сохраняем основной скрипт в файл
		if writefile then
			writefile("MxzyHub_MainScript.lua", scriptSource)
			print("[Mxzy] Основной скрипт сохранён в файл: MxzyHub_MainScript.lua")
		end

		-- Выводим скрипт в консоль
		print("========== ОСНОВНОЙ СКРИПТ ==========")
		print(scriptSource)
		print("========== КОНЕЦ СКРИПТА ==========")

		-- Запускаем
		local fn = loadstring(scriptSource)
		if fn then
			pcall(fn)
		else
			warn("Failed to load script")
		end
	end
end

local function onValid(res)
	saveKey(textbox.Text)
	notify("Mxzy Hub", "Key Verified")
	statusLabel.Text = "SUCCESS"
	task.wait(1)
	runScript(res.script)
end

local function invalid(msg)
	attempts += 1
	uiStroke.Color = Color3.fromRGB(255,80,80)
	statusLabel.Text = msg
	verifyButton.Text = "INVALID"
	notify("Mxzy Hub", msg .. " ("..attempts.."/"..MAX_ATTEMPTS..")")
	task.wait(1)
	verifyButton.Text = "VERIFY KEY"
	uiStroke.Color = Color3.fromRGB(0,255,136)

	if attempts >= MAX_ATTEMPTS then
		player:Kick("Too many attempts")
	end
end

-- =========================
-- VERIFY BUTTON
-- =========================

verifyButton.MouseButton1Click:Connect(function()
	local key = textbox.Text
	if key == "" then
		return invalid("ENTER KEY")
	end

	verifyButton.Text = "CHECKING..."
	verifyButton.Active = false

	local res = verifyKey(key)
	verifyButton.Active = true

	if res and res.success then
		onValid(res)
	else
		deleteKey()
		invalid(res and res.message or "FAILED")
	end
end)

-- =========================
-- GET KEY
-- =========================

getKeyButton.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(GET_KEY_LINK)
	end
	notify("Mxzy Hub", "Link copied")
end)

-- =========================
-- AUTO LOGIN
-- =========================

task.spawn(function()
	local saved = loadKey()
	if not saved then return end

	statusLabel.Text = "AUTO CHECK..."
	local res = verifyKey(saved)

	if res and res.success then
		runScript(res.script)
	else
		deleteKey()
		statusLabel.Text = "EXPIRED"
	end
end)
