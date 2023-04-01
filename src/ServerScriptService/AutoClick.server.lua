local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Remotes = ReplicatedStorage.Remotes
local PlayerData = require(ServerScriptService.PlayerData.Manager)

local isActive = false

local function UpdateAutoClicker(player: Player)
	local profile = PlayerData.Profiles[player]
	if not profile then return end
	
	isActive = profile.Data.Auto.Active
	
	if isActive then
		profile.Data.Auto.Active = false
		Remotes.UpdateAutoClicker:FireClient(player, false)
	elseif not isActive then
		profile.Data.Auto.Active = true
		Remotes.UpdateAutoClicker:FireClient(player, true)
	end
	
end

Remotes.UpdateAutoClicker.OnServerEvent:Connect(UpdateAutoClicker)

--OK so the issue lies probably with isActive or not finding the players profile
--Since this runs on start the players may not have loaded in yet
--activated button and the forloop stops running because a profile wasnt found
while true do 
	for _, player in Players:GetPlayers() do
		local profile = PlayerData.Profiles[player]
		
		--ryan you are stupid you use continue not return
		--return breaks out of the forloop and breaks the code
		--old code: if not profile then return end
		if not profile then continue end
		
		isActive = profile.Data.Auto.Active
		
		if isActive then 
			
			PlayerData.AdjustStrength(player, 100)
		end
	end
	
	task.wait(1)
end