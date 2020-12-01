({  
    doInit : function(cmp) {  
        
         var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        //alert("Inside Helper");
        var action = cmp.get("c.getOrgHierarchy");  
        //var spinner = cmp.find("spnr");
        
        var superId  = cmp.get("v.subrecordId");
        console.log('superId doInit........'+superId);
       action.setParams({ OrgId : superId });
       // action.setParams({ OrgId : 'a2v1k0000008uumAAA' });  
        action.setCallback(this, function(response) { 
            var state = response.getState(); 
            if (state === "SUCCESS") {
                 console.log('response.getReturnValue()...........'+response.getReturnValue());
                cmp.set( "v.items", response.getReturnValue());
                 var spinner = cmp.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
                //$A.util.toggleClass(spinner, "slds-hide");
            }  else{
                //$A.util.toggleClass(spinner, "slds-hide");
                console.log("No accounts retrieved with state :" + state);
            }
        });  
        $A.enqueueAction(action);
    } ,
    
        doInitOD : function(cmp) {  
            var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        var action = cmp.get("c.getOrgHierarchyOD");  
       // var spinner = cmp.find("spnr");
        
          var superId  = cmp.get("v.subrecordId");
        console.log('superId........'+superId);
         var checkCmpProspect = cmp.find("checkboxProspect");
         var checkCmpCustomer = cmp.find("checkboxCustomer");
         var checkCmpSite = cmp.find("checkboxSite");
         var checkCmpOrphan = cmp.find("checkboxOrphan");
       action.setParams({ OrgId : superId ,
                                    ProspectSelect : checkCmpProspect.get("v.value"),
                                    CustomerSelect : checkCmpCustomer.get("v.value"),
                                    SiteSelect : checkCmpSite.get("v.value"),
                                    OrphanSelect : checkCmpOrphan.get("v.value")
                       
                        });
                    //alert("Inside Helper"+cmp.get("v.subrecordId"));

       // action.setParams({ OrgId : 'a2v1k0000008uumAAA' });  
        action.setCallback(this, function(response) { 
            var state = response.getState(); 
           // alert("state"+state);
            if (state === "SUCCESS") {
                 console.log('response.getReturnValue()...........'+response.getReturnValue());
                 var orgHierarchyVal = response.getReturnValue();
                if(!$A.util.isEmpty(orgHierarchyVal)){
                    cmp.set( "v.items", response.getReturnValue());
                    var spinner = cmp.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
                   // $A.util.toggleClass(spinner, "slds-hide");
                }else{
                     cmp.set( "v.items", '');
                    var spinner = cmp.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
                    //$A.util.toggleClass(spinner, "slds-hide");
                }
                
                           // alert("Response"+response.getReturnValue());

                
            }  else{
               // $A.util.toggleClass(spinner, "slds-hide");
                console.log("No accounts retrieved with state :" + state);
            }
        });  
        $A.enqueueAction(action);
    } 

})