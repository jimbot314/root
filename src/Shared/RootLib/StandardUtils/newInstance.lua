local newInstance = function(self, className, props)
	local instance = Instance.new(className)
	if (props == nil) then
		return instance
	end

	local ttl = props.TTL
	props.TTL = nil
	local parent = props.Parent
	props.Parent = nil
	for name,value in pairs(props) do
		instance[name] = value
	end
	instance.Parent = parent
	if (ttl ~= nil) then
		spawn(function()
			task.wait(ttl)
			
			instance:Destroy()
		end)
	end
	return instance
end

return newInstance
