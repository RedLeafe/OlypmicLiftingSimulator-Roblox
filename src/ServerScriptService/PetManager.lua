local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local HttpService = game:GetService("HttpService")

local PetsConfig = require(ReplicatedStorage.Configs.PetsConfig)
local PlayerData = require(ServerScriptService.PlayerData.Manager)

local Remotes = ReplicatedStorage.Remotes.PetRemotes

local PetManager = {}

function PetManager.GivePet(player : Player, pet : PetsConfig.PetInstance)
    local profile = PlayerData.Profiles[player]
    if not profile then return "No profile found!" end

    local storedPets = PetsConfig.GetTotalStoredPets(profile.Data)
    local maxStoredPets = PetsConfig.GetMaxedStoredPets(profile.Data)
    if storedPets + 1 > maxStoredPets then return "Cannot hold more Pets!" end

    profile.Data.Pets[pet.UUID] = pet
    Remotes.GivePet:FireClient(player, pet)
    return "Pet given!"
end

function PetManager.DeletePet(player : Player, uuid : string)
    local profile = PlayerData.Profiles[player]
    if not profile then return "No profile found!" end

    local pet : PetsConfig.PetInstance = profile.Data.Pets[uuid]

    if not pet then return "no pet found!" end

    profile.Data.Pets[uuid] = nil
    Remotes.DeletePet:FireClient(player, uuid)

end

function PetManager.DeletePets(player: Player, uuids : {string})
    for _, uuid in uuids do
        PetManager.DeletePet(player, uuid)
    end
end

function PetManager.EquipPet(player : Player, uuid: string)
    local profile = PlayerData.Profiles[player]
    if not profile then return "no profile found!" end

    local pet: PetsConfig.PetInstance = profile.Data.Pets[uuid]
    if not pet then return "no pet found!" end

    if pet.Equipped then
        return "pet already equipped"
        --unequip
    end

    local equippedPets = #PetsConfig.GetEquippedPets(profile.Data)
    local maxEquippedPets = PetsConfig.GetMaxedEquippedPets(profile.Data)
    if equippedPets + 1 > maxEquippedPets then return "Cannot equip more Pets!" end

    pet.Equipped = true
    Remotes.EquipPet:FireClient(player, uuid)
end

function PetManager.UnequipPet(player : Player, uuid: string)
    local profile = PlayerData.Profiles[player]
    if not profile then return "no profile found!" end

    local pet: PetsConfig.PetInstance = profile.Data.Pets[uuid]
    if not pet then return "no pet found!" end

    if not pet.Equipped then
        return "pet not equiped"
        --equip
    end

    pet.Equipped = false
    Remotes.UnequipPet:FireClient(player, uuid)
end

function  PetManager.CreatePet(pet : string) : PetsConfig.PetInstance
    return {
        UUID = HttpService:GenerateGUID(false),
        Name = pet,
        Model = pet,
        Rarity = "Common",

        Level = 0,

        Equipped = false
    }
    
end

Remotes.DeletePets.OnServerEvent:Connect(PetManager.DeletePets)
Remotes.DeletePet.OnServerEvent:Connect(PetManager.DeletePet)
Remotes.EquipPet.OnServerEvent:Connect(PetManager.EquipPet)
Remotes.UnequipPet.OnServerEvent:Connect(PetManager.UnequipPet)


return PetManager