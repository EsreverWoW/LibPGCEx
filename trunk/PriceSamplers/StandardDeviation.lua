-- ***************************************************************************************************************************************************
-- * PriceSamplers/StandardDeviation.lua                                                                                                             *
-- ***************************************************************************************************************************************************
-- * Standard Deviation price sampler                                                                                                                *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.24 / Baanano: First version                                                                                                     *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
_G[addonID] = _G[addonID] or {}
local PublicInterface = _G[addonID]

local L = InternalInterface.Localization.L

local pairs = pairs

local ID = "stdev"
local NAME = L["Samplers/StdevName"]
local DEFAULT_WEIGHTED = true
local DEFAULT_LOW_DEVIATION = 15
local DEFAULT_HIGH_DEVIATION = 15
local MAX_DEVIATION = 100

local extraDescription =
{
	weighted =
	{
		name = L["Samplers/StdevWeighted"],
		value = "boolean",
		defaultValue = DEFAULT_WEIGHTED,
	},
	lowDeviation =
	{
		name = L["Samplers/StdevLowDeviation"],
		value = "integer",
		minValue = 0,
		maxValue = MAX_DEVIATION,
		defaultValue = DEFAULT_LOW_DEVIATION,
	},
	highDeviation =
	{
		name = L["Samplers/StdevHighDeviation"],
		value = "integer",
		minValue = 0,
		maxValue = MAX_DEVIATION,
		defaultValue = DEFAULT_HIGH_DEVIATION,
	},
	extraOrder = { "weighted", "lowDeviation", "highDeviation", }
}

local function SampleFunction(auctions, startTime, extra)
	local weighted = extra and extra.weighted
	if weighted == nil then weighted = DEFAULT_WEIGHTED end
	local lowDeviation = (extra and extra.lowDeviation or DEFAULT_LOW_DEVIATION) / 10
	local highDeviation = (extra and extra.highDeviation or DEFAULT_HIGH_DEVIATION) / 10

	local totalWeight, average, squaredDeltaSum = 0, 0, 0
		
	for auctionID, auctionData in pairs(auctions) do
		local buy = auctionData.buyoutUnitPrice
		local weight = weighted and auctionData.stack or 1
		
		local prevAverage = average
		totalWeight = totalWeight + weight
		average = average + weight * (buy - average) / totalWeight
		squaredDeltaSum = squaredDeltaSum + weight * (buy - prevAverage) * (buy - average)
	end
	
	local squaredLow, squaredHigh = squaredDeltaSum * lowDeviation * lowDeviation / totalWeight, squaredDeltaSum * highDeviation * highDeviation / totalWeight

	local filteredAuctions = {}
	for auctionID, auctionData in pairs(auctions) do
		local buy = auctionData.buyoutUnitPrice
		local squaredDeviation = (buy - average) * (buy - average)
		
		if (buy <= average and squaredDeviation <= squaredLow) or (buy > average and squaredDeviation <= squaredHigh) then
			filteredAuctions[auctionID] = auctionData
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
	local lowDeviationText = UICreateFrame("Text", configFrame:GetName() .. ".LowDeviationText", configFrame)
	local highDeviationText = UICreateFrame("Text", configFrame:GetName() .. ".HighDeviationText", configFrame)
	local lowDeviationSlider = UICreateFrame("BSlider", configFrame:GetName() .. ".LowDeviationSlider", configFrame)
	local highDeviationSlider = UICreateFrame("BSlider", configFrame:GetName() .. ".HighDeviationSlider", configFrame)

	weightedCheck:SetPoint("CENTERLEFT", configFrame, 0, 1/4, 10, 0)
	weightedCheck:SetChecked(DEFAULT_WEIGHTED == 1 and true or false)
	
	weightedText:SetPoint("CENTERLEFT", weightedCheck, "CENTERRIGHT", 10, 0)
	weightedText:SetFontSize(14)
	weightedText:SetText(L["Samplers/StdevWeighted"])
	
	lowDeviationText:SetPoint("CENTERLEFT", configFrame, 0, 2/4, 10, 0)
	lowDeviationText:SetFontSize(14)
	lowDeviationText:SetText(L["Samplers/StdevLowDeviation"])
	
	highDeviationText:SetPoint("CENTERLEFT", configFrame, 0, 3/4, 10, 0)
	highDeviationText:SetFontSize(14)
	highDeviationText:SetText(L["Samplers/StdevHighDeviation"])

	local offset = MMax(lowDeviationText:GetWidth(), highDeviationText:GetWidth()) + 20
	
	lowDeviationSlider:SetPoint("CENTERLEFT", configFrame, 0, 2/4, offset, 0)
	lowDeviationSlider:SetPoint("CENTERRIGHT", configFrame, 1, 2/4, -10, 0)
	lowDeviationSlider:SetRange(1, MAX_DEVIATION)
	lowDeviationSlider:SetPosition(DEFAULT_LOW_DEVIATION)

	highDeviationSlider:SetPoint("CENTERLEFT", configFrame, 0, 3/4, offset, 0)
	highDeviationSlider:SetPoint("CENTERRIGHT", configFrame, 1, 3/4, -10, 0)
	highDeviationSlider:SetRange(1, MAX_DEVIATION)
	highDeviationSlider:SetPosition(DEFAULT_HIGH_DEVIATION)

	local function GetExtra()
		return
		{
			weighted = weightedCheck:GetChecked() and 1 or 0,
			lowDeviation = lowDeviationSlider:GetPosition(),
			highDeviation = highDeviationSlider:GetPosition(),
		}
	end
	
	local function SetExtra(extra)
		weightedCheck:SetChecked((extra and extra.weighted or DEFAULT_WEIGHTED) == 1 and true or false)
		lowDeviationSlider:SetPosition(extra and extra.lowDeviation or DEFAULT_LOW_DEVIATION)
		highDeviationSlider:SetPosition(extra and extra.highDeviation or DEFAULT_HIGH_DEVIATION)
	end
	
	return configFrame, PREFERRED_FRAME_HEIGHT, GetExtra, SetExtra
end
]]
