local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local StateManager = require(ReplicatedStorage.Client.StateManager)

local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local Remotes = ReplicatedStorage.Remotes

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local ButtonGui = PlayerGui:WaitForChild("Left")
local OpenButton = ButtonGui.Frame.Buttons.Rebirth

local RebirthConfig = require(ReplicatedStorage.Configs.RebirthsConfig)

local RebirthGui = PlayerGui:WaitForChild("RebirthsGUI")
local Frame = RebirthGui.Frame

local Rebirths = Frame.Rebirths
local ExitButton = Frame.Exit

local instruction = Frame.Instructions.Instructions

local RebirthButton = Frame.RebirthButton

--Text Templates for GUI
local REBIRTH_DISPLAY_TEMPLATE = "Rebirths : AMOUNT"
local REBIRTH_BUTTON_COST_TEMPLATE = "Strength Required to Rebirth : AMOUNT"

--Amount of times this specific player has rebirthed


--Updates the Strength requires cost on the Client gui
local function UpdateButtonCost()
	
	local PlayerRebirths = Remotes.GetData:InvokeServer("Rebirths")
	PlayerRebirths = if PlayerRebirths then PlayerRebirths else 0
	local cost = RebirthConfig.CalculatePrice(PlayerRebirths, 1)
	instruction.Text = REBIRTH_BUTTON_COST_TEMPLATE:gsub("AMOUNT", FormatNumber.FormatCompact(cost))
end
--updates the color of the button to show if a rebirth is buyable
local function UpdateButtonBuyable()
	
end
--Updates the amount of rebirths the player has on Client gui 
local function UpdateRebirth(amount: number)
	amount = if amount then amount else 0
	Rebirths.Text = REBIRTH_DISPLAY_TEMPLATE:gsub("AMOUNT", FormatNumber.FormatCompact(amount))
end

local function Rebirth()
	print("Rebirth")
	Remotes.Rebirth:FireServer(1)
end

local function RebirthBuy()
	local PlayerRebirths = StateManager.GetData().Rebirths
	local PlayerStrength = StateManager.GetData().Strength
	local cost = RebirthConfig.CalculatePrice(PlayerRebirths, 1)
	print(PlayerStrength..">="..cost)
	if PlayerStrength >= cost then
		Rebirth()
	else
		print("not enough strength")
	end
end

RebirthButton.MouseButton1Click:Connect(RebirthBuy)
--runs on startup to update players rebirth with their current data
UpdateRebirth(StateManager.GetData().Rebirths)
UpdateButtonCost()


--On Rebirth Event rebirth counter gets updated
Remotes.UpdateRebirths.OnClientEvent:Connect(UpdateRebirth)

--Open button will close or open depending on if the gui is open or not
OpenButton.MouseButton1Click:Connect(function()
	RebirthGui.Enabled = not RebirthGui.Enabled
end)
--close out of the gui via button
ExitButton.MouseButton1Click:Connect(function()
	RebirthGui.Enabled = false
end)

