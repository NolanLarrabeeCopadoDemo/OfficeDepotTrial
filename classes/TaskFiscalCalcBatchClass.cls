Global class TaskFiscalCalcBatchClass implements database.Batchable<Sobject>,Database.Stateful,Schedulable
{
    
    global String strQuery; //this variable used to set query from test class or from shceduler if required

    
    
    // Below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY ='Select Id,ActivityDate,Appointment_FiscalMonth__C,Appointment_FiscalYear__c'
                                   +'  FROM Task'
                                   +' WHERE ILC_Batch__C= true  Limit 100'; 
    /* Default Constructor*/
    global TaskFiscalCalcBatchClass ()
    {        
        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global TaskFiscalCalcBatchClass (String query)
    {
        System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
        {    
            this.strQuery = query;
        }   
        else
        {
            this.strQuery = DEFAULT_QUERY;
        }     
    system.debug('strQuery@@@'+strQuery);       
    }
    /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug('strQuery@@@'+strQuery);
        return Database.getQueryLocator(strQuery);
    }
     /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
    //Method to Update Fiscal Year and Fiscal month of appointments
        List<Task> taskList= scope;
        
        System.debug('&&&&&here');
                for( Task rec: taskList){
                
                
                Datetime dt1= rec.activityDate;
                Date DT = date.newinstance(dT1.year(), dT1.month(), dT1.day());
                try{
                Period perMonth = [SELECT Id, Number ,FiscalYearSettings.name FROM Period WHERE 
                Type = 'Month' AND StartDate <=: dt AND EndDate >=: dt LIMIT 1];                             
                rec.Appointment_FiscalMonth__C =string.valueof(perMonth.Number);
                rec.Appointment_FiscalYear__c=string.valueof(perMonth.FiscalYearSettings.name);
                rec.ILC_Batch__C=false;  
                }
                catch(Exception e){}             
               }
        if(taskList.size()>0)          
        update taskList;
                 
        
   }
   
      /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
    
                Integer batchscope=Integer.valueof(Label.BatchScope);

        CustTransParentChildLevel__c PCLevel2 = [select TaskFiscalCalcBatchId__c,TaskFiscalCalcBatchInterval__c from CustTransParentChildLevel__c limit 1];
        integer interval = 300;        
        if (PCLevel2.TaskFiscalCalcBatchId__c<> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.TaskFiscalCalcBatchId__c])
            system.abortJob(existingJob.id);
        }
        
        if(PCLevel2.TaskFiscalCalcBatchInterval__c != null)
            interval = (Integer)PCLevel2.TaskFiscalCalcBatchInterval__c;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        TaskFiscalCalcBatchClass TaskFis= new TaskFiscalCalcBatchClass  ();
        ID cronid = System.schedule( 'taskRec' + sysTime, chronExpression, TaskFis);    
        
        PCLevel2.TaskFiscalCalcBatchId__c= cronid;
        
        update PCLevel2;    
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        TaskFiscalCalcBatchClass  taskRec= new TaskFiscalCalcBatchClass (strQuery);
        database.executebatch(taskRec, 1);
    } 
          
}