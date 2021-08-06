local function checkTableDoesNotHaveKey(tbl, key)
	if (tbl[key]) then
		local tableName = tbl.Name or "Unnamed"
		local errorMsg = "Error: %s was already added to %s, module names must be unique"
		error(errorMsg:format(key, tableName))
	end
end

local function checkRemoteSubscription(str)
	if (type(str) == "string" and str:sub(1,6) == "__Recv") then
		return true
	else
		return false
	end
end

local function checkRemoteValidation(str)
	if (type(str) == "string" and str:sub(1,5) == "__Val") then
		return true
	else
		return false
	end
end

local function getEndpointName(str)
	return str:sub(7)
end

local function getValidationName(str)
	return "__Val" .. str:sub(7)
end

local function bind(fn, context)
	return function(...)
		return fn(context, ...)
	end
end

local RunService = game:GetService("RunService")
local IS_CLIENT = RunService:IsClient()

local function registerRemotes(serviceModule, endpoints)
	for k,v in pairs(serviceModule) do
		if (checkRemoteSubscription(k)) then
			checkTableDoesNotHaveKey(endpoints, k)
			--local validationFunctionName = getValidationName(k)
			--local validationFunction = serviceModule[validationFunctionName]
			--if (not IS_CLIENT) then
			--	if (validationFunction == nil) then
			--		local msg = ("%s endpoint not validated"):format(k)
			--		warn(msg)
			--	end
			--end
			local endpointName = getEndpointName(k)
			endpoints[endpointName] = {
				Call = bind(v, serviceModule),
				--Validate = validationFunction and bind(validationFunction, serviceModule) or nil
			}
		end
	end
end

return registerRemotes
