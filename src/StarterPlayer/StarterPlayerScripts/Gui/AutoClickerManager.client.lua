local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StateManager = require(ReplicatedStorage.Client.StateManager)

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Remotes = ReplicatedStorage.Remotes

local Gui = PlayerGui:WaitForChild("Bottom")
local Frame = Gui.Frame

local autoClicker = Frame.AutoClickerButton
local autoClickerShadow = Frame.AutoClickerButton.Shadow
local onOff = Frame.AutoClickerButton["On/Off"]
local onOffShadow = Frame.AutoClickerButton["On/Off"].Shadow

local ButtonOffColor = Color3.fromRGB(173, 0, 0)
local ButtonOnColor = Color3.fromRGB(17, 173, 0)
local ShadowButtonOffColor = Color3.fromRGB(89, 0, 0)
local ShadowButtonOnColor = Color3.fromRGB(10, 100, 0)
local ClickTextOn = "On"
local ClickTextOff = "Off"

local autoOn = StateManager.GetData().Auto.Active

local function updateButton(mode: boolean)
	autoOn = mode

	if mode then 
		onOff.BackgroundColor3 = ButtonOnColor
		onOff.TextLabel.Text = ClickTextOn
		onOffShadow.BackgroundColor3 = ShadowButtonOnColor
	else
		onOff.BackgroundColor3 = ButtonOffColor
		onOff.TextLabel.Text = ClickTextOff
		onOffShadow.BackgroundColor3 = ShadowButtonOffColor
	end
end

updateButton(autoOn)

autoClicker.MouseButton1Click:Connect(function()
	updateButton(not autoOn)
	Remotes.UpdateAutoClicker:FireServer()
end)

Remotes.UpdateAutoClicker.OnClientEvent:Connect(updateButton)