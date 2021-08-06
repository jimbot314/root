local PlayerSeedDataInfo = {
  __extends = "InfoSeedModule"
}

function PlayerSeedDataInfo:__OnInit()
  self._info = {
    Coins = 10,
    Inventory = {
      {
        Name = "Pistol"
      },
      {
        Name = "Uzi"
      },
      {
        Name = "Shotgun"
      },
      {
        Name = "Minigun"
      },
      {
        Name = "Barricade"
      },
      {
        Name = "Turret"
      },
    },

    Backpack = {
      {
        Name = "Pistol"
      },
      {
        Name = "Shotgun"
      },
      {
        Name = "Barricade"
      },
      {
        Name = "Turret"
      },
    },

    Exp = 10,
    Level = 10,
  }
end

return PlayerSeedDataInfo