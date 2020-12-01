({
  getAccountInfo: function(cmp,event) {
    
          var params = event.getParam('arguments');  
        var selectedRec;
        if (params) {           
            selectedRec = params.param1;
        }
        else{
           selectedRec=cmp.get("v.subrecordId") ;
            
        }
                  // alert("here"+selectedRec);
 
            if(selectedRec !=null){
                cmp.set( "v.currentId", selectedRec);  
                cmp.set( "v.accountId", selectedRec);  
               // alert(selectedRec);
               // var isAccount = selectedRec.startsWith('001');
               // cmp.set("v.isAccountOrOrg",isAccount);  
                //helper.loadOrgorAccountData(cmp);  
                var action = cmp.get("c.getdml");
                action.setParams({OrgId : selectedRec }) ;
                action.setCallback(this, function(response){
                    var state = response.getState(); 
                  //  alert("Inside"+state);
                    
                    
                    if (state === "SUCCESS") {        
                        var returnData = response.getReturnValue();
                        //alert(returnData);
                          cmp.set('v.dml',returnData);
                    }
                });
                $A.enqueueAction(action);
            }
  }
})