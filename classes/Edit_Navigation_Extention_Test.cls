@isTest
    private class Edit_Navigation_Extention_Test {
     static testMethod void testeditnavigation () {
        Id rcid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Id omaxrcid =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect (OfficeMax)').getRecordTypeId();
        
        Profile profile = [select id from profile where name='System Administrator'];
        
        User TestUser = new User(alias = 'standt', email='standarduser@wipro.com', 
                           emailencodingkey='UTF-8',IsActive =true, lastname='Testing', languagelocalekey='en_US', 
                           localesidkey='en_US', profileid = profile.Id,OD_Employee_ID__c = '670065', 
                           timezonesidkey='America/Los_Angeles',username='testKam@wipro.com.od.uat');
                           
        insert TestUser;
        system.runAs(TestUser){
        
        Sales_Person__c salesID = new Sales_Person__c(ExtIDSalesPerson__c='243445',IsActive__c = true,Primary__c = true,User__c=TestUser.id,Name='76348');
        
        Account acc = new Account ();
        acc.name = 'SUN Test Account1';
        acc.BillingStreet = '1040 N 326 W';
        acc.billingcity = 'Orem';
        acc.zip__c = '123';
        acc.address1__c = 'abc';
        acc.City__c = 'Oklahama';
        acc.state__c = 'FL';
        acc.Country__c = 'USA';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123456';
        acc.AOPS_Cust_Id__c = '123456';
        acc.AOPS_Seq_ID__c = '123456';        
        acc.Assign_Specific_Owner__c = TestUser.id;
        acc.RecordTypeId = rcid;
        insert acc;
        ApexPages.StandardController stdController = new ApexPages.StandardController(acc);     
        Edit_Navigation_Extention EditN = new Edit_Navigation_Extention(stdController );
        EditN.redirectToPage();
        
        Account acc1 = new Account ();
        acc1.name = 'SUN Test Account2';
        acc1.BillingStreet = '1040 N 326 W';
        acc1.billingcity = 'Orem';
        acc1.zip__c = '123';
        acc1.address1__c = 'abc';
        acc1.City__c = 'Oklahama';
        acc1.state__c = 'FL';
        acc1.Country__c = 'USA';
        acc1.BillingState = 'UT';
        acc1.Billingcountry = 'USA';
        //acc.Oracle_Party_Id__c = '123456';
        //acc.AOPS_Cust_Id__c = '123456';
        //acc.AOPS_Seq_ID__c = '123456';        
        acc1.Assign_Specific_Owner__c = TestUser.id;
        acc1.RecordTypeId = omaxrcid ;
        insert acc1;
        ApexPages.StandardController stdController1 = new ApexPages.StandardController(acc1);     
        Edit_Navigation_Extention EditN1 = new Edit_Navigation_Extention(stdController1 );
        EditN1.redirectToPage();
    }
    }
    }