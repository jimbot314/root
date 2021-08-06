local ClientRootModule = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ClientScriptService = ReplicatedStorage.ClientScriptService

local SharedFolder = ReplicatedStorage.Shared
local ClientModules = ClientScriptService.ClientModules
local Assets = ClientScriptService.Assets
local VendorModules = ReplicatedStorage.VendorModules
local RootModuleUtils = ReplicatedStorage.RootModuleUtils
local GameConfigDev = require(ReplicatedStorage.SharedConfig.GameConfigDev)
local GameConfigProd = require(ReplicatedStorage.SharedConfig.GameConfigProd)
local rootignore = require(ClientScriptService.rootignore)

local registerFullSubscriptions = require(RootModuleUtils.registerFullSubscriptions)

local registerRemotes = require(RootModuleUtils.registerRemotes)

local endpoints = {Name = "EndpointsTable"}
local ROOT_ENV = RunService:IsStudio() and "Dev" or "Prod"

local GameConfig = ROOT_ENV == "Dev" and GameConfigDev or GameConfigProd

local rootTable = {
	Name = "RootTable", 
	Folders = {
		Name = "RootFolders"
	},
	Models = {
		Name = "Models"
	},
	Sounds = {
		Name = "Sounds"
	},
	Tools = {
		Name = "Tools"
	},
	Animations = {
		Name = "Animations"
	},
}
local vendorTable = {Name = "VendorTable"}
local rootMt = {
	Name = "RootMt",
	__index = function(self, key)
		local imports = rawget(self, "__includes")
		if (imports ~= nil and type(imports) == "string") then
			imports = {imports}
			self.__includes = imports
		elseif (imports == nil) then
			imports = {}
		end
		local match
		for i=1,#imports do
			local module = rootTable[imports[i]]
			if (rawget(module, key) ~= nil) then
				match = module
				break
			end
		end
		if (rawget(self, "__extends")) then
			local module = rootTable[self.__extends]
			
			self.super = module
			if (key == "super") then
				return module
			end
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
			self[key] = function(...)
				return match[key](match, ...)
			end
			return self[key]
		elseif (rootTable[key] ~= nil) then
			self[key] = rootTable[key]
			return rootTable[key]
		elseif (GameConfig[key] ~= nil) then
			self[key] = GameConfig[key]
			return GameConfig[key]
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
local initPriority = {NetworkController = true}

function ClientRootModule:Init()
	local entryPoints = {SharedFolder, ClientModules, Assets}
	self:_ConstructRootMt(entryPoints)
	self:_AddClientRootProperties()
	self:_HandleVendorModules(VendorModules)
	rootTable.NetworkController.Endpoints = endpoints
	local clientDataLoaded = rootTable.Player:WaitForChild("PlayerDataLoaded")
	self:_InitModules()
end

function ClientRootModule:Start()
	self:_StartModules()
end

function ClientRootModule:_ConstructRootMt(entryPoints)
	for i=1,#entryPoints do
		local entryPoint = entryPoints[i]
		self:_HandleEntryPoint(entryPoint)
	end
end

function ClientRootModule:_HandleEntryPoint(entryPoint)
	local instances = entryPoint:GetChildren()
	for i=1,#instances do
		local instance = instances[i]
		local instanceName = instance.Name
		if (rootignore[instanceName]) then continue end
		if (instance.ClassName == "ModuleScript") then

			self:_CheckTableDoesNotHaveKey(rootTable, instanceName)

			local module = require(instance)
			local moduleType = self:_GetModuleType(instance)
			
			rootTable[instanceName] = module
			if (type(module) ~= "table") then
				continue
			end
			module.ClassName = moduleType
			self:_DeepInject(module)

		elseif (instance.ClassName == "Folder") then
			self:_CheckTableDoesNotHaveKey(rootTable.Folders, instanceName)
			rootTable.Folders[instanceName] = instance

			self:_HandleEntryPoint(instance)
		else
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
		-- elseif (instance.ClassName == "Tool") then
		-- 	self:_CheckTableDoesNotHaveKey(rootTable.Tools, instanceName)
		-- 	rootTable.Tools[instanceName] = instance
		-- elseif (instance.ClassName == "Animation") then
		-- 	self:_CheckTableDoesNotHaveKey(rootTable.Animations, instanceName)
		-- 	rootTable.Animations[instanceName] = instance

		-- end
	end
end

--function ClientRootModule:_AddToRootTable(moduleScript)
--	local moduleName = moduleScript.Name
--	self:_CheckTableDoesNotHaveKey(rootTable, moduleName)
--	if (rootTable[moduleName]) then
--		local errorMsg = "Error: %s was already added to root table, module names must be unique"
--		error(errorMsg:format(moduleName))
--	else
--		local module = require(moduleScript)
--		rootTable[moduleName] = module
--		if (type(module) ~= "table") then
--			return
--		end
--		setmetatable(module, rootMt)
--	end
--end

function ClientRootModule:_AddClientRootProperties()
	local plr = rootTable.Players.LocalPlayer
	local char = plr.Character or plr.CharacterAdded:Wait()
	local properties = {
		Player = rootTable.Players.LocalPlayer,
		plr = rootTable.Players.LocalPlayer,
		PlayerGui = rootTable.Players.LocalPlayer.PlayerGui,
		char = char
	}
	for name,value in pairs(properties) do
		self:_CheckTableDoesNotHaveKey(rootMt, name)
		rootTable[name] = value
	end
end

function ClientRootModule:_HandleVendorModules(vendorModules)
	for k,vendorModule in pairs(vendorModules:GetChildren()) do
		local moduleName = vendorModule.Name
		if (rootignore[moduleName]) then
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

function ClientRootModule:_InitModules()
	--for moduleName in pairs(initPriority) do
		--rootTable[moduleName]:Init()
	--end
	--print(rootTable)
	
	for moduleName,module in pairs(rootTable) do
		
		--print(moduleName, module)
		--if (initPriority[moduleName]) then continue end
		if (type(module) == "table") then
			--if (module.ClassName == "Controller" or module.ClassName == "Gui") then
				
				registerFullSubscriptions(module, rootTable.PubSub)
				registerRemotes(module, endpoints)
			--end
			--if (module.Init) then
				--module:Init()
			--end
		end
	end
	rootTable.PubSub:EmitSync("Init")
	
end

function ClientRootModule:_StartModules()
	for moduleName,module in pairs(rootTable) do
		if (type(module) == "table" and module.Start) then
			spawn(function()
				--module:Start()
			end)
		end
	end
	rootTable.PubSub:Emit("Start")
	-- use rootTable:newInstance() !
	--rootTable.newInstance("BoolValue", {
		--Name = "ClientDataLoaded",
		--Parent = rootTable.plr
	--})
end

function ClientRootModule:_CheckTableDoesNotHaveKey(tbl, key)
	if (tbl[key]) then
		print(tbl)
		local errorMsg = "Error: %s was already added to %s, module names must be unique"
		error(errorMsg:format(key, tbl.Name))
	end
end

function ClientRootModule:_DeepInject(tbl)
	repeat
		local mt = getmetatable(tbl)
		if (mt ~= nil) then
			warn("Mt found in returned module, make sure it has the proper metamethod, so it does not return the routing table")
			tbl = mt
		end
	until mt == nil
	setmetatable(tbl, rootMt)
end

function ClientRootModule:_GetModuleType(moduleInstance)
	local name = moduleInstance.Name
	local moduleTypes = {
		"Controller",
		"Gui"
	}

	for i=1,#moduleTypes do
		local moduleType = moduleTypes[i]
		if (name:sub(-#moduleType) == moduleType) then
			return moduleType
		end
	end
	return "Module"
end

return ClientRootModule
