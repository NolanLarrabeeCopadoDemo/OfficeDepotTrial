global class ACEComplianceVetting_Batch implements Database.Batchable<Sobject>, Schedulable
{
    global String ace_comp_query;

    public static Map<String, String> LEVEL_VALUE_MAP               = new Map<String, String> {'C' => 'Child','S' => 'Standalone','P' => 'Parent','GP' => 'Grandparent','GGP' => 'GreatGrandParent'};
    public static Map<String, String> DEPARTMENT_VALUE_MAP          = new Map<String, String> {'01' => '1','02' => '2','03' => '3','04' => '4','05' => '5','06' => '6','07' => '7','08' => '8','09' => '9'};
    public static Map<String, String> NOTIFICATION_VALUE_MAP        = new Map<String, String> {'Needs validation' => '1','Contract silent' => '1','Notification only' => '2','Notification and customer approval' => '3'};
    public static Map<String, String> PRIVATE_BRAND_VALUE_MAP       = new Map<String, String> {'Y' => 'true','N' => 'false'};
    public Map<String, Date> aops_cust_id_to_first_order_date_map   = new Map<String, Date>();
    public Map<String, String> translation_map                      = new Map<String, String>();


  
    // Default Constructor
    global ACEComplianceVetting_Batch ()
    {
      ace_comp_query=  'select id, CustomerID__c from Ace_Customer_List__c where status__c != \'Processed\'';
    }
    
    /*This costructor is called from the Batch Schedule mathod */
    global ACEComplianceVetting_Batch (String strQuery)
    {
    ace_comp_query=strQuery;
    }

    

    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(ace_comp_query);
    }

    global void execute(Database.BatchableContext BC, List<Ace_Customer_List__c> batch_query)
    {
        set<String> cids = new set<String>();
        List<Ace_Customer_List__c> custstatuslist =  new List<Ace_Customer_List__c>();
        for(Ace_Customer_List__c acl : batch_query)
         {
         cids.add(acl.CustomerID__c);
         
         }
         List<ACE_Compliance_Vetting__c> batch_query_result = [select Id, OwnerId, IsDeleted, Name,IN_Owning_Customer_ID__c,IN_Owning_Customer_Type__c,IN_Private_Brand__c,IN_SKU_Dept__c,VCC_ENGINE_CONTROL_ID__c ,XREF_REQUEST_ID__c FROM ACE_Compliance_Vetting__c WHERE OUT_Response_Completion_Date__c = null and IN_Owning_Customer_ID__c =:cids limit 2000];
         // If the size is 2000, it is probable that not all records were retrieved.
         // We will make sure that the Ace_Customer_List__c record is not set to Processed,
         // so that a future run can pick up the rest of the ACE_Compliance_Vetting__c
         // records for this customer.
         Boolean notAllVettingRecordsRetrieved = batch_query_result.size() >= 1999 ? true : false;
        
        List<ACE_Compliance_Vetting__c> compl_list_for_update   = new List<ACE_Compliance_Vetting__c>();

        Set<String> aops_customer_ids                           = new Set<String>();
        Set<String> parent_aops_customer_ids                    = new Set<String>();

        Map<String, Account> aops_cust_id_to_account_map        = new Map<String, Account>();
        Map<String, Contract_Pricing_Terms__c> pricing_map      = new Map<String, Contract_Pricing_Terms__c>();
        
        List <ACE_Compliance_Vetting__c>  abclist = new List <ACE_Compliance_Vetting__c>  ();
/*
for(ACE_Compliance_Vetting__c x :batch_query_result)
{
x.OUT_Agreement_Start_Date__c=null;
x.OUT_Cap_Amount__c=null;
x.OUT_Cap_Calculation_Base__c=null;
x.OUT_Cap_Format__c=null;
x.OUT_Cap_Scope__c=null;
x.OUT_Cap_Units__c=null;
x.OUT_Contract_Type__c=null;
x.OUT_Disco_Alt_Price_Req__c=null;
x.OUT_Error_Code__c=null;
x.OUT_Error_Message__c=null;
x.OUT_Initial_Price_Freeze_Period__c=null;
x.OUT_Owning_Customer_Annual_Sales__c=null;
x.OUT_Requirement_Window__c=null;
x.OUT_Response_Completion_Date__c=null;
x.OUT_SFDC_Contract_Obj_Cust_ID__c=null;
x.OUT_SFDC_Contract_Object_ID__c=null;
x.OUT_SFDC_Notification_Flag__c=null;
x.OUT_SKU_Add_Notif_Req__c=null;
x.OUT_SKU_Del_Notif_Req__c=null;
x.OUT_SKU_Disco_Alt_Req__c=null;
x.OUT_SKU_Disco_Cust_Notif_Req__c=null;
x.OUT_Update_Frequency__c=null;
x.OUT_Update_Timing__c=null;
x.OUT_Vendor_Letter_Required__c=null;
x.OUT_Compliance_Vetting_Contract_Number__c=null;
x.OUT_Compliance_Vetting_Customer__c=null;
x.OUT_Compliance_Vetting_Pricing_Term__c=null;
x.OUT_Effective_Date_of_this_Language__c=null;
x.OUT_First_Order_Date__c=null;
x.OUT_Grand_Parent_Hosted_Catalog__c=null;
x.OUT_Is_Cap_Lesser_Of_Two_Values__c=null;
x.OUT_Is_There_A_Cap__c=null;
x.OUT_Price_Incr_Cap_App_Level__c=null;
x.OUT_Vendor_Letter_Req_For_CC_Increase__c=null;
x.OUT_Comm_Req_CC_Price_Chg__c=null;
x.OUT_How_frequently_can_we_pass_increases__c=null;
x.OUT_In_days__c=null;
x.OUT_Calendar_period__c=null;
x.OUT_Other_calendar_period__c=null;
x.OUT_Date_1__c=null;
x.OUT_Date_2__c=null;
x.OUT_Date_3__c=null;
x.OUT_Date_4__c=null;
x.OUT_Required_Timing_Of_CC_Updates__c=null;
x.OUT_CC_Prc_Chg_Notice_Reqd_days__c=null;
x.OUT_Departments__c=null;
x.OUT_Is_there_language_stating_applicable__c=null;
x.OUT_CC_Price_Incr_Capped__c=null;
x.OUT_CC_Initial_Freeze_Period_in_days__c =null;
x.OUT_DISCO_communication_requirements__c =null;
x.OUT_Addition_communication_requirements__c =null;
x.OUT_Deletion_communication_requirements__c =null;
x.type__c = null ;
    abclist.add(x);
    
}
update abclist;
*/
        for (ACE_Compliance_Vetting__c ac :batch_query_result)
        {
         
            aops_customer_ids.add(ac.IN_Owning_Customer_ID__c);
        }

        // Create a map of values and their translation
        for (Ace_Compliance_Cross_Reference__c record :[SELECT Type__c, Source_Value__c, Destination_Value__c FROM Ace_Compliance_Cross_Reference__c])
        {
            translation_map.put(record.Type__c + record.Source_Value__c, record.Destination_Value__c);
        }

        // Get all accounts related to any of these Ace Compliance Vetting records
        // cross reference using Account.aops_cust_id__c -> ACE_Compliance_Vetting__c.IN_Owning_Customer_ID__c
        List<Account> account_hierarchy = [SELECT
                                            Id,
                                            aops_cust_id__c,
                                            parent.Id,
                                            parent.aops_cust_id__c,
                                            parent.parent.Id, 
                                            parent.parent.aops_cust_id__c,
                                            parent.parent.parent.Id,
                                            parent.parent.parent.aops_cust_id__c 
                                            FROM Account
                                            WHERE aops_cust_id__c IN :aops_customer_ids];

        // Get all the parent_aops_customer_ids related to the accounts found above
        for (Account current_account :account_hierarchy)
        {
            aops_cust_id_to_account_map.put(current_account.aops_cust_id__c, current_account);

            if (current_account.parent.aops_cust_id__c != null)
                parent_aops_customer_ids.add(current_account.parent.aops_cust_id__c);
            if (current_account.parent.parent.aops_cust_id__c != null)
                parent_aops_customer_ids.add(current_account.parent.parent.aops_cust_id__c);
            if (current_account.parent.parent.parent.aops_cust_id__c != null)
                parent_aops_customer_ids.add(current_account.parent.parent.parent.aops_cust_id__c);
        }
        
        storePricing(aops_customer_ids, pricing_map);
        storePricing(parent_aops_customer_ids, pricing_map);

        getFirstOrderDates(aops_customer_ids, aops_cust_id_to_first_order_date_map);
        getFirstOrderDates(parent_aops_customer_ids, aops_cust_id_to_first_order_date_map);

        for (ACE_Compliance_Vetting__c ac :batch_query_result)
        {
            String key                          = null;
            String key_alt                      = null;
            String key_non_private_brand        = null;
            String key_non_private_brand_alt    = null;
            Boolean level1_exists               = false;
            Boolean level2_exists               = false;
            Boolean private_brand_checked       = false;
            Boolean found_match                 = false;

            key = ac.IN_Owning_Customer_ID__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
            
            // If customer is a Child
            if (ac.IN_Owning_Customer_Type__c == 'C')
            {
                key_alt = ac.IN_Owning_Customer_ID__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get('S') + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
            }

            // If Private Brand is true ('Y')
            if ('true'.equals(PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c)))
            {
                private_brand_checked = true;
                key_non_private_brand = ac.IN_Owning_Customer_ID__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) + 'false';

                // If customer type is Child
                if (ac.IN_Owning_Customer_Type__c == 'C')
                    key_non_private_brand_alt = ac.IN_Owning_Customer_ID__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get('S') + 'false';
            }
            // If CPT and ACV are the same
            if (pricing_map.containsKey(key))
            {
                loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                found_match = true;
            }
            // If Customer Type is 'S' for CPT and 'C' for ACV
            else if (pricing_map.containsKey(key_alt) && ac.IN_Owning_Customer_Type__c == 'C')
            {
                loadComplianceData(compl_list_for_update, pricing_map.get(key_alt), ac);
                found_match = true;
            }
            // If Private Brand is 'N' for CPT and 'Y' for ACV
            else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked)
            {
                loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                found_match = true;
            }
            // If Private Brand is 'N' and Customer Type is 'S' for CPT, and Private Brand is 'Y' and Customer Type is 'C' for ACV
            else if (pricing_map.containsKey(key_non_private_brand_alt) && private_brand_checked && ac.IN_Owning_Customer_Type__c == 'C')
            {
                loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand_alt), ac);
                found_match = true;
            }
            else
            {
                if (aops_cust_id_to_account_map.containsKey(ac.IN_Owning_Customer_ID__c))
                {
                    // Parent CSF checking
                    if (aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.aops_cust_id__c != null)
                    {
                        String level1 = null;

                        if (LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) == 'Child' || LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) == 'Standalone')
                            level1 = 'Parent';
                        if (LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) == 'Parent')
                            level1 = 'Grandparent';
                        if (LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) == 'GrandParent')
                            level1 = 'GreatGrandparent';

                        // Parent CSF with child terms
                        key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.aops_cust_id__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                        key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.aops_cust_id__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) + 'false';
                                                
                        if (pricing_map.containsKey(key))
                        {
                            loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                            level1_exists = true;
                            found_match = true;
                        }
                        else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked)
                        {
                            loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                            level1_exists = true;
                            found_match = true;
                        }

                        /* NAIT-143421 - parent csf only with relevant customer level
                        if (level1 == 'Parent' && !found_match) 
                        {
                            key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.aops_cust_id__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get('S') + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                            key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.aops_cust_id__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get('S') + 'false';

                            if (pricing_map.containsKey(key))
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                                level1_exists = true;
                                found_match = true;
                            }
                            else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked)
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                                level1_exists = true;
                                found_match = true;
                            }
                        } 
                        */

                        // Parent CSF with parent terms
                        /* NAIT-143421 - parent csf only with relevant customer level
                        if (!found_match)
                        {
                            key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level1 + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                            key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level1 + 'false';

                            if (pricing_map.containsKey(key))
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                                level1_exists = true;
                                found_match = true;
                            }
                            else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked)
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                                level1_exists = true;
                                found_match = true;
                            }
                        }  */
                    }

                    //GP CSF checking
                    if (aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c != null && !level1_exists)
                    {
                        String level3 = 'GreatGrandParent';
                        String level2 = 'Grandparent';
                        String level1 = 'Parent';

                        //GP CSF with Child Terms
                        key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                        key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) + 'false';
                        
                        if (pricing_map.containsKey(key))
                        {
                            loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                            found_match = true;
                            level2_exists = true;
                        }
                        else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked)
                        {
                            loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                            found_match = true;
                            level2_exists = true;
                        }

                        //GP CSF with Parent Terms
                        /* NAIT-143421 - parent csf only with relevant customer level
                        if (!found_match)
                        {
                            key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level1 + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                            key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level1 + 'false';

                            if (pricing_map.containsKey(key)) {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                                found_match = true;
                                level2_exists = true;
                            }
                            else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked){
                                loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                                found_match = true;
                                level2_exists = true;
                            }
                        } */

                        // GP CSF with GP Terms
                        /* NAIT-143421 - parent csf only with relevant customer level
                        if (!found_match)
                        {
                            key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level2 + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                            key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level2 + 'false';

                            if (pricing_map.containsKey(key)) {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                                found_match = true;
                                level2_exists = true;
                            }
                            else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked){
                                loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                                found_match = true;
                                level2_exists = true;
                            }
                        } */

                        // GP CSF with GGP Terms
                        /* NAIT-143421 - parent csf only with relevant customer level
                        if (!found_match)
                        {
                            key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level3 + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                            key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level3 + 'false';

                            if (pricing_map.containsKey(key))
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                                found_match = true;
                                level2_exists = true;
                            }
                            else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked)
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                                found_match = true;
                                level2_exists = true;
                            }
                        } */
                    }

                    //GGP CSF checking
                    if (aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.parent.aops_cust_id__c != null && !level1_exists && !level2_exists)
                    {
                        String level3 = 'GreatGrandParent';
                        String level2 = 'Grandparent';
                        String level1 = 'Parent';

                        //GGP CSF with Child Terms
                        // NAIT-143421 - parent csf only with relevant customer level
                        //key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                        //key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) + 'false';
                        key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                        key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + LEVEL_VALUE_MAP.get(ac.IN_Owning_Customer_Type__c) + 'false';

                        if (pricing_map.containsKey(key))
                        {
                            loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                            found_match = true;
                        }
                        else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked)
                        {
                            loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                            found_match = true;
                        }

                        //GGP CSF with Parent Terms
                        /* NAIT-143421 - parent csf only with relevant customer level
                        if (!found_match)
                        {
                            key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level1 + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                            key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level1 + 'false';

                            if (pricing_map.containsKey(key))
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                                found_match = true;
                            }
                            else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked)
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                                found_match = true;
                            }
                        } */

                        //GGP CSF with GP Terms
                        /* NAIT-143421 - parent csf only with relevant customer level
                        if (!found_match)
                        {
                            key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level2 + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                            key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level2 + 'false';

                            if (pricing_map.containsKey(key))
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                                found_match = true;
                            }
                            else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked)
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                                found_match = true;
                            }
                        } */

                        //GGP CSF with GGP Terms
                        /* NAIT-143421 - parent csf only with relevant customer level
                        if (!found_match)
                        {
                            key = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level3 + PRIVATE_BRAND_VALUE_MAP.get(ac.IN_Private_Brand__c);
                            key_non_private_brand = aops_cust_id_to_account_map.get(ac.IN_Owning_Customer_ID__c).parent.parent.aops_cust_id__c + ac.IN_SKU_Dept__c + level3 + 'false';
                            
                            if (pricing_map.containsKey(key))
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key), ac);
                                found_match = true;
                            }
                            else if (pricing_map.containsKey(key_non_private_brand) && private_brand_checked)
                            {
                                loadComplianceData(compl_list_for_update, pricing_map.get(key_non_private_brand), ac);
                                found_match = true;
                            }
                        } */
                    }
                }
            }

            if (!found_match)
            {
                ACE_Compliance_Vetting__c ac_upd = new ACE_Compliance_Vetting__c();
                ac_upd = ac;
                ac_upd.OUT_Response_Completion_Date__c = Date.today();
                compl_list_for_update.add(ac_upd);
            }

            ACE_Compliance_Vetting__c ac_upd = new ACE_Compliance_Vetting__c();
            ac_upd = ac;

            //NAIT-143421 - parent csf only with relevant customer level
            //if(ac_upd.OUT_First_Order_Date__c == null)
            //    ac_upd.OUT_First_Order_Date__c = aops_cust_id_to_first_order_date_map.get(ac_upd.IN_Owning_Customer_ID__c);
            
            Integer ac_index = compl_list_for_update.indexOf(ac);
            if (ac_index != -1)
            {
                compl_list_for_update.set(ac_index, ac_upd);
            }
        }
        
        update compl_list_for_update;
        
        for(Ace_Customer_List__c acl : [select id,status__c,CustomerID__c from Ace_Customer_List__c where CustomerID__c =:cids ])
         {
             // Not all vetting records were retrieved and updated.
             // We want to ensure a future run of this job will pick
             // up the leftover records.
             if(notAllVettingRecordsRetrieved == false) {
                acl.status__c = 'Processed';
                custstatuslist.add(acl );
             }
         
         }
         update custstatuslist;
    }

    global void execute(SchedulableContext sc)
    {
        ACEComplianceVetting_Batch aceBatch = new ACEComplianceVetting_Batch();
        Database.executeBatch(aceBatch, 1000);
    }

    global void finish(Database.BatchableContext BC)
    { }

    private void loadComplianceData(List<ACE_Compliance_Vetting__c> compl_list_for_update, Contract_Pricing_Terms__c contract_pricing_terms, ACE_Compliance_Vetting__c ac)
    {
        ACE_Compliance_Vetting__c ac_upd = new ACE_Compliance_Vetting__c();
        ac_upd = ac;
        ac_upd.type__c                                      = 'Response';
        ac_upd.OUT_Cap_Amount__c                            = contract_pricing_terms.Price_Incr_Cap_Amt__c;
        ac_upd.OUT_Is_There_A_Cap__c                        = translateValues('Cap_Exist_Check', contract_pricing_terms.CC_Price_Incr_Capped__c);
        ac_upd.OUT_First_Order_Date__c                      = contract_pricing_terms.Contract__r.Account.First_Order_Date__c;
        ac_upd.OUT_Agreement_Start_Date__c                  = contract_pricing_terms.Contract__r.Effective_Date_of_Original_Contract__c;
        ac_upd.OUT_SFDC_Notification_Flag__c                = NOTIFICATION_VALUE_MAP.get(contract_pricing_terms.Comm_Req_CC_Price_Chg__c);
        ac_upd.OUT_SFDC_Contract_Object_ID__c               = contract_pricing_terms.Contract__r.Id;
        ac_upd.OUT_Response_Completion_Date__c              = Date.today();
        ac_upd.OUT_SFDC_Contract_Obj_Cust_ID__c             = contract_pricing_terms.Contract__r.Account.Id;
        //----------Start CPT fields clean up and CPT new field NAIT-116337 ----------------
        ac_upd.OUT_DISCO_communication_requirements__c      = contract_pricing_terms.DISCO_communication_requirements__c;
        ac_upd.OUT_Addition_communication_requirements__c   = NOTIFICATION_VALUE_MAP.get(contract_pricing_terms.Addition_communication_requirements__c);
        ac_upd.OUT_Deletion_communication_requirements__c   = NOTIFICATION_VALUE_MAP.get(contract_pricing_terms.Deletion_communication_requirements__c);
        //ac_upd.OUT_Is_Cap_Lesser_Of_Two_Values__c           = translateValues('Cap_Exist_Check', contract_pricing_terms.Is_there_language_stating_thatapplicable__c);
        ac_upd.OUT_Complex_cap__c                           = contract_pricing_terms.Complex_cap__c;
        //----------End CPT fields clean up and CPT new field NAIT-116337 ----------------
        ac_upd.OUT_Grand_Parent_Hosted_Catalog__c           = translateValues('GP_HostCat_Flag', String.valueof(contract_pricing_terms.Contract__r.Account.Grand_Parent_Hosted_Catalog__c));
        ac_upd.OUT_Compliance_Vetting_Customer__c           = contract_pricing_terms.Contract__r.Account.aops_cust_id__c;
        ac_upd.OUT_Compliance_Vetting_Pricing_Term__c       = contract_pricing_terms.Id;
        ac_upd.OUT_Effective_Date_of_this_Language__c       = contract_pricing_terms.Effective_Date_of_this_Language__c;
        ac_upd.OUT_Compliance_Vetting_Contract_Number__c    = contract_pricing_terms.Contract__r.ContractNumber;
        ac_upd.OUT_CC_Price_Incr_Capped__c                  = contract_pricing_terms.CC_Price_Incr_Capped__c;
        ac_upd.OUT_Vendor_Letter_Req_For_CC_Increase__c     = contract_pricing_terms.Vendor_Letter_Required_For_CC_Increase__c;
        ac_upd.OUT_Comm_Req_CC_Price_Chg__c                 = contract_pricing_terms.Comm_Req_CC_Price_Chg__c;
        ac_upd.OUT_How_frequently_can_we_pass_increases__c  = contract_pricing_terms.How_frequently_can_we_pass_increases__c;
        ac_upd.OUT_In_days__c                               = contract_pricing_terms.In_days__c;
        ac_upd.OUT_Calendar_period__c                       = contract_pricing_terms.Calendar_period__c;
        ac_upd.OUT_Other_calendar_period__c                 = contract_pricing_terms.Other_calendar_period__c;
        ac_upd.OUT_Date_1__c                                = contract_pricing_terms.Date_1__c;
        ac_upd.OUT_Date_2__c                                = contract_pricing_terms.Date_2__c;
        ac_upd.OUT_Date_3__c                                = contract_pricing_terms.Date_3__c;
        ac_upd.OUT_Date_4__c                                = contract_pricing_terms.Date_4__c;
        ac_upd.OUT_Required_Timing_Of_CC_Updates__c         = contract_pricing_terms.Required_Timing_Of_CC_Updates__c;
        ac_upd.OUT_CC_Prc_Chg_Notice_Reqd_days__c           = contract_pricing_terms.CC_Prc_Chg_Notice_Reqd_days__c;
        ac_upd.OUT_Departments__c                           = contract_pricing_terms.Departments__c;
        ac_upd.OUT_CC_Initial_Freeze_Period_in_days__c      = contract_pricing_terms.CC_Initial_Freeze_Period_in_days__c;
        //---------- CPT fields clean up 
        //ac_upd.OUT_Is_there_language_stating_applicable__c  = contract_pricing_terms.Is_there_language_stating_thatapplicable__c;
        
        //if (contract_pricing_terms.CC_Pricing_Update_Frequency_in_days__c != null)
        //    ac_upd.OUT_Update_Frequency__c              = String.valueof(contract_pricing_terms.CC_Pricing_Update_Frequency_in_days__c);
        if (contract_pricing_terms.Price_Incr_Cap_App_Level__c != null)
            ac_upd.OUT_Cap_Format__c                    = translateValues('Cap Format', contract_pricing_terms.Price_Incr_Cap_App_Level__c);
        //if (contract_pricing_terms.Price_Incr_Cap_Calc_Scope__c != null)
        //    ac_upd.OUT_Cap_Calculation_Base__c          = translateValues('Cap Calculation Base', contract_pricing_terms.Price_Incr_Cap_Calc_Scope__c);
        //if (contract_pricing_terms.Price_Incr_Cap_App_Scope__c != null)
        //    ac_upd.OUT_Cap_Scope__c                     = translateValues('Cap batch_query_result', contract_pricing_terms.Price_Incr_Cap_App_Scope__c);
        if (contract_pricing_terms.Price_Incr_Cap_Type_Unit__c != null)
            ac_upd.OUT_Cap_Units__c                     = contract_pricing_terms.Price_Incr_Cap_Type_Unit__c.substring(0, 1);
        if (contract_pricing_terms.Vendor_Letter_Required_For_CC_Increase__c != null)
            ac_upd.OUT_Vendor_Letter_Required__c        = translateValues('Vendor/OEM Letters Required', contract_pricing_terms.Vendor_Letter_Required_For_CC_Increase__c);
        if (contract_pricing_terms.CC_Initial_Freeze_Period_in_days__c != null)
            ac_upd.OUT_Initial_Price_Freeze_Period__c   = String.valueof(contract_pricing_terms.CC_Initial_Freeze_Period_in_days__c);
        if (contract_pricing_terms.CC_Prc_Chg_Notice_Reqd_days__c != null)
            ac_upd.OUT_Requirement_Window__c            = String.valueof(contract_pricing_terms.CC_Prc_Chg_Notice_Reqd_days__c);

        if (contract_pricing_terms.Required_Timing_Of_CC_Updates__c != null)
        {
            String[] timing_types = contract_pricing_terms.Required_Timing_Of_CC_Updates__c.split(';'); 
            String timing_type_translated;

            for (String c :timing_types)
            {
                if (timing_type_translated == null)
                    timing_type_translated = translateValues('Update Timing', c);
                else
                    timing_type_translated += ';' + translateValues('Update Timing', c);
            }
            ac_upd.OUT_Update_Timing__c = timing_type_translated;
        }

        /*
        Multiple contract types can be stored in one field, separated by a semicolon.

        For example: ALL PRODUCTS;CBS;MPS;CPD-PRINT;
        
        This piece of code below separates that whole field's value by the semicolon (;).
        Then, it translates each one of those values by checking what the Destination_Value__c is
        on the Ace_Compliance_Cross_Reference__c object where the Type__c + Source_Value__c is
        'Contract Type' + [one of the values that was separated].
        
        For example: The Destination_Value__C for 'Contract TypeALLPRODUCTS' is '1'
        */
        if (contract_pricing_terms.Contract__r.contract_type__c != null)
        {
            String[] contract_types = contract_pricing_terms.Contract__r.contract_type__c.split(';'); 
            String contract_type_translated;

            for (String c :contract_types)
            {
            if (contract_type_translated == null)
                contract_type_translated = translateValues('Contract Type', c);
            else
                contract_type_translated += ';' + translateValues('Contract Type', c);
            }
            ac_upd.OUT_Contract_Type__c = contract_type_translated;
        }

        compl_list_for_update.add(ac_upd);
    }

    private void storePricing(Set<String> records, Map<String, Contract_Pricing_Terms__c> pricing_map)
    {
        // Get all contract pricing terms that are Active,
        // whose account AOPS_Cust_Id__c is in the 'records' argument
        // and whose Contract is 'Active' or 'Pending', and Primary
        List<Contract_Pricing_Terms__c> cpTerms = [SELECT Comm_Req_CC_Price_Chg__c, 
                                                    Required_Timing_Of_CC_Updates__c, 
                                                    CC_Prc_Chg_Notice_Reqd_days__c, 
                                                    //CC_Pricing_Update_Frequency_in_days__c, 
                                                    Price_Incr_Cap_App_Level__c, 
                                                    //Price_Incr_Cap_Calc_Scope__c, 
                                                    //Price_Incr_Cap_App_Scope__c, 
                                                    Price_Incr_Cap_Amt__c, 
                                                    Price_Incr_Cap_Type_Unit__c, 
                                                    Vendor_Letter_Required_For_CC_Increase__c, 
                                                    Relevant_Customer_Level__c, 
                                                    CC_Initial_Freeze_Period_in_days__c, 
                                                    Departments__c, 
                                                    private_brand__c, 
                                                    CC_Price_Incr_Capped__c,
                                                    //Is_there_language_stating_thatapplicable__c, 
                                                    Effective_Date_of_this_Language__c,
                                                    How_frequently_can_we_pass_increases__c,
                                                    In_days__c,
                                                    Calendar_period__c,
                                                    Other_calendar_period__c,
                                                    Date_1__c, Date_2__c, Date_3__c, Date_4__c,
                                                    Contract__r.Id, 
                                                    Contract__r.Account.Id,
                                                    Contract__r.contract_type__c, 
                                                    Contract__r.ContractNumber, Id,
                                                    Contract__r.Account.aops_cust_id__c, 
                                                    Contract__r.Account.First_Order_Date__c, 
                                                    Contract__r.Account.Grand_Parent_Hosted_Catalog__c,
                                                    Contract__r.Effective_Date_of_Original_Contract__c,
                                                    DISCO_communication_requirements__c,
                                                    Addition_communication_requirements__c,
                                                    Deletion_communication_requirements__c,
                                                    Complex_cap__c
                                                    FROM Contract_Pricing_Terms__c
                                                    WHERE Contract__r.Account.aops_cust_id__c = :records
                                                    //AND Active__c = true
                                                    AND (Contract__r.Contract_Status__c = 'Active'
                                                    OR Contract__r.Contract_Status__c = 'Pending')
                                                    AND Contract__r.Primary__c = true
                                                    ORDER BY Contract__r.Effective_Date_of_Original_Contract__c asc];
        
        // Put an entry into the pricing map for each individual department
        String deptCode;
        for (Contract_Pricing_Terms__c c :cpTerms)
        {
            String[] department_array;
            if (!String.isBlank(c.Departments__c))
            {
                department_array = c.Departments__c.split(';');
                for (String d : department_array)
                {
                    deptCode = null;
                    String[] dept_code = d.split(' - ');
                    if (dept_code.size() > 0)
                    {
                        if (DEPARTMENT_VALUE_MAP.containsKey(dept_code[0]))
                            deptCode = DEPARTMENT_VALUE_MAP.get(dept_code[0]);
                        else
                            deptCode = dept_code[0];
                        
                        pricing_map.put(c.Contract__r.Account.aops_cust_id__c + deptCode + c.Relevant_Customer_Level__c + c.private_brand__c, c);
                    }
                }
            }
        }
    }

    //To collect First_Order_Date__c for each vetting customer irrespective of contract existed or not
    private void getFirstOrderDates(Set<String> aopsCustomerIds, Map<String, Date> aops_cust_id_to_first_order_date_map)
    {
        List<Account> accountsWithAOPSId = [SELECT Id,
                                            aops_cust_id__c,
                                            First_Order_Date__c 
                                            FROM Account
                                            WHERE aops_cust_id__c IN :aopsCustomerIds];
        for (Account current_account :accountsWithAOPSId)
        {
            aops_cust_id_to_first_order_date_map.put(current_account.aops_cust_id__c, current_account.First_Order_Date__c);
        }
    }

    public String translateValues(String iType, String iValue)
    {
        if (translation_map.containsKey(iType + iValue))
            return translation_map.get(iType + iValue);
        else
            return iValue;
    }
}