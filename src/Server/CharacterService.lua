local CharacterService = {}

function CharacterService:__OnPlayerAdded(plr)
	self.maid = self.Maid:New()
	plr.CharacterAdded:Connect(function()
		self.maid:Destroy()
		self:emit("CharacterAdded", plr)
		self:_SubscribeEvents(plr)
	end)
	if (plr.Character) then
		self:emit("CharacterAdded", plr)
		self:_SubscribeEvents(plr)
	end
	plr.CharacterAppearanceLoaded:Connect(function()
		print("Character Appearance Loaded")
	end)
end

function CharacterService:_SubscribeEvents(plr)
	local humanoid = plr.Character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = self.PLAYER_SPEED

	humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	self.maid:GiveTask(humanoid.Died:Connect(function()
		self:emit("HumanoidDied", plr)
	end))
end

function CharacterService:Tp(plr, part)
	local hrp = plr.Character.HumanoidRootPart
	hrp.CFrame = part.CFrame + Vector3.new(0, 1, 0)
end

function CharacterService:Freeze(plr)
	local hrp = plr.Character.HumanoidRootPart
	hrp.Anchored = true
end

return CharacterService
