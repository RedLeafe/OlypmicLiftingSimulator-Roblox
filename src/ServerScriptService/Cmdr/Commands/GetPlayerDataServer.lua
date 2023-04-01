local ServerScriptService = game:GetService("ServerScriptService")

local PlayerData = require(ServerScriptService.PlayerData.Manager)


return function (context, player: Player?, dataDirectory: string?)
	--will set the player to the person who executed command if player isnt specified
	player = if player then player else context.Executor
	
	local profile = PlayerData.Profiles[player];
	if not profile then
		return "No profile found?"
	end
	
	if not dataDirectory then 
		print(profile.Data)
		return "All data printed!"
	end
	
	print(profile.Data[dataDirectory])
	return "Data printed!"
end