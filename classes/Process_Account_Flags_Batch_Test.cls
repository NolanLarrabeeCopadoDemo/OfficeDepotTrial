/**@@
#CLASS NAME  :  Process_Account_Flags_Batch_Test
#DESCRIPTION :  This class is test class for Process_Account_Flags_Batch,Process_Account_Parent_Flags_Batch, Process_Account_Customer_Flags_Batch
#MODIFIEDDDATE :  28-07-2020 (DD-MM-YYYY) 
#Auther: Sandesh Ganjare
@@**/
@isTest(SeeAllData=false)
public class Process_Account_Flags_Batch_Test{
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
    public static void Populate_GPO_Test(){
        
        Test.startTest();
    
         Process_Account_Flags_Batch obj = new Process_Account_Flags_Batch();   
         String chron = '0 0 0 ? * * *';        
         String jobid = System.schedule('testScheduledApex', chron, obj); 
         CronTrigger ct = [Select id , CronExpression from CronTrigger where id = :jobId];
         System.assertEquals(chron,ct.CronExpression);       
        Test.stopTest();
        
        
         
    }
}