public class ACESKUIGMCustomPage{

    
    public Decimal IGMGROSSDOLLAR{get;set;}
    public Decimal IGMGROSSPERCENT{get;set;}
    public Boolean RenderFields{get;set;}
    public ACE_Customer_SKU_Changes__c custList;
        
    public ACESKUIGMCustomPage(ApexPages.StandardController controller) {
        String urlID = ApexPages.currentPage().getParameters().get('id');
        
        User u = [select id,short_title__c from user where id=:UserInfo.getUserId()];
        String ShortTitle = u.short_title__c;
        
        custList = new ACE_Customer_SKU_Changes__c();
        custList = [select id,New_Gross_IGM__c,New_Gross_IGM1__c from ACE_Customer_SKU_Changes__c 
                    where id=:urlID];
        RenderFields = false;
        
        ACE_Settings__c CS= [select id,Level1Access__c,Level2Access__c,Level3Access__c from ACE_Settings__c limit 1];
        
        //Only Level2 and Level3 can See IGM
        if(ShortTitle !=null || ShortTitle== '') {
         
         if (cs.Level2Access__c != null) 
           if (cs.Level2Access__c.contains(ShortTitle))
             RenderFields = true;
        
         if (cs.Level3Access__c != null && !RenderFields)
           if (cs.Level3Access__c.contains(ShortTitle))
             RenderFields = true;
            
        }
            
        IGMGROSSDOLLAR = custList.New_Gross_IGM__c;
        IGMGROSSPERCENT = custList.New_Gross_IGM1__c;
    }
}