-- ***************************************************************************************************************************************************
-- * PriceSamplers/PercentileTrim.lua                                                                                                                *
-- ***************************************************************************************************************************************************
-- * Percentile Trim price sampler                                                                                                                    *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.24 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
_G[addonID] = _G[addonID] or {}
local PublicInterface = _G[addonID]

local L = InternalInterface.Localization.L

local MCeil = math.ceil
local MFloor = math.floor
local TInsert = table.insert
local TSort = table.sort
local pairs = pairs

local ID = "ptrim"
local NAME = L["Samplers/PtrimName"]
local DEFAULT_WEIGHTED = 1
local DEFAULT_LOW_TRIM = 25
local DEFAULT_HIGH_TRIM = 25

local extraDescription =
{
	weighted =
	{
		name = L["Samplers/PtrimWeighted"],
		value = "boolean",
		defaultValue = DEFAULT_WEIGHTED,
	},
	lowTrim =
	{
		name = L["Samplers/PtrimLowTrim"],
		value = "integer",
		minValue = 0,
		maxValue = 100,
		defaultValue = DEFAULT_LOW_TRIM,
	},
	highTrim =
	{
		name = L["Samplers/PtrimHighTrim"],
		value = "integer",
		minValue = 0,
		maxValue = 100,
		defaultValue = DEFAULT_HIGH_TRIM,
	},
	extraOrder = { "weighted", "lowTrim", "highTrim", }
}

local function SampleFunction(auctions, startTime, extra)
	local weighted = extra and extra.weighted
	if weighted == nil then weighted = DEFAULT_WEIGHTED end
	local lowTrim = extra and extra.lowTrim or DEFAULT_LOW_TRIM
	local highTrim = 100 - (extra and extra.highTrim or DEFAULT_HIGH_TRIM)
	
	if lowTrim > highTrim then return {} end

	local priceOrder = {}
		
	for auctionID, auctionData in pairs(auctions) do
		local buy = auctionData.buyoutUnitPrice
		local weight = weighted and auctionData.stack or 1
		
		for i = 1, weight do
			TInsert(priceOrder, auctionID)
		end
	end
	
	TSort(priceOrder, function(a, b) return auctions[b].buyoutUnitPrice < auctions[b].buyoutUnitPrice end)
	
	local firstIndex, lastIndex = MFloor(lowTrim * #priceOrder / 100) + 1, MCeil(highTrim * #priceOrder / 100)
	
	local filteredAuctions = {}
	
	for index = firstIndex, lastIndex do
		local auctionID = priceOrder[index]
		if auctionID and not filteredAuctions[auctionID] then
			filteredAuctions[auctionID] = auctions[auctionID]
		end
	end

	return filteredAuctions
end

PublicInterface.RegisterPriceSampler(ID, NAME, SampleFunction, extraDescription)

--[[
local function FrameConstructor(name, parent)
	local configFrame = UICreateFrame("Frame", name, parent)
	
	local weightedCheck = UICreateFrame("RiftCheckbox", configFrame:GetName() .. ".WeightedCheck", configFrame)
	local weightedText = UICreateFrame("Text", configFrame:GetName() .. ".WeightedText", configFrame)
	local lowTrimText = UICreateFrame("Text", configFrame:GetName() .. ".LowTrimText", configFrame)
	local highTrimText = UICreateFrame("Text", configFrame:GetName() .. ".HighTrimText", configFrame)
	local lowTrimSlider = UICreateFrame("BSlider", configFrame:GetName() .. ".LowTrimSlider", configFrame)
	local highTrimSlider = UICreateFrame("BSlider", configFrame:GetName() .. ".highTrimSlider", configFrame)

	weightedCheck:SetPoint("CENTERLEFT", configFrame, 0, 1/4, 10, 0)
	weightedCheck:SetChecked(DEFAULT_WEIGHTED == 1 and true or false)
	
	weightedText:SetPoint("CENTERLEFT", weightedCheck, "CENTERRIGHT", 10, 0)
	weightedText:SetFontSize(14)
	weightedText:SetText(L["Samplers/PtrimWeighted"])
	
	lowTrimText:SetPoint("CENTERLEFT", configFrame, 0, 2/4, 10, 0)
	lowTrimText:SetFontSize(14)
	lowTrimText:SetText(L["Samplers/PtrimLowTrim"])
	
	highTrimText:SetPoint("CENTERLEFT", configFrame, 0, 3/4, 10, 0)
	highTrimText:SetFontSize(14)
	highTrimText:SetText(L["Samplers/PtrimHighTrim"])

	local offset = MMax(lowTrimText:GetWidth(), highTrimText:GetWidth()) + 20
	
	lowTrimSlider:SetPoint("CENTERLEFT", configFrame, 0, 2/4, offset, 0)
	lowTrimSlider:SetPoint("CENTERRIGHT", configFrame, 1, 2/4, -10, 0)
	lowTrimSlider:SetRange(0, 99)
	lowTrimSlider:SetPosition(DEFAULT_LOW_TRIM)

	highTrimSlider:SetPoint("CENTERLEFT", configFrame, 0, 3/4, offset, 0)
	highTrimSlider:SetPoint("CENTERRIGHT", configFrame, 1, 3/4, -10, 0)
	highTrimSlider:SetRange(0, 99)
	highTrimSlider:SetPosition(DEFAULT_HIGH_TRIM)
	
	function lowTrimSlider.Event:PositionChanged()
		if lowTrimSlider:GetPosition() + highTrimSlider:GetPosition() > 99 then
			highTrimSlider:SetPosition(99 - lowTrimSlider:GetPosition())
		end
	end

	function highTrimSlider.Event:PositionChanged()
		if lowTrimSlider:GetPosition() + highTrimSlider:GetPosition() > 99 then
			lowTrimSlider:SetPosition(99 - highTrimSlider:GetPosition())
		end
	end

	local function GetExtra()
		return
		{
			weighted = weightedCheck:GetChecked() and 1 or 0,
			lowTrim = lowTrimSlider:GetPosition(),
			highTrim = highTrimSlider:GetPosition(),
		}
	end
	
	local function SetExtra(extra)
		weightedCheck:SetChecked((extra and extra.weighted or DEFAULT_WEIGHTED) == 1 and true or false)
		lowTrimSlider:SetPosition(extra and extra.lowTrim or DEFAULT_LOW_TRIM)
		highTrimSlider:SetPosition(extra and extra.highTrim or DEFAULT_HIGH_TRIM)
	end
	
	return configFrame, PREFERRED_FRAME_HEIGHT, GetExtra, SetExtra
end
]]
