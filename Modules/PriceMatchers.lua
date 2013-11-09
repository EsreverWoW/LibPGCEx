-- ***************************************************************************************************************************************************
-- * PriceMatchers.lua                                                                                                                               *
-- ***************************************************************************************************************************************************
-- * 0.5.0 / 2013.10.27 / Baanano: Structure update                                                                                                  *
-- * 0.4.1 / 2012.07.29 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local priceMatchers = {}
local PriceMatcherRegisteredEvent = Utility.Event.Create(addonID, "Price.Matcher.Registered")
local PriceMatcherUnregisteredEvent = Utility.Event.Create(addonID, "Price.Matcher.Unregistered")


function Public.Price.Matcher.Register(id, definition)
	if priceMatchers[id] then return false end
	
	priceMatchers[id] =
	{
		id = id,
		addon = Inspect.Addon.Current(),
		definition = definition,
	}
	PriceMatcherRegisteredEvent(id)
	
	return true
end

function Public.Price.Matcher.Unregister(id)
	if not priceMatchers[id] then return false end
	
	assert(priceMatchers[id].addon == Inspect.Addon.Current(), "Attempt to unregister a price matcher registered by other addon.")
	
	priceMatchers[id] = nil
	PriceMatcherUnregisteredEvent(id)
	
	return true
end

function Public.Price.Matcher.Get(id)
	return id and priceMatchers[id] and blUtil.Copy.Deep(priceMatchers[id].definition) or nil, priceMatchers[id] and priceMatchers[id].addon or nil
end

function Public.Price.Matcher.List()
	local matchers = {}
	
	for id, matcherData in pairs(priceMatchers) do
		matchers[id] = matcherData.addon
	end
	
	return matchers
end
