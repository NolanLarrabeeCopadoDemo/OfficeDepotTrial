({  

  doAction : function(cmp, event, helper) {
		helper.getAccountInfo(cmp,event);
          //var selectedRec = component.get('!v.acct.Org__c');        
        
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