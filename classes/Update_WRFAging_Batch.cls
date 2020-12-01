/***
Description: The Scope of this Batch Class is Case (WRF Record Type).
This will update Case with the Aging (KPI) for current status as well as CPM Apporvals if not Cancelled or Closed.

This single class implemnets Batchable interface.


Created By: Kishore Jena
Created Date: 25-SEP-2012

Modified By: Wipro Offshore
Modified Date: 22-MAR-2013

Modify Reason: Implemented different Business hours for Work Request and Account Maintenance.

Modified by Subhrajyoti.- 31stJan 2014
Comments - Deleted all the code for KPI as it is tracked in Record History. Added the code to calculate Total Approval Time and Actual Approval time.
**/
Global class Update_WRFAging_Batch implements database.Batchable<Sobject>,Schedulable
{
    public Datetime timenow = system.now(); // variable to capture time as of aging is being captured
    // Get the default business hours     
    public BusinessHours bh = [select id from businesshours where IsDefault=true];
    //Get the Account Maintainance hours
    public BusinessHours bh_AccMain = [select id from businesshours where name='Acct Maintenance'];
    public String strQuery; //this variable used to set query from test class or from shceduler if required

    // Get the last batch run time
    //Commented below line for Case #00827679
    //Case_Changes__c  Casemod = Case_Changes__c.getOrgDefaults();
    
    // Below is set a default query in case not set in test class or in scheduler
             
    private String DEFAULT_QUERY = 'Select id,Approval_Start_time__c,Status, Auto_Close_Date__c,Total_Hours_Approval__c,Approval_Status__c,Hours_Pending_Approval__c,Recordtypeid,' + 
                                   'CreatedDate,' +
                                   'WRF_Date_CPM_Launched__c,'+
                                   'Current_Approver__c, Current_Approval_Start__c' +                                                                                                        
                                   ' FROM Case ' +
                                   'Where (RecordType.Name =\'Work Request\' or '+
                                   'RecordType.Name =\'Account Maintenance\') and Status NOT IN (\'Cancelled\', \'Closed\') ' +
                                   'Order By LastModifiedDate asc';                                                                       
                                   
    /* Default Constructor*/
    global Update_WRFAging_Batch()
    {
        
        this.strQuery = DEFAULT_QUERY;
    }
    
    /*This costructor is called from the Batch Schedule method*/
    global Update_WRFAging_Batch(String query)
    {
        System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
        {    this.strQuery = query;
        }   
        else
        {
            this.strQuery = DEFAULT_QUERY;
        }
          
       
    }
    
    /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(strQuery);
    }
    
    /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {       
        List<Case> lstWRFs = scope;
        System.debug('SIZE LIST WRFs == '+lstWRFs.size());
        Schema.DescribeSObjectResult d1 = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> WRFRecType = d1.getRecordTypeInfosByName(); 
        System.Debug('The record type map'+WRFRecType);

  
        // Get the Last Batch run time
        //Commented below line for Case #00827679
        //Datetime lastrun = Casemod.WRF_Aging_Batch_Last_Run__c;

        Datetime starttime;
        
        // loop on the batch scope        
        for(Case objwrf: lstWRFs)
        {
            
            if (objwrf.Status == 'Awaiting Information' && objwrf.recordTypeId == WRFRecType.get('Work Request').getRecordTypeId()) 
            {
               if(objwrf.Auto_Close_Date__c<=System.Today() && objwrf.Auto_Close_Date__c!=null)
                {
                    System.Debug('Inside if');
                    objwrf.Status='Cancelled';
                    objwrf.IT_Action_Taken__c = 'Cancelled';
                    objwrf.Reason = 'No Field Response';
                }
            }
            
            // Created a time based workflow for the same
            //Added for the "Auto Close Acct Maint" Workflow as per Case # 00155545 -Begins
            if (objwrf.Status == 'Awaiting Information' && objwrf.recordTypeId == WRFRecType.get('Account Maintenance').getRecordTypeId()) 
            {
               if(objwrf.Auto_Close_Date__c<=System.Today() && objwrf.Auto_Close_Date__c!=null)
                {
                    System.Debug('Inside if accnt maintenance');
                    // Status update has been moved to work flow rule - Set AccMaint Auto Close No Field Reponse
                    // to avoid conflict between emails being sent for cancellation manually by the requestor
                    //objwrf.Status='Cancelled';
                    objwrf.IT_Action_Taken__c = 'Cancelled';
                    objwrf.Reason = 'No Field Response';
                }            
            
            }
            //Added for the "Auto Close Acct Maint" Workflow as per Case # 00155545 -Ends
            //Created a time based workflow for the same
            
            //Track Total hours in Approval
            if(objwrf.Approval_Start_time__c!=null && objwrf.recordTypeId == WRFRecType.get('Work Request').getRecordTypeId())
            {
                system.debug('Total');
                if(objwrf.recordTypeId == WRFRecType.get('Work Request').getRecordTypeId())
                {
                    objwrf.Total_Hours_Approval__c= (Businesshours.diff(bh.id,objwrf.Approval_Start_time__c, timenow)/(1000*60*60));
                }               
            } 
            //Track Actual Hours In Approval
            if(objwrf.WRF_Date_CPM_Launched__c!=null && objwrf.Approval_Status__c=='Pending Approval')  
            {
                system.debug('Actual');
                if(objwrf.recordTypeId == WRFRecType.get('Work Request').getRecordTypeId())
                {
                    objwrf.Hours_Pending_Approval__c = (objwrf.Hours_Pending_Approval__c ==null?0:objwrf.Hours_Pending_Approval__c )+ (Businesshours.diff(bh.id,objwrf.WRF_Date_CPM_Launched__c, timenow)/(1000*60*60));
                }               
            }   
        }                        
        // Update WRFs with right aging
        update lstWRFs;
    }
    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        // Capture time for the next batch run
        //Commented below line for Case #00827679
        /*Casemod.WRF_Aging_Batch_Last_Run__c = timenow;       
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
        Update_WRFAging_Batch assignBatch = new Update_WRFAging_Batch(strQuery);
        database.executebatch(assignBatch, 200);
    } 


}