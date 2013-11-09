-- ***************************************************************************************************************************************************
-- * Price.lua                                                                                                                                       *
-- ***************************************************************************************************************************************************
-- * 0.5.0 / 2013.10.27 / Baanano: Overhauled from ModulePriceModels                                                                                 *
-- * 0.4.1 / 2012.07.28 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public


function Public.Price.Calculate(item, chains, bidPercentage, dontMatch)
	-- 1. Check parameters
	if not item then return false end
	
	bidPercentage = math.min(type(bidPercentage) == "number" and bidPercentage or 1, 1)
	
	if not chains then
		chains = Public.Price.List()
	elseif type(chains) ~= "table" then 
		chains = { [chains] = true } 
	end
	
	-- 2. Find the required chains
	local simple, stat, external, composite = {}, {}, {}, {}
	local noneFound = true
	
	for id in pairs(chains) do
		local chainDefinition = Public.Price.Get(id)
		if chainDefinition then
			if chainDefinition.modelType == "simple" then
				simple[id] = chainDefinition
			elseif chainDefinition.modelType == "statistical" then
				stat[id] = chainDefinition
			elseif chainDefinition.modelType == "complex" then
				external[id] = chainDefinition
			elseif chainDefinition.modelType == "composite" then
				composite[id] = chainDefinition
			end

			noneFound = nil
		end
	end
	if noneFound then return false end
	
	-- 3. Expand composite chains
	local continueExpansion = next(composite) and true or false
	while continueExpansion do
		continueExpansion = false
		
		for id, chainDefinition in pairs(composite) do
			for dependency in pairs(chainDefinition.usage) do
				local dependencyDefinition = Public.Price.Get(dependency)
				
				if dependencyDefinition then
					if dependencyDefinition.modelType == "simple" then
						simple[dependency] = dependencyDefinition
					
					elseif dependencyDefinition.modelType == "statistical" then
						stat[dependency] = dependencyDefinition
					
					elseif dependencyDefinition.modelType == "complex" then
						external[dependency] = dependencyDefinition
					
					elseif dependencyDefinition.modelType == "composite" then
						continueExpansion = continueExpansion or not composite[dependency]
						composite[dependency] = dependencyDefinition
					end					
				end
			end
		end
	end
	
	-- 4. Get start time
	local startTime = Inspect.Time.Server()
	
	-- 5. Create task
	return blTasks.Task.Create(
		function(taskHandle)
			-- 5.1. Get auctions
			local auctions = LibPGC.Search.All(item):Result()
			
			-- 5.2. Extract active & priced auctions
			local activeAuctions = {}
			local pricedAuctions = {}
			
			for auctionID, auctionData in pairs(auctions) do
				if auctionData.active then
					activeAuctions[auctionID] = auctionData
				end
				
				if auctionData.buyoutPrice > 0 then
					pricedAuctions[auctionID] = auctionData
				end
			end
		
			-- 5.3. Get simple, statisticals and external prices
			local prices = {}
			do
				local priceTasks = {}
				
				-- 5.3.1. Simple prices
				for id, chainDefinition in pairs(simple) do
					local usage = chainDefinition.usage
					
					local simpleDefinition, simpleAddon = Public.Price.Fallback.Get(usage.id)
					local simpleParams = usage.extra
					
					if simpleDefinition then
						local SimpleExecute = simpleDefinition.execute
						priceTasks[id] = blTasks.Task.Create(function(taskHandle) return SimpleExecute(taskHandle, item, simpleParams) end, simpleAddon):Start()
					end
				end
				
				-- 5.3.2. Statistical prices
				for id, chainDefinition in pairs(stat) do
					local usage = chainDefinition.usage
					
					local statDefinition, statAddon = Public.Price.Stat.Get(usage.id)
					local statParams = usage.extra
					local statFilters = usage.filters
					statFilters = type(statFilters) == "table" and statFilters or {}
					
					if statDefinition then
						local StatExecute = statDefinition.execute
						
						priceTasks[id] = blTasks.Task.Create(
							function(taskHandle)
								local filteredAuctions = pricedAuctions
								
								for i = 1, #statFilters do
									local filter = statFilters[i]
									
									local filterDefinition, filterAddon = Public.Price.Sampler.Get(filter.id)
									local filterParams = filter.extra
									assert(filterDefinition, "Filter `" .. filter.id .. "' unavailable.")
									
									local FilterExecute = filterDefinition.execute
									filteredAuctions = blTasks.Task.Create(function(taskHandle) return FilterExecute(taskHandle, filteredAuctions, startTime, filterParams) end, filterAddon):Result()
								end
								
								return StatExecute(taskHandle, filteredAuctions, statParams)
								
							end, statAddon):Start()
					end
				end
				
				-- 5.3.4. External prices
				for id, chainDefinition in pairs(external) do
					local usage = chainDefinition.usage
					
					local externalDefinition, externalAddon = Public.Price.External.Get(usage.id)
					
					if externalDefinition then
						local ExternalExecute = externalDefinition.execute
						priceTasks[id] = blTasks.Task.Create(function(taskHandle) return ExternalExecute(taskHandle, item, auctions, startTime) end, externalAddon):Start()
					end
				end
				
				-- 5.3.5. Collect tasks results
				for priceID, priceTask in pairs(priceTasks) do
					local ok, bid, buy = pcall(priceTask.Result, priceTask)
					if ok then
						if buy then
							prices[priceID] = { bid = bid, buy = buy, }
						elseif bid then
							prices[priceID] = { bid = math.max(math.floor(bid * bidPercentage), 1), buy = bid, }
						end
					end
					priceTasks[priceID] = nil
				end
			end
			
			-- 5.4. Calculate composite prices
			local continueCalculation = next(composite) and true
			while continueCalculation do
				continueCalculation = false
				
				for id, chainDefinition in pairs(composite) do
					if not prices[id] then
						local failed = false
						local totalBid, totalBuy, totalWeight = 0, 0, 0
						
						for dependency, weight in pairs(chainDefinition.usage) do
							local dependencyPrices = prices[dependency]
							if not dependencyPrices then
								failed = true
								break
							else
								totalBid = totalBid + dependencyPrices.bid * weight
								totalBuy = totalBuy + dependencyPrices.buy * weight
								totalWeight = totalWeight + weight
							end
						end
						
						if not failed and totalWeight > 0 then
							prices[id] =
							{
								bid = math.max(1, math.floor(totalBid / totalWeight)),
								buy = math.max(1, math.floor(totalBuy / totalWeight)),
							}
							continueCalculation = true
						end
					end
				end
			end
			
			-- 5.5. Discard prices added during composite expansion
			local realPrices = {}
			for id in pairs(chains) do
				realPrices[id] = prices[id]
			end
			
			-- 5.6. Price matching
			if not dontMatch then
				local matcherTasks = {}
				
				for id, price in pairs(realPrices) do
					local definition = simple[id] or stat[id] or external[id] or composite[id]
					local matchers = definition.matchers
					
					matcherTasks[id] = blTasks.Task.Create(
						function(taskHandle)
							local adjustedBid, adjustedBuy = price.bid, price.buy

							
							for i = 1, #matchers do
								local matcher = matchers[i]
								
								local matcherDefinition, matcherAddon = Public.Price.Matcher.Get(matcher.id)
								local matcherParams = matcher.extra
								assert(matcherDefinition, "Matcher `" .. matcher.id .. "' unavailable.")
									
								local MatcherExecute = matcherDefinition.execute
								adjustedBid, adjustedBuy = blTasks.Task.Create(function(taskHandle) return MatcherExecute(taskHandle, item, price.bid, price.buy, adjustedBid, adjustedBuy, activeAuctions, matcherParams) end, matcherAddon):Result()
								
								if adjustedBuy then
									adjustedBuy = adjustedBuy
									adjustedBid = math.min(adjustedBid, adjustedBuy)
								elseif adjustedBid then
									adjustedBuy = adjustedBid
									adjustedBid = math.max(1, math.floor(adjustedBid * bidPercentage))
								end
							end
								
							return adjustedBid, adjustedBuy
						end):Start()
				end
				
				taskHandle:Wait(blTasks.Wait.Children())
				
				for id, price in pairs(realPrices) do
					local adjustedBid, adjustedBuy = price.bid, price.buy
					
					local matcherTask = matcherTasks[id]
					if matcherTask then
						local ok, bid, buy = pcall(matcherTask.Result, matcherTask)
						if ok then
							adjustedBid = bid
							adjustedBuy = buy
						end
					end
					
					price.adjustedBid = adjustedBid
					price.adjustedBuy = adjustedBuy
				end
			end
				
			return realPrices
			
		end, addonID):Start()
end
