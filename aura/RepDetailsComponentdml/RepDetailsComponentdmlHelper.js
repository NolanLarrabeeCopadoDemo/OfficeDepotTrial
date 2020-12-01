({
    loadRepData : function(cmp,event) {
        var params = event.getParam('arguments');  
        var selectedRec;
        if (params) {           
            selectedRec = params.param1;
            //cmp.set(("v.subrecordId"),selectedRec);
        }
            
            if(selectedRec !=null){
               // cmp.set( "v.currentId", selectedRec);  
               // cmp.set( "v.accountId", selectedRec);  
                // alert(selectedRec);
                //var isAccount = selectedRec.startsWith('001');
                //cmp.set("v.isAccountOrOrg",isAccount);  
                //helper.loadOrgorAccountData(cmp);  
                var action = cmp.get("c.getRepData");
                action.setParams({InputData : JSON.stringify(selectedRec)}) ;
                action.setCallback(this, function(response){
                    var state = response.getState(); 
                    //alert("Inside"+state);
                    
                    
                    if (state === "SUCCESS") {        
                        var returnData = response.getReturnValue();
                        cmp.set("v.salesRepList", returnData.salesRepList);
                        cmp.set("v.countRep", returnData.countRep);
                        cmp.set("v.recentRep", returnData.recentRep);
                        
                    }
                });
                $A.enqueueAction(action);
            }
    }
})