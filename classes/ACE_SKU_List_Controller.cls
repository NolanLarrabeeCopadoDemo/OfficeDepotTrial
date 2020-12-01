global class ACE_SKU_List_Controller 
{
    public String OwnerValue { get; set; }
    public PageReference SearchRecords() 
    {
        counter = 0;
        //total_size = 0;
        getURL();
        return null;
    }
    
    public String fieldName;
    public String sortDirection {get;set;}
    public String getFieldName{get;set;}
    public Boolean tabAsc{get;set;}
    public Boolean renderTab{get;set;}
    public Map<String,boolean> skuDisplayed {get;set;}
    
    public void sortCust() {
        if(getFieldName == 'SKU'){
            fieldName = 'SKU__c';
        }
        else if(getFieldName == 'ChangeType'){
            fieldName = 'price_changes_type__c';}
     //   else if(getFieldName == 'CoreListID'){
      //      fieldName = 'CoreList_ID__c';}
        //else if(getFieldName == 'OwningCustomer'){
       //     fieldName = 'OwningCustomer';}
        else if(getFieldName == 'Percent'){
            fieldName = 'ChangeAmount_per__c';}
        else if(getFieldName == 'UnitVolume'){
            fieldName = 'Item_12_Month_Qty__c';}
        else if(getFieldName == 'SpendImpact'){
            fieldName = 'Total_Spend_Impact_12_Month__c';}
        //else if(getFieldName == 'ImpactedCustomers'){
        //    fieldName = 'ImpactedCustomers';}
        else if (getFieldName =='SKUDesc'){
            fieldName = 'SKU_Description__c';}
        else if (getFieldName =='PrimVen'){
            fieldName = 'Core_s_SKU_Vendor_Name__c';}
        
            
        if(tabAsc){
            sortDirection = 'DESC';
           // fieldName = 'Customer__r.name';
            tabAsc = false;            
        }
        else {
            sortDirection = 'ASC';
          //  fieldName = 'Customer__r.name';
            tabAsc = true;             
        }  
        skuDisplayed.clear();
        getURL();  
    }

    public String SearchText { get; set; }
      
    public PageReference Refresh_rec() 
    {
        counter = 0;
        //total_size = 0;
        skuDisplayed.clear();
        getURL();
        return null;  
    }

    public String status{get;set;}  
    public String pageParam{get;set;}
    public String batch{get;set;}
    public String SectionTitle{get;set;}
  //  public List<custListTable> clsCusListTable{get;set;}
    public List<SKUListTable> clsSKUListTable{get;set;}
    
    public Integer List_size = 50;
    public Integer total_size;
    public Integer counter;
    public Boolean hasSelAcct{get;set;}
   
    //constructor 1
    public ACE_SKU_List_Controller ()
    {   
        counter = 0;    
        renderTab = false;
        fieldName = 'SKU__c'; 
        getFieldName = 'SKU';
        Status='None';  
        tabAsc = true;
        sortDirection = 'ASC'; 
        OwnerValue = 'Owned by me';
        skuDisplayed = new Map<String,Boolean> ();
    }
    
    public ID Userid{get;set;}
    public void getURL()
    {
            System.debug('^^^^^^^^^^^'+pageParam);
            userid = UserInfo.getUserID();
            batch= ApexPages.currentPage().getParameters().get('batch');
            List<Ace_Customer_SKU_Changes__c > lst = new List<Ace_Customer_SKU_Changes__c >();

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
             else if (OwnerValue == 'Owned by others' || OwnerValue == 'Owned by my team')
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
                  
            clsSKUListTable = new List<SKUListTable>();
            List<Ace_Customer_SKU_Changes__c> SKU_List = new List<Ace_Customer_SKU_Changes__c>();
             String Query = '';
                          
            if((searchText != null) && (searchText != ''))
            {      
              String textToSearch = '' + searchText.trim() + '%';
               if(status =='None')
               {
                   //DECIMAL d=1/0;
                  Query = 'select id,SKU__c,Owning_Customer_Corelist_Priority__c,CoreList_ID__c,Ace_Customer_Core_Changes__c,SKU_Description__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where price_not_calculated__C = false and sku__c  like \''+ textToSearch + '\' and price_changes_type__c != \'A\' and Price_Change_ID__c =: sID_ACE_Price_ID and update_timing_action__c =\'T\''; //+ limit :List_size OFFSET :counter '; //ROM-37 Added update_timing_action__c
                  lst = [select id from Ace_Customer_SKU_Changes__c where price_not_calculated__C = false and sku__c  like :textToSearch and price_changes_type__c != 'A' and Price_Change_ID__c =: sID_ACE_Price_ID and update_timing_action__c = 'T'];//ROM-37 Added update_timing_action__c
                  // SKU_List = [select id,SKU__c,Ace_Customer_Core_Changes__c,SKU_Description__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where sku__c  like :textToSearch and  batchId__c =:batch and Ace_Customer_Core_Changes__c in: sIDs  limit :List_size OFFSET :counter ] ; 
               }
               else
               {
                    Query = 'select id,SKU__c,Owning_Customer_Corelist_Priority__c,CoreList_ID__c,Ace_Customer_Core_Changes__c,SKU_Description__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where price_not_calculated__C = false and sku__c  like \''+ textToSearch + '\' and  price_Changes_Type__c = \''+ status + '\' and price_changes_type__c != \'A\' and  batchId__c = \''+ batch + '\' and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in: sID_ACE_Price_ID and update_timing_action__c =\'T\'' ; //+ limit :List_size OFFSET :counter ';//ROM-37 Added update_timing_action__c
                    lst = [select id from Ace_Customer_SKU_Changes__c where price_not_calculated__C = false and sku__c  like :textToSearch and price_Changes_Type__c =:status and Price_Change_ID__c =: sID_ACE_Price_ID and update_timing_action__c = 'T'];//ROM-37 Added update_timing_action__c
                  // SKU_List = [select id,SKU__c,Ace_Customer_Core_Changes__c,SKU_Description__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where sku__c  like :textToSearch and price_Changes_Type__c=:status and batchId__c =:batch and Ace_Customer_Core_Changes__c in: sIDs limit :List_size OFFSET :counter  ] ; 
               }  
           }
           else
           {
               if(status =='None')
               { 
                   Query = 'select id,SKU__c,Owning_Customer_Corelist_Priority__c,CoreList_ID__c,Ace_Customer_Core_Changes__c,SKU_Description__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where price_not_calculated__C = false and price_changes_type__c != \'A\' and Price_Change_ID__c =: sID_ACE_Price_ID and update_timing_action__c =\'T\'' ; //+ limit :List_size OFFSET :counter ';//ROM-37 Added update_timing_action__c
                   lst = [select id from Ace_Customer_SKU_Changes__c where price_not_calculated__C = false and (price_changes_type__c != 'A' and Price_Change_ID__c =: sID_ACE_Price_ID) and update_timing_action__c = 'T'];//ROM-37 Added update_timing_action__c
                   //decimal d=0;
                  // SKU_List = [select id,SKU__c,Ace_Customer_Core_Changes__c,SKU_Description__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where  batchId__c =:batch and Ace_Customer_Core_Changes__c in: sIDs limit :List_size OFFSET :counter ] ; 
               }
               else
               {
                   Query = 'select id,SKU__c,Owning_Customer_Corelist_Priority__c,CoreList_ID__c,Ace_Customer_Core_Changes__c,SKU_Description__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where price_not_calculated__C = false and price_Changes_Type__c = \''+ status + '\' and price_changes_type__c != \'A\' and Price_Change_ID__c =: sID_ACE_Price_ID and update_timing_action__c =\'T\'' ; //+ limit :List_size OFFSET :counter ';//ROM-37 Added update_timing_action__c
                   lst = [select id from Ace_Customer_SKU_Changes__c where price_not_calculated__C = false and price_Changes_Type__c =:status and price_changes_type__c != 'A' and Price_Change_ID__c =: sID_ACE_Price_ID and update_timing_action__c = 'T'];//ROM-37 Added update_timing_action__c
                   
                  // SKU_List = [select id,SKU__c,Ace_Customer_Core_Changes__c,SKU_Description__c,Total_Spend_Impact_12_Month__c,Item_12_Month_Qty__c,ChangeAmount_per__c,Core_s_SKU_Vendor_Name__c,price_Changes_Type__c, Name,batchId__c from Ace_Customer_SKU_Changes__c where price_Changes_Type__c=:status and batchId__c =:batch and Ace_Customer_Core_Changes__c in: sIDs  limit :List_size OFFSET :counter ] ; 
               }
           }
           
            Query = Query + ' ORDER BY '+ fieldName +' '+sortDirection+' limit :List_size offset :counter';
            System.debug('Query is : ' + Query);
            SKU_List = Database.query(query);  
            
            
            //lst = [select id from Ace_Customer_SKU_Changes__c where price_changes_type__c != 'A' and Price_Change_ID__c =: sID_ACE_Price_ID];                      
            System.debug('List of SKU Records' + SKU_List);
            total_size = lst.size();
            if(SKU_List.size()>0)
                renderTab = true;
            
            
            AggregateResult[] SKUListCustomers  = [select AVG(ChangeAmount_per__c) chng, Avg(spendImpactValue__c) spnd, Sum(Item_12_Month_Qty__c) AnualUsage, count_distinct(Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__r.customer__r.id) custCnt,SKU__c s, Core_s_SKU_Vendor_Name__c v  
                                                               from ACE_Customer_SKU_Changes__c where Price_Change_ID__c =: sID_ACE_Price_ID and update_timing_action__c = 'T'
                                                               GROUP BY SKU__c, Core_s_SKU_Vendor_Name__c order by SKU__c ASC];//ROM-37 Added update_timing_action__c
            
            Map<String,Integer> map_SKUVendor_Count = new Map<String,Integer>();
            Map<String,Decimal> map_SKUVendor_AnnualUsage = new Map<String,Decimal>();
            Map<String,Decimal> map_SKUVendor_SpendImpact = new Map<String,Decimal>();
            Map<String,Decimal> map_SKUVendor_ChangeAmount = new Map<String,Decimal>();
           
            for (AggregateResult ar : SKUListCustomers  )
            {
                if((String)ar.get('s') != null) 
                {
                        String val = (String)ar.get('s');
                        String val1 = (String)ar.get('v');
                        Integer val2 = (Integer)ar.get('custCnt');
                        Decimal annual = ((Decimal)ar.get('AnualUsage')).setScale(2);
                        Decimal spendImpact = ((Decimal)ar.get('spnd')).setScale(2);
                        Decimal changeAmount = ((Decimal)ar.get('chng')).setScale(2);
                       
                        map_SKUVendor_SpendImpact.put(val + '-' +val1, spendImpact );   
                        map_SKUVendor_Count.put(val + '-' +val1, val2);
                        map_SKUVendor_AnnualUsage.put(val + '-' +val1, annual);
                        map_SKUVendor_ChangeAmount.put(val + '-' +val1, changeAmount );
                       
                        //System.debug('>>>>>>>>>>>>>>>>>>>>>>>SKU ' + val + ' Vendor Name: ' + val1 + 'count:' + val2);
                }
            }
                
                
                                 
           Map<String,List<Ace_Customer_SKU_Changes__c>> map_skuID_lSKU = new Map<String,List<Ace_Customer_SKU_Changes__c>>();
            if(SKU_List != null)
            {
                
                for(Ace_Customer_SKU_Changes__c cus: SKU_List)
                {
                    String temp = '';
                    if(cus.Core_s_SKU_Vendor_Name__c == null || cus.Core_s_SKU_Vendor_Name__c == '')
                        temp = '' + cus.SKU__c + '-null';
                    else
                        temp = '' + cus.SKU__c + '-' + cus.Core_s_SKU_Vendor_Name__c;
                        
                    if(!map_skuID_lSKU.containsKey(temp))
                    {
                        List<Ace_Customer_SKU_Changes__c> lsku = new List<Ace_Customer_SKU_Changes__c>();
                        lsku.add(cus);
                        map_skuID_lSKU.put(temp,lsku );
                    }
                    else
                    {
                        List<Ace_Customer_SKU_Changes__c> lsku = new List<Ace_Customer_SKU_Changes__c>();
                        lsku= map_skuID_lSKU.get(temp);
                        lsku.add(cus);
                        map_skuID_lSKU.remove(temp);
                        map_skuID_lSKU.put(temp,lsku);
                    }
                }
            }
            
            if(map_skuID_lSKU.keyset() != null)
            {
                map<String,boolean> skuProcessed = new map<String,boolean>();
                //for(String cus: map_skuID_lSKU.keyset())
                for (Ace_Customer_SKU_Changes__c slist: SKU_List)
                {
                    
                    String temp = '';
                    if(slist.Core_s_SKU_Vendor_Name__c == null || slist.Core_s_SKU_Vendor_Name__c == '')
                        temp = '' + slist.SKU__c + '-null';
                    else
                        temp = '' + slist.SKU__c + '-' + slist.Core_s_SKU_Vendor_Name__c;
                    if (!skuProcessed.containsKey(temp) && map_skuid_lsku.containsKey(temp))
                    {
                    List<Ace_Customer_SKU_Changes__c> lsku = new List<Ace_Customer_SKU_Changes__c>();
                    lsku = map_skuID_lSKU.get(temp);
                    if(lsku != null)
                    {
                        Integer noOfImpacted = 0;
                        Decimal spendImpact = 0;
                        String ChangeType  = '';
                        String VendorName = '';
                        String ChangeAmount = '';
                        Decimal UnitVolume = 0; 
                        String skuDescription = '';
                        String CoreListID = '';
                        String OwningCustomer = '';
                        ID skuID;
                        String SKUNO = '';
                        Set<ID> sImpID = new Set<ID>();
                        for(Ace_Customer_SKU_Changes__c ace : lSku)
                        {
                            skuID = ace.ID;
                            SKUNo = ace.SKU__c;
                            if (ace.sku_description__c != null)
                               skuDescription = ace.sku_description__c;
                            if (ace.CoreList_ID__c != null)
                               CoreListID = ace.CoreList_ID__c;
                            if (ace.Owning_Customer_Corelist_Priority__c != null)
                               OwningCustomer = ace.Owning_Customer_Corelist_Priority__c;
                              
                            if(ace.price_Changes_Type__c != null)
                            {
                                if(ace.price_Changes_Type__c == 'C')
                                    ChangeType = 'Cost';
                                else if(ace.price_Changes_Type__c == 'M')
                                    ChangeType = 'Margin';
                                else if(ace.price_Changes_Type__c == 'A')
                                    ChangeType = 'Alternate';
                                else if(ace.price_Changes_Type__c == 'D')
                                    ChangeType = 'Discontinued';
                            }    
                                
                            if(ace.Core_s_SKU_Vendor_Name__c != null)
                                VendorName = ace.Core_s_SKU_Vendor_Name__c;
                            
                           // if(ace.ChangeAmount_per__c != null)
                           //     ChangeAmount = String.valueOf(ace.ChangeAmount_per__c);
                            
                           // if(ace.Item_12_Month_Qty__c != null)
                           //     UnitVolume  =  UnitVolume  + ace.Item_12_Month_Qty__c;
                            
                           // if((ace.Total_Spend_Impact_12_Month__c!=null && ace.Total_Spend_Impact_12_Month__c!=0.00) && (ace.Item_12_Month_Qty__c!=null && ace.Item_12_Month_Qty__c!=0.00))                  
                           //     spendImpact  = spendImpact  + (ace.Total_Spend_Impact_12_Month__c/ace.Item_12_Month_Qty__c).setScale(2);
                            
                        }
                        
                        SKUListTable c = new SKUListTable();
                        c.sID = SKUNo;
                        c.skuId = skuID;
                        c.ImpactedCustomer = map_SKUVendor_Count.get(temp);  //sImpID.size();     
                        c.changeType = changeType;
                        c.ChangeAmount = String.valueOf(map_SKUVendor_ChangeAmount.get(temp)); // changeAmount;
                        c.VendorName = VendorName;
                        c.SPNDIMPACT = map_SKUVendor_SpendImpact.get(temp);
                        c.SPNDIMPACT1 = String.valueOf(map_SKUVendor_SpendImpact.get(temp));  //spendImpact);
                        c.UnitVolume =   String.ValueOf(map_SKUVendor_AnnualUsage.get(temp)); // String.ValueOf(UnitVolume);
                        c.UnitVolumeN = map_SKUVendor_AnnualUsage.get(temp);
                        c.skuDescription = skuDescription;
                        c.CoreListID = CoreListID;
                        c.OwningCustomer = OwningCustomer;
                        
                        if (!skuDisplayed.containskey(c.skuId+c.VendorName)) {
                            clsSKUListTable.add(c); 
                            skuDisplayed.put(c.skuId+c.VendorName,true);
                        }
                      }
                        skuprocessed.put(temp,true);
                    }
                    
                    
                 }
             } 
            
            
            
            for(SKUListTable sLT : clsSKUListTable) 
            {
                sLT.sortOrder = sortDirection;
                sLT.sortedField = getFieldName;
                
                
            }
        //Sorting  for Non DB values 00826597 
        If(getFieldName == 'ImpCust')
        {
			
            clsSKUListTable.sort();
        }
     }         
    
     public static String sortBy{get;set;} 
     public static String sortByField{get;set;} 
     
     global class SKUListTable  implements Comparable
     {
        public Ace_Customer_SKU_Changes__c  ts{get;set;}
        public String SID{get;set;}
        public ID skuId {get;set;}
        public String NAME{get;set;}
        public Decimal SPNDIMPACT{get;set;}
        public String SPNDIMPACT1{get;set;}
        public Integer ImpactedCustomer{get;set;}
        public String ChangeType{get;set;}
        public String VendorName{get;set;}
        public String ChangeAmount{get;set;}
        public String skuDescription {get;set;}
        public String UnitVolume{get;set;}
        public Decimal UnitVolumeN{get;set;}
        public String CoreListID{get;set;}
        public String OwningCustomer{get;set;}
        public String sortedField{get;set;}
        public String sortOrder{get;set;}
        
        //Implemented for 00826597
        global Integer compareTo(Object compareTo)
            {
                
                SKUListTable compareToSKUListTable = (SKUListTable)compareTo;
                if(sortedField == 'ImpCust')
                {
                    if(compareToSKUListTable.sortOrder == 'ASC')
                    {
                        if (ImpactedCustomer == compareToSKUListTable.ImpactedCustomer) return 0;
                        if (ImpactedCustomer > compareToSKUListTable.ImpactedCustomer) return 1;
                        return -1; 
                    }
                    else
                    {
                        if (ImpactedCustomer == compareToSKUListTable.ImpactedCustomer) return 0;
                        if (ImpactedCustomer > compareToSKUListTable.ImpactedCustomer) return -1;
                        return 1;
                    }
           		}
                else
                {
                    return 0; //Default
                }
            }
        // public String sortBy{get;set;} 
           
        /* global Integer compareTo(Object objToCompare) 
        {
          //Sort by BookName Alphabetically
          //    return SID.compareTo(((SKUListTable)objToCompare).SID);
              
            if (sortBy.equals('ASC'))
            {    
                if(sortByfield.equals('SKU'))
                {
                    return SID.compareTo(((SKUListTable)objToCompare).SID);       
                }
                else  if(sortByfield.equals('OwningCustomer'))
                {
                    return OwningCustomer.compareTo(((SKUListTable)objToCompare).OwningCustomer);       
                }
                else  if(sortByfield.equals('ChangeType'))
                {
                    return ChangeType.compareTo(((SKUListTable)objToCompare).ChangeType);       
                } 
                else  if(sortByfield.equals('CoreListID'))
                {
                    return CoreListID.compareTo(((SKUListTable)objToCompare).CoreListID);       
                } 
                else  if(sortByfield.equals('UnitVolume'))
                {
                    return UnitVolume.compareTo(((SKUListTable)objToCompare).UnitVolume);       
                }
                else  if(sortByfield.equals('SpendImpact'))
                {
                      return SPNDIMPACT1.compareTo(((SKUListTable)objToCompare).SPNDIMPACT1); 
                }
                else  if(sortByfield.equals('Percent'))
                {
                    return ChangeAmount.compareTo(((SKUListTable)objToCompare).ChangeAmount);       
                }
                else
                    return -1;  
            } else if (sortBy.equals('DESC')) 
            {
                if(sortByfield.equals('SKU'))
                {
                    return SID.compareTo(((SKUListTable)objToCompare).SID) * (-1);       
                }
                else if(sortByfield.equals('ChangeType'))
                {
                    return ChangeType.compareTo(((SKUListTable)objToCompare).ChangeType) * (-1);       
                }
                else if(sortByfield.equals('CoreListID'))
                {
                    return CoreListID.compareTo(((SKUListTable)objToCompare).CoreListID) * (-1);       
                }
                else if(sortByfield.equals('OwningCustomer'))
                {
                    return OwningCustomer.compareTo(((SKUListTable)objToCompare).OwningCustomer) * (-1);       
                }
                else  if(sortByfield.equals('UnitVolume'))
                {
                    return UnitVolume.compareTo(((SKUListTable)objToCompare).UnitVolume) * (-1);       
                }
                else  if(sortByfield.equals('SpendImpact'))
                {
                   return SPNDIMPACT1.compareTo(((SKUListTable)objToCompare).SPNDIMPACT1) * (-1);       
                }
                else  if(sortByfield.equals('Percent'))
                {
                    return ChangeAmount.compareTo(((SKUListTable)objToCompare).ChangeAmount) * (-1);       
                }
                
                else
                    return -1;    
            } 
            else
                return -1;  
        }     */                            
    }
    
    public void nextPage(){
        counter = counter+List_size;
        system.debug('Next Counter Value:' + counter);
       // processSelected();
        getURL();
    }
    public void prevPage(){
        counter = counter-List_size;
        skuDisplayed.clear();
        system.debug('Previous Counter Value:' + counter);
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