({
    saveLeadDeal : function(cmp, event, helper) {
        var leadObj = cmp.get("v.leadObj");
        var saveAction = cmp.get("c.saveLeadDeal");    
        event.getSource().set("v.disabled", true);
        cmp.set("v.Spinner" , true);
        saveAction.setParams({
            "leadRec": leadObj
        });
        saveAction.setCallback(this, function(response) {
            var state = response.getState();
            cmp.set("v.Spinner" , false);
            var recordId = "";
            var leadDetailUrl = "/lead/";
            if (state == "SUCCESS") {
                var returnedLeadObj = response.getReturnValue();
                leadDetailUrl = leadDetailUrl + returnedLeadObj.Id;
                var msg = 'The new deal has been created successfully.';                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": msg,
                    "type" : 'success',
                });
                toastEvent.fire();
                 cmp.set("v.isOpenDesk", false);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": leadDetailUrl
                });    
                urlEvent.fire(); 
            } else {
                var msg = 'An error has occured. Please try again later.'; 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Error!",
                    "message": msg,
                    "type" : 'error',
                    "mode" : 'sticky'
                });
                toastEvent.fire();
            }        
        });
        $A.enqueueAction(saveAction);
    },
    fetchPickListVal: function(cmp, sObject, fieldName, listName) {
        var action = cmp.get("c.getPicklistValues");
        action.setParams({
            "objObject": sObject,
            "fieldName": fieldName
        });
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                
                for (var cnt = 0; cnt < allValues.length; cnt++) {
                    opts.push({
                        label: allValues[cnt],
                        value: allValues[cnt]
                    });
                }
                cmp.set(listName, opts);
            }
        });
        $A.enqueueAction(action);
    },
    isInputDataValid : function(cmp, event) {
        var isValid = true;
        if(cmp.find("firstName").reportValidity() == false) {
            isValid = false;
        }
        if (cmp.find("lastName").reportValidity() == false)  {
            isValid = false;
        }            
        if (cmp.find("company").reportValidity() == false) {
            isValid = false;
        }
       
        if (cmp.find("email").reportValidity() == false) {
            isValid = false;
        }

        if (cmp.find("address").reportValidity() == false) {
            isValid = false;
        }
        if (cmp.find("city").reportValidity() == false) {
            isValid = false;
        }
        if (cmp.find("postalCode").reportValidity() == false) {
            isValid = false;
        }
        if(!this.validatePhone(component, event)) {
            isValid  = false;
        }
        if(!this.validateEmail(cmp, event)) {
            isValid  = false;
        }
        if(!this.validateServiceType(cmp, event)) {
            isValid  = false;
        }
        return isValid;
    },
    
    validatePhone : function(component, event) {
        var phoneField = component.find("phoneid");
        var phoneValue = phoneField.get("v.value");
        if(!$A.util.isEmpty(phoneValue)) {   
            if (isNaN(phoneValue)) {
                phoneField.setCustomValidity("");
            }else
            {
                phoneField.setCustomValidity("Your entry does not match the allowed pattern.");
            }
        }
        return component.find("phoneid").reportValidity();
    },
    
    validateEmail : function(cmp, event) {
        
        var emailField = cmp.find("email");
        var emailFieldValue = emailField.get("v.value");
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        
        if(!$A.util.isEmpty(emailFieldValue)) {   
            if(emailFieldValue.match(regExpEmailformat)) {
                emailField.setCustomValidity("");  
            } else {
                emailField.setCustomValidity("Invalid email format.");
            }
        }
        return cmp.find("email").reportValidity();
    },
    
    validateServiceType : function(cmp, event)  {
        var itassIdField = cmp.find("itassId");
        var itassIdFieldValue = itassIdField.get("v.value");
        var numOfEmpField = cmp.find("numOfEmployeesId");
        var commentsIdField = cmp.find("commentsId");
        var isValid = true;
        
        if (itassIdFieldValue == 'true') {            
            var numOfEmpFieldValue = numOfEmpField.get("v.value");
            if($A.util.isEmpty(numOfEmpFieldValue)) {
                numOfEmpField.setCustomValidity("Complete this field.");
                isValid = false;
                numOfEmpField.reportValidity();
            } else {
                numOfEmpField.setCustomValidity("");
                numOfEmpField.reportValidity();
            }        	
            commentsIdField.setCustomValidity("");
            commentsIdField.reportValidity();
        } else {   
            numOfEmpField.setCustomValidity("");
            numOfEmpField.reportValidity();
            var commentsIdFieldValue = commentsIdField.get("v.value");
            if($A.util.isEmpty(commentsIdFieldValue)) {
                commentsIdField.setCustomValidity("Complete this field.");
                isValid = false;
                commentsIdField.reportValidity();
            } else {
                commentsIdField.setCustomValidity("");
                commentsIdField.reportValidity();
            }
        }
        return isValid;
    },
})