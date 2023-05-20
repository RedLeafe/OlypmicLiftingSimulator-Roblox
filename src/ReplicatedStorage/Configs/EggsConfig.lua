local Workspace = game:GetService("Workspace")

export type EggConfig = {
    Price: number,
    Currency: string,
    Pets: {
        [string]: {
            Chance: number,
            Rarity: string
        }
    }
}

local Config : { [string] : EggConfig} = {
    Basic = {
        Price = 1_000,
        Currency = "Strength",
        Pets = {
            Cat = {
                Chance = 40,
                Rarity = "Common"
            },
            Dog = {
                Chance = 20,
                Rarity = "Common"
            },
            Bunny = {
                Chance = 5,
                Rarity = "Rare"
            }
        }
    },
    Earth = {
        Price = 99_000,
        Currency = "Robux",
        Pets = {
            Cat = {
                Chance = 60,
                Rarity = "Common"
            },
            Dog = {
                Chance = 50,
                Rarity = "Common"
            },
            Bunny = {
                Chance = 20,
                Rarity = "Rare"
            }
        }
    },
    Forest = {
        Price = 1_000,
        Currency = "Strength",
        Pets = {
            Cat = {
                Chance = 40,
                Rarity = "Common"
            },
            Dog = {
                Chance = 20,
                Rarity = "Common"
            },
            Bunny = {
                Chance = 5,
                Rarity = "Rare"
            }
        }
    },
    Artic = {
        Price = 1_000,
        Currency = "Strength",
        Pets = {
            Cat = {
                Chance = 40,
                Rarity = "Common"
            },
            Dog = {
                Chance = 20,
                Rarity = "Common"
            },
            Bunny = {
                Chance = 5,
                Rarity = "Rare"
            }
        }
    },
}

local EggsConfig = {}

function EggsConfig.GetConfig(egg:string) : EggConfig
    return Config[egg]
end

function EggsConfig.GetEggModles()
    local models = {}

    for _, descendant in Workspace:GetDescendant() do
        if descendant.Name == "Egg Stand" then
            local egg = descendant:GetAttribute("egg")
            if egg then
                models[egg] = descendant
            end
        end
    end

    return models
end

function EggsConfig.GetHatchChance(egg: string, pet: string, data) 
    local config = EggsConfig.GetConfig(egg)
    if not config then return end

    local luckStat = 1 -- Do gamepass check here
    local chance = config.Pets[pet].Chance
    if chance < 10 then 
        chance *= luckStat
    end

    return chance
end

return EggsConfig