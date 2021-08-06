local tableHasValue = {}

function tableHasValue:Main(self, tbl, value)
	for i=1,#tbl do
		if (tbl[i] == value) then
			return true
		end
	end
	return false
end

return tableHasValue
