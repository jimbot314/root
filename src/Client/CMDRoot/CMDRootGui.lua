local CMDRootGui = {
	"ScreenGui",
	"blank",
	{
		Name = "RootCLIGui",
		Enabled = false
	},
	{
		"Frame",
		"blank",
		{
			Name = "RootCLIFrame",
			Size = UDim2.new(1,0,0.4,0),
			SizeConstraint = Enum.SizeConstraint.RelativeXY,
			BackgroundColor3 = Color3.new(30/255,30/255,30/255),
			BackgroundTransparency = 0.3
		},


		{
			"ScrollingFrame",
			"blank",
			{
				Name = "OutputScrollingFrame",
				Size = UDim2.new(1,0,0.9,0),
				Position = UDim2.new(0,0,0,0),
				CanvasSize = UDim2.new(0,0,0.1,0)
			}
		},
		{
			"TextBox",
			"paddingsm",
			{
				BackgroundColor3 = Color3.new(40/255,40/255,40/255),
				Size = UDim2.new(1,0,0.1,0),
				AnchorPoint = Vector2.new(0,1),
				Position = UDim2.new(0,0,1,0),
				Font = Enum.Font.SourceSans,
				TextXAlignment = Enum.TextXAlignment.Left
			}
		}

	}
}


return CMDRootGui
