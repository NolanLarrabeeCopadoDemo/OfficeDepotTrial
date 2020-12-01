/***
Description: This Batch is to bring in the Oracle partyid and Oracle partysiteid.
Created By: Subhrajyoti
Created Date: 19-Aug-2014

Modified By: Sushma Kamisetty
Modified Date: 31-Mar-2015
Modify Reason: Modifying the Scope Query as per Production Fix: 00371201
**/
Global class OMAXProspectSer_Batch implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts
{
    public String strQuery;
    public String accountid;
    public Id CustOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
    public Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
    //01290603   Modified query RecordTypeId = :SiteOMX  and Related_Account__r.recordtypeId= :CustOMX
    private String DEFAULT_QUERY  = 'SELECT Id, Related_Account__c,Related_Account__r.recordtypeId, OMXIsUpdated__c, RecordTypeId, OMAXProspectSer_Batch_Processed__c ' +
                                    'FROM Account ' +
                                    'WHERE (RecordTypeId = :CustOMX OR  ( RecordTypeId = :SiteOMX  and Related_Account__r.recordtypeId= :CustOMX  )) ' +
                                    'AND OMXIsUpdated__c = true AND Oracle_Party_Id__c = null AND Oracle_Party_Site_Id__c = null ' +
                                    'AND (OMAXProspectSer_Batch_Processed__c <= ' + Label.OMAXProspectSer_Batch_Max + ' ' +
                                    'OR OMAXProspectSer_Batch_Processed__c = NULL) ' +
                                    'LIMIT 5000';
    /* Default Constructor*/
    global OMAXProspectSer_Batch()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global OMAXProspectSer_Batch(String query)
    {
        //System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
            
            
            System.debug('&&&&&&&&&&&&&&&&&&&&&&strQuery '+strQuery );
    }
    /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
      System.debug('&&&&&&&&&&&&&&&&&&&&&&Inside strQuery '+strQuery );
    
        return Database.getQueryLocator(strQuery);
    }
    /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        List<Account> listAccts = scope; 
        
        
        List<String> listAcctids = new List<String>();
        Map<Id, Account> mapList = new Map<Id, Account>();
        
         System.debug('&&&&&&&&&&&&&&&&&&&&&&listAccts '+listAccts );
         for(Account accalias:listAccts ) 
        {
            if (accalias.OMAXProspectSer_Batch_Processed__c == null) {
                accalias.OMAXProspectSer_Batch_Processed__c = 1;
            }
            else {
                accalias.OMAXProspectSer_Batch_Processed__c = accalias.OMAXProspectSer_Batch_Processed__c + 1;
            }
            
        if(accalias.recordtypeid==CustOMX){
        
               if(!mapList.containsKey(accalias.Id)){
               listAcctids.add(accalias.id);
               mapList.put(accalias.Id,accalias);}
            }
        else{
            if(!mapList.containsKey(accalias.Id)){
            if(accalias.related_account__c!=null){
            listAcctids.add(accalias.related_account__c);
            mapList.put(accalias.Id,accalias);
            }
            }
            }
        }
        
        update listAccts;
        
       System.debug('listAcctids  size' + listAcctids .size());
       
          System.debug('&&&&&&&&&&&&&&&&&&&&&&listAcctids'+listAcctids);
       
         Set<String> setAccts = new Set<String>(listAcctids);
        System.debug('setAccts size' + setAccts.size());
    //  list<Prospect_Message__c > exstsmsgs = [select  id,Account__c from Prospect_Message__c where updated__c < 1];
   //    for(Prospect_Message__c msg:exstsmsgs  ) 
    //    {
    //  setAccts.remove(msg.Account__c );
    //   }
        List<Prospect_Message__c> insertProsMess= new List<Prospect_Message__c>();
        for(String acctid:setAccts){
        
        System.debug('acctid'+acctid);
        
        
            //This batch will always be processed with a batch size of 1
            accountid = acctid ;
            List<Account> OMAXRelatedSite= [Select id,Related_Account__c from Account where Related_Account__c =: acctid  limit 1];
         List<Prospect_Message__c> pms= [select id from Prospect_Message__c where createddate = today and
          Account__c =: acctid and Message_Complete__c in ('NP','AP')]; // Added the filter on Created date and account as per case # 00328854 
          
          
           System.debug('OMAXRelatedSite.size'+OMAXRelatedSite.size());
            System.debug('&&&&&&&&&&&&&&&&&&&&&&pms'+pms);
                 System.debug('&&&&&&&&&&&&&&&&&&&&&&accountid '+accountid );
          
           if(pms.size()<1)
            if(OMAXRelatedSite.size()>0)
            {
            
             System.debug('&&&&&&&&&&&&&&&&&&&&&&Inside here');
             List<Account> accupdate= new List<Account>();
                Prospect_Message__c myMessage = new Prospect_Message__c();
                myMessage.Work_Indicator__c = 'Get Stuff';
                myMessage.Account__c = acctid;
                insertProsMess.add(myMessage);
            }    
            
        }  
        if(insertProsMess.size()>0)
          insert insertProsMess;
          
          
              System.debug('&&&&&&&&&&&&&&&&&&&&&&insertProsMess'+insertProsMess);
            
    }
    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC) {
        /*
        Integer delay= 15;
        
        try
        {
            Map<String, Keyvalue_Map_CS__c> keyValueMap = Keyvalue_Map_CS__c.getAll();
            delay= Integer.valueOf(keyValueMap.get('delay').Data_Value__c);
        }
        catch(Exception e)
        {
            // do nothing
        }
     Datetime sysTime = System.now().addSeconds(delay);
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
     OMAXProspectSer_Batch scheduledBatch = new OMAXProspectSer_Batch();
                System.schedule( 'OMAXProspectSer_Batch' + sysTime, chronExpression, scheduledBatch ); 
        */

    }
    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc) {
        /*
      Integer pastDays = 15;
        try
        {
            Map<String, Keyvalue_Map_CS__c> keyValueMap = Keyvalue_Map_CS__c.getAll();
            pastDays = Integer.valueOf(keyValueMap.get('AccountAssignmentCleanPastDaysIn').Data_Value__c);
        }
        catch(Exception e)
        {
            // do nothing
        }
        
       Id CustOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();
       Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
        */
        String strQuery = '';
        OMAXProspectSer_Batch assignBatch = new OMAXProspectSer_Batch(strQuery);
        
        if (!Test.isRunningTest()) {
            database.executebatch(assignBatch, 1);
        }
    } 
  
}