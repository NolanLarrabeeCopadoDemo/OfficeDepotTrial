@isTest
public class TC_OMXAccountBeforeTrigger {
    static testMethod void Test_OMXAccountBeforeTrigger(){
        test.startTest();
        
        Address_Abbreviation__c addressAbb = new Address_Abbreviation__c(name='ILLINOIS',Abbreviation__c='IL');
        insert addressAbb;
        ID usrID = UserInfo.getUserId();
        Dataloader_User__c dataloaderUser = new Dataloader_User__c(name='Dataloader',User_ID__c='005E0000000R7xz');
        insert dataloaderUser;
        
   
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
                                          address2__c='8351 United States, 8207 Niaga');
        insert topAccount;     
        topAccount.status__c ='Active';
        topAccount.recordtypeid = System.Label.Customer;      
        update topAccount;
        
        test.stopTest();
    }
}