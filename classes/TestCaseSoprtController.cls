public with sharing class TestCaseSoprtController {


 public String testCaseid ;
 public list<cRecord> oCRecord{get;set;}
 public list<TestCaseStep__c> l1{get;set;}
   
 public case vv {get;set;}
    public TestCaseSoprtController(ApexPages.StandardController controller) {
    
    vv = new Case();
    vv.IT_Classification__c = 'Issue';
    vv.IT_Environment__C= 'Test';
    vv.IT_Track__C= 'Sprint';
    vv.Support_Type__c = 'Salesforce.com';
    vv.Support_Sub_Type__c = 'Issue';
    vv.IT_Sprint_Numb__c = 'Current Sprint';
    vv.recordtypeid='012E00000008dWdIAI';
    vv.Origin='Internal';
    
    vv.Move_to_IT_Queue__c = true;
    vv.Moved_To_IT_Queue__c = DateTime.now();
    vv.Dummy_Date_IT_Queue__c = DateTime.now();
    vv.Dummy_Age_In_Number__c = 0;
    
 String testCaseid1  = ApexPages.currentPage().getParameters().get('pid');

    if(testCaseid1 != null && testCaseid1 != '' )
        testCaseid = testCaseid1 ;
    }
 
  public PageReference onsave()
  {

      TestCaseStep__c ss= [SELECT ID, Test_Case__c,Test_Case__r.Support_Case__c,Test_Case__r.Support_Case__r.casenumber,Test_Case__r.Support_Case__r.Subject ,Test_Case__r.Support_Case__r.Description from TestCaseStep__c where id= :testCaseid ];
      system.debug('Parent Case>>>>>'+ss.Test_Case__r.Support_Case__c); 
      vv.Parentid = ss.Test_Case__r.Support_Case__c;  //As per Case # 00170161
      insert vv;

      ss.Support__c= vv.id;
      update ss;
      
      system.debug('casenumber>>>>>>'+vv.Parent.casenumber+'Subject>>>>>>'+vv.Parent.Subject +'Description>>>>>>>'+vv.Parent.Description);
        CaseComment cc = new CaseComment();
        cc.CommentBody='Defect Case Created for : ' + ' \r\n'
            +'Parent Case # : '+ ss.Test_Case__r.Support_Case__r.casenumber + ' \r\n'
            +'Parent Case Subject : '+ ss.Test_Case__r.Support_Case__r.Subject+ ' \r\n'
            +'Parent Case Description : ' + ss.Test_Case__r.Support_Case__r.Description;
            cc.parentID=vv.id;
        system.debug('Comment>>>>>>'+cc);
        insert cc;
      
         
      PageReference p1 = new PageReference('/'+ss.Test_Case__c );
      p1.setRedirect(true);
      return p1;
   }
   
   
   
   // New Code added
   
     public class cRecord {
         public TestCaseStep__c rec {get;set;}
         public Boolean selected {get;set;}
         
  }

     public void TestCaseScriptsController1() {
  
      oCRecord = new list<cRecord>();
      l1 = new list<TestCaseStep__c>() ;
      testCaseid = ApexPages.currentPage().getParameters().get('ID');
      String testCaseid1 = ApexPages.currentPage().getParameters().get('pid');
      
      if(testCaseid1 != null && testCaseid1 != '' )
        testCaseid = testCaseid1 ;
      System.Debug('TestCaseId = ' + testCaseId);
      
      for (TestCaseStep__c ss: [SELECT ID,name,Support__c,Support__r.CaseNumber,step__c,Expected_Results__c,Status__c,Comments__c,Actual_Results__c,Test_Case__c,Test_Step_Description__c from TestCaseStep__c where Test_Case__c = :testCaseid order by step__C])
      {   ss.step__c = Integer.valueof(ss.name);
          l1.add(ss);
          cRecord c = new cRecord();
          c.rec = ss;
          c.selected = false;
          oCRecord.add(c);
         }
     // New code finished    

}
}