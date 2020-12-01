({
    doInit: function(component,event,helper){
        
        console.log('accountRecord:'+component.get("v.currentUser").Profile.Name);
        component.set("v.ProfileLoggedIn",component.get("v.currentUser").Profile.Name);

        var profiles_label = $A.get("$Label.c.Qualifying_Lead_GT_Profiles");
        var currentUserProfile = component.get("v.ProfileLoggedIn"); 
        var isGTUser = false;      
        if(profiles_label){
            profiles_label = profiles_label.toLocaleLowerCase();
            currentUserProfile = currentUserProfile.toLocaleLowerCase();
            var profiles = profiles_label.split(",");
            for (let i = 0; i < profiles.length; i++) {
                if((profiles[i]).trim() === currentUserProfile){
                    isGTUser = true;
                    break;
                }
            }
        }
        component.set("v.isGTUser",isGTUser);
    },
    
    
    handleRecordUpdated: function(component,event,helper){
        
        //console.log('accountRecord:'+component.get("v.currentUser").Profile.Name);
    },
    
    recordLoaded: function(component,event,helper)
    {
        document.getElementById("spinnerDiv").style.display = 'none';
        
        if(component.get("v.isClassic") == 'No')
        {
           if(component.get("v.fields")){
                if(component.get("v.fields").RecordTypeId == $A.get("$Label.c.SiteRecordTypeLabel"))
                {
                    component.find("AccountId").set("v.value",component.get("v.fields").Related_Account__c);  
                    component.find("RelatedSite").set("v.value",component.get("v.recordId"));
                    component.find("Company").set("v.value",component.get("v.fields").Related_Account__r.Name);
                }
                else if(component.get("v.fields").RecordTypeId != $A.get("$Label.c.SiteRecordTypeLabel"))
                {
                    console.log("Test-->"+component.get("v.fields").Primary_Site_ID__c);
                    component.find("AccountId").set("v.value",component.get("v.fields").Id);  
                    //component.find("RelatedSite").set("v.value",component.get("v.fields").Primary_Site_ID__c);
                    component.find("Company").set("v.value",component.get("v.fields").Name);
                }
           }
            //Start: Updated by Rajendra for NAIT-141988 - 02988308 - G&T: Qualifying Deal Primary Competitor
            if(component.get("v.isGTUser")){
                
                component.set("v.leadRecordTypeId",$A.get("$Label.c.Qualifying_Lead_GT_Record_Type"));
            }else{
                
                component.set("v.leadRecordTypeId",$A.get("$Label.c.Qualifying_Lead_Record_Type"));
            }       
            console.log("Lead recordtype id " + component.get("v.leadRecordTypeId"));
            //End: Updated by Rajendra for NAIT-141988 - 02988308 - G&T: Qualifying Deal Primary Competitor
            
        }
        else if(component.get("v.isClassic") == 'Yes')
        {
            
            console.log('Test'+component.get("v.Id"));
            if(component.get("v.isSite") == 'false')
            {
                component.find("AccountId").set("v.value",component.get("v.Id"));  
                component.find("RelatedSite").set("v.value",component.get("v.SiteName"));
                component.find("Company").set("v.value",component.get("v.AccName"));
            }
            else
            {
                component.find("AccountId").set("v.value",component.get("v.Id"));  
                component.find("RelatedSite").set("v.value",component.get("v.SiteName"));
                component.find("Company").set("v.value",component.get("v.AccName"));
            }   
        }        
    },
    
    onRecordSubmit: function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var eventFields = event.getParam("fields");
        
        console.log('event fields-->'+$A.get("$Label.c.Qualifying_Lead_Record_Type"));
        /*var profiles_label = $A.get("$Label.c.Qualifying_Lead_GT_Profiles");
        var currentUserProfile = component.get("v.ProfileLoggedIn"); 
        var isGTUser = false;      
        if(profiles_label){
            profiles_label = profiles_label.toLocaleLowerCase();
            currentUserProfile = currentUserProfile.toLocaleLowerCase();
            var profiles = profiles_label.split(",");
            for (let i = 0; i < profiles.length; i++) {
                if((profiles[i]).trim() === currentUserProfile){
                    isGTUser = true;
                    break;
                }
            }
        }*/
        if(component.get("v.isGTUser")){
            eventFields["RecordTypeId"] = $A.get("$Label.c.Qualifying_Lead_GT_Record_Type");
        }else{
            eventFields["RecordTypeId"] = $A.get("$Label.c.Qualifying_Lead_Record_Type");
        }       
        //eventFields["Lang_in_contract_for_Perf_Notif_Requirem__c"] = PenaltyPicklistToBeStored;
        component.find('myForm11').submit(eventFields);
        
        document.getElementById("ToastMessage").style.display = 'block';
        document.getElementById("spinnerDiv").style.display = 'block';
        
    },
    
    ClosePage : function(component, event, helper) {
        console.log('=>',component.find("AccountId").get("v.value"));
        if(component.get("v.recordId") ){
            $A.get("e.force:closeQuickAction").fire();
        }else if( (component.find("RelatedSite").get("v.value") == null && component.find("AccountId").get("v.value") == null)){
            let flowUrl = window.location.protocol + '//' + window.location.hostname + '/lightning/o/Opportunity/list?filterName=Recent';
            location.replace(flowUrl);
        }else{
            let Id ='';
            if(component.find("RelatedSite").get("v.value")){
                Id = component.find("RelatedSite").get("v.value");
            }else{
                Id = component.find("AccountId").get("v.value");
            }
            let flowUrl = window.location.protocol + '//' + window.location.hostname + '/'+Id;
            location.replace(flowUrl);
        }      
    },
    
    handleSuccess : function(component, event, helper) {
        
        var payload = event.getParams().response;
        console.log(payload.id);
        location.replace($A.get("$Label.c.QualifyingLeadPage")+payload.id);
    },
    
    handleError : function(component,event,helper)
    {
        document.getElementById("ToastMessage").style.display = 'none';
        document.getElementById("spinnerDiv").style.display = 'none';
        var errors = event.getParams();
        //document.getElementById("ToastErrorMessage").style.display = 'block';
        
    }
})