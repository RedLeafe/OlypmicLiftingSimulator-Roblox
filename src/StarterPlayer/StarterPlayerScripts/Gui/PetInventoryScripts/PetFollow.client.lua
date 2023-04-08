local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

local PetsConfig = require(ReplicatedStorage.Configs.PetsConfig)
local StateManager = require(ReplicatedStorage.Client.StateManager)
local Remotes = ReplicatedStorage.Remotes.PetRemotes

-- hash table with player User Id has a key
local EquippedPets: { [string] : { [string] : PetsConfig.PetInstance} } = {}

--posible pet starting positions when equipping
local PetPositions = {
    {
        Position = Vector3.new(0, 1, 10),
        Orientation = Vector3.new(0, -90, 0)
    },
    {
        Position = Vector3.new(-7.5, 1, 8),
        Orientation = Vector3.new(0, -120, 0)
    },
    {
        Position = Vector3.new(7.5, 1, 8),
        Orientation = Vector3.new(0, -60, 0)
    },
}

local function getPetOrder(character : Model)
    local petFolder = character:FindFirstChild("Pets")
    if not petFolder then return 1 end

    if #petFolder:GetChildren() == 0 then
        return 1
    end

    local activeSlots = {}
    for _, pet in petFolder:GetChildren() do
        local order = pet.Order.Value
        activeSlots[order] = order
    end

    for availableSlot = 1, 5, 1 do
        if not activeSlots[availableSlot] then
            return availableSlot
        end
    end

end

local function PetFollow(player : Player, pet: PetsConfig.PetInstance)
    local character = player.Character or player.CharacterAdded:Wait()
    if not character then return end

    local humanoidRootPart : Part = character:WaitForChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local pets = EquippedPets[tostring(player.UserId)]
    if not pets then return end

    pets[pet.UUID] = pet

    local petsFolder = character:FindFirstChild("Pets")
    if not petsFolder then
        petsFolder = Instance.new("Folder", character)
        petsFolder.Name = "Pets"
    end

    local petModel : Model = ReplicatedStorage.Pets:FindFirstChild(pet.Model):Clone()
    petModel:PivotTo(humanoidRootPart.CFrame)

    local charAttachment = Instance.new("Attachment", humanoidRootPart)
    charAttachment.Visible = false

    local petAttachment = Instance.new("Attachment", petModel.PrimaryPart)
    petAttachment.Visible = false

    local alignPosition = Instance.new("AlignPosition", petModel)
    alignPosition.MaxForce = 25_000
    alignPosition.Responsiveness = 25
    alignPosition.Attachment0 = petAttachment
    alignPosition.Attachment1 = charAttachment

    local alignOrientation = Instance.new("AlignOrientation", petModel)
    alignOrientation.MaxTorque = 25_000
    alignOrientation.Responsiveness = 25
    alignOrientation.Attachment0 = petAttachment
    alignOrientation.Attachment1 = charAttachment

    local order = Instance.new("IntValue", petModel)
    order.Name = "Order"
    order.Value = getPetOrder(character)

    local petPosition = PetPositions[order.Value]
    charAttachment.Position = petPosition.Position
    charAttachment.Orientation = petPosition.Orientation

    petModel.Name = pet.UUID
    petModel.Parent = petsFolder
end

local function InitalizePlayer(player: Player)
    local pets = EquippedPets[tostring(player.UserId)]
    if not pets then
        EquippedPets[tostring(player.UserId)] = {}
        return
    end
    
    for uuid, pet in pets do
        PetFollow(player, pet)
    end
end

Remotes.EquipPet.OnClientEvent:Connect(function(uuid)
    local petInstance = StateManager.GetData().Pets[uuid]
    local pets = EquippedPets[tostring(Player.UserId)]
    pets[uuid] = petInstance
    PetFollow(Player,petInstance)
end)


--delays any function from running untill all data is loaded in
StateManager.GetData()

EquippedPets = Remotes.GetEquippedPets:InvokeServer()
for _, player in Players:GetPlayers() do
    player.CharacterAdded:Connect(function(character)
        InitalizePlayer(player)
    end)
    InitalizePlayer(player)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        InitalizePlayer(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    local pets = EquippedPets[tostring(player.UserId)]
    if pets then
        EquippedPets[tostring(player.UserId)] = nil
    end
end)