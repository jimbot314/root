local Test = {}
local describeQueue = {}

function Test:NewTestQueue(describeInstance)
  return function(description, callback)
    describeInstance[#describeInstance+1] = {
      Description = description,
      Callback = callback
    }
  end
end

local function run(suite)
  local successes = 0
  local total = #suite.DescribeInstance
  for i2,test in ipairs(suite.DescribeInstance) do
    local success, result = pcall(test.Callback)
    if (not success) then
      warn(("The following test failed %s from suite %s"):format(test.Description, suite.description))
      warn(result)
    else
      successes += 1
    end
  end
  return successes, total
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
  local successfulSuites = 0
  local totalSuites = #describeQueue
  for i,suite in ipairs(describeQueue) do
    local successes, total = run(suite)
    if (successes == total) then
      successfulSuites += 1
    end
  end
  warn(("All test suites finished running with %i/%i suites passing"):format(successfulSuites, totalSuites))
end

function Test:RunSuite(description:string)
  for i,suite in ipairs(describeQueue) do
    if (suite.Description == description) then
      warn(("Running test suite '%s'"):format(suite.Description))
      local successes, total = run(suite)
      warn(("Test suite '%s' finished running with %i/%i tests passing"):format(suite.Description, successes, total))
      break
    end
  end
end

return Test