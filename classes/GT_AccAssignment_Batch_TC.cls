@isTest
public class GT_AccAssignment_Batch_TC
{
    //public String YTD_Sales_Diff;
    
    public static testMethod void GT_AccAssignment_Batch_TC() 
    {
             
    //User u1 = GT_TestDataUtility.getTestUser('System Administrator');
    //Account acc1 = GT_TestDataUtility.getTestAccount(u1);
    
    
    
System.runAs(new user(ID = UserInfo.getUserID())){

    
        Profile profileObj = [select id from profile where name='System Administrator'];
    String profId = profileObj.id;
        user u = new user(Username='nbansal@acme.com',FirstName ='test1234', LastName='xyz1234', Alias='aa', CommunityNickname='aaa', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u.email='aabc@officedepot.com';
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c ='612207';
        u.GT_Employee_ID__c ='612207';
        u.IsActive=true;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.Token_Market_Builder__c ='xyz';
        Insert u;
        
    
        
        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='333333';
        s.Primary__c =true;
        s.user__c=u.id;
        insert s;
       
        Account acc = new Account ();
        acc.name = 'SUN'+u.name;
        acc.OMX_Primary_Key__c='654321';
        acc.Oracle_Party_Id__c = '654321';
        acc.AOPS_Cust_Id__c = '654321';
        acc.AOPS_Seq_ID__c = '654321';
        acc.OwnerID = u.id;// This is the salesforce User ID
        insert acc;
               
        user u1 = new user(Username='nbansal1@acme.com',FirstName ='test12', LastName='xyz13', Alias='b', CommunityNickname='ab', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u1.email='abc@officedepot.com';
        u1.MB_Expiration_Date__c = System.now().addminutes(1);
        u1.OD_Employee_ID__c ='612208';
        u1.GT_Employee_ID__c ='612208';
        u1.IsActive=true;
        u1.TimeZoneSidKey='America/Los_Angeles';
        u1.Token_Market_Builder__c ='xy';
        insert u1;
        
        Sales_Person__c s1= new Sales_Person__c();
        s1.IsActive__c=true;
        s1.Role_Relate_Id__c ='444444';
        s1.Primary__c =true;
        s1.user__c=u1.id;
        insert s1;
        
        Account acc1 = new Account ();
        acc1.name = 'SUN'+u1.name;
        acc1.OMX_Primary_Key__c='754321';
        acc1.Oracle_Party_Id__c = '754321';
        acc1.AOPS_Cust_Id__c = '754321';
        acc1.AOPS_Seq_ID__c = '754321';
        acc1.OwnerID = u.id;// This is the salesforce User ID
        insert acc1;
         
    
    //User u2 = GT_TestDataUtility.getTestUser('System Administrator');
    //Account acc2 = GT_TestDataUtility.getTestAccount(u2);
            Test.startTest();
    /*ErrorTracker__c et = new ErrorTracker__c();
    et.UserId__c = '612207';
    RecordType assignmentRecordType = [select id, name from recordtype where name ='Assignment' limit 1];
    et.recordtypeid=assignmentRecordType.id;
    insert et;*/
      
        AccountAssignments__c assign2 = new AccountAssignments__c();
        RecordType gtRecordType = [select id, name from recordtype where name ='GT' limit 1];
        assign2.RecordTypeid=gtRecordType.id;
        assign2.AccountId__c = '654321';
        assign2.AccountType__c = 'S';
        assign2.Entity_Type__c = 'CUSTOMER';
        assign2.Entity_Id__c = '654321';
        assign2.PrimaryEmpId__c = '612207';
        assign2.PrimaryEmpRole__c = '333333';
        assign2.OverlayEmpID1__c = '612208';
        assign2.OverlayEmpRole1__c = '444444';
        assign2.OverlayEmpID2__c = '595673';
        assign2.OverlayEmpRole2__c = '222222';
        assign2.OverlayEmpID3__c = '600980';
        assign2.OverlayEmpRole3__c = '333333';
        assign2.OverlayEmpID4__c = '652207';
        assign2.OverlayEmpRole4__c = '';
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
        assign2.Status__c = 'Open';
        
        
       insert assign2; 
       
         AccountAssignments__c assign3 = new AccountAssignments__c();
        assign3.AccountId__c = '654321';
        assign3.RecordTypeid=gtRecordType.id;
        assign3.AccountType__c = 'S';
        assign3.Entity_Type__c = 'PROSPECT';
        assign3.Entity_Id__c = '654321';
        assign3.PrimaryEmpId__c = '612208';
        assign3.PrimaryEmpRole__c = '444444';
        assign3.OverlayEmpID1__c = '612207';
        assign3.OverlayEmpRole1__c = '333333';
        assign3.Status__c = 'Open';
        
        
        insert assign3; 
        
        AccountAssignments__c assign4 = new AccountAssignments__c();
        assign4.AccountId__c = '654321';
        assign4.RecordTypeid=gtRecordType.id;
        assign4.AccountType__c = 'A';
        assign4.Entity_Type__c = 'PROSPECT';
        assign4.Entity_Id__c = '654321';
        assign4.PrimaryEmpId__c = '612207';
        assign4.PrimaryEmpRole__c = '333333';
        assign4.OverlayEmpID1__c = '612208';
        assign4.OverlayEmpRole1__c = '444444';
        assign4.Status__c = 'Open';
        
        insert assign4; 
        
        
        AccountAssignments__c assign5 = new AccountAssignments__c();
        assign5.AccountId__c = '754321';
        assign5.RecordTypeid=gtRecordType.id;
        assign5.AccountType__c = 'A';
        assign5.Entity_Type__c = 'PROSPECT';
        assign5.Entity_Id__c = '754321';
        assign5.PrimaryEmpId__c = '';
        assign5.PrimaryEmpRole__c = '111112';
        assign5.OverlayEmpID1__c = '612208';
        assign5.OverlayEmpRole1__c = '111111';
        assign5.Status__c = 'Open';
        
        
        insert assign5;
        
              AccountAssignments__c assign6 = new AccountAssignments__c();
        assign6.RecordTypeid=gtRecordType.id;
        assign6.AccountId__c = '754321';
        assign6.AccountType__c = 'S';
        assign6.Entity_Type__c = 'CUSTOMER';
        assign6.Entity_Id__c = '754321';
        assign6.PrimaryEmpId__c = '612207';
        assign6.PrimaryEmpRole__c = '333333';
        assign6.OverlayEmpID1__c = '612207';
        assign6.OverlayEmpRole1__c = '333333';
        assign6.OverlayEmpID2__c = '595673';
        assign6.OverlayEmpRole2__c = '222222';
        assign6.OverlayEmpID3__c = '600980';
        assign6.OverlayEmpRole3__c = '333333';
        assign6.OverlayEmpID4__c = '652207';
        assign6.OverlayEmpRole4__c = '';
         assign6.OverlayEmpID5__c = '234567';
        assign6.OverlayEmpRole5__c = '44444';
        assign6.OverlayEmpID6__c = '234567';
        assign6.OverlayEmpRole6__c = '44444';
        assign6.OverlayEmpID7__c = '234567';
        assign6.OverlayEmpRole7__c = '44444';
        assign6.OverlayEmpID8__c = '234567';
        assign6.OverlayEmpRole8__c = '44444';
        assign6.OverlayEmpID9__c = '234567';
        assign6.OverlayEmpRole9__c = '44444';
        assign6.OverlayEmpID10__c = '234567';
        assign6.OverlayEmpRole10__c = '44444';
        assign6.OverlayEmpID11__c = '612208';
        assign6.OverlayEmpRole11__c = '44444';
        /*assign6.OverlayEmpID12__c = '234567';
        assign2.OverlayEmpRole12__c = '44444';
        assign2.OverlayEmpID13__c = '234567';
        assign2.OverlayEmpRole13__c = '44444';
        assign2.OverlayEmpID14__c = '234567';
        assign2.OverlayEmpRole14__c = '44444';
        assign2.OverlayEmpID15__c = '234567';
        assign2.OverlayEmpRole15__c = '44444';
       
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
        assign2.OverlayEmpRole30__c = '44444';*/
        assign6.Status__c = 'Open';
        
        insert assign6;
     
        List <AccountAssignments__c> aacs = new List<AccountAssignments__c>();
        aacs.add(assign2);
        aacs.add(assign3);
        aacs.add(assign4);
        aacs.add(assign5);
        aacs.add(assign6);
                                 
   
        
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
        
        AccountTeamMember accTeam = new AccountTeamMember();
        accTeam.userId = u.id;
        accTeam.accountId = acc.id;
        insert accTeam;
        AccountTeamMember accTeam2 = new AccountTeamMember();
        accTeam2.userId = u1.id;
        accTeam2.accountId = acc1.id;
        
        insert accTeam2;
            system.runAs(u){
            ErrorTracker__c et = new ErrorTracker__c();
    et.UserId__c = '612207';
    RecordType assignmentRecordType = [select id, name from recordtype where name ='Assignment' limit 1];
    et.recordtypeid=assignmentRecordType.id;
  //  upsert et;
            }
        GT_AccAssignment_Batch assignBatch = new GT_AccAssignment_Batch();
          assignBatch.strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,'
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c, Status__c, Error_Message__c '
                            +' from AccountAssignments__c where Status__c != \'Processed\' and  RecordType.Name =\'GT\' and createddate >= yesterday' ;
                            
            
            
            
        database.executebatch(assignBatch, 100);
        System.schedule('Assignment Batch',CRON_EXP , assignBatch);
        Test.stopTest();
        }
    
    }
    }