// October 21 2016    Jessica Schilling     S-445717, OD Case 00796577  Modified the default query
//
global class CustTranOnDeckBatch implements database.Batchable<Sobject>,Schedulable
{

    //Variable Declaration
    public String strQuery;
    private Date dt = Date.today();
    //Modified below query JSCHILLING S-445717 10/21/2016 Modified so Written Agreement records are pulled 28 days before the Review Start Date
    //private String DEFAULT_QUERY = 'select id,account__C, account__r.ownerId,Status__c,Ready_for_Mod1__c,Review_Start_Date__c,Customer_Disposition__c,OMX_Primary_Key__c,Written_Agreement_Customer_No__c,Related_WRF_Case__c from Customer_Transition__c where X14_Days_before_Review_Start_Date__C < :dt and Ready_for_Mod1__c =false and (    (Status__c in (\'Scheduled\',\'ReScheduled\') and (Written_Agreement_Customer_No__c = NULL or Written_Agreement_Customer_No__c=\'\')) or ( Written_Agreement_Customer_No__c !=NULL and Customer_Disposition__c = \'Customer agrees to transition\'  and Status__c = \'Awaiting Disposition\' )) limit 1000';
    private String DEFAULT_QUERY = 'SELECT Id,account__C, account__r.ownerId,Status__c,Ready_for_Mod1__c,Review_Start_Date__c,Customer_Disposition__c,OMX_Primary_Key__c,Written_Agreement_Customer_No__c,Related_WRF_Case__c FROM Customer_Transition__c WHERE Ready_for_Mod1__c = false and (  (Status__c in (\'Scheduled\',\'ReScheduled\') and X14_Days_before_Review_Start_Date__C < :dt    and (Written_Agreement_Customer_No__c = NULL or Written_Agreement_Customer_No__c=\'\'))   or   ( Written_Agreement_Customer_No__c !=NULL and Customer_Disposition__c = \'Customer agrees to transition\'  and Status__c = \'Awaiting Disposition\' and X28_Days_before_Review_Start_Date__c < :dt)) limit 1000';

    
    /* Default Constructor*/
    global CustTranOnDeckBatch()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global CustTranOnDeckBatch(String query)
    {
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;        
        System.debug('QUERY IS---->'+strQuery);
    }
    // This method prepares the scope of the batch program based on the query result 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(strQuery);
    }
    
    // This method processes query result in batches 
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
       system.debug('>>>>scope>>>'+scope);
       List<Customer_Transition__c> ctList = scope;
       List<Customer_Transition__c> updatedCTList = new List<Customer_Transition__c>();
       List<Case> cases = new List<Case>();
       Id WRFRequestID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Work Request').getRecordTypeId();    
       Map<Id, Id> mapList = new Map<Id, Id>();
       //Changing records status to On Deck (14 Days before Review Start Date)
       for(Customer_Transition__c eachCT : ctList)
       {
       
                 //creating WRF only for a highest level written Parent
                 if(eachCT.Written_Agreement_Customer_No__c  !=null && 
                 (eachCT.Written_Agreement_Customer_No__c==eachCT.omx_primary_key__C) &&
                 eachCT.Customer_Disposition__c == 'Customer agrees to transition'  && 
                 eachCT.Status__c == 'Awaiting Disposition'  && eachCT.Related_WRF_Case__c==null){
                    Case Ca = New Case( );
                    ca.Accountid = eachCT.account__C;
                    ca.WRF_Requestor__c =  eachCT.account__r.OwnerId;  
                    ca.ownerId=eachCT.account__r.OwnerId;                    
                    Ca.Reason = 'WRF Request';
                    Ca.Priority = '3-Medium';
                    Ca.Status = 'Open';
                    Ca.RecordTypeId = WRFRequestID;  //Work Request 
                    Ca.WRF_Request_Type__c = 'Transition';
                    Ca.CPM_Required__c= True;
                    Ca.WRF_Finance__c = False;
                    Ca.WRF_Written_Agreement__c = 'Yes';
                    Ca.Approved_for_Analyst_Assignment__c = true;
                    cases.add(Ca);      
                  }
                         eachCT.status__c = 'On Deck';

       updatedCTList.add(eachCT);
       }
       if(cases.size()>0)
       insert cases;
       for(Case cas :cases){
         MapList.put(cas.AccountId,cas.Id);
       }
       
       if(updatedCTList.size() > 0){
       for(Customer_Transition__c eachCTRec : updatedCTList){
       eachCTRec.Related_WRF_Case__c= MapList.get(eachCTRec.Account__C);
       }
       update updatedCTList;
       
       }
       system.debug('>>>>updatedCTList>>>'+updatedCTList);
    }   
     // This method is to execute to relase some resources if any
   global void finish(Database.BatchableContext BC)
    {
    
    CustTransParentChildLevel__c PCLevel2 = [select CustTranOnDeckBatchID__c from CustTransParentChildLevel__c limit 1];
      integer interval = 60;        
     if (PCLevel2.CustTranOnDeckBatchID__c <> null) {
                      for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.CustTranOnDeckBatchID__c])
                         system.abortJob(existingJob.id);
            }
              
            DateTime sysTime = System.now().addSeconds(interval);
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
    
            CustTranOnDeckBatch custTranOnDeckBatchObj = new CustTranOnDeckBatch();
            ID cronid ;
            cronid = System.schedule( 'CustTranOnDeckBatch' + sysTime, chronExpression, custTranOnDeckBatchObj );    
            
            PCLevel2.CustTranOnDeckBatchID__c = cronid;
            
            update PCLevel2; 
            
    }
     /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        String query = '';
        CustTranOnDeckBatch custTranOnDeckBatchObj = new CustTranOnDeckBatch(query);
        if(!Test.isRunningTest())
        Database.executebatch(custTranOnDeckBatchObj, 1);   
    } 
 }