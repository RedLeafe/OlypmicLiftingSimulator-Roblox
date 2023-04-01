local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Remotes = ReplicatedStorage.Remotes

local dif = 0
local plr = Players.LocalPlayer
local leaderstats = plr:WaitForChild("leaderstats")

local first = true

local StrengthLabel = ReplicatedStorage:WaitForChild("StrengthLabel")

local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local currentNumber = 0

function StrengthPopup(amount : number)
	
	
	local random = math.random(1,900)
	local xnew = random/1000
	local new = StrengthLabel:Clone()
	new.Parent = plr.PlayerGui.StrengthPopup
	new.Position = UDim2.new(xnew,0,1,0)
	new.Text = "+"..FormatNumber.FormatCompact(amount)
	wait(0.1)
	new:TweenPosition(UDim2.new(new.Position.X, 0, 0, -0.1, 0))
	wait(0.1)
	if currentNumber == 0 then
		currentNumber = 1
		for _ = 1,20 do
			new.Rotation += 1
			new.TextStrokeTransparency += 0.05
			new.TextTransparency += 0.05
			new.StrengthImage.ImageTransparency += 0.05
			wait(0.05)
		end
	elseif currentNumber == 1 then
		currentNumber = 0
		for _ = 1,20 do
			new.Rotation -= 1
			new.TextStrokeTransparency += 0.05
			new.TextTransparency += 0.05
			new.StrengthImage.ImageTransparency += 0.05
			wait(0.05)
		end
	end
	new:Destroy()
	wait()
	
	
end

Remotes.UpdateStrPopup.OnClientEvent:Connect(StrengthPopup)
