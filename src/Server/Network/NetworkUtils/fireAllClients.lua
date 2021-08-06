local fireAllClients = {}

function fireAllClients:Main(self, ...)
	return self.NetworkService:FireAllClients(...)
end

return fireAllClients
