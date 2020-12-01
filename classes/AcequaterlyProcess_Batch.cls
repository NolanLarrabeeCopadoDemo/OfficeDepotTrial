global class AcequaterlyProcess_Batch implements database.Batchable<Sobject> 
{
    public String acequery ;  
    global Map<String,Ace_Customer_Core_Changes__c> map_aceCore;
    global String batchId = '1';
    global Date qtrStartDate;
    global Date qtrEndDate;
    
  global AcequaterlyProcess_Batch (){
        
        Map<String,String> qtrStart =  new Map<String,String> ();
        qtrStart.put('Q1','01/01');qtrStart.put('Q2','04/01');
        qtrStart.put('Q3','07/01');qtrStart.put('Q4','10/01');
        
        Map<String,String> qtrEnd = new Map<String,String> ();
        qtrEnd.put('Q1','03/31');qtrEnd.put('Q2','06/30');
        qtrEnd.put('Q3','09/30');qtrEnd.put('Q4','12/31');
        
        
        
        list<ACE_Settings__c> desettings =[SELECT Id, Name, BatchName__c from ACE_Settings__c limit 1];
        if(desettings[0]!= null)
            this.batchId = desettings[0].BatchName__c;
        String[] batchSplit = batchId.split('-');
        if (batchSplit.size() >= 2) {
         this.qtrStartDate = Date.parse(qtrStart.get(batchSplit[0]) + '/' + batchSplit[1]);
         this.qtrEndDate = Date.parse(qtrEnd.get(batchSplit[0]) + '/' + batchSplit[1]);
        }

       this.acequery  = 'SELECT Id,Name,sku__c, batchId__c,CoreList_ID__c, Owning_Customer_ID__c, ' 
       +' Cap_Lost_Margin_Dollar_12_Month__c, Cap_Lost_Margin_Dollar_3_Month__c,Core_s_SKU_Vendor_Name__c,' 
       +' Cap_Lost_Margin_Dollar_6_Month__c, Cap_Lost_Margin_Dollar_9_Month__c, Current_Margin_12_Month__c,'
       +' Current_Margin_3_Month__c, Current_Margin_6_Month__c, Current_Margin_9_Month__c, Current_Margin__c,'
       +' Forecasted_Spend_12_Month__c, Forecasted_Spend_3_Month__c, Forecasted_Spend_6_Month__c,' 
       +' Forecasted_Spend_9_Month__c, Gross_IGM_Basis_Point_Increase__c, Item_12_Month_Qty__c,' 
       +' Item_12_Month_Sales__c, Item_3_Month_Qty__c, Item_3_Month_Sales__c,' 
       +' Item_6_Month_Qty__c, Item_6_Month_Sales__c, Item_9_Month_Qty__c, Item_9_Month_Sales__c, ' 
       +' Margin_Exposure_12_Month__c, Margin_Exposure_3_Month__c, Margin_Exposure_6_Month__c,' 
       +' Margin_Exposure_9_Month__c, Margin_Exposure_before_change__c,'
       +' Margin_wo_Change_WAPO__c, Margin_wo_Change_WATD__c, New_Gross_IGM1__c, New_Gross_IGM__c,' 
       +' New_IGM_Change__c, New_Sell_Price_Dollar_Change_Amount__c, New_Sell_Price_Percentage_Change_Amoun__c,' 
       +' Old_Gross_IGM1__c, Old_Gross_IGM__c, Old_WAPO_Margin1__c, Old_WAPO_Margin__c, Old_WATD_SRM1__c,' 
       +' Old_WATD_SRM__c, Projected_Margin_12_Month__c, Projected_Margin_3_Month__c, Projected_Margin_6_Month__c,' 
       +' Projected_Margin_9_Month__c, Projected_Margin__c, Proposed_New_List_Less_Disc_Without_Cap__c,' 
       +' Proposed_SRM_with_Cap1__c, Proposed_SRM_with_Cap__c, Proposed_WAPO_Margin_with_Cap1__c, '
       +' Proposed_WAPO_Margin_with_Cap__c, SRM_Basis_Point_Increase__c, SRM_Differential__c,Dept_Description__c,' 
       +' Total_Spend_Impact_12_Month__c, Total_Spend_Impact_3_Month__c, Total_Spend_Impact_6_Month__c,' 
       +' Total_Spend_Impact_9_Month__c, WAPO_Cost_Change__c, WATD_Cost_Change1__c,' 
       +' WATD_Cost_Change__c,SFDC_Notification_Flag__c,IsProcessed__c,error__C,New_WAPO_Cost__c, '
       +' Core_s_SKU_Vendor_ID__c,Cap_Format__c, Total_Amount_not_passed_due_to_WA_restr2__c, ' 
       +' UOM__c, Update_Timing__c,New_WANET_Cost__c,SFDC_Contract_Object_ID__c,Cap_Amount__c, '
       +' Proposed_Price_with_Cap__c,Sales_Price_Change_Effective_Date__c, Class_Id__c,'
       +' Total_Amount_not_passed_due_to_WA__c,Notification_Action__c,Agreement_Start_Date__c, '
       +' Customer_Notification_Date__c,Group_Description__c,Old_WATD__c,Current_List_Price__c, '
       +' SKU_DISCO_Alternate_Price_Requirement__c,Class_Description__c,Requirement_Window__c,Cap_Calculation_Base__c, '
       +' Cap_Lost_Margin_Dollar__c,Division_Id__c,Current_Sell_Price__c,Total_Amount_not_passed_due_to_WA_restr3__c, '
       +' Update_Timing_Action__c, SKU_Alt__c,Old_WANET__c,Current_Price_Method__c,Batch_Run_Date__c,New_WATD_Cost__c,'
       +' Vendor_OEM_Letters_Required__c,Dept_Id__c,owning_customer_legal__c,Customers_Linked__c,NWCustomer_Notification_Flag__c,'
       +' Current_WATD_Cost__c,CoreList_Indicator__c,Initial_Price_Freeze_Period__c,Division_Description__c,'
       +' Cap_Scope__c,Request_Key__c,VCC_ENGINE_CONTROL_ID__c,XREF_REQUEST_ID__c,CoreList_Type__c,SFDC_Contract_Object_Customer_ID__c, '
       +' Owning_Customer_Type__c,Subclass_Description__c,Recommended_Action__c,Group_Id__c,Pricing_Method_Percentage__c,'
       +' Cost_Change_From_Date__c,Proposed_Price_Without_Cap__c,Recommended_Deletion__c,Core_Description__c,'
       +' New_WAPO_Cost_Effective_Date__c,Old_WAPO__c,Contract_Type__c, Price_Changes_Type__c,Next_eligible_increase_date__c,'
       +' Subclass_Id__c,PRICE_NOT_CALCULATED__c,Total_Amount_not_passed_due_to_WA_restr1__c,SKU_Description__c,Current_WAPO_Cost__c,SKU_Last_Update__c, '
       +' Total_Amount_not_passed_due_to_WA_restri__c, Cap_Units__c,hosted_catalog__c,Owning_Customer_Corelist_Priority__c,Current_WANET_Cost__c,'
       +' Cost_Change_To_Date__c,New_List_Price__c,Margin_Play_Type__c,QPU__c, SKU_Governed_By_Active_Written_Agreement__c,'
       +' Is_There_A_Cap__c,Is_Cap_Lesser_Of_Two__c,Effective_Date_Language__c,Complex_Cap__c,Related_Contract_Number__c,'
       +' Related_Pricing_Term__c,Related_Customer__c,Comp_Vetting_Not_Performed__c,Vendor_Letter_Eligible_No_Det__c,Retail_Price__c,'
       +' DISCO_communication_requirements__c,Addition_communication_requirements__c,Deletion_communication_requirements__c,'
       +' Update_Frequency_Type__c,Update_Frequency_In_Days__c,Update_Frequency_Calendar_Period__c,Update_Frequency_Other__c,'       
       +' Update_Frequency_Date_1__c,Update_Frequency_Date_2__c ,Update_Frequency_Date_3__c,Update_Frequency_Date_4__c'
     +' from ACE_SKU_Changes_inbound__c where Owning_Customer_ID__c  !=\'\'';    
       //+' from ACE_SKU_Changes_inbound__c where Owning_Customer_ID2__c  =\'\'';
       
       System.debug(this.acequery); 
       
    }
        global AcequaterlyProcess_Batch (String query){
        
         Map<String,String> qtrStart =  new Map<String,String> ();
        qtrStart.put('Q1','01/01');qtrStart.put('Q2','04/01');
        qtrStart.put('Q3','07/01');qtrStart.put('Q4','10/01');
        
        Map<String,String> qtrEnd = new Map<String,String> ();
        qtrEnd.put('Q1','03/31');qtrEnd.put('Q2','06/30');
        qtrEnd.put('Q3','09/30');qtrEnd.put('Q4','12/31');
        
        
        
        list<ACE_Settings__c> desettings =[SELECT Id, Name, BatchName__c from ACE_Settings__c limit 1];
        if(desettings[0]!= null)
            this.batchId = desettings[0].BatchName__c;
        String[] batchSplit = batchId.split('-');
        if (batchSplit.size() >= 2) {
         this.qtrStartDate = Date.parse(qtrStart.get(batchSplit[0]) + '/' + batchSplit[1]);
         this.qtrEndDate = Date.parse(qtrEnd.get(batchSplit[0]) + '/' + batchSplit[1]);
        }

       this.acequery  = query;
       
       System.debug(this.acequery); 
       
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    { 
                
        return Database.getQueryLocator(acequery);
    }
   global void execute(Database.BatchableContext BC, SObject[] scope)
    {      
      List<ACE_SKU_Changes_inbound__c> skuInbound = scope;
      Set<String> scopeAopsID = new Set<String>();
      Set<String> scopecp_termID = new Set<String>();//sfdc case 858359- ROM 34B
      
      Map<String,Ace_Customer_Core_Changes__c> map_Core = new Map<String,Ace_Customer_Core_Changes__c>();
      Map<String, String> mapSFDC_Notification_Flag = new  Map<String, String>();
      Map<String, ACE_SKU_Changes_inbound__c> mapAssortmentSwap = new Map<String, ACE_SKU_Changes_inbound__c>(); //NBOCK S-364741 11.16.2015 - map to hold assortment swap SKUs
      
      for(ACE_SKU_Changes_inbound__c sc_AopsIds :skuInbound){
            if(sc_AopsIds.Owning_Customer_ID__c !=''){
                scopeAopsID.add(sc_AopsIds.Owning_Customer_ID__c );
                if(mapSFDC_Notification_Flag.get(sc_AopsIds.Owning_Customer_ID__c) == null){
                    mapSFDC_Notification_Flag.put(sc_AopsIds.Owning_Customer_ID__c,sc_AopsIds.SFDC_Notification_Flag__c);
                }
            }
          
            //ROM 34B
            if(sc_AopsIds.Related_Pricing_Term__c != null){
                scopecp_termID.add(sc_AopsIds.Related_Pricing_Term__c);            
            }//sfdc case 858359- ROM 34B                     
      }
      
       Map<String,ACE_Customer_Price_Changes__c> map_aceCustomer = new Map<String,ACE_Customer_Price_Changes__c>();
        for(ACE_Customer_Price_Changes__c acecust: [select id, Customer__r.AOPS_Cust_Id__c From ACE_Customer_Price_Changes__c where batchId__c =: batchId and Customer__r.AOPS_Cust_Id__c =: scopeAopsID ]) 
        {
           map_aceCustomer.put(acecust.Customer__r.AOPS_Cust_Id__c, acecust);    
        }
        System.debug('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF ssssssss'+scopeAopsID.size() );
        System.debug('FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'+scopeAopsID );               
        Map<String, Account> acc = new Map<String, Account>();       
        for(Account lstacc:[select id,AOPS_Cust_Id__c,Remediation_Required__c from account where AOPS_Cust_Id__c =: scopeAopsID ]){
            acc.put(lstacc.AOPS_Cust_Id__c,lstacc) ;            
        }
        
        // Map for Contract_Pricing_Terms__c - ROM 34B
        Map<String, id> map_contract = new Map<String, id>();
    set<id> lst_cpterm = new set<id>();        
        for(Contract_Pricing_Terms__c lstcp_term:[select Contract__r.ContractNumber,contract__c,id from Contract_Pricing_Terms__c where id =: scopecp_termID]){
        map_contract.put(lstcp_term.Contract__r.ContractNumber, lstcp_term.Contract__c);
        lst_cpterm.add(lstcp_term.id);
        }//sfdc case 858359- ROM 34B                  
        
        //Error Handling
        for(ACE_SKU_Changes_inbound__c sc_AopsIds1 :skuInbound){
           
            if(acc.get(sc_AopsIds1.Owning_Customer_ID__c) == null){
                sc_AopsIds1.error__C ='Aops Id is not found in SFDC';
            }
        
        }
        // End Error  Handling
        
        System.debug('Account Count Found '+acc.size());
  
      list<ACE_Customer_Price_Changes__c > tocreate = new list<ACE_Customer_Price_Changes__c >();
      for(String rec :scopeAopsID){
        if((map_aceCustomer.get(rec)== null)&&(acc.get(rec) != null)){
            ACE_Customer_Price_Changes__c ocpc = new ACE_Customer_Price_Changes__c();
            ocpc.name = batchId;
            ocpc.batchId__c = batchId;             
            ocpc.Customer__c = acc.get(rec).id;               
            ocpc.Owning_Customer_ID__c = rec;
            ocpc.SFDC_Notification_Flag__c = mapSFDC_Notification_Flag.get(rec);
            ocpc.IsRemediation__c = acc.get(rec).remediation_required__c;
            ocpc.Remediation_Hold__c = acc.get(rec).remediation_required__c;
            // Generate Page Key - starts
               Blob blobKey = crypto.generateAesKey(256);
               ocpc.page_key__c = EncodingUtil.convertToHex(blobKey);
            // Generate Page Key - Ends  
            // For initial Record Lock
            // ocpc.Record_Lock__c = true;
            // Code ends
            System.debug('***************************Creating the customer Pricing'+ocpc+' ocpc.Owning_Customer_ID__c'+ ocpc.Owning_Customer_ID__c);
            tocreate.add(ocpc);
        }
      }
      if (tocreate.size() > 0)
      System.Debug('Size'+ tocreate.size());
        insert tocreate;
      

       map_aceCustomer = new Map<String,ACE_Customer_Price_Changes__c>();
        for(ACE_Customer_Price_Changes__c acecust: [select id,Vendor_OEM_Letters_Required__c,Update_Timing_Action__c, Customer__r.AOPS_Cust_Id__c,SFDC_Notification_Flag__c,Owning_Customer_Legal__c,Customer_Notification_Date__c,Customer_Notification_Date_Approved__c,Sales_Price_Change_Effective_Date__c,Sales_Price_Change_Effective_Date_Approv__c,Implementation_Status__c,Implementation_Status_Code__c,Notification_Status_Code__c,Notification_Status__c From ACE_Customer_Price_Changes__c where batchId__c =: batchId and Customer__r.AOPS_Cust_Id__c =: scopeAopsID ]) 
        {
           map_aceCustomer.put(acecust.Customer__r.AOPS_Cust_Id__c, acecust);
        }
        //End Creation of Pricing Customer Pricing Changes and updating the exisiting map.
       
        //Getting the list of exisitng Core for the Current Scoped Cusotmers
        for(Ace_Customer_Core_Changes__c acecore: [select id, CoreID__c,batchId__c,ACE_Customer_Price_Changes__r.Owning_Customer_ID__c From Ace_Customer_Core_Changes__c where batchId__c =: batchId and ACE_Customer_Price_Changes__r.Owning_Customer_ID__c =: scopeAopsID ]) 
        {
             String mapKey = acecore.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c+acecore.CoreID__c+acecore.batchId__c;
             map_Core.put(mapKey, acecore);
        }
        
        
        set <String> uniquecore_withinScope = new set <String>();
        map<String, ACE_SKU_Changes_inbound__c> inb = new map<String, ACE_SKU_Changes_inbound__c>();
       
       for(ACE_SKU_Changes_inbound__c sc_core :skuInbound)
        {
         String corekey = sc_core.Owning_Customer_ID__c+sc_core.CoreList_ID__c+batchId;
          uniquecore_withinScope.add(corekey);
          inb.put(corekey,sc_core);
        }
        
        list<Ace_Customer_Core_Changes__c> coretoCreate = new list<Ace_Customer_Core_Changes__c>();
        for(String coreItr:uniquecore_withinScope){
            if(map_Core.get(coreItr) == null){
                Ace_Customer_Core_Changes__c r = new Ace_Customer_Core_Changes__c();
                r.name = inb.get(coreItr).CoreList_ID__c;
                r.batchId__c = batchId;
                r.CoreID__c = inb.get(coreItr).CoreList_ID__c;
                r.Core_Description__c = inb.get(coreItr).Core_Description__c;
                
                System.debug('***************************READY TO CREATE CORE');
                if(inb.get(coreItr) != null){
                System.debug('***************************1');
                    if(map_aceCustomer.get(inb.get(coreItr).Owning_Customer_ID__c)!= null){
                       System.debug('***************************2');
                        r.ACE_Customer_Price_Changes__c = map_aceCustomer.get(inb.get(coreItr).Owning_Customer_ID__c).id;
                        coretoCreate.add(r);
                    }
                }
            }
        
        }
        
        insert (coretoCreate);
        
        map_Core = new Map<String,Ace_Customer_Core_Changes__c>();
        for(Ace_Customer_Core_Changes__c acecore: [select id, CoreID__c,batchId__c,ACE_Customer_Price_Changes__r.Owning_Customer_ID__c From Ace_Customer_Core_Changes__c where batchId__c =: batchId and ACE_Customer_Price_Changes__r.Owning_Customer_ID__c =: scopeAopsID ]) 
        {
             String mapKey = acecore.ACE_Customer_Price_Changes__r.Owning_Customer_ID__c+acecore.CoreID__c+acecore.batchId__c;
             map_Core.put(mapKey, acecore);
             System.debug('************************************MapKEYYYY'+mapKey);
             System.debug('************************************Core ID'+acecore.id);
        }
        
        //End of creating the core's
        //Creating the Sku's
        list<Ace_Customer_SKU_Changes__c> toCreatesku = new list<Ace_Customer_SKU_Changes__c>();
      
        for(ACE_SKU_Changes_inbound__c sc_sku :skuInbound){
            
            //String corekey = sc_sku.Owning_Customer_ID__c+sc_sku.CoreList_ID__c+batchId;
            String corekey = sc_sku.Owning_Customer_ID__c+sc_sku.CoreList_ID__c+batchId;
            System.debug('*************************YYYYYYYYY***************'+corekey);
            System.debug('***********************************^^^^^^^^'+map_Core.get(corekey));
            
            if(map_Core.get(corekey) != null){
                
                if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c) != null){
                    
                    // Set Cutomer Legal Flag
                    if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).owning_customer_legal__c != null) {
                        if (map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).owning_customer_legal__c != 'T' && sc_sku.Owning_Customer_Legal__c == 'T')
                          map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).owning_customer_legal__c = sc_sku.Owning_Customer_Legal__c;
                    } else {
                        map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).owning_customer_legal__c = sc_sku.Owning_Customer_Legal__c;
                    }
                    
                    //Set Update Timing Action
                    if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Update_Timing_Action__c != null) {
                        if (map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Update_Timing_Action__c != 'F' && sc_sku.Update_Timing_Action__c == 'F')
                          map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Update_Timing_Action__c = sc_sku.Update_Timing_Action__c;
                    } else {
                        map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Update_Timing_Action__c = sc_sku.Update_Timing_Action__c;
                    }
                    
                    //Set Vendor/OEM Letters Required
                    if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Vendor_OEM_Letters_Required__c != null) {
                        if (map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Vendor_OEM_Letters_Required__c != 'Yes' && sc_sku.Vendor_OEM_Letters_Required__c == 'Yes')
                          map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Vendor_OEM_Letters_Required__c = sc_sku.Vendor_OEM_Letters_Required__c;
                    } else {
                        map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Vendor_OEM_Letters_Required__c = sc_sku.Vendor_OEM_Letters_Required__c;
                    }
                    
                    //rolling up SFDC Notification Flag
                    if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).SFDC_Notification_Flag__c != null){
                        if(sc_sku.SFDC_Notification_Flag__c > map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).SFDC_Notification_Flag__c){
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).SFDC_Notification_Flag__c = sc_sku.SFDC_Notification_Flag__c;
                        }
                    }else{
                        map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).SFDC_Notification_Flag__c = sc_sku.SFDC_Notification_Flag__c;
                    }
                    //rolling up Implementation_Status__c and Notification_Status__c
                    if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).SFDC_Notification_Flag__c != null){
                         //1- No Requirments
                         if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).SFDC_Notification_Flag__c == '1'){
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Implementation_Status_Code__c = 'SCH';
                            //map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Implementation_Status__c = 'Scheduled';
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Notification_Status_Code__c = 'NOVAL';
                         }
                         //2- Notification Required
                         if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).SFDC_Notification_Flag__c == '2'){
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Implementation_Status_Code__c = 'SCH';
                            //map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Implementation_Status__c = 'Scheduled';
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Notification_Status_Code__c = 'NOTIFY-SCH';
                         }//3 - Approval Required
                         if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).SFDC_Notification_Flag__c == '3'){
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Implementation_Status_Code__c = 'SCH';
                            //map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Implementation_Status__c = 'Scheduled - Pending Customer Approval';
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Notification_Status_Code__c = 'NOTIFY-SCH';
                         }
                         
                    }
                    
                    //Rolling Up Hosted Catalog, Remediation, Remediation hold, hosted catalog Hold - Starts
                       if (sc_sku.Hosted_Catalog__c) {
                          map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Hosted_Catalog__c = sc_sku.Hosted_Catalog__c;
                          map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).HostedCatalog_Hold__c = sc_sku.Hosted_Catalog__c;
                       }
                    //Rolling Up Hosted Catalog, Remediation, Remediation hold, hosted catalog Hold - Ends
                    
                    //Flag populated at customer level if ACE does not derive price for atleast one child SKU
                     if (sc_sku.PRICE_NOT_CALCULATED__c)
                          map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).PRICE_NOT_CALCULATED__c = sc_sku.PRICE_NOT_CALCULATED__c;
                    
                    //rolling up Customer_Notification_Date__c - Logic to pickup up Minimum Notification Date
                    if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Customer_Notification_Date__c != null){
                        if(sc_sku.Customer_Notification_Date__c < map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Customer_Notification_Date__c && (sc_sku.sfdc_notification_flag__c != '1' || (sc_sku.sfdc_notification_flag__c == '1' && sc_sku.hosted_catalog__c))){
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Customer_Notification_Date__c = sc_sku.Customer_Notification_Date__c;
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Customer_Notification_Date_Approved__c = sc_sku.Customer_Notification_Date__c;
                        }
                    }
                    else{
                        if(sc_sku.sfdc_notification_flag__c != '1') {
                         map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Customer_Notification_Date__c = sc_sku.Customer_Notification_Date__c;
                         map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Customer_Notification_Date_Approved__c = sc_sku.Customer_Notification_Date__c;
                        }
                    }
                    //rolling up Sales_Price_Change_Effective_Date - Logic To Pick up Maximum Effective Date
                    if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Sales_Price_Change_Effective_Date__c != null){
                        if(sc_sku.Sales_Price_Change_Effective_Date__c > map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Sales_Price_Change_Effective_Date__c){
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Sales_Price_Change_Effective_Date__c = sc_sku.Sales_Price_Change_Effective_Date__c;
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Sales_Price_Change_Effective_Date_Approv__c = sc_sku.Sales_Price_Change_Effective_Date__c;
                        }
                    }else{
                        map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Sales_Price_Change_Effective_Date__c = sc_sku.Sales_Price_Change_Effective_Date__c;
                        map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Sales_Price_Change_Effective_Date_Approv__c = sc_sku.Sales_Price_Change_Effective_Date__c;
                        
                    }
                    // Rolling Up Sales_Price_Change_Effective_Date_Min__c - Logic to Pick up Minimum Effective Date
                    if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Sales_Price_Change_Effective_Date_Min__c != null){
                        if(sc_sku.Sales_Price_Change_Effective_Date__c < map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Sales_Price_Change_Effective_Date_Min__c){
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Sales_Price_Change_Effective_Date_Min__c = sc_sku.Sales_Price_Change_Effective_Date__c;
                        }
                    }else{
                        map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).Sales_Price_Change_Effective_Date_Min__c = sc_sku.Sales_Price_Change_Effective_Date__c;
                    }
                    // Rolling up Requirement Window - Logic to Pick Up Maximum Requirement Window
                    if(map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).requirement_window__c != null){
                        if(sc_sku.requirement_window__c > map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).requirement_window__c){
                            map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).requirement_window__c = sc_sku.requirement_window__c;
                        }
                    }else{
                        map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).requirement_window__c = sc_sku.requirement_window__c;
      
                    }
                }
                System.debug('***************************READY FOR SKU');
                Ace_Customer_SKU_Changes__c r_toCreatesku = new Ace_Customer_SKU_Changes__c();
                
                r_toCreatesku.Account__c = acc.get(sc_sku.Owning_Customer_ID__c).id;
                r_toCreatesku.Price_change_id__c = map_aceCustomer.get(sc_sku.Owning_Customer_ID__c).id;
                if (acc.get(sc_sku.Owning_Customer_ID__c).remediation_required__c)
                 r_toCreatesku.Vendavo_update_date__c = system.now();
                r_toCreatesku.name = sc_sku.SKU__c;
                r_toCreatesku.CoreList_ID__c = sc_sku.CoreList_ID__c;
                r_toCreatesku.Ace_Customer_Core_Changes__c = map_Core.get(corekey).id;
                r_toCreatesku.SKU__c = sc_sku.SKU__c;
                r_toCreatesku.batchId__c = batchid;
                r_toCreatesku.Core_s_SKU_Vendor_Name__c = sc_sku.Core_s_SKU_Vendor_Name__c;
                r_toCreatesku.Hosted_Catalog__c = sc_sku.Hosted_Catalog__c;
                r_toCreatesku.HostedCatalog_Hold__c = sc_sku.Hosted_Catalog__c;
                r_toCreatesku.Remediation_Hold__c = acc.get(sc_sku.Owning_Customer_ID__c).remediation_required__c;
                r_toCreatesku.Owning_Customer_ID__c = sc_sku.Owning_Customer_ID__c;//
                r_toCreatesku.Cap_Lost_Margin_Dollar_12_Month__c = nvl(sc_sku.Cap_Lost_Margin_Dollar_12_Month__c);  
                r_toCreatesku.Cap_Lost_Margin_Dollar_3_Month__c = nvl(sc_sku.Cap_Lost_Margin_Dollar_3_Month__c);
                r_toCreatesku.Cap_Lost_Margin_Dollar_6_Month__c = nvl(sc_sku.Cap_Lost_Margin_Dollar_6_Month__c);
                r_toCreatesku.Cap_Lost_Margin_Dollar_9_Month__c = nvl(sc_sku.Cap_Lost_Margin_Dollar_9_Month__c);
                r_toCreatesku.Current_Margin_12_Month__c  = nvl(sc_sku.Current_Margin_12_Month__c);
                r_toCreatesku.Current_Margin_3_Month__c  = nvl(sc_sku.Current_Margin_3_Month__c);
                r_toCreatesku.Current_Margin_6_Month__c  = nvl(sc_sku.Current_Margin_6_Month__c);             
                r_toCreatesku.Current_Margin_9_Month__c  = nvl(sc_sku.Current_Margin_9_Month__c);
                r_toCreatesku.Current_Margin__c  = nvl(sc_sku.Current_Margin__c);
                r_toCreatesku.Forecasted_Spend_12_Month__c  = nvl(sc_sku.Forecasted_Spend_12_Month__c);
                r_toCreatesku.Forecasted_Spend_3_Month__c  = nvl(sc_sku.Forecasted_Spend_3_Month__c);
                r_toCreatesku.Forecasted_Spend_6_Month__c  = nvl(sc_sku.Forecasted_Spend_6_Month__c);
                r_toCreatesku.Forecasted_Spend_9_Month__c = nvl(sc_sku.Forecasted_Spend_9_Month__c);                
                r_toCreatesku.Gross_IGM_Basis_Point_Increase__c  = nvl(sc_sku.Gross_IGM_Basis_Point_Increase__c);
                r_toCreatesku.Item_12_Month_Qty__c  = nvl(sc_sku.Item_12_Month_Qty__c);
                r_toCreatesku.Item_12_Month_Sales__c  = nvl(sc_sku.Item_12_Month_Sales__c);
                r_toCreatesku.Item_3_Month_Qty__c  = nvl(sc_sku.Item_3_Month_Qty__c);
                r_toCreatesku.Item_3_Month_Sales__c  = nvl(sc_sku.Item_3_Month_Sales__c);
                r_toCreatesku.Item_6_Month_Qty__c  = nvl(sc_sku.Item_6_Month_Qty__c);
                r_toCreatesku.Item_6_Month_Sales__c  = nvl(sc_sku.Item_6_Month_Sales__c);
                r_toCreatesku.Item_9_Month_Qty__c  = nvl(sc_sku.Item_9_Month_Qty__c);
                r_toCreatesku.Item_9_Month_Sales__c  = nvl(sc_sku.Item_9_Month_Sales__c);
                r_toCreatesku.Margin_Exposure_12_Month__c  = nvl(sc_sku.Margin_Exposure_12_Month__c);
                r_toCreatesku.Margin_Exposure_3_Month__c  = nvl(sc_sku.Margin_Exposure_3_Month__c);
                r_toCreatesku.Margin_Exposure_6_Month__c  = nvl(sc_sku.Margin_Exposure_6_Month__c);
                r_toCreatesku.Margin_Exposure_9_Month__c  = nvl(sc_sku.Margin_Exposure_9_Month__c);
                r_toCreatesku.Margin_Exposure_before_change__c  = nvl(sc_sku.Margin_Exposure_before_change__c);
                r_toCreatesku.Margin_wo_Change_WAPO__c  = nvl(sc_sku.Margin_wo_Change_WAPO__c);
                r_toCreatesku.Margin_wo_Change_WATD__c  = nvl(sc_sku.Margin_wo_Change_WATD__c);
                r_toCreatesku.New_Gross_IGM1__c  = nvl(sc_sku.New_Gross_IGM1__c);
                r_toCreatesku.Report_New_Gross_IGM_ACE__c  = nvl(sc_sku.New_Gross_IGM__c);
                r_toCreatesku.New_Gross_IGM__c  = nvl(sc_sku.New_Gross_IGM__c);
                r_toCreatesku.New_IGM_Change__c  = nvl(sc_sku.New_IGM_Change__c);
                r_toCreatesku.New_Sell_Price_Dollar_Change_Amount__c  = nvl(sc_sku.New_Sell_Price_Dollar_Change_Amount__c);
                r_toCreatesku.New_Sell_Price_Percentage_Change_Amoun__c  = nvl(sc_sku.New_Sell_Price_Percentage_Change_Amoun__c);
                r_toCreatesku.Old_Gross_IGM1__c  = nvl(sc_sku.Old_Gross_IGM1__c);
                r_toCreatesku.Old_Gross_IGM__c  = nvl(sc_sku.Old_Gross_IGM__c);
                r_toCreatesku.Old_WAPO_Margin1__c  = nvl(sc_sku.Old_WAPO_Margin1__c);
                r_toCreatesku.Old_WAPO_Margin__c  = nvl(sc_sku.Old_WAPO_Margin__c);
                r_toCreatesku.Old_WATD_SRM1__c  = nvl(sc_sku.Old_WATD_SRM1__c);
                r_toCreatesku.Old_WATD_SRM__c  = nvl(sc_sku.Old_WATD_SRM__c);
                r_toCreatesku.Projected_Margin_12_Month__c  = nvl(sc_sku.Projected_Margin_12_Month__c);
                r_toCreatesku.Projected_Margin_3_Month__c  = nvl(sc_sku.Projected_Margin_3_Month__c);
                r_toCreatesku.Projected_Margin_6_Month__c  = nvl(sc_sku.Projected_Margin_6_Month__c);
                r_toCreatesku.Projected_Margin_9_Month__c  = nvl(sc_sku.Projected_Margin_9_Month__c);
                r_toCreatesku.Projected_Margin__c  = nvl(sc_sku.Projected_Margin__c);
                r_toCreatesku.Proposed_New_List_Less_Disc_Without_Cap__c  = nvl(sc_sku.Proposed_New_List_Less_Disc_Without_Cap__c);
                r_toCreatesku.Proposed_SRM_with_Cap1__c  = nvl(sc_sku.Proposed_SRM_with_Cap1__c);
                r_toCreatesku.Proposed_SRM_with_Cap__c  = nvl(sc_sku.Proposed_SRM_with_Cap__c);
                r_toCreatesku.Proposed_WAPO_Margin_with_Cap1__c  = nvl(sc_sku.Proposed_WAPO_Margin_with_Cap1__c);
                r_toCreatesku.Proposed_WAPO_Margin_with_Cap__c  = nvl(sc_sku.Proposed_WAPO_Margin_with_Cap__c);
                r_toCreatesku.SRM_Basis_Point_Increase__c  = nvl(sc_sku.SRM_Basis_Point_Increase__c);
                r_toCreatesku.SRM_Differential__c  = nvl(sc_sku.SRM_Differential__c);
                r_toCreatesku.Total_Spend_Impact_12_Month__c  = nvl(sc_sku.Total_Spend_Impact_12_Month__c);
                r_toCreatesku.Report_Total_Spend_Impact_12_Month_ACE__c  = nvl(sc_sku.Total_Spend_Impact_12_Month__c);
                r_toCreatesku.Total_Spend_Impact_3_Month__c  = nvl(sc_sku.Total_Spend_Impact_3_Month__c);
                r_toCreatesku.Total_Spend_Impact_6_Month__c  = nvl(sc_sku.Total_Spend_Impact_6_Month__c);
                r_toCreatesku.Total_Spend_Impact_9_Month__c  = nvl(sc_sku.Total_Spend_Impact_9_Month__c);
                r_toCreatesku.WAPO_Cost_Change__c  = nvl(sc_sku.WAPO_Cost_Change__c);
                r_toCreatesku.WATD_Cost_Change1__c  = nvl(sc_sku.WATD_Cost_Change1__c);
                r_toCreatesku.WATD_Cost_Change__c  = nvl(sc_sku.WATD_Cost_Change__c);
                ///////////All Other Fields
                r_toCreatesku.New_WAPO_Cost__c = nvl(sc_sku.New_WAPO_Cost__c);
                r_toCreatesku.Core_s_SKU_Vendor_ID__c = sc_sku.Core_s_SKU_Vendor_ID__c;
                r_toCreatesku.Cap_Format__c = sc_sku.Cap_Format__c;
                r_toCreatesku.Total_Amount_not_passed_due_to_WA_restr2__c = nvl(sc_sku.Total_Amount_not_passed_due_to_WA_restr2__c);
                r_toCreatesku.UOM__c = sc_sku.UOM__c; 
                r_toCreatesku.Update_Timing__c = sc_sku.Update_Timing__c;
                r_toCreatesku.New_WANET_Cost__c = nvl(sc_sku.New_WANET_Cost__c);
                r_toCreatesku.Dept_Description__c = sc_sku.Dept_Description__c;
                r_toCreatesku.SFDC_Contract_Object_ID__c = sc_sku.SFDC_Contract_Object_ID__c;
                r_toCreatesku.Cap_Amount__c = nvl(sc_sku.Cap_Amount__c);
                r_toCreatesku.Proposed_Price_with_Cap__c = nvl(sc_sku.Proposed_Price_with_Cap__c);
                r_toCreatesku.Approved_Proposed_Price__c = nvl(sc_sku.Proposed_Price_with_Cap__c);
                r_toCreatesku.Sales_Price_Change_Effective_Date__c = sc_sku.Sales_Price_Change_Effective_Date__c;
                 r_toCreatesku.Sales_Price_Change_Effective_Date_Approv__c = sc_sku.Sales_Price_Change_Effective_Date__c;
                r_toCreatesku.Class_Id__c = sc_sku.Class_Id__c;
                r_toCreatesku.Total_Amount_not_passed_due_to_WA__c = nvl(sc_sku.Total_Amount_not_passed_due_to_WA__c);
                r_toCreatesku.Notification_Action__c = sc_sku.Notification_Action__c;
                r_toCreatesku.Agreement_Start_Date__c = sc_sku.Agreement_Start_Date__c;
                
                if (sc_sku.sfdc_notification_flag__c != '1' || (sc_sku.sfdc_notification_flag__c == '1' && sc_sku.Hosted_Catalog__c))
                  r_toCreatesku.Customer_Notification_Date__c = sc_sku.Customer_Notification_Date__c;
                
                r_toCreatesku.Group_Description__c = sc_sku.Group_Description__c;
                r_toCreatesku.Old_WATD__c = nvl(sc_sku.Old_WATD__c);
                r_toCreatesku.Current_List_Price__c = nvl(sc_sku.Current_List_Price__c);
                r_toCreatesku.SKU_DISCO_Alternate_Price_Requirement__c = sc_sku.SKU_DISCO_Alternate_Price_Requirement__c;
                //r_toCreatesku.SKU_Add_Notif_Req__c = sc_sku.SKU_Add_Notif_Req__c;
                //r_toCreatesku.SKU_Del_Notif_Req__c = sc_sku.SKU_Del_Notif_Req__c;
                //r_toCreatesku.SKU_Disco_Alt_Req__c = sc_sku.SKU_Disco_Alt_Req__c;
                r_toCreatesku.PRICE_NOT_CALCULATED__c = sc_sku.PRICE_NOT_CALCULATED__c;
                //r_toCreatesku.SKU_Disco_Cust_Notif_Req__c = sc_sku.SKU_Disco_Cust_Notif_Req__c;
                r_toCreatesku.request_key__c = sc_sku.request_key__c;
                r_toCreatesku.vcc_engine_control_id__c = sc_sku.vcc_engine_control_id__c;
                r_toCreatesku.xref_request_id__c = sc_sku.xref_request_id__c;
                r_toCreatesku.Class_Description__c = sc_sku.Class_Description__c;
                r_toCreatesku.Requirement_Window__c = sc_sku.Requirement_Window__c;
                r_toCreatesku.Cap_Lost_Margin_Dollar__c = nvl(sc_sku.Cap_Lost_Margin_Dollar__c);
                r_toCreatesku.Division_Id__c = sc_sku.Division_Id__c;
                r_toCreatesku.Current_Sell_Price__c = nvl(sc_sku.Current_Sell_Price__c);
                r_toCreatesku.Update_Timing_Action__c = sc_sku.Update_Timing_Action__c;
                r_toCreatesku.SKU_Alt__c = sc_sku.SKU_Alt__c;
                r_toCreatesku.Old_WANET__c = nvl(sc_sku.Old_WANET__c);
                r_toCreatesku.Current_Price_Method__c = sc_sku.Current_Price_Method__c;
                r_toCreatesku.Total_Amount_not_passed_due_to_WA_restr3__c = nvl(sc_sku.Total_Amount_not_passed_due_to_WA_restr3__c);
                r_toCreatesku.Cap_Calculation_Base__c = sc_sku.Cap_Calculation_Base__c;
                r_toCreatesku.Batch_Run_Date__c = sc_sku.Batch_Run_Date__c;
                r_toCreatesku.New_WATD_Cost__c = nvl(sc_sku.New_WATD_Cost__c);
                r_toCreatesku.Vendor_OEM_Letters_Required__c = sc_sku.Vendor_OEM_Letters_Required__c;
                r_toCreatesku.Dept_Id__c = sc_sku.Dept_Id__c;
                r_toCreatesku.Customers_Linked__c = sc_sku.Customers_Linked__c;
                r_toCreatesku.NWCustomer_Notification_Flag__c = sc_sku.NWCustomer_Notification_Flag__c;
                r_toCreatesku.Current_WATD_Cost__c = nvl(sc_sku.Current_WATD_Cost__c);
                r_toCreatesku.CoreList_Indicator__c = sc_sku.CoreList_Indicator__c;
                r_toCreatesku.Initial_Price_Freeze_Period__c = sc_sku.Initial_Price_Freeze_Period__c;
                r_toCreatesku.Division_Description__c = sc_sku.Division_Description__c;
                r_toCreatesku.Cap_Scope__c = sc_sku.Cap_Scope__c;
                //r_toCreatesku.Update_Frequency__c = sc_sku.Update_Frequency__c;
                r_toCreatesku.CoreList_Type__c = sc_sku.CoreList_Type__c;
                r_toCreatesku.New_List_Price__c = nvl(sc_sku.New_List_Price__c);
                r_toCreatesku.SFDC_Contract_Object_Customer_ID__c = sc_sku.SFDC_Contract_Object_Customer_ID__c;
                r_toCreatesku.Owning_Customer_Type__c = sc_sku.Owning_Customer_Type__c;
                r_toCreatesku.Subclass_Description__c = sc_sku.Subclass_Description__c;
                r_toCreatesku.Recommended_Action__c = sc_sku.Recommended_Action__c;
                r_toCreatesku.Group_Id__c = sc_sku.Group_Id__c;
                r_toCreatesku.Pricing_Method_Percentage__c = sc_sku.Pricing_Method_Percentage__c;
                r_toCreatesku.Cost_Change_From_Date__c = sc_sku.Cost_Change_From_Date__c;
                r_toCreatesku.Proposed_Price_Without_Cap__c = nvl(sc_sku.Proposed_Price_Without_Cap__c);
                r_toCreatesku.Recommended_Deletion__c = sc_sku.Recommended_Deletion__c;
                //r_toCreatesku.Core_Description__c = sc_sku.Core_Description__c
                r_toCreatesku.New_WAPO_Cost_Effective_Date__c = sc_sku.New_WAPO_Cost_Effective_Date__c;
                r_toCreatesku.Old_WAPO__c = nvl(sc_sku.Old_WAPO__c);
                r_toCreatesku.Contract_Type__c = sc_sku.Contract_Type__c;
                r_toCreatesku.Price_Changes_Type__c = sc_sku.Price_Changes_Type__c;
                //Added by Guha for CR - Margin_Play_Type__c
                r_toCreatesku.Margin_Play__c = sc_sku.Margin_Play_Type__c;
                r_toCreatesku.Next_eligible_increase_date__c = sc_sku.Next_eligible_increase_date__c;
                r_toCreatesku.Subclass_Id__c = sc_sku.Subclass_Id__c;
                r_toCreatesku.Total_Amount_not_passed_due_to_WA_restr1__c = nvl(sc_sku.Total_Amount_not_passed_due_to_WA_restr1__c);
                r_toCreatesku.SKU_Description__c = sc_sku.SKU_Description__c;
                r_toCreatesku.sfdc_notification_flag__c = sc_sku.sfdc_notification_flag__c;
                r_toCreatesku.Owning_Customer_Legal__c = sc_sku.Owning_Customer_Legal__c;
                r_toCreatesku.Current_WAPO_Cost__c = nvl(sc_sku.Current_WAPO_Cost__c);
                r_toCreatesku.SKU_Last_Update__c = sc_sku.SKU_Last_Update__c;
                r_toCreatesku.Total_Amount_not_passed_due_to_WA_restri__c = nvl(sc_sku.Total_Amount_not_passed_due_to_WA_restri__c);
                r_toCreatesku.Cap_Units__c = sc_sku.Cap_Units__c;
                r_toCreatesku.Owning_Customer_Corelist_Priority__c = sc_sku.Owning_Customer_Corelist_Priority__c;
                r_toCreatesku.Current_WANET_Cost__c = nvl(sc_sku.Current_WANET_Cost__c);
                r_toCreatesku.Cost_Change_To_Date__c = sc_sku.Cost_Change_To_Date__c;
                r_toCreatesku.Reporting_Quarter_Start_Date__c = qtrStartDate;
                r_toCreatesku.Reporting_Quarter_End_Date__c = qtrEndDate;
                
                //----------Recom new fields----Start---sfdc case 858359- ROM 34B-------//
                r_toCreatesku.QPU__c = sc_sku.QPU__c;//sfdc case 827451
                r_toCreatesku.SKU_Governed_By_Active_Written_Agreement__c = sc_sku.SKU_Governed_By_Active_Written_Agreement__c;//sfdc 826592                                  
                r_toCreatesku.Is_There_A_Cap__c = sc_sku.Is_There_A_Cap__c;
                r_toCreatesku.Is_Cap_Lesser_Of_Two__c = sc_sku.Is_Cap_Lesser_Of_Two__c; 
                r_toCreatesku.Effective_Date_Language__c = sc_sku.Effective_Date_Language__c; 
                 
                //--------Start of 34B               
                if(map_contract.containsKey(sc_sku.Related_Contract_Number__c))
                  r_toCreatesku.Related_Contract_Number__c = map_contract.get(sc_sku.Related_Contract_Number__c);
                if(lst_cpterm.contains(sc_sku.Related_Pricing_Term__c))
                  r_toCreatesku.Related_Contract_Pricing_Term__c = sc_sku.Related_Pricing_Term__c;
                if(acc.containsKey(sc_sku.Owning_Customer_ID__c))
                  r_toCreatesku.Related_Account__c = acc.get(sc_sku.Owning_Customer_ID__c).id;
                //--------End of 34B
                //---------------ROM-36 (Err grouping)---------------
                r_toCreatesku.Complex_Cap__c = sc_sku.Complex_Cap__c;
                r_toCreatesku.Comp_Vetting_Not_Performed__c = sc_sku.Comp_Vetting_Not_Performed__c;
                r_toCreatesku.Vendor_Letter_Eligible_No_Det__c = sc_sku.Vendor_Letter_Eligible_No_Det__c;                                          
                //----------Recom new fields----End---sfdc case 858359- ROM 34B-------//
                
                //----------Recom new fields----00826600-ROM 32A------------
                r_toCreatesku.Retail_Price__c = nvl(sc_sku.Retail_Price__c);
                
                //----------START CPT new fields NAIT NAIT-116337 ----------------
 
                r_toCreatesku.Update_Frequency_Type__c               = sc_sku.Update_Frequency_Type__c;
                r_toCreatesku.Update_Frequency_In_Days__c            = sc_sku.Update_Frequency_In_Days__c;
                r_toCreatesku.Update_Frequency_Calendar_Period__c    = sc_sku.Update_Frequency_Calendar_Period__c;
                r_toCreatesku.Update_Frequency_Other__c              = sc_sku.Update_Frequency_Other__c;
                r_toCreatesku.Update_Frequency_Date_1__c             = sc_sku.Update_Frequency_Date_1__c;
                r_toCreatesku.Update_Frequency_Date_2__c             = sc_sku.Update_Frequency_Date_2__c;
                r_toCreatesku.Update_Frequency_Date_3__c             = sc_sku.Update_Frequency_Date_3__c;
                r_toCreatesku.Update_Frequency_Date_4__c             = sc_sku.Update_Frequency_Date_4__c;
                r_toCreatesku.Addition_communication_requirements__c = sc_sku.Addition_communication_requirements__c;
                r_toCreatesku.Deletion_communication_requirements__c = sc_sku.Deletion_communication_requirements__c;
                r_toCreatesku.DISCO_communication_requirements__c    = sc_sku.DISCO_communication_requirements__c;
              
                //----------END CPT new fields NAIT NAIT-116337 ----------------
                
                //NBOCK S-364741 11.16.2015 - start - if SKU is assortment swap, set to deleted and add to map to process alt records
                if(sc_sku.Margin_Play_Type__c == 'A'){
                  if(sc_sku.SKU_Alt__c != null || sc_sku.SKU_Alt__c != ''){  
                    r_toCreatesku.isDeleted__c = true;
                    r_toCreatesku.status__c = 'Deleted';
                    r_toCreatesku.Alternate_Chosen_Flag__c = true;
                    mapAssortmentSwap.put(sc_sku.SKU_Alt__c, sc_sku);
                  }
                }
                
                //Mark SKU as Inactive 
                //If(sc_sku.Price_Changes_Type__c == 'A') {
                  //r_toCreatesku.Status__c = 'Inactive';
                  //r_toCreatesku.PROCESSING_ALLOWED__c = false;
                  //r_toCreatesku.Alt_SKU__c = true;
                //}
                //NBOCK S-364741 11.16.2015 - end
                System.debug('***************************READY FOR SKU1');
                toCreatesku.add(r_toCreatesku);
              //Add all the fields later 
            }
        } 
        if (toCreatesku.size() > 0) {
          //NBOCK S-364741 11.16.2015 - start - check for assortment swap alternate SKUs and set field values
          for(Ace_Customer_SKU_Changes__c newSKU : toCreatesku){
            if(newSKU.Price_Changes_Type__c == 'A'){
              //if sku is from an assortment swap, set to for immediate processing
              if(!mapAssortmentSwap.isEmpty() && mapAssortmentSwap.containsKey(newSKU.SKU__c)){
                newSKU.Status__c = 'Active';
                newSKU.Alt_SKU__c = true;
              }
              //if sku is not an assortment swap, set to allow user to select the alt sku
              else{
                newSKU.Status__c = 'Inactive';
                newSKU.PROCESSING_ALLOWED__c = false;
                newSKU.Alt_SKU__c = true;
              }
            }
          }
          //NBOCK S-364741 11.16.2015 - end
          insert toCreatesku; 
        }
        
        update map_aceCustomer.values();
        //Update the inbound for all the Processed records
        Map<String, Ace_Customer_SKU_Changes__c> allcretedSKU = new Map<String, Ace_Customer_SKU_Changes__c>(); 
       
        for( Ace_Customer_SKU_Changes__c r: toCreatesku){ 
           
            if(r.id != null){
                 String corekey1 = r.Owning_Customer_ID__c+r.SKU__c+r.batchId__c;
                allcretedSKU.put(corekey1,r);
                 //System.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'+corekey1);
            }
        }
        
       
         for(ACE_SKU_Changes_inbound__c sc_sku :skuInbound){           
             String corekey = sc_sku.Owning_Customer_ID__c+sc_sku.SKU__c+batchId;
             if(allcretedSKU.get(corekey)!= null){              
                 sc_sku.IsProcessed__c = 'YES';   
                //System.debug('************************************'+sc_sku.IsProcessed__c); 
             }
         }
        
        update skuInbound;     
      
      
    
    }
    
    private decimal nvl(decimal val) {
        if (val != null)
         return val;
        else
          return 0;
    }
    
    global void finish(Database.BatchableContext BC)
    {
       System.debug('Completed Processing.... ACE Quaterly Batch Id :'+batchId) ;
    }

}