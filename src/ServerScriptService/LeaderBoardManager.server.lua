local ServerScriptService = game:GetService("ServerScriptService")

local PlayerData = require(ServerScriptService.PlayerData.Manager)

local contentProvider = game:GetService("ContentProvider")

local leaderboards = game.Workspace:WaitForChild("Leaderboard")
local goldDummy = leaderboards:WaitForChild("#1Podium")["R15 Dummy"]
local silverDummy = leaderboards:WaitForChild("#2Podium")["R15 Dummy"]
local bronzeDummy = leaderboards:WaitForChild("#3Podium")["R15 Dummy"]

local goldHumanoid = goldDummy:WaitForChild("Humanoid")
local goldAnimation = Instance.new("Animation")
goldAnimation.AnimationId = "http://www.roblox.com/asset/?id=507771019"
contentProvider:PreloadAsync({goldAnimation})
local goldAnimationTrack = goldHumanoid:LoadAnimation(goldAnimation)
goldAnimationTrack:Play()

local silverHumanoid = silverDummy:WaitForChild("Humanoid")
local silverAnimation = Instance.new("Animation")
silverAnimation.AnimationId = "http://www.roblox.com/asset/?id=507771955"
contentProvider:PreloadAsync({silverAnimation})
local silverAnimationTrack = silverHumanoid:LoadAnimation(silverAnimation)
silverAnimationTrack:Play()

local bronzeHumanoid = bronzeDummy:WaitForChild("Humanoid")
local bronzeAnimation = Instance.new("Animation")
bronzeAnimation.AnimationId = "http://www.roblox.com/asset/?id=507772104"
contentProvider:PreloadAsync({bronzeAnimation})
local bronzeAnimationTrack = bronzeHumanoid:LoadAnimation(bronzeAnimation)
bronzeAnimationTrack:Play()

local surfaceGUI = leaderboards.StrengthLeaderboard.GlobalLB:WaitForChild("SurfaceGui")
local sample = surfaceGUI:WaitForChild("Sample")
local scrollingFrame = surfaceGUI:WaitForChild("ScrollingFrame")
local UI = scrollingFrame:WaitForChild("UIListLayout")
local Players = game:GetService("Players")

local dataStoreService = game:GetService("DataStoreService")
--Change the name of the string inside of GetOrderedDataStore to make a leaderboard
local dataStore = dataStoreService:GetOrderedDataStore("strengthLeaderboard")

wait(3)
while true do
	
    for i, plr in pairs(game.Players:GetChildren()) do
        if plr.UserId > 0 then
			--local w = plr.leaderstats.Strength.Value
			--local ps = game:GetService("PointsService")--PointsService
			--local w = ps:GetGamePointBalance(plr.UserId)
			local profile = PlayerData.Profiles[plr]
			local w = math.floor(profile.Data.Strength)
            if w then
				
                pcall(function()
					dataStore:UpdateAsync(plr.UserId, function(oldVal)
                        return tonumber(w)
                    end)
                end)
			end
        end
    end
	
    --Order of Leaderboard
    local smallestFirst = false
    --Number of ppl on leaderboard
    local numberToShow = 100
    local minValue = 1
    local maxValue = 10e30
    local pages = dataStore:GetSortedAsync(smallestFirst,numberToShow,minValue,maxValue)

	local top = pages:GetCurrentPage()

    local data = {}
    for a,b in ipairs(top) do
        local userid = b.key
        local points = b.value
		local username = "[Failed to load]"
        local s,e = pcall(function()
            username = game.Players:GetNameFromUserIdAsync(userid)
        end)
        if not s then
            warn("Error getting name for"..userid.."Error: "..e)
        end
        --If we want a picture of the player
        local image = game.Players:GetUserThumbnailAsync(userid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
		table.insert(data,{username,points,image})
	end
	
    UI.Parent = script
    scrollingFrame:ClearAllChildren()
    UI.Parent = scrollingFrame
    for number, d in pairs(data) do
        local name = d[1]
        local val = d[2]
        local image = d[3]
        local color = Color3.new(1,1,1)
        local id = Players:GetUserIdFromNameAsync(name)
        if number == 1 then
            color = Color3.new(1,1,0)
        elseif number == 2 then
            color = Color3.new(0.9,0.9,0.9)
        elseif number == 3 then
            color = Color3.new(166, 112, 0)
        end
        local new = sample:Clone()

        new.Name = id
        new.LayoutOrder = number
        new.ImageLabel.PlayerName.Text = name
		new.ImageLabel.PlayerRank.Text = "#"..number
        new.ImageLabel.PlayerRank.TextColor3 = color
		new.ImageLabel.PlayerValue.Text = val
        new.ImageLabel.PlayerValue.TextColor3 = color
		new.ImageLabel.PlayerName.TextColor3 = color
        new.Visible = true
        --might need to change this
		new.Parent = scrollingFrame

        if number == 1 then
			local goldHumanoidDescription = game.Players:GetHumanoidDescriptionFromUserId(id)
			goldDummy.Humanoid:ApplyDescription(goldHumanoidDescription)
		elseif number == 2 then
			local silverHumanoidDescription = game.Players:GetHumanoidDescriptionFromUserId(id)
			silverDummy.Humanoid:ApplyDescription(silverHumanoidDescription)
		elseif number == 3 then
			local bronzeHumanoidDescription = game.Players:GetHumanoidDescriptionFromUserId(id)
			bronzeDummy.Humanoid:ApplyDescription(bronzeHumanoidDescription)
        end
	end
	wait()
	--scrollingFrame.CanvasSize = UDim2.new(0,0,0,UI.AbsoluteContentSize.Y)
	--How often this leaderboard refreshes
	wait(180)
end