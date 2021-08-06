return function(self, tbl, fn)
  for i,v in ipairs(tbl) do
    local result = fn(v, i)
    if (result) then
      return i
    end
  end
  return nil
end