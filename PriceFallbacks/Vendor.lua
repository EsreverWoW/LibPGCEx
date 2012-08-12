-- ***************************************************************************************************************************************************
-- * PricingModels/Vendor.lua                                                                                                                        *
-- ***************************************************************************************************************************************************
-- * Vendor price fallback                                                                                                                           *
-- ***************************************************************************************************************************************************
-- * 0.4.1 / 2012.07.24 / Baanano: Rewritten for LibPGCEx                                                                                            *
-- * 0.4.0 / 2012.06.17 / Baanano: Rewritten for 1.9                                                                                                 *
-- ***************************************************************************************************************************************************

local addonInfo, InternalInterface = ...
local addonID = addonInfo.identifier
_G[addonID] = _G[addonID] or {}
local PublicInterface = _G[addonID]

local L = InternalInterface.Localization.L

local IIDetail = Inspect.Item.Detail
local MFloor = math.floor
local MMin = math.min
local pcall = pcall

local ID = "vendor"
local NAME = L["Fallbacks/VendorName"]
local DEFAULT_SELL_PRICE = 1
local DEFAULT_BID_MULTIPLIER = 3
local DEFAULT_BUY_MULTIPLIER = 5
local MAX_MULTIPLIER = 100

local extraDescription =
{
	bidMultiplier =
	{
		name = L["Fallbacks/VendorBidMultiplier"],
		value = "integer",
		minValue = 1,
		maxValue = MAX_MULTIPLIER,
		defaultValue = DEFAULT_BID_MULTIPLIER,
	},
	buyMultiplier =
	{
		name = L["Fallbacks/VendorBuyMultiplier"],
		value = "integer",
		minValue = 1,
		maxValue = MAX_MULTIPLIER,
		defaultValue = DEFAULT_BUY_MULTIPLIER,
	},
	extraOrder = { "bidMultiplier", "buyMultiplier", }
}

local function PriceFunction(item, extra)
	local ok, itemDetail = pcall(IIDetail, item)
	
	local bidMultiplier = extra and extra.bidMultiplier or DEFAULT_BID_MULTIPLIER
	local buyMultiplier = extra and extra.buyMultiplier or DEFAULT_BUY_MULTIPLIER
	local sellPrice = ok and itemDetail and itemDetail.sell or DEFAULT_SELL_PRICE
	
	local bid = MFloor(sellPrice * bidMultiplier)
	local buy = MFloor(sellPrice * buyMultiplier)
	bid = MMin(bid, buy)
	
	return bid, buy
end

PublicInterface.RegisterPriceFallback(ID, NAME, PriceFunction, extraDescription)

--[[
local function FrameConstructor(name, parent)
	local configFrame = UICreateFrame("Frame", name, parent)
	
	local bidMultiplierText = UICreateFrame("Text", configFrame:GetName() .. ".BidMultiplierText", configFrame)
	local buyMultiplierText = UICreateFrame("Text", configFrame:GetName() .. ".BuyMultiplierText", configFrame)
	local bidMultiplierSlider = UICreateFrame("BSlider", configFrame:GetName() .. ".BidMultiplierSlider", configFrame)
	local buyMultiplierSlider = UICreateFrame("BSlider", configFrame:GetName() .. ".BuyMultiplierSlider", configFrame)

	bidMultiplierText:SetPoint("CENTERLEFT", configFrame, 0, 1/3, 10, 0)
	bidMultiplierText:SetFontSize(14)
	bidMultiplierText:SetText(L["Fallbacks/VendorBidMultiplier"])
	
	buyMultiplierText:SetPoint("CENTERLEFT", configFrame, 0, 2/3, 10, 0)
	buyMultiplierText:SetFontSize(14)
	buyMultiplierText:SetText(L["Fallbacks/VendorBuyMultiplier"])

	local offset = MMax(bidMultiplierText:GetWidth(), buyMultiplierText:GetWidth()) + 20
	
	bidMultiplierSlider:SetPoint("CENTERLEFT", configFrame, 0, 1/3, offset, 0)
	bidMultiplierSlider:SetPoint("CENTERRIGHT", configFrame, 1, 1/3, -10, 0)
	bidMultiplierSlider:SetRange(1, MAX_MULTIPLIER)
	bidMultiplierSlider:SetPosition(DEFAULT_BID_MULTIPLIER)

	buyMultiplierSlider:SetPoint("CENTERLEFT", configFrame, 0, 2/3, offset, 0)
	buyMultiplierSlider:SetPoint("CENTERRIGHT", configFrame, 1, 2/3, -10, 0)
	buyMultiplierSlider:SetRange(1, MAX_MULTIPLIER)
	buyMultiplierSlider:SetPosition(DEFAULT_BUY_MULTIPLIER)

	local function GetExtra()
		return
		{
			bidMultiplier = bidMultiplierSlider:GetPosition(),
			buyMultiplier = buyMultiplierSlider:GetPosition(),
		}
	end
	
	local function SetExtra(extra)
		bidMultiplierSlider:SetPosition(extra and extra.bidMultiplier or DEFAULT_BID_MULTIPLIER)
		buyMultiplierSlider:SetPosition(extra and extra.buyMultiplier or DEFAULT_BUY_MULTIPLIER)
	end
	
	return configFrame, PREFERRED_FRAME_HEIGHT, GetExtra, SetExtra
end
]]