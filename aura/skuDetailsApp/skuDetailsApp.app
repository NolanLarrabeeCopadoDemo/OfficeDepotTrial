<aura:application access="GLOBAL" extends="ltng:outApp" implements="ltng:allowGuestAccess"> 
    <aura:attribute name="sku" type="String"/>
    Sku : {!v.sku}
    <c:skuDetails sku_num="{!v.sku}"/>
</aura:application>