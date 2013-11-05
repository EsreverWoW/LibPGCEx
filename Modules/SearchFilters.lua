-- ***************************************************************************************************************************************************
-- * SearchFilters.lua                                                                                                                               *
-- ***************************************************************************************************************************************************
-- * 0.5.0 / 2013.10.27 / Baanano: Overhauled ModuleAuctionSearchers                                                                                 *
-- * 0.4.12/ 2013.09.17 / Baanano: Updated to the new event model                                                                                    *
-- * 0.4.1 / 2012.08.10 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

local searchFilters = {}
local SearchFilterRegisteredEvent = Utility.Event.Create(addonID, "Search.Filter.Registered")
local SearchFilterUnregisteredEvent = Utility.Event.Create(addonID, "Search.Filter.Unregistered")


function Public.Search.Filter.Register(id, definition)
	if searchFilters[id] then return false end
	
	searchFilters[id] =
	{
		id = id,
		addon = Inspect.Addon.Current(),
		definition = definition,
	}
	SearchFilterRegisteredEvent(id)
	
	return true
end

function Public.Search.Filter.Unregister(id)
	if not searchFilters[id] then return false end
	
	assert(searchFilters[id].addon == Inspect.Addon.Current(), "Attempt to unregister a search filter registered by other addon.")
	
	searchFilters[id] = nil
	SearchFilterUnregisteredEvent(id)
	
	return true
end

function Public.Search.Filter.Get(id)
	return searchFilters[id] and blUtil.Copy.Deep(searchFilters[id].definition) or nil, searchFilters[id] and searchFilters[id].addon or nil
end

function Public.Search.Filter.List()
	local filters = {}
	
	for id, filterData in pairs(searchFilters) do
		filters[id] = filterData.addon
	end
	
	return filters
end
