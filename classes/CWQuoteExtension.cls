public class CWQuoteExtension {
    
    private final Opportunity oppt;
    
    public CWQuoteExtension(ApexPages.StandardController stdController) {
        this.oppt = (Opportunity) stdController.getRecord();
    }
    
    public boolean getIsOpptContactRoleExist() {  
        
        Map<Id, Opportunity> opportunityMap = new Map<Id,Opportunity>();
        opportunityMap.put(oppt.Id, oppt);
        List<OpportunityContactRole> contactRolesList = new List<OpportunityContactRole> ([SELECT Id, OpportunityId  from OpportunityContactRole  where OpportunityId in :opportunityMap.keySet()]);    	
        
        if (contactRolesList == null || contactRolesList.size() == 0) {
            return false;
        } else {
            return true;
        }
    }
}