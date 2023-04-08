local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
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

    if pet.Equipped then
        PetManager.UnequipPet(player, uuid)
    end

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
    for _, loopPlayer in Players:GetPlayers() do
        if player == loopPlayer then continue end
        Remotes.ReplicateEquipPet:FireClient(loopPlayer, player, pet)
    end
end

function PetManager.EquipBestPets(player :Player, uuid: string)
    local profile = PlayerData.Profiles[player]
    if not profile then return "no profile found!" end

    local pets = {}
    for uuid, pet:PetsConfig.PetInstance in profile.Data.Pets do
        local petInfo = {
            UUID = pet.UUID,
            Multiplier = PetsConfig.GetPetMultiplier(pet)
        }
        table.insert(pets,petInfo)
    end
    table.sort(pets,function(a,b)
        return a.Multiplier > b.Multiplier
    end)

    PetManager.UnequipAllPets(player)

    local maxEquippedPets = PetsConfig.GetMaxedEquippedPets(profile.Data)
    local total = if #pets < maxEquippedPets then #pets else maxEquippedPets
    for i = 1, total, 1 do
        local uuid = pets[i].UUID
        PetManager.EquipPet(player,uuid)
    end
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
    for _, loopPlayer in Players:GetPlayers() do
        if player == loopPlayer then continue end
        Remotes.ReplicateUnequipPet:FireClient(loopPlayer, player, uuid)
    end
end

function PetManager.UnequipAllPets(player :Player)
    local profile = PlayerData.Profiles[player]
    if not profile then return "No profile found!" end
    
    local equippedPets = PetsConfig.GetEquippedPets(profile.Data)
    for _, pet in equippedPets do
        PetManager.UnequipPet(player, pet.UUID)
    end


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

function PetManager.GetEquippedPets()
    local allEquippedPets = {}

    for _, player in Players:GetPlayers() do
        allEquippedPets[player.UserId] = {}

        local profile = PlayerData.Profiles[player]
        if not profile then continue end

        local equippedPets = PetsConfig.GetEquippedPets(profile.Data)
        for _, pet in equippedPets do
            allEquippedPets[player.UserId][pet.UUID] = pet
        end
    end

    return allEquippedPets
end

Remotes.DeletePets.OnServerEvent:Connect(PetManager.DeletePets)
Remotes.DeletePet.OnServerEvent:Connect(PetManager.DeletePet)
Remotes.EquipPet.OnServerEvent:Connect(PetManager.EquipPet)
Remotes.EquipBestPets.OnServerEvent:Connect(PetManager.EquipBestPets)
Remotes.UnequipPet.OnServerEvent:Connect(PetManager.UnequipPet)
Remotes.UnequipAllPets.OnServerEvent:Connect(PetManager.UnequipAllPets)

Remotes.GetEquippedPets.OnServerInvoke = PetManager.GetEquippedPets

return PetManager