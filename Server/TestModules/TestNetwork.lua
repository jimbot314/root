local TestNetwork = {}

function TestNetwork:__OnInit()
	local TestCommandsFolder = script.Parent.TestCommands
	self.TestCommands = {}
	self.PubSub:On("Hi", function(a,b) print(a,b) end)
	for k,child in pairs(TestCommandsFolder:GetChildren()) do
		if (child.ClassName == "ModuleScript") then
			local moduleName = child.Name
			local module = require(child)
			if (self.TestCommands[moduleName]) then
				local errorMsg = "%s module already exists as a test command"
				error(errorMsg:format(moduleName))
			end
			self.TestCommands[moduleName] = module
		end
	end
	return
end

function TestNetwork:__OnStart()
	self.ReplicatedStorage.TestRemoteFunction.OnServerInvoke = function(player, command)
		if (not self.TestingPermissions[player.UserId]) then return {Status = 400, Message = "Access denied"} end
		local words = command:split(" ")
		local method = table.remove(words, 1)
		if (not self.TestCommands[method]) then
			return {Status = 400, Message = ("%s not found"):format(method)}
		end
		local result = self.TestCommands[method](table.unpack(words)) or "Nil"
		
		return {Status = 200, Message = result}
	end
end



return TestNetwork
