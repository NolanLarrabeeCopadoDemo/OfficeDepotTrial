@isTest
private class Account_TC {
  static testmethod void Accounttest_method(){
    //create test data
    
           // Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        /*User u = new User(Alias = 'st11', Email='standarduser@officedepot.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='dataloadernorth@officedepot.com');
insert u;*/

User u=[select Id, name from User where UserName='dataloadernorth@officedepot.com'];

    Account acc = Test_Utils.createAccount('Customer (OfficeMax)');
      acc.Name = 'TestOriginalAccount';
      acc.Split_Record__c = false;
      acc.OMX_Primary_Key__c = '123456';
     acc.address1__C = 'Test';

      insert acc;
      
           acc.address1__C = 'Test1';
 update acc;
             Account_Extension__c ae=[select id from account_extension__c where Original_Account_ID__c=:acc.id];                          
             
                          
             Account_Dormant__C ad = new Account_Dormant__c(AccountExtension__c = ae.id);
             insert ad;
             ae.address1__C='Test1';
             update ae;
             
                System.runas(u){
                Customer_Transition__C rec=[select Id from Customer_Transition__C where account__C=:acc.Id];
             delete rec;
                       delete acc;
      try{                 
      Account acc1 = Test_Utils.createAccount('Customer (OfficeMax)');
      acc1.Name = 'TestOriginalAccount';
      acc1.Split_Record__c = false;
      acc1.OMX_Primary_Key__c = '123456';
      acc1.address1__C = 'Test';
      acc1.Account_Extension__c=ae.Id;
      insert acc1;
} catch(Exception e) {}

                }
   
             
             
       }      
      }