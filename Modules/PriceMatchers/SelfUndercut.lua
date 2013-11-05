-- ***************************************************************************************************************************************************
-- * SelfUndercut.lua                                                                                                                                *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.29 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local L = Internal.Localization.L

local ID = "selfundercut"
local NAME = L["Matchers/SelfundercutName"]
local DEFAULT_SELF_RANGE = 25
local DEFAULT_UNDERCUT_RANGE = 25
local DEFAULT_UNDERCUT_RELATIVE = 0
local DEFAULT_UNDERCUT_ABSOLUTE = 1
local DEFAULT_NOCOMPETITION_RELATIVE = 25
local DEFAULT_NOCOMPETITION_ABSOLUTE = 0

local extraDescription =
{
	selfRange =
	{
		name = L["Matchers/SelfundercutSelfRange"],
		value = "integer",
		minValue = 0,
		maxValue = 100,
		defaultValue = DEFAULT_SELF_RANGE,	
	},
	undercutRange =
	{
		name = L["Matchers/SelfundercutUndercutRange"],
		value = "integer",
		minValue = 0,
		maxValue = 100,
		defaultValue = DEFAULT_UNDERCUT_RANGE,	
	},
	undercutRelative =
	{
		name = L["Matchers/SelfundercutUndercutRelative"],
		value = "integer",
		minValue = 0,
		maxValue = 100,
		defaultValue = DEFAULT_UNDERCUT_RELATIVE,	
	},
	undercutAbsolute =
	{
		name = L["Matchers/SelfundercutUndercutAbsolute"],
		value = "money",
		defaultValue = DEFAULT_UNDERCUT_ABSOLUTE,	
	},
	noCompetitionRelative =
	{
		name = L["Matchers/SelfundercutNoCompetitionRelative"],
		value = "integer",
		minValue = 0,
		maxValue = 100,
		defaultValue = DEFAULT_NOCOMPETITION_RELATIVE,	
	},
	noCompetitionAbsolute =
	{
		name = L["Matchers/SelfundercutNoCompetitionAbsolute"],
		value = "money",
		defaultValue = DEFAULT_NOCOMPETITION_ABSOLUTE,	
	},
	Layout =
	{
		{ "selfRange" },
		{ "undercutRange" },
		{ "undercutRelative" },
		{ "undercutAbsolute" },
		{ "noCompetitionRelative" },
		{ "noCompetitionAbsolute" },
		columns = 1,
	},
}

local function MatchFunction(taskHandle, item, originalBid, originalBuy, adjustedBid, adjustedBuy, auctions, extra)
	local selfRange = extra and extra.selfRange or DEFAULT_SELF_RANGE
	local undercutRange = extra and extra.undercutRange or DEFAULT_UNDERCUT_RANGE
	local undercutRelative = extra and extra.undercutRelative or DEFAULT_UNDERCUT_RELATIVE
	local undercutAbsolute = extra and extra.undercutAbsolute or DEFAULT_UNDERCUT_ABSOLUTE
	local noCompetitionRelative = extra and extra.noCompetitionRelative or DEFAULT_NOCOMPETITION_RELATIVE
	local noCompetitionAbsolute = extra and extra.noCompetitionAbsolute or DEFAULT_NOCOMPETITION_ABSOLUTE

	local ownBidLow = math.floor(adjustedBid - selfRange * adjustedBid / 100)
	local ownBidHigh = math.ceil(adjustedBid + selfRange * adjustedBid / 100)
	local ownBuyLow = math.floor(adjustedBuy - selfRange * adjustedBuy / 100)
	local ownBuyHigh = math.ceil(adjustedBuy + selfRange * adjustedBuy / 100)

	local undercutBidLow = math.floor(adjustedBid - undercutRange * adjustedBid / 100)
	local undercutBidHigh = math.ceil(adjustedBid + undercutRange * adjustedBid / 100)
	local undercutBuyLow = math.floor(adjustedBuy - undercutRange * adjustedBuy / 100)
	local undercutBuyHigh = math.ceil(adjustedBuy + undercutRange * adjustedBuy / 100)
	
	local selfBid, selfBuy = nil, nil
	local undercutBid, undercutBuy = nil, nil
		
	for auctionID, auctionData in pairs(auctions) do
		local bid, buy = auctionData.bidUnitPrice, auctionData.buyoutUnitPrice
		if auctionData.own then
			if selfRange > 0 and bid and bid >= ownBidLow and bid <= ownBidHigh and (not selfBid or bid < selfBid) then
				selfBid = bid
			end
			if selfRange > 0 and buy and buy >= ownBuyLow and buy <= ownBuyHigh and (not selfBuy or buy < selfBuy) then
				selfBuy = buy
			end
		else
			if undercutRange > 0 and bid and bid >= undercutBidLow and bid <= undercutBidHigh and (not undercutBid or bid < undercutBid) then
				undercutBid = bid
			end
			if undercutRange > 0 and buy and buy >= undercutBuyLow and buy <= undercutBuyHigh and (not undercutBuy or buy < undercutBuy) then
				undercutBuy = buy
			end
		end
	end
	
	undercutBid = undercutBid and math.floor(undercutBid - undercutBid * undercutRelative / 100 - undercutAbsolute) or nil
	undercutBuy = undercutBuy and math.floor(undercutBuy - undercutBuy * undercutRelative / 100 - undercutAbsolute) or nil

	if selfBid or selfBuy then
		adjustedBid = selfBid or adjustedBid
		adjustedBuy = selfBuy or adjustedBuy
	elseif undercutBid or undercutBuy then
		adjustedBid = undercutBid or adjustedBid
		adjustedBuy = undercutBuy or adjustedBuy
	else
		adjustedBid = math.floor(adjustedBid + adjustedBid * noCompetitionRelative / 100 + noCompetitionAbsolute)
		adjustedBuy = math.floor(adjustedBuy + adjustedBuy * noCompetitionRelative / 100 + noCompetitionAbsolute)
	end
	
	adjustedBid = math.max(1, adjustedBid)
	adjustedBuy = math.max(1, adjustedBuy)
	
	return adjustedBid, adjustedBuy
end

Public.Price.Matcher.Register(ID, { name = NAME, execute = MatchFunction, definition = extraDescription })
