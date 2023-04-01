--ok so I am not gunna finish this function because I just dont think we need it
--we already save multipliers and do the calculations in manage
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerDataTemplate = require(ReplicatedStorage.PlayerData.Template)

local Stats = {}

function Stats.StrengthMultiplier(player: Player, playerData: PlayerDataTemplate.PlayerData)
	local multiplier = 1
	local rebirths = playerData.Rebirths
	multiplier = rebirths
end
return Stats