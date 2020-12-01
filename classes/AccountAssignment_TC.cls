@isTest
private class AccountAssignment_TC //For AccountAssignment Trigger
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
        acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
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
        Test.startTest();
        AccountAssignments__c assign1 = new AccountAssignments__c();
        assign1.AccountId__c = '123456';
        assign1.AccountType__c = 'A';
        assign1.Entity_Type__c = 'CUSTOMER';
        assign1.Entity_Id__c = '123456';
        assign1.PrimaryEmpId__c = '000000';
        assign1.PrimaryEmpRole__c = '000000';
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
        
        assign1.OverlayEmpID16__c = '179556';
        assign1.OverlayEmpRole16__c = '11111';
        assign1.OverlayEmpID17__c = '595673';
        assign1.OverlayEmpRole17__c = '22222';
        assign1.OverlayEmpID18__c = '601832';
        assign1.OverlayEmpRole18__c = '333333';
        assign1.OverlayEmpID19__c = '234567';
        assign1.OverlayEmpRole19__c = '44444';
        assign1.OverlayEmpID20__c = '234567';
        assign1.OverlayEmpRole20__c = '44444';
        assign1.OverlayEmpID21__c = '234567';
        assign1.OverlayEmpRole21__c = '44444';
        assign1.OverlayEmpID22__c = '234567';
        assign1.OverlayEmpRole22__c = '44444';
        assign1.OverlayEmpID23__c = '234567';
        assign1.OverlayEmpRole23__c = '44444';
        assign1.OverlayEmpID24__c = '234567';
        assign1.OverlayEmpRole24__c = '44444';
        assign1.OverlayEmpID25__c = '234567';
        assign1.OverlayEmpRole25__c = '44444';
        assign1.OverlayEmpID26__c = '234567';
        assign1.OverlayEmpRole26__c = '44444';
        assign1.OverlayEmpID27__c = '234567';
        assign1.OverlayEmpRole27__c = '44444';
        assign1.OverlayEmpID28__c = '234567';
        assign1.OverlayEmpRole28__c = '44444';
        assign1.OverlayEmpID29__c = '234567';
        assign1.OverlayEmpRole29__c = '44444';
        assign1.OverlayEmpID30__c = '234567';
        assign1.OverlayEmpRole30__c = '44444';
        assign1.Status__c = 'open';
        
        insert assign1;
        
        List<AccountAssignments__c> aassignments_List = [Select Id, Entity_Id__c from AccountAssignments__c where  Id =:assign1.id];
        aassignments_List[0].Entity_Type__c = 'CUSTOMER';
        update aassignments_List;
        

       /* AccountAssignments__c assign2 = new AccountAssignments__c();
        assign2.AccountId__c = '12345678';
        assign2.AccountType__c = 'S';
        assign2.Entity_Type__c = 'CUSTOMER';
        assign2.Entity_Id__c = '12345678';
        assign2.PrimaryEmpId__c = '000000';
        assign2.PrimaryEmpRole__c = '000000';
        assign2.OverlayEmpID1__c = '104344';
        assign2.OverlayEmpRole1__c = '111111';
        assign2.OverlayEmpID2__c = '595673';
        assign2.OverlayEmpRole2__c = '222222';
        assign2.OverlayEmpID3__c = '600980';
        assign2.OverlayEmpRole3__c = '333333';
        assign2.OverlayEmpID4__c = '';
        assign2.OverlayEmpRole4__c = '';
        assign2.Status__c = 'open';
        
       insert assign2;        
   
        AccountAssignments__c assign3 = new AccountAssignments__c();
        assign3.AccountId__c = '1234567890';
        assign3.AccountType__c = 'S';
        assign3.Entity_Type__c = 'PROSPECT';
        assign3.Entity_Id__c = '1234567890';
        assign3.PrimaryEmpId__c = '000000';
        assign3.PrimaryEmpRole__c = '000000';
        assign3.OverlayEmpID1__c = '104344';
        assign3.OverlayEmpRole1__c = '111111';

        
        insert assign3; */
        
         
        }
}