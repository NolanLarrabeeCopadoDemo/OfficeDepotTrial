public class TestCaseScriptsController {

   public list<TestCaseStep__c> l1{get;set;}
   public ID testCaseid {get;set;}
   public ID testCaseid2 {get;set;}
   public list<cRecord> oCRecord{get;set;}
   private final TestCaseStep__c spc;
   public Integer nxtStep =0;  
   public list<TestCaseStep__c> IdtoDelete {get;set;}
   public string toDelId {get;set;}
   public string toSupId{get;set;}
   public string toSupId2{get;set;}
   private ApexPages.StandardController controller {get; set;} 
   private SFDC_Test_Case__c po {get;set;}
   public ID newRecordId {get;set;}
   

  public TestCaseScriptsController(ApexPages.StandardController c1) {
  
      TestCaseScriptsController1();
     
     
  }

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
      
      AggregateResult[] groupedResults = [SELECT  Max(step__C) stp FROM TestCaseStep__c  where  Test_Case__c = :testCaseid];
      
      Object x;
      for (AggregateResult ar : groupedResults)
      { x= ar.get('stp');
         }
         nxtStep =Integer.valueof(x);

  }  

  public void new1() {
  
    TestCaseStep__c sp1 = new TestCaseStep__c();
    sp1.Test_Case__c = testCaseid;
    if(nxtStep == null)
    nxtStep =0;
    nxtStep =nxtStep +1;
    sp1.name=nxtStep + '';
    sp1.step__c = nxtStep ;
    sp1.Status__c = 'Not Started';
    l1.add(sp1);
    cRecord c = new cRecord();
    c.rec = sp1;
    c.selected = false;
    oCRecord.add(c);
 
  }
    
   public void addFive() {
    
        new1();
        new1();
        new1();
        new1();
        new1();
  } 
    
    
   public PageReference save() {
       //testCaseid2 = ApexPages.currentPage().getParameters().get('pid');
       list<TestCaseStep__c> listToSave = new list<TestCaseStep__c>();
       for(cRecord s :oCRecord){
          s.rec.step__c = Integer.valueof(s.rec.name);
          listToSave.add(s.rec); 
       }
       upsert listToSave;
       
       PageReference p1 = new PageReference('/'+testCaseid );
       p1.setRedirect(true);
       return p1; 
  }
  
  
     
   public void delete1() { 
       list<TestCaseStep__c> listToDel = new list<TestCaseStep__c>();
       list<Integer> rrecs = new list<Integer>();
       integer i=0;
       rrecs.clear();
       for(cRecord s :oCRecord ){
         if( s.rec.name== toDelId )
        {
          if(s.rec.id!=null)
          listTodel.add(s.rec); 
          rrecs.add(i);
        }
          i++;
       
      }
         for(Integer k :rrecs){
         oCRecord.remove(k);
         }
        
         delete listToDel;
  }  
    
   
        
  public PageReference cancel() {
       PageReference p1 = new PageReference('/'+testCaseid );
       p1.setRedirect(true);
       return p1;
  }
  
  


   public PageReference saveStep() {
   String SID = System.CurrentPageReference().getParameters().get('tosupIdent');
   String TId = '';
   //list<TestCaseStep__c> listToSave1 = new list<TestCaseStep__c>();
   system.debug('1');
   list<TestCaseStep__c> listToSave = new list<TestCaseStep__c>();
   
        list<Integer> rrecs = new list<Integer>();
        system.debug('1');
       // rrecs.clear();
        system.debug('2');
        for(cRecord s :oCRecord){
        system.debug('3');
        s.rec.step__c = Integer.valueof(s.rec.name);
        listToSave.add(s.rec);
        system.debug('4');
        
       /* if( s.rec.name == toSupId  ) // s.rec.name != toSupId
        {
          listToSave1.add(s.rec); 
          }*/
       }
       system.debug('5');
       upsert listToSave;
       system.debug('6');
      
      // upsert listToSave1;
     
      for(TestCaseStep__c a :listToSave){
      system.debug('7');
      system.debug('SID = ' + SID);
      system.debug('AAAAAAAID = ' + String.valueOf(a.id));
          if(SID == String.valueOf(a.name)){
          TId = a.id;
          
        }
      system.debug('8');
     }
     system.debug('TID= ' + TID);
           if(TId!=''){
           system.debug('Before Navigation to new support');
       PageReference p1 = new PageReference('/apex/NewSupport?pid='+TId );
                  system.debug('After Navigation to new support');
       p1.setRedirect(true);
       return p1; 
       }
       
     
       
       else {return null;}
       
    }
   

}