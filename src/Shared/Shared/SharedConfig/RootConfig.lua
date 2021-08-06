local RunService = game:GetService("RunService")

local ROOT_ENV = "development"
if (not RunService:IsStudio()) then
  ROOT_ENV = "production"
end

local SharedRootConfig = {
  ROOT_ENV = ROOT_ENV,
  -- server specific configs
  -- client specific configs
}


return SharedRootConfig