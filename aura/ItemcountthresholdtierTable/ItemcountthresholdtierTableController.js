({
	 onRecordSubmit: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        
        eventFields["Item_count_threshold_tier_From1__c"] = component.find("PointOfSalesFrom1").get("v.value");
        eventFields["Item_count_threshold_tier_To1__c"] = component.find("PointOfSalesTo1").get("v.value");
        eventFields["Item_count_threshold_tier_Count1__c"] = component.find("PointOfSalesDiscount1").get("v.value");
        eventFields["Item_count_threshold_tier_From2__c"] = component.find("PointOfSalesFrom2").get("v.value");
        eventFields["Item_count_threshold_tier_To2__c"] = component.find("PointOfSalesTo2").get("v.value");
        eventFields["Item_count_threshold_tier_Count2__c"] = component.find("PointOfSalesDiscount2").get("v.value");
        eventFields["Item_count_threshold_tier_From3__c"] = component.find("PointOfSalesFrom3").get("v.value");
        eventFields["Item_count_threshold_tier_To3__c"] = component.find("PointOfSalesTo3").get("v.value");
         eventFields["Item_count_threshold_tier_Count3__c"] = component.find("PointOfSalesDiscount3").get("v.value");
         eventFields["Item_count_threshold_tier_From4__c"] = component.find("PointOfSalesFrom4").get("v.value");
         eventFields["Item_count_threshold_tier_To4__c"] = component.find("PointOfSalesTo4").get("v.value");
         eventFields["Item_count_threshold_tier_Count4__c"] = component.find("PointOfSalesDiscount4").get("v.value");
         eventFields["Item_count_threshold_tier_From5__c"] = component.find("PointOfSalesFrom5").get("v.value");
         eventFields["Item_count_threshold_tier_To5__c"] = component.find("PointOfSalesTo5").get("v.value");
         eventFields["Item_count_threshold_tier_Count5__c"] = component.find("PointOfSalesDiscount5").get("v.value");
         
         eventFields["Item_count_threshold_tier_From6__c"] = component.find("PointOfSalesFrom6").get("v.value");
         eventFields["Item_count_threshold_tier_To6__c"] = component.find("PointOfSalesTo6").get("v.value");
         eventFields["Item_count_threshold_tier_Count6__c"] = component.find("PointOfSalesDiscount6").get("v.value");
         
         eventFields["Item_count_threshold_tier_From7__c"] = component.find("PointOfSalesFrom7").get("v.value");
         eventFields["Item_count_threshold_tier_To7__c"] = component.find("PointOfSalesTo7").get("v.value");
         eventFields["Item_count_threshold_tier_Count7__c"] = component.find("PointOfSalesDiscount7").get("v.value");
        //eventFields["Lang_in_contract_for_Perf_Notif_Requirem__c"] = PenaltyPicklistToBeStored;
        component.find('myForm11').submit(eventFields);
        
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Success!",
                "message": "Saved Successfully."
            });
            toastEvent.fire();

        
    }
})