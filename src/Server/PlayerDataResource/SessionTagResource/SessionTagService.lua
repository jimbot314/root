local SessionTagService = {
	__includes = "SessionTagStore"
}

function SessionTagService:__OnPlayerDataLoaded(plr, data)
	self:Set(plr, data.SessionTag)
end

function SessionTagService:__OnClientDataRequested(plr, clientData)
	-- clientData.SessionTag = self.Get(plr)
	local get = self.Get
	get(self, plr)
end

return SessionTagService
