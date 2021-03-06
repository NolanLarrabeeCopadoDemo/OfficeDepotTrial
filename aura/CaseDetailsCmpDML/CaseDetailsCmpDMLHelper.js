({
    loadCaseData : function(cmp,event) {
        var params = event.getParam('arguments');  
        var selectedRec;
        if (params) {           
            selectedRec = params.param1;
            //alert("selectedRec case "+selectedRec);
            cmp.set(("v.subrecordId"),selectedRec);
        }
        
            
            if(selectedRec !=null){
                //cmp.set( "v.currentId", selectedRec);  
                //cmp.set( "v.accountId", selectedRec);  
                // alert(selectedRec);
                //var isAccount = selectedRec.startsWith('001');
                //cmp.set("v.isAccountOrOrg",isAccount);  
                //helper.loadOrgorAccountData(cmp);  
                var action = cmp.get("c.getCaseData");
                action.setParams({InputData : JSON.stringify(cmp.get("v.subrecordId"))}) ;
                action.setCallback(this, function(response){
                    var state = response.getState();               
                    
                    if (state === "SUCCESS") {        
                        var returnData = response.getReturnValue();
                        var rows = returnData.caseList;
                        for (var i = 0; i < rows.length; i++) {
                            var row = rows[i];
                            if (row.Owner) row.OwnerName = row.Owner.Name;
                            //if (row.Recordtype) row.RTName = row.RecordType.Name;
                        }
                        cmp.set("v.caseList", rows);
                        cmp.set("v.recentCase", returnData.recentCase);
                        cmp.set("v.countCase", returnData.countCase);
                        
                        
                    }
                });
                $A.enqueueAction(action);
            }
    }
})