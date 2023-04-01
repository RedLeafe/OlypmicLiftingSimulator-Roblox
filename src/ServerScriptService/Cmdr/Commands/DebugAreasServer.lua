local ServerScriptService = game:GetService("ServerScriptService")

local Areas = require(ServerScriptService.Areas)

return function (context, area: string)
	local player = context.Executor
	
	
	return Areas.UnlockArea(player, area)
	
end