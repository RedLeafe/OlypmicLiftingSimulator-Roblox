local module = {}
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

module.tool = player.Backpack:WaitForChild("Weight")
local idleAnimation = Instance.new("Animation")
idleAnimation.AnimationId = "rbxassetid://12828758820"
module.idleTrack = humanoid:LoadAnimation(idleAnimation)

local replicatedStorage = game:GetService("ReplicatedStorage")
local strengthGain = 100

function module.Lift()
	replicatedStorage.Remotes.Lift:FireServer(strengthGain)
	
end

return module
