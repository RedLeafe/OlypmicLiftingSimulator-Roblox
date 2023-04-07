local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FormatTime = require(ReplicatedStorage.Libs.FormatTime)
local StateManager = require(ReplicatedStorage.Client.StateManager)
local Remotes = ReplicatedStorage.Remotes

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local Gui = PlayerGui:WaitForChild("ChestsGUI")
local Template = Gui.Template

local UnclaimedTitle = "CURRENCY Chest"
local ClaimedTitle = "Come back in:"
local UnclaimedSubtitle = "Ready To Collect!"

local function CreateGui(chest: Model)
    local clone = Template:Clone()
    clone.Parent = Gui
    clone.Adornee = chest
    clone.Name = chest.Parent.Name
    clone.Enabled = true

    clone:SetAttribute("currency", chest:GetAttribute("currency"))
end

local function GenerateGuis()
    for _, descendant in Workspace.Areas:GetDescendants() do
        if descendant.Name ~= "Chest" then continue end
        CreateGui(descendant)
    end
end

local function UpdateGui(area: string)
    local playerCooldown = StateManager.GetData().Chest[area]
    local gui = Gui[area]

    if playerCooldown and playerCooldown > os.time() then
        gui.Title.Text = ClaimedTitle
        gui.Subtitle.Text = FormatTime.convertToHMS(playerCooldown - os.time())
    else
        local currency = gui:GetAttribute("currency")
        gui.Title.Text = UnclaimedTitle:gsub("CURRENCY", currency)
        gui.Subtitle.Text = UnclaimedSubtitle
    end
end

GenerateGuis()

while true do
    for _, child in Gui:GetChildren() do
        if child.Name == "Template" then continue end
        UpdateGui(child.Name)
    end

    task.wait(1)
end