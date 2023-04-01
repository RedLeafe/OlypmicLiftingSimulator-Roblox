local ServerScriptService = game:GetService("ServerScriptService")

local Cmdr = require(ServerScriptService.Libs.Cmdr)

local TypesFolder = script.Parent.Types
local CommandsFolder = script.Parent.Commands
local HooksFolder = script.Parent.Hooks

Cmdr:RegisterDefaultCommands()
Cmdr:RegisterTypesIn(TypesFolder)
Cmdr:RegisterCommandsIn(CommandsFolder)
Cmdr:RegisterHooksIn(HooksFolder)
