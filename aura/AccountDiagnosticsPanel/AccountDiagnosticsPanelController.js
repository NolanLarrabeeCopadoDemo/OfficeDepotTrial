({	
	/**
	 * Account_Setup_Request__c
	 * Account_Message__c
	 * Account_Service_Data__c
	 */

	navigatetohomepage : function(component, event, helper) {
		console.log('User Pressed Cancel...')
	},
	look_up_onchange: function(component, event, helper){
		console.log('Lookup on change called.');
		if (component.get("v.selected_account") != null){
			console.log(JSON.stringify(component.get("v.selected_account")));
			component.set("v.record_selected", true);
			helper.helper_grabAccountInformation(component);

		}
	},

	fetch_account_information: function(component, event, helper){
		helper.helper_grabAccountInformation(component);
	}

})