@isTest
private class Accountassignmnet_primaryclass_TC 
{
    // Method update by Rahul for story - S-389134
    static testMethod void myUnitTest() 
    {   Account acc2 = Test_Utils.CreateAccount('Customer (OfficeMax)');
        insert acc2; // inserting account
        Account acc = Test_Utils.CreateAccount();
        acc.OMX_primary_key__c  = String.valueOf(acc2.Id).subString(0,14);
        acc.Related_Account__c = acc2.Id;
        update acc; // update account
        AccountAssignments__c assign1 = Test_Utils.createAccountAssignments(acc,'t','E','open',String.valueOf(acc2.Id).subString(0,14),true); // insert Account assignment
        list<AccountAssignments__c> accAssignments = new list<AccountAssignments__c>();
        accAssignments.add(assign1); 
        Test.StartTest();
        list<AccountAssignments__c> accAss = Accountassignmnet_primaryclass.cloneupsert(accAssignments); // method calling of class 
        System.assertEquals(accAss[0].AccountType__c,'A');
        System.assertEquals(accAss[0].Account__c,null);
        Test.StopTest();
    }
}