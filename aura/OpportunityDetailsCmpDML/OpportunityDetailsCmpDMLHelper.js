({
    loadOpportunityData : function(cmp,event) {
        var params = event.getParam('arguments');  
        var selectedRec;
        if (params) {           
            selectedRec = params.param1;
             //alert("selectedRec opp "+selectedRec);
            cmp.set(("v.subrecordId"),selectedRec);
        }

            
            if(selectedRec !=null){
                //cmp.set( "v.currentId", selectedRec);  
                //cmp.set( "v.accountId", selectedRec);  
                // alert(selectedRec);
                //var isAccount = selectedRec.startsWith('001');
                //cmp.set("v.isAccountOrOrg",isAccount);  
                //helper.loadOrgorAccountData(cmp);  
                var action = cmp.get("c.getOpportunityData");
                action.setParams({InputData : JSON.stringify(cmp.get("v.subrecordId"))}) ;
                action.setCallback(this, function(response){
                    var state = response.getState(); 
                    //alert("Inside"+state);
                    
                    
                    if (state === "SUCCESS") {        
                        var returnData = response.getReturnValue();
                        var rows = returnData.oppList;
                        for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                            if (row.Owner) row.OwnerName = row.Owner.Name;
                            //if (row.Recordtype) row.RTName = row.RecordType.Name;
                        }
                        cmp.set("v.oppList", rows);
                        cmp.set("v.countOpportunity", returnData.countOpportunity);
                        cmp.set("v.recentOpportunity", returnData.recentOpportunity);
                        
                        
                    }
                });
                $A.enqueueAction(action);
            }
    }
})