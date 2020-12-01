/*************************************************************
*Name : ContractHistoryCompareController
*Created By : Sandesh Ganjare
*Created Date :
*Purpose : CSF - Contract Audit History - Ability to Compare fields
*JIRA: NAIT-124929
****************************************************************/
public with sharing class ContractHistoryCompareController {
    public ContractHistoryCompareController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<ContractHistory__c> getContractHistoryList(String Id) {
        return [
            SELECT Id, Name, LastModifiedDate, LastModifiedBy.Name
            FROM ContractHistory__c
            WHERE Contract__c =: Id
            //WITH SECURITY_ENFORCED
            LIMIT 50000
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<ContractHistoryWrapper> getContractHistoryCompareData(String version1, String version2, String contractId, Boolean changed,String fields){
        System.debug('fields=>'+fields);    
        List<String> lstFields = (List<String>)JSON.deserialize(fields, List<String>.class);
        lstFields.add('LastModifiedDate');
        System.debug('lstFields=>'+lstFields.size());
        String fields1 = '';
        if(!lstFields.isEmpty()){
            for(integer j=0;j<lstFields.size()-1;j++){
                fields1 = fields1+ lstFields[j]+',';
            }
            
        }
        fields1 = fields1 + lstFields[lstFields.size()-1];
       
        List<Contract> lstContract = Database.query('SELECT Id, Name, LastModifiedBy.Name, '+fields1+' FROM Contract WHERE Id=\''+contractId+'\'');                                                                                                                 
        List<ContractHistory__c> lstContractHistory = Database.query('SELECT Id, Name, LastModifiedBy.Name, '+fields1+' FROM ContractHistory__c WHERE Name=\''+version1+'\' OR Name=\''+version2+'\''); 
        //List<ContractHistory__c> lstContractHistory = [SELECT Id, Name, Contract_Status__c, Contract_Type__c, Contract_Term__c, Core_of_annual_volume__c  FROM ContractHistory__c WHERE Name='00014539' OR Name='00014540'];
        
        ContractHistory__c ContractHistory1 = new ContractHistory__c();
        ContractHistory__c ContractHistory2 = new ContractHistory__c();
        Contract Contract = new Contract();
        List<ContractHistoryWrapper> lstchw = new List<ContractHistoryWrapper>();
        ContractHistoryWrapper chw0 = new ContractHistoryWrapper();
        chw0.id=500;
        chw0.fieldname='LastModifiedBy';
        chw0.name='LastModifiedBy';
        if(!lstContractHistory.isEmpty() && lstContractHistory.size() > 0){  
            if(version1 == 'current' || version2 == 'current'){
                if(version1 == 'current'){
                    Contract =  lstContract[0];
                    ContractHistory2 =  lstContractHistory[0];
                    chw0.version1= lstContract[0].LastModifiedBy.Name;
                    chw0.version2= lstContractHistory[0].LastModifiedBy.Name;
                }else if(version2 == 'current'){
                    Contract =  lstContract[0];
                    ContractHistory1 =  lstContractHistory[0];
                    chw0.version2 = lstContract[0].LastModifiedBy.Name;
                    chw0.version1 = lstContractHistory[0].LastModifiedBy.Name;
                }

            }else{
                if(lstContractHistory[0].Name == version1){
                    ContractHistory1 =  lstContractHistory[0];
                    ContractHistory2 =  lstContractHistory[1];
                    chw0.version1= lstContractHistory[0].LastModifiedBy.Name;
                    chw0.version2= lstContractHistory[1].LastModifiedBy.Name;
    
                }else{
                    ContractHistory1 =  lstContractHistory[1];
                    ContractHistory2 =  lstContractHistory[0];
                    chw0.version1= lstContractHistory[1].LastModifiedBy.Name;
                    chw0.version2= lstContractHistory[0].LastModifiedBy.Name;
                }
            }                      
        }        

        map<string, string> fieldMap = new map<string, string>();  
        map<string,SObjectField> fList = schema.getGlobalDescribe().get('Contract').getDescribe().fields.getMap();
        for(string str: fList.keySet()){
            fieldMap.put(str, fList.get(str).getDescribe().getLabel());                
        }

        lstchw.add(chw0);
        for(integer i=0;i<lstFields.size();i++){
            ContractHistoryWrapper chw = new ContractHistoryWrapper();
            chw.id = i;
            chw.name = lstFields[i];
            if(lstFields[i] == 'LastModifiedDate'){
                chw.fieldname ='LastModifiedDate';
            }else{
                chw.fieldname = fieldMap.get(lstFields[i]);
            }            
            System.debug('fieldMap=>'+ fieldMap.get(lstFields[i]));
            if(version1 == 'current' || version2 == 'current'){
                if(version1 == 'current'){
                    chw.version1 =  String.ValueOf(Contract.get(lstFields[i]));
                    chw.version2 =  String.ValueOf(ContractHistory2.get(lstFields[i]));

                }else if( version2 == 'current'){
                    chw.version1 =  String.ValueOf(ContractHistory1.get(lstFields[i]));
                    chw.version2 =  String.ValueOf(Contract.get(lstFields[i]));
                }
            }else{
                chw.version1 =  String.ValueOf(ContractHistory1.get(lstFields[i]));
                chw.version2 =  String.ValueOf(ContractHistory2.get(lstFields[i]));
            }
            
            System.debug('chw=>'+chw);
            System.debug('chw.version1=>'+chw.version1);
            System.debug('chw.version2=>'+chw.version2);
            System.debug('changed=>'+changed);
            if(changed){
                if(chw.version1 != chw.version2){
                    lstchw.add(chw);
                }  
            }else{
                lstchw.add(chw);
           }
                      
        }
        System.debug('lstchw=>'+lstchw);
        return lstchw;
    }
    
    public class ContractHistoryWrapper{
        @AuraEnabled
        public integer id;       
        @AuraEnabled
        public String fieldname;
        @AuraEnabled
        public String name;
        @AuraEnabled
        public String version1;
        @AuraEnabled
        public String version2;
    }
    @AuraEnabled(cacheable=true)
    public static map<string, string> getContractFieldsData(){
        //Skiping these fields are not present on the contarct object to compare
        List<String> skipFieldList = new List<String>{
        'anniversary_date__c',
        'bid_outcome__c',
        'cdm_emp_id__c',
        'clm_emp_id__c',
        'csf_emp_id__c',
        'custom_non_core_catalog__c',
        'execution_uploader__c',
        'gp_annual_spend_requirement__c',
        'name_of_tier_1_partner__c',
        'execution_upload_email_date__c',
        'name__c',
        'contract_number__c',
        'account__c',
        'executed_uploader__c',
        'notification_time_for_disco_items__c',
        'contract__c',
        'child_annual_spend_requirement__c',
        'core_spend_volume_threshold_for_pricing__c',
        'cost_language_included_in_agreement__c',
        'csf_review_date__c',
        'agreement_respon_based_on_cat_prod_assor__c',   
        'apply_child_core_written_agree_lang__c',
        'apply_parent_cust_core_agreement_lang__c',
        'aprimo_id__c',    
        'are_there_child_sku_count_limits__c',   
        'are_there_parent_sku_count_limitations__c',  
        'are_there_standalone_sku_count_limit__c',    
        'catalog_product_assortment__c',       
        'child_account_name__c',
        'child_account_number__c',
        'child_annual_spend_description__c',       
        'child_annual_spend_requirement_amount__c',
        'child_bid_agreement_number__c',
        'child_core_have_capped_price_increase__c',
        'child_core_list_capped_price_increase__c',
        'child_core_sku_level_capped_price_incr__c',
        'child_cust_core_update_notice_type__c',
        'child_cust_core_upd_notice_period__c',
        'child_cust_core_upd_notice_period_other__c',
        'child_custom_core_discount_basis__c',
        'child_custom_core_discount_percent__c',
        'child_decr_req_to_be_applied_to_cus_core__c',
        'child_floor_structure_description__c',
        'child_man_ven_letter_req_for_increase__c',
        'child_pricing_update_frequency__c',
        'child_pricing_update_frequency_other__c',
        'child_sku_cap_dollar_amount__c',
        'child_sku_cap_percent_amount__c',
        'child_sku_count_limitation__c',   
        'contract_extension_authorization_type__c',
        'contract_term__c',
        'current_legacy_max_agreement__c',
        'cust_notif_to_change_pricing_on_gp_core__c',
        'cust_notif_to_change_pricingon_standalon__c',
        'cust_notif_to_chg_pricing_on_child_core__c',
        'cust_notif_to_chg_pricing_on_par_core__c',
        'is_notification_required_to_delete_a_cus__c',
        'custom_core_written_agreement_language__c',
        'customer_type__c',
        'date_original_contract_signed__c',
        'describe_noncore_cat_structure__c',
        'describe_number_of_amendments__c',
        'notification_time_disco_items_other__c',
        'does_the_contract_include_odp_subsidiari__c',
        'duration_of_each_extension__c',
        'effective_date_of_current_amendment__c',
        'executed_amendments__c',
        'floor_for_offcontract_structure__c',
        'floors_permitted_in_child_cust_core__c',
        'floors_permitted_in_gp_cust_core__c',
        'floors_permitted_in_offcontr_whlsler_str__c',
        'floors_permitted_in_par_cust_core_list__c',
        'floors_permitted_in_standalone_cust_core__c',
        'flrs_permitted_in_cust_noncore_cat_struc__c',
        'gp_annual_spend_description__c',
        'gp_annual_spend_requirement_amount__c',
        'gp_bid_agreement_number__c',
        'gp_core_list_capped_price_increase__c',
        'gp_core_list_have_capped_price_increase__c',
        'gp_core_list_sku_capped_price_increase__c',
        'gp_cost_plus_language__c',
        'gp_cus_core_list_upd_notice_period_other__c',
        'gp_cus_core_list_update_notice_period__c',	
        'gp_cust_core_list_update_notice_type__c',
        'gp_custom_core_discount_basis__c',
        'gp_custom_core_discount_percent__c',
        'gp_decr_req_to_be_applied_to_cust_core__c',
        'gp_floor_specified_in_contract__c',
        'gp_floor_structure_description__c',
        'gp_manufac_vendor_letter_req_for_increas__c',
        'gp_pricing_update_frequency__c',
        'gp_pricing_update_frequency_other__c',
        'gp_sku_cap_dollar_amount__c',
        'gp_sku_cap_percent_amount__c',
        'grandparent_name__c',
        'grandparent_number__c',
        'have_amendment_s_been_executed__c',
        'is_there_a_point_of_sale_discount__c',
        'item_count_limit__c',
        'manuf_vendor_letter_requiried_for_increa__c',
        'marketing_direct_mail_status__c',
        'marketing_email_status__c',
        'marketing_phone_status__c',
        'marketing_status__c',
        'minimum_annual_spend_commitment_amount__c',
        'multi_country_agreement__c',
        'non_core_catalog_update_frequency_other__c',
        'noncore_cat_update_acceptance_process__c',
        'noncore_catalog_update_notice_type__c',
        'notification_process_for_disco_items__c',
        'number_of_extensions__c',
        'od_adjust_cust_prcing_if_spend_not_met__c',
        'offcontract_pricing_structure__c',
        /*'office_depot_signatory__c',*/
        'org__c',
        'original_expiration_date__c',
        'other_contract_terms_description__c',
        'other_extension_duration__c',
        'other_extension_number__c',
        'par_annual_spend_requirement_amount__c',
        'par_core_have_capped_price_increase__c',
        'par_core_list_capped_price_increase__c',
        'par_core_sku_level_capped_price_incr__c',
        'par_cus_core_list_upd_notice_per_other__c',
        'par_cust_core_list_update_notice_period__c',
        'par_cust_core_list_update_notice_type__c',
        'par_sku_cap_dollar_amount__c',
        'par_sku_cap_percent_amount__c',
        'parent_account_name__c',
        'parent_account_number__c',
        'parent_annual_spend_description__c',
        'parent_annual_spend_requirement__c',
        'parent_bid_agreement_number__c',
        'parent_custom_core_discount_basis__c',
        'parent_custom_core_discount_percent__c',
        'parent_decr_req_applied_to_cust_core__c',
        'parent_floor_structure_description__c',
        'parent_man_vendor_letter_req_for_increas__c',
        'parent_pricing_update_frequency__c',
        'parent_pricing_update_frequency_other__c',
        'parent_sku_count_limitation__c',
        'payment_term_other__c',
        'penalties_for_not_meeting_perf_notifi_re__c',
        'performance_notification_req_in_contract__c',
        'performance_notification_requirements__c',
        'price_decrease_language__c',
        'price_requirements_for_added_or_alternat__c',
        /*'pricing_analyst__c',*/
        /*'pricing_analyst_email__c',*/
        'pricing_summary__c',
        'prospect_account_name__c',
        'prospect_account_number__c',
        'provide_cost_language_in_agreement__c',
        'renewal_pending__c',
        /*'requester_s_manager__c',*/
        /*'requster_s_manager_email__c',*/
        'stand_alone_account_name__c',
        'stand_alone_account_number__c',
        'stand_alone_bid_agreement_number__c',
        'standaloncore_list_capped_price_increase__c',
        'standalone_annual_spend_description__c',
        'standalone_annual_spend_requirement_amt__c',
        'standalone_annual_spend_requirement__c',
        'standalone_core_list_have_capped_price__c',
        'standalone_core_list_sku_capped_price__c','standalone_core_list_upd_notice_period__c',
        'standalone_cust_core_list_update_notice__c',
        'standalone_custom_core_discount_basis__c',
        'standalone_custom_core_discount_percent__c',
        'standalone_custom_core_written_agreement__c',
        'standalone_floor_structure_description__c',
        'standalone_manufac_vendor_letter_req__c',
        'standalone_pricing_update_frequency__c',
        'standalone_pricing_update_frequencyother__c',
        'standalone_sku_cap_amount__c',
        'standalone_sku_count_limitation__c',
        'standalonecore_list_update_notice_period__c',
        'standalonedecr_req_to_be_applied_to_cust__c',
        'tech_depot_account_name__c',
        'tech_depot_account_number__c',
        'testmarketing_status__c',
        'tier_1_fees_paid__c',
        'what_type_of_customer_communication_is_r__c',
        'user_who_verified_data__c',
        'verified_date_time__c',
        /*'vp_admin_signature__c',*/
        'wapo_mark_up_percent__c',
        'what_of_spend_dollar__c',
        'what_of_spend__c',
        'action_requirements_for_deleted_or_disco__c',
        'what_countries_are_covered__c',
        'what_floor_permitted_on_cust_noncore_cat__c',
        'wholesaler_lang_in_agreement__c',
        'wholesaler_pricing_structure__c',
        /*'wrf_support_number1__c',*/
        'written_agreement_allow_child_cust_cores__c',
        'written_agreement_allow_parent_cust_core__c',
        'written_agreement_allow_standalone__c',
        'wholesaler_pricing_specified_in_contract__c',
        'account_extension_name__c',
        'account_org__c',
        'aops_cust_id__c',
        'contract_admin__c',
        /*'contract_cost__c',*/
        'contract_extension_authorization_type__c',
        'cust_notif_to_chg_cust_noncore_cat_prcin__c',
        'customer_type__c',
        'decreases_to_cust_non_core_non_catalog__c',
        'describe_number_of_amendments__c',
        'duration_of_each_extension__c',
        'effective_date_of_current_amendment__c',
        'executed_amendments__c',
        'executed_upload_email_date__c',
        'have_amendment_s_been_executed__c',
        'last_audit_change__c',
        'multi_country_agreement__c',
        'noncore_cat_update_notice_period__c',
        'noncore_cat_update_notice_period_other__c',
        'number_of_extensions__c',
        /*'od_signer_email__c',*/
        'other_extension_duration__c',
        'other_extension_number__c',
        /*'sales_rep_am__c',*/
        /*'sales_rep_am_email__c',*/
        'vp_admin__c'
        /*'vp_admin_signature_email__c'*/};
        map<string, string> fieldList = new map<string, string>();       
        map<string,SObjectField> fList = schema.getGlobalDescribe().get('ContractHistory__c').getDescribe().fields.getMap();
        for(string str: fList.keySet()){
            System.debug('field:'+str+' =>'+skipFieldList.contains(str));
            if(!skipFieldList.contains(str) && fList.get(str).getDescribe().isCustom()){ //
                fieldList.put(str, fList.get(str).getDescribe().getLabel());
            }                            
        }        
        return fieldList;
    }
}