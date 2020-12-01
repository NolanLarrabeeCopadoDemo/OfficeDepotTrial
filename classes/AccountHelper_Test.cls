/**@@
#CLASS NAME  :  AccountHelper_Test
#DESCRIPTION :  This class is test AccountHelper
#MODIFIEDDDATE :  28-07-2020 (DD-MM-YYYY) 
#Auther: Sandesh Ganjare
@@**/
@isTest
public class AccountHelper_Test{
    @testSetup
    public static void dataSetup(){
        Id grandParentRecordTypeId      = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
        Id greatGrandParentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Great Grandparent').getRecordTypeId();
        Id parentRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Id customerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        
        List<Account> GGP_Account_List = DataFactory.createAccountTestRecords('Account',4,'');
        GGP_Account_List[0].RecordTypeId = greatGrandParentRecordTypeId;
        GGP_Account_List[0].Current_GPO__c = true;        
        
        GGP_Account_List[1].ParentId = GGP_Account_List[0].Id;       
        GGP_Account_List[1].RecordTypeId = grandParentRecordTypeId;
        
        GGP_Account_List[2].ParentId = GGP_Account_List[1].Id;       
        GGP_Account_List[2].RecordTypeId = parentRecordTypeId;
        
        GGP_Account_List[3].ParentId = GGP_Account_List[2].Id;
        GGP_Account_List[3].RecordTypeId = customerRecordTypeId;
        
        UPDATE GGP_Account_List;            
    }
    
    @isTest
    public static void Populate_GPO_Test() {        
        Id grandRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();     
        List<Account> Account_List = [Select Id,Current_GPO__c,Parent.Current_GPO__c from Account Where RecordTypeId =:grandRecordTypeId LIMIT 10];        
        
        Test.StartTest();       
            AccountHelper.populate_GPO_Flag(Account_List);        
        Test.StopTest();
        
        List<Account> GP_Account_List = [Select Id,Current_GPO__c from Account Where RecordTypeId = :grandRecordTypeId ];
        System.assertEquals(true, GP_Account_List[0].Current_GPO__c);
    }
}