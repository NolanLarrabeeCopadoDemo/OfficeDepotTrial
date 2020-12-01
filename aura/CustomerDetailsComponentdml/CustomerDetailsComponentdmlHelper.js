({
    loadCustomerData : function(cmp,event) {
                //alert("here");

        var params = event.getParam('arguments');  
        var selectedRec;
        if (params) {           
            selectedRec = params.param1;
            cmp.set(("v.subrecordId"),selectedRec);
        }        
            if(selectedRec !=null){
                //cmp.set( "v.currentId", selectedRec);  
                //cmp.set( "v.accountId", selectedRec);  
                // alert(selectedRec);
                //var isAccount = selectedRec.startsWith('001');
              //  cmp.set("v.isAccountOrOrg",isAccount);  
                //helper.loadOrgorAccountData(cmp);  
                var action = cmp.get("c.getCustomerData");
                action.setParams({InputData : JSON.stringify(cmp.get("v.subrecordId"))}) ;
                action.setCallback(this, function(response){
                    var state = response.getState(); 
                    //alert("Inside"+state);
                    
                    
                    if (state === "SUCCESS") {        
                        var returnData = response.getReturnValue();
                        cmp.set("v.customerList", returnData.customerList);
                        cmp.set("v.countCustomer", returnData.countCustomer);
                        cmp.set("v.recentCustomer", returnData.recentCustomer);
                    }
                });
                $A.enqueueAction(action);
            }
    }
})