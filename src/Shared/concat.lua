local function concat(...)
  local args = {...}
  local result = {}
  local addedTable = {}
  for i,tbl in ipairs(args) do
    for k,v in pairs(tbl) do
      if (addedTable[k]) then
        error(("%s already added"):format(k))
      end
      result[k] = v
      addedTable[k] = true
    end 
  end
  return result
end

return concat