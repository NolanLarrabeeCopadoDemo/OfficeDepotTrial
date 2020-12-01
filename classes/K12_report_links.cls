public class K12_report_links {

public list<K12_Report_Link__mdt> Reportlist {get;set;}


public K12_report_links() {
          Reportlist = LoadlstReportLinks();
      }


 public List<K12_Report_Link__mdt> LoadlstReportLinks() {     
      return [SELECT Report_Label__c, Report_Link__c, Report_Description__c, Sorting__c
             From K12_Report_Link__mdt
             Order by Sorting__c];
  }

}