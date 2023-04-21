local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes

local productFunctions = {}

-- ProductId 1507827865 unlocks the forest area
productFunctions[1507827865] = function(receipt, player)
    Remotes.PurchaseAreaRobux:FireServer("ForestGate")
end

productFunctions[1524776508] = function(receipt, player)
    Remotes.PurchaseAreaRobux:FireServer("ArcticGate")
end

productFunctions[1524776586] = function(receipt, player)
    Remotes.PurchaseAreaRobux:FireServer("VolcanoGate")
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