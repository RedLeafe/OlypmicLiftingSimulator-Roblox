--Contains all player data
--PLEASE ADD ANY VARIABLES THAT WE WANT TO SAVE OVER SESSIONS

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local areaConfig = require(ReplicatedStorage.Configs.AreasConfig)
local codesConfig = require(ReplicatedStorage.Configs.CodesConfig)

local defaultAreas = {}
for area, info in areaConfig.Config do 
	defaultAreas[area] = false
end

local defaultCodes = {}
for code, info in codesConfig.Config do 
	defaultCodes[code] = false
end

local Template = {
	Strength = 0,
	StrengthMultiplier = 10,
	Gems = 0,
	Rebirths = 0,
	Auto = {
		Active = false
	},
	Areas = defaultAreas,
	Chest = { },
	Pets = {},
	Settings = {
		Popup_Effects = {ID = "Popup_Effects", Description = "Disable the popup effects for lifting!", Enabled = true},
		Music = {ID = "Music", Description = "111111", Enabled = true},
		SFX = {ID = "SFX", Description = "222222", Enabled = true},
		Trade_Request = {ID = "Trade_Request", Description = "333333", Enabled = true}
	},
	Codes = defaultCodes
}

export type PlayerData = typeof(Template)

return Template
