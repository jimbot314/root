local ServerScriptService = game:GetService("ServerScriptService")
local ServerRootModule = require(ServerScriptService.Boot.ServerRootModule)

ServerRootModule:Init()
ServerRootModule:Start()