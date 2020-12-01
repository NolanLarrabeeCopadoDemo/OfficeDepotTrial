({
	hinit : function(component) {
       
        var action=component.get("c.initLead");
		action.setCallback(this, function(response) {
             var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.li_lead", response.getReturnValue());
                console.log(response.getReturnValue());
            }
            else if (state === "ERROR") {
                alert(response.getError()[0].message);
                //TODO:error handling
            }
        });
        
        $A.enqueueAction(action);
	},
    
    hsubmitLead : function(component) {
        var action=component.get("c.saveLead");
        action.setParams({
         l : component.get("v.li_lead")
        });
        
        action.setCallback(this,function(response)  {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue() == 'S') {
                   // alert('success');
                    component.set("v.displayBody","false");
                    component.set("v.displaySuccess","true");
                }
                else {
                   $A.createComponent("ui:message",
                                      {"title": "Error: " + response.getReturnValue(),
                                  "severity":"error"
                                 },
                    function(cmp) {
                          component.set("v.messages", [cmp]);
                    });
                }
            }
            else if (state === "ERROR") {
                alert(response.getError()[0].message);
            }
        });
        
        $A.enqueueAction(action);
        
    }
})