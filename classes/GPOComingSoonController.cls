public with sharing class GPOComingSoonController {
    public GPOComingSoonController(){
    }
    
    public void insertCounter(){
        GPOCounter__c c2 = new GPOCounter__c();
        if(ApexPages.currentPage().getParameters().get('source') != null || ApexPages.currentPage().getParameters().get('source') != '' ){
			c2.Source__c = ApexPages.currentPage().getParameters().get('source');
        }
        insert c2;
    }


    
  
}