({
    loadCustomerData : function(cmp,event) {
                //alert("here");

        var params = event.getParam('arguments');  
        var selectedRec;
        if (params) {           
            selectedRec = params.param1;
        }
       
                  // alert("here"+selectedRec);
 
            if(selectedRec !=null){
                //cmp.set( "v.currentId", selectedRec);  
               // cmp.set( "v.accountId", selectedRec);  
                // alert(selectedRec);
                //var isAccount = selectedRec.startsWith('001');
                //cmp.set("v.isAccountOrOrg",isAccount);  
                //helper.loadOrgorAccountData(cmp);  
                var action = cmp.get("c.getDMLData");
                action.setParams({InputData :JSON.stringify(selectedRec)}) ;
                action.setCallback(this, function(response){
                    var state = response.getState(); 
                  //  alert("Inside"+state);
                    
                    
                    if (state === "SUCCESS") {        
                        var returnData = response.getReturnValue();
                        //alert(returnData.DMLList);
                        cmp.set("v.customerList", returnData.customerList);
               //      var    listOfData =returnData.DMLList;
                      //  for (var key in listOfData) {
                           // console.log(key, listOfData[key]);
                    //    }
                        //var jsonOfList=JSON.stringify(listOfData);
                      // console.log("jsonOfList"+jsonOfList);
                      //  var idList=JSON.parse(jsonOfList);
                      //  console.log("idList"+idList);
                       // console.log("idList"+idList[0].id);
                        
                       // cmp.set("v.countCustomer", returnData.countCustomer);
                     //   cmp.set("v.recentCustomer", returnData.recentCustomer);
                    }
                });
                $A.enqueueAction(action);
            }
    }
})