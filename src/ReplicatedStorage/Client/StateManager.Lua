local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes
local Template = require(ReplicatedStorage.PlayerData.Template)

local IsDataLoaded = false

local PlayerData : Template.PlayerData

local function LoadData()
	if IsDataLoaded then return end

	while not PlayerData do
		PlayerData = Remotes.GetAllData:InvokeServer()
		task.wait(0.2)
	end

	IsDataLoaded = true
end

LoadData()

local function UpdateData()
	PlayerData = nil
	while not PlayerData do
		PlayerData = Remotes.GetAllData:InvokeServer()
		task.wait(0.1)
	end
end

local StateManager = {}

function StateManager.GetData(): Template.PlayerData
	while not IsDataLoaded do
		task.wait(0.5)
	end
	UpdateData()
	return PlayerData
end

return StateManager