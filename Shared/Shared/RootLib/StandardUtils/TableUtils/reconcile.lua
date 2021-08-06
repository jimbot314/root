--local reconcile = {}

--function reconcile:Main(tbl1, tbl2)
--	for key,value in pairs(tbl2) do
--		if (tbl1[key] == nil) then
--			tbl1[key] = value
--		end
--	end
--	return tbl1
--end

return function(self, tbl1, tbl2)
	for key,value in pairs(tbl2) do
		if (tbl1[key] == nil) then
			tbl1[key] = value
		end
	end
	return tbl1
end
