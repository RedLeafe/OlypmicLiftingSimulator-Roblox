local ServerScriptService = game:GetService("ServerScriptService")

local Rebirths = require(ServerScriptService.Rebirths)

return function (context,  amount: number?)
	amount = if amount then amount else 1
	local player = context.Executor
	
	
	return Rebirths.Rebirth(player, amount)
	
end