({
    
    doInit : function(component, event, helper) {
        //let val = component.get("v.isClone");

       console.log("Test->>"+component.get("v.fields"));
         if(component.get("v.isClone") != true){
        var fieldValue1 = component.get("v.fields").Current_contract_expiration_date_1__c;
        component.find('ContractExpDate1').set('v.value', fieldValue1);
             }
        if(component.get("v.isClone") != true){
        var fieldValue2 = component.get("v.fields").Current_contract_expiration_date_2__c;
         component.find('ContractExpDate2').set('v.value', fieldValue2);
        }
        if(component.get("v.isClone") != true){
        var fieldValue3 = component.get("v.fields").Current_contract_expiration_date_3__c;
         component.find('ContractExpDate3').set('v.value', fieldValue3);
        }
        if(component.get("v.isClone") != true){
        var fieldValue4 = component.get("v.fields").Current_contract_expiration_date_4__c;
         component.find('ContractExpDate4').set('v.value', fieldValue4);
        }
         if(component.get("v.isClone") != true){
        var fieldValue5 = component.get("v.fields").Current_contract_expiration_date_5__c;
         component.find('ContractExpDate5').set('v.value', fieldValue5);
         }
        if(component.get("v.isClone") != true){
            var fieldValue6 = component.get("v.fields").Date_current_Legal_Contract_expires__c;
        console.log('Test-->'+component.get("v.fields").Date_current_Legal_Contract_expires__c);
         component.find('LegalContractExpDate').set('v.value', fieldValue6);
        }
         if(component.get("v.isClone") != true){
        var fieldValue7 = component.get("v.fields").Effective_Date_of_Original_Contract__c;
         component.find('EffectiveDate1').set('v.value', fieldValue7);
         }
        if(component.get("v.isClone") != true){
        var fieldValue8 = component.get("v.fields").Effective_Date_of_Original_Contract_2__c;
         component.find('EffectiveDate2').set('v.value', fieldValue8);
        }
        if(component.get("v.isClone") != true){
        var fieldValue9 = component.get("v.fields").Effective_Date_of_Original_Contract_3__c;
         component.find('EffectiveDate3').set('v.value', fieldValue9);
        }
        if(component.get("v.isClone") != true){
        var fieldValue10 = component.get("v.fields").Effective_Date_of_Original_Contract_4__c;
         component.find('EffectiveDate4').set('v.value', fieldValue10);
        }
        if(component.get("v.isClone") != true){
        var fieldValue11 = component.get("v.fields").Effective_Date_of_Original_Contract_5__c;
         component.find('EffectiveDate5').set('v.value', fieldValue11);
        }
        //component.set("v.ContractExpDate1",component.get("v.fields."));  
    },
    
    
	DateChange : function(component, event, helper) {
		 var Date1 = component.find("ContractExpDate1").get("v.value");
	 var Date2 = component.find("ContractExpDate2").get("v.value");
	 var Date3 = component.find("ContractExpDate3").get("v.value");
	 var Date4 = component.find("ContractExpDate4").get("v.value");
	 var Date5 = component.find("ContractExpDate5").get("v.value");
	
	var dates=[]; 
	if(Date1 != null && Date1 != '' && Date1 != 0)
	dates.push(Date1);
	if(Date2 != null && Date2 != '' && Date2 != 0)
	dates.push(Date2);
	if(Date3 != null && Date3 != '' && Date3 != 0)
	dates.push(Date3);
	if(Date4 != null && Date4 != '' && Date4 != 0)
	dates.push(Date4);
	if(Date5 != null && Date5 != '' && Date5 != 0)
	dates.push(Date5);
      var i; 
     var minimum;
      minimum =  dates[0];
    for (i=0; i < dates.length; i++)
    {
        if (dates[i] < minimum)
        {
           minimum = dates[i];
          
        }
    }
        console.log('minimumSDQQ'+minimum);
  component.find('LegalContractExpDate').set('v.value',minimum);
        
	
	/*var minDate=new Date(Math.min.apply(null,dates));
        console.log('minDate'+minDate);
 	component.find('LegalContractExpDate').set('v.value', minDate); */
        
	},
    
    onRecordSubmit: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        
        eventFields["Effective_Date_of_Original_Contract__c"] = component.find("EffectiveDate1").get("v.value");
        eventFields["Effective_Date_of_Original_Contract_2__c"] = component.find("EffectiveDate2").get("v.value");
        eventFields["Effective_Date_of_Original_Contract_3__c"] = component.find("EffectiveDate3").get("v.value");
        eventFields["Effective_Date_of_Original_Contract_4__c"] = component.find("EffectiveDate4").get("v.value");
        eventFields["Effective_Date_of_Original_Contract_5__c"] = component.find("EffectiveDate5").get("v.value");
        eventFields["Current_contract_expiration_date_1__c"] = component.find("ContractExpDate1").get("v.value");
        eventFields["Current_contract_expiration_date_2__c"] = component.find("ContractExpDate2").get("v.value");
        eventFields["Current_contract_expiration_date_3__c"] = component.find("ContractExpDate3").get("v.value");
        eventFields["Current_contract_expiration_date_4__c"] = component.find("ContractExpDate4").get("v.value");
        eventFields["Current_contract_expiration_date_5__c"] = component.find("ContractExpDate5").get("v.value");
        eventFields["Date_current_Legal_Contract_expires__c"] = component.find("LegalContractExpDate").get("v.value");
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