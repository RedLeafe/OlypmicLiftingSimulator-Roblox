local ServerScriptService = game:GetService("ServerScriptService")
local ServerScriptService = game:GetService("ServerScriptService")

local Pets = require(ServerScriptService.Pets)

return function (context, player: Player, pet : string)
    local petInstance = Pets.CreatePet(pet)
    return Pets.GivePet(player,petInstance)
end