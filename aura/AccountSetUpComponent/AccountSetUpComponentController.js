({
	//Sandesh Ganjare NAIT-148117 - Start
	doInit:function(component, event, helper) {
		helper.setShowChecklist(component, event);
	},
	//Sandesh Ganjare NAIT-148117 - End
	navigatetohomepage : function(component, event, helper) {
        var recid = component.get("v.subrecordId")
	     window.open('/'+recid,'_self');
	},

	handleEvent: function(component, event, helper) {
        component.set("v.showChecklist",false);
	},
	//Sandesh Ganjare NAIT-148117 - Start
	waiting: function(component, event, helper) {
		component.set("v.HideSpinner", true);
	},
	doneWaiting: function(component, event, helper) {
		component.set("v.HideSpinner", false);
	}
	//Sandesh Ganjare NAIT-148117 - End
})