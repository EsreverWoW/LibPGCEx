-- ***************************************************************************************************************************************************
-- * Vendor.lua                                                                                                                                      *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.24 / Baanano: Rewritten for LibPGCEx                                                                                            *
-- * 0.4.0 / 2012.06.17 / Baanano: Rewritten for 1.9                                                                                                 *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local L = Internal.Localization.L

local ID = "vendor"
local NAME = L["Fallbacks/VendorName"]
local DEFAULT_SELL_PRICE = 1
local DEFAULT_BID_MULTIPLIER = 3
local DEFAULT_BUY_MULTIPLIER = 5
local MAX_MULTIPLIER = 100

local extraDescription =
{
	bidMultiplier =
	{
		name = L["Fallbacks/VendorBidMultiplier"],
		value = "integer",
		minValue = 1,
		maxValue = MAX_MULTIPLIER,
		defaultValue = DEFAULT_BID_MULTIPLIER,
	},
	buyMultiplier =
	{
		name = L["Fallbacks/VendorBuyMultiplier"],
		value = "integer",
		minValue = 1,
		maxValue = MAX_MULTIPLIER,
		defaultValue = DEFAULT_BUY_MULTIPLIER,
	},
	Layout = 
	{
		{ "bidMultiplier" },
		{ "buyMultiplier" },
		columns = 1,
	}
}

local function PriceFunction(taskHandle, item, extra)
	local ok, itemDetail = pcall(Inspect.Item.Detail, item)
	
	local bidMultiplier = extra and extra.bidMultiplier or DEFAULT_BID_MULTIPLIER
	local buyMultiplier = extra and extra.buyMultiplier or DEFAULT_BUY_MULTIPLIER
	local sellPrice = ok and itemDetail and itemDetail.sell or DEFAULT_SELL_PRICE
	
	local bid = math.floor(sellPrice * bidMultiplier)
	local buy = math.floor(sellPrice * buyMultiplier)
	bid = math.min(bid, buy)
	
	return bid, buy
end

Public.Price.Fallback.Register(ID, { name = NAME, execute = PriceFunction, definition = extraDescription })
