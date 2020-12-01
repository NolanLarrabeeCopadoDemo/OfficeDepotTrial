/*** File Name   : AccountServiceBatch
*    Description : 
*    Copyright   : Office Depot 
*    @author     : Nagalingeswara Reddy
*    Created Date: 14/02/2018
*    Modification Log
*    ============================================================ 
*
***/ 
global class AccountServiceDataBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable {
    
    global Database.QueryLocator start(Database.BatchableContext bc){ 
        String query = 'SELECT id,SPC_Indicator__c,CREATE_UPDATE_FLAG__C,VERSION__C,SFDC_CUSTOMER_ID__C,ORACLE_CUSTOMER_ID__C,AOPS_CUSTOMER_ID__C,CONTRACT_RETAIL_CUST_CODE__C,BUSINESS_NAME__C,CUSTOMER_DELETE_FLAG__C,CUSTOMER_TYPE__C,RSV1_CHAR2__C,RSV2_CHAR2__c,PARENT_CUSTOMER_ID__C,FREIGHT_CHARGE_REQUIRED__C,ACCCOUNT_PROSPECT_ID__C,SEGMENTATION__C,SECTOR__C,ORDER_MAX_AMOUNT__C,REP__C,EMP_ID__C,HOSTED_CATALOG_FLAG__c,Legal_Flag__C,Account_Type__c, AOPSMSTRTIMEST__c FROM Account_Service_Data__c WHERE Batch_Processed__c = false and Account_Type__c =\'Customer\' and createddate  <= LAST_N_DAYS:'+System.Label.Account_Service_Batch_Created_Days  +'order by AOPSMSTRTIMEST__c desc Limit '+System.Label.AccountServiceBatchLimitRecords;
        //String query = 'SELECT id,SPC_Indicator__c,CREATE_UPDATE_FLAG__C,VERSION__C,SFDC_CUSTOMER_ID__C,ORACLE_CUSTOMER_ID__C,AOPS_CUSTOMER_ID__C,CONTRACT_RETAIL_CUST_CODE__C,BUSINESS_NAME__C,CUSTOMER_DELETE_FLAG__C,CUSTOMER_TYPE__C,RSV1_CHAR2__C,RSV2_CHAR2__c,PARENT_CUSTOMER_ID__C,FREIGHT_CHARGE_REQUIRED__C,ACCCOUNT_PROSPECT_ID__C,SEGMENTATION__C,SECTOR__C,ORDER_MAX_AMOUNT__C,REP__C,EMP_ID__C,HOSTED_CATALOG_FLAG__c,Legal_Flag__C,Account_Type__c FROM Account_Service_Data__c WHERE Batch_Processed__c = false and Account_Type__c =\'Customer\'  and AOPS_CUSTOMER_ID__c =\'02526870\'';
        return  Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    Constants.SkipAccountTrigger=true;
        
        List<Account_Service_Data__c> accServiceDataRec = (List<Account_Service_Data__c>)scope;
        List<Account_Service_Data__c> accServiceDataList = new List<Account_Service_Data__c>();
        
        Map<Id,Database.UpsertResult> custUpsertMap = new Map<Id,Database.UpsertResult>();
        Map<Id,Database.UpsertResult> siteUpsertMap = new Map<Id,Database.UpsertResult>();
        
        Map<String,Account> aopsCustMap = new Map<String,Account>();
        Map<String,Account> aopsSiteMap = new Map<String,Account>();
        
        Database.UpsertResult[] upsertCustResultAops;
        Database.UpsertResult[] upsertCustResultOracle;
        Database.SaveResult[]   upsertSiteResultsfdc;
        Database.UpsertResult[] upsertSiteResultAops;
        Database.UpsertResult[] upsertSiteResultOracle;
        
        //To hold error message while processing Customer records
        Map<String,String> customerAndSiteAccErrorMap = new Map<String,String>();
        String UpsertErrorMessage;
        
        List<Account> sites = new List<Account>();
        //Create a savepoint to rollback to in case of error
        Savepoint sp = Database.setSavepoint();
        Set<String> CustomerId= new Set<String>();
        //Get Customer Account record
        List<Account> accounts = new List<Account>();
        //Map<APOS Customer Id, Accountservice Data>
        Map<String,Account_Service_Data__c> customerRecMap= new Map<String,Account_Service_Data__c>();
        
        try{               
            if(!accServiceDataRec.isEmpty() ){
                for( Account_Service_Data__c  rec : accServiceDataRec){                
                    if(!CustomerId.contains(rec.AOPS_CUSTOMER_ID__C)){
                        CustomerId.add(rec.AOPS_CUSTOMER_ID__C);
                        accounts.add(setCustomerAccountFields(rec));
                        customerRecMap.put(rec.AOPS_CUSTOMER_ID__C, rec);
                    }           
                }
                
                // Code to Restore to Account from Dormant - starts
                Set<String> AOPSIDs = new Set<String>();
                AccountRestore ar = new AccountRestore();
                List<Account> accountsPartyUpdate = new List<Account>();
                Set<String> SiteId= new Set<String>();
                
                for (Account a:accounts) {
                    if (String.isNotBlank(a.aops_cust_id__c))
                        AOPSIDs.add(a.aops_cust_id__c);
                    if (String.isNotBlank(a.Oracle_Party_ID__c))
                        accountsPartyUpdate.add(a);
                }
                
                list<Account_Dormant__c> acctDormants = new list<Account_Dormant__c>();
                if (!AOPSIDs.isEmpty())
                    acctDormants =[select id,AccountExtension__c from Account_Dormant__c where AccountExtension__r.aops_cust_id__c=:AOPSIDs];
                if (!acctDormants.isEmpty())
                    ar.RestoreAccount(acctDormants,'Source System Update','');
                // Code to Restore to Account from Dotmant - Ends
                
                upsertCustResultAops = Database.upsert(accounts,Account.AOPS_Cust_Id__c,false);
                
                
                  upsertCustResultOracle = Database.upsert(accountsPartyUpdate,Account.Oracle_Party_ID__c,false);
                
                for(Integer i = 0; i < upsertCustResultOracle.size(); i++){
                    if(upsertCustResultOracle[i].isSuccess()){
                        custUpsertMap.put(upsertCustResultOracle[i].getId(),upsertCustResultOracle[i]);
                    }
                    else
                    {
                       for(Database.Error err : upsertCustResultAops[i].getErrors())        
                            UpsertErrorMessage = err.getStatusCode() + ': ' + err.getMessage();
                        
                        customerAndSiteAccErrorMap.put(accountsPartyUpdate[i].Oracle_Party_ID__c,UpsertErrorMessage);
                        // Database.rollback(sp);
                    }
                    
                }
                
                for(Integer i = 0; i < upsertCustResultAops.size(); i++){
                    if(upsertCustResultAops[i].isSuccess()){
                        if(!custUpsertMap.containsKey(upsertCustResultAops[i].getId()))
                            custUpsertMap.put(upsertCustResultAops[i].getId(),upsertCustResultAops[i]);
                    }
                    else{
                        for(Database.Error err : upsertCustResultAops[i].getErrors())        
                            UpsertErrorMessage = err.getStatusCode() + ': ' + err.getMessage();
                        
                        customerAndSiteAccErrorMap.put(accounts[i].AOPS_Cust_Id__c,UpsertErrorMessage);
                        //Database.rollback(sp);
                    }
                    
                }
                
                //create a map of the aops id's to the accounts just created
                //this is used to associate the accounts to the message passed in
                //and also to associate the parent customer to its associated sites
                List<Account> successAccount =[select Id,AOPS_Cust_Id__c from Account  where Id in :custUpsertMap.keyset()];
                Map<String,Id> successAccountId= new Map<String,Id>();
                Map<String,Account_Service_Data__c>  customerRecMap1 = new Map<String,Account_Service_Data__c>();
                
   
                                Map<Id,Account_Service_Data__c> sfdcCustMap1 = new Map<Id,Account_Service_Data__c>();

                for(Account aopsAcct : successAccount){
                    aopsCustMap.put(aopsAcct.AOPS_Cust_Id__c , aopsAcct);
                    successAccountId.put(aopsAcct.AOPS_Cust_Id__c , aopsAcct.Id);
                    if(customerRecMap.containsKey(aopsAcct.AOPS_Cust_Id__c)){
                        customerRecMap1.put(aopsAcct.Id,customerRecMap.get(aopsAcct.AOPS_Cust_Id__c));
                        sfdcCustMap1.put(aopsAcct.Id,customerRecMap.get(aopsAcct.AOPS_Cust_Id__c));

                    }
                }
                
                
                
                accServiceDataList = [SELECT Id,SPC_Indicator__c, CREATE_UPDATE_FLAG__c, VERSION__c, SFDC_CUSTOMER_ID__c, ORACLE_CUSTOMER_ID__c, 
                                      AOPS_CUSTOMER_ID__c, CONTRACT_RETAIL_CUST_CODE__c, BUSINESS_NAME__c, CUSTOMER_DELETE_FLAG__c, 
                                      CUSTOMER_TYPE__c, RSV1_CHAR2__c, RSV2_CHAR2__c, PARENT_CUSTOMER_ID__c, FREIGHT_CHARGE_REQUIRED__c, 
                                      ACCCOUNT_PROSPECT_ID__c, SEGMENTATION__c, ORDER_MAX_AMOUNT__c, SECTOR__c, REP__c, EMP_ID__c, 
                                      HOSTED_CATALOG_FLAG__c, Legal_Flag__c, ORACLE_ADDR_SEQ_NUM__c, SFDC_ADDR_SEQ_NUM__c, 
                                      AOPS_ADDR_SEQ_NUM__c, LOCATION_KEY__c, ACCOUNT_NAME__c, ADDRESS_LINE1__c, ADDRESS_LINE2__c, 
                                      CITY__c, Batch_Processed__c, STATE__c, ZIP_CODE__c, COUNTRY__c, COUNTY__c, SITE_REP__c, REP_EMP_ID__c,
                                      DEFAULT_FLAG__c, Name,Account_Type__c FROM Account_Service_Data__c 
                                      where account_type__C='Site' and Batch_Processed__c=false and 
                                      AOPS_CUSTOMER_ID__C in :aopsCustMap.keyset()
                                      order by createddate desc Limit 250];
                
                
                List<Account_Service_Data__c> siteAccountList     = new List<Account_Service_Data__c>();
                Map<String,List<Account_Service_Data__c>> customerSitesMap = new Map<String,List<Account_Service_Data__c>>();
                for(Account_Service_Data__c accServiceData : accServiceDataList){ 
                    if(!SiteId.contains(accServiceData.AOPS_ADDR_SEQ_NUM__c)){
                        SiteId.add(accServiceData.AOPS_ADDR_SEQ_NUM__c);
                        siteAccountList.add(accServiceData);
                        Id parentCustomerId = aopsCustMap.get(accServiceData.AOPS_CUSTOMER_ID__C).Id; 
                        sites.add(setSiteFields(accServiceData, parentCustomerId));
                        if(aopsCustMap.containsKey(accServiceData.AOPS_CUSTOMER_ID__C)){
                            if(customerSitesMap.containsKey(accServiceData.AOPS_CUSTOMER_ID__C)){
                                List<Account_Service_Data__c> accSiteData = customerSitesMap.get(accServiceData.AOPS_CUSTOMER_ID__C);
                                accSiteData.add(accServiceData); 
                                customerSitesMap.put(accServiceData.AOPS_CUSTOMER_ID__C,accSiteData); 
                            }else{
                                customerSitesMap.put(accServiceData.AOPS_CUSTOMER_ID__C,new List<Account_Service_Data__c>{accServiceData});
                            }
                        }
                    }
                }
                
                
                // Code to Restore to Sites from Dormant - starts
                set<String> AOPSSeqIDs = new set<String>();
                for (Account a:sites) {
                    if (String.isNotBlank(a.aops_seq_id__c))
                        AOPSSeqIDs.add(a.aops_seq_id__c);
                }
                list<Account_Dormant__c> siteDormants = new list<Account_Dormant__c>();
                if (!AOPSSeqIDs.isEmpty())
                    siteDormants =[select id,AccountExtension__c from Account_Dormant__c where AccountExtension__r.aops_seq_id__c=:AOPSSeqIDs];
                if (!siteDormants.isEmpty())
                    ar.RestoreAccount(siteDormants,'Source System Update','');
                // Code to Restore to Sites from Dotmant - Ends
                
                //loop through the sites and do the upserts just as we did for the customers with external id's and error conditions being handled
                upsertSiteResultAops = Database.upsert(sites,Account.AOPS_Seq_ID__c,false);
                upsertSiteResultOracle = Database.upsert(sites,Account.Oracle_Party_Site_ID__c,false);
                
                for(Integer i = 0; i < upsertSiteResultAops.size(); i++){
                    if(upsertSiteResultAops[i].isSuccess())
                        siteUpsertMap.put(upsertSiteResultAops[i].getId(),upsertSiteResultAops[i]);
                    else if(upsertSiteResultOracle[i].isSuccess())
                        siteUpsertMap.put(upsertSiteResultOracle[i].getId(),upsertSiteResultOracle[i]);
                }
                
             //Added 04/30 to fix DML issue  
            Set<String> successSiteSet = new Set<String>(); 
            List<Account> successSite =[select Id,AOPS_Seq_ID__c from Account  where Id in :siteUpsertMap.keyset()];

                for(  Account rec :successSite )
                successSiteSet.add(rec.AOPS_Seq_ID__c);
          //  end of Added 04/30 to fix DML issue  
    
                
                //create the same map of aops id to accounts for sites as we did for customers
                for(Account aopsSite : sites){
                    aopsSiteMap.put(aopsSite.AOPS_Seq_ID__c , aopsSite);
                }
                
                // Update the Processed records to success
                
                LIst< Account_Service_Data__c  > rec =[select Id ,status__C , Batch_Processed__c,AOPS_CUSTOMER_ID__c,
                ORACLE_CUSTOMER_ID__c from Account_Service_Data__c  
                                                       where AOPS_CUSTOMER_ID__C = : CustomerId 
                                                        and  AOPS_ADDR_SEQ_NUM__c  in :successSiteSet and Batch_Processed__c=false];
                for(Account_Service_Data__c  acc :rec){
                    if(aopsCustMap.containsKey(acc.AOPS_CUSTOMER_ID__C)){
                        acc.status__C='SUCCESS';
                        acc.Batch_Processed__c=true;
                    }else{
                        acc.status__C='FAIL';
                        acc.ERROR_Message__c = customerAndSiteAccErrorMap.get(acc.AOPS_CUSTOMER_ID__C);
                    }
                    
                }
                update rec; 
                
                
          List<AggregateResult> DataRollUp= [SELECT AOPS_CUSTOMER_ID__C,count(id) cnt
          from  Account_Service_Data__c where AOPS_CUSTOMER_ID__C = : CustomerId and Batch_Processed__c=false
          and account_type__C='Site'  
          GROUP BY CUBE(AOPS_CUSTOMER_ID__C)  ORDER BY GROUPING(AOPS_CUSTOMER_ID__C)];

        Map<String,Integer> MapCount= new Map<String,Integer>();
         for (AggregateResult ar1 :DataRollUp) {        
           String orgRecId=(String)ar1.get('AOPS_CUSTOMER_ID__C');
           if(orgRecId!=null){
           Integer count= (Integer) ar1.get('cnt');
           MapCount.put( orgRecId, count) ;         
           }
           
           }
  
             System.debug('&&&&&&&&&&&MapCount'+MapCount);  
            
            
            LIst< Account_Service_Data__c  > recCust =[select Id ,status__C , Batch_Processed__c,AOPS_CUSTOMER_ID__c,
                ORACLE_CUSTOMER_ID__c from Account_Service_Data__c  
                                                       where AOPS_CUSTOMER_ID__C = : CustomerId 
                                                       and account_type__C='Customer'  
                                                         and Batch_Processed__c=false  Limit 1000];
                                  System.debug('&&&&&&&&&&&recCust '+recCust );  
                                    
                                                         
                for(Account_Service_Data__c  acc :recCust){
                    if(aopsCustMap.containsKey(acc.AOPS_CUSTOMER_ID__C)){
                                                      System.debug('&&&&&&&&&&&Inside acc.AOPS_CUSTOMER_ID__C '+acc.AOPS_CUSTOMER_ID__C);  
                                                      System.debug('&&&&&&&&&&&Inside MapCount.get(acc.AOPS_CUSTOMER_ID__C) '+MapCount.get(acc.AOPS_CUSTOMER_ID__C));  

                     if(  (! ( MapCount.containskey(acc.AOPS_CUSTOMER_ID__C) )) ||  MapCount.get(acc.AOPS_CUSTOMER_ID__C)==0){
                     
                      System.debug('&&&&&&&&&&&in Loop' );  
                        acc.status__C='SUCCESS';
                        acc.Batch_Processed__c=true;
                        }
                    }else{
                        acc.status__C='FAIL';
                        acc.ERROR_Message__c = customerAndSiteAccErrorMap.get(acc.AOPS_CUSTOMER_ID__C);
                    }
                    
                }
                update recCust; 
    
            
            
                
                
                
                
                //Using the aops maps we can now associate sfdc ids to the message objects passed in.  We need this becuase later we need to check values between
                //the accounts created and the message passed in.
                Map<Id,Account_Service_Data__c> sfdcCustMap = new Map<Id,Account_Service_Data__c>();
                Map<Id,Account_Service_Data__c> sfdcSiteMap = new Map<Id,Account_Service_Data__c>();
                
                //Map<CustomerRecordId,List<SiteRecords>>
                Map<String,List<Account_Service_Data__c>> mapOfCustomerAndSites = new Map<String,List<Account_Service_Data__c>> ();
                for(String custAopsId : customerSitesMap.keySet()){
                    mapOfCustomerAndSites.put(aopsCustMap.get(custAopsId).Id,customerSitesMap.get(custAopsId));
                }
        
                for(String aposCustId  : mapOfCustomerAndSites.keySet()){
                    sfdcCustMap.put(aposCustId,customerRecMap1.get(aposCustId));
                    for(Account_Service_Data__c siteRec : mapOfCustomerAndSites.get(aposCustId)){
                        sfdcSiteMap.put(aopsSiteMap.get(siteRec.AOPS_ADDR_SEQ_NUM__c).id,siteRec);
                    }     
                }   
               
                //Below logic not implementing since we are not sending any response back to SOA
                //If a message was passed as an update but it was actually a create we need to throw an error.  This is so the appropriate fields can be passed
                //for the create.  We have already created the account so before we return we need to rollback to the savepoint.
                
                //update sales rep and owner for customers and sites
               // updateCustomerAssociations(accounts,sfdcCustMap,custUpsertMap);
               updateCustomerAssociations(accounts,sfdcCustMap1,custUpsertMap);
               
                updateSiteAssociations(sites,sfdcSiteMap,siteUpsertMap);
                
                //update the parent association for the hierarchy
                //updateParentAssociations(accounts,sfdcCustMap);
                updateParentAssociations(accounts,sfdcCustMap1 );
            }
        }
        catch(Exception e){
            System.debug('Error/Stack/Line Number Stack----->'+e.getMessage()+','+e.getStackTraceString()+','+e.getLineNumber());
            //Database.rollback(sp);
        }  
        
    }
    
    global void finish(Database.BatchableContext info){
        CustTransParentChildLevel__c CSAccountServiceObj = [select AccountServiceBatchID__c,AccountServiceBatchInterval__c from 
                                                 CustTransParentChildLevel__c limit 1];
        Integer interval = 300;        
        if (CSAccountServiceObj.AccountServiceBatchID__c <> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:CSAccountServiceObj.AccountServiceBatchID__c])
                system.abortJob(existingJob.id);
        }
        
        if(CSAccountServiceObj.AccountServiceBatchInterval__c!= null)
            interval = (Integer)CSAccountServiceObj.AccountServiceBatchInterval__c;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        AccountServiceDataBatch AccountServiceBatchObj = new AccountServiceDataBatch ();
        ID cronid = System.schedule( 'AccountServiceDAtaBatch' + sysTime, chronExpression, AccountServiceBatchObj );    
        
        CSAccountServiceObj.AccountServiceBatchID__c= cronid;
        
        update CSAccountServiceObj;   
    }
    
    global void execute(SchedulableContext sc){
        Integer batch_size = Integer.valueOf(Label.Account_Service_Batch_Size);
        Database.executeBatch(new AccountServiceDataBatch(),batch_size);
    }
    
    //Hepler method to construct Customer Account records from Account Service Data
    global static Account setCustomerAccountFields(Account_Service_Data__c accDataServiceRec){
        
        Account custAcc = new Account();
        custAcc.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        if(accDataServiceRec.BUSINESS_NAME__c != null)
            custAcc.Name = accDataServiceRec.BUSINESS_NAME__c;
        
        if(accDataServiceRec.ORACLE_CUSTOMER_ID__c != null)
            custAcc.Oracle_Party_id__c = accDataServiceRec.ORACLE_CUSTOMER_ID__c;
        
        if(accDataServiceRec.AOPS_CUSTOMER_ID__c != null)
        {
            custAcc.AOPS_Cust_Id__c = accDataServiceRec.AOPS_CUSTOMER_ID__c;
            custAcc.Account_Setup_Request_Status__c = 'Express Setup Complete';
        }
        
        if(accDataServiceRec.CONTRACT_RETAIL_CUST_CODE__c != null)
            custAcc.CONTRACT_RETAIL_CUST_CODE__c = accDataServiceRec.CONTRACT_RETAIL_CUST_CODE__c;
        
        if (accDataServiceRec.HOSTED_CATALOG_FLAG__c != null && accDataServiceRec.HOSTED_CATALOG_FLAG__c == 'Y')
            custAcc.Hosted_Catalog_Flag__c = True;
        
        if (accDataServiceRec.HOSTED_CATALOG_FLAG__c == null || accDataServiceRec.HOSTED_CATALOG_FLAG__c == 'N')
            custAcc.Hosted_Catalog_Flag__c = False;
        
        if(accDataServiceRec.CUSTOMER_DELETE_FLAG__c != null)
            custAcc.Status__c = accDataServiceRec.CUSTOMER_DELETE_FLAG__c;
            
        if(accDataServiceRec.SPC_Indicator__c     != null)
            custAcc.SPC_Allowed__c= accDataServiceRec.SPC_Indicator__c;
    
            
        
        
        if(accDataServiceRec.CUSTOMER_TYPE__c != null)
            custAcc.Loyalty_Type__c = accDataServiceRec.CUSTOMER_TYPE__c;
        
        if(accDataServiceRec.Legal_Flag__c != null)
            custAcc.Legal_flag__c = accDataServiceRec.Legal_Flag__c;
        
        if(accDataServiceRec.ORDER_MAX_AMOUNT__c != null){
            try{
                custAcc.Max_Order_Limit__c = decimal.valueOf(accDataServiceRec.ORDER_MAX_AMOUNT__c);
            }
            catch(Exception e){
                custAcc.Max_Order_Limit__c = null;
            }
        }
        
        if(accDataServiceRec.RSV2_CHAR2__c != null)
            custAcc.Deliver_Charge__c = accDataServiceRec.RSV2_CHAR2__c;
        
        if(accDataServiceRec.FREIGHT_CHARGE_REQUIRED__c != null)
            custAcc.Freight_Charge__c = accDataServiceRec.FREIGHT_CHARGE_REQUIRED__c;
        
        if(accDataServiceRec.SEGMENTATION__c != '')
            custAcc.Segment__c = accDataServiceRec.SEGMENTATION__c;
        
        if(accDataServiceRec.SECTOR__c != null)
            custAcc.Sector__c = accDataServiceRec.SECTOR__c;
         
        
        return custAcc;
    }
    
    //Hepler method to construct Site Account records corresponding Customer from Account Service Data records
    global static Account setSiteFields(Account_Service_Data__c sSite, Id parentAcctId){
        
        Account lclSite;
        
        if (sSite.SFDC_ADDR_SEQ_NUM__c != null)
            lclSite = new Account(id=sSite.SFDC_ADDR_SEQ_NUM__c);
        else
            lclSite = new Account();
        
        lclSite.Related_Account__c = parentAcctId;
        lclSite.recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        
        if(sSite.ORACLE_ADDR_SEQ_NUM__c != null)
            lclSite.Oracle_Party_Site_ID__c = sSite.ORACLE_ADDR_SEQ_NUM__c;
        
        if(sSite.AOPS_ADDR_SEQ_NUM__c != null)
            lclSite.AOPS_Seq_ID__c = sSite.AOPS_ADDR_SEQ_NUM__c;
        
        if(sSite.ACCOUNT_NAME__c != null)
            lclSite.Name = sSite.ACCOUNT_NAME__c;
        
        if(sSite.ADDRESS_LINE1__c != null)
            lclSite.Address1__c = sSite.ADDRESS_LINE1__c;
        
        if(sSite.ADDRESS_LINE2__c != null)
            lclSite.Address2__c = sSite.ADDRESS_LINE2__c;
        
        if(sSite.CITY__c != null)
            lclSite.City__c = sSite.CITY__c;
        
        if(sSite.STATE__c != null)
            lclSite.State__c = sSite.STATE__c;
        
        if(sSite.ZIP_CODE__c != null)
            lclSite.Zip__c = sSite.ZIP_CODE__c;
        
        if(sSite.COUNTRY__c != null)
            lclSite.Country__c = sSite.COUNTRY__c;
        
        if(sSite.COUNTY__c != null)
            lclSite.County__c = sSite.COUNTY__c;
        
        if (sSite.AOPS_ADDR_SEQ_NUM__c != null)
        {
            if(sSite.AOPS_ADDR_SEQ_NUM__c.contains('-00001'))
            {
                Account lact = [SELECT id FROM account where ID = :parentAcctId];
                
                if(sSite.ADDRESS_LINE1__c != null)
                    lact.Address1__c = sSite.ADDRESS_LINE1__c;
                
                if(sSite.ADDRESS_LINE2__c != null)
                    lact.Address2__c = sSite.ADDRESS_LINE2__c;
                
                if(sSite.CITY__c != null)
                    lact.City__c = sSite.CITY__c;
                
                if(sSite.STATE__c != null)
                    lact.State__c = sSite.STATE__c;
                
                if(sSite.ZIP_CODE__c != null)
                    lact.Zip__c = sSite.ZIP_CODE__c;
                
                if(sSite.COUNTRY__c != null)
                    lact.Country__c = sSite.COUNTRY__c;
                
                if(sSite.COUNTY__c != null)
                    lact.County__c = sSite.COUNTY__c;
                
                update lact;
            }
        }
        return lclSite;
    }
    
    //if a match on emp id and rep id is found then update the sales rep of the customer
    //and if the account was a create assign the owner
    global static void updateCustomerAssociations (List<Account> accounts, Map<Id,Account_Service_Data__c> msgs, Map<Id,Database.UpsertResult> urs){
        List<String> empIds = new List<String>();
        List<String> repIds = new List<String>();
        List<Account> acctsToUpdate = new List<Account>();
        
        for(Account acct : accounts){
            Account_Service_Data__c sa = msgs.get(acct.id);
            system.debug('sa.....'+sa);
            if(sa != null && sa.EMP_ID__C != null && !sa.EMP_ID__C.equals(''))
                empIds.add(sa.EMP_ID__c);
            
            if(sa != null && sa.REP__c != null && !sa.REP__c.equals(''))
                repIds.add(sa.REP__c);
        }
        
        List<Sales_Person__c> salesPersons = [SELECT Id, ExtIDSalesPerson__c, User__c, User__r.OD_Employee_ID__c
                                              from sales_person__c
                                              where ExtIDSalesPerson__c in :repIds
                                              and User__r.OD_Employee_ID__c in :empIds];
        
        for(Account acct : accounts){
            boolean accountMatched = false;
            Account_Service_Data__c sa = msgs.get(acct.id);
            String empId;
            String repId;
            if(sa != null && sa.EMP_ID__C != null && !sa.EMP_ID__C.equals('')){
                empId = sa.EMP_ID__c;
            }
            if(sa != null && sa.REP__c != null && !sa.REP__c.equals('')){
                repId = sa.REP__c;
            }
            
            
            Database.UpsertResult ur = urs.get(acct.id);
            for(Sales_Person__c sp : salesPersons){
                if(!accountMatched &&
                   sp.ExtIDSalesPerson__c != null &&
                   sp.user__r != null &&
                   sp.user__r.OD_Employee_ID__c != null &&
                   sp.ExtIDSalesPerson__c.equals(repId) &&
                   sp.user__r.OD_Employee_ID__c.equals(empId)){
                       accountMatched = true;
                       
                       if(ur !=null){
                           if(ur.isCreated()){
                               acct.ownerId = sp.User__c;
                               acct.Sales_PersonID__c = sp.id;
                           }
                       }
                       acctsToUpdate.add(acct);
                   }
            }
            if(ur !=null){
                if(!accountMatched && ur.isCreated()){
                    //Sales_Person__c DefaultSalesPerson = ([select Id, User__r.id from Sales_Person__c where ExtIDSalesPerson__c = :Label.DEFAULT_LEGACY_SALES_REP and User__r.IsActive = true Limit 1]);  
                    //acct.ownerId = DefaultSalesPerson.User__r.id;
                   acct.ownerId = Label.Dataloader_Id_Trigger;

                    acctsToUpdate.add(acct);
                }
            }
        }
        
        if(acctsToUpdate.size() > 0)
            //update acctsToUpdate;
            //Change to avoid bulk update failures
            database.update(acctsToUpdate,false);
    }
    
    //if a match on emp id and rep id is found then update the sales rep of the customer
    //and if the account was a create assign the owner
    global static void updateSiteAssociations(List<Account> accounts, Map<Id,Account_Service_Data__c> msgs, Map<Id,Database.UpsertResult> urs){
        List<String> empIds = new List<String>();
        List<String> repIds = new List<String>();
        List<Account> acctsToUpdate = new List<Account>();
        
        for(Account acct : accounts){
            Account_Service_Data__c si = msgs.get(acct.id);
            if(si != null && si.EMP_ID__c != null && !si.EMP_ID__c.equals(''))
                empIds.add(si.EMP_ID__c);
            
            if(si != null && si.REP__c != null && !si.REP__c.equals(''))
                repIds.add(si.REP__c);
        }
        
        List<Sales_Person__c> salesPersons = [SELECT Id, ExtIDSalesPerson__c, User__c, User__r.OD_Employee_ID__c
                                              from sales_person__c
                                              where ExtIDSalesPerson__c in :repIds
                                              and User__r.OD_Employee_ID__c in :empIds];
        
        for(Account acct : accounts){
            boolean accountMatched = false;
            Account_Service_Data__c si = msgs.get(acct.id);
            String empId;
            String repId;
            if(si != null && si.EMP_ID__c != null && !si.EMP_ID__c.equals(''))
                empId = si.EMP_ID__c;
            
            if(si != null && si.REP__c != null && !si.REP__c.equals(''))
                repId = si.REP__c;
            Database.UpsertResult ur = urs.get(acct.id);
            for(Sales_Person__c sp : salesPersons){
                if(!accountMatched &&
                   sp.ExtIDSalesPerson__c != null &&
                   sp.user__r != null &&
                   sp.user__r.OD_Employee_ID__c != null &&
                   sp.ExtIDSalesPerson__c.equals(repId) &&
                   sp.user__r.OD_Employee_ID__c.equals(empId)){
                       accountMatched = true;
                       
                       if(ur !=null){
                           if(ur.isCreated()){
                               acct.ownerId = sp.User__c;
                               acct.Sales_PersonID__c = sp.id;
                           }
                       }
                       acctsToUpdate.add(acct);
                   }
            }
            if(ur !=null){  
                if(!accountMatched && ur.isCreated()){
                   // Sales_Person__c DefaultSalesPerson = ([select Id, User__r.id from Sales_Person__c where ExtIDSalesPerson__c = :Label.DEFAULT_LEGACY_SALES_REP and User__r.IsActive = true Limit 1]);    
                    //acct.ownerId = DefaultSalesPerson.User__r.Id;
                    acct.ownerId = Label.Dataloader_Id_Trigger;
                    acctsToUpdate.add(acct);
                }
            }
        }
        
        if(acctsToUpdate.size() > 0)
            //Change to avoid bulk update failures
            //update acctsToUpdate;
            database.update(acctsToUpdate,false);
    }
    
    //associate an account with a parent account if it was passed in
    global static void updateParentAssociations(List<Account> accounts, Map<Id,Account_Service_Data__c> msgs){
        List<String> aopsParentIds = new List<String>();
        Map<String,Account> custAcctMap = new Map<String,Account>();
        List<Account> parentAccts = new List<Account>();
        List<Account> acctsToUpdate = new List<Account>();
        List<Id> currentaccountIdList= new List<Id>();
        Set<Id> grandParentList= new Set<Id>();

        
            Id GrandParent= Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
            System.debug('&&&&&&&&GrandParent'+GrandParent);

        //create list of aops parent ids
        //create map<aopsParent,account> of accounts to possibly update
        for(Account acct : accounts){
        currentaccountIdList.add(acct.Id);
            Account_Service_Data__c sa = msgs.get(acct.id);
            if(sa != null && sa.PARENT_CUSTOMER_ID__c != null ){
                aopsParentIds.add(sa.PARENT_CUSTOMER_ID__c);
                custAcctMap.put(sa.AOPS_CUSTOMER_ID__c,acct);
            }
        }
        
        //query on list of parent ids
        //if(aopsParentIds.size() > 0)
            parentAccts = [select id, AOPS_Cust_Id__c,Parent.recordtypeId,ParentId from account where AOPS_Cust_Id__c in :aopsParentIds
              or Id in :currentaccountIdList];
            
        System.debug('&&&&&&&&parentAccts '+parentAccts);

            //Newly added Logic
            
            Map<String ,Id> parentMap  = new  Map<String ,Id>();
            for( Account rec :parentAccts ) {
            if(aopsParentIds.contains(rec.AOPS_Cust_Id__c)){
              if(!(parentMap.containskey(rec.AOPS_Cust_Id__c)))
               parentMap.put(rec.AOPS_Cust_Id__c ,rec.Id);
            }
            if(currentaccountIdList.contains(rec.Id)  &&  rec.ParentId !=null){

                 if(rec.Parent.RecordtypeId == GrandParent)
                 grandParentList.add(rec.Id);
            }
            
            }
                     System.debug('&&&&&&&&grandParentList'+grandParentList);
   
            
           for(Account acct : accounts){
            Account_Service_Data__c sa = msgs.get(acct.id); 
             Account acctToUpdate = new Account();
             acctToUpdate = custAcctMap.get(acct.AOPS_Cust_Id__c);
                if(sa != null && sa.PARENT_CUSTOMER_ID__c != null){
                                  if(parentMap .get(sa.PARENT_CUSTOMER_ID__c) !=null)
                                   acctToUpdate.ParentId = parentMap .get(sa.PARENT_CUSTOMER_ID__c);
                                  //commented to fix issues with GP removal
                                  //else
                                  //acctToUpdate.ParentId=null;

                
                 }
                 else{
                 acctToUpdate = acct; 
                 System.debug('&&&&&&&&acct.Id'+acct.Id);

                 //commented to fix issues with GP removal
                 if( ! grandParentList.contains(acct.Id))
                 acctToUpdate.ParentId=null;
                 }
                 acctsToUpdate.add(acctToUpdate);

            }
           
        /////Replacing below logic
        //loop over list of accounts with parent ids getting the account with matching aops id from the map
        /*if(parentAccts.size() > 0){
            for(Account acct: parentAccts){
                Account acctToUpdate = custAcctMap.get(acct.AOPS_Cust_Id__c);
                acctToUpdate.ParentId = acct.id;
                acctsToUpdate.add(acctToUpdate);
            }
        }*/
        
        if(acctsToUpdate.size() > 0)
            database.update(acctsToUpdate,false);
    }
}