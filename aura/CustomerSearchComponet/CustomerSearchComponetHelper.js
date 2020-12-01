({
    initRecords : function(component) {
        var leadId  = component.get("v.leadRecId");
        var action = component.get("c.getAccountInstance");
        action.setParams({ leadId : leadId });
        action.setCallback(this, function(response){
            var accInstance = response.getReturnValue();
            component.set("v.accRec", accInstance.accRec);
            component.set("v.defaultAccRecordType", accInstance.defaultAccRecordType);
            component.set("v.accCountryList", accInstance.countryList);
            component.set("v.accStateList", accInstance.stateList);
            var accRTVal = accInstance.accRTMap;
            var opts = [];
            for(var key in accRTVal){
                opts.push({value:accRTVal[key], label:key});
            }
            component.set("v.accRecordTypeOptions", opts);
            component.find('accRTId').set('v.value',component.get("v.defaultAccRecordType"));
            //component.find('accRecCountryId').set('v.value',accInstance.accRec.Country__c);
            if(accInstance.accRec.Country__c == 'MEX'){
                component.set("v.accStateList",'');
                component.set("v.accStateActive",true);
            }else{
                //component.find('accRecStateId').set('v.value',accInstance.accRec.State__c);
            }
            if($A.util.isEmpty(leadId)){
                component.set("v.accStateActive",false);
                component.set("v.accStateRequired",true);
                component.set("v.accStateList", accInstance.stateList);
            }
            
        });
        $A.enqueueAction(action);
        
    },
    getStateValues : function(component){
        var countryVal = component.get("v.accRec.Country__c");
        var action = component.get("c.getStateList");
        action.setParams({
            "pObjName":"Account",
            "pControllingFieldName"  : "Country__c",
            "pDependentFieldName" : "State__c",
            "ctrlPicklistVal" : countryVal
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var stateList = response.getReturnValue();
                if(!$A.util.isEmpty(stateList)){
                    component.set("v.accStateList",stateList);
                    //component.set("v.accStateActive",false);
                    //component.set("v.accStateRequired",true);
                }else{
                    component.set("v.accStateList",'');
                    //component.set("v.accStateActive",true);
                    //component.set("v.accStateRequired",false);
                }
                
            }
        });
        $A.enqueueAction(action);
    },
    doInitValidate : function(component){
        var leadId  = component.get("v.leadRecId");
        var action = component.get("c.validateLeadData");
        action.setParams({ leadId : leadId });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue() !=''){
                    component.set( "v.errorMessage", response.getReturnValue());
                    component.set( "v.inputError", true);
                     
                }
                else{
                component.set( "v.inputError", false);
                component.set("v.showAccSearch",true);
                this.initRecords(component);                    
                }
               /// alert(component.get("v.errorMessage"));
                var spinner = component.find("mySpinner");
                $A.util.addClass(spinner, "slds-hide");
                
            }  else{

            }
           
        });
        
        $A.enqueueAction(action);
    },
    
    
    searchCustDataHelper : function(component) {
        var accData = component.get("v.accRec");
        var formattedAccData=JSON.stringify(accData);
        console.log('=========formattedAccData======='+formattedAccData);
        //var action = component.get("c.searchAggroService");
        //action.setParams({JSON_Account : formattedAccData});
        var action = component.get("c.searchCustInformation");
        action.setParams({prospectData : formattedAccData});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var orgResults = response.getReturnValue();
                component.set("v.Spinner",false);
                var appEvent = $A.get("e.c:ProcessIndicatorEvent");
                appEvent.setParams({
                    "currentStep" : "Org Results" });
                appEvent.fire();
                if($A.util.isEmpty(orgResults)){
                    component.set("v.noRecsFound",true);
                }else{
                    component.set("v.orgRecList",orgResults);
                    component.set("v.noRecsFound",false);
                }
                component.set("v.showAccSearch",false);
                var appEvent = $A.get("e.c:CustomerSearchEvent");
                appEvent.setParams({
                    "custSearchList" : orgResults,
                    "prospectRec" : accData});
                appEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})