({
    doInitHelper: function(component, event) {
        var recordid = component.get("v.leadRecId");
        var objLead = component.get("v.objLead");
        var action = component.get("c.retrieveDBData");
        action.setParams({ recordid: recordid });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var res = response.getReturnValue();
                var recordData = []
                //To show top 5 results and also to concatenate First and Last name
                res.slice(0,5).forEach(element => {
                    element["CEO_Name"]=element["CEO_First_Name__c"] +' '+ element["CEO_Last_Name__c"]
                    recordData.push(element);
                });
                    component.set("v.data", recordData);
                    component.set("v.showDBFields", true);  
                } else {
                    component.set("v.errorMessage",true);
                }
                });
                    $A.enqueueAction(action);
                }
                });