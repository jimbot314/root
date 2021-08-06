local PubSub = {}

local eventQueues = {}
local bindableInstances = {}

function PubSub:Start()
	
	local function doNothing()
		return math.random() * tick()
	end
	local doNothingMt = setmetatable({}, {__call = function()
		if (doNothing) then
			doNothing()
		end
	end})
	local startTime = tick()
	for i=1,100000 do
		doNothing()
	end
	print(tick() - startTime)
	startTime = tick()
	for i=1,100000 do
		doNothingMt()
	end
	print(tick() - startTime)
	self:on('hi', function()
		print('hi')
	end)
	self:Emit("Hi", "foo", "roblox")
end

function PubSub:Emit(eventName, ...)
	local bindableInstance = bindableInstances[eventName]
	if (bindableInstance == nil) then return end
	
	bindableInstance:Fire(...)
end

function PubSub:EmitSync(eventName, ...)
	local eventQueue = eventQueues[eventName]
	if (eventQueue == nil) then return end
	local args = {...}
	self:forEach(eventQueue, function(listenerInstance)
		local fn = listenerInstance.Callback
		fn(table.unpack(args))
	end)
end

function PubSub:On(eventName, callback)
	local eventQueue = eventQueues[eventName]
	local bindableInstance = bindableInstances[eventName]
	if (not eventQueue) then
		eventQueue = {}
		eventQueues[eventName] = eventQueue
	end
	if (not bindableInstance) then
		bindableInstance = Instance.new("BindableEvent")
		bindableInstances[eventName] = bindableInstance
	end
	local rbxScriptSignal = bindableInstance.Event:Connect(callback)
	local listenerInstance = self:_NewListenerInstance(eventName, callback, rbxScriptSignal)
	local eventQueueIndex = #eventQueue + 1
	eventQueue[eventQueueIndex] = listenerInstance
	return listenerInstance, eventQueueIndex
end

function PubSub:Off(eventName, id)
	local eventQueue = eventQueues[eventName]
	if (not eventQueue) then
		error(("Event queue not found for %s"):format(eventName))
	end
	if (type(id) == "number") then
		eventQueue[id]:Destroy()
	end
end

local ListenerClass = {
	Destroy = function(self)
		self.RBXScriptSignal:Disconnect()
		local index = self:indexOf(eventQueues, self)
		if (index ~= nil) then
			eventQueues[index] = nil
		end
	end,
}

local ListenerInstanceMt = {
	__index = ListenerClass
}

function PubSub:_NewListenerInstance(eventName, callback, rbxScriptSignal)
	local listenerInstance = {
		EventName = eventName,
		Callback = callback,
		RBXScriptSignal = rbxScriptSignal,
	}
	setmetatable(listenerInstance, ListenerInstanceMt)
	return listenerInstance
end

return PubSub
