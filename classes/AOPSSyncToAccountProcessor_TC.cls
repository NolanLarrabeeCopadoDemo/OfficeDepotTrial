@IsTest
public class AOPSSyncToAccountProcessor_TC {
    
    @IsTest
    static void accountData() {
        Id custRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

        User owner = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true LIMIT 1];       

        // Account without sfdc id
        Account_Final_Staging__c stagingRec1 = new Account_Final_Staging__c(AOPS_Cust_Id__c='12345678', AOPS_Seq_ID__c='00001',
                                            Name='TestAcc1', Action__c='C', Address1__c='790 E CAMPBELL AVE',  
                                            Is_Account_Master_Changed__c=true,Is_Account_Addendum_Community_Changed__c=true,Is_Account_Addendum_Legal_Changed__c=true,
                                            Is_Account_BSD_Addendum_Changed__c=true,Is_Account_OptIn_Changed__c=true,
                                            Sync_Failed__c=false);
        insert stagingRec1;
        
    }
}