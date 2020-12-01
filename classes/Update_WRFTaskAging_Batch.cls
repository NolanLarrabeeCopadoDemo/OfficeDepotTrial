/***
Description: The Scope of this WRF Task Object.
This will update WRF Tasks with the Aging (KPI) for current status.

This single class implemnets Batchable interface.


Created By: Kishore Jena
Created Date: 26-SEP-2012

Modified By:
Modified Date:

Modify Reason:
**/
Global class Update_WRFTaskAging_Batch implements database.Batchable<Sobject>,Schedulable
{
    public Datetime timenow = system.now(); // variable to capture time as of aging is being captured
    // Get the default business hours     
    //public BusinessHours bh = [select id from businesshours where IsDefault=true];
    public Id bhId = Label.Default_BusinessHours_Id;
    public String strQuery; //this variable used to set query from test class or from shceduler if required

    // Get the last batch run time
     //Commented below line for Case #00827679
    //Case_Changes__c  Casemod = Case_Changes__c.getOrgDefaults();
    
    // Below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select id, LastModifiedDate, Name, Status__c, ' + 
                                   'CreatedDate, Under_Review_Date__c, Team_Review_Date__c, ' +
                                   'In_Progress_Date__c, Final_Review_Date__c, Awaiting_Action_Date__c, ' +
                                   'Hours_Not_Started_Current__c, Hours_Under_Review_Current__c,  ' +
                                   'Hours_Team_Review_Current__c, Hours_In_Progress_Current__c, ' +
                                   'Hours_Final_Review_Current__c, Hours_Awaiting_Info_Current__c FROM WRF_Task__c ' +
                                   'Where Status__c != \'Completed\' ' +
                                   'Order By LastModifiedDate asc';    

    /* Default Constructor*/
    global Update_WRFTaskAging_Batch()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    
    /*This costructor is called from the Batch Schedule method*/
    global Update_WRFTaskAging_Batch(String query)
    {
        System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(strQuery);
    }
    
    /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {       
        List<WRF_Task__c> lstWRFTasks = scope;
        System.debug('SIZE LIST WRFTasks == '+lstWRFTasks.size());
  
        // Get the Last Batch run time
        //Commented below line for Case #00827679
        //Datetime lastrun = Casemod.WRFTask_Aging_Batch_Last_Run__c;
        
        // loop on the batch scope        
        for(WRF_Task__c objwrftask: lstWRFTasks)
        {
            System.debug('WRF Task Name = ' +objwrftask.Name);            
            // Update the current status Aging Hours
            if (objwrftask.Status__c == 'Not Started') 
                objwrftask.Hours_Not_Started_Current__c = 
                  ((Businesshours.diff(bhId, objwrftask.CreatedDate, timenow)) / (1000*60*60));
            
            if (objwrftask.Status__c == 'Under Review')  
                objwrftask.Hours_Under_Review_Current__c = 
                  ((Businesshours.diff(bhId, objwrftask.Under_Review_Date__c, timenow)) / (1000*60*60));

            if (objwrftask.Status__c == 'Team Review')
                objwrftask.Hours_Team_Review_Current__c = 
                    ((Businesshours.diff(bhId, objwrftask.Team_Review_Date__c, timenow)) / (1000*60*60));

            if (objwrftask.Status__c == 'In Progress')  
               objwrftask.Hours_In_Progress_Current__c = 
                  ((Businesshours.diff(bhId, objwrftask.In_Progress_Date__c, timenow)) / (1000*60*60));

            if (objwrftask.Status__c == 'Final Review')
                objwrftask.Hours_Final_Review_Current__c = 
                  ((Businesshours.diff(bhId, objwrftask.Final_Review_Date__c, timenow)) / (1000*60*60));

            if (objwrftask.Status__c == 'Awaiting Action')
                objwrftask.Hours_Awaiting_Info_Current__c =                                                     
                  ((Businesshours.diff(bhId, objwrftask.Awaiting_Action_Date__c, timenow)) / (1000*60*60));
          }
          // Update WRF Tasks with right aging
          update lstWRFTasks;
    }
    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        // Capture time for the next batch run
        //Commented below line for Case #00827679
        /*Casemod.WRFTask_Aging_Batch_Last_Run__c = timenow;
        if(!Test.isRunningTest())
        {
            upsert Casemod;
        }*/
    }
    
    
    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Update_WRFTaskAging_Batch assignBatch = new Update_WRFTaskAging_Batch(strQuery);
        database.executebatch(assignBatch, 200);
    } 


}