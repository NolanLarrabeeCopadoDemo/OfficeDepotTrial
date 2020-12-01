/***********************************************************************************************
Name    : LeadRepQueueAssignment_TC
VF Page : RepQueueAssignment
Created : 8/31/2015 [Hemant]
Story   : S-346407
Desc    : Test class for the class "LeadRepQueueAssignment"
***********************************************************************************************/
@isTest
private class LeadRepQueueAssignment_TC {
	
	public static Lead testLead;
	
	//test method
  static testMethod void LeadRepQueueAssignmentTest(){
  	//test with RQA record
  	String msg = LeadRepQueueAssignment.getNextLead(new String[]{''});
  	System.assertEquals(msg, LeadRepQueueAssignment.NO_REP_QUEUE_ASSIGN_RECORD_FOUND);
  	
  	
  	//create test data
    createTestData();
    
    //call getNextLead method without getting lead
    msg = LeadRepQueueAssignment.getNextLead(new String[]{''});
    System.assertEquals(msg, LeadRepQueueAssignment.NO_LEAD_FOUND);
    
    //call getNextLead method when getting lead
    LeadRepQueueAssignment.ldToBeAssigned = testLead;
    msg = LeadRepQueueAssignment.getNextLead(new String[]{''});
    System.assertEquals(msg, testLead.Id); //S-418605 [Hemant 8/10/2016] - Update message to Lead Id
  }
  
  //create Test data  
  private static void createTestData(){
    String LEAD_QUEUE_PACIFIC = 'Pacific Time Zone';
    String LEAD_QUEUE_GOVERNMENT = 'Government Leads';
    
    //insert Lead
    testLead = Test_Utils.GenerateLead('94525', 500, null, 'LName1', false);
    
    for(QueueSobject ldQueue : [Select Id, QueueId from QueueSobject
                        where SobjectType = 'Lead'
                        AND Queue.Name =: LEAD_QUEUE_PACIFIC limit 1]){
      testLead.OwnerId = ldQueue.QueueId;
    }
    insert testLead;
        
    //insert RQA
    List<Rep_Queue_Assignment__c> rqaLst = new List<Rep_Queue_Assignment__c>();
    rqaLst.add(new Rep_Queue_Assignment__c(Sales_Rep__c = UserInfo.getUserId(), Priority__c = '1', Queue_Name__c = LEAD_QUEUE_PACIFIC));
    rqaLst.add(new Rep_Queue_Assignment__c(Sales_Rep__c = UserInfo.getUserId(), Priority__c = '3', Queue_Name__c = LEAD_QUEUE_GOVERNMENT));
    insert rqaLst;
    System.assertNotEquals(rqaLst.get(0), null);
  }

  //test method
  static testMethod void LeadRepQueueAssignmentTest2(){
  	//test with RQA record
  	String msg = LeadRepQueueAssignment.getNextLeadLightning();
  	System.assertEquals(msg, LeadRepQueueAssignment.NO_REP_QUEUE_ASSIGN_RECORD_FOUND);
  	
  	
  	//create test data
    createTestData();
    
    //call getNextLead method without getting lead
    msg = LeadRepQueueAssignment.getNextLeadLightning();
    System.assertEquals(msg, LeadRepQueueAssignment.NO_LEAD_FOUND);
    
    //call getNextLead method when getting lead
    LeadRepQueueAssignment.ldToBeAssigned = testLead;
    msg = LeadRepQueueAssignment.getNextLeadLightning();
    System.assertEquals(msg, testLead.Id); 
  }
    
}