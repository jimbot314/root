local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientScriptService = ReplicatedStorage.ClientScriptService
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local RobloxServices = require(ReplicatedStorage.RobloxServices)
local concat = require(ReplicatedStorage.concat)
local merge = require(ReplicatedStorage.merge)

local ROOT_ENV = RunService:IsStudio() and "Development" or "Production"
local SharedConfig = ReplicatedStorage.SharedConfig
local GameConf = require(SharedConfig.GameProductionConf)

if (ROOT_ENV == "Development") then
  merge(GameConf, require(SharedConfig.GameDevelopmentConf))
end

local ClientRootConf = {
  RootIgnore = {
    printword = "ModuleScript",
  },

  EntryPoints = {
    ReplicatedStorage.Shared,
    ClientScriptService.ClientModules
  },

  RootProperties = concat({
      ROOT_ENV = ROOT_ENV,
      SYSTEM_ENV = "Client",
      plr = plr,
      char = char
    },
    RobloxServices,
    GameConf
  ),

  ModuleTypes = {
    "Controller",
    "Gui",
		"Partial",
    "Helper",
    "Service",
    "Info"
  },

  EventModuleTypes = {
    Controller = true,
    Service = true, -- For styles compiler service
    Info = true
  }


}

return ClientRootConf