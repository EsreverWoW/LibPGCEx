local _, InternalInterface = ...

InternalInterface.Localization.RegisterLocale("English",--@do-not-package@
{
	-- Searchers
	["Searchers/BasicName"] = "Basic",
	["Searchers/BasicCalling"] = "Calling",
	["Searchers/BasicRarity"] = "Rarity",
	["Searchers/BasicLevelMin"] = "Min. level",
	["Searchers/BasicLevelMax"] = "Max. level",
	["Searchers/BasicCategory"] = "Category",
	["Searchers/BasicPriceMin"] = "Min. price",
	["Searchers/BasicPriceMax"] = "Max. price",
	
	["Searchers/VendorName"] = "Vendor",
	["Searchers/VendorUseBuy"] = "Use buy price",
	["Searchers/VendorUseBid"] = "Use bid price",
	["Searchers/VendorBidDuration"] = "Max. hours left",
	["Searchers/VendorMinProfit"] = "Min. profit",
	["Searchers/VendorBidProfit"] = "Bid profit",
	["Searchers/VendorBuyProfit"] = "Buyout profit",
	
	["Searchers/ExtendedName"] = "Extended",
	["Searchers/ExtendedCalling"] = "Calling",
	["Searchers/ExtendedRarity"] = "Rarity",
	["Searchers/ExtendedLevelMin"] = "Min. level",
	["Searchers/ExtendedLevelMax"] = "Max. level",
	["Searchers/ExtendedCategory"] = "Category",
	["Searchers/ExtendedBidMin"] = "Min. unit bid",
	["Searchers/ExtendedBidMax"] = "Max. unit bid",
	["Searchers/ExtendedBuyMin"] = "Min. unit buyout",
	["Searchers/ExtendedBuyMax"] = "Max. unit buyout",
	["Searchers/ExtendedTimeLeft"] = "Max. hours left",
	["Searchers/ExtendedSeller"] = "Seller",
	
	["Searchers/ResellName"] = "Resell",
	["Searchers/ResellUseBuy"] = "Use buy price",
	["Searchers/ResellUseBid"] = "Use bid price",
	["Searchers/ResellBidDuration"] = "Max. hours left",
	["Searchers/ResellModel"] = "Reference price",
	["Searchers/ResellMinDiscount"] = "Min. discount",
	["Searchers/ResellMinProfit"] = "Min. profit",
	["Searchers/ResellCategory"] = "Category",
	["Searchers/ResellBidProfit"] = "Bid profit",
	["Searchers/ResellBuyProfit"] = "Buyout profit",

	-- Fallbacks
	["Fallbacks/VendorName"] = "Vendor",
	["Fallbacks/VendorBidMultiplier"] = "Bid multiplier",
	["Fallbacks/VendorBuyMultiplier"] = "Buyout multiplier",
	
	["Fallbacks/FixedName"] = "Fixed",
	["Fallbacks/FixedBidPrice"] = "Bid price",
	["Fallbacks/FixedBuyPrice"] = "Buyout price",
	
	-- Samplers
	["Samplers/TimeName"] = "Time",
	["Samplers/TimeDays"] = "Number of days",
	["Samplers/TimeMinSample"] = "Min. sample size",
	
	["Samplers/StdevName"] = "Standard Deviation",
	["Samplers/StdevWeighted"] = "Weight auctions by stack size",
	["Samplers/StdevLowDeviation"] = "Max. deviation below average price (tenths of the standard deviation)",
	["Samplers/StdevHighDeviation"] = "Max. deviation above average price (tenths of the standard deviation)",
	
	["Samplers/PtrimName"] = "Relative Trim",
	["Samplers/PtrimWeighted"] = "Weight auctions by stack size",
	["Samplers/PtrimLowTrim"] = "Discard cheapest prices (percentage)",
	["Samplers/PtrimHighTrim"] = "Discard most expensive prices (percentage)",
	
	-- Stats
	["Stats/AvgName"] = "Average",
	["Stats/AvgWeighted"] = "Weight auctions by stack size",
	
	["Stats/RposName"] = "Relative Position",
	["Stats/RposWeighted"] = "Weight auctions by stack size",
	["Stats/RposPosition"] = "Position (percentage)",
	
	-- Matchers
	["Matchers/SelfundercutName"] = "Competition matcher",
	["Matchers/SelfundercutSelfRange"] = "Match own auctions within range (percentage)",
	["Matchers/SelfundercutUndercutRange"] = "Undercut auctions within range (percentage)",
	["Matchers/SelfundercutUndercutRelative"] = "Amount to decrease price per unit when undercutting (percentage)",
	["Matchers/SelfundercutUndercutAbsolute"] = "Amount to decrease price per unit when undercutting (absolute)",
	["Matchers/SelfundercutNoCompetitionRelative"] = "Amount to increase price per unit when there is no competition (percentage)",
	["Matchers/SelfundercutNoCompetitionAbsolute"] = "Amount to increase price per unit when there is no competition (absolute)",
	
	["Matchers/MinprofitName"] = "Minimum profit",
	["Matchers/MinprofitMinProfit"] = "Minimum profit per unit against vendoring the item",	
}--@end-do-not-package@
--@localization(locale="enUS", format="lua_table", handle-subnamespaces="concat", namespace-delimiter="/")@
)
