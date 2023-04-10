--Profiles is from the profile service module that I downloaded from the video
--basically functions as a library that gives each player a profile
--which means less work for us having to create that system.

--this holds all the profiles currently connected to our game.
local Manager = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage.Remotes

Manager.Profiles = {}

Manager.ProfileLoaded = Instance.new("BindableEvent")

local function GetSettingsByID(id:string)
	for _, settingTable in pairs(Settings) do
		if settingTable.ID == id then
			return settingTable
		end
	end
end

--Controls the data management whenever strength is added client side
--Making it serverWide and applying it to any clientSide Gui
function Manager.AdjustStrength(player: Player, amount: number)
	
	local profile = Manager.Profiles[player]
	local info = GetSettingsByID("Popup_Effects")
	amount = amount * profile.Data.StrengthMultiplier
	if not profile then return end
	profile.Data.Strength += amount
	player.leaderstats.Strength.Value = profile.Data.Strength
	Remotes.UpdateStrength:FireClient(player, profile.Data.Strength)
	if not info.Enabled then Remotes.UpdateStrPopup:FireClient(player, amount) end

end
--adjust the strength without the multiplier :)
function Manager.AdjustStrengthNoMult(player: Player, amount: number)

	local profile = Manager.Profiles[player]
	local info = GetSettingsByID("Popup_Effects")
	if not profile then return end
	profile.Data.Strength += amount
	player.leaderstats.Strength.Value = profile.Data.Strength
	Remotes.UpdateStrength:FireClient(player, profile.Data.Strength)
	if not info.Enabled then Remotes.UpdateStrPopup:FireClient(player, amount) end

end

--add amount to profile's strength multiplier
function Manager.AdjustStrMultiplier(player:Player, amount:number)
	
	local profile = Manager.Profiles[player]
	if not profile then return end
	profile.Data.StrengthMultiplier += amount
	print("adjustedStrength by "..amount)
end
--adds amount to a profile's gems
function Manager.AdjustGems(player: Player, amount: number)

	local profile = Manager.Profiles[player]
	if not profile then return end
	profile.Data.Gems += amount
	--no leaderstats for gems
	--player.leaderstats.Gems.Value = profile.Data.Gems
	Remotes.UpdateGems:FireClient(player, profile.Data.Gems)
end

function Manager.AdjustRebirths(player: Player, amount: number)

	local profile = Manager.Profiles[player]
	if not profile then return end
	profile.Data.Rebirths += amount
	player.leaderstats.Rebirths.Value = profile.Data.Rebirths
	
	--no rebirths gui yet
	Remotes.UpdateRebirths:FireClient(player, profile.Data.Gems)
end

--Grabs the data of (player, Data Name)
local function GetData(player: Player, directory: string)
	local profile = Manager.Profiles[player]
	if not profile then return end

	return profile.Data[directory]
end

local function GetAllData(player: Player)
	local profile = Manager.Profiles[player]
	if not profile then return end

	return profile.Data
end

local function GetAutoClickData(player: Player)
	local profile = Manager.Profiles[player]
	if not profile then return end
	return profile.Data.Auto.Active
end

Remotes.GetData.OnServerInvoke = GetData
Remotes.GetAllData.OnServerInvoke = GetAllData
Remotes.GetAutoClickData.OnServerInvoke = GetAutoClickData

return Manager
