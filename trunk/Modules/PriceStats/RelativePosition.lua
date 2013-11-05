-- ***************************************************************************************************************************************************
-- * RelativePosition.lua                                                                                                                            *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.28 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local L = Internal.Localization.L

local ID = "rpos"
local NAME = L["Stats/RposName"]
local DEFAULT_WEIGHTED = true
local DEFAULT_POSITION = 50

local extraDescription =
{
	weighted =
	{
		name = L["Stats/RposWeighted"],
		value = "boolean",
		defaultValue = DEFAULT_WEIGHTED,
	},
	position =
	{
		name = L["Stats/RposPosition"],
		value = "integer",
		minValue = 0,
		maxValue = 100,
		defaultValue = DEFAULT_POSITION,	
	},
	Layout =
	{
		{ "weighted" },
		{ "position" },
		columns = 1
	}
}

local function StatFunction(taskHandle, auctions, extra)
	local weighted = extra and extra.weighted
	if weighted == nil then weighted = DEFAULT_WEIGHTED end
	local position = extra and extra.position or DEFAULT_POSITION
	
	local priceOrder = {}
	
	for auctionID, auctionData in pairs(auctions) do
		local weight = weighted and auctionData.stack or 1
		
		for i = 1, weight do
			priceOrder[#priceOrder + 1] = auctionID
		end
	end
	
	if #priceOrder <= 0 then return nil end
	
	table.sort(priceOrder, function(a, b) return auctions[a].buyoutUnitPrice < auctions[b].buyoutUnitPrice end)

	local index = math.min(math.floor(position * #priceOrder / 100) + 1, #priceOrder)

	return auctions[priceOrder[index]].buyoutUnitPrice
end

Public.Price.Stat.Register(ID, { name = NAME, execute = StatFunction, definition = extraDescription })
