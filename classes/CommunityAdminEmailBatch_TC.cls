@isTest
private class CommunityAdminEmailBatch_TC {

   
	private static testMethod void test() {
	    
	    string LeadQUERY = 'SELECT id, first_name__c, last_name__c, Login_Name__c, GPO_Group__c, GPO_Group__r.Community_Name__c, ' + 
        'Account__c FROM GPO_Lead__c WHERE Status__c = \'Pending\' AND Private__c = true';
        
        //Set the user
        //User testUser = getTestUser('Customer Community Login User','aaab@officedepot.com','227112');
        //User testUser = Test_Utils.createTestUser('Tst','112233');
        User testUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        GPO_Template__c GPOt1;
        GPO_Template__c GPOt2;
        GPO_Community_Setup__c GPOcs1;
        GPO_Community_Setup__c GPOcs2;
        
        Account acc;
        Contact contact1;
        User testSUser2;
        GPO_Group__c GPOg;
        GPO_Lead__c lead;
        
        System.runAs(testUser)
        {
            //create account
            acc = Test_Utils.CreateAccount();
        
            //Community Template 
             GPOt1 = Test_Utils.createGPOTemplate('deftemplate', true);
             GPOcs1 = Test_Utils.createGPOCommunitySetUp(GPOt1, true);
            
            //Community setup
             GPOt2 = Test_Utils.createGPOTemplate('com2template', true);
             GPOcs2 = Test_Utils.createGPOCommunitycom2SetUp(GPOt2, true);
            
            
            //Account acc = Test_Utils.getTestAccount(testUser,'123456');
             contact1 =  CreateContact(acc.Id);
            
            //------creatin super user-----------
            testSUser2 = getTestSUser('Customer Community Login User - GPO Admin','dsfsdf@officedepot.com','276743', contact1);
            //----------
            system.debug('testSUser: ' + testSUser2);
            System.assertNotEquals(testSUser2, null);
            
            //create GPO group
             GPOg = Test_Utils.createPrivateGPOGroup(GPOt2, acc,true,true);
            
            //Create GPO Lead
             lead = Test_Utils.createGPOLead_for_privgrp(acc,true);
        
        }
        
        System.runas(testSUser2)
        {
            test.startTest();
            SchedulableContext sc = null;
            CommunityAdminEmailBatch cadminb = new CommunityAdminEmailBatch();         
            database.executebatch(cadminb,1);
            test.stoptest();
            
            String CRON_EXP = '0 0 0 3 9 ? 2022';
            System.schedule('TestBatch1',CRON_EXP , cadminb );
        }
	    
	    

	}
	
	public static User getTestUser(String profileName,String userName,String empId){
        Profile profileObj = [select id from profile where name=: profileName];
        String profId = profileObj.id;
        UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        string email = userName;
        string[] name = userName.split('@');
        user u = new user(Username=userName,FirstName =name[1], LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u.email=email;
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c =empId;
        u.GT_Employee_ID__c =empId;
        u.IsActive=true;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.Token_Market_Builder__c ='xyz';
        u.UserRoleId = ContractDivisionRoleId.Id;
        
        try{ 
            Insert u;
            system.debug('@@@User@@@ : '+u);
            return u;
        }
        catch(Exception e) {
            system.debug('Exception'+e);
        }
        return u;
    }    
    
    public static User getTestSUser(String profileName,String userName,String empId, contact ct){
        Profile profileObj = [select id from profile where name=: profileName];
        String profId = profileObj.id;
        UserRole ContractDivisionRoleId = [SELECT Id from UserRole WHERE Name = 'Contract Division' limit 1];
        string email = userName;
        string[] name = userName.split('@');
        user u = new user(Username=userName,FirstName =name[1], contactid = ct.id, LastName=name[0], Alias=name[0], CommunityNickname=userName, LocaleSidKey='en_US', EmailEncodingKey='UTF-8', Profileid = profId, LanguageLocaleKey='en_US');
        u.email=email;
        u.MB_Expiration_Date__c = System.now().addminutes(1);
        u.OD_Employee_ID__c =empId;
        u.GT_Employee_ID__c =empId;
        u.IsActive=true;
        u.TimeZoneSidKey='America/Los_Angeles';
        u.Token_Market_Builder__c ='xyz';
        Insert u;
        
        return u;
    } 
    
    public static Contact CreateContact(Id accountId) {
        Contact contact = new Contact(LastName = 'TEST',AccountId = accountId);
        contact.MailingCountry = 'MEX';
        contact.Admin_Context__c =  accountId;
        contact.GPO_Community__c =accountId;
        insert contact;
        
        return contact;
    }

}