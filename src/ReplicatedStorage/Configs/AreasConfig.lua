local AreasConfig = {}

AreasConfig.Config = {
	ForestGate = {
		Price = 1000
	},
	ArcticGate = {
		Price = 5000,
		Requirement = "ForestGate"
	},
	VolcanoGate = {
		Price = 20000,
		Requirement = "ArcticGate"
	}
}

function AreasConfig.IsAreaUnlocked(data, area: string)
	return data.Areas[area]
end

return AreasConfig
