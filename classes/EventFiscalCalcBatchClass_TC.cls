@isTest
public class EventFiscalCalcBatchClass_TC{
    static testmethod void testMethod1()
    {
        Event evntObj = new Event();
        evntObj.ActivityDate = Date.newinstance(2016,02,02);
        evntObj.Appointment_FiscalMonth__C = '02';
        evntObj.Appointment_FiscalYear__c = '2016';
        evntObj.ILC_Batch__C = true;
        evntObj.DurationInMinutes = 10;
        evntObj.ActivityDateTime = Date.newinstance(2016,02,02);
        insert evntObj;
        
        
        CustTransParentChildLevel__c  ctPCLobj = new CustTransParentChildLevel__c();
        ctPCLobj.Mod5LaunchBatchID__c = '08ef000000FKyhFAAT';
        ctPCLobj.Mod5LaunchBatchInterval__c = 10;
        ctPCLobj.Name = 'Parent_Child Test';
        insert ctPCLobj;
        
        test.startTest();
        EventFiscalCalcBatchClass evntFscl = new EventFiscalCalcBatchClass();
        database.executeBatch(evntFscl);
        test.StopTest();
    }
  
}