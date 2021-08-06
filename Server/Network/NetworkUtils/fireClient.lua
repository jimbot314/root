local fireClient = {}

function fireClient:Main(self, ...)
	self.NetworkService:FireClient(...)
end

return fireClient
