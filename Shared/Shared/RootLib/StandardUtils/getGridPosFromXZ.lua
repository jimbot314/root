local getGridPosFromXZ = {}

local GRID_SIZE

function getGridPosFromXZ:__OnInit()
	GRID_SIZE = self.GRID_SIZE
end

function getGridPosFromXZ:Main(self, params)
	local x = math.ceil(params.X/GRID_SIZE) * GRID_SIZE
	local z = math.ceil(params.Z/GRID_SIZE) * GRID_SIZE
	local gridPos = Vector3.new(x - GRID_SIZE / 2, 0, z - GRID_SIZE / 2)
	return gridPos
end

return getGridPosFromXZ
