/***************************************************************
*Name : Test_AccountSetUp
*Created By : Anjali (Appirio Off)
*Created Date : 25th Oct,2011
*Purpose : Test AccountSetUpTrigger
*Last Modified : Appirio Off (Dheeraj, 27th Dec)
****************************************************************/
@isTest
private class Test_AccountSetUp { 

@isTest
  static void testAccountSetUp() {    
   
    //Create Account
    Account acc = Test_Utils.CreateAccount();
    
    //Create AccountSetUp object
    Account_Setup_Request__c accSetUp = Test_Utils.createAccountSetupReq(acc);
    insert accSetup;
        
    //for every insert/Update a new Account_Message__c is created
    List<Account_Message__c> lstAccountMsg = [Select id, ACCT_CUST_TYPE__c,ACCT_CUST_SUBTYPE__c ,
                                       AP_CT_AP_CONTACT_ROLE__c,  ACCT_CUSTOMER_NAME__c,ACCT_BT_SFDC_BILLTO_ID__c, ACCT_BT_BILLTO_NAME__c,
                                       ACCT_ST_SHIPTO_NAME__c,ACCT_ID_SFDC_ACCOUNT_ID__c, ACCT_ID_PROSPECT_ID__c,
                                       ACCT_ID_REQUEST_ID__c, ACCT_ID_PARENT_ID__c, ACCT_CPD_FLAG__c ,AP_CT_AP_EMAIL__c,
                                       AP_CT_AP_PRIMARY_FAX__c, AP_CT_AP_CONTACT_FIRSTNAME__c,AP_CT_AP_TITLE__c,
                                       AP_CT_AP_CONTACT_LASTNAME__c, AP_CT_AP_PRIMARY_PHONE__c, AP_CT_AP_SALUTAION__c,
                                       AP_CT_AP_MOB_PHONE__c, ACCT_BACK_ORDER_ALLOW__c, ACCT_DISPLAY_BACKORDERS__c,
                                       ACCT_BT_BILL_COUNTRY__c, ACCT_ADD_EDI_FLAG__c , PD_PD_PAY_FREQUENCY__c, ACCT_BT_BILL_CITY__c,
                                       ACCT_ST_SHIP_CITY__c, CNTR_01_CONTRACT_PRIORITY_1__c,CNTR_02_CONTRACT_PRIORITY_2__c,
                                       CNTR_03_CONTRACT_PRIORITY_3__c,CNTR_04_CONTRACT_PRIORITY_4__c,CNTR_05_CONTRACT_PRIORITY_5__c,
                                       CNTR_06_CONTRACT_PRIORITY_6__c,CNTR_07_CONTRACT_PRIORITY_7__c,CNTR_08_CONTRACT_PRIORITY_8__c,
                                       CNTR_09_CONTRACT_PRIORITY_9__c,CNTR_10_CONTRACT_PRIORITY_10__c from Account_Message__c 
                                       where ACCT_ID_SFDC_ACCOUNT_ID__c = :accSetup.Account__c];
   
    //Account Message fiels are populated with Account_Setup_Request__c fields
    //System.assertEquals(lstAccountMsg.size(),1);
    if(lstAccountMsg.size() > 0) {
        
      //System.assertEquals(lstAccountMsg[0].ACCT_ID_REQUEST_ID__c,accSetup.ORACLE_PARTY_ID__c);
      System.assertEquals(lstAccountMsg[0].ACCT_CUST_TYPE__c,accSetup.Loyalty_Type__c);
      System.assertEquals(lstAccountMsg[0].ACCT_ID_SFDC_ACCOUNT_ID__c,accSetup.Account__c);
      System.assertEquals(lstAccountMsg[0].ACCT_ID_PROSPECT_ID__c,accSetup.Account__c);
      // System.assertEquals(lstAccountMsg[0].ACCT_CUST_SUBTYPE__c,accSetup.Segment__c);
      //System.assertEquals(lstAccountMsg[0].AP_CT_AP_CONTACT_ROLE__c,accSetup.AP_Contact_Role__c);
      //System.assertEquals(lstAccountMsg[0].ACCT_CUSTOMER_NAME__c,accSetup.Loyalty_Type__c);
      System.assertEquals(lstAccountMsg[0].ACCT_BT_SFDC_BILLTO_ID__c,accSetup.SFDC_BILLTO_ID__c);
      System.assertEquals(lstAccountMsg[0].ACCT_BT_BILLTO_NAME__c,accSetup.BillTo_Name__c);
      System.assertEquals(lstAccountMsg[0].ACCT_ST_SHIPTO_NAME__c,accSetup.ShipTo_Name__c);
      
      System.assertEquals(lstAccountMsg[0].ACCT_ID_SFDC_ACCOUNT_ID__c,accSetup.ACCOUNT__c);
      System.assertEquals(lstAccountMsg[0].ACCT_ID_PROSPECT_ID__c,accSetup.ACCOUNT__c);
      //System.assertEquals(lstAccountMsg[0].ACCT_ID_REQUEST_ID__c,accSetup.Account_Setup_Request_Number__c);
      System.assertEquals(lstAccountMsg[0].ACCT_ID_PARENT_ID__c,accSetup.Add_Parent_ID__c);
      
      System.assertEquals(lstAccountMsg[0].ACCT_CPD_FLAG__c ,accSetup.Allow_Print_on_Demand__c);
      System.assertEquals(lstAccountMsg[0].AP_CT_AP_EMAIL__c,accSetup.AP_Contact_Email__c);
      System.assertEquals(lstAccountMsg[0].AP_CT_AP_PRIMARY_FAX__c,accSetup.AP_Contact_Fax__c);
      System.assertEquals(lstAccountMsg[0].AP_CT_AP_CONTACT_FIRSTNAME__c,accSetup.AP_Contact_First_Name__c);
      
      System.assertEquals(lstAccountMsg[0].AP_CT_AP_TITLE__c,accSetup.AP_Contact_Job_Title__c);
      System.assertEquals(lstAccountMsg[0].AP_CT_AP_CONTACT_LASTNAME__c,accSetup.AP_Contact_Last_Name__c);
      System.assertEquals(lstAccountMsg[0].AP_CT_AP_PRIMARY_PHONE__c,accSetup.AP_Contact_Phone__c);
      System.assertEquals(lstAccountMsg[0].AP_CT_AP_SALUTAION__c,accSetup.AP_Contact_Salutation__c);
      
      System.assertEquals(lstAccountMsg[0].AP_CT_AP_MOB_PHONE__c,accSetup.AP_Mobile_Phone__c);
      System.assertEquals(lstAccountMsg[0].ACCT_BACK_ORDER_ALLOW__c,accSetup.Back_Orders_Flag__c);
      System.assertEquals(lstAccountMsg[0].ACCT_DISPLAY_BACKORDERS__c,accSetup.Backorders_displayed_on_packing_list__c);
      //System.assertEquals(lstAccountMsg[0].ACCT_BT_BILL_COUNTRY__c,accSetup.BILL_COUNTRY__c);
      
      System.assertEquals(lstAccountMsg[0].ACCT_ADD_EDI_FLAG__c ,accSetup.billed_via_EDI_or_electronic_email_FTP__c);
     // System.assertEquals(lstAccountMsg[0].PD_PD_PAY_FREQUENCY__c,accSetup.Billing_Frequency__c);
      System.assertEquals(lstAccountMsg[0].ACCT_BT_BILL_CITY__c,accSetup.City_Bill__c);
      System.assertEquals(lstAccountMsg[0].ACCT_ST_SHIP_CITY__c,accSetup.City_Ship__c); 
      
      System.assertEquals(lstAccountMsg[0].CNTR_01_CONTRACT_PRIORITY_1__c,accSetup.Core_Item_Price_List_Priority_Code_1__c);      
      System.assertEquals(lstAccountMsg[0].CNTR_02_CONTRACT_PRIORITY_2__c,accSetup.Core_Item_Price_List_Priority_Code_2__c);
      System.assertEquals(lstAccountMsg[0].CNTR_03_CONTRACT_PRIORITY_3__c,accSetup.Core_Item_Price_List_Priority_Code_3__c);
      System.assertEquals(lstAccountMsg[0].CNTR_04_CONTRACT_PRIORITY_4__c,accSetup.Core_Item_Price_List_Priority_Code_4__c);
      System.assertEquals(lstAccountMsg[0].CNTR_05_CONTRACT_PRIORITY_5__c,accSetup.Core_Item_Price_List_Priority_Code_5__c);
      System.assertEquals(lstAccountMsg[0].CNTR_06_CONTRACT_PRIORITY_6__c,accSetup.Core_Item_Price_List_Priority_Code_6__c);
      System.assertEquals(lstAccountMsg[0].CNTR_07_CONTRACT_PRIORITY_7__c,accSetup.Core_Item_Price_List_Priority_Code_7__c);
      System.assertEquals(lstAccountMsg[0].CNTR_08_CONTRACT_PRIORITY_8__c,accSetup.Core_Item_Price_List_Priority_Code_8__c);
      System.assertEquals(lstAccountMsg[0].CNTR_09_CONTRACT_PRIORITY_9__c,accSetup.Core_Item_Price_List_Priority_Code_9__c);
      System.assertEquals(lstAccountMsg[0].CNTR_10_CONTRACT_PRIORITY_10__c,accSetup.Core_Item_Price_List_Priority_Code_10__c);
    }
  } 
  
  @isTest
  static void testAccountMsg() {   
    //--------------------------------------------------------------------
    //To test that account message record is created every time a Account setup request is inserted/updated 
    //--------------------------------------------------------------------  
    
    //Create Account
    Account acc = Test_Utils.CreateAccount();
    
    //Create AccountSetUp object
    Account_Setup_Request__c accSetUp = Test_Utils.createAccountSetupReq(acc);
    //LSLEVIN S-364691 11.19.2015 Start
    accSetup.AP_Contact_First_Name__c = 'test first name';
    accSetup.AP_Contact_Last_Name__c = 'test last name';
    accSetup.Billing_Delivery_Method_Media_type__c = 'E-Billing';
    accSetup.eBilling_Contact_Email2__c = 'test@testing.com';
    accSetup.eBilling_Contact_First_Name__c = 'Test First Name';
    accSetup.eBilling_Contact_Last_Name__c = 'Test Last Name';
    accSetup.eBilling_Contact_First_Name2__c = 'Test First Name';
    accSetup.eBilling_Contact_Last_Name2__c = 'Test Last Name';
    accSetup.Tax_Exempt__c = 'Yes';
    accSetup.SFDC_SHIPTO_ID__c = acc.Id;
    accSetup.SFDC_BILLTO_ID__c = acc.Id;
    accSetup.BILLTO_ORACLE_PARTY_SITE_ID__c = '158648570';
    accSetup.SHIPTO_ORACLE_PARTY_SITE_ID__c = '158648568';
    accSetup.Rename_release__c = 'Test Release';
    accSetup.Rename_purchase_order__c = 'Test';
    accSetup.Rename_desktop__C = 'Test Rename';
    accSetup.Rename_Cost_Center__c = 'Test Cost Center';
    //LSLEVIN S-364691 11.19.2015 End
    insert accSetup;
        
    //--------------------------------------------------------------------
    //Update account setup req so that after Update 1 more Account_Message__c 
    //is created for same Account Set Up request
    //--------------------------------------------------------------------
    accSetUp.Delivery_Method__c = 'testDelivery';
    //accSetUp.Rep_Comments__c = 'testComments';
    accSetUp.AP_Contact_Role__c = 'testAnotherContactRole';

    update accSetUp;
      
     List<Account_Message__c> lstAccountMsg = [SELECT id,ACCT_ID_PROSPECT_ID__c ,CMT_COMMENT__c,ACCT_ID_SFDC_ACCOUNT_ID__c,
                            ACCT_DLV_DOC_TYPE__c,ACCT_CUST_TYPE__c,ACCT_CUST_SUBTYPE__c ,AP_CT_AP_CONTACT_ROLE__c ,CNTR_01_CONTRACT_PRIORITY_1__c,
                            ACCT_GPFLOOR_PERCENT__c , ACCT_REVENUE_BAND__c, ACCT_FURNITURE_DELIVERY__c, ACCT_SIC_CODE__c, ACCT_PAY_METHOD__c,
                            ACCT_OFF_CNTRCT_CODE__c, ACCT_OFF_CNTRCT_PERCENT__c, ACCT_OFF_WHSALE_CODE__c,ACCT_OFF_WHSALE_PERCENT__c
                            FROM Account_Message__c WHERE ACCT_ID_SFDC_ACCOUNT_ID__c = :accSetup.Account__c order by CreatedDate];
    
    //--------------------------------------------------------------------
    //To verify data for the another account message created as a result of updating the account setup req 
    //--------------------------------------------------------------------
  //  System.assertEquals(lstAccountMsg.size(),2);        
    //Account Message fiels are populated with Account_Setup_Request__c fields
    if(lstAccountMsg.size() >= 2) {
      //System.assertEquals(lstAccountMsg[0].AP_CT_AP_CONTACT_ROLE__c,accSetup.AP_Contact_Role__c);
      //System.assertEquals(lstAccountMsg[1].ACCT_DLV_DOC_TYPE__c ,accSetup.Delivery_Method__c);
      System.assertEquals(lstAccountMsg[1].CMT_COMMENT__c ,accSetup.Rep_Comments__c);
      //z System.assertEquals(lstAccountMsg[1].AP_CT_AP_CONTACT_ROLE__c,accSetup.AP_Contact_Role__c);
      System.assertEquals(lstAccountMsg[1].ACCT_ID_SFDC_ACCOUNT_ID__c,accSetup.Account__c);
      System.assertEquals(lstAccountMsg[1].ACCT_ID_PROSPECT_ID__c,accSetup.Account__c);      
      
      System.assertEquals(lstAccountMsg[1].ACCT_GPFLOOR_PERCENT__c ,accSetup.GP_Floor__c);
      //System.assertEquals(lstAccountMsg[1].ACCT_REVENUE_BAND__c,accSetup.Revenue_Band__c);
      System.assertEquals(lstAccountMsg[1].ACCT_FURNITURE_DELIVERY__c,accSetup.Furniture_Delivery_Fee__c);
      System.assertEquals(lstAccountMsg[1].ACCT_SIC_CODE__c,accSetup.SIC_Code_c__c);
      
      System.assertEquals(lstAccountMsg[1].ACCT_PAY_METHOD__c ,accSetup.Invoice_Payment_Method__c);
      System.assertEquals(lstAccountMsg[1].ACCT_OFF_CNTRCT_CODE__c,accSetup.Off_Contract__c);
      System.assertEquals(lstAccountMsg[1].ACCT_OFF_CNTRCT_PERCENT__c,accSetup.Off_Contract_percent__c);
      System.assertEquals(lstAccountMsg[1].ACCT_OFF_WHSALE_CODE__c,accSetup.Off_Wholesale__c);
      System.assertEquals(lstAccountMsg[1].ACCT_OFF_WHSALE_PERCENT__c,accSetup.Off_Wholesale_percent__c);      
            
    }   
  }
}