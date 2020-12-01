({
	getAccountList: function(component) {
        var action = component.get('c.fetchCPT');
        // Set up the callback
        var self = this;
        action.setParams({ contractId : component.get("v.recordId") });

        action.setCallback(this, function(actionResult) {
         component.set('v.ContractPriceTerm', actionResult.getReturnValue());
        });
        $A.enqueueAction(action);
      },
   
   
})