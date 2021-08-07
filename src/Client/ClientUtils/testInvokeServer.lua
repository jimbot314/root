local testInvokeServer = {}

local TestRemoteFunction = game:GetService("ReplicatedStorage").TestRemoteFunction

function testInvokeServer:Main(...)
	return TestRemoteFunction:InvokeServer(...)
end

return testInvokeServer