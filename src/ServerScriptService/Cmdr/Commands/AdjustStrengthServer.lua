local ServerScriptService = game:GetService("ServerScriptService")

local PlayerData = require(ServerScriptService.PlayerData.Manager)

return function (context,player:Player,  amount: number)
	
	
	PlayerData.AdjustStrengthNoMult(player, amount)
	return "Adjusted by "..amount
	
end