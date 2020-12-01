@isTest
private class GT_DelRelContactOnAccountChange_TC 
{

    static testMethod void GT_DelRelContactOnAccountChangeUnitTest() 
    {
    RecordType rtSiteGT= [select Id from recordtype where name='Site (GT)' limit 1];
    
    Account acc1 = new Account();
    acc1.Name='Test';
    acc1.AOPS_Cust_Id__c ='123456';
    acc1.OMX_Primary_Key__c='654321';
    insert acc1;
    
    Account acc2 = new Account();
    acc2.Name='Test';
    acc2.AOPS_Cust_Id__c ='123458';
    acc2.OMX_Primary_Key__c='654323';
    insert acc2;
    
    Contact con1 = new Contact();
    con1.FirstName='FirstNametest';
    con1.LastName='LastNametest';
    con1.email='testemail@test.com';
    con1.AccountId = acc1.id;
    con1.OMX_Primary_Key__c='1234';
    con1.recordTypeId = Label.Contact_record_type_18;
    insert con1;

    Account site1 = new Account();
    site1.Name='Test';
    site1.AOPS_Cust_Id__c ='123457';
    site1.OMX_Primary_Key__c='654322';
    site1.Related_Account__c=acc1.id;
    site1.recordTypeid = rtSiteGT.id;
    site1.Site_Contact2__c = con1.id;
    site1.Site_Contact3__c = con1.id;
    site1.Site_Contact4__c = con1.id;
    site1.Site_Contact5__c = con1.id;
    site1.Site_Contact6__c = con1.id;
    site1.Site_Primary_Contact__c = con1.id;
    insert site1;
    
  
    Account site2 = new Account();
    site2.Name='Test';
    site2.AOPS_Cust_Id__c ='123459';
    site2.OMX_Primary_Key__c='654324';
    site2.Related_Account__c=acc2.id;
    site2.recordTypeid = rtSiteGT.id;
    //site2.Site_Contact2__c = con1.id;
    //site2.Site_Contact3__c = con1.id;
   // site2.Site_Contact4__c = con1.id;
    //site2.Site_Contact5__c = con1.id;
   // site2.Site_Contact6__c = con1.id;
   // site2.Site_Primary_Contact__c = con1.id;
    insert site2;
    
    con1.AccountId = acc2.id;
    update con1;
    
    
    }
}