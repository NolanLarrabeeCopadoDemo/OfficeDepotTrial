({  

    doAction : function(cmp, event,helper) { 

         cmp.set('v.salesDataColumns', [
            {label: 'Rolling Sales', fieldName: 'Rolling_12_month_Sales_text__c', type: 'decimal'},
            {label: 'Sales TY', fieldName: 'YTD_Sales_TY_text__c', type: 'decimal'}
        ]);

            helper.loadSalesData(cmp,event);

        
    },
    showSales : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showSalesInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    }
    
    
})