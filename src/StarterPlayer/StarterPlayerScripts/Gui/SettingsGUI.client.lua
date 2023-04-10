local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Settings = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("SettingsConfig"))
local player = Players.localPlayer

local ButtonGui = PlayerGui:WaitForChild("Left")
local OpenButton = ButtonGui.Frame.Buttons.Settings

local screenGUI = PlayerGui:WaitForChild("Settings")
local frame = screenGUI.Frame

local exitButton = frame.ExitButton --Might need to change
local contianer = frame.Container.Container
local template = container.Template

local ONCOLOR = Color3.fromRGB(47, 214, 28)
local OFFCOLOR = Color3.fromRGB(214, 0, 3)

local function GenerateSetting(setting: table)
  local clone = template:Clone()
  clone.Parent = container
  clone.Name = setting.ID
  clone.Title.Text = setting.ID:gsub("_", " ")
  clone.Description.Text = setting.Description
  clone.Button.BackgroundColor3 = if setting.Enabled then ONCOLOR else OFFCOLOR
  clone.Button.Text = if setting.Enabled then "On" else "Off"
  clone.Visible = true
      
  clone.Button.MouseButton1Click:Connect(function()
    setting.Enabled = not setting.Enabled
    clone.Button.BackgroundColor3 = if setting.Enabled then ONCOLOR else OFFCOLOR
    clone.Button.Text = if setting.Enabled then "On" else "Off"
  end)
end

for _, settingTable in pairs(Settings) do
  GenerateSetting(settingTable)
end
    
-- Open and Close Settings Menu
OpenButton.MouseButton1Click:Connect(function()
	RebirthGui.Enabled = not RebirthGui.Enabled
end)

ExitButton.MouseButton1Click:Connect(function()
	RebirthGui.Enabled = false
end)
