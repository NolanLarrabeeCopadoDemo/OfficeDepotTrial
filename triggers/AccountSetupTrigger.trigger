/**************************************************************************
*Created By : Mike Keller
*Created Date : 09/07/2011
*Purpose :
Create a message object for an outbound message based on the completion
of the clicktools survey.

Last Modified       : 02/13/2012
Last Modified By    : Mohan Kalyanasundaram
Last Modified Reason: Segment code is stored inside the AccountRequest object
                      instead of Segment picklist value. SFDC Account
                      Requestor service will be modifed to drop the mapping
                      done inside the code to pass the segment code.

Last Modified       : 03/21/2012
Last Modified By    : Phil Price
Last Modified Reason: Dont send any AP contact or eBill contact fields unless
                      rules are met for each one.
***************************************************************************/
trigger AccountSetupTrigger on Account_Setup_Request__c (after insert, after update) {
  //LSLEVIN S-347753 9.21.2015 Added below if
  if(userInfo.getUserId() != Label.SOA_Connection || (!trigger.isInsert && userInfo.getUserId() == Label.SOA_Connection)){
    if (Util.bypassTriggers('AccountSetupTrigger')) {
      Util.DEBUG('Bypassing trigger AccountSetupTrigger');
      return;
    }
  }
    for(Account_Setup_Request__c lclAccountSetup : trigger.new){
        if ( lclAccountSetup.IsAccountSetUp__c==true && lclAccountSetup.IsAccountSetUpSubmitted__c==false )
        {
            return;
        }
    }

  List <Account_Message__c> acctMsgList = new List <Account_Message__c>();
  List<Id>tmpAccountId = new List<Id>();
  Map<Id,Account> tmpAccountNameMap;
   Set<id>Set_owerids = new Set<Id>();
   Account updAcct = new Account();
    Map<Id,Sales_person__c> Map_ownrSalesPerson= new Map<Id,Sales_person__c>();

  //Added by ivarada - 12/2/2014
    Set<String> siteIds = new Set<String>();
    Map<String,ID> siteToIDMap = new Map<String,ID>();
  //Ends

  for(Account_Setup_Request__c lclAccountSetup : trigger.new){

    if(lclAccountSetup.Survey_Complete__c){
        tmpAccountId.add(lclAccountSetup.Account__c);
    }

    //Added by ivarada - 12/2/2014
      if (lclAccountSetup.BILLTO_ORACLE_PARTY_SITE_ID__c != null)
        siteIds.add(lclAccountSetup.BILLTO_ORACLE_PARTY_SITE_ID__c);
      if (lclAccountSetup.SHIPTO_ORACLE_PARTY_SITE_ID__c != null)
        siteIds.add(lclAccountSetup.SHIPTO_ORACLE_PARTY_SITE_ID__c);
    //Ends

  }

   //Added by ivarada - 12/2/2014
   for (Account a:[select id,oracle_party_site_id__c from account where oracle_party_site_id__c = :siteIds limit 50000])
     siteToIDMap.put(a.oracle_party_site_id__c,a.id);
   //End

    if(tmpAccountId.size() > 0) {
    tmpAccountNameMap = new Map<Id,Account>([select ID,name,ownerid from account where id in :tmpAccountId]);
   system.debug('Before Capture of SPID'  );
  // Logic for SalesPerson ID Starts

      if(!tmpAccountNameMap.isEmpty())
      {
          for(Id accountid :tmpAccountNameMap.keySet())
          {
          system.debug('Inside Capture of SPID'  );
          system.debug('Inside Capture of'+ tmpAccountNameMap.get(accountid).ownerid);
                Set_owerids.add(tmpAccountNameMap.get(accountid).ownerid);

          }
       }
   }
    system.debug('After Capture of SPID'  );


  //start of 00699719
  /*
  for(Sales_Person__c sp : [select id,user__c,ExtIDSalesPerson__c,Name from Sales_Person__c where IsActive__c=true and   Primary__c=true and user__c in :Set_owerids])
  {
  system.debug('Inside  SPID'  );
        Map_ownrSalesPerson.put(sp.user__c,sp);
          system.debug('Get SPID' +Map_ownrSalesPerson.get(sp.user__c) );
  }
  // Logic for Salesperson ID ends
  */
  //end  of 00699719

  for(Account_Setup_Request__c lclAccountSetup : trigger.new){
    if(lclAccountSetup.Survey_Complete__c && (lclAccountSetup.AOPS_ID1__c == null || lclAccountSetup.AOPS_ID1__c == '')){
      String lclName = '';
      String salesPersonID ='INVALID';
      if(tmpAccountNameMap.containsKey(lclAccountSetup.Account__c))
        lclName = tmpAccountNameMap.get(lclAccountSetup.Account__c).name;

      if (lclAccountSetup.TriggerByPass__c && lclName != null) {
                 if (lclName.length() > 30)
                  lclName = lclName.subString(0,30);
          }
//start of 00699719
/*
        // Salesperson ID Logic

        if(tmpAccountNameMap.containsKey(lclAccountSetup.Account__c))
        {

          if(Map_ownrSalesPerson.containsKey(tmpAccountNameMap.get(lclAccountSetup.Account__c).ownerid))
          {
              salesPersonID=Map_ownrSalesPerson.get(tmpAccountNameMap.get(lclAccountSetup.Account__c).ownerid).ExtIDSalesPerson__c;

              updAcct = [select id from account where id = :tmpAccountNameMap.get(lclAccountSetup.Account__c).id];
              updAcct.Sales_PersonID__c = Map_ownrSalesPerson.get(tmpAccountNameMap.get(lclAccountSetup.Account__c).ownerid).id;
              if(!lclAccountSetup.TriggerByPass__c){
              update updAcct;
              }
          }

    }
*/
     //end of 00699719
      Account_Message__c lclAccountMsg = new Account_Message__c();
      lclAccountMsg.ACCT_ID_REQUEST_ID__c = lclAccountSetup.ORACLE_PARTY_ID__c;
      lclAccountMsg.ACCT_CUST_TYPE__c = lclAccountSetup.Loyalty_Type__c;
      lclAccountMsg.ACCT_CUST_SUBTYPE__c = lclAccountSetup.Segment_Code__c;
      lclAccountMsg.ACCT_CUSTOMER_NAME__c = lclName;

      //Added by ivarada - 12/2/2014
      IF (lclAccountSetup.SFDC_BILLTO_ID__c != NULL)
       lclAccountMsg.ACCT_BT_SFDC_BILLTO_ID__c = lclAccountSetup.SFDC_BILLTO_ID__c;
      ELSE IF (lclAccountSetup.BILLTO_ORACLE_PARTY_SITE_ID__c != NULL) {
        IF (siteToIdMap.containskey(lclAccountSetup.BILLTO_ORACLE_PARTY_SITE_ID__c))
           lclAccountMsg.ACCT_BT_SFDC_BILLTO_ID__c = siteToIdMap.get(lclAccountSetup.BILLTO_ORACLE_PARTY_SITE_ID__c);
      }
      //Ends

      lclAccountMsg.ACCT_BT_BILLTO_NAME__c = lclAccountSetup.BillTo_Name__c;
      //lclAccountMsg.ACCT_BT_BILLTO_NAME__c = lclName;
      lclAccountMsg.ACCT_ST_SHIPTO_NAME__c = lclAccountSetup.ShipTo_Name__c;
      //lclAccountMsg.ACCT_ST_SHIPTO_NAME__c = lclName;
      lclAccountMsg.ACCT_ID_SFDC_ACCOUNT_ID__c = lclAccountSetup.ACCOUNT__c;
      lclAccountMsg.ACCT_ID_PROSPECT_ID__c = lclAccountSetup.ACCOUNT__c;

      lclAccountMsg.ACCT_ID_REQUEST_ID__c = lclAccountSetup.Account_Setup_Request_Number__c;

      lclAccountMsg.ACCT_ID_PARENT_ID__c = lclAccountSetup.Add_Parent_ID__c;
      lclAccountMsg.ACCT_CPD_FLAG__c = lclAccountSetup.Allow_Print_on_Demand__c;

      lclAccountMsg.ACCT_BACK_ORDER_ALLOW__c = lclAccountSetup.Back_Orders_Flag__c;
      lclAccountMsg.ACCT_DISPLAY_BACKORDERS__c = lclAccountSetup.Backorders_displayed_on_packing_list__c;
      lclAccountMsg.ACCT_BT_BILL_COUNTRY__c = lclAccountSetup.BILL_COUNTRY__c;
      lclAccountMsg.ACCT_ADD_EDI_FLAG__c = lclAccountSetup.billed_via_EDI_or_electronic_email_FTP__c;
      lclAccountMsg.PD_PD_PAY_FREQUENCY__c = lclAccountSetup.Billing_Frequency__c;
      lclAccountMsg.ACCT_BT_BILL_CITY__c = lclAccountSetup.City_Bill__c;
      lclAccountMsg.ACCT_ST_SHIP_CITY__c = lclAccountSetup.City_Ship__c;

      lclAccountMsg.CNTR_01_CONTRACT_ID_1__c = lclAccountSetup.Core_Item_Price_List_ID_1__c;
      lclAccountMsg.CNTR_02_CONTRACT_ID_2__c = lclAccountSetup.Core_Item_Price_List_ID_2__c;
      lclAccountMsg.CNTR_03_CONTRACT_ID_3__c = lclAccountSetup.Core_Item_Price_List_ID_3__c;
      lclAccountMsg.CNTR_04_CONTRACT_ID_4__c = lclAccountSetup.Core_Item_Price_List_ID_4__c;
      lclAccountMsg.CNTR_05_CONTRACT_ID_5__c = lclAccountSetup.Core_Item_Price_List_ID_5__c;
      lclAccountMsg.CNTR_06_CONTRACT_ID_6__c = lclAccountSetup.Core_Item_Price_List_ID_6__c;
      lclAccountMsg.CNTR_07_CONTRACT_ID_7__c = lclAccountSetup.Core_Item_Price_List_ID_7__c;
      lclAccountMsg.CNTR_08_CONTRACT_ID_8__c = lclAccountSetup.Core_Item_Price_List_ID_8__c;
      lclAccountMsg.CNTR_09_CONTRACT_ID_9__c = lclAccountSetup.Core_Item_Price_List_ID_9__c;
      lclAccountMsg.CNTR_10_CONTRACT_ID_10__c = lclAccountSetup.Core_Item_Price_List_ID_10__c;

      lclAccountMsg.CNTR_01_CONTRACT_PRIORITY_1__c = lclAccountSetup.Core_Item_Price_List_Priority_Code_1__c;
      lclAccountMsg.CNTR_02_CONTRACT_PRIORITY_2__c = lclAccountSetup.Core_Item_Price_List_Priority_Code_2__c;
      lclAccountMsg.CNTR_03_CONTRACT_PRIORITY_3__c = lclAccountSetup.Core_Item_Price_List_Priority_Code_3__c;
      lclAccountMsg.CNTR_04_CONTRACT_PRIORITY_4__c = lclAccountSetup.Core_Item_Price_List_Priority_Code_4__c;
      lclAccountMsg.CNTR_05_CONTRACT_PRIORITY_5__c = lclAccountSetup.Core_Item_Price_List_Priority_Code_5__c;
      lclAccountMsg.CNTR_06_CONTRACT_PRIORITY_6__c = lclAccountSetup.Core_Item_Price_List_Priority_Code_6__c;
      lclAccountMsg.CNTR_07_CONTRACT_PRIORITY_7__c = lclAccountSetup.Core_Item_Price_List_Priority_Code_7__c;
      lclAccountMsg.CNTR_08_CONTRACT_PRIORITY_8__c = lclAccountSetup.Core_Item_Price_List_Priority_Code_8__c;
      lclAccountMsg.CNTR_09_CONTRACT_PRIORITY_9__c = lclAccountSetup.Core_Item_Price_List_Priority_Code_9__c;
      lclAccountMsg.CNTR_10_CONTRACT_PRIORITY_10__c = lclAccountSetup.Core_Item_Price_List_Priority_Code_10__c;

      lclAccountMsg.ACCT_DEPT_FLAG__c = lclAccountSetup.Cost_Center__c;
      lclAccountMsg.ACCT_ITEM_XREF__c = lclAccountSetup.Cross_Reference_number__c;
      lclAccountMsg.ACCT_DELIVERY_CHARGE_CODE__c = lclAccountSetup.Deliver_Charge_Code__c;
      lclAccountMsg.ACCT_DLV_DOC_TYPE__c = lclAccountSetup.Delivery_Method__c;
      lclAccountMsg.ACCT_DESK_FLAG__c = lclAccountSetup.Desktop__c;
      lclAccountMsg.TAX_EXCEPTION_FLAG__c = lclAccountSetup.TAX_EXCEPTION_FLAG__c;

      lclAccountMsg.ACCT_DISPLAY_PAYMETHOD__c = ((lclAccountSetup.Display_Payment_Method__c==null) || (lclAccountSetup.Display_Payment_Method__c=='')) ? 'No' : lclAccountSetup.Display_Payment_Method__c;
      lclAccountMsg.ACCT_DISPLAY_PRICES__c = lclAccountSetup.Display_Prices__c;
      lclAccountMsg.ACCT_DISPLAY_PURCHASE_ORDER__c = lclAccountSetup.Display_Purchase_Orders__c;
      lclAccountMsg.ACCT_ID_DUNS_ID__c = lclAccountSetup.Duns_Number__c;
      lclAccountMsg.ACCT_CUSTOMER_DUNS_NUM__c = lclAccountSetup.Ultimate_Duns_Number__c;

      lclAccountMsg.ACCT_ID_EMPLOYER_TIN_ID__c = lclAccountSetup.Employer_TIN__c;

      lclAccountMsg.ACCT_GPFLOOR_PERCENT__c = lclAccountSetup.GP_Floor__c;
      lclAccountMsg.ACCT_REVENUE_BAND__c = lclAccountSetup.Revenue_Band__c;
      lclAccountMsg.ACCT_FURNITURE_DELIVERY__c = lclAccountSetup.Furniture_Delivery_Fee__c;
      lclAccountMsg.ACCT_SIC_CODE__c = lclAccountSetup.SIC_Code_c__c;
      lclAccountMsg.ACCT_PAY_METHOD__c = lclAccountSetup.Invoice_Payment_Method__c;

      lclAccountMsg.ACCT_ORDER_MAX_AMOUNT__c = zConvert.toString(lclAccountSetup.Max_Order_Amount__c);
      lclAccountMsg.ACCT_MIN_ORDER_AMOUNT__c = zConvert.toString(lclAccountSetup.Minimum_Order_Value__c);
      lclAccountMsg.ACCT_OFF_CNTRCT_CODE__c = lclAccountSetup.Off_Contract__c;
      lclAccountMsg.ACCT_OFF_CNTRCT_PERCENT__c = lclAccountSetup.Off_Contract_percent__c;
      lclAccountMsg.ACCT_OFF_WHSALE_CODE__c = lclAccountSetup.Off_Wholesale__c;

      lclAccountMsg.ACCT_OFF_WHSALE_PERCENT__c = lclAccountSetup.Off_Wholesale_percent__c;
      lclAccountMsg.ACCT_ADD_INTERNET_FLAG__c = lclAccountSetup.Online_Ordering__c;
      lclAccountMsg.ACCT_ID_ORACLE_PARTY_ID__c = lclAccountSetup.ORACLE_PARTY_ID__c;
      lclAccountMsg.AP_CT_AP_ORACLE_PARTY_SITE_ID__c = lclAccountSetup.ORACLE_PARTY_ID__c;
      lclAccountMsg.EBILL_CT_EBILL_ORACLE_PARTY_SITE_ID__c = lclAccountSetup.ORACLE_PARTY_ID__c;

      lclAccountMsg.ACCT_PO_FLAG__c = lclAccountSetup.PO__c;
      lclAccountMsg.ACCT_PRICE_PLAN__c = lclAccountSetup.Price_Plan__c;
      lclAccountMsg.SALES_CT_SALES_EMAIL__c = lclAccountSetup.Primary_Contact_Email__c;
      lclAccountMsg.SALES_CT_SALES_PRIMARY_FAX__c = lclAccountSetup.Primary_Contact_Fax__c;
      lclAccountMsg.SALES_CT_SALES_CONTACT_FIRSTNAME__c = lclAccountSetup.Primary_Contact_First_Name__c;

      lclAccountMsg.SALES_CT_SALES_TITLE__c = lclAccountSetup.Primary_Contact_Job_Title__c;
      lclAccountMsg.SALES_CT_SALES_CONTACT_LASTNAME__c = lclAccountSetup.Primary_Contact_Last_Name__c;
      lclAccountMsg.SALES_CT_SALES_MOB_PHONE__c = lclAccountSetup.Primary_Contact_Mobile_Phone__c;
      lclAccountMsg.SALES_CT_SALES_PRIMARY_PHONE__c = lclAccountSetup.Primary_Contact_Phone__c;
      ///if(lclAccountSetup.Parent_Creation__C==false)
      lclAccountMsg.SALES_CT_SALES_CONTACT_ROLE__c = lclAccountSetup.Primary_contact_role__c;

      //added by Nisha on 01/21/2016 for S-374372 [Case#00570010]
      //lclAccountMsg.PHONEEXT__c = lclAccountSetup.Account_Phone_Extension__c;
      // end S-374372

      lclAccountMsg.SALES_CT_SALES_SALUTAION__c = lclAccountSetup.Primary_Contact_Salutation__c;
      lclAccountMsg.ACCT_PRINT_INV__c = lclAccountSetup.Print_invoice__c;
      lclAccountMsg.ACCT_PROSPECT_SOURCE__c = lclAccountSetup.PROSPECT_SOURCE__c;
      lclAccountMsg.ACCT_RELEASE_FLAG__c = lclAccountSetup.Release__c;
      if(lclAccountSetup.Rename_Cost_Center__c != null)
      lclAccountMsg.ACCT_RENAMED_DEPT__c = lclAccountSetup.Rename_Cost_Center__c.toUpperCase();
      if( lclAccountSetup.Rename_desktop__C != null)
      lclAccountMsg.ACCT_RENAMED_DSKTP__c = lclAccountSetup.Rename_desktop__C.toUpperCase();
      if( lclAccountSetup.Rename_purchase_order__c != null)
      lclAccountMsg.ACCT_RENAMED_PO__c = lclAccountSetup.Rename_purchase_order__c.toUpperCase();
      if( lclAccountSetup.Rename_release__c != null)
      lclAccountMsg.ACCT_RENAMED_RELEASE__c = lclAccountSetup.Rename_release__c.toUpperCase();
      //start of 00699719
     lclAccountMsg.ACCT_ID_REP_ID__c = lclAccountSetup.Rep_ID__c; 
       
           //lclAccountMsg.ACCT_ID_REP_ID__c =    salesPersonID;   
           //end of 00699719
    //Added by ivarada - 12/2/2014
      IF (lclAccountSetup.SFDC_SHIPTO_ID__c != NULL)
       lclAccountMsg.ACCT_ST_SFDC_SHIPTO_ID__c = lclAccountSetup.SFDC_SHIPTO_ID__c;
      ELSE IF (lclAccountSetup.SHIPTO_ORACLE_PARTY_SITE_ID__c != NULL) {
        IF (siteToIdMap.containskey(lclAccountSetup.SHIPTO_ORACLE_PARTY_SITE_ID__c))
         lclAccountMsg.ACCT_ST_SFDC_SHIPTO_ID__c = siteToIdMap.get(lclAccountSetup.SHIPTO_ORACLE_PARTY_SITE_ID__c);
      }
     //Ends

      lclAccountMsg.ACCT_ST_SHIP_COUNTRY__c = lclAccountSetup.SHIP_COUNTRY__c;
      lclAccountMsg.ACCT_ST_SHIPTO_ORACLE_PARTY_SITE_ID__c = lclAccountSetup.SHIPTO_ORACLE_PARTY_SITE_ID__c;
      lclAccountMsg.ACCT_BT_BILLTO_ORACLE_PARTY_SITE_ID__c = lclAccountSetup.BILLTO_ORACLE_PARTY_SITE_ID__c;
      lclAccountMsg.ACCT_SMALL_ORDER_DLV_FLAG__c = lclAccountSetup.Small_Order_Fee_Flag__c;
      lclAccountMsg.ACCT_BT_BILL_STATE__c = lclAccountSetup.State_Bill__c;
      lclAccountMsg.ACCT_ST_SHIP_STATE__c = lclAccountSetup.State_Ship__c;

      lclAccountMsg.ACCT_ADD_SPC_FLAG__c = lclAccountSetup.Store_Purchasing_Cards__c;
      lclAccountMsg.ACCT_BT_BILL_ADD2__c = lclAccountSetup.Street_Address_2_Bill__c;
      lclAccountMsg.ACCT_ST_SHIP_ADD2__c = lclAccountSetup.Street_Address_2_Ship__c;
      lclAccountMsg.ACCT_BT_BILL_ADD1__c = lclAccountSetup.Street_Address_Bill__c;
      lclAccountMsg.ACCT_ST_SHIP_ADD1__c = lclAccountSetup.Street_Address_Ship__c;

      lclAccountMsg.ACCT_SUBSTITUTE_ALLOW__c = lclAccountSetup.Substitutions_Flag__c;
      lclAccountMsg.ACCT_ADD_TAX_EXEMPT_FLAG__c = lclAccountSetup.Tax_Exempt__c;
      //lclAccountMsg.TAX_EXMPT__c = lclAccountSetup.TAX_EXMPT__c; //S-333095 [Hemant 7/1/2015] - Added TAX_EXMPT field
      lclAccountMsg.ACCT_TECHDEPOT_ALLOWED_FLAG__c = lclAccountSetup.Tech_Depot_Blocked__c;
      lclAccountMsg.ACCT_BT_BILL_ZIP__c = lclAccountSetup.Zip_Bill__c;
      lclAccountMsg.ACCT_ST_SHIP_ZIP__c = lclAccountSetup.Zip_Ship__c;

      lclAccountMsg.ACCT_REPORT_LOC__c = lclAccountSetup.Report_Loc__c;
      lclAccountMsg.ACCT_RENAME_PACKLIST__c = lclAccountSetup.Rename_Packlist__c;
      lclAccountMsg.ACCT_ADD_SHIPTO_FLAG__c = lclAccountSetup.Add_ShipTo_Flag__c;
      lclAccountMsg.PD_PD_DOC_NAME__c = lclAccountSetup.PD_Doc_Name__c;
      lclAccountMsg.PD_PD_DETAIL__c = lclAccountSetup.PD_Detail__c;

      lclAccountMsg.PD_PD_INDIRECT__c = lclAccountSetup.PD_multiple_bill_to_locations__c;
      lclAccountMsg.PD_PD_INCL_BACKUP_INC__c = lclAccountSetup.PD_Incl_Backup_Inc__c;
      lclAccountMsg.PD_PD_SORTS__c = lclAccountSetup.PD_Sorts__c;
      lclAccountMsg.PD_PD_TOTALS__c = lclAccountSetup.PD_Totals__c;
      lclAccountMsg.PD_PD_PAGE_BREAKS__c = lclAccountSetup.PD_Page_Breaks__c;

      lclAccountMsg.CMT_COMMENT__c = lclAccountSetup.Rep_Comments__c;
      lclAccountMsg.PD_PD_DOC_TYPE__c = lclAccountSetup.PD_indicator__c;
      lclAccountMsg.PD_PD_BILLING_DELIVERY_METHOD__c = lclAccountSetup.Billing_Delivery_Method_Media_type__c;

      lclAccountMsg.ACCT_A_FAX_SHIP_CONFIRM__c = lclAccountSetup.Fax_Order_Flag__c;
      lclAccountMsg.ACCT_AUTO_FAX_FLAG__c = lclAccountSetup.Auto_Fax_Flag__c;

      // AP Contact must have a first or last name
      if (   (lclAccountSetup.AP_Contact_First_Name__c != null && lclAccountSetup.AP_Contact_First_Name__c.length() > 0)
          || (lclAccountSetup.AP_Contact_Last_Name__c  != null && lclAccountSetup.AP_Contact_Last_Name__c.length() > 0)) {

        lclAccountMsg.AP_CT_AP_CONTACT_ROLE__c      = lclAccountSetup.AP_Contact_Role__c;
        lclAccountMsg.AP_CT_AP_TITLE__c             = lclAccountSetup.AP_Contact_Job_Title__c;
        lclAccountMsg.AP_CT_AP_SALUTAION__c         = lclAccountSetup.AP_Contact_Salutation__c;
        lclAccountMsg.AP_CT_AP_CONTACT_FIRSTNAME__c = lclAccountSetup.AP_Contact_First_Name__c;
        lclAccountMsg.AP_CT_AP_CONTACT_LASTNAME__c  = lclAccountSetup.AP_Contact_Last_Name__c;
        lclAccountMsg.AP_CT_AP_EMAIL__c             = lclAccountSetup.AP_Contact_Email__c;
        lclAccountMsg.AP_CT_AP_PRIMARY_PHONE__c     = lclAccountSetup.AP_Contact_Phone__c;
        lclAccountMsg.AP_CT_AP_MOB_PHONE__c         = lclAccountSetup.AP_Mobile_Phone__c;
        lclAccountMsg.AP_CT_AP_PRIMARY_FAX__c       = lclAccountSetup.AP_Contact_Fax__c;
      }

      // eBill contact must have a first or last name, and the delivery media cant't be empty or set to "Paper".
      if(   ( lclAccountSetup.Billing_Delivery_Method_Media_type__c != null &&
             !lclAccountSetup.Billing_Delivery_Method_Media_type__c.equalsIgnoreCase('Paper'))
         && (   (lclAccountSetup.eBilling_Contact_First_Name__c != null && lclAccountSetup.eBilling_Contact_First_Name__c.length() > 0)
             || (lclAccountSetup.eBilling_Contact_Last_Name__c  != null && lclAccountSetup.eBilling_Contact_Last_Name__c.length() > 0))) {

        lclAccountMsg.EBILL_CT_EBILL_CONTACT_ROLE__c      = lclAccountSetup.eBilling_Contact_Role__c;
        lclAccountMsg.EBILL_CT_EBILL_TITLE__c             = lclAccountSetup.eBilling_Contact_Job_Title__c;
        lclAccountMsg.EBILL_CT_EBILL_SALUTAION__c         = lclAccountSetup.eBilling_Contact_Salutation__c;
        lclAccountMsg.EBILL_CT_EBILL_CONTACT_FIRSTNAME__c = lclAccountSetup.eBilling_Contact_First_Name__c;
        lclAccountMsg.EBILL_CT_EBILL_CONTACT_LASTNAME__c  = lclAccountSetup.eBilling_Contact_Last_Name__c;
        lclAccountMsg.EBILL_CT_EBILL_EMAIL__c             = lclAccountSetup.eBilling_Contact_Email__c;
        lclAccountMsg.EBILL_CT_EBILL_PRIMARY_PHONE__c     = lclAccountSetup.eBilling_Contact_Phone__c;
        lclAccountMsg.EBILL_CT_EBILL_MOB_PHONE__c         = lclAccountSetup.eBill_Mobile_Phone__c;
        lclAccountMsg.EBILL_CT_SFDC_EBILL_ISPRIMARY__c    = true ; //Added by Mohit for Story S-321049 //

        if(lclAccountSetup.eBilling_Contact_Email2__c!=null && lclAccountSetup.eBilling_Contact_First_Name2__c!=null && lclAccountSetup.eBilling_Contact_Last_Name2__c!=null){
            /* Comment by Mohit for  Story S-321049
            lclAccountMsg.EBILL_CT_EBILL_EMAIL2__c = lclAccountSetup.eBilling_Contact_Email2__c;
            lclAccountMsg.EBILL_CT_EBILL_CONTACT_FIRSTNAME2__c = lclAccountSetup.eBilling_Contact_First_Name2__c;
            lclAccountMsg.EBILL_CT_EBILL_CONTACT_LASTNAME2__c = lclAccountSetup.eBilling_Contact_Last_Name2__c; */
            // Start : Added by Mohit for Story S-321049 //
            lclAccountMsg.EBILL_CT_EBILL_1_EMAIL__c = lclAccountSetup.eBilling_Contact_Email2__c;
            lclAccountMsg.EBILL_CT_EBILL_1_CONTACT_FIRSTNAME__c = lclAccountSetup.eBilling_Contact_First_Name2__c;
            lclAccountMsg.EBILL_CT_EBILL_1_CONTACT_LASTNAME__c = lclAccountSetup.eBilling_Contact_Last_Name2__c;
            lclAccountMsg.EBILL_CT_EBILL_1_CONTACT_ROLE__c      = lclAccountSetup.eBilling_Contact_Role2__c;
            lclAccountMsg.EBILL_CT_EBILL_1_TITLE__c             = lclAccountSetup.eBilling_Contact_Job_Title2__c;
            lclAccountMsg.EBILL_CT_EBILL_1_SALUTAION__c         = lclAccountSetup.eBilling_Contact_Salutation2__c;
            lclAccountMsg.EBILL_CT_EBILL_1_PRIMARY_PHONE__c     = lclAccountSetup.eBilling_Contact_Phone2__c;
            lclAccountMsg.EBILL_CT_EBILL_1_MOB_PHONE__c         = lclAccountSetup.eBill_Mobile_Phone2__c;
            lclAccountMsg.EBILL_CT_EBILL_1_PRIMARY_FAX__c       = lclAccountSetup.eBilling_Contact_Fax2__c;
            // End : Added by Mohit for Story S-321049 //
        }
      }


      //lclAccountMsg.OPERATION__c = 'I';
      //This field is used for automatic account setup flag and passed from clicktools form



      lclAccountMsg.OPERATION__c = lclAccountSetup.OPERATION__c;
      //If the Tax exempt is Yes do not allow the Express Setup though the Pricing Template permits it Case #00255088
       if(lclAccountSetup.Tax_Exempt__c == 'Yes'){
                lclAccountMsg.OPERATION__c ='I';
        }

      //New fields created on 10/13/2014.

      lclAccountMsg.OMAX_ACCT_ID__c = lclAccountSetup.OMAX_ACCT_ID__c;
      lclAccountMsg.OMAX_BILL_TO_ADDR_ID__c = lclAccountSetup.OMAX_BILL_TO_ADDR_ID__c;
      lclAccountMsg.OMAX_SHIP_TO_ADDR_ID__c = lclAccountSetup.OMAX_SHIP_TO_ADDR_ID__c;

      lclAccountMsg.INV_NUM_OF_COPIES__c = lclAccountSetup.INV_NUM_OF_COPIES__c;
      lclAccountMsg.AUTO_BACK_FAX_EMAIL_FLAG__c = lclAccountSetup.AUTO_BACK_FAX_EMAIL__c;
      lclAccountMsg.AUTO_BACK_FAXNUM_EMAIL_ADDR__C = lclAccountSetup.AUTO_BACK_FAX_OR_EMAIL_ADDR__c;
      lclAccountMsg.TIER_1_ACCOUNT_CODE__c = lclAccountSetup.TIER_1_ACCOUNT_CODE__c;
      lclAccountMsg.PROMOTIONAL_CATALOG_FLAG__c = lclAccountSetup.PROMO_FLAG_CATALOG__c;
      lclAccountMsg.PROMOTIONAL_EMAIL_FLAG__c = lclAccountSetup.PROMO_FLAG_EMAIL__c;
      lclAccountMsg.PROMOTIONAL_FLYER_FLAG__c = lclAccountSetup.PROMO_FLAG_FLYER__c;
      lclAccountMsg.PROMOTIONAL_PHONE_FLAG__c = lclAccountSetup.PROMO_FLAG_PHONE__c;
      lclAccountMsg.PROMOTIONAL_STUFFER_FLAG__c = lclAccountSetup.PROMO_FLAG_STUFFER__c;
      lclAccountMsg.PARENT_CODE__c = lclAccountSetup.PARENT_CODE__c;
      //Modified by Nisha on 01/21/2016 for S-374372 [Case#00570010]
      lclAccountMsg.Sales_Contact_Phone_Extension__c = lclAccountSetup.Sales_Contact_Phone_Extension__c;
      //lclAccountMsg.Sales_Contact_Phone_Extension__c = Integer.valueOf(lclAccountSetup.Account_Phone_Extension__c);
      // end S-374372 [Case#00570010]
      lclAccountMsg.CONTENT_SET_VALUE__c = lclAccountSetup.Content_Set_2_PR_3_LP__c;
      lclAccountMsg.Furniture_delivery_Code__c = lclAccountSetup.Furniture_delivery_Code__c;
      lclAccountMsg.Sales_Rep_ID_for_First_Ship_to__c = lclAccountSetup.Sales_Rep_ID_for_First_Ship_to__c;
      lclAccountMsg.EXCLUDE_DROP_SHIP__c = lclAccountSetup.Y_N_exclude_Vendor_Drop_Ship__c;
      lclAccountMsg.EXCLUDE_ALT_SRC__c = lclAccountSetup.Y_N_exclude_Alternate_Sourcing__c;
      lclAccountMsg.PREFERRED_DLV_LOC__c = lclAccountSetup.PREFERRED_DLV_LOC__c;

lclAccountMsg.SFD201F_ACCOUNT_PROFILE__C= lclAccountSetup.SFD201F_ACCOUNT_PROFILE__C;

      acctMsgList.add(lclAccountMsg);
    }

    upsert(acctMsgList);
  }
}