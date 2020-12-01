({  

    doAction : function(cmp, event,helper) { 
        //alert("inside");
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
                
               selectedRec=selectedRec.substring(0,18) ;  
                //alert(selectedRec);
                cmp.set( "v.currentId", selectedRec);  
                cmp.set( "v.accountId", selectedRec);  
                // alert(selectedRec);
                var isAccount = selectedRec.startsWith('001');
                cmp.set("v.isAccountOrOrg",isAccount);  
            }          
                    
            
        }
       
})