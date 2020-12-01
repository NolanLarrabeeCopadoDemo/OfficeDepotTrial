global class Load_CustTransData_Batch2 implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts
{
    public String strQuery;
    public String OMXRecTyp = 'Customer (OfficeMax)';
    public String ParentChildLevel;
    public Integer addSec;
    public Integer addHour;
    public String DEFAULT_QUERY ;
    public Integer batchCount;
    public Integer schedulecount;
    public Integer Scope_Size = -1;
    public CustTransParentChildLevel__c PCLevel;
    

     //Default Constructor
    global Load_CustTransData_Batch2()
    {
        PCLevel = [select AddSeconds__c,AddHours__c,Parent_Child_Level__c from CustTransParentChildLevel__c limit 1];
        system.debug('@@@@@@@@@@@@@@PCLevel'+PCLevel);
        ParentChildLevel= PCLevel.Parent_Child_Level__c;
        addSec = Integer.valueof(PCLevel.AddSeconds__c);
        addHour = Integer.valueof(PCLevel.AddHours__c);
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // JB | added new flag for Bill 2 eval to both queries  (Ship_2_Bill_2_Code__c)   
        if(ParentChildLevel=='Parent'){ 
          DEFAULT_QUERY = 'SELECT id,Final_Split_Decision__c,Split_AR_Contact_First_Name__C,Split_AR_Contact_Last_Name__C,Split_Billing_Type__C,Split_AR_Phone__c,account__r.Split_Record__c,Ship_2_Bill_2_Code__c,account__r.sic,Service_Charge_Code__c,Freight_Charge_Flag__c,Pricing_on_packing_list__c,Mixture_of_exempt_non_exempt__c,Release_Number_Required__c,customer_transition_type__c,recordtype.name,recordtypeid,OwnerId,IsDeleted, CreatedById, Createddate,LastModifiedDate, LastModifiedById,Invoice_Email1__c,Fax_back_phone_number__c, Invoice_Email2__c, AR_Primary_Contact_First_Name__c,AR_Primary_Contact_Last_Name__c,AR_Phone__c,Cost_Center_Required__c,Back_Order_Cancel_or_Allow__c,Billing_Type_Flag__c,Billing_Frequency__c,AR_Flag__c,PO_Number_Required__c,Primary_Contact_First_Name__c,Primary_Contact_Last_Name__c,Primary_Contact_Phone__c,Tax_Exemption__c,Retail_Connect__c,Copies_in_Packing_list__c,Promo_Email__c,Promo_Phone__c,Promo_Catalog__c,Promo_Flyer__c,Drop_Ship_Flag__c,MIPAL_alternate_location_flag__c,Account__r.OwnerId,account__r.name,Account__r.id,Account__r.ParentId,Account__r.Phone,Account__r.Parent.AOPS_Cust_Id__c,Account__r.Related_Parent_Account__c,Account__r.Duns_Number__c,Account__r.Oracle_Party_ID__c,Account__r.Segment__c,Account__r.Ultimate_Duns_Number__c,Account__r.Omx_Primary_Key__c,Account__r.Sales_PersonID__r.name,Account__r.Oracle_Party_Site_ID__c,Account__r.Country__c,Account__r.City__c,Account__r.State__c,Account__r.Address2__c,Account__r.Address1__c,Account__r.Zip__c,AOPS_Flag__c,Primary_Contact_Phone_Extension__c,Billing_Document_Type__c,Error_Code__c,Account__r.Related_Account__c FROM Customer_Transition__c where  (Status__c=\'Launched\' or (Error_Message_Level__c=\'Initial Account Setup Failure\' and Error_Message_Type__c=\'System Failure\' and Status__c=\'Error - Launched\'))  and Account__r.Status__c = \'Active\' and customer_transition_type__c =:ParentChildLevel and Account__r.OMX_Mainframe_Account_Level__c = \'National\'  and (Account__r.AOPS_Cust_Id__c=null or Account__r.AOPS_Cust_Id__c=\'\') and (Error_Code__c = null or Error_Code__c != \'Processing\')   and    (  Mod5_Process__C =false or ( Mod5_Process__C =true  and Mod4FlowStatus__c= \'Splitted\' ))      and             (Account__r.split_record__C=false or (Account__r.split_record__C=true and Original_Customer_Transition__r.AOPS_Assigned_AOPS_Account_ID__c !=null)) order by omx_primary_key__C asc limit 3000'; 

        }    
        else
           DEFAULT_QUERY = 'SELECT id,Final_Split_Decision__c,Split_AR_Contact_First_Name__C,Split_AR_Contact_Last_Name__C,Split_Billing_Type__C,Split_AR_Phone__c,Ship_2_Bill_2_Code__c,account__r.Split_Record__c,account__r.name,account__r.sic,Service_Charge_Code__c,Freight_Charge_Flag__c,Pricing_on_packing_list__c,Mixture_of_exempt_non_exempt__c,Release_Number_Required__c,customer_transition_type__c,recordtype.name,recordtypeid,OwnerId,IsDeleted, CreatedById, Createddate,LastModifiedDate, LastModifiedById,Invoice_Email1__c,Fax_back_phone_number__c, Invoice_Email2__c, AR_Primary_Contact_First_Name__c,AR_Primary_Contact_Last_Name__c,AR_Phone__c,Cost_Center_Required__c,Back_Order_Cancel_or_Allow__c,Billing_Type_Flag__c,Billing_Frequency__c,AR_Flag__c,PO_Number_Required__c,Primary_Contact_First_Name__c,Primary_Contact_Last_Name__c,Primary_Contact_Phone__c,Tax_Exemption__c,Retail_Connect__c,Copies_in_Packing_list__c,Promo_Email__c,Promo_Phone__c,Promo_Catalog__c,Promo_Flyer__c,Drop_Ship_Flag__c,MIPAL_alternate_location_flag__c,Account__r.OwnerId,Account__r.id,Account__r.ParentId,Account__r.Phone,Account__r.Parent.AOPS_Cust_Id__c,Account__r.Related_Parent_Account__c,Account__r.Duns_Number__c,Account__r.Oracle_Party_ID__c,Account__r.Segment__c,Account__r.Ultimate_Duns_Number__c,Account__r.Omx_Primary_Key__c,Account__r.Sales_PersonID__r.name,Account__r.Oracle_Party_Site_ID__c,Account__r.Country__c,Account__r.City__c,Account__r.State__c,Account__r.Address2__c,Account__r.Address1__c,Account__r.Zip__c,AOPS_Flag__c,Primary_Contact_Phone_Extension__c,Billing_Document_Type__c,Error_Code__c,Account__r.Related_Account__c FROM Customer_Transition__c where (Status__c=\'Launched\' or (Error_Message_Level__c=\'Initial Account Setup Failure\' and Error_Message_Type__c=\'System Failure\' and Status__c=\'Error - Launched\'))and AOPS_Flag__c =\'Y\' and   Account__r.Status__c = \'Active\' and Account__r.recordtype.Name =:OMXRecTyp and (Account__r.OMX_Mainframe_Account_Level__c = \'Site/Consignee\' or Account__r.OMX_Mainframe_Account_Level__c = \'Main Account\') and Transition_Status__c=\'Active\' and (Account__r.AOPS_Cust_Id__c=null or Account__r.AOPS_Cust_Id__c=\'\') and (Error_Code__c = null or Error_Code__c != \'Processing\')   and  (  Mod5_Process__C =false or ( Mod5_Process__C =true  and Mod4FlowStatus__c= \'Splitted\' ))  and     (Account__r.split_record__C=false or (Account__r.split_record__C=true and Original_Customer_Transition__r.AOPS_Assigned_AOPS_Account_ID__c !=null)) order by omx_primary_key__C asc limit 3000';
           
        
        this.strQuery = DEFAULT_QUERY;
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // JB | Pre-Ship 2 Bill 2 Code-Replaced by block above -2/11/15
        /*
        if(ParentChildLevel=='Parent'){ 
            DEFAULT_QUERY = 'SELECT id,account__r.sic,Service_Charge_Code__c,Freight_Charge_Flag__c,Pricing_on_packing_list__c,Mixture_of_exempt_non_exempt__c,Release_Number_Required__c,customer_transition_type__c,recordtype.name,recordtypeid,OwnerId,IsDeleted, CreatedById, Createddate,LastModifiedDate, LastModifiedById,Invoice_Email1__c,Fax_back_phone_number__c, Invoice_Email2__c, AR_Primary_Contact_First_Name__c,AR_Primary_Contact_Last_Name__c,AR_Phone__c,Cost_Center_Required__c,Back_Order_Cancel_or_Allow__c,Billing_Type_Flag__c,Billing_Frequency__c,AR_Flag__c,PO_Number_Required__c,Primary_Contact_First_Name__c,Primary_Contact_Last_Name__c,Primary_Contact_Phone__c,Tax_Exemption__c,Retail_Connect__c,Copies_in_Packing_list__c,Promo_Email__c,Promo_Phone__c,Promo_Catalog__c,Promo_Flyer__c,Drop_Ship_Flag__c,MIPAL_alternate_location_flag__c,Account__r.OwnerId,Account__r.id,Account__r.ParentId,Account__r.Phone,Account__r.Parent.AOPS_Cust_Id__c,Account__r.Related_Parent_Account__c,Account__r.Duns_Number__c,Account__r.Oracle_Party_ID__c,Account__r.Segment__c,Account__r.Name,Account__r.Ultimate_Duns_Number__c,Account__r.Omx_Primary_Key__c,Account__r.Sales_PersonID__r.name,Account__r.Oracle_Party_Site_ID__c,Account__r.Country__c,Account__r.City__c,Account__r.State__c,Account__r.Address2__c,Account__r.Address1__c,Account__r.Zip__c,AOPS_Flag__c,Primary_Contact_Phone_Extension__c,Billing_Document_Type__c,Error_Code__c,Account__r.Related_Account__c FROM Customer_Transition__c where (account__r.sales_personid__c!=null or account__r.sales_personid__c!=\'\') and (Status__c=\'Launched\' or (Error_Message_Level__c=\'Initial Account Setup Failure\' and Error_Message_Type__c=\'System Failure\' and Status__c=\'Error - Launched\')) and AOPS_Flag__c =\'Y\' and Account__r.Status__c = \'Active\' and customer_transition_type__c =:ParentChildLevel and Account__r.OMX_Mainframe_Account_Level__c = \'National\' and Transition_Status__c=\'Active\' and (Account__r.AOPS_Cust_Id__c=null or Account__r.AOPS_Cust_Id__c=\'\') and (Error_Code__c = null or Error_Code__c != \'Processing\')';             
        }    
        else
            DEFAULT_QUERY = 'SELECT id,account__r.sic,Service_Charge_Code__c,Freight_Charge_Flag__c,Pricing_on_packing_list__c,Mixture_of_exempt_non_exempt__c,Release_Number_Required__c,customer_transition_type__c,recordtype.name,recordtypeid,OwnerId,IsDeleted, CreatedById, Createddate,LastModifiedDate, LastModifiedById,Invoice_Email1__c,Fax_back_phone_number__c, Invoice_Email2__c, AR_Primary_Contact_First_Name__c,AR_Primary_Contact_Last_Name__c,AR_Phone__c,Cost_Center_Required__c,Back_Order_Cancel_or_Allow__c,Billing_Type_Flag__c,Billing_Frequency__c,AR_Flag__c,PO_Number_Required__c,Primary_Contact_First_Name__c,Primary_Contact_Last_Name__c,Primary_Contact_Phone__c,Tax_Exemption__c,Retail_Connect__c,Copies_in_Packing_list__c,Promo_Email__c,Promo_Phone__c,Promo_Catalog__c,Promo_Flyer__c,Drop_Ship_Flag__c,MIPAL_alternate_location_flag__c,Account__r.OwnerId,Account__r.id,Account__r.ParentId,Account__r.Phone,Account__r.Parent.AOPS_Cust_Id__c,Account__r.Related_Parent_Account__c,Account__r.Duns_Number__c,Account__r.Oracle_Party_ID__c,Account__r.Segment__c,Account__r.Name,Account__r.Ultimate_Duns_Number__c,Account__r.Omx_Primary_Key__c,Account__r.Sales_PersonID__r.name,Account__r.Oracle_Party_Site_ID__c,Account__r.Country__c,Account__r.City__c,Account__r.State__c,Account__r.Address2__c,Account__r.Address1__c,Account__r.Zip__c,AOPS_Flag__c,Primary_Contact_Phone_Extension__c,Billing_Document_Type__c,Error_Code__c,Account__r.Related_Account__c FROM Customer_Transition__c where (Status__c=\'Launched\' or (Error_Message_Level__c=\'Initial Account Setup Failure\' and Error_Message_Type__c=\'System Failure\' and Status__c=\'Error - Launched\'))and AOPS_Flag__c =\'Y\' and Account__r.Status__c = \'Active\' and Account__r.recordtype.Name =:OMXRecTyp and (Account__r.OMX_Mainframe_Account_Level__c = \'Site/Consignee\' or Account__r.OMX_Mainframe_Account_Level__c = \'Main Account\') and Transition_Status__c=\'Active\' and (Account__r.AOPS_Cust_Id__c=null or Account__r.AOPS_Cust_Id__c=\'\') and (Error_Code__c = null or Error_Code__c != \'Processing\')';     
        
        
        this.strQuery = DEFAULT_QUERY;
        */
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    }
    
    
    /*This costructor is called from the Batch Schedule method*/
    global Load_CustTransData_Batch2(String query)
    {
        //getCustSettings();
        System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else{
            //conditioncheck();
            this.strQuery = DEFAULT_QUERY;
        }
    }


    /*Start Method*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(strQuery); 
    }
    
    /* Execute  - Batch processing */
    global void execute(Database.BatchableContext BC, SObject[] scope){
        //Assigning the scope to a list
        List<Customer_Transition__c> custTransList = scope;
        //Map<ID,String> billtoKeyMap = new Map<ID,String>();
        string defaultPhone = '9999999999';
        Map<String,String> CodeToDescContract = new Map<String,String>();
        
        CodeToDescContract.put('1','List Less');
        CodeToDescContract.put('2','Retail Less');
        CodeToDescContract.put('3','Cost Up');
        
        
        Map<String,String> CodeToDescWholeSale = new Map<String,String>();
        
        CodeToDescWholeSale.put('1','List Less');
        CodeToDescWholeSale.put('2','Cost Up');
        
        batchCount = custTransList.size();
        if(custTransList.size()>0){
        
        set<ID> AcctSet = new set<ID>();
        
                
        //Custom settings to retreive the Pricing Template Name
        Default_Pricing_Template__c DPT = new Default_Pricing_Template__c();
        DPT = [select Template_Name__c from Default_Pricing_Template__c limit 1];
        
        //Querying of Pricing template fields for mapping.
        Pricing_Template__c PT = new Pricing_Template__c();
        PT = [select id,Contract_Number_10__c,
                        Contract_Number_1__c,Contract_Number_2__c,
                        Contract_Number_3__c,Contract_Number_4__c,
                        Contract_Number_5__c,Contract_Number_6__c,
                        Contract_Number_7__c,Contract_Number_8__c,
                        Contract_Number_9__c,Priority_1__c,
                        Priority_2__c,Priority_3__c,
                        Priority_4__c,Priority_5__c,
                        Priority_6__c,Priority_7__c,
                        Priority_8__c,Priority_9__c,
                        Priority_10__c,Cust_Prod_Xref__c,
                        Delivery_Code__c,Exclude_Universal_Pricing__c,
                        GP_Floor_Percernt__c,Loyalty__c,
                        Minimum_Order_Value__c,Off_Contract_Code__c,
                        Off_Contract_Percent__c,Off_Wholesale_Code__c,
                        Off_Wholesale_Percent__c,Price_Plan_Id__c,
                        Account_Setup_Notes_c__c, Revenue_Band__c,
                        Freight_Charge__c from Pricing_Template__c where Name =: DPT.Template_Name__c limit 1];
        
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // JB | Bill 2 Override code
        
        // scope|query pulls in the list
        for(Customer_Transition__c ct:custTransList){
            AcctSet.add(ct.Account__c);
        }
        
        Map<id,Account> map_Primary = new Map<id,Account>();
        Map<id,Account> map_Secondary = new Map<id,Account>();
            
        // my new guy - it will check header for N and child for B,SB
        Map<id,Customer_Transition_Dtls__c> map_SiteAddresses = new Map<id,Customer_Transition_Dtls__c> ();
                
        // handle CTDetail map assignment
        
        for (Customer_Transition_Dtls__c ctd:[select Account_ID__r.Primary_BillTo__C,Account_id__r.split_record__c,account_id__r.name,
        Account_id__r.Sales_PersonID__r.Name,Customer_Transition_ID__r.account__C,Account_id__c,Account_id__r.omx_primary_key__c,
        Account_id__r.oracle_party_site_id__c,Account_id__r.Country__c,Account_id__r.City__c,Account_id__r.State__c,
        Account_id__r.Address2__c,Account_id__r.Address1__c,Account_id__r.Zip__c,Ship_2_Bill_2_Code__c  from Customer_Transition_Dtls__c 
        where Ship_2_Bill_2_Code__c in ('B','SB')
         and 
        (  
        (Customer_Transition_ID__r.Ship_2_Bill_2_Code__c = 'N' and Customer_Transition_ID__r.Final_Split_Decision__c !='Yes' and Customer_Transition_ID__r.account__r.split_record__C=false)
          or 
         (Customer_Transition_ID__r.Final_Split_Decision__c='Yes'  and  Customer_Transition_ID__r.Bill_To_Key__c!=''  and Customer_Transition_ID__r.Bill_To_Key__c!=null  )
         
         or
         
          (Customer_Transition_ID__r.account__r.split_record__C=true and  Customer_Transition_ID__r.Bill_To_Key__c!=''  and Customer_Transition_ID__r.Bill_To_Key__c!=null  )
         )
         //Prod Fix - 00961618 - (AOPS_Flag__c = 'Y' or Customer_Transition_ID__r.Final_Split_Decision__c='Yes')
         and RecordType.Name='Sites' and (AOPS_Flag__c = 'Y' or Customer_Transition_ID__r.Account__r.Split_Record__c=true)
          and Customer_Transition_ID__r.account__C in:AcctSet    order by Account_ID__r.Primary_BillTo__C desc]){
            if (!map_SiteAddresses.containsKey(ctd.Customer_Transition_ID__r.account__C)){
              map_SiteAddresses.put(ctd.Customer_Transition_ID__r.account__C, ctd);
              
              }
        }   
        
        //Added by ivarada - 7/13/2015 - starts
        
           Map<ID,ID> site2siteMap = new Map<ID,ID>();
           
           Map<ID,String> mapOracle= new Map<ID,String>();

           
           
           Set<String> sitesProcessed = new Set<String> ();
           Map<id,Customer_Transition_Dtls__c> map_shipAddresses = new Map<id,Customer_Transition_Dtls__c>();
           
           //Prod Fix - 00961618 - (AOPS_Flag__c = 'Y' or Customer_Transition_ID__r.Final_Split_Decision__c='Yes')
           for (Customer_Transition_Dtls__c ctd:[select Account_id__r.split_record__c,Account_id__r.Sales_PersonID__r.Name,account_id__r.name,
           Customer_Transition_ID__r.account__C,Ship_2_Bill_2_Code__c,Account_id__c,Account_id__r.omx_primary_key__c,
           Account_id__r.oracle_party_site_id__c,Account_id__r.Country__c,Account_id__r.City__c,Account_id__r.State__c,
           Account_id__r.Address2__c,Account_id__r.Address1__c,Account_id__r.Zip__c from Customer_Transition_Dtls__c 
           where RecordType.Name='Sites' and (AOPS_Flag__c = 'Y' or Customer_Transition_ID__r.Account__r.Split_Record__c=true) and Customer_Transition_ID__r.account__C in:AcctSet AND Ship_2_Bill_2_Code__c IN ('S','SB')] ){
             
             if (ctd.Ship_2_Bill_2_Code__c == 'SB' && map_SiteAddresses.containsKey(ctd.Customer_Transition_ID__r.account__C)) {
                  if (map_SiteAddresses.get(ctd.Customer_Transition_ID__r.account__C).Ship_2_Bill_2_Code__c =='SB')
                   map_shipAddresses.put(ctd.Customer_Transition_ID__r.account__C, map_SiteAddresses.get(ctd.Customer_Transition_ID__r.account__C));
                  else if (!map_shipAddresses.containsKey(ctd.Customer_Transition_ID__r.account__C) )
                   map_shipAddresses.put(ctd.Customer_Transition_ID__r.account__C, ctd);
               }
               else{
                 if (!map_shipAddresses.containsKey(ctd.Customer_Transition_ID__r.account__C) )
                   map_shipAddresses.put(ctd.Customer_Transition_ID__r.account__C, ctd);
                 }
             
             }
             
          
        //Added by ivarada - 7/13/2015 - ends            
        
        // now hit up the flag eval for all OMX-001's and override-let OMX-002's consume OG code
       
        for(Account ac:[select Name,id,Related_Account__r.split_record__c,Related_Account__c,Related_Account__r.omx_primary_key__c,split_record__c,OMX_Primary_Key__c,Oracle_Party_Site_ID__c,Country__c,City__c,State__c,Address2__c,
        Address1__c,Zip__c from Account where RecordType.Name='Site (OfficeMax)' and Related_Account__c in:AcctSet and 
        OMX_Primary_Key__c like '%OMX00%'])
        {
            if(ac.OMX_Primary_Key__c.contains('OMX001'))
                if (map_SiteAddresses.containsKey(ac.Related_Account__c)) {
                    // override address only - it links to the new map i created with the header and detail check
                    ac.Address1__c = map_SiteAddresses.get(ac.Related_Account__c).Account_id__r.Address1__c;
                    ac.Address2__c = map_SiteAddresses.get(ac.Related_Account__c).Account_id__r.Address2__c;
                    ac.Country__c = map_SiteAddresses.get(ac.Related_Account__c).Account_id__r.Country__c;
                    ac.City__c = map_SiteAddresses.get(ac.Related_Account__c).Account_id__r.City__c;
                    ac.State__c = map_SiteAddresses.get(ac.Related_Account__c).Account_id__r.State__c;
                    ac.Zip__c = map_SiteAddresses.get(ac.Related_Account__c).Account_id__r.Zip__c;
                    
                    
                    //case#705570 change begins
                    if (ac.Related_Account__r.split_record__c) {
                      ac.omx_primary_key__c = map_SiteAddresses.get(ac.Related_Account__c).Account_id__r.omx_primary_key__c;
                      ac.Oracle_Party_Site_ID__c = map_SiteAddresses.get(ac.Related_Account__c).Account_id__r.Oracle_Party_Site_ID__c;
                    }
                    else {
                      ac.OMX_Primary_key__c = ac.Related_Account__r.omx_primary_key__c;
                      //billtoKeyMap.put(ac.related_account__c,map_SiteAddresses.get(ac.Related_Account__c).Account_id__r.omx_primary_key__c);
                    }
                    //case#705570 change ends
                     
                    ac.split_record__c = map_SiteAddresses.get(ac.Related_Account__c).Account_id__r.split_record__c;
                   
                    /////////////////////////////////////////
                    System.debug('***Account Id of Valid Bill 2 Address---->'+ ac.Id + '<----***');
                    /////////////////////////////////////////
                    map_Primary.put(ac.Related_Account__c, ac);
                    site2siteMap.put(ac.id,map_SiteAddresses.get(ac.Related_Account__c).Account_id__c);

                }
                else {
                    map_Primary.put(ac.Related_Account__c, ac);  
                }                   
            else if(ac.OMX_Primary_Key__c.contains('OMX002')) {
            
             mapOracle.put(ac.Id,ac.oracle_party_site_id__c);

              //Added by ivarada - 7/13/2015 - starts 
               if (map_shipAddresses.containsKey(ac.Related_Account__c)) {
                    ac.Address1__c = map_shipAddresses.get(ac.Related_Account__c).Account_id__r.Address1__c;
                    ac.Address2__c = map_shipAddresses.get(ac.Related_Account__c).Account_id__r.Address2__c;
                    ac.Country__c = map_shipAddresses.get(ac.Related_Account__c).Account_id__r.Country__c;
                    ac.City__c = map_shipAddresses.get(ac.Related_Account__c).Account_id__r.City__c;
                    ac.State__c = map_shipAddresses.get(ac.Related_Account__c).Account_id__r.State__c;
                    ac.Zip__c = map_shipAddresses.get(ac.Related_Account__c).Account_id__r.Zip__c;
                    
                    //if(map_shipAddresses.get(ac.Related_Account__c).Ship_2_Bill_2_Code__c !='SB')
                    // ac.Oracle_Party_Site_ID__c = map_shipAddresses.get(ac.Related_Account__c).Account_id__r.Oracle_Party_Site_ID__c;
                   
                    
                     ac.omx_primary_key__c = map_shipAddresses.get(ac.Related_Account__c).Account_id__r.omx_primary_key__c;
                    
                     ac.split_record__c = map_shipAddresses.get(ac.Related_Account__c).Account_id__r.split_record__c;

                    map_Secondary.put(ac.Related_Account__c, ac);
                    
                    if(map_shipAddresses.get(ac.Related_Account__c).Ship_2_Bill_2_Code__c =='SB'  &&  map_SiteAddresses.containsKey(ac.Related_Account__c)  && map_SiteAddresses.get(ac.Related_Account__c).Ship_2_Bill_2_Code__c =='SB' && ac.Related_Account__r.split_record__c) {
                     site2siteMap.put(ac.id,ac.Id);
                    }
                    else {
                      site2siteMap.put(ac.id,map_shipAddresses.get(ac.Related_Account__c).Account_id__c);
                      ac.Oracle_Party_Site_ID__c = map_shipAddresses.get(ac.Related_Account__c).Account_id__r.Oracle_Party_Site_ID__c;
                    }
                    
                    System.debug('***Consignee Address Used for Shipto***');
               }
               else {
                map_Secondary.put(ac.Related_Account__c, ac);
                System.debug('***Main Account Address Used for Shipto***');
               }
             //Added by ivarada - 7/13/2015 - ends
            }   
        }       
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // JB | Pre-Ship 2 Bill 2 Code-Replaced by block above -2/11/15
        /*
        //Below Logic is for Primary and Secondary site information
        for(Customer_Transition__c ct:custTransList){
            AcctSet.add(ct.Account__c);
        }
        Map<id,Account> map_Primary = new Map<id,Account>();
        Map<id,Account> map_Secondary = new Map<id,Account>();
        for(Account ac:[select id,Related_Account__c,OMX_Primary_Key__c,Oracle_Party_Site_ID__c,Country__c,City__c,State__c,Address2__c,Address1__c,Zip__c from Account where RecordType.Name='Site (OfficeMax)' and Related_Account__c in:AcctSet and OMX_Primary_Key__c like '%OMX00%'])
        {
            if(ac.OMX_Primary_Key__c.contains('OMX001'))
                map_Primary.put(ac.Related_Account__c, ac);
            else if(ac.OMX_Primary_Key__c.contains('OMX002'))
                map_Secondary.put(ac.Related_Account__c, ac);
            
        }
        */
        /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        /*
        Set<ID> sParentID = new Set<ID>();
        Set<ID> s2ParentID = new Set<ID>();
        Set<ID> sGParentID = new Set<ID>();
        Set<ID> listParentID = new Set<ID>();
        List<Account> l3Accounts = [Select id,parentID,parent.parentID,name from Account where parentID != null and parent.parentID != null];
        for(Account acc : l3Accounts){
               //sChildIDs.add(acc.id); 
               sParentID.add(acc.parentId);
               sGParentID.add(acc.parent.parentId);
        }
        List<Account> l2Accounts = [Select id,parentID,parent.parentID,name from Account where id not in :sParentID and parentID != null and parent.parentID = null];
        
        for(Account acc : l2Accounts)
        {     
            
            s2ParentID.add(acc.parentId);
        }
        listParentID.addAll(sParentID);
        listParentID.addAll(s2ParentID);
        */
        
        
        
                
        // below logic is to fetch scope size only once duriing the whole batch process
        if(Scope_Size != -1)
            Scope_Size =  custTransList.size(); 
        //initializing Account Setup Request object List
        List<Account_Setup_Request__c> ASRList = new List<Account_Setup_Request__c>();
        
        //Looping over Customer Transition object for mapping 
        
        
        for(Customer_Transition__c CT: custTransList){
        
        boolean ProcessSec= false;
        
        System.debug('&&&&&&&&&&&&&&&&Processesing Record here1'+CT.Account__r.Omx_Primary_Key__c);
         boolean processRecord = true;
         
         if (ct.Account__r.ParentId != null && ParentChildLevel!=null && ParentChildLevel=='Child' && CT.Account__r.Parent.aops_cust_id__c == null) {
            processRecord = false;
            system.debug('Transition ID:' + ct.id + ' Does not have parent setup in AOPS');
         }
            
        /* if (CT.Account__r.Sales_PersonID__c == null) {
            processRecord = false;
            system.debug('Transition ID:' + ct.id + ' Does not have Sales Rep Setup');
         }*/
         
         if (processRecord)                  
         {
                 System.debug('&&&&&&&&&&&&&&&&Processesing Record here2'+CT.Account__r.Omx_Primary_Key__c);

            Account_Setup_Request__c ASR = new Account_Setup_Request__c();
            
            //below fields are mapped from customer transition obj directly/*
            
            
            if(CT.Final_Split_Decision__c=='Yes'){
            ASR.AP_Contact_First_Name__c = CT.Split_AR_Contact_First_Name__C;
            ASR.AP_Contact_Last_Name__c = CT.Split_AR_Contact_Last_Name__C;
            
            
              
            if (CT.Split_AR_Phone__c != null && CT.Split_AR_Phone__c != '0000000000')
             ASR.AP_Contact_Phone__c = CT.Split_AR_Phone__c; //'(701) 651-1035'; 
            else
              ASR.AP_Contact_Phone__c = defaultPhone;

             }
             
             else{
            
            
            ASR.AP_Contact_First_Name__c = CT.AR_Primary_Contact_First_Name__c;
            ASR.AP_Contact_Last_Name__c = CT.AR_Primary_Contact_Last_Name__c;
            
            if (CT.AR_Phone__c != null && CT.AR_Phone__c != '0000000000')
             ASR.AP_Contact_Phone__c = CT.AR_Phone__c; //'(701) 651-1035'; 
            else
              ASR.AP_Contact_Phone__c = defaultPhone;
             } 
             
             
             if (ASR.AP_Contact_First_Name__c != null && ASR.AP_Contact_First_Name__c != '' && (ASR.AP_Contact_Last_Name__c == null || ASR.AP_Contact_Last_Name__c == ''))
              ASR.AP_Contact_Last_Name__c = 'Payables';
            
            IF (CT.Release_Number_Required__c == 'Y')
               ASR.Release__c = 'Yes';
            else
               ASR.Release__c = 'No';
            
            
            ASR.Are_cost_center_numbers_etc_required__c = CT.Cost_Center_Required__c;
            
            if (CT.Back_Order_Cancel_or_Allow__c == 'Y')
              ASR.Back_Orders_Flag__c = 'Yes';
            else
              ASR.Back_Orders_Flag__c = 'No';
   
            if(CT.Billing_Type_Flag__c == 'P')
                ASR.Billing_Delivery_Method_Media_type__c = 'Paper';
            else
                ASR.Billing_Delivery_Method_Media_type__c = 'ePDF';
                
            if(CT.Billing_Frequency__c == 'D')
                ASR.Billing_Frequency__c = 'Daily';
            else if(CT.Billing_Frequency__c == 'W')
                ASR.Billing_Frequency__c = 'Weekly';
            else if(CT.Billing_Frequency__c == 'M'  || CT.Billing_Frequency__c == 'C')
                ASR.Billing_Frequency__c = 'Monthly';
            else if(CT.Billing_Frequency__c == 'S')
                ASR.Billing_Frequency__c = 'Semi-Monthly';
               
                
            if(CT.AR_Flag__c == 'Y')
                ASR.Invoice_Payment_Method__c = 'Account Billing';
            else
                ASR.Invoice_Payment_Method__c = 'Credit Card';
            
            if (CT.PO_Number_Required__c == 'Y')
              ASR.PO__c = 'Yes';
            else
              ASR.PO__c = 'No';
          
            
           
             ASR.Primary_Contact_First_Name__c = noName(CT.Primary_Contact_First_Name__c,'fname');
             ASR.Primary_Contact_Last_Name__c = noName(CT.Primary_Contact_Last_Name__c,'lname');
             ASR.Sales_Contact_Phone_Extension__c = CT.Primary_Contact_Phone_Extension__c;
              if (CT.Primary_Contact_Phone__c != null && CT.Primary_Contact_Phone__c != '0000000000'){                 
                     ASR.Primary_Contact_Phone__c = CT.Primary_Contact_Phone__c;                
                     }        
                    else
                     ASR.Primary_Contact_Phone__c = defaultPhone;
                
                          
            
            ASR.Tax_Exempt__c = CT.Tax_Exemption__c; 
            
           /* if(CT.Tax_Exemption__c == true)
                ASR.Tax_Exempt__c = 'Y';
            else
                ASR.Tax_Exempt__c = 'N';
           */ 
            if(CT.Retail_Connect__c == true)
                ASR.pick_up_orders_from_our_retail_stores__c = 'Y';
            else
                ASR.pick_up_orders_from_our_retail_stores__c = 'N';
                
            ASR.INV_NUM_OF_COPIES__c = CT.Copies_in_Packing_list__c;
            ASR.PROMO_FLAG_EMAIL__c = CT.Promo_Email__c;
            ASR.PROMO_FLAG_PHONE__c = CT.Promo_Phone__c;
            ASR.PROMO_FLAG_CATALOG__c = CT.Promo_Catalog__c;
            ASR.PROMO_FLAG_FLYER__c = CT.Promo_Flyer__c;
            ASR.Y_N_exclude_Vendor_Drop_Ship__c = CT.Drop_Ship_Flag__c;
            ASR.Y_N_exclude_Alternate_Sourcing__c = CT.MIPAL_alternate_location_flag__c;
            ASR.AUTO_BACK_FAX_OR_EMAIL_ADDR__c = CT.Fax_back_phone_number__c;
            ASR.SIC_Code_c__c = CT.account__r.sic;
                        
            if(CT.Invoice_Email1__c != null){
                String str = CT.Invoice_Email1__c;
                ASR.eBilling_Contact_Email__c = CT.Invoice_Email1__c;
                ASR.eBilling_Contact_First_Name__c = str.substring(0,str.indexOf('@'));
                ASR.eBilling_Contact_Last_Name__c = str.substring(0,str.indexOf('@'));
            }
           /* else{
                ASR.eBilling_Contact_Email__c = 'test@exampls.com';
                ASR.eBilling_Contact_First_Name__c = 'AOPS NFNOMX';
                ASR.eBilling_Contact_Last_Name__c = 'AOPS NLNOMX';
            }*/
            
           /* if(CT.Invoice_Email2__c != null){
                String str2 = CT.Invoice_Email2__c;
                ASR.eBilling_Contact_Email2__c = CT.Invoice_Email2__c;
                ASR.eBilling_Contact_First_Name2__c = str2.substring(0,str2.indexOf('@'));
                ASR.eBilling_Contact_Last_Name2__c = str2.substring(0,str2.indexOf('@'));
            }
            else{
                ASR.eBilling_Contact_Email2__c = 'test@exml.com';
                ASR.eBilling_Contact_First_Name2__c = 'test';
                ASR.eBilling_Contact_Last_Name2__c = 'test';
            }*/
            
            
            //Below mapping for fields from account ref fields
            ASR.OwnerId = CT.Account__r.OwnerId;
            ASR.ACCOUNT_ID__c = CT.Account__r.id;
            ASR.AOPS_Parent_ID__c = CT.Account__r.Parent.AOPS_Cust_Id__c;
            if (CT.Account__r.Phone != null && CT.Account__r.Phone != '0000000000')
              ASR.Account_Phone__c = CT.Account__r.Phone; //'(701) 651-1035'; //
            else
              ASR.Account_Phone__c = defaultPhone;
            ASR.Account__c = CT.Account__r.Id;
            if(ParentChildLevel!=null && ParentChildLevel=='Child')
                ASR.Add_Parent_ID__c = CT.Account__r.Parent.aops_cust_id__c;
            /*if(CT.Account__r.Name.length()>30)
                ASR.BillTo_Name__c = CT.Account__r.Name.substring(0,30);
            else
                ASR.BillTo_Name__c = CT.Account__r.Name; 
            */    
            
            ASR.Duns_Number__c = CT.Account__r.Duns_Number__c;
            ASR.ORACLE_PARTY_ID__c = CT.Account__r.Oracle_Party_ID__c;
            ASR.Rep_ID__c = CT.Account__r.Sales_PersonID__r.name;
            ASR.Segment__c = CT.Account__r.Segment__c;
            
            /*
            if(CT.Account__r.Name.length()>30)
                ASR.ShipTo_Name__c = CT.Account__r.Name.substring(0,30);
            else
                ASR.ShipTo_Name__c = CT.Account__r.Name; 
            */
            ASR.Ultimate_Duns_Number__c = CT.Account__r.Ultimate_Duns_Number__c;
            
            if(!CT.Account__r.Split_Record__c   ){
             ASR.OMAX_ACCT_ID__c = CT.Account__r.Omx_Primary_Key__c;
            }
            else{
             String[] chars = CT.Account__r.Omx_Primary_Key__c.split('-');
             ASR.OMAX_ACCT_ID__c=chars[0];
            }
            
            
            //Added/Modified by ivarada 7/13/2015 - starts
            
            if (map_SiteAddresses.containsKey(CT.Account__r.id)) {
              if (!map_Primary.get(CT.Account__r.id).split_record__c)
               ASR.OMAX_BILL_TO_ADDR_ID__c = map_Primary.get(CT.Account__r.id).omx_primary_key__c;
            }
            else {
             if(!CT.Account__r.split_record__c)
              ASR.OMAX_BILL_TO_ADDR_ID__c = CT.Account__r.Omx_Primary_Key__c;
            }
            
            
            
            
            if (map_shipAddresses.containsKey(CT.Account__r.id)) {
             if (!map_Secondary.get(CT.Account__r.id).split_record__c){
              if( map_Secondary.get(CT.Account__r.id).omx_primary_key__c.length()<=13)   {  
                  if(map_Secondary.get(CT.Account__r.id).omx_primary_key__c.contains('OMX002'))
                  ASR.OMAX_SHIP_TO_ADDR_ID__c = CT.Account__r.Omx_Primary_Key__c;
                  else
                  ASR.OMAX_SHIP_TO_ADDR_ID__c = map_Secondary.get(CT.Account__r.id).omx_primary_key__c;
              }
              }
            }
            else {
             if(!CT.Account__r.split_record__c)  
              ASR.OMAX_SHIP_TO_ADDR_ID__c = CT.Account__r.Omx_Primary_Key__c;
            }
            
                       

            
            //Added/Modified by ivarda 7/13/2015 - ends
            
            if (ct.Mixture_of_exempt_non_exempt__c)
              ASR.TAX_EXCEPTION_FLAG__c = 'Y';
            else
              ASR.TAX_EXCEPTION_FLAG__c = 'N';
            
            system.debug('CT.Account__r.Sales_PersonID__c>>>>>'+CT.Account__r.Sales_PersonID__c+'  '+CT.Account__r.Sales_PersonID__r.name);
            
            //Added/Modified by ivarada 7/13/2015 - starts
            
            if(CT.Account__r.Sales_PersonID__r.name!='' && CT.Account__r.Sales_PersonID__r.name!=null){
            
            if (map_shipAddresses.containsKey(CT.Account__r.id)) {
              if (map_shipAddresses.get(CT.Account__r.id).Account_id__r.Sales_PersonID__r.Name != null) {
                
                if(map_shipAddresses.get(CT.Account__r.id).Account_id__r.Sales_PersonID__r.Name.length()>7)
                  ASR.Sales_Rep_ID_for_First_Ship_to__c = map_shipAddresses.get(CT.Account__r.id).Account_id__r.Sales_PersonID__r.Name.substring(0,6);
                else
                 ASR.Sales_Rep_ID_for_First_Ship_to__c = map_shipAddresses.get(CT.Account__r.id).Account_id__r.Sales_PersonID__r.Name;
                 
              }
            
            }
            else {
            
             if(CT.Account__r.Sales_PersonID__r.name.length()>7)
                ASR.Sales_Rep_ID_for_First_Ship_to__c = CT.Account__r.Sales_PersonID__r.name.substring(0,6);
             else
                 ASR.Sales_Rep_ID_for_First_Ship_to__c = CT.Account__r.Sales_PersonID__r.name;
             }
            }
            
            //Added/Modified by ivarada 7/13/2015 - ends
            
            //below mapping for fields from account-Site ref fields
            if(map_Primary.get(CT.Account__r.id)!=null && map_Secondary.get(CT.Account__r.id)!=null){
          
            //Added/Modified by ivarada 7/13/2015 - starts
            if (site2siteMap.containskey(map_Primary.get(CT.Account__r.id).id)) {       
                
               //Case#705570 begins
               if (CT.Account__r.split_record__c)   {   
                ASR.SFDC_BILLTO_ID__c = site2siteMap.get(map_Primary.get(CT.Account__r.id).id);  
                ASR.BILLTO_ORACLE_PARTY_SITE_ID__c = map_SiteAddresses.get(CT.Account__r.id).Account_id__r.Oracle_Party_Site_ID__c; 
               }
               else {
                 ASR.SFDC_BILLTO_ID__c = map_Primary.get(CT.Account__r.id).id;
                 ASR.BILLTO_ORACLE_PARTY_SITE_ID__c = map_Primary.get(CT.Account__r.id).Oracle_Party_Site_ID__c; 
              
               }
               
               //Case#705570 ends
        
                                            
               ASR.BILL_COUNTRY__c = map_SiteAddresses.get(CT.Account__r.id).Account_id__r.Country__c;                              
               ASR.City_Bill__c = map_SiteAddresses.get(CT.Account__r.id).Account_id__r.City__c;                                 
               ASR.State_Bill__c = map_SiteAddresses.get(CT.Account__r.id).Account_id__r.State__c;                            
               ASR.Street_Address_2_Bill__c = map_SiteAddresses.get(CT.Account__r.id).Account_id__r.Address2__c;                              
               ASR.Street_Address_Bill__c = map_SiteAddresses.get(CT.Account__r.id).Account_id__r.Address1__c;                              
               ASR.Zip_Bill__c = map_SiteAddresses.get(CT.Account__r.id).Account_id__r.Zip__c;
               
               String billToname=map_SiteAddresses.get(CT.Account__r.id).Account_id__r.name;
             if(billToname!=null){
              if(billToname.length()>30)
                ASR.BillTo_Name__c = billToname.substring(0,30);
               else
                ASR.BillTo_Name__c = billToname; 
               } 
               
                              
               
            }
            else{
            ASR.AP_ORACLE_PARTY_SITE_ID__c = map_Primary.get(CT.Account__r.id).Oracle_Party_Site_ID__c;

              ASR.SFDC_BILLTO_ID__c = map_Primary.get(CT.Account__r.id).id;
              ASR.BILLTO_ORACLE_PARTY_SITE_ID__c = map_Primary.get(CT.Account__r.id).Oracle_Party_Site_ID__c;
              ASR.BILL_COUNTRY__c = map_Primary.get(CT.Account__r.id).Country__c;
              ASR.City_Bill__c = map_Primary.get(CT.Account__r.id).City__c;
              ASR.State_Bill__c = map_Primary.get(CT.Account__r.id).State__c;
              ASR.Street_Address_2_Bill__c = map_Primary.get(CT.Account__r.id).Address2__c;
              ASR.Street_Address_Bill__c = map_Primary.get(CT.Account__r.id).Address1__c;
              ASR.Zip_Bill__c = map_Primary.get(CT.Account__r.id).Zip__c;
              
               String billTonamePrim=map_Primary.get(CT.Account__r.id).Name;
              if(billTonamePrim.length()>30)
                ASR.BillTo_Name__c = billTonamePrim.substring(0,30);
               else
                ASR.BillTo_Name__c = billTonamePrim; 
                
              

              }
            
            if (site2siteMap.containskey(map_Secondary.get(CT.Account__r.id).id)) {
              
              ASR.SFDC_SHIPTO_ID__c = site2siteMap.get(map_Secondary.get(CT.Account__r.id).id);  
              
                         
              ASR.City_Ship__c = map_shipAddresses.get(CT.Account__r.id).Account_id__r.City__c; 
              ASR.SHIPTO_ORACLE_PARTY_SITE_ID__c=mapOracle.get(site2siteMap.get(map_Secondary.get(CT.Account__r.id).id));
              
              if(map_shipAddresses.get(CT.Account__r.id).Ship_2_Bill_2_Code__c == 'SB'){
                ASR.SHIPTO_ORACLE_PARTY_SITE_ID__c =map_Secondary.get(CT.Account__r.id).Oracle_Party_Site_ID__c;
              }
              else{                                              
              ASR.SHIPTO_ORACLE_PARTY_SITE_ID__c = map_shipAddresses.get(CT.Account__r.id).Account_id__r.Oracle_Party_Site_ID__c;
              }
              
              
              ASR.SHIP_COUNTRY__c = map_shipAddresses.get(CT.Account__r.id).Account_id__r.Country__c;
              ASR.State_Ship__c = map_shipAddresses.get(CT.Account__r.id).Account_id__r.State__c;
              ASR.Street_Address_2_Ship__c = map_shipAddresses.get(CT.Account__r.id).Account_id__r.Address2__c;
              ASR.Street_Address_Ship__c = map_shipAddresses.get(CT.Account__r.id).Account_id__r.Address1__c;
              ASR.Zip_Ship__c = map_shipAddresses.get(CT.Account__r.id).Account_id__r.Zip__c;
              
                 String shiptoName=map_shipAddresses.get(CT.Account__r.id).Account_id__r.name;
                 if(shiptoName.length()>30)
                 ASR.ShipTo_Name__c = shiptoName.substring(0,30);
                 else
                 ASR.ShipTo_Name__c = shiptoName; 
                
                
              
            }
            else{
            ASR.SFDC_SHIPTO_ID__c = map_Secondary.get(CT.Account__r.id).id;
            ASR.City_Ship__c = map_Secondary.get(CT.Account__r.id).City__c;                                               
            ASR.SHIPTO_ORACLE_PARTY_SITE_ID__c = map_Secondary.get(CT.Account__r.id).Oracle_Party_Site_ID__c;
            ASR.SHIP_COUNTRY__c = map_Secondary.get(CT.Account__r.id).Country__c;
            ASR.State_Ship__c = map_Secondary.get(CT.Account__r.id).State__c;
            ASR.Street_Address_2_Ship__c = map_Secondary.get(CT.Account__r.id).Address2__c;
            ASR.Street_Address_Ship__c = map_Secondary.get(CT.Account__r.id).Address1__c;
            ASR.Zip_Ship__c = map_Secondary.get(CT.Account__r.id).Zip__c;
              
               String shiptoNameSec=map_Secondary.get(CT.Account__r.id).Name;
               if(shiptoNameSec.length()>30)
               ASR.ShipTo_Name__c = shiptoNameSec.substring(0,30);
               else
               ASR.ShipTo_Name__c = shiptoNameSec; 
                
            }  
             
              
            //Added/Modified by ivarada 7/13/2015 - ends
            }

            // Below mapping for fields from Pricing Template
            ASR.Core_Item_Price_List_ID_10__c = PT.Contract_Number_10__c;
            ASR.Core_Item_Price_List_ID_1__c = PT.Contract_Number_1__c;
            ASR.Core_Item_Price_List_ID_2__c = PT.Contract_Number_2__c;
            ASR.Core_Item_Price_List_ID_3__c = PT.Contract_Number_3__c;
            ASR.Core_Item_Price_List_ID_4__c = PT.Contract_Number_4__c;
            ASR.Core_Item_Price_List_ID_5__c = PT.Contract_Number_5__c;
            ASR.Core_Item_Price_List_ID_6__c = PT.Contract_Number_6__c;
            ASR.Core_Item_Price_List_ID_7__c = PT.Contract_Number_7__c;
            ASR.Core_Item_Price_List_ID_8__c = PT.Contract_Number_8__c;
            ASR.Core_Item_Price_List_ID_9__c = PT.Contract_Number_9__c;
            ASR.Core_Item_Price_List_Priority_Code_10__c = PT.Priority_10__c;
            ASR.Core_Item_Price_List_Priority_Code_1__c = PT.Priority_1__c;
            ASR.Core_Item_Price_List_Priority_Code_2__c = PT.Priority_2__c;
            ASR.Core_Item_Price_List_Priority_Code_3__c = PT.Priority_3__c;
            ASR.Core_Item_Price_List_Priority_Code_4__c = PT.Priority_4__c;
            ASR.Core_Item_Price_List_Priority_Code_5__c = PT.Priority_5__c;
            ASR.Core_Item_Price_List_Priority_Code_6__c = PT.Priority_6__c;
            ASR.Core_Item_Price_List_Priority_Code_7__c = PT.Priority_7__c;
            ASR.Core_Item_Price_List_Priority_Code_8__c = PT.Priority_8__c;
            ASR.Core_Item_Price_List_Priority_Code_9__c = PT.Priority_9__c;
            ASR.Cross_Reference_Number__c = PT.Cust_Prod_Xref__c;
            
            if (CT.Freight_Charge_Flag__c == 'Y')
              ASR.Deliver_Charge_Code__c = CT.Service_Charge_Code__c;
            //check
            ASR.Exclude_Account_from_Universal_Pricing__c = PT.Exclude_Universal_Pricing__c;
            ASR.GP_Floor__c = PT.GP_Floor_Percernt__c;
            ASR.Loyalty_Type__c =PT.Loyalty__c;
            if (PT.Minimum_Order_Value__c != null)
             ASR.Minimum_Order_Value__c = Double.valueof(PT.Minimum_Order_Value__c);
            if (PT.Off_Contract_Code__c != null)
              ASR.Off_Contract__c = CodeToDescContract.get(PT.Off_Contract_Code__c);
            ASR.Off_Contract_percent__c = PT.Off_Contract_Percent__c;
            if (PT.Off_Wholesale_Code__c != null)
              ASR.Off_Wholesale__c = CodeToDescWholeSale.get(PT.Off_Wholesale_Code__c);
            ASR.Off_Wholesale_percent__c = PT.Off_Wholesale_Percent__c;
            ASR.Price_Plan__c = PT.Price_Plan_Id__c;
            //ASR.Rep_Comments__c = PT.Account_Setup_Notes_c__c;
            ASR.Revenue_Band__c = PT.Revenue_Band__c;
            if (CT.Freight_Charge_Flag__c == 'Y')
             ASR.Small_Order_Fee_Flag__c = 'Yes';
            else
             ASR.Small_Order_Fee_Flag__c = 'No';
            
            if (CT.Cost_Center_Required__c == 'Y')
               ASR.Cost_Center__c = 'Yes';
            else if (CT.Cost_Center_Required__c == 'H')
               ASR.Cost_Center__c = 'Hide';
            else if (CT.Cost_Center_Required__c == 'V')
               ASR.Cost_Center__c = 'Validate';
            else
               ASR.Cost_Center__c = 'No';

            // Hardcoded fields
            ASR.OPERATION__c = 'E';
            ASR.Auto_Fax_Flag__c = 'F';
            //ASR.Cost_Center__c = 'Hide';
            ASR.Desktop__c = 'Hide';
            ASR.Delivery_Method__c = 'INV'; 
            ASR.Display_Payment_Method__c = 'No';
            ASR.Display_Prices__c = 'No';
            ASR.PROSPECT_SOURCE__c = 'SFDC';
            //ASR.Existing_OMAX_Account__c = 'Y'; // This field is discontinued in this class. 
            ASR.AUTO_BACK_FAX_EMAIL__c = 'F';
            ASR.TIER_1_ACCOUNT_CODE__c = '';
            ASR.PROMO_FAX__c = '';
            ASR.PROMO_FLAG_STUFFER__c = '';
            ASR.PD_Detail__c = 'Yes';            
            if(CT.Billing_Document_Type__c == 'S' || CT.Billing_Document_Type__c == 'N')
                ASR.PD_Doc_Name__c = 'Standard Invoice';
            else if(CT.Billing_Document_Type__c == 'C')
                ASR.PD_Doc_Name__c = 'Consolidated Bill';
            
            ASR.PD_Incl_Backup_Inc__c = 'No';
                                    
            if(ParentChildLevel!=null && ParentChildLevel=='Parent'){
                ASR.PARENT_CODE__c = 'P';
            }
            else{
                ASR.PARENT_CODE__c = '';
            }
            
            ASR.Content_Set_2_PR_3_LP__c = CT.Pricing_on_packing_list__c;
            ASR.Survey_Complete__c = true;
            ASR.TriggerByPass__c = true;
            ASRList.add(ASR);
            
            sitesProcessed.add(ASR.OMAX_SHIP_TO_ADDR_ID__c);
            sitesProcessed.add(ASR.OMAX_BILL_TO_ADDR_ID__c);
            
            
                    System.debug('&&&&&&&&&&&&&&&&Processesing Record here2'+CT.Account__r.Omx_Primary_Key__c);

            CT.Error_Code__c = 'Processing';
             
            //case#705570 change begins
             //if (!ct.account__r.Split_Record__c) {
             //    if (billtoKeyMap.containsKey(ct.Account__r.id))
             //        ct.Bill_To_Key__c = billtoKeyMap.get(ct.Account__r.id); 
            // }
            //case#705570 change ends
            
           }
        }
        
        try{
                insert ASRList;
                        System.debug('&&&&&&&&&&&&&&&&Processesing Record here3');

                Id recordtypeidCust= Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
                System.debug('&&&&&&'+recordtypeidCust);

                List<Customer_transition_dtls__C> dtlsUpd = new list<customer_transition_dtls__C>();
            
               //TimeoutFix - Starts
                  list<String> sitesProcessedN = new list<String> ();
                  for (String s:sitesProcessed) {
                      if (s != null && s!='') {
                        sitesProcessedN.add(s);
                        system.debug('Site Added:' + s);
                      }
                  }
               //TimeoutFix - Ends
                
                For (Customer_Transition_dtls__C d:[select id,error_code__c from customer_transition_dtls__c where
                 omx_primary_key__c = :sitesProcessedN  and recordtypeId=:recordtypeidCust  order by lastmodifieddate limit 5000]) {
                    d.error_code__C = 'Processing';
                    dtlsUpd.add(d);
                }
                
                Database.SaveResult[] dtlsUpdResult = Database.update(dtlsUpd, false);
                
                For (database.SaveResult sr: dtlsUpdResult) {
                    
                    if (!sr.isSuccess()) {
                        for(Database.Error err : sr.getErrors()) {

                            System.debug('The following error has occurred for Dtls Update: ' + sr.getId());                   

                            System.debug(err.getStatusCode() + ': ' + err.getMessage());

                       }
                    }
                    
                }
                 
                //update custTransList;
                Database.SaveResult[] custTransSaveList = Database.update(custTransList, false);

                // Iterate through each returned result
                for (Database.SaveResult sr : custTransSaveList) {
                
                


                    if (sr.isSuccess()) {

                        // Operation was successful, so get the ID of the record that was processed

                        //System.debug('Customer Transition Successfully updated. Customer Transition ID: ' + sr.getId());

                    }

                    else {
                    
                                      System.debug('output' + sr);                   


                        // Operation failed, so get all errors               

                        for(Database.Error err : sr.getErrors()) {

                            System.debug('The following error has occurred for Customer Transition ID: ' + sr.getId());                   

                            System.debug(err.getStatusCode() + ': ' + err.getMessage());

                       }

                    }

        
                }
            }
            catch(Exception e)
            {
            system.debug('Error'+e);
            }
        }
    }

    public string nullcheck(string check){
        if(check == null)
        return '0';
        else
        return check;
    }
    
    public String noName(String val,String type) {
      if (val == null && type == 'fname')
        return 'AOPS NFNOMX';
      else if (val == null && type == 'lname')
        return 'AOPS NLNOMX';
      else
        return val;
    }
    
    /* Finish Method*/
    global void finish(Database.BatchableContext BC){
        
            CustTransParentChildLevel__c PCLevel2 = [select Transition_Interval__c,Parent_Child_Level__c,CronID__c from CustTransParentChildLevel__c limit 1];
            integer interval = 120;
            
            if (PCLevel2.cronID__c <> null) {
              for (CronTrigger t: [SELECT Id FROM CronTrigger where ID=:PCLevel2.cronID__c])
                 system.abortJob(t.id);
            }
            
 
                if(PCLevel2.Parent_Child_Level__c=='Parent') { 
                    PCLevel2.Parent_Child_Level__c = 'Child';
                }
                else if(PCLevel2.Parent_Child_Level__c=='Child') {
                    PCLevel2.Parent_Child_Level__c = 'Parent';
                    
                    IF (PCLevel2.Transition_Interval__c != NULL)
                     interval = integer.valueof(PCLevel2.Transition_Interval__c);
                }
                    
                
            
             
            DateTime sysTime = System.now().addSeconds(interval);
            String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
    
            Load_CustTransData_Batch2 scheduledBatch = new Load_CustTransData_Batch2();
            ID cronid = System.schedule( 'Load_CustTransData_Batch2' + sysTime, chronExpression, scheduledBatch );
            
            PCLevel2.cronID__c = cronid;
            
            update PCLevel2;   

           /* if(ParentChildLevel != 'Child'){
                if(ParentChildLevel!=null && ParentChildLevel=='Parent') 
                    PCLevel.Parent_Child_Level__c = 'Child';
                else if(ParentChildLevel!=null && ParentChildLevel=='Child')
                    PCLevel.Parent_Child_Level__c = 'Parent';
                
                //Added Try catch block by Nitish
                try {
                    update PCLevel;
                }
                catch(Exception e) {
                    system.debug('Exception occured'+e);
                }
                
                sysTime = System.now().addHours(addHour);
                String chronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        
                Load_CustTransData_Batch2 scheduledBatch = new Load_CustTransData_Batch2();
                System.schedule( 'Load_CustTransData_Batch2' + sysTime, chronExpression, scheduledBatch );
                
            }*/
        
    }
    //Method to implement Schedulable Interface
    global void execute(SchedulableContext sc){
        //String strQuery = '';
        Load_CustTransData_Batch2 assignBatch = new Load_CustTransData_Batch2();
        database.executebatch(assignBatch, 1);
        
        //System.abortJob(sc.getTriggerID());
        
    }
}