@isTest
public class ReassignAccount_TC 
{
   public static testMethod void myUnitTest() 
{
          
Profile pf = [Select Id from Profile where Name = 'System Administrator'];
User u = new User();
u.FirstName = 'Test';
u.LastName = 'User';
u.Email = 'testuser@officedepot.com';
u.CompanyName = 'test.com';
u.Title = 'Test User';
u.Username = 'nitishuser@officedepot.com';
u.Alias = 'testuser';
u.CommunityNickname = 'Test User';
u.TimeZoneSidKey = 'America/Mexico_City';
u.LocaleSidKey = 'en_US';
u.EmailEncodingKey = 'ISO-8859-1';
u.ProfileId = pf.Id;
//u.Default_Group__c='All';
u.LanguageLocaleKey = 'en_US';
insert u;
system.runAs(u)
 {
Account acc = new Account();
acc.OwnerId=u.id; 
acc.name='test1';
insert acc;  

Reassignment_Queue__c rq = new Reassignment_Queue__c();
rq.Account__c = acc.id;
rq.Requestor__c = u.id;
rq.New_Owner__c = u.id;
rq.Approver__c = u.id;
rq.Status__c = 'Failed';
rq.Approve_Reject_Date__c= system.now();
insert rq;

test.starttest();
PageReference pgRef = Page.ReassignProspect;
Test.setCurrentPage(pgRef);
ApexPages.StandardController sc = new ApexPages.StandardController(acc);
ApexPages.currentPage().getParameters().put('id', acc.id);
ReassignAccount Resacc = new ReassignAccount(sc);
Resacc.createAssignment();
Resacc.SaveRecord();
Resacc.CancelRec();
Resacc.getaccList();
test.stoptest();



}
    
}
}