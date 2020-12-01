@isTest
public class PopulateK12SalesActivityAppointment_TC
{
    static testmethod void testMethod1()
    {   
        List<Instructional_Lead_Consultant__c>  ilcList = new List<Instructional_Lead_Consultant__c>();
        List<Event>  envtLst = new List<Event>();
        String currentYear=String.valueof(System.Today().Year()); 
        Profile p1 = [select id from profile where name = 'System Administrator'];
        
        User us1 = new User(alias = 'us_12', email='proxy@proxy1478.officedepot.com',OD_Employee_ID__c='113455',emailencodingkey='UTF-8', lastname='lastnam2',languagelocalekey='en_US',localesidkey='en_US', profileid = p1.id,timezonesidkey='America/Los_Angeles',username='12proxy@proxy466.com');
        insert us1;
        system.runas(us1)
        {
        
        ILC_Metric_Quota__c ilcMtrcQuota = new ILC_Metric_Quota__c();
        ilcMtrcQuota.Amount_Value__c = 23;
        ilcMtrcQuota.Appointments_Per_Month__c = 18;
        ilcMtrcQuota.Month_Past_Training_Date__c = 3;
        ilcMtrcQuota.Quota_Period__c = 'Fiscal Week';
        ilcMtrcQuota.Quota_Value__c = 10;
        ilcMtrcQuota.Summary_Stage__c = '3.Introduce';
        ilcMtrcQuota.Type__c = 'Appointment';
        insert ilcMtrcQuota;
        
        ILC_Stage_Milestone_Adjustment__c ilcStgObj = new ILC_Stage_Milestone_Adjustment__c();
        ilcStgObj.ILC_Name__c = us1.id;
        ilcStgObj.MileStone__c = 'Appointment';
        ilcStgObj.Adjustment_Period__c = '4';
        ilcStgObj.Adjustment_ValueAmount__c = 5;
        insert ilcStgObj;
        
       Instructional_Lead_Consultant__c  ilcObj = new Instructional_Lead_Consultant__c();
        ilcObj.Non_Watson_Training_Date__c = Date.newInstance(2015,10,02);
        ilcObj.Region__c = 'West';
        ilcObj.Service_Date__c = Date.newInstance(2016,02,02);
        ilcObj.Termination_Date__c = Date.newInstance(2016,01,02);
        ilcObj.User__c = us1.id;
        ilcList.add(ilcObj);
        insert ilcList;
        
        Opportunity oppObj = new Opportunity();
        oppObj.product__C =  'K-12 Growth';
        oppObj.Product_Subtype__c  = 'Printers';
        oppObj.StageName = '10%-Appointment Secured';
        oppObj.PLOC_Opportunity_Stage__c = 'Introduce Solution (4.0)';
        oppObj.Name = 'Opp Name';
        oppObj.CloseDate = Date.newInstance(2016,10,02);
        insert oppObj;
        
        Event evntObj = new Event();
        evntObj.ownerId = us1.id;
        evntObj.ActivityDate = Date.Today();
        evntObj.ActivityDateTime = Date.newInstance(2010,10,02);
        evntObj.Task_Type__c = 'In Person';
        evntObj.DurationInMinutes = 10;
        evntObj.Appointment_FiscalMonth__C = '1';
        evntObj.whatId = oppObj.id;
        envtLst.add(evntObj);
        insert envtLst;
        
        K12_Sales_Activity__c k12Obj = new K12_Sales_Activity__c();
        k12Obj.Activity_Type__C='Appointment';
        k12Obj.FiscalYear__c = '2016';
        insert k12Obj;
        
        
        Test.startTest();
        PopulateK12SalesActivityAppointment PopClsObj = new PopulateK12SalesActivityAppointment();        
        database.executebatch(PopClsObj);
        test.stoptest();
    }
    }
     static testmethod void testMethod2()
    {   
        List<Instructional_Lead_Consultant__c>  ilcList = new List<Instructional_Lead_Consultant__c>();
        List<Event>  envtLst = new List<Event>();
        String currentYear=String.valueof(System.Today().Year()); 
        Profile p1 = [select id from profile where name = 'System Administrator'];
        
        User us1 = new User(alias = 'us_12', email='proxy@proxy1478.officedepot.com',OD_Employee_ID__c='113455',emailencodingkey='UTF-8', lastname='lastnam2',languagelocalekey='en_US',localesidkey='en_US', profileid = p1.id,timezonesidkey='America/Los_Angeles',username='12proxy@proxy466.com');
        insert us1;
        system.runas(us1)
        {
        
        ILC_Metric_Quota__c ilcMtrcQuota = new ILC_Metric_Quota__c();
        ilcMtrcQuota.Amount_Value__c = 23;
        ilcMtrcQuota.Appointments_Per_Month__c = 18;
        ilcMtrcQuota.Month_Past_Training_Date__c = 3;
        ilcMtrcQuota.Quota_Period__c = 'Fiscal Week';
        ilcMtrcQuota.Quota_Value__c = 10;
        ilcMtrcQuota.Summary_Stage__c = '3.Introduce';
        ilcMtrcQuota.Type__c = 'Appointment';
        insert ilcMtrcQuota;
        
        ILC_Stage_Milestone_Adjustment__c ilcStgObj = new ILC_Stage_Milestone_Adjustment__c();
        ilcStgObj.ILC_Name__c = us1.id;
        ilcStgObj.MileStone__c = 'Appointment';
        ilcStgObj.Adjustment_Period__c = '4';
        ilcStgObj.Adjustment_ValueAmount__c = 5;
        insert ilcStgObj;
        
       Instructional_Lead_Consultant__c  ilcObj = new Instructional_Lead_Consultant__c();
        ilcObj.Non_Watson_Training_Date__c = Date.newInstance(2015,10,02);
        ilcObj.Region__c = 'East';
        ilcObj.Service_Date__c = Date.newInstance(2016,02,02);
        ilcObj.Termination_Date__c = Date.newInstance(2016,01,02);
        ilcObj.User__c = us1.id;
        ilcList.add(ilcObj);
        insert ilcList;
        
        Opportunity oppObj = new Opportunity();
        oppObj.product__C =  'K-12 Growth';
        oppObj.Product_Subtype__c  = 'Printers';
        oppObj.StageName = '10%-Appointment Secured';
        oppObj.PLOC_Opportunity_Stage__c = 'Introduce Solution (4.0)';
        oppObj.Name = 'Opp Name';
        oppObj.CloseDate = Date.newInstance(2016,10,02);
        insert oppObj;
        
        Event evntObj = new Event();
        evntObj.ownerId = us1.id;
        evntObj.ActivityDate = Date.Today();
        evntObj.ActivityDateTime = Date.newInstance(2010,10,02);
        evntObj.Task_Type__c = 'In Person';
        evntObj.DurationInMinutes = 10;
        evntObj.Appointment_FiscalMonth__C = '1';
        evntObj.whatId = oppObj.id;
        envtLst.add(evntObj);
        insert envtLst;
        
        K12_Sales_Activity__c k12Obj = new K12_Sales_Activity__c();
        k12Obj.Activity_Type__C='Appointment';
        k12Obj.FiscalYear__c = '2016';
        insert k12Obj;
        
        
        Test.startTest();
        PopulateK12SalesActivityAppointment PopClsObj = new PopulateK12SalesActivityAppointment();        
        database.executebatch(PopClsObj);
        test.stoptest();
        }
    }
}