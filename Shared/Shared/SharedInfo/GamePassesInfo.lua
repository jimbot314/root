local GamePassesInfo = {
  __extends = "InfoSeedModule"
}

function GamePassesInfo:__OnInit()
  self._info = {
    {
      Id = 123456,
      Name = "VIP",
      Description = "Gives you cool perks",
      Price = 500
    }
  }
end

return GamePassesInfo