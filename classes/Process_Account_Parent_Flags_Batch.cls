/* @class: Process_Account_Parent_Flags_Batch
*  @author: Sandesh Ganjare 
*  @JIRA/Case: NAIT-131763 / Case # 02900372 Inherit GPO Flag through the Account Hierarchy
*  @description: This batch job update the Current_GOP__c flag on Parent Account in hierarchy.
*  @date: 22-July-2020
*/
global class Process_Account_Parent_Flags_Batch implements Database.Batchable<Sobject> {

    private string query;

    public Process_Account_Parent_Flags_Batch() {
		Id parentRecordTypeId      = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        query = 'SELECT Id, Current_GPO__c,LastModifiedDate,Parent.Current_GPO__c,Parent.LastModifiedDate FROM Account WHERE RecordTypeId=\''+parentRecordTypeId+'\' AND Parent.LastModifiedDate >= LAST_N_DAYS:1';

    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, SObject[] scope) {
        List<Account> accountList = scope;
        System.debug('accountList =>'+accountList );
        if(accountList != null && accountList.size()>0){
            AccountHelper.populate_GPO_Flag(accountList);
        }
        
    }

    global void finish(Database.BatchableContext bc) {
        Database.executeBatch(new Process_Account_Customer_Flags_Batch(), 200);
    }
}