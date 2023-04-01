local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerData = require(ServerScriptService.PlayerData.Manager)
local AreasConfig = require(ReplicatedStorage.Configs.AreasConfig)

return function (context, player:Player)
	local profile = PlayerData.Profiles[player]
    if not profile then return "No profile found!" end
    for area, info in AreasConfig.Config do
        profile.Data.Areas[area] = false
    end

	return "Reset Players area data"
	
end