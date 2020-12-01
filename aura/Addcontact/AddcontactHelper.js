({
    savecontact : function(component,event) 
    {
        var objContact= component.get("v.objContact");
        var ouserrole= component.find("a_opt").get("v.value");
        component.set("v.Spinner" , true);
        console.log('==>contact fields are:'+objContact+'==>Userrole selected on the component:'+ouserrole);
        var action = component.get("c.saveContact");
        action.setParams({
            objContact: objContact,
            ouserrole : ouserrole
        });
        action.setCallback(this,function(response) {
            component.set("v.Spinner" , false);
            if(response.getState() == "SUCCESS") { 
                var res = response.getReturnValue();
                if(res != null && res != undefined) {
                    var msg = 'Thank you, User has been created ';
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams ({
                        "title": "Success!",
                        "message": msg,
                        "type" : 'success'
                    });
                    toastEvent.fire(); 
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": res.Id,
                        "slideDevName": "related"
                    });
                    navEvt.fire();
                }  
            } else
            {
                var badnotifier= "Caused by: common.apex.runtime.impl.ExecutionException:";
                var obadnotifier = "Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION,";
               if(response.getError()[0].message.includes(badnotifier)) {
                var fnlmsg=response.getErrPhoneor()[0].message.split(badnotifier)[1];
                   console.log('==>First kind of message'+fnlmsg);
               } else if(response.getError()[0].message.includes(obadnotifier)) {
                var fnlmsg=response.getError()[0].message.split(obadnotifier)[1];
                    fnlmsg=fnlmsg.substring(0,fnlmsg.indexOf(': '));
                   console.log('==>Second kind of message'+fnlmsg);
               } else {
                    var fnlmsg=response.getError()[0].message;
                   console.log('==>Third kind of message'+fnlmsg);
               } 
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": '"Error"',
                    "type": '"error"',
                    "message": fnlmsg
                });
                toastEvent.fire(); 
            }
        });
        $A.enqueueAction(action);    
    },
    
    doInitHelper : function(component,event) {
        component.set("v.Spinner" , true);
        var action = component.get("c.getAccountName");
        action.setCallback(this,function(response) {
            component.set("v.Spinner" , false);
            console.log('==>Response is:'+response.getState());
            if(response.getState() == "SUCCESS") {
                var res = response.getReturnValue();
                console.log('==>AccountName is:'+res.accountname+'==>Portal Role to display accordingly:'+res.portalrole);
                var objContact = component.get("v.objContact");
                var userrole = component.get("v.userrole");
                if(res.accountname != undefined) {
                    objContact.Account = res.accountname;  
                }
                if(res.portalrole != undefined) {
                    userrole= res.portalrole;  
                }
                component.set("v.objContact" , objContact); 
                component.set("v.userrole" , userrole); 
            } 
        });
        $A.enqueueAction(action);     
    },
    
    isInputDataValid : function(component, event) {
        var isValid = true;
        if(component.find("firstname_id").reportValidity() == false) {
            isValid = false;
        }
        if (component.find("lastname_id").reportValidity() == false)  {
            isValid = false;
        }            
        
        if (component.find("email_id").reportValidity() == false) {
            isValid = false;
        }
        if (component.find("title_id").reportValidity() == false) {
            isValid = false;
        }
        if(!this.validateEmail(component, event)) {
            isValid  = false;
        }
  
        if(!this.validateFirstName(component, event)) {
            isValid  = false;
        }
        if(!this.validateLastName(component, event)) {
            isValid  = false;
        }
        
        if(!this.validatePhoneNum(component, event)) {
            isValid  = false;
        }
        return isValid;
    },
    
    validateEmail : function(component, event) {
        
        var emailField = component.find("email_id");
        var emailFieldValue = emailField.get("v.value");
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;  
        
        if(!$A.util.isEmpty(emailFieldValue)) {   
            if(emailFieldValue.match(regExpEmailformat)) {
                emailField.setCustomValidity("");  
            } else {
                emailField.setCustomValidity("Invalid email format.");
            }
        }
        return component.find("email_id").reportValidity();
    },
    
    validateFirstName : function(component, event) {
        var fnameField = component.find("firstname_id");
        var fnameFieldValue = fnameField.get("v.value");
        
        if(!$A.util.isEmpty(fnameFieldValue)) {   
            if (isNaN(fnameFieldValue)) {
                fnameField.setCustomValidity("");
            }else
            {
                fnameField.setCustomValidity("First Name cannot contain numbers");
            }
        }
        return component.find("firstname_id").reportValidity();
    },
    
    validateLastName : function(component, event) {
        var lnameField = component.find("lastname_id");
        var lnameFieldValue = lnameField.get("v.value");
        if(!$A.util.isEmpty(lnameFieldValue)) {   
            if (isNaN(lnameFieldValue)) {
                lnameField.setCustomValidity("");
            }else
            {
                lnameField.setCustomValidity("Last Name cannot contain numbers");
            }
        }
        return component.find("lastname_id").reportValidity();
    },
    
    validatePhoneNum : function(component, event) {
        var phoneField = component.find("phone_id");
        var phoneValue = phoneField.get("v.value");
        if(!$A.util.isEmpty(phoneValue)) {   
            if (isNaN(phoneValue)) {
                phoneField.setCustomValidity("");
            }else
            {
                phoneField.setCustomValidity("Your entry does not match the allowed pattern.");
            }
        }
        return component.find("phone_id").reportValidity();
    },
})