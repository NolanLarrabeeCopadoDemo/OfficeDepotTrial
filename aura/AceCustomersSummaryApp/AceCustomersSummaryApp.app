<aura:application access="GLOBAL" extends="force:slds" implements="ltng:allowGuestAccess">
    <div class="slds-p-around_medium">
        <c:aceCustomersSummary />
    </div>
    <aura:handler name="init" value="{!this}" action="{!c.init}" />
</aura:application>