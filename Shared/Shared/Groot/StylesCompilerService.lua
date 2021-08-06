local StylesCompiler = {}
-- Name has to include service at the end for full subscription

function StylesCompiler:__OnInit()
	self.Styles = {}
	local styleSheets = self.Folders.Styles:GetChildren()
	for i=1,#styleSheets do
		local styleSheetName = styleSheets[i].Name
		local stylesDictionary = self[styleSheetName]:All()
		for class,styles in pairs(stylesDictionary) do
			self:checkTableDoesNotHaveKey(self.Styles, class)
			self.Styles[class] = styles
		end
	end
	
	self.injectIntoRootTable("GrootStyles", self.Styles)
end

function StylesCompiler:__OnStart()
	
end

return StylesCompiler
