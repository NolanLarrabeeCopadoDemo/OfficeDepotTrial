<aura:application extends="force:slds" implements="lightning:isUrlAddressable" access="GLOBAL">
<!--<aura:dependency resource="c:crossMatchResults" />-->
<!--<aura:dependency resource="markup://force:*" type="EVENT"/>-->
    <aura:attribute name="reference_id" type="String" />
    <aura:attribute name="FileName" type="String" />
    <aura:handler name="init" value="{!this}" action="{!c.init}" />
    
    <c:crossMatchResults refID="{!v.reference_id}" fileName="{!v.FileName}"/>
</aura:application>