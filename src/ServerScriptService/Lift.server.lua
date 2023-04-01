local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Remotes = ReplicatedStorage.Remotes
local PlayerData = require(ServerScriptService.PlayerData.Manager)

local Cooldown = {}

local CLICK_COOLDOWN = 0.5


--To have an object give strength pass Remotes.Lift:FireServer(Strength Amount)
--That will give parameter of strength the rest should do it by itself

--Controls the Lift cooldown
local function Lift(player: Player, amount)
	if table.find(Cooldown, player) then return end
	table.insert(Cooldown, player)
	task.delay(CLICK_COOLDOWN, function() 
		local foundPlayer = table.find(Cooldown, player)
		if foundPlayer then 
			table.remove(Cooldown, foundPlayer)
		end
	end)
	PlayerData.AdjustStrength(player, amount)
end

Remotes.Lift.OnServerEvent:Connect(Lift)