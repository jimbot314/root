local NetworkService = {
	__includes = "NetworkStore"
}
local endpoints = {Name = "Endpoints"}


local RemoteEvent,RemoteFunction

function NetworkService:__OnInit()
	
	
	RemoteEvent = self.ReplicatedStorage.RemoteEvent
	RemoteFunction = self.ReplicatedStorage.RemoteFunction
	function NetworkService:FireClient(player, ...)
		RemoteEvent:FireClient(player, ...)
	end
	
	function NetworkService:FireAllClients(...)
		RemoteEvent:FireAllClients(...)
	end
	
	function NetworkService:FireAllClientsExcept(player, ...)
		for k,plr in pairs(self.Players:GetPlayers()) do
			if (plr == player) then
				continue
			end
			RemoteEvent:FireClient(player, ...)
		end
	end
	return
end

function NetworkService:__OnStart()
	--self.EmitSync("ClientEndpointsRegistration", endpoints)
	
	local endpoints = self.Endpoints
	RemoteEvent.OnServerEvent:Connect(function(player, endpointName, ...)
		-- check if endpoint is valid
		-- validate
		--local success, result = self:Validate(player, endpointName, ...)
		local endpoint = endpoints[endpointName]
		if (not endpoint) then
			self.Log(player, {tick(), "Did not pass event"})
		end
		endpoints[endpointName].Call(player, ...)
	end)
	RemoteFunction.OnServerInvoke = function(player, endpointName, ...)
		--local success, result = self:Validate(player, endpointName, ...)
		--if (not success) then
		--	return
		--end
		--print(success, result)
		return endpoints[endpointName].Call(player, ...)
	end
	return
end

function NetworkService:Validate(player, endpointName, ...)
	local endpoints = self.Endpoints
	if (not endpoints[endpointName]) then
		return false, "Did not even specify a correct endpoint name"
	end
	if (endpoints[endpointName].Validate == nil) then
		return true, "No validation"
	end
	local validationSuite = endpoints[endpointName].Validate(player, ...)
	for i=1,#validationSuite do
		local validation = validationSuite[i]
		local validationName = validation[1]
		--print(validation[2])
		if (self.TestUtils[validationName](select(2, table.unpack(validation))) == false) then
			warn(validationName)
			return false, "Did not pass validation"
		end
	end
	return true, "All good"
end

function NetworkService:__OnPlayerDataLoaded(plr, data)
	self.Create(plr, data)
end
--function NetworkService:Type(a, b)
	--return type(a) == b
--end

--function NetworkService:_addClientEndpoints(endpoints)
--	for endpointName,endpointFunction in pairs(endpoints) do
--		if (clientEndpoints[endpointName]) then
--			local errorMsg = "Non-unique client endpoint name detected: %s"
--			error(errorMsg:format(endpointName))
--		end
--		clientEndpoints[endpointName] = endpointFunction
--		-- TODO:
--		-- check if validation module has endpointName
--	end
--end

--function NetworkService:_addReplicatedStats(repStats)
--	for statName,remoteProperty in pairs(repStats) do
--		if (replicatedStats[statName]) then
--			local errorMsg = "Non-unique replicated stat name detected: %s"
--			error(errorMsg:format(statName))
--		end
--		replicatedStats[statName] = remoteProperty:Get()
--	end
--end

return NetworkService
