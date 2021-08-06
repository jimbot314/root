local unif = {}

local rand = Random.new(1234)

function unif:Main(self, a,b)
	return rand:NextNumber(a, b)
end

return unif
