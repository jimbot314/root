local Test = {}

function Test:NewTestQueue(describeInstance)
  return function(description, callback)
    describeInstance[#describeInstance+1] = {
      Description = description,
      Callback = callback
    }
  end
end

local describeQueue = {}

function Test:describe(description, callback)
  local describeInstance = {}
  local test = Test:NewTestQueue(describeInstance)
  callback({
    test = test
  }) -- this should add tests to the describeInstance
  describeQueue[#describeQueue+1] = {
    Description = description,
    DescribeInstance = describeInstance
  }
end

function Test:Run()
  for i,v in ipairs(describeQueue) do
    warn(("Running test suite '%s'"):format(v.Description))
    local successes = 0
    local total = #v.DescribeInstance
    for i2,v2 in ipairs(v.DescribeInstance) do
      local success, result = pcall(v2.Callback)
      if (not success) then
        warn(("The following test failed %s"):format(v2.Description))
        warn(result)
      else
        successes += 1
      end
    end
    warn(("Test suite %s finished running with %i/%i tests passing"):format(v.Description, successes, total))
  end
end

return Test