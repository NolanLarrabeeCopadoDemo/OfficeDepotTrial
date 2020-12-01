public class QuikLnkCtrl {
    MarketBuilderController mkc = new MarketBuilderController();
    //Added for S-425883[Case#00744549]
    final String ACC_REQUEST ='ODS Account Maintenance';      
    public String Account_Maintenance_Request_Link {get{ return Click_Tool_Links__c.getInstance(ACC_REQUEST).Value__c; }set;}
    //END S-425883[Case#00744549]
    
    public void QuiklnkCtrl(){
        
    }
    
    Public PageReference MarketPage(){
    
        return mkc.onMBButton();
        
    }
}