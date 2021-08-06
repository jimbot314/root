local getIdFromXZ = {}

local GRID_SIZE

function getIdFromXZ:__OnInit()
	GRID_SIZE = self.GRID_SIZE
end

function getIdFromXZ:Main(self, params)
	local x = params.X
	local z = params.Z
	local id = (math.ceil(x/GRID_SIZE) - 1) * self.GRIDS_X + math.ceil(z/GRID_SIZE)
	return id
end

return getIdFromXZ
