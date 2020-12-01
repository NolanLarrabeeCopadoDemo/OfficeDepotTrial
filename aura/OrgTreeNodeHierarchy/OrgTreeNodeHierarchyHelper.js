// Fetches the details from the controller and return to component
({
    getAccountHierarchy:function(component){
        
        //var action = component.get("c.getAccountJSON");
        var action = component.get("c.getOrgHierarchyImage");         
        //action.setParams({ OrgId : 'a2v1k000000KYA9' }); 
       var superId  = component.get("v.subrecordId");
        
        
        
        
       var subaccountId  = component.get("v.subaccountId");
        if(!$A.util.isEmpty(subaccountId)){
            if (subaccountId.length == 15) {
                var s = "";
                for (var i = 0; i < 3; i++) {
                    var f = 0;
                    for (var j = 0; j < 5; j++) {
                        var c = subaccountId.charAt(i * 5 + j);
                        if (c >= "A" && c <= "Z")
                            f += 1 << j;
                    }
                    s += "ABCDEFGHIJKLMNOPQRSTUVWXYZ012345".charAt(f);
                }
                subaccountId= subaccountId+s;
            } 
        }
        //console.log('superId doInit........'+superId);
        if (superId.length == 15) {
		var s = "";
		for (var i = 0; i < 3; i++) {
			var f = 0;
			for (var j = 0; j < 5; j++) {
				var c = superId.charAt(i * 5 + j);
				if (c >= "A" && c <= "Z")
					f += 1 << j;
			}
			s += "ABCDEFGHIJKLMNOPQRSTUVWXYZ012345".charAt(f);
		}
           superId= superId+s;
            
                        
            if($A.util.isEmpty(subaccountId)){
                component.set("v.subrecordId",superId);
            }else{
                component.set("v.subrecordId",subaccountId+'-'+superId);
            }
		
        }  
       
        
        
       action.setParams({ OrgId : superId });
         
        action.setCallback(this, function(response) {
            var state = response.getState();
                        //alert("Inside Helper Main"+state);
            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //alert("Response"+response.getReturnValue());
                component.set("v.accounts", response.getReturnValue());
                alert("hereAccHier"+component.get("v.accounts"));

            }
            else {
                console.log("No accounts retrieved with state :" + state);
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    
    
    getAccountHierarchyOD : function(component) {  
        
            //alert("inside here getAccountHierarchyOD");

            var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
       // var spinner = cmp.find("spnr");
        
         var superId  = component.get("v.idEvent");
        console.log('superId........'+superId);
               ///alert("superId"+superId);

         var checkCmpProspect = component.get("v.chkProspectEvent");
        ////alert("checkCmpProspect"+checkCmpProspect);
         var checkCmpCustomer = component.get("v.chkCustomerEvent");
         var checkCmpSite = component.get("v.chkSiteEvent");
         var checkCmpOrphan = component.get("v.chkOrphanEvent");
           var action = component.get("c.getOrgHierarchyODImage");  
           action.setParams({ OrgId : superId ,
                                    ProspectSelect : checkCmpProspect,
                                    CustomerSelect : checkCmpCustomer,
                                    SiteSelect : checkCmpSite,
                                    OrphanSelect : checkCmpOrphan
                       
                        });
                 /////alert("Inside Helper"+component.get("v.subrecordId"));

       // action.setParams({ OrgId : 'a2v1k0000008uumAAA' });  
        action.setCallback(this, function(response) { 
            var state = response.getState(); 
     ////alert("state"+state);
            if (state === "SUCCESS") {
                 console.log('response.getReturnValue()...........'+response.getReturnValue());
                 var orgHierarchyVal = response.getReturnValue();
                if(!$A.util.isEmpty(orgHierarchyVal)){
                component.set("v.accounts", response.getReturnValue());
                    var spinner = component.find("mySpinner");
        $A.util.addClass(spinner, "slds-hide");
                   // $A.util.toggleClass(spinner, "slds-hide");
                }else{
                     component.set( "v.items", '');
                    var spinner = component.find("mySpinner");
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
    } ,
    
    
    
        getAccountHierarchyInit:function(component){
        /////alert("hereeeeeeeeeeee");
        //var action = component.get("c.getAccountJSON");
        var action = component.get("c.getOrgHierarchyODImage");         
        //action.setParams({ OrgId : 'a2v1k000000KYA9' }); 
       var superId  = component.get("v.subrecordId");
       var subaccountId  = component.get("v.subaccountId");
        if(!$A.util.isEmpty(subaccountId)){
            if (subaccountId.length == 15) {
                var s = "";
                for (var i = 0; i < 3; i++) {
                    var f = 0;
                    for (var j = 0; j < 5; j++) {
                        var c = subaccountId.charAt(i * 5 + j);
                        if (c >= "A" && c <= "Z")
                            f += 1 << j;
                    }
                    s += "ABCDEFGHIJKLMNOPQRSTUVWXYZ012345".charAt(f);
                }
                subaccountId= subaccountId+s;
            } 
        }
        //console.log('superId doInit........'+superId);
        if (superId.length == 15) {
		var s = "";
		for (var i = 0; i < 3; i++) {
			var f = 0;
			for (var j = 0; j < 5; j++) {
				var c = superId.charAt(i * 5 + j);
				if (c >= "A" && c <= "Z")
					f += 1 << j;
			}
			s += "ABCDEFGHIJKLMNOPQRSTUVWXYZ012345".charAt(f);
		}
           superId= superId+s;
            if($A.util.isEmpty(subaccountId)){
                component.set("v.subrecordId",superId);
            }else{
                component.set("v.subrecordId",subaccountId+'-'+superId);
            }
		
        }  
            


var checkCmpProspect=false;
var checkCmpCustomer=true;
var checkCmpSite=false;
var checkCmpOrphan=false;


                  action.setParams({ OrgId : superId ,
                                    ProspectSelect : checkCmpProspect,
                                    CustomerSelect : checkCmpCustomer,
                                    SiteSelect : checkCmpSite,
                                    OrphanSelect : checkCmpOrphan
                       
                        });
    
        action.setCallback(this, function(response) {
            var state = response.getState();
                            //alert("Inside Helper Main"+response.getReturnValue());

            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //alert("Response"+response.getReturnValue());
                component.set("v.accounts", response.getReturnValue());
                //alert("here"+component.get("v.accounts"));

            }
            else {
                console.log("No accounts retrieved with state :" + state);
            }
        });
        
        $A.enqueueAction(action);
    },
    
            getAccountHierarchyAll:function(component){
        
        //var action = component.get("c.getAccountJSON");
        var action = component.get("c.getOrgHierarchyODImage");         
        //action.setParams({ OrgId : 'a2v1k000000KYA9' }); 
       var superId  = component.get("v.subrecordId");
       var subaccountId  = component.get("v.subaccountId");
        if(!$A.util.isEmpty(subaccountId)){
            if (subaccountId.length == 15) {
                var s = "";
                for (var i = 0; i < 3; i++) {
                    var f = 0;
                    for (var j = 0; j < 5; j++) {
                        var c = subaccountId.charAt(i * 5 + j);
                        if (c >= "A" && c <= "Z")
                            f += 1 << j;
                    }
                    s += "ABCDEFGHIJKLMNOPQRSTUVWXYZ012345".charAt(f);
                }
                subaccountId= subaccountId+s;
            } 
        }
        //console.log('superId doInit........'+superId);
        if (superId.length == 15) {
		var s = "";
		for (var i = 0; i < 3; i++) {
			var f = 0;
			for (var j = 0; j < 5; j++) {
				var c = superId.charAt(i * 5 + j);
				if (c >= "A" && c <= "Z")
					f += 1 << j;
			}
			s += "ABCDEFGHIJKLMNOPQRSTUVWXYZ012345".charAt(f);
		}
           superId= superId+s;
            if($A.util.isEmpty(subaccountId)){
                component.set("v.subrecordId",superId);
            }else{
                component.set("v.subrecordId",subaccountId+'-'+superId);
            }
		
        }  
            


var checkCmpProspect=true;
var checkCmpCustomer=true;
var checkCmpSite=true;
var checkCmpOrphan=true;


                  action.setParams({ OrgId : superId ,
                                    ProspectSelect : checkCmpProspect,
                                    CustomerSelect : checkCmpCustomer,
                                    SiteSelect : checkCmpSite,
                                    OrphanSelect : checkCmpOrphan
                       
                        });

        action.setCallback(this, function(response) {
            var state = response.getState();
                            //alert("Inside Helper Main"+state);

            if (state === "SUCCESS") {
                console.log(response.getReturnValue());
                //alert("Response"+response.getReturnValue());
                component.set("v.accounts", response.getReturnValue());
                //alert("here"+component.get("v.accounts"));

            }
            else {
                console.log("No accounts retrieved with state :" + state);
            }
        });
        
        $A.enqueueAction(action);
    }

    

 
    
    
    
})