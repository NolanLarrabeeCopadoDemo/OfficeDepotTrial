/**@@
#CLASS NAME  :  OpportunityProductController(Related classes: OpportunityProductController_Test)
#DESCRIPTION :   Modified for NAIT-148129 03050397 - Price Book Screen Times Out When Selecting Products
#MODIFIEDDATE :  18-08-2020 (DD-MM-YYYY) 
@@**/
public class OpportunityProductController
{
    public id oppId{get;set;}
    public id Pricebook2Id{get;set;}
    public id DefaultPricebook2Id{get;set;}
    public boolean isPricebookAvailabel{get;set;}
    public boolean isBSD{get;set;}
    public boolean isPricebookSame{get;set;}
    public boolean hasExistingProducts{get;set;}
    public string DefaultPricebookName{get;set;}
    public integer numOfExistingProducts{get;set;}
    public string strExistingProductsPricebookName{get;set;}
    
    public OpportunityProductController(ApexPages.StandardController controller)
    {        
    }
   
    public void init()
    {
        String stroppId = Apexpages.currentPage().getParameters().get('oppId');
        system.debug(' stroppId ' + stroppId);        
        isPricebookAvailabel = false;
        isPricebookSame = false;
        hasExistingProducts = false;
        numOfExistingProducts = 0;
        isBSD = false;
        set<id> setOppRecordTypes = new set<Id>();
        list<id> lstOppRecordTypes = label.Product_SubType_US_Opportunity_RecordTypes.split(',');
        setOppRecordTypes.addAll(lstOppRecordTypes);
        if(stroppId != null && stroppId != '') 
        {
            oppId = stroppId;
        	list<opportunity> lstOpp = [select id,recordtypeId,Pricebook2Id,Pricebook2.Name,recordtype.Name from opportunity where id =:oppId];
            if(lstOpp != null && lstOpp.size() > 0)
            {
                //Start : Modified by Rajendra Shahane for NAIT-148129 03050397 - Price Book Screen Times Out When Selecting Products
                if(setOppRecordTypes.contains(lstOpp[0].recordtypeId))
                {
                    isBSD = true;
                    DefaultPricebook2Id = (Id)Label.BSD_Pricebook_Id;
                    DefaultPricebookName = Label.BSD_Pricebook_Name;
                }
                else
                {
                    DefaultPricebook2Id = (Id)Label.GT_Pricebook_Id;
                    DefaultPricebookName = Label.GT_Pricebook_Name;
                }
                if(lstOpp[0].Pricebook2Id != null)
                {
                    Pricebook2Id = lstOpp[0].Pricebook2Id;
                    strExistingProductsPricebookName = lstOpp[0].Pricebook2.Name;
                    isPricebookAvailabel = true;                    
                }
                else 
                {
                    Pricebook2Id = DefaultPricebook2Id;
                    strExistingProductsPricebookName = DefaultPricebookName;
                    isPricebookAvailabel = true;
                }
            }
        	if(DefaultPricebook2Id == Pricebook2Id)
            	isPricebookSame = true;
            else
            {
                hasExistingProducts = true;
                list<OpportunityLineItem> lstProducts = [select Id,Name,Product_Subtype__c,IMU__c,Quantity,UnitPrice,Unit_Cost__c from OpportunityLineItem where OpportunityId =:oppId];
                if(lstProducts != null && lstProducts.size() > 0)
                {
                    numOfExistingProducts = lstProducts.size();
                    
                }
            }
            //End : Modified by Rajendra Shahane for NAIT-148129 03050397 - Price Book Screen Times Out When Selecting Products
        }
    }
	
    @AuraEnabled
    public static void updateOpportunityPricebook(string opportunityId, string pricebookId)
    {
        opportunity currentOpp = new opportunity(id=opportunityId,Pricebook2Id=pricebookId);
        //Start : Added by Rajendra Shahane for NAIT-148129 03050397 - Price Book Screen Times Out When Selecting Products
        list<opportunitylineitem> lstOLI = [select Id from opportunitylineitem where opportunityid=:opportunityId];
        if(lstOLI != null && lstOLI.size() > 0 ) delete lstOLI;
        //End : Added by Rajendra Shahane for NAIT-148129 03050397 - Price Book Screen Times Out When Selecting Products
        update currentOpp;
    }
    
     @AuraEnabled(Cacheable=true)
    public static List<pricebookentry> getProducts(string pricebookId) {
        return [select id,product2.id,product2id,product2.name,product2.ProductCode,product2.List_Price__c,product2.Description,product2.Family from pricebookentry where isactive = true and pricebook2Id =:pricebookId order by product2.name asc];
    }
}