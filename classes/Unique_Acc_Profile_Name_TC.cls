@isTest
private class Unique_Acc_Profile_Name_TC
{
 static testMethod void UnitTest()
 {
        Schema.DescribeSObjectResult A_P_R = Schema.SObjectType.Account_Profile__c;
        Map<String,Schema.RecordTypeInfo> A_P_RMapByName = A_P_R.getRecordTypeInfosByName();
        Date TDy = System.today();
        Schema.DescribeSObjectResult AR = Schema.SObjectType.Account;
        Map<String,Schema.RecordTypeInfo> ARMapByName = AR.getRecordTypeInfosByName();
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.recordtypeid= ARMapByName.get('Customer').getRecordTypeId();
        insert acc;

  Account_Profile__c AccPrf = new Account_Profile__c(Account__c=acc.id,
                                                     Account_Owner__c='abc',
                                                     RecordTypeId=A_P_RMapByName.get('MPS/Tech').getRecordTypeId());
     
     insert AccPrf;

 Account_Profile__c AP_tx = new Account_Profile__c(
       	Account__c=acc.id,
       	Account_Owner__c='abc',
       	RecordTypeId=A_P_RMapByName.get('TaxCertStatus').getRecordTypeId(),
       	Expiration_Date__c = TDy.addDays(6),
		Address_State__c = 'FL',
      	Country_Code__c = 'USA',
      	Tax_Status__c = 'A',
      	Profile_Unique_Name__c = null,
      	Name = 'Tax Certificate Status'       
       ); 
 insert AP_Tx;
     
     AP_tx.Profile_Unique_Name__c = AP_tx.RecordTypeId + '-' + AP_tx.Account__c + AP_tx.Address_State__c;  
     
 Delete AP_tx;     

//This record should create a Tax record but not create an email or a log record in log_object Day 365 out
  Account_Profile__c AP_Tx_Exp365 = new Account_Profile__c(
       	Account__c=acc.id,
       	Account_Owner__c='abc',
       	RecordTypeId=A_P_RMapByName.get('TaxCertStatus').getRecordTypeId(),
       	Expiration_Date__c = TDy.addDays(365),
		Address_State__c = 'SC',
      	Country_Code__c = 'USA',
      	Tax_Status__c = 'A',
      	Profile_Unique_Name__c = '^^',
      	Name = 'Tax Certificate Status'       
       ); 
 insert AP_Tx_Exp365;
     
     AP_Tx_Exp365.Profile_Unique_Name__c = AP_Tx_Exp365.RecordTypeId + '-' + AP_Tx_Exp365.Account__c + AP_Tx_Exp365.Address_State__c;
     
 Delete AP_Tx_Exp365;     
     
//This record should create a Tax record, an email and a log record in log_object Day 59 out     
     Account_Profile__c AP_Tx_Exp60 = new Account_Profile__c(
       	Account__c=acc.id,
       	Account_Owner__c='abc',
       	RecordTypeId=A_P_RMapByName.get('TaxCertStatus').getRecordTypeId(),
       	Expiration_Date__c = TDy.addDays(59),
		Address_State__c = 'FL',
      	Country_Code__c = 'USA',
      	Tax_Status__c = 'A',
      	Profile_Unique_Name__c = '^^',
      	Name = 'Tax Certificate Status'       
       ); 
  insert  AP_Tx_Exp60;
     
      AP_Tx_Exp60.Profile_Unique_Name__c = AP_Tx_Exp60.RecordTypeId + '-' + AP_Tx_Exp60.Account__c + AP_Tx_Exp60.Address_State__c;
     
  delete  AP_Tx_Exp60;     
     
//This record should create a Tax record, an email and a log record in log_object Day 29 out          
  Account_Profile__c AP_Tx_Exp30 = new Account_Profile__c(
       	Account__c=acc.id,
       	Account_Owner__c='abc',
       	RecordTypeId=A_P_RMapByName.get('TaxCertStatus').getRecordTypeId(),
       	Expiration_Date__c = TDy.addDays(29),
		Address_State__c = 'FL',
      	Country_Code__c = 'USA',
      	Tax_Status__c = 'A',
      	Profile_Unique_Name__c = '^^',
      	Name = 'Tax Certificate Status'       
       ); 
 insert AP_Tx_Exp30;
     
     AP_Tx_Exp30.Profile_Unique_Name__c = AP_Tx_Exp30.RecordTypeId + '-' + AP_Tx_Exp30.Account__c + AP_Tx_Exp30.Address_State__c;   
     
  delete  AP_Tx_Exp30;         
//This record should create a Tax record, an email and a log record in log_object Day 7 out       
    Account_Profile__c AP_Tx_Exp7 = new Account_Profile__c(
       	Account__c=acc.id,
       	Account_Owner__c='abc',
       	RecordTypeId=A_P_RMapByName.get('TaxCertStatus').getRecordTypeId(),
       	Expiration_Date__c = TDy.addDays(6),
		Address_State__c = 'FL',
      	Country_Code__c = 'USA',
      	Tax_Status__c = 'A',
      	Profile_Unique_Name__c = null,
      	Name = 'Tax Certificate Status'       
       ); 
 insert AP_Tx_Exp7;
     
     AP_Tx_Exp7.Profile_Unique_Name__c = AP_Tx_Exp7.RecordTypeId + '-' + AP_Tx_Exp7.Account__c + AP_Tx_Exp7.Address_State__c;  
     
 Delete AP_tx_Exp7;
//This record should create a similar type record but not create an email or a log record in log_object  Day 5 out 
    Account_Profile__c AP_Tx_Exp5 = new Account_Profile__c(
       	Account__c=acc.id,
       	Account_Owner__c='abc',
       	RecordTypeId=A_P_RMapByName.get('TaxCertStatus').getRecordTypeId(),
       	Expiration_Date__c = TDy.addDays(5),
		Address_State__c = 'FL',
      	Country_Code__c = 'USA',
      	Tax_Status__c = 'A',
      	Profile_Unique_Name__c = '^^',
      	Name = 'Tax Certificate Status'       
       ); 
 insert AP_Tx_Exp5;
     
     AP_Tx_Exp5.Profile_Unique_Name__c = AP_Tx_Exp5.RecordTypeId + '-' + AP_Tx_Exp5.Account__c + AP_Tx_Exp5.Address_State__c;  
  
 }
}