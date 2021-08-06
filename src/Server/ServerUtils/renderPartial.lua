function renderPartial(self, guiName, props, ancestor)
	local module = self[guiName]
  if (module == nil) then
    local msg = ("%s module not found"):format(guiName)
    error(msg)
  end
  local guiTree = module(props)
  if (ancestor) then
	  return self.GrootService:Render(guiTree, ancestor)
  else
    return self.GrootService:AbstractRender(guiTree, ancestor)
  end
end

return renderPartial
