@isTest
private class OMXAccountBeforeTrigger_TC{

    static testMethod void Test_OMXAccountBeforeTrigger(){
     //test.startTest();

        ID usrID = UserInfo.getUserId();
        
        Sales_Person__c s1= new Sales_Person__c();
        s1.IsActive__c=true;
        s1.Role_Relate_Id__c ='222222';
        s1.Primary__c =true;
        s1.user__c = usrID;
        insert s1;
        
         Set<Id> accountList = new Set<ID>();
         Account topAccount = new Account (name = 'GP SUN Test - Top Account',
                                 AOPS_Seq_ID__c = '123666',
                                 AOPS_Cust_Id__c = '123666',
                                 Oracle_Party_Id__c = '123666',
                                 recordtypeid=System.Label.Customer_OfficeMax,
                                 Billingcountry = 'USA',
                                 BillingState = 'UT',
                                 Ownerid=usrID,
                                 Duns_Enrichment__c = '12345', 
                                 DNBI_CREDIT_OUTCOME__c = 'Approved',
                                 BillingStreet = '1040 N 326 W',
                                 billingcity = 'Orem',
                                 OMX_Primary_Key__c = 'Test_OMX_1111', //S-367255 [12/10/2015]- Fix test class 
                                 address2__c='Address2');
         insert topAccount;
        accountList.add(topAccount.id);
        
        test.startTest();

         Account middleAccount = new Account (name = 'P SUN Test Middle Account',
                                 AOPS_Seq_ID__c = '123466',
                                 AOPS_Cust_Id__c = '123466',
                                 Oracle_Party_Id__c = '123466',
                                 Billingcountry = 'USA',
                                 BillingState = 'UT',
                                 parentid=topAccount.id,
                                 Ownerid=usrID,
                                 Duns_Enrichment__c = '12345', 
                                 DNBI_CREDIT_OUTCOME__c = 'Approved',
                                 BillingStreet = '1040 N 325 W',
                                 OMX_Primary_Key__c = 'Test_OMX_1112', //S-367255 [12/10/2015]- Fix test class 
                                 billingcity = 'Orem');
         insert middleAccount;
        accountList.add(middleAccount.id);
        
        Account lowAccount = new Account (name = 'GP SUN Test - Low Account',
                                 AOPS_Seq_ID__c = '123566',
                                 AOPS_Cust_Id__c = '125666',
                                 Oracle_Party_Id__c = '123566',
                                 recordtypeid=System.Label.Site_OfficeMax,
                                 Billingcountry = 'USA',
                                 BillingState = 'UT',
                                 Ownerid=usrID,
                                 Duns_Enrichment__c = '12345', 
                                 DNBI_CREDIT_OUTCOME__c = 'Approved',
                                 BillingStreet = '1040 N 327 W',
                                 OMX_Primary_Key__c = 'Test_OMX_1113', //S-367255 [12/10/2015]- Fix test class 
                                 billingcity = 'Orem');
         insert lowAccount;
        accountList.add(lowAccount.id);
        
        topAccount.status__c ='Inactive';
        update topAccount;
        topAccount.status__c ='Active';
        update topAccount;

        test.stopTest();
        
    }

}