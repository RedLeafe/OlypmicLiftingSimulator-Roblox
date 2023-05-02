local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerData = require(ServerScriptService.PlayerData.Manager)
local CodesConfig = require(ReplicatedStorage.Configs.CodesConfig)
local Remotes = ReplicatedStorage.Remotes

local Codes = {}

Remotes.RedeemCode.OnServerInvoke = function(player, code)
	--Codes.ProcessCodes(player: Player, code: string)
    print("Entered Function")
	local profile = PlayerData.Profiles[player]
	if not profile then return "No profile found!" end
	
	local codeInfo = CodesConfig.Config[code]
	if not codeInfo then return "DOES NOT EXIST" end
	
	local isUnlocked = CodesConfig.IsCodeUsed(profile.Data, code)
	if isUnlocked then return "ALREADY REDEEMED" end
	
	profile.Data.Codes[code] = true
    PlayerData.AdjustStrengthNoMult(player, CodesConfig.Config[code])
	return "REDEEMED"
end
	
--Remotes.RedeemCode.OnServerEvent:Connect(function(player, code)
    --print ("Recieved Server Event")
    --Codes.ProcessCodes(player, code)
--end)

return Codes