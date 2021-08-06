local injectIntoRootTable = {}

function injectIntoRootTable:Main(key, value)
	local rootTable = getmetatable(self)
	if (rootTable == nil) then
		error("Root table has not been injected yet")
	end
	--if (rootTable[key]) then
	--	local errorMsg = "Injection error, %s key already exists in root table"
	--	error(errorMsg:format(key))
	--end
	self:checkTableDoesNotHaveKey(rootTable, key)
	rootTable[key] = value
end

return injectIntoRootTable
