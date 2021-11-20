local PlayerService = {}

function PlayerService:__OnStart()
	self.Players.PlayerAdded:Connect(function(plr)
		self:emit("PlayerAdded", plr)
	end)
	local existingPlrs = self.Players:GetPlayers()
	self:forEach(existingPlrs, function(plr)
		self:emit("PlayerAdded", plr)
	end)
	
	self.Players.PlayerRemoving:Connect(function(plr)
		self:emitSync("BeforePlayerRemoving", plr)
		self:emitSync("PlayerRemoving", plr)
	end)
	warn("remember to set to emitsync on the other place")
end

function PlayerService:GetPlayerFromHrp(hrp)
	if (hrp == nil) then return nil end
	local char = hrp.Parent
	return self.Players:GetPlayerFromCharacter(char)
end

return PlayerService
