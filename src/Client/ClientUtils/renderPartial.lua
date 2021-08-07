local renderPartial = {}

function renderPartial:Main(self, instance, props, ancestor)
	local guiName
	if (typeof(instance) == "Instance") then
		local resourceName = instance.Name:gsub("Controller", "")
		guiName = resourceName .. "Partial"
	elseif (type(instance) == "string") then
		guiName = instance
	else
		warn("Type error when calling renderGui")
	end
	local module = self[guiName]
	module = module(props)
	
	return self.GrootService:Render(module, ancestor)
end

return renderPartial