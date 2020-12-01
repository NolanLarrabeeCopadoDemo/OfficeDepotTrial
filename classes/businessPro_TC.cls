@IsTest
public class businessPro_TC
{
    static testMethod void businessProInfoTest() 
    {
        Recordtype rtype = [select id from recordtype where recordtype.name = 'Customer (Business Pro)' limit 1];
        Profile prfleObj = [SELECT Id FROM Profile WHERE Name='Business Pro Rep'];
        
        User usrObj = new User();
        usrObj.Alias = 'standt';
        usrObj.Email='test@Officedepot.com';
        usrObj.EmailEncodingKey='UTF-8';
        usrObj.LastName='Testing';
        usrObj.LanguageLocaleKey='en_US';
        usrObj.LocaleSidKey='en_US';
        usrObj.ProfileId = prfleObj.Id;
        usrObj.TimeZoneSidKey='America/Los_Angeles';
        usrObj.UserName='sdss3211@test.com';
        insert usrObj;
        
        Sales_Person__c slsPrsnObj = new Sales_Person__c();
        slsPrsnObj.IsActive__c = true;
        slsPrsnObj.Primary__c = true;
        slsPrsnObj.User__c = usrObj.id;
        insert slsPrsnObj;
        
        Account acc = new Account ();
        acc.recordtypeId=rtype.id;
        acc.name = 'SUN Test Account1';
        acc.BillingStreet = '1039 N 326 W';
        acc.billingcity = 'Orem';
        acc.BillingState = 'UT';
        acc.Billingcountry = 'USA';
        acc.Oracle_Party_Id__c = '09856';
        acc.AOPS_Cust_Id__c = '09856';
        acc.AOPS_Seq_ID__c = '09856';
        acc.OwnerID = usrObj.id;
        acc.Sales_PersonID__c = slsPrsnObj.id;
        acc.Loyatly_Number__c='12304';
        insert acc;

       /* Contact Site_Primary_Contact = new Contact();
        Site_Primary_Contact.LastName='LastNametest1';
        Site_Primary_Contact.email='testemail1@test.com';
        Site_Primary_Contact.AccountId = acc.id;
        Site_Primary_Contact.OMX_Primary_Key__c='123456';
        insert Site_Primary_Contact;

    
        
        business_pro_owner__c busProOwnerObj = new business_pro_owner__c();
        busProOwnerObj.isCurrent__C = true;
        busProOwnerObj.BusinessPro__C = usrObj.id;
        busProOwnerObj.account__c = acc.id;
        busProOwnerObj.Start_Date__c = system.today();//Date.newInstance(2015, 12, 12);
        insert busProOwnerObj;*/
        
    }
   
    
}