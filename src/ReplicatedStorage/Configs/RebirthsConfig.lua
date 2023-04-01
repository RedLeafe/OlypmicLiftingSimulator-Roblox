local rebirthsConfig = {}

rebirthsConfig.BasePrice = 15000
rebirthsConfig.IncreasePerRebirth = 175

function rebirthsConfig.CalculatePrice(currentRebirth: number, amountOfRebirths: number)
	amountOfRebirths = if amountOfRebirths then amountOfRebirths else 1
	
	local price = 0
	local rebirths = 0
	while (rebirths < amountOfRebirths) do
		price += rebirthsConfig.BasePrice + ( (rebirths + currentRebirth) * rebirthsConfig.IncreasePerRebirth)
		rebirths += 1
	end
	
	return price
end


return rebirthsConfig
