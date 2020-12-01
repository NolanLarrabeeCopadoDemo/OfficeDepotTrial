/**@@
#APEX CLASS NAME          :    DataFactory 
#DESCRIPTION              :    This is Utility class used for test data creation.Modified by Rajendra Shahane for ticket 02831114 - Account triggers conversion to Lightning
@@**/
@istest
public class DataFactory {
    public static List<User> userList = new List<User>();
    
    public Static List<User> createUserTestRecords(String userLastName,Integer totalUsers){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        for(Integer i=0;i<totalUsers;i++){
            User testUser = new User(Alias = 'standt'+i, 
                                     Email='proxy@proxy1456.officedepot.com', 
                                     EmailEncodingKey='UTF-8', 
                                     LastName=userLastName, 
                                     LanguageLocaleKey='en_US', 
                                     LocaleSidKey='en_US',
                                     ProfileId = p.Id, 
                                     TimeZoneSidKey='America/Los_Angeles', 
                                     UserName='standarduser'+i+'@t2estorg.com');
            userList.add(testUser);
        }
        insert userList;
        return userList;
    }//END OF USER INSERT
    
    
    //  Test Records for List of Account Object
    public Static List<Account> createAccountTestRecords(String accName,Integer totalAccounts, String ParentId){
        Id GPRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<totalAccounts; i++) {
            Account accObj;
            if(ParentId != ''){
                accObj = new Account( Name =accName + i, BillingCity ='Orem', BillingCountry = 'USA',
                                     BillingPostalCode='111111', BillingState='UT', BillingStreet='1040 N 326 W',
                                     RecordTypeId = GPRecordTypeId, ParentId = ParentId,                                     
                                     Industry='TestSoftware',Website = 'www.acmetesttest.com' + i,AOPS_Cust_Id__c='12345688' + i, AOPS_Seq_ID__c = '1234577' + i
                                    );
            }else{
                accObj = new Account( Name =accName + i, BillingCity ='Orem', BillingCountry = 'USA',
                                     BillingPostalCode='111111', BillingState='UT', BillingStreet='1040 N 326 W',                                                                              
                                     Industry='TestSoftware',Website = 'www.acmetest.com' + i,AOPS_Cust_Id__c='123456' + i, AOPS_Seq_ID__c = '123456' + i
                                    );
            }
            
            accList.add(accObj);
        }
        insert accList;
        return accList;
    }//END OF ACCOUNT INSERT 
    
    //  Test Records for List of Account Object
    public Static List<Account> createSpecificAccountRecords(String accName,String ParentId,list<string> lstrecordtypeId){
        Id GPRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('GrandParent').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Id CustBizProTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (Business Pro)').getRecordTypeId();
        for(Integer i=0; i<lstrecordtypeId.size(); i++) 
        {
            Account accObj;
            
            accObj = new Account( Name =accName + i, BillingCity ='Orem', BillingCountry = 'USA',
                                 BillingPostalCode='111111', BillingState='UT', BillingStreet='1040 N 326 W',
                                 RecordTypeId = lstrecordtypeId[i], ParentId = ParentId,                                     
                                 Industry='TestSoftware',Website = 'www.acmetesttest.com' + i,AOPS_Cust_Id__c='12345688' + i, AOPS_Seq_ID__c = '1234577' + i
                                );
            if(lstrecordtypeId[i] == CustBizProTypeId)
            {
                accObj.Rating = 'Cold';
                accObj.Loyatly_Number__c = '123456';
            }
            accList.add(accObj);
        }
        insert accList;
        return accList;
    }//END OF ACCOUNT INSERT 
    
    //  Test Records for List of Contract Object
    public Static List<Contract> createContractTestRecords(String conName, Id accId, integer totalContracts){
        Id StandardRecordtypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Standard').getRecordTypeId();
        List<Contract> conList = new List<Contract>();
        for(Integer i=0; i<totalContracts; i++) {
            Contract conObj;
            //Only one Contract can be the primary for an Account
            if(i == 0){
                conObj = new Contract( Name='Test Con'+ i, 
                                      AccountId = accId,
                                      RecordTypeId = StandardRecordtypeId,
                                      Contract_Status__c = 'Closed/Cancelled',
                                      //Refer_to_Prior_CSF__c = 'xxxxx',
                                      Is_this_a_renewal__c = 'N/A',
                                      //Other_contract_type__c = 'Test',
                                      Vendor_Funded_Core_Specificall__c = 'No',
                                      Are_there_Rebates_Incentives__c ='Yes',
                                      Basis_Level_for_Customer_Agreement__c = 'Great Grandparent',
                                      GPO_Contract__c = true,
                                      primary__c = true,
                                      Is_this_a_2_party_or_3_party_agreement__c = '3-party',
                                      
                                     // GP_Core_List_SKU_Capped_Price_Increase__c = '% Cap',
                                     // Child_Core_SKU_Level_Capped_Price_Incr__c =  '% Cap',
                                      //Par_Core_SKU_Level_Capped_Price_Incr__c = '% Cap',
                                      Minimum_Annual_Spend_Commitment__c = null,
                                      Does_written_agreement_allow_for_price__c = 'Needs validation'
                                      
                                     );
            }else if(math.mod(i, 2) == 0){
                conObj = new Contract( Name='Test Con'+ i, 
                                      AccountId = accId,
                                      RecordTypeId = StandardRecordtypeId,
                                      Contract_Status__c = 'Closed/Cancelled',
                                     // Refer_to_Prior_CSF__c = 'xxxxx',
                                      Is_this_a_renewal__c = 'N/A',
                                      //Other_contract_type__c = 'Test',
                                      Vendor_Funded_Core_Specificall__c = 'No',
                                      Are_there_Rebates_Incentives__c ='Yes',
                                      Basis_Level_for_Customer_Agreement__c = 'Child Account',                                            
                                      Is_this_a_2_party_or_3_party_agreement__c = '3-party',
                                      
                                     // GP_Core_List_SKU_Capped_Price_Increase__c = '% Cap',
                                    //  Child_Core_SKU_Level_Capped_Price_Incr__c =  '% Cap',
                                     // Par_Core_SKU_Level_Capped_Price_Incr__c = '% Cap',
                                      Minimum_Annual_Spend_Commitment__c = null,
                                      Does_written_agreement_allow_for_price__c = 'Needs validation'
                                      
                                     );
            }else{
                conObj = new Contract( Name='Test Con'+ i, 
                                      AccountId = accId,
                                      //RecordTypeId = StandardRecordtypeId,                                            
                                     // Refer_to_Prior_CSF__c = 'xxxxx',                                            
                                      Other_contract_type__c = 'Test',
                                      Item_count_restrictions__c='Single',
                                      Agreement_allow_for_custom_cores__c = 'Yes',
                                      Custom_core_item_count__c = 'Yes',
                                      Contract_Status__c = 'Expired',
                                      Call_Out_Auto_Force_Sub__c = 'Yes',
                                      Call_Out_Cost_Plus_Floor__c = 'Yes',
                                      Contract_have_req_for_prop_items__c = 'Yes',
                                      Vendor_Funded_Core_Specificall__c = 'Yes',
                                      Minimum_Annual_Spend_Commitment__c = 'Yes',
                                      
                                      Current_contract_expiration_date_4__c = Date.today(),
                                      Current_contract_expiration_date_1__c = Date.today().addDays(2),
                                      Current_contract_expiration_date_2__c = Date.today().addDays(4),
                                      Current_contract_expiration_date_3__c = Date.today().addDays(1),
                                      Current_contract_expiration_date_5__c = Date.today().addDays(5),
                                      
                                      NCNC_governed_by_the_agreement__c='Yes',
                                      X3rd_party_required_to_provide_a_securit__c = 'Yes',
                                      Are_there_Rebates_Incentives__c = null,
                                      
                                      Contract_state_a_Small_Order_Fee_charge__c='Yes',
                                      Contract_state_a_furniture_delivery_fee__c = 'Yes',
                                      Dimension_fee_for_furn_charge_are_exclud__c = 'Yes',
                                      Contract_state_Restocking_Fees_excluded__c = 'Yes',
                                      Contract_State_Minimum_Order__c= 'Yes',
                                      Payment_Terms__c='Other',
                                      Is_there_a_clawback_provision__c = 'Yes',
                                      Duration_of_each_extension__c='Other',
                                      Contract_Extensions__c= 'Yes',
                                      Contract_cover_NonCore_Cat_setup_pricing__c = 'Yes',
                                      Basis_Level_for_Customer_Agreement__c = 'Parent Account',
                                      
                                      Contract_data_verified__c = true,
                                      Penalties_for_late_Rebate_payment__c = 'Yes',
                                      Reporting_Requirements_In_Legal_Agreemen__c = 'Yes',
                                      Report_Frequency__c = 'Other',
                                      Reporting_Penalties_for_late_reports__c = 'Yes',
                                      Multi_Country_Agreement__c = 'Yes',
                                      Have_Amendment_s_been_executed__c = 'Yes',
                                      Is_there_a_Most_Favored_Customer_claus__c = 'Yes',
                                     // Agreement_respon_based_on_cat_prod_assor__c= 'Yes',
                                      Does_contract_have_provisions_for_an_emp__c= 'Yes',
                                      //Are_there_Minority_Spend_Requirements__c= 'Yes',
                                      Written_Agreement_allow_GP_Custom_Cores__c= 'Yes',
                                     // Written_Agreement_allow_Standalone__c= 'Yes',
                                      //Written_Agreement_allow_Child_Cust_Cores__c= 'Yes',
                                      //Notification_process_for_disco_items__c= 'Yes',
                                      Is_there_a_custom_NCC__c= 'Yes', //// catalog_assortment_display = true
                                      Cust_notif_to_chg_Cust_NonCore_Cat_Prcin__c= 'Yes',
                                      
                                      OffContract_Pricing_specified_in_contrac__c= 'Yes',
                                      Wholesaler_Pricing_specified_in_contract__c= 'Yes',
                                      
                                      Work_with_Tier_1_partner_on_this_account__c= 'No/Contract Silent',
                                      Deviated_Pricing_offered_to_Customer__c= 'Yes',
                                      Does_written_agreement_allow_for_price__c= 'Yes',
                                      Agreement_provide_disco_on_spec_orders__c= 'Yes',
                                      Is_this_a_2_party_or_3_party_agreement__c = '2-party (OD & Customer)',
                                      
                                      
                                      
                                      //Par_Core_have_Capped_Price_Increase__c = 'Yes',
                                     // Par_Core_List_Capped_Price_Increase__c = 'SKU Level',
                                      
                                    //  Parent_Custom_Core_Discount_Basis__c = 'WAPO Mark-Up',
                                      
                                      
                                      
                                      
                                    
                                      
                                      
                                      
                                      NonCore_Cat_Update_Notice_Period__c = 'Other',
                                      NonCore_Catalog_Update_Frequency__c = 'Other',
                                      
                                      Decr_req_to_be_applied_to_NonCore_Cat__c= 'Yes',
                                     // Written_Agreement_allow_Parent_Cust_Core__c= 'Yes',
                                      
                                      
                                      Are_there_GP_SKU_Count_Limitations__c= 'Yes',
                                      
                                     // GP_Core_List_SKU_Capped_Price_Increase__c = '$ Cap', 
                                      
                                     // Standalone_Core_List_have_Capped_Price__c = 'Yes',
                                     // Are_there_Standalone_SKU_Count_Limit__c= 'Yes',
                                     // StandalonCore_List_Capped_Price_Increase__c = 'SKU Level',
                                      //Standalone_Custom_Core_Discount_Basis__c = 'WAPO Mark-Up',
                                      
                                    //  Child_Core_SKU_Level_Capped_Price_Incr__c = '$ Cap', //// '% Cap'
                                     // Par_Core_SKU_Level_Capped_Price_Incr__c = '$ Cap', /// '% Cap'
                                      
                                     // Par_Cust_Core_List_Update_Notice_Period__c ='Other',
                                     
                                      
                                     // Standalone_Pricing_Update_Frequency__c = 'Other',
                                      //Parent_Pricing_Update_Frequency__c = 'Other',
                                      
                                      Is_this_a_renewal__c = 'Yes',
                                      Point_of_sale_or_rebate_option__c = true,
                                      IT_security_breach_notice_obligation__c = 'Contract silent',
                                      Is_there_a_Point_of_Sale_Discount__c = 'Yes',
                                      Documentation_confirmation_required_to_p__c= 'Yes',
                                      Desktop_delivery__c = 'Yes'
                                      
                                     );
            }
            
            conList.add(conObj);
        }
        insert conList;
        return conList;
    }//END OF Contract INSERT 
    
    //  Test Records for List of Contract Price Terms Object
    public Static List<Contract_Pricing_Terms__c> createContractPriceTermsTestRecords(String conName, Id conId, integer totalCPT){
        
        List<Contract_Pricing_Terms__c> cptList = new List<Contract_Pricing_Terms__c>();
        for(Integer i=0; i<totalCPT; i++) {
            Contract_Pricing_Terms__c cptObj = new Contract_Pricing_Terms__c( Name='Test CPT' + i, Contract__c = conId
                                                                            );
            cptList.add(cptObj);
        }
        insert cptList;
        return cptList;
    }//END OF Contract Price Terms INSERT 
    
    //  Test Records for List of Opportunity Object
    public Static List<opportunity> createOpportunityTestRecords(String oppName, Id accId, integer totalOpp){
        
        List<opportunity> oppList = new List<opportunity>();
        for(Integer i=0; i<totalOpp; i++) {
            opportunity oppObj = new opportunity( Name='Test Opp' + i, AccountId = accId
            ,StageName =  'New',CloseDate = system.Today()
                                                );
            oppList.add(oppObj);
        }
        insert oppList;
        return oppList;
    }//END OF Opportunity INSERT
    
    public Static List<Lead> createLeadTestRecords(Id OwnerId, Integer totalLead, Id RecordType, Boolean Converted){
        
        List<Lead> QualifyingLeads = new List<Lead>();
        for(Integer i = 0; i < totalLead; i++){
            QualifyingLeads.add(
                new Lead(
                    FirstName ='Gen_Lead_First_Name_' + i,
                    LastName ='Gen_Lead_Last_Name_' + i,
                    Company = 'The Qualifying Company_' + i,
                    Email = 'Qualifying'+i+'@Email.Com',
                    Phone = '1092837364',
                    RecordTypeId = RecordType,
                    Estimated_Close_Date__c = System.today(),
                    OwnerId = OwnerId,
                    IsConverted = Converted));
        }
        //return QualifyingLeads;
        insert QualifyingLeads;
        return QualifyingLeads;
    }//END OF  INSERT

    public Static List<Org__c> createOrgTestRecords(String Name,Integer count, String RecordType){       
        List<Org__c> OrgList = new List<Org__c>();
        for(Integer i = 0; i < count; i++){
            OrgList.add(
                new Org__c(
                    Business_Name__c =Name+''+i,
                    Address_1__c ='2235 Seacrest Blvd' + i,
                    City__c = 'Delray Beach',
                    State__c = 'FL',
                    Zip__c = '33444',
                    //RecordTypeId = RecordType,
                    DUNS_Number__c = '00655840'+i));
        }
        //return QualifyingLeads;
        insert OrgList;
        return OrgList;
    } //Decision_Maker_Name__c, DML__c, DML_Details__c FROM DML_Relation__c

    
    public Static List<DML__c> createDMLTestRecords(String Name,Integer count, String RecordType){      
        List<DML__c> DMLList = new List<DML__c>();
        for(Integer i = 0; i < count; i++){
            DMLList.add(
                new DML__c(
                    DECISION_MAKER_NM__c= Name+i,
                    Notes__c='Test',
                    DML_State__c='FL',
                    DML_City__c='Delray Beach',
                    DECISION_MAKER_SEGMENT__c='',
                    DECISION_MAKER_ZIP_CD__c='10928',
                    Effective_Start_Date__c = Date.today()));
        }
        insert DMLList;
        return DMLList;
    }

    public Static List<Contact> createContactTestRecords(String Name,Integer count, String RecordType,String accountid){      
        List<Contact> ContactList = new List<Contact>();
        for(Integer i = 0; i < count; i++){
            ContactList.add(
                new Contact(
                    FirstName='First'+i,
                    LastName='Last'+i,
                    AccountId=accountid)
                );    
        }
        insert ContactList; 
        return ContactList;
    }
    
}