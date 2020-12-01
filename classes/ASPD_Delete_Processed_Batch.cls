/**@@
    #CLASS NAME  :  ASPD_Delete_Processed_Batch 
    #DESCRIPTION :  Batch class to delete processed records from Account_Service_Proc_Data__c object and dump them into new object called Account_Service_Processed_Data__c.
    #CREATEDDATE :  10-16-2019 (MM-DD-YYYY) 
@@**/
global class ASPD_Delete_Processed_Batch implements Database.Batchable<sObject>,Database.Stateful{
    
    public final List<Account_Service_Proc_Data__c> aspdToDelete = New List<Account_Service_Proc_Data__c>();
    
    global Database.QueryLocator start(Database.BatchableContext bc){ 
        
        String query = 'SELECT Id, ACCCOUNT_PROSPECT_ID__c, ACCOUNT_NAME__c, Account_Type__c, ADDRESS_LINE1__c, ADDRESS_LINE2__c,AOPS_ADDR_SEQ_NUM__c,AOPS_CUSTOMER_ID__c,AOPSMSTROPCODE__c,AOPSMSTRROWID__c,AOPSMSTRSOURCE__c,AOPSMSTRTBLNM__c,AOPSMSTRTIMEST__c,AOPSTBLID__c,Batch_Processed__c,BUSINESS_NAME__c,CITY__c,CONTRACT_RETAIL_CUST_CODE__c,COUNTRY__c,COUNTY__c,CREATE_UPDATE_FLAG__c,CUSTOMER_DELETE_FLAG__c,CUSTOMER_TYPE__c,DEFAULT_FLAG__c,EMP_ID__c,ERROR_Message__c,FREIGHT_CHARGE_REQUIRED__c,HOSTED_CATALOG_FLAG__c,Legal_Flag__c,LOCATION_KEY__c,ORACLE_ADDR_SEQ_NUM__c,ORACLE_CUSTOMER_ID__c,ORDER_MAX_AMOUNT__c,PARENT_CUSTOMER_ID__c,REP__c,REP_EMP_ID__c,RSV1_CHAR2__c,RSV2_CHAR2__c,SECTOR__c,SEGMENTATION__c,SFDC_ADDR_SEQ_NUM__c,SFDC_CUSTOMER_ID__c,SITE_REP__c,SPC_Indicator__c,STATE__c,STATUS__c,Unique_ID__c,VERSION__c,ZIP_CODE__c FROM Account_Service_Proc_Data__c where Batch_Processed__c = true and STATUS__c  =\'SUCCESS\'';
            return  Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        try{
            //Clone the processed records from Account_Service_Proc_Data__c to Account_Service_Processed_Data__c
            List<Account_Service_Proc_Data__c> accServiceDataProcList = (List<Account_Service_Proc_Data__c>)scope;
            List<Account_Service_Processed_Data__c> accServiceDataProcessedList = new List<Account_Service_Processed_Data__c>();
            
            aspdToDelete.addAll((List<Account_Service_Proc_Data__c>)scope);
            
            for(Account_Service_Proc_Data__c asd: accServiceDataProcList){
                Account_Service_Processed_Data__c aspd = new Account_Service_Processed_Data__c();
                aspd.ACCCOUNT_PROSPECT_ID__c = asd.ACCCOUNT_PROSPECT_ID__c;
                aspd.ACCOUNT_NAME__c = asd.ACCOUNT_NAME__c;
                aspd.Account_Type__c = asd.Account_Type__c;
                aspd.ADDRESS_LINE1__c = asd.ADDRESS_LINE1__c;
                aspd.ADDRESS_LINE2__c = asd.ADDRESS_LINE2__c;
                aspd.AOPS_ADDR_SEQ_NUM__c = asd.AOPS_ADDR_SEQ_NUM__c;
                aspd.AOPS_CUSTOMER_ID__C = asd.AOPS_CUSTOMER_ID__C;
                aspd.AOPSMSTROPCODE__c = asd.AOPSMSTROPCODE__c;
                aspd.AOPSMSTRROWID__c = asd.AOPSMSTRROWID__c;
                aspd.AOPSMSTRSOURCE__c = asd.AOPSMSTRSOURCE__c;
                aspd.AOPSMSTRTBLNM__c = asd.AOPSMSTRTBLNM__c;
                aspd.AOPSMSTRTIMEST__c = asd.AOPSMSTRTIMEST__c;
                aspd.AOPSTBLID__c = asd.AOPSTBLID__c;
                aspd.Batch_Processed__c = asd.Batch_Processed__c;
                aspd.BUSINESS_NAME__c = asd.BUSINESS_NAME__c;
                aspd.CITY__c = asd.CITY__c;
                aspd.CONTRACT_RETAIL_CUST_CODE__c = asd.CONTRACT_RETAIL_CUST_CODE__c;
                aspd.COUNTRY__c = asd.COUNTRY__c;
                aspd.COUNTY__c = asd.COUNTY__c;
                aspd.CREATE_UPDATE_FLAG__c = asd.CREATE_UPDATE_FLAG__c;
                aspd.CUSTOMER_DELETE_FLAG__c = asd.CUSTOMER_DELETE_FLAG__c;
                aspd.CUSTOMER_TYPE__c = asd.CUSTOMER_TYPE__c;
                aspd.SPC_Indicator__c = asd.SPC_Indicator__c;
                aspd.CREATE_UPDATE_FLAG__C = asd.CREATE_UPDATE_FLAG__C;
                aspd.CUSTOMER_TYPE__C = asd.CUSTOMER_TYPE__C;
                aspd.CUSTOMER_DELETE_FLAG__C = asd.CUSTOMER_DELETE_FLAG__C;
                aspd.DEFAULT_FLAG__c = asd.DEFAULT_FLAG__c;
                aspd.EMP_ID__C = asd.EMP_ID__C;
                aspd.ERROR_Message__c = asd.ERROR_Message__c;
                aspd.FREIGHT_CHARGE_REQUIRED__C = asd.FREIGHT_CHARGE_REQUIRED__C;
                aspd.HOSTED_CATALOG_FLAG__c = asd.HOSTED_CATALOG_FLAG__c;
                aspd.Legal_Flag__C = asd.Legal_Flag__C;
                aspd.LOCATION_KEY__c = asd.LOCATION_KEY__c;
                aspd.ORACLE_ADDR_SEQ_NUM__c = asd.ORACLE_ADDR_SEQ_NUM__c;
                aspd.ORACLE_CUSTOMER_ID__C = asd.ORACLE_CUSTOMER_ID__C;
                aspd.ORDER_MAX_AMOUNT__C = asd.ORDER_MAX_AMOUNT__C;
                aspd.PARENT_CUSTOMER_ID__C = asd.PARENT_CUSTOMER_ID__C;
                aspd.REP__C = asd.REP__C;
                aspd.REP_EMP_ID__c = asd.REP_EMP_ID__c;
                aspd.RSV1_CHAR2__C = asd.RSV1_CHAR2__C;
                aspd.RSV2_CHAR2__c = asd.RSV2_CHAR2__c;
                aspd.SEGMENTATION__C = asd.SEGMENTATION__C;
                aspd.SECTOR__C =  asd.SECTOR__C;
                aspd.SFDC_ADDR_SEQ_NUM__c = asd.SFDC_ADDR_SEQ_NUM__c;
                aspd.SFDC_CUSTOMER_ID__C = asd.SFDC_CUSTOMER_ID__C;
                aspd.SITE_REP__c = asd.SITE_REP__c;
                aspd.SPC_Indicator__c = asd.SPC_Indicator__c;
                aspd.STATE__c = asd.STATE__c;
                aspd.STATUS__c = asd.STATUS__c;
                aspd.VERSION__C = asd.VERSION__C;
                aspd.ZIP_CODE__c = asd.ZIP_CODE__c;
                    
                    accServiceDataProcessedList.add(aspd);
                
            } 
            if(!accServiceDataProcessedList.isEmpty())
            {
                insert accServiceDataProcessedList;
            }
            
            }
        catch(Exception e){
            System.debug('ASPD_Delete_Processed Error/Stack/Line Number Stack----->'+e.getMessage()+','+e.getStackTraceString()+','+e.getLineNumber());
        }
        
    }
    global void finish(Database.BatchableContext info){
        
        //Delete Processed records from Account_Service_Proc_Data__c
        try{
             if(!aspdToDelete.isEmpty()){
                 delete aspdToDelete;
             }
         }
         catch(Exception e){
           system.debug('Exception in delete is'+e);   
        }
    }
    
}