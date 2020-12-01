/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
Description: This Is test class to do unit testing and check test code coverage for class 'AccountAssignments_Clean_Batch'.

Created By: Sunil Bansal
Created Date: 21-May-2012

Modified By:
Modified Date:

Modify Reason:
 
 */
@isTest
private class AccountAssignments_Clean_Batch_TC 
{

    static testMethod void myUnitTest() 
    {
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        insert acc;
        
        Account accSite = new Account ();
        accSite.name = 'SUN Test Account';
        accSite.BillingStreet = '1040 N 326 W';
        accSite.billingcity = 'Orem';
        accSite.BillingState = 'UT';
        accSite.Billingcountry = 'USA';
        accSite.Oracle_Party_Site_Id__c = '12345678';
        accSite.AOPS_Cust_Id__c = '12345678';
        accSite.AOPS_Seq_ID__c = '12345678';
        insert accSite;

        AccountAssignments__c assign1 = new AccountAssignments__c();
        assign1.AccountId__c = '123456';
        assign1.AccountType__c = 'A';
        assign1.Entity_Type__c = 'CUSTOMER';
        assign1.Entity_Id__c = '1234568763';
        assign1.PrimaryEmpId__c = '439874';
        assign1.PrimaryEmpRole__c = 'TestRole';
        assign1.OverlayEmpID1__c = '179556';
        assign1.OverlayEmpRole1__c = '11111';
        assign1.OverlayEmpID2__c = '595673';
        assign1.OverlayEmpRole2__c = '22222';
        assign1.OverlayEmpID3__c = '601832';
        assign1.OverlayEmpRole3__c = '333333';
        assign1.OverlayEmpID4__c = '234567';
        assign1.OverlayEmpRole4__c = '44444';
        assign1.OverlayEmpID5__c = '234567';
        assign1.OverlayEmpRole5__c = '44444';
        assign1.OverlayEmpID6__c = '234567';
        assign1.OverlayEmpRole6__c = '44444';
        assign1.OverlayEmpID7__c = '234567';
        assign1.OverlayEmpRole7__c = '44444';
        assign1.OverlayEmpID8__c = '234567';
        assign1.OverlayEmpRole8__c = '44444';
        assign1.OverlayEmpID9__c = '234567';
        assign1.OverlayEmpRole9__c = '44444';
        assign1.OverlayEmpID10__c = '234567';
        assign1.OverlayEmpRole10__c = '44444';
        assign1.OverlayEmpID11__c = '234567';
        assign1.OverlayEmpRole11__c = '44444';
        assign1.OverlayEmpID12__c = '234567';
        assign1.OverlayEmpRole12__c = '44444';
        assign1.OverlayEmpID13__c = '234567';
        assign1.OverlayEmpRole13__c = '44444';
        assign1.OverlayEmpID14__c = '234567';
        assign1.OverlayEmpRole14__c = '44444';
        assign1.OverlayEmpID15__c = '234567';
        assign1.OverlayEmpRole15__c = '44444';
        assign1.Status__c = 'TestData';
        
        insert assign1;

        AccountAssignments__c assign2 = new AccountAssignments__c();
        assign2.AccountId__c = '12345678';
        assign2.AccountType__c = 'S';
        assign2.Entity_Type__c = 'CUSTOMER';
        assign2.Entity_Id__c = '1234567238';
        assign2.PrimaryEmpId__c = '179475';
        assign2.PrimaryEmpRole__c = 'TestRole';
        assign2.OverlayEmpID1__c = '104344';
        assign2.OverlayEmpRole1__c = '111111';
        assign2.OverlayEmpID2__c = '595673';
        assign2.OverlayEmpRole2__c = '222222';
        assign2.OverlayEmpID3__c = '600980';
        assign2.OverlayEmpRole3__c = '333333';
        assign2.OverlayEmpID4__c = '';
        assign2.OverlayEmpRole4__c = '';
        assign2.Status__c = 'Processed';
        
        insert assign2;        
   
        AccountAssignments__c assign3 = new AccountAssignments__c();
        assign3.AccountId__c = '1234567890';
        assign3.AccountType__c = 'S';
        assign3.Entity_Type__c = 'PROSPECT';
        assign3.Entity_Id__c = '1234567845';
        assign3.PrimaryEmpId__c = '179475';
        assign3.PrimaryEmpRole__c = 'TestRole';
        assign3.OverlayEmpID1__c = '104344';
        assign3.OverlayEmpRole1__c = '111111';
        assign3.Status__c = 'Processed';
        
        insert assign3; 

        
        Test.startTest();
            DateTime dt = DateTime.now();
            String strQuery = 'Select Id from AccountAssignments__c where Status__c = \'Processed\' ';
            AccountAssignments_Clean_Batch assignCleanBatch = new AccountAssignments_Clean_Batch(strQuery);
            database.executebatch(assignCleanBatch, 2000);
            
            // added for the story #S-418600 (00715635) #START
            AccountAssignments_Clean_Batch assignCleanBatch1 = new AccountAssignments_Clean_Batch();
            AccountAssignments_Clean_Batch assignCleanBatch2 = new AccountAssignments_Clean_Batch('');
            
            String CRON_EXP = '0 0 0 3 9 ? 2022';       
            System.schedule('Assignment clean Batch',CRON_EXP , assignCleanBatch);
            
            system.assertNotEquals(assignCleanBatch2, null);
            
            // added for the story #S-418600 (00715635) #END
            
        Test.stopTest();

    }
}