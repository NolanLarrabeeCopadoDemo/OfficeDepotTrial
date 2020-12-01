@isTest
public class AccountAssignmentBeforeTrigger_TC 
{
     public static testMethod void myUnitTest() 
    {
        list<AccountAssignments__c> AccAssign = new list<AccountAssignments__c>();
        //list<Account> Acclist = new List<Account>();
               
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = 'oracle';
        acc.AOPS_Cust_Id__c = 'Aopscust';
        acc.AOPS_Seq_ID__c = 'AopsSeq';
        acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        acc.Primary_Site__c = true;
        acc.OMX_Primary_Key__c = 'OMX0';
        insert acc;
        
        Account acc1 = new Account ();
        acc1.name = 'SUN Test Account';
        acc1.BillingStreet = '1040 N 326 W';
        acc1.billingcity = 'Orem';
        acc1.BillingState = 'UT';
        acc1.Billingcountry = 'USA';
        acc1.Oracle_Party_Id__c = 'oracle1';
        acc1.AOPS_Cust_Id__c = 'Aopscust1';
        acc1.AOPS_Seq_ID__c = 'AopsSeq1';
        acc1.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        acc1.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        acc1.Primary_Site__c = true;
        
        insert acc1;
        
        
       // Acclist.add(acc);
        //insert acc;
        
        Account accSite = new Account ();
        accSite.name = 'SUN Test Account';
        accSite.BillingStreet = '1040 N 326 W';
        accSite.billingcity = 'Orem';
        accSite.BillingState = 'UT';
        accSite.Billingcountry = 'USA';
        accSite.Oracle_Party_Site_Id__c = 'oracle2';
        accSite.AOPS_Cust_Id__c = 'Aopscust2';
        accSite.AOPS_Seq_ID__c = 'AopsSeq2';
        accSite.OMX_Primary_Key__c = 'OMX';
        accSite.Oracle_Party_Id__c = 'Oracle3';
         accSite.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        accSite.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        accSite.Primary_Site__c = true;
        accsite.Related_Account__c=acc.id; 
        //Acclist.add(accSite);
        insert accSite;

        Account accSite1 = new Account ();
        accSite1.name = 'SUN Test Account';
        accSite1.BillingStreet = '1040 N 326 W';
        accSite1.billingcity = 'Orem';
        accSite1.BillingState = 'UT';
        accSite1.Billingcountry = 'USA';
        accSite1.Oracle_Party_Site_Id__c = 'oracle4';
        accSite1.AOPS_Cust_Id__c = 'Aopscust3';
        accSite1.AOPS_Seq_ID__c = '';
        accSite1.OMX_Primary_Key__c = 'OMX1';
        accSite1.Oracle_Party_Id__c = 'Oracle1';
         accSite1.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        accSite1.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        accSite1.Primary_Site__c = true;
        accsite1.Related_Account__c=acc1.id; 
       
       
        AccountAssignments__c assign1 = new AccountAssignments__c();
        assign1.AccountId__c = '12456';
        assign1.Account__c=acc.id;
        assign1.Ex_Id__c ='12456';
        assign1.AccountType__c = 'S';
        assign1.Entity_Type__c = 'ODN Customer';
        assign1.Entity_Id__c = 'OMX0';
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
        assign1 .Status__c= 'open';
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
       
        AccAssign.add(assign1);
        //insert assign1;

        AccountAssignments__c assign2 = new AccountAssignments__c();
        assign2.AccountId__c = '123456';
        assign1.Ex_Id__c ='123456';
        assign2.AccountType__c = 'S';
        assign2.Entity_Type__c = 'ODS Customer';
        assign2.Entity_Id__c = 'AopsSeq2';
        assign2.PrimaryEmpId__c = '000000';
        assign2.PrimaryEmpRole__c = '000000';
        assign2.OverlayEmpID1__c = '179556';
        assign2.OverlayEmpRole1__c = '11111';
        assign2.OverlayEmpID2__c = '595673';
        assign2.OverlayEmpRole2__c = '22222';
        assign2.OverlayEmpID3__c = '601832';
        assign2.OverlayEmpRole3__c = '333333';
        assign2.OverlayEmpID4__c = '234567';
        assign2.OverlayEmpRole4__c = '44444';
        assign2.OverlayEmpID5__c = '234567';
        assign2.OverlayEmpRole5__c = '44444';
        assign2.OverlayEmpID6__c = '234567';
        assign2.OverlayEmpRole6__c = '44444';
        assign2.OverlayEmpID7__c = '234567';
        assign2.OverlayEmpRole7__c = '44444';
        assign2.OverlayEmpID8__c = '234567';
        assign2.OverlayEmpRole8__c = '44444';
        assign2.OverlayEmpID9__c = '234567';
        assign2.OverlayEmpRole9__c = '44444';
        assign2.OverlayEmpID10__c = '234567';
        assign2.OverlayEmpRole10__c = '44444';
        assign2.OverlayEmpID11__c = '234567';
        assign2.OverlayEmpRole11__c = '44444';
        assign2.OverlayEmpID12__c = '234567';
        assign2.OverlayEmpRole12__c = '44444';
        assign2.OverlayEmpID13__c = '234567';
        assign2.OverlayEmpRole13__c = '44444';
        assign2.OverlayEmpID14__c = '234567';
        assign2.OverlayEmpRole14__c = '44444';
        assign2.OverlayEmpID15__c = '234567';
        assign2.OverlayEmpRole15__c = '44444';
        assign2 .Status__c= 'open';
        assign2.OverlayEmpID16__c = '179556';
        assign2.OverlayEmpRole16__c = '11111';
        assign2.OverlayEmpID17__c = '595673';
        assign2.OverlayEmpRole17__c = '22222';
        assign2.OverlayEmpID18__c = '601832';
        assign2.OverlayEmpRole18__c = '333333';
        assign2.OverlayEmpID19__c = '234567';
        assign2.OverlayEmpRole19__c = '44444';
        assign2.OverlayEmpID20__c = '234567';
        assign2.OverlayEmpRole20__c = '44444';
        assign2.OverlayEmpID21__c = '234567';
        assign2.OverlayEmpRole21__c = '44444';
        assign2.OverlayEmpID22__c = '234567';
        assign2.OverlayEmpRole22__c = '44444';
        assign2.OverlayEmpID23__c = '234567';
        assign2.OverlayEmpRole23__c = '44444';
        assign2.OverlayEmpID24__c = '234567';
        assign2.OverlayEmpRole24__c = '44444';
        assign2.OverlayEmpID25__c = '234567';
        assign2.OverlayEmpRole25__c = '44444';
        assign2.OverlayEmpID26__c = '234567';
        assign2.OverlayEmpRole26__c = '44444';
        assign2.OverlayEmpID27__c = '234567';
        assign2.OverlayEmpRole27__c = '44444';
        assign2.OverlayEmpID28__c = '234567';
        assign2.OverlayEmpRole28__c = '44444';
        assign2.OverlayEmpID29__c = '234567';
        assign2.OverlayEmpRole29__c = '44444';
        assign2.OverlayEmpID30__c = '234567';
        assign2.OverlayEmpRole30__c = '44444';
       
       
        AccAssign.add(assign2);
        insert AccAssign;  
        
        
    
     //test.starttest();
     AccountAssignmentUpdatingSitesClass AccAssignUpdate = new AccountAssignmentUpdatingSitesClass();
     AccAssignUpdate.updateAssignData(AccAssign);
     //test.stoptest();
   }
   
   }