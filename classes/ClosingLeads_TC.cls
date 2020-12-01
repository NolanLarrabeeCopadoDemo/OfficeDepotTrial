@isTest

public class ClosingLeads_TC {

 static testMethod void ClosingLeads_TC()

{

    Account acc = new Account();
    acc.Name = 'Account1';
    acc.Zip__c = '33496';
    acc.State__c = 'FL';
    insert acc;


    Lead ld = new Lead();
    ld.RecordtypeId = '012E000000093HI';
    ld.Company = 'Account1';
    ld.LastName = 'LeadTest';
    ld.Zip__c = '33496';
    ld.State__c = 'FL';
    ld.Status = 'Closed';
    ld.Sub_Status__c = 'Account Duplicate';
    ld.Closed_Date__c = System.today();
    ld.Close_Reason__c = 'Other';
    //Modified By Vipul Jain for Story#S-440209 [00810890 - Lead & Account De-Duplication Notification] on 7, October, 2016
    //START
    ld.LeadSource = 'Customer Service';
    //End - Vipul
    insert ld;




 }

}