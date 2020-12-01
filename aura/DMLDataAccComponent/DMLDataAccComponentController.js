({  

    doAction : function(cmp, event,helper) { 
        cmp.set('v.CustomerColumns', [
            
            {label: 'Account Name', fieldName: 'Name', type: 'text'},
            {label: 'AOPS#', fieldName: 'AOPS_Cust_Id__c', type: 'text'}
          
            
            
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