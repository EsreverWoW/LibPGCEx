-- ***************************************************************************************************************************************************
-- * PriceExternal.lua                                                                                                                               *
-- ***************************************************************************************************************************************************
-- * 0.5.0 / 2013.10.27 / Baanano: Structure update, renamed from ModulePriceComplex                                                                 *
-- * 0.4.1 / 2012.07.27 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local priceExternals = {}
local PriceExternalRegisteredEvent = Utility.Event.Create(addonID, "Price.External.Registered")
local PriceExternalUnregisteredEvent = Utility.Event.Create(addonID, "Price.External.Unregistered")


function Public.Price.External.Register(id, definition)
	if priceExternals[id] then return false end
	
	priceExternals[id] =
	{
		id = id,
		addon = Inspect.Addon.Current(),
		definition = definition,
	}
	PriceExternalRegisteredEvent(id)
	
	return true
end

function Public.Price.External.Unregister(id)
	if not priceExternals[id] then return false end
	
	assert(priceExternals[id].addon == Inspect.Addon.Current(), "Attempt to unregister a price external registered by other addon.")
	
	priceExternals[id] = nil
	PriceExternalUnregisteredEvent(id)
	
	return true
end

function Public.Price.External.Get(id)
	return priceExternals[id] and blUtil.Copy.Deep(priceExternals[id].definition) or nil, priceExternals[id] and priceExternals[id].addon or nil
end

function Public.Price.External.List()
	local externals = {}
	
	for id, externalData in pairs(priceExternals) do
		externals[id] = externalData.addon
	end
	
	return externals
end
