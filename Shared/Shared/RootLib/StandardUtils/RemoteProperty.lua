local RemoteProperty = {}
RemoteProperty.__index = function(self, key)
	if (self.ValueIsATable and self.Value[key]) then
		return self.Value[key]
	end
	return RemoteProperty[key]
end

function RemoteProperty.new(value, name)
	local newRemoteProperty = {
		Name = name,
		Value = value,
		ChangedQueue = {},
		ValueIsATable = type(value) == "table"
	}
	setmetatable(newRemoteProperty, RemoteProperty)
	return newRemoteProperty
end

function RemoteProperty:Get()
	return self.Value
end

function RemoteProperty:Set(value)
	local oldValue = self.Value
	if (oldValue == value) then return end
	self.Value = value
	self:forEach(self.ChangedQueue, function(fn)
		fn(value)
	end, true)
	if (self.RunService:IsServer()) then
		--self.ReplicateToAll(self.Name, value)
		--self:fireAllClients("ReplicaController.Set", "Time", value)
	end
end


function RemoteProperty:Changed(callback, context)
	local changedQueue = self.ChangedQueue
	if (context ~= nil) then
		callback = self:bind(callback, context)
	end
	self:push(changedQueue, callback)
end

return RemoteProperty
