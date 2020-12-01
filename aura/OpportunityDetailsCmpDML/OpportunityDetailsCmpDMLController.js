({  

    doAction : function(cmp, event,helper) { 
        
        cmp.set('v.oppColumns', [
            {label: 'Opp Name', fieldName: 'Name', type: 'text'},
            {label: 'Account Name', fieldName: 'LBI__LatticeAccountName__c', type: 'text'},
            {label: 'Stage', fieldName: 'StageName', type: 'text'},
            {label: 'Product', fieldName: 'Product__c', type: 'text'},
            {label: 'Opportunity Amount', fieldName: 'Opportunity_Amount__c', type: 'currency'},
            {label: 'IMU%', fieldName: 'IMU__c', type: 'currency'},
            {label: 'Close Date', fieldName: 'CloseDate', type: 'text'},
            {label: 'Next Step', fieldName: 'NextStep', type: 'text'},
            {label: 'Owner',fieldName: 'OwnerName', type: 'text'},
            {label: 'Last Modified Date', fieldName: 'LastModifiedDate', type: 'date', typeAttributes: {
                    year: 'numeric',
                    month: '2-digit',
                day: '2-digit'}}
            ]);
        
            helper.loadOpportunityData(cmp,event);

        
    },
    showOpp : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showOppInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    }
    
    
})