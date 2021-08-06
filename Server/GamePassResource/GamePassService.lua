local GamePassService = {
	__includes = "GamePassStore"
}

function GamePassService:__OnStart()
  self.MarketplaceService.PromptGamePassPurchaseFinished:Connect(self:bind(self._HandlePurchaseFinished, self))
  return
end

-- function GamePassService:__OnPlayerDataLoaded(plr, data)
-- 	local gamePassesData = data.GamePasses
-- 	local gamePasses = self.Shared.GamePassesInfo.GetGamePasses()
-- 	for i=1,#gamePasses do
-- 		local gamePassId = gamePasses[i].Id
-- 		local playerOwnedGamePass = self:_FindGamePass(gamePassId, gamePassesData)
-- 		if (playerOwnedGamePass) then
-- 			self.GamePassFunctions[gamePassId](plr)
-- 		else
-- 			local success,result = pcall(function()
-- 				return self.MarketplaceService:UserOwnsGamePassAsync(plr.UserId, gamePassId)
-- 			end)
-- 			if (success and result) then
-- 				local price = self.MarketplaceService:GetProductInfo(gamePassId).PriceInRobux
-- 				self.Services.DataService.PushGamePass(plr,gamePassId,price)
-- 				self.GamePassFunctions[gamePassId](plr)
-- 			end
-- 		end
-- 	end
-- end

function GamePassService:_HandlePurchaseFinished(plr, gamePassId, purchaseSuccess)
	if purchaseSuccess then
		local price = self.MarketplaceService:GetProductInfo(gamePassId).PriceInRobux
		self.Services.DataService.PushGamePass(plr,gamePassId,price)
		self.GamePassFunctions[gamePassId](plr)
		print(gamePassId,type(gamePassId))
	end
end

function GamePassService:_FindGamePass(gamePassId, gamePassesData)
	local gamePassData = gamePassesData[tostring(gamePassId)]
	if (gamePassData) then
		return gamePassData
	end
	return false
end



return GamePassService
