@isTest
public class customItemToApproveController_TC {

public static Account account1;
public static Opportunity opp1;
public static Case case1;


@TestSetup
static void makeData(){
  String currentProfile = [SELECT Id,Name,Profile.Name FROM User WHERE Id = :UserInfo.getUserId()].Profile.Name;
        insert new  PROS_Access_Custom_Setting__c(Name = 'Draft_VIEW', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'Pricing Analyst_NO ACCESS', Profiles__c = currentProfile);
        insert new  PROS_Access_Custom_Setting__c(Name = 'In Review_VIEW', Profiles__c = currentProfile);
        
      
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'apTest', Email='standarduser@officedepot.com', 
                        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                        LocaleSidKey='en_US', ProfileId = p.Id, 
                        TimeZoneSidKey='America/Los_Angeles', UserName='mohit.test@officedepot.com');
      insert u;
      
      Admin_Config__c conf = new Admin_Config__c(Name = 'Default', Bypass_Triggers__c = String.valueOf(u.Id).substring(0,15), BatchSize__c = '500');
      INSERT conf;


      System.runas(u){
          List<User> usrs = DataFactory.createUserTestRecords('SubmitDOAApprovalTest', 5);
          Id Prospect_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
          Id parentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
          
          Account acc = new Account();
          acc.Name = 'Test';
          acc.Address1__c = 'New Testing';
          acc.City__c = 'City Test';
          acc.State__c = 'TMO';
          acc.Country__c = 'USA';
          acc.Zip__c = '12321';
          acc.RecordtypeId = Prospect_RecordTypeId;
          
          Account acc2 = new Account();
          acc2.Name = 'Test2';
          acc2.Address1__c = 'New Testing';
          acc2.City__c = 'City Test';
          acc2.State__c = 'TMO';
          acc2.Country__c = 'USA';
          acc2.Zip__c = '12321';
          acc2.Hierarchy__c = 'P';
          acc2.RecordtypeId = parentRecordTypeId;
          
          Account acc3 = new Account();
          acc3.Name = 'Test3';
          acc3.Address1__c = 'New Testing';
          acc3.City__c = 'City Test';
          acc3.State__c = 'TMO';
          acc3.Country__c = 'USA';
          acc3.Zip__c = '12321';
          acc3.Hierarchy__c = 'P';
          acc3.RecordtypeId = parentRecordTypeId;
          insert new List<Account> { acc, acc2, acc3 };
              
              // Opportunity opp = new Opportunity();
              //  opp.name = 'Test';
              // opp.AccountId = Acc.Id;
              // opp.StageName = 'Closed Won';
              // opp.CloseDate = date.today();
              //  opp.Type = 'New Customers';
              //  insert opp;
              
              CameleonCPQ__QxSetup__c  c = new CameleonCPQ__QxSetup__c(Name='Master',CameleonCPQ__QuoteModelName__c='OfficeDepot',CameleonCPQ__MappingSetName__c='New_Written_Agreement',CameleonCPQ__LinesManagementPolicy__c=1);
          insert c;
          
          // PROS_Access_Custom_Setting__c pacs1 = new PROS_Access_Custom_Setting__c(Name='In Review_VIEW', Profiles__c='Field Sales');
          //    PROS_Access_Custom_Setting__c pacs2 = new PROS_Access_Custom_Setting__c(Name='Draft_VIEW', Profiles__c='Field Sales');
          //   insert new List<PROS_Access_Custom_Setting__c> { pacs1, pacs2 };
          
          
          
          CameleonCPQ__QxQuote__c pq = new CameleonCPQ__QxQuote__c();
          pq.Name = 'Test_Quote_1';
          pq.CameleonCPQ__AccountId__c = acc.id;
          // pq.OpportunityId__c = opp.id;
          pq.Agreement_Term__c = 1;
          pq.CDM__c = UserInfo.getUserId();
          pq.Sales_Rep__c = usrs[0].Id;
          pq.CameleonCPQ__SyncStatus__c = 'COMPLETE';
          
          //insert pq;
          pq.Sales_Rep__c = usrs[0].Id;
          //update pq;
          
          Group grp = new Group();
          grp.name = 'Test Group1';
          grp.Type = 'Regular'; 
          Insert grp;
          
          
          GroupMember GM = new GroupMember();
          GM.GroupId = grp.ID;
          GM.UserOrGroupId = U.Id;
          Insert GM;
          
        
          
          Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
          Case cs = new Case();
        
          cs.recordTypeId = CaseRecType.get('SCOE Cases').getRecordTypeId();
          cs.WRF_Request_Type__c = 'Grandparent/Great Grandparent Maintenance';
          
          cs.accountId = acc.id;
          
          insert cs; 
          Case cs1 = new Case();
          cs1.recordTypeId = CaseRecType.get('SCOE Cases').getRecordTypeId();
          cs1.WRF_Request_Type__c = 'Grandparent/Great Grandparent Maintenance';
          cs1.accountId = acc.id;
            insert cs1;
          
          ID id1=cs.id;
          String s = 'tester12';
          String s1 = 'tester22';
          String s2 = '14/10/2020';
          String s3 = 'tester32';
          ID id2= cs1.id;
          SObject obj1= [Select Id,AccountId,Account.Name,Account.Cust_ID__c,WRF_Request_Type__c from Case where Id =:  cs.id limit 1];
          //SObject obj2= [Select Id,CameleonCPQ__AccountId__r.Name,CameleonCPQ__AccountId__r.Cust_ID__c,CameleonCPQ__AccountId__c from CameleonCPQ__QxQuote__c where Id =:  pq.id limit 1];
          
          customItemToApproveController.item_wrapper Wrapper = new customItemToApproveController.item_wrapper(id1,s,s1,s2,s3,id2,obj1);
          customItemToApproveController.item_wrapper WrapperQuote = new customItemToApproveController.item_wrapper(id1,s,s1,s2,s3,id2,new CameleonCPQ__QxQuote__c());
          
          //System.runas(u){
              /*Approval.ProcessSubmitRequest app1 = new Approval.ProcessSubmitRequest();
              app1.setObjectId(pq.id);
              
              Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
              req1.setObjectId(cs.id);
              // Submit on behalf of a specific submitter
              req1.setSubmitterId(u.Id); 
              
              // Submit the record to specific process and skip the criteria evaluation
            
              req1.setSkipEntryCriteria(true);
              
              // Submit the approval request for the account 
              //Approval.ProcessResult result = Approval.process(req1);
             
              
               // Create an approval for the account and submit
              Approval.ProcessSubmitRequest AccountRequest = new Approval.ProcessSubmitRequest();
              AccountRequest.setObjectId(pq.id);
              Approval.ProcessResult AccountRequestResult = Approval.Process(AccountRequest);
              ProcessInstanceWorkitem pworkItem = new ProcessInstanceWorkitem();
             // pworkItem.ActorId = u.Id;
              //pworkItem.OriginalActorId = u.Id;
              //pworkItem.ProcessInstanceId = AccountRequestResult.Id;
              //insert pworkItem;

              Approval.ProcessSubmitRequest AccountRequest1 = new Approval.ProcessSubmitRequest();
              AccountRequest1.setObjectId(cs.id);
              //Approval.ProcessResult AccountRequestResult1 = Approval.Process(AccountRequest1);
              //ProcessInstanceWorkitem pworkItem1 = new ProcessInstanceWorkitem();
              //pworkItem.ActorId = u.Id;
              //pworkItem.OriginalActorId = u.Id;
              //pworkItem.ProcessInstanceId = AccountRequestResult1.Id;
              //insert pworkItem;
//
             */
              
          //}
          
      }
}
  @isTest
  static void testTask(){
    test.startTest();
    customItemToApproveController testApproval = new customItemToApproveController();
      customItemToApproveController.DummyMethod();
    customItemToApproveController.cst();
    test.stopTest();
    
  }
}