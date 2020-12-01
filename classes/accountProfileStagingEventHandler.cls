/*
  (c) 2014 Appirio, Inc.
  General Purpose class to consolidate business logic for trigger events on Account_Profile_Staging__c
  8 Jun 2015     Ben Lorenz          Created
*/ 

public class accountProfileStagingEventHandler {
  public Account_Profile_Staging__c[] newLst = new Account_Profile_Staging__c[]{};
  public Account_Profile_Staging__c[] oldLst = new Account_Profile_Staging__c[]{};
  public Map <ID, Account_Profile_Staging__c> newMap = new Map<ID, Account_Profile_Staging__c>{};
  public Map <ID, Account_Profile_Staging__c> oldMap = new Map<ID, Account_Profile_Staging__c>{};
   
  public accountProfileStagingEventHandler(Account_Profile_Staging__c[] triggered, Account_Profile_Staging__c[] triggeredFrom,
                                           Map<ID,Account_Profile_Staging__c> triggerNewMap,Map<ID,Account_Profile_Staging__c> triggerOldMap){
    newLst = triggered;
    oldLst = triggeredFrom;
    newMap = triggerNewMap;
    oldMap = triggerOldMap;
  }
     
  public void upsertTaxStatus() {
    Map <String, ID> customerIDMap = new Map <String, ID>();
    List <Account_Profile__c> accountProfileLst = new List <Account_Profile__c>();
    ID taxCertRecType = [SELECT Id FROM recordtype where sObjectType ='Account_Profile__c' and name = 'TaxCertStatus'].Id;
    //get all customer IDs from incoming records
    for (Account_Profile_Staging__c aps : newLst) {customerIdMap.put(aps.Customer_ID__c,null);}
    //add in SFDC IDs
    for (Account a : [SELECT Id, AOPS_Cust_Id__c FROM Account WHERE AOPS_Cust_Id__c IN :customerIDMap.keyset()]) {
      customerIdMap.put(a.AOPS_Cust_Id__c,a.Id);
    }
    //create records for upsert
    for (Account_Profile_Staging__c aps : newLst) {
      Account_Profile__c ap = new Account_Profile__c();
      ap.Expiration_Date__c = aps.Expiration_Date__c;
      ap.Address_State__c = aps.Address_State__c;
      ap.Country_Code__c = aps.Country_Code__c;
      ap.Tax_Status__c = aps.Tax_Status__c;
      ap.RecordTypeId= taxCertRecType;
      ap.Account__c = customerIDMap.get(aps.Customer_ID__c);
      string stateID = aps.Address_State__c==null ? '' : aps.Address_State__c;
      ap.Profile_Unique_Name__c = taxCertRecType + '-' + ap.Account__c + stateID;
      ap.Name = 'Tax Certificate Status';
      accountProfileLst.add(ap);
    }
    if (!accountProfileLst.isEmpty()) {
      Schema.SObjectField f = Account_Profile__c.Fields.Profile_Unique_Name__c;
      Database.UpsertResult[] urLst = Database.upsert (accountProfileLst,f,FALSE);
      for(Database.UpsertResult ur : urLst) {
        for(Database.Error err : ur.getErrors()) {
          System.debug('### The following error has occurred upserting Account Profile Tax Certificate Status records ' + err.getMessage());                   
        }
      }
    }   
  }
}