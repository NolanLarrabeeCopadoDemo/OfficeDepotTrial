@isTest
private class TaskFiscalCalcBatchClass_TC
{
    
    static testMethod void myUnitTest() 
    {
    Task tsk = new Task();
    tsk.Appointment_FiscalMonth__c ='7';
    tsk.ActivityDate = date.today();
    tsk.Appointment_FiscalYear__c ='2016';
    tsk.ILC_Batch__C=true;
    insert tsk;
    
   
    
     CustTransParentChildLevel__c PCLevel2 = new CustTransParentChildLevel__c(name='test',
                                                    AddSeconds__c = 200,
                                                    AddHours__c = 200,
                                                    Parent_Child_Level__c = 'Parent',
                                                    CronID_DTL__c = '',
                                                    SOA_EndPoint__c='https://osbuat01.officedepot.com/',
                                                    soa_user__c='SVC-SFDCWS:SVC4sfd3');
        insert PCLevel2;
    
    TaskFiscalCalcBatchClass taskFis = new TaskFiscalCalcBatchClass();
   
    database.executebatch(taskFis);
    
    }
}