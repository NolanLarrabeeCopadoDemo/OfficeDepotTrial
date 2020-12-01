({
    // Function calls the getAccountHierarchy function in Helper.js
    doInit : function(component, event, helper) {
        //////helper.getAccountHierarchy(component);
        
                helper.getAccountHierarchyInit(component);

        
        
    },
    // Function calls the getAccountHierarchy function in Helper.js
    filterData : function(component, event, helper) {
                 //alert("inside filterData");

                var selectedRec = event.getParam('recordId'); 
                var checkCmp=event.getParam('chkAll');
                var checkCmpCustomer = event.getParam('chkCustomer');  
                var checkCmpSite = event.getParam('chkSite');  
                var checkCmpOrphan = event.getParam('chkOrphan');  
                var checkCmpProspect = event.getParam('chkProspect');  

        
              // alert("inside checkCmpProspect"+checkCmpProspect);
               //alert("inside checkCmpSite"+checkCmpSite);

               //alert("inside checkCmpOrphan"+checkCmpOrphan);
               //alert("inside checkCmpCustomer"+checkCmpCustomer);


                     component.set("v.idEvent", selectedRec);
                     component.set("v.chkAllEvent", checkCmp);
                     component.set("v.chkCustomerEvent", checkCmpCustomer);
                     component.set("v.chkSiteEvent", checkCmpSite);
                     component.set("v.chkOrphanEvent", checkCmpOrphan);
                     component.set("v.chkProspectEvent", checkCmpProspect);

        

             if(

       (
           /*checkCmpProspect==false  &&
       checkCmpCustomer==false  &&                
       checkCmpSite==false  &&
       checkCmpOrphan==false  &&*/
        checkCmp==true
       )){
        //cmp.set( "v.showOrgDetails",false);
        helper.getAccountHierarchyAll(component);                   
        }
              
       else if(

       (checkCmpProspect==false  ||
       checkCmpCustomer==false  ||                
       checkCmpSite==false  ||
       checkCmpOrphan==false
       )

        ){
         /////alert("inside here1111111");

        // cmp.set( "v.showOrgDetails",false);
        helper.getAccountHierarchyOD(component);
        }
        else{
        ///    alert('&&&&&&&Inside');
           // cmp.set( "v.showOrgDetails",false);
        helper.getAccountHierarchyOD(component);                   
        }
                                 
    },
    // Dsiplays the selected account name
    showResult : function(component, event, helper) {
        var accName= event.getParam("name");
        var accId=event.getParam("id");
        console.log("accId"+accId);
        component.set("v.id", accId);
        console.log("accName"+accName);
        component.set("v.name", accName);
    },
})