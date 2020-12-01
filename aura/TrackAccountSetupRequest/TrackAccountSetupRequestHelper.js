({
    getResponse: function (component, accId) {
        component.set('v.isLoading', true);
        var columns = [
        {
            fieldName: 'Step_Description',
            label: 'Step Description',
            type: 'text'
        },
        {
            fieldName: 'Request_Id',
            label: 'Request Id',
            type: 'text'
        },
        {
            fieldName: 'SFDC_Id',
            label: 'SFDC Id',
            type: 'text'
        },
        {
            fieldName: 'AOPS_Account_Id',
            label: 'AOPS Account Id',
            type: 'text'
        },
        {
            fieldName: 'B_Name',
            label: 'B Name',
            type: 'text'
        },
        {
            fieldName: 'Message',
            label: 'Message',
            type: 'text'
        },
        {
            fieldName: 'Posted_Timestamp',
            label: 'Posted Timestamp',
            type: 'text'
        },
        {
            fieldName: 'Operation',
            label: 'Operation',
            type: 'text'
        },
    ];      
    component.set('v.columns', columns);
            
        let action = component.get("c.TrackAccountSetupRequest");
        action.setParams({ SFDCAccountId: accId });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let res = JSON.parse(response.getReturnValue()).sets;
                component.set("v.response", res);
            	}
            component.set('v.isLoading', false);
        });
        $A.enqueueAction(action);
    }
})