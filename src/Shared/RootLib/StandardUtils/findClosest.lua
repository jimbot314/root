local findClosest = {}

function findClosest:Main(self, reference, items)
	local closest
	local minDistance = 1000
	local pos = reference.Position

	self:forEach(items, function(item)
		local dist = (pos - item.Position).Magnitude
		if (dist < minDistance) then
			minDistance = dist
			closest = item
		end
	end)
	return closest
end

return findClosest
