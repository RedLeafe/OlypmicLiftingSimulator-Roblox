--API for the profile service library: https://madstudioroblox.github.io/ProfileService/ 

--IMPORTANT NOTE #1 - USE "TEST" for data store when testing the game and "PRODUCTION" for when we publish it THIS IS SO WE DONT MESS WITH PEOPLES DATA.
--IMPORTANT NOTE #2 - IF WE WANT NEW VARIABLES TO SAVE THROUGH SERVER SESSIONS ADD THE VARIABLE IN TEMPLATE
--IMPORTANT NOTE #3 - DO NOT EDIT THIS CODE EXCEPT FOR CREATING LEADERSTATS


--What this script does
--Detects Whenever a Player joins or leaves a game
--Script will load or unload their data respectively
--includes basic session locking capabilities to prevent duplication and loss of data.

--Variable refrences to services so that code doesnt get long and messy trying to call from the services that we are using
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Template = require(ReplicatedStorage.PlayerData.Template)
local Manager = require(ServerScriptService.PlayerData.Manager)
local ProfileService = require(ServerScriptService.Libs.ProfileService)

--This sets the store of the data that we are using to a string
--So all the data will be stored under the string production when live
--changing this data will create a new store with brand new data
--We will use "Test" as the store for testing and "Production" as the data store for when we publish
--This allows us to test our code without affecting our players current data by creating a different dataset
--Template is just a module that clarifies what variables we should store over time.
local ProfileStore = ProfileService.GetProfileStore("Test1", Template)

local KICK_MESSAGE = "Data issue, try again shortly. If issue persists, contact us!"

local function CreateLeaderstats(player: Player)
	local profile = Manager.Profiles[player]
	if not profile then return end
	
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	
	--clicks just a place holder for now
	--we can change it to strength later
	local strength = Instance.new("NumberValue", leaderstats)
	strength.Name = "Strength"
	strength.Value = profile.Data.Strength
	
	--We can remove gems from leaderstats
	--to make it private 
	--once we have the gui for it setup
	local Rebirths = Instance.new("NumberValue",leaderstats)
	Rebirths.Name = "Rebirths"
	Rebirths.Value = profile.Data.Rebirths
end

--the function parameter includes the variable name and then asserts its type
--(name: type assertion)
--This is done for better roblox autofilling
local function LoadProfile(player: Player)

	--this attempts to load the specific profile of a player using their UserId.
	local profile = ProfileStore:LoadProfileAsync("Player_"..player.UserId, "ForceLoad")
	
	--If the players data fails to load then we kick them from the game to prevent issues
	
	if not profile then 
		player:Kick(KICK_MESSAGE)
		--stop the function
		return
	end
	
	profile:AddUserId(player.UserId)
	--looks at players current template to see if it has all the data in our (serverside) template
	--if not then it will update its current template to match all varaibles with our template
	profile:Reconcile()
	
	--runs function when Release() is called i think
	profile:ListenToRelease(function()
		Manager.Profiles[player] = nil
		player:Kick(KICK_MESSAGE)
	end)
	
	if player:IsDescendantOf(Players) == true then
		Manager.Profiles[player] = profile
		CreateLeaderstats(player)
	else
	--removes session lock for the profile meaning and saves the profile data for the last time this session 
		profile:Release()
	end
	
end

--Calls the function for each player to load their profile and to save their profile on leaving.
for _, player in Players:GetPlayers() do
	task.spawn(LoadProfile, player)
end

Players.PlayerAdded:Connect(LoadProfile)
Players.PlayerRemoving:Connect(function(player)
	local profile = Manager.Profiles[player]
	if profile then
		profile:Release()
	end
end)
