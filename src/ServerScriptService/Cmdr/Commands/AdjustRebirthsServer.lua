local ServerScriptService = game:GetService("ServerScriptService")

local PlayerData = require(ServerScriptService.PlayerData.Manager)

return function (context,player:Player,  amount: number)
	
	local player = if player then player else context.Executor
	
	PlayerData.AdjustRebirths(player, amount)
	return "Adjusted by "..amount
	
end