local grootbasestyles = {}

function grootbasestyles:__OnInit()
	
end

function grootbasestyles:All()
	local gsc = self.grootstylesconfig
	return {
		TextLabel = gsc:Construct({
			"BackgroundColor3",
			"BackgroundTransparency",
			"BorderColor3",
			"BorderMode",
			"BorderSizePixel",
			"Position",
			"Rotation",
			
			"Visible",
			"ZIndex",
			"Font",
			"LineHeight",
			"TextColor3",
			"TextScaled",
			"TextSize",
			"TextStrokeColor3",
			"TextStrokeTransparency",
			"TextWrapped",
			"TextXAlignment",
			"TextYAlignment",
			
			"UIPadding",
			-- "UICorner"
		}, {
			Size = UDim2.new(1,0,1,0),
			SizeConstraint = Enum.SizeConstraint.RelativeXY,
			TextTransparency = 0.1
		}),
		
		TextButton = gsc:Construct({
			"BackgroundColor3",
			"BackgroundTransparency",
			"BorderColor3",
			"BorderMode",
			"BorderSizePixel",
			"Position",
			"Rotation",

			"Visible",
			"ZIndex",
			"Font",
			"LineHeight",
			"TextColor3",
			"TextScaled",
			"TextSize",
			"TextStrokeColor3",
			"TextStrokeTransparency",
			"TextWrapped",
			"TextXAlignment",
			"TextYAlignment",

			"UIPadding",
			-- "UICorner"
		}, {
			Size = UDim2.new(1,0,1,0),
			SizeConstraint = Enum.SizeConstraint.RelativeXY,
			TextTransparency = 0.1
		}),
		
		TextBox = gsc:Construct({
			
			"BackgroundColor3",
			"BackgroundTransparency",
			"BorderColor3",
			"BorderMode",
			"BorderSizePixel",
			"Position",
			"Rotation",

			"Visible",
			"ZIndex",
			"Font",
			"LineHeight",
			"TextColor3",
			"TextScaled",
			"TextSize",
			"TextStrokeColor3",
			"TextStrokeTransparency",
			"TextWrapped",
			"TextXAlignment",
			"TextYAlignment",

			"UIPadding",
			--"UICorner"
		}, {
			Size = UDim2.new(1,0,1,0),
			SizeConstraint = Enum.SizeConstraint.RelativeXY,
			TextTransparency = 0.1
		}),
		
		Frame = gsc:Construct({
			"BackgroundColor3",
			"BackgroundTransparency",
			"BorderColor3",
			"BorderMode",
			"BorderSizePixel",
			"Position",
			"Size",
			"SizeConstraint",
			-- "UICorner"
		}, {
			Size = UDim2.new(0.2,0,0.1,0)
		}),
		
		ScrollingFrame = gsc:Construct({
			
			"BackgroundColor3",
			"BackgroundTransparency",
			"BorderColor3",
			"BorderMode",
			"BorderSizePixel",
			"Position",
			"Size",
			-- "UICorner"
		}, {
			Size = UDim2.new(0.2,0,0.1,0)
		}),

		ViewportFrame = gsc:Construct({
			"BackgroundColor3",
			"BackgroundTransparency",
			"BorderColor3",
			"BorderMode",
			"BorderSizePixel",
			"Position",
			"Size",
			-- "UICorner"
		}),
		
		ScreenGui = gsc:Construct({
			"IgnoreGuiInset",
			"ResetOnSpawn"
		}),
		
		BillboardGui = gsc:Construct({
			"ResetOnSpawn"
		}, {
			Active = true,
			LightInfluence = 1,
			MaxDistance = 50,
			--ResetOnSpawn = false,
			Size = UDim2.new(0,100,0,50),
			--StudsOffset = Vector3.new(0,3,0)
			ExtentsOffsetWorldSpace = Vector3.new(0,3,0)
		})
	}
end

function grootbasestyles:__OnStart()
	
end



return grootbasestyles
