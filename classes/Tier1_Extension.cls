public class Tier1_Extension {
    
    private final Partner__c partner = null;
    
    public List<Opportunity> lstAccountOpportunities {get;set;}

      public Tier1_Extension(ApexPages.StandardController controller) {
          partner = (Partner__c)controller.getRecord();
          lstAccountOpportunities = LoadOpportunitiesForChildAccounts();
      }
  
  public List<Opportunity> LoadOpportunitiesForChildAccounts() {     
      return [SELECT id, AccountId, Account.Name, Name, StageName, Product__c, Opportunity_Amount__c, Account.YTD_SALES_TY__c, IMU__c, Owner.Name, LastModifiedDate
              FROM opportunity 
              Where Account.Tier_1_Partner__c = :partner.ID
              and Status__c = 'Open'
             Order by AccountId, Opportunity_Amount__c Desc ];
  }
 
}