local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlayerData = require(ServerScriptService.PlayerData.Manager)
local AreasConfig = require(ReplicatedStorage.Configs.AreasConfig)

local Remotes = ReplicatedStorage.Remotes

function UnlockAreaRobux(player: Player, area: string)
	local profile = PlayerData.Profiles[player]
	if not profile then return "No profile found!" end
	
	local areaInfo = AreasConfig.Config[area]
	if not areaInfo then return "No Area found!" end
	
	local isUnlocked = AreasConfig.IsAreaUnlocked(profile.Data, area)
	if isUnlocked then return "Already unlocked!" end

	profile.Data.Areas[area] = true
	Remotes.UpdateArea:FireClient(player, area)
	return "Area unlocked!"
end

local productFunctions = {}

-- ProductId 1507827865 unlocks the forest area
productFunctions[1507827865] = function(receipt, player)
	--print("Purchased Forest Area")
	UnlockAreaRobux(player, "ForestGate")
end

productFunctions[1524776508] = function(receipt, player)
	--print("Purchased Arctic Area")
	UnlockAreaRobux(player, "ArcticGate")
end

productFunctions[1524776586] = function(receipt, player)
	--print("Purchased Volcano Area")
	UnlockAreaRobux(player, "VolcanoGate")
end

local function processReceipt(receiptInfo)
	local userId = receiptInfo.PlayerId
	local productId = receiptInfo.ProductId

	local player = Players:GetPlayerByUserId(userId)
	if player then
		-- Get the handler function associated with the developer product ID and attempt to run it
		local handler = productFunctions[productId]
		local success, result = pcall(handler, receiptInfo, player)
		if success then
			-- return PurchaseGranted to confirm the transaction.
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("Failed to process receipt:", receiptInfo, result)
		end
	end

	-- return NotProcessedYet to try again next time the user joins.
	return Enum.ProductPurchaseDecision.NotProcessedYet
end

-- Set the callback
MarketplaceService.ProcessReceipt = processReceipt