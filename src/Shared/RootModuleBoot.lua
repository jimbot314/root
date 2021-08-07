local ServerRootModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local ServerStorage = game:GetService("ServerStorage")
-- local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

-- local SharedFolder = ReplicatedStorage.Shared
-- local ServerModules = ServerScriptService.ServerModules
local VendorModules = ReplicatedStorage.VendorModules
local RootLib = ReplicatedStorage.Root.Shared.RootLib
local RootModuleUtils = RootLib.RootModuleUtils
-- local GameConfigDev = require(ReplicatedStorage.SharedConfig.GameConfigDev)
-- local GameConfigProd = require(ReplicatedStorage.SharedConfig.GameConfigProd)
-- local rootignore = require(ServerScriptService.Boot.rootignore)

local registerFullSubscriptions = require(RootModuleUtils.registerFullSubscriptions)

local registerRemotes = require(RootModuleUtils.registerRemotes)


local ROOT_ENV = RunService:IsStudio() and "Dev" or "Prod"

-- local GameConfig = ROOT_ENV == "Dev" and GameConfigDev or GameConfigProd

local rootTable = {
	Name = "RootTable", 
	ClassName = "LocalTable", 
	Folders = {
		Name = "RootFolders"
	},
	Models = {
		Name = "Models"
	},
	Sounds = {
		Name = "Sounds"
	},
	
	-- ROOT_ENV = ROOT_ENV
}
local vendorTable = {Name = "VendorTable", ClassName = "LocalTable"}
local rootMt = {
	Name = "RootMt",
	ClassName = "LocalTable",
	__index = function(self, key)
		if (rootTable[key] ~= nil) then
			self[key] = rootTable[key]
			return rootTable[key]
		end
		local imports = rawget(self, "__includes")
		--print(key, imports, self)
		if (imports ~= nil and type(imports) == "string") then
			imports = {imports} -- change it to a table if it's a string
			self.__includes = imports
		--else (imports could also be a table)
			--imports = {} (this would unintentionally reset the table)
		elseif (imports == nil) then
			imports = {}
		end
		local match
		for i=1,#imports do
			local module = rootTable[imports[i]]
			if (module[key] ~= nil) then
				-- print(key)
				-- match = module

				local fn = function(importIgnore, ...)
					return module[key](module, ...) -- ignores the self from the importing module colon syntax
				end
				self[key] = fn
				return fn
				-- break
			end
		end
		if (rawget(self, "__extends")) then
			local module = rootTable[self.__extends]
			
			self.super = module
			if (key == "super") then
				return module
			end
			--print(self, key)
			local result
			if (rawget(module, "__find")) then
				
				result = module.__find(self, key)
			else
				result = module[key]
			end
			if (result ~= nil) then
				self[key] = result
				return result
			end
		end
		
		if (match ~= nil) then
			local value = match[key]
			if (type(value) == "function") then
				self[key] = function(...)
					return match[key](match, ...)
				end
			else
				self[key] = value
			end
			return self[key]
		elseif (rootTable[key] ~= nil) then
			self[key] = rootTable[key]
			return rootTable[key]
		-- elseif (GameConfig[key] ~= nil) then
			-- self[key] = GameConfig[key]
			-- return GameConfig[key]
		else
			self[key] = vendorTable[key]
			return vendorTable[key]
		end
	end,
	
	__call = function(self, ...)
		if (self.Main) then
			return self.Main(self, ...)
		else
			error("Attempt to call a table without 'Main'", 2)
		end
	end,
	__metatable = rootTable
}

function ServerRootModule:Init(config)
	self._entryPoints = config.EntryPoints -- {SharedFolder, ServerModules, ServerStorage}
	self._rootIgnore = config.RootIgnore
	self._rootProperties = config.RootProperties
	self._moduleTypes = config.ModuleTypes
	self._eventModuleTypes = config.EventModuleTypes
	self._endpoints = {Name = "EndpointsTable"}
	
	self:_ConstructRootMt(self._entryPoints)
	self:_AddRootProperties()
	-- self:_HandleVendorModules(VendorModules)
	if (self._rootProperties.SYSTEM_ENV == "Server") then
		rootTable.NetworkService.Endpoints = self._endpoints
	else
		rootTable.NetworkController.Endpoints = self._endpoints
		game:GetService("Players").LocalPlayer:WaitForChild("PlayerDataLoaded")
	end
	self:_InitModules()
end

function ServerRootModule:Start()
	self:_StartModules()
end


function ServerRootModule:_ConstructRootMt(entryPoints)
	for i=1,#entryPoints do
		local entryPoint = entryPoints[i]
		self:_HandleEntryPoint(entryPoint)
	end
	self:_HandleVendorModules(VendorModules)
end

function ServerRootModule:_HandleEntryPoint(entryPoint)
	local instances = entryPoint:GetChildren()
	for i=1,#instances do
		local instance = instances[i]
		
		local instanceName = instance.Name
		if (self._rootIgnore[instanceName]) then
			continue
		end
		if (instance.ClassName == "ModuleScript") then
			
			self:_CheckTableDoesNotHaveKey(rootTable, instanceName)
			-- if (self._rootProperties.SYSTEM_ENV == "Client") then print(instanceName) end
			local module = require(instance)
			local moduleType = self:_GetModuleType(instance)
			
			
			rootTable[instanceName] = module
			if (type(module) ~= "table") then continue end
			module.ClassName = moduleType
			
			--if (getmetatable(module) ~= nil) then
			--	local warnMsg = "Warning: %s has an mt that will not be overriden"
			--	warn(warnMsg:format(instanceName))
			--	continue
			--end
			self:_DeepInject(module)
		elseif (instance.ClassName == "Folder") then
			self:_CheckTableDoesNotHaveKey(rootTable.Folders, instanceName)
			rootTable.Folders[instanceName] = instance
			self:_HandleEntryPoint(instance)
		else
			-- pluralization means appending an s
			-- does not take into account irregulars
			local category = ("%ss"):format(instance.ClassName)
			if (rootTable[category] == nil) then
				rootTable[category] = {
					Name = category
				}
			end
			rootTable[category][instanceName] = instance
		end
		-- elseif (instance.ClassName == "Model") then
		-- 	self:_CheckTableDoesNotHaveKey(rootTable.Models, instanceName)
		-- 	rootTable.Models[instanceName] = instance
		-- elseif (instance.ClassName == "Sound") then
		-- 	self:_CheckTableDoesNotHaveKey(rootTable.Sounds, instanceName)
		-- 	rootTable.Sounds[instanceName] = instance
		-- end
	end
end

function ServerRootModule:_AddRootProperties()
	for name,value in pairs(self._rootProperties) do
		self:_CheckTableDoesNotHaveKey(rootMt, name)
		rootTable[name] = value
	end
end

function ServerRootModule:_HandleVendorModules(vendorModules)
	for k,vendorModule in pairs(vendorModules:GetChildren()) do
		local moduleName = vendorModule.Name
		if (self._rootignore[moduleName]) then
			continue
		end
		if (vendorModule.ClassName ~= "ModuleScript") then
			local errorMsg = "%s not a module script!"
			error(errorMsg:format(moduleName))
		end
		self:_CheckTableDoesNotHaveKey(rootTable, moduleName)
		self:_CheckTableDoesNotHaveKey(vendorTable, moduleName)
		local module = require(vendorModule)
		vendorTable[moduleName] = module
	end
end


function ServerRootModule:_InitModules()
	local eventModuleTypes = self._eventModuleTypes
	for moduleName,module in pairs(rootTable) do
		if (type(module) == "table") then
			-- if (moduleName == "StylesCompilerService") then
			-- 	print(module.ClassName)
			-- 	print(eventModuleTypes)
			-- end
			if (eventModuleTypes[module.ClassName] ~= nil) then
				registerFullSubscriptions(module, rootTable.PubSub)
				registerRemotes(module, self._endpoints)
			end
			--if (module.Init) then
			--	module:Init()
			--end
		end
	end
	-- It's supposed to be capitalized!
	print("Initialize module")
	rootTable.PubSub:EmitSync("Init")
	print("All modules initialized")
end

function ServerRootModule:_StartModules()
	--for moduleName,module in pairs(rootTable) do
	--	if (type(module) == "table" and module.Start) then
	--		coroutine.wrap(function()
	--			module:Start()
	--		end)()
	--	end
	--end
	rootTable.PubSub:Emit("Start")
end

function ServerRootModule:_CheckTableDoesNotHaveKey(tbl, key)
	if (tbl[key]) then
		local tableName = tbl.Name or "Unnamed"
		local errorMsg = "Error: %s was already added to %s, module names must be unique"
		error(errorMsg:format(key, tableName))
	end
end

function ServerRootModule:_DeepInject(tbl)
	repeat
		local mt = getmetatable(tbl)
		if (mt ~= nil) then
			warn("Mt found in returned module, make sure it has the proper metamethod, so it does not return the routing table")
			tbl = mt
		end
	until mt == nil
	setmetatable(tbl, rootMt)
end

-- Gets module type based on module name
function ServerRootModule:_GetModuleType(moduleInstance)
	local name = moduleInstance.Name


	-- local moduleTypes = {
	-- 	"Service",
	-- 	"Store",
	-- 	"Helper",
	-- }

	local moduleTypes = self._moduleTypes
	
	for i=1,#moduleTypes do
		local moduleType = moduleTypes[i]
		if (name:sub(-#moduleType) == moduleType) then
			return moduleType
		end
	end
	return "Module"
end

return ServerRootModule
