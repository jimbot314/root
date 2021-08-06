local PubSub = {}

local eventQueues = {}

function PubSub:Start()
	
end

function PubSub:Emit(eventName, ...)
	local eventQueue = eventQueues[eventName]
	if (eventQueue == nil) then return end
	local args = {...}
	self:forEach(eventQueue, function(listenerInstance)
		local fn = listenerInstance.Callback
		fn(table.unpack(args))
	end, true)
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
	if (not eventQueue) then
		eventQueue = {}
		eventQueues[eventName] = eventQueue
	end
	local listenerInstance = self:_NewListenerInstance(eventName, callback)
	local eventQueueIndex = #eventQueue + 1
	eventQueue[eventQueueIndex] = listenerInstance
	return listenerInstance, eventQueueIndex
end

function PubSub:Off(eventName, id)
	local eventQueue = eventQueues[eventName]
	if (not eventQueue) then
		return
		--error(("Event queue not found for %s"):format(eventName))
	end
	if (type(id) == "number") then
		eventQueue[id]:Destroy()
	end
end

local ListenerClass = {
	Destroy = function(self)
		local index = self:indexOf(eventQueues, self)
		if (index ~= nil) then
			eventQueues[index] = nil
		end
	end,
}

local ListenerInstanceMt = {
	__index = ListenerClass
}

function PubSub:_NewListenerInstance(eventName, callback)
	local listenerInstance = {
		EventName = eventName,
		Callback = callback
	}
	setmetatable(listenerInstance, ListenerInstanceMt)
	return listenerInstance
end

return PubSub
