global class UpdateAOPSFlag implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts,Database.stateful
{

    private String strQuery;      
    private String DEFAULT_QUERY ='Select Id,DBStampMillisec__C,AOPS_DB_TimeStamp__C,UserSetUpFlag__C, DNSFlag__C,CSLSetUpFlag__C,OrderSetUpFlag__C,AOPS_Assigned_AOPS_Account_ID__c ,DBStamp__C,ReadyToOrderFlag__c,RedirectFlag__c FROM Customer_Transition__c WHERE   Mod_2_Complete__c= \'N\'  and  (CSLSetUpFlag__C != null and   OrderSetUpFlag__C !=null  and UserSetUpFlag__C!=null)  limit 70'; 
    
    // Default Constructor
    global UpdateAOPSFlag ()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    
    //This constructor is called from the Batch Schedule method
    global UpdateAOPSFlag (String query)
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
       List<Customer_Transition__c> orginialCTList = scope;
       List<Customer_Transition__c> updatelist= new List<Customer_Transition__c> ();

       
    if(orginialCTList.size()>0){       
       for(integer i=0;i<orginialCTList.size();i++){
       
       String AOPSId;
       AOPSId=orginialCTList[i].AOPS_Assigned_AOPS_Account_ID__c ;  
             
       system.debug('@@AOPSId@@'+AOPSId);
       if(AOPSId !=null && AOPSId!=''){
       
         try{
         
         AOPS_Flag__c rec =[ select createddate,AOPS_DB_TimeStamp__c,DBStamp__c,DBStampMillisec__c,UserSetUpFlag__c,
         OrderSetUpFlag__c,CSLSetUpFlag__c,ReadyToOrderFlag__c,RedirectFlag__c,DNSFlag__c from AOPS_Flag__c 
         where AopsId__c=:AOPSId  order by AOPS_DB_TimeStamp__c desc,DBStampMillisec__c desc limit 1];
           if (rec !=null){
           
            /*customer_transition__C cust= [select Id,DBStampMillisec__C,AOPS_DB_TimeStamp__C,UserSetUpFlag__C,               
            DNSFlag__C,CSLSetUpFlag__C,OrderSetUpFlag__C,AOPS_Assigned_AOPS_Account_ID__c ,DBStamp__C,
            ReadyToOrderFlag__c,RedirectFlag__c
                           from Customer_transition__C 
                           where AOPS_Assigned_AOPS_Account_ID__c =:AOPSId];*/
                           
            customer_transition__C cust= new customer_transition__C ();
            cust.Id=  orginialCTList[i].Id;             
            cust.DBStampMillisec__C= rec.DBStampMillisec__C;
            cust.AOPS_DB_TimeStamp__C=rec.AOPS_DB_TimeStamp__C;
            cust.UserSetUpFlag__C=rec.UserSetUpFlag__C;
            cust.CSLSetUpFlag__C=rec.CSLSetUpFlag__C;
            cust.OrderSetUpFlag__C=rec.OrderSetUpFlag__C;
            cust.RedirectFlag__c=rec.RedirectFlag__c;
            cust.ReadyToOrderFlag__c=rec.ReadyToOrderFlag__c;
            cust.DNSFlag__c =rec.DNSFlag__c ;
            cust.DBStamp__c =rec.DBStamp__c ;
            cust.ProcessFlag__C=false;

            //if(  (cust.CSLSetUpFlag__C=='W' || cust.CSLSetUpFlag__C=='C')  &&  (cust.OrderSetUpFlag__C=='W' || cust.OrderSetUpFlag__C=='C')  &&  (cust.UserSetUpFlag__C=='W' || cust.UserSetUpFlag__C=='C') )
            //cust.ProcessFlag__C=false;
            updatelist.add(cust);
            //update cust;
                  system.debug('Success');

           }
         
         }
         catch(Exception e){}
       
       
       }
       
       }
       if(updatelist.size()>0)
       update updatelist;
       }
    
    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC)
    {    
    
    
     CustTransParentChildLevel__c PCLevel2 = [select AOPSFlagJobId__c,AOPSFlagInterval__C from 
            CustTransParentChildLevel__c limit 1];
        integer interval = 300;        
        if (PCLevel2.AOPSFlagJobId__c<> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.AOPSFlagJobId__c])
            system.abortJob(existingJob.id);
        }
        
        if(PCLevel2.AOPSFlagInterval__C!= null)
            interval = (Integer)PCLevel2.AOPSFlagInterval__C;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        UpdateAOPSFlag SentAOPS = new UpdateAOPSFlag();
        ID cronid = System.schedule( 'SentAOPS ' + sysTime, chronExpression, SentAOPS );    
        
        PCLevel2.AOPSFlagJobId__c= cronid;
        
        update PCLevel2;    
        
        
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        UpdateAOPSFlag SentAOPSObj = new UpdateAOPSFlag(strQuery);
        database.executebatch(SentAOPSObj , 99);
    } 
    
    
    
}