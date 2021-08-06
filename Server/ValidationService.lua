local ValidationService = {}

function ValidationService:Validate(suite)
  local t = self.TestUtils
  for k,fn in ipairs(suite) do
    local result, message = fn(t)
    if (result == false) then
      error("Did not pass validation")
      error(message)
    end
  end
  return true
end

return ValidationService