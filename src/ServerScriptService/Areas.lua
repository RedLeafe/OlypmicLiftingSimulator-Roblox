local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ServerScriptService.PlayerData.Manager)
local AreasConfig = require(ReplicatedStorage.Configs.AreasConfig)
local Remotes = ReplicatedStorage.Remotes

local Areas = {}

function Areas.UnlockArea(player: Player, area: string)
	local profile = PlayerData.Profiles[player]
	if not profile then return "No profile found!" end
	
	local areaInfo = AreasConfig.Config[area]
	if not areaInfo then return "No Area found!" end
	
	local isUnlocked = AreasConfig.IsAreaUnlocked(profile.Data, area)
	if isUnlocked then return "Already unlocked!" end
	
	local areaRequirement = areaInfo.Requirement
	if areaRequirement then 
		local isPreviousUnlocked = AreasConfig.IsAreaUnlocked(profile.Data, areaRequirement)
		if not isPreviousUnlocked then return "Unlock previous Area first!" end
	end
	
	local price = areaInfo.Price
	if price > profile.Data.Strength then return "Cannot afford!" end
	PlayerData.AdjustStrengthNoMult(player, -price)

	profile.Data.Areas[area] = true
	Remotes.UpdateArea:FireClient(player, area)
	return "Area unlocked!"
end
	
Remotes.PurchaseArea.OnServerEvent:Connect(function(player, area)
	Areas.UnlockArea(player, area)
end)

return Areas
