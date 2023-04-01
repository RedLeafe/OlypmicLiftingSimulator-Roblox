local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local StateManager = require(ReplicatedStorage.Client.StateManager)
local AreasConfig = require(ReplicatedStorage.Configs.AreasConfig)
local Remotes = ReplicatedStorage.Remotes

local player = Players.LocalPlayer
local PlayerScripts = player.PlayerScripts
local PlayerGui = player.PlayerGui

local PurchaseArea = require(PlayerScripts:WaitForChild("Gui").PurchaseAreaScripts.PurchaseAreas)

local Gui = PlayerGui:WaitForChild("PurchaseArea")
local Frame = Gui.Frame

local debounce = false

local function RegisterButtonClicked()
    for _, gate in Workspace.Gates:GetChildren() do
        local button = gate.GateHUD.Buttons.StrengthBuyButton
        button.MouseButton1Click:Connect(function()
            --this is not needed cuz we already get which player has hit the button
            --He had this because technically otherparts of the player can hit the portal and the touch function returned the specific part.
            --local player = Players:GetPlayerFromCharacter(otherPart.Parnet)
            
            if not player --[[or player ~= typeof(Player)]] then return end
            if debounce then return end
            print(gate.Name)
            PurchaseArea.DisplayGui(gate.Name)
            debounce = true
            task.delay(0.5, function()
                debounce = false
            end)
        end)
    end
end

RegisterButtonClicked()