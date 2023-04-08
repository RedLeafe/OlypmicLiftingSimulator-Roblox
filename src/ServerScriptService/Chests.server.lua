local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

local Remotes = ReplicatedStorage.Remotes
local PlayerData = require(ServerScriptService.PlayerData.Manager)
local AreasConfig = require(ReplicatedStorage.Configs.AreasConfig)

local debounce = {}

local function CollectChest(player: Player, chest: Model)
    if debounce[player] then return end

    local profile = PlayerData.Profiles[player]
    if not profile then return end

    local area = chest.Parent.Name
    if area ~= "Spawn" then
    local isAreaUnlocked = AreasConfig.IsAreaUnlocked(profile.Data, (area.."Gate"))
    if not isAreaUnlocked then return end
    end
    
    local playerCooldown = profile.Data.Chest[area]
    if playerCooldown and playerCooldown > os.time() then return end

    local cooldown = chest:GetAttribute("cooldown")
    local currency = chest:GetAttribute("currency")
    local reward = chest:GetAttribute("reward")

    if currency == "Strength" then
        PlayerData.AdjustStrengthNoMult(player, reward)
    elseif currency == "Gems" then
        PlayerData.AdjustGems(player, reward)
    elseif currency == "Group" then
        PlayerData.AdjustStrengthNoMult(player, reward)
        PlayerData.AdjustGems(player, (reward / 10))
    end

    profile.Data.Chest[area] = os.time() + cooldown
    Remotes.UpdateChest:FireClient(player, area, profile.Data.Chest[area])
    debounce[player] = true
    task.delay(0.5, function()
        debounce[player] = nil
    end)
end

local function CreateChestListener()
    for _, descendant in Workspace.Areas:GetDescendants() do
        if descendant.Name ~= "Chest" then continue end

        local touchPart = descendant.Hitbox
        touchPart.Touched:Connect(function(otherPart)
            local player = Players:GetPlayerFromCharacter(otherPart.Parent)
            if player then
                CollectChest(player, descendant)
            end
        end)
    end
end

CreateChestListener()