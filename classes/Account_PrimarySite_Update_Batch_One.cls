/*** File Name   : Account_PrimarySite_Update_Batch_One
*    Description : To update Site Accouts to primary
*    Copyright   : Office Depot 
*    @author     : Naga
*    Created Date: 22/12/2017
*    Modification Log
*    ============================================================ 
*
***/ 
global class Account_PrimarySite_Update_Batch_One implements Database.Batchable<sObject>,Database.Stateful,Schedulable  {
    global Database.QueryLocator start(Database.BatchableContext bc)
    { 
        //Captures All site recordtype Accounts where primary site is false and Customer Id ends with -00001 
        String accSiteRecId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        String customerIDType = '-00001';
        String query = 'SELECT Id, Primary_Site__c FROM Account where recordtypeId =: accSiteRecId and Primary_Site__c = false and AOPS_Seq_ID__c like \'%' +customerIDType + '%\'';
        return  Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Account>  accList = (List<Account>)scope;
        for(Account acc : accList ){
            acc.Primary_Site__c = true;
        }
        
        try{
            if(!accList.isEmpty()){
                update accList;
            } 
        }catch(Exception e){
            
        }
    }
    
    global void finish(Database.BatchableContext info){
    
         CustTransParentChildLevel__c PCLevel2 = [select Primary00001ID__C,Primary00001Interval__c from 
            CustTransParentChildLevel__c limit 1];
        integer interval = 60;        
        if (PCLevel2.Primary00001ID__C<> null) {
            for (CronTrigger existingJob: [SELECT Id FROM CronTrigger where ID=:PCLevel2.Primary00001ID__C])
            system.abortJob(existingJob.id);
        }
        
        if(PCLevel2.Primary00001Interval__c != null)
            interval = (Integer)PCLevel2.Primary00001Interval__c ;
        
        DateTime sysTime = System.now().addSeconds(interval);
        String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
        Account_PrimarySite_Update_Batch_One SentDNSProcessingBatchObj = new Account_PrimarySite_Update_Batch_One();
        ID cronid = System.schedule( 'Account_PrimarySite_Update_Batch_One' + sysTime, chronExpression, SentDNSProcessingBatchObj );    
        
        PCLevel2.Primary00001ID__C= cronid;
        
        update PCLevel2;  

        
    }
    global void execute(SchedulableContext sc){
        Integer batch_size = Integer.valueOf(Label.Set_Primary_Account_Batch_Size);
        Database.executeBatch(new Account_PrimarySite_Update_Batch_One(),batch_size);
    }
}