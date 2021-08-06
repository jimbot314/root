local StoreSeedModule = {}

local VERBS = {
  Create = true,
  Inc = true,
  Set = true,
  Get = true,
  Delete = true,
  Clear = true,
  Push = true
}

local mt = {}

local function partitionMethod(key)
  for i=1,#key do
    local str = key:sub(1, i)
    if (VERBS[str]) then
      return str, key:sub(i + 1)
    end
  end
  return nil, nil
end

function StoreSeedModule:__find(key)
  local verb, noun = partitionMethod(key)
  if (noun == "") then
    local method = mt[verb]
    return method(self._store, "_store") -- MAJOR BUG HERE FIXED 6/5/2021 (DID NOT INCLUDE THE STORE NAME)
  elseif (noun ~= nil) then
    local method = mt[verb]
    noun = ("%s%s"):format(noun:split("")[1]:lower(), noun:sub(2))
    local storeName = ("%s%s%s"):format("_", noun, "Store")

    print(getmetatable(self))

    if (self[storeName] == nil) then
      error("Incorrect store name")
    end
    return method(self, storeName)
  else
    -- placement instance creation will take this path
    local msg = "%s key was not found"
    warn(msg:format(key))
    return nil
  end
end

function mt.Create(self, storeName)
  return function(self, key, value)
    local store = self[storeName]
    store[key] = value
  end
end

function mt.Inc(self, storeName)
  return function(self, key, amount)
    local store = self[storeName]
    amount = amount or 1
    store[key] += amount
  end
end

function mt.Set(self, storeName)
  return function(self, key, value)
    local store = self[storeName]
    store[key] = value
  end
end

function mt.Get(self, storeName)
  return function(self, key)
    local store = self[storeName]
    if (key == nil) then
      return store
    else
      return store[key]
    end
  end
end


function mt.Delete(self, storeName)
  return function(self, key)
    local store = self[storeName]
    store[key] = nil
  end
end

function mt.Clear(self, storeName)
  return function(self)
    self[storeName] = {}
  end
end

-- setmetatable(StoreSeedModule, mt)

return StoreSeedModule