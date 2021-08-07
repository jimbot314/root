local on = {}

function on:Main(self, eventName, callback, context)
	if (context) then
		callback = self:bind(self, callback, context)
	end
	return self.PubSub:On(eventName, callback)
end

return on
