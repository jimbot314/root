local DefaultStyles = {}

function DefaultStyles:All()
	return {
		tl = {
			TextColor3 = Color3.new(0.3,0.5,1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Font = "GothamBold",
			TextSize = 12
		},
		
		blank = {
			
		},
		
		nopadding = {
			UIPadding = {
				PaddingBottom = UDim.new(0,0),
				PaddingLeft = UDim.new(0,0),
				PaddingRight = UDim.new(0,0),
				PaddingTop = UDim.new(0,0)
			},
		},
		
		paddingsm = {
			UIPadding = {
				PaddingBottom = UDim.new(0.02,0),
				PaddingLeft = UDim.new(0.01,0),
				PaddingRight = UDim.new(0.02,0),
				PaddingTop = UDim.new(0.02,0)
			},
		},

		paddingmd = {
			UIPadding = {
				PaddingBottom = UDim.new(0.05,0),
				PaddingLeft = UDim.new(0.05,0),
				PaddingRight = UDim.new(0.05,0),
				PaddingTop = UDim.new(0.05,0)
			},
		},

		xy = {
			SizeConstraint = Enum.SizeConstraint.RelativeXY
		},

		xx = {
			SizeConstraint = Enum.SizeConstraint.RelativeXX
		},

		center = {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5,0,0.5,0)
		},

		bottomleft = {
			AnchorPoint = Vector2.new(0,1),
			Position = UDim2.new(0,0,1,0)
		},

		centerleft = {
			AnchorPoint = Vector2.new(0,0.5),
			Position = UDim2.new(0.01,0,0.5,0)
		},

		clear = {
			BackgroundTransparency = 1
		},

		opaque = {
			BackgroundTransparency = 0
		}
	}
end

function DefaultStyles:Init()
	
end

function DefaultStyles:Start()
	
end



return DefaultStyles
