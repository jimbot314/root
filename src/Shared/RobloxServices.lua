local RobloxServices = {
	["Workspace"] = game:GetService("Workspace"),
	["ServerStorage"] = game:GetService("ServerStorage"),
	["ReplicatedStorage"] = game:GetService("ReplicatedStorage"),
	["ReplicatedFirst"] = game:GetService("ReplicatedFirst"),
	["ServerScriptService"] = game:GetService("ServerScriptService"),
	["StarterGui"] = game:GetService("StarterGui"),
	["StarterPack"] = game:GetService("StarterPack"),
	["StarterPlayer"] = game:GetService("StarterPlayer"),
	["Players"] = game:GetService("Players"),
	["Lighting"] = game:GetService("Lighting"),
	["Teams"] = game:GetService("Teams"),
	["TweenService"] = game:GetService("TweenService"),
	["RunService"] = game:GetService("RunService"),
	["ContextActionService"] = game:GetService("ContextActionService"),
	["UserInputService"] = game:GetService("UserInputService"),
	["CollectionService"] = game:GetService("CollectionService"),
	["PathfindingService"] = game:GetService("PathfindingService"),
	["SoundService"] = game:GetService("SoundService"),
	["MarketplaceService"] = game:GetService("MarketplaceService"),
	["PhysicsService"] = game:GetService("PhysicsService"),
	["DataStoreService"] = game:GetService("DataStoreService"),
	["TeleportService"] = game:GetService("TeleportService"),
	["ContentProvider"] = game:GetService("ContentProvider")
}

-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local SharedFolder = ReplicatedStorage.Shared
-- local RobloxServicesFolder = SharedFolder.RobloxServices
-- for serviceName,service in pairs(RobloxServices) do
-- 	if (RobloxServicesFolder:FindFirstChild(serviceName)) then continue end
-- 	local moduleScript = Instance.new("ModuleScript")
-- 	moduleScript.Name = serviceName
-- 	local source = ('return game:GetService("%s")'):format(serviceName)
-- 	moduleScript.Source = source
-- 	moduleScript.Parent = RobloxServicesFolder
-- end

return RobloxServices
