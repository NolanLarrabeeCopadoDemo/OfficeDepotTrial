public class TestCaseEdit{

private ApexPages.StandardController controller {get; set;}

  public TestCaseStep__c  ts {get;set;}
  
  public TestCaseEdit (ApexPages.StandardController controller) {
    ts = [SELECT id,Test_Case__c from TestCaseStep__c where id = :controller.getid()];
  }

  public PageReference edit2() {
       PageReference p1 = new PageReference('/apex/TestSteps?pid=' + ts.Test_Case__C);
       p1.setRedirect(true);
       return p1;
  }
  
  }