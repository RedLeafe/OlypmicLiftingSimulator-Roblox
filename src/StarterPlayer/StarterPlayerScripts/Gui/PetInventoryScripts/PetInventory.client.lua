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

local INFO_MULTIPLIER_STRING = "Multiplier : AMOUNT"

local EQUIP_BUTTON_COLOR = Color3.fromRGB(127, 206, 115)
local UNEQUIP_BUTTON_COLOR = Color3.fromRGB(255, 98, 101)

local selectedPet: string?

local function UpdateInfo(uuid :string)
    local pet : PetsConfig.PetInstance = StateManager.GetData().Pets[uuid]
    if not pet then return end

    selectedPet = uuid

    Info.Visible = true
    Info.PetName.Text = pet.Name
    
    local model = ReplicatedStorage.Pets:FindFirstChild(pet.Model)
    ViewportModel.CleanViewport(Info.ViewportFrame)
    ViewportModel.GenerateViewPort(Info.ViewportFrame, model:Clone(), CFrame.Angles(0, math.rad(-90), 0))

    local multiplierStat = PetsConfig.GetPetMultiplier(pet)
    Info.Stats.PetMultiplierText = INFO_MULTIPLIER_STRING:gsub("AMOUNT", FormatNumber.FormatCompact(multiplierStat))
    
end

local function GeneratePet(pet : PetsConfig.PetInstance)
    local clone = PetTemplate:Clone()
    clone.Parent = Container
    clone.Visible = true
    clone.Name = pet.UUID

    clone.PetName.Text = pet.Name
    clone.Equipped.Visible = pet.Equipped
    clone.Multiplier.Text = FormatNumber.FormatCompact(PetsConfig.GetPetMultiplier(pet))

    local model = ReplicatedStorage.Pets:FindFirstChild(pet.Model)
    ViewportModel.GenerateViewport(clone.ViewportFrame, model:Clone(), CFrame.Angles(0, math.rad(-90), 0))

    clone.MouseButton1Click:Connect(function()
        UpdateInfo(pet.UUID)
    --not implemented yet    
    end)
end



OpenButton.MouseButton1Click:Connect(function()
    Gui.Enabled = not Gui.Enabled
end)
Exit.MouseButton1Click:Connect(function()
    Gui.Enabled = false
end)


--[[
Remotes.GivePet.OnClientEvent:Connect()
Remotes.DeletePet.OnClientEvent:Connect()
Remotes.EquipPet.OnClientEvent:Connect()
Remotes.UnequipPet.OnClientEvent:Connect()
]]