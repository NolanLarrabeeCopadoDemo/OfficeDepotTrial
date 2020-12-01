<aura:application extends="force:slds"  access="GLOBAL">
    <aura:attribute name="recordId" type="Id"/>
    <aura:attribute name="recordShow" type="Boolean"/>
    <aura:attribute name="recId" type="Id"/>
    <aura:handler name="init" value="{!this}" action="{!c.doInit}" />
    <aura:if isTrue="{!v.recordShow}">
         <c:customerTabs recId="{!v.recordId}"></c:customerTabs>
  </aura:if>
    </aura:application>