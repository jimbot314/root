local emit = {}

function emit:Main(self, ...)
	return self.PubSub:Emit(...)
end

return emit
