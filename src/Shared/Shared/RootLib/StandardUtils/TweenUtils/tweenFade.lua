local tweenFade = {}

function tweenFade:Main(self, instance, params)
	local instanceType = typeof(instance)
	if (instanceType ~= "Instance") then
		error(("Expected instance instead got %s"):format(instanceType))
	end
	if (instance.ClassName == "Part") then
		local tween = self:createTween(instance, {Time = 0.5}, {Transparency = 1})
		tween:Play()
		tween.Completed:Wait()
	else
		-- it's a GUI
		local tween = self:createTween(instance, {Time = 1}, {BackgroundTransparency = 1, TextTransparency = 1, TextStrokeTransparency = 1})
		
		tween:Play()
		tween.Completed:Wait()
	end
end

return tweenFade
