local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerTemplate = require(ReplicatedStorage.PlayerData.Template)

export type PetInstance = {
    UUID : string,
    Name : string,
    Model: string,
    Rarity: string,

    Level: number,
    Equipped: boolean
}

type PetConfig = {
    Multiplier: number,
    
    MaxLevel : number,
    PetsPerLevel: number?
}

local Config : { [string] : PetConfig } = {
    Bunny = {
        Multiplier = 1.5,
        MaxLevel = 2, 
    },
    Cat = {
        Multiplier = 2.5,
        MaxLevel = 2, 
    }
}

local DEFUALT_MAX_STORED_PETS = 25
local DEFUALT_MAX_EQUIPPED_PETS = 3

local PetsConfig = {}

PetsConfig.Config = Config

--returns the pet config of a specific pet
function PetsConfig.GetConfig(pet : PetInstance) : PetConfig
    return PetsConfig.Config[pet.Model]
end

--Gets the total multiplier of all equipped pets
function PetsConfig.GetEquippedMultiplier(data : PlayerTemplate.PlayerData)
    local equippedPets = PetsConfig.GetEquippedPets(data)
    local multiplier = 0
    for _, pet in equippedPets do
        multiplier += PetsConfig.GetPetMultiplier(pet)
    end
    return multiplier
end

--returns the multiplier of a specific pet
function PetsConfig.GetPetMultiplier(pet : PetInstance)
    local config = PetsConfig.GetConfig(pet)
    local Multiplier = config.Multiplier

    return Multiplier
end

--returns a table of the pets that are currently equiped
function PetsConfig.GetEquippedPets(data : PlayerTemplate.PlayerData)
    local equipped = {}
    for uuid, petInstance : PetInstance in data.Pets do
        if petInstance.Equipped then
            table.insert(equipped,petInstance)
        end
    end

    return equipped
end

--returns total amount of pets in inventory
function PetsConfig.GetTotalStoredPets(data : PlayerTemplate.PlayerData)
    local amount = 0
    for uuid, petInstance: PetInstance in data.Pets do
        amount += 1
    end
    return amount
end

--returns the limit of stored pets
function PetsConfig.GetMaxedStoredPets(data : PlayerTemplate.PlayerData)
    local amount = DEFUALT_MAX_STORED_PETS
    -- Do gamepass check here
    return amount
end

--returns the limit of equipped pets
function PetsConfig.GetMaxedEquippedPets(data : PlayerTemplate.PlayerData)
    local amount = DEFUALT_MAX_EQUIPPED_PETS
    -- Do gamepass check here
    return amount
end

return PetsConfig