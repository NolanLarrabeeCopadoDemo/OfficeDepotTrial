({  
	doInit: function (cmp, event, helper) {  
        
        
        
        console.log("Test hierarchy->>"+JSON.stringify(cmp.get("v.recordId")));
        console.log("test-->"+JSON.stringify(cmp.get("v.fields").Org__c));
        if(cmp.get("v.fields").Org__c !=null && cmp.get("v.fields").Org__c !='' && cmp.get("v.fields").Org__c != undefined){
            var accId; 
            var siteId= cmp.get("v.fields").Related_Account_Id__c; 
            if(siteId='') 
            {
                accId=siteId; 
            }
            else{
                accId=cmp.get("v.fields").Id;
            } 
            
            cmp.set("v.subrecordId",cmp.get("v.fields").Org__c);
            cmp.set("v.subaccountId",accId);
            cmp.set("v.isDataLoaded",true);
        }
         else{
             
             var toastEvent = $A.get("e.force:showToast");
             toastEvent.setParams({
                 
                 "message": "There is No Org associated"
             });
             toastEvent.fire();
             
             var dismissActionPanel = $A.get("e.force:closeQuickAction");
             dismissActionPanel.fire();

				
			}
        
        
        
    	var checkCmp = cmp.find("checkbox");
        ////////////checkCmp.set("v.value",true);
        //
        //
        //
        checkCmp.set("v.value",false);

        
        var checkCmpProspect = cmp.find("checkboxProspect");
        checkCmpProspect.set("v.value",false);
        var checkCmpCustomer = cmp.find("checkboxCustomer");
        checkCmpCustomer.set("v.value",true);
        var checkCmpSite = cmp.find("checkboxSite");
        checkCmpSite.set("v.value",false);
        var checkCmpOrphan = cmp.find("checkboxOrphan");
        checkCmpOrphan.set("v.value",false);
        
        
        //helper.doInit(cmp);
        $A.enqueueAction(cmp.get('c.handleSelect'));  
    }, 
    
    
    updateTreeNew: function(component, event) {
        //alert("inside updateTreeNew");
        //var id= event.target.id;
        var checkCmp1 = component.find("checkbox");
        var checkCmp=checkCmp1.get("v.value");
        var checkCmpProspect1 = component.find("checkboxProspect");
        var checkCmpProspect=checkCmpProspect1.get("v.value");
        var checkCmpCustomer1 = component.find("checkboxCustomer");
        var checkCmpCustomer=checkCmpCustomer1.get("v.value");
        var checkCmpSite1 = component.find("checkboxSite");
        var checkCmpSite=checkCmpSite1.get("v.value");
        
        var checkCmpOrphan1 = component.find("checkboxOrphan");
        var checkCmpOrphan=checkCmpOrphan1.get("v.value");
        var superId  = component.get("v.subrecordId");
        var evt = $A.get("e.c:HandleSelectEvent");
        // var evt = component.getEvent("ResultData");
        // alert("inside updateTreeNew"+checkCmpCustomer);
        
        evt.setParams({
            recordId : superId,
            chkAll : checkCmp,
            chkCustomer : checkCmpCustomer,
            chkProspect : checkCmpProspect,
            chkSite : checkCmpSite,
            chkOrphan : checkCmpOrphan
        });
        evt.fire();
        //alert("After fire");
    },
    
    updateTree: function (cmp, event, helper) { 
        
        ///alert("here fire");
        
        var checkCmp = cmp.find("checkbox");
        var checkCmpProspect = cmp.find("checkboxProspect");
        var checkCmpCustomer = cmp.find("checkboxCustomer");
        var checkCmpSite = cmp.find("checkboxSite");
        
        var checkCmpOrphan = cmp.find("checkboxOrphan");
        
        // cmp.set( "v.updateFlag",checkCmp.get("v.value"));
        if(
            
            (checkCmpProspect.get("v.value")==false  &&
             checkCmpCustomer.get("v.value")==false  &&                
             checkCmpSite.get("v.value")==false  &&
             checkCmpOrphan.get("v.value")==false  && checkCmp.get("v.value")==true
            )){
            cmp.set( "v.showOrgDetails",false);
            helper.doInit(cmp);           
            
        }
        
        
        else if(
            
            (checkCmpProspect.get("v.value")==false  ||
             checkCmpCustomer.get("v.value")==false  ||                
             checkCmpSite.get("v.value")==false  ||
             checkCmpOrphan.get("v.value")==false
            )
            
        ){
            cmp.set( "v.showOrgDetails",false);
            helper.doInitOD(cmp);  
        }
            else{
                cmp.set( "v.showOrgDetails",false);
                helper.doInit(cmp);  
            }
        
        
        //alert("hi"+checkCmp.get("v.value"));
    },
    
    handleSelect: function (cmp, event, helper) { 
        var selectedRec;
        var selectedAccId = cmp.get("v.subaccountId");
        console.log('selectedAccId....'+selectedAccId);
        if(event != undefined){
            selectedRec = event.getParam('id');  
        }else{
            if($A.util.isEmpty(selectedAccId)){
                selectedRec = cmp.get("v.subrecordId");
            }else{
                selectedRec = selectedAccId;
                //cmp.set("v.subrecordId",selectedRec);
            }
            
        }
        
        cmp.set( "v.showOrgDetails",true);
        cmp.set( "v.currentIdVal", selectedRec); 
        //alert("inside handleselect3"+selectedRec);
        
        
        var selectedRec1=selectedRec.substring(0,18) ;  
        var isAccount = selectedRec.startsWith('001');
        //alert(isAccount);
        
        if(isAccount==false)
            cmp.set("v.showForm",true);  
        else
            cmp.set("v.showForm",false); 
        
        
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
        var childComponentAcc = cmp.find('childAcc');
        childComponentAcc.reInitAcc(selectedRec);
        var childComponentContract = cmp.find('childContract');
        childComponentContract.reInitContract(selectedRec);
        var childComponentNote = cmp.find('childNote');
        childComponentNote.reInitNote(selectedRec);
        var childComponentPricing = cmp.find('childPricing');
        childComponentPricing.reInitPricing(selectedRec);
        var childComponentCustomer = cmp.find('childCustomer');
        childComponentCustomer.reInitCustomer(selectedRec);
        var childComponentDML = cmp.find('childAccDML');
        childComponentDML.reInitAccDML(selectedRec);
        
        
        
        //var childComponentRelated = cmp.find('childAccRelated');
        //childComponentRelated.reInitAccRelated(selectedRec);
        //alert(document.getElementById(selectedRec));
    } 
    
})