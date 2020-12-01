@isTest
private class AccountRestore_TC {
    static User testUser;
    private static testMethod void restoreAPItest() {
         testUser = Test_Utils.createTestUser('tes46','9965445');
               Id SystemId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('System').getRecordTypeId();
               Id ProspectId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();

         
         System.RunAs(testUser){
         
         DNBI_Credentials__c cred = new DNBI_Credentials__c(name='Test',UserName__c='Test',DnB_Active__c=true);
         insert cred;
         
         
         List<Account> accInsert= new List<Account>();
             Data_Cleansing_Settings__c dc = new Data_Cleansing_Settings__c(system_account__c='SYSTEMCLEANSE');
             insert dc;
             String systemAccount = [SELECT id,system_account__c from Data_Cleansing_Settings__c].system_account__c;
             Account account = new Account(Name = 'acct1',AOPS_Cust_Id__c='123456');
             accInsert.add(account);
             
             
             Account accountSystem = new Account(Name = systemAccount,AOPS_Cust_Id__c='987654',recordtypeId=SystemId);
             accInsert.add(accountSystem);
             
             Account accountProspect = new Account(Name = 'TetProspect',recordtypeId=ProspectId,Address1__c ='Test');
             accInsert.add(accountProspect);


              insert accInsert;
             
             
             Account_Extension__c ae=[select id from account_extension__c where Original_Account_ID__c=:account.id]; 
             ae.Account_Owner__c=testUser.Id;
             ae.Account_Name__c='TestExt';
             update ae;                        
             
                       System.debug('&&&&&&&&&&&&&extensionTestClass'+ae.Id);

             
            Test.starttest();

             
             //Account_Extension__c aeSystem=[select id from account_extension__c where Original_Account_ID__c=:accountSystem.id];
             Account_Profile__c ap = new Account_Profile__C(account__c=accountSystem.id,
                                                            Account_Profile_Extension_Account__c=ae.id,
                                                            Profile_Unique_Name__c = 'XYZ'+accountSystem.name);
             insert ap;
             
             //***********logic is occuring for both insert and update 
            ap.Account_Profile_Extension_Account__c = ae.id;
            update ap;

                          
             Account_Dormant__C ad = new Account_Dormant__c(AccountExtension__c = ae.id);
             insert ad;
             delete account;
             
             //account_profile__c a = [select id from account_profile__C where Account_Profile_Extension_Account__c=:ae.id];
             
             Account_Extension__c  recId=[ select account__C from Account_Extension__c where Id =:ae.id];
             System.debug('&&&&&&&&&&&& extension Record'+recId.account__C );
            
             list<Account_Dormant__c> adList = new list<Account_Dormant__c>();
             adList.add(ad);
             AccountRestore ar = new AccountRestore();
             executeoncetest.bypassAccountExtension = false;
             ar.restoreAccount(adList,'Sales Exist','');
             
             update accountProspect;
             Test.stoptest();

             
         }
    }
    
    
}