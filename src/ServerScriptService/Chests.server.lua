local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Remotes = ReplicatedStorage.Remotes
local PlayerData = require(ServerScriptService.PlayerData.Manager)
local AreasConfig = require(ReplicatedStorage.Configs.AreasConfig)

local function CollectChest(player: Player, chest: Model)
    if debounce[player] then return end

    local profile = PlayerData.Profiles[player]
    if not profile then return end

    local area = chest.Parent.Name
    local isAreaUnlocked = AreasConfig.IsAreaUnlocked(profile.Data, area)
    if not isAreaUnlocked then return end

    local playerCooldown = profile.Data.Chests[area]
    if playerCooldown and playerCooldown > os.time() then return end

    local cooldown = chest:GetAttribute("cooldown")
    local currency = chest:GetAttribute("currency")
    local reward = chest:GetAttribute("reward")

    if currency == "Strength" then
        PlayerData.AdjustStrengthNoMult(player, reward)
    else if currency == "Gems" then
        PlayerData.AdjustGems(player, reward)
    end

    profile.Data.Chests[area] = os.time() + cooldown
    Remotes.UpdateChest:FireClient(player, area, profile.Data.Chests[area])
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
                CollectChest(player, descendant)
            end)
        end
    end
end

CreateChestListener()