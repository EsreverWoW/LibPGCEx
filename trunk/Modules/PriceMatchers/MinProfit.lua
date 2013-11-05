-- ***************************************************************************************************************************************************
-- * MinProfit.lua                                                                                                                                   *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.29 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local L = Internal.Localization.L

local ID = "minprofit"
local NAME = L["Matchers/MinprofitName"]
local DEFAULT_MIN_PROFIT = 0
local DEFAULT_SELL_PRICE = 1
local AH_FEE_MULTIPLIER = 0.95

local extraDescription =
{
	minProfit =
	{
		name = L["Matchers/MinprofitMinProfit"],
		value = "money",
		defaultValue = DEFAULT_MIN_PROFIT,
	},
	Layout =
	{
		{ "minProfit", },
		columns = 1
	},
}

local function MatchFunction(taskHandle, item, originalBid, originalBuy, adjustedBid, adjustedBuy, auctions, extra)
	local minProfit = extra and extra.minProfit or DEFAULT_MIN_PROFIT
	local ok, itemDetail = pcall(Inspect.Item.Detail, item)
	
	local sellPrice = ok and itemDetail and itemDetail.sell or DEFAULT_SELL_PRICE
	sellPrice = math.ceil((sellPrice + minProfit) / AH_FEE_MULTIPLIER)
	
	adjustedBid = math.max(sellPrice, adjustedBid)
	adjustedBuy = math.max(sellPrice, adjustedBuy)
	
	return adjustedBid, adjustedBuy
end

Public.Price.Matcher.Register(ID, { name = NAME, execute = MatchFunction, definition = extraDescription })
