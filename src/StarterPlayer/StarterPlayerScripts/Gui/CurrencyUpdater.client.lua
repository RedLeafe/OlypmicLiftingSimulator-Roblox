local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StateManager = require(ReplicatedStorage.Client.StateManager)
local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local Remotes = ReplicatedStorage.Remotes

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Gui = PlayerGui:WaitForChild("Left")
local Frame = Gui.Frame.Currency

local Strength = Frame.Strength.Amount

local BuyStrength = Frame.Strength.Buy
local Gems = Frame.Gems.Amount
--Takes in a string parameter for the type of currency changing, and amount parameter by how much it changes
local function UpdateCurrency(currency: "Strength" | "Gems", amount: number?)
	amount = if amount then amount else 0
	amount = FormatNumber.FormatCompact(amount)
	if currency == "Strength" then
		Strength.Text = amount
	elseif currency == "Gems" then
		Gems.Text = amount
	end
end

UpdateCurrency("Strength", StateManager.GetData().Strength)

Remotes.UpdateStrength.OnClientEvent:Connect(function(amount)
	UpdateCurrency("Strength",amount)
end)

Remotes.UpdateGems.OnClientEvent:Connect(function(amount)
	UpdateCurrency("Gems",amount)
end)

UpdateCurrency("Gems", StateManager.GetData().Gems)