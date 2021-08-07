local off = {}

function off:Main(self, ...)
	return self.PubSub:Off(...)
end

return off
