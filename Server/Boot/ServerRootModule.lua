local ServerRootModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RootModuleBoot = require(ReplicatedStorage.RootModuleBoot)

-- entry points
-- root ignore
-- root properties?
-- module types
-- events registration module list


function ServerRootModule:Init()
	local config = require(script.Parent.ServerRootConf)
	RootModuleBoot:Init(config)
	-- supply entry points
	-- rootignore specify the classname
	-- modularize parts that are for root and for game
	-- what to do with sharedConfigs?

	-- change the network utils to use colon syntax
end

function ServerRootModule:Start()
	RootModuleBoot:Start()
end

return ServerRootModule
