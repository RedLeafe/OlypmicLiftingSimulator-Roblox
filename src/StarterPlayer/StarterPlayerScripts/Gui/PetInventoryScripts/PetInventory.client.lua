local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FormatNumber = require(ReplicatedStorage.Libs.FormatNumber.Simple)
local ViewportModel = require(ReplicatedStorage.Libs.ViewportModelLib.ViewportModel)
local StateManager = require(ReplicatedStorage.Client.StateManager)
local PetsConfig = require(ReplicatedStorage.Configs.PetsConfig)
local Remotes = ReplicatedStorage.Remotes.PetRemotes

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local LeftGui = PlayerGui:WaitForChild("Left")
local OpenButton = LeftGui.Frame.Buttons.Pets

local Gui = PlayerGui:WaitForChild("PetInventoryGUI")
local Frame = Gui.Frame
local WarningFrame = Gui.Warning

local Searchbar = Frame.SearchFrame.SearchBar
local StorageFrame = Frame.StorageFrame
local HolderButtons = Frame.PetHolder.Buttons
local Container = Frame.PetHolder.PetContainer
local Info = Frame.PetHolder.PetInfo

local PetTemplate = Container.Template

local Exit = Frame.Exit

local INFO_MULTIPLIER_STRING = "Multiplier : AMOUNTX"

local WARNING_SUBTITLE_STRING = "Are you sure you want to delete AMOUNT pets?"

local EQUIP_BUTTON_COLOR = Color3.fromRGB(127, 206, 115)
local UNEQUIP_BUTTON_COLOR = Color3.fromRGB(255, 98, 101)

local TRASH_MODE_BUTTON_COLOR = Color3.fromRGB(255, 119, 133)

local selectedPet: string?
local selectedPets = {}
local isSelecting = false

local function UpdateInfo(uuid :string)
    local pet : PetsConfig.PetInstance = StateManager.GetData().Pets[uuid]
    if not pet then return end

    selectedPet = uuid

    Info.Visible = true
    Info.PetName.Text = pet.Name
    
    local model = ReplicatedStorage.Pets:FindFirstChild(pet.Model)
    print(model)
    ViewportModel.CleanViewport(Info.ViewportFrame)
    ViewportModel.GenerateViewPort(Info.ViewportFrame, model:Clone(), CFrame.Angles(0, math.rad(-90), 0))
        
    local multiplierStat = PetsConfig.GetPetMultiplier(pet)
    Info.Stats.PetMultiplierText.Text = INFO_MULTIPLIER_STRING:gsub("AMOUNT", FormatNumber.FormatCompact(multiplierStat))
    
end

local function GeneratePet(pet : PetsConfig.PetInstance)
    local clone = PetTemplate:Clone()
    clone.Parent = Container
    clone.Visible = true
    clone.Name = pet.UUID

    clone.PetName.Text = pet.Name
    clone.Equipped.Visible = pet.Equipped
    clone.Multiplier.Text = FormatNumber.FormatCompact(PetsConfig.GetPetMultiplier(pet)).."X"

    local model = ReplicatedStorage.Pets:FindFirstChild(pet.Model)
    ViewportModel.GenerateViewport(clone.ViewportFrame, model:Clone(), CFrame.Angles(0, math.rad(-90), 0))

    clone.MouseButton1Click:Connect(function()
        if isSelecting then
            local petState: PetsConfig.PetInstance = StateManager.GetData().Pets[pet.UUID]
            if petState.Equipped then return end

            local index = table.find(selectedPets, pet.UUID)
            clone:FindFirstChild("Selected").Visible = not index
            if index then
                table.remove(selectedPets, index)
            else 
                table.insert(selectedPets,pet.UUID)
            end
        
        else
        UpdateInfo(pet.UUID)
        end
    end)
end

local function UpdatePet(uuid : string)
    local pet : PetsConfig.PetInstance = StateManager.GetData().Pets[uuid]
    local button = Container:FindFirstChild(uuid)
    button.PetName.Text = pet.Name
    button.Equipped.Visible = pet.Equipped
    button.Multiplier.Text = FormatNumber.FormatCompact(PetsConfig.GetPetMultiplier(pet))
    button.LayoutOrder = if pet.Equipped then -1 else 0

    if selectedPet == uuid then
        UpdateInfo(uuid)
    end
end

local function UpdateStorage()
    local equipped = #PetsConfig.GetEquippedPets(StateManager.GetData())
    local maxEquipped = PetsConfig.GetMaxedEquippedPets(StateManager.GetData())
    StorageFrame.EquippedFrame.EquippedLabel.Text = equipped.."/"..maxEquipped


    local stored = PetsConfig.GetTotalStoredPets(StateManager.GetData())
    local maxStored = PetsConfig.GetMaxedStoredPets(StateManager.GetData())
    StorageFrame.PetStorageFrame.PetStorageLabel.Text = stored.."/"..maxStored
end

local function DeletePet(uuid : string)
    local button = Container:FindFirstChild(uuid)
    button:Destroy()

    if selectedPet == uuid then
        selectedPet = nil
        Info.Visible = false
    end

    task.delay(0, function()
        UpdateStorage()
    end)
end

local function SelectMode(enabled : boolean)
    isSelecting = enabled
    HolderButtons.TrashMode.BackgroundColor3 = if isSelecting then EQUIP_BUTTON_COLOR else TRASH_MODE_BUTTON_COLOR

    if not isSelecting then
        for _, children in Container:GetChildren() do
            if not children:IsA("GuiButton") then continue end
            children:FindFirstChild("Selected").Visible = false
        end
    end
    selectedPets = {}
end

local function UpdateSearchedPets()
    local input = string.upper(Searchbar.Text)

    local uuids = {}
    for uuid, pet : PetsConfig.PetInstance in StateManager.GetData().Pets do
        if string.find(string.upper(pet.Model), input) then 
            table.insert(uuids,pet.UUID)
        end
    end

    for _, child in Container:GetChildren() do
        if not child:IsA("GuiButton") or child.Name == "Template" then continue end
        child.Visible = table.find(uuids, child.Name) or input == ""
    end
end

--[[
--supposed to update a total multiplier on the gui
local function UpdateTotal()
    local totalMultiplier = PetsConfig.GetEquippedMultiplier(StateManager.GetData()) 
    --implement a gui component that shows the pet multiplier if we want it   
end
]]--

Info.Buttons.Equip.MouseButton1Click:Connect(function()
    SelectMode(false)
    if selectedPet then 
        Remotes.EquipPet:FireServer(selectedPet)
    end
end)

Info.Buttons.Unequip.MouseButton1Click:Connect(function()
    SelectMode(false)
    if selectedPet then 
        Remotes.UnequipPet:FireServer(selectedPet)
    end
end)

Info.Buttons.Upgrade.MouseButton1Click:Connect(function()
    SelectMode(false)
    --updgrade button    
end)

HolderButtons.Delete.MouseButton1Click:Connect(function()
    if isSelecting then
        WarningFrame.Subtitle.Text = WARNING_SUBTITLE_STRING:gsub("AMOUNT", FormatNumber.FormatCompact(#selectedPets))
        WarningFrame.Visible = true
    end
    if not selectedPet then return end

    Remotes.DeletePet:FireServer(selectedPet)
end)

HolderButtons.UnequipAll.MouseButton1Click:Connect(function()
    SelectMode(false)
    Remotes.UnequipAllPets:FireServer()
end)

HolderButtons.EquipBest.MouseButton1Click:Connect(function()
    SelectMode(false)
    Remotes.EquipBestPets:FireServer()
end)

HolderButtons.TrashMode.MouseButton1Click:Connect(function()
    if isSelecting then
        if #selectedPets == 0 then
            SelectMode(false)
        end
    else
        SelectMode(true)
    end
end)

WarningFrame.ConfirmDelete.MouseButton1Click:Connect(function()
    if isSelecting then
        Remotes.DeletePet:FireServer(selectedPets)
        SelectMode(false)
    end
    WarningFrame.Visible = false
end)

WarningFrame.BackButton.MouseButton1Click:Connect(function()
    WarningFrame.Visible = false
    if isSelecting then
        SelectMode(false)
    end
end)

Searchbar.Changed:Connect(UpdateSearchedPets)

OpenButton.MouseButton1Click:Connect(function()
    Gui.Enabled = not Gui.Enabled
    Searchbar.Text = ""
    UpdateSearchedPets()
end)
Exit.MouseButton1Click:Connect(function()
    SelectMode(false)
    Gui.Enabled = false
end)



Remotes.GivePet.OnClientEvent:Connect(function(pet : PetsConfig.PetInstance)
    task.delay(0, function() 
        GeneratePet(pet)
        UpdateStorage()
        --UpdateTotal()
    end)
end)

Remotes.DeletePet.OnClientEvent:Connect(DeletePet)
Remotes.EquipPet.OnClientEvent:Connect(function(pet : PetsConfig.PetInstance)
    task.delay(0, function() 
        UpdatePet(pet)
        UpdateStorage()
        --UpdateTotal()
    end)
end)

Remotes.UnequipPet.OnClientEvent:Connect(function(pet : PetsConfig.PetInstance)
    task.delay(0, function() 
        UpdatePet(pet)
        UpdateStorage()
        --UpdateTotal()
    end)
end)

--UpdateTotal
UpdateStorage()
for uuid, pet in StateManager.GetData().Pets do
    GeneratePet(pet)
end

