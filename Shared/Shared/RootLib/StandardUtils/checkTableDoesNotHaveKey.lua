return function(self, tbl, key)
	if (tbl[key]) then
		local tableName = tbl.Name or "Unnamed"
		local errorMsg = "Error: %s was already added to %s, module names must be unique"
		error(errorMsg:format(key, tableName))
	end
end
