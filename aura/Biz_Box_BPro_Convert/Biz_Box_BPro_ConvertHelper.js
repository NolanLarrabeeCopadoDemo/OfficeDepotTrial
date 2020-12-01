({
	GetLead : function(component, event, helper) {
	    var leadId = component.get("v.recordId");

		var action = component.get("c.startInit");
		action.setParams({LeadId:  leadId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var myLead = response.getReturnValue();
                component.set("v.MyLead", myLead);
                component.set("v.IsConverted", myLead.IsConverted);
                console.log(response.getReturnValue());

            }
            else if (state === "ERROR") {
                alert('An Error Occurred, please consult your browser console.');
                var errors = response.getError();
                for( var i = 0; i < errors.length; i++){
                    console.log(errors[i].message);
                }
            }
        });

        $A.enqueueAction(action);
	},
	ConvertLead :function(component, event, helper) {
        var leadId = component.get("v.recordId");

        var action = component.get("c.ConvertLead");
        action.setParams({LeadId:  leadId});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.SubmissionInProgress', false);
                var result = response.getReturnValue();
                console.log(result);
                if(result.StatusCode === -1){
                    console.log(result);
                    if(result.Status.includes("VALIDATION_EXCEPTION,")){
                        var ErrorStatus = result.Status.split("VALIDATION_EXCEPTION,");
                        var ErrorMessage = ErrorStatus[1].replace(/&quot;/g, '"');
                    }
                    console.log(ErrorMessage);
                    component.set("v.ErrorMessage", ErrorMessage);
                }
                else if(result == null){
                    console.log("An error occurred during lead conversion. " +
                        "If your problem persists, please contact IT.");
                }else{
                    component.set("v.ConvertedAccount", result.Account);
                    component.set("v.ConvertedContact", result.Contact);
                    component.set("v.IsConverted", true);
                    //$A.get('e.force:refreshView').fire();
                }
                return response.getReturnValue();

            }
            else if (state === "ERROR") {
                component.set('v.SubmissionInProgress', false);
                alert('An Error Occurred, please consult your browser console.');
                var errors = response.getError();
                for( var i = 0; i < errors.length; i++){
                    console.log(errors[i].message);
                }
            }
        });
        component.set('v.SubmissionInProgress', true);
        $A.enqueueAction(action);
    }
})