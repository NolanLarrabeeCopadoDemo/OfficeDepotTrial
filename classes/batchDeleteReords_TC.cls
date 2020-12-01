@isTest
private class batchDeleteReords_TC {
  static testmethod void test1() {
    String query = 'SELECT ID FROM Account_Profile_Staging__c';
    account_profile_staging__c aps = new account_profile_staging__c();
    aps.Expiration_Date__c= date.ValueOf('1900-01-01');
    aps.Country_Code__c='USA';
    aps.Tax_Status__c='A';
    aps.Customer_ID__c='8675309';
    insert aps;
    Test.startTest();
    batchDeleteRecords bdr = new batchDeleteRecords(query);
    Database.executeBatch(bdr);
    Test.stopTest();
    Integer i = [SELECT COUNT() FROM Account_Profile_Staging__c];
    System.assertEquals(i, 0);
  }
}