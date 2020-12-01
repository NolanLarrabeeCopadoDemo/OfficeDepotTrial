({
	doInit : function(component, event, helper) {
		// First, get the Contact for this record ID
        var firstAction = component.get("c.getContact");
        firstAction.setParams({"contactId": component.get("v.recordId")});
        firstAction.setCallback(this, function(response) {
        	var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.contact", response.getReturnValue());
            } else {
                console.log('Problem getting Contact, response state: ' + state);
            }
        });
        $A.enqueueAction(firstAction);
        
        // Second, check if there exists a User with the same email as this Contact
        var secondAction = component.get("c.checkUserExists");
        secondAction.setParams({"checkContactId": component.get("v.recordId")});
        secondAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.checkExists", response.getReturnValue() );
                component.set("v.initCompleted", true);
                
            } else {
                console.log('Problem getting User, response state: ' + state);
            }
        });
        $A.enqueueAction(secondAction);
        /*
        // Third, check if Account has been set up as a Partner Account
        var secondAction = component.get("c.checkPartnerAccount");
        secondAction.setParams({"checkContactId": component.get("v.recordId")});
        secondAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.checkExists", response.getReturnValue() );
                component.set("v.initCompleted", true);
                
            } else {
                console.log('Problem getting User, response state: ' + state);
            }
        });
        $A.enqueueAction(secondAction);
        */
        
        
    },

    handleSaveUser: function(component, event, helper) {
            
            // Prepare the action to create the new User
            var selectedRole = component.find("roleSelect").get("v.value");
            var saveUserAction = component.get("c.createUser");
            saveUserAction.setParams({
                "contact": component.get("v.contact"),
                "selectedRole": selectedRole
            });
            saveUserAction.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    // Prepare a toast UI message
                    var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams({
                        "title": "User Enabled",
                        "message": "New User has been enabled."
                    });

                    // Update the UI: close panel, show toast, refresh page
                    $A.get("e.force:closeQuickAction").fire();
                    resultsToast.fire();
                    $A.get("e.force:refreshView").fire();
                }
                else if (state === "ERROR") {
                    let toastParams = {  // Configure error toast
                        title: "Error",
                        message: "Unknown error", // Default error message
                        type: "error"
                    };
                    var errors = response.getError();
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        toastParams.message = 'This Account is not set up as a Partner Account. Please set up this account to proceed.';
                        errors = errors[0].message;
                    }
                    // Fire error toast
                    let toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams(toastParams);
                    $A.get("e.force:closeQuickAction").fire();
                    toastEvent.fire();
                    console.log('Problem saving user, response state: ' + errors);
                }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
            });
            $A.enqueueAction(saveUserAction);
    },

	handleCancel: function(component, event, helper) {
	    $A.get("e.force:closeQuickAction").fire();
    },
})