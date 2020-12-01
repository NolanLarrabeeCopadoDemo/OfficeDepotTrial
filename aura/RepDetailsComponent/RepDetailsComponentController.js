({  

    doAction : function(cmp, event,helper) { 
        
        cmp.set('v.salesRepColumns', [
            {label: 'Name', fieldName: 'User_Name__c', type: 'text'},
            {label: 'ProfilePhoto', fieldName: 'SmallPhotoURL__c', type: 'text'},


            {label: 'Employee Id', fieldName: 'ODP_Employee_Id__c', type: 'text'}
        ]);
            helper.loadRepData(cmp,event);

        
    },
    showRep : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showRepInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    }
    
    
})