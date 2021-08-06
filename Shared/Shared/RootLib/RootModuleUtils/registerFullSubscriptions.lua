local function checkFullSubscriptionSyntax(str)
	if (type(str) == "string" and str:sub(1,4) == "__On") then
		return true
	else
		return false
	end
end

local function getEventName(str)
	return str:sub(5)
end

local function bind(fn, context)
	return function(...)
		return fn(context, ...)
	end
end

local function registerFullSubscriptions(serviceModule, PubSub)
	for k,v in pairs(serviceModule) do
		if (checkFullSubscriptionSyntax(k) and type(v) == "function") then
			
			local eventName = getEventName(k)
			PubSub:On(eventName, bind(v, serviceModule))
		end
	end
end

return registerFullSubscriptions
