({
    init: function(cmp, event, helper) {
        helper.fetchPickListVal(cmp, cmp.get("v.leadObj"), 'State__c', 'v.usStatePicklist');
    },
    //Added condition for lead deal mobile page by Faraz.//
    openModel: function(cmp, event, helper) 
    {
        var device = $A.get("$Browser.formFactor");       
        if(device == 'DESKTOP'){
            cmp.set("v.isOpenDesk", true);
        }else{
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/lead-mobile"
            });
            
            urlEvent.fire();
        }
    },

    
    handleBlur: function(component, event, helper){
        var phoneNumber = component.find("phoneid").get("v.value");
        var x = phoneNumber;
        var ph =  myUtil.phoneFormat(x);
        component.find("phoneid").set("v.value", ph);
    },
    
    closeModel: function(cmp, event, helper) {
        cmp.set("v.isOpenDesk", false);
        location.reload();
    },
    
    clickSave: function(cmp, event, helper) {
        var isValid = true;
        var allValid = cmp.find('stateId').reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        
        if(!helper.validateEmail(cmp, event)) {
            isValid  = false;
        }
         if (cmp.find("phoneid").reportValidity() == false) {
            isValid = false;
        }
        if (cmp.find("titleId").reportValidity() == false) {
            isValid = false;
        }
        if(!helper.validateServiceType(cmp, event)) {
            
            isValid  = false;
        }
       
        
        if (cmp.find("postalCode").reportValidity() == false) {
            isValid = false;
            
        }
        if (cmp.find("numOfEmployeesId").reportValidity() == false) {
            isValid = false;
        }
        
        if (allValid && isValid) {
            
            helper.saveLeadDeal(cmp, event, helper); 
        } else {
            
        }
    }
})