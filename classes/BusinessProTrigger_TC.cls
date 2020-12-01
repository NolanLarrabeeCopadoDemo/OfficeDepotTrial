@IsTest
public class BusinessProTrigger_TC
{
    static testMethod void businessProTriggerTest() 
    {
        Recordtype rcrdTypeObj = [select id from recordtype where recordtype.name = 'Customer (Business Pro)' limit 1];

        //Profile prfleObj = [SELECT Id FROM Profile WHERE Name='Business Pro Rep'];

        User usrObj = [select id from user where name = 'Dataloader' limit 1];
        System.runAs (usrObj)
        { 
            Sales_Person__c slsPrsnObj = new Sales_Person__c();
            slsPrsnObj.IsActive__c = true;
            slsPrsnObj.Primary__c = true;
            slsPrsnObj.User__c = usrObj.id;
            insert slsPrsnObj;

            Account acc = new Account ();
            acc.recordtypeId=rcrdTypeObj.id;
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
            acc.Loyatly_Number__c='11223';
            insert acc;

            Contact conObj = new Contact();
            conObj.LastName='LastName BusinessPro';
            conObj.email='testemail11@test.com';
            conObj.OMX_Primary_Key__c='123456';
            conObj.Loyalty_Number__c='11223';
            conObj.Primary_Contact__c=true;
            insert conObj;
        }
    }
    

}