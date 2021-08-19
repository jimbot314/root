local fireClient = {}

function fireClient:Main(self, ...)
	local args = {...}
	if (type(args[1]) == "string") then return end -- from testing
	self.NetworkService:FireClient(...)
end

return fireClient
