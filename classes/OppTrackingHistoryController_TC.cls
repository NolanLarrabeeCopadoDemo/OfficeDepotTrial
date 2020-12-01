@isTest

public class OppTrackingHistoryController_TC
{
    public integer owned{get;set;}
    public integer teamed{get;set;}
    public integer total{get;set;}
    public String stageName {get; set;}
    
     static testMethod void oppTest()
    { 
        Account acc = new Account();
        acc.name='test';
        insert acc;
        
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
        insert u1;
       
        Opportunity opp = new opportunity();
        opp.accountid=  acc.id;
        opp.Name='Testopp';
        opp.product__c = 'K-12 Growth';
        opp.StageName= 'Verbal Win' ;
        opp.CloseDate=System.today();
        opp.Last_Stage_Change__c=DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3);
        opp.Watson_Door_Opener__c=true;
        opp.amount=123.45;
        opp.PLOC_Opportunity_Stage__c='Identify Prospect (1.0)';
        opp.Product_Subtype__c='Other Equipment';
        opp.ownerId=u1.id;          
        opp.Watson_Notes__C='My text';
        insert opp;
    
         Opportunity_Tracking_History__c  OPH = new Opportunity_Tracking_History__c();
         OPH.Summary_Stage__c='1.Identify';
         OPH.Is_Watson__c =true;
         OPH.Pipeline_Week__c = '2016-W27';
         OPH.Type__c ='Weekly';
         OPH.Summary_Stage_Old_Value__c='1.Identify';
         OPH.opportunity__c=opp.id;
         OPH.Holistic_Flow_Stage__c='Pre - Work - 10%';
         insert OPH;
         
         
         Opportunity_History_Tracking_Fields__c OHTF =new Opportunity_History_Tracking_Fields__c();
         
         OHTF.Display_Order__c=2;
         OHTF.Display_Stage__c='Pre - Work - 10%';
         OHTF.Is_Watson__c=false;
         OHTF.name='test123';
         insert OHTF;
         
         FiscalYearSettings fiscalYear = [SELECT Id FROM FiscalYearSettings WHERE Name = :String.valueOf(System.Today().Year()) LIMIT 1];
                                             
         Period per = [SELECT Id, Number  FROM Period WHERE FiscalYearSettingsId = :fiscalYear.Id AND Type = 'Week' AND StartDate <= :System.Today() AND EndDate >= :System.Today() LIMIT 1];
        
         Test.startTest();
        PageReference pageRefer = page.WatsonPipeline;
        Test.setCurrentPage(pageRefer);
        OppTrackingHistoryController controller = new OppTrackingHistoryController();
        controller.pipelineWeek='2016-W27';
        
         OppTrackingHistoryController op = new OppTrackingHistoryController();
         list<OppTrackingHistoryController.StageWrapper>  wraplist = new List<OppTrackingHistoryController.StageWrapper>();    
         
         PageReference pageRef = Page.NonWatsonDBPDF;
         pageReference pageRef1 = Page.WatsonPipelinePdf;
         controller.createPDF();
         controller.createPdfWatson();
         //op.getCurrentFiscalWeek();
         controller.getNonWatsonValues();
         controller.getWatsonValues();
         Test.stoptest();
     
     }
      static testMethod void oppTest2()
    { 
        Account acc = new Account();
        acc.name='test';
        insert acc;
        
        Profile p4 = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u1 = new User(alias = 'test121', email='proxy@proxy56654.officedepot.com',OD_Employee_ID__c='225886',emailencodingkey='UTF-8', lastname='teOfficedepo',languagelocalekey='en_US',localesidkey='en_US',short_title__c = 'TSR', profileid = p4.Id,timezonesidkey='America/Los_Angeles',username='proxy@7878.com',isactive=true);
        insert u1;
       
        Opportunity opp = new opportunity();
        opp.accountid=  acc.id;
        opp.Name='Testopp';
        opp.product__c = 'K-12 Growth';
        opp.StageName= 'Verbal Win' ;
        opp.CloseDate=System.today();
        opp.Last_Stage_Change__c=DateTime.newInstanceGMT(2016,5, 29, 2, 2, 3);
        opp.Watson_Door_Opener__c=true;
        opp.amount=123.45;
        opp.PLOC_Opportunity_Stage__c='Identify Prospect (1.0)';
        opp.Product_Subtype__c='Other Equipment';
        opp.ownerId=u1.id;          
        opp.Watson_Notes__C='My text';
        insert opp;
    
         Opportunity_Tracking_History__c  OPH = new Opportunity_Tracking_History__c();
         OPH.Summary_Stage__c='10.End-of-Opportunity';
         OPH.Is_Watson__c =true;
         OPH.Pipeline_Week__c = '2016-W28';
         OPH.Type__c ='Weekly';
         OPH.Previous_Summary_Stage__c='Identify';
         OPH.opportunity__c=opp.id;
         OPH.Holistic_Flow_Stage__c='Pre - Work - 10%';
         insert OPH;
         
         
         Opportunity_History_Tracking_Fields__c OHTF =new Opportunity_History_Tracking_Fields__c();
         OHTF.Display_Order__c=2;
         OHTF.Display_Stage__c='Pre - Work - 10%';
         OHTF.Is_Watson__c=false;
         OHTF.name='test123';
         insert OHTF;
         
         Stage_to_Summary_Stage__c stageSumm = new Stage_to_Summary_Stage__c();
         stageSumm.Summary_Stage_Name__c = '9.Support';
         insert stageSumm;
         
         
         FiscalYearSettings fiscalYear = [SELECT Id FROM FiscalYearSettings WHERE Name = :String.valueOf(System.Today().Year()) LIMIT 1];
                                             
         Period per = [SELECT Id, Number  FROM Period WHERE FiscalYearSettingsId = :fiscalYear.Id AND Type = 'Week' AND StartDate <= :System.Today() AND EndDate >= :System.Today() LIMIT 1];
        
         Test.startTest();
        PageReference pageRefer = page.WatsonPipeline;
        Test.setCurrentPage(pageRefer);
        OppTrackingHistoryController controller = new OppTrackingHistoryController();
        controller.pipelineWeek='2016-W28';
         list<OppTrackingHistoryController.StageWrapper>  wraplist = new List<OppTrackingHistoryController.StageWrapper>();    
         
         PageReference pageRef = Page.NonWatsonDBPDF;
         pageReference pageRef1 = Page.WatsonPipelinePdf;
         controller.createPDF();
         controller.createPdfWatson();
         controller.getNonWatsonValues();
         controller.getWatsonValues();
         Test.stoptest();
     
     }
 }