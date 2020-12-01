// October 21 2016    Jessica Schilling     S-445717, OD Case 00796577    Added assert statement
//
@isTest

private class CustTranOnDeckBatch_TC{
  static testMethod void testUnit(){
      Date d = Date.today();
      d= d-60;
    
        CustTransParentChildLevel__c PCLevel2 = new CustTransParentChildLevel__c(name='TestCust');
         PCLevel2.CustTranOnDeckBatchID__c ='60';
         insert PCLevel2;
    
    
    List<Account> insertaccList = new List<Account> ();
    List<Customer_Transition__c> insertcustList = new List<Customer_Transition__c> ();

    
    Account acc= new Account (name='Written',omx_primary_key__C = '2211');
    insertaccList.add(acc);
    Account acc1= new Account (name='Non Written',omx_primary_key__C = '1221121');
    insertaccList.add(acc1);
    insert insertaccList;
      
      Customer_Transition__c  cust = new Customer_Transition__c(name='Written',
      Account__c = acc.id,omx_primary_key__C = '2211',
            Written_Agreement__c = true, Customer_Disposition__c = 'Customer agrees to transition' , Status__c = 'Awaiting Disposition',
      Review_Start_Date__c=d);
      insertcustList.add(    cust);
     
     Customer_Transition__c cust1 = new Customer_Transition__c(Name='Non Written',
      Account__c = acc1.id, Written_agreement__c = false,      omx_primary_key__C = '1221121', 
        Status__c = 'Scheduled',Review_Start_Date__c=d);
      insertcustList.add(    cust1);
      
      insert insertcustList;
 
        
    
       test.starttest();
        String query = '';
        CustTranOnDeckBatch custTranOnDeckBatchObjNew = new CustTranOnDeckBatch(query);
        Database.executebatch(custTranOnDeckBatchObjNew, 500);   
        test.stoptest();

        //Added below 2 lines JSCHILLING S-445717, OD Case 00796577 10/21/2016 Added assert statement
        Customer_Transition__c testRecord = [SELECT Id, Status__c FROM Customer_Transition__c WHERE Id =:cust1.Id];
        System.assertEquals('On Deck', testRecord.Status__c);
      }
}