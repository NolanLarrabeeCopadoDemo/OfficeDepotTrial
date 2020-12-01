({
    doInit : function(component, event, helper) {
        var flow = component.find("flowData");
        
        if(component.get("v.fields").Cust_ID__c == undefined)
            var CustId = '';
        else
            var CustId = component.get("v.fields").Cust_ID__c;
        var inputVariables = [
            
            { name : "acctid", type : "String", value: component.get("v.fields").Id},
            { name : "acctnm", type : "String", value: component.get("v.fields").Name },
            { name : "custid", type : "String", value: CustId }
        ]
        
        flow.startFlow("SCOE_Button_Seismic_Checkpoint", inputVariables);
        
    },
    
    handleStatusChange : function (component, event) {
        if(event.getParam("status") === "FINISHED") {
            var outputVariables = event.getParam("outputVariables");
            console.log('test-->'+JSON.stringify(outputVariables));
            var outputVar;
            for(var i = 0; i < outputVariables.length; i++) {
                outputVar = outputVariables[i];
                if(outputVar.name === "acctid") {
                    var urlEvent = $A.get("e.force:navigateToSObject");
                    urlEvent.setParams({
                        "recordId": outputVar.value,
                        "isredirect": "true"
                    });
                    urlEvent.fire();
                }
            }
        }
    }
})