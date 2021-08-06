local ReplicaService = {}

local replicatedStats = {}

local nonReplicatedKeys = {
	"Network"
}

function ReplicaService:__OnInit()
	
end

function ReplicaService:__OnStart()
	
end

function ReplicaService:__RecvGetReplicatedStats(player)
	local clientData = {Name = "ClientData"}
	self:emitSync("ClientDataRequested", player, clientData)
	for statName,stat in pairs(replicatedStats) do
		self:checkTableDoesNotHaveKey(clientData, statName)
		clientData[statName] = stat

	end
	self:forEach(nonReplicatedKeys, function(nonReplicatedKey)
		clientData[nonReplicatedKey] = nil
	end)
	return clientData
end

function ReplicaService:__ValGetReplicatedStats(player)
	return {
		{
			"Type",
			"validation",
			"string"
		}
	}
end

--ReplicaService.Endpoints = {
	--GetClientEndpoints = function() 
		--return clientEndpoints
	--end,
--	GetReplicatedStats = ReplicaService.GetReplicatedStats
--}

return ReplicaService
