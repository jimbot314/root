local fireAllClientsExcept = {}

function fireAllClientsExcept:Main(self, ...)
	return self.NetworkService:FireAllClientsExcept(...)
end

return fireAllClientsExcept
