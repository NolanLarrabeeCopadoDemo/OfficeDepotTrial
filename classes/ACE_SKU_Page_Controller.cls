public class ACE_SKU_Page_Controller 
{
    
    public PageReference Refresh_rec() 
    {
        getURL();
        return null;  
    }

    public String status{get;set;}  
    public String vendorName{get;set;}
    public String SkuID{get;set;}
    public String batch{get;set;}
    public String SectionTitle{get;set;}
    
 
    
    public Integer List_size = 50;
    public Integer total_size;
    public Integer counter;
    public Boolean hasSelAcct{get;set;}
   
    //constructor 1
    public ACE_SKU_Page_Controller ()
    {   
        counter = 0;   
        status ='None';     
    }
    
    public ID Userid{get;set;}
    public String OwnerValue{get;set;}
    public List<Ace_Customer_SKU_Changes__c> SKU_List{get;set;}
    public List<Ace_Customer_Price_Changes__c> lCustomerPriceChanges {get;set;}
    public void getURL()
    {
            System.debug('^^^^^^^^^^^'+Vendorname);
            Vendorname = '';
            userid = UserInfo.getUserID();
            batch= ApexPages.currentPage().getParameters().get('batch');
            SkuID= ApexPages.currentPage().getParameters().get('skuid');
            ownerValue= ApexPages.currentPage().getParameters().get('ownerValue');
            VendorName= ApexPages.currentPage().getParameters().get('Vendor');
            System.debug('^^^^^VendorName^^^^^^' + Vendorname);
            // Heirarchy code
            
            List<User> userList = new List<User>();
            ACE_User_Cust_Hierarchy_Controller obj = new ACE_User_Cust_Hierarchy_Controller();
            UserList = obj.lUserList;
            system.debug('ownerlist:' + UserList);
            Set<ID> ownerList = new Set<ID>();
            
            for(User u : UserList)
            {
                ownerList.add(u.id);
            }
            
            if(OwnerValue == 'All')
            {
                ownerList.add(UserInfo.getUserId());    
            }
            else if(OwnerValue == 'Owned by me')
            {
                ownerList = new Set<ID>();
                ownerList.add(UserInfo.getUserId());    
            }
             else if (OwnerValue == 'Owned by others'  || OwnerValue == 'Owned by my team')
            {
                ownerList.remove(UserInfo.getUserId());
            }
            else
            {
                ownerList = new Set<ID>();
                ownerList.add(UserInfo.getUserId());
            }    
            
            
            Set<ID> sID_ACE_Price_ID = new Set<ID>();
            sID_ACE_Price_ID = obj.CustomerPriceChangeRecs(ownerList,OwnerValue,batch);
            system.debug('Total Customers To Collect:' + sID_ACE_Price_ID.size());
            
            // Heirarchy code ends here
            
         
         
             SKU_List = new List<Ace_Customer_SKU_Changes__c>();
           if(status =='None')
           { 
               if(VendorName != null && vendorname != '')
                   SKU_List = [select id,Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Owning_Customer_ID__c,Owning_Customer_Corelist_Priority__c,CoreList_ID__c,Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.customer__r.name,Current_Sell_Price__c,Approved_Proposed_Price__c,New_Price_cal__c,SKU__c,Ace_Customer_Core_Changes__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where Core_s_SKU_Vendor_Name__c=:VendorName and sku__c = :skuid and batchId__c =:batch and Price_Change_ID__c = :sID_ACE_Price_ID and update_timing_action__c = 'T'] ; //ROM-37 - To not create WRF for update_timing_action__c = 'F" 
               else
                   SKU_List = [select id,Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Owning_Customer_ID__c,Owning_Customer_Corelist_Priority__c,CoreList_ID__c,Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.customer__r.name,Current_Sell_Price__c,Approved_Proposed_Price__c,New_Price_cal__c,SKU__c,Ace_Customer_Core_Changes__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where  Core_s_SKU_Vendor_Name__c= null and sku__c = :skuid and batchId__c =:batch and Price_Change_ID__c = :sID_ACE_Price_ID and update_timing_action__c = 'T'] ; //ROM-37 - To not create WRF for update_timing_action__c = 'F" 
           
           }
           else
           {
               if(VendorName != null && vendorname != '')
                   SKU_List = [select id,Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Owning_Customer_ID__c,Owning_Customer_Corelist_Priority__c,CoreList_ID__c,Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.customer__r.name,Current_Sell_Price__c,Approved_Proposed_Price__c,New_Price_cal__c,SKU__c,Ace_Customer_Core_Changes__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where Core_s_SKU_Vendor_Name__c=:VendorName and price_Changes_Type__c=:status and sku__c = :skuid and batchId__c =:batch and Price_Change_ID__c = :sID_ACE_Price_ID and update_timing_action__c = 'T'] ; //ROM-37 - To not create WRF for update_timing_action__c = 'F"  
               else
                   SKU_List = [select id,Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.Owning_Customer_ID__c,Owning_Customer_Corelist_Priority__c,CoreList_ID__c,Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__r.customer__r.name,Current_Sell_Price__c,Approved_Proposed_Price__c,New_Price_cal__c,SKU__c,Ace_Customer_Core_Changes__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where Core_s_SKU_Vendor_Name__c=null and sku__c = :skuid and batchId__c =:batch and price_Changes_Type__c=:status and Price_Change_ID__c = :sID_ACE_Price_ID and update_timing_action__c = 'T'] ; //ROM-37 - To not create WRF for update_timing_action__c = 'F" 
           
           }  
          
            System.debug('List of SKU Records' + SKU_List);
          /*  Set<ID> sID = new Set<ID>();
            for(Ace_Customer_SKU_Changes__c sku : SKU_List)
            {
                sID.add(sku.Ace_Customer_Core_Changes__r.Ace_Customer_Price_Changes__c);
            } 
           
            lCustomerPriceChanges = [Select id,Name , customer__r.name from ACE_Customer_Price_Changes__c where id in : sID]; // customer__r.ownerid = :userid];
          */
        }         
    
    
  
    
    public void nextPage(){
        counter = counter+List_size;
       // processSelected();
        getURL();
    }
    public void prevPage(){
        counter = counter-List_size;
       // processSelected();
        getURL();
    }
    
    public Boolean getDisablePrevious() {      
      if (counter>0) return true; else return false;
    }
    public Boolean getDisableNext() { 
      if (counter + list_size < total_size) return true; else return false;
   }
    
 
}