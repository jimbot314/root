local playTween = {}

function playTween:Main(self, target, params, goals)
	self:createTween(target, params, goals):Play()
end

return playTween
