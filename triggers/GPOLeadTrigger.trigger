// Communities - creates a case whenever a new GPO_Lead__c record is created. 
// Test Class - com2GPOCommunityLandingController_TC
trigger GPOLeadTrigger on GPO_Lead__c (after Insert) {
    if (Trigger.isAfter && Trigger.isInsert) {
        system.debug('in trigger');
        List<Case> caseList = new List<Case>();
        Id queueId = [select Id from Group where Type = 'Queue' and Name = 'Communities Queue' limit 1][0].Id;
        for (GPO_Lead__c gpoLead: Trigger.New) {
             system.debug('in for loop' + gpolead.Private__c);
            if (gpoLead.Private__c){
                system.debug('in if statement');
                Case newCase = new Case();
                newCase.Subject = 'Communities Private User';
                newCase.AccountId = gpoLead.Account__c;
                newCase.AM_New_Business_Name__c = gpoLead.Business_Name__c;
                newCase.recordTypeid = Schema.SobjectType.Case.getRecordTypeInfosByName().get('AM Communities').getRecordTypeId();
                newCase.ownerId = queueId;
                newCase.GPO_User_Registration__c = gpolead.id;//sfdc GPO user record
                newCase.AM_Contact_Email__c = gpoLead.Email__c;
                newCase.AM_Contact_Phone__c = gpoLead.Phone__c;
                newCase.Number_of_Employees__c = gpoLead.WCW_Range__c;
                newCase.AM_New_Business_Name__c = gpoLead.Business_Name__c;
                newCase.AM_Ship_To_City__c = gpoLead.City__c	;
                newCase.AM_Ship_To_State__c = gpoLead.State__c;
                newCase.AM_Ship_To_Zip__c = gpoLead.Zip__c;
                newCase.AM_Contact_First_Name__c = gpoLead.first_name__c;
                newCase.AM_Contact_Last_Name__c = gpoLead.Last_Name__c;
                newCase.WRF_Website_URL__c = gpoLead.URL__c;
                newCase.IT_QA_Notes__c = gpoLead.Notes__c;
                newCase.AM_Ship_To_Address_1__c = gpoLead.address1__c;
                newCase.AM_Ship_To_Address_2__c = gpoLead.address2__c;
                newCase.Multiple_Ship_To__c = gpoLead.MultipleShipTo__c;
                newCase.AM_Delivery_Code__c = gpoLead.SSO_Id__c;
                newCase.PO_Number__c = gpoLead.PO_Number__c;
                newCase.CostCenter__c = gpoLead.Cost_Center__c  ;  
                newCase.Release__c = gpoLead.Release__c   ;
                newCase.Desktop__c = gpoLead.Desktop__c;
                newCase.Multiple_PO_Numbers__c = gpoLead.Multiple_PO_Numbers__c;
                newCase.Multiple_Cost_Centers__c = gpoLead.Multiple_Cost_Centers__c;
                newCase.Multiple_Releases__c = gpoLead.Multiple_Releases__c;
                newCase.Multiple_Desktops__c = gpoLead.Multiple_Desktops__c;
                caseList.add(newCase);
            }
        }
        
        try {
            insert caseList; 
        } catch(exception e){
            system.debug('INSERT FAILED');
        }
     }
}