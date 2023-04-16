local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

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