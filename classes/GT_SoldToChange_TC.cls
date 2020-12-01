@isTest
private class GT_SoldToChange_TC 
{

    static testMethod void GT_SoldToChangeUnitTest() 
    {
        System.runas(new user(ID = UserInfo.getUserID())){

         Profile profileObj = [select id from profile where name='System Administrator'];

         String profId = profileObj.id;
         user usrObj = new user(Username='abc123@officedepot.com.uat',FirstName ='Fname',
          LastName='Lname', Alias='abc123', CommunityNickname='abc123', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', 
         Profileid = profId, LanguageLocaleKey='en_US', email='abc123@officedepot.com.uat',TimeZoneSidKey='America/New_York');
         usrObj.Short_Title__c='';
         Insert usrObj;

        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='777777';
        s.Primary__c =true;
        s.user__c=usrObj.id;
        insert s;

        
        Account oldRelatedAcc = new Account ();
        oldRelatedAcc.recordtypeId=Label.Customer_GT_Record_Type;
        //oldRelatedAcc.Related_Account__c=acc;
        oldRelatedAcc.name = 'SUN Test Account1';
        oldRelatedAcc.BillingStreet = '1039 N 326 W';
        oldRelatedAcc.billingcity = 'Orem';
        oldRelatedAcc.BillingState = 'UT';
        oldRelatedAcc.Billingcountry = 'USA';
        oldRelatedAcc.Oracle_Party_Id__c = '123457';
        oldRelatedAcc.AOPS_Cust_Id__c = '123457';
        oldRelatedAcc.AOPS_Seq_ID__c = '123457';
        oldRelatedAcc.OwnerID = usrObj.Id;// This is the salesforce User ID
        oldRelatedAcc.Sales_PersonID__c = s.Id; //Sales person Id for the Salesforce USer
        insert oldRelatedAcc;
        
        Account relatedAcc = new Account ();
        relatedAcc.recordtypeId=Label.Customer_GT_Record_Type;
        //relatedAcc.Related_Account__c=acc;
        relatedAcc.name = 'SUN Test Account2';
        relatedAcc.BillingStreet = '1038 N 326 W';
        relatedAcc.billingcity = 'Orem';
        relatedAcc.BillingState = 'UT';
        relatedAcc.Billingcountry = 'USA';
        relatedAcc.Oracle_Party_Id__c = '123458';
        relatedAcc.AOPS_Cust_Id__c = '123458';
        relatedAcc.AOPS_Seq_ID__c = '123458';
        relatedAcc.OwnerID = usrObj.Id;// This is the salesforce User ID
        relatedAcc.Sales_PersonID__c = s.Id; //Sales person Id for the Salesforce USer
        insert relatedAcc;
        
        Account acc = new Account ();
        acc.recordtypeId=Label.Site_GT_Record_Type;
        acc.Related_Account__c=oldRelatedAcc.id;
        acc.name = 'SUN Test Account3';
        acc.BillingStreet = '1037 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123459';
        acc.AOPS_Cust_Id__c = '123459';
        acc.AOPS_Seq_ID__c = '123459';
        acc.OwnerID = usrObj.Id;// This is the salesforce User ID
        acc.Sales_PersonID__c = s.Id; //Sales person Id for the Salesforce USer
        insert acc;
        
        List<Contact> List_Con = new List<Contact>();

        Contact Site_Primary_Contact = new Contact();
        Site_Primary_Contact.LastName='LastNametest1';
        Site_Primary_Contact.email='testemail1@test.com';
        Site_Primary_Contact.AccountId = oldRelatedAcc.id;
        Site_Primary_Contact.OMX_Primary_Key__c='123456';
        List_Con.add(Site_Primary_Contact);
        
        Contact Site_Contact2 = new Contact();
        Site_Contact2.LastName='LastNametest2';
        Site_Contact2.email='testemail2@test.com';
        Site_Contact2.AccountId = oldRelatedAcc.id;
        Site_Contact2.OMX_Primary_Key__c='123457';
        List_Con.add(Site_Contact2);
        
        Contact Site_Contact3 = new Contact();
        Site_Contact3.LastName='LastNametest3';
        Site_Contact3.email='testemail3@test.com';
        Site_Contact3.AccountId = oldRelatedAcc.id;
        Site_Contact3.OMX_Primary_Key__c='123458';
        List_Con.add(Site_Contact3);
        
        Contact Site_Contact4 = new Contact();
        Site_Contact4.LastName='LastNametest4';
        Site_Contact4.email='testemail4@test.com';
        Site_Contact4.AccountId = oldRelatedAcc.id;
        Site_Contact4.OMX_Primary_Key__c='123459';
        List_Con.add(Site_Contact4);
        
        insert List_Con;
        
        acc.Related_Account__c=relatedAcc.id;
        update acc;
        
        acc.recordtypeId=Label.Customer_GT_Record_Type;
        update acc;
        }
                
    }
    
    static testMethod void GT_SoldToChangeUnitTestChangeRT() 
    {
         System.runas(new user(ID = UserInfo.getUserID())){
                 Profile profileObj = [select id from profile where name='System Administrator'];

         String profId = profileObj.id;
         user usrObj = new user(Username='abc1234@officedepot.com.uat',FirstName ='Fname',
          LastName='Lname', Alias='abc1234', CommunityNickname='abc1234', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', 
         Profileid = profId, LanguageLocaleKey='en_US', email='abc1234@officedepot.com.uat',TimeZoneSidKey='America/New_York');
         usrObj.Short_Title__c='';
         Insert usrObj;
             system.runas(usrobj){

        Sales_Person__c s= new Sales_Person__c();
        s.IsActive__c=true;
        s.Role_Relate_Id__c ='777777';
        s.Primary__c =true;
        s.user__c=usrObj.id;
        insert s;

        Account oldRelatedAcc = new Account ();
        oldRelatedAcc.recordtypeId=Label.Site_GT_Record_Type;
        //oldRelatedAcc.Related_Account__c=acc;
        oldRelatedAcc.name = 'SUN Test Account1';
        oldRelatedAcc.BillingStreet = '1039 N 326 W';
        oldRelatedAcc.billingcity = 'Orem';
        oldRelatedAcc.BillingState = 'UT';
        oldRelatedAcc.Billingcountry = 'USA';
        oldRelatedAcc.Oracle_Party_Id__c = '123457';
        oldRelatedAcc.AOPS_Cust_Id__c = '123457';
        oldRelatedAcc.AOPS_Seq_ID__c = '123457';
        oldRelatedAcc.OwnerID = usrObj.Id;// This is the salesforce User ID
        oldRelatedAcc.Sales_PersonID__c = s.Id; //Sales person Id for the Salesforce USer
        insert oldRelatedAcc;
        
        Account relatedAcc = new Account ();
        relatedAcc.recordtypeId=Label.GT_Prospect;
        //relatedAcc.Related_Account__c=acc;
        relatedAcc.name = 'SUN Test Account2';
        relatedAcc.BillingStreet = '1038 N 326 W';
        relatedAcc.billingcity = 'Orem';
        relatedAcc.BillingState = 'UT';
        relatedAcc.Billingcountry = 'USA';
        relatedAcc.Oracle_Party_Id__c = '123458';
        relatedAcc.AOPS_Cust_Id__c = '123458';
        relatedAcc.AOPS_Seq_ID__c = '123458';
        relatedAcc.OwnerID = usrObj.Id;// This is the salesforce User ID
        relatedAcc.Sales_PersonID__c = s.Id; //Sales person Id for the Salesforce USer
        insert relatedAcc;
        
        Account acc = new Account ();
        acc.recordtypeId=Label.Site_GT_Record_Type;
        acc.Related_Account__c=oldRelatedAcc.id;
        acc.name = 'SUN Test Account3';
        acc.BillingStreet = '1037 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '123459';
        acc.AOPS_Cust_Id__c = '123459';
        acc.AOPS_Seq_ID__c = '123459';
        acc.OwnerID = usrObj.Id;// This is the salesforce User ID
        acc.Sales_PersonID__c = s.Id; //Sales person Id for the Salesforce USer
        insert acc;
        
        List<Contact> List_Con = new List<Contact>();

        Contact Site_Primary_Contact = new Contact();
        Site_Primary_Contact.LastName='LastNametest1';
        Site_Primary_Contact.email='testemail1@test.com';
        Site_Primary_Contact.AccountId = oldRelatedAcc.id;
        Site_Primary_Contact.OMX_Primary_Key__c='123456';
        List_Con.add(Site_Primary_Contact);
        
        Contact Site_Contact2 = new Contact();
        Site_Contact2.LastName='LastNametest2';
        Site_Contact2.email='testemail2@test.com';
        Site_Contact2.AccountId = oldRelatedAcc.id;
        Site_Contact2.OMX_Primary_Key__c='123457';
        List_Con.add(Site_Contact2);
        
        Contact Site_Contact3 = new Contact();
        Site_Contact3.LastName='LastNametest3';
        Site_Contact3.email='testemail3@test.com';
        Site_Contact3.AccountId = oldRelatedAcc.id;
        Site_Contact3.OMX_Primary_Key__c='123458';
        List_Con.add(Site_Contact3);
        
        Contact Site_Contact4 = new Contact();
        Site_Contact4.LastName='LastNametest4';
        Site_Contact4.email='testemail4@test.com';
        Site_Contact4.AccountId = oldRelatedAcc.id;
        Site_Contact4.OMX_Primary_Key__c='123459';
        List_Con.add(Site_Contact4);
        
        //insert List_Con;
        
        acc.Related_Account__c=relatedAcc.id;
        update acc;
        delete acc;
         }
         }
                
    }
}