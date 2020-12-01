@IsTest
public class businessProInfo_TC
{
    static testMethod void businessProInfoTest() 
    {
        Account acc = new Account ();
        acc.recordtypeId=Label.Customer_GT_Record_Type;
        acc.name = 'SUN Test Account1';
        acc.BillingStreet = '1039 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123457';
        acc.AOPS_Cust_Id__c = '123457';
        acc.AOPS_Seq_ID__c = '123457';
        acc.OwnerID = '005E0000000lNbV'; // This is the salesforce User ID
        acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc;

        Contact Site_Primary_Contact = new Contact();
        Site_Primary_Contact.LastName='LastNametest1';
        Site_Primary_Contact.email='testemail1@test.com';
        Site_Primary_Contact.AccountId = acc.id;
        Site_Primary_Contact.OMX_Primary_Key__c='123456';
        insert Site_Primary_Contact;

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser)
        {        
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Business Pro Rep'];
            //User u = [SELECT Id FROM User WHERE ProfileId =: p.Id and Business_Pro_User__c = true limit 1];
            String usrName = 'LastName';
            User u = new User();
            u.firstName = 'stdTestUser';
            u.LastName = 'test'+usrName;
            u.Alias = usrName;
            u.Email = usrName+'stdTestUser@officedepot.com';
            u.UserName= usrName+'stdTestUser@metacube.com';
            u.ProfileId = p.id;
            u.CommunityNickname = u.firstname+'_'+u.lastName;
            u.EmailEncodingKey ='ISO-8859-1';
            u.LanguageLocaleKey = 'en_US';
            u.TimeZoneSidKey ='America/New_York';
            u.LocaleSidKey = 'en_US';
            u.Country = 'USA';
            insert u;
            
            // Insert group
            Group grp = new Group();
            grp.Name = 'Business Pro MGR';
            insert grp;
            system.debug('@@@@grp' + grp);
            GroupMember grpMbrObj = new GroupMember();
            grpMbrObj.GroupId = grp.id;
            if(u != null)
            grpMbrObj.UserOrGroupId = u.id ;
            insert grpMbrObj;
            system.debug('@@@@grpMbrObj' + grpMbrObj);

        
        business_pro_owner__c busProOwnerObj = new business_pro_owner__c();
        busProOwnerObj.isCurrent__C = true;
        busProOwnerObj.BusinessPro__C = u.id;
        busProOwnerObj.account__c = acc.id;
        busProOwnerObj.Start_Date__c = Date.newInstance(2015, 12, 12);
        insert busProOwnerObj;
        
        business_pro_owner__c busProOwnerObj1 = new business_pro_owner__c();
        busProOwnerObj1.BusinessPro__C = u.id;
        busProOwnerObj1.Start_Date__c = Date.newInstance(2015, 12, 12);
        busProOwnerObj1.account__c = acc.id;
        insert busProOwnerObj1;
        
        
    
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        businessProInfo businessPro = new businessProInfo(sc);
        PageReference pageRef = Page.BusinessProInfo;
        pageRef.getParameters().put('id', String.valueOf(acc.Id));
        Test.setCurrentPage(pageRef);
        businessPro.changeOwner();
        businessPro.newBo = busProOwnerObj1;
        businessPro.savebpro();
        businessPro.cancelbpro();
        businessProInfo businessPro1 = new businessProInfo();
        test.stopTest();
        }
    }
   static testMethod void businessProInfoTest1() 
    {
        Account acc = new Account ();
        acc.recordtypeId=Label.Customer_GT_Record_Type;
        acc.name = 'SUN Test Account1';
        acc.BillingStreet = '1039 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123457';
        acc.AOPS_Cust_Id__c = '123457';
        acc.AOPS_Seq_ID__c = '123457';
        acc.OwnerID = '005E0000000lNbV'; // This is the salesforce User ID
        acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc;

        Contact Site_Primary_Contact = new Contact();
        Site_Primary_Contact.LastName='LastNametest1';
        Site_Primary_Contact.email='testemail1@test.com';
        Site_Primary_Contact.AccountId = acc.id;
        Site_Primary_Contact.OMX_Primary_Key__c='123456';
        insert Site_Primary_Contact;

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser)
        {        
            
            Profile p = [SELECT Id FROM Profile WHERE Name='Business Pro Rep'];
             //User u = [SELECT Id FROM User WHERE ProfileId =: p.Id and Business_Pro_User__c = true limit 1];
            String usrName = 'LastName';
            User u = new User();
            u.firstName = 'stdTestUser';
            u.LastName = 'test'+usrName;
            u.Alias = usrName;
            u.Email = usrName+'stdTestUser@officedepot.com';
            u.UserName= usrName+'stdTestUser@metacube.com';
            u.ProfileId = p.id;
            u.CommunityNickname = u.firstname+'_'+u.lastName;
            u.EmailEncodingKey ='ISO-8859-1';
            u.LanguageLocaleKey = 'en_US';
            u.TimeZoneSidKey ='America/New_York';
            u.LocaleSidKey = 'en_US';
            u.Country = 'USA';
            insert u;
            
            User u1 = new User(Alias = 'standt', Email='test@Officedepot.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='sdss123@test.com');
            insert u1;
            // Insert group
            Group grp = new Group();
            grp.Name = 'Business Pro MGR';
            insert grp;
            system.debug('@@@@grp' + grp);
            GroupMember grpMbrObj = new GroupMember();
            grpMbrObj.GroupId = grp.id;
            if(u != null)
            grpMbrObj.UserOrGroupId = u.id ;
            insert grpMbrObj;
            system.debug('@@@@grpMbrObj' + grpMbrObj);

        
        business_pro_owner__c busProOwnerObj1 = new business_pro_owner__c();
        busProOwnerObj1.BusinessPro__C = u.id;
        busProOwnerObj1.Start_Date__c = Date.newInstance(2016, 12, 12);
        busProOwnerObj1.account__c = acc.id;
        insert busProOwnerObj1;
        
        
    
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        businessProInfo businessPro = new businessProInfo(sc);
        PageReference pageRef = Page.BusinessProInfo;
        pageRef.getParameters().put('id', String.valueOf(acc.Id));
        Test.setCurrentPage(pageRef);
        businessPro.changeOwner();
        businessPro.newBo = busProOwnerObj1;
        businessPro.savebpro();
        businessPro.cancelbpro();
        businessProInfo businessPro1 = new businessProInfo();
        test.stopTest();
        }
    }
    static testMethod void businessProInfoTest2() 
    {
        Account acc = new Account ();
        acc.recordtypeId=Label.Customer_GT_Record_Type;
        acc.name = 'SUN Test Account1';
        acc.BillingStreet = '1039 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123457';
        acc.AOPS_Cust_Id__c = '123457';
        acc.AOPS_Seq_ID__c = '123457';
        acc.OwnerID = '005E0000000lNbV'; // This is the salesforce User ID
        acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc;
        system.debug('!!!!!!!!!!!!!acc' + acc);
        

        system.debug('@@@@@@@acc.id'+ acc.id);

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser)
        {        
            Profile p = [SELECT Id FROM Profile WHERE Name='Business Pro Rep'];
            //User u = [SELECT Id FROM User WHERE ProfileId =: p.Id and Business_Pro_User__c = true limit 1];
            String usrName = 'LastName';
            User u = new User();
            u.firstName = 'stdTestUser';
            u.LastName = 'test'+usrName;
            u.Alias = usrName;
            u.Email = usrName+'stdTestUser@officedepot.com';
            u.UserName= usrName+'stdTestUser@metacube.com';
            u.ProfileId = p.id;
            u.CommunityNickname = u.firstname+'_'+u.lastName;
            u.EmailEncodingKey ='ISO-8859-1';
            u.LanguageLocaleKey = 'en_US';
            u.TimeZoneSidKey ='America/New_York';
            u.LocaleSidKey = 'en_US';
            u.Country = 'USA';
            insert u;
            
            User u1 = new User(Alias = 'standt', Email='test@Officedepot.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='sdss123@test.com');
            insert u1;
            // Insert group
            Group grp = new Group();
            grp.Name = 'Business Pro MGR';
            insert grp;
            system.debug('@@@@grp in businessProInfoTest2 ' + grp);
            GroupMember grpMbrObj = new GroupMember();
            grpMbrObj.GroupId = grp.id;
            if(u != null)
            grpMbrObj.UserOrGroupId = u.id ;
            insert grpMbrObj;
            system.debug('@@@@grpMbrObj businessProInfoTest2 ' + grpMbrObj);

        
        business_pro_owner__c busProOwnerObj = new business_pro_owner__c();
        busProOwnerObj.isCurrent__C = true;
        busProOwnerObj.BusinessPro__C = u.id;
        busProOwnerObj.account__c = acc.id;
        busProOwnerObj.Start_Date__c = Date.newInstance(2015, 12, 12);
        busProOwnerObj.end_date__c = Date.newInstance(2015, 11, 12);
        insert busProOwnerObj;
        
        business_pro_owner__c busProOwnerObj1 = new business_pro_owner__c();
        busProOwnerObj1.BusinessPro__C = u1.id;
        busProOwnerObj1.Start_Date__c = Date.newInstance(2014, 12, 12);
        busProOwnerObj1.end_date__c = Date.newInstance(2015, 11, 12);
        busProOwnerObj1.isCurrent__C = true;
        insert busProOwnerObj1;
       
    
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        businessProInfo businessPro = new businessProInfo(sc);
        PageReference pageRef = Page.BusinessProInfo;
        pageRef.getParameters().put('id', String.valueOf(acc.Id));
        Test.setCurrentPage(pageRef);
        businessPro.changeOwner();
        businessPro.newBo = busProOwnerObj1;
        businessPro.savebpro();
        businessPro.cancelbpro();
        businessProInfo businessPro1 = new businessProInfo();
        test.stopTest();
        }
    }
    static testMethod void businessProInfoTest3() 
    {
        Account acc = new Account ();
        acc.recordtypeId=Label.Customer_GT_Record_Type;
        acc.name = 'SUN Test Account1';
        acc.BillingStreet = '1039 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123457';
        acc.AOPS_Cust_Id__c = '123457';
        acc.AOPS_Seq_ID__c = '123457';
        acc.OwnerID = '005E0000000lNbV'; // This is the salesforce User ID
        acc.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc;
        system.debug('!!!!!!!!!!!!!acc' + acc);
        

        system.debug('@@@@@@@acc.id'+ acc.id);
        
        Account acc1 = new Account ();
        acc1.recordtypeId=Label.Customer_GT_Record_Type;
        acc1.name = 'SUN Test Account1';
        acc1.BillingStreet = '1039 N 326 W';
        acc1.billingcity = 'Orem';
        acc1.BillingState = 'UT';
        acc1.Billingcountry = 'USA';
        acc1.Oracle_Party_Id__c = '4351';
        acc1.AOPS_Cust_Id__c = '4351';
        acc1.AOPS_Seq_ID__c = '4351';
        acc1.OwnerID = '005E0000000lNbV'; // This is the salesforce User ID
        acc1.Sales_PersonID__c = 'a0AE0000000GGMn'; //Sales person Id for the Salesforce USer
        insert acc1;

        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser)
        {        
            Profile p = [SELECT Id FROM Profile WHERE Name='Business Pro Rep'];
            //User u = [SELECT Id FROM User WHERE ProfileId =: p.Id and Business_Pro_User__c = true limit 1];
            String usrName = 'LastName';
            User u = new User();
            u.firstName = 'stdTestUser';
            u.LastName = 'test'+usrName;
            u.Alias = usrName;
            u.Email = usrName+'stdTestUser@officedepot.com';
            u.UserName= usrName+'stdTestUser@metacube.com';
            u.ProfileId = p.id;
            u.CommunityNickname = u.firstname+'_'+u.lastName;
            u.EmailEncodingKey ='ISO-8859-1';
            u.LanguageLocaleKey = 'en_US';
            u.TimeZoneSidKey ='America/New_York';
            u.LocaleSidKey = 'en_US';
            u.Country = 'USA';
            insert u;
            
            User u1 = new User(Alias = 'standt', Email='test@Officedepot.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles', UserName='sdss123@test.com');
            insert u1;
            // Insert group
            Group grp = new Group();
            grp.Name = 'Business Pro MGR';
            insert grp;
            system.debug('@@@@grp in businessProInfoTest2 ' + grp);
            GroupMember grpMbrObj = new GroupMember();
            grpMbrObj.GroupId = grp.id;
            if(u != null)
            grpMbrObj.UserOrGroupId = u.id ;
            insert grpMbrObj;
            system.debug('@@@@grpMbrObj businessProInfoTest2 ' + grpMbrObj);

        
        business_pro_owner__c busProOwnerObj = new business_pro_owner__c();
        busProOwnerObj.isCurrent__C = true;
        busProOwnerObj.BusinessPro__C = u.id;
        busProOwnerObj.account__c = acc1.id;
        busProOwnerObj.Start_Date__c = Date.newInstance(2015, 12, 12);
        busProOwnerObj.end_date__c = Date.newInstance(2015, 11, 12);
        insert busProOwnerObj;
        
        business_pro_owner__c busProOwnerObj1 = new business_pro_owner__c();
        busProOwnerObj1.BusinessPro__C = u1.id;
        busProOwnerObj1.account__c = acc1.id;
        busProOwnerObj1.Start_Date__c = Date.newInstance(2014, 12, 12);
        busProOwnerObj1.end_date__c = Date.newInstance(2015, 11, 12);
        busProOwnerObj1.isCurrent__C = true;
        insert busProOwnerObj1;
       
    
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        businessProInfo businessPro = new businessProInfo(sc);
        PageReference pageRef = Page.BusinessProInfo;
        pageRef.getParameters().put('id', String.valueOf(acc.Id));
        Test.setCurrentPage(pageRef);
        businessPro.changeOwner();
        businessPro.newBo = busProOwnerObj1;
        businessPro.savebpro();
        businessPro.cancelbpro();
        businessProInfo businessPro1 = new businessProInfo();
        test.stopTest();
        }
    }
}