({
    
    doInit: function(component, event, helper) {
        
        component.set("v.showContactInfo",true);
        
        component.set('v.OrgColumns', [
            {label: 'Org Name', fieldName: 'Business_Name__c', type: 'text'},
            {label: 'Street', fieldName: 'Address_1__c', type: 'text'},
            {label: 'City', fieldName: 'City__c', type: 'text'},
            {label: 'State', fieldName: 'State__c', type: 'text'},
            {label: 'Type', fieldName: 'Type__c', type: 'text'},
            {label: 'Web Site', fieldName: 'Website__c', type: 'text'},
            {label: 'Line Of Business', fieldName: 'LOB__c', type: 'text'},
            {label: 'DUNS Number', fieldName: 'DUNS_Number__c', type: 'text'}
            //{label: 'D&B Id', fieldName: 'D_B_ID__c', type: 'text'}
            
        ]); 
        
        var leadId = component.get("v.leadRecId");
		var onloadAction = component.get("c.onLoadData");
        onloadAction.setParams({ leadId : leadId });
        onloadAction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
            	component.set("v.currentUserInfo", result.userData);
                component.set("v.leadRec",result.leadData); 
            }
        });
        $A.enqueueAction(onloadAction);
        
        //Get onload Account Picklist values
		var accPickListAction = component.get("c.onloadAccPicklistVaues");
        accPickListAction.setParams({ leadId : leadId });
        accPickListAction.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.accDuplicatDispositionVal", result.duplicateDispositionList);
                component.set("v.accIndustryRepVal", result.industryRepList);
            }
        });
        $A.enqueueAction(accPickListAction);
        //helper.createNewOrgRecordHelper(component);
		//helper.setContactAndOppRecordTypeHelper(component);
    },
    validatePhoneNo : function(component, event, helper){       
        if((event.which < 48 || event.which > 57)){
             event.preventDefault();
        }
    }, 
    handleCheck : function(component, event, helper){
        //var isChecked = component.find("AutoAssignId").get("v.checked");
        //component.set("v.prospectRec.Auto_Assign__c", isChecked);
        console.log('Auto assign---'+component.get("v.prospectRec.Auto_Assign__c"));
    },
    handleCustSerachEvent : function(component, event, helper) {
        
        component.set("v.isAventionOrgs",false);
		component.set("v.isSfOrgs",false);
        var serachList = event.getParam("custSearchList");
        var accRec = event.getParam("prospectRec");
        // set the handler attributes based on event data
        component.set("v.showResults",true);
        component.set("v.orgRecList", '');
        if($A.util.isEmpty(serachList)){
            component.set("v.noRecs",true);
            component.set("v.disableProceedBtn",false);
        }else{
            component.set("v.orgRecList", serachList);
           var sfOrg =  serachList[0].Id;
            if(!$A.util.isEmpty(sfOrg)){
                component.set("v.isSfOrgs",true);
            }else{
                component.set("v.isAventionOrgs",true);
            }
        }
        component.set("v.prospectRec", accRec);
        helper.createNewOrgRecordHelper(component);
		helper.setContactAndOppRecordTypeHelper(component);
    },
    handleCusToProsSearchEvent : function(component, event, helper) {
        console.log('In Prospect event---');
        var serachList1 = event.getParam("custSearchList");
        var accRec = event.getParam("prospectRec");
        component.set("v.prospectRec", accRec);
        
    },
    getSelectedRecord : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set("v.selectedOrgRec",selectedRows);
        var parentOrgRec = component.get("v.selectedOrgRec");
        component.set("v.disableProceedBtn", false);
        if(parentOrgRec != null){
            component.set("v.parentOrgRec",parentOrgRec);
            //component.set("v.showReasonForDuplicate",true);
        }else{
            component.set("v.parentOrgRec",parentOrgRec);
        }
        
    },
    ProceedOrg : function(component, event, helper) {
        component.set("v.showResults",false);
        component.set("v.showDuplicateDisposition",false);//by Ramalakshmi
        var appEvent = $A.get("e.c:ProcessIndicatorEvent");
        appEvent.setParams({
            "currentStep" : "Prospect Info"});
        appEvent.fire();
        var parentOrgRec = component.get("v.selectedOrgRec");
         console.log('parentOrgRec..1..'+parentOrgRec);
        console.log('parentOrgRec....'+JSON.stringify(parentOrgRec));
        component.set("v.OrgInfoPanel",false);//by anand
        component.set("v.showDuplicateDisposition",false);
           if(!$A.util.isEmpty(parentOrgRec)){
           if (parentOrgRec[0].Business_Name__c =='None Of the Above')
           {
               parentOrgRec.length = 0;
               console.log('inside none of above');
               
           }
 
        }
        
        if(!$A.util.isEmpty(parentOrgRec)){
            var sfId = parentOrgRec[0].Id;
            var custExists = parentOrgRec[0].IsCustomerExist__c ;
            console.log('cust exists'+custExists )
            if(!$A.util.isEmpty(sfId)){
                console.log('hi---114');
                if(custExists)
                {
               		console.log('inside duplicate section');
                	component.set("v.showDuplicateDisposition",true);
                	component.set("v.OrgInfoPanel",true);
            	}
            }else{
                console.log('hi---117');
                
                // by anand
            }
        }
        if($A.util.isEmpty(parentOrgRec)){
            console.log('hi---123');
            component.set("v.createNewOrg",true);
           // component.set("v.showReasonForDuplicate",false);
            component.set("v.OrgInfoPanel",true);// by anand
        }else{
            console.log('hi---128');
            component.set("v.createNewOrg",false);
          //  component.set("v.showReasonForDuplicate",true);
        }
        component.set("v.showProspectSection",true);
        component.set("v.backToOrgResultsEnable",true);
        
        console.log('showDuplicateDisposition---from js-----'+component.get("v.showDuplicateDisposition"));
        console.log('createNewOrg---from js-----'+component.get("v.createNewOrg"));
        
        //Retain Prospect and Contact Values
        var ctRec= component.get("v.contactRec");        
        //Set value to contat for when back to Prospect Info Section
        console.log('ctRec.....'+ctRec);
        if(!$A.util.isEmpty(ctRec)){
            //component.find("ctNameId").set("v.value",component.get("v.tempContactRec").Name);
            //component.find("ctSalId").set("v.value",ctRec.Salutation);
       	component.find("ctFNameId").set("v.value",ctRec.FirstName);
        	component.find("ctLNameId").set("v.value",ctRec.LastName);
            component.find("ctTitleId").set("v.value",ctRec.Title);
            component.find("ctEmailId").set("v.value",ctRec.Email);
            component.find("ctDepartmentId").set("v.value",ctRec.Department);
            component.find("ctPhoneExtId").set("v.value",ctRec.Phone_Ext__c);
            component.find("ctPhoneRepId").set("v.value",ctRec.Phone1_Rep__c); 
            if(component.get("v.addMorePhones") == true){
                var changeElement = component.find("moreInfoDivId");
                $A.util.toggleClass(changeElement, "slds-hide");
            }
           
            component.find("ctDecisionMakerId").set("v.value",ctRec.Decision_Maker__c);
            component.find("ctPhoneType1Id").set("v.value",ctRec.Phone_Type1__c);
            component.find("ctPhone2RepId").set("v.value",ctRec.Phone2_Rep__c);
            component.find("ctPhoneType2Id").set("v.value",ctRec.Phone_Type2__c);
            component.find("ctPhone3RepId").set("v.value",ctRec.Phone3_Rep__c);
            component.find("ctPhoneType3Id").set("v.value",ctRec.Phone_Type3__c);
            component.find("ctRoleId").set("v.value",ctRec.Role__c);
            component.find("ctProductFocusId").set("v.value",ctRec.Product_Focus__c);
        }
        //Set US Prospect Information
        var usprospectRec = component.get("v.prospectRec");
         console.log('usprospectRec.Auto_Assign__c.....'+usprospectRec.Auto_Assign__c);
       if(component.get('v.accRecTypeName') == 'Prospect'){
            var leadId1 = component.get("v.leadRecId");
            component.find("prospectPhoneId").set("v.value",usprospectRec.Phone);
            component.find("prospectWebsiteid").set("v.value",usprospectRec.Website);
            component.find("prospectSectorId").set("v.value",usprospectRec.Sector__c);
            component.find("prospectWWId").set("v.value",usprospectRec.Org_WCW_Count_Rep__c);
            component.find("prospectSegmentId").set("v.value",usprospectRec.Segment__c);
            component.find("prospectEstSpendId").set("v.value",usprospectRec.Est_Spend__c);
            component.find("prospectBuyingGrpId").set("v.value",usprospectRec.Buying_Group__c);
            component.find("prospectPaymentTermId").set("v.value",usprospectRec.Payment_Term__c);
            component.find("prospectPricingTempId").set("v.value",usprospectRec.Pricing_template_cd__c);
            component.find("prospectPrimaryProductId").set("v.value",usprospectRec.Primary_Product__c);
            component.find("prospectIndustryRepId").set("v.value",usprospectRec.Industry_OD_SIC_Rep__c);
            component.find("prospectRepCallDateId").set("v.value",usprospectRec.Rep_Call_Date__c);
         if ($A.util.isEmpty(leadId1)) {
             if(usprospectRec.Auto_Assign__c == undefined || usprospectRec.Auto_Assign__c == null){
                component.find("prospectAutoAssignId").set("v.value",false); 
             }else{
               component.find("prospectAutoAssignId").set("v.value",usprospectRec.Auto_Assign__c);  
             }
            
            }
            component.find("prospectLocationtypeid").set("v.value",usprospectRec.Location_Type__c);
		} 
        if(component.get('v.accRecTypeName') == 'Prospect (GT)'){
             component.find("prospectGTPhoneId").set("v.value",usprospectRec.Phone);
             var leadId = component.get("v.leadRecId");
             if(!$A.util.isEmpty(leadId)){
            	component.find("prospectGTLocationTypeId").set("v.value",component.get("v.prospectRec.Location_Type__c"));
            	component.find("prospectGTSegmentId").set("v.value",component.get("v.prospectRec.GT_Segment__c"));
        	}
         }
    if(component.get('v.accRecTypeName') == 'Customer (Business Pro)'){
            component.find("prospectLoyatlyId").set("v.value",component.get("v.prospectRec.Loyatly_Number__c"));
        	component.find("prospectContactInitiationTypeId").set("v.value",component.get("v.prospectRec.Contact_Initiation_Type__c"));
        	component.find("prospectLeadSourceId").set("v.value",component.get("v.prospectRec.Lead_Source__c"));
        	component.find("prospectVIPCardIssueReqtId").set("v.value",component.get("v.prospectRec.VIP_Card_Issue_Reqt__c"));
        	component.find("prospectVIPCardEffectiveDateId").set("v.value",component.get("v.prospectRec.VIP_Card_Effective_Date__c"));
        	component.find("prospectVIPCardEndDateId").set("v.value",component.get("v.prospectRec.VIP_Card_End_Date__c"));
         }
        if(component.get('v.accRecTypeName') == 'Prospect (BizBox)'){
            var leadId2 = component.get("v.leadRecId");
            component.find("prospectBZRepCallDateId").set("v.value",usprospectRec.Rep_Call_Date__c);
            if ($A.util.isEmpty(leadId2)) {
            component.find("prospectBZAutoAssignId").set("v.value",usprospectRec.Auto_Assign__c);
            }
        }
        
        if(!$A.util.isEmpty(component.get("v.prospectRec.Location_Decision_Making__c"))){
           //component.find("locDecisionMakingId").set("v.value",component.get("v.prospectRec.Location_Decision_Making__c"));
        }
        var Accinfo=component.get("v.accRecinfo");
        var Orginfo=component.get("v.newOrgRec");
        Orginfo.Business_Name__c= Accinfo.Name;
        Orginfo.Address_1__c	= Accinfo.Address1__c;
        Orginfo.Address_2__c	= Accinfo.Address2__c;
        Orginfo.City__c			= Accinfo.City__c;
        Orginfo.State__c		= Accinfo.State__c;
        Orginfo.Zip__c			= Accinfo.Zip__c;
        component.set("v.newOrgRec",Orginfo);
    },
    backToOrgSearch : function(component, event, helper) {
        var  prospect= component.get("v.prospectRec");
        if(!$A.util.isEmpty(prospect))
            prospect.Duplicate_Disposition__c=null;
        
        component.set("v.noRecs",false);
        var appEvent = $A.get("e.c:ProcessIndicatorEvent");
        appEvent.setParams({
            "currentStep" : "Search Org Information"});
        appEvent.fire();
        
        var appEvent1 = $A.get("e.c:ProspectBackToCustSearchEvent");
        appEvent1.setParams({
            "backToCustSearchCmp" : true,
            "prospectRec":component.get("v.prospectRec")
            });
        appEvent1.fire();
        
        component.set("v.showResults",false);
        component.set("v.selectedOrgRec",null);
        
    },
       
    isDescisionMakingLocation : function(component, event, helper) { 
        var radioSelected = event.getParam("value");
        //var radioSelected = event.getSource().get('v.value');
        component.set("v.isDecisionLocationSelected",radioSelected);
        if(radioSelected == 'No'){
            component.set("v.createOrgbtnEnable",false);
            component.set("v.familyOrgSelected",false);
            var childComponent = component.find("familyWBRec");
            childComponent.callFamilyTree_WB(component);
        }
        if(radioSelected == 'Yes'){
            component.set("v.createOrgbtnEnable",false);
            component.set("v.createNewOrg",false);
            component.set("v.noFamilyRecs",false);
        }
        component.set("v.prospectRec.Location_Decision_Making__c",radioSelected);
    },
    /* hide by anand
    createNewOrg : function(component, event, helper) {
        component.set("v.createNewOrg",true);
    },
    */
    handleOrgFamilySearchEvent : function(component, event, helper) {
        var showCreateOrgButton = event.getParam("showCreateOrgButton");
        component.set("v.createOrgbtnEnable", showCreateOrgButton);
        component.set("v.createNewOrg",false);
        component.set("v.familyOrgSelected",true);
    },
    backToOrgResults : function(component, event, helper) {
        //by Anand
        /*var  prospect= component.get("v.prospectRec");
        if(!$A.util.isEmpty(prospect))
            prospect.Duplicate_Disposition__c=null;*/
component.set("v.disableProceedBtn",true);
     
        var appEvent = $A.get("e.c:ProcessIndicatorEvent");
        appEvent.setParams({
            "currentStep" : "Org Results"});
        appEvent.fire();
      
        //component.set("v.selectedOrgRec",null);
        var selectedOrgRec = component.get("v.selectedOrgRec");
        console.log('selectedOrgRec....'+selectedOrgRec);
        if($A.util.isEmpty(selectedOrgRec)){
            component.set("v.selectedOrgRec",null);
        }
        component.set("v.noFamilyRecs",false);
        component.set("v.showProspectSection",false);
        component.set("v.backToOrgResultsEnable",false);
        component.set("v.familyOrgSelected",false);
        component.set("v.createNewOrg",false);
        component.set("v.isDecisionLocationSelected","None");
       // component.set("v.showReasonForDuplicate",false);
        component.set("v.requiredError", false);
        //component.set("v.prospectRec.Location_Decision_Making__c",'');
        if(!$A.util.isEmpty(component.get("v.prospectRec.Location_Decision_Making__c"))){
           //component.find("locDecisionMakingId").set("v.value",component.get("v.prospectRec.Location_Decision_Making__c"));
        }
        component.set("v.showResults",true);
        var parentOrgRec = component.get("v.selectedOrgRec");
        if(!$A.util.isEmpty(parentOrgRec)){
            var sfId = parentOrgRec[0].Id;
            if(!$A.util.isEmpty(sfId)){
                var setRows = [];
                setRows.push(sfId);
                 console.log('setRows...'+setRows);
                component.set("v.selectedRows", setRows);
            }else{
                var sfDBID = parentOrgRec[0].D_B_ID__c;
                var setRows1 = [];
                setRows1.push(sfDBID);
                console.log('setRows1...'+setRows1);
                component.set("v.selectedRows", setRows1);
            }
        }
        console.log('selectedRows....'+component.get("v.selectedRows"));
        console.log('selectedRows1....'+JSON.stringify(component.get("v.selectedRows")));
    },
    showCtRequiredFields: function(component, event, helper){
        
		$A.util.removeClass(component.find("ctEmailId"), "none");
        $A.util.removeClass(component.find("ctDecisionMakerId"), "none");
        var leadInfo = component.get("v.leadRec");
        var ctRecLoad= component.get("v.contactRec");
        if(!$A.util.isEmpty(leadInfo.Name)&& $A.util.isEmpty(ctRecLoad)){
          component.find("ctEmailId").set("v.value",leadInfo.Email);
          //component.find("ctNameId").set("v.value",leadInfo.Name);
          //component.find("ctSalId").set("v.value",leadInfo.Salutation);
          component.find("ctFNameId").set("v.value",leadInfo.FirstName);
          component.find("ctLNameId").set("v.value",leadInfo.LastName);
        }
        //var ctRecLoad= component.get("v.contactRec");
        
        if(ctRecLoad != null){
          component.find("ctEmailId").set("v.value",ctRecLoad.Email);
          //component.find("ctNameId").set("v.value",ctRecLoad.Name);
          //component.find("ctSalId").set("v.value",ctRecLoad.Salutation);
          component.find("ctFNameId").set("v.value",ctRecLoad.FirstName);
          component.find("ctLNameId").set("v.value",ctRecLoad.LastName);
          //component.find("ctPhoneRepId").set("v.value",ctRecLoad.Phone);//added by Ramalakshmi
        }
        /*var tempRec = component.get("v.tempContactRec");
        if(tempRec != null){
           component.find("ctNameId").set("v.value",tempRec.Name);  
        }*/
          
	},
    showMorePhones : function(component, event, helper) {
        var changeElement = component.find("moreInfoDivId");
        $A.util.toggleClass(changeElement, "slds-hide");
        if( component.get("v.addMorePhones") == false){
            component.find("ctPhone2RepId").set("v.value",'');
        	component.find("ctPhoneType2Id").set("v.value",'');
        	component.find("ctPhone3RepId").set("v.value",'');
        	component.find("ctPhoneType3Id").set("v.value",'');
        }
    },
    setContactFields : function(component, event, helper) {
        //Contact Information
        //var ctName 			=  component.find("ctNameId").get("v.value");
        //var ctSal 			=  component.find("ctSalId").get("v.value");
        var ctFName			=  component.find("ctFNameId").get("v.value");
        var ctLName 		=  component.find("ctLNameId").get("v.value");
        var ctTitle			=  component.find("ctTitleId").get("v.value");
        var ctEmail 		=  component.find("ctEmailId").get("v.value");
        //var ctPhone 		=  component.find("ctPhoneId").get("v.value");
        var ctDepartment 	=  component.find("ctDepartmentId").get("v.value");
        var ctPhoneExt 		=  component.find("ctPhoneExtId").get("v.value");
        var ctPhoneRep 		=  component.find("ctPhoneRepId").get("v.value");
        var ctPhoneType1 	=  component.find("ctPhoneType1Id").get("v.value");
        var ctPhone2Rep	 	=  component.find("ctPhone2RepId").get("v.value");
        var ctPhoneType2 	=  component.find("ctPhoneType2Id").get("v.value");
        var ctPhone3Rep  	=  component.find("ctPhone3RepId").get("v.value");
        var ctPhoneType3 	=  component.find("ctPhoneType3Id").get("v.value");
        var ctRole 			=  component.find("ctRoleId").get("v.value");
        var ctDecisionMaker =  component.find("ctDecisionMakerId").get("v.value");
        var ctProductFocus 	=  component.find("ctProductFocusId").get("v.value");
        var re = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'
        if(!$A.util.isEmpty(ctPhoneRep)){
           var newPhoneNo = helper.formatPhoneNumber(component,ctPhoneRep);    
        ctPhoneRep = newPhoneNo;
        console.log('ctPhoneRep----after change---'+ctPhoneRep);
        if(!ctPhoneRep.match(re)){
            console.log('inside re if----');
            component.set("v.errorMsg",'Please make sure the contact Phone is in the following format (999) 999-9999');
        }
        component.set("v.contactRec.Phone1_Rep__c",ctPhoneRep);
    	}
        if(!$A.util.isEmpty(ctPhoneRep)&&(component.get('v.accRecTypeName') == 'Prospect' || component.get('v.accRecTypeName') == 'Prospect (GT)' || component.get('v.accRecTypeName') == 'Customer (Business Pro)')){
            $A.util.addClass(component.find("ctPhoneType1Id"), "customRequired");
            
        }else{
            $A.util.removeClass(component.find("ctPhoneType1Id"), "customRequired");
        }
        if(!$A.util.isEmpty(ctPhone2Rep)){
            $A.util.addClass(component.find("ctPhoneType2Id"), "customRequired");
        }else{
            $A.util.removeClass(component.find("ctPhoneType2Id"), "customRequired");
        }
        if(!$A.util.isEmpty(ctPhone3Rep)){
            $A.util.addClass(component.find("ctPhoneType3Id"), "customRequired");
        }else{
            $A.util.removeClass(component.find("ctPhoneType3Id"), "customRequired");
        }
        /*var tempCt = [];
            tempCt.push({'Name':ctName});
        
        component.set("v.tempContactRec",tempCt[0]);
        var contactRecords = component.get("v.tempContactRec");*/
        //'Phone'		:ctPhone,
        var ct = [];
            ct.push({
                	 'LastName'		:ctLName,
                     'FirstName'	:ctFName,
                	 //'Salutation'	:ctSal,
                     'Email'		:ctEmail,
                	 'Title'		:ctTitle,
                     'Department'	:ctDepartment,
                     'Phone_Ext__c'	:ctPhoneExt,
                     'Phone1_Rep__c':ctPhoneRep,
                     'Phone_Type1__c':ctPhoneType1,
                     'Phone2_Rep__c' :ctPhone2Rep,
                     'Phone_Type2__c':ctPhoneType2,
                     'Phone3_Rep__c' :ctPhone3Rep,
                     'Phone_Type3__c':ctPhoneType3,
                     'Role__c'		 :ctRole,
                     'Decision_Maker__c':ctDecisionMaker,
                     'Product_Focus__c':ctProductFocus});
       component.set("v.contactRec",ct[0]);
        
    },
    industryOnchange : function(component, event, helper) {
        helper.getVericalPickVal(component);
    },
    showProspectReqFields : function(component, event, helper) {
        //US Prospect 
       $A.util.removeClass(component.find("prospectPhoneId"), "none");
       $A.util.removeClass(component.find("prospectSectorId"), "none");
       $A.util.removeClass(component.find("prospectWWId"), "none");
       $A.util.removeClass(component.find("prospectEstSpendId"), "none");
       $A.util.removeClass(component.find("prospectPrimaryProductId"), "none");
       $A.util.removeClass(component.find("prospectPaymentTermId"), "none");
       $A.util.removeClass(component.find("prospectisOmaxAccountId"), "none");
       //Auto populate values
       //Set Prospect White collar wrker
       var leadInfo = component.get("v.leadRec");
        var prosRecLoad= component.get("v.prospectRec");
        if(!$A.util.isEmpty(leadInfo)&& $A.util.isEmpty(prosRecLoad)){
            if(leadInfo.RecordType.Name == 'Lead (US)'){
                component.find("prospectWWId").set("v.value",leadInfo.WCW_Count__c);
            }
        }
       // GT Prospect
        $A.util.removeClass(component.find("prospectGTPhoneId"), "none");
        if(!$A.util.isEmpty(component.get("v.leadRecId"))){
            $A.util.removeClass(component.find("prospectGTLocationTypeId"), "none");
            $A.util.removeClass(component.find("prospectGTSegmentId"), "none");
        }
        //Business pro
        $A.util.removeClass(component.find("prospectContactInitiationTypeId"), "none");
        //TZ
        $A.util.removeClass(component.find("prospectTZTypeId"), "none");
        component.set("v.prospectRec.Type","Prospect");
    },
    setUpUSProspectFields : function(component, event, helper) {
        var ProsPhone = component.find("prospectPhoneId").get("v.value");
        if(!$A.util.isEmpty(ProsPhone)){
            var newPhoneNo = helper.formatPhoneNumber(component,ProsPhone);    
            ProsPhone = newPhoneNo;
            component.set("v.prospectRec.Phone",ProsPhone);
        }
        component.set("v.prospectRec.Website",component.find("prospectWebsiteid").get("v.value"));
        var prospectSector= component.find("prospectSectorId").get("v.value");
        component.set("v.prospectRec.Sector__c",prospectSector);
        if(!$A.util.isEmpty(prospectSector)){
            $A.util.addClass(component.find("prospectSegmentId"), "customRequired");
        }else{
            $A.util.removeClass(component.find("prospectSegmentId"), "customRequired");
        }
       
        component.set("v.prospectRec.Org_WCW_Count_Rep__c",component.find("prospectWWId").get("v.value"));
        var prospectSegment= component.find("prospectSegmentId").get("v.value");
        component.set("v.prospectRec.Segment__c",prospectSegment);
        if(!$A.util.isEmpty(prospectSegment)){
            $A.util.addClass(component.find("prospectBuyingGrpId"), "customRequired");
            $A.util.addClass(component.find("prospectIndustryRepId"), "customRequired");
        }else{
            $A.util.removeClass(component.find("prospectBuyingGrpId"), "customRequired");
            $A.util.removeClass(component.find("prospectIndustryRepId"), "customRequired");
        }
        
        component.set("v.prospectRec.Est_Spend__c",component.find("prospectEstSpendId").get("v.value"));
        var prospectBuyingGrp= component.find("prospectBuyingGrpId").get("v.value");
        component.set("v.prospectRec.Buying_Group__c",prospectBuyingGrp);
        if(!$A.util.isEmpty(prospectBuyingGrp)){
            $A.util.addClass(component.find("prospectPricingTempId"), "customRequired");
        }else{
            $A.util.removeClass(component.find("prospectPricingTempId"), "customRequired");
        }
        
        component.set("v.prospectRec.Payment_Term__c",component.find("prospectPaymentTermId").get("v.value"));
        component.set("v.prospectRec.Pricing_template_cd__c",component.find("prospectPricingTempId").get("v.value"));
        component.set("v.prospectRec.Primary_Product__c",component.find("prospectPrimaryProductId").get("v.value"));
        component.set("v.prospectRec.Industry_OD_SIC_Rep__c",component.find("prospectIndustryRepId").get("v.value"));
        component.set("v.prospectRec.Rep_Call_Date__c",component.find("prospectRepCallDateId").get("v.value"));
        ///alert("hi"+component.find("prospectAutoAssignId").get("v.value"));
         //component.set("v.prospectRec.Auto_Assign__c",component.find("prospectAutoAssignId").get("v.value"));

        ///component.set("v.prospectRec.Auto_Assign__c",component.find("Auto_Assign__c").get("v.value"));
        /*var isChecked = component.find("prospectAutoAssignId").get("v.checked");
        component.set("v.prospectRec.Auto_Assign__c", isChecked);*/
        component.set("v.prospectRec.Location_Type__c",component.find("prospectLocationtypeid").get("v.value"));
        console.log('Auto assign---'+component.get("v.prospectRec.Auto_Assign__c"));
        
        },
    PricingTemplateChange: function(component, event, helper) {
    var pricingTemplte = component.find("prospectPricingTempId").get("v.value");

    component.set(
        "v.prospectRec.Pricing_template_cd__c",
        component.find("prospectPricingTempId").get("v.value")
      ); 
      //Makes Attach Parent Pricing Field Required if Selected as Pricing Template- Support 01805613 - START - Part 1 of 2
        if (pricingTemplte === "Attach to Parent Pricing") {
            $A.util.addClass(component.find("prospectRelParentAccId1"),
                "customRequired");
        } else {
            $A.util.removeClass(component.find(
                "prospectRelParentAccId1"), "customRequired");
        };
    //Makes Attach Parent Pricing Field Required if Selected as Pricing Template - Support 01805613 - END
    component.find("prospectRelParentAccId1").set("v.value",'');
    var PRec = component.get("v.prospectRec");
    var AccData = JSON.stringify(PRec);
    console.log(
      "Pricing template--" +
        component.get("v.prospectRec.Pricing_template_cd__c")
    );
    if (
      !$A.util.isEmpty(component.get("v.prospectRec.Pricing_template_cd__c"))
    ) {
      var action = component.get("c.populateparentaccount");
      action.setParams({
        PricingTemplate: pricingTemplte,
        prospectData: AccData
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          var result = response.getReturnValue();
          var val = result.accData.Related_Parent_Account__c;
            if(val != null)
            {
          console.log("val---" + val + "trim" + val.trim().length);
                component.set("v.prospectRec.Related_Parent_Account__c", val);
                component.set(
            "v.prospectRec.Related_Pricing_Template_Account__c",
            result.accData.Related_Pricing_Template_Account__c
          );
            } else
            {    component.set("v.prospectRec.Related_Parent_Account__c", '');
            component.set(
                "v.prospectRec.Related_Pricing_Template_Account__c",''
              );
            }
           
          
          
        }
      });
      $A.enqueueAction(action);
    }
  },
        
       
    setUpGTProspectFields : function(component, event, helper) {
        var ProsGTPhone = component.find("prospectGTPhoneId").get("v.value");
        if(!$A.util.isEmpty(ProsGTPhone)){
            var newPhoneNo = helper.formatPhoneNumber(component,ProsGTPhone);    
            ProsGTPhone = newPhoneNo;
            component.set("v.prospectRec.Phone",ProsGTPhone);
        }
        var leadId = component.get("v.leadRecId");
        if(!$A.util.isEmpty(leadId)){
            component.set("v.prospectRec.Location_Type__c",component.find("prospectGTLocationTypeId").get("v.value"));
            component.set("v.prospectRec.GT_Segment__c",component.find("prospectGTSegmentId").get("v.value"));
        }
    },
    setUpBusinessProProspectFields : function(component, event, helper) {
        component.set("v.prospectRec.Loyatly_Number__c",component.find("prospectLoyatlyId").get("v.value"));
        component.set("v.prospectRec.Contact_Initiation_Type__c",component.find("prospectContactInitiationTypeId").get("v.value"));
        component.set("v.prospectRec.Lead_Source__c",component.find("prospectLeadSourceId").get("v.value"));
        component.set("v.prospectRec.VIP_Card_Issue_Reqt__c",component.find("prospectVIPCardIssueReqtId").get("v.value"));
        component.set("v.prospectRec.VIP_Card_Effective_Date__c",component.find("prospectVIPCardEffectiveDateId").get("v.value"));
        component.set("v.prospectRec.VIP_Card_End_Date__c",component.find("prospectVIPCardEndDateId").get("v.value"));
    },
    setUpTZProspectFields : function(component, event, helper) {
        component.set("v.prospectRec.Type",component.find("prospectTZTypeId").get("v.value"));
    },
    setUpBizBoxProspectFields : function(component, event, helper) {
        component.set("v.prospectRec.Rep_Call_Date__c",component.find("prospectBZRepCallDateId").get("v.value"));
        //component.set("v.prospectRec.Auto_Assign__c",component.find("prospectBZAutoAssignId").get("v.value"));
    },
    moveToOppInfo : function(component, event, helper) {
        var decisionMaking = component.get("v.isDecisionLocationSelected");
        var familyOrgRecSelected = component.get("v.familyOrgSelected");
        var ctRec = component.get("v.contactRec");
        var newOrgRec = component.get("v.newOrgRec");
        var prospectRec = component.get("v.prospectRec");
        var accRecTypeName = component.get('v.accRecTypeName');
        var leadId = component.get("v.leadRecId");
        var re = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'
        var busninessName;
        var regExp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,20})$/;
        console.log('prospectRec---'+prospectRec);
        if(component.get('v.accRecTypeName') == 'Prospect'){
            var ProsPhone = component.find("prospectPhoneId").get("v.value");
        }if(component.get('v.accRecTypeName') == 'Prospect (GT)'){
        var ProsGTPhone = component.find("prospectGTPhoneId").get("v.value");
        }
        var ctPhone = component.find("ctPhoneRepId").get("v.value");
        if(!$A.util.isEmpty(newOrgRec.Business_Name__c)){
             var busninessName = newOrgRec.Business_Name__c.trim();
        }
        
         if(decisionMaking == 'None' && $A.util.isEmpty(busninessName)){      
            	component.set("v.requiredError", true);
             	return false;
        //Created to show error message if Attach Parent Pricing is not filled- Support 01805613 - START - Part 2 of 2
         } else if ((component.get('v.accRecTypeName') == 'Prospect' && component.get('v.prospectRec.Pricing_template_cd__c') === 'Attach to Parent Pricing') &&
            ($A.util.isEmpty(prospectRec.Related_Pricing_Template_Account__c))) {
            component.set("v.requiredError", true);
            console.log('Parent Pricing Chanel'+ prospectRec.Related_Pricing_Template_Account__c);
           return false;
        //Created to show error message if Attach Parent Pricing is not filled- Support 01805613 - END
         } else if(decisionMaking == 'No' && !familyOrgRecSelected && (busninessName == undefined ||$A.util.isEmpty(busninessName))){ 
          	 	component.set("v.requiredError", true);
             	return false;
         } else if(component.get('v.showDuplicateDisposition')==true && $A.util.isEmpty(prospectRec.Duplicate_Disposition__c)){ 
          	 	component.set("v.requiredError", true);
             	return false;
         } else if(((!$A.util.isEmpty(ctPhone)) && ctPhone.length<10) || (!$A.util.isEmpty(ctRec.Phone1_Rep__c) && !ctRec.Phone1_Rep__c.match(re))){
             console.log('Inlength--');
             component.set("v.requiredError", true);
             component.set("v.ctLastNameRequired", true);
             component.set("v.errorMsg",' Phone1 should not less than 10 digits');  
             return false;
         } else if((!$A.util.isEmpty(ProsPhone)) && ProsPhone.length<10){
             console.log('Inlength--');
             component.set("v.requiredError", true);
             component.set("v.ctLastNameRequired", true);
             component.set("v.errorMsg",'Account Phone Number should not less than 10 digits');  
             return false;
         } else if(component.get('v.accRecTypeName') == 'Prospect' && ($A.util.isEmpty(prospectRec.Sector__c) ||
             		$A.util.isEmpty(prospectRec.Segment__c) 	  || $A.util.isEmpty(prospectRec.Org_WCW_Count_Rep__c) ||
             		$A.util.isEmpty(prospectRec.Est_Spend__c)     || $A.util.isEmpty(prospectRec.Buying_Group__c) ||
             		$A.util.isEmpty(prospectRec.Payment_Term__c)  || $A.util.isEmpty(prospectRec.Pricing_template_cd__c) ||
             		$A.util.isEmpty(prospectRec.Industry_OD_SIC_Rep__c) || $A.util.isEmpty(prospectRec.Primary_Product__c)||
             		$A.util.isEmpty(prospectRec.Phone))){
             	component.set("v.requiredError", true);
             	return false;
         } else if(component.get('v.accRecTypeName') == 'Prospect' && $A.util.isEmpty(ctRec.Phone1_Rep__c) && (!$A.util.isEmpty(ctRec.Phone2_Rep__c) || !$A.util.isEmpty(ctRec.Phone3_Rep__c))){
             	component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
                 component.set("v.errorMsg",'Phone Numbers must be entered in sequential order');
                 return false;
         }else if(component.get('v.accRecTypeName') == 'Prospect' && (($A.util.isEmpty(ctRec.Phone1_Rep__c) || $A.util.isEmpty(ctRec.Phone2_Rep__c)) && (!$A.util.isEmpty(ctRec.Phone3_Rep__c)))){
             	component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
                 component.set("v.errorMsg",'Phone Numbers must be entered in sequential order');
                 return false;
         }else if((component.get('v.accRecTypeName') == 'Prospect' || component.get('v.accRecTypeName') == 'Prospect (BizBox)') && (($A.util.isEmpty(ctRec.Phone1_Rep__c) && !$A.util.isEmpty(ctRec.Phone_Type1__c)) ||
                                                                      ($A.util.isEmpty(ctRec.Phone2_Rep__c) && !$A.util.isEmpty(ctRec.Phone_Type2__c)) ||
                                                                      ($A.util.isEmpty(ctRec.Phone3_Rep__c) && !$A.util.isEmpty(ctRec.Phone_Type3__c)) ||
                                                                      (!$A.util.isEmpty(ctRec.Phone1_Rep__c) && $A.util.isEmpty(ctRec.Phone_Type1__c)) ||
                                                                      (!$A.util.isEmpty(ctRec.Phone2_Rep__c) && $A.util.isEmpty(ctRec.Phone_Type2__c)) ||
                                                                      (!$A.util.isEmpty(ctRec.Phone3_Rep__c) && $A.util.isEmpty(ctRec.Phone_Type3__c)) )){
             component.set("v.requiredError", true);
             component.set("v.ctLastNameRequired", true);
             component.set("v.errorMsg",'Phone and Phone Type Values are Required.');
             return false;
         } else if(component.get('v.accRecTypeName') == 'Prospect (GT)' && $A.util.isEmpty(ctRec.FirstName)){
                 component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
              	 component.set("v.errorMsg",'Contact First Name is required if Prospect is Grand and Toy.');
                 return false;
         } else if(component.get('v.accRecTypeName') == 'Prospect (GT)' && $A.util.isEmpty(ctRec.Phone1_Rep__c) && (!$A.util.isEmpty(ctRec.Phone2_Rep__c) || !$A.util.isEmpty(ctRec.Phone3_Rep__c))){
             	component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
                 component.set("v.errorMsg",'Phone Numbers must be entered in sequential order');
                 return false;
         }else if(component.get('v.accRecTypeName') == 'Prospect (GT)' && ($A.util.isEmpty(prospectRec.Phone))){
            	component.set("v.ctLastNameRequired", false);
             	component.set("v.requiredError", true);
             	return false;
         } /*else if(component.get('v.accRecTypeName') == 'Prospect (GT)' && !$A.util.isEmpty(prospectRec.Phone) && !prospectRec.Phone.match(re)){
             	component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
                 component.set("v.errorMsg",'Please make sure the Account Phone is in the following format (999) 999-9999');
                 return false;
         }*/else if(!$A.util.isEmpty(prospectRec.Phone) && !prospectRec.Phone.match(re)){
             	component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
                 component.set("v.errorMsg",'Please make sure the Account Phone number should contain 10 digits');
                 return false;
         }else if((!$A.util.isEmpty(ProsGTPhone)) && ProsGTPhone.length<10){
             component.set("v.requiredError", true);
             component.set("v.ctLastNameRequired", true);
             component.set("v.errorMsg",'Account Phone Number should not less than 10 digits');  
             return false;
         }else if(component.get('v.accRecTypeName') == 'Prospect (GT)' && (!$A.util.isEmpty(leadId)) &&
                   ($A.util.isEmpty(prospectRec.Location_Type__c) || $A.util.isEmpty(prospectRec.GT_Segment__c) ||
                    $A.util.isEmpty(prospectRec.Industry_OD_SIC_Rep__c) || 
                    (component.get('v.accVerticalVal').length > 0 && $A.util.isEmpty(prospectRec.Verticals__c)))){
                     component.set("v.requiredError", true);
                     component.set("v.ctLastNameRequired", false);
             		 return false;
         } else if($A.util.isEmpty(ctRec.LastName) || $A.util.isEmpty(ctRec.FirstName) || $A.util.isEmpty(ctRec.Decision_Maker__c)){
            	component.set("v.ctLastNameRequired", false);    
             	component.set("v.requiredError", true);
                 return false;
         } else if(!$A.util.isEmpty(ctRec.Email) && regExp.test(ctRec.Email) == false){
                component.set("v.errorMsg",'Invalid Contact email format.');
            	component.set("v.ctLastNameRequired", true);    
             	component.set("v.requiredError", true);
                 return false;
         } else if(component.get('v.accRecTypeName') == 'Customer (Business Pro)' && $A.util.isEmpty(prospectRec.Contact_Initiation_Type__c)){
            	component.set("v.ctLastNameRequired", false);
             	component.set("v.requiredError", true);
             	return false;
         } else if(component.get('v.accRecTypeName') == 'Customer (Business Pro)' && 
                   ($A.util.isEmpty(prospectRec.Loyatly_Number__c) && $A.util.isEmpty(prospectRec.BSD_Account_Number__c))){
                component.set("v.ctLastNameRequired", true);	
                component.set("v.errorMsg",'Prospect BSD Account Number or Loyalty Account Number Has to be Entered.');
             	component.set("v.requiredError", true);
             	return false;
         } else if(component.get('v.accRecTypeName') == 'Customer (Business Pro)' && 
                   (!$A.util.isEmpty(prospectRec.Loyatly_Number__c) && !$A.util.isEmpty(prospectRec.BSD_Account_Number__c))){
                component.set("v.ctLastNameRequired", true);	
                component.set("v.errorMsg",'Prospect Both BSD Account Number and Loyalty Account Number Cannot be Entered');
             	component.set("v.requiredError", true);
             	return false;
         } else if(component.get('v.accRecTypeName') == 'Prospect (Tech-Zone)' && $A.util.isEmpty(prospectRec.Type)){
              	console.log('Inside Techzone..');
             	component.set("v.requiredError", true);
             	return false;
         } else if(!$A.util.isEmpty(component.get('v.prospectRec.Assign_Specific_Owner__c')) && component.get('v.prospectRec.Auto_Assign__c') == true){
              console.log('Inside AA.');	
             component.set("v.ctLastNameRequired", true);	
                component.set("v.errorMsg",'Please choose only Auto Assign or Assign Specific Owner.');
             	component.set("v.requiredError", true);
             	return false;
         }else {
             	 component.set("v.errorMsg",'');
                 component.set("v.requiredError", false);
                 component.set("v.ctLastNameRequired", false);
         }
        
        

    },
   
    backToProspectInfo : function(component, event, helper) {
        console.log('hi1----');
         var appEvent = $A.get("e.c:ProcessIndicatorEvent");
         appEvent.setParams({"currentStep" : "Prospect Info"});
         appEvent.fire();
         component.set("v.showProspectSection",true);
         var ctRec= component.get("v.contactRec");        
        //Set value to contat for when back to Prospect Info Section
        //if($A.util.isEmpty(ctRec)){
            //component.find("ctNameId").set("v.value",component.get("v.tempContactRec").Name);
        	//component.find("ctSalId").set("v.value",ctRec.Salutation);
        	component.find("ctFNameId").set("v.value",ctRec.FirstName);
        	component.find("ctLNameId").set("v.value",ctRec.LastName);
            component.find("ctTitleId").set("v.value",ctRec.Title);
        	component.find("ctEmailId").set("v.value",ctRec.Email);
            component.find("ctDepartmentId").set("v.value",ctRec.Department);
            component.find("ctPhoneExtId").set("v.value",ctRec.Phone_Ext__c);
            component.find("ctPhoneRepId").set("v.value",ctRec.Phone1_Rep__c);
            if(component.get("v.addMorePhones") == true){
                var changeElement = component.find("moreInfoDivId");
                $A.util.toggleClass(changeElement, "slds-hide");
            }
           console.log('hi1--2--');
            component.find("ctDecisionMakerId").set("v.value",ctRec.Decision_Maker__c);
            component.find("ctPhoneType1Id").set("v.value",ctRec.Phone_Type1__c);
            component.find("ctPhone2RepId").set("v.value",ctRec.Phone2_Rep__c);
            component.find("ctPhoneType2Id").set("v.value",ctRec.Phone_Type2__c);
            component.find("ctPhone3RepId").set("v.value",ctRec.Phone3_Rep__c);
            component.find("ctPhoneType3Id").set("v.value",ctRec.Phone_Type3__c);
            component.find("ctRoleId").set("v.value",ctRec.Role__c);
            component.find("ctProductFocusId").set("v.value",ctRec.Product_Focus__c);
            console.log('hi1--3--');
            //component.find("locDecisionMakingId").set("v.value",component.get("v.prospectRec.Location_Decision_Making__c"));
            if(!$A.util.isEmpty(component.get("v.prospectRec.Location_Decision_Making__c"))){
               component.find("locDecisionMakingId").set("v.value",component.get("v.prospectRec.Location_Decision_Making__c"));
            }
       	// }
        //Set US Prospect Information
        var usprospectRec = component.get("v.prospectRec");
        if(component.get('v.accRecTypeName') == 'Prospect'){
            var leadId1 = component.get("v.leadRecId");
            console.log('leadId1--'+leadId1);
            component.find("prospectPhoneId").set("v.value",usprospectRec.Phone);
            component.find("prospectWebsiteid").set("v.value",usprospectRec.Website);
            component.find("prospectSectorId").set("v.value",usprospectRec.Sector__c);
            component.find("prospectWWId").set("v.value",usprospectRec.Org_WCW_Count_Rep__c);
            component.find("prospectSegmentId").set("v.value",usprospectRec.Segment__c);
            component.find("prospectEstSpendId").set("v.value",usprospectRec.Est_Spend__c);
            component.find("prospectBuyingGrpId").set("v.value",usprospectRec.Buying_Group__c);
            component.find("prospectPaymentTermId").set("v.value",usprospectRec.Payment_Term__c);
            component.find("prospectPricingTempId").set("v.value",usprospectRec.Pricing_template_cd__c);
            component.find("prospectPrimaryProductId").set("v.value",usprospectRec.Primary_Product__c);
            component.find("prospectIndustryRepId").set("v.value",usprospectRec.Industry_OD_SIC_Rep__c);
            component.find("prospectRepCallDateId").set("v.value",usprospectRec.Rep_Call_Date__c);
            if ($A.util.isEmpty(leadId1)) {
            component.find("prospectAutoAssignId").set("v.value",usprospectRec.Auto_Assign__c);
            }
            component.find("prospectLocationtypeid").set("v.value",usprospectRec.Location_Type__c);
            if ($A.util.isEmpty(leadId1)) {
            console.log('Auto assign--1234-'+component.find("prospectAutoAssignId").get("v.value"));
            }
		}
        if(component.get('v.accRecTypeName') == 'Prospect (GT)'){
             component.find("prospectGTPhoneId").set("v.value",usprospectRec.Phone);
             var leadId = component.get("v.leadRecId");
             if(!$A.util.isEmpty(leadId)){
            	component.find("prospectGTLocationTypeId").set("v.value",component.get("v.prospectRec.Location_Type__c"));
            	component.find("prospectGTSegmentId").set("v.value",component.get("v.prospectRec.GT_Segment__c"));
                 console.log('hi1--3--');
        	}
         }
        if(component.get('v.accRecTypeName') == 'Customer (Business Pro)'){
            component.find("prospectLoyatlyId").set("v.value",component.get("v.prospectRec.Loyatly_Number__c"));
        	component.find("prospectContactInitiationTypeId").set("v.value",component.get("v.prospectRec.Contact_Initiation_Type__c"));
        	component.find("prospectLeadSourceId").set("v.value",component.get("v.prospectRec.Lead_Source__c"));
        	component.find("prospectVIPCardIssueReqtId").set("v.value",component.get("v.prospectRec.VIP_Card_Issue_Reqt__c"));
        	component.find("prospectVIPCardEffectiveDateId").set("v.value",component.get("v.prospectRec.VIP_Card_Effective_Date__c"));
        	component.find("prospectVIPCardEndDateId").set("v.value",component.get("v.prospectRec.VIP_Card_End_Date__c"));
            console.log('hi1--4--');
         }
        if(component.get('v.accRecTypeName') == 'Prospect (BizBox)'){
            var leadId2 = component.get("v.leadRecId");
            component.find("prospectBZRepCallDateId").set("v.value",usprospectRec.Rep_Call_Date__c);
            if ($A.util.isEmpty(leadId2)) {
            component.find("prospectBZAutoAssignId").set("v.value",usprospectRec.Auto_Assign__c);
            }
        }
    	console.log('hi1--5--');
    },
   
    createProspect : function(component, event, helper) { 
        component.set("v.errorMsg",'');
        component.set("v.requiredError", false);
        component.set("v.ctLastNameRequired", false);        
        
        var decisionMaking = component.get("v.isDecisionLocationSelected");
        var familyOrgRecSelected = component.get("v.familyOrgSelected");
        var ctRec = component.get("v.contactRec");
        var newOrgRec = component.get("v.newOrgRec");
        var prospectRec = component.get("v.prospectRec");
        var accRecTypeName = component.get('v.accRecTypeName');
        var leadId = component.get("v.leadRecId");
        var re = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'
        var busninessName;
        var regExp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,20})$/;
        console.log('prospectRec---'+prospectRec);
        if(component.get('v.accRecTypeName') == 'Prospect'){
            var ProsPhone = component.find("prospectPhoneId").get("v.value");
        }if(component.get('v.accRecTypeName') == 'Prospect (GT)'){
        var ProsGTPhone = component.find("prospectGTPhoneId").get("v.value");
        }
        var ctPhone = component.find("ctPhoneRepId").get("v.value");
        if(!$A.util.isEmpty(newOrgRec.Business_Name__c)){
             var busninessName = newOrgRec.Business_Name__c.trim();
        }
        
         if(decisionMaking == 'None' && $A.util.isEmpty(busninessName)){      
            	component.set("v.requiredError", true);
             	return false;
        //Created to show error message if Attach Parent Pricing is not filled- Support 01805613 - START - Part 2 of 2
         } else if ((component.get('v.accRecTypeName') == 'Prospect' && component.get('v.prospectRec.Pricing_template_cd__c') === 'Attach to Parent Pricing') &&
            ($A.util.isEmpty(prospectRec.Related_Pricing_Template_Account__c))) {
            component.set("v.requiredError", true);
            console.log('Parent Pricing Chanel'+ prospectRec.Related_Pricing_Template_Account__c);
           return false;
        //Created to show error message if Attach Parent Pricing is not filled- Support 01805613 - END
         } else if(decisionMaking == 'No' && !familyOrgRecSelected && (busninessName == undefined ||$A.util.isEmpty(busninessName))){ 
          	 	component.set("v.requiredError", true);
             	return false;
         } else if(component.get('v.showDuplicateDisposition')==true && $A.util.isEmpty(prospectRec.Duplicate_Disposition__c)){ 
          	 	component.set("v.requiredError", true);
             	return false;
         } else if(((!$A.util.isEmpty(ctPhone)) && ctPhone.length<10) || (!$A.util.isEmpty(ctRec.Phone1_Rep__c) && !ctRec.Phone1_Rep__c.match(re))){
             console.log('Inlength--');
             component.set("v.requiredError", true);
             component.set("v.ctLastNameRequired", true);
             component.set("v.errorMsg",' Phone1 should not less than 10 digits');  
             return false;
         } else if((!$A.util.isEmpty(ProsPhone)) && ProsPhone.length<10){
             console.log('Inlength--');
             component.set("v.requiredError", true);
             component.set("v.ctLastNameRequired", true);
             component.set("v.errorMsg",'Account Phone Number should not less than 10 digits');  
             return false;
         } else if(component.get('v.accRecTypeName') == 'Prospect' && ($A.util.isEmpty(prospectRec.Sector__c) ||
             		$A.util.isEmpty(prospectRec.Segment__c) 	  || $A.util.isEmpty(prospectRec.Org_WCW_Count_Rep__c) ||
             		$A.util.isEmpty(prospectRec.Est_Spend__c)     || $A.util.isEmpty(prospectRec.Buying_Group__c) ||
             		$A.util.isEmpty(prospectRec.Payment_Term__c)  || $A.util.isEmpty(prospectRec.Pricing_template_cd__c) ||
             		$A.util.isEmpty(prospectRec.Industry_OD_SIC_Rep__c) || $A.util.isEmpty(prospectRec.Primary_Product__c)||
             		$A.util.isEmpty(prospectRec.Phone))){
             	component.set("v.requiredError", true);
             	return false;
         } else if(component.get('v.accRecTypeName') == 'Prospect' && $A.util.isEmpty(ctRec.Phone1_Rep__c) && (!$A.util.isEmpty(ctRec.Phone2_Rep__c) || !$A.util.isEmpty(ctRec.Phone3_Rep__c))){
             	component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
                 component.set("v.errorMsg",'Phone Numbers must be entered in sequential order');
                 return false;
         }else if(component.get('v.accRecTypeName') == 'Prospect' && (($A.util.isEmpty(ctRec.Phone1_Rep__c) || $A.util.isEmpty(ctRec.Phone2_Rep__c)) && (!$A.util.isEmpty(ctRec.Phone3_Rep__c)))){
             	component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
                 component.set("v.errorMsg",'Phone Numbers must be entered in sequential order');
                 return false;
         }else if((component.get('v.accRecTypeName') == 'Prospect' || component.get('v.accRecTypeName') == 'Prospect (BizBox)') && (($A.util.isEmpty(ctRec.Phone1_Rep__c) && !$A.util.isEmpty(ctRec.Phone_Type1__c)) ||
                                                                      ($A.util.isEmpty(ctRec.Phone2_Rep__c) && !$A.util.isEmpty(ctRec.Phone_Type2__c)) ||
                                                                      ($A.util.isEmpty(ctRec.Phone3_Rep__c) && !$A.util.isEmpty(ctRec.Phone_Type3__c)) ||
                                                                      (!$A.util.isEmpty(ctRec.Phone1_Rep__c) && $A.util.isEmpty(ctRec.Phone_Type1__c)) ||
                                                                      (!$A.util.isEmpty(ctRec.Phone2_Rep__c) && $A.util.isEmpty(ctRec.Phone_Type2__c)) ||
                                                                      (!$A.util.isEmpty(ctRec.Phone3_Rep__c) && $A.util.isEmpty(ctRec.Phone_Type3__c)) )){
             component.set("v.requiredError", true);
             component.set("v.ctLastNameRequired", true);
             component.set("v.errorMsg",'Phone and Phone Type Values are Required.');
             return false;
         } else if(component.get('v.accRecTypeName') == 'Prospect (GT)' && $A.util.isEmpty(ctRec.FirstName)){
                 component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
              	 component.set("v.errorMsg",'Contact First Name is required if Prospect is Grand and Toy.');
                 return false;
         } else if(component.get('v.accRecTypeName') == 'Prospect (GT)' && $A.util.isEmpty(ctRec.Phone1_Rep__c) && (!$A.util.isEmpty(ctRec.Phone2_Rep__c) || !$A.util.isEmpty(ctRec.Phone3_Rep__c))){
             	component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
                 component.set("v.errorMsg",'Phone Numbers must be entered in sequential order');
                 return false;
         }else if(component.get('v.accRecTypeName') == 'Prospect (GT)' && ($A.util.isEmpty(prospectRec.Phone))){
            	component.set("v.ctLastNameRequired", false);
             	component.set("v.requiredError", true);
             	return false;
         } /*else if(component.get('v.accRecTypeName') == 'Prospect (GT)' && !$A.util.isEmpty(prospectRec.Phone) && !prospectRec.Phone.match(re)){
             	component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
                 component.set("v.errorMsg",'Please make sure the Account Phone is in the following format (999) 999-9999');
                 return false;
         }*/else if(!$A.util.isEmpty(prospectRec.Phone) && !prospectRec.Phone.match(re)){
             	component.set("v.requiredError", true);
                 component.set("v.ctLastNameRequired", true);
                 component.set("v.errorMsg",'Please make sure the Account Phone number should contain 10 digits');
                 return false;
         }else if((!$A.util.isEmpty(ProsGTPhone)) && ProsGTPhone.length<10){
             component.set("v.requiredError", true);
             component.set("v.ctLastNameRequired", true);
             component.set("v.errorMsg",'Account Phone Number should not less than 10 digits');  
             return false;
         }else if(component.get('v.accRecTypeName') == 'Prospect (GT)' && (!$A.util.isEmpty(leadId)) &&
                   ($A.util.isEmpty(prospectRec.Location_Type__c) || $A.util.isEmpty(prospectRec.GT_Segment__c) ||
                    $A.util.isEmpty(prospectRec.Industry_OD_SIC_Rep__c) || 
                    (component.get('v.accVerticalVal').length > 0 && $A.util.isEmpty(prospectRec.Verticals__c)))){
                     component.set("v.requiredError", true);
                     component.set("v.ctLastNameRequired", false);
             		 return false;
         } else if($A.util.isEmpty(ctRec.LastName) || $A.util.isEmpty(ctRec.FirstName) || $A.util.isEmpty(ctRec.Decision_Maker__c)){
            	component.set("v.ctLastNameRequired", false);    
             	component.set("v.requiredError", true);
                 return false;
         } else if(!$A.util.isEmpty(ctRec.Email) && regExp.test(ctRec.Email) == false){
                component.set("v.errorMsg",'Invalid Contact email format.');
            	component.set("v.ctLastNameRequired", true);    
             	component.set("v.requiredError", true);
                 return false;
         } else if(component.get('v.accRecTypeName') == 'Customer (Business Pro)' && $A.util.isEmpty(prospectRec.Contact_Initiation_Type__c)){
            	component.set("v.ctLastNameRequired", false);
             	component.set("v.requiredError", true);
             	return false;
         } else if(component.get('v.accRecTypeName') == 'Customer (Business Pro)' && 
                   ($A.util.isEmpty(prospectRec.Loyatly_Number__c) && $A.util.isEmpty(prospectRec.BSD_Account_Number__c))){
                component.set("v.ctLastNameRequired", true);	
                component.set("v.errorMsg",'Prospect BSD Account Number or Loyalty Account Number Has to be Entered.');
             	component.set("v.requiredError", true);
             	return false;
         } else if(component.get('v.accRecTypeName') == 'Customer (Business Pro)' && 
                   (!$A.util.isEmpty(prospectRec.Loyatly_Number__c) && !$A.util.isEmpty(prospectRec.BSD_Account_Number__c))){
                component.set("v.ctLastNameRequired", true);	
                component.set("v.errorMsg",'Prospect Both BSD Account Number and Loyalty Account Number Cannot be Entered');
             	component.set("v.requiredError", true);
             	return false;
         } else if(component.get('v.accRecTypeName') == 'Prospect (Tech-Zone)' && $A.util.isEmpty(prospectRec.Type)){
              	console.log('Inside Techzone..');
             	component.set("v.requiredError", true);
             	return false;
         } else if(!$A.util.isEmpty(component.get('v.prospectRec.Assign_Specific_Owner__c')) && component.get('v.prospectRec.Auto_Assign__c') == true){
              console.log('Inside AA.');	
             component.set("v.ctLastNameRequired", true);	
                component.set("v.errorMsg",'Please choose only Auto Assign or Assign Specific Owner.');
             	component.set("v.requiredError", true);
             	return false;
         }else {
             	 component.set("v.errorMsg",'');
                 component.set("v.requiredError", false);
                 component.set("v.ctLastNameRequired", false);
                 component.set("v.Spinner",true);
                 helper.createProspectHelper(component);
         }
        
	
},

    AssignSpecificOwnerName : function(component, event, helper) { 
     helper.AssignSpecificOwnerName_helper(component, event, helper);
}
    
})