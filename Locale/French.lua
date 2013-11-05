local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

Internal.Localization.Register("French",--@do-not-package@
{
}--@end-do-not-package@
--@localization(locale="frFR", format="lua_table", handle-subnamespaces="concat", namespace-delimiter="/")@
)
