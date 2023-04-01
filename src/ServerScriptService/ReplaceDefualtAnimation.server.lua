local Players = game:GetService("Players")

local function onCharacterAdded(character)
	-- Get animator on humanoid
	local humanoid = character:WaitForChild("Humanoid")
	local animator = humanoid:WaitForChild("Animator")

	-- Stop all animation tracks
	for _, playingTrack in pairs(animator:GetPlayingAnimationTracks()) do
		playingTrack:Stop(0)
	end

	local animateScript = character:WaitForChild("Animate")
	--animateScript.run.RunAnim.AnimationId = "rbxassetid://507767714"
	--animateScript.walk.WalkAnim.AnimationId = "rbxassetid://507777826"
	animateScript.jump.JumpAnim.AnimationId = "rbxassetid://507765000"
	animateScript.idle.Animation1.AnimationId = "rbxassetid://507766951"
	animateScript.idle.Animation2.AnimationId = "rbxassetid://507766388"
	animateScript.fall.FallAnim.AnimationId = "rbxassetid://507767968"
	animateScript.swim.Swim.AnimationId = "rbxassetid://507784897"
	animateScript.swimidle.SwimIdle.AnimationId = "rbxassetid://507785072"
	animateScript.climb.ClimbAnim.AnimationId = "rbxassetid://507765644"
end

local function onPlayerAdded(player)
	player.CharacterAppearanceLoaded:Connect(onCharacterAdded)
end

Players.PlayerAdded:Connect(onPlayerAdded)