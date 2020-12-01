public with sharing class DmlDisplay {
    @AuraEnabled
    public static Id getDmlIdFromAccount(String account_id){
        try {
            DML_Relation__c my_relation = [SELECT Id, DML__c FROM DML_Relation__c WHERE IsActive__c = true AND Account__c = :account_id];
            return my_relation.DML__c;
        } catch(Exception e){
            throw new AuraHandledException('' + e);
        }
    }
}