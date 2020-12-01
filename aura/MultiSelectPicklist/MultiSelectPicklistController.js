({
	doInit: function (component, event, helper) {
		component.set("v.isLoading", true);

		var getAvailablePicklistValuesAction = component.get("c.getAvailablePicklistValues");
		getAvailablePicklistValuesAction.setParams({
			objName: component.get("v.objName"),
			fieldName: component.get("v.fieldName")
		});

		getAvailablePicklistValuesAction.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();
				var plValues = [];
				for (var i = 0; i < result.length; i++) {
					plValues.push({
						label: result[i],
						value: result[i]
					});
				}
				component.set("v.genreList", plValues);
			}
		});
		$A.enqueueAction(getAvailablePicklistValuesAction);

		var getCurrentPicklistValuesAction = component.get("c.getCurrentPicklistValues");
		getCurrentPicklistValuesAction.setParams({
			objName: component.get("v.objName"),
			fieldName: component.get("v.fieldName"),
			recId: component.get("v.recId")
		});

		getCurrentPicklistValuesAction.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var selectedValues = response.getReturnValue();
				component.set("v.selectedGenreList", selectedValues);
			}
			component.set("v.isLoading", false);
		});
		$A.enqueueAction(getCurrentPicklistValuesAction);
	},

	handleGenreChange: function (component, event, helper) {
		//Get the Selected values
		var selectedValues = event.getParam("value");
		//Update the Selected values
		component.set("v.selectedGenreList", selectedValues);
	},

	onSaveClick: function (component, event, helper) {
		component.set("v.isLoading", true);
		var selectedValues = component.get("v.selectedGenreList");
		var savePicklistValueAction = component.get("c.savePicklistValue");
		savePicklistValueAction.setParams({
			objName: component.get("v.objName"),
			fieldName: component.get("v.fieldName"),
			recId: component.get("v.recId"),
			value: selectedValues.join(';')
		});
		savePicklistValueAction.setCallback(this, function (response)
		{
			component.set("v.isLoading", false);
		});
		$A.enqueueAction(savePicklistValueAction);
	}
})