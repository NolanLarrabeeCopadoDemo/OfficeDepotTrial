public class CT_Controller_Report_Links {
    
    
    public List<CM_Report_Center_Links__c> lstReportLinks {get;set;}
    
    public CT_Controller_Report_Links() {
          lstReportLinks = LoadlstReportLinks();
      }
    
    public List<CM_Report_Center_Links__c> LoadlstReportLinks() {     
      return [SELECT Report_Label__c, Report_Link__c, Report_Description__c
              From CM_Report_Center_Links__c 
             Order by Sort_Order__c];
  }

}