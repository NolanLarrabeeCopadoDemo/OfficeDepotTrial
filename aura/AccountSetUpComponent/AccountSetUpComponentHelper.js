({
	//Sandesh Ganjare NAIT-148117 - Start
	setShowChecklist : function(component, event) {
		var action = component.get("c.getProfileCheck");
		//action.setParams({OrgId : cmp.get("v.currentId")}) ;
		action.setCallback(this, function(response){
			var state = response.getState();			
			if (state === "SUCCESS") {        
				var returnData = response.getReturnValue();
				component.set("v.showChecklist", returnData);				
			}
		});
		$A.enqueueAction(action);
            
	}
	//Sandesh Ganjare NAIT-148117 - End
})