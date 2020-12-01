({
    ToggleCollapseHandler : function(component, event) {
        
        var prospectRec = component.get("v.prospectRec");
        var newOrgRec = component.get("v.newOrgRec");
        var parentOrgRecord = component.get("v.parentOrgRecord");
        var contactRec = component.get("v.contactRec");
        var headerName =  component.get("v.header");
        var showDuplicateDisposition =  component.get("v.dupliatedisosition");
        var createNewOrg1 =  component.get("v.createNewOrg")
        
       var leaddata=component.get("v.leadRec");
        
        var leadRecType ;
       if(component.get("v.leadRec").Id != undefined)
       leadRecType  =  component.get("v.leadRec").RecordType.Name;
        
        
        if((headerName == 'Contact Information')&&(createNewOrg1 || showDuplicateDisposition)){
            var showDuplicateDisposition =  component.get("v.dupliatedisosition");
            console.log('showDuplicateDisposition....'+showDuplicateDisposition);
            var decisionMakingLoc = prospectRec.Location_Decision_Making__c;
            console.log('decisionMakingLoc....'+decisionMakingLoc);
            var dupdisposition=prospectRec.Duplicate_Disposition__c;
                console.log('dupdisposition....'+dupdisposition);
            var busninessName;
            var address;
            if(!$A.util.isEmpty(component.get("v.newOrgRec.Business_Name__c"))){
             var busninessName = component.get("v.newOrgRec.Business_Name__c").trim();
            }
            if(!$A.util.isEmpty(component.get("v.newOrgRec.Address_1__c"))){
             var address = component.get("v.newOrgRec.Address_1__c").trim();
            }
            if((!$A.util.isEmpty(parentOrgRecord) && dupdisposition == undefined) ||($A.util.isEmpty(parentOrgRecord) && (($A.util.isEmpty(component.get("v.newOrgRec.Business_Name__c"))) || ($A.util.isEmpty(component.get("v.newOrgRec.Address_1__c")))))){
            //if((parentOrgRecord == null && $A.util.isEmpty(newOrgRec.Business_Name__c))){
            console.log('hi===31');
            console.log('colindex&&&&---32'+component.get("v.collapseIdx"));
                
            if(component.get("v.collapseIdx")=='1')
              {
                   console.log('hi===34');
                $A.util.removeClass(document.getElementById('decisionInfoId'),'sucessAlert');
                $A.util.removeClass(document.getElementById('decisionInfoId'),'Message');
                $A.util.addClass(document.getElementById('decisionInfoId'),'errorAlert');
                document.getElementById("decisionInfoId_1").innerHTML = " ------> Section Required fields are missing!";
                  }
            }else{
                var dupdisposition=prospectRec.Duplicate_Disposition__c;
                console.log('dupdisposition..2..'+dupdisposition);
                  //By Anand
                if(!$A.util.isEmpty(prospectRec)&&$A.util.isEmpty(prospectRec.Duplicate_Disposition__c)&&prospectRec.Duplicate_Disposition__c!=undefined)
                {
                    console.log('dupdisposition..38..'+dupdisposition);
                    $A.util.removeClass(document.getElementById('decisionInfoId'),'sucessAlert');
                    $A.util.removeClass(document.getElementById('decisionInfoId'),'Message');
                    $A.util.addClass(document.getElementById('decisionInfoId'),'errorAlert');
                  document.getElementById("decisionInfoId_1").innerHTML = " ------> Section Required fields are missing!";
                }else{
                $A.util.addClass(document.getElementById('decisionInfoId'),'sucessAlert');
                $A.util.removeClass(document.getElementById('decisionInfoId'),'Message');
                $A.util.removeClass(document.getElementById('decisionInfoId'),'errorAlert');
                $A.util.removeClass(document.getElementById('decisionInfoId'),'addError');
                document.getElementById("decisionInfoId_1").innerHTML = "";
                }
            }
        }
        else if(headerName == 'Company/Prospect Additional Information'){
            var ctLName = contactRec.LastName;
            var ctFName = contactRec.FirstName;
            var ctEmail = contactRec.Email;
            var ctDecision = contactRec.Decision_Maker__c;
            if(!$A.util.isEmpty(contactRec.LastName)){
             var ctName = contactRec.LastName.trim();
            }
            var regExp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            //var ctPhone = contactRec.Phone;
            var re = '^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$'
            var ctPhoneRep = contactRec.Phone1_Rep__c;
            if($A.util.isEmpty(ctName) || $A.util.isEmpty(ctFName) ||  $A.util.isEmpty(ctDecision) ){//||regExp.test(ctEmail) == false||  $A.util.isEmpty(ctEmail)
                $A.util.removeClass(document.getElementById('ctInfoId'),'sucessAlert');
                $A.util.removeClass(document.getElementById('ctInfoId'),'Message');
                $A.util.addClass(document.getElementById('ctInfoId'),'errorAlert');
                document.getElementById("ctInfoId_1").innerHTML = " ------> Section Required fields are missing!";
                /*if(!$A.util.isEmpty(ctEmail)&&regExp.test(ctEmail) == false){
                    document.getElementById("ctInfoId_1").innerHTML = " -----> Invalid Email format";
                }*/
                
            }else{
                $A.util.removeClass(document.getElementById('ctInfoId'),'errorAlert');
                $A.util.removeClass(document.getElementById('ctInfoId'),'Message');
                $A.util.addClass(document.getElementById('ctInfoId'),'sucessAlert');
                document.getElementById("ctInfoId_1").innerHTML = "";
            }
        }
        
        var existingText = component.get("v.collpaseText");
        var header = component.get("v.header");
        if(header == 'Duplicate Information'|| header =='Org Information'){//Org Information
            //$A.util.addClass(document.getElementById('prospectBody0'),'show');
            $A.util.toggleClass(document.getElementById('prospectBody0'), 'hide');
            $A.util.addClass(document.getElementById('prospectBody1'),'hide');
            $A.util.addClass(document.getElementById('prospectBody2'),'hide');
            $A.util.addClass(document.getElementById('prospectBody3'),'hide');
            if($A.util.hasClass(document.getElementById('left0'),'slds-show')){
                $A.util.removeClass(document.getElementById('left0'), 'slds-show');
                $A.util.addClass(document.getElementById('left0'), 'slds-hide');
                $A.util.removeClass(document.getElementById('down0'), 'slds-hide');
                $A.util.addClass(document.getElementById('down0'), 'slds-show');
            }else{
                $A.util.removeClass(document.getElementById('left0'), 'slds-hide');
                $A.util.addClass(document.getElementById('left0'), 'slds-show');
                $A.util.removeClass(document.getElementById('down0'), 'slds-show');
                $A.util.addClass(document.getElementById('down0'), 'slds-hide');
            }
            $A.util.removeClass(document.getElementById('down1'), 'slds-show');
            $A.util.addClass(document.getElementById('down1'), 'slds-hide');
            $A.util.removeClass(document.getElementById('left1'), 'slds-hide');
            $A.util.addClass(document.getElementById('left1'), 'slds-show');
            
            $A.util.removeClass(document.getElementById('down2'), 'slds-show');
            $A.util.addClass(document.getElementById('down2'), 'slds-hide');
            $A.util.removeClass(document.getElementById('left2'), 'slds-hide');
            $A.util.addClass(document.getElementById('left2'), 'slds-show');
            
            $A.util.removeClass(document.getElementById('down3'), 'slds-show');
            $A.util.addClass(document.getElementById('down3'), 'slds-hide');
            $A.util.removeClass(document.getElementById('left3'), 'slds-hide');
            $A.util.addClass(document.getElementById('left3'), 'slds-show');
            
        }else if(header == 'Contact Information'){
            
            $A.util.toggleClass(document.getElementById('prospectBody1'), 'hide');
            //$A.util.toggleClass(container, 'hide');
            $A.util.addClass(document.getElementById('prospectBody0'),'hide');
            $A.util.addClass(document.getElementById('prospectBody2'),'hide');
            $A.util.addClass(document.getElementById('prospectBody3'),'hide');
            
            if($A.util.hasClass(document.getElementById('left1'),'slds-show')){
                
                $A.util.removeClass(document.getElementById('left1'), 'slds-show');
                $A.util.addClass(document.getElementById('left1'), 'slds-hide');
                $A.util.removeClass(document.getElementById('down1'), 'slds-hide');
                $A.util.addClass(document.getElementById('down1'), 'slds-show');
            }else{
                
                $A.util.removeClass(document.getElementById('left1'), 'slds-hide');
                $A.util.addClass(document.getElementById('left1'), 'slds-show');
                $A.util.removeClass(document.getElementById('down1'), 'slds-show');
                $A.util.addClass(document.getElementById('down1'), 'slds-hide');
            }
            
            $A.util.removeClass(document.getElementById('down0'), 'slds-show');
            $A.util.addClass(document.getElementById('down0'), 'slds-hide');
            $A.util.removeClass(document.getElementById('left0'), 'slds-hide');
            $A.util.addClass(document.getElementById('left0'), 'slds-show');
            
            $A.util.removeClass(document.getElementById('down2'), 'slds-show');
            $A.util.addClass(document.getElementById('down2'), 'slds-hide');
            $A.util.removeClass(document.getElementById('left2'), 'slds-hide');
            $A.util.addClass(document.getElementById('left2'), 'slds-show');
            
            $A.util.removeClass(document.getElementById('down3'), 'slds-show');
            $A.util.addClass(document.getElementById('down3'), 'slds-hide');
            $A.util.removeClass(document.getElementById('left3'), 'slds-hide');
            $A.util.addClass(document.getElementById('left3'), 'slds-show');
            
        }else if(header == 'Company/Prospect Additional Information'){
            
            $A.util.toggleClass(document.getElementById('prospectBody2'), 'hide');
            //$A.util.toggleClass(container, 'hide');
            $A.util.addClass(document.getElementById('prospectBody0'),'hide');
            $A.util.addClass(document.getElementById('prospectBody1'),'hide');
            $A.util.addClass(document.getElementById('prospectBody3'),'hide');
            
            if($A.util.hasClass(document.getElementById('left2'),'slds-show')){
                
                $A.util.removeClass(document.getElementById('left2'), 'slds-show');
                $A.util.addClass(document.getElementById('left2'), 'slds-hide');
                $A.util.removeClass(document.getElementById('down2'), 'slds-hide');
                $A.util.addClass(document.getElementById('down2'), 'slds-show');
            }else{
                
                $A.util.removeClass(document.getElementById('left2'), 'slds-hide');
                $A.util.addClass(document.getElementById('left2'), 'slds-show');
                $A.util.removeClass(document.getElementById('down2'), 'slds-show');
                $A.util.addClass(document.getElementById('down2'), 'slds-hide');
            }
            
            $A.util.removeClass(document.getElementById('down0'), 'slds-show');
            $A.util.addClass(document.getElementById('down0'), 'slds-hide');
            $A.util.removeClass(document.getElementById('left0'), 'slds-hide');
            $A.util.addClass(document.getElementById('left0'), 'slds-show');
            
            $A.util.removeClass(document.getElementById('down1'), 'slds-show');
            $A.util.addClass(document.getElementById('down1'), 'slds-hide');
            $A.util.removeClass(document.getElementById('left1'), 'slds-hide');
            $A.util.addClass(document.getElementById('left1'), 'slds-show');
            
            $A.util.removeClass(document.getElementById('down3'), 'slds-show');
            $A.util.addClass(document.getElementById('down3'), 'slds-hide');
            $A.util.removeClass(document.getElementById('left3'), 'slds-hide');
            $A.util.addClass(document.getElementById('left3'), 'slds-show');
        }
    }
})