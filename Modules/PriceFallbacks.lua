-- ***************************************************************************************************************************************************
-- * PriceFallbacks.lua                                                                                                                              *
-- ***************************************************************************************************************************************************
-- * 0.5.0 / 2013.10.27 / Baanano: Structure update                                                                                                  *
-- * 0.4.1 / 2012.07.24 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local priceFallbacks = {}
local PriceFallbackRegisteredEvent = Utility.Event.Create(addonID, "Price.Fallback.Registered")
local PriceFallbackUnregisteredEvent = Utility.Event.Create(addonID, "Price.Fallback.Unregistered")


function Public.Price.Fallback.Register(id, definition)
	if priceFallbacks[id] then return false end
	
	priceFallbacks[id] =
	{
		id = id,
		addon = Inspect.Addon.Current(),
		definition = definition,
	}
	PriceFallbackRegisteredEvent(id)
	
	return true
end

function Public.Price.Fallback.Unregister(id)
	if not priceFallbacks[id] then return false end
	
	assert(priceFallbacks[id].addon == Inspect.Addon.Current(), "Attempt to unregister a price fallback registered by other addon.")
	
	priceFallbacks[id] = nil
	PriceFallbackUnregisteredEvent(id)
	
	return true
end

function Public.Price.Fallback.Get(id)
	return priceFallbacks[id] and blUtil.Copy.Deep(priceFallbacks[id].definition) or nil, priceFallbacks[id] and priceFallbacks[id].addon or nil
end

function Public.Price.Fallback.List()
	local fallbacks = {}
	
	for id, fallbackData in pairs(priceFallbacks) do
		fallbacks[id] = fallbackData.addon
	end
	
	return fallbacks
end
