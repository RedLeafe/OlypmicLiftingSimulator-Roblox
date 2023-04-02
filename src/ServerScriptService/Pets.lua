local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

local PetsConfig = require(ReplicatedStorage.Configs.PetsConfig)
local PlayerData = require(ServerScriptService.PlayerData.Manager)

local Remotes = ReplicatedStorage.Remotes.PetRemotes

local Pets = {}

function Pets.GivePet(player : Player, pet : PetsConfig.PetInstance)
    local profile = PlayerData.Profiles[player]
    if not profile then return "No profile found!" end

    local storedPets = PetsConfig.GetTotalStoredPets(profile.Data)
    local maxStoredPets = PetsConfig.GetMaxedStoredPets(profile.Data)
    if storedPets + 1 > maxStoredPets then return "Cannot hold more Pets!" end

    profile.Data.Pets[pet.UUID] = pet
    Remotes.GivePet:FireClient(player, pet)
    return "Pet given!"
end

function  Pets.CreatePet(pet : string) : PetsConfig.PetInstance
    return {
        UUID = HttpService:GenerateGUID(false),
        Name = pet,
        Model = pet,
        Rarity = "Common",

        Level = 0,

        Equipped = false
    }
    
end

return Pets