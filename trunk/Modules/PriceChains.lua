-- ***************************************************************************************************************************************************
-- * PriceChains.lua                                                                                                                                 *
-- ***************************************************************************************************************************************************
-- * 0.5.0 / 2013.10.27 / Baanano: Overhauled from ModulePriceModels                                                                                 *
-- * 0.4.1 / 2012.07.28 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local priceChains = {}
local PriceChainRegisteredEvent = Utility.Event.Create(addonID, "Price.Registered")
local PriceChainUnregisteredEvent = Utility.Event.Create(addonID, "Price.Unregistered")


function Public.Price.Register(id, definition)
	if priceChains[id] then return false end
	
	priceChains[id] =
	{
		id = id,
		addon = Inspect.Addon.Current(),
		definition = definition,
	}
	PriceChainRegisteredEvent(id)
	
	return true
end

function Public.Price.Unregister(id)
	if not priceChains[id] then return false end
	
	assert(priceChains[id].addon == Inspect.Addon.Current(), "Attempt to unregister a price registered by other addon.")
	
	priceChains[id] = nil
	PriceChainUnregisteredEvent(id)
	
	return true
end

function Public.Price.Get(id)
	return id and priceChains[id] and blUtil.Copy.Deep(priceChains[id].definition) or nil, priceChains[id] and priceChains[id].addon or nil
end

function Public.Price.List()
	local chains = {}
	
	for id, chainData in pairs(priceChains) do
		chains[id] = chainData.addon
	end
	
	return chains
end
