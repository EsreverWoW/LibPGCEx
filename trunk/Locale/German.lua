local addonDetail, addonData = ...
local addonID = addonDetail.identifier
local Internal, Public = addonData.Internal, addonData.Public

Internal.Localization.Register("German",--@do-not-package@
{
}--@end-do-not-package@
--@localization(locale="deDE", format="lua_table", handle-subnamespaces="concat", namespace-delimiter="/")@
)
