local StarterPack = game:GetService("StarterPack")
local module = require(script.Parent:WaitForChild("ModuleScript"))
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local tool = module.tool
local mouse = player:GetMouse()
local liftingId = "rbxassetid://12828662336"
local equipped = false
local replicatedStorage = game:GetService("ReplicatedStorage")

if tool.Unequipped then
	module.idleTrack:Stop()
end

tool.Equipped:Connect(function()
	equipped = true
	module.idleTrack:Play()
end)

tool.Unequipped:Connect(function()
	equipped = false
	module.idleTrack:Stop()
end)

local function playAnimation()
	script.Disabled = true

	local animation = Instance.new("Animation")
	animation.AnimationId = liftingId
	local track = humanoid:LoadAnimation(animation)
	track:Play()
	wait(track.Length)

	script.Disabled = false
end

tool.Activated:Connect(function()
	module.Lift()
	playAnimation()
end)

