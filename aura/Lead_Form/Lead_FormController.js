({
    CheckAndSubmit: function(component, event, helper) {
        var requestInProgress = component.get("v.RequestInProgress");
        console.log('Request in progress status is ' + requestInProgress);
        //console.log("The Request in progress trigger is " + component.find("requestStatus").get("v.value"));
        if(!requestInProgress){
            var input = helper.aggregateInput(component, event, helper);
            if (input !== null) {
                helper.commitInput(component, event, helper, input);
            }

        }




    },
    doInit: function(component, event, helper) {
        console.log("Doing Init");
        var action = component.get("c.Init");
        var urlParams = helper.getURLParams();
        var paramMap = helper.parseParams(component, event, helper, urlParams);
        console.log("Params is " +urlParams);
        var store = paramMap.get("store");
        console.log(store);
        if (store != null)
        {
            console.log("Inside store not null");
            store = ("000000"+store).slice(-6);
            component.set("v.store", store);
            var storeAction = component.get('c.CheckStoreNumber');
            storeAction.setParams({
                "iStoreNumber": store
            });
            storeAction.setCallback(this, function(response) {
                    console.log("inside set callback");
                    var state = response.getState();
                    console.log(state);
                    if (state == "SUCCESS") {
                        var reaction = response.getReturnValue();
                        console.log("Reaction is " +reaction + ' ' + response);
                        console.log(response);
                        component.set("v.validStore", reaction);
                    }
             });
             console.log("before enqueue");
             $A.enqueueAction(storeAction);
        }
        action.setCallback(this, function(response) {
            var state = response.getState();
                if (state === "SUCCESS") {
                    var result = JSON.parse(response.getReturnValue());

                    console.log(result);

                    }else if (state === "INCOMPLETE") {
                        console.log("Init in Progress");
                    }else if(state=== "ERROR") {
                        var errors = response.getError();
                        if(errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + errors[0].message);
                            }
                        }else {
                            console.log("Unknown error occurred.");
                        }
                    }
        });

        $A.enqueueAction(action);

    }
})