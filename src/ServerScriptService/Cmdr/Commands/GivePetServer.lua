local ServerScriptService = game:GetService("ServerScriptService")
local ServerScriptService = game:GetService("ServerScriptService")

local PetManager = require(ServerScriptService.PetManager)

return function (context, player: Player, pet : string)
    local petInstance = PetManager.CreatePet(pet)
    return PetManager.GivePet(player,petInstance)
end