({
    doInit : function(component, event, helper) {
    	//component.set("v.isModalOpen", 'c.getCorrectProfilename');        
         //alert("v.isModalOpen");

         var Action = component.get("c.getCorrectProfileName");
         Action.setCallback(this, function (response) {
             var state = response.getState();
             if (state === 'SUCCESS'){
                 var value = response.getReturnValue();
                 console.log(value);
                 component.set("v.isModalOpen", true); 
                 component.set("v.isRedirect", value); 
                                 
             } else if (state === "INCOMPLETE") {
                 // do something
             }else if (state === "ERROR") {
                component.set("v.isModalOpen", false);  
                 
             }
         });
         $A.enqueueAction(Action);
    },
        
    createRecord : function (component, event, helper) {
    var createRecordEvent = $A.get("e.force:createRecord");
    createRecordEvent.setParams({
        "entityApiName": "Opportunity"
    });
    createRecordEvent.fire();
   },
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false
        component.set("v.isModalOpen", false);
        
        var modal = component.find("myModal");
    	var modalBackdrop = component.find("myModal-Back");
    	$A.util.removeClass(modal, 'slds-fade-in-open');
        $A.util.removeClass(modalBackdrop, 'slds-fade-in-open');
        
        var navService = component.find("navService");
        // Uses the pageReference definition in the init handler
        var pageReference = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Opportunity',
                actionName: 'list'
            },
            state: {
                filterName: "Recent"
            }
        };
        event.preventDefault();
        navService.navigate(pageReference);
   }
})