({
	doInit : function(component, event, helper) {
		var myDocumentName = component.get("v.documentName");
		var getDocumentLinkAction = component.get("c.retrieveDocumentURL");
		getDocumentLinkAction.setParams({
			documentName: myDocumentName,
			publicURL: true,
		});
		getDocumentLinkAction.setCallback(this, function(response){
			var responseState = response.getState();
			if (responseState === 'SUCCESS'){
				var myURL = response.getReturnValue();
				component.set("v.downloadLink", myURL);
                console.log('Received: ' + myURL);
            } else if (responseState === "INCOMPLETE") {
                // do something
            }
            else if (responseState === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + 
								 errors[0].message);
                    }
                } else {
                    console.error("Unknown error");
                }
            }
		});
		$A.enqueueAction(getDocumentLinkAction);
	}
})