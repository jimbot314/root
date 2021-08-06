local PlayerDataService = {
	__includes = {
		"PlayerDataConf",
		"PlayerDataStore"
	},
	_db = {},
}

local db

function PlayerDataService:__OnInit()
	db = self.DataStoreService:GetDataStore(self.ROOT_ENV)
end

function PlayerDataService:__OnPlayerAdded(plr)
	if (self.ROOT_ENV == "Development") then
		self:newInstance("BoolValue", {
			Name = "PlayerDataLoaded",
			Parent = plr
		})
		self:emitSync("PlayerDataLoaded", plr, self.PlayerSeedDataInfo:All())
		return
	end
	while (db == nil) do
		warn("Player added before db init")
		wait(1)
	end
	local repeats = 0
	local success, result
	repeat
		repeats += 1
		success, result = pcall(db.UpdateAsync, db, function(prevData)
			return self:_UpdateAsyncEntry(plr, prevData)
		end)
	until success == true or repeats == self._DATA_RETRIES
	self:emitSync("PlayerDataLoaded", plr, result)
	self:newInstance("BoolValue", {
		Name = "PlayerDataLoaded",
		Parent = plr
	})
end

function PlayerDataService:__OnPlayerRemoving(plr)
	
	local data = {}
	self:emitSync("ClientDataRequested", plr, {})
	local repeats = 0
	local result, success
	repeat
		repeats += 1
		result, success = pcall(db.UpdateAsync, db, function(prevData)
			return self:_UpdateAsyncExit(plr, prevData)
		end)
	until success == true or repeats == self._DATA_RETRIES
end

function PlayerDataService:_UpdateAsyncEntry(plr, prevData)
	if (prevData == nil) then
		return {}
	elseif (prevData.SessionTag ~= nil) then
		warn("Previous session still loading")
		return nil
	else
		
		self:_Tag(prevData)
		return prevData
	end
end

function PlayerDataService:_UpdateAsyncExit(plr, prevData)
	if (prevData == nil) then return nil end
	if (self.CurrentData.Visits >= prevData.Visits) then
		local data = self.Get(plr)
		local sessionTag = prevData.SessionTag
		
		self:push(data.Tags, {sessionTag, self:_GetDate()})
		return data
	else
		return nil
	end
	--log the session save time
	--untag
	--return
end

function PlayerDataService:_Tag(data)
	self.SessionTag = self:_GetDate()
end

function PlayerDataService:_GetDate()
	return os.date("%x%a%X", os.time())
end

return PlayerDataService
