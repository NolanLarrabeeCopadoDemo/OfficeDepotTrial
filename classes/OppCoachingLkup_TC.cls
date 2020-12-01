@isTest
private class OppCoachingLkup_TC {
    static User testUser;
	private static testMethod void test() {
       testUser = Test_Utils.createTestUser('test11','999654');
       System.RunAs(testUser){
         RecordType r=[select id from recordType where sobjecttype='Opportunity' and developerName='Field_Sales_US'];
         
          Account A2 = new Account();
          A2.Name='Test';
          A2.AOPS_Cust_Id__c ='123';
          A2.OMX_Primary_Key__c='2719';
          A2.AOPS_Seq_ID__c ='123';
          insert A2;
         
         Opportunity op = new Opportunity(
               AccountId=A2.id,
               recordtypeid=r.id,
               status__c='Open',
               Name = 'OppTest1',
               CloseDate = date.parse('12/27/2030'),
               StageName = 'Verbal Win'
             );
             
         insert op;
         
         coaching__c c= new coaching__c(
              Sales_Rep__c=testUser.id 
             );
         
         insert c;
        
        Test.startTest();
        SchedulableContext sc = null;
        OppCoachingLkup clkup = new OppCoachingLkup();
        clkup.execute(sc);       
        Test.stopTest();
        OppCoachingLkup lkup2 = new OppCoachingLkup('select id from opportunity');
        OppCoachingLkup lkup3 = new OppCoachingLkup('');
       }
	}

}