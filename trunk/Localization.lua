-- ***************************************************************************************************************************************************
-- * Localization.lua                                                                                                                                *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.24 / Baanano: Separate version for LibPGCEx                                                                                     *
-- * 0.4.0 / 2012.05.30 / Baanano: Old LocalizationService.lua file                                                                                  *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

Internal.Localization.L = Internal.Localization.L or
setmetatable({},
	{
		__index = 
			function(tab, key)
				rawset(tab, key, key)
				return key
			end,
		
		__newindex = 
			function(tab, key, value)
				if value == true then
					rawset(tab, key, key)
				else
					rawset(tab, key, value)
				end
			end,
	}
)

function Internal.Localization.Register(locale, tab)
	local L = Internal.Localization.L
	if locale == "English" or locale == Inspect.System.Language() then
		for key, value in pairs(tab) do
			L[key] = type(value) == "string" and value or key
		end
	end
end
