/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountAssignments_Error_Batch_TC 
{

    static testMethod void myUnitTest() 
    {
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456780764859'; // update by Rahul S-389134
        acc.Oracle_Party_Site_Id__c = '12345678';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        insert acc;
        Account accSite = new Account ();
        accSite.name = 'SUN Test Account';
        accSite.BillingStreet = '1040 N 326 W';
        accSite.billingcity = 'Orem';
        accSite.BillingState = 'UT';
        accSite.Oracle_Party_Id__c = '12345678076-1';//Added by Lalit for S-414434
        accSite.Billingcountry = 'USA';
        accSite.Oracle_Party_Site_Id__c = '12345678-1';//Added by Lalit for S-414434
        accSite.AOPS_Cust_Id__c = '12345678';
        accSite.AOPS_Seq_ID__c = '12345678';
        insert accSite;
        // Start S-389134 by Rahul - Insert Account Team member
        list<AccountTeamMember> accTeamMembers = new list<AccountTeamMember>();
        AccountTeamMember accMember = new AccountTeamMember();
        User usr = Test_Utils.CreateUser();
        accMember.UserId = usr.Id;
        accMember.AccountId = acc.Id;
        accTeamMembers.add(accMember);
        AccountTeamMember accMember2 = new AccountTeamMember();
        accMember2.UserId = usr.Id;
        accMember2.AccountId = accSite.Id;
        accTeamMembers.add(accMember2);
        
        insert accTeamMembers;
        // END S-389134
        AccountAssignments__c assign1 = new AccountAssignments__c();
        assign1.AccountId__c = '123456';
        assign1.AccountType__c = 'A';
        assign1.Entity_Type__c = 'CUSTOMER';
        assign1.Entity_Id__c = '1234563456';
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
        assign2.Entity_Id__c = '1234567834';
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
        assign2.Status__c = 'TestData';
        
       insert assign2;        
   
        AccountAssignments__c assign3 = new AccountAssignments__c();
        assign3.AccountId__c = '1234567890';
        assign3.AccountType__c = 'S';
        assign3.Entity_Type__c = 'PROSPECT';
        assign3.Entity_Id__c = '12345678076';
        assign3.PrimaryEmpId__c = '179475';
        assign3.PrimaryEmpRole__c = 'TestRole';
        assign3.OverlayEmpID1__c = '104344';
        assign3.OverlayEmpRole1__c = '111111';
        assign3.Status__c = 'TestData'; // update by Rahul S-389134

        
        insert assign3; 
        // Start S-389134 by Rahul
        AccountAssignments__c assign4 = new AccountAssignments__c();
        assign4.AccountId__c = '1234567890';
        assign4.AccountType__c = 'A';
        assign4.Entity_Type__c = 'PROSPECT';
        assign4.Entity_Id__c = '12345678076';
        assign4.PrimaryEmpId__c = '179475';
        assign4.PrimaryEmpRole__c = 'TestRole';
        assign4.OverlayEmpID1__c = '104344';
        assign4.OverlayEmpRole1__c = '111111';
        assign4.Status__c = 'TestData';

        
        insert assign4; 
        // END S-389134
        
        Test.startTest();
      
        String strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c, Status__c, Error_Message__c '
                            +' from AccountAssignments__c where Status__c = \'TestData\'';
                            
        AccountAssignments_Error_Batch assignErrorBatch = new AccountAssignments_Error_Batch(strQuery);

        database.executebatch(assignErrorBatch, 200);
        Test.stopTest();

    }
}