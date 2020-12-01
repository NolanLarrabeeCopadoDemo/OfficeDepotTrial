({  

    doAction : function(cmp, event,helper) { 
        
        cmp.set('v.siteColumns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Cust ID', fieldName: 'Cust_ID__c', type: 'text'},
            {label: 'Primary Site', fieldName: 'Primary_Site__c', type: 'boolean'},
            {label: 'Status', fieldName: 'Status__c', type: 'text'},
            {label: 'Address - Full', fieldName: 'Address__c', type: 'text'},
             {label: 'YTD Sales TY', fieldName: 'YTD_Sales_TY__c', type: 'text'},
            {label: 'YTD Sales Diff', fieldName: 'YTD_Sales_Diff__c', type: 'text'},
            {label: 'Weeks Since Last Order', fieldName: 'Weeks_Since_Last_Order__c', type: 'text'},
            {label: 'Owner Alias', fieldName: 'OwnerAlias', type: 'text'},
            {label: 'LastActivity', fieldName: 'LastModifiedDate', type: 'date', typeAttributes: {
                    year: 'numeric',
                    month: '2-digit',
                 day: '2-digit'}}
           
        ]);
            helper.loadSiteData(cmp,event);

        
    },
    showSites : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showSiteInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    }
    
    
})