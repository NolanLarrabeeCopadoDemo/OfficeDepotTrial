<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Make_Awaiting_Sales_ID_null</fullName>
        <field>ACCT_ID_REP_ID__c</field>
        <name>Make Awaiting Sales ID null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Resend_Account_Setup_Data</fullName>
        <field>Republish__c</field>
        <name>Resend Account Setup Data</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Account_Message</fullName>
        <apiVersion>32.0</apiVersion>
        <description>Micro Service Endpoint: 
https://api.officedepot.io/services/salesforce-customer-create-requestor-service/eaiapi/salesforce/createcustomer</description>
        <endpointUrl>https://alliance.officedepot.com/soa-infra/services/cdh_rt/SFDCCustomerRequestorABCS/sfdccustomerrequestorabcs_client_ep</endpointUrl>
        <fields>ACCT_ADDRESS_DUNS_NUM__c</fields>
        <fields>ACCT_ADD_EDI_FLAG__c</fields>
        <fields>ACCT_ADD_INTERNET_FLAG__c</fields>
        <fields>ACCT_ADD_SHIPTO_FLAG__c</fields>
        <fields>ACCT_ADD_SPC_FLAG__c</fields>
        <fields>ACCT_ADD_TAX_EXEMPT_FLAG__c</fields>
        <fields>ACCT_AUTO_FAX_FLAG__c</fields>
        <fields>ACCT_A_FAX_SHIP_CONFIRM__c</fields>
        <fields>ACCT_BACK_ORDER_ALLOW__c</fields>
        <fields>ACCT_BT_BILLTO_NAME__c</fields>
        <fields>ACCT_BT_BILLTO_ORACLE_PARTY_SITE_ID__c</fields>
        <fields>ACCT_BT_BILL_ADD1__c</fields>
        <fields>ACCT_BT_BILL_ADD2__c</fields>
        <fields>ACCT_BT_BILL_CITY__c</fields>
        <fields>ACCT_BT_BILL_COUNTRY__c</fields>
        <fields>ACCT_BT_BILL_STATE__c</fields>
        <fields>ACCT_BT_BILL_ZIP__c</fields>
        <fields>ACCT_BT_SFDC_BILLTO_ID__c</fields>
        <fields>ACCT_CPD_FLAG__c</fields>
        <fields>ACCT_CUSTOMER_DUNS_NUM__c</fields>
        <fields>ACCT_CUSTOMER_NAME__c</fields>
        <fields>ACCT_CUST_SUBTYPE__c</fields>
        <fields>ACCT_CUST_TYPE__c</fields>
        <fields>ACCT_DELIVERY_CHARGE_CODE__c</fields>
        <fields>ACCT_DEPT_FLAG__c</fields>
        <fields>ACCT_DESK_FLAG__c</fields>
        <fields>ACCT_DISPLAY_BACKORDERS__c</fields>
        <fields>ACCT_DISPLAY_PAYMETHOD__c</fields>
        <fields>ACCT_DISPLAY_PRICES__c</fields>
        <fields>ACCT_DISPLAY_PURCHASE_ORDER__c</fields>
        <fields>ACCT_DLV_DOC_TYPE__c</fields>
        <fields>ACCT_FURNITURE_DELIVERY__c</fields>
        <fields>ACCT_GPFLOOR_PERCENT__c</fields>
        <fields>ACCT_HEDBERG_FLAG__c</fields>
        <fields>ACCT_ID_DUNS_ID__c</fields>
        <fields>ACCT_ID_EMPLOYER_TIN_ID__c</fields>
        <fields>ACCT_ID_GRANDPARENT_ID__c</fields>
        <fields>ACCT_ID_ORACLE_PARTY_ID__c</fields>
        <fields>ACCT_ID_PARENT_ID__c</fields>
        <fields>ACCT_ID_PROSPECT_ID__c</fields>
        <fields>ACCT_ID_REP_ID__c</fields>
        <fields>ACCT_ID_REQUEST_ID__c</fields>
        <fields>ACCT_ID_SFDC_ACCOUNT_ID__c</fields>
        <fields>ACCT_ITEM_XREF__c</fields>
        <fields>ACCT_MIN_ORDER_AMOUNT__c</fields>
        <fields>ACCT_OFF_CNTRCT_CODE__c</fields>
        <fields>ACCT_OFF_CNTRCT_PERCENT__c</fields>
        <fields>ACCT_OFF_WHSALE_CODE__c</fields>
        <fields>ACCT_OFF_WHSALE_PERCENT__c</fields>
        <fields>ACCT_ORDER_MAX_AMOUNT__c</fields>
        <fields>ACCT_PAY_METHOD__c</fields>
        <fields>ACCT_PO_FLAG__c</fields>
        <fields>ACCT_PRICE_PLAN__c</fields>
        <fields>ACCT_PRINT_INV__c</fields>
        <fields>ACCT_PROSPECT_SOURCE__c</fields>
        <fields>ACCT_RELEASE_FLAG__c</fields>
        <fields>ACCT_RENAMED_DEPT__c</fields>
        <fields>ACCT_RENAMED_DSKTP__c</fields>
        <fields>ACCT_RENAMED_PO__c</fields>
        <fields>ACCT_RENAMED_RELEASE__c</fields>
        <fields>ACCT_RENAME_PACKLIST__c</fields>
        <fields>ACCT_REPORT_LOC__c</fields>
        <fields>ACCT_REQUESTOR_NAME__c</fields>
        <fields>ACCT_REQUEST_TIMESTAMP__c</fields>
        <fields>ACCT_REVENUE_BAND__c</fields>
        <fields>ACCT_SIC_CODE__c</fields>
        <fields>ACCT_SMALL_ORDER_DLV_FLAG__c</fields>
        <fields>ACCT_ST_SFDC_SHIPTO_ID__c</fields>
        <fields>ACCT_ST_SHIPTO_NAME__c</fields>
        <fields>ACCT_ST_SHIPTO_ORACLE_PARTY_SITE_ID__c</fields>
        <fields>ACCT_ST_SHIP_ADD1__c</fields>
        <fields>ACCT_ST_SHIP_ADD2__c</fields>
        <fields>ACCT_ST_SHIP_CITY__c</fields>
        <fields>ACCT_ST_SHIP_COUNTRY__c</fields>
        <fields>ACCT_ST_SHIP_STATE__c</fields>
        <fields>ACCT_ST_SHIP_ZIP__c</fields>
        <fields>ACCT_SUBSTITUTE_ALLOW__c</fields>
        <fields>ACCT_TECHDEPOT_ALLOWED_FLAG__c</fields>
        <fields>ADDRESS_KEY__c</fields>
        <fields>AP_CT_AP_CONTACT_FIRSTNAME__c</fields>
        <fields>AP_CT_AP_CONTACT_LASTNAME__c</fields>
        <fields>AP_CT_AP_CONTACT_ROLE__c</fields>
        <fields>AP_CT_AP_EMAIL__c</fields>
        <fields>AP_CT_AP_MOB_PHONE__c</fields>
        <fields>AP_CT_AP_ORACLE_PARTY_SITE_ID__c</fields>
        <fields>AP_CT_AP_PRIMARY_FAX__c</fields>
        <fields>AP_CT_AP_PRIMARY_PHONE__c</fields>
        <fields>AP_CT_AP_SALUTAION__c</fields>
        <fields>AP_CT_AP_TITLE__c</fields>
        <fields>AP_CT_SFDC_AP_CONTACT_ID__c</fields>
        <fields>AP_CT_SFDC_AP_DEFAULT_SITE_ID__c</fields>
        <fields>AUTO_BACK_FAXNUM_EMAIL_ADDR__c</fields>
        <fields>AUTO_BACK_FAX_EMAIL_FLAG__c</fields>
        <fields>CMT_COMMENT__c</fields>
        <fields>CNTR_01_CONTRACT_DESCRIPTION_1__c</fields>
        <fields>CNTR_01_CONTRACT_ID_1__c</fields>
        <fields>CNTR_01_CONTRACT_PRIORITY_1__c</fields>
        <fields>CNTR_02_CONTRACT_DESCRIPTION_2__c</fields>
        <fields>CNTR_02_CONTRACT_ID_2__c</fields>
        <fields>CNTR_02_CONTRACT_PRIORITY_2__c</fields>
        <fields>CNTR_03_CONTRACT_DESCRIPTION_3__c</fields>
        <fields>CNTR_03_CONTRACT_ID_3__c</fields>
        <fields>CNTR_03_CONTRACT_PRIORITY_3__c</fields>
        <fields>CNTR_04_CONTRACT_DESCRIPTION_4__c</fields>
        <fields>CNTR_04_CONTRACT_ID_4__c</fields>
        <fields>CNTR_04_CONTRACT_PRIORITY_4__c</fields>
        <fields>CNTR_05_CONTRACT_DESCRIPTION_5__c</fields>
        <fields>CNTR_05_CONTRACT_ID_5__c</fields>
        <fields>CNTR_05_CONTRACT_PRIORITY_5__c</fields>
        <fields>CNTR_06_CONTRACT_DESCRIPTION_6__c</fields>
        <fields>CNTR_06_CONTRACT_ID_6__c</fields>
        <fields>CNTR_06_CONTRACT_PRIORITY_6__c</fields>
        <fields>CNTR_07_CONTRACT_DESCRIPTION_7__c</fields>
        <fields>CNTR_07_CONTRACT_ID_7__c</fields>
        <fields>CNTR_07_CONTRACT_PRIORITY_7__c</fields>
        <fields>CNTR_08_CONTRACT_DESCRIPTION_8__c</fields>
        <fields>CNTR_08_CONTRACT_ID_8__c</fields>
        <fields>CNTR_08_CONTRACT_PRIORITY_8__c</fields>
        <fields>CNTR_09_CONTRACT_DESCRIPTION_9__c</fields>
        <fields>CNTR_09_CONTRACT_ID_9__c</fields>
        <fields>CNTR_09_CONTRACT_PRIORITY_9__c</fields>
        <fields>CNTR_10_CONTRACT_DESCRIPTION_10__c</fields>
        <fields>CNTR_10_CONTRACT_ID_10__c</fields>
        <fields>CNTR_10_CONTRACT_PRIORITY_10__c</fields>
        <fields>CONTENT_SET_VALUE__c</fields>
        <fields>EBILL_CT_EBILL_1_CONTACT_FIRSTNAME__c</fields>
        <fields>EBILL_CT_EBILL_1_CONTACT_LASTNAME__c</fields>
        <fields>EBILL_CT_EBILL_1_CONTACT_ROLE__c</fields>
        <fields>EBILL_CT_EBILL_1_EMAIL__c</fields>
        <fields>EBILL_CT_EBILL_1_MOB_PHONE__c</fields>
        <fields>EBILL_CT_EBILL_1_ORACLE_PARTY_SITE_ID__c</fields>
        <fields>EBILL_CT_EBILL_1_PRIMARY_FAX__c</fields>
        <fields>EBILL_CT_EBILL_1_PRIMARY_PHONE__c</fields>
        <fields>EBILL_CT_EBILL_1_SALUTAION__c</fields>
        <fields>EBILL_CT_EBILL_1_TITLE__c</fields>
        <fields>EBILL_CT_EBILL_CONTACT_FIRSTNAME2__c</fields>
        <fields>EBILL_CT_EBILL_CONTACT_FIRSTNAME__c</fields>
        <fields>EBILL_CT_EBILL_CONTACT_LASTNAME2__c</fields>
        <fields>EBILL_CT_EBILL_CONTACT_LASTNAME__c</fields>
        <fields>EBILL_CT_EBILL_CONTACT_ROLE__c</fields>
        <fields>EBILL_CT_EBILL_EMAIL2__c</fields>
        <fields>EBILL_CT_EBILL_EMAIL__c</fields>
        <fields>EBILL_CT_EBILL_MOB_PHONE__c</fields>
        <fields>EBILL_CT_EBILL_ORACLE_PARTY_SITE_ID__c</fields>
        <fields>EBILL_CT_EBILL_PRIMARY_FAX__c</fields>
        <fields>EBILL_CT_EBILL_PRIMARY_PHONE__c</fields>
        <fields>EBILL_CT_EBILL_SALUTAION__c</fields>
        <fields>EBILL_CT_EBILL_TITLE__c</fields>
        <fields>EBILL_CT_SFDC_EBILL_1_DEFAULT_SITE_ID__c</fields>
        <fields>EBILL_CT_SFDC_EBILL_1_ISPRIMARY__c</fields>
        <fields>EBILL_CT_SFDC_EBILL_DEFAULT_SITE_ID__c</fields>
        <fields>EBILL_CT_SFDC_EBILL_ISPRIMARY__c</fields>
        <fields>EXCLUDE_ALT_SRC__c</fields>
        <fields>EXCLUDE_DROP_SHIP__c</fields>
        <fields>Furniture_delivery_Code__c</fields>
        <fields>INV_NUM_OF_COPIES__c</fields>
        <fields>Id</fields>
        <fields>OMAX_ACCT_ID__c</fields>
        <fields>OMAX_BILL_TO_ADDR_ID__c</fields>
        <fields>OMAX_SHIP_TO_ADDR_ID__c</fields>
        <fields>OPERATION__c</fields>
        <fields>PARENT_CODE__c</fields>
        <fields>PD_PD_BILLING_DELIVERY_METHOD__c</fields>
        <fields>PD_PD_DETAIL__c</fields>
        <fields>PD_PD_DOC_NAME__c</fields>
        <fields>PD_PD_DOC_TYPE__c</fields>
        <fields>PD_PD_INCL_BACKUP_INC__c</fields>
        <fields>PD_PD_INDIRECT__c</fields>
        <fields>PD_PD_PAGE_BREAKS__c</fields>
        <fields>PD_PD_PAY_FREQUENCY__c</fields>
        <fields>PD_PD_SORTS__c</fields>
        <fields>PD_PD_TOTALS__c</fields>
        <fields>PREFERRED_DLV_LOC__c</fields>
        <fields>PROMOTIONAL_CATALOG_FLAG__c</fields>
        <fields>PROMOTIONAL_EMAIL_FLAG__c</fields>
        <fields>PROMOTIONAL_FAX_FLAG__c</fields>
        <fields>PROMOTIONAL_FLYER_FLAG__c</fields>
        <fields>PROMOTIONAL_PHONE_FLAG__c</fields>
        <fields>PROMOTIONAL_STUFFER_FLAG__c</fields>
        <fields>SALES_CONTACT_PHONE_EXTENSION__c</fields>
        <fields>SALES_CT_SALES_CONTACT_FIRSTNAME__c</fields>
        <fields>SALES_CT_SALES_CONTACT_LASTNAME__c</fields>
        <fields>SALES_CT_SALES_CONTACT_ROLE__c</fields>
        <fields>SALES_CT_SALES_EMAIL__c</fields>
        <fields>SALES_CT_SALES_MOB_PHONE__c</fields>
        <fields>SALES_CT_SALES_PRIMARY_FAX__c</fields>
        <fields>SALES_CT_SALES_PRIMARY_PHONE__c</fields>
        <fields>SALES_CT_SALES_SALUTAION__c</fields>
        <fields>SALES_CT_SALES_TITLE__c</fields>
        <fields>SALES_CT_SFDC_SALES_CONTACT_ID__c</fields>
        <fields>SALES_CT_SFDC_SALES_CONTACT_ROLE_ID__c</fields>
        <fields>SFD201F_ACCOUNT_PROFILE__c</fields>
        <fields>Sales_Rep_ID_for_First_Ship_to__c</fields>
        <fields>TAX_EXCEPTION_FLAG__c</fields>
        <fields>TIER_1_ACCOUNT_CODE__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>soa_connection@officedepot.com</integrationUser>
        <name>Account Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Account Message</fullName>
        <actions>
            <name>Resend_Account_Setup_Data</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Sends the outbound message for account setup to aops</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Make Awaiting Sales ID null</fullName>
        <actions>
            <name>Make_Awaiting_Sales_ID_null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Message__c.ACCT_ID_REP_ID__c</field>
            <operation>equals</operation>
            <value>Awaiting SalesID</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
