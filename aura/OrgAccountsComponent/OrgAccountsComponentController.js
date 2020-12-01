({  

    doAction : function(cmp, event,helper) { 
        cmp.set('v.CustomerColumns', [
            
            {label: 'Customer', fieldName: 'AOPS_Cust_Id__c', type: 'text'},
            {label: 'Parent', fieldName: 'Parent_ID__c', type: 'text'},
            {label: 'Grand Parent', fieldName: 'Grandparent_ID__c', type: 'text'},
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Account Owner', fieldName: 'Account_Owner_Name__c', type: 'text'}
            
            
        ]);
            helper.loadCustomerData(cmp,event);

        
    },
    showCustomer : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showCustomerInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    }
    
    
})