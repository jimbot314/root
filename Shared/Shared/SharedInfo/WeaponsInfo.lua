local WeaponsInfo = {
	__extends = "InfoSeedModule"
}

function WeaponsInfo:__OnInit()
	self._info = {
		{
			-- Upgrades = 0,
			-- LastActivate = 0, (Do not store these here)
			Name = "Pistol",
			Price = 0,
			Capacity = "Infinity",
			Damage = 10,
			Cooldown = 0.5,
			Class = "Weapon",
			Range = 15,	
			Auto = true,

			Offset = CFrame.new(0,0,1),
			Rotation = CFrame.Angles(0,0,0)
		},
		{

			Name = "Uzi",
			Price = 100,
			Offset = CFrame.new(0,0,2.5),
			Rotation = CFrame.Angles(0,math.rad(90),0)
		},
		{
			Name = "Shotgun",
			Price = 100,
			Capacity = 20,
			Damage = 100,
			Cooldown = 1,
			Class = "Weapon",
			Pellets = 1,
			Range = 10,
			Auto = false,

			Offset = CFrame.new(0,0,2.3),
			Rotation = CFrame.Angles(0,0,0)
		},
		{
			Name = "M60",
			Price = 100,
			Offset = CFrame.new(0,0,5),
			Rotation = CFrame.Angles(0,0,0)
		},
		{
			Name = "Minigun",
			Price = 100,
			Capacity = 100,
			Damage = 5,
			Cooldown = 0.01,
			Class = "Weapon",
			Range = 15,
			Auto = true,

			Offset = CFrame.new(0,0,3),
			Rotation = CFrame.Angles(0,0,0)
		},
		{
			Name = "Barricade",
			Price = 100,
			Capacity = 10,
			Cooldown = 0.1,
			Class = "Placement",
			Auto = false,

			Offset = CFrame.new(0,0,2.7),
			Rotation = CFrame.Angles(0,math.rad(45),0)
		},
		{
			Name = "Turret",
			Price = 100,
			Capacity = 5,
			Damage = 20,
			Cooldown = 0.5,
			Range = 20,
			Class = "Placement",
			Auto = false,

			Offset = CFrame.new(0,0,1.8),
			Rotation = CFrame.Angles(math.rad(40),math.rad(-120),0)
		},
		
	}
	print(self)
end

function WeaponsInfo:CheckStarter(weaponName)
	local starterWeapons = {
		Pistol = true
	}
	return starterWeapons[weaponName] == true
end

return WeaponsInfo
