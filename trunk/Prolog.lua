-- ***************************************************************************************************************************************************
-- * Prolog.lua                                                                                                                                      *
-- ***************************************************************************************************************************************************
-- * 0.5.0 / 2013.10.27 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier

-- Initialize Internal table
addonData.Internal = addonData.Internal or {}
local Internal = addonData.Internal

-- Initialize Internal hierarchy
Internal.Constants = {}
Internal.Localization = {}

-- Initialize Public table
_G[addonID] = _G[addonID] or {}
addonData.Public = _G[addonID]
local Public = addonData.Public

-- Initialize Public hierarchy
Public.Search = {}
Public.Search.Filter = {}
Public.Price = {}
Public.Price.Fallback = {}
Public.Price.Sampler = {}
Public.Price.Stat = {}
Public.Price.External = {}
Public.Price.Matcher = {}
