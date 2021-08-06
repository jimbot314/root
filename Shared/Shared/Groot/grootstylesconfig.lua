local grootstylesconfig = {
	Active = false,
	AnchorPoint = UDim.new(0,0),
	AutomaticSize = Enum.AutomaticSize.None,
	BackgroundColor3 = Color3.new(0,0,0),
	BackgroundTransparency = 0.5,
	BorderColor3 = Color3.new(1,1,1),
	BorderMode = Enum.BorderMode.Outline,
	BorderSizePixel = 0,
	LayoutOrder = 0,
	Position = UDim2.new(0,0,0,0),
	Rotation = 0,
	Selectable = false,
	Size = UDim2.new(1,0,1,0),
	SizeConstraint = Enum.SizeConstraint.RelativeYY,
	Visible = true,
	ZIndex = 1,
	Archivable = true,
	ClipsDescendants = false,
	Font = Enum.Font.GothamBold,
	LineHeight = 1,
	MaxVisibleGraphemes = -1,
	RichText = false,
	TextColor3 = Color3.new(0.7,0.7,0.7),
	TextScaled = false,
	TextSize = 14,
	TextStrokeColor3 = Color3.new(0.1,0.1,0.1),
	TextStrokeTransparency = 1,
	TextTransparency = 0,
	TextTruncate = Enum.TextTruncate.None,
	TextWrapped = false,
	TextXAlignment = Enum.TextXAlignment.Center,
	TextYAlignment = Enum.TextYAlignment.Center,
	Autolocalize = true,
	
	
	IgnoreGuiInset = false,
	ResetOnSpawn = false,
	
	
	UIPadding = {
		PaddingBottom = UDim.new(0.1,0),
		PaddingLeft = UDim.new(0.1,0),
		PaddingRight = UDim.new(0.1,0),
		PaddingTop = UDim.new(0.1,0)
	},
	
	UICorner = {
		CornerRadius = UDim.new(0,6)
	}
}

function grootstylesconfig:Construct(props, styles)
	local styles = styles or {}
	for i=1,#props do
		local prop = props[i]
		styles[prop] = self[prop]
	end
	return styles
end







return grootstylesconfig
