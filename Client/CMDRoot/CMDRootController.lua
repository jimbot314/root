local CMDRootController = {}

local map

local history = {}
local historyWaypoint = 1
local historyInput
local TestRemoteFunction = game:GetService("ReplicatedStorage").TestRemoteFunction
local outputCount = 0

function CMDRootController:__OnInit()
	self.ContextActionService:BindAction("ToggleRootCLI", self:bind(self.ToggleRootCLI, self), false, Enum.KeyCode.Comma)
end

function CMDRootController:__OnStart()
	return
end

function CMDRootController:__OnGrootInit()
	self:renderGui(script)
end

function CMDRootController:__OnGrootStart()
	map = self.GrootTree:Find("RootCLIGui")
end

function CMDRootController:ToggleRootCLI(name, state, input)
	if (state ~= Enum.UserInputState.End) then return end

	if (map.Enabled) then
		self.ContextActionService:UnbindAction("EnterCommand")
		if (historyInput) then
			historyInput:Disconnect()
		end
		map:SetProp("Enabled", false)
	else
		map:SetProp("Enabled", true)
		map:Find("TextBox").Ref:CaptureFocus()	
		self.ContextActionService:BindAction("EnterCommand", self:bind(self.EnterCommand, self), false, Enum.KeyCode.Return)
		--self.ContextActionService:BindAction("PreviousCommand", self:bind(self.PreviousCommand, self), false, Enum.KeyCode.Up)
		--self.ContextActionService:BindAction("NextCommand", self:bind(self.NextCommand, self), false, Enum.KeyCode.Down)
		historyInput = self.UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if (input.KeyCode == Enum.KeyCode.Up) then
				self:PreviousCommand()
			elseif (input.KeyCode == Enum.KeyCode.Down) then
				self:NextCommand()
			end
		end)
	end
end

function CMDRootController:EnterCommand(name, state, input)
	if (state ~= Enum.UserInputState.End) then return end
	local command = map:Find("TextBox").Text
	if (command == "") then return end
	map:Find("TextBox"):SetProp("Text", "")
	map:Find("TextBox").Ref:CaptureFocus()
	
	local index = self:indexOf(history, command)
	if (index) then
		table.remove(history, index)
	end
	table.insert(history, command)
	historyWaypoint = #history + 1 -- set historyWaypoint to most recent?
	if (command == "clear") then
		self:ClearCLI()
		return
	end


	local outputFrame = self:LogOutput(command)

	if (command == "ping") then
		local startTime = tick()
		TestRemoteFunction:InvokeServer("ping")
		outputFrame.ResponseLb.Text = ("Time taken: %f"):format(tick() - startTime)
		return
	end
	local response = TestRemoteFunction:InvokeServer(command)
	print(response)


	--outputCount += 1
	--local responseOutputLb = OutputLb:Clone()
	--responseOutputLb.Text = ("%i - Status: %i, Message: %s"):format(tick(),response.Status, response.Message)
	outputFrame.ResponseLb.Text = ("%i - Status: %i, Message: %s"):format(tick(),response.Status, response.Message)
	--local yPosition = (outputCount - 1) * 18



	--responseOutputLb.Position = UDim2.new(0,0,0,yPosition)
	--responseOutputLb.Parent = RootCLIGui.RootCLIFrame.OutputScrollingFrame

end

function CMDRootController:PreviousCommand(name, state, input)
	--if (state ~= Enum.UserInputState.End) then return end
	if (historyWaypoint <= 1) then return end
	print(history)
	historyWaypoint -= 1
	local text = history[historyWaypoint]
	map:Find("TextBox"):SetProp("Text", history[historyWaypoint])
	map:Find("TextBox"):SetProp("CursorPosition", #text + 1)
end

function CMDRootController:NextCommand(name, state, input)
	--if (state ~= Enum.UserInputState.End) then return end
	if (historyWaypoint > #history) then return end
	historyWaypoint += 1
	if (historyWaypoint > #history) then
		map:Find("TextBox"):SetProp("Text", "")
		return
	end
	map:Find("TextBox"):SetProp("Text", history[historyWaypoint])
end

function CMDRootController:LogOutput(message)
	outputCount += 1
	local yPosition = (outputCount - 1) * 36
	--local outputFrame = self:Map("OutputFrame"):Clone()
	local props = {
		Id = outputCount,
		Text = ("%i - %s"):format(tick(), message),
		Position = UDim2.new(0,0,0,yPosition)
	}
	local outputFrameTemplate = self.CMDRootOutputGui(props)
	--outputFrame.OutputLb.Text = ("%i - %s"):format(tick(), message)
	
	--outputFrame.Position = UDim2.new(0,0,0,yPosition)
	--outputFrame.Parent = CMDRootController.RootCLIFrame.OutputScrollingFrame
	
	local outputFrame = self.GrootService:Render(outputFrameTemplate, map:Find("OutputScrollingFrame"))
	
	map:Find("OutputScrollingFrame"):SetProps({
		CanvasSize = UDim2.new(1,0,0,outputCount * 36),
		
	})
	map:Find("OutputScrollingFrame"):SetProp("CanvasPosition", Vector2.new(0,outputCount * 36))
	return outputFrame
end

function CMDRootController:ClearCLI()
	map:Find("OutputScrollingFrame").Ref:ClearAllChildren()
	outputCount = 0
	map:Find("OutputScrollingFrame").Ref.CanvasSize = UDim2.new(1,0,0,10)
end

return CMDRootController
