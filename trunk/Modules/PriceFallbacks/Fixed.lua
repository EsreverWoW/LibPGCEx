-- ***************************************************************************************************************************************************
-- * Fixed.lua                                                                                                                                       *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.10.27 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local L = Internal.Localization.L

local ID = "fixed"
local NAME = L["Fallbacks/FixedName"]
local DEFAULT_PRICE = 1

local extraDescription =
{
	bidPrice =
	{
		name = L["Fallbacks/FixedBidPrice"],
		value = "money",
		defaultValue = DEFAULT_PRICE,
	},
	buyPrice =
	{
		name = L["Fallbacks/FixedBuyPrice"],
		value = "money",
		defaultValue = DEFAULT_PRICE,
	},
	Layout = 
	{
		{ "bidPrice" },
		{ "buyPrice" },
		columns = 1,
	}
}

local function PriceFunction(taskHandle, item, extra)
	local bid = extra and extra.bidPrice or DEFAULT_PRICE
	local buy = extra and extra.buyPrice or DEFAULT_PRICE

	bid = math.min(bid, buy)
	
	return bid, buy
end

Public.Price.Fallback.Register(ID, { name = NAME, execute = PriceFunction, definition = extraDescription })
