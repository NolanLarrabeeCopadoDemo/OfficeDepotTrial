global class ACEVendavoRecCollection implements Database.Batchable<sObject>,Schedulable,Database.Stateful
{
    public String acequery ;  
    global Map<String,Ace_Customer_Core_Changes__c> map_aceCore;
    global String batchId = '1';
    //global Date StartDate;
    //global Date EndDate;
    public set<ID> sIds;
    public Decimal reminderDays,escalationDays;
    public integer processingWindow;
    Decimal maxseqid  =1000000000;
    ACE_Settings__c aceSetting{get;set;}
    
        
    global void execute(SchedulableContext sc)
    {
     //Batch size set for each iteration
     //integer batch_size = 100;
     integer batch_size=integer.valueof(Label.VendavorecollectionBatchsize);
     ACEVendavoRecCollection aceBatch = new ACEVendavoRecCollection();     
     database.executebatch(aceBatch,batch_size); 
     
    }
    
    global ACEVendavoRecCollection (){  
    Date StartDate,EndDate;
        Decimal minseqid =1000000;
        aceSetting =[SELECT Id,processing_window__c,EsclationDays__c,Expiry_Days__c, Name, BatchName__c,Vendavo_Update_Start_Date__c,Vendavo_Update_End_Date__c,Minimum_Object_ID__c,Max_Object_ID__c, batchsize__c from ACE_Settings__c limit 1];
        reminderDays = 0;escalationDays = 0;processingWindow = 0;
        if(aceSetting != null){
        if (aceSetting.Minimum_Object_ID__c != null)
        {
            minseqid = aceSetting.Minimum_Object_ID__c ;
           
            }
            
            if (aceSetting.batchsize__c != null)
            { maxseqid =minseqid + aceSetting.batchsize__c  ;
           
            }
            this.batchId = aceSetting.BatchName__c;
             StartDate = aceSetting.Vendavo_Update_Start_Date__c;//Date.valueOf('2016-12-01');
             EndDate = aceSetting.Vendavo_Update_End_Date__c+1;
            if (aceSetting.Expiry_Days__c != null)
             reminderDays = aceSetting.Expiry_Days__c;
            if (aceSetting.EsclationDays__c != null)
             escalationDays = aceSetting.EsclationDays__c; 
            if (aceSetting.processing_window__c != null)
             processingWindow = integer.valueof(aceSetting.processing_window__c); 
        }    
        
        system.debug('Start Date:' + StartDate + ' End Date:' + EndDate);
        this.acequery  = 'SELECT Id,PRICE_NOT_CALCULATED__c,Approval_status__c,status__c,Price_Changes_Type__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_Min__c,'
                         + 'Vendavo_Update_Date__c,PROCESSING_ALLOWED__c,ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c,ace_customer_core_changes__r.ace_customer_price_changes__r.record_unlock__c,'
                         +'ace_customer_core_changes__r.ace_customer_price_changes__r.Exception_Date_Lock__c,ace_customer_core_changes__r.ace_customer_price_changes__r.SKU_Approval_Pending__c,ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Remediation_Hold__c,'
                         +'ace_customer_core_changes__r.ace_customer_price_changes__r.Hosted_Catalog__c,ace_customer_core_changes__r.ace_customer_price_changes__r.HostedCatalog_Hold__c,ace_customer_core_changes__r.ace_customer_price_changes__r.notification_status_code__c,'
                         +'ace_customer_core_changes__r.ace_customer_price_changes__r.Customer_Response__c,sfdc_notification_flag__c,ace_customer_core_changes__r.ace_customer_price_changes__r.id,ace_customer_core_changes__r.ace_customer_price_changes__c,ace_customer_core_changes__r.ace_customer_price_changes__r.notification_error__c,'
                   +'backlog_reason__c'
                     //    + ' from ACE_Customer_SKU_Changes__c where batch_processed__C=false and ACE_SKU_Changes_ID__c >=:minseqid and ACE_SKU_Changes_ID__c <:maxseqid  and ((Vendavo_Update_Date__c >= :StartDate  AND Vendavo_Update_Date__c < :EndDate ) OR (ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_Min__c >= :StartDate and ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c = false AND ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_Min__c < :EndDate)) order by Owning_Customer_ID__c  '  ;   
               
                         + ' from ACE_Customer_SKU_Changes__c where batch_processed__C=false and ACE_SKU_Changes_ID__c >='+minseqid+' and ACE_SKU_Changes_ID__c <'+maxseqid;
            
      
        System.debug(this.acequery); 
       
    }
    
    global ACEVendavoRecCollection (Decimal minseqid ){  
    Date StartDate,EndDate;
        String acequery;
        aceSetting =[SELECT Id,processing_window__c,EsclationDays__c,Expiry_Days__c, Name, BatchName__c,Vendavo_Update_Start_Date__c,Vendavo_Update_End_Date__c,Minimum_Object_ID__c,Max_Object_ID__c,batchsize__c from ACE_Settings__c limit 1];
        reminderDays = 0;escalationDays = 0;processingWindow = 0;
        if(aceSetting != null){
        
            if (aceSetting.batchsize__c != null)
            { maxseqid =minseqid  + aceSetting.batchsize__c  ;
           
            }
            this.batchId = aceSetting.BatchName__c;
             StartDate = aceSetting.Vendavo_Update_Start_Date__c;//Date.valueOf('2016-12-01');
             EndDate = aceSetting.Vendavo_Update_End_Date__c+1;
            if (aceSetting.Expiry_Days__c != null)
             reminderDays = aceSetting.Expiry_Days__c;
            if (aceSetting.EsclationDays__c != null)
             escalationDays = aceSetting.EsclationDays__c; 
            if (aceSetting.processing_window__c != null)
             processingWindow = integer.valueof(aceSetting.processing_window__c); 
        }    
        
        system.debug('Start Date:' + StartDate + ' End Date:' + EndDate);
        this.acequery  = 'SELECT Id,PRICE_NOT_CALCULATED__c,Approval_status__c,status__c,Price_Changes_Type__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_Min__c,'
                         + 'Vendavo_Update_Date__c,PROCESSING_ALLOWED__c,ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c,ace_customer_core_changes__r.ace_customer_price_changes__r.record_unlock__c,'
                         +'ace_customer_core_changes__r.ace_customer_price_changes__r.Exception_Date_Lock__c,ace_customer_core_changes__r.ace_customer_price_changes__r.SKU_Approval_Pending__c,ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Remediation_Hold__c,'
                         +'ace_customer_core_changes__r.ace_customer_price_changes__r.Hosted_Catalog__c,ace_customer_core_changes__r.ace_customer_price_changes__r.HostedCatalog_Hold__c,ace_customer_core_changes__r.ace_customer_price_changes__r.notification_status_code__c,'
                         +'ace_customer_core_changes__r.ace_customer_price_changes__r.Customer_Response__c,sfdc_notification_flag__c,ace_customer_core_changes__r.ace_customer_price_changes__r.id,ace_customer_core_changes__r.ace_customer_price_changes__c,ace_customer_core_changes__r.ace_customer_price_changes__r.notification_error__c,'
                   +'backlog_reason__c'//ROM-47
                         + ' from ACE_Customer_SKU_Changes__c where batch_processed__C=false and ACE_SKU_Changes_ID__c >='+minseqid+' and ACE_SKU_Changes_ID__c <'+maxseqid;
               
                         
            
      
        System.debug(this.acequery); 
       
    }
    
                         
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {  
     Date StartDate,EndDate;
     aceSetting =[SELECT Id,processing_window__c,EsclationDays__c,Expiry_Days__c, Name, BatchName__c,Vendavo_Update_Start_Date__c,Vendavo_Update_End_Date__c,Minimum_Object_ID__c,batchsize__c from ACE_Settings__c limit 1];
        if(aceSetting != null){
        
              StartDate = aceSetting.Vendavo_Update_Start_Date__c;//Date.valueOf('2016-12-01');
             EndDate = aceSetting.Vendavo_Update_End_Date__c+1;
            if (aceSetting.Expiry_Days__c != null)
             reminderDays = aceSetting.Expiry_Days__c;
            if (aceSetting.EsclationDays__c != null)
             escalationDays = aceSetting.EsclationDays__c; 
            if (aceSetting.processing_window__c != null)
             processingWindow = integer.valueof(aceSetting.processing_window__c); 
        }    
        this.acequery = acequery+ ' and ((Vendavo_Update_Date__c >= :StartDate  AND Vendavo_Update_Date__c < :EndDate ) OR (ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_Min__c >= :StartDate and ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c = false AND ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_Min__c < :EndDate)) order by Owning_Customer_ID__c    '  ;   
        system.debug('Query inside the locator:' + this.acequery);
       
        return Database.getQueryLocator(this.acequery);
    }
  
    global void execute(Database.BatchableContext BC, List<sObject> scope)
    {
         List<Ace_Customer_SKU_Changes__c> sku2 = scope;
         system.debug('Inside Execute:'+ sku2.size());
         list<ID> skuids = new list<ID>();
         For (Ace_Customer_SKU_Changes__c s: sku2)
            skuids.add(s.id);
         List<Ace_Customer_SKU_Changes__c> sku = [SELECT Id,ace_customer_core_changes__r.ace_customer_price_changes__r.notification_status_code__c,Approval_status__c,status__c,Price_Changes_Type__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_Min__c,Vendavo_Update_Date__c,PROCESSING_ALLOWED__c,ace_customer_core_changes__r.ace_customer_price_changes__r.notification_error__c,ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c,ace_customer_core_changes__r.ace_customer_price_changes__r.record_unlock__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Exception_Date_Lock__c,ace_customer_core_changes__r.ace_customer_price_changes__r.SKU_Approval_Pending__c,ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Remediation_Hold__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Hosted_Catalog__c,ace_customer_core_changes__r.ace_customer_price_changes__r.HostedCatalog_Hold__c,ace_customer_core_changes__r.ace_customer_price_changes__r.Customer_Response__c,sfdc_notification_flag__c,ace_customer_core_changes__r.ace_customer_price_changes__r.id,ace_customer_core_changes__r.ace_customer_price_changes__c from ACE_Customer_SKU_Changes__c where ID in :skuids];
         List<Ace_Customer_SKU_Changes__c> skuList = new List<Ace_Customer_SKU_Changes__c>();
         set<ID> clist =new set<ID>();
         Map<ID,boolean> custAppCheck = new Map<ID,boolean> ();
         set<ID> recallIDs = new Set<ID>();
         list<ACE_Customer_Price_Changes__c> updImplCode = new List<ACE_Customer_Price_Changes__c>(); 
         
         // Added by IVARADA - 04/30/2014
         
         //Construct CLIST
         for(Ace_Customer_SKU_Changes__c ace: sku){   
            
             if(ace.Approval_status__c == 'Pending'){
                     custAppCheck.put(ace.ace_customer_core_changes__r.ace_customer_price_changes__c,true);
              }
             
             if(ace.ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c == '3' 
                 && ace.ace_customer_core_changes__r.ace_customer_price_changes__r.Customer_Response__c == 'Approved' 
                 && ace.ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_Min__c <= system.Today().adddays(processingWindow) && ace.Status__c != 'InActive'){
                     clist.add(ace.ace_customer_core_changes__r.ace_customer_price_changes__r.id);
                 } 
              
             if(((ace.ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c == '2'  && ace.ace_customer_core_changes__r.ace_customer_price_changes__r.notification_status_code__c == 'NOTIFY-DELIVERED')
                  || ace.ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c == '1')
                 && ace.ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_Min__c <= system.Today().addDays(processingWindow) && ace.Status__c != 'InActive'
                 ){
                         clist.add(ace.ace_customer_core_changes__r.ace_customer_price_changes__r.id);

                 }   
             
         }
         
         //Auto Reject functionality  -- Begins
         
         List<Ace_Customer_Price_Changes__c> custList2 = new List<Ace_Customer_Price_Changes__c>();     

         for(Ace_Customer_Price_Changes__c cust: [select id,Record_Lock__c,record_unlock__c,Exception_Date_Lock__c,Owning_Customer_Legal__c,Reschduled_For_Reminder__c,sfdc_notification_flag__c,Sales_Price_Change_Effective_Date_Min__c,Sales_Price_Change_Effective_Date_Approv__c from Ace_Customer_Price_Changes__c where id in: clist]){

              //check for SKU approvals as well
               if ((cust.Exception_Date_Lock__c || custAppCheck.containsKey(cust.id) || cust.record_unlock__c) && !cust.Reschduled_For_Reminder__c) {
                  //modify effective date
                  integer total_time = 0;

                   if (cust.owning_customer_legal__c == 'T')
                    total_time = integer.valueof(reminderDays+escalationDays);
                   else
                    total_time = Integer.valueOf(reminderDays);

                 
                  if (cust.Sales_Price_Change_Effective_Date_Approv__c != null)  
                   cust.Sales_Price_Change_Effective_Date_Approv__c = cust.Sales_Price_Change_Effective_Date_Approv__c.addDays(total_time);
                  if (cust.Sales_Price_Change_Effective_Date_Min__c != null)
                   cust.Sales_Price_Change_Effective_Date_Min__c = cust.Sales_Price_Change_Effective_Date_Min__c.addDays(total_time); 
                 
                  cust.Reschduled_For_Reminder__c = true;

               }
               else {
                 cust.record_lock__c = true;
                 cust.Reschduled_For_Reminder__c = false;
                 cust.record_unlock__c = false;
                 recallIDs.add(cust.id);
                 //build the recall list and call recall approval process
               }

             
            
             
             custList2.add(cust);
         }
         
         for(ace_customer_sku_changes__c s : [select id from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__c = :recallIDs and approval_status__c = 'Pending'])
           recallIDs.add(s.id);
         
         update custList2;
         
         
         
           if(recallIDs.size() >0 )          
             ACE_RECALL_APPROVAL_PROCESS.ACERecallMethod(recallIDs);
             
         //Auto Reject functionality  -- Ends
             
        for (ACE_Customer_Price_Changes__c c: [select id,implementation_status_code__c from ace_customer_price_changes__c where id in :clist and Reschduled_For_Reminder__c = false and Remediation_Hold__c = false and record_unlock__c = false and Hosted_Catalog__c = false]) {
            c.Implementation_Status_Code__c = 'DATA-SENT';
            updImplCode.add(c);
        }
         
         update updImplCode;
         
         //Set Processing Flag on SKUs - Begins
         sku = [SELECT Id,batch_processed__C,Approval_status__c,status__c,Price_Changes_Type__c,ace_customer_core_changes__r.ace_customer_price_changes__r.notification_error__c,
         ace_customer_core_changes__r.ace_customer_price_changes__r.Sales_Price_Change_Effective_Date_Min__c,Vendavo_Update_Date__c,
         PROCESSING_ALLOWED__c,ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c,
         ace_customer_core_changes__r.ace_customer_price_changes__r.record_unlock__c,
         ace_customer_core_changes__r.ace_customer_price_changes__r.Exception_Date_Lock__c,
         ace_customer_core_changes__r.ace_customer_price_changes__r.SKU_Approval_Pending__c,
         ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c,
         ace_customer_core_changes__r.ace_customer_price_changes__r.Remediation_Hold__c,
         ace_customer_core_changes__r.ace_customer_price_changes__r.Hosted_Catalog__c,
         ace_customer_core_changes__r.ace_customer_price_changes__r.HostedCatalog_Hold__c,
         ace_customer_core_changes__r.ace_customer_price_changes__r.Customer_Response__c,
         sfdc_notification_flag__c,ace_customer_core_changes__r.ace_customer_price_changes__r.id,
         ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c,
         ace_customer_core_changes__r.ace_customer_price_changes__r.Notification_Status_Code__c,//ROM-47
         ace_customer_core_changes__r.ace_customer_price_changes__c,
         Sales_Price_Change_Effective_Date__c, Sales_Price_Change_Effective_Date_Approv__c,//ROM-47
         Proposed_Price_with_Cap__c, Approved_Proposed_Price__c //ROM-47
         from ACE_Customer_SKU_Changes__c where ID in :skuids];
        
        //ROM-47 - Amnesia - Backlog reasons ----Start
         list<id> lskuids = new list<id>();
         for(Ace_Customer_SKU_Changes__c ace :sku){
         lskuids.add(ace.ace_customer_core_changes__r.ace_customer_price_changes__r.id);                
         }//end of for
        
         map <id, case> map_id_sku = new map<id, case>();         
         for(case accase:[select id,Customer_Core_Price_Changes__c from case where Customer_Core_Price_Changes__c in :lskuids and 
                         (WRF_Request_Type__c = 'BSD Pricing' OR WRF_Request_Type__c = 'Remediation' OR WRF_Request_Type__c = 'Compliance')])
         {
             if(!map_id_sku.containsKey(accase.Customer_Core_Price_Changes__c))
                map_id_sku.put(accase.Customer_Core_Price_Changes__c, accase);                 
         }
         //ROM-47 - Amnesia - Backlog reasons ----End  
         
         for(Ace_Customer_SKU_Changes__c ace: sku){        
                 
                 
                 //for bulk processing
              ace.batch_processed__C=true;
                 
                 //Logic for Processing Allowed flag             
                 ace.PROCESSING_ALLOWED__c = true;
                 //ace.Vendavo_Update_Date__c = system.now();
                 system.debug('MADHAVI:' + ace.id);
                 //  00826586 added ace.ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c  and ace.ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c
                 if((ace.ace_customer_core_changes__r.ace_customer_price_changes__r.Remediation_Hold__c
                     && ace.ace_customer_core_changes__r.ace_customer_price_changes__r.IsRemediation__c==true)// NAIT-38879 -- Changed from OR to AND
                     || (ace.ace_customer_core_changes__r.ace_customer_price_changes__r.Hosted_Catalog__c 
                             && ace.ace_customer_core_changes__r.ace_customer_price_changes__r.HostedCatalog_Hold__c)
                     ||  ace.Status__c == 'InActive' 
                     || ace.ace_customer_core_changes__r.ace_customer_price_changes__r.record_unlock__c 
                     || ace.PRICE_NOT_CALCULATED__c == true 
                     || ace.ace_customer_core_changes__r.ace_customer_price_changes__r.PRICE_NOT_CALCULATED__c == true                       
                     ){
                     
                         ace.PROCESSING_ALLOWED__c = false;
                         system.debug('MADHAVI insideIFS:' + ace.id);
                         
                 }
             
                
                 // Start of 00827427 
                 /*if(ace.ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c != '1' && ace.ace_customer_core_changes__r.ace_customer_price_changes__r.notification_error__c != null)
                         ace.PROCESSING_ALLOWED__c = false;
                 if(ace.ace_customer_core_changes__r.ace_customer_price_changes__r.sfdc_notification_flag__c == '3' && ace.ace_customer_core_changes__r.ace_customer_price_changes__r.Customer_Response__c != 'Approved')
                         ace.PROCESSING_ALLOWED__c = false;*/
                         
                if(ace.sfdc_notification_flag__c != '1' && ace.ace_customer_core_changes__r.ace_customer_price_changes__r.notification_error__c != null)
                         ace.PROCESSING_ALLOWED__c = false;
                 if(ace.sfdc_notification_flag__c == '3' && ace.ace_customer_core_changes__r.ace_customer_price_changes__r.Customer_Response__c != 'Approved')
                         ace.PROCESSING_ALLOWED__c = false;

             // end of 00827427 

                 
                 
                 //Price Change type
                 //ace.Price_Change_Type__c = ace.Price_Changes_Type__c;
                 
                 if(ace.status__c == 'Deleted'){                     
                    // ace.Price_Change_Type__c = 'D'; 
                 }
             
             
                //ROM-47 - Amnesia - Backlog reasons ----Start
                if(map_id_sku.containsKey(ace.ace_customer_core_changes__r.ace_customer_price_changes__r.id))
                    ace.Backlog_Reason__c = 'WRF';                     
                 else if(ace.ace_customer_core_changes__r.ace_customer_price_changes__r.Notification_Status_Code__c == 'NOTIFY-FAILED')
                     ace.Backlog_Reason__c = 'Notification Failure';     
                else if(ace.Sales_Price_Change_Effective_Date__c != ace.Sales_Price_Change_Effective_Date_Approv__c)                                     
                     ace.Backlog_Reason__c = 'Date Exception';                   
                else if(ace.Proposed_Price_with_Cap__c != ace.Approved_Proposed_Price__c)
                     ace.Backlog_Reason__c = 'Price Exception';                               
                //ROM-47 - Amnesia - Backlog reasons -----End           
               
                 skuList.add(ace);                                                               
         }    
         
        
         update skuList;
         
         //Set Processing Flag on SKUs - Ends
         

    }  
    
    global void finish(Database.BatchableContext BC)
    {
        Date dtSet;
        Decimal newmaxid = 0; 
        Decimal objmaxid = 0; 
        aceSetting =[SELECT Id,processing_window__c,EsclationDays__c,Expiry_Days__c, Name, BatchName__c,Vendavo_Update_Start_Date__c,Vendavo_Update_End_Date__c,Minimum_Object_ID__c,Max_Object_ID__c,batchsize__c from ACE_Settings__c limit 1];
        
        if( aceSetting.Max_Object_ID__c !=null)
        {
            objmaxid = aceSetting.Max_Object_ID__c ;
        }
        
        
        
           System.debug(objmaxid  + ' obj id'); 
       
       if (objmaxid >= maxseqid)
       {
            
         integer batch_size_n =integer.valueof(Label.VendavorecollectionBatchsize);
         ACEVendavoRecCollection aceBatchn = new ACEVendavoRecCollection(maxseqid);     
         database.executebatch(aceBatchn ,batch_size_n ); 
       
       }
      else
      {  
      
        system.debug('Custom Setting Vendavo End Date:'+aceSetting.Vendavo_Update_End_Date__c);
        if (aceSetting.Vendavo_Update_End_Date__c == system.today()) {
            dtSet = system.today() + 1;
            system.debug('here1:'+dtset);
        }
         else
            dtSet = system.today();
        
        
         aceSetting.Vendavo_Update_Start_Date__c = dtSet;
         aceSetting.Vendavo_Update_End_Date__c = dtSet;
         
         update aceSetting;

        System.debug('Completed Processing.... ACE To Vendavo Record Collection for Quarter :'+batchId);
        }
    }
}