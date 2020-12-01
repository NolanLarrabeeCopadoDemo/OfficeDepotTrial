// 
// (c) 2011 Appirio, Inc., Office Depot, Inc
//
// Test AssignmentService Class
//
// Review Status:  @DRAFT
//
// 2011-09-05     Virendra (Jaipur)  
// 2011-09-08     Joe Krutulis    changes to convert id from numeric to string
//                                changed ids to make them less likely to collide with Production Data
// 2011-09-19     Virendra      Changes regarding OverlayRep to assignments as per new csv format 
//
@isTest
private class AssignmentServiceTest {
  
  static testMethod void testAssignmentService() {
    User usr1 =  createTestUser('standarduser125@officedepot.com','.u144','usr41');
    User usr2 =  createTestUser('standarduser15@officedepot.com','.u446','use4r2');
    
//    User usr1 = Test_Utils.CreateUser();
 //   insert usr1;
    
   
    
    
 //   User usr2 = Test_Utils.CreateUser();
 //   insert usr2;
    
   


    
//       Account parentAccount = Test_Utils.GenerateAccount();
 //      insert parentAccount;
    
    
    List<User> testUsers = new List<User>();
    testUsers.add(usr1);
    testUsers.add(usr2);
    insert testUsers; 
    
    List<sales_person__c> testUsersSPid = new List<sales_person__c>();
    
    sales_person__c salesp1 = Test_Utils.createTestSalesPerson(usr1.Id,'testSales33Person');
    sales_person__c salesp2 = Test_Utils.createTestSalesPerson(usr2.Id,'testSalesPerson');
    
    
    
    
    List<Account> testAccounts = new List<Account>();
    
    Account acc1 = Test_Utils.GenerateAccount();
      insert acc1;
      acc1.oracle_party_site_id__c = '.a446';
      acc1.name = 'testAccount1';
       
      update acc1;
      
    Account acc2 = Test_Utils.GenerateAccount();
      insert acc2;
      acc2.oracle_party_site_id__c = '.a789';
      acc2.name = 'testAccount2';
      update acc1;
  
  
//       account.Name = lead.Company;
//       account.Zip__c = lead.PostalCode;
//       update account; 
       
     
    testAccounts.add(acc1);
    testAccounts.add(acc2);
    update testAccounts;
    
    for(Account acct:[Select id,ownerId from account where id in:testAccounts]){
        System.assertEquals(acct.ownerId,Userinfo.getUserId());
    }
    
    List<AssignmentService.Assignment> testAssinments = new List<AssignmentService.Assignment>();
    AssignmentService.Assignment assignment1 = createAssignments('.a446','.u144');
    
    //Below Statement causing to wrong User might be not exist :: Virendra Changed 
    //AssignmentService.Assignment assignment2 = createAssignments('.a789','.u235');
    
    AssignmentService.Assignment assignment2 = createAssignments('.a789','.u446');
    testAssinments.add(assignment1);
    testAssinments.add(assignment2);
    
    AssignmentService.updateAssignments(testAssinments);
    
    //Owner of Site Account has been Changed Now 
    Map<Id,User> userMap = new Map<Id,User>([Select id from user where id in :testUsers]);
    for(Account acct:[Select id,ownerId from account where id in:testAccounts]){
        if(acct.id == acc1.Id ){
          //System.assertEquals(acct.ownerId,'005E0000000R1yS');
        }else if(acct.id == acc2.Id ){
          //System.assertEquals(acct.ownerId,'005E0000000R1ySIAS');
        } 
    }
   
     //Create new TeamMember record for each Account As per accountOwner Changed and Given Overlays for each Assignment   
    Integer recordCount=0;
    List<Id> acctTeamMemberIds = new List<Id> (); 
    for(AccountTeamMember acctTeammember: [select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel 
                                         from AccountTeamMember 
                                         where AccountId in :testAccounts]){
         System.debug('::Team member User  Id ::'+acctTeammember.UserId);
        if(acctTeammember.id == acc1.Id ){
          //Store the AccountTeam memeber Id for Account1 to verify the existance of team member record on owner id change  
          acctTeamMemberIds.add(acctTeammember.id); 
          System.assertEquals(acctTeammember.UserId,userMap.get(usr1.id).id);
        }else if(acctTeammember.id == acc2.Id ){
          System.assertEquals(acctTeammember.UserId,userMap.get(usr2.id).id);
        }
        //System.assertEquals(acctTeammember.TeamMemberRole,'Overlay');     
        recordCount++;                                          
    }
    
    //Confirm for the number of records in AccountTeam Member 
    //System.assertEquals(recordCount,0);
     
    //Create new Account Share records for each account 
    recordCount=0;
    List<Id> acctAccountShareIds = new List<Id>();
     
    for(AccountShare accShare:[Select a.UserOrGroupId, a.RowCause, a.OpportunityAccessLevel,a.AccountAccessLevel, a.AccountId From AccountShare a where a.AccountId in :testAccounts]){
        if(accShare.id == acc1.Id ){
          //Store Account share id to confirm for the existance  when account owner Changes     
          acctAccountShareIds.add(accShare.id); 
          System.assertEquals(accShare.UserOrGroupId,userMap.get(usr1.id).id);
        }else if(accShare.id == acc2.Id ){
          System.assertEquals(accShare.UserOrGroupId,userMap.get(usr2.id).id);
        }  
        System.debug('::AccountShare ::'+accShare);
        recordCount++;      
    }                                          
     //Confirm for the number of records in Account Share
    //System.assertEquals(recordCount,2);
    
    List<Opportunity> opportunities = new List<Opportunity>();
     
    Opportunity testOpportunity = new Opportunity();  
    testOpportunity.Name = 'testOpp';
    testOpportunity.AccountId = acc1.Id;
    testOpportunity.StageName = '0%-Lost';
    testOpportunity.CloseDate = System.today().addDays(20);
    testOpportunity.Close_Reason__c = 'Other';
    opportunities.add(testOpportunity);
    
    Opportunity testOpportunity1 = new Opportunity();  
    testOpportunity1.Name = 'testOpp1';
    testOpportunity1.AccountId = acc2.Id;
    testOpportunity1.StageName = '0%-Lost';
    testOpportunity1.CloseDate = System.today().addDays(20);
    testOpportunity1.Close_Reason__c = 'Other';
    opportunities.add(testOpportunity1);
    
    insert opportunities;
    
    
    //Opportunity Share record for the Account owner will be not created for the New opportunity Of that Account
    List<OpportunityShare> oppShare = [Select o.UserOrGroupId, o.RowCause, o.OpportunityId, o.OpportunityAccessLevel, o.Id From OpportunityShare o
                                       where o.OpportunityId  in : opportunities];
    for(OpportunityShare oppSh:oppShare){    
      System.debug(':: Opportunity ::'+oppSh);
      if(oppSh.OpportunityId == testOpportunity.Id)
         System.assertNotEquals(oppSh.UserOrGroupId,userMap.get(usr1.id).id);
      else if(oppSh.OpportunityId == testOpportunity1.Id){}
         //System.assertNotEquals(oppSh.UserOrGroupId,userMap.get(usr2.id).id);
    } 
    
     
    //Change the Owner of Account now 
    User usr3 =  createTestUser('standarduser3@officedepot.com','.u987','usr3');
    insert usr3;              
    
    List<AssignmentService.Assignment> testAssinments1 = new List<AssignmentService.Assignment>();
    AssignmentService.Assignment assignment3 = createAssignments('.a446','.u987');
    testAssinments1.add(assignment3);
    
    AssignmentService.SiteStatus st = new AssignmentService.SiteStatus();
    List<AssignmentService.Assignment> testAssinments2 = new List<AssignmentService.Assignment>();
    AssignmentService.Assignment assignment4 = createAssignments('.a457','.u446');
    testAssinments1.add(assignment4);
    
    AssignmentService.updateAssignments(testAssinments2);
    
    AssignmentService.AssignmentStatus assignmentStatus = new AssignmentService.AssignmentStatus();
    AssignmentService.updateAssignmentsImpl(testAssinments1, assignmentStatus );
              
     //Owner of Site Account has been Changed Now 
    for(Account acct:[Select id,ownerId from account where id =:acc1.id]){
      //System.assertEquals(acct.ownerId,usr3.id);
    }
    
    //Old Records 
    List<AccountTeamMember> acctTeammembers = [select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel 
                                         from AccountTeamMember 
                                         where id in :acctTeamMemberIds];
    
    //Confirm no Old record  for Team Member Found 
    System.assertEquals(acctTeammembers.isEmpty(),true);
    
    List<AccountShare> accShares = [Select a.UserOrGroupId, a.RowCause, a.OpportunityAccessLevel,a.AccountAccessLevel, a.AccountId 
                                    From AccountShare a where id in :acctAccountShareIds];
                                    
   //Confirm no Old record for Account Share Found 
    System.assertEquals(acctTeammembers.isEmpty(),true);
    
    
    
  } 
  
  
  public static AssignmentService.Assignment createAssignments(String acctId,String primaryRepId){ 
    AssignmentService.Assignment assignment = new AssignmentService.Assignment();
    assignment.typeFlag = 'S';
    assignment.primaryRepId= primaryRepId;
    assignment.siteId = acctId;
    assignment.accountId = acctId;
    List<AssignmentService.OverlayRep> overlayReps = new List<AssignmentService.OverlayRep>();
     
    AssignmentService.OverlayRep ovrlRep = new AssignmentService.OverlayRep();
    ovrlRep.overlayRepId = '.u123';
    ovrlRep.overlayRepRole = 'Sales Manager';
    overlayReps.add(ovrlRep);
     
    AssignmentService.OverlayRep ovrlRep1 = new AssignmentService.OverlayRep();
    ovrlRep1.overlayRepId = '.u446';
    ovrlRep1.overlayRepRole = 'Account Manager';
    overlayReps.add(ovrlRep1);
     
    assignment.overlayReps = overlayReps;
    return assignment;
  }
  
  public static User createTestUser(String emailId,String employeeId,String usrName){
     Profile p = [select id from profile where name='Standard User'];
     User u = new User(alias = 'standt', email=emailId,
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,
            timezonesidkey='America/Los_Angeles', username=emailId+'@officedepot.com',
            OD_Employee_ID__c = employeeId);
     return u;
  }
  
 // public static Account createTestAccount(String accName,String partySiteId){
 //   Account testAccount = new Account(name=accName);
  //  testAccount.Oracle_Party_Site_ID__c = partySiteId;

 //   return testAccount;
 // }
  
 
  

   
}