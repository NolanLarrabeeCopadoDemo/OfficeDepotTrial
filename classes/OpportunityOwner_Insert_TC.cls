@isTest
private class OpportunityOwner_Insert_TC
{

    static testMethod void OpportunityOwner_Insert_TC()
    {

        /*Schema.DescribeSObjectResult WR = Schema.SObjectType.WRF_Task__c; 
        Map<String,Schema.RecordTypeInfo> WRFMapByName = WR.getRecordTypeInfosByName();

        Schema.DescribeSObjectResult CR = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> CRFMapByName = CR.getRecordTypeInfosByName();*/
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test123 ', email='proxy@proxy456654.officedepot.com',OD_Employee_ID__c='125886',emailencodingkey='UTF-8', lastname='teOfficedepot',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
        insert u1; 
        system.runas(u1)
        {
          
        Admin_Config__c ad= new Admin_Config__c();
        ad.name ='Default';
        ad.Tech_Depot_Title__c = 'TSR';
        ad.Tech_Depot_Auto_Assign_Opp__c =true;
        ad.Tech_Depot_User__c ='salesforce';
        ad.BatchSize__c ='100';
        insert ad;
        
        Account acc = new Account();
        acc.Aops_seq_id__c='12345';
        acc.Name='Realted';
        insert acc;
        Account acc1 = new Account();
        acc1.Name='TestAcc';
        acc1.Aops_seq_id__c='12345-111';
        acc1.Related_account__c = acc.Id;
        acc1.Name='Test';
        insert acc1;
        Account acc2 = new Account();
        acc2.Name='Test';
        insert acc2;

        AccountTeamMember atm = new AccountTeamMember();
        atm.UserId = u1.Id;
        atm.AccountId = acc1.Id;
        insert atm;

        
        
 
        Test.StartTest();
        

            opportunity opp = new Opportunity();
            opp.accountid=  acc1.id;
            opp.LeadSource = 'BSD NET';
            opp.Name='Test';
            opp.product__c = 'tech';
            opp.StageName='90%-Execute';
            opp.CloseDate=System.today();
            insert opp;
            
            opportunity opp1 = new Opportunity();
            opp1.accountid=  acc1.id;
            opp1.LeadSource = 'BSD NET';
            opp1.Name='Test2';
            opp1.product__c = 'tech';
            opp1.StageName='0%-Lost';
            opp1.CloseDate=System.today();
            insert opp1;
            opp1.StageName='90%-Execute';
            update opp1;
            
            executeoncetest.oppemailsend=true;
            
            
        Test.StopTest();
       }    
    }
}