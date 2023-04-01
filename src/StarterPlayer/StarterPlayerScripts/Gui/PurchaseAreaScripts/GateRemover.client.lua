local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.Remotes
local StateManager = require(ReplicatedStorage.Client.StateManager)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer


local function gateRemove(area : string)
    local gate = Workspace.Gates:WaitForChild(area)
    gate:Destroy()
end

local function gateRemoveStartup()
    for area, info in StateManager.GetData().Areas do
        if StateManager.GetData().Areas[area] then
            local gate = Workspace.Gates:WaitForChild(area)
            gate:Destroy()
        end
    end
end

gateRemoveStartup()
Remotes.UpdateArea.OnClientEvent:Connect(gateRemove)