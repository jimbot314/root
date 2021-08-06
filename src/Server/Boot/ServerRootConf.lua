local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

local RobloxServices = require(ReplicatedStorage.RobloxServices)
local concat = require(ReplicatedStorage.concat)
local merge = require(ReplicatedStorage.merge)

local ROOT_ENV = RunService:IsStudio() and "Development" or "Production"
local SharedConfig = ReplicatedStorage.SharedConfig
local GameConf = require(SharedConfig.GameProductionConf)

if (ROOT_ENV == "Development") then
  merge(GameConf, require(SharedConfig.GameDevelopmentConf))
end

local ServerRootConf = {
  RootIgnore = {
    LegacyAssets = "Folder"
  },

  EntryPoints = {
    ReplicatedStorage.Shared,
    ServerScriptService.ServerModules,
    ServerStorage
  },

  RootProperties = concat({
      ROOT_ENV = ROOT_ENV,
      SYSTEM_ENV = "Server",
    },
    RobloxServices,
    GameConf
  ),

  ModuleTypes = {
    "Service",
    "Store",
    "Helper",
    "Info"
  },

  EventModuleTypes = {
    Service = true,
    Info = true
  }


}

return ServerRootConf