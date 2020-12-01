public class MDR_Extension {

    private final MDR__c mdr = null;
    
    public List<MDR__c> lstChildMDR {get;set;}
    
      public MDR_Extension(ApexPages.StandardController controller) {
          mdr = (MDR__c)controller.getRecord();
			lstChildMDR = LoadChildMDR();
      }
  
  public List<MDR__c> LoadChildMDR() {     
      return [SELECT Id, PID__c, Name, Enrollment__c, FILETYPE_L__c, POVLVLCODE_L__c,  
              Potential__c, School_Type__c, PUPEXPAIM_L__c, CHARTER_L__c, schclass_l__c 
              from MDR__c 
              Where ParentPID__c = :mdr.ID or CMO_PID__c = :mdr.ID 
              Order by Name];
  }
    
}