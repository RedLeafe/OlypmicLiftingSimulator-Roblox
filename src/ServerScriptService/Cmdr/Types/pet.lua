local ReplicatedStorage = game:GetService("ReplicatedStorage")

local pets = {}

for _, model in ReplicatedStorage.Pets:GetChildren() do
    table.insert(pets, model.Name)
end

return function (registry)
    registry:RegisterType("pet", registry.Cmdr.Util.MakeEnumType("pet", pets))
end