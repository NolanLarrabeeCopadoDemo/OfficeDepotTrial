global class DeleteAllAssignmentRules implements Database.Batchable<SObject> {

  global Database.QueryLocator start(Database.BatchableContext c) {     
    return Database.getQueryLocator('SELECT id FROM Assignment_rule__c');
  }
  
  global void execute(Database.BatchableContext c, List<Sobject> objects) {     
    List<Assignment_rule__c> listToDelete = new List<Assignment_rule__c>();
    for (SObject s : objects) {
      listToDelete.add((Assignment_rule__c)s);
    }    
    delete listToDelete;
  }
  
  global void finish(Database.BatchableContext c) {     
  }
  
  
  @isTest
  // To test assignment rules deletion
  private static void DeleteAllAssignmentRules() {
    Test.startTest();
    
    List<Assignment_rule__c> assignmentRuleList = new List<Assignment_rule__c> ();
    Schema.DescribeSObjectResult d1 = Schema.SObjectType.Assignment_Rule__c; 
    Map<String,Schema.RecordTypeInfo> AssRuleRecType = d1.getRecordTypeInfosByName();
    // Insert 5 assignment rules
    for (Integer i = 0; i<5; i++){
        Assignment_Rule__c assignmentRule = new Assignment_Rule__c( WCW_count__c = '50to99' ,   Industry_Group__c = 'other' , Access_ID__c ='test'+i,recordtypeid=AssRuleRecType.get('Zip Tracker').getRecordTypeId());      
        assignmentRuleList.add(assignmentRule);
    }
    insert assignmentRuleList;
    
    // Verify that 5 assignment rules inserted
    List<Assignment_rule__c> assignmentRuleListBeforeDelete = [SELECT id FROM Assignment_rule__c];
    System.assertEquals(assignmentRuleListBeforeDelete.size(), 5);
    
    DeleteAllAssignmentRules deleteAllAssignmentRule = new DeleteAllAssignmentRules(); 
    ID batchprocessid = Database.executeBatch(deleteAllAssignmentRule);
    Test.stopTest();
    // Verify that after deletion all 5 assignment rules are deleted
    List<Assignment_rule__c> assignmentRuleListAfterDelete = [SELECT id FROM Assignment_rule__c];
    System.assertEquals(assignmentRuleListAfterDelete.size(), 0);   
  }

}