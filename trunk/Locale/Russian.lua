local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

Internal.Localization.Register("Russian",--@do-not-package@
{
}--@end-do-not-package@
--@localization(locale="ruRU", format="lua_table", handle-subnamespaces="concat", namespace-delimiter="/")@
)
