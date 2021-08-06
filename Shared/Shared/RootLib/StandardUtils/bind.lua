local bind = {}

function bind:Main(self, fn, context)
	if (type(fn) ~= "function") then
		error("First argument not a function")
	end
	return function(...)
		return fn(context, ...)
	end
end


--local tbl = {}
--function tbl:printHi(word)
--	print(self, 'Hi', word)
--end
--local printHi = self:bind(tbl.printHi, self)

--print(printHi)
--printHi(123)

return bind
