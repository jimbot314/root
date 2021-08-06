local push = {}

function push:Main(self, tbl, element)
	tbl[#tbl + 1] = element
	return #tbl
end

return push
