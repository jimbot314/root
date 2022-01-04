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

local function run(suite)
  warn(("Running test suite '%s'"):format(suite.Description))
  local successes = 0
  local total = #suite.DescribeInstance
  for i2,test in ipairs(suite.DescribeInstance) do
    local success, result = pcall(test.Callback)
    if (not success) then
      warn(("The following test failed %s"):format(test.Description))
      warn(result)
    else
      successes += 1
    end
  end
  warn(("Test suite %s finished running with %i/%i tests passing"):format(v.Description, successes, total))
end

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

function Test:describex(description, callback)
  return
end

function Test:Run()
  for i,suite in ipairs(describeQueue) do
    run(suite)
  end
end

function Test:RunSuite(description)
  for i,suite in ipairs(describeQueue) do
    if (suite.description == description) then
      run(suite)
      break
    end
  end
end

return Test