local renderGui = {}

function renderGui:Main(self, instance, ancestor)
	local guiName
	if (typeof(instance) == "Instance") then
		local resourceName = instance.Name:gsub("Service", ""):gsub("Class", "")
		guiName = resourceName .. "Gui"
	elseif (type(instance) == "string") then
		guiName = instance .. "Gui"
	else
		warn("Type error when calling renderGui")
	end
	local module = self[guiName]
	print(guiName)
	return self.GrootService:Render(self[guiName], ancestor)
end

return renderGui
