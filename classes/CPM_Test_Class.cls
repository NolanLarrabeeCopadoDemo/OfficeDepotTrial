//
// 8/10/2016 Jessica Schilling Case 175803 Fixed test class failures
//
@isTest
private class CPM_Test_Class {
  static testMethod void Test_Info(){
      Date d = Date.today();
      Id CaseRecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Work Request').getRecordTypeId();
     User CPMu = New USer(Username = 'Test_27@officedepot.com', 
                           LastName = 'Test_27', 
                           Email = 'Test_27@officedepot.com', 
                           Alias= 'Test_27', 
                           CommunityNickname = 'CPMTest_User_27', 
                           LocaleSidKey = 'en_US', 
                           LanguageLocaleKey = 'en_US',
                           ProfileId = '00eE0000000IALGIA4',
                           EmployeeNumber='000027');
      insert CPMu; 
      
    Account CPMa = new Account(Name='CPM_Test_27');
        insert CPMa;
      
    Case CPMc = New Case( Accountid = CPMa.id,
                                        Reason = 'WRF Request', 
                                        Priority = '3-Medium', 
                                        Status = 'Open',
                                        Approved_for_Analyst_Assignment__c = TRUE,
                                        RecordTypeId = CaseRecordTypeID,  //Work Request 
                                        WRF_Request_Type__c = 'Transition', 
                                        CPM_Required__c = TRUE, 
                                        WRF_Finance__c = FALSE, 
                                        WRF_Requestor__c = CPMa.OwnerId);
        //START JSCHILLING Case 175803 8/09/2016
        //Moved start and stop of test here to fix test class failure
        Test.StartTest();
        insert CPMc;
        Test.StopTest();
        //END JSCHILLING Case 175803 8/09/2016
      
    CPM__c CPM11 = New CPM__C(Name='CPM_4_CPM_Test_27_s1v1', 
                              Account_Name__C = CPMa.id,
                              Pricing_Analyst__c = CPMu.id,
                              Support_Number__c = CPMc.id, 
                              District_Sales_Manager__c = CPMu.id,
                              Finance__C = true,
                              Scenario__c = 1, 
                              Version__c = 1, 
                              Approval_status__c = 'Pending',
                              Next_ApproverId__c = CPMu.id );
        insert CPM11;

		/*if([select count() from ProcessInstance where targetobjectid=:CPMa.id] < 1)
        	{ 
        		Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();           
            	req1.setObjectId(CPM11.id);
        		Approval.ProcessResult result = Approval.process(req1);
            }*/
      
    //Modified the below line JSCHILLING Case 175803 8/10/2016 Moved start and stop of test to fix test class failure
    //Test.startTest();
    CPM__c CPM12 = New CPM__C(Name='CPM_4_CPM_Test_27_s1v2', 
                              Account_Name__C = CPMa.id, 
                              Finance__C = false, 
                              Support_Number__c = CPMc.id, 
                              Scenario__c = 1, 
                              Version__c = 2, 
                              Next_ApproverId__c = CPMu.id,
                              Pricing_Analyst__c = CPMu.id);
        insert CPM12;  
    CPM12.Send_Reminder__c = true;
      Update CPM12;
      
         //Modified the below line JSCHILLING Case 175803 8/10/2016 Moved start and stop of test to fix test class failure
         //Test.stopTest();

         
  } 
}