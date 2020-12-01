trigger aceCustomerSKUChanges on Ace_Customer_SKU_Changes__c (After update,After Insert,before insert,before update) 
{      
      
         if (Trigger.isBefore){         
        	//00826551
        	for(Ace_Customer_SKU_Changes__c skuRec : Trigger.new)
			{
        		System.debug('&&&&&&&&&Inside'+skuRec.Customer_Price_Change__c);
            	skuRec.Customer_Core_Price_Changes__c = skuRec.Customer_Price_Change__c ;               
        	}
		}
      
      
    list<ACE_Settings__c> desettings =[SELECT Id, trigger_by_pass__c from ACE_Settings__c limit 1];
        if(desettings[0]!= null) {
            if (desettings[0].trigger_by_pass__c != null) {
              boolean userByPass = desettings[0].trigger_by_pass__c.contains(userInfo.getUserId());
              if (userByPass) {
               system.debug('UserByPassTrigger Set');
               return;  
             }
            }
        }
  
  If(Trigger.isAfter)
  {

    
   System.debug ('Processing SKU Trigger');
    
   list<ID> recordIDs = new list<ID>();
   list<Audit_History__c> aHist = new list<Audit_History__c> ();
   
   // Logic to Sync Changes to customer view - Begins (Ivarada)
   
   Map<String,ace_customer_sku_changes__c> skuidKeyMap = new Map<String,ace_customer_sku_changes__c> ();
   list<ace_customer_view__c> custViewUpd = new list<ace_customer_view__c>();
   set<String> skuNames = new Set<String>();
   list<ID> cpList = new list<ID>();
   Map<ID,String> customerMailOutMap = new Map<ID,String>();
   Map<String,Product2> productsMap = new Map<String,Product2>();
   Map<ID,String> skuexistsForUpdate = new Map<ID,String>();
   set<id> pidsForDel = new set<id>();
   map<id,decimal> custToSkuCount = new Map<id,decimal>();
   Set<String> sALTSKUIDs = new Set<String>(); 
   Map<String,Ace_Customer_SKU_Changes__c> map_ASKu_SKu = new Map<String,Ace_Customer_SKU_Changes__c>(); 
   
    if (Trigger.isInsert) {
       //Added status__c for story S-410496
       for(ace_customer_sku_changes__c s: [select id,status__c,CoreList_ID__c,Owning_Customer_ID__c,SKU_Alt__c,Alternate_Chosen_Flag__c,price_changes_type__c,Item_12_Month_Qty__c,sku_last_update__c,
       ace_customer_core_changes__r.ace_customer_price_changes__r.id,sku_description__c,Item_12_Month_Sales__c,current_sell_price__c,uom__c,
       Approved_Proposed_Price__c,Sales_Price_Change_Effective_Date_Approv__c,sku__c,ace_customer_core_changes__r.ace_customer_price_changes__r.page_key__c,
       QPU__c, New_List_Price__c from ace_customer_sku_changes__c where id in :Trigger.newMap.keySet() and status__c != 'Inactive']) {  
           skunames.add(s.sku__c); 
           cpList.add(s.ace_customer_core_changes__r.ace_customer_price_changes__r.ID);
           skuidKeyMap.put(s.ace_customer_core_changes__r.ace_customer_price_changes__r.page_key__c + s.sku__c,s);
       }
       
       for (ace_customer_sku_changes__c s: Trigger.new) {
         if (s.Alternate_Chosen_Flag__c)
           sALTSKUIDs.add(s.SKU_Alt__c);
       }
       
       for(Ace_Customer_SKU_Changes__c ASRec: [Select id,Owning_Customer_ID__c,CoreList_ID__c, SKU__c,Current_Sell_Price__c,approved_proposed_price__c,SKU_Description__c,UOM__c,
       QPU__c, New_List_Price__c from Ace_Customer_SKU_Changes__c where SKU__c in :sALTSKUIDs and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in :cpList])
             map_ASKu_SKu.put(ASRec.SKU__c+ASRec.CoreList_ID__c+ASRec.Owning_Customer_ID__c, ASRec);
       
       for (Product2 prd: [Select id, SKUID__c, quntity_per_unit__c from Product2 where SKUID__c in :skunames])
           productsMap.put(prd.skuid__c,prd);
       
        for (Ace_customer_mailout__c m:[select id,customer__c,Customer_Core_Price_Changes__c from ace_customer_mailout__c where customer_core_price_changes__c = :cplist]) {
            customerMailoutMap.put(m.Customer_Core_Price_Changes__c,'Exists');
        }
        for (ace_customer_sku_changes__c s: skuidKeyMap.values()) {
            if (customerMailoutMap.containskey(s.ace_customer_core_changes__r.ace_customer_price_changes__r.id) && s.price_Changes_Type__c != 'A') {
                
                ACE_Customer_View__c aceCust = new ACE_Customer_View__c();
                aceCust.Current_Sell_Price__c = s.Current_Sell_Price__c;
                aceCust.Sales_Price_Change_Effective_Date_Appro__c = s.Sales_Price_Change_Effective_Date_Approv__c;
                //aceCust.Expiration_Date__c = system.now().date().addDays(Integer.valueOf(aceSetting.Expiry_Days__c));
                aceCust.Item_12_Month_Sales__c = s.Item_12_Month_Sales__c;
                aceCust.Approved_Proposed_Price__c = s.Approved_Proposed_Price__c;
                aceCust.Old_Price__c = s.Current_Sell_Price__c;
                aceCust.SKU_Description__c = s.SKU_Description__c;
                aceCust.Item_12_Month_Qty__c = s.Item_12_Month_Qty__c;
                aceCust.sku_last_update__c = s.sku_last_update__c;
                aceCust.UOM__c = s.UOM__c;
               // Modified for 00827451
                          aceCust.QPU__c =  s.QPU__c;
                          aceCust.List_Price__c=  s.New_List_Price__c;
                
               if(s.status__c == 'Deleted' && s.price_Changes_Type__c == 'D')
                   aceCust.Status__c = 'D';
               else if(s.status__c == 'Deleted' && s.price_Changes_Type__c != 'D')
                  aceCust.Status__c = 'R'; 
                aceCust.name = s.ace_customer_core_changes__r.ace_customer_price_changes__r.Page_Key__c;
               
               if(s.SKU_Alt__c != null && map_ASKu_SKu.containsKey(s.SKU_Alt__c+s.CoreList_ID__c+s.Owning_Customer_ID__c))
               {
                              system.debug('Inside Alt Fetch Logic');
                              aceCust.Alt_SKU__c = s.SKU_Alt__c;
                              Ace_Customer_SKU_Changes__c skuRec = map_ASKu_SKu.get(s.SKU_Alt__c+s.CoreList_ID__c+s.Owning_Customer_ID__c);
                              aceCust.Alt_Sell_Price__c = SkuRec.approved_proposed_price__c;
                              aceCust.Alt_SKU_Description__c = SkuRec.SKU_Description__c;
                              aceCust.Alt_UOM__c = SkuRec.UOM__c;   
                              // Modified for 00827451
                          aceCust.Alt_QPU__c =  SkuRec.QPU__c;
                          aceCust.Alt_List_Price__c=  SkuRec.New_List_Price__c;                
                }
                
                
                if (productsMap.containsKey(s.sku__c))
                   aceCust.Quantity_Per_Unit__c = productsMap.get(s.sku__c).quntity_per_unit__c;
                   
                custViewUpd.add(aceCust);
            }
        }
       
        insert custViewUpd;
        
        
    }
    //Code added by guha - SKU Count increment on customer [5/29/2014]
        set<String> sku_ids3 = new set<String>();
       //temporary commented by dee
       /* for (ACE_Customer_sku_Changes__c s: Trigger.new) {
            //added below null check because it was hitting null pointer exception at new record insert from test class.  - by Guha 23rd July.
            if(Trigger.isUpdate){
                if((Trigger.OldMap.get(s.id).status__c == null && s.status__c == 'Active')||(s.status__c != Trigger.OldMap.get(s.id).status__c && s.status__c == 'Active')){
                    sku_ids3.add(s.id);              
                }
            }
            if(Trigger.isUpdate){
                if(s.status__c == 'Active'){
                    sku_ids3.add(s.id);              
                }
            }    
                
        }*/
        
        //Code for Incrementing on Customer sku count
        list<ace_customer_price_changes__c> cpUpd1 = new list<ace_customer_price_changes__c>();
        if (sku_ids3.size() > 0) {
        for(AggregateResult sk:[select Price_Change_ID__c custid, count(id) cnt from ace_customer_sku_changes__c where id in:sku_ids3 group by Price_Change_ID__c]){          
            ace_customer_price_changes__c cp1 = new ace_customer_price_changes__c(id=String.valueof(sk.get('custid')));
            if(cp1.Report_SKU_Count__c != null){
                cp1.Report_SKU_Count__c = cp1.Report_SKU_Count__c + Integer.valueof(sk.get('cnt'));          
                cpUpd1.add(cp1);
            }
            else{
                cp1.Report_SKU_Count__c = Integer.valueof(sk.get('cnt'));
            }
        }
        }
        if(cpUpd1.size()>0)
            update cpUpd1;                
  
    //End of - Code added by guha - SKU Count increment/Decrement on customer [5/29/2014]
    
    if (Trigger.isupdate) {    
        
        // Added by Guha [06/May/2014]
        set<String> sku_ids = new set<String>();// [29/may/2014]
        set<String> sku_ids2 = new set<String>();
        
        List<ID> skuIds = new List<ID>(); 
        List<ID> skuIds2 = new List<ID>();                 
        Map<ID,ace_customer_price_changes__c> map_custRecUpdt = new Map<ID,ace_customer_price_changes__c>();
        // Added by Guha [06/May/2014] Ends
        
        //Code by ivarada:Begins - 9/8/2014 to capture vendavo response
         Map<ID,String> custToStatus = new Map<ID,String> ();
         Map<ID,Boolean> failedCust = new Map<ID,Boolean> ();
         Map<ID,Boolean> notProcessedCust = new Map<ID,Boolean> ();
         Set<ID> skuStatusChange = new Set<ID>();
         sALTSKUIDs.clear();
         
         for(ace_customer_sku_changes__c s: [select id,CoreList_ID__c,Owning_Customer_ID__c,SKU_Alt__c,Alternate_Chosen_Flag__c,price_changes_type__c,Item_12_Month_Qty__c,sku_last_update__c,ace_customer_core_changes__r.ace_customer_price_changes__r.id,sku_description__c,Item_12_Month_Sales__c,current_sell_price__c,uom__c,Approved_Proposed_Price__c,Sales_Price_Change_Effective_Date_Approv__c,sku__c,ace_customer_core_changes__r.ace_customer_price_changes__r.page_key__c,
         QPU__c, New_List_Price__c from ace_customer_sku_changes__c where id in :Trigger.newMap.keySet() and status__c != 'Inactive']) {  
           
           cpList.add(s.ace_customer_core_changes__r.ace_customer_price_changes__r.ID);
         }
         
         for (ace_customer_sku_changes__c s: Trigger.new) {
           if (s.Alternate_Chosen_Flag__c)
            sALTSKUIDs.add(s.SKU_Alt__c);
         }
         
         for(Ace_Customer_SKU_Changes__c ASRec: [Select id,Owning_Customer_ID__c,CoreList_ID__c, SKU__c,Current_Sell_Price__c,approved_proposed_price__c,SKU_Description__c,UOM__c,QPU__c, New_List_Price__c from Ace_Customer_SKU_Changes__c where SKU__c in :sALTSKUIDs and Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c in :cpList])
             map_ASKu_SKu.put(ASRec.SKU__c+ASRec.CoreList_ID__c+ASRec.Owning_Customer_ID__c, ASRec);
         
         for (ace_customer_sku_changes__c s: Trigger.new)  {
            
            if (s.Alternate_Chosen_Flag__c)
              sALTSKUIDs.add(s.SKU_Alt__c);
            if (s.Implementation_Status__c != Trigger.oldMap.get(s.id).Implementation_Status__c && (s.Implementation_Status__c == 'DATA-FAILED' || s.Implementation_Status__c == 'DATA-SUCCESS') ) {
                skuStatusChange.add(s.id);
                if (custToStatus.get(s.Price_Change_ID__c) != 'DATA-FAILED')
                  custToStatus.put(s.Price_Change_ID__c,s.Implementation_Status__c);
            }
         }  
         
         
         
          // Find failed or Not Processed SKUs - Excludes current SKUs
         for (ace_customer_sku_changes__c sf : [select Price_Change_ID__c,id,Implementation_Status__c,QPU__c, New_List_Price__c from ace_customer_sku_changes__c where ace_customer_core_changes__r.ace_customer_price_changes__c = :custToStatus.keySet() and ID != :skuStatusChange and (Implementation_Status__c = 'DATA-FAILED' OR Implementation_Status__c = NULL) and status__c != 'Inactive']) { 
         //for (ace_customer_sku_changes__c sf : [select Price_Change_ID__c,id,Implementation_Status__c from ace_customer_sku_changes__c where Price_Change_ID__c = :custToStatus.keySet() and ID != :skuStatusChange and (Implementation_Status__c = 'DATA-FAILED') and status__c != 'Inactive']) { 
            if (sf.Implementation_Status__c == 'DATA-FAILED') {
              failedCust.put(sf.Price_Change_ID__c,true);
    
            }
            else
              notProcessedCust.put(sf.Price_Change_ID__c,true);
         }
         
         
         List<ace_customer_price_changes__c> custPriceUpd = new list<ace_customer_price_changes__c>();
         for (ID i: custToStatus.keySet()) {
         
            ace_customer_price_changes__c aPrice = new ace_customer_price_changes__c (ID = i);
            boolean processed = false;

            if (failedCust.containsKey(i) || notProcessedCust.containsKey(i)) {
              if (failedCust.containsKey(i))
               aPrice.Implementation_Status_Code__c = 'DATA-FAILED';
               processed = true;
            }
            
            if (!processed)
              aPrice.Implementation_Status_Code__c = custToStatus.get(i);
              
            custPriceUpd.add(aPrice);
         }

         database.update(custPriceUpd,false);
         
        //Code by ivarada:Ends - 9/8/2014 to capture vendavo response
        
      for (ACE_Customer_sku_Changes__c s: Trigger.new) {   
       if (s.Approved_Proposed_Price__c != Trigger.oldMap.get(s.id).Approved_Proposed_price__c
          || (s.Sales_Price_Change_Effective_Date_Approv__c != Trigger.oldMap.get(s.id).Sales_Price_Change_Effective_Date_Approv__c
               && s.Sales_Price_Change_Effective_Date_Approv__c > Trigger.oldMap.get(s.id).Sales_Price_Change_Effective_Date_Approv__c)
          || (s.status__c != Trigger.oldMap.get(s.id).status__c))
            recordIDs.add(s.id);
            
       // Added by Guha [06/May/2014]
       if(s.Approval_status__c != Trigger.oldMap.get(s.id).Approval_status__c && (s.Approval_status__c == 'Approved' || s.Approval_status__c == 'Rejected'))     
           skuIds.add(s.id); 
       
       // Added by Guha [07/May/2014]
       if(s.Approval_status__c != Trigger.oldMap.get(s.id).Approval_status__c && s.Approval_status__c == 'Pending')     
           skuIds2.add(s.id);       
       //scrapped off as we have existing logic for this - by Guha [14/may/2014].
       /*if(s.Approved_Proposed_Price__c != Trigger.OldMap.get(s.id).Approved_Proposed_Price__c 
                     && s.Approval_status__c != Trigger.OldMap.get(s.id).Approval_status__c){              
              sku_ids.add(s.id);              
       } */  
       
       //Code added by guha - SKU Count Decrement on customer [5/29/2014]
       
       if(s.status__c != Trigger.OldMap.get(s.id).status__c 
                     && s.status__c == 'Deleted'){              
              sku_ids.add(s.id); 
              pidsForDel.add(s.price_change_id__c); 
              system.debug('entering into list>>>>>>>>>');            
       }
       
       
       if(s.Approved_Proposed_Price__c != s.Proposed_Price_with_Cap__c && s.Approved_Proposed_Price__c != trigger.oldmap.get(s.id).Approved_Proposed_Price__c){
           sku_ids2.add(s.id);
       }
       
       
      }
      
      for (ace_customer_price_changes__c c: [select id,report_sku_count__c from ace_customer_price_changes__c where id = :pidsForDel]) {
         custToSkuCount.put(c.id,c.report_sku_count__c);
         system.debug('entering into map>>>>>>>>>');
       }
      
      //Code added by guha - Customer with 100% passthru in Reporting [5/29/2014]     
      list<ace_customer_price_changes__c> cpUpd2 = new list<ace_customer_price_changes__c>();      
      set<String> cids2 = new set<String>();
      
      if (sku_ids2.size() > 0) {
        for(ace_customer_sku_changes__c cus2: [select Price_Change_ID__c from ace_customer_sku_changes__c where id in:sku_ids2]){
          cids2.add(cus2.Price_Change_ID__c);        
        }
      }
      
      for (String i:cids2) {
          ace_customer_price_changes__c cp2 = new ace_customer_price_changes__c(id=i);
          cp2.Report_isSKU_Exception__c = true;
          cpUpd2.add(cp2); 
      }
      if (cpUpd2.size()> 0) {
       update cpUpd2;
       cids2.clear();
      }
      //Code by guha ends - Customer with 100% passthru in Reporting
      
      //Code added by guha - SKU Count increment/Decrement on customer [5/29/2014]           
      //Code for Decrementing on Customer sku count
      list<ace_customer_price_changes__c> cpUpd3 = new list<ace_customer_price_changes__c>();    
      
      if (sku_ids.size() > 0) {                  
        for(AggregateResult sk:[select Price_Change_ID__c custid, count(id) cnt from ace_customer_sku_changes__c where id in:sku_ids group by Price_Change_ID__c]){          
           ace_customer_price_changes__c cp1 = new ace_customer_price_changes__c(id=String.valueof(sk.get('custid')));
           system.debug('Deepak:' + custToSkuCount.get((id)sk.get('custid')) + ':' + String.valueof(sk.get('custid')));
           
           if(custToSkuCount.containskey((id)sk.get('custid'))){
             if (custToSkuCount.get((id)sk.get('custid')) != null && custToSkuCount.get((id)sk.get('custid')) <> 0 ){
              system.debug('Decrement happens>>>>>>');
              system.debug('Decrement happens>>>>>>custToSkuCount.get'+custToSkuCount.get((id)sk.get('custid')) +'Integer.valueof>>>>>>>'+Integer.valueof(sk.get('cnt')));
              cp1.Report_SKU_Count__c = custToSkuCount.get((id)sk.get('custid')) - Integer.valueof(sk.get('cnt'));   
              system.debug('Decrement happens>>>>>>'+cp1.Report_SKU_Count__c);
              }    
            }
          cpUpd3.add(cp1);
         }
      }
      
      if(cpUpd3.size()>0) {
          system.debug('Decrement happens@@@@@@@');
          update cpUpd3;
      }
  
      
      //Added by IVARADA - Begins      
      list<ace_customer_price_changes__c> cpUpd = new list<ace_customer_price_changes__c>();
      
      set<id> cids = new set<id>();
      
      if (skuIds2.size() > 0) {
       for(ace_customer_sku_changes__c cus: [select ace_customer_core_changes__r.ace_customer_price_changes__c from ace_customer_sku_changes__c where id in: skuIds2 and ace_customer_core_changes__r.ace_customer_price_changes__r.SKU_Approval_Pending__c = false]){
          cids.add(cus.ace_customer_core_changes__r.ace_customer_price_changes__c);        
       }
      }
      
      for (id i:cids) {
          ace_customer_price_changes__c cp = new ace_customer_price_changes__c(id=i);
          cp.SKU_Approval_Pending__c = true;
          cpUpd.add(cp); 
      }
      cids.clear();
      
      Map<String,Boolean> pendingSkuExists = new Map<String,Boolean> ();
      if(skuIds.size() > 0) {
       for(ace_customer_sku_changes__c cus: [select ace_customer_core_changes__r.ace_customer_price_changes__c from ace_customer_sku_changes__c where id in: skuIds and ace_customer_core_changes__r.ace_customer_price_changes__r.SKU_Approval_Pending__c = true])
        cids.add(cus.ace_customer_core_changes__r.ace_customer_price_changes__c);
      }
      if (cids.size() > 0) {
       for (ace_customer_sku_changes__c s : [select id,Price_Change_ID__c from ace_customer_sku_changes__c where Price_Change_ID__c = :cids and Approval_status__c = 'Pending'])
        pendingSkuExists.put(s.Price_Change_ID__c,true);
      }
      for (ID I: cids) {
        if (!pendingskuExists.containskey(string.valueof(I))) {
          ace_customer_price_changes__c cp = new ace_customer_price_changes__c(id=I);
          cp.SKU_Approval_Pending__c = false;
          cpUpd.add(cp);
        }
      }
      if (cpUpd.size() >0)
        update cpUpd;
      //Added by IVARADA - Ends
      
      
      Map<String,ace_customer_sku_changes__c> AlternateSkuMap = new Map<String,ace_customer_sku_changes__c> ();
      set<String> AltList = new Set<String> ();
      list<ace_customer_sku_changes__c> aSkus = new list<ace_customer_sku_changes__c>();
      if (recordIDs.size() >0)
       aSkus = [select id,batchid__c,price_Changes_Type__c,owning_customer_id__c,CoreList_ID__c,status__c,SKU_Alt__c,
       Item_12_Month_Qty__c,sku_last_update__c,Item_12_Month_Sales__c,Current_Sell_Price__c,
       ace_customer_core_changes__r.ace_customer_price_changes__r.ID,Approved_Proposed_Price__c,
       Sales_Price_Change_Effective_Date_Approv__c,sku__c,SKU_Description__c,uom__c,
       ace_customer_core_changes__r.ace_customer_price_changes__r.page_key__c,QPU__c, New_List_Price__c 
       from ace_customer_sku_changes__c where id in :recordIDs and status__c != 'Inactive'];
      
      if (recordIDs.size() >0) {
        for(ace_customer_sku_changes__c s: aSkus) {
            skuidKeyMap.put(s.ace_customer_core_changes__r.ace_customer_price_changes__r.page_key__c + s.sku__c,s);
            cpList.add(s.ace_customer_core_changes__r.ace_customer_price_changes__r.ID);
            skunames.add(s.sku__c);    
        }
      }  
        
        set <String> removeSkus = new Set<String> ();
        
        if (recordIDs.size()>0) {
         for (ace_customer_sku_changes__c s: [select ace_customer_core_changes__r.ace_customer_price_changes__r.page_key__c,sku__c from ace_customer_sku_changes__c where id in :recordIDs and status__c = 'Inactive']) {
            removeskus.add(s.ace_customer_core_changes__r.ace_customer_price_changes__r.page_key__c + s.sku__c);
         }
        }
        system.debug('cplist:' + cpList);
        if (cplist.size() > 0) {
         for (Ace_customer_mailout__c m:[select id,customer__c,Customer_core_price_Changes__c from ace_customer_mailout__c where customer_core_price_changes__c = :cplist]) {
            customerMailoutMap.put(m.Customer_Core_Price_Changes__c,'Exists');
            system.debug('test');
         }
        }
        
        for (ace_customer_sku_changes__c s:aSkus) {
            if (s.SKU_Alt__c != null && customerMailoutMap.containsKey(s.ace_customer_core_changes__r.ace_customer_price_changes__r.ID))
              AltList.add(s.sku_Alt__c);
        }
        
       for (ace_customer_sku_changes__c s: [select id,batchid__c,owning_customer_id__c,CoreList_ID__c,Current_Sell_Price__c,SKU_Description__c,UOM__c,QPU__c, New_List_Price__c from ace_customer_sku_changes__c where SKU__c IN :AltList and status__c = 'Active' and Price_Changes_Type__c = 'A']) 
           AlternateSkuMap.put(s.batchid__c+s.owning_customer_id__c+s.CoreList_ID__c,s);    
      
        
        if (removeskus.size() > 0)
         Delete [select id from ace_customer_view__c where recordKey__c in :removeskus];
        
        if (skunames.size() >0)
        for (Product2 prd: [Select id, SKUID__c, quntity_per_unit__c from Product2 where SKUID__c in :skunames])
           productsMap.put(prd.skuid__c,prd);
        
        if (skuidKeyMap.size() > 0) {
            
          for (ace_customer_view__c v:[select id,recordkey__c from ace_customer_view__c where recordkey__c = :skuidKeyMap.keySet()]) {
            system.debug('Customer View SKU Update');
            v.Sales_Price_Change_Effective_Date_Appro__c = skuidKeyMap.get(v.recordkey__c).Sales_Price_Change_Effective_Date_Approv__c;
            v.Approved_Proposed_Price__c = skuidKeyMap.get(v.recordkey__c).Approved_Proposed_Price__c;
            v.Price_Changed_After_Notify__c = true;
             if(skuidKeyMap.get(v.recordkey__c).status__c == 'Deleted' && skuidKeyMap.get(v.recordkey__c).price_Changes_Type__c == 'D')
                   v.Status__c = 'D';
               else if(skuidKeyMap.get(v.recordkey__c).status__c == 'Deleted' && skuidKeyMap.get(v.recordkey__c).price_Changes_Type__c != 'D')
                  v.Status__c = 'R'; 
            
            if(skuidKeyMap.get(v.recordkey__c).SKU_Alt__c != null && map_ASKu_SKu.containsKey(skuidKeyMap.get(v.recordkey__c).SKU_Alt__c+skuidKeyMap.get(v.recordkey__c).CoreList_ID__c+skuidKeyMap.get(v.recordkey__c).Owning_Customer_ID__c))
            {
                                  system.debug('Inside Alt Fetch Logic');
                                  v.Alt_SKU__c = skuidKeyMap.get(v.recordkey__c).SKU_Alt__c;
                                  Ace_Customer_SKU_Changes__c skuRec = map_ASKu_SKu.get(skuidKeyMap.get(v.recordkey__c).SKU_Alt__c+skuidKeyMap.get(v.recordkey__c).CoreList_ID__c+skuidKeyMap.get(v.recordkey__c).Owning_Customer_ID__c);
                                  v.Alt_Sell_Price__c = SkuRec.approved_proposed_price__c;
                                  v.Alt_SKU_Description__c = SkuRec.SKU_Description__c;
                                  v.Alt_UOM__c = SkuRec.UOM__c;                          
                              }
      
            
            custViewUpd.add(v);
            skuexistsForUpdate.put(skuidKeyMap.get(v.recordkey__c).id,'Exists');
          }
       
        }
         if (custViewUpd.size() > 0)
          Update custViewUpd;
        
        custViewUpd.clear();
        
        for (ace_customer_sku_changes__c s: skuidKeyMap.values()) {
            system.debug('Check1:' + skuexistsForUpdate.size() + ':' + customerMailoutMap.containsKey(s.ace_customer_core_changes__r.ace_customer_price_changes__r.id) + ':' + skuexistsForUpdate.containsKey(s.id));
            if (customerMailoutMap.containsKey(s.ace_customer_core_changes__r.ace_customer_price_changes__r.id) && s.price_changes_type__c != 'A' && !skuexistsForUpdate.containsKey(s.id)) {
                
                ACE_Customer_View__c aceCust = new ACE_Customer_View__c();
                aceCust.Current_Sell_Price__c = s.Current_Sell_Price__c;
                aceCust.Sales_Price_Change_Effective_Date_Appro__c = s.Sales_Price_Change_Effective_Date_Approv__c;
                //aceCust.Expiration_Date__c = system.now().date().addDays(Integer.valueOf(aceSetting.Expiry_Days__c));
                aceCust.Item_12_Month_Sales__c = s.Item_12_Month_Sales__c;
                aceCust.Item_12_Month_Qty__c = s.Item_12_Month_Qty__c; 
                aceCust.SKU_Last_Update__c = s.sku_last_update__c;
                aceCust.Approved_Proposed_Price__c = s.Approved_Proposed_Price__c;
                aceCust.Old_Price__c = s.Current_Sell_Price__c;
                aceCust.SKU_Description__c = s.SKU_Description__c;
                aceCust.UOM__c = s.UOM__c;
                aceCust.Sku__c =  s.SKU__c;
                aceCust.name = s.ace_customer_core_changes__r.ace_customer_price_changes__r.Page_Key__c;
                // Modified for 00827451
                aceCust.QPU__c =  s.QPU__c;
                aceCust.List_Price__c=  s.New_List_Price__c;
                
                if (productsMap.containsKey(s.sku__c))
                   aceCust.Quantity_Per_Unit__c = productsMap.get(s.sku__c).quntity_per_unit__c;
                custViewUpd.add(aceCust);
            
            }
        }
         if (custViewUpd.size() > 0)
            insert custViewUpd;
        
      // Logic to Sync Changes to customer view - Ends (Ivarada)
  
      
      for (Ace_Customer_SKU_Changes__c c:Trigger.new) {
      
        if (c.Approval_status__c != Trigger.OldMap.get(c.id).Approval_status__c ||
            c.Approved_Proposed_Price__c != Trigger.OldMap.get(c.id).Approved_Proposed_Price__c) {
           Audit_History__c ah = new Audit_History__c();
           
           ah.Ace_Customer_SKU_Changes__c = c.ID;
               
           
           ah.New_Approval_Status__c = c.Approval_Status__c;
           ah.Old_Approval_Status__c = Trigger.OldMap.get(c.id).Approval_Status__c;
           
           ah.New_Approval_Price__c = c.Approved_Proposed_Price__c;
           ah.Old_Approval_Price__c = Trigger.OldMap.get(c.id).Approved_Proposed_Price__c;
           
           ah.New_User_Proposed_Price__c = c.Proposed_Price__c;
           ah.Old_User_Proposed_Price__c = Trigger.OldMap.get(c.id).Proposed_Price__c;
           
           ah.SKU__c = c.SKU__c; // for price change level
           //ah.HomePage_Approval_History__c = false;
           system.debug ('Processing SKU :'+c.ID);           
           aHist.add(ah);                                 
           
        }
        
      }
         insert ahist;
         system.debug('Trigger Processing Complete');
    }
    
    //Added 4/25/2014 by IVARADA : Begins - Reset Customer response in case price changes on unlock
      // Code commented as part of case fix - 00349491
       /* list<ace_customer_price_changes__c> cUpd = new list<ace_customer_price_changes__c>();
        if (cplist.size() > 0) {
          for (ace_customer_price_changes__c c : [select id,customer_response__c,customer_comments__c,customer_response_email__c,implementation_status_code__c from ace_customer_price_changes__c where id=:cplist and sfdc_notification_flag__c ='3' and customer_response__c = 'Approved']) {
            c.customer_response__c = 'Pending';
            c.customer_response_email__c = null;
            c.customer_comments__c = null;
            cUpd.add(c);
          }
        }
        update cUpd; */
        //Added 4/25/2014 by IVARADA : ends
    
  }
  
  // -  New record is inserted
   if (Trigger.isBefore)
   {
    if(Trigger.IsInsert)
    {
        for(Ace_Customer_SKU_Changes__c sku : Trigger.new)
        {
            sku.Vendavo_Update_Date__c = System.now();               
        }
    }
    
    
    //  - 'Approved_Proposed_Price__c' is modified.
    //  - 'Sales_Price_Change_Effective_Date_Approv__c' is modified
    //  - 'Status__c' is Modified

    if(Trigger.IsUpdate)
    {
        
        for(Ace_Customer_SKU_Changes__c sku : Trigger.new)
        {
            if((sku.Status__c != 'Inactive') && ((sku.Status__c != Trigger.OldMap.get(sku.id).Status__c) || (sku.Approved_Proposed_Price__c != Trigger.OldMap.get(sku.id).Approved_Proposed_Price__c) || (sku.Sales_Price_Change_Effective_Date_Approv__c != Trigger.OldMap.get(sku.id).Sales_Price_Change_Effective_Date_Approv__c && sku.Sales_Price_Change_Effective_Date_Approv__c > Trigger.OldMap.get(sku.id).Sales_Price_Change_Effective_Date_Approv__c))) {
                sku.Vendavo_Update_Date__c = System.now();   
                
            }       
        }
    }
    
  }
    
    
}