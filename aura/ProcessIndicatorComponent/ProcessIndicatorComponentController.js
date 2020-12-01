({
    handleProcessIndicatorEvent : function(component, event, helper) {
       
        var currentStep = event.getParam("currentStep");
        component.set("v.currentStepName",currentStep);
      
	}
})