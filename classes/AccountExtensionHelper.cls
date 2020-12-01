public class AccountExtensionHelper {

   public void copyToExtension(List<Account> accountListPassed) {
       

        System.debug('AccountExtensionHelper -> copyToExtension');
    
        // Get account IDs and query Account
        List<Id> passedAcctIds = new List<Id>();
        
        for (Account acct : accountListPassed) {
            passedAcctIds.add(acct.Id);
        }
        
        List<Account> accountList = [SELECT Id, Name, Type, RecordTypeId, ParentId, Phone, Fax, AccountNumber, Website, PhotoUrl, Sic, Industry, AnnualRevenue, NumberOfEmployees, Ownership, TickerSymbol, Description, Rating, Site, OwnerId,IsCustomerPortal, Jigsaw, JigsawCompanyId, AccountSource, SicDesc, ConnectionReceivedId, ConnectionSentId, Adoption_Metric1__c, Primary_Site_ID__c, Related_Account_Record_Type__c, Pot_Disposition_Reason__c, ADS_Current_Month__c, ADS_Current_Qtr__c, ADS_Current_Yr__c, ADS_Last_Month__c, ADS_Last_Qtr__c, ADS_Last_Yr__c, AOPS_Cust_Id__c, iSell__OSKeyID__c, Rolling_12_month_sales__c, AOPS_Seq_ID__c, Account_Legal_Name__c, Primary_BillTo__c, Address1__c, Address2__c, Address_Key__c, AssignRulesSICLookup__c, AssignRulesWCWLookup__c, Assign_Specific_Owner__c, Auto_Assign__c, Account_Number__c, CBS_Diff__c, CBS_IMU_LY__c, CBS_IMU_LY_per__c, CBS_IMU_TY__c, CBS_IMU_TY_per__c, CBS_LY__c, CBS_Last_Order__c, CBS_Last_order_amt__c, CBS_Pot__c, CBS_TY__c, CONTRACT_RETAIL_CUST_CODE__c, CPD_Diff__c, CPD_IMU_LY__c, CPD_IMU_LY_per__c, CPD_IMU_TY__c, CPD_IMU_TY_per__c, CPD_LY__c, CPD_Last_Order__c, CPD_Last_order_amt__c, CPD_Pot__c, CPD_TY__c, Cadence_Call_Date_Override_Value__c, Cadence_Call_Date_Override__c, Cadence_Call_Date__c, Account_Level__c, City__c, Country__c, County__c, Rolling_9_month_sales__c, Pot_Disposition__c, Pot_Other_Disposition_Reason__c, Potential_DeDuplicate__c, Lattice_Opportunity_Amount__c, Customer_Setup_Completed__c, Customer_Setup_Requested__c, DW_Effective_Start_Date__c, Deliver_Charge__c, Duns_Number__c, Est_Spend__c, Filing_Binding_Diff__c, Filing_Binding_IMU_LY__c, Filing_Binding_IMU_LY_per__c, Filing_Binding_IMU_TY__c, Filing_Binding_IMU_TY_per__c, Filing_Binding_LY__c, Filing_Binding_Last_Order__c, Filing_Binding_Last_Order_amt__c, Filing_Binding_Pot__c, Filing_Binding_TY__c, Freight_Charge__c, Furniture_Diff__c, Furniture_IMU_LY__c, Furniture_IMU_LY_per__c, Furniture_IMU_TY__c, Furniture_IMU_TY_per__c, Furniture_LY__c, Furniture_Last_Order__c, Furniture_Pot__c, Furniture_TY__c, Furniture_last_order_amt__c, Split_Record__c, GP_Id__c, GParent_GPID__c, Industry_OD_SIC_DB__c, Industry_OD_SIC_Rep_Code__c, Industry_OD_SIC_Rep__c, Initial_Site_Flag__c, Ink_Toner_Diff__c, Ink_Toner_IMU_LY__c, Ink_Toner_IMU_LY_per__c, Ink_Toner_IMU_TY__c, Ink_Toner_IMU_TY_per__c, Ink_Toner_LY__c, Ink_Toner_Last_Order__c, Ink_Toner_Last_Order_amt__c, Ink_Toner_Pot__c, Ink_Toner_TY__c, Labels_Forms_Diff__c, Labels_Forms_IMU_LY__c, Labels_Forms_IMU_LY_per__c, Labels_Forms_IMU_TY__c, Labels_Forms_IMU_TY_per__c, Labels_Forms_LY__c, Labels_Forms_Last_Order__c, Labels_Forms_Last_Order_amt__c, Labels_Forms_Pot__c, Labels_Forms_TY__c, Legacy_CreatedBy__c, Legacy_CreatedDate__c, Legacy_LastModifiedBy__c, Legacy_LastModifiedDate__c, Location_Type__c, Loyalty_Type__c, MPS_Diff__c, MPS_IMU_LY__c, MPS_IMU_LY_per__c, MPS_IMU_TY__c, MPS_IMU_TY_per__c, MPS_LY__c, MPS_Last_Order__c, MPS_Last_order_amt__c, MPS_Pot__c, MPS_TY__c, MTD_Sales_Diff__c, MTD_Sales_LY_IMU2__c, MTD_Sales_LY_IMU__c, MTD_Sales_LY__c, MTD_Sales_TY_IMU2__c, MTD_Sales_TY_IMU__c, MTD_Sales_TY__c, PID_numeric__c, Max_Order_Limit__c, Minimum_Discount__c, Miscellaneous_Diff__c, Miscellaneous_IMU_LY__c, Miscellaneous_IMU_LY_per__c, Miscellaneous_IMU_TY__c, Miscellaneous_IMU_TY_per__c, Miscellaneous_LY__c, Miscellaneous_Last_Order__c, Miscellaneous_Last_Order_amt__c, Miscellaneous_Pot__c, Miscellaneous_TY__c, Account_Extension__c, Monthly_LY_IMU_Per__c, Monthly_LY_IMU__c, Monthly_LY__c, Monthly_Sales__c, Num_of_Categories__c, Num_of_Orders_Since_Start__c, Number_of_Categories_Check__c, Number_of_Orders_Check__c, Number_of_Orders__c, Off_Contract_Percent__c, Off_Contract_Price_Code__c, Office_Essentials_Diff__c, Office_Essentials_IMU_LY__c, Office_Essentials_IMU_LY_per__c, Office_Essentials_IMU_TY__c, Office_Essentials_IMU_TY_per__c, Office_Essentials_LY__c, Office_Essentials_Last_Order__c, Office_Essentials_Last_Order_amt__c, Office_Essentials_Pot__c, Office_Essentials_TY__c, Opportunity_Amt__c, Oracle_Party_ID__c, Oracle_Party_Number__c, Oracle_Party_Site_ID__c, Oracle_Party_Site_Number__c, Org_Number_of_Locations__c, Org_WCW_Count_DB__c, Org_WCW_Count_Rep__c, Existing_OMax_Account__c, Overlay_Sales_IDs__c, Run_Rate__c, Paper_Diff__c, Paper_IMU_LY__c, Paper_IMU_TY__c, Paper_IMU_TY_per__c, Paper_LY__c, Paper_Last_Order__c, Paper_Last_Order_amt__c, Paper_Pot__c, Paper_TY__c, Pending_Tiger_Team_Rvw__c, Cost_Centre_Dept__c, Phone_Ext__c, Potential_Amount__c, Predictive_Purchase__c, Address_Validated__c, Primary_Site__c, Address_Validation_Error__c, Related_Pricing_Template_Account__c, Potential_Warning_Key__c, Rolling_6_month_sales__c, QTD_Sales_Diff__c, QTD_Sales_LY_IMU2__c, QTD_Sales_LY_IMU__c, QTD_Sales_LY__c, QTD_Sales_TY_IMU2__c, QTD_Sales_TY_IMU__c, QTD_Sales_TY__c, Quarter_LY_IMU__c, Quarter_LY_IMU_per__c, Quarter_LY__c, Ranking__c, Recurring_Request_Enabled__c, Related_Account__c, Rep_Call_Date__c, GT_Description__c, Revenue_Band__c , Sales_Check__c, Sales_PersonID__c, Sales__c, Sector__c, Segment_Code__c, Segment__c, Site_Contact2__c, Site_Contact3__c, Site_Contact4__c, Site_Contact5__c, Site_Contact6__c, Site_Primary_Contact__c, Source_System__c, Stage__c, State__c, Status__c, Related_Parent_Account__c, Tech_Diff__c, Tech_IMU_LY__c, Tech_IMU_LY_per__c, Tech_IMU_TY__c, Tech_IMU_TY_per__c, Tech_LY__c, Tech_Last_Order__c, Tech_Last_Order_amt__c, Tech_Pot__c, Tech_TY__c, Total_LY_IMU_Per__c, Total_LY_Sales_to_Date__c, Total_Potential_to_Date__c, Total_Sales_Diff__c, Total_TY_IMU_per__c, Total_TY_Sales_to_Date__c, Ultimate_Duns_Number__c, Rolling_3_month_sales__c, Copiers__c, WLR_Enrolled__c, Duplicate_Disposition__c, Weekly_Sales__c, Weeks_Since_1st_Order__c, Weeks_Since_Last_Order__c, Wholesaler_Discount_Percent__c, Wholesaler__c, Writing_Drafting_Diff__c, Writing_Drafting_IMU_LY__c, Writing_Drafting_IMU_LY_per__c, Writing_Drafting_IMU_TY__c, Writing_Drafting_IMU_TY_per__c, Writing_Drafting_LY__c, Writing_Drafting_Last_Order__c, Writing_Drafting_Last_Order_amt__c, Writing_Drafting_Pot__c, Writing_Drafting_TY__c, Name_DW__c, YTD_Sales_Diff__c, YTD_Sales_LY_IMU2__c, YTD_Sales_LY_IMU__c, YTD_Sales_LY__c, YTD_Sales_TY_IMU2__c, YTD_Sales_TY_IMU__c, YTD_Sales_TY__c, Year_LY_IMU__c, Year_LY_IMU_per__c, Year_LY__c, Zip__c, paper_IMU_LY_per__c, ParentOraclePartyID__c, Processing__c, CBS_Calc_Pot__c, CPD_Calc_Pot__c, Filing_Binding_Calc_Pot__c, Furniture_Calc_Pot__c, Ink_Toner_Calc_Pot__c, Labels_Forms_Calc_Pot__c, MPS_Calc_Pot__c, Misc_Calc_Pot__c, Office_Essentials_Calc_Pot__c, Paper_Calc_Pot__c, Tech_Calc_Pot__c, Writing_Drafting_Calc_Pot__c, Sites_Cust_AOPS_ID__c, YTD_Change__c, Grandparent__c, Account_Setup_Request_Status__c, Hide__c, Pricing_Strategy_Option__c, Cust_ID__c, Follow_Up_Note__c, Customer_Source__c, Primary_Competitor__c, Data_Staging_TableID__c, Business_Usage_Type__c, Setup_URL1__c, Mod_5_EBS_Sync_Error__c, YTD_IMU_Chg_bps__c, Address__c, Consolidated_DUNS_ID__c, OMX_Primary_Key__c, Disposition__c, OMX_Do_Not_Call__c, Segment_Group__c, Pricing_template_cd__c, First_Order_Date__c, Last_Order_Date__c, OMX_Mainframe_Account_Number__c, Open_Opp_Amt__c, Open_Opp_Count__c, OMX_Mainframe_Account_Level__c, Grandparent_Name__c, Total_Order__c, Zip_5digit__c, OMX_GPO__c, AOV_Current_Month__c, AOV_Current_Qtr__c, OMX_Mainframe_Consignee_ID__c, AOV_Last_Month__c, AOV_Last_Qtr__c, OMX_Mainframe_National_Acct_Number__c, AOV_Current_Yr__c, AOV_Last_Yr__c, Won_Opp_Amt__c, Orders_Current_Month__c, Orders_Current_Qtr__c, Orders_Current_Yr__c, Orders_Last_Month__c, Orders_Last_Qtr__c, Orders_Last_Yr__c, Payment_Term__c, Buying_Group__c, OMX_Mainframe_Owning_Rep_Number__c, OMX_Tier_1_Type__c, Account_Owner_Manager_2__c, Lost_Opp_Amount__c, Sales_Validation_Field__c, Sector_Seq__c, Segment_Seq__c, Contact_Initiation_Type__c, Remediation_Required__c, DNB_Duns__c, DNB_Status__c, DNB_Minority_Business__c, DNB_WCW_Here__c, DNB_WCW_Total__c, Transition_Customer__c, DNB_Year_Started__c, IOWNACCOUNT__c, Potential_Duplicate_of_ID__c, Account_Owner_Manager_Name__c, Customer_Lifecycle__c, Transition_Calender_Date__c, Buying_Account__c, DNBI_Application_ID__c, Copier_Fleet_Expiration_Date__c, OMX_Account__c, Contract_Furniture_Diff__c, Contract_Furniture_IMU_LY__c, Contract_Furniture_IMU_LY_per__c, Potential_Printers__c, Contract_Furniture_IMU_TY__c, Contract_Furniture_IMU_TY_per__c, Contract_Furniture_LY__c, Contract_Furniture_Last_Order__c, Account_level_email_permission_flag__c, Grand_Siloe__c, Contract_Furniture_Last_Order_amt__c, Contract_Furniture_Pot__c, Contract_Furniture_TY__c, Mod_5_EBS_Sync_Status__c, Delivery__c, Est_Spend_CAD__c, Fuel_Surcharge__c, GT_Account_Type__c, CBS_Total_LY__c, GT_Max_Perks_Eligible__c, GT_Max_Perks_Enrolled_Date__c, GT_Max_Perks_Enrolled__c, GT_Segment__c, Min_Order_Charge__c, Primary_Product__c, Price_As__c, SIC_Description_FR__c, Salesforce_ID__c, Pricing_Flip_Effective_Date__c, Modified_Price_Value__c, Parent_Account_Owner__c, Parent_YTD_Sales__c, Silo__c, Other_Non_Strategy__c, Strategy__c, Pricing_Strategy_Seq__c, Implementation_Manager__c, Related_account_Split_Record__c, Weeks_since_1st_Order_new__c, Weeks_since_last_order_new__c, CPD_Total_LY__c, OneSource__OSKeyID__c, Previous_Owner_ID__c, Header_Record_Access__c, MPS_Parent_Account__c, Verticals__c, Override_Duplicate_Check_ownerid__c, Hosted_Catalog_Flag__c, Account_Type__c, EIN__c, Furniture_Total_LY__c, Tech_Total_LY__c, Paper_Total_LY__c, Ink_Toner_Total_LY__c, Filing_Binding_Total_LY__c, Labels_Forms_Total_LY__c, Writing_Drafting_Total_LY__c, Office_Essentials_Total_LY__c, MPS_Total_LY__c, Miscellaneous_Total_LY__c, Total_LY_Sales__c, Customer_Contact_Touch_Point__c, Won_Opp_Gap__c, Adj_Incr_Potential__c, Original_System__c, Hierarchy__c, Failed_Reason__c, Opt_Date__c, Opt_in_Date__c, Opt_out_Date__c, Coupon_flag__c, Potential_Duplicate__c, WinLossAmount__c, Open_Opp_Amt_CAD__c, Parent_ID__c, Parent_Name__c, Grandparent_ID__c, Grandparent_Name_site__c, Source_System_that_has_the_latest_opt_de__c, Duns_Enrichment__c, Account_Owner_Manager2__c, YTD_IMU_Diff__c, DNBI_CREDIT_OUTCOME__c, DNBI_MatchScore__c, DSM_User__c, RSD_User__c, Credit_Flag__c, Legal_Flag__c, OMXIsUpdated__c, DNBI_FSS_Score__c, Owner_Status__c, Account_Owner_VP__c, Prospect_Creation_Failure__c, Split_Flag__c, Request_Account_Billing__c, Tax_Exempt__c, Site_Account_RecordTypeID__c, Lead_Source__c, Tier_1_Partner__c, Assignment_Status__c, Address1_DW__c, Address2_DW__c, Loyatly_Number__c, VIP_Card_Effective_Date__c, VIP_Card_End_Date__c, VIP_Card_Issue_Reqt__c, Account_Page_Source__c, BSD_Account_Number__c, Account_Owner__c,
                                         Owner.Id, recordtype.DeveloperName
                                     FROM Account
                                     WHERE Id IN :passedAcctIds];

        
        // Prepare map that will be used to populte Account Extension values (accountMap)
        // Insert missing exceptions (missingExtensions list)
        // Query the Account Extension correctly for restored accounts (existingExtensionIds map)
        Map<Id, Account> accountMap = new Map<Id, Account>();
        List<Account_Extension__c> missingExtensions = new List<Account_Extension__c>();
        Map<Id, Account> existingExtensionIds = new Map<Id, Account>();
        
        for (Account acct : accountList) {
            accountMap.put(acct.Id, acct);
            
            // To insert missing Extensions
            if (acct.Account_Extension__c == null) {
                System.debug('AccountExtensionHelper -> acct.Account_Extension__c == null');
                
                String acctId = '' + acct.Id;
                Account_Extension__c newExt = new Account_Extension__c(Account__c = acct.Id, 
                                                                        Original_Account_ID__c = acct.Id, 
                                                                        Current_Account_ID__c = acctId.substring(0, 15),
                                                                        AOPS_Cust_Id__c = acct.AOPS_Cust_Id__c,
                                                                        AOPS_Seq_ID__c = acct.AOPS_Seq_ID__c,
                                                                        OMX_Primary_Key__c = acct.OMX_Primary_Key__c,
                                                                        Oracle_Party_ID__c = acct.Oracle_Party_ID__c,
                                                                        Oracle_Party_Site_ID__c = acct.Oracle_Party_Site_ID__c);
                missingExtensions.add(newExt);
            }
            else {
                // To query Account Extension for restored accounts
                existingExtensionIds.put(acct.Account_Extension__c, acct);
            }
        }
        
        // Insert missing Account Extensions
        Set<Id> AcctExtensionIdsInserted = new Set<Id>();
        
        if (missingExtensions.size() > 0) {
            System.debug('AccountExtensionHelper -> missingExtensions.size() > 0');
            Database.SaveResult[] srList = Database.insert(missingExtensions, false);
            
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // To update Account later to lookup to the newly inserted Extensions
                    AcctExtensionIdsInserted.add(sr.getId());
                }
                else {
                    for (Database.Error err : sr.getErrors()) {
                        System.debug('AccountExtensionHelper -> errors = ' + err.getStatusCode() + ': ' + err.getMessage() + ' ( ' +  err.getFields() + ' ) ');
                    }
                }
            }
        }
        
        // Get Account Extensions
        List<Account_Extension__c> extensions = [SELECT Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, 
                                                    ConnectionReceivedId, ConnectionSentId, ADS_Current_Month__c, ADS_Current_Qtr__c, ADS_Current_Yr__c, 
                                                    ADS_Last_Month__c, ADS_Last_Qtr__c, ADS_Last_Yr__c, AOPS_Cust_Id__c, AOPS_Seq_ID__c, 
                                                    AOV_Current_Month__c, AOV_Current_Qtr__c, AOV_Current_Yr__c, AOV_Last_Month__c, AOV_Last_Qtr__c, 
                                                    AOV_Last_Yr__c, Account_Legal_Name__c, Account_Page_Source__c, 
                                                    Account_Setup_Request_Status__c, Account_Type__c, Account_level_email_permission_flag__c, 
                                                    Acct_Hqtrs__c, Address1__c, Address2__c, 
                                                    Address_Key__c, Address_Validated__c, Address_Validation_Error__c, 
                                                    Assign_Specific_Owner__c, Auto_Assign__c, 
                                                    Back_to_School__c, Business_Usage_Type__c, Buying_Account__c, Buying_Group__c, 
                                                    CBS_IMU_LY__c, CBS_IMU_TY__c, CBS_LY__c, 
                                                    CBS_Last_Order__c, CBS_Last_order_amt__c, CBS_Pot__c, CBS_TY__c, CBS_Total_LY__c, 
                                                    CONTRACT_RETAIL_CUST_CODE__c, CPD_IMU_LY__c, 
                                                    CPD_IMU_TY__c, CPD_LY__c, CPD_Last_Order__c, CPD_Last_order_amt__c, CPD_Pot__c, 
                                                    CPD_TY__c, CPD_Total_LY__c, Cadence_Call_Date_Override_Value__c, Cadence_Call_Date_Override__c, 
                                                    Cadence_Call_Date__c, Campaign__c, City__c, Click_Tools_Qual_Survey__c, 
                                                    Consolidated_DUNS_ID__c, Contract_Furniture_IMU_LY__c, 
                                                    Contract_Furniture_IMU_TY__c,  
                                                    Contract_Furniture_LY__c, Contract_Furniture_Last_Order__c, Contract_Furniture_Last_Order_amt__c, 
                                                    Contract_Furniture_Pot__c, Contract_Furniture_TY__c, Copier_Fleet_Expiration_Date__c, Copiers__c, 
                                                    Cost_Centre_Dept__c, Country__c, County__c, Coupon_flag__c, Cust_ID__c, 
                                                    Customer_Lifecycle__c, Customer_Setup_Completed__c, Customer_Setup_Requested__c, 
                                                    Customer_Source__c, DNBI_Application_ID__c, DNBI_CREDIT_OUTCOME__c, DNBI_FSS_Score__c, 
                                                    DNBI_MatchScore__c, DNB_Block_Group_Code__c, DNB_Division__c, DNB_Duns__c, DNB_Employee_Total__c, 
                                                    DNB_Employees_Here__c, DNB_Family_Updated_Date__c, DNB_Global_Ult_Duns__c, DNB_Hier_Code__c, 
                                                    DNB_Hqtr_Duns__c, DNB_Legal_Status__c, DNB_Minority_Business__c, DNB_Parent_Duns__c, DNB_Phone__c, 
                                                    DNB_Private__c, DNB_SIC__c, DNB_Sales__c, DNB_Small_Business__c, DNB_Status__c, DNB_Subsidiary__c, 
                                                    DNB_Total_Family_Member__c, DNB_Ultimate_Name__c, DNB_Vertical_Markets__c, DNB_WCW_Here__c, 
                                                    DNB_WCW_Total__c, DNB_Year_Started__c, DSM_User__c, Deliver_Charge__c, 
                                                    Delivery__c, Disposition__c, Duns_Enrichment__c, Duns_Number__c, Duplicate_Disposition__c, EIN__c, 
                                                    Est_Spend_CAD__c, Est_Spend__c, Failed_Reason__c, Filing_Binding_IMU_LY__c, 
                                                    Filing_Binding_IMU_TY__c,  
                                                    Filing_Binding_LY__c, Filing_Binding_Last_Order__c, Filing_Binding_Last_Order_amt__c, 
                                                    Filing_Binding_Pot__c, Filing_Binding_TY__c, Filing_Binding_Total_LY__c, First_Order_Date__c, 
                                                    Follow_Up_Note__c, Freight_Charge__c, Fuel_Surcharge__c, 
                                                    Furniture_IMU_LY__c, Furniture_IMU_TY__c,  
                                                    Furniture_LY__c, Furniture_Last_Order__c, Furniture_Pot__c, Furniture_TY__c, Furniture_Total_LY__c, 
                                                    Furniture_last_order_amt__c, GGPId__c, GP_Id__c, GParent_GPID__c, GT_Account_Type__c, GT_Description__c, 
                                                    GT_Max_Perks_Eligible__c, GT_Max_Perks_Enrolled_Date__c, GT_Max_Perks_Enrolled__c, GT_Segment__c, 
                                                    Grand_Siloe__c, Grandparent_Type__c, Header_Record_Access__c, 
                                                    Hide__c, Hierarchy__c, Hosted_Catalog_Flag__c, Industry_OD_SIC_DB__c, 
                                                    Industry_OD_SIC_Rep__c, Initial_Site_Flag__c, 
                                                    Ink_Toner_IMU_LY__c, Ink_Toner_IMU_TY__c,  
                                                    Ink_Toner_LY__c, Ink_Toner_Last_Order__c, Ink_Toner_Last_Order_amt__c, Ink_Toner_Pot__c, Ink_Toner_TY__c, 
                                                    Ink_Toner_Total_LY__c, Labels_Forms_IMU_LY__c, 
                                                    Labels_Forms_IMU_TY__c, Labels_Forms_LY__c, 
                                                    Labels_Forms_Last_Order__c, Labels_Forms_Last_Order_amt__c, Labels_Forms_Pot__c, Labels_Forms_TY__c, 
                                                    Labels_Forms_Total_LY__c, Last_Order_Date__c, Legacy_CreatedBy__c, Legacy_CreatedDate__c, 
                                                    Legacy_LastModifiedBy__c, Legacy_LastModifiedDate__c, Legal_Flag__c, Location_Type__c, Loyalty_Type__c, 
                                                    MPS_IMU_LY__c, MPS_IMU_TY__c,  
                                                    MPS_LY__c, MPS_Last_Order__c, MPS_Last_order_amt__c, MPS_Pot__c, MPS_TY__c, MPS_Total_LY__c, 
                                                    MTD_Sales_LY_IMU__c, MTD_Sales_LY__c,  
                                                    MTD_Sales_TY_IMU__c, MTD_Sales_TY__c, Max_Order_Limit__c, Min_Order_Charge__c, Minimum_Discount__c, 
                                                    Miscellaneous_IMU_LY__c, 
                                                    Miscellaneous_IMU_TY__c, Miscellaneous_LY__c, Miscellaneous_Last_Order__c, 
                                                    Miscellaneous_Last_Order_amt__c, Miscellaneous_Pot__c, Miscellaneous_TY__c, Miscellaneous_Total_LY__c, 
                                                    Mod_5_EBS_Sync_Error__c, Mod_5_EBS_Sync_Status__c, Modified_Price_Value__c,  
                                                    Monthly_LY_IMU__c, Monthly_LY__c, Monthly_Sales__c, Num_of_Categories__c, 
                                                    Num_of_Orders_Since_Start__c, Number_of_Categories_Check__c, Number_of_Orders_Check__c, 
                                                    Number_of_Orders__c, OMXIsUpdated__c, OMX_Account__c, OMX_Do_Not_Call__c, OMX_GPO__c, 
                                                    OMX_Mainframe_Account_Level__c, OMX_Mainframe_Account_Number__c, OMX_Mainframe_Consignee_ID__c, 
                                                    OMX_Mainframe_National_Acct_Number__c, OMX_Mainframe_Owning_Rep_Number__c, OMX_Primary_Key__c, 
                                                    OMX_Tier_1_Type__c, Off_Contract_Percent__c, Off_Contract_Price_Code__c, 
                                                    Office_Essentials_IMU_LY__c, 
                                                    Office_Essentials_IMU_TY__c, Office_Essentials_LY__c, 
                                                    Office_Essentials_Last_Order__c, Office_Essentials_Last_Order_amt__c, Office_Essentials_Pot__c, 
                                                    Office_Essentials_TY__c, Office_Essentials_Total_LY__c, Opportunity_Amt__c, Opt_Date__c, Opt_in_Date__c, 
                                                    Opt_out_Date__c, Oracle_Party_ID__c, Oracle_Party_Number__c, Oracle_Party_Site_ID__c, 
                                                    Oracle_Party_Site_Number__c, Orders_Current_Month__c, Orders_Current_Qtr__c, Orders_Current_Yr__c, 
                                                    Orders_Last_Month__c, Orders_Last_Qtr__c, Orders_Last_Yr__c, Org_Number_of_Locations__c, 
                                                    Org_WCW_Count_DB__c, Org_WCW_Count_Rep__c, Original_System__c,  
                                                    Override_Duplicate_Check_ownerid__c, Paper_IMU_LY__c, Paper_IMU_TY__c, Paper_LY__c, 
                                                    Paper_Last_Order__c, Paper_Last_Order_amt__c, Paper_Pot__c, Paper_TY__c, Paper_Total_LY__c, 
                                                    Payment_Term__c, Phone_Ext__c, Pot_Disposition_Reason__c, Pot_Disposition__c, Potential_Amount__c, 
                                                    Potential_DeDuplicate__c, Potential_Duplicate__c, Potential_Duplicate_of_ID__c, Potential_Printers__c, 
                                                    Predictive_Purchase__c, Previous_Owner_ID__c, Price_As__c, Pricing_Flip_Effective_Date__c, 
                                                    Pricing_template_cd__c, Primary_BillTo__c, Primary_Competitor__c, Primary_Product__c, Primary_Site_ID__c, 
                                                    Primary_Site__c, Processing__c, Prospect_Creation_Failure__c, QTD_Sales_LY_IMU__c, QTD_Sales_LY__c, 
                                                    QTD_Sales_TY_IMU__c, QTD_Sales_TY__c, Quarter_LY_IMU__c, Quarter_LY__c, RSD_User__c, Ranking__c, 
                                                    Recurring_Request_Enabled__c, Related_Parent_Account__c, Remediation_Required__c, Rep_Call_Date__c, 
                                                    Request_Account_Billing__c, Revenue_Band__c, Rolling_12_month_sales__c, Rolling_3_month_sales__c,
                                                   
                                                    Rolling_6_month_sales__c, Rolling_9_month_sales__c, SIC_Description_FR__c, Sales_Check__c, Sales__c, 
                                                    Sector__c, Segment__c, 
                                                    Setup_URL1__c, Silo__c, Source_System__c, Source_System_that_has_the_latest_opt_de__c, Split_Flag__c, 
                                                    Split_Record__c, Stage__c, State__c, Status__c, Tax_Exempt__c, 
                                                    Tech_IMU_LY__c, Tech_IMU_TY__c, Tech_LY__c, 
                                                    Tech_Last_Order__c, Tech_Last_Order_amt__c, Tech_Pot__c, Tech_TY__c, Tech_Total_LY__c, 
                                                    Total_Order__c, 
                                                    Transition_Calender_Date__c, Transition_Customer__c, Ultimate_Duns_Number__c, Verticals__c, 
                                                    WLR_Enrolled__c, Weekly_Sales__c, Weeks_Since_1st_Order__c, 
                                                    Weeks_Since_Last_Order__c, Wholesaler_Discount_Percent__c, Wholesaler__c, 
                                                    Writing_Drafting_IMU_LY__c, Writing_Drafting_IMU_TY__c, 
                                                    Writing_Drafting_LY__c, Writing_Drafting_Last_Order__c, 
                                                    Writing_Drafting_Last_Order_amt__c, Writing_Drafting_Pot__c, Writing_Drafting_TY__c, 
                                                    Writing_Drafting_Total_LY__c, 
                                                    YTD_Sales_LY_IMU__c, YTD_Sales_LY__c,  
                                                    YTD_Sales_TY_IMU__c, YTD_Sales_TY__c, Year_LY_IMU__c, Year_LY__c,  
                                                    Zip__c, Sales_PersonID__c, Site_Contact2__c, Site_Contact3__c, Site_Contact4__c, 
                                                    Site_Contact5__c, Site_Contact6__c, Tier_1_Partner__c, Existing_OMax_Account__c, 
                                                    Implementation_Manager__c, Site_Primary_Contact__c, Account_Owner_ID__c, 
                                                    Related_OD_Account_Extension__c, Related_Pricing_Template_Dormant_Account__c, Account__c, 
                                                    Original_Account_ID__c, Account_Record_Type_Id__c, Account_ParentId__c, Sic__c, Current_Account_ID__c
                                                 FROM Account_Extension__c 
                                                 WHERE Id IN :existingExtensionIds.keySet()
                                                    OR Account__c IN :accountMap.keySet()];
        
        // Populate necessary maps
        List<ID> acct_ids = new List<ID>();
        List<ID> acct_pids = new List<ID>();
        List<ID> acct_OMax = new List<ID>();
        List<ID> acct_Racct = new List<ID>();
        List<ID> acct_PT = new List<ID>();
        
        Map<String, Account> Acctmap = new Map<String, Account>();
        Map<String, String> Prntmap = new Map<String, String>();
        Map<String, String> AcctmapOMax = new Map<String, String>();
        Map<String, String> AcctmapRacct = new Map<String, String>();
        Map<String, String> AcctmapPT = new Map<String, String>();
        Map<String, String> rectypes = new Map<String, String>();
        Map<String, String> EnrichmentIdsMap = new Map<String, String>();
        Map<String, String> MasterIdsMap = new Map<String, String>();
        Map<String, String> DedupIdsMap = new Map<String, String>();
        
        for (RecordType r : [SELECT Id, DeveloperName FROM RecordType WHERE SObjectType = 'Account_Extension__c']) {
            rectypes.put(r.DeveloperName, r.id);
        }
        
        for (Account a : accountList) {
            Acctmap.put(a.id, a);

            acct_ids.add(a.id);
            
            
            if (a.Parentid != null) {
                acct_pids.add(a.Parentid);
            }
            
            if (a.Related_Account__c != null) {
                acct_Racct.add(a.Related_Account__c);
            }
            
            if (a.Related_Pricing_Template_Account__c != null) {
                acct_PT.add(a.Related_Pricing_Template_Account__c);
            }
            
            if (a.Existing_OMax_Account__c != null) {
                acct_OMax.add(a.Existing_OMax_Account__c);
            }
        }
        
        for (Account_Extension__c ae : [SELECT id, Account__c FROM Account_Extension__c WHERE Account__c = :acct_pids]) {
            Prntmap.put(ae.Account__c, ae.id);
        }
    
    
        for (Account_Extension__c ae : [SELECT id, Account__c FROM Account_Extension__c WHERE Account__c = :acct_OMax]) {
            AcctmapOMax.put(ae.Account__c, ae.id);
        }
        
        if (acct_Racct != null && acct_Racct.size() > 0) {
            for (Account_Extension__c ae : [SELECT id, Account__c FROM Account_Extension__c WHERE Account__c = :acct_Racct]) {
                AcctmapRacct.put(ae.Account__c, ae.id);
            }
        }
        
        for (Account_Extension__c ae : [SELECT id, Account__c FROM Account_Extension__c WHERE Account__c = :acct_PT]) {
            AcctmapPT.put(ae.Account__c, ae.id);
        }
        
        // Assign Account fields to Extension
        Map<Id, Id> accountIdToExtensionId = new Map<Id, Id>();
        System.debug('&&&&&&&&&&&&&&&&&&&&&&  extensions List'+extensions);
        for (Account_Extension__c extension : extensions) {
            Account acct;
            
            if (existingExtensionIds.containsKey(extension.Id)) {
                acct = existingExtensionIds.get(extension.Id);
            }
            else {
                acct = accountMap.get(extension.Account__c);
            }
            
            String acctId = '' + acct.Id;
            
            if (acct.Account_Legal_Name__c != null) extension.Account_Legal_Name__c = acct.Account_Legal_Name__c;
            if (acct.Account_level_email_permission_flag__c != null) extension.Account_level_email_permission_flag__c = acct.Account_level_email_permission_flag__c;
            if (acct.Account_Page_Source__c != null) extension.Account_Page_Source__c = acct.Account_Page_Source__c;
            if (acct.Account_Setup_Request_Status__c != null) extension.Account_Setup_Request_Status__c = acct.Account_Setup_Request_Status__c;
            if (acct.Account_Type__c != null) extension.Account_Type__c = acct.Account_Type__c;
            //if (acct.Acct_Hqtrs__c != null) extension.Acct_Hqtrs__c = acct.Acct_Hqtrs__c;
            if (acct.Address_Key__c != null) extension.Address_Key__c = acct.Address_Key__c;
            if (acct.Address_Validated__c != null) extension.Address_Validated__c = acct.Address_Validated__c;
            if (acct.Address_Validation_Error__c != null) extension.Address_Validation_Error__c = acct.Address_Validation_Error__c;
            if (acct.Address1__c != null) extension.Address1__c = acct.Address1__c;
            if (acct.Address2__c != null) extension.Address2__c = acct.Address2__c;
            if (acct.ADS_Current_Month__c != null) extension.ADS_Current_Month__c = acct.ADS_Current_Month__c;
            if (acct.ADS_Current_Qtr__c != null) extension.ADS_Current_Qtr__c = acct.ADS_Current_Qtr__c;
            if (acct.ADS_Current_Yr__c != null) extension.ADS_Current_Yr__c = acct.ADS_Current_Yr__c;
            if (acct.ADS_Last_Month__c != null) extension.ADS_Last_Month__c = acct.ADS_Last_Month__c;
            if (acct.ADS_Last_Qtr__c != null) extension.ADS_Last_Qtr__c = acct.ADS_Last_Qtr__c;
            if (acct.ADS_Last_Yr__c != null) extension.ADS_Last_Yr__c = acct.ADS_Last_Yr__c;
            if (acct.AOPS_Cust_Id__c != null) extension.AOPS_Cust_Id__c = acct.AOPS_Cust_Id__c;
            if (acct.AOPS_Seq_ID__c != null) extension.AOPS_Seq_ID__c = acct.AOPS_Seq_ID__c;
            if (acct.AOV_Current_Month__c != null) extension.AOV_Current_Month__c = acct.AOV_Current_Month__c;
            if (acct.AOV_Current_Qtr__c != null) extension.AOV_Current_Qtr__c = acct.AOV_Current_Qtr__c;
            if (acct.AOV_Current_Yr__c != null) extension.AOV_Current_Yr__c = acct.AOV_Current_Yr__c;
            if (acct.AOV_Last_Month__c != null) extension.AOV_Last_Month__c = acct.AOV_Last_Month__c;
            if (acct.AOV_Last_Qtr__c != null) extension.AOV_Last_Qtr__c = acct.AOV_Last_Qtr__c;
            if (acct.AOV_Last_Yr__c != null) extension.AOV_Last_Yr__c = acct.AOV_Last_Yr__c;
            if (acct.Assign_Specific_Owner__c != null) extension.Assign_Specific_Owner__c = acct.Assign_Specific_Owner__c;
            if (acct.Auto_Assign__c != null) extension.Auto_Assign__c = acct.Auto_Assign__c;
            //if (acct.Back_to_School__c != null) extension.Back_to_School__c = acct.Back_to_School__c;
            if (acct.Business_Usage_Type__c != null) extension.Business_Usage_Type__c = acct.Business_Usage_Type__c;
            if (acct.Buying_Account__c != null) extension.Buying_Account__c = acct.Buying_Account__c;
            if (acct.Buying_Group__c != null) extension.Buying_Group__c = acct.Buying_Group__c;
            if (acct.Cadence_Call_Date__c != null) extension.Cadence_Call_Date__c = acct.Cadence_Call_Date__c;
            if (acct.Cadence_Call_Date_Override__c != null) extension.Cadence_Call_Date_Override__c = acct.Cadence_Call_Date_Override__c;
            if (acct.Cadence_Call_Date_Override_Value__c != null) extension.Cadence_Call_Date_Override_Value__c = acct.Cadence_Call_Date_Override_Value__c;
            //if (acct.Campaign__c != null) extension.Campaign__c = acct.Campaign__c;
            if (acct.CBS_IMU_LY__c != null) extension.CBS_IMU_LY__c = acct.CBS_IMU_LY__c;
            if (acct.CBS_IMU_TY__c != null) extension.CBS_IMU_TY__c = acct.CBS_IMU_TY__c;
            if (acct.CBS_Last_Order__c != null) extension.CBS_Last_Order__c = acct.CBS_Last_Order__c;
            if (acct.CBS_Last_order_amt__c != null) extension.CBS_Last_order_amt__c = acct.CBS_Last_order_amt__c;
            if (acct.CBS_LY__c != null) extension.CBS_LY__c = acct.CBS_LY__c;
            if (acct.CBS_Pot__c != null) extension.CBS_Pot__c = acct.CBS_Pot__c;
            if (acct.CBS_Total_LY__c != null) extension.CBS_Total_LY__c = acct.CBS_Total_LY__c;
            if (acct.CBS_TY__c != null) extension.CBS_TY__c = acct.CBS_TY__c;
            if (acct.City__c != null) extension.City__c = acct.City__c;
            //if (acct.Click_Tools_Qual_Survey__c != null) extension.Click_Tools_Qual_Survey__c = acct.Click_Tools_Qual_Survey__c;
            if (acct.Consolidated_DUNS_ID__c != null) extension.Consolidated_DUNS_ID__c = acct.Consolidated_DUNS_ID__c;
            if (acct.Contract_Furniture_IMU_LY__c != null) extension.Contract_Furniture_IMU_LY__c = acct.Contract_Furniture_IMU_LY__c;
            if (acct.Contract_Furniture_IMU_TY__c != null) extension.Contract_Furniture_IMU_TY__c = acct.Contract_Furniture_IMU_TY__c;
            if (acct.Contract_Furniture_Last_Order__c != null) extension.Contract_Furniture_Last_Order__c = acct.Contract_Furniture_Last_Order__c;
            if (acct.Contract_Furniture_Last_Order_amt__c != null) extension.Contract_Furniture_Last_Order_amt__c = acct.Contract_Furniture_Last_Order_amt__c;
            if (acct.Contract_Furniture_LY__c != null) extension.Contract_Furniture_LY__c = acct.Contract_Furniture_LY__c;
            if (acct.Contract_Furniture_TY__c != null) extension.Contract_Furniture_TY__c = acct.Contract_Furniture_TY__c;
            if (acct.CONTRACT_RETAIL_CUST_CODE__c != null) extension.CONTRACT_RETAIL_CUST_CODE__c = acct.CONTRACT_RETAIL_CUST_CODE__c;
            if (acct.Copier_Fleet_Expiration_Date__c != null) extension.Copier_Fleet_Expiration_Date__c = acct.Copier_Fleet_Expiration_Date__c;
            if (acct.Copiers__c != null) extension.Copiers__c = acct.Copiers__c;
            if (acct.Cost_Centre_Dept__c != null) extension.Cost_Centre_Dept__c = acct.Cost_Centre_Dept__c;
            if (acct.Country__c != null) extension.Country__c = acct.Country__c;
            if (acct.County__c != null) extension.County__c = acct.County__c;
            if (acct.Coupon_flag__c != null) extension.Coupon_flag__c = acct.Coupon_flag__c;
            if (acct.CPD_IMU_LY__c != null) extension.CPD_IMU_LY__c = acct.CPD_IMU_LY__c;
            if (acct.CPD_IMU_TY__c != null) extension.CPD_IMU_TY__c = acct.CPD_IMU_TY__c;
            if (acct.CPD_Last_Order__c != null) extension.CPD_Last_Order__c = acct.CPD_Last_Order__c;
            if (acct.CPD_Last_order_amt__c != null) extension.CPD_Last_order_amt__c = acct.CPD_Last_order_amt__c;
            if (acct.CPD_LY__c != null) extension.CPD_LY__c = acct.CPD_LY__c;
            if (acct.CPD_Pot__c != null) extension.CPD_Pot__c = acct.CPD_Pot__c;
            if (acct.CPD_Total_LY__c != null) extension.CPD_Total_LY__c = acct.CPD_Total_LY__c;
            if (acct.CPD_TY__c != null) extension.CPD_TY__c = acct.CPD_TY__c;
            if (acct.Customer_Lifecycle__c != null) extension.Customer_Lifecycle__c = acct.Customer_Lifecycle__c;
            if (acct.Customer_Setup_Completed__c != null) extension.Customer_Setup_Completed__c = acct.Customer_Setup_Completed__c;
            if (acct.Customer_Setup_Requested__c != null) extension.Customer_Setup_Requested__c = acct.Customer_Setup_Requested__c;
            if (acct.Customer_Source__c != null) extension.Customer_Source__c = acct.Customer_Source__c;
            if (acct.Deliver_Charge__c != null) extension.Deliver_Charge__c = acct.Deliver_Charge__c;
            if (acct.Delivery__c != null) extension.Delivery__c = acct.Delivery__c;
            if (acct.Disposition__c != null) extension.Disposition__c = acct.Disposition__c;
            if (acct.Duns_Number__c != null) extension.Duns_Number__c = acct.Duns_Number__c;
            if (acct.Duplicate_Disposition__c != null) extension.Duplicate_Disposition__c = acct.Duplicate_Disposition__c;
            if (acct.EIN__c != null) extension.EIN__c = acct.EIN__c;
            //if (acct.Enrichment__c != null) extension.Enrichment__c = acct.Enrichment__c;
            if (acct.Est_Spend__c != null) extension.Est_Spend__c = acct.Est_Spend__c;
            if (acct.Est_Spend_CAD__c != null) extension.Est_Spend_CAD__c = acct.Est_Spend_CAD__c;
            if (acct.Existing_OMax_Account__c != null) extension.Existing_OMax_Account__c = acct.Existing_OMax_Account__c;
            if (acct.Failed_Reason__c != null) extension.Failed_Reason__c = acct.Failed_Reason__c;
            if (acct.Filing_Binding_IMU_LY__c != null) extension.Filing_Binding_IMU_LY__c = acct.Filing_Binding_IMU_LY__c;
            if (acct.Filing_Binding_IMU_TY__c != null) extension.Filing_Binding_IMU_TY__c = acct.Filing_Binding_IMU_TY__c;
            if (acct.Filing_Binding_Last_Order__c != null) extension.Filing_Binding_Last_Order__c = acct.Filing_Binding_Last_Order__c;
            if (acct.Filing_Binding_Last_Order_amt__c != null) extension.Filing_Binding_Last_Order_amt__c = acct.Filing_Binding_Last_Order_amt__c;
            if (acct.Filing_Binding_LY__c != null) extension.Filing_Binding_LY__c = acct.Filing_Binding_LY__c;
            if (acct.Filing_Binding_Pot__c != null) extension.Filing_Binding_Pot__c = acct.Filing_Binding_Pot__c;
            if (acct.Filing_Binding_Total_LY__c != null) extension.Filing_Binding_Total_LY__c = acct.Filing_Binding_Total_LY__c;
            if (acct.Filing_Binding_TY__c != null) extension.Filing_Binding_TY__c = acct.Filing_Binding_TY__c;
            if (acct.First_Order_Date__c != null) extension.First_Order_Date__c = acct.First_Order_Date__c;
            if (acct.Follow_Up_Note__c != null) extension.Follow_Up_Note__c = acct.Follow_Up_Note__c;
            if (acct.Freight_Charge__c != null) extension.Freight_Charge__c = acct.Freight_Charge__c;
            if (acct.Fuel_Surcharge__c != null) extension.Fuel_Surcharge__c = acct.Fuel_Surcharge__c;
            if (acct.Furniture_IMU_LY__c != null) extension.Furniture_IMU_LY__c = acct.Furniture_IMU_LY__c;
            if (acct.Furniture_IMU_TY__c != null) extension.Furniture_IMU_TY__c = acct.Furniture_IMU_TY__c;
            if (acct.Furniture_Last_Order__c != null) extension.Furniture_Last_Order__c = acct.Furniture_Last_Order__c;
            if (acct.Furniture_last_order_amt__c != null) extension.Furniture_last_order_amt__c = acct.Furniture_last_order_amt__c;
            if (acct.Furniture_LY__c != null) extension.Furniture_LY__c = acct.Furniture_LY__c;
            if (acct.Furniture_Pot__c != null) extension.Furniture_Pot__c = acct.Furniture_Pot__c;
            if (acct.Furniture_Total_LY__c != null) extension.Furniture_Total_LY__c = acct.Furniture_Total_LY__c;
            if (acct.Furniture_TY__c != null) extension.Furniture_TY__c = acct.Furniture_TY__c;
            //if (acct.GGPId__c != null) extension.GGPId__c = acct.GGPId__c;
            if (acct.GP_Id__c != null) extension.GP_Id__c = acct.GP_Id__c;
            if (acct.GParent_GPID__c != null) extension.GParent_GPID__c = acct.GParent_GPID__c;
            if (acct.Grand_Siloe__c != null) extension.Grand_Siloe__c = acct.Grand_Siloe__c;
            //if (acct.Grandparent_Type__c != null) extension.Grandparent_Type__c = acct.Grandparent_Type__c;
            if (acct.GT_Account_Type__c != null) extension.GT_Account_Type__c = acct.GT_Account_Type__c;
            if (acct.GT_Description__c != null) extension.GT_Description__c = acct.GT_Description__c;
            if (acct.GT_Max_Perks_Eligible__c != null) extension.GT_Max_Perks_Eligible__c = acct.GT_Max_Perks_Eligible__c;
            if (acct.GT_Max_Perks_Enrolled__c != null) extension.GT_Max_Perks_Enrolled__c = acct.GT_Max_Perks_Enrolled__c;
            if (acct.GT_Max_Perks_Enrolled_Date__c != null) extension.GT_Max_Perks_Enrolled_Date__c = acct.GT_Max_Perks_Enrolled_Date__c;
            if (acct.GT_Segment__c != null) extension.GT_Segment__c = acct.GT_Segment__c;
            if (acct.Header_Record_Access__c != null) extension.Header_Record_Access__c = acct.Header_Record_Access__c;
            if (acct.Hide__c != null) extension.Hide__c = acct.Hide__c;
            if (acct.Hierarchy__c != null) extension.Hierarchy__c = acct.Hierarchy__c;
            if (acct.Hosted_Catalog_Flag__c != null) extension.Hosted_Catalog_Flag__c = acct.Hosted_Catalog_Flag__c;
            if (acct.Implementation_Manager__c != null) extension.Implementation_Manager__c = acct.Implementation_Manager__c;
            if (acct.Industry_OD_SIC_DB__c != null) extension.Industry_OD_SIC_DB__c = acct.Industry_OD_SIC_DB__c;
            if (acct.Industry_OD_SIC_Rep__c != null) extension.Industry_OD_SIC_Rep__c = acct.Industry_OD_SIC_Rep__c;
            if (acct.Initial_Site_Flag__c != null) extension.Initial_Site_Flag__c = acct.Initial_Site_Flag__c;
            if (acct.Ink_Toner_IMU_LY__c != null) extension.Ink_Toner_IMU_LY__c = acct.Ink_Toner_IMU_LY__c;
            if (acct.Ink_Toner_IMU_TY__c != null) extension.Ink_Toner_IMU_TY__c = acct.Ink_Toner_IMU_TY__c;
            if (acct.Ink_Toner_Last_Order__c != null) extension.Ink_Toner_Last_Order__c = acct.Ink_Toner_Last_Order__c;
            if (acct.Ink_Toner_Last_Order_amt__c != null) extension.Ink_Toner_Last_Order_amt__c = acct.Ink_Toner_Last_Order_amt__c;
            if (acct.Ink_Toner_LY__c != null) extension.Ink_Toner_LY__c = acct.Ink_Toner_LY__c;
            if (acct.Ink_Toner_Pot__c != null) extension.Ink_Toner_Pot__c = acct.Ink_Toner_Pot__c;
            if (acct.Ink_Toner_Total_LY__c != null) extension.Ink_Toner_Total_LY__c = acct.Ink_Toner_Total_LY__c;
            if (acct.Ink_Toner_TY__c != null) extension.Ink_Toner_TY__c = acct.Ink_Toner_TY__c;
            if (acct.Labels_Forms_IMU_LY__c != null) extension.Labels_Forms_IMU_LY__c = acct.Labels_Forms_IMU_LY__c;
            if (acct.Labels_Forms_IMU_TY__c != null) extension.Labels_Forms_IMU_TY__c = acct.Labels_Forms_IMU_TY__c;
            if (acct.Labels_Forms_Last_Order__c != null) extension.Labels_Forms_Last_Order__c = acct.Labels_Forms_Last_Order__c;
            if (acct.Labels_Forms_Last_Order_amt__c != null) extension.Labels_Forms_Last_Order_amt__c = acct.Labels_Forms_Last_Order_amt__c;
            if (acct.Labels_Forms_LY__c != null) extension.Labels_Forms_LY__c = acct.Labels_Forms_LY__c;
            if (acct.Labels_Forms_Pot__c != null) extension.Labels_Forms_Pot__c = acct.Labels_Forms_Pot__c;
            if (acct.Labels_Forms_Total_LY__c != null) extension.Labels_Forms_Total_LY__c = acct.Labels_Forms_Total_LY__c;
            if (acct.Labels_Forms_TY__c != null) extension.Labels_Forms_TY__c = acct.Labels_Forms_TY__c;
            if (acct.Last_Order_Date__c != null) extension.Last_Order_Date__c = acct.Last_Order_Date__c;
            if (acct.Legacy_CreatedBy__c != null) extension.Legacy_CreatedBy__c = acct.Legacy_CreatedBy__c;
            if (acct.Legacy_CreatedDate__c != null) extension.Legacy_CreatedDate__c = acct.Legacy_CreatedDate__c;
            if (acct.Legacy_LastModifiedBy__c != null) extension.Legacy_LastModifiedBy__c = acct.Legacy_LastModifiedBy__c;
            if (acct.Legacy_LastModifiedDate__c != null) extension.Legacy_LastModifiedDate__c = acct.Legacy_LastModifiedDate__c;
            if (acct.Legal_Flag__c != null) extension.Legal_Flag__c = acct.Legal_Flag__c;
            if (acct.Location_Type__c != null) extension.Location_Type__c = acct.Location_Type__c;
            if (acct.Loyalty_Type__c != null) extension.Loyalty_Type__c = acct.Loyalty_Type__c;
            if (acct.Max_Order_Limit__c != null) extension.Max_Order_Limit__c = acct.Max_Order_Limit__c;
            if (acct.Min_Order_Charge__c != null) extension.Min_Order_Charge__c = acct.Min_Order_Charge__c;
            if (acct.Minimum_Discount__c != null) extension.Minimum_Discount__c = acct.Minimum_Discount__c;
            if (acct.Miscellaneous_IMU_LY__c != null) extension.Miscellaneous_IMU_LY__c = acct.Miscellaneous_IMU_LY__c;
            if (acct.Miscellaneous_IMU_TY__c != null) extension.Miscellaneous_IMU_TY__c = acct.Miscellaneous_IMU_TY__c;
            if (acct.Miscellaneous_Last_Order__c != null) extension.Miscellaneous_Last_Order__c = acct.Miscellaneous_Last_Order__c;
            if (acct.Miscellaneous_Last_Order_amt__c != null) extension.Miscellaneous_Last_Order_amt__c = acct.Miscellaneous_Last_Order_amt__c;
            if (acct.Miscellaneous_LY__c != null) extension.Miscellaneous_LY__c = acct.Miscellaneous_LY__c;
            if (acct.Miscellaneous_Pot__c != null) extension.Miscellaneous_Pot__c = acct.Miscellaneous_Pot__c;
            if (acct.Miscellaneous_Total_LY__c != null) extension.Miscellaneous_Total_LY__c = acct.Miscellaneous_Total_LY__c;
            if (acct.Miscellaneous_TY__c != null) extension.Miscellaneous_TY__c = acct.Miscellaneous_TY__c;
            if (acct.Mod_5_EBS_Sync_Error__c != null) extension.Mod_5_EBS_Sync_Error__c = acct.Mod_5_EBS_Sync_Error__c;
            if (acct.Mod_5_EBS_Sync_Status__c != null) extension.Mod_5_EBS_Sync_Status__c = acct.Mod_5_EBS_Sync_Status__c;
            if (acct.Modified_Price_Value__c != null) extension.Modified_Price_Value__c = acct.Modified_Price_Value__c;
            if (acct.Monthly_LY__c != null) extension.Monthly_LY__c = acct.Monthly_LY__c;
            if (acct.Monthly_LY_IMU__c != null) extension.Monthly_LY_IMU__c = acct.Monthly_LY_IMU__c;
            if (acct.Monthly_Sales__c != null) extension.Monthly_Sales__c = acct.Monthly_Sales__c;
            if (acct.MPS_IMU_LY__c != null) extension.MPS_IMU_LY__c = acct.MPS_IMU_LY__c;
            if (acct.MPS_IMU_TY__c != null) extension.MPS_IMU_TY__c = acct.MPS_IMU_TY__c;
            if (acct.MPS_Last_Order__c != null) extension.MPS_Last_Order__c = acct.MPS_Last_Order__c;
            if (acct.MPS_Last_order_amt__c != null) extension.MPS_Last_order_amt__c = acct.MPS_Last_order_amt__c;
            if (acct.MPS_LY__c != null) extension.MPS_LY__c = acct.MPS_LY__c;
            if (acct.MPS_Pot__c != null) extension.MPS_Pot__c = acct.MPS_Pot__c;
            if (acct.MPS_Total_LY__c != null) extension.MPS_Total_LY__c = acct.MPS_Total_LY__c;
            if (acct.MPS_TY__c != null) extension.MPS_TY__c = acct.MPS_TY__c;
            if (acct.MTD_Sales_LY__c != null) extension.MTD_Sales_LY__c = acct.MTD_Sales_LY__c;
            if (acct.MTD_Sales_LY_IMU__c != null) extension.MTD_Sales_LY_IMU__c = acct.MTD_Sales_LY_IMU__c;
            if (acct.MTD_Sales_TY__c != null) extension.MTD_Sales_TY__c = acct.MTD_Sales_TY__c;
            if (acct.MTD_Sales_TY_IMU__c != null) extension.MTD_Sales_TY_IMU__c = acct.MTD_Sales_TY_IMU__c;
            if (acct.Num_of_Categories__c != null) extension.Num_of_Categories__c = acct.Num_of_Categories__c;
            if (acct.Num_of_Orders_Since_Start__c != null) extension.Num_of_Orders_Since_Start__c = acct.Num_of_Orders_Since_Start__c;
            if (acct.Number_of_Categories_Check__c != null) extension.Number_of_Categories_Check__c = acct.Number_of_Categories_Check__c;
            if (acct.Number_of_Orders__c != null) extension.Number_of_Orders__c = acct.Number_of_Orders__c;
            if (acct.Number_of_Orders_Check__c != null) extension.Number_of_Orders_Check__c = acct.Number_of_Orders_Check__c;
            if (acct.Off_Contract_Percent__c != null) extension.Off_Contract_Percent__c = acct.Off_Contract_Percent__c;
            if (acct.Off_Contract_Price_Code__c != null) extension.Off_Contract_Price_Code__c = acct.Off_Contract_Price_Code__c;
            if (acct.Office_Essentials_IMU_LY__c != null) extension.Office_Essentials_IMU_LY__c = acct.Office_Essentials_IMU_LY__c;
            if (acct.Office_Essentials_IMU_TY__c != null) extension.Office_Essentials_IMU_TY__c = acct.Office_Essentials_IMU_TY__c;
            if (acct.Office_Essentials_Last_Order__c != null) extension.Office_Essentials_Last_Order__c = acct.Office_Essentials_Last_Order__c;
            if (acct.Office_Essentials_Last_Order_amt__c != null) extension.Office_Essentials_Last_Order_amt__c = acct.Office_Essentials_Last_Order_amt__c;
            if (acct.Office_Essentials_LY__c != null) extension.Office_Essentials_LY__c = acct.Office_Essentials_LY__c;
            if (acct.Office_Essentials_Pot__c != null) extension.Office_Essentials_Pot__c = acct.Office_Essentials_Pot__c;
            if (acct.Office_Essentials_Total_LY__c != null) extension.Office_Essentials_Total_LY__c = acct.Office_Essentials_Total_LY__c;
            if (acct.Office_Essentials_TY__c != null) extension.Office_Essentials_TY__c = acct.Office_Essentials_TY__c;
            if (acct.OMX_Account__c != null) extension.OMX_Account__c = acct.OMX_Account__c;
            if (acct.OMX_Do_Not_Call__c != null) extension.OMX_Do_Not_Call__c = acct.OMX_Do_Not_Call__c;
            if (acct.OMX_GPO__c != null) extension.OMX_GPO__c = acct.OMX_GPO__c;
            if (acct.OMX_Mainframe_Account_Level__c != null) extension.OMX_Mainframe_Account_Level__c = acct.OMX_Mainframe_Account_Level__c;
            if (acct.OMX_Mainframe_Account_Number__c != null) extension.OMX_Mainframe_Account_Number__c = acct.OMX_Mainframe_Account_Number__c;
            if (acct.OMX_Mainframe_Consignee_ID__c != null) extension.OMX_Mainframe_Consignee_ID__c = acct.OMX_Mainframe_Consignee_ID__c;
            if (acct.OMX_Mainframe_National_Acct_Number__c != null) extension.OMX_Mainframe_National_Acct_Number__c = acct.OMX_Mainframe_National_Acct_Number__c;
            if (acct.OMX_Mainframe_Owning_Rep_Number__c != null) extension.OMX_Mainframe_Owning_Rep_Number__c = acct.OMX_Mainframe_Owning_Rep_Number__c;
            if (acct.OMX_Primary_Key__c != null) extension.OMX_Primary_Key__c = acct.OMX_Primary_Key__c;
            if (acct.OMX_Tier_1_Type__c != null) extension.OMX_Tier_1_Type__c = acct.OMX_Tier_1_Type__c;
            if (acct.OMXIsUpdated__c != null) extension.OMXIsUpdated__c = acct.OMXIsUpdated__c;
            if (acct.Opportunity_Amt__c != null) extension.Opportunity_Amt__c = acct.Opportunity_Amt__c;
            if (acct.Opt_Date__c != null) extension.Opt_Date__c = acct.Opt_Date__c;
            if (acct.Oracle_Party_ID__c != null) extension.Oracle_Party_ID__c = acct.Oracle_Party_ID__c;
            if (acct.Oracle_Party_Number__c != null) extension.Oracle_Party_Number__c = acct.Oracle_Party_Number__c;
            if (acct.Oracle_Party_Site_ID__c != null) extension.Oracle_Party_Site_ID__c = acct.Oracle_Party_Site_ID__c;
            if (acct.Oracle_Party_Site_Number__c != null) extension.Oracle_Party_Site_Number__c = acct.Oracle_Party_Site_Number__c;
            if (acct.Orders_Current_Month__c != null) extension.Orders_Current_Month__c = acct.Orders_Current_Month__c;
            if (acct.Orders_Current_Qtr__c != null) extension.Orders_Current_Qtr__c = acct.Orders_Current_Qtr__c;
            if (acct.Orders_Current_Yr__c != null) extension.Orders_Current_Yr__c = acct.Orders_Current_Yr__c;
            if (acct.Orders_Last_Month__c != null) extension.Orders_Last_Month__c = acct.Orders_Last_Month__c;
            if (acct.Orders_Last_Qtr__c != null) extension.Orders_Last_Qtr__c = acct.Orders_Last_Qtr__c;
            if (acct.Orders_Last_Yr__c != null) extension.Orders_Last_Yr__c = acct.Orders_Last_Yr__c;
            if (acct.Org_Number_of_Locations__c != null) extension.Org_Number_of_Locations__c = acct.Org_Number_of_Locations__c;
            if (acct.Org_WCW_Count_DB__c != null) extension.Org_WCW_Count_DB__c = acct.Org_WCW_Count_DB__c;
            if (acct.Org_WCW_Count_Rep__c != null) extension.Org_WCW_Count_Rep__c = acct.Org_WCW_Count_Rep__c;
            if (acct.Original_System__c != null) extension.Original_System__c = acct.Original_System__c;
            if (acct.Paper_IMU_LY__c != null) extension.Paper_IMU_LY__c = acct.Paper_IMU_LY__c;
            if (acct.Paper_IMU_TY__c != null) extension.Paper_IMU_TY__c = acct.Paper_IMU_TY__c;
            if (acct.Paper_Last_Order__c != null) extension.Paper_Last_Order__c = acct.Paper_Last_Order__c;
            if (acct.Paper_Last_Order_amt__c != null) extension.Paper_Last_Order_amt__c = acct.Paper_Last_Order_amt__c;
            if (acct.Paper_LY__c != null) extension.Paper_LY__c = acct.Paper_LY__c;
            if (acct.Paper_Pot__c != null) extension.Paper_Pot__c = acct.Paper_Pot__c;
            if (acct.Paper_Total_LY__c != null) extension.Paper_Total_LY__c = acct.Paper_Total_LY__c;
            if (acct.Paper_TY__c != null) extension.Paper_TY__c = acct.Paper_TY__c;
            if (acct.Payment_Term__c != null) extension.Payment_Term__c = acct.Payment_Term__c;
            if (acct.Phone_Ext__c != null) extension.Phone_Ext__c = acct.Phone_Ext__c;
            if (acct.Pot_Disposition__c != null) extension.Pot_Disposition__c = acct.Pot_Disposition__c;
            if (acct.Pot_Disposition_Reason__c != null) extension.Pot_Disposition_Reason__c = acct.Pot_Disposition_Reason__c;
            if (acct.Potential_Amount__c != null) extension.Potential_Amount__c = acct.Potential_Amount__c;
            if (acct.Potential_DeDuplicate__c != null) extension.Potential_DeDuplicate__c = acct.Potential_DeDuplicate__c;
            if (acct.Potential_Duplicate__c != null) extension.Potential_Duplicate__c = acct.Potential_Duplicate__c;
            if (acct.Potential_Duplicate_of_ID__c != null) extension.Potential_Duplicate_of_ID__c = acct.Potential_Duplicate_of_ID__c;
            if (acct.Potential_Printers__c != null) extension.Potential_Printers__c = acct.Potential_Printers__c;
            if (acct.Predictive_Purchase__c != null) extension.Predictive_Purchase__c = acct.Predictive_Purchase__c;
            if (acct.Previous_Owner_ID__c != null) extension.Previous_Owner_ID__c = acct.Previous_Owner_ID__c;
            if (acct.Price_As__c != null) extension.Price_As__c = acct.Price_As__c;
            if (acct.Pricing_Flip_Effective_Date__c != null) extension.Pricing_Flip_Effective_Date__c = acct.Pricing_Flip_Effective_Date__c;
            if (acct.Pricing_template_cd__c != null) extension.Pricing_template_cd__c = acct.Pricing_template_cd__c;
            if (acct.Primary_BillTo__c != null) extension.Primary_BillTo__c = acct.Primary_BillTo__c;
            if (acct.Primary_Competitor__c != null) extension.Primary_Competitor__c = acct.Primary_Competitor__c;
            if (acct.Primary_Product__c != null) extension.Primary_Product__c = acct.Primary_Product__c;
            if (acct.Primary_Site__c != null) extension.Primary_Site__c = acct.Primary_Site__c;
            if (acct.Primary_Site_ID__c != null) extension.Primary_Site_ID__c = acct.Primary_Site_ID__c;
            if (acct.Processing__c != null) extension.Processing__c = acct.Processing__c;
            if (acct.Prospect_Creation_Failure__c != null) extension.Prospect_Creation_Failure__c = acct.Prospect_Creation_Failure__c;
            if (acct.QTD_Sales_LY__c != null) extension.QTD_Sales_LY__c = acct.QTD_Sales_LY__c;
            if (acct.QTD_Sales_LY_IMU__c != null) extension.QTD_Sales_LY_IMU__c = acct.QTD_Sales_LY_IMU__c;
            if (acct.QTD_Sales_TY__c != null) extension.QTD_Sales_TY__c = acct.QTD_Sales_TY__c;
            if (acct.QTD_Sales_TY_IMU__c != null) extension.QTD_Sales_TY_IMU__c = acct.QTD_Sales_TY_IMU__c;
            if (acct.Quarter_LY__c != null) extension.Quarter_LY__c = acct.Quarter_LY__c;
            if (acct.Quarter_LY_IMU__c != null) extension.Quarter_LY_IMU__c = acct.Quarter_LY_IMU__c;
            if (acct.Ranking__c != null) extension.Ranking__c = acct.Ranking__c;
            if (acct.Recurring_Request_Enabled__c != null) extension.Recurring_Request_Enabled__c = acct.Recurring_Request_Enabled__c;
            if (acct.Related_Parent_Account__c != null) extension.Related_Parent_Account__c = acct.Related_Parent_Account__c;
            if (acct.Remediation_Required__c != null) extension.Remediation_Required__c = acct.Remediation_Required__c;
            if (acct.Rep_Call_Date__c != null) extension.Rep_Call_Date__c = acct.Rep_Call_Date__c;
            if (acct.Request_Account_Billing__c != null) extension.Request_Account_Billing__c = acct.Request_Account_Billing__c;
            if (acct.Revenue_Band__c != null) extension.Revenue_Band__c = acct.Revenue_Band__c;
            if (acct.Rolling_12_month_sales__c != null) extension.Rolling_12_month_sales__c = acct.Rolling_12_month_sales__c;
            if (acct.Rolling_3_month_sales__c != null) extension.Rolling_3_month_sales__c = acct.Rolling_3_month_sales__c;
            if (acct.Rolling_6_month_sales__c != null) extension.Rolling_6_month_sales__c = acct.Rolling_6_month_sales__c;
            if (acct.Rolling_9_month_sales__c != null) extension.Rolling_9_month_sales__c = acct.Rolling_9_month_sales__c;
            if (acct.RSD_User__c != null) extension.RSD_User__c = acct.RSD_User__c;
            if (acct.Sales__c != null) extension.Sales__c = acct.Sales__c;
            if (acct.Sales_Check__c != null) extension.Sales_Check__c = acct.Sales_Check__c;
            if (acct.Sales_PersonID__c != null) extension.Sales_PersonID__c = acct.Sales_PersonID__c;
            if (acct.Sector__c != null) extension.Sector__c = acct.Sector__c;
            if (acct.Segment__c != null) extension.Segment__c = acct.Segment__c;
            if (acct.Setup_URL1__c != null) extension.Setup_URL1__c = acct.Setup_URL1__c;
            if (acct.SIC_Description_FR__c != null) extension.SIC_Description_FR__c = acct.SIC_Description_FR__c;
            if (acct.Silo__c != null) extension.Silo__c = acct.Silo__c;
            if (acct.Site_Contact2__c != null) extension.Site_Contact2__c = acct.Site_Contact2__c;
            if (acct.Site_Contact3__c != null) extension.Site_Contact3__c = acct.Site_Contact3__c;
            if (acct.Site_Contact4__c != null) extension.Site_Contact4__c = acct.Site_Contact4__c;
            if (acct.Site_Contact5__c != null) extension.Site_Contact5__c = acct.Site_Contact5__c;
            if (acct.Site_Contact6__c != null) extension.Site_Contact6__c = acct.Site_Contact6__c;
            if (acct.Site_Primary_Contact__c != null) extension.Site_Primary_Contact__c = acct.Site_Primary_Contact__c;
            if (acct.Source_System__c != null) extension.Source_System__c = acct.Source_System__c;
            if (acct.Source_System_that_has_the_latest_opt_de__c != null) extension.Source_System_that_has_the_latest_opt_de__c = acct.Source_System_that_has_the_latest_opt_de__c;
            if (acct.Split_Flag__c != null) extension.Split_Flag__c = acct.Split_Flag__c;
            if (acct.Split_Record__c != null) extension.Split_Record__c = acct.Split_Record__c;
            if (acct.Stage__c != null) extension.Stage__c = acct.Stage__c;
            if (acct.State__c != null) extension.State__c = acct.State__c;
            if (acct.Status__c != null) extension.Status__c = acct.Status__c;
            if (acct.Tax_Exempt__c != null) extension.Tax_Exempt__c = acct.Tax_Exempt__c;
            if (acct.Tech_IMU_LY__c != null) extension.Tech_IMU_LY__c = acct.Tech_IMU_LY__c;
            if (acct.Tech_IMU_TY__c != null) extension.Tech_IMU_TY__c = acct.Tech_IMU_TY__c;
            if (acct.Tech_Last_Order__c != null) extension.Tech_Last_Order__c = acct.Tech_Last_Order__c;
            if (acct.Tech_Last_Order_amt__c != null) extension.Tech_Last_Order_amt__c = acct.Tech_Last_Order_amt__c;
            if (acct.Tech_LY__c != null) extension.Tech_LY__c = acct.Tech_LY__c;
            if (acct.Tech_Pot__c != null) extension.Tech_Pot__c = acct.Tech_Pot__c;
            if (acct.Tech_Total_LY__c != null) extension.Tech_Total_LY__c = acct.Tech_Total_LY__c;
            if (acct.Tech_TY__c != null) extension.Tech_TY__c = acct.Tech_TY__c;
            if (acct.Tier_1_Partner__c != null) extension.Tier_1_Partner__c = acct.Tier_1_Partner__c;
            if (acct.Total_Order__c != null) extension.Total_Order__c = acct.Total_Order__c;
            if (acct.Transition_Calender_Date__c != null) extension.Transition_Calender_Date__c = acct.Transition_Calender_Date__c;
            if (acct.Transition_Customer__c != null) extension.Transition_Customer__c = acct.Transition_Customer__c;
            if (acct.Ultimate_Duns_Number__c != null) extension.Ultimate_Duns_Number__c = acct.Ultimate_Duns_Number__c;
            if (acct.Verticals__c != null) extension.Verticals__c = acct.Verticals__c;
            if (acct.Weekly_Sales__c != null) extension.Weekly_Sales__c = acct.Weekly_Sales__c;
            if (acct.Weeks_Since_1st_Order__c != null) extension.Weeks_Since_1st_Order__c = acct.Weeks_Since_1st_Order__c;
            if (acct.Weeks_Since_Last_Order__c != null) extension.Weeks_Since_Last_Order__c = acct.Weeks_Since_Last_Order__c;
            if (acct.Wholesaler__c != null) extension.Wholesaler__c = acct.Wholesaler__c;
            if (acct.Wholesaler_Discount_Percent__c != null) extension.Wholesaler_Discount_Percent__c = acct.Wholesaler_Discount_Percent__c;
            if (acct.WLR_Enrolled__c != null) extension.WLR_Enrolled__c = acct.WLR_Enrolled__c;
            if (acct.Writing_Drafting_IMU_LY__c != null) extension.Writing_Drafting_IMU_LY__c = acct.Writing_Drafting_IMU_LY__c;
            if (acct.Writing_Drafting_IMU_TY__c != null) extension.Writing_Drafting_IMU_TY__c = acct.Writing_Drafting_IMU_TY__c;
            if (acct.Writing_Drafting_Last_Order__c != null) extension.Writing_Drafting_Last_Order__c = acct.Writing_Drafting_Last_Order__c;
            if (acct.Writing_Drafting_Last_Order_amt__c != null) extension.Writing_Drafting_Last_Order_amt__c = acct.Writing_Drafting_Last_Order_amt__c;
            if (acct.Writing_Drafting_LY__c != null) extension.Writing_Drafting_LY__c = acct.Writing_Drafting_LY__c;
            if (acct.Writing_Drafting_Pot__c != null) extension.Writing_Drafting_Pot__c = acct.Writing_Drafting_Pot__c;
            if (acct.Writing_Drafting_Total_LY__c != null) extension.Writing_Drafting_Total_LY__c = acct.Writing_Drafting_Total_LY__c;
            if (acct.Writing_Drafting_TY__c != null) extension.Writing_Drafting_TY__c = acct.Writing_Drafting_TY__c;
            if (acct.Year_LY__c != null) extension.Year_LY__c = acct.Year_LY__c;
            if (acct.Year_LY_IMU__c != null) extension.Year_LY_IMU__c = acct.Year_LY_IMU__c;
            if (acct.YTD_Sales_LY__c != null) extension.YTD_Sales_LY__c = acct.YTD_Sales_LY__c;
            if (acct.YTD_Sales_LY_IMU__c != null) extension.YTD_Sales_LY_IMU__c = acct.YTD_Sales_LY_IMU__c;
            if (acct.YTD_Sales_TY__c != null) extension.YTD_Sales_TY__c = acct.YTD_Sales_TY__c;
            if (acct.YTD_Sales_TY_IMU__c != null) extension.YTD_Sales_TY_IMU__c = acct.YTD_Sales_TY_IMU__c;
            if (acct.Zip__c != null) extension.Zip__c = acct.Zip__c;
            if (AcctmapRacct.get(acct.Related_Account__c) != null) extension.Related_OD_Account_Extension__c = AcctmapRacct.get(acct.Related_Account__c);
            // Line added to update Related account
            extension.Related_Account__c=acct.Related_Account__c;
            if (acct.Owner.id != null) extension.Account_Owner_ID__c = acct.Owner.id;
            if (acctmapPT.get(acct.Related_Pricing_Template_Account__c) != null) extension.Related_Pricing_Template_Dormant_Account__c = acctmapPT.get(acct.Related_Pricing_Template_Account__c);
            if (Prntmap.get(acct.Parentid) != null) extension.Account_ParentId__c = Prntmap.get(acct.Parentid);
            if (acct.id != null) extension.Account__c = acct.id;
            if (acct.Name != null) extension.Name = acct.Name;
            if (rectypes.get(acct.recordtype.DeveloperName) != null) extension.RecordTypeId= rectypes.get(acct.recordtype.DeveloperName);
            if (acct.recordtypeid != null) extension.Account_Record_Type_Id__c = acct.recordtypeid;
            extension.Current_Account_ID__c = acctId.substring(0, 15);
            
            // Will be used to assign Account.Account_Extension__c
            if (AcctExtensionIdsInserted.contains(extension.Id)) {
                accountIdToExtensionId.put(acct.Id, extension.Id);
            }
        }
        
        Database.SaveResult[] srList2 = Database.update(extensions, false);
        
        for (Database.SaveResult sr : srList2) {
            if (!sr.isSuccess()) {
                for (Database.Error err : sr.getErrors()) {
                    System.debug('AccountExtensionHelper -> update(extensions) errors = ' + err.getStatusCode() + ': ' + err.getMessage() + ' ( ' +  err.getFields() + ' ) ');
                }
            }
        }
        
        // Assign Account.Account_Extension__c if needed
        List<Account> acctsToUpdate = [SELECT Id, Account_Extension__c FROM Account WHERE Id IN :accountIdToExtensionId.keySet()];
        
        for (Account acct : acctsToUpdate) {
            acct.Account_Extension__c = accountIdToExtensionId.get(acct.Id);
        }
        
        Database.SaveResult[] srList3 = Database.update(acctsToUpdate, false);
        
        for (Database.SaveResult sr : srList3) {
            if (!sr.isSuccess()) {
                for (Database.Error err : sr.getErrors()) {
                    System.debug('AccountExtensionHelper -> update(acctsToUpdate) errors = ' + err.getStatusCode() + ': ' + err.getMessage() + ' ( ' +  err.getFields() + ' ) ');
                }
            }
        }
    }
    
    public Map<Id, Id> getAccountExtensionIds(List<Id> accountIds) {
        System.debug('AccountExtensionHelper > getAccountExtensionIds()');
        
        Map<Id, Id> accountIdToExtensionId = new Map<Id, Id>();
        
        List<Account_Extension__c> extensions = [SELECT Id, Account__c FROM Account_Extension__c WHERE Account__c IN :accountIds];
        
        for (Account_Extension__c ext : extensions) {
           /////////// System.debug('AccountExtensionHelper > ext = ' + ext);
            accountIdToExtensionId.put(ext.Account__c, ext.Id);
        }

        return accountIdToExtensionId;
    } 
}