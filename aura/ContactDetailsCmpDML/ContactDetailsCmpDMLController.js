({  

    doAction : function(cmp, event,helper) { 
        
        cmp.set('v.contactColumns', [
            {label: 'Contact Name', fieldName: 'Name', type: 'text'}, 
            {label: 'Decision Maker', fieldName: 'Decision_Maker__c', type: 'text'},
            {label: 'Title', fieldName: 'Title', type: 'text'},
            {label: 'Primary', fieldName: 'Primary_Contact__c', type: 'boolean'},
            {label: 'Role', fieldName: 'Role__c', type: 'text'},
            {label: 'Phone 1', fieldName: 'Phone1_Rep__c', type: 'text'},
            {label: 'Phone 1 Type', fieldName: 'Phone_Type1__c', type: 'text'},
            {label: 'Email', fieldName: 'Email', type: 'email'}
        ]); 
        
            helper.loadContactData(cmp,event);

        
    },
    showContacts : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showContactsInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    }
    
    
})