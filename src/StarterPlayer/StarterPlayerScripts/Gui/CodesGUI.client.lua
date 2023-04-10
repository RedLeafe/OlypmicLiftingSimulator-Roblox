local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Settings = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("CodesConfig"))
local player = Players.LocalPlayer

local ButtonGui = PlayerGui:WaitForChild("Left")
local OpenButton = ButtonGui.Frame.Buttons.Codes

local screenGUI = PlayerGui:WaitForChild("Settings")
local frame = screenGUI.Frame
local textBox = frame.TextBox
local redeemButton = frame.Redeem
local resultText = frame.Result

local exitButton = frame.ExitButton --Might need to change
local contianer = frame.Container.Container

local SUCCESSCOLOR = Color3.fromRGB(47, 214, 28)
local FAILCOLOR = Color3.fromRGB(214, 0, 3)

local function DisplayerResult(text: string, color: Color3)
	resultText.Text = text
	resultText.TextColor3 = color
	resultText.Visible = true
	task.delay(3, function()
		resultText.Visible = false
	end)
end

redeemButton.MouseButton1Click:Connect(function()
	local result = Remotes.RedeemCode:InvokeServer(textBox.Text)
	if result == "DOES NOT EXIST" then
		DisplayResult("Invalid Code!", FAILCOLOR)
	elseif result == "ALREADY REDEEMED" then
		DisplayResult("Already Redeemed!", FAILCOLOR)
	else if result == "REDEEMED" then
		DisplayResult("Redeemed!", SUCCESSCOLOR)
	end
end)

-- Open and Close Settings Menu
OpenButton.MouseButton1Click:Connect(function()
	RebirthGui.Enabled = not RebirthGui.Enabled
end)

ExitButton.MouseButton1Click:Connect(function()
	RebirthGui.Enabled = false
end)
