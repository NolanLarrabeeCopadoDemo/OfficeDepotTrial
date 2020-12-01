({
    loadDMLData : function(cmp,event) {
        var params = event.getParam('arguments');  
        var selectedRec;
        if (params) {           
            selectedRec = params.param1;
        }
        else{
           selectedRec=cmp.get("v.subrecordId") ;
            
        }
            
            if(selectedRec !=null){
                cmp.set( "v.currentId", selectedRec);  
                cmp.set( "v.accountId", selectedRec);  
                // alert(selectedRec);
                var isAccount = selectedRec.startsWith('001');
                cmp.set("v.isAccountOrOrg",isAccount);  
                //helper.loadOrgorAccountData(cmp);  
                var action = cmp.get("c.getDMLData");
                action.setParams({OrgId : cmp.get("v.currentId")}) ;
                action.setCallback(this, function(response){
                    var state = response.getState(); 
                    //alert("Inside"+state);
                    
                    
                    if (state === "SUCCESS") {        
                        var returnData = response.getReturnValue();
                        cmp.set("v.DMLList", returnData.DMLList);
                        cmp.set("v.countDML", returnData.countDML);
                        cmp.set("v.recentDML", returnData.recentDML);
                        
                    }
                });
                $A.enqueueAction(action);
            }
    }
})