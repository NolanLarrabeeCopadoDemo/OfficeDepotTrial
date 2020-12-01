({
    isPublicSectorCompany : function(component, event, helper) {
        var radioSelected = event.getSource().get('v.value');
        console.log('radioSelected...'+radioSelected);
        if(radioSelected){
            //component.set("v.contactRec.Sector__c",'Public');
        }else{
            //component.set("v.contactRec.Sector__c",'Private');
        }
        var changeElement = component.find("sectorNSegmentDivId");
        $A.util.toggleClass(changeElement, "slds-hide");	
    }
})