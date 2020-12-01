({
	doInit: function (component, event, helper) {
		let accId = component.get("v.recordId")
		helper.getResponse(component, accId); // Passing the account id to the callout API
	}
})