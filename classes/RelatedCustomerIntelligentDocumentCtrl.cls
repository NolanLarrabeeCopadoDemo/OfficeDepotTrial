/**
* @author Sandesh Ganjare, sandesh.ganjare@officedepot.com
* @date 06/09/2020
*
* 
* @description This class fetch all the records of Customer Intelligent Document object related to Accounts in hierarchy.
*              This class used for 'RelatedCustomerIntelligentDocument' LWC component.
*               Test class => RelatedCIDCtrl_Test
* JIRA: NAIT-137444: 02944812 - Ability to Input/Maintain Fact Sheet Fields in SFDC
*/

public class RelatedCustomerIntelligentDocumentCtrl {
    @AuraEnabled(cacheable=true)
    public static List<Fact_Sheet__c> getRelatedCID(String recId){
        system.debug('==>'+recId);
        List<Fact_Sheet__c> customerIntelligentDocumentList = new List<Fact_Sheet__c>();
        Set<Id> accountIdSet = new Set<Id>();
        List<Account> accountList = [SELECT id,Parentid,Parent.Parentid,Parent.Parent.Parentid FROM Account WHERE id=:recId LIMIT 1];
        if(!accountList.isEmpty()){
            if(accountList[0].id != null){
                accountIdSet.add(accountList[0].id);
            }
            if(accountList[0].Parentid != null){
                accountIdSet.add(accountList[0].Parentid);
            }
            if(accountList[0].Parent.Parentid != null){
                accountIdSet.add(accountList[0].Parent.Parentid);
            }
            if(accountList[0].Parent.Parent.Parentid != null){
                accountIdSet.add(accountList[0].Parent.Parent.Parentid);    
            }
            system.debug('accountIdSet==>'+accountIdSet);
        }
        customerIntelligentDocumentList = [SELECT Id,Name, Name__c,Account_Type__c,Additional_Account_Handling_Comments__c,Can_Customer_Care_Maintain_Account__c,
                                                Can_Restrictions_Be_Overridden_Without_A__c,Custmustclearcreditpriortorebill__c,EDI_Customer_Email__c,
                                                EDI_Customer_Name__c,EDI_Customer_Phone__c,EDI_Exceptions_Email__c,
                                                EDI_Exceptions_Name__c,EDI_Exceptions_Phone__c,Forms_of_Order_Entry__c,
                                                Inherit_Hierarchy__c,MISC__c,Ordering_Platform__c,Price_Match__c,Price_Variance__c,
                                                Proprietary_Flag__c,Special_Instructions__c,What_Can_Be_Done_To_Maintain_Account__c,LastModifiedDate FROM Fact_Sheet__c WHERE Account__c IN :accountIdSet];
        system.debug('customerIntelligentDocumentList==>'+customerIntelligentDocumentList);
        return customerIntelligentDocumentList;
    }
}