({  

    doAction : function(cmp, event,helper) { 
        
         cmp.set('v.contractColumns', [
            {label: 'Contract Number', fieldName: 'ContractNumber', type: 'text'},
            {label: 'Customer ID', fieldName: 'Customer_Number__c', type: 'text'},
            {label: 'Customer Name', fieldName: 'Customer_Name__c', type: 'text'},
            {label: 'Account Type', fieldName: 'Account_Recordtype__c', type:'text'},
            {label: 'Contract Type', fieldName: 'Contract_Type__c', type: 'text'},
            {label: 'Contract Status', fieldName: 'Contract_Status__c', type: 'text'},
            {label: 'Contract Lifecycle Manager', fieldName: 'Contract_Lifecycle_Manager__c', type: 'text'},
            {label: 'Date Current Legal Contract Expires', fieldName: 'Date_current_Legal_Contract_expires__c', type: 'date',typeAttributes: {
                   year: 'numeric',
                   month: 'numeric',
                day: 'numeric'}}
            
        ]); 
            helper.loadContractData(cmp,event);

        
    },
    showContract : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showContractInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    }
    
    
})