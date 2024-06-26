﻿local _, InternalInterface = ...

InternalInterface.Localization.RegisterLocale("French",
{
	["Fallbacks/FixedBidPrice"] = "Prix d'enchère", -- Needs review
	["Fallbacks/FixedBuyPrice"] = "Prix de vente", -- Needs review
	["Fallbacks/FixedName"] = "figé", -- Needs review
	["Fallbacks/VendorBidMultiplier"] = "Multiple d'enchère", -- Needs review
	["Fallbacks/VendorBuyMultiplier"] = "Multiple d'achat", -- Needs review
	["Fallbacks/VendorName"] = "Vendeur", -- Needs review
	["Matchers/MinprofitMinProfit"] = "Profit minimal par unité contre vente de l'item", -- Needs review
	["Matchers/MinprofitName"] = "Profit minimal", -- Needs review
	["Matchers/SelfundercutName"] = "Ajustage sur concurrence", -- Needs review
	["Matchers/SelfundercutNoCompetitionAbsolute"] = "Quantité d'accroissement du prix unitaire sans concurrence ( absolue )", -- Needs review
	["Matchers/SelfundercutNoCompetitionRelative"] = "Augmentation du prix unitaire sans concurrence ( pourcentage )", -- Needs review
	["Matchers/SelfundercutSelfRange"] = "ajuster enchères dans la fourchette définie ( pourcentage )", -- Needs review
	["Matchers/SelfundercutUndercutAbsolute"] = "Diminution du prix unitaire sans concurrence ( abolsue )", -- Needs review
	["Matchers/SelfundercutUndercutRange"] = "Diminution prix des enchères dans la fourchette ( pourcentage )", -- Needs review
	["Matchers/SelfundercutUndercutRelative"] = "Montant de diminution du prix unitaire quand prix plus bas ( pourcentage )", -- Needs review
	["Samplers/PtrimHighTrim"] = "Nettoyer les prix les plus onéreux ( pourcentage )", -- Needs review
	["Samplers/PtrimLowTrim"] = "Nettoyer les prix très bas ( pourcentage )", -- Needs review
	["Samplers/PtrimName"] = "Nettoyage relatif", -- Needs review
	["Samplers/PtrimWeighted"] = "Poids d'enchères par taille de pile", -- Needs review
	["Samplers/StdevHighDeviation"] = "Ecart maxi. au dessus du prix moyen ( en dixièmes de l'écart standard )", -- Needs review
	["Samplers/StdevLowDeviation"] = "Ecart maxi.sous le prix moyen ( en dixièmes de l'écart standard )", -- Needs review
	["Samplers/StdevName"] = "Ecart standart", -- Needs review
	["Samplers/StdevWeighted"] = "Poids d'enchères par taille de pile", -- Needs review
	["Samplers/TimeDays"] = "Nombre de jours", -- Needs review
	["Samplers/TimeMinSample"] = "Taille d'échantillon mini.", -- Needs review
	["Samplers/TimeName"] = "Temps", -- Needs review
	["Searchers/BasicCalling"] = "Appel", -- Needs review
	["Searchers/BasicCategory"] = "Catégorie", -- Needs review
	["Searchers/BasicLevelMax"] = "Niveau maxi", -- Needs review
	["Searchers/BasicLevelMin"] = "Niveau mini", -- Needs review
	["Searchers/BasicName"] = "Basique", -- Needs review
	["Searchers/BasicPriceMax"] = "Prix maxi.", -- Needs review
	["Searchers/BasicPriceMin"] = "Prix mini.", -- Needs review
	["Searchers/BasicRarity"] = "Rareté", -- Needs review
	["Searchers/ExtendedBidMax"] = "Enchère maxi. sur prix unitaire", -- Needs review
	["Searchers/ExtendedBidMin"] = "Enchère mini. sur prix unitaire", -- Needs review
	["Searchers/ExtendedBuyMax"] = "Prix d'achat unitaire Maxi.", -- Needs review
	["Searchers/ExtendedBuyMin"] = "Prix d'achat unitaire mini.", -- Needs review
	["Searchers/ExtendedCalling"] = "Appeler", -- Needs review
	["Searchers/ExtendedCategory"] = "Catégorie", -- Needs review
	["Searchers/ExtendedLevelMax"] = "Niveau Maxi.", -- Needs review
	["Searchers/ExtendedLevelMin"] = "Niveau Mini.", -- Needs review
	["Searchers/ExtendedName"] = "Etendu", -- Needs review
	["Searchers/ExtendedRarity"] = "Rareté", -- Needs review
	["Searchers/ExtendedSeller"] = "Vendeur", -- Needs review
	["Searchers/ExtendedTimeLeft"] = "Heures restantes maxi.", -- Needs review
	["Searchers/ResellBidDuration"] = "Temps d'enchère maxi.", -- Needs review
	["Searchers/ResellBidProfit"] = "Profit d'enchère", -- Needs review
	["Searchers/ResellBuyProfit"] = "Profit de vente", -- Needs review
	["Searchers/ResellCategory"] = "Catégorie", -- Needs review
	["Searchers/ResellMinDiscount"] = "Ristourne mini.", -- Needs review
	["Searchers/ResellMinProfit"] = "Profit mini.", -- Needs review
	["Searchers/ResellModel"] = "Prix de référence", -- Needs review
	["Searchers/ResellName"] = "Revente", -- Needs review
	["Searchers/ResellUseBid"] = "Prix de vente utilisateur", -- Needs review
	["Searchers/ResellUseBuy"] = "Prix de vente utilisateur", -- Needs review
	["Searchers/VendorBidDuration"] = "Temps restant maxi.", -- Needs review
	["Searchers/VendorBidProfit"] = "Profit d'enchère", -- Needs review
	["Searchers/VendorBuyProfit"] = "Profit de vente", -- Needs review
	["Searchers/VendorMinProfit"] = "Profit mini.", -- Needs review
	["Searchers/VendorName"] = "Vendeur", -- Needs review
	["Searchers/VendorUseBid"] = "Prix d'enchère utilisateur", -- Needs review
	["Searchers/VendorUseBuy"] = "Prix de vente utilisateur", -- Needs review
	["Stats/AvgName"] = "moyen", -- Needs review
	["Stats/AvgWeighted"] = "Prix d'enchère moyen par taille de pile", -- Needs review
	["Stats/RposName"] = "Position relative", -- Needs review
	["Stats/RposPosition"] = "Position ( pourcent )", -- Needs review
	["Stats/RposWeighted"] = "Position d'enchères par taille de pile", -- Needs review
}

)
