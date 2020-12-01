/*************************************************************
*Name             : Account_PrimarySite_Update_Batch_Test
*Created By       : Naga 
*Created Date     : 29th Dec,2017
*Purpose          : Account_PrimarySite_Update_Batch_Test class to test Account_PrimarySite_Update_Batch class to update primary account to true 
                    and non primary account to false.
*Modification log : 
                  : 
****************************************************************/
@isTest
public class Account_PrimarySite_Update_Batch_Test {
    public static testMethod void testPrimaryAccountToTrue() 
    {
    
        CustTransParentChildLevel__c  CustParentChild = new CustTransParentChildLevel__c(name='test1',
                                                             Parent_Child_Level__c= 'Parent',
                                                             AddSeconds__c=300,
                                                             AddHours__c=1);
         insert CustParentChild; 

       String  accSiteRecId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.recordTypeId = accSiteRecId;
        acc.Primary_Site__c = false;
        acc.AOPS_Seq_ID__c  = '02581234-00001';
        
        Test.StartTest();
        insert acc;
        Account_PrimarySite_Update_Batch_One sh1 = new Account_PrimarySite_Update_Batch_One();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Update Non Primary Account to true', sch, sh1); 
        Test.stopTest();

    }
    public static testMethod void testNonPrimaryAccountToFalse() 
    {
    
                CustTransParentChildLevel__c  CustParentChild = new CustTransParentChildLevel__c(name='test1',
                                                             Parent_Child_Level__c= 'Parent',
                                                             AddSeconds__c=300,
                                                             AddHours__c=1);
         insert CustParentChild; 

       String  accSiteRecId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.recordTypeId = accSiteRecId;
        acc.Primary_Site__c = true;
        acc.AOPS_Seq_ID__c  = '02581234-00002';
        
        Test.StartTest();
        insert acc;
        Account_PrimarySite_Update_Batch_Two sh1 = new Account_PrimarySite_Update_Batch_Two();
        String sch = '0 0 23 * * ?'; 
        system.schedule('Update Non Primary Account to False', sch, sh1); 
        Test.stopTest();

    }
}