local indexOf = {}

function indexOf:Main(self, tbl, value)
	for i=1,#tbl do
		local tblValue = tbl[i]
		if (tblValue == value) then
			return i
		end
	end
	return nil
end

return indexOf
