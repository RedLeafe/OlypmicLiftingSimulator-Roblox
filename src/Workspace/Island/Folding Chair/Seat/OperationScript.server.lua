local WaitFor = (function(parent, child_name)
	local found = parent:FindFirstChild(child_name)
	while found == nil do
		parent.ChildAdded:wait()
		found = parent:FindFirstChild(child_name)
		if found then break end
	end
	return found
end)

local last = { neckC1 = nil, rshoC0 = nil, lshoC0 = nil, rhipC0 = nil, lhipC0 = nil }

local ApplyModifications = (function(weld, char)
	local torso = WaitFor(char, "Torso")
	local neck = WaitFor(torso, "Neck")
	local rsho = WaitFor(torso, "Right Shoulder")
	local lsho = WaitFor(torso, "Left Shoulder")
	local rhip = WaitFor(torso, "Right Hip")
	local lhip = WaitFor(torso, "Left Hip")

	local config = script.Parent.Configuration
	local head_ang = config["Head Angle"].Value
	local legs_ang = config["Legs Angle"].Value
	local arms_ang = config["Arms Angle"].Value
	local sit_ang  = config["Sitting Angle"].Value
	local sit_pos  = config["Sitting Position"].Value

	--First adjust sitting position and angle
	--Add 90 to the angle because that's what most people will be expecting.
	weld.C1 = weld.C1 * CFrame.fromEulerAnglesXYZ(math.rad((sit_ang) + 90), 0, 0)
	
	weld.C0 = CFrame.new(sit_pos)

	last.neckC1 = neck.C1
	last.rshoC0 = rsho.C0
	last.lshoC0 = lsho.C0
	last.rhipC0 = rhip.C0
	last.lhipC0 = lhip.C0

	--Now adjust the neck angle.
	neck.C1 = neck.C1 * CFrame.fromEulerAnglesXYZ(math.rad(head_ang), 0, 0)
	

	--Now adjust the arms angle.
	rsho.C0 = rsho.C0 * CFrame.fromEulerAnglesXYZ(0, 0, math.rad(arms_ang))
	lsho.C0 = lsho.C0 * CFrame.fromEulerAnglesXYZ(0, 0, math.rad(-arms_ang))
	

	--Now the legs
	rhip.C0 = rhip.C0 * CFrame.fromEulerAnglesXYZ(0, 0, math.rad(legs_ang))
	lhip.C0 = lhip.C0 * CFrame.fromEulerAnglesXYZ(0, 0, math.rad(-legs_ang))
end)

local RevertModifications = (function(weld, char)
	--Any modifications done in ApplyModifications have to be reverted here if they
	--change any welds - otherwise people will wonder why their head is pointing the wrong way.

	local torso = WaitFor(char, "Torso")
	local neck = WaitFor(torso, "Neck")
	local rsho = WaitFor(torso, "Right Shoulder")
	local lsho = WaitFor(torso, "Left Shoulder")
	local rhip = WaitFor(torso, "Right Hip")
	local lhip = WaitFor(torso, "Left Hip")


	--Now adjust the neck angle.
	neck.C1 = last.neckC1 or CFrame.new()

	rsho.C0 = last.rshoC0 or CFrame.new()
	lsho.C0 = last.lshoC0 or CFrame.new()

	rhip.C0 = last.rhipC0 or CFrame.new()
	lhip.C0 = last.lhipC0 or CFrame.new()

	weld:Destroy()
end)

script.Parent.ChildAdded:connect(function(c)
	if c:IsA("Weld") then
		local character = nil
		if c.Part1 ~= nil and c.Part1.Parent ~= nil and c.Part1.Parent:FindFirstChild("Humanoid") ~= nil then
			character = c.Part1.Parent
		else return end
		ApplyModifications(c, character)
	end
end)

script.Parent.ChildRemoved:connect(function(c)
	if c:IsA("Weld") then
		local character = nil
		if c.Part1 ~= nil and c.Part1.Parent ~= nil and c.Part1.Parent:FindFirstChild("Humanoid") ~= nil then
			character = c.Part1.Parent
		else return end
		RevertModifications(c, character)
	end
end)