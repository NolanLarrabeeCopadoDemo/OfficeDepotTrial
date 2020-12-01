global class Mod5InsertCntcBatchV3 implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts,Database.stateful
{

    global String strQuery;
    global Set<Id> newAccSet;
    global Set<Id> originalAccIdSet;
    global Set<Id> originalCTidSet;
    global List<Customer_Transition__c> orginialCTList ;
    global List<Split_Account_Detail__c>    splitDetail;
    //global String DEFAULT_QUERY ='Select Id,account__c '
                              //     +' FROM Customer_Transition__c '
                                //   +'WHERE Mod4FlowStatus__c= \'Splitted\'  Limit 1'; 
    
    // Default Constructor
    global Mod5InsertCntcBatchV3()
    {
       // this.strQuery = DEFAULT_QUERY;
    }
    //This costructor is called from the Batch Schedule method
    global Mod5InsertCntcBatchV3(String query)
    {
       // if(query != null && query != '')
       //     this.strQuery = query;
       // else
      //      this.strQuery = DEFAULT_QUERY;
     //   System.debug('QUERY IS---->'+strQuery);
    }
    
   
    
    // This method prepares the scope of the batch program based on the query result 
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
    
        newAccSet = new Set<Id> ();
        originalAccIdSet = new Set<Id> ();
        originalCTidSet = new Set<Id> ();
        orginialCTList = new List<Customer_Transition__c>();
        splitDetail = new List<Split_Account_Detail__c> ();
        
        //system.debug('>>>>scope>>>'+scope);
        

        
       //Setup of required input for Contact Class
      orginialCTList = [Select Id,account__c FROM Customer_Transition__c WHERE Mod5TriggerContact__C=true and Split_Launching_Status__c ='Success' Limit 1];
        
        if((!orginialCTList.isEmpty())  && (orginialCTList.size() > 0))
        {
           for(Customer_Transition__c eachCT : orginialCTList)
           {
           originalAccIdSet.add(eachCT.account__c);
           originalCTidSet.add(eachCT.id);
           }
        
            splitDetail =[Select id,Linked_Customer_Transition__r.account__c,ContactsAdded__c from Split_Account_Detail__c
                where Customer_Transition__c in:originalCTidSet and Linked_Customer_Transition__c !=null and ContactsAdded__c=false limit 99];  
        }
        else
        {
        strQuery = 'Select Id,account__c FROM Customer_Transition__c WHERE Mod5TriggerContact__C=true  Limit 1';
        return Database.getQueryLocator(strQuery);
        }
        
        if((!splitDetail.isEmpty())  && (splitDetail.size() > 0) && (!originalAccIdSet.isEmpty())  && (originalAccIdSet.size() > 0))
        {
           for(Split_Account_Detail__c sadtls : splitDetail)
           {
           newAccSet.add(sadtls.Linked_Customer_Transition__r.account__c);
           }
        this.strQuery = 'Select firstname,lastname, email,AccountId,phone,fax,recordtypeId,ownerId  from Contact where AccountId in :originalAccIdSet';
        return Database.getQueryLocator(strQuery);
        }
        else
        {
        strQuery = 'Select id,recordtypeId,ownerId,Linked_Customer_Transition__r.account__c,ContactsAdded__c from Split_Account_Detail__c where Customer_Transition__c in:originalCTidSet and Linked_Customer_Transition__c !=null and ContactsAdded__c=false limit 99';
        return Database.getQueryLocator(strQuery);
        }
    }
    
    
    // This method processes query result in batches 
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
      
       
       //Contact Class logic
       List < Contact > contList = scope;
       List<Contact> contInsertList = new List<Contact>();
     
    if( (!newAccSet.isEmpty())  && (newAccSet.size() > 0) && (!originalAccIdSet.isEmpty())  && (originalAccIdSet.size() > 0))
    {
        for (Id recordId : new List<ID>(newAccSet))
        {   
        System.debug('@@@@contList '+contList.size());
        integer countSize = 0;
          for(integer i=0;i<contList.size();i++)
          {
          system.debug('contList '+i+'@@@'+contList[i]);
            Contact contnew = new Contact(firstname=contList[i].firstname,lastname=contList[i].lastname,
                                        Override_duplicate_check__c = true,accountId=recordId ,recordtypeId=contList[i].recordtypeId,
                                        ownerId=contList[i].ownerId,
                                        email =contList[i].email, phone=contList[i].phone,fax=contList[i].fax);
            contInsertList.add(contnew);
          }
        }
    }
    
                executeoncetest.mod5ByPass=false;

    if((contInsertList.size() > 0) && (!contInsertList.isEmpty()))
    insert contInsertList;
    
    
    }
    
    // This method is to execute to relase some resources if any
    global void finish(Database.BatchableContext BC)
    {
    
    
    //Updating SAD ContactsAdded__c to true
    List<Split_Account_Detail__c>  updateSAD = new List<Split_Account_Detail__c>  ();
    
    for(Split_Account_Detail__c eachSAD : splitDetail)
    {
    eachSAD.ContactsAdded__c = true;
    updateSAD.add(eachSAD);
    }
    if(updateSAD.size()>0)
    update updateSAD;
    
    //Check if more SAD remaining for main CT record
     List<Customer_Transition__c > custUpdate = new List<Customer_Transition__c > ();
     Integer countSAD = 0;
         for(  Split_Account_Detail__c remainingSAD: [Select id,Linked_Customer_Transition__r.account__c from Split_Account_Detail__c
                where Customer_Transition__c in:originalCTidSet and Linked_Customer_Transition__c !=null and ContactsAdded__c=false limit 99])
            {
            countSAD=countSAD+1;
               
            }
        if(countSAD == 0)
        {
        
            for(Customer_transition__C cstRec : orginialCTList)
                {
                Customer_transition__C cust= new Customer_transition__C   (Id=cstRec.Id);
                cust.Mod5TriggerContact__C  =false;
                custUpdate .add(cust);
                }
        
            if(custUpdate.size()>0)
            update custUpdate ;
        }
        
    
     CustTransParentChildLevel__c PCLevel2 = [select Mod5InsertCntcBatchV1ID__c,Mod5InsertCntcBatchV1Interval__c from 
            CustTransParentChildLevel__c limit 1];
        integer interval = 100;        
        if (PCLevel2.Mod5InsertCntcBatchV1ID__c<> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.Mod5InsertCntcBatchV1ID__c])
            system.abortJob(existingJob.id);
        }
        
        if(PCLevel2.Mod5InsertCntcBatchV1Interval__c!= null)
            interval = (Integer)PCLevel2.Mod5InsertCntcBatchV1Interval__c;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        Mod5InsertCntcBatchV3 Mod5InsertCntcBatchV3Obj = new Mod5InsertCntcBatchV3 ();
        ID cronid = System.schedule( 'Mod5InsertCntcBatchV3' + sysTime, chronExpression, Mod5InsertCntcBatchV3Obj );    
        
        PCLevel2.Mod5InsertCntcBatchV1ID__c= cronid;
        
        update PCLevel2;    

     
    }     
        
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        Mod5InsertCntcBatchV3 Mod5InsertCntcBatchV3Obj = new Mod5InsertCntcBatchV3 (strQuery);
        database.executebatch(Mod5InsertCntcBatchV3Obj, 99);
    } 
    
    
    
}