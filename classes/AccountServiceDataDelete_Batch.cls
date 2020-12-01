/*** File Name   : AccountServiceDataDelete_Batch
*    Description : To Delete Batch processed(Success) records from the Account service Data object.
*    Copyright   : Office Depot 
*    @author     : Nagalingeswara Reddy
*    Created Date: 03/02/2018
*    Modification Log
*    ============================================================ 
*
***/ 
global class AccountServiceDataDelete_Batch implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
    global Database.QueryLocator start(Database.BatchableContext bc){ 
        String query = 'SELECT Id FROM Account_Service_Data__c where Batch_Processed__c = true and STATUS__c  =\'SUCCESS\'';
            return  Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        try{
            
            Database.DeleteResult[] deleteResultList = Database.delete(scope,false);
            List<Id>  deleteRecIds = new List<Id>();
            for(Database.DeleteResult rec : deleteResultList){
                if (rec.isSuccess()) 
                    deleteRecIds.add(rec.getId());
   			}
            //delete Reords from RecycleBin (Hard Delete)
            Database.emptyRecycleBin(deleteRecIds);
           }
        catch(Exception e){
            System.debug('AccountServiceData_Batch Error/Stack/Line Number Stack----->'+e.getMessage()+','+e.getStackTraceString()+','+e.getLineNumber());
        }
        
    }
    global void finish(Database.BatchableContext info){
    }
    global void execute(SchedulableContext sc){
        Database.executeBatch(new AccountServiceDataDelete_Batch());
    }
}