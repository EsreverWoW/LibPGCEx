-- ***************************************************************************************************************************************************
-- * PriceStats.lua                                                                                                                                  *
-- ***************************************************************************************************************************************************
-- * 0.5.0 / 2013.10.27 / Baanano: Structure update                                                                                                  *
-- * 0.4.1 / 2012.07.26 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local priceStats = {}
local PriceStatRegisteredEvent = Utility.Event.Create(addonID, "Price.Stat.Registered")
local PriceStatUnregisteredEvent = Utility.Event.Create(addonID, "Price.Stat.Unregistered")


function Public.Price.Stat.Register(id, definition)
	if priceStats[id] then return false end
	
	priceStats[id] =
	{
		id = id,
		addon = Inspect.Addon.Current(),
		definition = definition,
	}
	PriceStatRegisteredEvent(id)
	
	return true
end

function Public.Price.Stat.Unregister(id)
	if not priceStats[id] then return false end
	
	assert(priceStats[id].addon == Inspect.Addon.Current(), "Attempt to unregister a price stat registered by other addon.")
	
	priceStats[id] = nil
	PriceStatUnregisteredEvent(id)
	
	return true
end

function Public.Price.Stat.Get(id)
	return priceStats[id] and blUtil.Copy.Deep(priceStats[id].definition) or nil, priceStats[id] and priceStats[id].addon or nil
end

function Public.Price.Stat.List()
	local stats = {}
	
	for id, statData in pairs(priceStats) do
		stats[id] = statData.addon
	end
	
	return stats
end
