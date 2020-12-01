@isTest

private class OpportunityHistoryPopulateMonthly_TC
{
     static testMethod void oppTest()
    {
    
            Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
            User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
            insert u1; 
            
            System.runas(u1){
            
            Account acc = new Account();
            acc.Name='Test Account';
            insert acc;
            
            Opportunity opp = new opportunity();
            opp.accountid=  acc.id;
            opp.Name='Testopp';
            opp.product__c = 'K-12 Growth';
            opp.StageName='Verbal Win';
            opp.CloseDate=System.today();
            opp.Last_Stage_Change__c=DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3);
            opp.Watson_Door_Opener__c=true;
           // opp.Summary_Stage__c='Identify Prospect (1.0)';
            opp.amount=123.45;
            opp.PLOC_Opportunity_Stage__c='Identify Prospect (1.0)';
            opp.Product_Subtype__c='Other Equipment';
            opp.ownerId=u1.id;          
            opp.Watson_Notes__C='My text';
            insert opp;
            
            
                    
            
            Instructional_Lead_Consultant__c ILC = new Instructional_Lead_Consultant__c();
            ILC.user__c=u1.id;
            insert ILC;
            
            OpportunityTeamMember opm = new OpportunityTeamMember();
            opm.opportunityid=opp.id;
            opm.userId = u1.id;
            insert opm;
            
            Opportunity_Tracking_History__c  OTH = new Opportunity_Tracking_History__c();
            OTH.Opportunity__c=opp.id;
            OTH.Pipeline_Week__c='2016-W27';
            OTH.Amount__c=123.45;
            OTH.PLOC_stage__c='Identify Prospect (1.0)';
            OTH.PLOC_Old_Value__c='Identify Prospect (1.0)';
            OTH.Stage_Old_Value__c='90%-Execute';
            OTH.stage__C='90%-Execute';
            OTH.Opportunity_Owner__c=u1.id;
            OTH.Is_Watson__c=true;
            OTH.Product__c='K-12 Growth';
            OTH.Product_Sub_Type__c='Other Equipment';
            OTH.Watson_Notes__C='My text';
            OTH.Fiscal_Month__c='6';
            OTH.type__c='Monthly';
            OTH.fiscal_year__C='2016';
            //OTH.Summary_Stage__c=
            OTH.Opportunity_Team_Member__c=String.valueOf(u1.id);
            OTH.Close_Date__c=System.today();
            OTH.Watson_Door_Opener__c=true;
           // OTH.Stage_Age__c=Integer.valueof(DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3));
            OTH.Account__c=acc.id;
            insert OTH;
       
           Test.startTest();
           OpportunityHistoryPopulateMonthly c = new OpportunityHistoryPopulateMonthly();
           Database.executeBatch(c);
           Test.stopTest();
           
           }

    }          

        static testMethod void oppTest1()
    {
    
            Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
            User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
            insert u1; 
            
            System.runas(u1){
            
            Account acc = new Account();
            acc.Name='Test Account';
            insert acc;
            
            Stage_to_Summary_Stage__c Stge = new Stage_to_Summary_Stage__c();
            Stge.Stage__c='Qualify Prospect (2.0)';
            insert stge;
            
            
            
            
            
            Opportunity opp = new opportunity();
            opp.accountid=  acc.id;
            opp.Name='Testopp';
            opp.product__c = 'K-12 Growth';
            opp.StageName='Verbal Win';
            opp.CloseDate=System.today();
            opp.Last_Stage_Change__c=DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3);
            opp.Watson_Door_Opener__c=true;
           // opp.Summary_Stage__c='Identify Prospect (1.0)';
            opp.amount=123.45;
            opp.PLOC_Opportunity_Stage__c='Identify Prospect (1.0)';
            opp.Product_Subtype__c='Other Equipment';
            opp.ownerId=u1.id;          
            opp.Watson_Notes__C='My text';
            insert opp;
            
            opp.PLOC_Opportunity_Stage__c='Qualify Prospect (2.0)';
            opp.Last_Stage_Change__C = System.now();
            opp.Stage_Summary_Stage__C=stge.id;
            opp.Previous_PLOC_Opportunity_Stage__c='Identify Prospect (1.0)';
            opp.Previous_Summary_Stage__c='Qualify Prospect (2.0)';
            update opp;
           /*FiscalYearSettings FY = new FiscalYearSettings();
            FY.name='2016';
           insert FY;
            
            Period PR = new Period();
            PR.Number=12345;
           // PR.FiscalYearSettingsId=FY.id;
            PR.Type='Week';
            PR.StartDate=system.today();
            PR.EndDate=system.today();
            insert PR;*/
            
            
            Instructional_Lead_Consultant__c ILC = new Instructional_Lead_Consultant__c();
            ILC.user__c=u1.id;
            insert ILC;
            
            OpportunityTeamMember opm = new OpportunityTeamMember();
            opm.opportunityid=opp.id;
            opm.userId = u1.id;
            insert opm;
            
            Opportunity_Tracking_History__c  OTH = new Opportunity_Tracking_History__c();
            OTH.Opportunity__c=opp.id;
            OTH.Pipeline_Week__c='2016-W27';
            OTH.Amount__c=123.45;
            OTH.PLOC_stage__c='Identify Prospect (1.0)';
            OTH.PLOC_Old_Value__c='Identify Prospect (1.0)';
            OTH.Stage_Old_Value__c='90%-Execute';
            OTH.stage__C='90%-Execute';
            OTH.Opportunity_Owner__c=u1.id;
            OTH.Is_Watson__c=true;
            OTH.Product__c='K-12 Growth';
            OTH.Product_Sub_Type__c='Other Equipment';
            OTH.Watson_Notes__C='My text';
            OTH.Fiscal_Month__c='6';
            OTH.type__c='Weekly';
            OTH.fiscal_year__C='2016';
            //OTH.Summary_Stage__c=
            OTH.Opportunity_Team_Member__c=String.valueOf(u1.id);
            OTH.Close_Date__c=System.today();
            OTH.Watson_Door_Opener__c=true;
           // OTH.Stage_Age__c=Integer.valueof(DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3));
            OTH.Account__c=acc.id;
            insert OTH;
            
            
            
       
           Test.startTest();
           OpportunityHistoryPopulateWeekly c = new OpportunityHistoryPopulateWeekly();
           Database.executeBatch(c);
           Test.stopTest();
           
           }

    }            
                
                
            
}