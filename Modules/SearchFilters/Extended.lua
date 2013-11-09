-- ***************************************************************************************************************************************************
-- * Extended.lua                                                                                                                                    *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.08.12 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local L = Internal.Localization.L

local ID = "extended"
local NAME = L["Searchers/ExtendedName"]
local ONLINE_CAPABLE = false
local DEFAULT_CALLING = nil
local DEFAULT_RARITY = "sellable"
local DEFAULT_CATEGORY = ""
local MIN_LEVEL = 0
local MAX_LEVEL = 60

local extraDescription =
{
	Online = ONLINE_CAPABLE,
	calling =
	{
		name = L["Searchers/ExtendedCalling"],
		value = "calling",
		defaultValue = DEFAULT_CALLING,
	},
	rarity =
	{
		name = L["Searchers/ExtendedRarity"],
		value = "rarity",
		defaultValue = DEFAULT_RARITY,
	},
	levelMin =
	{
		name = L["Searchers/ExtendedLevelMin"],
		value = "integer",
		minValue = MIN_LEVEL,
		maxValue = MAX_LEVEL,
		defaultValue = MIN_LEVEL,
	},
	levelMax =
	{
		name = L["Searchers/ExtendedLevelMax"],
		value = "integer",
		minValue = MIN_LEVEL,
		maxValue = MAX_LEVEL,
		defaultValue = MAX_LEVEL,
	},
	category =
	{
		name = L["Searchers/ExtendedCategory"],
		value = "category",
		defaultValue = DEFAULT_CATEGORY,
	},
	bidMin =
	{
		name = L["Searchers/ExtendedBidMin"],
		value = "money",
		defaultValue = 0,
	},	
	bidMax =
	{
		name = L["Searchers/ExtendedBidMax"],
		value = "money",
		defaultValue = 0,
	},
	buyMin =
	{
		name = L["Searchers/ExtendedBuyMin"],
		value = "money",
		defaultValue = 0,
	},	
	buyMax =
	{
		name = L["Searchers/ExtendedBuyMax"],
		value = "money",
		defaultValue = 0,
	},
	timeLeft =
	{
		name = L["Searchers/ExtendedTimeLeft"],
		value = "integer",
		minValue = 1,
		maxValue = 48,
		defaultValue = 48,
	},
	seller =
	{
		name = L["Searchers/ExtendedSeller"],
		value = "text",
		defaultValue = "",
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
		role = "calling",
		rarity = "rarity",
		levelMin = "levelMin",
		levelMax = "levelMax",
		category = "category",
		priceMin = nil,
		priceMax = nil,
	},
	Layout =
	{ 
		{ "calling", "rarity", "category", nil },
		{ "seller", "timeLeft", "bidMin", "bidMax", },
		{ "levelMin", "levelMax", "buyMin", "buyMax", },
		columns = 4,
	},
	ExtraInfo = { },
}

local function SearchFunction(taskHandle, nativeAuctions, extra)
	extra = extra or {}
	
	local seller = (extra.seller or ""):upper()
	local maxTime = Inspect.Time.Server() + (extra.timeLeft or 48) * 3600
	local bidMin = extra.bidMin or 0
	local bidMax = extra.bidMax and extra.bidMax > 0 and extra.bidMax or math.huge
	local buyMin = extra.buyMin or 0
	local buyMax = extra.buyMax and extra.buyMax > 0 and extra.buyMax or math.huge
	
	for auctionID, auctionData in pairs(nativeAuctions) do
		local preserve = true
		
		preserve = preserve and ((auctionData.sellerName:upper():find(seller, 1, true)) and true or false)
		preserve = preserve and auctionData.maxExpireTime <= maxTime
		preserve = preserve and auctionData.bidUnitPrice >= bidMin and auctionData.bidUnitPrice <= bidMax
		preserve = preserve and (auctionData.buyoutUnitPrice or 0) >= buyMin and (auctionData.buyoutUnitPrice or 0) <= buyMax
		
		if not preserve then
			nativeAuctions[auctionID] = nil
		end
		
		taskHandle:BreathShort()
	end
	
	return nativeAuctions
end

Public.Search.Filter.Register(ID, { name = NAME, execute = SearchFunction, definition = extraDescription })
