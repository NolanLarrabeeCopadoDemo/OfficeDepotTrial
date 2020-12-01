@isTest
public class OpportunityTeamMemberAfterDelete_TC{
    public static testMethod void OpportunityTeamMemberAfterDelete_TC() 
    {

       Opportunity opp=new opportunity();
       opp.name='ABC';
       opp.StageName = '100%-Won';
       opp.CloseDate = system.today();
       insert opp;
       
       Opportunity opp1=new opportunity();
       opp1.name='Opportunity 2 ';
       opp1.StageName = '100%-Won';
       opp1.CloseDate = system.today();
       insert opp1;
       
      Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
      User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true,Is_ILC_Rep__c = true);
      insert u1; 
              
       OpportunityTeamMember otm=new OpportunityTeamMember();
       otm.OpportunityId=opp.Id;
       otm.User = u1;
       otm.UserId = u1.id;
       insert otm;
       
       delete otm;
       
       
    }
}