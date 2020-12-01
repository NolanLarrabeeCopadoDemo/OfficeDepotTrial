/************************************************************
Created by: Wipro Technologies
Start Date:25 April 2013
Desc:The class is used in SpringCMContract2 Visualforce Page for:
1.Create and Edit of a contract in the system.
2.To Save the Contract at Tab Level.
3.To Notify the User once the Tab is saved, by a Pop-up message.
4.To Alert the user of any Unsaved Changes when he switches the tabs.
5.To redirect the User to Account Page on click of Cancel button.

LSLEVIN 5.7.2015    Modified    S-309031
LSLEVIN 5.11.2015   Modified    S-309038
LSLEVIN 5.12.2014   Modified    S-309032  
LSLEVIN 5.12.2015   Modified    S-309030
LSLEVIN 5.13.2015   Modified    S-309036
JGUPTA 5.21.2015    Modified    S-309029
CFLYNN 6.30.2015    Modified    C-125363
NSHARP 7.14.2015    Modified    S-334902
NSHARP 8.12.2015    Modified    Case 00130611
*************************************************************/

public class springcmContract2{
    
    
    /***** Declaration of Variables starts here *****/
    public Account accnt {get;set;}
    public Contract newcontr {get;set;}
    public ID AccountID;
    
   
   
    //// Booleans for Details Tab Rendering fields
    public boolean details_techdepot_grid_display {get;set;}
    public boolean details_standalone_grid_display {get;set;}
    public boolean details_other_grid_display {get;set;}
    public boolean details_grandparent_grid_display {get;set;}
    public boolean details_parent_grid_display {get;set;}
    public boolean details_child_grid_display {get;set;}
    public boolean details_DataVerified_grid_display {get;set;} // Added as per Sprint 13 Case# 75108
    //LSLEVIN 5.7.2015 S-309031 Added below line
    public boolean renewal_Pending_grid_display {get;set;}
    //LSLEVIN 5.12.2015 - S-309032 Start
    public boolean other_Contract_Descrip_grid_display {get;set;}
    public boolean small_Order_Fee_grid_display {get;set;}
    public boolean furniture_Delivery_Fee_grid_display {get;set;}
    public boolean exess_Dimension_Fee_grid_display {get;set;}
    public boolean restocking_Fee_Language_grid_display {get;set;}
    public boolean minimum_Order_Value_grid_display {get;set;}
    //LSLEVIN 5.12.2015 - S-309032 Stop
    //LSLEVIN 5.12.2015 - S-309030 Added Below Line
    public List<ContractHistory> contractActivityHistory {get;set;}
    //// Booleans for Legal Tab Rendering fields
    public boolean legal_pos_display {get;set;}
    public boolean legal_amendment_display {get;set;}
    public boolean legal_fav_lang_display {get;set;}
    public boolean legal_cat_product_display {get;set;}
    public boolean legal_cont_prov_display {get;set;}
    public boolean legal_performance_display {get;set;}
    public boolean legal_country_cov_display {get;set;}
    public boolean Minority_Requirements_display {get;set;}
    //// Booleans for Pricing Tab Rendering fields
    public boolean Written_Agreement_allow_GP_Custom_Cores_Display {get;set;}
    public boolean Written_Agreement_allow_Parent_Cust_Core_Display {get;set;}
    public boolean Written_Agreement_allow_Child_Cust_Cores_Display {get;set;}
    public boolean Cust_Notif_to_change_Pricing_on_GP_Core_Display {get;set;}
    public boolean GP_Core_List_have_Capped_Price_Increase_Display {get;set;}
    public boolean GP_Core_List_Capped_Price_Increase_Display {get;set;}
    public boolean GP_Core_List_SKU_Capped_Price_Increase_Display {get;set;}
    public boolean GP_Core_List_SKU_Capped_Price_Increase_per_Display {get;set;}
    public boolean Are_there_GP_SKU_Count_Limitations_Display {get;set;}
    public boolean GP_Annual_Spend_Requirement_Display {get;set;}
    public boolean GP_Custom_Core_Discount_Basis_Display {get;set;}
    public boolean Floors_permitted_in_GP_Cust_Core_Display {get;set;}
    /*LSLEVIN S-309036 5.13.2015 Start*/
    public boolean Pricing_Call_Out_AutoSub_Language_Display {get;set;}
    public boolean Pricing_Call_Out_CostPlus_FloorType_Display {get;set;}
    public boolean Proprietry_Items_Display {get;set;}
    public boolean Vendor_Funded_Language_Display {get;set;}
    public boolean Vendor_Funded_Language_No_Display {get;set;}
    public boolean Minimum_Annual_Spend_Threshold_Display {get;set;}
    /*LSLEVIN S-309036 5.13.2015 Stop*/
    //Added on 16th July
    public boolean Written_Agreement_allow_Standalone_Custom_Cores_Display {get;set;}
    public boolean Cust_Notif_to_change_Pricing_on_Standalone_Core_Display {get;set;}
    public boolean Standalone_Core_List_have_Capped_Price_Increase_Display {get;set;}
    public boolean Standalone_Core_List_Capped_Price_Increase_Display {get;set;}
    public boolean Standalone_Core_List_SKU_Capped_Price_Increase_Display {get;set;}
    public boolean Standalone_Core_List_SKU_Capped_Price_Increase_per_Display {get;set;}
    public boolean Are_there_Standalone_SKU_Count_Limitations_Display {get;set;}
    public boolean Standalone_Annual_Spend_Requirement_Display {get;set;}
    public boolean Standalone_Custom_Core_Discount_Basis_Display {get;set;}
    public boolean Floors_permitted_in_Standalone_Cust_Core_Display {get;set;}
    public boolean Standalone_Cus_Core_List_Update_Notice_Period_Display{get;set;}
    public boolean Standalone_Pricing_Update_Frequency_display{get;set;}
    public boolean Standalone_Pricing_Update_Frequency_grid{get;set;}
    public boolean Core_Spend_Volume_Threshold_for_Pricing{get;set;}
    public boolean Agreement_provide_disco_on_spec{get;set;}
    public boolean GP_Cost_Plus_Language_Display{get;set;}
    public boolean Price_Decrease_Language_Display{get;set;}
    public boolean NonCore_Catalog_Update_Frequency_Display{get;set;}
    //Added By Vipul Jain for Story#S-457176 (00899739 - Tier 1: Story 20 Account-Level CSF Changes) on December 30,2016
    public boolean Work_with_2_or_3_party_agreement{get;set;}
    public boolean Work_with_documentation_required{get;set;}
    public boolean Work_with_desktop_delivery{get;set;}
    public boolean Work_with_annual_volume{get;set;}
    //End -Vipul
    public boolean Cust_Notif_to_chg_Pricing_on_Par_Core_Display {get;set;}
    public boolean Par_Core_have_Capped_Price_Increase_Display {get;set;}
    public boolean Par_Core_List_Capped_Price_Increase_Display {get;set;}
    public boolean Are_there_Parent_SKU_Count_Limitations_Display {get;set;}
    public boolean Parent_Annual_Spend_Requirement_Display {get;set;}
    public boolean Parent_Custom_Core_Discount_Basis_Display {get;set;}
    public boolean Floors_permitted_in_Par_Cust_Core_List_Display {get;set;}
    public boolean Cust_Notif_to_chg_Pricing_on_Child_Core_Display {get;set;}
    public boolean Child_Core_have_Capped_Price_Increase_Display {get;set;}
    public boolean Child_Core_List_Capped_Price_Increase_Display {get;set;}
    public boolean Are_there_Child_SKU_Count_Limits_Display {get;set;}
    public boolean Child_Annual_Spend_Requirement_Display {get;set;}
    public boolean Child_Custom_Core_Discount_Basis_Display {get;set;}
    public boolean Floors_permitted_in_Child_Cust_Core_Display {get;set;}
    public boolean Par_Core_SKU_Level_Capped_Price_Incr_Display {get;set;}
    public boolean Par_Core_SKU_Level_Capped_Price_Incr_per_Display {get;set;}
    public boolean Child_Core_SKU_Level_Capped_Price_Incr_per_Display {get;set;}
    public boolean Child_Core_SKU_Level_Capped_Price_Incr_Display {get;set;}
    public boolean Notification_process_for_disco_items_Display {get;set;}
    public boolean Notification_time_for_disco_items_Display {get;set;}
    public boolean GP_Cus_Core_List_Update_Notice_Period_Display {get;set;}
    public boolean Par_Cust_Core_List_Update_Notice_Period_Display {get;set;}
    public boolean Child_Cust_Core_Upd_Notice_Period_Display {get;set;}
    public boolean GP_Pricing_Update_Frequency_display{get;set;}
    public boolean Parent_Pricing_Update_Frequency_Display{get;set;}
    public boolean Child_Pricing_Update_Frequency_Display{get;set;}
    public boolean Custom_Non_Core_Catalog_Display {get;set;}
    public boolean Flrs_permitted_in_Cust_NonCore_Cat_struc_Display {get;set;}
    public boolean Custom_Non_Core_Catalog_Discount_Basis_Display {get;set;}
    public boolean Cust_notif_to_chg_Cust_NonCore_Cat_Prcin_Display {get;set;}
    public boolean NonCore_Cat_Update_Notice_Period_Display {get;set;}
    public boolean Floors_permitted_in_OffContr_Whlsler_str_Display {get;set;}
    public boolean OffContract_Pricing_specified_in_contrac_Display {get;set;}
    public boolean Wholesaler_Pricing_specified_in_contract_Display {get;set;}
    public boolean GP_Floor_specified_in_contract_Display {get;set;}
    public boolean Cost_Language_included_in_agreement_Display {get;set;}
    public boolean Work_with_Tier_1_partner_on_this_account_Display {get;set;}
    public boolean Work_with_is_this_a_20_or_3_agreement {get;set;}
    public boolean Deviated_Pricing_offered_to_Customer_Display {get;set;}
    public boolean Minimum_Annual_Spend_Commitment_Display {get;set;}
    public boolean display_springcm_contract {get;set;}
    public boolean display_crud {get;set;}
    //// Booleans for Rebates Tab Rendering fields
    public boolean rebates_incentive_grid_display {get;set;}
    public boolean rebates_penalties_grid_display {get;set;}
    //// Booleans for Reporting Tab Rendering fields
    public boolean reporting_requirement_grid_display {get;set;}
    public boolean reporting_requirement_grid_display2 {get;set;}
    public boolean reporting_freq_other_grid_display {get;set;}
    public boolean Is_there_a_custom_NCC_display {get;set;}
    public boolean Reporting_penalties_grid_display {get;set;}
    
    public boolean Is_this_a_renewal_Display {get;set;}
    //02217136 
    public boolean Other_Contract_Type {get;set;}
    //02217136
    //public String Refer_to_Prior_CSF__c ;
    //public String Is_this_a_renewal__c;
    
    /////// Declaration of list variables for Removing --None-- Value from the Picklist starts here
    public List<SelectOption> statusOptions {get;set;}
    public List<SelectOption> statusOptions1 {get;set;}
    public List<SelectOption> statusOptions3 {get;set;}
    public List<SelectOption> statusOptions4 {get;set;}
    public List<SelectOption> statusOptions5 {get;set;}
    public List<SelectOption> statusOptions6 {get;set;}
    public List<SelectOption> statusOptions7 {get;set;}
    public List<SelectOption> statusOptions8 {get;set;}
    public List<SelectOption> statusOptions9 {get;set;}
    public List<SelectOption> statusOptions10 {get;set;}
    public List<SelectOption> statusOptions11 {get;set;}
    public List<SelectOption> statusOptions12 {get;set;}
    public List<SelectOption> statusOptions13 {get;set;}
    public List<SelectOption> statusOptions14 {get;set;}
    public List<SelectOption> statusOptions15 {get;set;}
    public List<SelectOption> statusOptions16 {get;set;}
    public List<SelectOption> statusOptions17 {get;set;}
    public List<SelectOption> statusOptions18 {get;set;}
    public List<SelectOption> statusOptions19 {get;set;}
    public List<SelectOption> statusOptions20 {get;set;}
    public List<SelectOption> statusOptions21 {get;set;}
    public List<SelectOption> statusOptions22 {get;set;}
    public List<SelectOption> statusOptions23 {get;set;}
    public List<SelectOption> statusOptions24 {get;set;}
    public List<SelectOption> statusOptions25 {get;set;}
    public List<SelectOption> statusOptions26 {get;set;}
    public List<SelectOption> statusOptions28 {get;set;}
    public List<SelectOption> statusOptions29 {get;set;}
    public List<SelectOption> statusOptions27 {get;set;}
    public List<SelectOption> statusOptions30 {get;set;}
    public List<SelectOption> statusOptions32 {get;set;}
    public List<SelectOption> statusOptions33 {get;set;}
    public List<SelectOption> statusOptions34 {get;set;}
    
    // Added as per Sprint 13 Case# 75108
    /////// Declaration of list variables for Removing --None-- Value from the Picklist ends here
    public String ActiveTab {get; set;} // To get the Tab which the User is currently on
    public string legal_contract {get;set;}
    public String callfunc{get;set;} // To call the java function on succesful save of tab
    public String contractvalue{get;set;} // To Call the Id of contract after the page reloads on save
    public String activetabvalue{get;set;} // To Call the Active Tab after the page reloads on save
    public boolean Enable_Details_Tab{get;set;} // Boolean set to enable all the Tabs on an existing contract
    public boolean Account_Label{get;set;} // Boolean set to enable the Account Label and Cust Id on an contract directed from Account related list
    public boolean rendering_display{get;set;}
    public boolean List_readonly{get;set;}
    public boolean newaccdisplay{get;set;} // Boolean set to display the field of Account if redirected from Contract Tab
    public boolean display{get;set;} // Boolean set to display the panel of Account Label and Cust Id
    public boolean cntrdeletepermission{get;set;}
    Contract newcontract_alias= new Contract();
    /***** Declaration of Variables ends here *****/
    ID contract_id_alias = ApexPages.currentPage().getParameters().get('id');
    
    //deepak changes starts
    public boolean contract_extension_display {get;set;}
    public boolean catalog_assortment_display {get;set;}
    public boolean contract_extension_authorization_display {get;set;}
    public boolean other_extension_display {get;set;}
    public boolean other_duration_display {get;set;}
    public boolean rebates_clawback_grid_display {get;set;}
    public boolean payment_term_other_display {get;set;}
    //deepak changes ends
    public boolean marketing_substatuses_grid_display {get;set;}
    
    public List<Contract_Pricing_Terms__c> RelatedList_PricingTerms{get;set;}
    //public List<ContractHistory__c> Related_ContractHistory{get;set;}
    public Boolean renderrelatedlist{get;set;}
    Public Boolean renderrelatedlistHis{get;set;}
    public boolean deletepermission{get;set;}
    public boolean pricingtermseditper{get;set;}
    //Subhro Clone Functionality Case#--00171452
    public boolean clonebutton{get;set;}
    public boolean clonepermission{get;set;}
    public String Clone;
    public boolean showSaveAsDraft {get;set;}//Added by Akanksha for story S-351420
    Public Boolean isselected{set;get;}
    Public Boolean Display_Point_of_sale_or_rebate_option_language{set;get;}
    Public Boolean Display_IT{set;get;}
    Public Boolean Display_flex{set;get;}
    Public Boolean Display_master{set;get;}
    public Boolean party_required{get;set;}
    
    Public List<wrpclass> wrplist{set;get;}
    
    //Added by Pune Team/Mohit Support Number-02469967
    Public List<WrapClassCustomerfees> customerFessList{set;get;}
    
    //Added by Pune Team/Mohit Support Number-02490900
    public Boolean renderExpirationDater{get;set;}
    
     Boolean Forcedinheritance;
    
    Boolean cloneflag=false;

    
    
    //End
    /***** Standard Controller to Fetch the Id's and Tabs from the URL *****/
    public springcmContract2(ApexPages.StandardController controller) {
        RelatedList_PricingTerms= new List<Contract_Pricing_Terms__c>();
         //Related_ContractHistory= new List<ContractHistory__C>();
        //LSLEVIN 5.13.2015 S-309030 Added below line
        contractActivityHistory = new List<ContractHistory>();
        renderrelatedlist=false;
        renderrelatedlistHis=false;
        ID contract_id = ApexPages.currentPage().getParameters().get('id');
        
        ID AccountID = ApexPages.currentPage().getParameters().get('accid');
        contractvalue = contract_id;
        system.debug('The Active tab constructor'+ActiveTab);
        display_springcm_contract = false;
        Enable_Details_Tab = true;
        Account_Label = false;
        deletepermission=false;
        pricingtermseditper=false;
        clonebutton=false;
        clonepermission= false;
        Schema.DescribeSObjectResult pricingtermpermission = Contract_Pricing_Terms__c.SObjectType.getDescribe();
        if(pricingtermpermission.isDeletable())
        {
            system.debug('permission true');
            deletepermission=true;
        }
        if(pricingtermpermission.isUpdateable())
        {
            pricingtermseditper=true;
        }
        Schema.DescribeSObjectResult c_ob = Contract.SObjectType.getDescribe();
        if(c_ob.isUpdateable())
        {
            display_crud = true;
            List_readonly = false;
        }
        else
        {
            List_readonly = true;
            display_crud = false;
        }
        //Clone should be seen by user with all the permissions on Contract object.
        if(c_ob.isCreateable() && c_ob.isUpdateable() && c_ob.isAccessible() && c_ob.isDeletable())
        {
            clonepermission=true;
        }
        
        if(ApexPages.currentPage().getParameters().get('save_new') != null)
        {
            system.debug('save');
            newaccdisplay = true;
            display = false;
            Enable_Details_Tab = false;
            Account_Label = false;
            display_springcm_contract = false;
            newcontr = new Contract();
        }
        
        else
        {
            if(ApexPages.currentPage().getParameters().get('at') != null){
                ActiveTab = ApexPages.currentPage().getParameters().get('at');
            }
            
            if (contract_id != null) {
                clonebutton=true;
                Enable_Details_Tab = true;
                display = true;
                Account_Label = false;
                display_springcm_contract = true;
                renderrelatedlist=true;
                /*-----Query updated by Himanshu Sharma for JIRA ticket NAIT-111807-----------------*/
                RelatedList_PricingTerms = [Select id,Private_Brand__c,Name,Relevant_Customer_Level__c,Addition_communication_requirements__c,Deletion_communication_requirements__c,How_frequently_can_we_pass_increases__c,In_days__c,Calendar_period__c,Contract__c,Active__c,CC_Pricing_Update_Frequency_in_days__c,CC_Prc_Chg_Notice_Reqd_days__c,CC_Price_Incr_Capped__c,Comm_Req_CC_Price_Chg__c from Contract_Pricing_Terms__c where Contract__c=:contract_id order by Active__c desc]; //S-350559 [Hemant 9/9/2015] - Added Comm_Req_CC_Price_Chg__c in query
                renderrelatedlistHis=true;
                //Related_ContractHistory = [Select id,Name,Contract_Status__c,Account_Name__c,LastModifiedBy.Name,LastModifiedDate,primary__c,Contract_Type__c from ContractHistory__c where Contract__c=:contract_id order by createddate desc];
                //deepak changes start
                /*LSLEVIN S-309031 5.7.2015 Removed Bid_Outcome__c
from below query and added field Current_Legacy_Max_Agreement__c
and Renewal_Pending__c*/
                /*LSLEVIN S-309032 5.11.2015 Removed Anniversary_Date__c from query
and added Executed_Amendments__c,Other_Contract_Terms_Description__c,Small_Order_Fee_Language__c,
Furniture_Delivery_Fee_Language__c,Excess_Dimension_Fees_Language__c,Restocking_Fees_Language__c,
Contract_State_Minimum_Order__c,Minimum_Order_Value_Language__c*/
                /*LSLEVIN S-309036 5.13.2015 Added the following to the below query Call_Out_Cost_Plus_Floor__c,
Call_Out_Auto_Force_Sub__c,Call_Out_Sub_Language__c,Cost_Plus_Floor_Type__c,Customer_Hierarchy_Cost_Plus_Pricing__c,
Proprietary_Items__c,Vendor_Funded_Core_Specificall__c,Vendor_funded_core_language__c,Minimum_Annual_Spend_Threshold_for_Prici__c*/
                //START NSHARP CASE 00130611 8.12.15
                //newcontr = [select Id,Any_other_callouts_from_legal__c,Minimum_Annual_Spend_Threshold_for_Prici__c,Vendor_funded_core_language__c,Vendor_Funded_Core_Specificall__c,Proprietary_Items__c,Customer_Hierarchy_Cost_Plus_Pricing__c,Cost_Plus_Floor_Type__c,Call_Out_Sub_Language__c,Call_Out_Auto_Force_Sub__c,Call_Out_Cost_Plus_Floor__c,Minimum_Order_Value_Language__c,Contract_State_Minimum_Order__c,Restocking_Fees_Language__c,Excess_Dimension_Fees_Language__c,Furniture_Delivery_Fee_Language__c,Small_Order_Fee_Language__c,Other_Contract_Terms_Description__c,Executed_Amendments__c,Current_Legacy_Max_Agreement__c,Renewal_Pending__c,Standalone_Floor_Structure_Description__c,Payment_Term_Other__c,Special_Order_Discount_Language__c,GP_Cost_Plus_Language__c,Price_Decrease_Language__c,Minimum_Annual_Spend_Commitment_Amount__c,Is_there_a_custom_NCC__c,How_frequently_can_the_pricing_on_the_cu__c,Action_requirements_for_deleted_or_disco__c,Price_requirements_for_added_or_alternat__c,Is_notification_required_to_delete_a_cus__c,What_type_of_customer_communication_is_r__c,Does_written_agreement_allow_for_price__c,Core_Spend_Volume_Threshold_for_Pricing__c,Standalonedecr_req_to_be_applied_to_Cust__c,Standalone_Custom_Core_Written_Agreement__c,Standalone_SKU_Count_Limitation__c,Standalone_Custom_Core_Discount_Percent__c,Written_Agreement_allow_Standalone__c,Standalone_Pricing_Update_Frequency__c,Cust_Notif_to_change_Pricingon_Standalon__c,StandaloneCore_List_Update_Notice_Period__c,Standalone_Core_List_have_Capped_Price__c,StandalonCore_List_Capped_Price_Increase__c,Standalone_Core_List_SKU_Capped_Price__c,Are_there_Standalone_SKU_Count_Limit__c,Standalone_Annual_Spend_Requirement__c,Standalone_Custom_Core_Discount_Basis__c,Floors_permitted_in_Standalone_Cust_Core__c, Does_the_contract_include_ODP_Subsidiari__c,Clawback_Provision_Language__c,Effective_Date_Of_Current_Amendment__c,Other_Extension_Duration__c,Duration_Of_Each_Extension__c,Contract_Extension_Authorization_Type__c,Number_Of_Extensions__c,Other_Extension_Number__c,Describe_number_of_Amendments__c,Is_there_a_clawback_provision__c,AccountId,Account.Name, Account.Cust_ID__c ,Account.AOPS_Cust_Id__c,CSF_Review_Date__c,OwnerExpirationNotice, contract_type__c,contract_status__c,Contract_data_verified__c,Verified_date_time__c,User_who_verified_data__c,Verification_notes__c,Status_Detail__c, StartDate, EndDate, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ContractTerm, Status, CompanySignedId, CompanySignedDate, CustomerSignedId, CustomerSignedTitle, CustomerSignedDate, SpecialTerms, ActivatedById, ActivatedDate, StatusCode, Description, ContractNumber, Basis_Level_for_Customer_Agreement__c, Grandparent_Number__c, Grandparent_Name__c, Parent_Account_Number__c, Parent_Account_Name__c, Child_Account_Number__c, Child_Account_Name__c, Tech_Depot_Account_Number__c, Tech_Depot_Account_Name__c, Stand_Alone_Account_Number__c, Stand_Alone_Account_Name__c, Prospect_Account_Number__c, Prospect_Account_Name__c, Contract_Development_Negotiation_MGR__c, Contract_Lifecycle_Manager__c,Contract_Owner__c, Date_Original_Contract_Signed__c, Original_Expiration_Date__c, Effective_Date_of_Original_Contract__c, Date_current_Legal_Contract_expires__c, Contract_Extensions__c, Extension_Terms__c, Have_Amendment_s_been_executed__c,Is_there_a_Most_Favored_Customer_claus__c, Most_Favored_Contract_Language__c, Does_contract_have_provisions_for_an_emp__c, Emp_Pricing_tied_to_Cust_Pricing__c, Specific_lang_on_the_contract_on_emp_pgm__c, Do_employee_purchases_go_toward_rebates__c, Contract_state_a_Small_Order_Fee_charge__c, Contract_state_a_furniture_delivery_fee__c, Dimension_fee_for_furn_charge_are_exclud__c, Contract_state_Restocking_Fees_excluded__c, Start_date_of_Point_of_Sale_Discount__c, End_date_of_Point_of_Sale_Discount__c, Are_there_Rebates_Incentives__c, Rebate_Incentive_Type__c, Penalties_for_late_Rebate_payment__c, Reporting_Requirements_In_Legal_Agreemen__c, Reporting_Requirements__c, Reporting_Penalties_for_late_reports__c, Report_Frequency__c, Report_Frequency_Other__c, Other_Report_Penalties_Description__c,Stand_Alone_Bid_Agreement_Number__c, GP_Bid_Agreement_Number__c, Parent_Bid_Agreement_Number__c, Child_Bid_Agreement_Number__c,Are_there_Minority_Spend_Requirements__c,What_of_Spend_Dollar__c,What_of_spend__c,Minority_Spend_Requirements_Language__c, Written_Agreement_allow_GP_Custom_Cores__c, GP_Custom_Core_Written_Agreement_Languag__c, GP_Pricing_Update_Frequency__c,Child_Pricing_Update_Frequency_Other__c,Parent_Pricing_Update_Frequency_Other__c,GP_Pricing_Update_Frequency_Other__c, GP_Manufac_Vendor_letter_req_for_Increas__c, GP_decr_req_to_be_applied_to_Cust_Core__c, Cust_Notif_to_change_Pricing_on_GP_Core__c, GP_Cust_Core_List_Update_Notice_Type__c, GP_Cus_Core_List_Update_Notice_Period__c, GP_Core_List_have_Capped_Price_Increase__c, GP_Core_List_Capped_Price_Increase__c, GP_Core_List_SKU_Capped_Price_Increase__c, GP_SKU_Cap_Dollar_Amount__c, GP_SKU_Cap_Percent_Amount__c, Are_there_GP_SKU_Count_Limitations__c, GP_SKU_Count_Limitation__c, GP_Annual_Spend_Requirement__c, GP_Annual_Spend_Description__c, GP_Annual_Spend_Requirement_Amount__c, GP_Custom_Core_Discount_Basis__c, GP_Custom_Core_Discount_Percent__c, Floors_permitted_in_GP_Cust_Core__c, GP_Floor_Structure_Description__c, Written_Agreement_allow_Parent_Cust_Core__c, Apply_Parent_Cust_Core_Agreement_Lang__c, Parent_Pricing_Update_Frequency__c, Parent_Man_Vendor_letter_req_for_Increas__c, Parent_decr_req_applied_to_Cust_Core__c, Cust_Notif_to_chg_Pricing_on_Par_Core__c, Par_Cust_Core_List_Update_Notice_Type__c, Par_Cust_Core_List_Update_Notice_Period__c, Par_Core_have_Capped_Price_Increase__c, Par_Core_List_Capped_Price_Increase__c, Par_Core_SKU_Level_Capped_Price_Incr__c, Par_SKU_Cap_Dollar_Amount__c, Par_SKU_Cap_Percent_Amount__c, Are_there_Parent_SKU_Count_Limitations__c, Parent_SKU_Count_Limitation__c, Parent_Annual_Spend_Requirement__c, Parent_Annual_Spend_Description__c, Par_Annual_Spend_Requirement_Amount__c, Parent_Custom_Core_Discount_Basis__c, Parent_Custom_Core_Discount_Percent__c, Floors_permitted_in_Par_Cust_Core_List__c, Parent_Floor_Structure_Description__c, Written_Agreement_allow_Child_Cust_Cores__c, Apply_Child_Core_Written_Agree_Lang__c, Child_Pricing_Update_Frequency__c, Child_Man_Ven_letter_req_for_Increase__c, Child_decr_req_to_be_applied_to_Cus_Core__c, Cust_Notif_to_chg_Pricing_on_Child_Core__c, Child_Cust_Core_Update_Notice_Type__c, Child_Cust_Core_Upd_Notice_Period__c, Child_Core_have_Capped_Price_Increase__c, Child_Core_List_Capped_Price_Increase__c, Child_Core_SKU_Level_Capped_Price_Incr__c, Child_SKU_Cap_Dollar_Amount__c, Child_SKU_Cap_Percent_Amount__c, Are_there_Child_SKU_Count_Limits__c, Child_SKU_Count_Limitation__c, Child_Annual_Spend_Requirement__c, Child_Annual_Spend_Description__c, Child_Annual_Spend_Requirement_Amount__c, Child_Custom_Core_Discount_Basis__c, Child_Custom_Core_Discount_Percent__c, Floors_permitted_in_Child_Cust_Core__c, Child_Floor_Structure_Description__c, Notification_process_for_disco_items__c, Notification_time_for_disco_items__c, Notification_time_disco_items_Other__c, Agreement_provide_disco_on_spec_orders__c, Contract_have_req_for_prop_items__c, Contract_cover_NonCore_Cat_setup_pricing__c, Non_Core_Catalog__c, Custom_Non_Core_Catalog__c, Decr_req_to_be_applied_to_NonCore_Cat__c, Flrs_permitted_in_Cust_NonCore_Cat_struc__c, What_floor_permitted_on_Cust_NonCore_Cat__c, Custom_Non_Core_Catalog_Discount_Basis__c, WAPO_Mark_Up_Percent__c, Describe_NonCore_Cat_Structure__c, Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c, NonCore_Cat_Update_Notice_Period__c, NonCore_Cat_Update_Notice_Period_Other__c, NonCore_Catalog_Update_Notice_Type__c, NonCore_Cat_Update_Acceptance_process__c,Non_Core_Catalog_Update_Frequency_Other__c, NonCore_Catalog_Update_Frequency__c, Floors_permitted_in_OffContr_Whlsler_str__c, Floor_for_OffContract_Structure__c, OffContract_Pricing_specified_in_contrac__c, OffContract_Pricing_Structure__c, OffContract_Lang_in_agreement__c, Wholesaler_Pricing_specified_in_contract__c, Wholesaler_Pricing_Structure__c, Wholesaler_Lang_in_agreement__c, GP_Floor_specified_in_contract__c, Cost_Language_included_in_agreement__c, Provide_Cost_Language_in_agreement__c, Manuf_Vendor_Letter_requiried_for_Increa__c, Work_with_Tier_1_partner_on_this_account__c, Name_of_Tier_1_Partner__c, Tier_1_fees_paid__c, Deviated_Pricing_offered_to_Customer__c, Specifics_of_the_Deviated_Cost_offering__c, Minimum_Annual_Spend_Commitment__c, Min_Annual_Spend_Comm_contract_lang_amt__c, OD_adjust_Cust_Prcing_if_Spend_not_met__c, Pricing_Summary__c, Multi_Country_Agreement__c, What_countries_are_covered__c, Payment_Terms__c, Agreement_respon_based_on_cat_prod_assor__c, Catalog_Product_Assortment__c, Is_there_a_Point_of_Sale_Discount__c, Point_of_Sale_Discount_levels_per_contra__c, Performance_Notification_Req_in_contract__c, Performance_Notification_Requirements__c, Penalties_for_not_meeting_Perf_Notifi_Re__c, Lang_in_contract_for_Perf_Notif_Requirem__c, Rebate_Description__c, Rebate_Penalty_Description__c, Report_Description__c,Par_Cus_Core_List_Upd_Notice_Per_Other__c,Child_Cust_Core_Upd_Notice_Period_Other__c, GP_Cus_Core_List_Upd_Notice_Period_Other__c,Floors_permitted_in_OffContr_Whlsler_str__c from Contract where id = :contract_id];
                //Modified and improved allignments for query By Vipul Jain for Story#S-457176 (00899739 - Tier 1: Story 20 Account-Level CSF Changes) on December 30,2016
                // Custom_Non_Core_Catalog_Discount_Basis__c added on 6/27/19 by Ryan Tocco for support #02486102
                //NCC_minimum_sell_price__c,Sell_price__c,Trigger__c,Trigger_Integer__c,Trigger_un_named__c,Sell_price_Integer__c,Sell_price_un_named__c fields added by Pune team/Mohit for support #02469982
                //Fields related to Customer Fees Grid Added by Pune team/Mohit Support Number - 02469967
                //Added by CSF COntract Hierarchy related fields by Pune Team/Mohit Support Number-02490656
                 
                newcontr = [select Id,Is_there_different_compensation_for_AB__c,ePS_Fee_Subcomponent_Within_PGC__c,Credit_Card_Fee_Subcomponent_Within_Part__c,
                            Is_this_a_2_party_or_3_party_agreement__c,Diversity_Type_Requirement__c,Any_other_callouts_from_legal__c,
                            Minimum_Annual_Spend_Threshold_for_Prici__c,Vendor_funded_core_language__c,Vendor_Funded_Core_Specificall__c,
                            Proprietary_Items__c,Customer_Hierarchy_Cost_Plus_Pricing__c,Cost_Plus_Floor_Type__c,Call_Out_Sub_Language__c,
                            Call_Out_Auto_Force_Sub__c,Call_Out_Cost_Plus_Floor__c,Minimum_Order_Value_Language__c,Contract_State_Minimum_Order__c,
                            Restocking_Fees_Language__c,Excess_Dimension_Fees_Language__c,Furniture_Delivery_Fee_Language__c,Small_Order_Fee_Language__c,
                            Other_Contract_Terms_Description__c,Executed_Amendments__c,Current_Legacy_Max_Agreement__c,Renewal_Pending__c,
                            Standalone_Floor_Structure_Description__c,Payment_Term_Other__c,Special_Order_Discount_Language__c,GP_Cost_Plus_Language__c,
                            Price_Decrease_Language__c,Minimum_Annual_Spend_Commitment_Amount__c,Is_there_a_custom_NCC__c,How_frequently_can_the_pricing_on_the_cu__c,
                            Action_requirements_for_deleted_or_disco__c,Contract_cover_NonCore_Cat_setup_pricing__c,Price_requirements_for_added_or_alternat__c,
                            Is_notification_required_to_delete_a_cus__c,What_type_of_customer_communication_is_r__c,Does_written_agreement_allow_for_price__c,
                            Core_Spend_Volume_Threshold_for_Pricing__c,Standalonedecr_req_to_be_applied_to_Cust__c,Standalone_Custom_Core_Written_Agreement__c,
                            Standalone_SKU_Count_Limitation__c,Standalone_Custom_Core_Discount_Percent__c,Written_Agreement_allow_Standalone__c,Standalone_Pricing_Update_Frequency__c,
                            Cust_Notif_to_change_Pricingon_Standalon__c,StandaloneCore_List_Update_Notice_Period__c,Standalone_Core_List_have_Capped_Price__c,StandalonCore_List_Capped_Price_Increase__c,
                            Standalone_Core_List_SKU_Capped_Price__c,Are_there_Standalone_SKU_Count_Limit__c,Standalone_Annual_Spend_Requirement__c,Standalone_Custom_Core_Discount_Basis__c,
                            Floors_permitted_in_Standalone_Cust_Core__c, Does_the_contract_include_ODP_Subsidiari__c,Clawback_Provision_Language__c,Effective_Date_Of_Current_Amendment__c,
                            Other_Extension_Duration__c,Duration_Of_Each_Extension__c,Contract_Extension_Authorization_Type__c,Number_Of_Extensions__c,Other_Extension_Number__c,
                            Describe_number_of_Amendments__c,Is_there_a_clawback_provision__c, AccountId, Account.Name, Account.Cust_ID__c ,Account.RecordType.Name, Account.AOPS_Cust_Id__c,CSF_Review_Date__c,OwnerExpirationNotice,
                            contract_type__c,Diversity_Partner_Reseller_Name__c,contract_status__c,Contract_data_verified__c,Verified_date_time__c,User_who_verified_data__c,Verification_notes__c,Status_Detail__c, StartDate, EndDate,
                            BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ContractTerm,
                            Status, CompanySignedId, CompanySignedDate, CustomerSignedId, CustomerSignedTitle, CustomerSignedDate, SpecialTerms, ActivatedById, ActivatedDate, StatusCode, Description,
                            ContractNumber, Basis_Level_for_Customer_Agreement__c, Grandparent_Number__c, Grandparent_Name__c, Parent_Account_Number__c, Parent_Account_Name__c, Child_Account_Number__c,
                            Child_Account_Name__c, Tech_Depot_Account_Number__c, Tech_Depot_Account_Name__c, Stand_Alone_Account_Number__c, Stand_Alone_Account_Name__c, Prospect_Account_Number__c,
                            Prospect_Account_Name__c, Contract_Development_Negotiation_MGR__c, Contract_Lifecycle_Manager__c,Contract_Owner__c, Date_Original_Contract_Signed__c, Original_Expiration_Date__c,
                            Effective_Date_of_Original_Contract__c, Date_current_Legal_Contract_expires__c,  Contract_Term__c,Contract_Extensions__c, Extension_Terms__c, Have_Amendment_s_been_executed__c,
                            Is_there_a_Most_Favored_Customer_claus__c, Most_Favored_Contract_Language__c, Does_contract_have_provisions_for_an_emp__c, Emp_Pricing_tied_to_Cust_Pricing__c,
                            Specific_lang_on_the_contract_on_emp_pgm__c, Do_employee_purchases_go_toward_rebates__c, Contract_state_a_Small_Order_Fee_charge__c, Contract_state_a_furniture_delivery_fee__c,
                            Dimension_fee_for_furn_charge_are_exclud__c, Contract_state_Restocking_Fees_excluded__c, Start_date_of_Point_of_Sale_Discount__c, End_date_of_Point_of_Sale_Discount__c,
                            Are_there_Rebates_Incentives__c, Rebate_Incentive_Type__c, Penalties_for_late_Rebate_payment__c, Reporting_Requirements_In_Legal_Agreemen__c, Reporting_Requirements__c,
                            Reporting_Penalties_for_late_reports__c, Report_Frequency__c, Report_Frequency_Other__c, Other_Report_Penalties_Description__c,Stand_Alone_Bid_Agreement_Number__c,
                            GP_Bid_Agreement_Number__c, Parent_Bid_Agreement_Number__c, Child_Bid_Agreement_Number__c,Are_there_Minority_Spend_Requirements__c,What_of_Spend_Dollar__c,
                            What_of_spend__c,Minority_Spend_Requirements_Language__c, Written_Agreement_allow_GP_Custom_Cores__c, GP_Custom_Core_Written_Agreement_Languag__c,
                            GP_Pricing_Update_Frequency__c,Child_Pricing_Update_Frequency_Other__c,Parent_Pricing_Update_Frequency_Other__c,GP_Pricing_Update_Frequency_Other__c,
                            GP_Manufac_Vendor_letter_req_for_Increas__c, GP_decr_req_to_be_applied_to_Cust_Core__c, Cust_Notif_to_change_Pricing_on_GP_Core__c,
                            GP_Cust_Core_List_Update_Notice_Type__c, GP_Cus_Core_List_Update_Notice_Period__c, GP_Core_List_have_Capped_Price_Increase__c, GP_Core_List_Capped_Price_Increase__c,
                            GP_Core_List_SKU_Capped_Price_Increase__c, GP_SKU_Cap_Dollar_Amount__c, GP_SKU_Cap_Percent_Amount__c, Are_there_GP_SKU_Count_Limitations__c, GP_SKU_Count_Limitation__c,
                            /*GP_Annual_Spend_Requirement__c,*/ GP_Annual_Spend_Description__c, GP_Annual_Spend_Requirement_Amount__c, GP_Custom_Core_Discount_Basis__c, GP_Custom_Core_Discount_Percent__c,
                            Floors_permitted_in_GP_Cust_Core__c, GP_Floor_Structure_Description__c, Written_Agreement_allow_Parent_Cust_Core__c, Apply_Parent_Cust_Core_Agreement_Lang__c, Parent_Pricing_Update_Frequency__c,
                            Parent_Man_Vendor_letter_req_for_Increas__c, Parent_decr_req_applied_to_Cust_Core__c, Cust_Notif_to_chg_Pricing_on_Par_Core__c, Par_Cust_Core_List_Update_Notice_Type__c,
                            Par_Cust_Core_List_Update_Notice_Period__c, Par_Core_have_Capped_Price_Increase__c, Par_Core_List_Capped_Price_Increase__c, Par_Core_SKU_Level_Capped_Price_Incr__c,
                            Par_SKU_Cap_Dollar_Amount__c, Par_SKU_Cap_Percent_Amount__c, Are_there_Parent_SKU_Count_Limitations__c, Parent_SKU_Count_Limitation__c, /*Parent_Annual_Spend_Requirement__c,*/
                            Parent_Annual_Spend_Description__c, Par_Annual_Spend_Requirement_Amount__c, Parent_Custom_Core_Discount_Basis__c, Parent_Custom_Core_Discount_Percent__c,
                            Floors_permitted_in_Par_Cust_Core_List__c, Parent_Floor_Structure_Description__c, Written_Agreement_allow_Child_Cust_Cores__c, Apply_Child_Core_Written_Agree_Lang__c,
                            Child_Pricing_Update_Frequency__c, Child_Man_Ven_letter_req_for_Increase__c, Child_decr_req_to_be_applied_to_Cus_Core__c, Cust_Notif_to_chg_Pricing_on_Child_Core__c,
                            Child_Cust_Core_Update_Notice_Type__c, Child_Cust_Core_Upd_Notice_Period__c, Child_Core_have_Capped_Price_Increase__c,
                            Child_Core_List_Capped_Price_Increase__c, Child_Core_SKU_Level_Capped_Price_Incr__c, Child_SKU_Cap_Dollar_Amount__c, Child_SKU_Cap_Percent_Amount__c,
                            Are_there_Child_SKU_Count_Limits__c, Child_SKU_Count_Limitation__c, /*Child_Annual_Spend_Requirement__c,*/ Child_Annual_Spend_Description__c, Child_Annual_Spend_Requirement_Amount__c,
                            Child_Custom_Core_Discount_Basis__c, Child_Custom_Core_Discount_Percent__c, Floors_permitted_in_Child_Cust_Core__c, Child_Floor_Structure_Description__c,
                            Notification_process_for_disco_items__c, Notification_time_disco_items_Other__c, Agreement_provide_disco_on_spec_orders__c, Contract_have_req_for_prop_items__c,
                            Non_Core_Catalog__c, Decr_req_to_be_applied_to_NonCore_Cat__c, What_floor_permitted_on_Cust_NonCore_Cat__c, WAPO_Mark_Up_Percent__c, Describe_NonCore_Cat_Structure__c,
                            Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c, NonCore_Cat_Update_Notice_Period__c, NonCore_Cat_Update_Notice_Period_Other__c, NonCore_Catalog_Update_Notice_Type__c,
                            NonCore_Cat_Update_Acceptance_process__c,Non_Core_Catalog_Update_Frequency_Other__c, NonCore_Catalog_Update_Frequency__c, Floor_for_OffContract_Structure__c,
                            OffContract_Pricing_specified_in_contrac__c, OffContract_Pricing_Structure__c, OffContract_Lang_in_agreement__c, Wholesaler_Pricing_specified_in_contract__c,
                            Wholesaler_Pricing_Structure__c, Wholesaler_Lang_in_agreement__c, Cost_Language_included_in_agreement__c, Provide_Cost_Language_in_agreement__c, Manuf_Vendor_Letter_requiried_for_Increa__c,
                            Work_with_Tier_1_partner_on_this_account__c, Tier_1_fees_paid__c, Tier_1_Partner_Compensation_Language__c, Deviated_Pricing_offered_to_Customer__c, Specifics_of_the_Deviated_Cost_offering__c,
                            Minimum_Annual_Spend_Commitment__c, Min_Annual_Spend_Comm_contract_lang_amt__c, OD_adjust_Cust_Prcing_if_Spend_not_met__c, Pricing_Summary__c, Multi_Country_Agreement__c, What_countries_are_covered__c,
                            Payment_Terms__c, Payment_Terms_language__c, Agreement_respon_based_on_cat_prod_assor__c, Catalog_Product_Assortment__c, Is_there_a_Point_of_Sale_Discount__c, Point_of_Sale_Discount_levels_per_contra__c,
                            Performance_Notification_Req_in_contract__c, Performance_Notification_Requirements__c, Penalties_for_not_meeting_Perf_Notifi_Re__c, Lang_in_contract_for_Perf_Notif_Requirem__c, Rebate_Description__c,
                            Rebate_Penalty_Description__c, Report_Description__c,Par_Cus_Core_List_Upd_Notice_Per_Other__c,Child_Cust_Core_Upd_Notice_Period_Other__c, GP_Cus_Core_List_Upd_Notice_Period_Other__c,Is_this_a_renewal__c,
                            Refer_to_Prior_CSF__c,
                            Printed_Catalog_Required__c,Documentation_confirmation_required_to_p__c,Participation_requirement__c,Desktop_delivery__c,
                            Desktopdelivery_language__c,Non_standard_callout__c,Nonstandard_language__c,Contract_allow_for_dependent_pricing_rel__c ,Cost_basis__c ,
                            Point_of_sale_or_rebate_option__c,Point_of_sales_tiers_Discount1__c,Point_of_sales_tiers_Discount2__c,
                            Point_of_sales_tiers_Discount3__c,Point_of_sales_tiers_Discount4__c,Point_of_sales_tiers_Discount5__c,Point_of_sales_tiers_Form1__c,
                            Point_of_sales_tiers_Form2__c,Point_of_sales_tiers_Form3__c,Point_of_sales_tiers_Form4__c,
                            Point_of_sales_tiers_Form5__c,Point_of_sales_tiers_To1__c,Point_of_sales_tiers_To2__c,Point_of_sales_tiers_To3__c,
                            Point_of_sales_tiers_To4__c,Point_of_sales_tiers_To5__c,Custom_core_item_count__c,
                            Item_count_restrictions__c,Item_count_limit__c,Item_count_threshold_tier_From1__c,Item_count_threshold_tier_From2__c,Item_count_threshold_tier_From3__c,
                            Item_count_threshold_tier_From4__c,Item_count_threshold_tier_From5__c,Item_count_threshold_tier_To1__c,Item_count_threshold_tier_To2__c,Item_count_threshold_tier_To3__c,
                            Item_count_threshold_tier_To4__c,Item_count_threshold_tier_To5__c,Item_count_threshold_tier_Count1__c,Item_count_threshold_tier_Count2__c,Item_count_threshold_tier_Count3__c,Item_count_threshold_tier_Count4__c,
                            Item_count_threshold_tier_Count5__c,Other_cost_basis__c,Forced_inheritance_no_custom_cores__c,
                            Custom_pricing_should_not_be_more_or_les__c,Agreement_allow_for_custom_cores__c,Next_day_delivery__c,Next_day_delivery_language__c,No_customization_on_inherited_core_sku__c,
                            Custom_items_must_from_specific_formular__c,IT_security_breach_notice_obligation__c,IT_security_breach_obligation_lang__c,Web_indicators_language__c,
                            indicators_required_by_written_agreement__c,Point_of_sale_or_rebate_option_language__c,Custom_core_written_agreement_language__c
                            ,Termination_clause_language__c,Termination_clause__c,SKU_level_pricing_language__c,SKU_level_pricing__c,
                            Other_discount_basis__c,Document_s_missing__c,Missing_document_s_notes__c,NCC_discount_basis__c,Variable_NCC_discount_language__c,Variable_NCC_discount__c,Tiered_discounts_on_CPD__c,CPD_tiered_discount_language__c,Core_of_annual_volume__c,primary__c,
                            NCNC_governed_by_the_agreement__c,Prod_Assortment_is_response_based_upon__c,NCNC_Type__c,Non_Core_None_Catalog_description__c,Decreases_to_Cust_Non_Core_Non_Catalog__c
                            ,Penalty_for_not_meeting__c,Other_contract_type__c,Data_type_received_from_customer__c,TextBox_1__c,TextBox_2__c,TextBox_3__c,TextBox_1_Yes__c,TextBox_2_Yes__c,TextBox_3_Yes__c,
                            TextBox_1_Penalty__c,TextBox_2_Penalty__c,TextBox_3_Penalty__c,Security_assessment_frequency__c,X3rd_party_required_to_provide_a_securit__c,
                            Data_breach_notification_period__c,Contract_on_Office_Depot_or_custom_paper__c,contractstate_we_can_charge_bulkitem_fee__c,Name,
                            Is_this_a_Flex_program_contract__c,Flex_program_language__c,Contract_cost__c,Master_program_language__c,
                            Is_this_a_Master_program_contract__c,GPO_Contract__c,Floors_permitted_in_OffContr_Whlsler_str__c,
                            GP_Floor_specified_in_contract__c,Flrs_permitted_in_Cust_NonCore_Cat_struc__c, Custom_Non_Core_Catalog_Discount_Basis__c,NCC_minimum_sell_price__c,Sell_price__c,Trigger__c,Trigger_Integer__c,Trigger_un_named__c,Sell_price_Integer__c,Sell_price_un_named__c,
                            Customer_fees__c,Customer_fees_yes_other_1__c,Customer_fees_yes_other_2__c,Customer_fees_yes_other_3__c,Customer_Fees_Other_1__c, Customer_Fees_Other_2__c,Customer_Fees_Other_3__c,Fee_Language_Other_1__c ,Fee_Language_Other_2__c ,Fee_Language_Other_3__c, Effective_Date_of_Original_Contract_2__c, 
                            Effective_Date_of_Original_Contract_3__c ,Effective_Date_of_Original_Contract_4__c, Effective_Date_of_Original_Contract_5__c,Current_contract_expiration_date_1__c, Current_contract_expiration_date_2__c,Current_contract_expiration_date_3__c,Current_contract_expiration_date_4__c, Current_contract_expiration_date_5__c,CSF_Hierarchy_1__c ,
                            CSF_Hierarchy_2__c ,CSF_Hierarchy_3__c ,CSF_Hierarchy_4__c , CSF_Hierarchy_5__c, Bulk_item_fee_language__c,Imports_fee_language__c,Printed_catalog_fee_language__c,Reporting_fee_language__c,Hosted_catalog_fee_language__c,Desktop_delivery_fee_language__c,
                            Storeroom_stocking_fee_language__c,Customer_item_warehousing_fee_language__c,EDI_fee_language__c,VW_shipping_fee_language__c,Return_fee_language__c from Contract where id = :contract_id]; //Support Ticket
                
                //END- Vipul
                //END NSHARP CASE 00130611 8.12.15
                // deepak changes end
                //Added Marketing Fields, Miles NAIT-1753
            }
            else {
                system.debug('New Contract');
                Enable_Details_Tab = false;
                display = true;
                Account_Label = true;
                newcontr = new Contract();
                system.debug('>>>>>>Setting Account Lookup' + AccountID);
                newcontr.AccountID = AccountID;
                accnt = [select Id, Name, Cust_ID__c from Account Where id =: AccountID ];
                system.debug('>>>>>>'+accnt);
            }
        }
        
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        //system.debug('ProfileName'+profileName);
        
        if(c_ob.isDeletable() && renderrelatedlist == true) // && profileName =='System Administrator'
        {
            cntrdeletepermission = true;
        }
        
        System.debug('@@@@-----'+newcontr.Have_Amendment_s_been_executed__c);
        
        ///////Removing --None-- Value from the Picklist
        
        statusOptions = new List<SelectOption>();
        // Use DescribeFieldResult object to retrieve status field.
        Schema.DescribeFieldResult statusFieldDescription = Contract.Contract_Status__c.getDescribe();
        
        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry:statusFieldDescription.getPicklistValues()){
            
            statusOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
            
            // obtain and assign default value
            if ((picklistEntry.defaultValue)&&(newcontr.Contract_Status__c==null)){
                newcontr.Contract_Status__c = pickListEntry.getValue();
            }
        }
        //Added by Akanksha for story S-351420
        if(newcontr.Contract_Status__c == 'Draft' && display_crud)
        {
            showSaveAsDraft = true;
        }
        else
        {
            showSaveAsDraft = false;
        }
        //End by Akanksha for story S-351420
        
        statusOptions1 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription1 = Contract.Report_Frequency__c.getDescribe();
        for (Schema.Picklistentry picklistEntry1:statusFieldDescription1.getPicklistValues()){
            
            statusOptions1.add(new SelectOption(pickListEntry1.getValue(),pickListEntry1.getLabel()));
            if ((picklistEntry1.defaultValue)&&(newcontr.Report_Frequency__c==null)){
                newcontr.Report_Frequency__c = pickListEntry1.getValue();
            }
        }
        
        statusOptions3 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription3 = Contract.Have_Amendment_s_been_executed__c.getDescribe();
        for (Schema.Picklistentry picklistEntry3:statusFieldDescription3.getPicklistValues()){
            
            statusOptions3.add(new SelectOption(picklistEntry3.getValue(),picklistEntry3.getLabel()));
            if ((picklistEntry3.defaultValue)&&(newcontr.Have_Amendment_s_been_executed__c==null)){
                newcontr.Have_Amendment_s_been_executed__c = picklistEntry3.getValue();
            }
        }
        
        statusOptions4 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription4 = Contract.Is_there_a_Most_Favored_Customer_claus__c.getDescribe();
        for (Schema.Picklistentry picklistEntry4:statusFieldDescription4.getPicklistValues()){
            
            statusOptions4.add(new SelectOption(picklistEntry4.getValue(),picklistEntry4.getLabel()));
            if ((picklistEntry4.defaultValue)&&(newcontr.Is_there_a_Most_Favored_Customer_claus__c==null)){
                newcontr.Is_there_a_Most_Favored_Customer_claus__c = picklistEntry4.getValue();
                
            }
            
            
            
        }
        
        
        statusOptions5 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription5 = Contract.Performance_Notification_Req_in_contract__c.getDescribe();
        for (Schema.Picklistentry picklistEntry5:statusFieldDescription5.getPicklistValues()){
            
            statusOptions5.add(new SelectOption(picklistEntry5.getValue(),picklistEntry5.getLabel()));
            if ((picklistEntry5.defaultValue)&&(newcontr.Performance_Notification_Req_in_contract__c==null)){
                newcontr.Performance_Notification_Req_in_contract__c = picklistEntry5.getValue();
            }
        }
        
        statusOptions6 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription6 = Contract.Are_there_Rebates_Incentives__c.getDescribe();
        for (Schema.Picklistentry picklistEntry6:statusFieldDescription6.getPicklistValues()){
            
            statusOptions6.add(new SelectOption(picklistEntry6.getValue(),picklistEntry6.getLabel()));
            if ((picklistEntry6.defaultValue)&&(newcontr.Are_there_Rebates_Incentives__c==null)){
                newcontr.Are_there_Rebates_Incentives__c = picklistEntry6.getValue();
            }
        }
        
        statusOptions7 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription7 = Contract.GP_Cus_Core_List_Update_Notice_Period__c.getDescribe();
        for (Schema.Picklistentry picklistEntry7:statusFieldDescription7.getPicklistValues()){
            
            statusOptions7.add(new SelectOption(picklistEntry7.getValue(),picklistEntry7.getLabel()));
            if ((picklistEntry7.defaultValue)&&(newcontr.GP_Cus_Core_List_Update_Notice_Period__c==null)){
                newcontr.GP_Cus_Core_List_Update_Notice_Period__c = picklistEntry7.getValue();
            }
        }
        
        statusOptions8 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription8 = Contract.GP_Core_List_Capped_Price_Increase__c.getDescribe();
        for (Schema.Picklistentry picklistEntry8:statusFieldDescription8.getPicklistValues()){
            
            statusOptions8.add(new SelectOption(picklistEntry8.getValue(),picklistEntry8.getLabel()));
            if ((picklistEntry8.defaultValue)&&(newcontr.GP_Core_List_Capped_Price_Increase__c==null)){
                newcontr.GP_Core_List_Capped_Price_Increase__c = picklistEntry8.getValue();
            }
        }
        
        statusOptions9 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription9 = Contract.GP_Core_List_SKU_Capped_Price_Increase__c.getDescribe();
        for (Schema.Picklistentry picklistEntry9:statusFieldDescription9.getPicklistValues()){
            
            statusOptions9.add(new SelectOption(picklistEntry9.getValue(),picklistEntry9.getLabel()));
            if ((picklistEntry9.defaultValue)&&(newcontr.GP_Core_List_SKU_Capped_Price_Increase__c==null)){
                newcontr.GP_Core_List_SKU_Capped_Price_Increase__c = picklistEntry9.getValue();
            }
        }
        /*
statusOptions10 = new List<SelectOption>();
Schema.DescribeFieldResult statusFieldDescription10 = Contract.GP_Annual_Spend_Requirement__c.getDescribe();
for (Schema.Picklistentry picklistEntry10:statusFieldDescription10.getPicklistValues()){

statusOptions10.add(new SelectOption(picklistEntry10.getValue(),picklistEntry10.getLabel()));
if ((picklistEntry10.defaultValue)&&(newcontr.GP_Annual_Spend_Requirement__c==null)){
newcontr.GP_Annual_Spend_Requirement__c = picklistEntry10.getValue();
}
}
*/
        statusOptions11 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription11 = Contract.Par_Cust_Core_List_Update_Notice_Period__c.getDescribe();
        for (Schema.Picklistentry picklistEntry11:statusFieldDescription11.getPicklistValues()){
            
            statusOptions11.add(new SelectOption(picklistEntry11.getValue(),picklistEntry11.getLabel()));
            if ((picklistEntry11.defaultValue)&&(newcontr.Par_Cust_Core_List_Update_Notice_Period__c==null)){
                newcontr.Par_Cust_Core_List_Update_Notice_Period__c = picklistEntry11.getValue();
            }
        }
        
        statusOptions12 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription12 = Contract.Par_Core_List_Capped_Price_Increase__c.getDescribe();
        for (Schema.Picklistentry picklistEntry12:statusFieldDescription12.getPicklistValues()){
            
            statusOptions12.add(new SelectOption(picklistEntry12.getValue(),picklistEntry12.getLabel()));
            if ((picklistEntry12.defaultValue)&&(newcontr.Par_Core_List_Capped_Price_Increase__c==null)){
                newcontr.Par_Core_List_Capped_Price_Increase__c = picklistEntry12.getValue();
            }
        }
        
        statusOptions13 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription13 = Contract.Par_Core_SKU_Level_Capped_Price_Incr__c.getDescribe();
        for (Schema.Picklistentry picklistEntry13:statusFieldDescription13.getPicklistValues()){
            
            statusOptions13.add(new SelectOption(picklistEntry13.getValue(),picklistEntry13.getLabel()));
            if ((picklistEntry13.defaultValue)&&(newcontr.Par_Core_SKU_Level_Capped_Price_Incr__c==null)){
                newcontr.Par_Core_SKU_Level_Capped_Price_Incr__c = picklistEntry13.getValue();
            }
        }
        
        /*statusOptions14 = new List<SelectOption>();
Schema.DescribeFieldResult statusFieldDescription14 = Contract.Parent_Annual_Spend_Requirement__c.getDescribe();
for (Schema.Picklistentry picklistEntry14:statusFieldDescription14.getPicklistValues()){

statusOptions14.add(new SelectOption(picklistEntry14.getValue(),picklistEntry14.getLabel()));
if ((picklistEntry14.defaultValue)&&(newcontr.Parent_Annual_Spend_Requirement__c==null)){
newcontr.Parent_Annual_Spend_Requirement__c = picklistEntry14.getValue();
}
}*/
        
        statusOptions15 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription15 = Contract.Child_Core_List_Capped_Price_Increase__c.getDescribe();
        for (Schema.Picklistentry picklistEntry15:statusFieldDescription15.getPicklistValues()){
            
            statusOptions15.add(new SelectOption(picklistEntry15.getValue(),picklistEntry15.getLabel()));
            if ((picklistEntry15.defaultValue)&&(newcontr.Child_Core_List_Capped_Price_Increase__c==null)){
                newcontr.Child_Core_List_Capped_Price_Increase__c = picklistEntry15.getValue();
            }
        }
        
        statusOptions16 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription16 = Contract.Child_Core_SKU_Level_Capped_Price_Incr__c.getDescribe();
        for (Schema.Picklistentry picklistEntry16:statusFieldDescription16.getPicklistValues()){
            
            statusOptions16.add(new SelectOption(picklistEntry16.getValue(),picklistEntry16.getLabel()));
            if ((picklistEntry16.defaultValue)&&(newcontr.Child_Core_SKU_Level_Capped_Price_Incr__c==null)){
                newcontr.Child_Core_SKU_Level_Capped_Price_Incr__c = picklistEntry16.getValue();
            }
        }
        
        /*statusOptions17 = new List<SelectOption>();
Schema.DescribeFieldResult statusFieldDescription17 = Contract.Child_Annual_Spend_Requirement__c.getDescribe();
for (Schema.Picklistentry picklistEntry17:statusFieldDescription17.getPicklistValues()){

statusOptions17.add(new SelectOption(picklistEntry17.getValue(),picklistEntry17.getLabel()));
if ((picklistEntry17.defaultValue)&&(newcontr.Child_Annual_Spend_Requirement__c==null)){
newcontr.Child_Annual_Spend_Requirement__c = picklistEntry17.getValue();
}
}*/
        
        statusOptions18 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription18 = Contract.Notification_process_for_disco_items__c.getDescribe();
        for (Schema.Picklistentry picklistEntry18:statusFieldDescription18.getPicklistValues()){
            
            statusOptions18.add(new SelectOption(picklistEntry18.getValue(),picklistEntry18.getLabel()));
            if ((picklistEntry18.defaultValue)&&(newcontr.Notification_process_for_disco_items__c==null)){
                newcontr.Notification_process_for_disco_items__c = picklistEntry18.getValue();
            }
        }
        
        //START NSHARP CASE 00130611 8.12.15
        //statusOptions19 = new List<SelectOption>();
        //Schema.DescribeFieldResult statusFieldDescription19 = Contract.Notification_time_for_disco_items__c.getDescribe();
        //for (Schema.Picklistentry picklistEntry19:statusFieldDescription19.getPicklistValues()){
        
        //statusOptions19.add(new SelectOption(picklistEntry19.getValue(),picklistEntry19.getLabel()));
        //if ((picklistEntry19.defaultValue)&&(newcontr.Notification_time_for_disco_items__c==null)){
        //newcontr.Notification_time_for_disco_items__c = picklistEntry19.getValue();
        //}
        //}
        //END NSHARP CASE 00130611 8.12.15
        
        statusOptions20 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription20 = Contract.NonCore_Catalog_Update_Frequency__c.getDescribe();
        for (Schema.Picklistentry picklistEntry20:statusFieldDescription20.getPicklistValues()){
            
            statusOptions20.add(new SelectOption(picklistEntry20.getValue(),picklistEntry20.getLabel()));
            if ((picklistEntry20.defaultValue)&&(newcontr.NonCore_Catalog_Update_Frequency__c==null)){
                newcontr.NonCore_Catalog_Update_Frequency__c = picklistEntry20.getValue();
            }
        }
        
        statusOptions21 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription21 = Contract.NonCore_Cat_Update_Notice_Period__c.getDescribe();
        for (Schema.Picklistentry picklistEntry21:statusFieldDescription21.getPicklistValues()){
            
            statusOptions21.add(new SelectOption(picklistEntry21.getValue(),picklistEntry21.getLabel()));
            if ((picklistEntry21.defaultValue)&&(newcontr.NonCore_Cat_Update_Notice_Period__c==null)){
                newcontr.NonCore_Cat_Update_Notice_Period__c = picklistEntry21.getValue();
            }
        }
        
        statusOptions22 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription22 = Contract.Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c.getDescribe();
        for (Schema.Picklistentry picklistEntry22:statusFieldDescription22.getPicklistValues()){
            
            statusOptions22.add(new SelectOption(picklistEntry22.getValue(),picklistEntry22.getLabel()));
            if ((picklistEntry22.defaultValue)&&(newcontr.Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c==null)){
                newcontr.Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c = picklistEntry22.getValue();
            }
        }
        
        statusOptions23 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription23 = Contract.Minimum_Annual_Spend_Commitment__c.getDescribe();
        for (Schema.Picklistentry picklistEntry23:statusFieldDescription23.getPicklistValues()){
            
            statusOptions23.add(new SelectOption(picklistEntry23.getValue(),picklistEntry23.getLabel()));
            if ((picklistEntry23.defaultValue)&&(newcontr.Minimum_Annual_Spend_Commitment__c==null)){
                newcontr.Minimum_Annual_Spend_Commitment__c = picklistEntry23.getValue();
            }
        }
        
        //START NSHARP CASE 00130611 8.12.15
        //statusOptions24 = new List<SelectOption>();
        //Schema.DescribeFieldResult statusFieldDescription24 = Contract.Flrs_permitted_in_Cust_NonCore_Cat_struc__c.getDescribe();
        //for (Schema.Picklistentry picklistEntry24:statusFieldDescription24.getPicklistValues()){
        
        //statusOptions24.add(new SelectOption(pickListEntry24.getValue(),pickListEntry24.getLabel()));
        //if ((picklistEntry24.defaultValue)&&(newcontr.Flrs_permitted_in_Cust_NonCore_Cat_struc__c==null)){
        //newcontr.Flrs_permitted_in_Cust_NonCore_Cat_struc__c = pickListEntry24.getValue();
        //}
        //}
        
        
        //statusOptions25 = new List<SelectOption>();
        //Schema.DescribeFieldResult statusFieldDescription25 = Contract.Custom_Non_Core_Catalog_Discount_Basis__c.getDescribe();
        //for (Schema.Picklistentry picklistEntry25:statusFieldDescription25.getPicklistValues()){
        
        //statusOptions25.add(new SelectOption(pickListEntry25.getValue(),pickListEntry25.getLabel()));
        //if ((picklistEntry25.defaultValue)&&(newcontr.Custom_Non_Core_Catalog_Discount_Basis__c==null)){
        //newcontr.Custom_Non_Core_Catalog_Discount_Basis__c = pickListEntry25.getValue();
        //}
        //}
        //END NSHARP CASE 00130611 8.12.15
        
        statusOptions26 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription26 = Contract.Child_Cust_Core_Upd_Notice_Period__c.getDescribe();
        for (Schema.Picklistentry picklistEntry26:statusFieldDescription26.getPicklistValues()){
            
            statusOptions26.add(new SelectOption(pickListEntry26.getValue(),pickListEntry26.getLabel()));
            if ((picklistEntry26.defaultValue)&&(newcontr.Child_Cust_Core_Upd_Notice_Period__c==null)){
                newcontr.Child_Cust_Core_Upd_Notice_Period__c = pickListEntry26.getValue();
            }
        }
        
        //Added as per Sprint 13 Case# 75108
        statusOptions27 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription27 = Contract.Status_Detail__c.getDescribe();
        for (Schema.Picklistentry picklistEntry27:statusFieldDescription27.getPicklistValues()){
            
            statusOptions27.add(new SelectOption(pickListEntry27.getValue(),pickListEntry27.getLabel()));
            if ((picklistEntry27.defaultValue)&&(newcontr.Status_Detail__c==null)){
                newcontr.Status_Detail__c = pickListEntry27.getValue();
            }
        }
        
        statusOptions28 = new List<SelectOption>();
        Schema.DescribeFieldResult statusFieldDescription28 = Contract.Decr_req_to_be_applied_to_NonCore_Cat__c.getDescribe();
        for (Schema.Picklistentry picklistEntry28:statusFieldDescription28.getPicklistValues()){
            
            statusOptions28.add(new SelectOption(pickListEntry28.getValue(),pickListEntry28.getLabel()));
            if ((picklistEntry28.defaultValue)&&(newcontr.Decr_req_to_be_applied_to_NonCore_Cat__c==null)){
                newcontr.Decr_req_to_be_applied_to_NonCore_Cat__c = pickListEntry28.getValue();
            }
            
         statusOptions30 = new List<SelectOption>();
          Schema.DescribeFieldResult statusFieldDescription30 = Contract.IT_security_breach_notice_obligation__c.getDescribe();
        for (Schema.Picklistentry picklistEntry30:statusFieldDescription30.getPicklistValues()){
           
            statusOptions30.add(new SelectOption(pickListEntry30.getValue(),pickListEntry30.getLabel()));
            if ((picklistEntry30.defaultValue)&&(newcontr.IT_security_breach_notice_obligation__c==null)){
                newcontr.IT_security_breach_notice_obligation__c = pickListEntry30.getValue();
            }
        }
        //02229075 
       
         statusOptions32 = new List<SelectOption>();
          Schema.DescribeFieldResult statusFieldDescription32 = Contract.Reporting_Penalties_for_late_reports__c.getDescribe();
        for (Schema.Picklistentry picklistEntry32:statusFieldDescription32.getPicklistValues()){
           
            statusOptions32.add(new SelectOption(pickListEntry32.getValue(),pickListEntry32.getLabel()));
          }
            
        //02229075 
        //02401235 
       /* statusOptions33 = new List<SelectOption>();
          Schema.DescribeFieldResult statusFieldDescription33 = Contract.Is_this_a_Flex_program_contract__c.getDescribe();
        for (Schema.Picklistentry picklistEntry33:statusFieldDescription33.getPicklistValues()){
           
            statusOptions33.add(new SelectOption(pickListEntry33.getValue(),pickListEntry33.getLabel()));
          }*/
        //02401235 
        //02401214  
       /* statusOptions34 = new List<SelectOption>();
          Schema.DescribeFieldResult statusFieldDescription34 = Contract.Is_this_a_Master_program_contract__c.getDescribe();
        for (Schema.Picklistentry picklistEntry34:statusFieldDescription34.getPicklistValues()){
           
            statusOptions34.add(new SelectOption(pickListEntry34.getValue(),pickListEntry34.getLabel()));
          }*/
        //02401214  
        //02224564
        if(newcontr.NCNC_governed_by_the_agreement__c==null)
          newcontr.NCNC_governed_by_the_agreement__c=picklistdefaultValue('Contract','NCNC_governed_by_the_agreement__c');
 //02224564
            //LSLEVIN S-309030 5.12.2015 Added Below Query
            contractActivityHistory = [SELECT Id, IsDeleted, ContractId, CreatedBy.Name, CreatedDate, Field, OldValue, NewValue FROM ContractHistory WHERE ContractId = :contract_id Limit 10];
            
            /*LSLEVIN S-309036 5.13.2015 Start*/
            if(newContr.Call_Out_Auto_Force_Sub__c == 'Yes'){
                Pricing_Call_Out_AutoSub_Language_Display = true;
            }
            else {
                Pricing_Call_Out_AutoSub_Language_Display = false;
            }
            if(newContr.Call_Out_Cost_Plus_Floor__c == 'Yes'){
                Pricing_Call_Out_CostPlus_FloorType_Display = true;
            }
            else {
                Pricing_Call_Out_CostPlus_FloorType_Display = false;
            }
            if(newContr.Contract_have_req_for_prop_items__c == 'Yes'){
                Proprietry_Items_Display = true;
            }
            else {
                Proprietry_Items_Display = false;
            }
            if(newContr.Vendor_Funded_Core_Specificall__c == 'Yes'){
                Vendor_Funded_Language_Display = true;
                Vendor_Funded_Language_No_Display = false;
            }
            else {
                Vendor_Funded_Language_Display = false;
                if(newcontr.Vendor_Funded_Core_Specificall__c == 'No') {
                    Vendor_Funded_Language_No_Display = true;
                }
            }
            if(newContr.Minimum_Annual_Spend_Commitment__c == 'Yes'){
                Minimum_Annual_Spend_Threshold_Display = true;
            }
            else {
                Minimum_Annual_Spend_Threshold_Display = false;
            }
            /*LSLEVIN S-309036 5.13.2015 Stop*/
            
        }
            
        PerformanceNotificationRequirements_getPicklistvalues();
        //Added by Pune Team/Mohit Support Number-02469967
        CustomerFees_getPicklistvalues();
       
        
        /////////Calling the Rendering Functionality Methods into the controller to display all the rendered fields when the page reloads
        conditionaldisplay();
        GP_Custom_Core_Discount_Basis_grid();
        Standalone_Custom_Core_Discount_Basis_grid();
        Floors_permitted_in_GP_Cust_Core_grid();
        Cust_Notif_to_chg_Pricing_on_Par_Core_grid();
        Par_Core_have_Capped_Price_Increase_grid();
        Par_Core_List_Capped_Price_Increase_grid();
        Are_there_Parent_SKU_Count_Limitations_grid();
        Parent_Annual_Spend_Requirement_grid();
        Parent_Custom_Core_Discount_Basis_grid();
        Floors_permitted_in_Par_Cust_Core_List_grid();
        Cust_Notif_to_chg_Pricing_on_Child_Core_grid();
        Child_Core_have_Capped_Price_Increase_grid();
        Child_Core_List_Capped_Price_Increase_grid();
        Are_there_Child_SKU_Count_Limits_grid();
        Child_Annual_Spend_Requirement_grid();
        Child_Custom_Core_Discount_Basis_grid();
        Floors_permitted_in_Child_Cust_Core_grid();
        Cost_Language_included_in_agreement_grid();
        NonCore_Cat_Update_Notice_Period_grid();
        NonCore_Catalog_Update_Frequency_grid();
        //START NSHARP CASE 00130611 8.12.15
        //Custom_Non_Core_Catalog_Discount_Basis_grid();
        //END NSHARP CASE 00130611 8.12.15
        Flrs_permitted_in_Cust_NonCore_Cat_struc_grid();
        Written_Agreement_allow_Parent_Cust_Core_grid();
        Cust_Notif_to_change_Pricing_on_GP_Core_grid();
        Cust_Notif_to_change_Pricing_on_Standalone_Core_grid();
        Standalone_Core_List_have_Capped_Price_Increase_grid();
        Are_there_Standalone_SKU_Count_Limitations_grid();
        Standalone_Core_List_Capped_Price_Increase_grid();
        Standalone_Core_List_SKU_Capped_Price_Increase_grid();
        GP_Core_List_have_Capped_Price_Increase_grid();
        Are_there_GP_SKU_Count_Limitations_grid();
        GP_Core_List_Capped_Price_Increase_grid();
        GP_Core_List_SKU_Capped_Price_Increase_grid();
        Child_Core_SKU_Level_Capped_Price_Incr_grid();
        Par_Core_SKU_Level_Capped_Price_Incr_grid();
        GP_Annual_Spend_Requirement_grid();
        //Notification_time_for_disco_items_grid();
        GP_Cus_Core_List_Update_Notice_Period_grid();
        Par_Cust_Core_List_Update_Notice_Period_grid();
        Child_Cust_Core_Upd_Notice_Period_grid();
        GP_Pricing_Update_Frequency_grid();
        Standalone_Pricing_Update_Frequency_grid();
        Parent_Pricing_Update_Frequency_grid();
        Child_Pricing_Update_Frequency_grid();
        Floors_permitted_in_Standalone_Cust_Core_grid();
        Price_Decrease_Language_grid();
        Flrs_permitted_in_Cust_NonCore_Cat_struc_grid();
        
        Forcedinheritance=newcontr.Forced_inheritance_no_custom_cores__c;
        CSFconditionaldisplay();
        CSFconditionaldisplayRo();
         PerformanceNotificationRequirements_Onload();
        //Is_this_a_renewal();
        //Added by Pune Team/Mohit Support Number-02469967
        CustomerFees_Onload();
        
     
        
    }
    
    public springcmContract2(){
        details_grandparent_grid_display = false;
        legal_fav_lang_display = false;
        legal_pos_display = false;
        // WIPRO - this will need to change for updates. ID param will be contract record id
        // AccountID = ApexPages.currentPage().getParameters().get('id');
        //val1 = acct.name;
        
    }
    
    /////// Getter and setter for account and contract instances
    public Account getacc()
    {
        return accnt;
    }
    public Contract getnewContract() {
        return newcontr;
    }
    
    /////// Methods for the functionality of Rendering the fields starts here
    
    public void conditionaldisplay()
    {
        //Added by Pune Team/Mohit Support Number-02490900
        renderExpirationDater = true;
        List<Date> datelist = new List<Date>();
        
        if(newcontr.Current_contract_expiration_date_1__c!=NULL)
        {
            datelist.add(newcontr.Current_contract_expiration_date_1__c);
        }
        if(newcontr.Current_contract_expiration_date_2__c!=NULL)
        {
            datelist.add(newcontr.Current_contract_expiration_date_2__c);
        }
        if(newcontr.Current_contract_expiration_date_3__c!=NULL)
        {
            datelist.add(newcontr.Current_contract_expiration_date_3__c);
        }
        if(newcontr.Current_contract_expiration_date_4__c!=NULL)
        {
            datelist.add(newcontr.Current_contract_expiration_date_4__c);
        }
        if(newcontr.Current_contract_expiration_date_5__c!=NULL)
        {
            datelist.add(newcontr.Current_contract_expiration_date_5__c);
        }
        
        if(!datelist.isEmpty())
        {
            datelist.sort();
            date minDate = datelist.get(0);
            newcontr.Date_current_Legal_Contract_expires__c = minDate;
        }

        /////// Conditional Check for the Details Tab Render fields starts here
        //LSLEVIN S-309031 5.7.2015 Start
        if('Expired'.equals(newcontr.Contract_Status__c)) {
            renewal_Pending_grid_display = true;
        }
        else{
            renewal_Pending_grid_display = false;
        }
        //LSLEVIN S-309031 5.6.2015 Stop
        //LSLEVIN S-309032 5.12.2015 Start
        /*
        if('Other'.equals(newcontr.Contract_Term__c)) {
            other_Contract_Descrip_grid_display = true;
        }
        else{
            other_Contract_Descrip_grid_display = false;
        }*/
         if(('Yes - Compulsory'.equals(newcontr.Contract_state_a_Small_Order_Fee_charge__c)) || ('Yes - Optional'.equals(newcontr.Contract_state_a_Small_Order_Fee_charge__c)) ) {
            small_Order_Fee_grid_display = true;
        }
        else{
            small_Order_Fee_grid_display = false;
        }
        if(('Yes - Compulsory'.equals(newcontr.Contract_state_a_furniture_delivery_fee__c)) || ('Yes - Optional'.equals(newcontr.Contract_state_a_furniture_delivery_fee__c)) ) {
            furniture_Delivery_Fee_grid_display = true;
        }
        else{
            furniture_Delivery_Fee_grid_display = false;
        }
        if(('Yes - Compulsory'.equals(newcontr.Dimension_fee_for_furn_charge_are_exclud__c)) || ('Yes - Optional'.equals(newcontr.Dimension_fee_for_furn_charge_are_exclud__c)) ) {
            exess_Dimension_Fee_grid_display = true;
        }
        else{
            exess_Dimension_Fee_grid_display = false;
        }
        if(('Yes - Compulsory'.equals(newcontr.Contract_state_Restocking_Fees_excluded__c)) ||  ('Yes - Optional'.equals(newcontr.Contract_state_Restocking_Fees_excluded__c)) ) {
            restocking_Fee_Language_grid_display = true;
        }
        else{
            restocking_Fee_Language_grid_display = false;
        }
        if(('Yes - Compulsory'.equals(newcontr.Contract_State_Minimum_Order__c)) || ('Yes - Optional'.equals(newcontr.Contract_State_Minimum_Order__c)) ) {
            minimum_Order_Value_grid_display = true;
        }
        else{
            minimum_Order_Value_grid_display = false;
        }
        //LSLEVIN S-309032 5.12.2015 Stop
        //deepak changes starts
        if ('Other'.equals(newContr.Payment_Terms__c))
            payment_term_other_display = true;
        else {
            payment_term_other_display = false;
            newContr.Payment_Term_Other__c = null;
        }
        if ('Yes'.equals(newContr.Is_there_a_clawback_provision__c))
            rebates_clawback_grid_display = true;
        else {
            rebates_clawback_grid_display = false;
            newContr.clawback_provision_language__c = null;
        }
        if ('Other'.equals(newcontr.Number_Of_Extensions__c))
            other_extension_display = true;
        else {
            newContr.Other_Extension_Number__c = null;
            other_extension_display = false;
        }
        if ('Other'.equals(newcontr.Duration_of_each_extension__c))
            other_duration_display = true;
        else {
            newContr.Other_extension_duration__c = null;
            other_duration_display = false;
        }
        if ('Yes'.equals(newcontr.Contract_Extensions__c) || 'Evergreen'.equals(newcontr.Contract_Extensions__c))
        {
            contract_extension_authorization_display = true;
        }
        else {
            other_extension_display = false;
            other_duration_display = false;
            newContr.Number_Of_Extensions__c = null;
            newContr.Duration_of_each_extension__c = null;
            contract_extension_authorization_display = false;
            //newContr.Contract_Extension_Authorization_Type__c = null;
            newContr.Extension_Terms__c = null;
            newContr.Other_Extension_Number__c = null;
            newContr.Other_extension_duration__c = null;
        }
        if ('Yes'.equals(newcontr.Contract_Extensions__c))
        {
            contract_extension_display = true;
        }
        else {
            newContr.Number_Of_Extensions__c = null;
            newContr.Duration_of_each_extension__c = null;
            contract_extension_display = false;
            other_extension_display = false;
            other_duration_display = false;
            //newContr.Extension_Terms__c = null;
            newContr.Contract_Extension_Authorization_Type__c = null;
            newContr.Other_Extension_Number__c = null;
            newContr.Other_extension_duration__c = null;
        }
        if ('Yes'.equals(newcontr.Contract_cover_NonCore_Cat_setup_pricing__c))
        {
            catalog_assortment_display = true;
        }
            
        else {
            catalog_assortment_display = false;
            newContr.Agreement_respon_based_on_cat_prod_assor__c = null;
            newcontr.Variable_NCC_discount__c=picklistdefaultValue('Contract','Variable_NCC_discount__c');
            newcontr.NCC_discount_basis__c=picklistdefaultValue('Contract','NCC_discount_basis__c'); 
            newcontr.Is_there_a_custom_NCC__c =picklistdefaultValue('Contract','Is_there_a_custom_NCC__c');
            //added by Pune team/Mohit for support #02469982
           newcontr.NCC_minimum_sell_price__c=picklistdefaultValue('Contract','NCC_minimum_sell_price__c');
          /* newcontr.Trigger__c=picklistdefaultValue('Contract','Trigger__c');
           newcontr.Sell_price__c=picklistdefaultValue('Contract','Sell_price__c');
           newcontr.Sell_price_un_named__c=picklistdefaultValue('Contract','Sell_price_un_named__c');
           newcontr.Trigger_un_named__c=picklistdefaultValue('Contract','Trigger_un_named__c'); */
        
        }
        
        //deepak changes ends
        if ( 'Parent Account'.equals(newcontr.Basis_Level_for_Customer_Agreement__c))
            details_parent_grid_display = true;
        else
        {
            details_parent_grid_display = false;
            newcontr.Parent_Account_Name__c=null;
            newcontr.Parent_Account_Number__c=null;
        }
        if ( 'Child Account'.equals(newcontr.Basis_Level_for_Customer_Agreement__c))
            details_child_grid_display = true;
        else
        {
            details_child_grid_display = false;
            newcontr.Child_Account_Name__c=null;
            newcontr.Child_Account_Number__c=null;
        }
        
        //----Added on 1st Aug----
        if ( 'None'.equals(newcontr.Contract_Status__c)){//Updated by Akanksha for story S-351420
            statusOptions27.clear();
            //START NSHARP S-334902 7.14.15 - removed Awaiting Information select option
            //statusOptions27.add(new SelectOption('Awaiting Information','Awaiting Information'));
            //END NSHARP S-334902 7.14.15
        }else if ( 'Active'.equals(newcontr.Contract_Status__c)){
            statusOptions27.clear();
            statusOptions27.add(new SelectOption('Active account','Active account'));
        }else if ( 'Closed/Cancelled'.equals(newcontr.Contract_Status__c)){
            statusOptions27.clear();
            statusOptions27.add(new SelectOption('Customer Terminated','Customer Terminated'));
            statusOptions27.add(new SelectOption('Lost Customer','Lost Customer'));
            //LSLEVIN S-309031 Added Below Line 5.7.2015
            statusOptions27.add(new SelectOption('New Agreement Executed','New Agreement Executed'));
        }else if ( 'Expired'.equals(newcontr.Contract_Status__c)){
            statusOptions27.clear();
            statusOptions27.add(new SelectOption('Agreement no longer in place','Agreement no longer in place'));
        }else{
            statusOptions27.clear();
            //START NSHARP S-334902 7.14.15 - removed Awaiting Information select option
            //statusOptions27.add(new SelectOption('Awaiting Information','Awaiting Information'));
            //END NSHARP S-334902 7.14.15
            statusOptions27.add(new SelectOption('Pending Signatures','Pending Signatures'));
            statusOptions27.add(new SelectOption('In Negotiation','In Negotiation'));
        }
        
        //--------End---------
        
        
        if ( 'Grandparent Account'.equals(newcontr.Basis_Level_for_Customer_Agreement__c))
            details_grandparent_grid_display = true;
        else
        {
            details_grandparent_grid_display = false;
            newcontr.Grandparent_Name__c=null;
            newcontr.Grandparent_Number__c=null;
        }
        if ( 'Tech Depot'.equals(newcontr.Basis_Level_for_Customer_Agreement__c))
            details_techdepot_grid_display = true;
        else
        {
            details_techdepot_grid_display = false;
            newcontr.Tech_Depot_Account_Name__c=null;
            newcontr.Tech_Depot_Account_Number__c=null;
        }
        if ( 'Stand-Alone'.equals(newcontr.Basis_Level_for_Customer_Agreement__c))
            details_standalone_grid_display = true;
        else
        {
            details_standalone_grid_display = false;
            newcontr.Stand_Alone_Account_Name__c = null;
            newcontr.Stand_Alone_Account_Number__c = null;
        }
        if ( 'Other'.equals(newcontr.Basis_Level_for_Customer_Agreement__c))
            details_other_grid_display = true;
        else
        {
            details_other_grid_display = false;
            newcontr.Prospect_Account_Name__c = null;
            newcontr.Prospect_Account_Number__c = null;
        }
        
        // Added as per Sprint 13 Case# 75108
        if (newcontr.Contract_data_verified__c == True)
            details_DataVerified_grid_display = true;
        else
        {
            details_DataVerified_grid_display = false;
            newcontr.Verified_date_time__c = null;
            newcontr.User_who_verified_data__c = null;
            newcontr.Verification_notes__c = null;
        }
        /////// Conditional Check for the Details Tab Render fields ends here
        
        if(newcontr.Agreement_allow_for_custom_cores__c!='Yes'){
            newcontr.Custom_core_item_count__c= null;
            //newcontr.Item_count_restrictions__c= null;
        }
        if(newcontr.Custom_core_item_count__c!='Yes'){
            system.debug('hiii---'+newcontr.Item_count_restrictions__c);
            newcontr.Item_count_restrictions__c= null;
            system.debug('hiii--1055-'+newcontr.Item_count_restrictions__c);
        }
        /////// Conditional Check for the Rebates/Incentives Tab Render fields starts here
        if ( 'Yes'.equals(newcontr.Are_there_Rebates_Incentives__c))
            rebates_incentive_grid_display = true;
        else
        {
            rebates_incentive_grid_display = false;
            rebates_penalties_grid_Display = false;
            rebates_clawback_grid_display = false;
            newcontr.Rebate_Incentive_Type__c = null;
            newcontr.Rebate_Description__c = null;
            newcontr.Penalties_for_late_Rebate_payment__c = null;
            newcontr.Rebate_Penalty_Description__c = null;
            newcontr.Clawback_Provision_Language__c = null;
            newcontr.Is_there_a_clawback_provision__c = null;
        }
        if ( 'Yes'.equals(newcontr.Penalties_for_late_Rebate_payment__c))
            rebates_penalties_grid_display = true;
        else
        {
            rebates_penalties_grid_display = false;
            newcontr.Rebate_Penalty_Description__c = null;
        }
        /////// Conditional Check for the Rebates/Incentives Tab Render fields ends here
        
        /////// Conditional Check for the Reports Tab Render fields starts here
        if ( 'Yes'.equals(newcontr.Reporting_Requirements_In_Legal_Agreemen__c))
        {
            reporting_requirement_grid_display = true;
            
        }
        else
        {
            reporting_requirement_grid_display = false;
            reporting_freq_other_grid_display = false;
            Reporting_penalties_grid_display = false;
            newcontr.Other_Report_Penalties_Description__c = null;
            newcontr.Reporting_Requirements__c = null;
            newcontr.Reporting_Penalties_for_late_reports__c = null;
            newcontr.Report_Description__c = null;
            newcontr.Report_Frequency__c = null;
            newcontr.Report_Frequency_Other__c = null;
             newcontr.Reporting_Penalties_for_late_reports__c =picklistdefaultValue('Contract','Reporting_Penalties_for_late_reports__c');
             newcontr.Report_Frequency__c =picklistdefaultValue('Contract','Report_Frequency__c');
        }
        if ('Other'.equals(newcontr.Report_Frequency__c))
        {
            reporting_freq_other_grid_display = true;
        }
        else
        {
            reporting_freq_other_grid_display = false;
            newcontr.Report_Frequency_Other__c = null;
        }
        /*LSLEVIN 5.11.2015 S-309038 Removed condition from IF Below
||(newcontr.Reporting_Penalties_for_late_reports__c == 'No/Contract Silent')
*/
        if((newcontr.Reporting_Penalties_for_late_reports__c == 'Yes'))
        {
            Reporting_penalties_grid_display = true;
        }
        else
        {
            Reporting_penalties_grid_display = false;
            newcontr.Other_Report_Penalties_Description__c = null;
        }
        /////// Conditional Check for the Reporting Tab Render fields ends here
        
        /////// Conditional Check for the Legal Tab Render fields starts here
        if('Yes'.equals(newcontr.Multi_Country_Agreement__c))
            legal_country_cov_display = true;
        else
        {
            legal_country_cov_display = false;
            newcontr.What_countries_are_covered__c = null;
        }
        
       
        
        //deepak changes start
        if(('Yes'.equals(newcontr.Have_Amendment_s_been_executed__c)))
        {
            legal_amendment_display = true;
        }
        else
        {
            legal_amendment_display = false;
            newcontr.Describe_number_of_Amendments__c = null;
            newContr.Effective_Date_Of_Current_Amendment__c = null;
        }
        //deepak changes end
        
        if('Yes'.equals(newcontr.Is_there_a_Most_Favored_Customer_claus__c))
            legal_fav_lang_display = true;
        else
        {
            legal_fav_lang_display = false;
            newcontr.Most_Favored_Contract_Language__c = null;
        }
        if('Yes'.equals(newcontr.Agreement_respon_based_on_cat_prod_assor__c))
            legal_cat_product_display = true;
        else
        {
            legal_cat_product_display = false;
            newcontr.Catalog_Product_Assortment__c = null;
        }
        if('Yes'.equals(newcontr.Does_contract_have_provisions_for_an_emp__c))
            legal_cont_prov_display = true;
        else
        {
            legal_cont_prov_display = false;
            newcontr.Emp_Pricing_tied_to_Cust_Pricing__c = null;
            newcontr.Specific_lang_on_the_contract_on_emp_pgm__c = null;
            newcontr.Do_employee_purchases_go_toward_rebates__c = null;
        }
     /*   if('Yes'.equals(newcontr.Performance_Notification_Req_in_contract__c))
        {
            PerformanceNotificationRequirements_getPicklistvalues();
            legal_performance_display = true;          
        }            
        else
        {
            legal_performance_display = false;
            newcontr.Performance_Notification_Requirements__c = null;
            newcontr.Penalties_for_not_meeting_Perf_Notifi_Re__c = null;
            newcontr.Lang_in_contract_for_Perf_Notif_Requirem__c = null;
            //02217021 Start
            newcontr.TextBox_1__c= null;
            newcontr.TextBox_2__c= null;
            newcontr.TextBox_3__c= null;
            newcontr.TextBox_1_Yes__c=false;
            newcontr.TextBox_2_Yes__c=false;
            newcontr.TextBox_3_Yes__c=false;
            newcontr.TextBox_1_Penalty__c=false;
            newcontr.TextBox_2_Penalty__c=false;
            newcontr.TextBox_3_Penalty__c=false;
            
             //02217021 End
        } */
        if(newcontr.Are_there_Minority_Spend_Requirements__c == 'Yes')
            Minority_Requirements_display = true;
        else
        {
            Minority_Requirements_display = false;
            newcontr.Minority_Spend_Requirements_Language__c = null;
            newcontr.What_of_Spend_Dollar__c = null;
            newcontr.What_of_spend__c = null;
        }
        /////// Conditional Check for the Legal Tab Render fields ends here
        
        /////// Conditional Check for the Pricing Tab Render fields starts here
        Written_Agreement_allow_GP_Custom_Cores_Display = false;
        if(newcontr.Written_Agreement_allow_GP_Custom_Cores__c == 'Yes')
            Written_Agreement_allow_GP_Custom_Cores_Display = true;
        else
        {
            Written_Agreement_allow_GP_Custom_Cores_Display = false;
            Cust_Notif_to_change_Pricing_on_GP_Core_Display = false;
            GP_Core_List_have_Capped_Price_Increase_Display = false;
            GP_Core_List_Capped_Price_Increase_Display = false;
            GP_Core_List_SKU_Capped_Price_Increase_Display = false;
            GP_Core_List_SKU_Capped_Price_Increase_per_Display = false;
            Are_there_GP_SKU_Count_Limitations_Display =false;
            GP_Annual_Spend_Requirement_Display = false;
            GP_Custom_Core_Discount_Basis_Display = false;
            Floors_permitted_in_GP_Cust_Core_Display = false;
            GP_Cus_Core_List_Update_Notice_Period_Display = false;
            GP_Pricing_Update_Frequency_display = false;
            GP_Cost_Plus_Language_display = false;
            newcontr.GP_Cus_Core_List_Upd_Notice_Period_Other__c = null;
            newcontr.GP_Custom_Core_Written_Agreement_Languag__c = null;
            newcontr.GP_Pricing_Update_Frequency__c = null;
            newcontr.GP_Pricing_Update_Frequency_other__c = null;
            newcontr.GP_Manufac_Vendor_letter_req_for_Increas__c = null;
            newcontr.GP_decr_req_to_be_applied_to_Cust_Core__c = null;
            newcontr.Cust_Notif_to_change_Pricing_on_GP_Core__c = null;
            newcontr.GP_Cust_Core_List_Update_Notice_Type__c = null;
            newcontr.GP_Cus_Core_List_Update_Notice_Period__c = null;
            newcontr.GP_Core_List_have_Capped_Price_Increase__c = null;
            newcontr.GP_Core_List_Capped_Price_Increase__c = null;
            newcontr.GP_Core_List_SKU_Capped_Price_Increase__c = null;
            newcontr.GP_SKU_Cap_Dollar_Amount__c = null;
            newcontr.GP_SKU_Cap_Percent_Amount__c = null;
            newcontr.Are_there_GP_SKU_Count_Limitations__c = null;
            newcontr.GP_SKU_Count_Limitation__c = null;
            //newcontr.GP_Annual_Spend_Requirement__c = null;
            newcontr.GP_Annual_Spend_Requirement_Amount__c = null;
            newcontr.GP_Annual_Spend_Description__c = null;
            newcontr.GP_Custom_Core_Discount_Basis__c = null;
            newcontr.GP_Custom_Core_Discount_Percent__c = null;
            newcontr.Floors_permitted_in_GP_Cust_Core__c = null;
            newcontr.GP_Floor_Structure_Description__c = null;
            newcontr.GP_Cost_Plus_Language__c = null;
        }
        /*LSLEVIN S-309036 5.13.2015 Start*/
        if(newContr.Call_Out_Auto_Force_Sub__c == 'Yes'){
            Pricing_Call_Out_AutoSub_Language_Display = true;
        }
        else {
            Pricing_Call_Out_AutoSub_Language_Display = false;
        }
        if(newContr.Call_Out_Cost_Plus_Floor__c == 'Yes'){
            Pricing_Call_Out_CostPlus_FloorType_Display = true;
        }
        else {
            Pricing_Call_Out_CostPlus_FloorType_Display = false;
        }
        if(newContr.Contract_have_req_for_prop_items__c == 'Yes'){
            Proprietry_Items_Display = true;
        }
        else {
            Proprietry_Items_Display = false;
        }
        if(newContr.Vendor_Funded_Core_Specificall__c == 'Yes'){
            Vendor_Funded_Language_Display = true;
            Vendor_Funded_Language_No_Display = false;
        }
        else {
            Vendor_Funded_Language_Display = false;
            if(newcontr.Vendor_Funded_Core_Specificall__c == 'No') {
                Vendor_Funded_Language_No_Display = true;
            }
        }
        if(newContr.Minimum_Annual_Spend_Commitment__c == 'Yes'){
            Minimum_Annual_Spend_Threshold_Display = true;
        }
        else {
            Minimum_Annual_Spend_Threshold_Display = false;
        }
        /*LSLEVIN S-309036 5.13.2015 Stop*/
        //---Starts----Added on 16th July---
        Written_Agreement_allow_Standalone_Custom_Cores_Display = false;
        if(newcontr.Written_Agreement_allow_Standalone__c == 'Yes')
            Written_Agreement_allow_Standalone_Custom_Cores_Display = true;
        else
        {
            Written_Agreement_allow_Standalone_Custom_Cores_Display = false;
            Cust_Notif_to_change_Pricing_on_Standalone_Core_Display = false;
            Standalone_Core_List_have_Capped_Price_Increase_Display = false;
            Standalone_Core_List_Capped_Price_Increase_Display = false;
            Standalone_Core_List_SKU_Capped_Price_Increase_Display = false;
            Standalone_Core_List_SKU_Capped_Price_Increase_per_Display = false;
            Are_there_Standalone_SKU_Count_Limitations_Display =false;
            Standalone_Annual_Spend_Requirement_Display = false;
            Standalone_Custom_Core_Discount_Basis_Display = false;
            Floors_permitted_in_Standalone_Cust_Core_Display = false;
            Standalone_Cus_Core_List_Update_Notice_Period_Display = false;
            Standalone_Pricing_Update_Frequency_display = false;
            Standalone_Pricing_Update_Frequency_grid = false;
            
            newcontr.Standalone_Core_List_Upd_Notice_Period__c = null;
            newcontr.Standalone_Custom_Core_Written_Agreement__c = null;
            newcontr.Standalone_Pricing_Update_Frequency__c = null;
            newcontr.Standalone_Pricing_Update_FrequencyOther__c = null;
            newcontr.Standalone_Manufac_Vendor_letter_req__c = null;
            newcontr.Standalonedecr_req_to_be_applied_to_Cust__c = null;
            newcontr.Cust_Notif_to_change_Pricingon_Standalon__c = null;
            newcontr.Standalone_Cust_Core_List_Update_Notice__c = null;
            newcontr.StandaloneCore_List_Update_Notice_Period__c = null;
            newcontr.Standalone_Core_List_have_Capped_Price__c = null;
            newcontr.StandalonCore_List_Capped_Price_Increase__c = null;
            newcontr.Standalone_Core_List_SKU_Capped_Price__c = null;
            newcontr.Standalone_SKU_Cap_Amount__c = null;
            //newcontr.GP_SKU_Cap_Percent_Amount__c = null;
            newcontr.Are_there_Standalone_SKU_Count_Limit__c = null;
            newcontr.Standalone_SKU_Count_Limitation__c = null;
            newcontr.Standalone_Annual_Spend_Requirement__c = null;
            newcontr.Standalone_Annual_Spend_Requirement_Amt__c = null;
            newcontr.Standalone_Annual_Spend_Description__c = null;
            newcontr.Standalone_Custom_Core_Discount_Basis__c = null;
            newcontr.Standalone_Custom_Core_Discount_Percent__c = null;
            newcontr.Floors_permitted_in_Standalone_Cust_Core__c = null;
            newcontr.Standalone_Floor_Structure_Description__c = null;
        }
        //------End-----
        Written_Agreement_allow_Child_Cust_Cores_Display = false;
        if(newcontr.Written_Agreement_allow_Child_Cust_Cores__c == 'Yes')
            Written_Agreement_allow_Child_Cust_Cores_Display = true;
        else
        {
            Written_Agreement_allow_Child_Cust_Cores_Display = false;
            Cust_Notif_to_chg_Pricing_on_Child_Core_Display = false;
            Child_Cust_Core_Upd_Notice_Period_Display = false;
            Child_Core_have_Capped_Price_Increase_Display = false;
            Child_Core_List_Capped_Price_Increase_Display = false;
            Child_Core_SKU_Level_Capped_Price_Incr_Display = false;
            Child_Core_SKU_Level_Capped_Price_Incr_per_Display = false;
            Are_there_Child_SKU_Count_Limits_Display = false;
            Child_Annual_Spend_Requirement_Display = false;
            Child_Custom_Core_Discount_Basis_Display = false;
            Floors_permitted_in_Child_Cust_Core_Display = false;
            Child_Pricing_Update_Frequency_Display = false;
            newcontr.Apply_Child_Core_Written_Agree_Lang__c = null;
            newcontr.Child_Pricing_Update_Frequency__c = null;
            newcontr.Child_Pricing_Update_Frequency_Other__c = null;
            newcontr.Child_Man_Ven_letter_req_for_Increase__c = null;
            newcontr.Child_decr_req_to_be_applied_to_Cus_Core__c = null;
            newcontr.Cust_Notif_to_chg_Pricing_on_Child_Core__c = null;
            newcontr.Child_Cust_Core_Update_Notice_Type__c = null;
            newcontr.Child_Cust_Core_Upd_Notice_Period__c = null;
            newcontr.Child_Cust_Core_Upd_Notice_Period_Other__c = null;
            newcontr.Child_Core_have_Capped_Price_Increase__c = null;
            newcontr.Child_Core_List_Capped_Price_Increase__c = null;
            newcontr.Child_Core_SKU_Level_Capped_Price_Incr__c = null;
            newcontr.Child_SKU_Cap_Dollar_Amount__c = null;
            newcontr.Child_SKU_Cap_Percent_Amount__c = null;
            newcontr.Are_there_Child_SKU_Count_Limits__c = null;
            newcontr.Child_SKU_Count_Limitation__c = null;
            //newcontr.Child_Annual_Spend_Requirement__c = null;
            newcontr.Child_Annual_Spend_Requirement_Amount__c = null;
            newcontr.Child_Annual_Spend_Description__c = null;
            newcontr.Child_Custom_Core_Discount_Basis__c = null;
            newcontr.Child_Custom_Core_Discount_Percent__c = null;
            newcontr.Floors_permitted_in_Child_Cust_Core__c = null;
            newcontr.Child_Floor_Structure_Description__c = null;
            
        }
        
        if(newcontr.Notification_process_for_disco_items__c == 'Yes'){
            //Notification_process_for_disco_items_Display = true;
            Notification_time_for_disco_items_Display = true;
        }else
        {
            // Notification_process_for_disco_items_Display = false;
            Notification_time_for_disco_items_Display = false;
            //newcontr.Notification_time_for_disco_items__c = null;
            newcontr.Notification_time_disco_items_Other__c = null;
        }
        //LSLEVIN 5.13.2015 S-309036 Updated If Below
        //Connor Flynn Case 00125363 added && catalog_assortment_display as a condition
        if((newcontr.Is_there_a_custom_NCC__c == 'Yes') || (newContr.Is_there_a_custom_NCC__c == 'Custom') && catalog_assortment_display){
            Is_there_a_custom_NCC_Display = true;
        }else
        {
            Is_there_a_custom_NCC_Display = false;
            newcontr.How_frequently_can_the_pricing_on_the_cu__c = null;
        }
        
        /*Custom_Non_Core_Catalog_Display = false;
if(newcontr.Custom_Non_Core_Catalog__c == 'Yes')
Custom_Non_Core_Catalog_Display = true;
else
{
Custom_Non_Core_Catalog_Display = false;
Flrs_permitted_in_Cust_NonCore_Cat_struc_Display = false;
Custom_Non_Core_Catalog_Discount_Basis_Display = false;
newcontr.Decr_req_to_be_applied_to_NonCore_Cat__c = null;
newcontr.Flrs_permitted_in_Cust_NonCore_Cat_struc__c = null;
newcontr.What_floor_permitted_on_Cust_NonCore_Cat__c = null;
newcontr.Custom_Non_Core_Catalog_Discount_Basis__c = null;
newcontr.WAPO_Mark_Up_Percent__c = null;
}*/
        
        Cust_notif_to_chg_Cust_NonCore_Cat_Prcin_Display = false;
        if(newcontr.Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c == 'Yes')
            Cust_notif_to_chg_Cust_NonCore_Cat_Prcin_Display = true;
        else
        {
            Cust_notif_to_chg_Cust_NonCore_Cat_Prcin_Display = false;
            NonCore_Cat_Update_Notice_Period_Display = false;
            newcontr.NonCore_Cat_Update_Notice_Period__c = null;
            newcontr.NonCore_Cat_Update_Notice_Period_Other__c = null;
            newcontr.NonCore_Catalog_Update_Notice_Type__c = null;
            newcontr.NonCore_Cat_Update_Acceptance_process__c = null;
        }
        
        Floors_permitted_in_OffContr_Whlsler_str_Display = false;
        if(newcontr.Floors_permitted_in_OffContr_Whlsler_str__c == 'Yes')
            Floors_permitted_in_OffContr_Whlsler_str_Display = true;
        else
        {
            Floors_permitted_in_OffContr_Whlsler_str_Display = false;
            newcontr.Floor_for_OffContract_Structure__c = null;
        }
        
        OffContract_Pricing_specified_in_contrac_Display = false;
        if(newcontr.OffContract_Pricing_specified_in_contrac__c == 'Yes')
            OffContract_Pricing_specified_in_contrac_Display = true;
        else
        {
            OffContract_Pricing_specified_in_contrac_Display = false;
            newcontr.OffContract_Pricing_Structure__c = null;
            newcontr.OffContract_Lang_in_agreement__c = null;
        }
        
        Wholesaler_Pricing_specified_in_contract_Display = false;
        if(newcontr.Wholesaler_Pricing_specified_in_contract__c == 'Yes')
            Wholesaler_Pricing_specified_in_contract_Display = true;
        else
        {
            Wholesaler_Pricing_specified_in_contract_Display = false;
            newcontr.Wholesaler_Pricing_Structure__c = null;
            newcontr.Wholesaler_Lang_in_agreement__c = null;
        }
        
        GP_Floor_specified_in_contract_Display = false;
        if(newcontr.GP_Floor_specified_in_contract__c == 'Yes')
            GP_Floor_specified_in_contract_Display = true;
        else
        {
            GP_Floor_specified_in_contract_Display = false;
            Cost_Language_included_in_agreement_Display = false;
            newcontr.Cost_Language_included_in_agreement__c = null;
            newcontr.Provide_Cost_Language_in_agreement__c = null;
        }
        
        Work_with_Tier_1_partner_on_this_account_Display = false;
        if(newcontr.Work_with_Tier_1_partner_on_this_account__c == 'Yes')
            Work_with_Tier_1_partner_on_this_account_Display = true;
        else
        {
            Work_with_Tier_1_partner_on_this_account_Display = false;
            //Modified By Vipul Jain for Story#S-457176 (00899739 - Tier 1: Story 20 Account-Level CSF Changes) on December 30,2016
            //newcontr.Name_of_Tier_1_Partner__c = null;
            //newcontr.Tier_1_fees_paid__c = null;
            //END -Vipul
        }
         
        //Modified By Vipul Jain for Story#S-457176 (00899739 - Tier 1: Story 20 Account-Level CSF Changes) on December 30,2016
        Work_with_2_or_3_party_agreement = false;
        if(newcontr.Is_this_a_2_party_or_3_party_agreement__c == '2 - party (OD & Customer)') {
            Work_with_2_or_3_party_agreement= true;
        }
        else if(newcontr.Is_this_a_2_party_or_3_party_agreement__c == '2 - party (OD & Diversity Partner/Reseller)'){
            Work_with_2_or_3_party_agreement= true;
        }
        else if(newcontr.Is_this_a_2_party_or_3_party_agreement__c == '3 - party'){
            Work_with_2_or_3_party_agreement= true;
            
        }
        else{
            Work_with_2_or_3_party_agreement = false;
        }
        //End-Vipul
        
        //Modified By Asif Khan for Story #NAIT-113608 on Jan 23,2020
        Deviated_Pricing_offered_to_Customer_Display = false;
        if(newcontr.Deviated_Pricing_offered_to_Customer__c == 'Yes')
            Deviated_Pricing_offered_to_Customer_Display = true;
        else
        {
            Deviated_Pricing_offered_to_Customer_Display = false;
            newcontr.Specifics_of_the_Deviated_Cost_offering__c = null;
            Vendor_Funded_Language_Display = false;
            Vendor_Funded_Language_No_Display = false;
        }
        
        Minimum_Annual_Spend_Commitment_Display = false;
        if(newcontr.Minimum_Annual_Spend_Commitment__c == 'Yes')
            Minimum_Annual_Spend_Commitment_Display = true;
        else
        {
            Minimum_Annual_Spend_Commitment_Display = false;
            newcontr.Min_Annual_Spend_Comm_contract_lang_amt__c = null;
            newcontr.OD_adjust_Cust_Prcing_if_Spend_not_met__c = null;
        }
        //------Added on 16th july----
        Core_Spend_Volume_Threshold_for_Pricing = false;
        if(newcontr.Does_written_agreement_allow_for_price__c == 'Yes')
            Core_Spend_Volume_Threshold_for_Pricing = true;
        else
        {
            Core_Spend_Volume_Threshold_for_Pricing = false;
            //newcontr.Does_written_agreement_allow_for_price__c = null;
            newcontr.Core_Spend_Volume_Threshold_for_Pricing__c = null;
        }
        Agreement_provide_disco_on_spec = false;
        if(newcontr.Agreement_provide_disco_on_spec_orders__c == 'Yes')
            Agreement_provide_disco_on_spec = true;
        else
        {
            Agreement_provide_disco_on_spec = false;
            newcontr.Special_Order_Discount_Language__c = null;
        }
        //-----End----
        
        
        
        //NAIT-1753 Miles Robson Marketing status check
       /* if(newcontr.Marketing_Status__c == 'Yes')
        {
            marketing_substatuses_grid_display = true;
        }
        else
        {
            marketing_substatuses_grid_display = false;
            //        newcontr.Marketing_Direct_Mail_Status__c = 'No';          Melissa Mann
            //        newcontr.Marketing_Email_Status__c = 'No';                Melissa Mann
            //        newcontr.Marketing_Phone_Status__c = 'No';                Melissa Mann
            //NAIT-1753 Resetting fields to no if Marketing Status on no
        } */
        //NAIT-1753 Miles Robson Marketing status check ends
        
        
        //Melissa Mann TestMarketing_Status__c
        //if(newcontr.TestMarketing_Status__c == 'Yes')
        //    {
        //        marketing_substatuses_grid_display = true;
        //    }
        //    else
        //    {
        //        marketing_substatuses_grid_display = false;
        //    }
        //Melissa Mann      TestMarketing_Status__c
       if ('Yes'.equals(newcontr.NCC_minimum_sell_price__c))
       {
           
           
       } else{
           newcontr.Trigger__c=picklistdefaultValue('Contract','Trigger__c');
           newcontr.Sell_price__c=picklistdefaultValue('Contract','Sell_price__c');
           newcontr.Sell_price_un_named__c=picklistdefaultValue('Contract','Sell_price_un_named__c');
           newcontr.Trigger_un_named__c=picklistdefaultValue('Contract','Trigger_un_named__c');  
           
       }
        if ('Yes'.equals(newcontr.Are_there_Rebates_Incentives__c))
       {
           
           
       } else{
           
           newcontr.Penalties_for_late_Rebate_payment__c =picklistdefaultValue('Contract','Penalties_for_late_Rebate_payment__c');
           newcontr.Is_there_a_clawback_provision__c =picklistdefaultValue('Contract','Is_there_a_clawback_provision__c');
            
           
       }
                  
    }
    public void GP_Custom_Core_Discount_Basis_grid()
    {
        GP_Custom_Core_Discount_Basis_Display = false;
        GP_Cost_Plus_Language_Display = false;
        if(newcontr.GP_Custom_Core_Discount_Basis__c == 'WAPO Mark-Up')
            GP_Custom_Core_Discount_Basis_Display = true;
        else if(newcontr.GP_Custom_Core_Discount_Basis__c == 'Yes')
            GP_Cost_Plus_Language_Display = true;
        else
        {
            GP_Custom_Core_Discount_Basis_Display = false;
            GP_Cost_Plus_Language_Display =false;
            newcontr.GP_Custom_Core_Discount_Percent__c = null;
            newcontr.GP_Cost_Plus_Language__c = null;
        }
    }
    
    public void Floors_permitted_in_GP_Cust_Core_grid()
    {
        Floors_permitted_in_GP_Cust_Core_Display = false;
        if(newcontr.Floors_permitted_in_GP_Cust_Core__c == 'Yes')
            Floors_permitted_in_GP_Cust_Core_Display = true;
        else
        {
            Floors_permitted_in_GP_Cust_Core_Display = false;
            newcontr.GP_Floor_Structure_Description__c = null;
        }
    }
    
    public void Cust_Notif_to_chg_Pricing_on_Par_Core_grid()
    {
        Cust_Notif_to_chg_Pricing_on_Par_Core_Display = false;
        if(newcontr.Cust_Notif_to_chg_Pricing_on_Par_Core__c == 'Notification Required')
            Cust_Notif_to_chg_Pricing_on_Par_Core_Display = true;
        else
        {
            Cust_Notif_to_chg_Pricing_on_Par_Core_Display = false;
            Par_Cust_Core_List_Update_Notice_Period_Display = false;
            newcontr.Par_Cus_Core_List_Upd_Notice_Per_Other__c = null;
            newcontr.Par_Cust_Core_List_Update_Notice_Type__c = null;
            newcontr.Par_Cust_Core_List_Update_Notice_Period__c = null;
        }
    }
    
    public void Par_Core_have_Capped_Price_Increase_grid()
    {
        Par_Core_have_Capped_Price_Increase_Display = false;
        if(newcontr.Par_Core_have_Capped_Price_Increase__c == 'Yes')
            Par_Core_have_Capped_Price_Increase_Display = true;
        else
        {
            Par_Core_have_Capped_Price_Increase_Display = false;
            Par_Core_List_Capped_Price_Increase_Display = false;
            Par_Core_SKU_Level_Capped_Price_Incr_Display = false;
            Par_Core_SKU_Level_Capped_Price_Incr_per_Display = false;
            newcontr.Par_Core_List_Capped_Price_Increase__c = null;
            newcontr.Par_Core_SKU_Level_Capped_Price_Incr__c = null;
            newcontr.Par_SKU_Cap_Dollar_Amount__c = null;
            newcontr.Par_SKU_Cap_Percent_Amount__c = null;
        }
    }
    
    public void Par_Core_List_Capped_Price_Increase_grid()
    {
        Par_Core_List_Capped_Price_Increase_Display = false;
        if(newcontr.Par_Core_List_Capped_Price_Increase__c == 'SKU Level')
            Par_Core_List_Capped_Price_Increase_Display = true;
        else
        {
            Par_Core_List_Capped_Price_Increase_Display = false;
            Par_Core_SKU_Level_Capped_Price_Incr_Display = false;
            Par_Core_SKU_Level_Capped_Price_Incr_per_Display = false;
            newcontr.Par_Core_List_Capped_Price_Increase__c = null;
            newcontr.Par_Core_SKU_Level_Capped_Price_Incr__c = null;
            newcontr.Par_SKU_Cap_Dollar_Amount__c = null;
            newcontr.Par_SKU_Cap_Percent_Amount__c = null;
        }
    }
    
    public void Are_there_Parent_SKU_Count_Limitations_grid()
    {
        Are_there_Parent_SKU_Count_Limitations_Display = false;
        if(newcontr.Are_there_Parent_SKU_Count_Limitations__c == 'Yes')
            Are_there_Parent_SKU_Count_Limitations_Display = true;
        else
        {
            Are_there_Parent_SKU_Count_Limitations_Display = false;
            Parent_Annual_Spend_Requirement_Display = false;
            newcontr.Parent_SKU_Count_Limitation__c = null;
            //newcontr.Parent_Annual_Spend_Requirement__c = null;
            newcontr.Par_Annual_Spend_Requirement_Amount__c = null;
            newcontr.Parent_Annual_Spend_Description__c = null;
        }
    }
    
    public void Parent_Annual_Spend_Requirement_grid()
    {
        Parent_Annual_Spend_Requirement_Display = false;
        /*if(newcontr.Parent_Annual_Spend_Requirement__c == 'Yes')
Parent_Annual_Spend_Requirement_Display = true;
else
{
Parent_Annual_Spend_Requirement_Display = false;
newcontr.Par_Annual_Spend_Requirement_Amount__c = null;
newcontr.Parent_Annual_Spend_Description__c = null;
}*/
    }
    
    public void Parent_Custom_Core_Discount_Basis_grid()
    {
        Parent_Custom_Core_Discount_Basis_Display = false;
        if(newcontr.Parent_Custom_Core_Discount_Basis__c == 'WAPO Mark-Up')
            Parent_Custom_Core_Discount_Basis_Display = true;
        else
        {
            Parent_Custom_Core_Discount_Basis_Display = false;
            newcontr.Parent_Custom_Core_Discount_Percent__c = null;
        }
    }
    
    public void Floors_permitted_in_Par_Cust_Core_List_grid()
    {
        Floors_permitted_in_Par_Cust_Core_List_Display = false;
        if(newcontr.Floors_permitted_in_Par_Cust_Core_List__c == 'Yes')
            Floors_permitted_in_Par_Cust_Core_List_Display = true;
        else
        {
            Floors_permitted_in_Par_Cust_Core_List_Display = false;
            newcontr.Parent_Floor_Structure_Description__c = null;
        }
    }
    
    public void Cust_Notif_to_chg_Pricing_on_Child_Core_grid()
    {
        Cust_Notif_to_chg_Pricing_on_Child_Core_Display = false;
        if(newcontr.Cust_Notif_to_chg_Pricing_on_Child_Core__c == 'Notification Required')
            Cust_Notif_to_chg_Pricing_on_Child_Core_Display = true;
        else
        {
            Cust_Notif_to_chg_Pricing_on_Child_Core_Display = false;
            Child_Cust_Core_Upd_Notice_Period_Display = false;
            newcontr.Child_Cust_Core_Upd_Notice_Period_Other__c = null;
            newcontr.Child_Cust_Core_Update_Notice_Type__c = null;
            newcontr.Child_Cust_Core_Upd_Notice_Period__c = null;
            
        }
    }
    
    public void Child_Core_have_Capped_Price_Increase_grid()
    {
        Child_Core_have_Capped_Price_Increase_Display = false;
        if(newcontr.Child_Core_have_Capped_Price_Increase__c == 'Yes')
            Child_Core_have_Capped_Price_Increase_Display = true;
        else
        {
            Child_Core_have_Capped_Price_Increase_Display = false;
            Child_Core_List_Capped_Price_Increase_Display = false;
            Child_Core_SKU_Level_Capped_Price_Incr_Display = false;
            Child_Core_SKU_Level_Capped_Price_Incr_per_Display = false;
            newcontr.Child_Core_List_Capped_Price_Increase__c = null;
            newcontr.Child_Core_SKU_Level_Capped_Price_Incr__c = null;
            newcontr.Child_SKU_Cap_Dollar_Amount__c = null;
            newcontr.Child_SKU_Cap_Percent_Amount__c = null;
        }
    }
    
    public void Child_Core_List_Capped_Price_Increase_grid()
    {
        Child_Core_List_Capped_Price_Increase_Display = false;
        if(newcontr.Child_Core_List_Capped_Price_Increase__c == 'SKU Level')
            Child_Core_List_Capped_Price_Increase_Display = true;
        else
        {
            Child_Core_List_Capped_Price_Increase_Display = false;
            Child_Core_SKU_Level_Capped_Price_Incr_Display = false;
            Child_Core_SKU_Level_Capped_Price_Incr_per_Display = false;
            newcontr.Child_Core_SKU_Level_Capped_Price_Incr__c = null;
            newcontr.Child_SKU_Cap_Dollar_Amount__c = null;
            newcontr.Child_SKU_Cap_Percent_Amount__c = null;
        }
    }
    
    public void Are_there_Child_SKU_Count_Limits_grid()
    {
        Are_there_Child_SKU_Count_Limits_Display = false;
        if(newcontr.Are_there_Child_SKU_Count_Limits__c == 'Yes')
            Are_there_Child_SKU_Count_Limits_Display = true;
        else
        {
            Are_there_Child_SKU_Count_Limits_Display = false;
            Child_Annual_Spend_Requirement_Display = false;
            newcontr.Child_SKU_Count_Limitation__c = null;
            //newcontr.Child_Annual_Spend_Requirement__c = null;
            newcontr.Child_Annual_Spend_Requirement_Amount__c = null;
            newcontr.Child_Annual_Spend_Description__c = null;
        }
    }
    
    public void Child_Annual_Spend_Requirement_grid()
    {
        Child_Annual_Spend_Requirement_Display = false;
        /*if(newcontr.Child_Annual_Spend_Requirement__c == 'Yes')
Child_Annual_Spend_Requirement_Display = true;
else
{
Child_Annual_Spend_Requirement_Display = false;
newcontr.Child_Annual_Spend_Requirement_Amount__c = null;
newcontr.Child_Annual_Spend_Description__c = null;
}*/
    }
    
    public void Child_Custom_Core_Discount_Basis_grid()
    {
        Child_Custom_Core_Discount_Basis_Display = false;
        if(newcontr.Child_Custom_Core_Discount_Basis__c == 'WAPO Mark-Up')
            Child_Custom_Core_Discount_Basis_Display = true;
        else
        {
            Child_Custom_Core_Discount_Basis_Display = false;
            newcontr.Child_Custom_Core_Discount_Percent__c = null;
        }
    }
    
    public void Floors_permitted_in_Child_Cust_Core_grid()
    {
        Floors_permitted_in_Child_Cust_Core_Display = false;
        if(newcontr.Floors_permitted_in_Child_Cust_Core__c == 'Yes')
            Floors_permitted_in_Child_Cust_Core_Display = true;
        else
        {
            Floors_permitted_in_Child_Cust_Core_Display = false;
            newcontr.Child_Floor_Structure_Description__c = null;
        }
    }
    
    public void Cost_Language_included_in_agreement_grid()
    {
        Cost_Language_included_in_agreement_Display = false;
        if(newcontr.Cost_Language_included_in_agreement__c == 'Yes')
            Cost_Language_included_in_agreement_Display = true;
        else
        {
            Cost_Language_included_in_agreement_Display = false;
            newcontr.Provide_Cost_Language_in_agreement__c = null;
        }
    }
    
    public void NonCore_Cat_Update_Notice_Period_grid()
    {
        NonCore_Cat_Update_Notice_Period_Display = false;
        if(newcontr.NonCore_Cat_Update_Notice_Period__c == 'Other')
            NonCore_Cat_Update_Notice_Period_Display = true;
        else
        {
            NonCore_Cat_Update_Notice_Period_Display = false;
            newcontr.NonCore_Cat_Update_Notice_Period_Other__c = null;
        }
    }
    public void NonCore_Catalog_Update_Frequency_grid()
    {
        NonCore_Catalog_Update_Frequency_Display = false;
        if(newcontr.NonCore_Catalog_Update_Frequency__c == 'Other')
            NonCore_Catalog_Update_Frequency_Display = true;
        else
        {
            NonCore_Catalog_Update_Frequency_Display = false;
            newcontr.Non_Core_Catalog_Update_Frequency_Other__c = null;
        }
    }
    
    //START NSHARP CASE 00130611 8.12.15
    //public void Custom_Non_Core_Catalog_Discount_Basis_grid()
    //{
    //Custom_Non_Core_Catalog_Discount_Basis_Display = false;
    //if(newcontr.Custom_Non_Core_Catalog_Discount_Basis__c == 'WAPO Mark-Up')
    //Custom_Non_Core_Catalog_Discount_Basis_Display = true;
    //else
    //{
    //Custom_Non_Core_Catalog_Discount_Basis_Display = false;
    //newcontr.WAPO_Mark_Up_Percent__c = null;
    //}
    //}
    //END NSHARP CASE 00130611 8.12.15
    
    public void Flrs_permitted_in_Cust_NonCore_Cat_struc_grid()
    {
        Flrs_permitted_in_Cust_NonCore_Cat_struc_Display = false;
        if(newcontr.Flrs_permitted_in_Cust_NonCore_Cat_struc__c == 'Yes')
            Flrs_permitted_in_Cust_NonCore_Cat_struc_Display = true;
        else
        {
            Flrs_permitted_in_Cust_NonCore_Cat_struc_Display = false;
            newcontr.What_floor_permitted_on_Cust_NonCore_Cat__c = null;
        }
    }
    
    public void Price_Decrease_Language_grid()
    {
        Price_Decrease_Language_Display =false;
        system.debug('Price_Decrease1**'+Price_Decrease_Language_Display);
        if(newcontr.Decr_req_to_be_applied_to_NonCore_Cat__c == 'Yes'){
            system.debug('Price_Decrease2**'+Price_Decrease_Language_Display);
            Price_Decrease_Language_Display =true;
            system.debug('Price_Decrease3**'+Price_Decrease_Language_Display);
        }
        else{
            Price_Decrease_Language_Display =false;
            newcontr.Price_Decrease_Language__c = null;
        }
        
    }
    
    public void Written_Agreement_allow_Parent_Cust_Core_grid()
    {
        Written_Agreement_allow_Parent_Cust_Core_Display = false;
        if(newcontr.Written_Agreement_allow_Parent_Cust_Core__c == 'Yes')
            Written_Agreement_allow_Parent_Cust_Core_Display = true;
        else
        {
            Written_Agreement_allow_Parent_Cust_Core_Display = false;
            Cust_Notif_to_chg_Pricing_on_Par_Core_Display = false;
            Par_Core_have_Capped_Price_Increase_Display = false;
            Par_Core_List_Capped_Price_Increase_Display = false;
            Par_Core_SKU_Level_Capped_Price_Incr_Display = false;
            Par_Core_SKU_Level_Capped_Price_Incr_per_Display = false;
            Are_there_Parent_SKU_Count_Limitations_Display =false;
            Parent_Annual_Spend_Requirement_Display = false;
            Parent_Custom_Core_Discount_Basis_Display = false;
            Floors_permitted_in_Par_Cust_Core_List_Display = false;
            Par_Cust_Core_List_Update_Notice_Period_Display = false;
            Parent_Pricing_Update_Frequency_display = false;
            newcontr.Par_Cus_Core_List_Upd_Notice_Per_Other__c = null;
            newcontr.Apply_Parent_Cust_Core_Agreement_Lang__c = null;
            newcontr.Parent_Pricing_Update_Frequency__c = null;
            newcontr.Parent_Pricing_Update_Frequency_other__c = null;
            newcontr.Parent_Man_Vendor_letter_req_for_Increas__c = null;
            newcontr.Parent_decr_req_applied_to_Cust_Core__c = null;
            newcontr.Cust_Notif_to_chg_Pricing_on_Par_Core__c = null;
            newcontr.Par_Cust_Core_List_Update_Notice_Type__c = null;
            newcontr.Par_Cust_Core_List_Update_Notice_Period__c = null;
            newcontr.Par_Core_have_Capped_Price_Increase__c = null;
            newcontr.Par_Core_List_Capped_Price_Increase__c = null;
            newcontr.Par_Core_SKU_Level_Capped_Price_Incr__c = null;
            newcontr.Par_SKU_Cap_Dollar_Amount__c = null;
            newcontr.Par_SKU_Cap_Percent_Amount__c = null;
            newcontr.Par_Cust_Core_List_Update_Notice_Period__c = null;
            newcontr.Are_there_Parent_SKU_Count_Limitations__c = null;
            newcontr.Parent_SKU_Count_Limitation__c = null;
            //newcontr.Parent_Annual_Spend_Requirement__c = null;
            newcontr.Par_Annual_Spend_Requirement_Amount__c = null;
            newcontr.Parent_Annual_Spend_Description__c = null;
            newcontr.Parent_Custom_Core_Discount_Basis__c = null;
            newcontr.Parent_Custom_Core_Discount_Percent__c = null;
            newcontr.Floors_permitted_in_Par_Cust_Core_List__c = null;
        }
    }
    
    public void Cust_Notif_to_change_Pricing_on_GP_Core_grid()
    {
        Cust_Notif_to_change_Pricing_on_GP_Core_Display = false;
        if(newcontr.Cust_Notif_to_change_Pricing_on_GP_Core__c == 'Notification Required')
            Cust_Notif_to_change_Pricing_on_GP_Core_Display = true;
        else
        {
            Cust_Notif_to_change_Pricing_on_GP_Core_Display = false;
            GP_Cus_Core_List_Update_Notice_Period_Display = false;
            newcontr.GP_Cus_Core_List_Upd_Notice_Period_Other__c = null;
            newcontr.GP_Cust_Core_List_Update_Notice_Type__c = null;
            newcontr.GP_Cus_Core_List_Update_Notice_Period__c = null;
        }
    }
    
    public void GP_Core_List_have_Capped_Price_Increase_grid()
    {
        GP_Core_List_have_Capped_Price_Increase_Display = false;
        if(newcontr.GP_Core_List_have_Capped_Price_Increase__c == 'Yes')
            GP_Core_List_have_Capped_Price_Increase_Display = true;
        else
        {
            GP_Core_List_have_Capped_Price_Increase_Display = false;
            GP_Core_List_Capped_Price_Increase_Display = false;
            GP_Core_List_SKU_Capped_Price_Increase_Display = false;
            GP_Core_List_SKU_Capped_Price_Increase_per_Display = false;
            newcontr.GP_Core_List_Capped_Price_Increase__c = null;
            newcontr.GP_Core_List_SKU_Capped_Price_Increase__c = null;
            newcontr.GP_SKU_Cap_Dollar_Amount__c = null;
            newcontr.GP_SKU_Cap_Percent_Amount__c = null;
        }
    }
    
    public void Are_there_GP_SKU_Count_Limitations_grid()
    {
        Are_there_GP_SKU_Count_Limitations_Display = false;
        if(newcontr.Are_there_GP_SKU_Count_Limitations__c == 'Yes')
            Are_there_GP_SKU_Count_Limitations_Display = true;
        else
        {
            Are_there_GP_SKU_Count_Limitations_Display = false;
            GP_Annual_Spend_Requirement_Display = false;
            newcontr.GP_SKU_Count_Limitation__c = null;
            //newcontr.GP_Annual_Spend_Requirement__c = null;
            newcontr.GP_Annual_Spend_Requirement_Amount__c = null;
            newcontr.GP_Annual_Spend_Description__c = null;
        }
    }
    
    public void GP_Core_List_Capped_Price_Increase_grid()
    {
        GP_Core_List_Capped_Price_Increase_Display = false;
        if(newcontr.GP_Core_List_Capped_Price_Increase__c == 'SKU Level')
            GP_Core_List_Capped_Price_Increase_Display = true;
        else
        {
            GP_Core_List_Capped_Price_Increase_Display = false;
            GP_Core_List_SKU_Capped_Price_Increase_Display =false;
            GP_Core_List_SKU_Capped_Price_Increase_per_Display = false;
            newcontr.GP_Core_List_SKU_Capped_Price_Increase__c = null;
            newcontr.GP_SKU_Cap_Dollar_Amount__c = null;
            newcontr.GP_SKU_Cap_Percent_Amount__c = null;
        }
    }
    
    public void GP_Core_List_SKU_Capped_Price_Increase_grid()
    {
        if(newcontr.GP_Core_List_SKU_Capped_Price_Increase__c == '$ Cap')
        {
            GP_Core_List_SKU_Capped_Price_Increase_Display = true;
            GP_Core_List_SKU_Capped_Price_Increase_per_Display = false;
            newcontr.GP_SKU_Cap_Percent_Amount__c = null;
        }
        else
        {
            newcontr.GP_SKU_Cap_Dollar_Amount__c = null;
            if(newcontr.GP_Core_List_SKU_Capped_Price_Increase__c == '% Cap')
                GP_Core_List_SKU_Capped_Price_Increase_per_Display = true;
            GP_Core_List_SKU_Capped_Price_Increase_Display = false;
            
        }
    }
    
    
    //------Added on 16th July----
    public void Cust_Notif_to_change_Pricing_on_Standalone_Core_grid()
    {
        Cust_Notif_to_change_Pricing_on_Standalone_Core_Display = false;
        if(newcontr.Cust_Notif_to_change_Pricingon_Standalon__c == 'Notification Required')
            Cust_Notif_to_change_Pricing_on_Standalone_Core_Display = true;
        else
        {
            Cust_Notif_to_change_Pricing_on_Standalone_Core_Display = false;
            Standalone_Cus_Core_List_Update_Notice_Period_Display = false;
            newcontr.Standalone_Core_List_Upd_Notice_Period__c = null;
            newcontr.Standalone_Cust_Core_List_Update_Notice__c= null;
            newcontr.StandaloneCore_List_Update_Notice_Period__c = null;
        }
    }
    public void Standalone_Cus_Core_List_Update_Notice_Period_grid()
    {
        Standalone_Cus_Core_List_Update_Notice_Period_Display = false;
        if(newcontr.StandaloneCore_List_Update_Notice_Period__c == 'Other')
            Standalone_Cus_Core_List_Update_Notice_Period_Display = true;
        else
        {
            Standalone_Cus_Core_List_Update_Notice_Period_Display = false;
            newcontr.Standalone_Core_List_Upd_Notice_Period__c = null;
        }
    }
    public void Standalone_Core_List_have_Capped_Price_Increase_grid()
    {
        Standalone_Core_List_have_Capped_Price_Increase_Display = false;
        if(newcontr.Standalone_Core_List_have_Capped_Price__c == 'Yes')
            Standalone_Core_List_have_Capped_Price_Increase_Display = true;
        else
        {
            Standalone_Core_List_have_Capped_Price_Increase_Display = false;
            Standalone_Core_List_Capped_Price_Increase_Display = false;
            Standalone_Core_List_SKU_Capped_Price_Increase_Display = false;
            Standalone_Core_List_SKU_Capped_Price_Increase_per_Display = false;
            newcontr.StandalonCore_List_Capped_Price_Increase__c = null;
            newcontr.Standalone_Core_List_SKU_Capped_Price__c = null;
            newcontr.Standalone_SKU_Cap_Amount__c = null;
        }
    }
    
    public void Are_there_Standalone_SKU_Count_Limitations_grid()
    {
        Are_there_Standalone_SKU_Count_Limitations_Display = false;
        if(newcontr.Are_there_Standalone_SKU_Count_Limit__c == 'Yes')
            Are_there_Standalone_SKU_Count_Limitations_Display = true;
        else
        {
            Are_there_Standalone_SKU_Count_Limitations_Display = false;
            Standalone_Annual_Spend_Requirement_Display = false;
            newcontr.Standalone_SKU_Count_Limitation__c = null;
            newcontr.Standalone_Annual_Spend_Requirement__c = null;
            newcontr.Standalone_Annual_Spend_Requirement_Amt__c = null;
            newcontr.Standalone_Annual_Spend_Description__c = null;
        }
    }
    
    public void Standalone_Core_List_Capped_Price_Increase_grid()
    {
        Standalone_Core_List_Capped_Price_Increase_Display = false;
        if(newcontr.StandalonCore_List_Capped_Price_Increase__c == 'SKU Level')
            Standalone_Core_List_Capped_Price_Increase_Display = true;
        else
        {
            Standalone_Core_List_Capped_Price_Increase_Display = false;
            Standalone_Core_List_SKU_Capped_Price_Increase_Display =false;
            Standalone_Core_List_SKU_Capped_Price_Increase_per_Display = false;
            newcontr.Standalone_Core_List_SKU_Capped_Price__c = null;
            newcontr.Standalone_SKU_Cap_Amount__c = null;
        }
    }
    
    public void Standalone_Core_List_SKU_Capped_Price_Increase_grid()
    {
        if(newcontr.Standalone_Core_List_SKU_Capped_Price__c == '$ Cap')
        {
            Standalone_Core_List_SKU_Capped_Price_Increase_Display = true;
            Standalone_Core_List_SKU_Capped_Price_Increase_per_Display = false;
            newcontr.Standalone_SKU_Cap_Amount__c = null;
        }
        else
        {
            newcontr.Standalone_SKU_Cap_Amount__c = null;
            if(newcontr.Standalone_Core_List_SKU_Capped_Price__c == '% Cap')
                Standalone_Core_List_SKU_Capped_Price_Increase_Display = true;
            Standalone_Core_List_SKU_Capped_Price_Increase_per_Display = true;
            
            
        }
    }
    public void Standalone_Annual_Spend_Requirement_grid()
    {
        Standalone_Annual_Spend_Requirement_Display = false;
        if(newcontr.Standalone_Annual_Spend_Requirement__c == 'Yes')
            Standalone_Annual_Spend_Requirement_Display = true;
        else
        {
            Standalone_Annual_Spend_Requirement_Display = false;
            newcontr.Standalone_Annual_Spend_Requirement_Amt__c = null;
            newcontr.Standalone_Annual_Spend_Description__c = null;
        }
    }
    public void Standalone_Custom_Core_Discount_Basis_grid()
    {
        Standalone_Custom_Core_Discount_Basis_Display = false;
        if(newcontr.Standalone_Custom_Core_Discount_Basis__c == 'WAPO Mark-Up')
            Standalone_Custom_Core_Discount_Basis_Display = true;
        else
        {
            Standalone_Custom_Core_Discount_Basis_Display = false;
            newcontr.Standalone_Custom_Core_Discount_Percent__c = null;
        }
    }
    
    public void Floors_permitted_in_Standalone_Cust_Core_grid()
    {
        Floors_permitted_in_Standalone_Cust_Core_Display = true;
        if(newcontr.Floors_permitted_in_Standalone_Cust_Core__c == 'Yes')
            Floors_permitted_in_Standalone_Cust_Core_Display = true;
        else
        {
            Floors_permitted_in_Standalone_Cust_Core_Display = false;
            newcontr.Standalone_Floor_Structure_Description__c = null;
        }
    }
    ///-------End------------------
    
    
    
    
    public void Child_Core_SKU_Level_Capped_Price_Incr_grid()
    {
        if(newcontr.Child_Core_SKU_Level_Capped_Price_Incr__c == '$ Cap')
        {
            Child_Core_SKU_Level_Capped_Price_Incr_Display = true;
            Child_Core_SKU_Level_Capped_Price_Incr_per_Display = false;
        }
        else
        {
            if(newcontr.Child_Core_SKU_Level_Capped_Price_Incr__c == '% Cap')
                Child_Core_SKU_Level_Capped_Price_Incr_per_Display = true;
            Child_Core_SKU_Level_Capped_Price_Incr_Display = false;
            
        }
    }
    
    public void Par_Core_SKU_Level_Capped_Price_Incr_grid()
    {
        if(newcontr.Par_Core_SKU_Level_Capped_Price_Incr__c == '$ Cap')
        {
            Par_Core_SKU_Level_Capped_Price_Incr_Display = true;
            Par_Core_SKU_Level_Capped_Price_Incr_per_Display = false;
        }
        else
        {
            if(newcontr.Par_Core_SKU_Level_Capped_Price_Incr__c == '% Cap')
                Par_Core_SKU_Level_Capped_Price_Incr_per_Display = true;
            Par_Core_SKU_Level_Capped_Price_Incr_Display = false;
        }
    }
    
    public void GP_Annual_Spend_Requirement_grid()
    {
        GP_Annual_Spend_Requirement_Display = false;
        /*if(newcontr.GP_Annual_Spend_Requirement__c == 'Yes')
GP_Annual_Spend_Requirement_Display = true;
else
{
GP_Annual_Spend_Requirement_Display = false;
newcontr.GP_Annual_Spend_Requirement_Amount__c = null;
newcontr.GP_Annual_Spend_Description__c = null;
}*/
    }
    
    //START NSHARP CASE 00130611 8.12.15
    //public void Notification_time_for_disco_items_grid()
    //{
    //Notification_time_for_disco_items_Display = false;
    //if(newcontr.Notification_time_for_disco_items__c == 'Other')
    //Notification_time_for_disco_items_Display = true;
    //else
    //{
    //Notification_time_for_disco_items_Display = false;
    //newcontr.Notification_time_disco_items_Other__c = null;
    //}
    //}
    //END NSHARP CASE 00130611 8.12.15
    
    public void GP_Cus_Core_List_Update_Notice_Period_grid()
    {
        GP_Cus_Core_List_Update_Notice_Period_Display = false;
        if(newcontr.GP_Cus_Core_List_Update_Notice_Period__c == 'Other')
            GP_Cus_Core_List_Update_Notice_Period_Display = true;
        else
        {
            GP_Cus_Core_List_Update_Notice_Period_Display = false;
            newcontr.GP_Cus_Core_List_Upd_Notice_Period_Other__c = null;
        }
    }
    
    public void Par_Cust_Core_List_Update_Notice_Period_grid()
    {
        Par_Cust_Core_List_Update_Notice_Period_Display = false;
        if(newcontr.Par_Cust_Core_List_Update_Notice_Period__c == 'Other')
            Par_Cust_Core_List_Update_Notice_Period_Display = true;
        else
        {
            Par_Cust_Core_List_Update_Notice_Period_Display = false;
            newcontr.Par_Cus_Core_List_Upd_Notice_Per_Other__c = null;
        }
    }
    
    public void Child_Cust_Core_Upd_Notice_Period_grid()
    {
        Child_Cust_Core_Upd_Notice_Period_Display = false;
        if(newcontr.Child_Cust_Core_Upd_Notice_Period__c == 'Other')
            Child_Cust_Core_Upd_Notice_Period_Display = true;
        else
        {
            Child_Cust_Core_Upd_Notice_Period_Display = false;
            newcontr.Child_Cust_Core_Upd_Notice_Period_Other__c = null;
        }
    }
    
    public void GP_Pricing_Update_Frequency_grid()
    {
        GP_Pricing_Update_Frequency_Display = false;
        if(newcontr.GP_Pricing_Update_Frequency__c == 'Other')
            GP_Pricing_Update_Frequency_Display = true;
        else
        {
            GP_Pricing_Update_Frequency_Display = false;
            newcontr.GP_Pricing_Update_Frequency_Other__c = null;
        }
    }
    public void Standalone_Pricing_Update_Frequency_grid()
    {
        Standalone_Pricing_Update_Frequency_Display = false;
        if(newcontr.Standalone_Pricing_Update_Frequency__c == 'Other')
            Standalone_Pricing_Update_Frequency_Display = true;
        else
        {
            Standalone_Pricing_Update_Frequency_Display = false;
            newcontr.Standalone_Pricing_Update_FrequencyOther__c = null;
        }
    }
    public void Parent_Pricing_Update_Frequency_grid()
    {
        Parent_Pricing_Update_Frequency_Display = false;
        if(newcontr.Parent_Pricing_Update_Frequency__c == 'Other')
            Parent_Pricing_Update_Frequency_Display = true;
        else
        {
            Parent_Pricing_Update_Frequency_Display = false;
            newcontr.Parent_Pricing_Update_Frequency_Other__c = null;
        }
    }
    
    public void Child_Pricing_Update_Frequency_grid()
    {
        Child_Pricing_Update_Frequency_Display = false;
        if(newcontr.Child_Pricing_Update_Frequency__c == 'Other')
            Child_Pricing_Update_Frequency_Display = true;
        else
        {
            Child_Pricing_Update_Frequency_Display = false;
            newcontr.Child_Pricing_Update_Frequency_Other__c = null;
        }
    }
    
    /////// Conditional Check for the Pricing Tab Render fields ends here
    
    /////// Methods for the functionality of Rendering the fields ends here
    
    ////// 'Save', 'Save and Close' and 'Cancel' buttons implementation starts from here
    ////// For the controlling fields being saved for inactive tabs.
    public void saveindividualtab()
    {
        
        if (contract_id_alias != null)
        {
            //deepak changes start
            /*LSLEVIN S-309031 5.7.2015 Removed Bid_Outcome__c
from below query and added field Current_Legacy_Max_Agreement__c
and Renewal_Pending__c*/
            /*LSLEVIN S-309032 5.11.2015 Removed Anniversary_Date__c from below query
and added Executed_Amendments__c,Other_Contract_Terms_Description__c,Small_Order_Fee_Language__c,
Furniture_Delivery_Fee_Language__c,Excess_Dimension_Fees_Language__c,Restocking_Fees_Language__c,
Contract_State_Minimum_Order__c,Minimum_Order_Value_Language__c,*/
            /*LSLEVIN S-309036 5.13.2015 Added fields to the below query Call_Out_Cost_Plus_Floor__c,
Call_Out_Auto_Force_Sub__c,Call_Out_Sub_Language__c,Cost_Plus_Floor_Type__c,Customer_Hierarchy_Cost_Plus_Pricing__c,
Proprietary_Items__c,Vendor_Funded_Core_Specificall__c,Vendor_funded_core_language__c,Minimum_Annual_Spend_Threshold_for_Prici__c*/
            
            //START NSHARP CASE 00130611 8.12.15
            //newcontract_alias = [select Id,Any_other_callouts_from_legal__c,Minimum_Annual_Spend_Threshold_for_Prici__c,Vendor_funded_core_language__c,Vendor_Funded_Core_Specificall__c,Proprietary_Items__c,Customer_Hierarchy_Cost_Plus_Pricing__c,Cost_Plus_Floor_Type__c,Call_Out_Sub_Language__c,Call_Out_Auto_Force_Sub__c,Call_Out_Cost_Plus_Floor__c,Minimum_Order_Value_Language__c,Contract_State_Minimum_Order__c,Restocking_Fees_Language__c,Excess_Dimension_Fees_Language__c,Furniture_Delivery_Fee_Language__c,Small_Order_Fee_Language__c,Other_Contract_Terms_Description__c,Executed_Amendments__c,Current_Legacy_Max_Agreement__c,Renewal_Pending__c,Standalone_Floor_Structure_Description__c,Payment_Term_Other__c,Special_Order_Discount_Language__c,GP_Cost_Plus_Language__c,Price_Decrease_Language__c,Minimum_Annual_Spend_Commitment_Amount__c,Is_there_a_custom_NCC__c,How_frequently_can_the_pricing_on_the_cu__c,Action_requirements_for_deleted_or_disco__c,Price_requirements_for_added_or_alternat__c,Is_notification_required_to_delete_a_cus__c,What_type_of_customer_communication_is_r__c,Does_written_agreement_allow_for_price__c,Core_Spend_Volume_Threshold_for_Pricing__c,Standalonedecr_req_to_be_applied_to_Cust__c,Standalone_Custom_Core_Written_Agreement__c,Standalone_SKU_Count_Limitation__c,Standalone_Custom_Core_Discount_Percent__c,Written_Agreement_allow_Standalone__c,Standalone_Pricing_Update_Frequency__c,Cust_Notif_to_change_Pricingon_Standalon__c,StandaloneCore_List_Update_Notice_Period__c,Standalone_Core_List_have_Capped_Price__c,StandalonCore_List_Capped_Price_Increase__c,Standalone_Core_List_SKU_Capped_Price__c,Are_there_Standalone_SKU_Count_Limit__c,Standalone_Annual_Spend_Requirement__c,Standalone_Custom_Core_Discount_Basis__c,Floors_permitted_in_Standalone_Cust_Core__c, Does_the_contract_include_ODP_Subsidiari__c,Clawback_Provision_Language__c,Effective_Date_Of_Current_Amendment__c,Other_Extension_Duration__c, Duration_Of_Each_Extension__c,Other_Extension_Number__c,Contract_Extension_Authorization_Type__c, Number_Of_Extensions__c,Describe_number_of_Amendments__c,Is_there_a_clawback_provision__c,AccountId,Account.Name, Account.Cust_ID__c ,Account.AOPS_Cust_Id__c,CSF_Review_Date__c,OwnerExpirationNotice, contract_type__c,contract_status__c,Contract_data_verified__c,Verified_date_time__c,User_who_verified_data__c,Verification_notes__c,Status_Detail__c, StartDate, EndDate, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ContractTerm, Status, CompanySignedId, CompanySignedDate, CustomerSignedId, CustomerSignedTitle, CustomerSignedDate, SpecialTerms, ActivatedById, ActivatedDate, StatusCode, Description, ContractNumber, Basis_Level_for_Customer_Agreement__c, Grandparent_Number__c, Grandparent_Name__c, Parent_Account_Number__c, Parent_Account_Name__c, Child_Account_Number__c, Child_Account_Name__c, Tech_Depot_Account_Number__c, Tech_Depot_Account_Name__c, Stand_Alone_Account_Number__c, Stand_Alone_Account_Name__c, Prospect_Account_Number__c, Prospect_Account_Name__c, Contract_Development_Negotiation_MGR__c, Contract_Lifecycle_Manager__c,Contract_Owner__c, Date_Original_Contract_Signed__c, Original_Expiration_Date__c, Effective_Date_of_Original_Contract__c, Date_current_Legal_Contract_expires__c, Contract_Extensions__c, Extension_Terms__c, Have_Amendment_s_been_executed__c, Is_there_a_Most_Favored_Customer_claus__c, Most_Favored_Contract_Language__c, Does_contract_have_provisions_for_an_emp__c, Emp_Pricing_tied_to_Cust_Pricing__c, Specific_lang_on_the_contract_on_emp_pgm__c, Do_employee_purchases_go_toward_rebates__c, Contract_state_a_Small_Order_Fee_charge__c, Contract_state_a_furniture_delivery_fee__c, Dimension_fee_for_furn_charge_are_exclud__c, Contract_state_Restocking_Fees_excluded__c, Start_date_of_Point_of_Sale_Discount__c, End_date_of_Point_of_Sale_Discount__c, Are_there_Rebates_Incentives__c, Rebate_Incentive_Type__c, Penalties_for_late_Rebate_payment__c, Reporting_Requirements_In_Legal_Agreemen__c, Reporting_Requirements__c, Reporting_Penalties_for_late_reports__c, Report_Frequency__c, Report_Frequency_Other__c, Other_Report_Penalties_Description__c,Stand_Alone_Bid_Agreement_Number__c, GP_Bid_Agreement_Number__c, Parent_Bid_Agreement_Number__c, Child_Bid_Agreement_Number__c,Are_there_Minority_Spend_Requirements__c,What_of_Spend_Dollar__c,What_of_spend__c,Minority_Spend_Requirements_Language__c, Written_Agreement_allow_GP_Custom_Cores__c, GP_Custom_Core_Written_Agreement_Languag__c, GP_Pricing_Update_Frequency__c,GP_Pricing_Update_Frequency_Other__c,Parent_Pricing_Update_Frequency_Other__c,Child_Pricing_Update_Frequency_Other__c, GP_Manufac_Vendor_letter_req_for_Increas__c, GP_decr_req_to_be_applied_to_Cust_Core__c, Cust_Notif_to_change_Pricing_on_GP_Core__c, GP_Cust_Core_List_Update_Notice_Type__c, GP_Cus_Core_List_Update_Notice_Period__c, GP_Core_List_have_Capped_Price_Increase__c, GP_Core_List_Capped_Price_Increase__c, GP_Core_List_SKU_Capped_Price_Increase__c, GP_SKU_Cap_Dollar_Amount__c, GP_SKU_Cap_Percent_Amount__c, Are_there_GP_SKU_Count_Limitations__c, GP_SKU_Count_Limitation__c, GP_Annual_Spend_Requirement__c, GP_Annual_Spend_Description__c, GP_Annual_Spend_Requirement_Amount__c, GP_Custom_Core_Discount_Basis__c, GP_Custom_Core_Discount_Percent__c, Floors_permitted_in_GP_Cust_Core__c, GP_Floor_Structure_Description__c, Written_Agreement_allow_Parent_Cust_Core__c, Apply_Parent_Cust_Core_Agreement_Lang__c, Parent_Pricing_Update_Frequency__c, Parent_Man_Vendor_letter_req_for_Increas__c, Parent_decr_req_applied_to_Cust_Core__c, Cust_Notif_to_chg_Pricing_on_Par_Core__c, Par_Cust_Core_List_Update_Notice_Type__c, Par_Cust_Core_List_Update_Notice_Period__c, Par_Core_have_Capped_Price_Increase__c, Par_Core_List_Capped_Price_Increase__c, Par_Core_SKU_Level_Capped_Price_Incr__c, Par_SKU_Cap_Dollar_Amount__c, Par_SKU_Cap_Percent_Amount__c, Are_there_Parent_SKU_Count_Limitations__c, Parent_SKU_Count_Limitation__c, Parent_Annual_Spend_Requirement__c, Parent_Annual_Spend_Description__c, Par_Annual_Spend_Requirement_Amount__c, Parent_Custom_Core_Discount_Basis__c, Parent_Custom_Core_Discount_Percent__c, Floors_permitted_in_Par_Cust_Core_List__c, Parent_Floor_Structure_Description__c, Written_Agreement_allow_Child_Cust_Cores__c, Apply_Child_Core_Written_Agree_Lang__c, Child_Pricing_Update_Frequency__c, Child_Man_Ven_letter_req_for_Increase__c, Child_decr_req_to_be_applied_to_Cus_Core__c, Cust_Notif_to_chg_Pricing_on_Child_Core__c, Child_Cust_Core_Update_Notice_Type__c, Child_Cust_Core_Upd_Notice_Period__c, Child_Core_have_Capped_Price_Increase__c, Child_Core_List_Capped_Price_Increase__c, Child_Core_SKU_Level_Capped_Price_Incr__c, Child_SKU_Cap_Dollar_Amount__c, Child_SKU_Cap_Percent_Amount__c, Are_there_Child_SKU_Count_Limits__c, Child_SKU_Count_Limitation__c, Child_Annual_Spend_Requirement__c, Child_Annual_Spend_Description__c, Child_Annual_Spend_Requirement_Amount__c, Child_Custom_Core_Discount_Basis__c, Child_Custom_Core_Discount_Percent__c, Floors_permitted_in_Child_Cust_Core__c, Child_Floor_Structure_Description__c, Notification_process_for_disco_items__c, Notification_time_for_disco_items__c, Notification_time_disco_items_Other__c, Agreement_provide_disco_on_spec_orders__c, Contract_have_req_for_prop_items__c, Contract_cover_NonCore_Cat_setup_pricing__c, Non_Core_Catalog__c, Custom_Non_Core_Catalog__c, Decr_req_to_be_applied_to_NonCore_Cat__c, Flrs_permitted_in_Cust_NonCore_Cat_struc__c, What_floor_permitted_on_Cust_NonCore_Cat__c, Custom_Non_Core_Catalog_Discount_Basis__c, WAPO_Mark_Up_Percent__c, Describe_NonCore_Cat_Structure__c, Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c, NonCore_Cat_Update_Notice_Period__c, NonCore_Cat_Update_Notice_Period_Other__c, NonCore_Catalog_Update_Notice_Type__c, NonCore_Cat_Update_Acceptance_process__c,Non_Core_Catalog_Update_Frequency_Other__c, NonCore_Catalog_Update_Frequency__c, Floors_permitted_in_OffContr_Whlsler_str__c, Floor_for_OffContract_Structure__c, OffContract_Pricing_specified_in_contrac__c, OffContract_Pricing_Structure__c, OffContract_Lang_in_agreement__c, Wholesaler_Pricing_specified_in_contract__c, Wholesaler_Pricing_Structure__c, Wholesaler_Lang_in_agreement__c, GP_Floor_specified_in_contract__c, Cost_Language_included_in_agreement__c, Provide_Cost_Language_in_agreement__c, Manuf_Vendor_Letter_requiried_for_Increa__c, Work_with_Tier_1_partner_on_this_account__c, Name_of_Tier_1_Partner__c, Tier_1_fees_paid__c, Deviated_Pricing_offered_to_Customer__c, Specifics_of_the_Deviated_Cost_offering__c, Minimum_Annual_Spend_Commitment__c, Min_Annual_Spend_Comm_contract_lang_amt__c, OD_adjust_Cust_Prcing_if_Spend_not_met__c, Pricing_Summary__c, Multi_Country_Agreement__c, What_countries_are_covered__c, Payment_Terms__c, Agreement_respon_based_on_cat_prod_assor__c, Catalog_Product_Assortment__c, Is_there_a_Point_of_Sale_Discount__c, Point_of_Sale_Discount_levels_per_contra__c, Performance_Notification_Req_in_contract__c, Performance_Notification_Requirements__c, Penalties_for_not_meeting_Perf_Notifi_Re__c, Lang_in_contract_for_Perf_Notif_Requirem__c, Rebate_Description__c, Rebate_Penalty_Description__c, Report_Description__c,Par_Cus_Core_List_Upd_Notice_Per_Other__c,Child_Cust_Core_Upd_Notice_Period_Other__c, GP_Cus_Core_List_Upd_Notice_Period_Other__c from Contract where id = :contract_id_alias];
            //Modified By Vipul Jain for Story#S-457176 (00899739 - Tier 1: Story 20 Account-Level CSF Changes) on December 30,2016
            newcontract_alias = [select Id,Any_other_callouts_from_legal__c,Is_this_a_2_party_or_3_party_agreement__c,Minimum_Annual_Spend_Threshold_for_Prici__c,Vendor_funded_core_language__c,Vendor_Funded_Core_Specificall__c,Proprietary_Items__c,Customer_Hierarchy_Cost_Plus_Pricing__c,Cost_Plus_Floor_Type__c,Call_Out_Sub_Language__c,Call_Out_Auto_Force_Sub__c,Call_Out_Cost_Plus_Floor__c,Minimum_Order_Value_Language__c,Contract_State_Minimum_Order__c,Restocking_Fees_Language__c,Excess_Dimension_Fees_Language__c,Furniture_Delivery_Fee_Language__c,Small_Order_Fee_Language__c,Other_Contract_Terms_Description__c,Executed_Amendments__c,Current_Legacy_Max_Agreement__c,Renewal_Pending__c,Standalone_Floor_Structure_Description__c,Payment_Term_Other__c,Special_Order_Discount_Language__c,GP_Cost_Plus_Language__c,Price_Decrease_Language__c,Minimum_Annual_Spend_Commitment_Amount__c,Is_there_a_custom_NCC__c,How_frequently_can_the_pricing_on_the_cu__c,Action_requirements_for_deleted_or_disco__c,Price_requirements_for_added_or_alternat__c,Is_notification_required_to_delete_a_cus__c,What_type_of_customer_communication_is_r__c,Does_written_agreement_allow_for_price__c,Core_Spend_Volume_Threshold_for_Pricing__c,Standalonedecr_req_to_be_applied_to_Cust__c,Standalone_Custom_Core_Written_Agreement__c,Standalone_SKU_Count_Limitation__c,Standalone_Custom_Core_Discount_Percent__c,Written_Agreement_allow_Standalone__c,Standalone_Pricing_Update_Frequency__c,Cust_Notif_to_change_Pricingon_Standalon__c,StandaloneCore_List_Update_Notice_Period__c,Contract_cover_NonCore_Cat_setup_pricing__c,Standalone_Core_List_have_Capped_Price__c,StandalonCore_List_Capped_Price_Increase__c,Standalone_Core_List_SKU_Capped_Price__c,Are_there_Standalone_SKU_Count_Limit__c,Standalone_Annual_Spend_Requirement__c,Standalone_Custom_Core_Discount_Basis__c,Floors_permitted_in_Standalone_Cust_Core__c, Does_the_contract_include_ODP_Subsidiari__c,Clawback_Provision_Language__c,Effective_Date_Of_Current_Amendment__c,Other_Extension_Duration__c, Duration_Of_Each_Extension__c,Other_Extension_Number__c,Contract_Extension_Authorization_Type__c, Number_Of_Extensions__c,Describe_number_of_Amendments__c,Is_there_a_clawback_provision__c,AccountId,Account.Name, Account.Cust_ID__c ,Account.AOPS_Cust_Id__c,CSF_Review_Date__c,OwnerExpirationNotice, contract_type__c,contract_status__c,Contract_data_verified__c,Verified_date_time__c,User_who_verified_data__c,Verification_notes__c,Status_Detail__c, StartDate, EndDate, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry, ContractTerm, Status, CompanySignedId, CompanySignedDate, CustomerSignedId, CustomerSignedTitle, CustomerSignedDate, SpecialTerms, ActivatedById, ActivatedDate, StatusCode, Description, ContractNumber, Basis_Level_for_Customer_Agreement__c, Grandparent_Number__c, Grandparent_Name__c, Parent_Account_Number__c, Parent_Account_Name__c, Child_Account_Number__c, Child_Account_Name__c, Tech_Depot_Account_Number__c, Tech_Depot_Account_Name__c, Stand_Alone_Account_Number__c, Stand_Alone_Account_Name__c, Prospect_Account_Number__c, Prospect_Account_Name__c, Contract_Development_Negotiation_MGR__c, Contract_Lifecycle_Manager__c,Contract_Owner__c, Date_Original_Contract_Signed__c, Original_Expiration_Date__c, Effective_Date_of_Original_Contract__c, Contract_Term__c, Contract_Extensions__c, Extension_Terms__c, Have_Amendment_s_been_executed__c, Is_there_a_Most_Favored_Customer_claus__c, Most_Favored_Contract_Language__c, Does_contract_have_provisions_for_an_emp__c,
             Emp_Pricing_tied_to_Cust_Pricing__c, Specific_lang_on_the_contract_on_emp_pgm__c, Do_employee_purchases_go_toward_rebates__c, 
             Contract_state_a_Small_Order_Fee_charge__c, Contract_state_a_furniture_delivery_fee__c, Dimension_fee_for_furn_charge_are_exclud__c,
              Contract_state_Restocking_Fees_excluded__c, Start_date_of_Point_of_Sale_Discount__c, End_date_of_Point_of_Sale_Discount__c, 
              Are_there_Rebates_Incentives__c, Rebate_Incentive_Type__c, Penalties_for_late_Rebate_payment__c, 
              Reporting_Requirements_In_Legal_Agreemen__c, Reporting_Requirements__c, Reporting_Penalties_for_late_reports__c, 
              Report_Frequency__c, Report_Frequency_Other__c, Other_Report_Penalties_Description__c,Stand_Alone_Bid_Agreement_Number__c, 
              GP_Bid_Agreement_Number__c, Parent_Bid_Agreement_Number__c, Child_Bid_Agreement_Number__c,Are_there_Minority_Spend_Requirements__c,
              What_of_Spend_Dollar__c,What_of_spend__c,Minority_Spend_Requirements_Language__c, Written_Agreement_allow_GP_Custom_Cores__c,
               GP_Custom_Core_Written_Agreement_Languag__c, GP_Pricing_Update_Frequency__c,GP_Pricing_Update_Frequency_Other__c,
               Parent_Pricing_Update_Frequency_Other__c,Child_Pricing_Update_Frequency_Other__c, GP_Manufac_Vendor_letter_req_for_Increas__c,
                GP_decr_req_to_be_applied_to_Cust_Core__c, Cust_Notif_to_change_Pricing_on_GP_Core__c, GP_Cust_Core_List_Update_Notice_Type__c,
                 GP_Cus_Core_List_Update_Notice_Period__c, GP_Core_List_have_Capped_Price_Increase__c, GP_Core_List_Capped_Price_Increase__c, 
                 GP_Core_List_SKU_Capped_Price_Increase__c, GP_SKU_Cap_Dollar_Amount__c, GP_SKU_Cap_Percent_Amount__c,
                  Are_there_GP_SKU_Count_Limitations__c, GP_SKU_Count_Limitation__c, /*GP_Annual_Spend_Requirement__c,*/
                   GP_Annual_Spend_Description__c, GP_Annual_Spend_Requirement_Amount__c, GP_Custom_Core_Discount_Basis__c,
                    GP_Custom_Core_Discount_Percent__c, Floors_permitted_in_GP_Cust_Core__c, GP_Floor_Structure_Description__c, 
                    Written_Agreement_allow_Parent_Cust_Core__c, Apply_Parent_Cust_Core_Agreement_Lang__c, Parent_Pricing_Update_Frequency__c, 
                    Parent_Man_Vendor_letter_req_for_Increas__c, Parent_decr_req_applied_to_Cust_Core__c, Cust_Notif_to_chg_Pricing_on_Par_Core__c, 
                    Par_Cust_Core_List_Update_Notice_Type__c, Par_Cust_Core_List_Update_Notice_Period__c, Par_Core_have_Capped_Price_Increase__c, Par_Core_List_Capped_Price_Increase__c, Par_Core_SKU_Level_Capped_Price_Incr__c, Par_SKU_Cap_Dollar_Amount__c, Par_SKU_Cap_Percent_Amount__c, Are_there_Parent_SKU_Count_Limitations__c, 
                    Parent_SKU_Count_Limitation__c,/* Parent_Annual_Spend_Requirement__c,*/ Parent_Annual_Spend_Description__c, 
                    Par_Annual_Spend_Requirement_Amount__c, Parent_Custom_Core_Discount_Basis__c, Parent_Custom_Core_Discount_Percent__c, 
                    Floors_permitted_in_Par_Cust_Core_List__c, Parent_Floor_Structure_Description__c, Written_Agreement_allow_Child_Cust_Cores__c,
                     Apply_Child_Core_Written_Agree_Lang__c, Child_Pricing_Update_Frequency__c, Child_Man_Ven_letter_req_for_Increase__c, Child_decr_req_to_be_applied_to_Cus_Core__c, Cust_Notif_to_chg_Pricing_on_Child_Core__c, Child_Cust_Core_Update_Notice_Type__c, Child_Cust_Core_Upd_Notice_Period__c, Child_Core_have_Capped_Price_Increase__c, Child_Core_List_Capped_Price_Increase__c, Child_Core_SKU_Level_Capped_Price_Incr__c, Child_SKU_Cap_Dollar_Amount__c, Child_SKU_Cap_Percent_Amount__c, Are_there_Child_SKU_Count_Limits__c, Child_SKU_Count_Limitation__c, /*Child_Annual_Spend_Requirement__c,*/ Child_Annual_Spend_Description__c, Child_Annual_Spend_Requirement_Amount__c, Child_Custom_Core_Discount_Basis__c, Child_Custom_Core_Discount_Percent__c, Floors_permitted_in_Child_Cust_Core__c, Child_Floor_Structure_Description__c, Notification_process_for_disco_items__c, Notification_time_disco_items_Other__c, Agreement_provide_disco_on_spec_orders__c, Contract_have_req_for_prop_items__c, Non_Core_Catalog__c, Decr_req_to_be_applied_to_NonCore_Cat__c, What_floor_permitted_on_Cust_NonCore_Cat__c, WAPO_Mark_Up_Percent__c, Describe_NonCore_Cat_Structure__c, Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c, NonCore_Cat_Update_Notice_Period__c, NonCore_Cat_Update_Notice_Period_Other__c, NonCore_Catalog_Update_Notice_Type__c, NonCore_Cat_Update_Acceptance_process__c,Non_Core_Catalog_Update_Frequency_Other__c, 
                     NonCore_Catalog_Update_Frequency__c, Floor_for_OffContract_Structure__c, OffContract_Pricing_specified_in_contrac__c, OffContract_Pricing_Structure__c, OffContract_Lang_in_agreement__c, Wholesaler_Pricing_specified_in_contract__c, Wholesaler_Pricing_Structure__c, Wholesaler_Lang_in_agreement__c, Cost_Language_included_in_agreement__c, Provide_Cost_Language_in_agreement__c, Manuf_Vendor_Letter_requiried_for_Increa__c, Work_with_Tier_1_partner_on_this_account__c, Tier_1_fees_paid__c,Tier_1_Partner_Compensation_Language__c,Deviated_Pricing_offered_to_Customer__c, Specifics_of_the_Deviated_Cost_offering__c, Minimum_Annual_Spend_Commitment__c, Min_Annual_Spend_Comm_contract_lang_amt__c, OD_adjust_Cust_Prcing_if_Spend_not_met__c, Pricing_Summary__c, Multi_Country_Agreement__c, What_countries_are_covered__c, Payment_Terms__c, Payment_Terms_language__c, Agreement_respon_based_on_cat_prod_assor__c, Catalog_Product_Assortment__c, Is_there_a_Point_of_Sale_Discount__c, Point_of_Sale_Discount_levels_per_contra__c, Performance_Notification_Req_in_contract__c, Performance_Notification_Requirements__c, Penalties_for_not_meeting_Perf_Notifi_Re__c, Lang_in_contract_for_Perf_Notif_Requirem__c, Rebate_Description__c, Rebate_Penalty_Description__c, Report_Description__c,Par_Cus_Core_List_Upd_Notice_Per_Other__c,Child_Cust_Core_Upd_Notice_Period_Other__c, GP_Cus_Core_List_Upd_Notice_Period_Other__c,
                     Printed_Catalog_Required__c from Contract where id = :contract_id_alias]; // Support Ticket 00769458
            //END -Vipul
            //END NSHARP CASE 00130611 8.12.15
            //deepak changes end
            // Added Marketing Status fields NAIT-1753 Miles
            //system.assertEquals('Yes', newcontract_alias.Performance_Notification_Req_in_contract__c);
        }
        
    }
    ////// All the tabs are only checked fron their corresponding Controlling fields.
    public void Detaistabfields()
    {
        if(contract_id_alias != null)
        {
            saveindividualtab();
            newcontr.Basis_Level_for_Customer_Agreement__c=newcontract_alias.Basis_Level_for_Customer_Agreement__c;
        }
        
    }
    public void Legaltabfields()
    {
        if(contract_id_alias != null)
        {
            //system.assertEquals('Yes', newcontr.Performance_Notification_Req_in_contract__c);
            saveindividualtab();
            //system.assertEquals('Yes', newcontract_alias.Performance_Notification_Req_in_contract__c);
            newcontr.Have_Amendment_s_been_executed__c=newcontract_alias.Have_Amendment_s_been_executed__c;
            newcontr.Multi_Country_Agreement__c=newcontract_alias.Multi_Country_Agreement__c;
            newcontr.Is_there_a_Most_Favored_Customer_claus__c=newcontract_alias.Is_there_a_Most_Favored_Customer_claus__c;
            newcontr.Does_contract_have_provisions_for_an_emp__c=newcontract_alias.Does_contract_have_provisions_for_an_emp__c;
            newcontr.Is_there_a_Point_of_Sale_Discount__c=newcontract_alias.Is_there_a_Point_of_Sale_Discount__c;
            //newcontr.Performance_Notification_Req_in_contract__c=newcontract_alias.Performance_Notification_Req_in_contract__c;
            newcontr.Contract_Extensions__c = newcontract_alias.Contract_Extensions__c;
            newcontr.Duration_Of_Each_Extension__c = newcontract_alias.Duration_Of_Each_Extension__c;
            newcontr.Number_Of_Extensions__c = newcontract_alias.Number_Of_Extensions__c;
            newcontr.Other_Extension_Number__c = newcontract_alias.Other_Extension_Number__c;
            newcontr.Other_Extension_Duration__c = newcontract_alias.Other_Extension_Duration__c;
            newcontr.Contract_Extension_Authorization_Type__c = newcontract_alias.Contract_Extension_Authorization_Type__c;
            newcontr.Extension_Terms__c = newcontract_alias.Extension_Terms__c;
            newcontr.Payment_Term_Other__c = newcontract_alias.Payment_Term_Other__c;
            newcontr.Payment_Terms__c = newcontract_alias.Payment_Terms__c;
            newcontr.Payment_Terms_language__c= newcontract_alias.Payment_Terms_language__c; // Support Ticket 00769458
            //newcontr.Performance_Notification_Req_in_contract__c=newcontract_alias.Performance_Notification_Req_in_contract__c;
            newcontr.Are_there_Minority_Spend_Requirements__c=newcontract_alias.Are_there_Minority_Spend_Requirements__c;
            newcontr.Minority_Spend_Requirements_Language__c=newcontract_alias.Minority_Spend_Requirements_Language__c;
            newcontr.What_of_Spend_Dollar__c=newcontract_alias.What_of_Spend_Dollar__c;
            newcontr.What_of_spend__c=newcontract_alias.What_of_spend__c;
            /*newcontr.Marketing_Status__c = newcontract_alias.Marketing_Status__c;
            newcontr.Marketing_Email_Status__c = newcontract_alias.Marketing_Email_Status__c;
            newcontr.Marketing_Direct_Mail_Status__c = newcontract_alias.Marketing_Direct_Mail_Status__c;
            newcontr.Marketing_Phone_Status__c = newcontract_alias.Marketing_Phone_Status__c; */
            
            
            
            //NAIT-1753 Added Marketing Fields Miles Robson
            //system.assertEquals('Yes', newcontr.Performance_Notification_Req_in_contract__c);
        }
        
    }
    
    public void Pricingtabfields()
    {
        if(contract_id_alias != null)
        {
            saveindividualtab();
            newcontr.Written_Agreement_allow_GP_Custom_Cores__c=newcontract_alias.Written_Agreement_allow_GP_Custom_Cores__c;
            newcontr.GP_Pricing_Update_Frequency__c=newcontract_alias.GP_Pricing_Update_Frequency__c;
            newcontr.Cust_Notif_to_change_Pricing_on_GP_Core__c=newcontract_alias.Cust_Notif_to_change_Pricing_on_GP_Core__c;
            newcontr.GP_Cus_Core_List_Update_Notice_Period__c=newcontract_alias.GP_Cus_Core_List_Update_Notice_Period__c;
            newcontr.GP_Core_List_have_Capped_Price_Increase__c=newcontract_alias.GP_Core_List_have_Capped_Price_Increase__c;
            newcontr.GP_Core_List_Capped_Price_Increase__c=newcontract_alias.GP_Core_List_Capped_Price_Increase__c;
            newcontr.GP_Core_List_SKU_Capped_Price_Increase__c=newcontract_alias.GP_Core_List_SKU_Capped_Price_Increase__c;
            newcontr.Are_there_GP_SKU_Count_Limitations__c=newcontract_alias.Are_there_GP_SKU_Count_Limitations__c;
            //newcontr.GP_Annual_Spend_Requirement__c=newcontract_alias.GP_Annual_Spend_Requirement__c;
            newcontr.GP_Custom_Core_Discount_Basis__c=newcontract_alias.GP_Custom_Core_Discount_Basis__c;
            newcontr.Floors_permitted_in_GP_Cust_Core__c=newcontract_alias.Floors_permitted_in_GP_Cust_Core__c;
            newcontr.Written_Agreement_allow_Parent_Cust_Core__c=newcontract_alias.Written_Agreement_allow_Parent_Cust_Core__c;
            newcontr.Parent_Pricing_Update_Frequency__c=newcontract_alias.Parent_Pricing_Update_Frequency__c;
            newcontr.Cust_Notif_to_chg_Pricing_on_Par_Core__c=newcontract_alias.Cust_Notif_to_chg_Pricing_on_Par_Core__c;
            newcontr.Par_Cust_Core_List_Update_Notice_Period__c=newcontract_alias.Par_Cust_Core_List_Update_Notice_Period__c;
            newcontr.Par_Core_have_Capped_Price_Increase__c=newcontract_alias.Par_Core_have_Capped_Price_Increase__c;
            newcontr.Par_Core_List_Capped_Price_Increase__c=newcontract_alias.Par_Core_List_Capped_Price_Increase__c;
            newcontr.Par_Core_SKU_Level_Capped_Price_Incr__c=newcontract_alias.Par_Core_SKU_Level_Capped_Price_Incr__c;
            newcontr.Are_there_Parent_SKU_Count_Limitations__c=newcontract_alias.Are_there_Parent_SKU_Count_Limitations__c;
            //newcontr.Parent_Annual_Spend_Requirement__c=newcontract_alias.Parent_Annual_Spend_Requirement__c;
            newcontr.Parent_Custom_Core_Discount_Basis__c=newcontract_alias.Parent_Custom_Core_Discount_Basis__c;
            newcontr.Floors_permitted_in_Par_Cust_Core_List__c=newcontract_alias.Floors_permitted_in_Par_Cust_Core_List__c;
            newcontr.Written_Agreement_allow_Child_Cust_Cores__c=newcontract_alias.Written_Agreement_allow_Child_Cust_Cores__c;
            newcontr.Child_Pricing_Update_Frequency__c=newcontract_alias.Child_Pricing_Update_Frequency__c;
            newcontr.Cust_Notif_to_chg_Pricing_on_Child_Core__c=newcontract_alias.Cust_Notif_to_chg_Pricing_on_Child_Core__c;
            newcontr.Child_Cust_Core_Upd_Notice_Period__c=newcontract_alias.Child_Cust_Core_Upd_Notice_Period__c;
            newcontr.Child_Core_have_Capped_Price_Increase__c=newcontract_alias.Child_Core_have_Capped_Price_Increase__c;
            newcontr.Child_Core_List_Capped_Price_Increase__c=newcontract_alias.Child_Core_List_Capped_Price_Increase__c;
            newcontr.Child_Core_SKU_Level_Capped_Price_Incr__c=newcontract_alias.Child_Core_SKU_Level_Capped_Price_Incr__c;
            newcontr.Child_Floor_Structure_Description__c = newcontract_alias.Child_Floor_Structure_Description__c;
            newcontr.Are_there_Child_SKU_Count_Limits__c=newcontract_alias.Are_there_Child_SKU_Count_Limits__c;
            //newcontr.Child_Annual_Spend_Requirement__c=newcontract_alias.Child_Annual_Spend_Requirement__c;
            newcontr.Child_Custom_Core_Discount_Basis__c=newcontract_alias.Child_Custom_Core_Discount_Basis__c;
            newcontr.Floors_permitted_in_Child_Cust_Core__c=newcontract_alias.Floors_permitted_in_Child_Cust_Core__c;
            newcontr.Notification_process_for_disco_items__c=newcontract_alias.Notification_process_for_disco_items__c;
            newcontr.Notification_time_disco_items_Other__c=newcontract_alias.Notification_time_disco_items_Other__c;
            //newcontr.Flrs_permitted_in_Cust_NonCore_Cat_struc__c=newcontract_alias.Flrs_permitted_in_Cust_NonCore_Cat_struc__c;
            //START NSHARP CASE 00130611 8.12.15
            //newcontr.Notification_time_for_disco_items__c=newcontract_alias.Notification_time_for_disco_items__c;
            //newcontr.Custom_Non_Core_Catalog__c=newcontract_alias.Custom_Non_Core_Catalog__c;
            //newcontr.Custom_Non_Core_Catalog_Discount_Basis__c=newcontract_alias.Custom_Non_Core_Catalog_Discount_Basis__c;
            //newcontr.GP_Floor_specified_in_contract__c=newcontract_alias.GP_Floor_specified_in_contract__c;
            //newcontr.Floors_permitted_in_OffContr_Whlsler_str__c=newcontract_alias.Floors_permitted_in_OffContr_Whlsler_str__c;
            //newcontr.Flrs_permitted_in_Cust_NonCore_Cat_struc__c = newcontract_alias.Flrs_permitted_in_Cust_NonCore_Cat_struc__c;
            //END NSHARP CASE 00130611 8.12.15
            //system.debug('newcontract_alias.Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c--'+newcontract_alias.Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c);
            
            newcontr.Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c=newcontract_alias.Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c;
            newcontr.NonCore_Cat_Update_Notice_Period__c=newcontract_alias.NonCore_Cat_Update_Notice_Period__c;
            newcontr.OffContract_Pricing_specified_in_contrac__c=newcontract_alias.OffContract_Pricing_specified_in_contrac__c;
            newcontr.Wholesaler_Pricing_specified_in_contract__c=newcontract_alias.Wholesaler_Pricing_specified_in_contract__c;
            newcontr.Cost_Language_included_in_agreement__c=newcontract_alias.Cost_Language_included_in_agreement__c;
            //Modified By Vipul Jain for Story#S-457176 (00899739 - Tier 1: Story 20 Account-Level CSF Changes) on December 30,2016
            //newcontr.Work_with_Tier_1_partner_on_this_account__c=newcontract_alias.Work_with_Tier_1_partner_on_this_account__c;
            //End vipul
            newcontr.Deviated_Pricing_offered_to_Customer__c=newcontract_alias.Deviated_Pricing_offered_to_Customer__c;
            newcontr.Minimum_Annual_Spend_Commitment__c=newcontract_alias.Minimum_Annual_Spend_Commitment__c;
            //Addded on 25th July
            newcontr.What_floor_permitted_on_Cust_NonCore_Cat__c = newcontract_alias.What_floor_permitted_on_Cust_NonCore_Cat__c;
            newcontr.Written_Agreement_allow_Standalone__c=newcontract_alias.Written_Agreement_allow_Standalone__c;
            newcontr.Standalone_Pricing_Update_Frequency__c=newcontract_alias.Standalone_Pricing_Update_Frequency__c;
            newcontr.Cust_Notif_to_change_Pricingon_Standalon__c=newcontract_alias.Cust_Notif_to_change_Pricingon_Standalon__c;
            newcontr.StandaloneCore_List_Update_Notice_Period__c=newcontract_alias.StandaloneCore_List_Update_Notice_Period__c;
            newcontr.Standalone_Core_List_have_Capped_Price__c=newcontract_alias.Standalone_Core_List_have_Capped_Price__c;
            newcontr.StandalonCore_List_Capped_Price_Increase__c=newcontract_alias.StandalonCore_List_Capped_Price_Increase__c;
            newcontr.Standalone_Core_List_SKU_Capped_Price__c=newcontract_alias.Standalone_Core_List_SKU_Capped_Price__c;
            newcontr.Are_there_Standalone_SKU_Count_Limit__c=newcontract_alias.Are_there_Standalone_SKU_Count_Limit__c;
            newcontr.Standalone_Annual_Spend_Requirement__c=newcontract_alias.Standalone_Annual_Spend_Requirement__c;
            newcontr.Standalone_Custom_Core_Discount_Basis__c=newcontract_alias.Standalone_Custom_Core_Discount_Basis__c;
            newcontr.Floors_permitted_in_Standalone_Cust_Core__c=newcontract_alias.Floors_permitted_in_Standalone_Cust_Core__c;
            newcontr.Standalone_Floor_Structure_Description__c = newcontract_alias.Standalone_Floor_Structure_Description__c;
            newcontr.Standalonedecr_req_to_be_applied_to_Cust__c = newcontract_alias.Standalonedecr_req_to_be_applied_to_Cust__c;
            newcontr.Standalone_Custom_Core_Written_Agreement__c = newcontract_alias.Standalone_Custom_Core_Written_Agreement__c;
            newcontr.Child_Custom_Core_Discount_Percent__c =newcontract_alias.Child_Custom_Core_Discount_Percent__c;
            newcontr.Parent_Custom_Core_Discount_Percent__c = newcontract_alias.Parent_Custom_Core_Discount_Percent__c;
            newcontr.Standalone_SKU_Count_Limitation__c = newcontract_alias.Standalone_SKU_Count_Limitation__c;
            newcontr.Standalone_Custom_Core_Discount_Percent__c = newcontract_alias.Standalone_Custom_Core_Discount_Percent__c;
            newcontr.Special_Order_Discount_Language__c = newcontract_alias.Special_Order_Discount_Language__c;
            newcontr.GP_Cost_Plus_Language__c = newcontract_alias.GP_Cost_Plus_Language__c;
            newcontr.Price_Decrease_Language__c = newcontract_alias.Price_Decrease_Language__c;
            newcontr.Minimum_Annual_Spend_Commitment_Amount__c = newcontract_alias.Minimum_Annual_Spend_Commitment_Amount__c;
            newcontr.Does_written_agreement_allow_for_price__c = newcontract_alias.Does_written_agreement_allow_for_price__c;
            newcontr.Core_Spend_Volume_Threshold_for_Pricing__c = newcontract_alias.Core_Spend_Volume_Threshold_for_Pricing__c;
            newcontr.Decr_req_to_be_applied_to_NonCore_Cat__c = newcontract_alias.Decr_req_to_be_applied_to_NonCore_Cat__c;
            newcontr.Agreement_respon_based_on_cat_prod_assor__c=newcontract_alias.Agreement_respon_based_on_cat_prod_assor__c;
            newcontr.Floor_for_OffContract_Structure__c = newcontract_alias.Floor_for_OffContract_Structure__c;
            newcontr.Is_there_a_custom_NCC__c = newcontract_alias.Is_there_a_custom_NCC__c;
            newcontr.How_frequently_can_the_pricing_on_the_cu__c = newcontract_alias.How_frequently_can_the_pricing_on_the_cu__c;
            newcontr.Action_requirements_for_deleted_or_disco__c = newcontract_alias.Action_requirements_for_deleted_or_disco__c;
            newcontr.Price_requirements_for_added_or_alternat__c = newcontract_alias.Price_requirements_for_added_or_alternat__c;
            newcontr.Is_notification_required_to_delete_a_cus__c = newcontract_alias.Is_notification_required_to_delete_a_cus__c;
            newcontr.What_type_of_customer_communication_is_r__c = newcontract_alias.What_type_of_customer_communication_is_r__c;
            newcontr.Agreement_provide_disco_on_spec_orders__c = newcontract_alias.Agreement_provide_disco_on_spec_orders__c;
            newcontr.Contract_cover_NonCore_Cat_setup_pricing__c = newcontract_alias.Contract_cover_NonCore_Cat_setup_pricing__c;
          /*  newcontr.Trigger__c = newcontract_alias.Trigger__c;
            newcontr.Sell_price__c = newcontract_alias.Sell_price__c;
            newcontr.Sell_price_un_named__c = newcontract_alias.Sell_price_un_named__c;
            newcontr.Trigger_un_named__c = newcontract_alias.Trigger_un_named__c; */
            
            //----End---
        }
        
    }
    public void Rebatestabfields()
    {
        if(contract_id_alias != null)
        {
            saveindividualtab();
            newcontr.Are_there_Rebates_Incentives__c=newcontract_alias.Are_there_Rebates_Incentives__c;
            newcontr.Penalties_for_late_Rebate_payment__c=newcontract_alias.Penalties_for_late_Rebate_payment__c;
            newcontr.Is_there_a_clawback_provision__c=newcontract_alias.Is_there_a_clawback_provision__c;
        }
        
    }
    public void Reportingtabfields()
    {
        if(contract_id_alias != null)
        {
            saveindividualtab();
            newcontr.Reporting_Requirements_In_Legal_Agreemen__c=newcontract_alias.Reporting_Requirements_In_Legal_Agreemen__c;
            newcontr.Report_Frequency__c=newcontract_alias.Report_Frequency__c;
            newcontr.Performance_Notification_Req_in_contract__c=newcontract_alias.Performance_Notification_Req_in_contract__c;//added for 02229079 
        }
        
    }
    public void tabrerender()
    {
        if(contract_id_alias != null)
        {
            
            //Details Tab
            if(ActiveTab=='customerlevelimputs')
            {
                Legaltabfields();
                Pricingtabfields();
                Rebatestabfields();
                Reportingtabfields();
            }
            
            //Legal Tab
            if(ActiveTab=='customerlevelimputs2')
            {
                Detaistabfields();
                Pricingtabfields();
                Rebatestabfields();
                Reportingtabfields();
            }
            
            //Pricing Tab
            if(ActiveTab=='customerlevelimputs3')
            {
                Detaistabfields();
                Legaltabfields();
                Rebatestabfields();
                Reportingtabfields();
            }
            
            //Rebates and Incentives Tab
            if(ActiveTab=='customerlevelimputs4')
            {
                Detaistabfields();
                Legaltabfields();
                Pricingtabfields();
                Reportingtabfields();
            }
            
            //Reporting Tab
            if(ActiveTab=='customerlevelimputs5')
            {
                Detaistabfields();
                Legaltabfields();
                //system.assertEquals('Yes', newcontr.Performance_Notification_Req_in_contract__c);
                Pricingtabfields();
                Rebatestabfields();
                //system.assertEquals('Yes', newcontr.Performance_Notification_Req_in_contract__c);
            }
        }
    }
    public void CallSpringCM_workflow(String conId){
        System.debug('Spring CM WorkFlow is calleddddddd');
        String WFNAME = 'CloseContract';
        String URL = 'https://officedepot--UAT.cs14.my.salesforce.com/services/Soap/u/28.0/00Dc0000001gD43';
        String APIKey = '37EA6375-371B-42AD-87D0-1C6086550C80';
        String SCM_ACCID = '7180';
        String StsfId = conId;
        String sfType = 'Contract';
        String userSessionID = UserInfo.getSessionId();
        
        
        if(UserInfo.getOrganizationId() == '00DE0000000J4oSMAS'){
            //Production
            URL = 'https://officedepot.my.salesforce.com/services/Soap/u/{version}/00DE0000000J4oS';
            APIKey = '2155AD71-F164-4B7D-AC88-698548B6EDDF';
            SCM_ACCID = '13083';
        }
        
        
        SpringCMHelperUAT.StartWorkflow(WFNAME,URL,APIKey,SCM_ACCID,StsfId,sfType,userSessionID);
        
    }
    // Start - Jai Gupta - May 21,2015 - S-309029
    public pageReference saveAsDraft() {
        system.debug('Anydatatype_msg');
        newcontr.Contract_Status__c = 'Draft' ; 
        return saveContract() ;
    }
    // End - Jai Gupta - May 21,2015 - S-309029
    //////Inactive Tab controlling fields soultion ends.
    public PageReference saveContract()
    {
        //system.assertEquals('Yes', newcontr.Performance_Notification_Req_in_contract__c);
        PageReference contractref;
        system.debug('Performance_Notification_Req_in_contract__c **==='+newcontr.Performance_Notification_Req_in_contract__c );
        //system.assertEquals('Yes', newcontr.Performance_Notification_Req_in_contract__c);
        tabrerender();
        system.debug('Performance_Notification_Req_in_contract__c **'+newcontr.Performance_Notification_Req_in_contract__c );
        //START NSHARP S-334902 7.21.15
        List<String> errorList = validateInfo(newcontr);
        //Added by Kritika Bhati on 01/10/2017 for Case#00184643
        if(String.isBlank(newcontr.Payment_Terms_Language__c)){
            newcontr.Payment_Terms_Language__c ='DRAFT';
        }//End Case#00184643
        if(newcontr.Contract_Status__c != 'Draft'){
            if(!errorList.isEmpty()){
                for(String s: errorList){
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The field "' + s + '" has a value of None.  Please update and try saving again.'));//Updated by Akanksha for story S-351420
                }
                return null;
            }
        }
        //END NSHARP S-334902 7.21.15
        //Added on 18th July----
        string oldContractStatus;
        if(newcontr.id!=null){
            oldContractStatus = [select Contract_Status__c from Contract where id = :newcontr.id].Contract_Status__c;
            system.debug('oldContractStatus **'+oldContractStatus );
        }
        //-----End----------
        try
        {
        //02217136 
            if(newcontr.Other_contract_type__c!=null){
            newcontr.Contract_Type__c=newcontr.Contract_Type__c+';'+newcontr.Other_contract_type__c;
        List<String> rmList=newcontr.Contract_Type__c.split(';');
        String cntype;
        cntype='';
        for(String s:rmList){
            if(s!='other' && s!='null'){
                cntype=cntype+';'+s;
                cntype.removeStart(';');
            }
        }
        system.debug('abc'+cntype);
        Other_Contract_Type=false;
        newcontr.Contract_Type__c=cntype;
        newcontr.Other_contract_type__c=null;
        }
        //02217136 
            //Subhro Clone functionality
            Clone= ApexPages.currentPage().getParameters().get('clone');
            if(clone=='1')
            {
                Contract cloneContract= new Contract();
                cloneContract = newcontr.clone(false, true);
                insert cloneContract;
                newcontr= cloneContract;
                system.debug('The cloned contract id'+newcontr);
            }
            //End
            else
            {
            
            
        
                upsert newcontr;
            }
            
            contractvalue=newcontr.id;
            activetabvalue=Activetab;
            
           }
        catch(Exception ex)
        {
            ApexPages.addMessages(ex);
            cloneflag=true;
           
        }
        
        //-----Added on 18th July
        if(oldContractStatus !=null){
            if(oldContractStatus != 'Closed/Cancelled' && newcontr.Contract_Status__c== 'Closed/Cancelled'){
                CallSpringCM_workflow(String.valueOf(newcontr.Id));
            }
        }
        //-------End-------------
        
        if(ActiveTab <> 'close')
        {
            contractref = new PageReference('/apex/SpringcmContract2?id=' + newcontr.Id+'&at='+ActiveTab );
            //system.assertEquals('Yes', newcontr.Performance_Notification_Req_in_contract__c);
           try
           {
               //Added by Pune Team/Mohit Support Number-02469967
                 CustomerFeesGridSave();
                  PerformanceNotificationRequirements();
                Database.upsertResult uResults = Database.upsert(newcontr,true);
                system.debug('Success1111'+uResults);
                if (uResults.isSuccess()&&cloneflag==false)
                {
                    system.debug('Success'+newcontr.id);
                    callfunc='<script> savesuccess(); </script>';
                }
           }catch(exception ex)
           {
                ApexPages.addMessages(ex);
           }
             cloneflag=false;
        }
        else
        {
            contractref = new PageReference('/' + newcontr.AccountId);
            contractref.setRedirect(true);
            return contractref;
        }
        return null;
    }
    
    public PageReference Cancel()
    {
        PageReference accountRef = new PageReference('/'+ newcontr.AccountId);
        return accountRef;
    }
    
    public PageReference deleteContractItem()
    {
        delete newcontr;
        PageReference accountRef = new PageReference('/'+ newcontr.AccountId);
        return accountRef;
    }
    
    public PageReference deletepricingterm()
    {
        
        String ContractPricing= ApexPages.currentPage().getParameters().get('selectedRecord');
        system.debug('The Pricing id'+ContractPricing);
        if(ContractPricing!=null)
        {
            Contract_Pricing_Terms__c ContractPricing_alias=[Select id from Contract_Pricing_Terms__c where id=:ContractPricing];
            delete ContractPricing_alias;
            system.debug('Custom Delete');
            PageReference curPage = ApexPages.currentPage();
            curPage.getParameters().put('success','true');
            curPage.getParameters().put('id',Apexpages.currentPage().getParameters().get('id'));
            curPage.setRedirect(true);
            return curPage;
            
            
            
        }
        // pageReference pr1;
        //string s1 = '/apex/springcmContract2?id='+newcontr.id;
        //system.debug('pagereference'+s1);
        //return new PageReference('/apex/springcmContract2?id='+newcontr.id);//new PageReference(s1);
        return null;
        
        
    }
    public PageReference redirectnew()
    {
        PageReference Pricingtermsnew;
        if(UserInfo.getOrganizationId() == '00DE0000000J4oSMAS'){
            Pricingtermsnew = new PageReference('/apex/Contract_Pricing_Terms_edit_page?CF00NE0000001v8i2='+newcontr.ContractNumber+'&CF00NE0000001v8i2_lkid='+newcontr.Id+'&scontrolCaching=1&retURL=%2Fapex%2FSpringCMContract2%3Fid%3D'+newcontr.Id+'%26sfdc.override%3D1&sfdc.override=1');
        }else{
            //Pricingtermsnew = new PageReference('/apex/Contract_Pricing_Terms_edit_page?CF00NM0000000z2Lr='+newcontr.ContractNumber+'&CF00NM0000000z2Lr_lkid='+newcontr.Id+'&scontrolCaching=1&retURL=%2Fapex%2FSpringCMContract2%3Fid%3D'+newcontr.Id+'%26sfdc.override%3D1&sfdc.override=1');
            Pricingtermsnew = new PageReference('/apex/Contract_Pricing_Terms_edit_page?CF00NE0000001v8i2='+newcontr.ContractNumber+'&CF00NE0000001v8i2_lkid='+newcontr.Id+'&scontrolCaching=1&retURL=%2Fapex%2FSpringCMContract2%3Fid%3D'+newcontr.Id+'%26sfdc.override%3D1&sfdc.override=1');
        }
        return Pricingtermsnew;
    }
    // added by Rohini on part of testing the lightning component for CPT
    public PageReference redirectnewlightning()
    {
        PageReference Pricingtermsnew;
        /*  if(UserInfo.getOrganizationId() == '00DE0000000J4oSMAS'){
Pricingtermsnew = new PageReference('/apex/Contract_Pricing_Terms_edit_page?CF00NE0000001v8i2='+newcontr.ContractNumber+'&CF00NE0000001v8i2_lkid='+newcontr.Id+'&scontrolCaching=1&retURL=%2Fapex%2FSpringCMContract2%3Fid%3D'+newcontr.Id+'%26sfdc.override%3D1&sfdc.override=1');
}else{*/
        //Pricingtermsnew = new PageReference('/apex/Contract_Pricing_Terms_edit_page?CF00NM0000000z2Lr='+newcontr.ContractNumber+'&CF00NM0000000z2Lr_lkid='+newcontr.Id+'&scontrolCaching=1&retURL=%2Fapex%2FSpringCMContract2%3Fid%3D'+newcontr.Id+'%26sfdc.override%3D1&sfdc.override=1');
        Pricingtermsnew = new PageReference('/apex/ContractPricingTermsPage?ParentId='+newcontr.Id+'&mode=Edit');
        // }
        return Pricingtermsnew;
    }
    public PageReference saveContractLegal()
    {
        try
        {
            upsert newcontr;
        }
        catch(DmlException ex)
        {
            system.debug('#### Exception: ' + ex);
            ApexPages.addMessages(ex);
        }
        return null;
    }
    //START NSHARP S-334902 7.21.15
    public List<String> validateInfo(Contract c){
        //Added by Najma Ateeq for Story #S-355231
        Schema.DescribeSObjectResult describeSObjectResultObj = Schema.getGlobalDescribe().get('Contract').getDescribe();//get schema of Contract object
        List<String> selectFields = new List<String>();
        if(describeSObjectResultObj != null){
            Schema.FieldSet fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get('Error_Field_Set');//get field set called Error_Field_Set
            if(fieldSetObj != null){
                for(Schema.FieldSetMember fieldSetMemberObj : fieldSetObj.getFields())
                {
                    if (fieldSetMemberObj.getType()==Schema.DisplayType.PICKLIST){ //needs to be worked for Picklist type fields
                        System.debug('Test error: ' + fieldSetMemberObj.getFieldPath());
                        if(c.get(fieldSetMemberObj.getFieldPath()) == 'None'){//Updated by Akanksha for story S-351420
                            //system.debug('#### name: ' + fieldSetMemberObj.getLabel() + ' = ' + c.get(fieldSetMemberObj.getFieldPath()));
                            //Connor Flynn Case 00134934 changed to != custom to avoid data issues
                            system.debug(c + fieldSetMemberObj.getLabel());
                            /* Case 00168674 LSLEVIN Commented out 5.24.16 START
if(c.Contract_cover_NonCore_Cat_setup_pricing__c != null && !(c.Contract_cover_NonCore_Cat_setup_pricing__c.equals('Yes')) && (fieldSetMemberObj.getLabel() == 'Decr req to be applied to NonCore Cat' || fieldSetMemberObj.getLabel() == 'Cust notif to chg Cust NonCore Cat Prcin')){
//do nothing
}
else if(!(fieldSetMemberObj.getLabel() == 'NCC Update Frequency (In days)' && c.Is_there_a_custom_NCC__c != 'Custom'))//Added condition by Akanksha for story S-351420
{    if(fieldSetMemberObj.getLabel() != 'NCC Type?'){ // Added by Ankush to avoid Ncc None error for case 00141368
selectFields.add(fieldSetMemberObj.getLabel());
}
}Case 00168674 LSLEVIN Commented out 5.24.16 END*/
                        }
                        System.debug('Test error: Here');
                    }
                }
            }
        }
        return selectFields;
        //End - Added by Najma Ateeq for Story #S-355231
        /* commented by Najma Ateeq for Story #S-355231
Map<String, Schema.SObjectField> fMap =Schema.getGlobalDescribe().get('contract').getDescribe().Fields.getMap();
List<String> selectFields = new List<String>();
if(fMap!=null){
for(Schema.SObjectField ft : fMap.values()){ //loop through all field tokens (ft)
Schema.DescribeFieldResult fd = ft.getDescribe(); //describe each field (fd)
if (fd.isUpdateable() && fd.getType()==Schema.DisplayType.PICKLIST){ //field is updateable

if(c.get(fd.getName()) == 'None'){//Updated by Akanksha for story S-351420
system.debug('#### name: ' + fd.getLabel() + ' = ' + c.get(fd.getName()));
//Connor Flynn Case 00134934 changed to != custom to avoid data issues
if(!(fd.getLabel() == 'NCC Update Frequency (In days)' && c.Is_there_a_custom_NCC__c != 'Custom'))//Added condition by Akanksha for story S-351420
{
selectFields.add(fd.getLabel());
}
}
}
}
}
return selectFields;*/
    }
    //END NSHARP S-334902 7.21.15
    
    //Modified By Vipul Jain for Story#S-457177 (00899744 - Tier 1: Story 21.1 Partner-Level Contract Object) on December 30,2016
    //START
    public PageReference redirectToPage(){
        Id RecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        ID recordId = ApexPages.currentPage().getParameters().get('id');
        ID accId = ApexPages.currentPage().getParameters().get('accid');
        List<RecordType> lstRecordType = new List<RecordType>([SELECT Id, Name FROM RecordType where id =:RecordTypeId]);
        List<Contract> lstContract = new List<Contract>([Select Id, RecordType.Name from Contract where id=: recordId]);
        String isClone = ApexPages.currentPage().getParameters().get('clone');
        String returnUrl = ApexPages.currentPage().getParameters().get('retURL');
        String retrievedURL = ApexPages.currentPage().getURL();
        Map<String, String> params  =  ApexPages.currentPage().getParameters();
        if(recordId == null &&  !lstRecordType.isEmpty() && lstRecordType.get(0).Name ==Constants.STANDARD_CONTRACT_RECORD_TYPE){
            if(retrievedURL.contains('save_new') && retrievedURL.contains('accid')) { 
            params.remove('save_new');
            PageReference currentPage = ApexPages.currentPage();
            currentPage.getParameters().putAll(params);
    currentPage  =  new PageReference(currentPage.getURL());
    currentPage.setRedirect(true);
    return currentPage;
            }
        }else{
        if(recordId == null && !lstRecordType.isEmpty() && lstRecordType.get(0).Name !=Constants.STANDARD_CONTRACT_RECORD_TYPE ){
            //To Identify Creation of new record
            if(retrievedURL.contains('save_new') || retrievedURL.contains('save_new_url')){
                params.remove('save_new');
              
                PageReference p1= new PageReference('/800/e?nooverride=1');
                p1.getParameters().putAll(params);
                return p1.setRedirect(true);
            }
            
            else{
                PageReference p1= new  PageReference('/800/e?nooverride=1&retURL=%2F800&RecordType='+lstRecordType.get(0).id+'&ent=Contract');
                return p1.setRedirect(true);
            }
            
        }
        
        else if(!lstContract.isEmpty() && lstContract.get(0).RecordType.Name !=Constants.STANDARD_CONTRACT_RECORD_TYPE){
            PageReference p1;
            if(isClone=='1'){
                p1= new  PageReference('/'+recordId+'/e?clone=1&nooverride=1&retURL='+returnUrl); //To Identify Clone Mode
            }
            else if(retrievedURL.contains('retURL') && isClone!='1'){
                if(!lstRecordType.isEmpty())
                  p1= new  PageReference('/'+recordId+'/e?nooverride=1&RecordType='+lstRecordType.get(0).id+'&retURL='+returnUrl);  //To Identify Edit Mode
                else
                 p1= new  PageReference('/'+recordId+'/e?nooverride=1&retURL='+returnUrl);  //To Identify Edit Mode

            }
            else{
                p1= new  PageReference('/'+recordId+'?nooverride=1'); //To Identify View Mode
            }
            
            return p1.setRedirect(true);
        }
        }
        return null;
        
    }
    //END-Vipul
    /* added new method CSFconditionaldisplay for all CSF related tickects.
    public void Is_this_a_renewal() {
        Is_this_a_renewal_Display = false;
        if (newcontr.Is_this_a_renewal__c == 'Yes') {
            Is_this_a_renewal_Display = true;
        }
        else {
            Is_this_a_renewal_Display = false;
            newcontr.Refer_to_Prior_CSF__c = '';
        }
    }
    
    Public void Forced_inheritance_no_custom_cores()
    {
        
        newcontr.Forced_inheritance_no_custom_cores__c=newcontr.Agreement_allow_for_custom_cores__c=='No (Forced inheritance)'?true:false;
        //newcontr.Custom_core_item_count__c=null;
        if(newcontr.Agreement_allow_for_custom_cores__c!='Yes'){
            newcontr.Custom_core_item_count__c= null;
            newcontr.Item_count_restrictions__c= null;
        }
        if(newcontr.Custom_core_item_count__c!='Yes'){
            system.debug('hiii---'+newcontr.Item_count_restrictions__c);
            newcontr.Item_count_restrictions__c= null;
            system.debug('hiii--1055-'+newcontr.Item_count_restrictions__c);
        }
        
    }
    
    Public void CostBasis(){
        if(newcontr.Cost_basis__c!='Other'){ 
          newcontr.Other_cost_basis__c=null;
    }
    
    }
    */
    Public void CSFconditionaldisplay()
    {
        // Ticket no:1 start
        Is_this_a_renewal_Display = false;
        if (newcontr.Is_this_a_renewal__c == 'Yes') {
            Is_this_a_renewal_Display = true;
        }
        else {
            Is_this_a_renewal_Display = false;
            newcontr.Refer_to_Prior_CSF__c = '';
        }
         // Ticket no:1 End
         //  Ticket no:2 Start
         //  
         //  02240409
      
        if((newcontr.Agreement_allow_for_custom_cores__c!='No (Forced inheritance)'&&Forcedinheritance==true)||
           (Forcedinheritance==false&& newcontr.Agreement_allow_for_custom_cores__c=='No (Forced inheritance)'))
        {
          
        }
         else
        {
            
            newcontr.Forced_inheritance_no_custom_cores__c= newcontr.Agreement_allow_for_custom_cores__c=='No (Forced inheritance)'?true:false;
        }
        
          Forcedinheritance=null;
       // system.debug('newcontr.Forced_inheritance_no_custom_cores__c'+newcontr.Forced_inheritance_no_custom_cores__c);
        if(newcontr.Agreement_allow_for_custom_cores__c!='Yes'){
            newcontr.Custom_core_item_count__c= null;
            newcontr.Item_count_restrictions__c= null;
            newcontr.Item_count_limit__c=null;
            newcontr.Item_count_threshold_tier_From1__c= null;
            newcontr.Item_count_threshold_tier_To1__c= null;
            newcontr.Item_count_threshold_tier_Count1__c= null;
            newcontr.Item_count_threshold_tier_From2__c= null;
            newcontr.Item_count_threshold_tier_To2__c= null;
            newcontr.Item_count_threshold_tier_Count2__c= null;
            newcontr.Item_count_threshold_tier_From3__c= null;
            newcontr.Item_count_threshold_tier_To3__c= null;
            newcontr.Item_count_threshold_tier_Count3__c= null;
            newcontr.Item_count_threshold_tier_From4__c= null;
            newcontr.Item_count_threshold_tier_To4__c= null;
            newcontr.Item_count_threshold_tier_Count4__c= null;
            newcontr.Item_count_threshold_tier_From5__c= null;
            newcontr.Item_count_threshold_tier_To5__c= null;
            newcontr.Item_count_threshold_tier_Count5__c= null;
            
        }

        if(newcontr.Custom_core_item_count__c!='Yes'){
            newcontr.Item_count_restrictions__c= null;
            newcontr.Item_count_limit__c=null;
            newcontr.Item_count_threshold_tier_From1__c= null;
            newcontr.Item_count_threshold_tier_To1__c= null;
            newcontr.Item_count_threshold_tier_Count1__c= null;
            newcontr.Item_count_threshold_tier_From2__c= null;
            newcontr.Item_count_threshold_tier_To2__c= null;
            newcontr.Item_count_threshold_tier_Count2__c= null;
            newcontr.Item_count_threshold_tier_From3__c= null;
            newcontr.Item_count_threshold_tier_To3__c= null;
            newcontr.Item_count_threshold_tier_Count3__c= null;
            newcontr.Item_count_threshold_tier_From4__c= null;
            newcontr.Item_count_threshold_tier_To4__c= null;
            newcontr.Item_count_threshold_tier_Count4__c= null;
            newcontr.Item_count_threshold_tier_From5__c= null;
            newcontr.Item_count_threshold_tier_To5__c= null;
            newcontr.Item_count_threshold_tier_Count5__c= null;
        }
       /* if(newcontr.Item_count_restrictions__c==null){
            newcontr.Item_count_limit__c=null;
            newcontr.Item_count_threshold_tier_From1__c= null;
            newcontr.Item_count_threshold_tier_To1__c= null;
            newcontr.Item_count_threshold_tier_Count1__c= null;
            newcontr.Item_count_threshold_tier_From2__c= null;
            newcontr.Item_count_threshold_tier_To2__c= null;
            newcontr.Item_count_threshold_tier_Count2__c= null;
            newcontr.Item_count_threshold_tier_From3__c= null;
            newcontr.Item_count_threshold_tier_To3__c= null;
            newcontr.Item_count_threshold_tier_Count3__c= null;
            newcontr.Item_count_threshold_tier_From4__c= null;
            newcontr.Item_count_threshold_tier_To4__c= null;
            newcontr.Item_count_threshold_tier_Count4__c= null;
            newcontr.Item_count_threshold_tier_From5__c= null;
            newcontr.Item_count_threshold_tier_To5__c= null;
            newcontr.Item_count_threshold_tier_Count5__c= null;
        }
        if(newcontr.Item_count_restrictions__c!='Single'){
             newcontr.Item_count_limit__c=null;
            newcontr.Item_count_threshold_tier_From1__c=null;
            newcontr.Item_count_threshold_tier_From2__c=null;
            newcontr.Item_count_threshold_tier_From3__c=null;
            newcontr.Item_count_threshold_tier_From4__c=null;
            newcontr.Item_count_threshold_tier_From5__c=null;
            newcontr.Item_count_threshold_tier_To1__c=null;
            newcontr.Item_count_threshold_tier_To2__c=null;
            newcontr.Item_count_threshold_tier_To3__c=null;
            newcontr.Item_count_threshold_tier_To4__c=null;
            newcontr.Item_count_threshold_tier_To5__c=null;
            newcontr.Item_count_threshold_tier_Count1__c=null;
            newcontr.Item_count_threshold_tier_Count2__c=null;
            newcontr.Item_count_threshold_tier_Count3__c=null;
            newcontr.Item_count_threshold_tier_Count4__c=null;
            newcontr.Item_count_threshold_tier_Count4__c=null;
         }
        if(newcontr.Item_count_restrictions__c=='Single'){
                newcontr.Item_count_threshold_tier_From1__c=0;
                newcontr.Item_count_threshold_tier_From2__c=0;
                newcontr.Item_count_threshold_tier_From3__c=0;
                newcontr.Item_count_threshold_tier_From4__c=0;
                newcontr.Item_count_threshold_tier_From5__c=0;
                newcontr.Item_count_threshold_tier_To1__c=0;
                newcontr.Item_count_threshold_tier_To2__c=0;
                newcontr.Item_count_threshold_tier_To3__c=0;
                newcontr.Item_count_threshold_tier_To4__c=0;
                newcontr.Item_count_threshold_tier_To5__c=0;
                newcontr.Item_count_threshold_tier_Count1__c=null;
                newcontr.Item_count_threshold_tier_Count2__c=null;
                newcontr.Item_count_threshold_tier_Count3__c=null;
                newcontr.Item_count_threshold_tier_Count4__c=null;
                newcontr.Item_count_threshold_tier_Count4__c=null;
               
         }*/
        //  Ticket no:2 End
        //  Ticket no:3 start
        
          if(newcontr.Cost_basis__c!='Other'){ 
                  newcontr.Other_cost_basis__c=null;
            }
        //Ticket no:3 End
        Display_Point_of_sale_or_rebate_option_language=false;
       if(newcontr.Point_of_sale_or_rebate_option__c!=true)
            newcontr.Point_of_sale_or_rebate_option_language__c=null;
       else
            Display_Point_of_sale_or_rebate_option_language=true;

   
   Display_IT=false;
        if(newcontr.IT_security_breach_notice_obligation__c!='Yes'){
            system.debug('@@@@@@@'+newcontr);
            newcontr.IT_security_breach_obligation_lang__c=null;
            
        }
        else
            Display_IT=true;
        //02401235 
   /* Display_Flex=false;
        if(newcontr.Is_this_a_Flex_program_contract__c!='Yes'){
            system.debug('@@@@@@@'+newcontr);
            newcontr.Flex_program_language__c=null;
            
        }
        else
            Display_Flex=true;*/
    //02401235     
    //02401214  
   /* Display_master=false;
        if(newcontr.Is_this_a_Master_program_contract__c!='Yes'){
           system.debug(Display_master+'check');
            system.debug('@@@@@@@'+newcontr+'master');
            newcontr.Master_program_language__c=null;
            
        }
        else{
            system.debug('master lang');
            Display_master=true;
        }*/
    //02401214      
        newcontr.Web_indicators_language__c=newcontr.indicators_required_by_written_agreement__c==true?newcontr.Web_indicators_language__c:null;
        newcontr.No_customization_on_inherited_core_sku__c=newcontr.Agreement_allow_for_custom_cores__c=='Yes'?newcontr.No_customization_on_inherited_core_sku__c:null;
        newcontr.Custom_items_must_from_specific_formular__c=newcontr.Agreement_allow_for_custom_cores__c=='Yes'?newcontr.Custom_items_must_from_specific_formular__c:null;
        newcontr.Custom_pricing_should_not_be_more_or_les__c=newcontr.Agreement_allow_for_custom_cores__c=='Yes'?newcontr.Custom_pricing_should_not_be_more_or_les__c:null;
        newcontr.Next_day_delivery_language__c=newcontr.Next_day_delivery__c=='Yes'?newcontr.Next_day_delivery_language__c:null;
        newcontr.Termination_clause_language__c=newcontr.Termination_clause__c==true?newcontr.Termination_clause_language__c:null;
        //02230780
        newcontr.Custom_core_written_agreement_language__c=newcontr.Agreement_allow_for_custom_cores__c=='Yes'?newcontr.Custom_core_written_agreement_language__c:null;
        
        if('Yes'.equals(newcontr.Is_there_a_Point_of_Sale_Discount__c))
            legal_pos_display = true;
        else
        {
            legal_pos_display = false;
            newcontr.Point_of_Sale_Discount_levels_per_contra__c = null;
            newcontr.Start_date_of_Point_of_Sale_Discount__c = null;
            newcontr.End_date_of_Point_of_Sale_Discount__c = null;
            
            newcontr.Point_of_sales_tiers_Form1__c=null;
            newcontr.Point_of_sales_tiers_To1__c=null;
            newcontr.Point_of_sales_tiers_Discount1__c=null;
            
            newcontr.Point_of_sales_tiers_Form2__c=null;
            newcontr.Point_of_sales_tiers_To2__c=null;
            newcontr.Point_of_sales_tiers_Discount2__c=null;
            
            newcontr.Point_of_sales_tiers_Form3__c=null;
            newcontr.Point_of_sales_tiers_To3__c=null;
            newcontr.Point_of_sales_tiers_Discount3__c=null;
            
            newcontr.Point_of_sales_tiers_Form4__c=null;
            newcontr.Point_of_sales_tiers_To4__c=null;
            newcontr.Point_of_sales_tiers_Discount4__c=null;

            newcontr.Point_of_sales_tiers_Form5__c=null;
            newcontr.Point_of_sales_tiers_To5__c=null;
            newcontr.Point_of_sales_tiers_Discount5__c=null;

            
        }
        //02229076
        system.debug('========newcontr.SKU_level_pricing__c===='+newcontr.SKU_level_pricing__c);
        newcontr.SKU_level_pricing_language__c=newcontr.SKU_level_pricing__c==true?newcontr.SKU_level_pricing_language__c:null;
        //02229078
        newcontr.CPD_tiered_discount_language__c=newcontr.Tiered_discounts_on_CPD__c==true?newcontr.CPD_tiered_discount_language__c:null;
       //02229084
        newcontr.Other_discount_basis__c=newcontr.NCC_discount_basis__c=='Other'?newcontr.Other_discount_basis__c:null; 
        newcontr.Variable_NCC_discount_language__c=newcontr.Variable_NCC_discount__c=='Other'?newcontr.Variable_NCC_discount_language__c:null;
         if(newcontr.NCNC_governed_by_the_agreement__c!='Yes')
         {
             newcontr.Prod_Assortment_is_response_based_upon__c=null;
             newcontr.NCNC_Type__c=null;
             newcontr.Non_Core_None_Catalog_description__c=null;
             newcontr.Decreases_to_Cust_Non_Core_Non_Catalog__c=null;
                       
         }
        
        //02224564 start
        if(newcontr.NCNC_governed_by_the_agreement__c=='Yes'){
            if(newcontr.NCNC_Type__c==null)
            newcontr.NCNC_Type__c=picklistdefaultValue('Contract','NCNC_Type__c');
            if(newcontr.Decreases_to_Cust_Non_Core_Non_Catalog__c==null)
            newcontr.Decreases_to_Cust_Non_Core_Non_Catalog__c=picklistdefaultValue('Contract','Decreases_to_Cust_Non_Core_Non_Catalog__c');
            }
        //02224564 end
        
        //02323304 Start
        party_required = false;
        if(newcontr.X3rd_party_required_to_provide_a_securit__c == 'Yes') {
            party_required= true;
        }    
       
        
        if(newcontr.X3rd_party_required_to_provide_a_securit__c!='Yes'){
           newcontr.Security_assessment_frequency__c=null;       
       }
       //02323304  End

             
    }
   // CSFconditionaldisplayRo
    public void CSFconditionaldisplayRo()
    {//02247646
        Work_with_documentation_required = false;
        if(newcontr.Documentation_confirmation_required_to_p__c == 'Yes') {
            Work_with_documentation_required= true;
        }    
        //02247646  
        //02240354
        Work_with_desktop_delivery = false;
        if(newcontr.Desktop_delivery__c == 'Yes') {
            Work_with_desktop_delivery= true;
        }       
        //02240354  
        //
        Work_with_annual_volume = false;
        if(newcontr.Does_written_agreement_allow_for_price__c == 'Yes') {
            Work_with_annual_volume= true;
        }       
        //
       if(newcontr.Documentation_confirmation_required_to_p__c!='Yes'){
           
           newcontr.Participation_requirement__c=null; 
       } 
       if(newcontr.Desktop_delivery__c!='Yes'){
           newcontr.Desktopdelivery_language__c=null;         
       }
       if(newcontr.Non_standard_callout__c!=true){
           newcontr.Nonstandard_language__c=null;       
       }    
        //02224563
         if(newcontr.Document_s_missing__c!=true){
           newcontr.Missing_document_s_notes__c=null;       
       }  
        //02224563
        //02229060
         if(newcontr.Does_written_agreement_allow_for_price__c!='Yes'){
           newcontr.Core_of_annual_volume__c=null;       
       } 
        //0222906
        
        //02217136 
        Other_Contract_Type=false;
       
        
        if(newcontr.Contract_Type__c=='' || newcontr.Contract_Type__c==null){
            system.debug('null');
            Other_Contract_Type=false;
        }
        else if(newcontr.Contract_Type__c.contains('OTHER')){
            system.debug('other');
        Other_Contract_Type=True;
        }
        else if(!newcontr.Contract_Type__c.contains('OTHER')){
            system.debug('not other');
            Other_Contract_Type=false;
            newcontr.Other_contract_type__c=null;
        }
        //02217136
        
        
   }
    
    public void Item_count_conditionaldisplay(){
        
        if(newcontr.Item_count_restrictions__c==null){
            newcontr.Item_count_limit__c=null;
            newcontr.Item_count_threshold_tier_From1__c= null;
            newcontr.Item_count_threshold_tier_To1__c= null;
            newcontr.Item_count_threshold_tier_Count1__c= null;
            newcontr.Item_count_threshold_tier_From2__c= null;
            newcontr.Item_count_threshold_tier_To2__c= null;
            newcontr.Item_count_threshold_tier_Count2__c= null;
            newcontr.Item_count_threshold_tier_From3__c= null;
            newcontr.Item_count_threshold_tier_To3__c= null;
            newcontr.Item_count_threshold_tier_Count3__c= null;
            newcontr.Item_count_threshold_tier_From4__c= null;
            newcontr.Item_count_threshold_tier_To4__c= null;
            newcontr.Item_count_threshold_tier_Count4__c= null;
            newcontr.Item_count_threshold_tier_From5__c= null;
            newcontr.Item_count_threshold_tier_To5__c= null;
            newcontr.Item_count_threshold_tier_Count5__c= null;
        }
        /*if(newcontr.Item_count_restrictions__c!='Single'){
             newcontr.Item_count_limit__c=null;
            newcontr.Item_count_threshold_tier_From1__c=null;
            newcontr.Item_count_threshold_tier_From2__c=null;
            newcontr.Item_count_threshold_tier_From3__c=null;
            newcontr.Item_count_threshold_tier_From4__c=null;
            newcontr.Item_count_threshold_tier_From5__c=null;
            newcontr.Item_count_threshold_tier_To1__c=null;
            newcontr.Item_count_threshold_tier_To2__c=null;
            newcontr.Item_count_threshold_tier_To3__c=null;
            newcontr.Item_count_threshold_tier_To4__c=null;
            newcontr.Item_count_threshold_tier_To5__c=null;
            newcontr.Item_count_threshold_tier_Count1__c=null;
            newcontr.Item_count_threshold_tier_Count2__c=null;
            newcontr.Item_count_threshold_tier_Count3__c=null;
            newcontr.Item_count_threshold_tier_Count4__c=null;
            newcontr.Item_count_threshold_tier_Count4__c=null;
         }*/
        if(newcontr.Item_count_restrictions__c=='Single'){
                newcontr.Item_count_threshold_tier_From1__c=0;
                newcontr.Item_count_threshold_tier_From2__c=0;
                newcontr.Item_count_threshold_tier_From3__c=0;
                newcontr.Item_count_threshold_tier_From4__c=0;
                newcontr.Item_count_threshold_tier_From5__c=0;
                newcontr.Item_count_threshold_tier_To1__c=0;
                newcontr.Item_count_threshold_tier_To2__c=0;
                newcontr.Item_count_threshold_tier_To3__c=0;
                newcontr.Item_count_threshold_tier_To4__c=0;
                newcontr.Item_count_threshold_tier_To5__c=0;
                newcontr.Item_count_threshold_tier_Count1__c=null;
                newcontr.Item_count_threshold_tier_Count2__c=null;
                newcontr.Item_count_threshold_tier_Count3__c=null;
                newcontr.Item_count_threshold_tier_Count4__c=null;
                newcontr.Item_count_threshold_tier_Count4__c=null;
               
         }
        else{
            newcontr.Item_count_threshold_tier_From1__c=null;
            newcontr.Item_count_threshold_tier_From2__c=null;
            newcontr.Item_count_threshold_tier_From3__c=null;
            newcontr.Item_count_threshold_tier_From4__c=null;
            newcontr.Item_count_threshold_tier_From5__c=null;
            newcontr.Item_count_threshold_tier_To1__c=null;
            newcontr.Item_count_threshold_tier_To2__c=null;
            newcontr.Item_count_threshold_tier_To3__c=null;
            newcontr.Item_count_threshold_tier_To4__c=null;
            newcontr.Item_count_threshold_tier_To5__c=null;
            newcontr.Item_count_threshold_tier_Count1__c=null;
            newcontr.Item_count_threshold_tier_Count2__c=null;
            newcontr.Item_count_threshold_tier_Count3__c=null;
            newcontr.Item_count_threshold_tier_Count4__c=null;
            newcontr.Item_count_threshold_tier_Count4__c=null;
        }
    }
    
  public static string picklistdefaultValue(String objectName, String fieldName) {
        Map<String, String> values = new Map<String, String>{};

        List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(new List<String>{objectName});
        
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                if ((entry.defaultValue)){
                 return entry.getValue();
            }
            }
        }

        return null;
    }
    
    //02217021 Start
    Public void   PerformanceNotificationRequirements_getPicklistvalues(){
             wrplist= New List<wrpclass>();
               Schema.DescribeFieldResult PerformanceNotificationRequirements = Contract.Performance_Notification_Requirements__c.getDescribe();
            for (Schema.Picklistentry picklistEntry:PerformanceNotificationRequirements.getPicklistValues()){
                //Modified by Asif Khan as updated the condition and added the check "picklistEntry.getValue()!='Other'" as part of NAIT-113609 on 23rd JAN 2020
                if (picklistEntry.getValue()!='none' && picklistEntry.getValue()!='Other'){
                   wrpclass w=New wrpclass();
                    w.Picklistvalue=picklistEntry.getValue();
                    wrplist.add(w);
                }
            }  
    }
     Public void PerformanceNotificationRequirements_Onload()
     {
        
          Set<String> sPNR=New Set<String>();
          Set<String> sPNM=New Set<String>();
         
         if(newcontr.Performance_Notification_Requirements__c!=null&&newcontr.Performance_Notification_Requirements__c!='')
         {
             sPNR.addall(newcontr.Performance_Notification_Requirements__c.split(';'));
             
         }
         
         if(newcontr.Penalty_for_not_meeting__c!=null&&newcontr.Penalty_for_not_meeting__c!='')
         {
               sPNM.addall(newcontr.Penalty_for_not_meeting__c.split(';'));
         }

             for(wrpclass w:wrplist)
             {
                 if(!sPNR.isEmpty()&&sPNR.contains(w.Picklistvalue))
                     w.Yes_checkbox=true;
                 
                  if(!sPNM.isEmpty()&&sPNM.contains(w.Picklistvalue))
                      w.Penalty_checkbox=true;
             }
     }
    Public void PerformanceNotificationRequirements()
    {
        newcontr.Performance_Notification_Requirements__c=null;
        newcontr.Penalty_for_not_meeting__c=null;
        
        for(wrpclass w:wrplist)
        {
            If(w.Yes_checkbox)
             newcontr.Performance_Notification_Requirements__c=newcontr.Performance_Notification_Requirements__c==null?w.Picklistvalue:newcontr.Performance_Notification_Requirements__c+';'+w.Picklistvalue;
            
             if(w.Penalty_checkbox) 
               newcontr.Penalty_for_not_meeting__c=newcontr.Penalty_for_not_meeting__c==null?w.Picklistvalue:newcontr.Penalty_for_not_meeting__c+';'+w.Picklistvalue;
           
        }
         
    }
    
    
    Public class wrpclass
    {
        Public String Picklistvalue{set;get;}
        Public Boolean Yes_checkbox{set;get;}
        Public Boolean Penalty_checkbox{set;get;}
        
        Public wrpclass()
        {
            Yes_checkbox=false;
            Penalty_checkbox=false;
        }
         
    }
      //02217021 End
      
      //Added by Pune Team/Mohit Support Number-02469967
      
      Public void CustomerFeesGridSave()
    {
        newcontr.Customer_fees__c=null;
        integer count=0;
        
        for(WrapClassCustomerfees w: customerFessList)
        {
            If(w.Yes_checkbox)
             newcontr.Customer_fees__c=newcontr.Customer_fees__c==null?w.Picklistvalue:newcontr.Customer_fees__c+';'+w.Picklistvalue;
             
             
            
            switch on count {
                when 0 {
                  newcontr.Bulk_item_fee_language__c = w.feeLanguage;
                }
                when 1 {
                 newcontr.Imports_fee_language__c = w.feeLanguage;   
                }
                when 2 {
                    newcontr.Printed_catalog_fee_language__c = w.feeLanguage;
                }
                when 3 {
                    newcontr.Reporting_fee_language__c = w.feeLanguage;
                    
                }
                when 4 {
                    newcontr.Hosted_catalog_fee_language__c = w.feeLanguage;
                    
                }
                when 5 {
                    newcontr.Desktop_delivery_fee_language__c = w.feeLanguage;
                    
                }
                when 6 {
                    newcontr.Storeroom_stocking_fee_language__c = w.feeLanguage;
                    
                }
                when 7 {
                    newcontr.Customer_item_warehousing_fee_language__c = w.feeLanguage;
                    
                }
                when 8 {
                    newcontr.EDI_fee_language__c = w.feeLanguage;
                    
                }
                when 9 {
                    newcontr.VW_shipping_fee_language__c = w.feeLanguage;
                    
                }
                when 10 {
                    newcontr.Return_fee_language__c = w.feeLanguage;
                    
                }
            }
            count = count + 1;
        }
         
    }
    
    Public void CustomerFees_Onload()
     {
        
          Set<String> sPNR=New Set<String>();
          
         
         if(newcontr.Customer_fees__c!=null&&newcontr.Customer_fees__c!='')
         {
             sPNR.addall(newcontr.Customer_fees__c.split(';'));
             
         }
         
        integer count = 0;

             for(WrapClassCustomerfees w: customerFessList)
             {
                 
                 if(!sPNR.isEmpty()&&sPNR.contains(w.Picklistvalue))
                     w.Yes_checkbox=true;
                     
                 switch on count {
                when 0 {
                    
                  if(newcontr.Bulk_item_fee_language__c!=null&&newcontr.Bulk_item_fee_language__c!='')
                  {
                    w.feeLanguage = newcontr.Bulk_item_fee_language__c;   
                  }
                    else
                    {
                        w.feeLanguage = '';   
                    }
                  
                }
                when 1 {
                    
                    if(newcontr.Imports_fee_language__c!=null&&newcontr.Imports_fee_language__c!='')
                    {
                        w.feeLanguage = newcontr.Imports_fee_language__c; 
                    }
                    else
                    {
                        w.feeLanguage = '';   
                    }
                  
                }
                when 2 {
                    if(newcontr.Printed_catalog_fee_language__c!=null&&newcontr.Printed_catalog_fee_language__c!='')
                    {
                    w.feeLanguage = newcontr.Printed_catalog_fee_language__c;
                    }
                    else
                    {
                        w.feeLanguage = '';   
                    }
                }
                when 3 {
                    if(newcontr.Reporting_fee_language__c!=null&&newcontr.Reporting_fee_language__c!='')
                    {
                    w.feeLanguage = newcontr.Reporting_fee_language__c;
                    }
                    else
                    {
                        w.feeLanguage = '';   
                    }
                    
                }
                when 4 {
                    if(newcontr.Hosted_catalog_fee_language__c!=null&&newcontr.Hosted_catalog_fee_language__c!='')
                    {
                    w.feeLanguage = newcontr.Hosted_catalog_fee_language__c;
                    }
                    else
                    {
                        w.feeLanguage = '';   
                    }
                }
                when 5 {
                    if(newcontr.Desktop_delivery_fee_language__c!=null&&newcontr.Desktop_delivery_fee_language__c!='')
                    {
                    w.feeLanguage = newcontr.Desktop_delivery_fee_language__c;
                   }
                    else
                    {
                        w.feeLanguage = '';   
                    } 
                }
                when 6 {
                    if(newcontr.Storeroom_stocking_fee_language__c!=null&&newcontr.Storeroom_stocking_fee_language__c!='')
                    {
                    w.feeLanguage = newcontr.Storeroom_stocking_fee_language__c;
                    }
                    else
                    {
                        w.feeLanguage = '';   
                    } 
                }
                when 7 {
                     if(newcontr.Customer_item_warehousing_fee_language__c!=null&&newcontr.Customer_item_warehousing_fee_language__c!='')
                    {
                    w.feeLanguage = newcontr.Customer_item_warehousing_fee_language__c;
                    }
                    else
                    {
                        w.feeLanguage = '';   
                    } 
                    
                }
                when 8 {
                     if(newcontr.EDI_fee_language__c!=null&&newcontr.EDI_fee_language__c!='')
                    {
                    w.feeLanguage = newcontr.EDI_fee_language__c;
                    }
                    else
                    {
                        w.feeLanguage = '';   
                    } 
                    
                }
                when 9 {
                     if(newcontr.VW_shipping_fee_language__c!=null&&newcontr.VW_shipping_fee_language__c!='')
                    {
                    w.feeLanguage = newcontr.VW_shipping_fee_language__c;
                    }
                    else
                    {
                        w.feeLanguage = '';   
                    } 
                    
                }
                when 10 {
                     if(newcontr.Return_fee_language__c!=null&&newcontr.Return_fee_language__c!='')
                    {
                    w.feeLanguage = newcontr.Return_fee_language__c;
                    }
                    else
                    {
                        w.feeLanguage = '';   
                    } 
                    
                }
            }
                 count = count + 1;
                 
              }
     }
      
 Public void   CustomerFees_getPicklistvalues(){
             customerFessList = New List<WrapClassCustomerfees>();
               Schema.DescribeFieldResult CustomerFees= Contract.Customer_fees__c.getDescribe();
            for (Schema.Picklistentry picklistEntry:CustomerFees.getPicklistValues()){
                if (picklistEntry.getValue()!='none'){
                   WrapClassCustomerfees w=New WrapClassCustomerfees();
                    w.Picklistvalue=picklistEntry.getValue();
                    customerFessList.add(w);
                }
            }  
    }
 
 
 Public class WrapClassCustomerfees
    {
        Public String Picklistvalue{set;get;}
        Public Boolean Yes_checkbox{set;get;}
        Public String feeLanguage{set;get;}
        
        Public WrapClassCustomerfees()
        {
            Yes_checkbox=false;
            
        }
         
    }
}