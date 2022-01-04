local Groot = {}



function Groot:__OnInit()
	--self.grootTree = {Ref = Instance.new("ScreenGui"), Children = {}}
	--self.grootTree.Ref.Name = "GrootTree"
	
	-- Node class new has to use namecall
	--self.grootTree = self.NodeClass.new("ScreenGui", "GrootTree")

	--self.grootTree.Ref.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

function Groot:__OnStart()
	if (self.SYSTEM_ENV == "Client") then
		self.grootTree = self.NodeClass:New("ScreenGui", "GrootTree")
		self.grootTree:SetStyles({})
		self.grootTree.Ref.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
		self:emitSync("GrootInit")
		self.injectIntoRootTable("GrootTree", self.grootTree)
		self:emitSync("GrootStart")
		self:newInstance("BoolValue", {
			Name = "GrootContentLoaded",
			Parent = self.plr
		})
	end
	self:emit("AfterGrootStart")
end

function Groot:AbstractRender(tree, ancestor)
	local className = tree[1]
	local name = tree[3].Name or className
	local node = self.NodeClass:New(className, name)
	local styles = tree[2]
	styles = styles:split(" ")
	node:SetStyles(styles)
	
	local props = tree[3]
	node:SetProps(props)
	
	--if (ancestor) then
		--node.Parent = ancestor
	--end
	if (ancestor ~= nil) then
		node:Mount(ancestor)
	end
		--ancestor[name] = node
	--local descendants = tree[4] or {}
	
	local hasDescendants = tree[4]
	if (hasDescendants) then
		for i=4,#tree do
			local descendant = tree[i]
			self:Render(descendant, node)
		end
	end
	return node
end

function Groot:Render(tree, ancestor)
	local className = tree[1]
	local name = tree[3].Name or className
	local node = self.NodeClass:New(className, name)
	local styles = tree[2]
	styles = styles:split(" ")
	node:SetStyles(styles)
	
	local props = tree[3]
	node:SetProps(props)
	
	--if (ancestor) then
		--node.Parent = ancestor
	--end
	node:Mount(ancestor)
	--ancestor[name] = node
	--local descendants = tree[4] or {}
	
	local hasDescendants = tree[4]
	if (hasDescendants) then
		for i=4,#tree do
			local descendant = tree[i]
			self:Render(descendant, node)
		end
	end
	return node
end

function Groot:Mount(node, ancestor)
	ancestor = ancestor or self.grootTree
	--if (ancestor == grootTree) then
	if (type(ancestor) == "table") then
		self:push(ancestor.Children, node)
		
		
	end
	--end
	node:SetParent(ancestor)
end

return Groot
