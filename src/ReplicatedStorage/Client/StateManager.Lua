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
		if PlayerData == nil then
			task.wait(0.1)
		end
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

--[[
	So we could update data using remotes so evertime an updateRemote from serverside fires a client it would update our client state data
	the other way of doing this is everytime data is requested through stateManager we wipe all data in client and then ask the server for the up to date version of the data.
	
Remotes.UpdateStrength.OnClientEvent:Connect(function(amount)
	PlayerData.Strength = amount
end)

Remotes.UpdateGems.OnClientEvent:Connect(function(amount)
	PlayerData.Gems = amount
end)


Remotes.UpdateRebirths.OnClientEvent:Connect(function(amount)
	PlayerData.Rebirths = amount
end)

]]

return StateManager