@IsTest
public class AOPSSyncToSiteProcessor_TC {
    
    @IsTest
    static void newSiteContact() {
        Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        //ExecuteOnceTest.OnceProspectMsg = false;
        User owner          = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];
        //RecordType rtCust   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Customer'];
        Account acc             = new Account(Name='TestAcc1', OwnerId=owner.Id, RecordtypeId=custRecordTypeId, Aops_Cust_Id__c='12345678');
        insert acc;
        
        RecordType rtSite   = [SELECT Id FROM RecordType WHERE sObjectType = 'Account' AND Name = 'Site'];
        Account siteAcc1    = new Account(Name='Siteacc1', OwnerId=owner.Id, RecordtypeId=rtSite.Id, related_Account__c=acc.id, aops_seq_id__c='12345678-00001');
      	insert siteAcc1;

        // Site with sfdc id
        Account_Site_Final_Staging__c stagingRec1 = new Account_Site_Final_Staging__c(AOPS_Cust_Id__c='12345678', AOPS_Seq_ID__c='12345678-00001',
                                            Account_Name__c='TestAcc1', Action__c='C', Address1__c='790 E CAMPBELL AVE', Address_Key__c='CA419', 
                                            Is_Address_Master_Changed__c=true,Is_Address_Addendum_Changed__c=true,
                                            CXTF001P_SFDC_KEY1__c=siteAcc1.id,Sync_Failed__c=false);
        insert stagingRec1;
        
        // Site without sfdc id
        Account_Site_Final_Staging__c stagingRec2 = new Account_Site_Final_Staging__c(AOPS_Cust_Id__c='12345678', AOPS_Seq_ID__c='12345678-00002',
                                            Account_Name__c='TestAcc1', Action__c='C', Address1__c='790 E CAMPBELL AVE', Address_Key__c='CA419', 
											Is_Address_Master_Changed__c=true,Is_Address_Addendum_Changed__c=true,
                                            Sync_Failed__c=false);
        insert stagingRec2;
        
        // Site without sfdc id and address master flag not changed but other flags changed.
        Account_Site_Final_Staging__c stagingRec22 = new Account_Site_Final_Staging__c(Id=stagingRec2.Id,AOPS_Cust_Id__c='12345678', AOPS_Seq_ID__c='12345678-00002',
                                            Account_Name__c='TestAcc1', Action__c='C', Address1__c='790 E CAMPBELL AVE', Address_Key__c='CA419', 
                                            Is_Address_Master_Changed__c=false,Is_Address_Addendum_Changed__c=true, Sync_Failed__c=false);
        update stagingRec22;
        
        // Account does not exist so cannot create site.
        Account_Site_Final_Staging__c stagingRec3 = new Account_Site_Final_Staging__c(AOPS_Cust_Id__c='1234567', AOPS_Seq_ID__c='1234567-00003',
                                            Account_Name__c='TestAcc1', Action__c='C', Address1__c='790 E CAMPBELL AVE', Address_Key__c='CA419', Is_Address_Master_Changed__c=true,
                                            Sync_Failed__c=false);
        insert stagingRec3;
        
        // Delete
        Account_Site_Final_Staging__c stagingRec4 = new Account_Site_Final_Staging__c(Id=stagingRec2.Id,AOPS_Cust_Id__c='12345678', AOPS_Seq_ID__c='12345678-00002',
                                            Account_Name__c='TestAcc1', Action__c='D', Address1__c='790 E CAMPBELL AVE', Address_Key__c='CA419', Is_Address_Master_Changed__c=true,
                                            Sync_Failed__c=false);
        update stagingRec4;
    }
}