({
	 onRecordSubmit: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        
        eventFields["Point_of_sales_tiers_Form1__c"] = component.find("PointOfSalesFrom1").get("v.value");
        eventFields["Point_of_sales_tiers_To1__c"] = component.find("PointOfSalesTo1").get("v.value");
        eventFields["Point_of_sales_tiers_Discount1__c"] = component.find("PointOfSalesDiscount1").get("v.value");
        eventFields["Point_of_sales_tiers_Form2__c"] = component.find("PointOfSalesFrom2").get("v.value");
        eventFields["Point_of_sales_tiers_To2__c"] = component.find("PointOfSalesTo2").get("v.value");
        eventFields["Point_of_sales_tiers_Discount2__c"] = component.find("PointOfSalesDiscount2").get("v.value");
        eventFields["Point_of_sales_tiers_Form3__c"] = component.find("PointOfSalesFrom3").get("v.value");
        eventFields["Point_of_sales_tiers_To3__c"] = component.find("PointOfSalesTo3").get("v.value");
         eventFields["Point_of_sales_tiers_Discount3__c"] = component.find("PointOfSalesDiscount3").get("v.value");
         eventFields["Point_of_sales_tiers_Form4__c"] = component.find("PointOfSalesFrom4").get("v.value");
         eventFields["Point_of_sales_tiers_To4__c"] = component.find("PointOfSalesTo4").get("v.value");
         eventFields["Point_of_sales_tiers_Discount4__c"] = component.find("PointOfSalesDiscount4").get("v.value");
         eventFields["Point_of_sales_tiers_Form5__c"] = component.find("PointOfSalesFrom5").get("v.value");
         eventFields["Point_of_sales_tiers_To5__c"] = component.find("PointOfSalesTo5").get("v.value");
         eventFields["Point_of_sales_tiers_Discount5__c"] = component.find("PointOfSalesDiscount5").get("v.value");
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