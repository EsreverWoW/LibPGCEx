-- ***************************************************************************************************************************************************
-- * Vendor.lua                                                                                                                                      *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.08.11 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local L = Internal.Localization.L

local ID = "vendor"
local NAME = L["Searchers/VendorName"]
local ONLINE_CAPABLE = false
local DEFAULT_USE_BUY = true
local DEFAULT_USE_BID = true
local DEFAULT_MIN_PROFIT = 1

local knownPrices = {}

local extraDescription =
{
	Online = ONLINE_CAPABLE,
	useBuy =
	{
		name = L["Searchers/VendorUseBuy"],
		value = "boolean",
		defaultValue = DEFAULT_USE_BUY,
	},
	useBid =
	{
		name = L["Searchers/VendorUseBid"],
		value = "boolean",
		defaultValue = DEFAULT_USE_BID,
	},
	bidDuration =
	{
		name = L["Searchers/VendorBidDuration"],
		value = "integer",
		minValue = 1,
		maxValue = 48,
		defaultValue = 48,
	},
	minProfit =
	{
		name = L["Searchers/VendorMinProfit"],
		value = "money",
		defaultValue = DEFAULT_MIN_PROFIT,
	},	
	NativeFixed =
	{
		role = nil,
		rarity = nil,
		levelMin = nil,
		levelMax = nil,
		category = nil,
		priceMin = nil,
		priceMax = nil,
	},
	NativeMapping =
	{
		role = nil,
		rarity = nil,
		levelMin = nil,
		levelMax = nil,
		category = nil,
		priceMin = nil,
		priceMax = nil,
	},
	Layout =
	{ 
		{ "useBuy", "useBid", "bidDuration", nil, "minProfit", nil },
		columns = 6,		
	},
	ExtraInfo =
	{
		bidProfit =
		{
			name = L["Searchers/VendorBidProfit"],
			value = "money",
		},
		buyProfit =
		{
			name = L["Searchers/VendorBuyProfit"],
			value = "money",
		},
		"bidProfit", "buyProfit",
	},
}

local function SearchFunction(taskHandle, nativeAuctions, extra)
	extra = type(extra) == "table" and extra or {}
	if not extra.useBid and not extra.useBuy then return {} end
	
	local maxTime = Inspect.Time.Server() + (extra.bidDuration or 48) * 3600
	for auctionID, auctionData in pairs(nativeAuctions) do
		local preserve = false

		if not knownPrices[auctionData.itemType] then
			local ok, itemDetail = pcall(Inspect.Item.Detail, auctionData.itemType)
			knownPrices[auctionData.itemType] = ok and itemDetail and (itemDetail.sell or 0) or nil
		end
		
		if knownPrices[auctionData.itemType] then
			local totalSell = auctionData.stack * knownPrices[auctionData.itemType]
			local minProfit = extra.minProfit
			
			nativeAuctions[auctionID].bidProfit = totalSell - auctionData.bidPrice
			nativeAuctions[auctionID].buyProfit = auctionData.buyoutPrice > 0 and totalSell - auctionData.buyoutPrice or -1
			
			if extra.useBid and auctionData.maxExpireTime <= maxTime and nativeAuctions[auctionID].bidProfit >= minProfit then preserve = true end
			if extra.useBuy and nativeAuctions[auctionID].buyProfit >= minProfit then preserve = true end
		end
		
		if not preserve then
			nativeAuctions[auctionID] = nil
		end
		
		taskHandle:BreathShort()
	end
	return nativeAuctions
end

Public.Search.Filter.Register(ID, { name = NAME, execute = SearchFunction, definition = extraDescription })
