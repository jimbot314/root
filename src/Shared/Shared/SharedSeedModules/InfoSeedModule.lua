local InfoSeedModule = {}

function InfoSeedModule:Get(id)
  self:_CheckCache()
  if (self._cache[id]) then
    return self._cache[id]
  end
  for i,v in ipairs(self._info) do
    if (v.Id == id or v.Name == id) then
      self._cache[id] = v
      return v
    end
  end

  error(("%i id does not exist"):format(id))
end

function InfoSeedModule:All()
  return self._info
end

function InfoSeedModule:FindBy(prop, value)
  self:_CheckCache()
  local key = ("%s%s"):format(prop, tostring(value))
  if (self._cache[key]) then
    return self._cache[key]
  end

  for i,v in ipairs(self._info) do
    if (v[prop] == value) then
      self._cache[key] = v
      return v
    end
  end

  error(("%i id does not exist"):format(key))
end

function InfoSeedModule:Index(index)
  return self._info[index]
end

function InfoSeedModule:GetIndex(prop, value)
  for i,v in ipairs(self._info) do
    if (v[prop] == value) then
      return i
    end
  end
end

function InfoSeedModule:_CheckCache()
  if (self._cache == nil) then
    self._cache = {}
  end
end

return InfoSeedModule