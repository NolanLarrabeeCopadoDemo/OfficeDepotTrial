@isTest
public class MigrationDashboardController_TC1{
  static testMethod void MDCTest() {
  Map<String,String> statusesToBuckets = new Map<String, String>();
  Account a= new Account();
  a.Name='abc';
  a.Phone='8512356562';
  a.City__c='New jersy';
  a.Address1__c='xyz';
  a.State__c='UT';
  a.Zip__c='243635';
  a.Country__c='USA';
  insert a;
  
  List<Customer_Transition__C> ct=new List<Customer_Transition__C>();
  
  Customer_Transition__C ctc=new Customer_Transition__C();
  ctc.Account__c=a.id;
  ctc.Status__c='Scheduled';
  ctc.Written_Agreement__c=True;
  ct.add(ctc);
  
  
  Customer_Transition__C ctc1=new Customer_Transition__C();
  ctc1.Account__c=a.id;
  ctc1.Status__c='UnScheduled';
  ctc1.Written_Agreement__c=False;
  ct.add(ctc1);
  
  Customer_Transition__C ctc2=new Customer_Transition__C();
  ctc2.Account__c=a.id;
  ctc2.Status__c='On deck';
  ctc2.Written_Agreement__c=False;
  ct.add(ctc2);
  
  Customer_Transition__C ctc3=new Customer_Transition__C();
  ctc3.Account__c=a.id;
  ctc3.Status__c='Launched';
  ctc3.Written_Agreement__c=False;
  ct.add(ctc3);
 
  insert ct;
  
  List<AggregateResult> statusCounts  = [SELECT Status__c, Count(Id) recordCount FROM Customer_Transition__c GROUP BY Status__c];    
  
  for(Customer_Transition__C cm : ct){ 
  statusesToBuckets.put(cm.status__c,cm.status__c);
    }
  MigrationDashboardController mcd=new MigrationDashboardController();
  MigrationDashboardController.MigrationDashboardWrapper mdw=new MigrationDashboardController.MigrationDashboardWrapper();
      mdw.scheduled=15;
      mdw.pricing=35;
      mdw.launched=25;
      mdw.complete=25;
      mcd.populatePurchasingLevel();
      mcd.pupulateWrittenAgreement();
      mcd.populateWrapper(statusCounts, statusesToBuckets);
      mcd.getStatuses();
  }
}