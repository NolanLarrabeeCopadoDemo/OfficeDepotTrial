({
    //Code for getting all the Contracts on the Account and its Parents by calling Apex class method.
	getContractList: function(component) {
        console.log("Test-->"+component.get("v.recordId"));
        var action = component.get('c.fetchContracts');
        // Set up the callback
        var self = this;
        action.setParams({ AccountRecordId : component.get("v.recordId") });

        action.setCallback(this, function(actionResult) {
            if(actionResult.getReturnValue() != null)
            {
                component.set('v.ContractList', actionResult.getReturnValue());
               //console.log('test-->'+JSON.stringify(component.get("v.ContractList")));
            }
            else
                console.log('Failure');
         	
        });
        $A.enqueueAction(action);
      }
})