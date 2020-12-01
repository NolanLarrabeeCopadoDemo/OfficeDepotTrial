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
private class AccountAssignments_Batch_TC 
{
    static testMethod void myUnitTest() 
    {
        
        
        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='111111';
        s.Primary__c =true;
        insert s;
        
        Sales_Person__c s1= new Sales_Person__c();
        s1.IsActive__c=true;
        s1.Role_Relate_Id__c ='222222';
        s1.Primary__c =true;
        insert s1;
        
        user u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM USER WHERE id =:UserInfo.getUserId()];
        
        user u = new user(Username='jasmet@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=u2.ProfileId, LanguageLocaleKey='en_US');
        //u.name = 'abc';
        u.email='aaabc@officedepot.com';
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c ='622207';
        //u.Manager = u1;
        u.IsActive=true;
        u.TimeZoneSidKey=u2.TimeZoneSidKey;
        u.Token_Market_Builder__c ='abc';
        Insert u;
        
        ErrorTracker__c et = new ErrorTracker__c();
        et.UserId__c = '622207';
        insert et;
        
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '1234567890'; // update by Rahul S-389134
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        acc.Sales_PersonID__c =s.id;
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
        assign1.Status__c = 'TestData';
        
        insert assign1;

        AccountAssignments__c assign2 = new AccountAssignments__c();
        assign2.AccountId__c = '12345678';
        assign2.AccountType__c = 'S';
        assign2.Entity_Type__c = 'CUSTOMER';
        assign2.Entity_Id__c = '1234590-O';
        assign2.PrimaryEmpId__c = '622207';
        assign2.PrimaryEmpRole__c = '123456';
        assign2.OverlayEmpID1__c = '104344';
        assign2.OverlayEmpRole1__c = '111111';
        assign2.OverlayEmpID2__c = '595673';
        assign2.OverlayEmpRole2__c = '222222';
        assign2.OverlayEmpID3__c = '600980';
        assign2.OverlayEmpRole3__c = '333333';
        assign2.OverlayEmpID4__c = '652207';
        assign2.OverlayEmpRole4__c = '';
        assign2.Status__c = 'TestData';
        
       insert assign2;        
   
        AccountAssignments__c assign3 = new AccountAssignments__c();
        assign3.AccountId__c = '1234567890';
        assign3.AccountType__c = 'S';
        assign3.Entity_Type__c = 'PROSPECT';
        assign3.Entity_Id__c = '1234590-OM';
        assign3.PrimaryEmpId__c = '622207';
        assign3.PrimaryEmpRole__c = '123456';
        assign3.OverlayEmpID1__c = '104344';
        assign3.OverlayEmpRole1__c = '111111';

        
        insert assign3; 
        
        AccountAssignments__c assign4 = new AccountAssignments__c();
        assign4.AccountId__c = '1234567890';
        assign4.AccountType__c = 'A';
        assign4.Entity_Type__c = 'PROSPECT';
        assign4.Entity_Id__c = '1234590-OMX';
        assign4.PrimaryEmpId__c = '622207';
        assign4.PrimaryEmpRole__c = '111111';
        assign4.OverlayEmpID1__c = '104344';
        assign4.OverlayEmpRole1__c = '111111';
        
        insert assign4; 
        
        
        AccountAssignments__c assign5 = new AccountAssignments__c();
        assign5.AccountId__c = '1234567890';
        assign5.AccountType__c = 'S';
        assign5.Entity_Type__c = 'ODN Customer';
        assign5.Entity_Id__c = '1234567890';
        assign5.PrimaryEmpId__c = '622209';
        assign5.PrimaryEmpRole__c = '111112';
        assign5.OverlayEmpID1__c = '104344';
        assign5.OverlayEmpRole1__c = '111111';
        
        insert assign5; 
        
        
        
        
        Datetime dt = System.now();
        String scheduleString='0';
        scheduleString+=' '+ dt.minute();
        scheduleString+=' '+ dt.hour();
        scheduleString+=' '+ dt.day();
        scheduleString+=' '+ dt.month();
        scheduleString+=' ?';
        scheduleString+=' '+ dt.year();     
        System.debug('currently scheduled.' + scheduleString); 

        String CRON_EXP = '0 0 0 3 9 ? 2022';       
        
        Test.startTest();
        AccountAssignments_Batch assignBatch = new AccountAssignments_Batch();
        assignBatch.strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c,Status__c, Error_Message__c'
                            +' from AccountAssignments__c where Status__c = \'TestData\'';
                            
        database.executebatch(assignBatch, 100);
        System.schedule('Assignment Batch',CRON_EXP , assignBatch);

       /* AccountAssignments_Error_Batch assignErrorBatch = new AccountAssignments_Error_Batch();
        assignErrorBatch.strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c,Status__c, Error_Message__c'
                            +' from AccountAssignments__c where Status__c = \'TestData\'';
        database.executebatch(assignErrorBatch, 200);
        System.schedule('Assignment error Batch',CRON_EXP , assignErrorBatch);*/
        Test.stopTest();

    }
    
    static testMethod void myUnitTest1() 
    {
        
        
        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='111111';
        s.Primary__c =true;
        insert s;
        
        Sales_Person__c s1= new Sales_Person__c();
        s1.IsActive__c=true;
        s1.Role_Relate_Id__c ='222222';
        s1.Primary__c =true;
        insert s1;
        
        //user u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM USER WHERE id =:UserInfo.getUserId()];
        Profile p = [select id from Profile where name='System Administrator' limit 1];
        
        User u = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'name',Email='Rep.name@officedepot.com', Username ='Rep.name@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='234567');
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.Token_Market_Builder__c ='abc';
        u.IsActive=true;
        Insert u;
        /*user u = new user(Username='jasmettest@acme.com',FirstName ='test123', LastName='xyz123', Alias='a', CommunityNickname='aa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', ProfileId=p.id, LanguageLocaleKey='en_US');
        //u.name = 'abc';
        u.email='aaabc@officedepot.com';
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c ='622207';
        //u.Manager = u1;
        u.IsActive=true;
        u.TimeZoneSidKey=u2.TimeZoneSidKey;
        u.Token_Market_Builder__c ='abc';
        Insert u;*/
        
        ErrorTracker__c et = new ErrorTracker__c();
        et.UserId__c = '622207';
        insert et;
        
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '1234567890'; // update by Rahul S-389134
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        acc.Sales_PersonID__c =s.id;
        insert acc;
        
        AccountTeamMember accTeamMember = new AccountTeamMember();
        accTeamMember.AccountId = acc.id;
        accTeamMember.UserId = u.id;
        accTeamMember.TeamMemberRole = 'Developer';
        
        insert accTeamMember;
        
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
        assign1.Entity_Id__c = '123456';
        assign1.PrimaryEmpId__c = '622207';
        assign1.PrimaryEmpRole__c = '111111';
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
        assign1.Status__c = 'TestData';
        
        insert assign1;

        AccountAssignments__c assign2 = new AccountAssignments__c();
        assign2.AccountId__c = '12345678';
        assign2.AccountType__c = 'S';
        assign2.Entity_Type__c = 'CUSTOMER';
        assign2.Entity_Id__c = '12345678';
        assign2.PrimaryEmpId__c = '622207';
        assign2.PrimaryEmpRole__c = '111111';
        assign2.OverlayEmpID1__c = '104344';
        assign2.OverlayEmpRole1__c = '111111';
        assign2.OverlayEmpID2__c = '595673';
        assign2.OverlayEmpRole2__c = '222222';
        assign2.OverlayEmpID3__c = '600980';
        assign2.OverlayEmpRole3__c = '333333';
        assign2.OverlayEmpID4__c = '652207';
        assign2.OverlayEmpRole4__c = '';
        assign2.Status__c = 'TestData';
        
       insert assign2;        
   
        AccountAssignments__c assign3 = new AccountAssignments__c();
        assign3.AccountId__c = '1234567890';
        assign3.AccountType__c = 'S';
        assign3.Entity_Type__c = 'PROSPECT';
        assign3.Entity_Id__c = '12345678';
        assign3.PrimaryEmpId__c = '622207';
        assign3.PrimaryEmpRole__c = '222222';
        assign3.OverlayEmpID1__c = '104344';
        assign3.OverlayEmpRole1__c = '111111';

        
        insert assign3; 
        
        AccountAssignments__c assign4 = new AccountAssignments__c();
        assign4.AccountId__c = '1234567890';
        assign4.AccountType__c = 'A';
        assign4.Entity_Type__c = 'PROSPECT';
        assign4.Entity_Id__c = '12345678';
        assign4.PrimaryEmpId__c = '622207';
        assign4.PrimaryEmpRole__c = '111111';
        assign4.OverlayEmpID1__c = '104344';
        assign4.OverlayEmpRole1__c = '111111';
        
        insert assign4; 
        
        
       /* AccountAssignments__c assign5 = new AccountAssignments__c();
        assign5.AccountId__c = '1234567890';
        assign5.AccountType__c = 'A';
        assign5.Entity_Type__c = 'PROSPECT';
        assign5.Entity_Id__c = '12345678';
        assign5.PrimaryEmpId__c = '622207';
        assign5.PrimaryEmpRole__c = '111111';
        assign5.OverlayEmpID1__c = '104344';
        assign5.OverlayEmpRole1__c = '111111';
        
        insert assign5; */

        
        
        Datetime dt = System.now();
        String scheduleString='0';
        scheduleString+=' '+ dt.minute();
        scheduleString+=' '+ dt.hour();
        scheduleString+=' '+ dt.day();
        scheduleString+=' '+ dt.month();
        scheduleString+=' ?';
        scheduleString+=' '+ dt.year();     
        System.debug('currently scheduled.' + scheduleString); 

        String CRON_EXP = '0 0 0 3 9 ? 2022';       
        
        Test.startTest();
        AccountAssignments_Batch assignBatch = new AccountAssignments_Batch();
        assignBatch.strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c,Status__c, Error_Message__c'
                            +' from AccountAssignments__c where Status__c = \'TestData\'';
                            
        database.executebatch(assignBatch, 100);
        System.schedule('Assignment Batch',CRON_EXP , assignBatch);

       /* AccountAssignments_Error_Batch assignErrorBatch = new AccountAssignments_Error_Batch();
        assignErrorBatch.strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c,Status__c, Error_Message__c'
                            +' from AccountAssignments__c where Status__c = \'TestData\'';
        database.executebatch(assignErrorBatch, 200);
        System.schedule('Assignment error Batch',CRON_EXP , assignErrorBatch);*/
        Test.stopTest();

    }
    
    static testMethod void myUnitTest2() 
    {
        
        
        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='111111';
        s.Primary__c =true;
        insert s;
        
        Sales_Person__c s1= new Sales_Person__c();
        s1.IsActive__c=true;
        s1.Role_Relate_Id__c ='222222';
        s1.Primary__c =true;
        insert s1;
        
        //user u2=[SELECT id,ProfileId,OD_Employee_ID__c,TimeZoneSidKey FROM USER WHERE id =:UserInfo.getUserId()];
        Profile p = [select id from Profile where name='System Administrator' limit 1];
        
        User u = new User(TimeZoneSidKey='America/Los_Angeles',ProfileId = p.id,LastName = 'Rep', FirstName = 'name',Email='Rep.name@officedepot.com', Username ='Rep.name@officedepot.com', Alias='test12', CommunityNickname='test Approve', LanguageLocaleKey='en_US', EmailEncodingKey='UTF-8', LocaleSidKey='en_US',OD_Employee_ID__c='234567');
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.Token_Market_Builder__c ='abc';
        u.IsActive=true;
        u.OMX_Rep_Number__c ='111111';
        Insert u;
        
        ErrorTracker__c et = new ErrorTracker__c();
        et.UserId__c = '622207';
        // Start update by Rahul S-389134
        Map<String,Schema.RecordTypeInfo> ErrorTrackerRecType = Schema.SObjectType.ErrorTracker__c.getRecordTypeInfosByName();
        if(ErrorTrackerRecType.get(Constants.ASSIGNMENT).getRecordTypeId() != null)
            et.recordTypeId = ErrorTrackerRecType.get(Constants.ASSIGNMENT).getRecordTypeId();
        insert et;
        // End S-389134
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '1234567890'; // update by Rahul S-389134
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';
        acc.OwnerID = '005E0000000lNbV';// This is the salesforce User ID
        //acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        acc.Sales_PersonID__c =s.id;
        acc.omx_primary_key__c = '123456';
        //acc.omx_primary_key__c = '123456';
        acc.primary_site__c = true;
        acc.OMX_Mainframe_Consignee_ID__c = 'OMX001';
        insert acc;
        
        AccountTeamMember accTeamMember = new AccountTeamMember();
        accTeamMember.AccountId = acc.id;
        accTeamMember.UserId = u.id;
        accTeamMember.TeamMemberRole = 'Developer';
        
        insert accTeamMember;
        
        Account accSite = new Account ();
        accSite.name = 'SUN Test Account';
        accSite.BillingStreet = '1040 N 326 W';
        accSite.billingcity = 'Orem';
        accSite.BillingState = 'UT';
        accSite.Billingcountry = 'USA';
        accSite.Oracle_Party_Site_Id__c = '12345678';
        accSite.AOPS_Cust_Id__c = '12345678';
        accSite.AOPS_Seq_ID__c = '12345678';
        acc.omx_primary_key__c = '123456';
        acc.primary_site__c = true;
        acc.OMX_Mainframe_Consignee_ID__c = 'OMX001';
        insert accSite;

        AccountAssignments__c assign1 = new AccountAssignments__c();
        assign1.RecordTypeId = '012E000000092uNIAQ';
        assign1.AccountId__c = '123456';
        assign1.AccountType__c = 'A';
        assign1.Entity_Type__c = 'CUSTOMER';
        assign1.Entity_Id__c = '123456';
        assign1.PrimaryEmpId__c = '622207';
        assign1.PrimaryEmpRole__c = '111111';
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
        assign1.Status__c = 'TestData';
        
        insert assign1;

        AccountAssignments__c assign2 = new AccountAssignments__c();
        assign1.RecordTypeId = '012E000000092uNIAQ';
        assign2.AccountId__c = '12345678';
        assign2.AccountType__c = 'S';
        assign2.Entity_Type__c = 'CUSTOMER';
        assign2.Entity_Id__c = '12345678';
        assign2.PrimaryEmpId__c = '622207';
        assign2.PrimaryEmpRole__c = '111111';
        assign2.OverlayEmpID1__c = '104344';
        assign2.OverlayEmpRole1__c = '111111';
        assign2.OverlayEmpID2__c = '595673';
        assign2.OverlayEmpRole2__c = '222222';
        assign2.OverlayEmpID3__c = '600980';
        assign2.OverlayEmpRole3__c = '333333';
        assign2.OverlayEmpID4__c = '652207';
        assign2.OverlayEmpRole4__c = '';
        assign2.Status__c = 'TestData';
        
       insert assign2;        
   
        AccountAssignments__c assign3 = new AccountAssignments__c();
        assign1.RecordTypeId = '012E000000092uNIAQ';
        assign3.AccountId__c = '1234567890';
        assign3.AccountType__c = 'S';
        assign3.Entity_Type__c = 'PROSPECT';
        assign3.Entity_Id__c = '12345678';
        assign3.PrimaryEmpId__c = '622207';
        assign3.PrimaryEmpRole__c = '222222';
        assign3.OverlayEmpID1__c = '104344';
        assign3.OverlayEmpRole1__c = '111111';

        
        insert assign3; 
        
        AccountAssignments__c assign4 = new AccountAssignments__c();
        assign1.RecordTypeId = '012E000000092uNIAQ';
        assign4.AccountId__c = '1234567890';
        assign4.AccountType__c = 'A';
        assign4.Entity_Type__c = 'ODS Customer'; // update by Rahul S-389134
        assign4.Entity_Id__c = '12345678';
        assign4.PrimaryEmpId__c = '622207';
        assign4.PrimaryEmpRole__c = '111111';
        assign4.OverlayEmpID1__c = '104344';
        assign4.OverlayEmpRole1__c = '111111';
        
        insert assign4; 
        // Start Added by Rahul S-389134
        AccountAssignments__c assign5 = new AccountAssignments__c();
        assign5.AccountId__c = '1234567890';
        assign5.AccountType__c = 'S';
        assign5.Entity_Type__c = 'ODS Customer';
        assign5.Entity_Id__c = '12345678';
        assign5.PrimaryEmpId__c = '622207';
        assign5.PrimaryEmpRole__c = '111111';
        assign5.OverlayEmpID1__c = '104344';
        assign5.OverlayEmpRole1__c = '111111';
        
        insert assign5; 
        // End  S-389134
        
        Datetime dt = System.now();
        String scheduleString='0';
        scheduleString+=' '+ dt.minute();
        scheduleString+=' '+ dt.hour();
        scheduleString+=' '+ dt.day();
        scheduleString+=' '+ dt.month();
        scheduleString+=' ?';
        scheduleString+=' '+ dt.year();     
        System.debug('currently scheduled.' + scheduleString); 

        String CRON_EXP = '0 0 0 3 9 ? 2022';       
        
        Test.startTest();
        AccountAssignments_Batch assignBatch = new AccountAssignments_Batch();
        assignBatch.strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c,Status__c, Error_Message__c'
                            +' from AccountAssignments__c where Status__c = \'TestData\'';
                            
        database.executebatch(assignBatch, 100);
        System.schedule('Assignment Batch',CRON_EXP , assignBatch);

       /* AccountAssignments_Error_Batch assignErrorBatch = new AccountAssignments_Error_Batch();
        assignErrorBatch.strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c,Status__c, Error_Message__c'
                            +' from AccountAssignments__c where Status__c = \'TestData\'';
        database.executebatch(assignErrorBatch, 200);
        System.schedule('Assignment error Batch',CRON_EXP , assignErrorBatch);*/
        Test.stopTest();

    }
}