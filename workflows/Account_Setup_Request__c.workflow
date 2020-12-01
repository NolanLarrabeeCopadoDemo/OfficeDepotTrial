<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Setup_Group_Email_address_Notification</fullName>
        <description>Account Setup - Group Email address Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Archived_Email_Templates/Group_Email_Addr</template>
    </alerts>
    <alerts>
        <fullName>Account_Setup_Pay_Method_ACH</fullName>
        <description>Account Setup - Pay Method - ACH</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AccountSetup_Emails/Pay_Method_ACH</template>
    </alerts>
    <alerts>
        <fullName>Account_Setup_Pay_Method_Check</fullName>
        <description>Account Setup - Pay Method - Check</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AccountSetup_Emails/Pay_Method_Check</template>
    </alerts>
    <alerts>
        <fullName>Accounts_Payable_Contacts</fullName>
        <description>Accounts Payable Contacts</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AccountSetup_Emails/Accounts_Payable_Contacts</template>
    </alerts>
    <alerts>
        <fullName>Add_Ship_Tos</fullName>
        <description>Add Ship Tos</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Archived_Email_Templates/Add_Ship_Tos</template>
    </alerts>
    <alerts>
        <fullName>Billing_Budget_Limits</fullName>
        <description>Billing - Budget Limits</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Archived_Email_Templates/Budget_Limits</template>
    </alerts>
    <alerts>
        <fullName>Billing_Delivery_Type</fullName>
        <ccEmails>billingsetup@officedepot.com</ccEmails>
        <description>Billing Delivery Type</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AccountSetup_Emails/Billing_Delivery_Type</template>
    </alerts>
    <alerts>
        <fullName>Billing_Frequency_Other</fullName>
        <ccEmails>khaled.ziadeh@officedepot.com</ccEmails>
        <description>Billing Frequency (Other)</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>AccountSetup_Emails/Billing_Frequency</template>
    </alerts>
    <alerts>
        <fullName>Contract_Maintenance</fullName>
        <description>Contract Maintenance</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Archived_Email_Templates/Contract_Maintenance</template>
    </alerts>
    <alerts>
        <fullName>Early_Pay_Discounts</fullName>
        <description>Early Pay Discounts</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AccountSetup_Emails/Early_Pay_Discount</template>
    </alerts>
    <alerts>
        <fullName>Electronic_Interface_EDI</fullName>
        <ccEmails>B2BSupport@officedepot.com</ccEmails>
        <description>Electronc Interface  EDI Alert</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AccountSetup_Emails/Electronic_Interface_EDI</template>
    </alerts>
    <alerts>
        <fullName>Exclude_Universal_Pricing</fullName>
        <ccEmails>BSD-Pricing@officedepot.com</ccEmails>
        <description>Exclude Universal Pricing</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AccountSetup_Emails/Universal_Pricing_Exclusion</template>
    </alerts>
    <alerts>
        <fullName>Extended_Terms</fullName>
        <description>Extended Terms</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AccountSetup_Emails/Extended_Terms</template>
    </alerts>
    <alerts>
        <fullName>Minimum_Order_Value_Alert</fullName>
        <ccEmails>ContractMaint@officedepot.com</ccEmails>
        <description>Minimum Order Value Alert</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AccountSetup_Emails/Minimum_Order_Value</template>
    </alerts>
    <alerts>
        <fullName>Multiple_Bill_To</fullName>
        <ccEmails>khaled.ziadeh@officedepot.com</ccEmails>
        <description>Multiple Bill To</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AccountSetup_Emails/Accounts_Payable_Contacts</template>
    </alerts>
    <alerts>
        <fullName>Onling_Ordering_BSDNET</fullName>
        <description>Onling Ordering (BSDNET)</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AccountSetup_Emails/eCommerce_Setup</template>
    </alerts>
    <alerts>
        <fullName>Order_Level_Tier_Discounts</fullName>
        <description>Order Level/Tier Discounts</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Archived_Email_Templates/Order_Level_Tier_Discounts</template>
    </alerts>
    <alerts>
        <fullName>Restricted_Ordering_on_Products</fullName>
        <description>Restricted Ordering on Products</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AccountSetup_Emails/Restrictions</template>
    </alerts>
    <alerts>
        <fullName>Small_Order_Fee_Notification</fullName>
        <description>Small Order Fee Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Archived_Email_Templates/Small_Order_Fee</template>
    </alerts>
    <alerts>
        <fullName>Special_Delivery</fullName>
        <description>Special Delivery</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AccountSetup_Emails/Special_Delivery</template>
    </alerts>
    <alerts>
        <fullName>Store_Purchase_Cards</fullName>
        <description>Store Purchase Cards</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AccountSetup_Emails/SPC_Cards</template>
    </alerts>
    <alerts>
        <fullName>Tax_Cert</fullName>
        <ccEmails>BSD-TaxExemption@officedepot.com</ccEmails>
        <description>Tax Cert</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AccountSetup_Emails/Tax_Cert</template>
    </alerts>
    <alerts>
        <fullName>Tax_Cert_Reminder</fullName>
        <description>Tax Cert Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>AccountSetup_Emails/Tax_Cert_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Tax_Reminder_Email</fullName>
        <description>Tax Reminder Email</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AccountSetup_Emails/Tax_Cert_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Tiered_Discounts_order_level</fullName>
        <ccEmails>khaled.ziadeh@Officedepot.com</ccEmails>
        <description>Tiered Discounts (order level)</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AccountSetup_Emails/Tiered_Discounts</template>
    </alerts>
    <alerts>
        <fullName>ePro_Email_Notification</fullName>
        <description>ePro Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Archived_Email_Templates/ePro_email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Revenue_Band_Update</fullName>
        <field>Revenue_Band__c</field>
        <formula>&apos;STANDARD&apos;</formula>
        <name>Revenue Band Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Bill Management Access</fullName>
        <actions>
            <name>Onling_Ordering_BSDNET</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Bill_Mgmt_Access__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Email for setting up bill management (Same as eCommerce setup)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Billing Delivery Type</fullName>
        <actions>
            <name>Billing_Delivery_Type</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Accept_ePDF__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>This rule will send an email to setup team when an account setup requires an electronic billing format other then ePDF</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Billing Frequency</fullName>
        <actions>
            <name>Billing_Frequency_Other</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Other_Billing_Frequency__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Account Setup Request, when a user choses &quot;other&quot; for billing frequency</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Budget Limits</fullName>
        <actions>
            <name>Billing_Budget_Limits</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Are_there_budgetary_limits__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Billing - Account Setup Email Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contract Maintenance</fullName>
        <actions>
            <name>Contract_Maintenance</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8</booleanFilter>
        <criteriaItems>
            <field>Account_Setup_Request__c.individual_invoice_billing_or_consolida__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Billing_Frequency__c</field>
            <operation>equals</operation>
            <value>Other</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.PO__c</field>
            <operation>equals</operation>
            <value>Validated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Desktop__c</field>
            <operation>equals</operation>
            <value>Validated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Cost_Center__c</field>
            <operation>equals</operation>
            <value>Validated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Release__c</field>
            <operation>equals</operation>
            <value>Validated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Bill_Mgmt_Access__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Monthly_eStatement_Email__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Early Pay Discount</fullName>
        <actions>
            <name>Early_Pay_Discounts</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Early_Pay_Discount_Needed__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Account Setup Email Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Electronic Interface EDI</fullName>
        <actions>
            <name>Electronic_Interface_EDI</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Does_Account_require_B2B_Integration__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Electronic Interface Request Setup</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Extended  Terms</fullName>
        <actions>
            <name>Extended_Terms</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Confirm_payment_terms_are_Net_30__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <description>Account Setup Email Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Group Email Addr</fullName>
        <actions>
            <name>Account_Setup_Group_Email_address_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Monthly_eStatement_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This rule will send an email address from an account setup to support team at OD</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Minimum Order Value</fullName>
        <actions>
            <name>Minimum_Order_Value_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Minimum_Order_Value__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sends an email to Account Maintenance team on a minimum order value</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Multiply Bill to Locations</fullName>
        <actions>
            <name>Accounts_Payable_Contacts</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.PD_multiple_bill_to_locations__c</field>
            <operation>startsWith</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Account Setup Email Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Account Setup</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.ACCOUNT_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Order Level%2FTier Discounts</fullName>
        <actions>
            <name>Order_Level_Tier_Discounts</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Order_Level_Discounts__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Billing - Account Setup Email Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pay Method - ACH</fullName>
        <actions>
            <name>Account_Setup_Pay_Method_ACH</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Billing_Document_Type__c</field>
            <operation>equals</operation>
            <value>EDI/ACH</value>
        </criteriaItems>
        <description>Sends email to Account owner with detailson how to setup ACH</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pay Method - Check</fullName>
        <actions>
            <name>Account_Setup_Pay_Method_Check</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Billing_Document_Type__c</field>
            <operation>equals</operation>
            <value>Check</value>
        </criteriaItems>
        <description>Sends email to Account owner with detailson how to setup Check Payment</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Restricted Ordering on Products</fullName>
        <actions>
            <name>Restricted_Ordering_on_Products</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Restricted_Ordering_of_Product_Category__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Billing - Account Setup Email Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Revenue Band Update</fullName>
        <actions>
            <name>Revenue_Band_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.Revenue_Band__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SPC Card Request</fullName>
        <actions>
            <name>Store_Purchase_Cards</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Store_Purchasing_Cards__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Request for Store Purchase Cards</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Small Order Fee</fullName>
        <actions>
            <name>Small_Order_Fee_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Small_Order_Fee_Flag__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <description>Billing - Account Setup Request Email Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Special Delivery</fullName>
        <actions>
            <name>Special_Delivery</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Special_Delivery_Requirements__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Account Setup Email Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tax Cert</fullName>
        <actions>
            <name>Tax_Cert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Tax_Exempt__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Tax - Account Setup Email Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tax Cert Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.Tax_Exempt__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Sends a reminder to the creator of the account setup after 3 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Tax_Reminder_Email</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account_Setup_Request__c.CreatedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Tiered Discounts</fullName>
        <actions>
            <name>Tiered_Discounts_order_level</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Order_Level_Discounts__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Universal Pricing</fullName>
        <actions>
            <name>Exclude_Universal_Pricing</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Exclude_Account_from_Universal_Pricing__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Send email with instructions on how to handle universal pricing</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>eCommerce Setup</fullName>
        <actions>
            <name>Onling_Ordering_BSDNET</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Online_Ordering__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Sends an email for business.officedepot.com setup</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ePro Email Notification</fullName>
        <actions>
            <name>ePro_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Setup_Request__c.AOPS_ID1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Setup_Request__c.Using_Customer_eProcurement_system__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>eProcurement - Account Setup Email Notifications</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
