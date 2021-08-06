local NodeClass = {}

function NodeClass:Mount(ancestor)
	self.GrootService:Mount(self, ancestor)
end

function NodeClass:SetParent(ancestor)
	self.Parent = ancestor
	if (type(ancestor) == "table") then -- check ancestor not a part/instance
		self.Ref.Parent = ancestor.Ref
	else
		self.Ref.Parent = ancestor
	end
end


function NodeClass:SetStyles(styles)
	self.Styles = {}
	table.insert(styles, 1, self.ClassName)
	for i=1,#styles do
		local style = styles[i]
		if (not self:tableHasValue(self.Styles, style)) then
			self:AddStyle(style)
		end
	end
	--self.Styles = styles
end

function NodeClass:AddStyle(style)
	for i,v in ipairs(self.Styles) do
		if (v == style) then return end
	end
	self:push(self.Styles, style)
	local info = self.GrootStyles[style]

	if (info == nil) then
		local msg = "%s not a valid style"
		warn(msg:format(style))
		return
	end
	for prop,value in pairs(info) do
		self:SetProp(prop, value)
	end
end

function NodeClass:RemoveStyle(style)
	local index = self:indexOf(self.Styles, style)
	if (index) then
		local info = self.GrootStyles[style]
		table.remove(self.Styles, index)
		for prop,value in pairs(info) do
			for i=#self.Styles,1,-1 do
				local style2 = self.Styles[i]
				local info2 = self.GrootStyles[style2]
				if (info2[prop]) then
					self:SetProp(prop, info2[prop])
					break
				end
			end
		end
	end
end


function NodeClass:SetProps(props)
	for prop,value in pairs(props) do
		self:SetProp(prop, value)
	end
	--self.Props = props
end

function NodeClass:SetProp(prop, value)	
	if (prop:sub(1,2) == "UI") then
		local instance
		if (self.Ref:FindFirstChild(prop)) then
			instance = self.Ref[prop]
		else
			instance = Instance.new(prop)
			instance.Parent = self.Ref
		end
		for uiProp,uiValue in pairs(value) do
			instance[uiProp] = uiValue
		end
		
		--self.Props[prop] = value
		
	elseif (prop:sub(1,4) == "Data") then
		local attr = prop:sub(5)
		self.Data[attr] = value
	else
		self.Ref[prop] = value	
	end
	
end

function NodeClass:Get(prop)
	return self.Ref[prop]
end

function NodeClass:Text(text)
	self:SetProp("Text", text)
end

function NodeClass:Toggle(prop)
	local newValue = not self.Ref[prop]
	self:SetProp(prop, newValue)
end

function NodeClass:OnClick(fn)
	self.Ref.MouseButton1Click:Connect(fn)
end

function NodeClass:Tween(params, goal)
	self:playTween(self.Ref, params, goal)
end

--function NodeClass:ApplyBaseStyles()
--	local baseProps = self.grootbasestyles[self.ClassName]
--	--print(self)
--	if (baseProps == nil) then
--		local msg = "Did not define base props for %s"
--		error(msg:format(self.ClassName))
--	end
--	self:SetProps(baseProps)
--end

function NodeClass:Find(nodeName)
	local children = self.Children
	
	if (#children == 0) then return nil end
	nodeName = tostring(nodeName)
	if (self.Cached[nodeName]) then
		return self.Cached[nodeName]
	end
	
	for i,child in ipairs(children) do
		if (child.Name == nodeName) then
			return child
		end
	end
	for i,child in ipairs(children) do
		local node = child:Find(nodeName)
		if (node ~= nil) then
			return node
		end
	end
	return nil
end

function NodeClass:Hi()
	print("Hi")
end

local nodeClassMt = {
	__index = function(self, key)
		if NodeClass[key] then
			return NodeClass[key]
		else
			return self.Ref[key]
		end
	end,
}


function NodeClass:New(className, name)
	local ref = Instance.new(className)
	
	name = name  and tostring(name) or ref.Name
	local node = {
		Ref = ref,
		Styles = {},
		--Props = {},
		ClassName = className,
		Name = name,
		Children = {},
		Cached = {},
		Data = {}
	}
	setmetatable(node, nodeClassMt)
	-- warn("comment out the feature below?")
	if (className == "TextButton") then
		local eventName = ("%sClicked"):format(name)
		ref.MouseButton1Click:Connect(function()
			self:emit(eventName, node)
		end)
	end
	
	--node:ApplyBaseStyles()
	return node
end

function NodeClass:__OnInit()
	
end

function NodeClass:__OnStart()
	
end

return NodeClass
