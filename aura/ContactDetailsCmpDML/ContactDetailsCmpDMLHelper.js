({
    loadContactData : function(cmp,event) {
        var params = event.getParam('arguments');  
        var selectedRec;
        if (params) {           
            selectedRec = params.param1;
            cmp.set(("v.subrecordId"),selectedRec);
        }

        //alert("contact"+selectedRec);    
            if(selectedRec !=null){
                //cmp.set( "v.currentId", selectedRec);  
               //cmp.set( "v.accountId", selectedRec);  
                // alert(selectedRec);
                //var isAccount = selectedRec.startsWith('001');
                //cmp.set("v.isAccountOrOrg",isAccount);  
                //helper.loadOrgorAccountData(cmp);  
                var action = cmp.get("c.getContactData");
                action.setParams({InputData : JSON.stringify(cmp.get("v.subrecordId"))}) ;
                action.setCallback(this, function(response){
                    var state = response.getState(); 
                    //alert("Inside"+state);
                    
                    
                    if (state === "SUCCESS") {        
                        var returnData = response.getReturnValue();
                        cmp.set("v.contactList", returnData.contactList);
                        cmp.set("v.countContact", returnData.countContact);
                        cmp.set("v.recentContact", returnData.recentContact);
                        
                    }
                });
                $A.enqueueAction(action);
            }
    }
})