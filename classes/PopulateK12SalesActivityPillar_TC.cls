@isTest
public class PopulateK12SalesActivityPillar_TC
{
    static testmethod void testMethod1()
    {   
        List<Instructional_Lead_Consultant__c>  ilcList = new List<Instructional_Lead_Consultant__c>();
        
        Opportunity oppObj = new Opportunity();
        oppObj.product__C =  'K-12 Growth';
        oppObj.Product_Subtype__c  = 'Printers';
        oppObj.StageName = '10%-Appointment Secured';
        oppObj.PLOC_Opportunity_Stage__c = 'Introduce Solution (4.0)';
        oppObj.Name = 'Opp Name';
        oppObj.CloseDate = Date.newInstance(2016,10,02);
        insert oppObj;
        
        Profile p1 = [select id from profile where name = 'System Administrator'];
        
        User us1 = new User(alias = 'us_12', email='proxy@proxy1478.officedepot.com',OD_Employee_ID__c='113455',emailencodingkey='UTF-8', lastname='lastnam2',languagelocalekey='en_US',localesidkey='en_US', profileid = p1.id,timezonesidkey='America/Los_Angeles',username='12proxy@proxy466.com');
        insert us1;
        
        List<Product_Subtypes_to_Pillar__c> proPlrList = new List<Product_Subtypes_to_Pillar__c>();
        Product_Subtypes_to_Pillar__c proPlr = new Product_Subtypes_to_Pillar__c();
        proPlr.Pillar__c = 'Content Exchange';
        proPlr.Watson__c = false;
        proPlrList.add(proPlr);
        insert proPlrList;
        
        ILC_Metric_Quota__c ilcMtrcQuota = new ILC_Metric_Quota__c();
        ilcMtrcQuota.Amount_Value__c = 23;
        ilcMtrcQuota.Appointments_Per_Month__c = 18;
        ilcMtrcQuota.Month_Past_Training_Date__c = 12;
        ilcMtrcQuota.Quota_Period__c = 'Fiscal Week';
        ilcMtrcQuota.Quota_Value__c = 10;
        ilcMtrcQuota.Summary_Stage__c = '3.Introduce';
        ilcMtrcQuota.Type__c = 'Non-Watson';
        insert ilcMtrcQuota;

        ILC_Stage_Milestone_Adjustment__c ilcStgObj = new ILC_Stage_Milestone_Adjustment__c();
        ilcStgObj.ILC_Name__c = us1.id;
        ilcStgObj.MileStone__c = 'WatsonOpportunity';
        ilcStgObj.Adjustment_Period__c = '4';
        ilcStgObj.Adjustment_ValueAmount__c = 5;
        insert ilcStgObj;
        
       Instructional_Lead_Consultant__c  ilcObj = new Instructional_Lead_Consultant__c();
        ilcObj.Non_Watson_Training_Date__c = Date.newInstance(2014,10,02);
        ilcObj.Region__c = 'West';
        ilcObj.Service_Date__c = Date.newInstance(2016,02,02);
        ilcObj.User__c = us1.id;
        ilcList.add(ilcObj);
        insert ilcList;
        
        K12_Sales_Activity__c k12Obj1 = new K12_Sales_Activity__c();
        k12Obj1.Pillar_Amount__c = 12;
        k12Obj1.Pillar_Monthly_Amount__c = 13;
        insert k12obj1;
        
        
        List<Opportunity> oppList = [select id from Opportunity where product__C =  'K-12 Growth' limit 1];
        system.debug('@@@@@@@@@@oppList Test class' + oppList);
        Opportunity_Tracking_History__c   oppTrkngHstryObj = new Opportunity_Tracking_History__c  ();
        oppTrkngHstryObj.type__c ='Monthly' ;
        oppTrkngHstryObj.Fiscal_Year__c = '2016';
        oppTrkngHstryObj.Opportunity__c =oppList[0].id;
        oppTrkngHstryObj.Fiscal_Month__c = '7';
        oppTrkngHstryObj.Amount__c = 1100;
        oppTrkngHstryObj.Opportunity_Owner__c = us1.id;
        oppTrkngHstryObj.Pillar_key__C = 'Content Exchange';
        insert oppTrkngHstryObj;
        
        
        K12_Sales_Activity__c k12Obj = new K12_Sales_Activity__c();
        k12Obj.Activity_Type__C='Pillar';
        insert k12Obj;
        
        
        Test.startTest();
        PopulateK12SalesActivityPillar PopClsObjPllr = new PopulateK12SalesActivityPillar();        
        database.executebatch(PopClsObjPllr);
        test.stoptest();
    }
    static testmethod void testMethod2()
    {   
        List<Instructional_Lead_Consultant__c>  ilcList = new List<Instructional_Lead_Consultant__c>();
        
        Opportunity oppObj = new Opportunity();
        oppObj.product__C =  'K-12 Growth';
        oppObj.Product_Subtype__c  = 'Printers';
        oppObj.StageName = '10%-Appointment Secured';
        oppObj.PLOC_Opportunity_Stage__c = 'Introduce Solution (4.0)';
        oppObj.Name = 'Opp Name';
        oppObj.CloseDate = Date.newInstance(2016,10,02);
        insert oppObj;
        
        Profile p1 = [select id from profile where name = 'System Administrator'];
        
        User us1 = new User(alias = 'us_12', email='proxy@proxy1478.officedepot.com',OD_Employee_ID__c='113455',emailencodingkey='UTF-8', lastname='lastnam2',languagelocalekey='en_US',localesidkey='en_US', profileid = p1.id,timezonesidkey='America/Los_Angeles',username='12proxy@proxy466.com');
        insert us1;
        
        List<Product_Subtypes_to_Pillar__c> proPlrList = new List<Product_Subtypes_to_Pillar__c>();
        Product_Subtypes_to_Pillar__c proPlr = new Product_Subtypes_to_Pillar__c();
        proPlr.Pillar__c = 'Content Exchange';
        proPlr.Watson__c = false;
        proPlrList.add(proPlr);
        insert proPlrList;
        
        ILC_Metric_Quota__c ilcMtrcQuota = new ILC_Metric_Quota__c();
        ilcMtrcQuota.Amount_Value__c = 23;
        ilcMtrcQuota.Appointments_Per_Month__c = 18;
        ilcMtrcQuota.Month_Past_Training_Date__c = 12;
        ilcMtrcQuota.Quota_Period__c = 'Fiscal Week';
        ilcMtrcQuota.Quota_Value__c = 10;
        ilcMtrcQuota.Summary_Stage__c = '3.Introduce';
        ilcMtrcQuota.Type__c = 'Non-Watson';
        insert ilcMtrcQuota;

        ILC_Stage_Milestone_Adjustment__c ilcStgObj = new ILC_Stage_Milestone_Adjustment__c();
        ilcStgObj.ILC_Name__c = us1.id;
        ilcStgObj.MileStone__c = 'WatsonOpportunity';
        ilcStgObj.Adjustment_Period__c = '4';
        ilcStgObj.Adjustment_ValueAmount__c = 5;
        insert ilcStgObj;
        
       Instructional_Lead_Consultant__c  ilcObj = new Instructional_Lead_Consultant__c();
        ilcObj.Non_Watson_Training_Date__c = Date.newInstance(2014,10,02);
        ilcObj.Region__c = 'East';
        ilcObj.Service_Date__c = Date.newInstance(2016,02,02);
        ilcObj.User__c = us1.id;
        ilcList.add(ilcObj);
        insert ilcList;
        
        
        List<Opportunity> oppList = [select id from Opportunity where product__C =  'K-12 Growth' limit 1];
        system.debug('@@@@@@@@@@oppList Test class' + oppList);
        Opportunity_Tracking_History__c   oppTrkngHstryObj = new Opportunity_Tracking_History__c  ();
        oppTrkngHstryObj.type__c ='Monthly' ;
        oppTrkngHstryObj.Fiscal_Year__c = '2016';
        oppTrkngHstryObj.Opportunity__c =oppList[0].id;
        oppTrkngHstryObj.Fiscal_Month__c = '7';
        oppTrkngHstryObj.Amount__c = 1100;
        oppTrkngHstryObj.Opportunity_Owner__c = us1.id;
        oppTrkngHstryObj.Pillar_key__C = 'Content Exchange';
        insert oppTrkngHstryObj;
        
        
        K12_Sales_Activity__c k12Obj = new K12_Sales_Activity__c();
        k12Obj.Activity_Type__C='Pillar';
        insert k12Obj;
        
        
        Test.startTest();
        PopulateK12SalesActivityPillar PopClsObjPllr = new PopulateK12SalesActivityPillar();        
        database.executebatch(PopClsObjPllr);
        test.stoptest();
    }
    static testmethod void testMethod3()
    {   
        List<Instructional_Lead_Consultant__c>  ilcList = new List<Instructional_Lead_Consultant__c>();
        
        Opportunity oppObj = new Opportunity();
        oppObj.product__C =  'K-12 Growth';
        oppObj.Product_Subtype__c  = 'Printers';
        oppObj.StageName = '10%-Appointment Secured';
        oppObj.PLOC_Opportunity_Stage__c = 'Introduce Solution (4.0)';
        oppObj.Name = 'Opp Name';
        oppObj.CloseDate = Date.newInstance(2016,10,02);
        insert oppObj;
        
        Profile p1 = [select id from profile where name = 'System Administrator'];
        
        User us1 = new User(alias = 'us_12', email='proxy@proxy1478.officedepot.com',OD_Employee_ID__c='113455',emailencodingkey='UTF-8', lastname='lastnam2',languagelocalekey='en_US',localesidkey='en_US', profileid = p1.id,timezonesidkey='America/Los_Angeles',username='12proxy@proxy466.com');
        insert us1;
        
        List<Product_Subtypes_to_Pillar__c> proPlrList = new List<Product_Subtypes_to_Pillar__c>();
        Product_Subtypes_to_Pillar__c proPlr = new Product_Subtypes_to_Pillar__c();
        proPlr.Pillar__c = 'Content Exchange';
        proPlr.Watson__c = false;
        proPlrList.add(proPlr);
        insert proPlrList;
        
        ILC_Metric_Quota__c ilcMtrcQuota = new ILC_Metric_Quota__c();
        ilcMtrcQuota.Amount_Value__c = 23;
        ilcMtrcQuota.Appointments_Per_Month__c = 18;
        ilcMtrcQuota.Month_Past_Training_Date__c = 12;
        ilcMtrcQuota.Quota_Period__c = 'Fiscal Week';
        ilcMtrcQuota.Quota_Value__c = 10;
        ilcMtrcQuota.Summary_Stage__c = '3.Introduce';
        ilcMtrcQuota.Type__c = 'Non-Watson';
        insert ilcMtrcQuota;

        ILC_Stage_Milestone_Adjustment__c ilcStgObj = new ILC_Stage_Milestone_Adjustment__c();
        ilcStgObj.ILC_Name__c = us1.id;
        ilcStgObj.MileStone__c = 'WatsonOpportunity';
        ilcStgObj.Adjustment_Period__c = '4';
        ilcStgObj.Adjustment_ValueAmount__c = 5;
        insert ilcStgObj;
        
       Instructional_Lead_Consultant__c  ilcObj = new Instructional_Lead_Consultant__c();
        ilcObj.Watson_Training_Date__c = Date.newInstance(2014,10,02);
        ilcObj.Region__c = 'East';
        ilcObj.Service_Date__c = Date.newInstance(2016,02,02);
        ilcObj.User__c = us1.id;
        ilcList.add(ilcObj);
        insert ilcList;
        
        
        List<Opportunity> oppList = [select id from Opportunity where product__C =  'K-12 Growth' limit 1];
        system.debug('@@@@@@@@@@oppList Test class' + oppList);
        Opportunity_Tracking_History__c   oppTrkngHstryObj = new Opportunity_Tracking_History__c  ();
        oppTrkngHstryObj.type__c ='Monthly' ;
        oppTrkngHstryObj.Fiscal_Year__c = '2016';
        oppTrkngHstryObj.Opportunity__c =oppList[0].id;
        oppTrkngHstryObj.Fiscal_Month__c = '7';
        oppTrkngHstryObj.Amount__c = 1100;
        oppTrkngHstryObj.Opportunity_Owner__c = us1.id;
        oppTrkngHstryObj.Pillar_key__C = 'Content Exchange';
        insert oppTrkngHstryObj;
        
        
        K12_Sales_Activity__c k12Obj = new K12_Sales_Activity__c();
        k12Obj.Activity_Type__C='Pillar';
        insert k12Obj;
        
        
        Test.startTest();
        PopulateK12SalesActivityPillar PopClsObjPllr = new PopulateK12SalesActivityPillar();        
        database.executebatch(PopClsObjPllr);
        test.stoptest();
    }
}