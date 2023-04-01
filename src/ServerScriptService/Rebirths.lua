local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ServerScriptService.PlayerData.Manager)
local RebirthConfig = require(ReplicatedStorage.Configs.RebirthsConfig)
local Remotes = ReplicatedStorage.Remotes

local RebirthMultiplier = 0.1

local Rebirths = {}

function Rebirths.Rebirth(player:Player, amount : number?)
	amount = if amount then amount else 1
	
	local profile = PlayerData.Profiles[player]
	if not profile then return "No profile!"end
	
	local currentRebirth = profile.Data.Rebirths
	local price = RebirthConfig.CalculatePrice(currentRebirth,amount)
	
	local canAfford = profile.Data.Strength >= price
	if not canAfford then return "Cannot afford "..price end
	
	PlayerData.AdjustRebirths(player, amount)
	PlayerData.AdjustStrengthNoMult(player, -profile.Data.Strength)
	PlayerData.AdjustStrMultiplier(player, RebirthMultiplier * amount)
	Remotes.UpdateRebirths:FireClient(player, profile.Data.Rebirths) 
	return "You Rebirthed"
	
end
Remotes.Rebirth.OnServerEvent:Connect(Rebirths.Rebirth)

return Rebirths