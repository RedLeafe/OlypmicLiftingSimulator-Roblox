local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService")
local Player = game:GetService("Players")
local Settings = require(ReplicatedStorage:WaitForChild("Configs"):WaitForChild("SettingsConfig"))

local PlayerData = require(ServerScriptService.PlayerData.Manager)

local Remotes = ReplicatedStorage.Remotes

function updatePopupEffects (player : Player, setting)
    
	--print(setting)
    local profile = PlayerData.Profiles[player]
    if not profile then return "No profile found!" end
    --setting.Enabled = not setting.Enabled
    for index, settingType in pairs(profile.Data.Settings) do
        print(settingType)
        if settingType.ID == setting.ID then
            profile.Data.Settings[index].Enabled = setting.Enabled;
            print(profile.Data.Settings[index].ID, " is ", profile.Data.Settings[index].Enabled)
            return nil
        end
        
    end
  
end

Remotes.UpdateSettings.OnServerEvent:Connect(updatePopupEffects)
