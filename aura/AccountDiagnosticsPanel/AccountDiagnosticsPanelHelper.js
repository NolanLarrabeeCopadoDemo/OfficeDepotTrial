({
	helper_grabAccountInformation: function (component) {
		var AccountId = component.get("v.selected_account");

		var accountInformationRequest = component.get("c.GetAccountInformation");
		accountInformationRequest.setParams({
			accountId: AccountId
		});
		accountInformationRequest.setCallback(this, function (response) {
			var state = response.getState();
			if(state === "SUCCESS"){
				var result = response.getReturnValue();
				console.log(result);
				component.set("v.myAccount", result.myAccount);
				
				if(result.my_account_message !== 'undefined')
					component.set("v.my_account_message", result.AccountMessage);
					var account_message = component.get("v.my_account_message");
					console.log(account_message);
				
				if(result.my_account_setup_request !== 'undefined')
					component.set("v.my_account_setup_request", result.AccountSetupRequest);
					var account_setup_request = component.get("v.my_account_setup_request");
					console.log(account_setup_request);

				if(result.my_account_service_data !== 'undefined')
					component.set("v.my_account_service_data", result.AccountServiceData);
					var account_service_data = component.get("v.my_account_service_data");
					console.log(account_service_data);

			}else if(state === "ERROR"){
				//Show Error Message...
				console.log('An Error Occured...');
			}
		});
		//Show Spinner....
		$A.enqueueAction(accountInformationRequest);
	}
})