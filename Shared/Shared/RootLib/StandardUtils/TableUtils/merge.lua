local merge = {}

function merge:Main(self, tbl1, tbl2)
	for key,value in pairs(tbl2) do
		tbl1[key] = value
	end
	return tbl1
end

return merge
