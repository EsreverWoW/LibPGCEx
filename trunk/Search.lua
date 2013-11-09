-- ***************************************************************************************************************************************************
-- * Search.lua                                                                                                                                      *
-- ***************************************************************************************************************************************************
-- * 0.5.0 / 2013.11.08 / Baanano: First version                                                                                 *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public


function Public.Search.Auctions(searcher, itemName, extra)
	return blTasks.Task.Create(
		function(taskHandle)
			local searcherDetail = Public.Search.Filter.Get(searcher)
			if not searcherDetail then return {} end
			
			local addon = searcherDetail.addon or addonID
			local definition = searcherDetail.definition
			local nativeFixed = definition.NativeFixed or {}
			local nativeMapping = definition.NativeMapping or {}
			
			itemName = itemName and tostring(itemName) or nil
			itemName = itemName and itemName:len() > 0 and itemName or nil
			local role = nativeFixed.role or (nativeMapping.role and extra and extra[nativeMapping.role] or nil) or nil
			local rarity = nativeFixed.rarity or (nativeMapping.rarity and extra and extra[nativeMapping.rarity] or nil) or nil
			local levelMin = nativeFixed.levelMin or (nativeMapping.levelMin and extra and extra[nativeMapping.levelMin] or nil) or 0
			levelMin = levelMin > 0 and levelMin or nil
			local levelMax = nativeFixed.levelMax or (nativeMapping.levelMax and extra and extra[nativeMapping.levelMax] or nil) or 60
			levelMax = levelMax > 0 and levelMax or nil
			local category = nativeFixed.category or (nativeMapping.category and extra and extra[nativeMapping.category] or nil) or nil
			local priceMin = nativeFixed.priceMin or (nativeMapping.priceMin and extra and extra[nativeMapping.priceMin] or nil) or 0
			priceMin = priceMin > 0 and priceMin or nil
			local priceMax = nativeFixed.priceMax or (nativeMapping.priceMax and extra and extra[nativeMapping.priceMax] or nil) or 0
			priceMax = priceMax > 0 and priceMax or nil
			
			local SearcherExecute = searcherDetail and searcherDetail.execute
			if type(SearcherExecute) ~= "function" then
				SearcherExecute = function(taskHandle, nativeAuctions, extra) return nativeAuctions end
			end
			
			return blTasks.Task.Create(
				function(taskHandle)
					return SearcherExecute(taskHandle, LibPGC.Search.Native(role, rarity, levelMin, levelMax, category, priceMin, priceMax, itemName):Result(), extra)
				end, addon):Result()

		end, addonID):Start()
end
