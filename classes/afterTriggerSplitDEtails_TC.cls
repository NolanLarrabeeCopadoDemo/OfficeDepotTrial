@isTest
public class afterTriggerSplitDEtails_TC
{
    static testMethod void afterTriggerSplitDEtails_Test() 
    {
    
    Account acc = new Account(Name='Test_Acc',OMX_Primary_Key__c='123458');
    
      Id SiteOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site (OfficeMax)').getRecordTypeId();
    insert acc;
    Account site = new Account(Name='Test_Acc',OMX_Primary_Key__c='123456',recordtypeid=SiteOMX,Related_Account__c=acc.id);
    
    insert site;
    Customer_Transition__c ctRec = new Customer_Transition__c(name='Customer Transition of Test_Acc', 
         Account__c = acc.id, Cascade_down__c = true,OMX_Primary_Key__c='123458' );
    insert ctRec;
    Split_Account_Detail__c eachCTdtls = new Split_Account_Detail__c();
    eachCTdtls.status__c='';
    eachCTdtls.Master_Account__c ='123458-01';
    eachCTdtls.Customer_Transition__c =ctRec.id;
    eachCTdtls.AP_CONTACT_FIRST_NAME__c ='First';
    eachCTdtls.AP_CONTACT_LAST_NAME__c ='Last';
    eachCTdtls.NEW_BILLING_TYPE_AT_HEADER_LEVEL__c ='Di';
    eachCTdtls.Original_Account__c = acc.id;
    eachCTdtls.AP_CONTACT_TELEPHONE__c ='12345698789';
    eachCTdtls.NEW_BILL_TO_OMX_CONSIGNEE__c = '123456';
    eachCTdtls.NEW_MAIN_ACCT_ADDRESS__c = '123456';
    eachCTdtls.Main_Account_Name__c ='New Name';
    
    
    insert eachCTdtls;
    eachCTdtls.Master_Account__c ='123458';
    eachCTdtls.status__c='Uploaded';
    update eachCTdtls;
    }
}