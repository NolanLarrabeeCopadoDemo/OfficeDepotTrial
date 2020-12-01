@isTest
Public class GT_UpdateCanadaFields_TC {
static testMethod void GT_UpdateCanadaFields_TC(){
 
 Exchange_Rate__c ER=new Exchange_Rate__c();
 ER.Rate__c='50';
 insert ER;
  ER.Rate__c='60';
  update ER;
 }
 }