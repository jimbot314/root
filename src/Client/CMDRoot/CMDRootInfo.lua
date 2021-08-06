local CMDRootInfo = {}

function CMDRootInfo:__OnInit()
	local info = {}
	self.info = info
	local cmd = self.CMDRootController
	function info:clear()
		cmd:ClearCLI()
	end
end

return CMDRootInfo
