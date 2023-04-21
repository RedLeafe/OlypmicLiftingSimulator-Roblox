local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local PlayerScripts = player.PlayerScripts
local PlayerGui = player.PlayerGui

local ForestProductId = 1507827865
local ArcticProductId = 1524776508
local VolcanoProductId = 1524776586

local PurchaseArea = require(PlayerScripts:WaitForChild("Gui").PurchaseAreaScripts.PurchaseAreas)

local Gui = PlayerGui:WaitForChild("PurchaseArea")
local Frame = Gui.Frame

local debounce = false

local function RegisterButtonClicked()
    for _, gate in Workspace.Gates:GetChildren() do
        local strengthButton = gate.GateHUD.Buttons.StrengthBuyButton
        local robuxButton = gate.GateHUD.Buttons.RobuxBuyButton

        strengthButton.MouseButton1Click:Connect(function()
            if not player --[[or player ~= typeof(Player)]] then return end
            if debounce then return end
            --print(gate.Name)
            PurchaseArea.DisplayGui(gate.Name)
            debounce = true
            task.delay(0.5, function()
                debounce = false
            end)
        end)

        robuxButton.MouseButton1Click:Connect(function()
            if not player --[[or player ~= typeof(Player)]] then return end
            if debounce then return end
            --print(gate.Name)
            if (gate.Name == "ForestGate") then MarketplaceService:PromptProductPurchase(player, ForestProductId)
            elseif (gate.Name == "ArcticGate") then MarketplaceService:PromptProductPurchase(player, ArcticProductId)
            elseif (gate.Name == "VolcanoGate") then MarketplaceService:PromptProductPurchase(player, VolcanoProductId) end
            debounce = true
            task.delay(0.5, function()
                debounce = false
            end)
        end)

    end
end

RegisterButtonClicked()