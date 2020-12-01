// 
// (c) 2015 Appirio, Inc.
//
//
// 23 September 2016     Connor Flynn S-440217 (OD 00816640)

@isTest

private class OpportunityHistoryWatsonStageChange_TC
{
     static testMethod void oppTest()
    {
    
            Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
            User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
            insert u1; 
            
             User u2 = new User(alias = 'test122', email='proxy@proxy566541.officedepot.com',OD_Employee_ID__c='225826',emailencodingkey='UTF-8', lastname='teOfficedepo1',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy12@7878.com',isactive=true);
            insert u2;
            
            system.runas(u2){

            Account acc = new Account();
            acc.Name='Test Account';
            insert acc;
            
            //Connor Flynn S-440217 (OD 00816640) Start
            Stage_to_Summary_Stage__c stageSumStage = new Stage_to_Summary_Stage__c(Summary_Stage_Name__c = 'PLOC (Assigned)', Stage_Nbr__c = 1);
            insert stageSumStage;
            //Connor Flynn S-440217 (OD 00816640) End

            Opportunity opp = new opportunity();
            opp.accountid=  acc.id;
            opp.Name='Testopp';
            //Connor Flynn S-440217 (OD 00816640) Start
            opp.Stage_Summary_Stage__c = stageSumStage.Id;
            //Connor Flynn S-440217 (OD 00816640) End
            opp.product__c = 'K-12 Growth';
            opp.StageName='Verbal Win' ;
            opp.CloseDate=System.today();
            opp.Last_Stage_Change__c=DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3);
            opp.Watson_Door_Opener__c=true;
            opp.amount=123.45;
            opp.PLOC_Opportunity_Stage__c='Identify Prospect (1.0)';
            //Connor Flynn S-440217 (OD 00816640) Start
            //opp.Product_Subtype__c='PLOC (Assigned)';
            opp.Product_Subtype__c='Watson for Education';
            //Connor Flynn S-440217 (OD 00816640) End
            opp.ownerId=u1.id;          
            opp.Watson_Notes__C='My text';
            opp.OwnerId=u1.id;
            insert opp;
            
            
                    
            
            Instructional_Lead_Consultant__c ILC = new Instructional_Lead_Consultant__c();
            ILC.user__c=u1.id;
            insert ILC;

            Instructional_Lead_Consultant__c ILC2 = new Instructional_Lead_Consultant__c();
            ILC2.user__c=u2.id;
            insert ILC2;
            
            OpportunityTeamMember opm = new OpportunityTeamMember();
            opm.opportunityid=opp.id;
            opm.TeamMemberRole='Team Member';
            opm.userId = u1.id;
            insert opm;

            //Connor Flynn S-440217 (OD 00816640) Start
            OpportunityTeamMember opm2 = new OpportunityTeamMember();
            opm2.opportunityid=opp.id;
            opm2.TeamMemberRole='Team Member';
            opm2.userId = u2.id;
            insert opm2;
            //Connor Flynn S-440217 (OD 00816640) END
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
            OTH.Fiscal_Month__c='7';
            OTH.type__c='Monthly';
            OTH.fiscal_year__C='2016';
            OTH.Summary_Stage__c='10.End-of-Opportunity';
           // OTH.pls_key__c =u1.id+'-10.End-of-Opportunity-7';
            OTH.Opportunity_Team_Member__c=String.valueOf(u1.id);
            OTH.Close_Date__c=System.today();
            OTH.Watson_Door_Opener__c=true;
           // OTH.Stage_Age__c=Integer.valueof(DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3));
            OTH.Account__c=acc.id;
            insert OTH;
       
           Test.startTest();
           OpportunityHistoryWatsonStageChange  c = new OpportunityHistoryWatsonStageChange();
           Database.executeBatch(c);
           Test.stopTest();
     }
    }          
    
    static testMethod void oppTest1()
    {
    
            Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
            User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
            insert u1; 
            
            User u2 = new User(alias = 'test122', email='proxy@proxy566541.officedepot.com',OD_Employee_ID__c='225826',emailencodingkey='UTF-8', lastname='teOfficedepo1',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy12@7878.com',isactive=true);
            insert u2;
            
            System.runas(u2){
            
            Account acc = new Account();
            acc.Name='Test Account';
            insert acc;
            
            Exchange_Rate__c exc = new Exchange_Rate__c();
            exc.Rate__c='10';
            insert exc;
            
            Instructional_Lead_Consultant__c ILC = new Instructional_Lead_Consultant__c();
            ILC.user__c=u2.id;
            insert ILC;
            
            
            Opportunity opp = new opportunity();
            opp.accountid=  acc.id;
            opp.Name='Testopp';
            opp.product__c = 'K-12 Growth';
            opp.StageName='Verbal Win' ;
            opp.CloseDate=System.today();
            opp.Last_Stage_Change__c=DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3);
            opp.Watson_Door_Opener__c=true;
           // opp.Summary_Stage__c='Identify Prospect (1.0)';
           // opp.amount=123.45;
            opp.PLOC_Opportunity_Stage__c='Qualify Prospect (2.0)';
            //Connor Flynn S-440217 (OD 00816640) Start
            //opp.Product_Subtype__c='PLOC (Assigned)';
            opp.Product_Subtype__c='Watson for Education';
            //Connor Flynn S-440217 (OD 00816640) End
            opp.ownerId=u1.id;          
            opp.Watson_Notes__C='My text';
            opp.OwnerId=u1.id;
            opp.recordtypeid=Label.GTOpportunity;
            opp.Committed_Forecast_CAD__c=100;
            opp.Amount_CAD__c=50;
            opp.Amount=5;
            opp.Committed_Forecast__c=10;
            insert opp;
            opp.PLOC_Opportunity_Stage__c='Onsite Discovery Workshop (6.5)';
            opp.StageName='Verbal Win' ;
            opp.Ownerid=u2.id;
            update opp;
            
            OpportunityTeamMember otm = new OpportunityTeamMember();
            otm.opportunityid=opp.id;
            otm.TeamMemberRole='Team Member';
            otm.userId = u1.id;
            insert otm;

            //Connor Flynn S-440217 (OD 00816640) Start
            OpportunityTeamMember otm2 = new OpportunityTeamMember();
            otm2.opportunityid=opp.id;
            otm2.TeamMemberRole='Team Member';
            otm2.userId = u1.id;
            insert otm2;
            //Connor Flynn S-440217 (OD 00816640) End
                  
           Opportunity_Tracking_History__c  OTH = new Opportunity_Tracking_History__c();
           OTH.Summary_Stage__c='10.End-of-Opportunity';
           OTH.type__c='WatsonStageChange';
           OTH.LaterChange__c = true;
           OTH.Fiscal_Month__c='7';
           OTH.Opportunity__c=opp.id;
           OTH.pls_key__c=u1.id+'-10.End-of-Opportunity-7';
           insert OTH;
           
            Opportunity_Team_Member_History__c opm = new Opportunity_Team_Member_History__c();
            opm.Opportunity__c=opp.id;
            opm.Summary_Stage__c='10.End-of-Opportunity';
            opm.Fiscal_Month__c='7';
            opm.Fiscal_Year__c='2016';
            opm.Type__c='WatsonStageChange';
            opm.User__c=u1.id;
            opm.key__c= u1.id+'-10.End-of-Opportunity-7';
            opm.Opportunity_Tracking_History__c=OTH.id;
            insert opm;
           
        }        
    }

    static testMethod void schedulableTest()
    {
    
            Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
            User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
            insert u1; 
            
             User u2 = new User(alias = 'test122', email='proxy@proxy566541.officedepot.com',OD_Employee_ID__c='225826',emailencodingkey='UTF-8', lastname='teOfficedepo1',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy12@7878.com',isactive=true);
            insert u2;
            
            System.runas(u2){

            Account acc = new Account();
            acc.Name='Test Account';
            insert acc;
            
            //Connor Flynn S-440217 (OD 00816640) Start
            Stage_to_Summary_Stage__c stageSumStage = new Stage_to_Summary_Stage__c(Summary_Stage_Name__c = 'PLOC (Assigned)', Stage_Nbr__c = 1);
            insert stageSumStage;
            //End

            Opportunity opp = new opportunity();
            opp.accountid=  acc.id;
            opp.Name='Testopp';
            //Connor Flynn S-440217 (OD 00816640) Start
            opp.Stage_Summary_Stage__c = stageSumStage.Id;
            //Connor Flynn S-440217 (OD 00816640) End
            opp.product__c = 'K-12 Growth';
            opp.StageName='Verbal Win' ;
            opp.CloseDate=System.today();
            opp.Last_Stage_Change__c=DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3);
            opp.Watson_Door_Opener__c=true;
            opp.amount=123.45;
            opp.PLOC_Opportunity_Stage__c='Identify Prospect (1.0)';
            //Connor Flynn S-440217 (OD 00816640) Start
            //opp.Product_Subtype__c='PLOC (Assigned)';
            opp.Product_Subtype__c='Watson for Education';
            //Connor Flynn S-440217 (OD 00816640) End
            opp.ownerId=u1.id;          
            opp.Watson_Notes__C='My text';
            opp.OwnerId=u1.id;
            insert opp;
            
            
                    
            
            Instructional_Lead_Consultant__c ILC = new Instructional_Lead_Consultant__c();
            ILC.user__c=u1.id;
            insert ILC;

            Instructional_Lead_Consultant__c ILC2 = new Instructional_Lead_Consultant__c();
            ILC2.user__c=u2.id;
            insert ILC2;
            
            OpportunityTeamMember opm = new OpportunityTeamMember();
            opm.opportunityid=opp.id;
            opm.TeamMemberRole='Team Member';
            opm.userId = u1.id;
            insert opm;

            //Connor Flynn S-440217 (OD 00816640) Start
            OpportunityTeamMember opm2 = new OpportunityTeamMember();
            opm2.opportunityid=opp.id;
            opm2.TeamMemberRole='Team Member';
            opm2.userId = u2.id;
            insert opm2;
            //Connor Flynn S-440217 (OD 00816640) END
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
            OTH.Fiscal_Month__c='7';
            OTH.type__c='Monthly';
            OTH.fiscal_year__C='2016';
            OTH.Summary_Stage__c='10.End-of-Opportunity';
           // OTH.pls_key__c =u1.id+'-10.End-of-Opportunity-7';
            OTH.Opportunity_Team_Member__c=String.valueOf(u1.id);
            OTH.Close_Date__c=System.today();
            OTH.Watson_Door_Opener__c=true;
           // OTH.Stage_Age__c=Integer.valueof(DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3));
            OTH.Account__c=acc.id;
            insert OTH;
            Test.startTest();
            String jobId = System.schedule('ScheduleApexClassTest', '0 0 0 15 3 ? 2022', new OpportunityHistoryWatsonStageChange());

           
            //OpportunityHistoryWatsonStageChange  c = new OpportunityHistoryWatsonStageChange();
           //Database.executeBatch(c);
           Test.stopTest();
        }
    }   
    
}