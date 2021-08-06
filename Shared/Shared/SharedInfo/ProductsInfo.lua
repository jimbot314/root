local ProductsInfo = {
  __extends = "InfoSeedModule"
}

function ProductsInfo:__OnInit()
  self._info = {
    {
      Id = 123,
      Name = "100 coins",
      Description = "Gives you 100 coins",
      Price = 10
    }
  }
end

return ProductsInfo