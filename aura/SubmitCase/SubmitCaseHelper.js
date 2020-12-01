({
    submitcasehelperMethod :function(component,event) {
        
        var objCase = component.get("v.objCase");
        if(this.validateRequiredFields(component,event,objCase)) {   
            component.set("v.Spinner" , true);
            var action = component.get("c.saveCase");
            action.setParams({
                'objCase': objCase
            });
            action.setCallback(this,function(response) {
                component.set("v.Spinner" , false);
                if(response.getState() == "SUCCESS") {
                    var res = response.getReturnValue();
                    if(res != null && res != undefined) {
                       
                        var msg = 'Thank you, your case has been submitted with Case Number : ' + res.CaseNumber;
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Success!",
                            "message": msg,
                            "mode": 'sticky',
                            "type" : 'success'
                        });
                        toastEvent.fire(); 
                        component.set("v.bCaseSubmitted" , true);
                    }
                }else {
                    alert('There is a technical Error. Can you please try after sometime or Email your Channel Manager directly');
                }
            });
            $A.enqueueAction(action);    
        }
        
    },
    
    validateRequiredFields :function(component,event,objCase) {
        var isValid = true;
        
        if(objCase.PC_Priority__c == '') {
            isValid = false;
            component.find("priority_Id").showHelpMessageIfInvalid();
        }  
        
        if(objCase.IT_Classification__c == '') {
            isValid = false;
            component.find("issueType_Id").showHelpMessageIfInvalid();
        }
        
        if(objCase.Department__c == '') {
            isValid = false;
            component.find("Shoot_Your_Question_to_Id").showHelpMessageIfInvalid();
        }
        
        return isValid;
    },
    doInitHelper :function(component,event) {
        component.set("v.Spinner" , true);
        var action = component.get("c.fetchLoginUserDetails");
        action.setCallback(this,function(response) {
            component.set("v.Spinner" , false);
            if(response.getState() == "SUCCESS") {
                var res = response.getReturnValue();
                var objCase = component.get("v.objCase");
                if(res.Name != undefined) {
                   objCase.Case_Name_field1__c = res.Name;  
                 }
                if(res.Email != undefined) {
                   objCase.ContactEmail = res.Email;  
                 }
                if(res.Phone != undefined) {
                   objCase.ContactPhone = res.Phone;  
                 }
                component.set("v.objCase" , objCase); 
             }
        });
        $A.enqueueAction(action);           
    },
    fetchPickListVal: function(component, fieldName, listName) {
        var action = component.get("c.getselectOptions");
        action.setParams({
            "objObject": component.get("v.objCase"),
            "fld": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push(allValues[i]);
                }
                component.set(listName , opts);
            }
        });
        $A.enqueueAction(action);
    },
})