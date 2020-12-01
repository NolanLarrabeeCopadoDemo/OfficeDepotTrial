({
  // Fetch the accounts from the Apex controller
  getAccountInfo: function(component) {
    var action = component.get('c.getAccount');
       var spinner = component.find("spnr");
      var superId = component.get("v.subrecordId");
      action.setParams({AcctId:  superId
 });
//action.setParams({ OrgId : 'a2v1k0000008uumAAA' });
    // Set up the callback
    var self = this;
        action.setCallback(this, function(response) { 
            var state = response.getState(); 
            if (state === "SUCCESS") {
                 console.log('response.getReturnValue()...........'+response.getReturnValue().Org__c);
                 component.set('v.acct', response.getReturnValue());
                component.set('v.org', response.getReturnValue().Org__c);
                component.set('v.oid', response.getReturnValue().Org__c);
                
             
               // component.set( "v.items", response.getReturnValue());
                $A.util.toggleClass(spinner, "slds-hide");
            }  else{
                $A.util.toggleClass(spinner, "slds-hide");
                console.log("No accounts retrieved with state :" + state);
            }
             component.set('v.ind', true);
        }
 );
    $A.enqueueAction(action);
  },
     getAccountIds: function(component) {
    var action = component.get('c.getAccid');
       var spinner = component.find("spnr");
      var superId = component.get("v.subrecordId");
      action.setParams({AcctId:  superId
 });
//action.setParams({ OrgId : 'a2v1k0000008uumAAA' });
    // Set up the callback
    var self = this;
        action.setCallback(this, function(response) { 
            var state = response.getState(); 
            if (state === "SUCCESS") {
                 console.log('response.getReturnValue()...........new'+response.getReturnValue());
                 component.set('v.ListAcct', response.getReturnValue());
                //component.set('v.org', response.getReturnValue().Org__c);
               // component.set('v.oid', response.getReturnValue().Org__c);
                //alert("here"+component.get("v.ListAcct"));
             
               // component.set( "v.items", response.getReturnValue());
                $A.util.toggleClass(spinner, "slds-hide");
            }  else{
                $A.util.toggleClass(spinner, "slds-hide");
                console.log("No accounts retrieved with state :" + state);
            }
            // component.set('v.ind', true);
        }
 );
    $A.enqueueAction(action);
  },
     handleActive: function (cmp, event) {
      
      var tab = event.getSource();
         var tabId = tab.get('v.id');
        if(tabId == undefined){
             tabId = 'org' ;       
        }
   
        switch (tabId) {
            case 'org' :
             // var selectedRec = 'a2v1k0000008uumAAA'; 
           var selectedRec = cmp.get('v.oid'); 
                //alert(selectedRec);
        var childComponentAccts = cmp.find('childAccounts');
        childComponentAccts.reInitCustomer(selectedRec);        
        var childComponentContact = cmp.find('childContact');
        childComponentContact.reInitContact(selectedRec);
        var childComponentOpp = cmp.find('childOpp');
        childComponentOpp.reInitOpp(selectedRec);
        var childComponentTask = cmp.find('childTask');
        childComponentTask.reInitTask(selectedRec);
        var childComponentCase = cmp.find('childCase');
        childComponentCase.reInitCase(selectedRec);
        var childComponentRep = cmp.find('childRep');
        childComponentRep.reInitRepresent(selectedRec);
        var childComponentSite = cmp.find('childSite');
        childComponentSite.reInitSite(selectedRec);
        var childComponentSales = cmp.find('childSales');
        childComponentSales.reInitSales(selectedRec);
        //var childComponentAcc = cmp.find('childAcc');
       // childComponentAcc.reInitAcc(selectedRec);
        var childComponentContract = cmp.find('childContract');
        childComponentContract.reInitContract(selectedRec);
        var childComponentNote = cmp.find('childNote');
        childComponentNote.reInitNote(selectedRec);
        var childComponentPricing = cmp.find('childPricing');
        childComponentPricing.reInitPricing(selectedRec);
        var childComponentCustomer = cmp.find('childCustomer');
        childComponentCustomer.reInitCustomer(selectedRec);
                break;
            case 'dml' : 
                   var selectedRec = cmp.get("v.ListAcct"); 
                //alert("here"+selectedRec);
                 var selectedRec1 = cmp.get("v.subrecordId"); 
                //alert("herenew"+selectedRec1);
               /*   var childComponentDML = cmp.find('childDml');
        childComponentDML.reInitAccDML(selectedRec);
                
                var childComponentDMLs = cmp.find('childDmls');
        childComponentDMLs.reInitAccDMLs(selectedRec);*/
                var childComponentDMLRec = cmp.find('childDMLRec');
        childComponentDMLRec.reInitDMLAcc(selectedRec1); 
                
                 var childComponentDMLAcc = cmp.find('childDmlAcc');
        childComponentDMLAcc.reInitAccDMLAcc(selectedRec);
                
                 var childComponentDMLCon = cmp.find('childContacts');
        childComponentDMLCon.reInitContacts(selectedRec);
                
                  var childComponentDMLOpps= cmp.find('childOpps');
        childComponentDMLOpps.reInitOpps(selectedRec);
                
                       
                  var childComponentDMLcases= cmp.find('childCases');
        childComponentDMLcases.reInitCases(selectedRec);
                
                var childComponentDMLtasks= cmp.find('childTasks');
        childComponentDMLtasks.reInitTasks(selectedRec);
                
                      var childComponentDMLsites= cmp.find('childSites');
        childComponentDMLsites.reInitSites(selectedRec);
                
                   var childComponentDMLsals= cmp.find('childSaless');
        childComponentDMLsals.reInitSaless(selectedRec1);
                
                           var childComponentDMLcontracts= cmp.find('childcontracts');
        childComponentDMLcontracts.reInitContracts(selectedRec);
                
                   var childComponentDMLnotes= cmp.find('childnotes');
        childComponentDMLnotes.reInitNotes(selectedRec);
                
                var childComponentDMLprices= cmp.find('childprices');
        childComponentDMLprices.reInitPricings(selectedRec);
                
                
                
                     var childComponentDMLcusdetails= cmp.find('childcusdetails');
        childComponentDMLcusdetails.reInitCustomers(selectedRec);
                
                            var childComponentDMLrep= cmp.find('childreps');
        childComponentDMLrep.reInitRepresents(selectedRec);
                
              //  this.injectComponent('lightningcomponentdemo:exampleRegularButtons', tab);
                break;
           
        }
    },
    handleSelect :function (cmp, event) {
          
      //  cmp.set( "v.showOrgDetails",true);
      //  var selectedRec = event.getParam('name');  
     //   cmp.set( "v.currentIdVal", selectedRec); 
        //alert("inside handleselect"+selectedRec);
 var selectedRec = event.getParam('name'); 
          var childComponentContact = cmp.find('childContact');
       childComponentContact.reInitContact(selectedRec);
          
        var childComponentContact = cmp.find('childContact');
        childComponentContact.reInitContact(selectedRec);
        var childComponentOpp = cmp.find('childOpp');
        childComponentOpp.reInitOpp(selectedRec);
        var childComponentTask = cmp.find('childTask');
        childComponentTask.reInitTask(selectedRec);
        var childComponentCase = cmp.find('childCase');
        childComponentCase.reInitCase(selectedRec);
        var childComponentRep = cmp.find('childRep');
        childComponentRep.reInitRepresent(selectedRec);
        var childComponentSite = cmp.find('childSite');
        childComponentSite.reInitSite(selectedRec);
        var childComponentSales = cmp.find('childSales');
        childComponentSales.reInitSales(selectedRec);
       // var childComponentAcc = cmp.find('childAcc');
     //   childComponentAcc.reInitAcc(selectedRec);
        var childComponentContract = cmp.find('childContract');
        childComponentContract.reInitContract(selectedRec);
        var childComponentNote = cmp.find('childNote');
        childComponentNote.reInitNote(selectedRec);
        var childComponentPricing = cmp.find('childPricing');
        childComponentPricing.reInitPricing(selectedRec);
        var childComponentCustomer = cmp.find('childCustomer');
        childComponentCustomer.reInitCustomer(selectedRec);
        
    /*       var childComponentDML = cmp.find('childDml');
        childComponentDML.reInitAccDML(selectedRec);
        
         var childComponentDMLs = cmp.find('childDmls');
        childComponentDMLs.reInitAccDMLs(selectedRec);*/
            var childComponentCustomer = cmp.find('childCustomer');
        childComponentCustomer.reInitCustomer(selectedRec);
        var childComponentDMLAcc = cmp.find('childDmlAcc');
        childComponentDMLAcc.reInitAccDMLAcc(selectedRec);
        
                 var childComponentDMLCon = cmp.find('childContacts');
        childComponentDMLCon.reInitContacts(selectedRec);
                
                  var childComponentDMLOpps= cmp.find('childOpps');
        childComponentDMLOpps.reInitOpps(selectedRec);
                var childComponentDMLcases= cmp.find('childCases');
        childComponentDMLcases.reInitCases(selectedRec);
                
                var childComponentDMLtasks= cmp.find('childTasks');
        childComponentDMLtasks.reInitTasks(selectedRec);
                
                      var childComponentDMLsites= cmp.find('childSites');
        childComponentDMLsites.reInitSites(selectedRec);
                
                   var childComponentDMLsals= cmp.find('childSaless');
        childComponentDMLsals.reInitSaless(selectedRec);
        
           var childComponentDMLcontracts= cmp.find('childcontracts');
        childComponentDMLcontracts.reInitContracts(selectedRec);
        
          var childComponentDMLnotes= cmp.find('childnotes');
        childComponentDMLnotes.reInitNotes(selectedRec);	
        
           var childComponentDMLprices= cmp.find('childprices');
        childComponentDMLprices.reInitPricings(selectedRec);
                    
                   
        
              var childComponentDMLcusdetails= cmp.find('childcusdetails');
        childComponentDMLcusdetails.reInitCustomers(selectedRec);
        
             var childComponentDMLrep= cmp.find('childreps');
        childComponentDMLrep.reInitRepresents(selectedRec);
           var childComponentDMLRec = cmp.find('childDMLRec');
        childComponentDMLRec.reInitDMLAcc(selectedRec); 
        
    },
    injectComponent: function (name, target) {
        $A.createComponent(name, {
            // no attrs
        }, function (contentComponent, status, error) {
            if (status === "SUCCESS") {
                target.set('v.body', contentComponent);
            } else {
                throw new Error(error);
            }
        });
    }
})