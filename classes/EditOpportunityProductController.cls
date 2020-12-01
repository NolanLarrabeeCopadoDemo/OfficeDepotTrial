/**@@
#CLASS NAME  :  EditOpportunityProductController(Related classes: EditOpportunityProductController_Test)
#DESCRIPTION :   Modified for NAIT-148130 03050412 - Product and Product Subtype Dependency Upon Editing Products
#MODIFIEDDATE :  18-08-2020 (DD-MM-YYYY) 
@@**/
public class EditOpportunityProductController {
    public id oppId{get;set;}
    public boolean hasExistingProducts{get;set;}
    public list<OpportunityLineItem> oppLineItems{get;set;}
    public string DefaultPricebookName{get;set;}
    public boolean isBSD{get;set;}
    
	public EditOpportunityProductController(ApexPages.StandardController controller)
    {        
    }
    
    public void init()
    {
        String stroppId = Apexpages.currentPage().getParameters().get('oppId');
        hasExistingProducts = false;
        oppLineItems = new list<OpportunityLineItem>();
        DefaultPricebookName = Label.GT_Pricebook_Name;
        isBSD = false;
        hasExistingProducts = false;   
        set<id> setOppRecordTypes = new set<Id>();
        list<id> lstOppRecordTypes = label.Product_SubType_US_Opportunity_RecordTypes.split(',');
        setOppRecordTypes.addAll(lstOppRecordTypes);
        
        if(stroppId != null && stroppId != '') 
        {
            oppId = stroppId;
            
            list<OpportunityLineItem> lstProducts = [select Id,Opportunity.recordtypeid,Opportunity.recordtype.Name,Product_Subtype__c,Product_BSD__c,Product_GT__c,Product_Subtype_BSD__c,Product_Subtype_GT__c,IMU__c,Quantity,UnitPrice,Unit_Cost__c from OpportunityLineItem where OpportunityId =:oppId];
            if(lstProducts != null && lstProducts.size() > 0)
            {
                oppLineItems = lstProducts;
                hasExistingProducts = true;
                if(setOppRecordTypes.contains(lstProducts[0].Opportunity.recordtypeId))
                {
                    isBSD = true;
                    DefaultPricebookName = Label.BSD_Pricebook_Name;
                }	
            }
        }
    }
    
     @AuraEnabled(Cacheable=true)
    public static List<OpportunityLineItem> getProducts(string oppId) {
        return [select Id,Product_Subtype__c,Product_BSD__c,Product_GT__c,Product_Subtype_BSD__c,Product_Subtype_GT__c,IMU__c,Quantity,UnitPrice,Unit_Cost__c from OpportunityLineItem where OpportunityId =:oppId];
    }
}