({  

    doAction : function(cmp, event,helper) { 
        cmp.set('v.PricingColumns', [
            {label: 'Name', fieldName: 'Name', type: 'text'}
        ]);
            helper.loadPricingData(cmp,event);

        
    },
    showPricing : function (cmp, event, helper) {
        cmp.set("v.showModel",true);
        cmp.set("v.showPricingInfo",true);      
    },
    closeModel : function (cmp, event, helper) {
        cmp.set("v.showModel",false);
        document.body.style.overflow = "auto";
    }
    
    
})