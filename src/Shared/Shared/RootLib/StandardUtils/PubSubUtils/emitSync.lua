local emitSync = {}

function emitSync:Main(self, ...)
	return self.PubSub:EmitSync(...)
end

return emitSync
