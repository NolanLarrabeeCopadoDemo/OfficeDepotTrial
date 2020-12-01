@isTest
Public Class CreateParentAccount_ctrl_Test
{
    public static testmethod void CreateParentAccount()
    {
        Account acc = Test_Utils.CreateAccount();

      
        
        ApexPages.StandardController sc = new ApexPages.StandardController(acc );
          CreateParentAccount_ctrl CPA=New CreateParentAccount_ctrl(sc);
          
          Sales_Person__c  SP=New Sales_Person__c();
          SP.Name='Test Sales Person';
          SP.IsActive__c=true;
          SP.ExtIDSalesPerson__c='EC11006';
          SP.Primary__c=true;
          SP.User__c=userInfo.getUserId();
          
          
          Insert SP;
          
          CPA.Acc.Name='Test Account';
          CPA.cont.LastName='Test Contact';
          
          CPA.Submit();
        
        
    }
}