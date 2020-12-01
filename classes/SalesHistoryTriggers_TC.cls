@isTest
public class SalesHistoryTriggers_TC {

    static testMethod void beforeInsert() {
        Sales_History__c sh = new Sales_History__c();
        sh.OMX_Primary_Key__c = 'test';
        insert sh;
    }
}