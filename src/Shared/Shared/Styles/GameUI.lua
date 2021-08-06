local GameUI = {}

function GameUI:All()
	return {
		["inv-selected"] = {
			BackgroundTransparency = 0.2,
			BackgroundColor3 = Color3.new(0.4,0.4,0.4),
			TextColor3 = Color3.new(1,1,1)
		},
		itemnotpurchased = {
			BackgroundColor3 = Color3.new(0.4,0.6,0.4),
			Text = "Purchase"
		},
		itempurchased = {
			BackgroundColor3 = Color3.new(0.2,0.4,0.2),
			Text = "Item Purchased"
		},
		equipbtn = {
			BackgroundColor3 = Color3.new(0.4,0.6,0.4),
			Text = "Equip",
		},
		unequipbtn = {
			BackgroundColor3 = Color3.new(0.6,0.4,0.4),
			Text = "Unequip"
		}
	}
end

return GameUI
