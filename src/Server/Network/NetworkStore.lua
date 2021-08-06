local NetworkStore = {
	_store = {}
}

function NetworkStore:Create(plr, data)
	self._store[plr] = data
end

function NetworkStore:Get(plr)
	return self._store[plr]
end

function NetworkStore:Log(plr, log)
	local data = self:Get(plr)
	self:push(data, log)
end

return NetworkStore
