-- ***************************************************************************************************************************************************
-- * PriceSamplers/Time.lua                                                                                                                          *
-- ***************************************************************************************************************************************************
-- * Time price sampler                                                                                                                              *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.25 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
_G[addonID] = _G[addonID] or {}
local PublicInterface = _G[addonID]

local L = InternalInterface.Localization.L

local pairs = pairs

local ID = "time"
local NAME = L["Samplers/TimeName"]
local DEFAULT_DAYS = 3
local MAX_DAYS = 30
local DAY_LENGTH = 86400

local extraDescription =
{
	days =
	{
		name = L["Samplers/TimeDays"],
		value = "integer",
		minValue = 0,
		maxValue = MAX_DAYS,
		defaultValue = DEFAULT_DAYS,
	},
	Layout =
	{
		{ "days" },
		columns = 1,
	}
}

local function SampleFunction(auctions, startTime, extra)
	local days = extra and extra.days or DEFAULT_DAYS

	local timeLimit = days > 0 and startTime - days * DAY_LENGTH or nil
	
	local filteredAuctions = {}
	
	for auctionID, auctionData in pairs(auctions) do
		if (timeLimit and auctionData.lastSeenTime >= timeLimit) or (not timeLimit and auctionData.active) then
			filteredAuctions[auctionID] = auctionData
		end
	end

	return filteredAuctions
end

PublicInterface.RegisterPriceSampler(ID, NAME, SampleFunction, extraDescription)
