// Appirio 2015 
// Universal trigger handler for Customer_Transition__c object
//
// NBOCK - Original - 7.15.2015 - S-335210

@istest
private class customerTransitionTriggerHandler_Test {
    static testMethod void testTrigger() {
        //create account
        Account acc = new Account();
        acc.Name ='Test Account';
        insert acc;
        
        //create case
        Case c = new Case();
        insert c;

        //create customer transition record
        Customer_Transition__c ct = new Customer_Transition__c();
        ct.name = 'testing CustomerTransition';
        ct.Account__c = acc.id;
        ct.Status__c = 'On Deck';
        ct.Related_WRF_Case__c = c.Id;

        Test.startTest();
            insert ct;
            Case updatedCase = [SELECT Id, Approved_for_Analyst_Assignment__c FROM Case WHERE Id = :c.Id LIMIT 1];
        Test.stopTest();

        //System.assert([SELECT Id, Approved_for_Analyst_Assignment__c FROM Case WHERE Id = :c.Id].Approved_for_Analyst_Assignment__c);
    }
    
    //START OD Case # 00678706 (S-407207) - [Hemant 5/6/2016]
    //test method for trigger CustomerTransition_Retrigger_Mod5 on Customer_Transition__c
    static testMethod void CustomerTransition_Retrigger_Mod5Test() {
        
      Account acc = Test_Utils.CreateAccount('Prospect');
      acc.OMX_Primary_Key__c = 'OMX003';
      insert acc; 
    System.assertNotEquals(acc.Id, null);
    
      Customer_Transition__c ct = Test_Utils.CreateCustomerTransaction(true, acc);
      
      Split_Account_Detail__c  sad = Test_Utils.createSplitAccount(false, ct, acc);
      
      Split_Account_Detail__c sad1 = Test_Utils.createSplitAccount(false, ct, acc);
      sad1.status__c = 'Error';
    
      insert new List<Split_Account_Detail__c>{sad, sad1};
      
      ct.Retrigger_Mod_5__c = true;
      update ct;
      
      //for add error msg
      ct.Ready_for_Mod1__c = true;
      try{
        update ct;
      }catch(Exception e){}
      
    }
    //END OD Case # 00678706 (S-407207)
}