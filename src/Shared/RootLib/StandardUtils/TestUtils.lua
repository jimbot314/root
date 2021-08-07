local TestUtils = {
	Type = function(a, b)
		return type(a) == b
	end,
	
	Types = function(a, b)
		for key,value in pairs(b) do
			if (type(a[key]) ~= value) then
				return false
			end
		end
		return true
	end,
	
	Equal = function(a, b)
		return a == b
	end,
	
	NotEqual = function(a, b)
		return a ~= b
	end,
	
	GreaterThan = function(a, b)
		return a > b
	end,
	
	Geq = function(a, b)
		return a >= b
	end,
	
	WithinRange = function(plr, pos, distance)
		return (plr.Character.HumanoidRootPart.Position - pos).Magnitude <= distance
	end,
}

return TestUtils
