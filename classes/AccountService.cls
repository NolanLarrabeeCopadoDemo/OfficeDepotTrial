/**
Modified By: Wipro Offshore team
Modified Date: 22 August 2012

Modify Reason: As per case# 4968, we have added a line "lclAcct.Account_Setup_Request_Status__c = 'Express Setup Complete'" in
line number 357 so as to change the status message when the account is created.

Modified By: Wipro Offshore team
Modified Date: 25 Feb 2018

Modify Reason: To avoid governor limits and other issues maininig Customer and Site data into separate object called Account service Data and processing batch job
to synch and update Customer and Site information.
**/
global class AccountService {
    webservice static UpsertAccountTxnStatus UpsertAccounts(SalesCustomerAccountCreation customerAccounts) {
        UpsertAccountTxnStatus resp = new UpsertAccountTxnStatus();
        Map<Id,ServiceAccount> sfdcCustMap = new Map<Id,ServiceAccount>();
        Map<Id,ServiceSite> sfdcSiteMap = new Map<Id,ServiceSite>();
        List<Account_Service_Data__c> accountServiceList= new List<Account_Service_Data__c>();
        
        //update customer accounts to values passed in
        for(ServiceAccount sa : customerAccounts.customers) {
            Account_Service_Data__c rec1 = new Account_Service_Data__c(); 
            rec1.CREATE_UPDATE_FLAG__C = sa.CREATE_UPDATE_FLAG;
            rec1.VERSION__C = sa.VERSION;
            rec1.SFDC_CUSTOMER_ID__C = sa.SFDC_CUSTOMER_ID;
            rec1.ORACLE_CUSTOMER_ID__C = sa.ORACLE_CUSTOMER_ID;
            /*
            if(sa.AOPS_CUSTOMER_ID.length()==7)
            rec1.AOPS_CUSTOMER_ID__C='0'+sa.AOPS_CUSTOMER_ID;
            else if(sa.AOPS_CUSTOMER_ID.length()==6)
            rec1.AOPS_CUSTOMER_ID__C='00'+sa.AOPS_CUSTOMER_ID;
            else
            rec1.AOPS_CUSTOMER_ID__C=sa.AOPS_CUSTOMER_ID;
           */
            if (sa.AOPS_CUSTOMER_ID != null  && sa.AOPS_CUSTOMER_ID.length() < 8) {
                rec1.AOPS_CUSTOMER_ID__C = sa.AOPS_CUSTOMER_ID.leftPad(8,'0');
            } else {
                rec1.AOPS_CUSTOMER_ID__C = sa.AOPS_CUSTOMER_ID;
            }
            rec1.CONTRACT_RETAIL_CUST_CODE__C=sa.CONTRACT_RETAIL_CUST_CODE;
            rec1.BUSINESS_NAME__C=sa.BUSINESS_NAME;
            rec1.CUSTOMER_DELETE_FLAG__C=sa.CUSTOMER_DELETE_FLAG;
            rec1.CUSTOMER_TYPE__C=sa.CUSTOMER_TYPE;
            rec1.RSV1_CHAR2__C=sa.RSV1_CHAR2;
            rec1.RSV2_CHAR2__c=sa.RSV2_CHAR2;
            // rec1.PARENT_CUSTOMER_ID__C=sa.PARENT_CUSTOMER_ID;
            if (sa.PARENT_CUSTOMER_ID != null  && sa.PARENT_CUSTOMER_ID.length() < 8) {
                rec1.PARENT_CUSTOMER_ID__C = sa.PARENT_CUSTOMER_ID.leftPad(8,'0');
            } else {
                rec1.PARENT_CUSTOMER_ID__C = sa.PARENT_CUSTOMER_ID;
            }
            rec1.FREIGHT_CHARGE_REQUIRED__C=sa.FREIGHT_CHARGE_REQUIRED;
            rec1.ACCCOUNT_PROSPECT_ID__C=sa.ACCCOUNT_PROSPECT_ID;
            rec1.SEGMENTATION__C=sa.SEGMENTATION;
            rec1.SECTOR__C=sa.SECTOR;
            rec1.ORDER_MAX_AMOUNT__C=sa.ORDER_MAX_AMOUNT;
            rec1.REP__C=sa.REP;
            rec1.EMP_ID__C=sa.EMP_ID;
            rec1.HOSTED_CATALOG_FLAG__c=sa.HOSTED_CATALOG_FLAG;
            rec1.Legal_Flag__C=sa.Legal_Flag;
            rec1.Account_Type__c='Customer';   
            rec1.spc_indicator__c=sa.spc_indicator;//NAIT-11785
            // TIMESTAMP Variables
            rec1.AOPSMSTRROWID__c = sa.AOPSMSTRROWID;
            rec1.AOPSMSTRTIMEST__c = sa.AOPSMSTRTIMEST;
            rec1.AOPSMSTRSOURCE__c = sa.AOPSMSTRSOURCE;
            rec1.AOPSMSTROPCODE__c = sa.AOPSMSTROPCODE;
            rec1.AOPSMSTRTBLNM__c = sa.AOPSMSTRTBLNM;
            rec1.AOPSTBLID__c = sa.AOPSTBLID;
            
            system.debug('MYTEST DEBUG 1 ----' + rec1.AOPSMSTRTIMEST__c);
            accountServiceList.add(rec1);
            
            if(sa.sites != null && sa.sites.size() > 0) {
                for(ServiceSite si : sa.sites) {
                    Account_Service_Data__c rec = new Account_Service_Data__c(); 
                    rec.CREATE_UPDATE_FLAG__C = sa.CREATE_UPDATE_FLAG;
                    rec.VERSION__C = sa.VERSION;
                    rec.SFDC_CUSTOMER_ID__C = sa.SFDC_CUSTOMER_ID;
                    //Uncomment back
                    /* if(sa.AOPS_CUSTOMER_ID.length()==7)
                    rec.AOPS_CUSTOMER_ID__C='0'+sa.AOPS_CUSTOMER_ID;
                    else if(sa.AOPS_CUSTOMER_ID.length()==6)
                    rec.AOPS_CUSTOMER_ID__C='00'+sa.AOPS_CUSTOMER_ID;
                    else
                    rec.AOPS_CUSTOMER_ID__C=sa.AOPS_CUSTOMER_ID;*/
                    if (sa.AOPS_CUSTOMER_ID != null  && sa.AOPS_CUSTOMER_ID.length() < 8) {
                        rec.AOPS_CUSTOMER_ID__C = sa.AOPS_CUSTOMER_ID.leftPad(8,'0');
                    } else {
                        rec.AOPS_CUSTOMER_ID__C = sa.AOPS_CUSTOMER_ID;
                    }
                    rec.spc_indicator__c=sa.spc_indicator;//NAIT-11785
                    rec.ORACLE_CUSTOMER_ID__C=sa.ORACLE_CUSTOMER_ID;
                    rec.CONTRACT_RETAIL_CUST_CODE__C=sa.CONTRACT_RETAIL_CUST_CODE;
                    rec.BUSINESS_NAME__C=sa.BUSINESS_NAME;
                    rec.CUSTOMER_DELETE_FLAG__C=sa.CUSTOMER_DELETE_FLAG;
                    rec.CUSTOMER_TYPE__C=sa.CUSTOMER_TYPE;
                    rec.RSV1_CHAR2__C=sa.RSV1_CHAR2;
                    rec.RSV2_CHAR2__c=sa.RSV2_CHAR2;
                    //rec.PARENT_CUSTOMER_ID__C=sa.PARENT_CUSTOMER_ID;
                    if (sa.PARENT_CUSTOMER_ID!=null  && sa.PARENT_CUSTOMER_ID.length() < 8) {
                        rec.PARENT_CUSTOMER_ID__C = sa.PARENT_CUSTOMER_ID.leftPad(8,'0');
                    } else {
                        rec.PARENT_CUSTOMER_ID__C = sa.PARENT_CUSTOMER_ID;
                    }
                    rec.FREIGHT_CHARGE_REQUIRED__C=sa.FREIGHT_CHARGE_REQUIRED;
                    rec.ACCCOUNT_PROSPECT_ID__C=sa.ACCCOUNT_PROSPECT_ID;
                    rec.SEGMENTATION__C=sa.SEGMENTATION;
                    rec.SECTOR__C=sa.SECTOR;
                    rec.ORDER_MAX_AMOUNT__C=sa.ORDER_MAX_AMOUNT;
                    rec.REP__C=sa.REP;
                    rec.EMP_ID__C=sa.EMP_ID;
                    rec.HOSTED_CATALOG_FLAG__c=sa.HOSTED_CATALOG_FLAG;
                    rec.Legal_Flag__C=sa.Legal_Flag;
                    rec.Account_Type__c='Site';
                    // TIMESTAMP Variables
                    
                    rec.AOPSMSTRROWID__c = sa.AOPSMSTRROWID;
                    rec.AOPSMSTRTIMEST__c = sa.AOPSMSTRTIMEST;
                    rec.AOPSMSTRSOURCE__c = sa.AOPSMSTRSOURCE;
                    rec.AOPSMSTROPCODE__c = sa.AOPSMSTROPCODE;
                    rec.AOPSMSTRTBLNM__c = sa.AOPSMSTRTBLNM;
                    rec.AOPSTBLID__c = sa.AOPSTBLID;
                    
                    // Data of sites
                    rec.ORACLE_ADDR_SEQ_NUM__C=si.ORACLE_ADDR_SEQ_NUM;
                    rec.SFDC_ADDR_SEQ_NUM__C=si.SFDC_ADDR_SEQ_NUM;
                   //Uncomment back
                    /*if(sa.AOPS_CUSTOMER_ID.length()==7)
                    rec.AOPS_ADDR_SEQ_NUM__C='0'+si.AOPS_ADDR_SEQ_NUM;
                    else if(sa.AOPS_CUSTOMER_ID.length()==6)
                    rec.AOPS_ADDR_SEQ_NUM__C='00'+si.AOPS_ADDR_SEQ_NUM;
                    else
                    rec.AOPS_ADDR_SEQ_NUM__C=si.AOPS_ADDR_SEQ_NUM;*/
                    if (sa.AOPS_CUSTOMER_ID!=null  && sa.AOPS_CUSTOMER_ID.length() < 8) {
                        rec.AOPS_ADDR_SEQ_NUM__C = si.AOPS_ADDR_SEQ_NUM.substringBefore('-').leftPad(8,'0')+'-'+si.AOPS_ADDR_SEQ_NUM.substringAfter('-');
                    } else {
                        rec.AOPS_ADDR_SEQ_NUM__C=si.AOPS_ADDR_SEQ_NUM; 
                    }
                    rec.LOCATION_KEY__C=si.LOCATION_KEY;
                    rec.ACCOUNT_NAME__C=si.ACCOUNT_NAME;
                    rec.ADDRESS_LINE1__C=si.ADDRESS_LINE1;
                    rec.ADDRESS_LINE2__C=si.ADDRESS_LINE2;
                    rec.CITY__C =si.CITY;
                    rec.STATE__C=si.STATE;
                    rec.ZIP_CODE__C=si.ZIP_CODE;
                    rec.COUNTRY__C=si.COUNTRY;
                    rec.COUNTY__c=si.COUNTY;
                    rec.SITE_REP__C=si.REP;
                    rec.REP_EMP_ID__C=si.EMP_ID;
                    rec.DEFAULT_FLAG__C=si.DEFAULT_FLAG;
                    accountServiceList.add(rec);
          }
        }
      }
           
   
        //Create a savepoint to rollback to in case of error
        Savepoint sp = Database.setSavepoint();
        List<Id> successId= new List<Id> (); 
        system.debug('MYTEST DEBUG 2 ----' );
        try {
            if(accountServiceList.size()>0) {
                List<Database.SaveResult> updateResults = Database.insert(accountServiceList, false);
                for (Integer i = 0; i < updateResults.size(); i++) {
                    if (updateResults.get(i).isSuccess()) {
                        successId.add(updateResults[i].getId());
                        system.debug('MYTEST DEBUG 3 ----' );
                    }
                    else if (!updateResults.get(i).isSuccess()) {
                        // DML operation failed
                        Database.Error error = updateResults.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        accountServiceList.get(i);//failed record from the list
                        resp.STATUS = resp.STATUS_ERROR_GENERAL;
                        resp.STATUS_MESSAGE = failedDML;
                        System.debug('#######################'+resp);
                        system.debug('MYTEST DEBUG 4 ----' );
                        return resp;        
                    }
                }
           
                List<ServiceAccountStatus> sasList = new List<ServiceAccountStatus>();
                List<Account_Service_Data__c> insertListCustomer = new List<Account_Service_Data__c>();
                List<Account_Service_Data__c> sites = new List<Account_Service_Data__c>();

                insertListCustomer = [select Account_Type__c, AOPS_CUSTOMER_ID__c, AOPS_ADDR_SEQ_NUM__c from Account_Service_Data__c 
                    where Id in : successId and Account_Type__c='Customer']; 
                sites = [select Account_Type__c, AOPS_CUSTOMER_ID__c, AOPS_ADDR_SEQ_NUM__c from Account_Service_Data__c 
                    where Id in : successId and Account_Type__c='Site']; 
           
                for (integer i=0;i< insertListCustomer.size();i++) {
                    ServiceAccountStatus sas = new ServiceAccountStatus();
                    sas.STATUS = sas.STATUS_SUCCESS;
                    sas.STATUS_MESSAGE = sas.MESSAGE_SUCCESS;
                    sas.SOURCE_ID = insertListCustomer[i].AOPS_CUSTOMER_ID__c;
                    system.debug('MYTEST DEBUG 5 ----' );
                    if (sites.size() > 0) {
                        List<ServiceSiteStatus> sssList = new List<ServiceSiteStatus>();
                        for (Account_Service_Data__c lclSite : sites) {
                            if (lclSite.AOPS_CUSTOMER_ID__c == insertListCustomer[i].AOPS_CUSTOMER_ID__c) {
                                ServiceSiteStatus sss = new ServiceSiteStatus();
                                sss.STATUS = sss.STATUS_SUCCESS;
                                sss.STATUS_MESSAGE = sss.MESSAGE_SUCCESS;
                                sss.SOURCE_ID = lclSite.AOPS_ADDR_SEQ_NUM__c;
                                sssList.add(sss);
                                system.debug('MYTEST DEBUG 6 ----' );
                            }
                        }
                        sas.SitesStatus = sssList;
                    }
                    sasList.add(sas);                                        
                }  
                return resp;
            }
            else {
                resp.STATUS = resp.STATUS_ERROR_GENERAL;
                resp.STATUS_MESSAGE = 'No Records To Insert';
                System.debug('#######################'+resp);
                system.debug('MYTEST DEBUG 7 ----' );
                return resp;        
            }
        }
        catch(Exception e) {
            Database.rollback(sp);
            resp.STATUS = resp.STATUS_ERROR_GENERAL;
            resp.STATUS_MESSAGE = resp.MESSAGE_ERROR_GENERAL + e.getMessage() + e.getLineNumber();
            System.debug('#######################'+resp);
            system.debug('MYTEST DEBUG 8 ----' );
            return resp;        
        }
    }
  
  
  
    // Added method to insert row in AOPS Cross Reference Table, Story S-343934 by Rahul Chitkara

    webservice static String createCrossReferenceRecord(String source,String omxKey,Date createDate, String aops, String operation, Datetime timestamp){
    String result='';
      try{
          //Trim OMXKey and create unique key
          string omxKeyTrim = omxkey.substring(0,7);
          string uniqueKey = aops + omxKeyTrim;
          List <OfficeMax_OfficeDepot_CrossReference__c> crossCheck = [select id from  OfficeMax_OfficeDepot_CrossReference__c where Unique_Key__c = :uniqueKey limit 1];
          
          if (crossCheck.isEmpty()){
            operation = 'c';
          }
          
          // S-371579 - Hitesh Pareek [Dec 21, 2015]--------START
            Customer_Transition__c customerTransition;
            if(omxKey != null && omxKey != ''){
                string omxKeyT = omxKeyTrim.trim();
                for(Customer_Transition__c ct :[select id, OMX_Primary_Key__c from Customer_Transition__c where OMX_Primary_Key__c =:omxKeyT limit 1]){
                    customerTransition = ct;
                }
            }
          // S-371579 - Hitesh Pareek [Dec 21, 2015]--------END
      
          //For operation = c (Create), check for existing record and throw error if one exists
          if (operation == 'c'){

            if (!crossCheck.isEmpty()){
              result = 'Record Already Exists';
               return result;

            }
            else {
              //Create Cross Ref Record
               OfficeMax_OfficeDepot_CrossReference__c crossReferenceObj = new OfficeMax_OfficeDepot_CrossReference__c();
               crossReferenceObj.Source__c = source;
               crossReferenceObj.OMX_Key__c = omxKeyTrim;
               crossReferenceObj.Created_Date__c = createDate;
               crossReferenceObj.AOPS_Number__c = aops;
               crossReferenceObj.Unique_Key__c = uniquekey;
               
               // S-371579 - Hitesh Pareek [Dec 21, 2015]--------START
                if(customerTransition != null)
                    crossReferenceObj.Customer_Transition__c =  customerTransition.id;                                        
               // S-371579 - Hitesh Pareek [Dec 21, 2015]--------END

              //Insert
               insert crossReferenceObj;
              result = 'Record Inserted';
               return result;

            }

          }

          else  {

              //If true update, update source
              crossCheck[0].Source__c = source;
              update crossCheck[0];

             result = 'Record Updated';
             return result;

          }




      }

    catch(Exception e){
      result = e.getMessage();
      return result;
    }
  }

  
  
  
  
  
  

    webservice static boolean updateAcctSetupReqStatus(String accountId, String status) {
        System.debug('&&&&&&&&&&& inside updateAcctSetupReqStatus');
        Account acct = [select id from account where id =:accountId];
        if(acct == null) {
            return false;
        }
        else{
            if(status.equals('S')) {
                //'S' indicates status of Success
                acct.Account_Setup_Request_Status__c = 'Pending Express Setup';
            }
            else { //'E' status has been returned indicating error
                acct.Account_Setup_Request_Status__c = 'Failed Account Setup';
            }
            update(acct);
        }
        return true;
  }



  global class SalesCustomerAccountCreation {
    webservice List<ServiceAccount> customers;
  }

  global class UpsertAccountTxnStatus {
    webservice String STATUS;
    webservice String STATUS_MESSAGE;
    webservice List<ServiceAccountStatus> REC_STATUS;
    final String STATUS_SUCCESS = '0';
    final String STATUS_ERROR_ACCOUNT = '1';
    final String STATUS_ERROR_SITE = '2';
    final String STATUS_ERROR_ACCOUNT_SITE = '3';
    final String STATUS_ERROR_GENERAL = '4';
    final String MESSAGE_SUCCESS = 'Success';
    final String MESSAGE_ERROR_ACCOUNT = 'Error in account processing';
    final String MESSAGE_ERROR_SITE = 'Error in site processing';
    final String MESSAGE_ERROR_ACCOUNT_SITE = 'Error in account and site processing';
    final String MESSAGE_ERROR_GENERAL = 'Error in processing: ';
  }

  global class ServiceAccountStatus {
    webservice String STATUS;
    webservice String STATUS_MESSAGE;
    webservice String SFCD_ID;
    webservice String SOURCE_ID;
    webservice List<ServiceSiteStatus> SitesStatus;
    final String STATUS_SUCCESS = '0';
    final String STATUS_ERROR_ACCOUNT = '1';
    final String STATUS_ERROR_ACCOUNT_MISSING = '2';
    final String MESSAGE_SUCCESS = 'Success';
    final String MESSAGE_ERROR_ACCOUNT = 'Error in processing';
    final String MESSAGE_ERROR_ACCOUNT_MISSING = 'Account missing';
  }

  global class ServiceSiteStatus {
    webservice String STATUS;
    webservice String STATUS_MESSAGE;
    webservice String SFCD_ID;
    webservice String SOURCE_ID;
    final String STATUS_SUCCESS = '0';
    final String STATUS_ERROR_SITE = '1';
    final String MESSAGE_SUCCESS = 'Success';
    final String MESSAGE_ERROR_SITE = 'Error in processing';
  }

  global class ServiceAccount {
    webservice String CREATE_UPDATE_FLAG; //
    webservice String VERSION;
    webservice String SFDC_CUSTOMER_ID; //
    webservice String ORACLE_CUSTOMER_ID; //
    webservice String AOPS_CUSTOMER_ID; //
    webservice String CONTRACT_RETAIL_CUST_CODE; //
    webservice String BUSINESS_NAME; //
    webservice String CUSTOMER_DELETE_FLAG; //
    webservice String CUSTOMER_TYPE; //
    webservice String RSV1_CHAR2; //
    webservice String RSV2_CHAR2; //
    webservice String PARENT_CUSTOMER_ID; //
    webservice String FREIGHT_CHARGE_REQUIRED; //
    webservice String ACCCOUNT_PROSPECT_ID;
    webservice String SEGMENTATION; //
    webservice String SECTOR; //
    webservice String ORDER_MAX_AMOUNT; //
    webservice String REP; //
    webservice String EMP_ID; //
    //S-343745 [Joe/Hemant 8/18/2015] - Added Hosted Catalog Flag
    webservice String HOSTED_CATALOG_FLAG; //
    webservice String spc_indicator;//NAIT-11785
    webservice String Legal_Flag; //
    webservice List<ServiceSite> sites;
    // TIMESTAMP Variables
    webservice String AOPSMSTRROWID;
    webservice String AOPSMSTRTIMEST;
    webservice String AOPSMSTRSOURCE;
    webservice String AOPSMSTROPCODE;
    webservice String AOPSMSTRTBLNM;
    webservice String AOPSTBLID;
  }

  global class ServiceSite {
    webservice String ORACLE_ADDR_SEQ_NUM; //
    webservice String SFDC_ADDR_SEQ_NUM; //
    webservice String AOPS_ADDR_SEQ_NUM; //
    webservice String LOCATION_KEY; //
    webservice String ACCOUNT_NAME; //
    webservice String ADDRESS_LINE1; //
    webservice String ADDRESS_LINE2; //
    webservice String CITY; //
    webservice String STATE; //
    webservice String ZIP_CODE; //
    webservice String COUNTRY; //
    webservice String COUNTY; //
    webservice String REP; //
    webservice String EMP_ID; //
    webservice String DEFAULT_FLAG; //
  }
}