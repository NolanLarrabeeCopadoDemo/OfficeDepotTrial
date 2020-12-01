({
	handleProcessIndicatorEvent : function(component, event, helper) {
		console.log('Inside handleProcessIndicatorEvent');
        var currentStep = event.getParam("currentStep");
        console.log('currentStep.....'+currentStep);
        component.set("v.currentStepName",currentStep);
	}
})