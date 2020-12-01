global class ACE_Site_CustomerDetails implements Database.Batchable<sObject>,Database.Stateful,Schedulable 
{
    // this method is used to get all records that will be processed by execute method  
    ACE_Settings__c aceSetting{get;set;} 
     
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        aceSetting = [Select id,Site_Batch_Start_Date__c,Site_Batch_End_Date__c,Site_URL__c,EsclationDays__c,Expiry_Days__c from ACE_Settings__c limit 1];  
              
        Date dt = aceSetting.Site_Batch_Start_Date__c;
        Date dt1 = aceSetting.Site_Batch_End_Date__c;
         
        String query = 'SELECT id,customer__r.status__C,notification_status_code__c,requirement_window__c,Customer__r.owner.name,Customer__r.owner.firstname,Customer__r.owner.lastname, Exception_Date_Lock__c,Reschduled_For_Reminder__c, Customer__r.owner.email, Customer__r.owner.phone,Sales_Price_Change_Effective_Date_Approv__c,Sales_Price_Change_Effective_Date_Min__c,Customer__c,Record_Lock__c,Page_Key__c,SFDC_Notification_Flag__c,Customer_Notification_Date_Approved__c,Hosted_Catalog__c' 
                          + ' FROM ACE_Customer_Price_Changes__c '
            
                          + 'where Customer_Notification_Date_Approved__c >= :dt and Customer_Notification_Date_Approved__c <= :dt1 and Remediation_Hold__c=false and price_not_calculated__c=false and notification_status_code__c != \'NOTIFY-DELIVERED\' ORDER BY REPORT_SKU_COUNT__C ASC';
        System.debug('&&&&&&&&&&query     : '+query );                                 
        return  Database.getQueryLocator(query);
    } 
     
    // querylocator start
    global void execute(SchedulableContext sc)
    {
        //Batch size set for each iteration
        integer batch_size = 1;
        ACE_Site_CustomerDetails aceBatch = new ACE_Site_CustomerDetails();
        database.executebatch(aceBatch,batch_size);
    }//end of execute(SchedulableContext sc)
     
    global void execute(Database.BatchableContext BC, List<sObject> scope) 
    {          
        // loop thru results  
        List<ACE_Customer_Price_Changes__c> lACE = new List<ACE_Customer_Price_Changes__c>();
        List<ACE_Customer_MailOut__c> lMailOut = new List<ACE_Customer_MailOut__c>();
        List<ACE_Customer_View__c> lAceCustView = new List<ACE_Customer_View__c>();
        List<ACE_Customer_Price_Changes__c> lErrors = new List<ACE_Customer_Price_Changes__c>();
        Map<ID,ace_customer_price_changes__c> acctToPriceMap = new Map<ID,ace_customer_price_changes__c> ();
        Set<ID> sCustSKUIDs = new Set<ID>();
        set<ID> recallIDs = new Set<ID>();
        Set<ID> sIDs = new Set<ID>();
        Set<String> sIDsTrim = new Set<String>();

        Set<ID> custIDs = new Set<ID> ();
        Map<ID,ID> contactsMap = new Map<ID,ID> ();
        Map<ID,Contact> IDToContact = new Map<ID,Contact> ();
        Set<String> sIDACEPageView = new Set<String>();
        Set<String> sSKUIDs = new Set<String>();
        Map<ID,boolean> customersForReschedule = new Map<ID,boolean> ();
        List<ID> wrfIDs = new List<ID>();
        ACEWRFCreation wrfCr = new ACEWRFCreation();
        
        //------------Collecting BSD_Pricing cases--madhavi------
        List<case> caseList = new List<case>();
        Set<ID> caseSet = new Set<ID>();
        caseList = [select Customer_Core_Price_Changes__r.id from case where Customer_Core_Price_Changes__c!=null and WRF_Request_Type__c = 'BSD Pricing'];
        for(case cs:caseList){
            caseSet.add(cs.Customer_Core_Price_Changes__r.id);
        }//-------------------
          
        //Added 4/30/2014 by Ivarada - Begins : Collecting customers that have to be rescheduled due to Pending approvals                  
        aceSetting = [Select id,EsclationDays__c,Expiry_Days__c,Site_URL__c,Site_Batch_Start_Date__c,Site_Batch_End_Date__c from ACE_Settings__c];
        
        Decimal reminderDays = 0,escalationDays = 0;                             
        Date dt = aceSetting.Site_Batch_Start_Date__c;
        Date dt1 = aceSetting.Site_Batch_End_Date__c;         
          
        if (aceSetting.Expiry_Days__c != null)
            reminderDays = aceSetting.Expiry_Days__c;
        if (aceSetting.EsclationDays__c != null)
           escalationDays = aceSetting.EsclationDays__c;//No.of days before when the pending approval is escalated-madhavi
          
        System.debug('&&&&&&&&&&scope'+scope.size());
        
        Set<Id> custId = new set<Id>();//to collect the inactive and Deleted customers-madhavi        
        for (SObject s : scope) 
        {
            ACE_Customer_Price_Changes__c cp = (ACE_Customer_Price_Changes__c)s;
            sIDs.add(cp.id);
            custIDs.add(cp.customer__c);
            
            //collecting Notification and Approval required customers-madhavi
            if (cp.Exception_Date_Lock__c && !cp.Reschduled_For_Reminder__c && cp.sfdc_notification_flag__c != '1')
                customersForReschedule.put(cp.id,true);
               
            //collecting Inactive or deleted customers               
            if(cp.customer__r.status__C=='Inactive' || cp.customer__r.status__C=='Delete'){
                if(!custId.contains(cp.Id))
                custId.add(cp.Id); 
            }
              
            //Below code for ACE WRF Creation for Hosted Catalog customers
            //if(cp.Hosted_Catalog__c && !caseSet.contains(cp.id)) 
            if(cp.Hosted_Catalog__c )              
                wrfIDs.add(cp.id);                  
        }//end of for
        
        //WRF Creation for Hosted catalog customers
        //if (test.IsRunningTest() != true){              
        if(wrfIDs.size() > 0) {
            wrfCr.createWRF(wrfIDs,'BSD Pricing');
        }
        //}
        
        System.debug('&&&&&&&&&&sIDs'+sIDs);     
   
        //story  00826551--------------start------------------------------------------------         
        // get count of SKUS that satisfy notify Cancelled condition           
        List<AggregateResult > tasklist= [SELECT  Customer_Core_Price_Changes__c,COUNT(id) tasks 
        from  Ace_Customer_SKU_Changes__c where Customer_Core_Price_Changes__c in :sIDs and IsNotifyCancelled__c=true                                                                        
        GROUP BY CUBE(Customer_Core_Price_Changes__c)];
        
        System.debug('&&&&&&&&&&tasklist'+tasklist);

        Map<String, integer> fieldMap= new Map<String, integer>();               
        for (AggregateResult ar : tasklist) {
                   String KepMaptask=(String)ar.get('Customer_Core_Price_Changes__c');
                   if(KepMaptask!=null && KepMaptask !='')
                   fieldMap.put(KepMaptask, ((decimal)ar.get('tasks')).intValue());
        }
        
        System.debug('&&&&&&&&&&fieldMap'+fieldMap);   
   
        // get Total count of SKUS          
        List<AggregateResult > tasklistTotal= [SELECT  Customer_Core_Price_Changes__c,COUNT(id) tasks 
        from  Ace_Customer_SKU_Changes__c where Customer_Core_Price_Changes__c in :sIDs   
        GROUP BY CUBE(Customer_Core_Price_Changes__c)  ];
        
        System.debug('&&&&&&&&&&tasklistTotal'+tasklistTotal);
        Map<String, integer> fieldMapTotal= new Map<String, integer>();  
              
        for (AggregateResult ar : tasklistTotal) {
                   String KepMaptaskTotal=(String)ar.get('Customer_Core_Price_Changes__c');
                   if(KepMaptaskTotal!=null && KepMaptaskTotal!='')
                   fieldMapTotal.put(KepMaptaskTotal, ((decimal)ar.get('tasks')).intValue());
        }        

        List<ace_customer_price_changes__c > aceList= new List< ace_customer_price_changes__c >();
        
        for(Id fieldName :sIDs){
            //for (String fieldName : fieldMap.keySet()){
            //check if customer is Inactive or skus met Cancellation criteria
            System.debug('&&&&&&&&&&&& fieldName '+fieldMap.get(fieldName ));
            System.debug('&&&&&&&&&&&& Cancelled count'+fieldMap.get(fieldName ));
            System.debug('&&&&&&&&&&&& Total count'+fieldMapTotal.get(fieldName ));

            if(custId.contains(fieldName) || 
               (fieldMap.containskey(fieldName) && fieldMapTotal.containskey(fieldName) && (fieldMap.get(fieldName) == fieldMapTotal.get(fieldName)) )){
                ace_customer_price_changes__c rec= new ace_customer_price_changes__c ();
                rec.Id=fieldName ;
                rec.Notification_Status_Code__c ='NOTIFY-CANCELLED';
                rec.Implementation_Status_Code__c='NOTIFY-CANCELLED';
                rec.Approval_Satus__c   ='NOTIFY-CANCELLED';        
                aceList.add(rec);
            }
        }//end of for
        
        if(aceList.size()>0)
            update aceList;//updating ace_customer_price_changes__c obj records with NOTIFY-CANCELLED status-madhavi
        //story  00826551------------End----------------------------------------------------------------------              
        
        //-----------------------------------------------------------
        //collecting the notification & approval pending customers
        for (ace_customer_sku_changes__c s: [select id,Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c from ace_customer_sku_changes__c where approval_status__c = 'Pending' and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.Reschduled_For_Reminder__c = false and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in : sIDs and status__c != 'Inactive' and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.sfdc_notification_flag__c in ('2','3')]) {
            customersForReschedule.put(s.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c,true);
        }
        sIDs.clear();//clearing the scope customerids-madhavi
        //-------------------------------------------------------------        
        
        //Adjust the dates for notification and approval pending customers---start----madhavi------  
        list<ace_customer_price_changes__c> cNotificationUpdate = new list<ace_customer_price_changes__c>();
        Integer total_time = 0;             
        for (ace_customer_price_changes__c a: [select id,Owning_Customer_Legal__c,Customer_Notification_Date_Approved__c,Reschduled_For_Reminder__c,Sales_Price_Change_Effective_Date_Approv__c,Sales_Price_Change_Effective_Date_Min__c from ace_customer_price_changes__c where id = :customersForReschedule.keySet()]) {
            total_time = 0;
            
            if (a.owning_customer_legal__c == 'T')
                total_time = integer.valueof(reminderDays+escalationDays);
            else
                total_time = Integer.valueOf(reminderDays);
             
            if (a.Customer_Notification_Date_Approved__c != null)
                a.Customer_Notification_Date_Approved__c = a.Customer_Notification_Date_Approved__c.addDays(total_time);
            if (a.Sales_Price_Change_Effective_Date_Approv__c != null)
                a.Sales_Price_Change_Effective_Date_Approv__c = a.Sales_Price_Change_Effective_Date_Approv__c.addDays(total_time);
            if (a.Sales_Price_Change_Effective_Date_Min__c != null)
                a.Sales_Price_Change_Effective_Date_Min__c = a.Sales_Price_Change_Effective_Date_Min__c.addDays(total_time); 
            
            a.Reschduled_For_Reminder__c = true;
            
            //list to update the notification and effective date
            cNotificationUpdate.add(a); 
          
        }//end of for
        
        update cNotificationUpdate;//updating ace_customer_price_changes__c obj records with adjusted dates---madhavi
        //Adjust the dates for notification and approval pending customers---end----madhavi------  
        
        Map<ID,Boolean> contactExists = new Map<ID,Boolean>();
        Map<ID,Boolean> ApproverContactExists = new Map<ID,Boolean> ();
        //Added 4/30/2014 by Ivarada - Ends
          
        //Collect the Contacts - Starts----------             
        For (Contact c: [select account.id,id,email from contact where account.id = :custIDs and email <> null and (role__c includes ('Price Change Approver') OR role__c includes ('Price Change Notification/Viewer'))]) {
            contactsMap.put(c.id,c.account.id);
            contactExists.put(c.account.id,true);
            IDToContact.put(c.id,c);
        } 
        
        //Collecting the approver contact--madhavi
        For (Contact c: [select account.id,id,email from contact where account.id = :custIDs and email <> null and role__c includes ('Price Change Approver')]) 
            ApproverContactExists.put(c.account.id,true);
        
        System.debug('&&&&&&&& contactExists'+ contactExists.size());
        System.debug('&&&&&&&& ApproverContactExists'+ ApproverContactExists.size());
        System.debug('&&&&&&&& sIDs '+ sIDs );                        
        //Collect the Contacts - Ends---------------
        
        
        List<ID> totalPriceIDs = new List<ID>();                
    /*NAIT-11595 START---
        List <ACE_Customer_Price_Changes__c> scopeNew= new List <ACE_Customer_Price_Changes__c> ();          
        List <ACE_Customer_Price_Changes__c> scopeNewRec= new List<ACE_Customer_Price_Changes__c>();//nowhere used this-madhavi
        
        //Pulling the non remediation customers (notification and approval pending) with adjusted dates--madhavi
        scopeNew = [SELECT id,notification_status_code__c,requirement_window__c,Customer__r.owner.name,
                    Customer__r.owner.firstname,
                    Customer__r.owner.lastname, Exception_Date_Lock__c,Reschduled_For_Reminder__c, Customer__r.owner.email, 
                    Customer__r.owner.phone,Sales_Price_Change_Effective_Date_Approv__c,Sales_Price_Change_Effective_Date_Min__c,
                    Customer__c,Record_Lock__c,Page_Key__c,SFDC_Notification_Flag__c,Customer_Notification_Date_Approved__c,
                    Customer_Notification_Date__c,Hosted_Catalog__c, Compare_Quarter__c //mm rom item 1d
                    FROM ACE_Customer_Price_Changes__c 
                    where Customer_Notification_Date_Approved__c >= :dt and Customer_Notification_Date_Approved__c <= :dt1
                    and Remediation_Hold__c=false and price_not_calculated__c=false and 
                    notification_status_code__c != 'NOTIFY-DELIVERED'  and
                    notification_status_code__c != 'NOTIFY-CANCELLED' 
                    ORDER BY REPORT_SKU_COUNT__C ASC];
    
        System.debug('after scope'+  scopeNew);

        for( ACE_Customer_Price_Changes__c rec:scopeNewRec){//this for wont work -madhavi-need to verify with deepak
            if(!( rec.notification_status_code__c=='NOTIFY-CANCELLED'   &&  sIDs.contains(rec.Id)))
                 scopeNew.add(rec);
        }                                  
         
        
        for (SObject s : scopeNew) --NAIT-11595--END*/
        for (SObject s : scope) 
        {
            ACE_Customer_Price_Changes__c PI = (ACE_Customer_Price_Changes__c)s;
            
            totalPriceIDs.add(PI.ID);
            
            //Added 4/30/2014 - filter to not sendnotification for customers in customersForReschedule list 
            if (!customersForReschedule.containsKey(PI.id) && 
                pi.notification_status_code__c != 'NOTIFY-CANCELLED' && //Added for not to process 'NOTIFY-CANCELLED' //sfdc 00826551
                ((pi.sfdc_notification_flag__c != '3' && contactExists.containsKey(PI.customer__c)) || (pi.sfdc_notification_flag__c == '3' && ApproverContactExists.containsKey(PI.customer__c)))) {
                System.debug('&&&&&&&& Inside loop');
                
                if (pi.notification_status_code__c == 'NOTIFY-FAILED' && PI.sfdc_notification_flag__c != '1') 
                  pi.Update_Vendavo_Date__c = true;
                  
                /*if ((pi.notification_status_code__c == null || pi.notification_status_code__c == 'NOTIFY-FAILED') && pi.sfdc_notification_flag__c != '1' && pi.Customer_Notification_Date_Approved__c != null) {
                    Integer noOfDays = pi.Customer_Notification_Date_Approved__c.daysbetween(date.today());
                    
                if (noOfDays > 0 && pi.Sales_Price_Change_Effective_Date_Min__c != null && pi.Sales_Price_Change_Effective_Date_Approv__c != null) {
                            pi.Sales_Price_Change_Effective_Date_Min__c = pi.Sales_Price_Change_Effective_Date_Min__c.addDays(noOfDays);
                            pi.Sales_Price_Change_Effective_Date_Approv__c = pi.Sales_Price_Change_Effective_Date_Approv__c.addDays(noOfDays);
                            pi.effective_date_difference__c = noOfDays;
                }                           
                }*/
                
                if (PI.sfdc_notification_flag__c == '3')
                    pi.implementation_status__c = 'NOTIFY';
                
                pi.notification_status_code__c = 'NOTIFY-DELIVERED';
                pi.Reschduled_For_Reminder__c = false;
                pi.Notification_Error__c = null;
                
                lACE.add(PI);
                acctToPriceMap.put(PI.customer__c,PI);
                sIDs.add(pi.id);
                sIDACEPageView.add(pi.Page_key__c);//collecting customer view page keys-madhavi 
                recallIDs.add(pi.ID);
            } 
            else if (!customersForReschedule.containsKey(PI.id) && 
                pi.notification_status_code__c != 'NOTIFY-CANCELLED')//Added for not to process 'NOTIFY-CANCELLED' //sfdc 00826551
            {
                ACE_Customer_Price_Changes__c PIError = (ACE_Customer_Price_Changes__c)s;
                PIError.Notification_Error__c = 'No Pricing Contacts Found For Communication';
                pi.notification_status_code__c = 'NOTIFY-FAILED';
                if (pi.sfdc_notification_flag__c != '1')
                    PIError.Update_Vendavo_Date__c = true;
                //logic to set vendavo update date is handled in trigger
                lErrors.add(PIError);
            } 
        }//end of for:newscope                
          
        //System.debug('lACE' + lACE[0].customer__c);
                    
        // Delete duplicate records from Customer view object
        List<ACE_Customer_View__c> lAceCustViewOlD = new List<ACE_Customer_View__c>();
        lAceCustViewOlD = [Select id, name from ACE_Customer_View__c where name in :sIDACEPageView];
        if(lAceCustViewOlD != null)
            delete lAceCustViewOlD;  
        // delete code ends 
          
        //Added on [13/may/2014] - for Alt sku details mapping
        Set<String> sALTSKUIDs = new Set<String>();
        
        // Querying all SKU's linked to Price Change
        List<Ace_Customer_SKU_Changes__c> lSku = new List<Ace_Customer_SKU_Changes__c>();
        
        //================================ROM Item 1.C==================================================  
        //sfdc-882478 --start- code to not include skus for customer view - madhavi        
        map<String, Decimal> map_vendavoskulist = new map<String, Decimal>();
        map<String, Ace_Customer_SKU_Changes__c> map_lskuFull = new map<String, Ace_Customer_SKU_Changes__c>();
        
        set<string> skuUnique = new set<String>();
        for (ace_customer_sku_changes__c ac1:[select CoreList_ID__c,sku__c from ace_customer_sku_changes__c where Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in : sIDs and status__c != 'Inactive']){
            string sku_uniqueid = ac1.CoreList_ID__c+ac1.SKU__c;
            skuUnique.add(sku_uniqueid);
            system.debug('sku_uniqueid:'+sku_uniqueid);
        } 
        
        //collect daily updated vendavo prices
        for (ACE_Vendavo_SKU_Prices__c vendavosku:[select Identifier__c,CoreList_ID__c,SKU__c,Vendavo_Price__c from ACE_Vendavo_SKU_Prices__c      
                                                   where Identifier__c=:skuUnique]){
            system.debug('vendavosku.Identifier__c:'+ vendavosku.Identifier__c);
            string sku_uniqueid = vendavosku.Identifier__c;            
            map_vendavoskulist.put(vendavosku.Identifier__c, vendavosku.Vendavo_Price__c); 
        }
        
        //pull SKUs for the newscope customers, check the 
        
        Map<Id,Id> custIdMap= new Map<Id,Id>();  //01888531
        for(Ace_Customer_SKU_Changes__c SkuFull:[Select Approval_Status__c,vendavo_update_date__c,Owning_Customer_ID__c,price_changes_type__c,Alternate_Chosen_Flag__c,
                sku_last_update__c,Item_12_Month_Qty__c,SKU_Alt__c,Owning_Customer_Corelist_Priority__c,CoreList_ID__c,Core_Priority__c,
                ace_customer_core_changes__r.ace_customer_price_changes__r.page_key__c,ace_customer_core_changes__r.ace_customer_price_changes__r.id,id,
                New_Sell_Price_Percentage_Change_Amoun__c,SKU__c,UOM__c,SKU_Description__c,Current_List_Price__c,Ace_Customer_Core_Changes__c,
                Approved_Proposed_Price__c,Item_12_Month_Sales__c,Sales_Price_Change_Effective_Date_Approv__c,name,Current_Sell_Price__c,Status__c,
                New_List_Price__c,QPU__c,Change_Amount__c,Price_Changes_Type1__c,
                Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__c ,  // ticket 01888531
                Price_Comparison__c //ROM Item 1.C
                from Ace_Customer_SKU_Changes__c where
                Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in : sIDs and status__c != 'Inactive' and Status__c != 'Deleted'
                and CompareQtr_Appr__c != true //ROM Item 1C
                and update_timing_action__c = 'T' ])   //MM Exclude update timing action = false skus
        {
             // ticket 01888531
             
             if(!custIdMap.containskey(SkuFull.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c ))
             custIdMap.put(SkuFull.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c ,  SkuFull.Id);
             
           /*  if(!custIdMap.containskey(SkuFull.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__c ))
             custIdMap.put(SkuFull.Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__c ,  SkuFull.Id);*/
             
            string sku_uniqueid = SkuFull.CoreList_ID__c+SkuFull.SKU__c;
            //map_lskuFull.put(sku_uniqueid,SkuFull);
            if(map_vendavoskulist.containsKey(sku_uniqueid)){
                //Including the below skus for customer report
                if(map_vendavoskulist.get(sku_uniqueid) <= SkuFull.Price_Comparison__c)   
                    lsku.add(skufull); 
            }
            else if (map_vendavoskulist.get(sku_uniqueid) != null)
            //else//Including the below skus for customer report
                lsku.add(skufull);                              
        }  
        //==========================ROM Item 1.C========================================================
        
               
        // Modified for 00827452,00826573 -----ROM Item 1.C
        /*lSku = [Select Approval_Status__c,vendavo_update_date__c,Owning_Customer_ID__c,price_changes_type__c,Alternate_Chosen_Flag__c,
                sku_last_update__c,Item_12_Month_Qty__c,SKU_Alt__c,Owning_Customer_Corelist_Priority__c,CoreList_ID__c,Core_Priority__c,
                ace_customer_core_changes__r.ace_customer_price_changes__r.page_key__c,ace_customer_core_changes__r.ace_customer_price_changes__r.id,id,
                New_Sell_Price_Percentage_Change_Amoun__c,SKU__c,UOM__c,SKU_Description__c,Current_List_Price__c,Ace_Customer_Core_Changes__c,
                Approved_Proposed_Price__c,Item_12_Month_Sales__c,Sales_Price_Change_Effective_Date_Approv__c,name,Current_Sell_Price__c,Status__c,
                New_List_Price__c,QPU__c,Change_Amount__c,Price_Changes_Type1__c,
                Price_Comparison__c //ROM Item 1.C
                from Ace_Customer_SKU_Changes__c where
                Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in : sIDs and status__c != 'Inactive'];*/             
       
        list<ACE_Customer_SKU_Changes__c> skuUpdVdt = new list<Ace_Customer_SKU_Changes__c>();
        Map<String,ace_customer_sku_changes__C> skuMap = new Map<String,ace_customer_sku_changes__c>();
        
        for(Ace_Customer_SKU_Changes__c s :lSku){
            
            if (s.Approval_Status__c == 'Pending')
                recallIDs.add(s.id);//collecting sku ids-madhavi
                
            String key = s.ace_customer_core_changes__r.ace_customer_price_changes__r.id+s.sku__c+s.CoreList_ID__c;
            sSKUIDs.add(s.sku__c);//collecting sku numbers-madhavi
            
            if(s.SKU_Alt__c != null && s.Alternate_Chosen_Flag__c)
                sALTSKUIDs.add(s.SKU_Alt__c);//collecting ALT sku numbers
              
            if (s.Price_Changes_Type__c != 'A') {//if it is not Alt SKU - madhavi
                if (skuMap.containskey(key)) {
                    if (s.core_priority__c < skuMap.get(key).Core_Priority__c)
                    skuMap.put(key,s);//putting the low priority sku - madhavi
                }
                else  
                  skuMap.put(key,s);
            }               
              
        }//end of for                 
        
        System.debug('&&&&&&&& skuMap'+ skuMap);        
          
        /* For (ACE_Customer_SKU_Changes__c s:[select id,vendavo_update_date__c,qpu__C ,New_List_Price__c from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__c in :totalPriceIDs]) {
            s.vendavo_update_date__c = system.now();
            skuUpdVdt.add(s);
        }*/
          
       //Added on [13/may/2014] - for Alt sku details mapping 
       Map<String,Ace_Customer_SKU_Changes__c> map_ASKu_SKu = new Map<String,Ace_Customer_SKU_Changes__c>(); 
       for(Ace_Customer_SKU_Changes__c ASRec: [Select id,Owning_Customer_ID__c,CoreList_ID__c, SKU__c,Current_Sell_Price__c,approved_proposed_price__c,SKU_Description__c,UOM__c,qpu__C,New_List_Price__c  from Ace_Customer_SKU_Changes__c where SKU__c in :sALTSKUIDs and status__c = 'Active' and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in :sIDs])
            map_ASKu_SKu.put(ASRec.SKU__c+ASRec.CoreList_ID__c+ASRec.Owning_Customer_ID__c, ASRec);
          
       Map<String,Product2> map_Prod = new map<String,Product2>(); 
       for(Product2 prd: [Select id, SKUID__c, quntity_per_unit__c from Product2 where SKUID__c in :sSKUIDs ])
            map_Prod.put(prd.SKUID__c, prd);
                    
        AggregateResult[] groupedResults = [SELECT ace_customer_core_changes__r.ace_customer_price_changes__r.id PID,min(ChangeAmount_per__c) min,max(ChangeAmount_per__c) max from ace_customer_sku_changes__c where Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in : sIDs and status__c != 'Inactive' group by ace_customer_core_changes__r.ace_customer_price_changes__r.id];
        Map<ID,AggregateResult> map_ID_aggrResult = new Map<ID,AggregateResult>();
        for (AggregateResult ar : groupedResults) 
            map_ID_aggrResult.put((ID)ar.get('PID'),ar);
          
        System.debug('map_ID_aggrResult >>>>>>>>>>>>' +  map_ID_aggrResult);
        
        // Creating mail out record starts here--------         
        for (ID I : contactsMap.keySet()) {
            ID acctID = contactsMap.get(i);
            
            if (acctToPriceMap.get(acctID) != null) {
                Ace_Customer_Price_Changes__c ace = acctToPriceMap.get(acctID);                
                sCustSKUIDs.add(ace.id);
                  
                ACE_Customer_MailOut__c mailOut = new ACE_Customer_MailOut__c();
                if (userInfo.getOrganizationId() != '00DE0000000J4oSMAS')
                    mailOut.Email__c = 'indra.varada@officedepot.com'; 
                else
                    mailOut.Email__c = IDToContact.get(I).email;
                
                mailout.Contact__c = I;   

                //mm rom item 1d                             
/*              if ((ace.Customer_Notification_Date__c <> ace.customer_notification_date_approved__c) && (ace.Compare_Quarter__c == true))   
                {
                    mailout.Email_Template_Code__c = '11';
                }
                else if ((ace.Customer_Notification_Date_Approved__c <> ace.Customer_Notification_Date__c) && (ace.Compare_Quarter__c == false))
*/              //mm rom item 1d                    
                {        
                    if (ace.Hosted_Catalog__c) {
                        if (ace.SFDC_Notification_Flag__c == '3')//approval required bucket-madhavi
                            mailOut.Email_Template_Code__c = '4';
                        else if (ace.SFDC_Notification_Flag__c == '2') //notification required bucket-madhavi
                            mailOut.Email_Template_Code__c = '5';
                        else//no requirements required bucket-madhavi
                            mailOut.Email_Template_Code__c = '6';
                    }
                    else {
                        if (ace.SFDC_Notification_Flag__c == '1')//no requirements required bucket-madhavi
                            mailOut.Email_Template_Code__c = '3';
                        else if (ace.SFDC_Notification_Flag__c == '2')//notification required bucket-madhavi
                            mailOut.Email_Template_Code__c = '2';
                        else if (ace.SFDC_Notification_Flag__c == '3')//approval required bucket-madhavi
                            mailOut.Email_Template_Code__c = '1';
                    }
                
                    mailOut.Notification_Date__c = ace.Customer_Notification_Date_Approved__c;
                    // Generate Email Key - starts
                    Blob blobKey = crypto.generateAesKey(128);
                    mailOut.email_key__c = EncodingUtil.convertToHex(blobKey);
                    // Generate Page Key - Ends  
                    mailOut.URL__c = aceSetting.Site_URL__c + '?pkey='+ ace.Page_Key__c+'&ekey='+mailOut.email_key__c;
                    mailOut.Customer__c = ace.customer__c;
                    mailOut.Customer_Core_Price_Changes__c = ace.id;
                    mailOut.Sales_Price_Change_Effective_Date_Min__c = ace.Sales_Price_Change_Effective_Date_Min__c;
                    mailOut.Sales_Price_Change_Effective_Date_Appr__c = ace.Sales_Price_Change_Effective_Date_Approv__c;
                    mailOut.Rep_Name__c = ace.Customer__r.owner.name;
                    mailout.Rep_First_name__c = ace.Customer__r.owner.firstname;
                    mailout.Rep_Last_Name__c = ace.Customer__r.owner.lastname;
                    mailOut.Rep_Email__c = ace.Customer__r.owner.email;
                    mailOut.Rep_Phone__c = ace.Customer__r.owner.phone;
                    if(map_ID_aggrResult != null)
                    {
                        if(map_ID_aggrResult.get(ace.id) != null)
                        {   
                            AggregateResult ar  = map_ID_aggrResult.get(ace.id);    
                            mailOut.New_Sell_Price_Change_Amount_Max__c = (Decimal)ar.get('max');
                            mailOut.New_Sell_Price_Change_Amount_Min__c = (Decimal)ar.get('min'); 
                        }
                    
                    } 
                    if(custIdMap.containskey(ace.id )) //    ticket 01888531             
                    lMailOut.add(mailOut);
                
                    //if (ace.sfdc_notification_flag__c != '1') - Removing the condition as per business requirement
                        ace.Record_Lock__c = true;
                
                }//end of else
                
            }//end of if (acctToPriceMap.get(acctID) != null)
            
        }//end of for
        //mm          
        //  Creating Mail out code ends here----------
         
        // Creating ACE Customer View record--starts here-------------------
        set<String> skuNum = new set<String>();
        for(Ace_Customer_SKU_Changes__c s : skuMap.values())
        {    
            System.debug('&&&&&&&& Inside here '+ s);        
            // Modified for 00826573
            if(s.Price_Changes_Type__c=='D'  || s.Price_Changes_Type1__c=='Assortment Swap' || s.Price_Changes_Type1__c=='Alternate'  || s.Price_Changes_Type1__c=='Margin Swap' ||
                (s.Price_Changes_Type1__c=='Margin Lift' &&  s.Change_Amount__c==0  && (s.Alternate_Chosen_Flag__c==true || s.status__c == 'Deleted' ))   ||
                (s.Price_Changes_Type1__c=='Margin Lift' &&  s.Change_Amount__c>0 )  ||
                (s.Price_Changes_Type1__c=='Cost' &&  s.Change_Amount__c==0  && (s.Alternate_Chosen_Flag__c==true || s.status__c == 'Deleted' ))   ||
                (s.Price_Changes_Type1__c=='Cost' &&  s.Change_Amount__c>0 ) ){
                sCustSKUIDs.add(s.id);
                //if(!skuNum.contains(s.SKU__c)){
                //skuNum.add(s.SKU__c);
                
                ACE_Customer_View__c aceCust = new ACE_Customer_View__c();
                aceCust.SKUID__c = s.id;
                aceCust.Current_Sell_Price__c = s.Current_Sell_Price__c;
                aceCust.Sales_Price_Change_Effective_Date_Appro__c = s.Sales_Price_Change_Effective_Date_Approv__c;
                aceCust.Expiration_Date__c = system.now().date().addDays(Integer.valueOf(aceSetting.Expiry_Days__c));
                aceCust.Item_12_Month_Sales__c = s.Item_12_Month_Sales__c;
                aceCust.Approved_Proposed_Price__c = s.Approved_Proposed_Price__c;
                aceCust.Old_Price__c = s.Current_Sell_Price__c;
                aceCust.Item_12_Month_Qty__c = s.Item_12_Month_Qty__c;
                aceCust.sku_last_update__c = s.sku_last_update__c;
                aceCust.SKU_Description__c = s.SKU_Description__c;
                aceCust.UOM__c = s.UOM__c;
                aceCust.Sku__c =  s.SKU__c;
                          
                // Modified for 00827452
                aceCust.QPU__c =  s.QPU__c;
                aceCust.List_Price__c =  s.New_List_Price__c;                          
                          
                // Modified for 00826573
                if(s.Price_Changes_Type__c=='D'  || s.Price_Changes_Type1__c=='Assortment Swap'  || s.Price_Changes_Type1__c=='Margin Swap' ||
                    (s.Price_Changes_Type1__c=='Margin Lift' &&  s.Change_Amount__c==0  && (s.Alternate_Chosen_Flag__c==true || s.status__c == 'Deleted' ))   ||
                    (s.Price_Changes_Type1__c=='Cost' &&  s.Change_Amount__c==0  && (s.Alternate_Chosen_Flag__c==true || s.status__c == 'Deleted' ))   // ||
                    ){
                        aceCust.List_Price__c =  null;
                }                                      

                //aceCust.Cutomer_Priority__c = s.Ace_Customer_core_Changes__r.Ace_Customer_price_Changes__r.Owning_Customer_Corelist_Priority__c
                aceCust.name = s.ace_customer_core_changes__r.ace_customer_price_changes__r.Page_Key__c;
                    
                //Added on [13/may/2014] - for Alt sku details mapping
                if(s.SKU_Alt__c != null && map_ASKu_SKu.containsKey(s.SKU_Alt__c+s.CoreList_ID__c+s.Owning_Customer_ID__c))
                {
                    system.debug('Inside Alt Fetch Logic');
                    aceCust.Alt_SKU__c = s.SKU_Alt__c;
                    Ace_Customer_SKU_Changes__c skuRec = map_ASKu_SKu.get(s.SKU_Alt__c+s.CoreList_ID__c+s.Owning_Customer_ID__c);
                    aceCust.Alt_Sell_Price__c = SkuRec.approved_proposed_price__c;
                    aceCust.Alt_SKU_Description__c = SkuRec.SKU_Description__c;
                    aceCust.Alt_UOM__c = SkuRec.UOM__c;                              
                    // Modified for 00827452
                    aceCust.Alt_QPU__c =  SkuRec.QPU__c;
                    aceCust.Alt_List_Price__c =  SkuRec.New_List_Price__c;
                        
                }
                    
                //Added by Guha [12/may/2014] - for sku details mapping
                if(s.status__c == 'Deleted' && s.price_Changes_Type__c == 'D')
                    aceCust.Status__c = 'D';
                else if(s.status__c == 'Deleted' && s.price_Changes_Type__c != 'D')
                    aceCust.Status__c = 'R'; 
                                 
                if(map_Prod != null){
                    if(map_Prod.get(s.sku__c) != null)
                        aceCust.Quantity_Per_Unit__c = map_Prod.get(s.sku__c).quntity_per_unit__c;
                }
                    
                lAceCustView.add(aceCust); 
                          
            }//end of if
            //}            
        } //end of for        
        // Creating ACE Customer View record code ends here---------------------------------
          
        // Recall Approval Process
        ACE_RECALL_APPROVAL_PROCESS.ACERecallMethod(recallIDs);
          
        // Insert Mail out records
        if(lMailOut.size() > 0)
            insert lMailOut;
        
        // Update price change records
        if(lACE.size() > 0)
            update lACE;  
          
        /*if (skuUpdVdt.size() > 0)
            update skuUpdVdt; */
          
        if(lErrors.size() > 0)
            update lErrors;  
          
        // Insert Customer view records
        if(lAceCustView != null)
            insert lAceCustView;                      
            
     } //end of execute(Database.BatchableContext BC, List<sObject> scope) 
 
     global void finish(Database.BatchableContext info) 
     {
        /*aceSetting.Site_Batch_Start_Date__c = System.now().addDays(1).date();
        aceSetting.Site_Batch_End_Date__c = System.now().addDays(2).date();*/
        Date dtSet;
        if (aceSetting.Site_Batch_End_Date__c == system.today())
            dtSet = system.today() + 1;
        else
            dtSet = system.today();        
        
        aceSetting.Site_Batch_Start_Date__c = dtSet;
        aceSetting.Site_Batch_End_Date__c = dtSet;
         
        update aceSetting;
                  
     } // finish 
    
} // end class