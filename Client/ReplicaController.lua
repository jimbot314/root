local ReplicaController = {}
local replicaStore

function ReplicaController:__OnInit()
	replicaStore = self:invokeServer("GetReplicatedStats")
	--local statsModel = self:ConstructStatsModel(replicaStore)
	self.injectIntoRootTable("Stats", replicaStore)
end

function ReplicaController:__OnStart()
	
end


function ReplicaController:ConstructStatsModel(replicaStore)
	if (type(replicaStore) == "table") then
		for key,value in pairs(replicaStore) do
			local wrappedValue = self:ConstructStatsModel(value)
			replicaStore[key] = wrappedValue
		end
	end
	return self.RemoteProperty.new(replicaStore)
end

function ReplicaController:Set(path, value)
	local path = path:split(".")
	local firstKey = table.remove(path, 1)
	local wrappedValue = self.Stats[firstKey]
	self:forEach(path, function(key)
		wrappedValue = wrappedValue[key]
	end)
	--if (type(path) == "string") then
		--self.Stats[path]:Set(value)
	--end
	wrappedValue:Set(value)
end

function ReplicaController:__RecvSet(path, value)
	-- self:Set(path, value)
	self.Stats[path] = value
end

return ReplicaController
