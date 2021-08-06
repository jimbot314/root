local ProductService = {}

function ProductService:__OnStart() 
  self.MarketplaceService.ProcessReceipt = self:bind(self.ProcessReceipt, self)
  return
end

local function notify(plr, message)
	-- self.Network:FireClient(plr, "Alert", message, {status = "Success"})
end

function ProductService:_CheckAlreadyPurchased(plr, purchaseId)
	local products = self.Services.DataService.Get(plr,"Products")
	for key, product in pairs(products) do
		if product and type(product) == "table" and product.PurchaseId == purchaseId then
			return true
		end
	end
end

function ProductService:ProcessReceipt(receiptInfo)
	--	local playerProductKey =  receiptInfo.PlayerId.."_"..receiptInfo.PurchaseId
	local plr = self.Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if (not plr) then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	if (self:_CheckAlreadyPurchased(plr, receiptInfo.PurchaseId)) then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	local success, result = pcall(self.ProductFunctions[receiptInfo.ProductId],plr)
	if (not success or not result) then
		warn("success", success, "result", result)
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	self.Services.DataService.PushProductReceipt(plr,receiptInfo)
	return Enum.ProductPurchaseDecision.PurchaseGranted

end




return ProductService
