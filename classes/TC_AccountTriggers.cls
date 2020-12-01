@isTest
public class TC_AccountTriggers {
    
    static testMethod void testAccountTriggers(){
        test.startTest();
        
        Dataloader_User__c dataloaderUser = new Dataloader_User__c(name='Dataloader',User_ID__c=UserInfo.getUserId().substring(0,15));
        insert dataloaderUser;
        
        Id rtId = [SELECT Id, Name, SobjectType, DeveloperName FROM RecordType where SobjectType='Account' and DeveloperName='GrandParent'].id;
        ID usrID = UserInfo.getUserId();
        
        Sales_Person__c s1= new Sales_Person__c();
        s1.IsActive__c=true;
        s1.Role_Relate_Id__c ='222222';
        s1.Primary__c =true;
        s1.user__c = usrID;
        insert s1;
        Sales_Person__c s2= new Sales_Person__c();
        s2.IsActive__c=true;
        s2.Role_Relate_Id__c ='333333';
        s2.Primary__c =true;
        s2.user__c = usrID;
        insert s2;
        
        Profile p = [SELECT Id FROM profile WHERE name='System Administrator'];   
        User u = new User(alias = 'test123 ', email='proxy@proxy456.officedepot.com',OD_Employee_ID__c='123466',emailencodingkey='UTF-8', lastname='test123',languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id,timezonesidkey='America/Los_Angeles',username='proxy@proxy456.com',isactive=true);
        insert u; 
        DNBI_Credentials__c dnbi = new DNBI_Credentials__c(Name = 'Test123',DnB_Active__c= true);
        insert dnbi;
        Account topAccount = new Account (name = 'GP SUN Test - Top Account',
                                          AOPS_Seq_ID__c = '942114',
                                          AOPS_Cust_Id__c = '942114',
                                          Oracle_Party_Id__c = '942114',
                                          recordtypeid=rtId,
                                          Billingcountry = 'USA',
                                          BillingState = 'UT',
                                          Ownerid=usrID,
                                          Duns_Enrichment__c = '12345', 
                                          DNBI_CREDIT_OUTCOME__c = 'Approved',
                                          BillingStreet = '1040 N 326 W',
                                          billingcity = 'Orem',
                                          OMX_Primary_Key__c = 'Test_OMX_1111', //S-367255 [12/10/2015]- Fix test class 
                                          address2__c='8351 United States, 8207 Niaga',
                                          Sales_PersonID__c = s1.id);
        insert topAccount;    
        Account topAccount1 = new Account (name = 'GP SUN Test - Top Account',
                                           AOPS_Seq_ID__c = '94211411',
                                           AOPS_Cust_Id__c = '94211411',
                                           Oracle_Party_Id__c = '94211411',
                                           recordtypeid=rtId,
                                           Billingcountry = 'USA',
                                           BillingState = 'UT',
                                           Ownerid=usrID,
                                           Duns_Enrichment__c = '12345', 
                                           DNBI_CREDIT_OUTCOME__c = 'Approved',
                                           BillingStreet = '1040 N 326 W',
                                           billingcity = 'Orem',
                                           OMX_Primary_Key__c = 'Test_OMX_11111', //S-367255 [12/10/2015]- Fix test class 
                                           address2__c='8351 United States, 8207 Niaga',
                                           Sales_PersonID__c = s1.id,
                                           status__c ='Inactive');
        insert topAccount1;
        topAccount1.Sales_PersonID__c = s2.id;
        topAccount1.status__c ='Active';
        topAccount1.Implementation_Manager__c= u.id;
        topAccount1.Duns_Enrichment__c = '';
        topAccount1.DNBI_CREDIT_OUTCOME__c = '';
        topAccount1.address2__c =  '1234 United States, 3456 Niaga';
        update topAccount1;
        test.stopTest();
    }
    
    static testMethod void testAccountTriggers2(){
        test.startTest();
        DNBI_Credentials__c dnbi = new DNBI_Credentials__c(Name = 'Test123',DnB_Active__c= true);
        insert dnbi;
        Id ProspectRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        Account topAccount = new Account (name = 'GP SUN Test - Top Account',
                                          AOPS_Seq_ID__c = '942114',
                                          AOPS_Cust_Id__c = '942114',
                                          Oracle_Party_Id__c = '942114',
                                          recordtypeid=ProspectRecordTypeID,
                                          Billingcountry = 'USA',
                                          BillingState = 'UT',
                                          Duns_Enrichment__c = '12345', 
                                          DNBI_CREDIT_OUTCOME__c = 'Approved',
                                          BillingStreet = '1040 N 326 W',
                                          billingcity = 'Orem',
                                          OMX_Primary_Key__c = 'Test_OMX_1111', //S-367255 [12/10/2015]- Fix test class 
                                          address2__c='8351 United States, 8207 Niaga'
                                         );
        insert topAccount;
        topAccount.Address2__c = 'Test';
        update topAccount;
        test.stopTest();
    }
    static testMethod void testUpdateAOPSAssignedOnRecordTypeChange(){
        test.startTest();
        Dataloader_User__c dataloaderUser = new Dataloader_User__c(name='Dataloader',User_ID__c=UserInfo.getUserId().substring(0,15));
        insert dataloaderUser;
        ID usrID = UserInfo.getUserId();
        
        Account topAccount = new Account (name = 'GP SUN Test - Top Account',
                                          AOPS_Seq_ID__c = '942114',
                                          AOPS_Cust_Id__c = '942114',
                                          Oracle_Party_Id__c = '942114',
                                          Billingcountry = 'USA',
                                          BillingState = 'UT',
                                          Ownerid=usrID,
                                          Duns_Enrichment__c = '12345', 
                                          DNBI_CREDIT_OUTCOME__c = 'Approved',
                                          BillingStreet = '1040 N 326 W',
                                          billingcity = 'Orem',
                                          OMX_Primary_Key__c = 'Test_OMX_1111', //S-367255 [12/10/2015]- Fix test class 
                                          address2__c='8351 United States, 8207 Niaga',
                                          recordtypeId = '012E000000092k3'
                                         );
        insert topAccount;    
        Account acc = [select id,recordtypeId from Account where id =:topAccount.id];
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        update acc;
        test.stopTest();
    }
    
}