-- ***************************************************************************************************************************************************
-- * PriceSamplers.lua                                                                                                                               *
-- ***************************************************************************************************************************************************
-- * 0.5.0 / 2013.10.27 / Baanano: Structure update                                                                                                  *
-- * 0.4.1 / 2012.07.24 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local priceSamplers = {}
local PriceSamplerRegisteredEvent = Utility.Event.Create(addonID, "Price.Sampler.Registered")
local PriceSamplerUnregisteredEvent = Utility.Event.Create(addonID, "Price.Sampler.Unregistered")


function Public.Price.Sampler.Register(id, definition)
	if priceSamplers[id] then return false end
	
	priceSamplers[id] =
	{
		id = id,
		addon = Inspect.Addon.Current(),
		definition = definition,
	}
	PriceSamplerRegisteredEvent(id)
	
	return true
end

function Public.Price.Sampler.Unregister(id)
	if not priceSamplers[id] then return false end
	
	assert(priceSamplers[id].addon == Inspect.Addon.Current(), "Attempt to unregister a price sampler registered by other addon.")
	
	priceSamplers[id] = nil
	PriceSamplerUnregisteredEvent(id)
	
	return true
end

function Public.Price.Sampler.Get(id)
	return id and priceSamplers[id] and blUtil.Copy.Deep(priceSamplers[id].definition) or nil, priceSamplers[id] and priceSamplers[id].addon or nil
end

function Public.Price.Sampler.List()
	local samplers = {}
	
	for id, samplerData in pairs(priceSamplers) do
		samplers[id] = samplerData.addon
	end
	
	return samplers
end
