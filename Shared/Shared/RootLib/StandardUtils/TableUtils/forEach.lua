local forEach = {}

function forEach:Main(self, tbl, callback, async)
	assert(tbl ~= nil, "Passed in table was nil")
	if (async ~= true) then
		for i=1,#tbl do
			local v = tbl[i]
			callback(v, i)
		end
	else
		for i=1,#tbl do
			local v = tbl[i]
			--coroutine.wrap(function()
				--callback(v, i)
			--end)()
			spawn(function()
				callback(v, i)
			end)
		end
	end
end

return forEach
