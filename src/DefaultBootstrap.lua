local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local RootModuleBoot = require(ReplicatedStorage.Root.Shared.RootModuleBoot)

local config

local SYSTEM_ENV = RunService:IsServer() and "Server" or "Client"

if (SYSTEM_ENV == "Server") then
  config = require(ServerScriptService.Boot.ServerRootConf)
else
  config = require(ReplicatedStorage.ClientBoot.ClientRootConf)
end

return function()
  RootModuleBoot:Init(config)
  RootModuleBoot:Start()
end