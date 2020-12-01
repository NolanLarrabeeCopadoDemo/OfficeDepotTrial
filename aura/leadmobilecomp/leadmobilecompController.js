({
    init: function(cmp, event, helper) {
        helper.fetchPickListVal(cmp, cmp.get("v.leadObj"), 'State__c', 'v.usStatePicklist');
    },
    
    closeModel: function(cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/"
        });
        
        urlEvent.fire();
    },
    
    clickSave: function(cmp, event, helper) {
        if (helper.isInputDataValid(cmp, event)) {
            helper.saveLeadDeal(cmp, event, helper);      
        }
    }
})