local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local StateManager = require(ReplicatedStorage.Client.StateManager)
local AreasConfig = require(ReplicatedStorage.Configs.AreasConfig)
local Remotes = ReplicatedStorage.Remotes

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Gui = PlayerGui:WaitForChild("PurchaseArea")
local Frame = Gui.Frame

local Price = Frame.Buttons.StrengthBuyButton.Price

local Exit = Frame.Exit
local Accept = Frame.Buttons.StrengthBuyButton

local StrengthPrice = "AMOUNT Strength"

local PurchaseArea = {}

PurchaseArea.Area = nil

function PurchaseArea.DisplayGui(area: string)
    local areaInfo = AreasConfig.Config[area]
    local price = areaInfo.Price

    Price.Text = StrengthPrice:gsub("AMOUNT", FormatNumber.FormatCompact(price))
    Gui.Enabled = true
    PurchaseArea.Area = area
end

Exit.MouseButton1Click:Connect(function()
    Gui.Enabled = false
end)

Accept.MouseButton1Click:Connect(function()
    if PurchaseArea.Area then
        Remotes.PurchaseArea:FireServer(PurchaseArea.Area)
    end
    Gui.Enabled = false
    PurchaseArea.Area = false
end)

return PurchaseArea