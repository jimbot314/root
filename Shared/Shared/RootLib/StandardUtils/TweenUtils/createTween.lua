local createTween = {}

function createTween:Main(self, target, params, goals)
	local timeNum = params.Time or 1
	local easingStyle = params.EasingStyle and Enum.EasingStyle[params.EasingStyle] or 0
	local easingDirection = params.EasingDirection and Enum.EasingDirection[params.EasingDirection] or 2
	local repeatCount = params.RepeatCount or 0
	local reverses = params.Reverses or false
	local delayTime = params.DelayTime or 0
	local tweenInfo = TweenInfo.new(
		timeNum,
		easingStyle,
		easingDirection,
		repeatCount,
		reverses,
		delayTime
	)
	return self.TweenService:Create(target, tweenInfo, goals)
end

return createTween
