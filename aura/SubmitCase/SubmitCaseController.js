({    
    doInit : function(component, event, helper) {
        helper.doInitHelper(component,event);
        helper.fetchPickListVal(component, 'PC_Priority__c', 'v.listPC_Priority');
        helper.fetchPickListVal(component, 'IT_Classification__c', 'v.listIT_Classification');
        helper.fetchPickListVal(component, 'Department__c', 'v.listDepartment');
    },
    savepartnercase : function(component, event, helper) {
        helper.submitcasehelperMethod(component,event);
    },
})