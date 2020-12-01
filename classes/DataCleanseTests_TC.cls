@isTest
private class DataCleanseTests_TC {
    static User testUser;
	private static testMethod void restoreAPItest() {
         testUser = Test_Utils.createTestUser('test11','999654');
         System.RunAs(testUser){
             Data_Cleansing_Settings__c dc = new Data_Cleansing_Settings__c(system_account__c='SYSTEMCLEANSE');
             insert dc;
             String systemAccount = [SELECT id,system_account__c from Data_Cleansing_Settings__c].system_account__c;
             Account account = new Account(Name = 'acct1',AOPS_Cust_Id__c='123456');
             insert account;
             Account_Extension__c ae=[select id from account_extension__c where Original_Account_ID__c=:account.id];
             Account_Dormant__C ad = new Account_Dormant__c(AccountExtension__c = ae.id);
             insert ad;
             delete account;
             Account accountSystem = new Account(Name = systemAccount,AOPS_Cust_Id__c='987654');
             insert accountSystem;
             //Account_Extension__c aeSystem=[select id from account_extension__c where Original_Account_ID__c=:accountSystem.id];
             Account_Profile__c ap = new Account_Profile__C(account__c=accountSystem.id,
                                                            Account_Profile_Extension_Account__c=ae.id,
                                                            Profile_Unique_Name__c = 'XYZ'+accountSystem.name);
             insert ap;
            
             list<Account_Dormant__c> adList = new list<Account_Dormant__c>();
             adList.add(ad);
             AccountRestore ar = new AccountRestore();
             executeoncetest.bypassAccountExtension = false;
             ar.restoreAccount(adList,'Sales Exist','');
         }
	}
	
	private static testMethod void restorectrlTest() {
	    testUser = Test_Utils.createTestUser('test11','999654');
         System.RunAs(testUser){
             Data_Cleansing_Settings__c dc = new Data_Cleansing_Settings__c(system_account__c='SYSTEMCLEANSE');
             insert dc;
             Account account = new Account(Name = 'acct1',AOPS_Cust_Id__c='123456');
             insert account;
             Account_Extension__c ae=[select id from account_extension__c where Original_Account_ID__c=:account.id];
             Account_Dormant__C ad = new Account_Dormant__c(AccountExtension__c = ae.id);
             insert ad;
             delete account;
             AccountRestorectrl actrl = new AccountRestorectrl();
             actrl.ReasonCode = 'Manual Restore';
             actrl.comments = '';
             ApexPages.currentPage().getParameters().Put('AcctDormantID',ad.id);
             PageReference pr = actrl.restoreAcct();
         }
             
	}
	
	private static testMethod void siteContactctrlTest() {
	    testUser = Test_Utils.createTestUser('test11','999654');
         System.RunAs(testUser){
         Account account = new Account(Name = 'acct1',AOPS_Cust_Id__c='123456');
         insert account;
         Account site = new Account(Name = 'site1',AOPS_seq_Id__c='123456-00001',Related_Account__c=account.id,
                                   Address1__c='6600 N Military Trl',City__c='Boca Raton',State__c='FL',Zip__c='33496',Country__c='USA');
         insert site;
         Contact c = New Contact(AccountId=account.id,firstname='fname',lastname='lname',email='test@email.com',phone='5616456434');
         insert c;
         ApexPages.currentPage().getParameters().Put('id',site.id);
         ApexPages.currentPage().getParameters().put('AccountID',account.id);
         ApexPages.currentPage().getParameters().put('SiteID',site.id);
         ApexPages.currentPage().getParameters().put('contactID',C.id);
         ApexPages.StandardController scontroller = new ApexPages.StandardController(account); 
         SiteContactCtrl scontrolExt = new SiteContactCtrl(scontroller); 
         scontrolExt.csearch.firstName = 'fname';
         scontrolExt.csearch.lastname = 'lname';
         scontrolExt.csearch.email = 'test@email.com';
         scontrolExt.csearch.phone = '5616456434';
         scontrolExt.populateMatchingContacts();
         pageReference p = scontrolExt.addContact();
         }
             
	 }
	 
	 private static testMethod void AccountduplicatesCtrlTest() {
	    testUser = Test_Utils.createTestUser('test11','999654');
         System.RunAs(testUser){
         Account account = new Account(Name = 'acct1',AOPS_Cust_Id__c='123456');
         insert account;
         Account site = new Account(Name = 'site1',AOPS_seq_Id__c='123456-00001',Related_Account__c=account.id,
                                   Address1__c='6600 N Military Trl',City__c='Boca Raton',State__c='FL',Zip__c='33496',Country__c='USA');
         insert site;
         
         ApexPages.currentPage().getParameters().Put('id',account.id);
       
         ApexPages.StandardController scontroller = new ApexPages.StandardController(account); 
         AccountDuplicatesctrl scontrolExt = new AccountDuplicatesctrl(scontroller); 
         account_duplicate_junction__c dj = new Account_Duplicate_Junction__c (Account_Master__c=account.id,Account_Dup__c=site.id);
         insert dj;
         scontrolExt.loadData();
         scontrolExt.displayHeaderCategory();
         scontrolExt.hideHeaderCategory();
         scontrolExt.displaySiteCategory();
         scontrolExt.hideSiteCategory();
         scontrolExt.displayAcitveAccts();
         scontrolExt.hideAcitveAccts();
         scontrolExt.displayAcitveSites();
         scontrolExt.hideAcitveSites();
         scontrolExt.displaydormantAccts();
         scontrolExt.hidedormantAccts();
         scontrolExt.displaydormantSites();
         scontrolExt.hideDormantSites();
         scontrolExt.displayleads();
         scontrolExt.hideleads();
         }
             
	 }
	 
	 private static testMethod void dormantToAccountBatchTest() {
	    testUser = Test_Utils.createTestUser('test11','999654');
         System.RunAs(testUser){
         Data_Cleansing_Settings__c dc = new Data_Cleansing_Settings__c(system_account__c='SYSTEMCLEANSE');
             insert dc;
             String systemAccount = [SELECT id,system_account__c from Data_Cleansing_Settings__c].system_account__c;
             Account account = new Account(Name = 'acct1',AOPS_Cust_Id__c='123456',last_order_date__c=date.today());
             insert account;
             Account_Extension__c ae=[select id from account_extension__c where Original_Account_ID__c=:account.id];
             Account_Dormant__C ad = new Account_Dormant__c(AccountExtension__c = ae.id);
             insert ad;
             delete account;
             Account accountSystem = new Account(Name = systemAccount,AOPS_Cust_Id__c='987654');
             insert accountSystem;
             //Account_Extension__c aeSystem=[select id from account_extension__c where Original_Account_ID__c=:accountSystem.id];
             Account_Profile__c ap = new Account_Profile__C(account__c=accountSystem.id,
                                                            Account_Profile_Extension_Account__c=ae.id,
                                                            Profile_Unique_Name__c = 'XYZ'+accountSystem.name);
             insert ap;
            
             list<Account_Dormant__c> adList = new list<Account_Dormant__c>();
             adList.add(ad);
             Test.StartTest();
             DormantToAccountBatch  dToABatch = new DormantToAccountBatch ('');
             database.executebatch(dToABatch,10);    
             
              Datetime dt = System.now();
              String scheduleString='0';//0 seconds
              scheduleString+=' '+ dt.minute();
              scheduleString+=' '+ dt.hour();
              scheduleString+=' '+ dt.day();
              scheduleString+=' '+ dt.month();
              scheduleString+=' ?';
              scheduleString+=' '+ dt.year();     
              System.debug('currently scheduled. time for education eduMasterGroup  ' + scheduleString); 

              String CRON_EXP = '0 0 0 3 9 ? 2022';                                  
              String mappingQuery = '';
              DormantToAccountBatch dBatch = new DormantToAccountBatch('');
              System.schedule('dormant to account',CRON_EXP , dBatch);
             
             Test.StopTest();
             
         }
             
	 }
	 
	 private static testMethod void dedupNotesAttachmentBatchTest() {
	    testUser = Test_Utils.createTestUser('test11','999654');
         System.RunAs(testUser){
             Data_Cleansing_Settings__c dc = new Data_Cleansing_Settings__c(system_account__c='SYSTEMCLEANSE');
             insert dc;
             String systemAccount = [SELECT id,system_account__c from Data_Cleansing_Settings__c].system_account__c;
             Account account = new Account(Name = 'acct1',AOPS_Cust_Id__c='123456',last_order_date__c=date.today());
             insert account;
             Account_Extension__c ae=[select id from account_extension__c where Original_Account_ID__c=:account.id];
             Account_Dormant__C ad = new Account_Dormant__c(AccountExtension__c = ae.id,Original_Account_ID__c=account.id);
             insert ad;
             
             note nc = new note(parentid=account.id,title='test',body='test');
             insert nc;
             
             attachment at = new attachment(parentid=account.id,name='test',body=Blob.valueOf('test'));
             insert at;
             test.startTest();
             Dedup_notesAttachments_Batch dbatch = new Dedup_notesAttachments_Batch('');
             database.executebatch(dbatch,10);
             
              Datetime dt = System.now();
              String scheduleString='0';//0 seconds
              scheduleString+=' '+ dt.minute();
              scheduleString+=' '+ dt.hour();
              scheduleString+=' '+ dt.day();
              scheduleString+=' '+ dt.month();
              scheduleString+=' ?';
              scheduleString+=' '+ dt.year();     
              System.debug('currently scheduled. time for education eduMasterGroup  ' + scheduleString); 

              String CRON_EXP = '0 0 0 3 9 ? 2022';                                  
              String mappingQuery = '';
              Dedup_notesAttachments_Batch dBatch2 = new Dedup_notesAttachments_Batch('');
              System.schedule('dormant to account',CRON_EXP , dBatch2);
             
             
             test.stopTest();
        }

     }
  
  

    private static testMethod void trigTest() {
	  
     User stdTestUser = new User();
     stdTestUser.firstName = 'stdTestUser';
     stdTestUser.LastName = 'test';
     stdTestUser.Alias = '12';
     stdTestUser.Email = 'stdTestUser@officedepot.com';
     stdTestUser.UserName= 'dataload12xy@officedepot.com';
     stdTestUser.ProfileId = [Select id from profile where name = 'System Administrator' limit 1].Id;
     stdTestUser.CommunityNickname = stdTestUser.firstname+'_'+stdTestUser.lastName;
     stdTestUser.EmailEncodingKey ='ISO-8859-1';
     stdTestUser.LanguageLocaleKey = 'en_US';
     //stdTestUser.TimeZoneSidKey ='America/Indianapolis';
     stdTestUser.TimeZoneSidKey ='America/New_York';
     stdTestUser.LocaleSidKey = 'en_US';
     stdTestUser.Country = 'USA';
     stdTestUser.OD_Employee_ID__c ='999654';
     
         System.RunAs(stdTestUser){
             Data_Cleansing_Settings__c dc = new Data_Cleansing_Settings__c(system_account__c='SYSTEMCLEANSE');
             insert dc;
             String systemAccount = [SELECT id,system_account__c from Data_Cleansing_Settings__c].system_account__c;
             account a = new account(
                        name='test88',
                        OMX_Mainframe_Account_Number__c='0947578',
                        omx_primary_key__c='0947578',
                        omx_mainframe_account_level__c='Main Account');
              insert a;
           
             Account_Extension__c ae=[select id from account_extension__c where Original_Account_ID__c=:a.id];
             Account_Dormant__C ad = new Account_Dormant__c(AccountExtension__c = ae.id);
             insert ad;
             delete a;
             Account accountSystem = new account(
                        name='test88',
                        OMX_Mainframe_Account_Number__c='0947578',
                        omx_primary_key__c='0947578',
                        omx_mainframe_account_level__c='Main Account');
             database.insert(accountSystem,false);
        
         }      

}
}