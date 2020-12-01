<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AR_Submission_Approved_Completed</fullName>
        <ccEmails>od.Corpcredit@officedepot.com</ccEmails>
        <description>AR_Submission_Approved_Completed</description>
        <protected>false</protected>
        <senderAddress>sfdc-support@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AR/AR_Submission_Completed</template>
    </alerts>
    <alerts>
        <fullName>AR_Submission_Completed</fullName>
        <ccEmails>od.Corpcredit@officedepot.com</ccEmails>
        <description>AR_Submission_Completed</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-support@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AR/AR_Submission_Completed</template>
    </alerts>
    <alerts>
        <fullName>Alert_for_Requestor72</fullName>
        <description>Alert for Requestor after 72 close to Clone ticket</description>
        <protected>false</protected>
        <recipients>
            <field>IT_BU_Reviewer__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>jeffrey.timor@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CASES/X72hrAlertSalesOps</template>
    </alerts>
    <alerts>
        <fullName>Automatic_email_for_fasttrack</fullName>
        <description>Email will trigger when a Fast Track ticket is moved to the IT Queue</description>
        <protected>false</protected>
        <recipients>
            <recipient>764657@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Support_Cases_Fast_Track_Tickets</template>
    </alerts>
    <alerts>
        <fullName>BSD_Acct_Maint_SLA_Receipt</fullName>
        <description>BSD Acct Maint SLA Receipt</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>bsd-pricing@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_WRF_BSD_Pricing</template>
    </alerts>
    <alerts>
        <fullName>BSD_Training_Case_Creation_Notification</fullName>
        <description>BSD Training - Case Creation Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-support@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support/BSD_Training_Case_Creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>CT_Email_Alert_Notification_Upon_WRF_Creation_Account_Owner</fullName>
        <description>CT Email Alert Notification Upon WRF Creation to Account Owner</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Customer_Transition_Discussion_Template</template>
    </alerts>
    <alerts>
        <fullName>Case_Closed</fullName>
        <description>Case Closed</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>business.solutions@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Account_Maintenance_WRF/Closed_Auto_Notification_to_Rep</template>
    </alerts>
    <alerts>
        <fullName>Case_Completed_Notification</fullName>
        <ccEmails>michael.houng@officedepot.com</ccEmails>
        <description>Case Completed Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CASES/Case_Completed_Closed_Ticket_Email_Nofitication</template>
    </alerts>
    <alerts>
        <fullName>Case_Creation_Notification_for_Workspace_Interiors</fullName>
        <description>Case Creation Notification for Workspace Interiors</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CASES/Workspace_Interiors_Auto_Notification_to_Rep</template>
    </alerts>
    <alerts>
        <fullName>Communities_Invoice_Confirmation</fullName>
        <description>Communities Invoice Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Requestor_Email_2__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EXTERNAL_Communities_Templates/Invoice_Account_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Critical_Case_Notification</fullName>
        <ccEmails>crm-selling@officedepot.com</ccEmails>
        <ccEmails>sellingoncall@officedepot.com</ccEmails>
        <ccEmails>sfdc-support@officedepot.com</ccEmails>
        <description>Critical Case Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>IT_Functional_Grp</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>Salesforce_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support/CASESCriticalCaseNotification</template>
    </alerts>
    <alerts>
        <fullName>EmailAlertToWRFRequestor</fullName>
        <ccEmails>lalit.malav@appirio.com</ccEmails>
        <description>EmailAlertToWRFRequestor</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EmailAlertToWRFRequestorTempalate</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert</fullName>
        <description>Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>764657@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Support_Cases_Fast_Track_Tickets</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Requester</fullName>
        <description>Email Alert to Requester</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/Workspace_Interiors_Requester_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Email_to_Case_SCOE_Support_Requester</fullName>
        <description>Email: Email to Case - SCOE Support Requester</description>
        <protected>false</protected>
        <recipients>
            <field>Dup_Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Requestor_Email_2__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>business.solutions@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support/SUPPORT_Case_Response_with_Solution_for_Email_to_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_Email_to_Deployment_Case_Requestor_Response</fullName>
        <description>Email : Email to Deployment Case - Requestor Response</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support/SUPPORT_Case_Response_with_Solution_for_Email_to_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_for_New_Implementation_Request</fullName>
        <description>Email Notification for New Implementation Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>277991@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zzz154342@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/Case_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Case_Requestor_Response_Email</fullName>
        <description>Email : Email to Case - Requestor Response</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support/SUPPORT_Case_Response_with_Solution_for_Email_to_Case</template>
    </alerts>
    <alerts>
        <fullName>Email_will_trigger_when_a_Production_Fix_ticket_is_moved_to_the_IT_Queue</fullName>
        <description>Email will trigger when a Production Fix ticket is moved to the IT Queue</description>
        <protected>false</protected>
        <recipients>
            <recipient>764657@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Support_Cases_Prod_Fix_Tickets</template>
    </alerts>
    <alerts>
        <fullName>Finance_SCOE_Closed_case_notification</fullName>
        <description>Finance: SCOE Closed case notification</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AR/FIN_Closed_Auto_Notification_to_Rep</template>
    </alerts>
    <alerts>
        <fullName>GT_Closed_Case_Notification</fullName>
        <description>GT - Closed Case Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GT_Support/GT_Closed_Case</template>
    </alerts>
    <alerts>
        <fullName>GT_Email_Legal_Team_when_GT_Legal_Review_Case_is_Created</fullName>
        <description>GT - Email Legal Team when GT Legal Review Case is Created</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GT_Support/GT_New_Template</template>
    </alerts>
    <alerts>
        <fullName>GT_Report_Notification</fullName>
        <description>GT Report Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/Canada_Report_Notification</template>
    </alerts>
    <alerts>
        <fullName>GT_Send_Notification_to_Assigned_To</fullName>
        <description>GT - Send Notification to Assigned To</description>
        <protected>false</protected>
        <recipients>
            <field>AM_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GT_Support/GT_Case_Assigned_To</template>
    </alerts>
    <alerts>
        <fullName>GT_Send_Notification_to_Support_Requester</fullName>
        <description>GT - Send Notification to Support Requester</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>GT_Support/GT_Status_In_Progress</template>
    </alerts>
    <alerts>
        <fullName>Legal_Callout_Risk_Approval_Launch</fullName>
        <description>Legal Callout Risk Approval Launch</description>
        <protected>false</protected>
        <recipients>
            <field>Approval_Submitter_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PROS_templates/Legal_Callout_Risk_Approval_Launch</template>
    </alerts>
    <alerts>
        <fullName>Legal_Callout_Risk_Approval_Response</fullName>
        <description>Legal Callout Risk Approval Response</description>
        <protected>false</protected>
        <recipients>
            <field>Approval_Submitter_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PROS_templates/Legal_Callout_Risk_Approval_Response</template>
    </alerts>
    <alerts>
        <fullName>LostDevice_Critical_Case_Notification</fullName>
        <ccEmails>crmit-sfdc@officedepot.com</ccEmails>
        <ccEmails>sfdc-support@officedepot.com</ccEmails>
        <description>LOST DEVICE Critical Case Notification</description>
        <protected>false</protected>
        <senderAddress>jeffrey.timor@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support/CASESCriticalCaseNotification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Creator</fullName>
        <description>Notify Case Creator</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support/SUPPORTCaseResponsewithSolution</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Creator_Deployment</fullName>
        <description>Notify Case Creator Deployment</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CASES/SUPPORT_Case_Response_Deployment1</template>
    </alerts>
    <alerts>
        <fullName>Notify_Case_Receipt</fullName>
        <description>Notify Case Receipt</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>contractmaint@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_WRF_Auto_Notification_to_Rep</template>
    </alerts>
    <alerts>
        <fullName>Notify_Owner_of_Approval</fullName>
        <ccEmails>suelair.riveron@officedepot.com</ccEmails>
        <description>Notify Owner of Approval</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Owner_of_Rejection</fullName>
        <description>Notify Owner of Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Pricing_Analyst_of_Approval</fullName>
        <ccEmails>bsdfinance.contractdivision@officedepot.com</ccEmails>
        <description>Notify Pricing Analyst of Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Compliance_Mgr__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>DSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Pricing_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Regional_Dir__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Regional_VP__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CPM/CPM_Case_Fully_Approved</template>
    </alerts>
    <alerts>
        <fullName>Notify_Pricing_Analyst_of_Rejection</fullName>
        <description>Notify Pricing Analyst of Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Pricing_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Approval_Request_Emails/CPM_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Rep_of_WRF_Initial_Approval_Rejection</fullName>
        <description>Notify Rep of WRF Initial Approval Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Initial_Approval_Emails/WRF_Request_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Support_Requester_of_Submission</fullName>
        <description>Notify Support Requester of Submission</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Initial_Approval_Emails/WRF_Initial_Approval_to_Rep</template>
    </alerts>
    <alerts>
        <fullName>PRM_Email_Notification_On_Case_Closed</fullName>
        <description>PRM Email Notification On Case Closed</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/PRM_Support_Ticket_Closed</template>
    </alerts>
    <alerts>
        <fullName>PRM_Email_Notification_On_Case_Creation</fullName>
        <description>PRM Email Notification On Case Creation</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/PRM_Support_Ticket_Creation</template>
    </alerts>
    <alerts>
        <fullName>RCOE_Auto_Reply</fullName>
        <description>RCOE Auto Reply</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CASES/RCOE_Auto_Reply_Email</template>
    </alerts>
    <alerts>
        <fullName>Rebate_Email_Alert</fullName>
        <ccEmails>bsd.customerrebates@officedepot.com</ccEmails>
        <description>Send an notification to bsd.customerrebates@officedepot.com when ticket assigned to rebate queue</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_Rebate_Auto_Notification</template>
    </alerts>
    <alerts>
        <fullName>Rep_Email</fullName>
        <description>Rep Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/Case_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>Reply_IT_Ops_Team_job_failure_details</fullName>
        <ccEmails>sellingoncall@officedepot.com</ccEmails>
        <ccEmails>sellingoncall@13tkf7o944xfo4esy5guzia02a65duagnqde1iu6nfj91gue9e.e-j4osmas.na100.case.salesforce.com</ccEmails>
        <description>Reply IT Ops Team  job failure details</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>sellingoncall@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CASES/ITCASE_Ticket_Questionnaire</template>
    </alerts>
    <alerts>
        <fullName>SCOE_Auto_Notification_on_Internal_Case</fullName>
        <description>SCOE: Auto Notification on Internal Case</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>business.solutions@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Account_Maintenance_WRF/SCOE_Auto_Notification_to_Requester</template>
    </alerts>
    <alerts>
        <fullName>SCOE_Copy_Print_Email_Alert</fullName>
        <ccEmails>ryan.cooper@officedepot.com;</ccEmails>
        <ccEmails>lisa.shelnutt@officedepot.com</ccEmails>
        <description>SCOE Copy &amp; Print Email Alert</description>
        <protected>false</protected>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Not_Used/SCOE_Copy_Print_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>SCOE_Email_Alert_when_case_is_assigned_field_Assigned_To</fullName>
        <description>SCOE Email Alert when case is assigned field Assigned To</description>
        <protected>false</protected>
        <recipients>
            <field>AM_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Not_Used/SCOE_Assigned_To_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>SCOE_Finance_Rep_Notification</fullName>
        <description>SCOE: Finance Rep Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CASES/Finance_Auto_Notification_to_Rep</template>
    </alerts>
    <alerts>
        <fullName>SCOE_Orion_Email_Alert</fullName>
        <ccEmails>Orion@officedepot.com</ccEmails>
        <description>SCOE Orion Email Alert</description>
        <protected>false</protected>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Not_Used/SCOE_Copy_Print_Case_Notification</template>
    </alerts>
    <alerts>
        <fullName>SalesOps_Pricing_Compliance_Notification</fullName>
        <description>SalesOps - Pricing Compliance Notification</description>
        <protected>false</protected>
        <recipients>
            <field>AM_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/SalesOps_Pricing_Compliance_Notification</template>
    </alerts>
    <alerts>
        <fullName>SalesOps_Support_Requestor_Pricing_Compliance</fullName>
        <description>SalesOps Support Requestor - Pricing Compliance</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/SalesOps_Support_Requestor_Pricing_Compliance</template>
    </alerts>
    <alerts>
        <fullName>Send_Account_Maint_Requestor_Auto_Close_Notification</fullName>
        <description>Send Account Maint. Requestor Auto Close Notification</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>contractmaint@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_WRF_Auto_Close_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Account_Maint_Requestor_Cancelled_Notification</fullName>
        <description>Send Account Maint. Requestor Cancelled Notification</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>contractmaint@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_WRF_Case_Cancelled</template>
    </alerts>
    <alerts>
        <fullName>Send_Account_Maint_Requestor_Close_Notification</fullName>
        <description>Send Account Maint. Requestor Close Notification</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>contractmaint@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_WRF_Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Account_Maint_Requestor_Close_Notification_for_Child_to_Parent_Move</fullName>
        <description>Send Account Maint. Requestor Close Notification for Child to Parent Move</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>field-contracts@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_WRF_Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Account_Maint_Requestor_New_Case_Notification</fullName>
        <description>Send Account Maint. Requestor New Case Notification</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>field-contracts@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_WRF_Auto_Notification_to_Rep</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Alert_to_RCOE_Email_INbox</fullName>
        <ccEmails>rcoerequests@officedepot.com</ccEmails>
        <description>Send Email Alert to RCOE Email Inbox</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>RCOE_Templates/RCOE_Notify_RCOE_email</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_when_the_case_closed</fullName>
        <description>Send Email Notification when the case closed</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_WRF_Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_Requester</fullName>
        <description>Send Email to Requester</description>
        <protected>false</protected>
        <recipients>
            <field>Support_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Backlog_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Post_Survey_Email_Alert</fullName>
        <description>Send Post Survey Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Templates/WRF_Post_Work_Survey_21_days</template>
    </alerts>
    <alerts>
        <fullName>Send_Requestor_Email</fullName>
        <description>Send Requestor Email</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_WRF_Awaiting_Info_Auto_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Send_Requestor_Email_about_Closure_and_Survey</fullName>
        <description>Send Requestor Email about Closure and Survey</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Templates/WRF_Case_Closed</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_to_complianceadmin_rebates_officedepot_com</fullName>
        <ccEmails>complianceAdmin-rebates@officedepot.com</ccEmails>
        <description>Send an email to complianceadmin-rebates@officedepot.com</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Acct_Maint_Auto_Emails/Acct_Maint_Rebate_Auto_Notification</template>
    </alerts>
    <alerts>
        <fullName>WRF_Adjacency_CPD</fullName>
        <description>WRF Adjacency - CPD</description>
        <protected>false</protected>
        <recipients>
            <recipient>278157@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Templates/Work_Request_Adjacency_Notif</template>
    </alerts>
    <alerts>
        <fullName>WRF_Adjacency_Furniture</fullName>
        <description>WRF Adjacency - Furniture</description>
        <protected>false</protected>
        <recipients>
            <recipient>278026@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Templates/Work_Request_Adjacency_Notif</template>
    </alerts>
    <alerts>
        <fullName>WRF_Adjacency_MPS</fullName>
        <description>WRF Adjacency - MPS</description>
        <protected>false</protected>
        <recipients>
            <recipient>278274@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Templates/Work_Request_Adjacency_Notif</template>
    </alerts>
    <alerts>
        <fullName>WRF_Assessment_Email_to_Sales_Rep_DSM_and_MD</fullName>
        <description>WRF Assessment Email to Sales Rep, DSM, and MD</description>
        <protected>false</protected>
        <recipients>
            <field>DSM__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Regional_Dir__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Templates/WRF_AssessmentEmail</template>
    </alerts>
    <alerts>
        <fullName>WRF_Autoclose_Notification</fullName>
        <description>WRF Autoclose Notification</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Templates/WRF_Auto_Close_New</template>
    </alerts>
    <alerts>
        <fullName>WRF_Confirmation_Email_to_Requestor</fullName>
        <description>WRF Confirmation Email to Requestor</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Initial_Approval_Emails/WRF_Receipt_Notification_to_rep</template>
    </alerts>
    <alerts>
        <fullName>WRF_Field_Action_Reminder</fullName>
        <description>WRF Field Action Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>WRF_Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Templates/WRF_Auto_Reminder_New</template>
    </alerts>
    <alerts>
        <fullName>WRF_Initial_Approval_Reminder</fullName>
        <description>WRF Initial Approval Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Regional_Dir__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/WRF_Initial_Approval_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Workspace_Interiors_Support_Assigned_to_Alert</fullName>
        <description>Workspace Interiors: Support Assigned to Alert</description>
        <protected>false</protected>
        <recipients>
            <field>AM_Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/Workspace_Interiors_Case_Assignment_Assigned_To</template>
    </alerts>
    <alerts>
        <fullName>Workspace_Interiors_Support_Owner_Email</fullName>
        <description>Workspace Interiors Support Owner Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/Workspace_Interiors_Case_Assignment_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Request_Support_Type</fullName>
        <field>Support_Type__c</field>
        <literalValue>Account Requests</literalValue>
        <name>Account Request Support Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_Next_ApproverId_10</fullName>
        <field>Next_ApproverId__c</field>
        <formula>IF(Sr_Vice_President__c!=null, Sr_Vice_President__c, null)</formula>
        <name>Add Next ApproverId 10</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_Next_ApproverId_5</fullName>
        <field>Next_ApproverId__c</field>
        <formula>IF(Regional_VP__c!=null, Regional_VP__c, IF(VP_Sales_Ops__c!=null, VP_Sales_Ops__c, IF( Director_Finance__c!=null, Director_Finance__c,
IF(Field_Sales_VP__c!=null, Field_Sales_VP__c, IF(Sr_Vice_President__c!=null, Sr_Vice_President__c, null) ) ) ) )</formula>
        <name>Add Next ApproverId 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_Next_ApproverId_7</fullName>
        <field>Next_ApproverId__c</field>
        <formula>IF(VP_Sales_Ops__c!=null, VP_Sales_Ops__c, IF( Director_Finance__c!=null, Director_Finance__c,
IF(Field_Sales_VP__c!=null, Field_Sales_VP__c, IF(Sr_Vice_President__c!=null, Sr_Vice_President__c, null) ) ) )</formula>
        <name>Add Next ApproverId 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_Next_ApproverId_8</fullName>
        <field>Next_ApproverId__c</field>
        <formula>IF( Director_Finance__c!=null, Director_Finance__c,
IF(Field_Sales_VP__c!=null, Field_Sales_VP__c,
IF(Sr_Vice_President__c!=null, Sr_Vice_President__c, null) ) )</formula>
        <name>Add Next ApproverId 8</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_Next_ApproverId_9</fullName>
        <field>Next_ApproverId__c</field>
        <formula>IF(Field_Sales_VP__c!=null, Field_Sales_VP__c,
IF(Sr_Vice_President__c!=null, Sr_Vice_President__c, null) )</formula>
        <name>Add Next ApproverId 9</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_Next_Approver_Id_3</fullName>
        <field>Next_ApproverId__c</field>
        <formula>IF(Public_Sector_VP__c!=null, Public_Sector_VP__c,
IF(WRF_Finance__c==true, &quot;Finance&quot;,IF(Regional_VP__c!=null, Regional_VP__c, IF(VP_Sales_Ops__c!=null, VP_Sales_Ops__c, IF( Director_Finance__c!=null, Director_Finance__c,
IF(Field_Sales_VP__c!=null, Field_Sales_VP__c, IF(Sr_Vice_President__c!=null, Sr_Vice_President__c, null) ) ) ) ) ) )</formula>
        <name>Add Next Approver Id 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_Task_Classification</fullName>
        <description>Change Classification to Task</description>
        <field>IT_Classification__c</field>
        <literalValue>Task</literalValue>
        <name>Add Task Classification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_next_Approver2</fullName>
        <field>Next_ApproverId__c</field>
        <formula>IF(Regional_Dir__c!=null, Regional_Dir__c,
IF(Public_Sector_VP__c!=null, Public_Sector_VP__c,
IF(WRF_Finance__c==true, &quot;Finance&quot;,IF(Regional_VP__c!=null, Regional_VP__c, IF(VP_Sales_Ops__c!=null, VP_Sales_Ops__c, IF( Director_Finance__c!=null, Director_Finance__c,
IF(Field_Sales_VP__c!=null, Field_Sales_VP__c, IF(Sr_Vice_President__c!=null, Sr_Vice_President__c, null) ) ) ) ) ) ) )</formula>
        <name>Add next Approver2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_next_ApproverId_6</fullName>
        <field>Next_ApproverId__c</field>
        <formula>IF(Regional_VP__c!=null, Regional_VP__c, IF(VP_Sales_Ops__c!=null, VP_Sales_Ops__c, IF( Director_Finance__c!=null, Director_Finance__c,
IF(Field_Sales_VP__c!=null, Field_Sales_VP__c, IF(Sr_Vice_President__c!=null, Sr_Vice_President__c, null) ) ) ) )</formula>
        <name>Add next ApproverId 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_next_Approver_Id_4</fullName>
        <field>Next_ApproverId__c</field>
        <formula>IF(WRF_Finance__c==true, &quot;Finance&quot;,IF(Regional_VP__c!=null, Regional_VP__c, IF(VP_Sales_Ops__c!=null, VP_Sales_Ops__c, IF( Director_Finance__c!=null, Director_Finance__c,
IF(Field_Sales_VP__c!=null, Field_Sales_VP__c, IF(Sr_Vice_President__c!=null, Sr_Vice_President__c, null) ) ) ) ) )</formula>
        <name>Add next Approver Id 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_next_approverId_S_1</fullName>
        <field>Next_ApproverId__c</field>
        <formula>IF(DSM__c!=null, DSM__c, IF(Strategy_Director__c!=null, Strategy_Director__c, IF(Regional_Dir__c!=null, Regional_Dir__c, IF(Public_Sector_VP__c!=null, Public_Sector_VP__c, IF(WRF_Finance__c==true, &quot;Finance&quot;, IF(Sr_Strategy_Director__c!=null, Sr_Strategy_Director__c, IF(Regional_VP__c!=null, Regional_VP__c, IF(VP_Sales_Ops__c!=null, VP_Sales_Ops__c, IF( Director_Finance__c!=null, Director_Finance__c, IF(Field_Sales_VP__c!=null, Field_Sales_VP__c, IF(Sr_Vice_President__c!=null, Sr_Vice_President__c, null) ) ) ) ) ) ) ) ) ) )</formula>
        <name>Add next approverId S_1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_next_approver_id</fullName>
        <field>Next_ApproverId__c</field>
        <formula>IF(Compliance_Mgr__c!=null, Compliance_Mgr__c, IF(DSM__c!=null, DSM__c, IF(Regional_Dir__c!=null, Regional_Dir__c, IF(Public_Sector_VP__c!=null, Public_Sector_VP__c, IF(WRF_Finance__c==true, &quot;Finance&quot;,IF(Regional_VP__c!=null, Regional_VP__c, IF(VP_Sales_Ops__c!=null, VP_Sales_Ops__c, IF( Director_Finance__c!=null, Director_Finance__c, IF(Field_Sales_VP__c!=null, Field_Sales_VP__c, IF(Sr_Vice_President__c!=null, Sr_Vice_President__c, null) ) ) ) ) ) ) ) ) )</formula>
        <name>Add next approver id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Update_Open</fullName>
        <description>#01624389</description>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>Approval Status Update Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Date</fullName>
        <field>Approved_Rejected_Date_for_Initial_Apprv__c</field>
        <formula>NOW()</formula>
        <name>Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_for_Analyst_Assignment</fullName>
        <field>Approved_for_Analyst_Assignment__c</field>
        <literalValue>1</literalValue>
        <name>Approved for Analyst Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_for_Analyst_Assignment_TRUE</fullName>
        <description>Marks &apos;Approved for Analyst Assignment&apos; as TRUE.</description>
        <field>Approved_for_Analyst_Assignment__c</field>
        <literalValue>1</literalValue>
        <name>Approved for Analyst Assignment = TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AssignMumford</fullName>
        <description>Update Case Support Owner to &quot;Rich Mumford&quot;------Changed  the owner to Monica Arbelaez</description>
        <field>OwnerId</field>
        <lookupValue>575942@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>AssignMumford</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_to_BU</fullName>
        <field>OwnerId</field>
        <lookupValue>L3_Support_Queue_SalesOps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign to BU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assigned_Partner_Case</fullName>
        <field>OwnerId</field>
        <lookupValue>Partner_Case</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assigned Partner Case</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AssigntoBlank</fullName>
        <field>Assign_To__c</field>
        <name>AssigntoBlank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AssigntoIT</fullName>
        <field>OwnerId</field>
        <lookupValue>ITQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AssigntoIT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AssigtoBusiness</fullName>
        <field>OwnerId</field>
        <lookupValue>L3_Support_Queue_SalesOps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AssigtoBusiness</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BSD_pricing</fullName>
        <field>OwnerId</field>
        <lookupValue>BSD_Pricing</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>BSD pricing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_IT_Stage_to_1_Not_Started</fullName>
        <field>IT_Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>Case IT Stage to 1 Not Started</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_IT_Stage_to_3_Blocked</fullName>
        <field>IT_Status__c</field>
        <literalValue>Blocked</literalValue>
        <name>Case IT Stage to 3 Blocked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_IT_Stage_to_5_BU_Approval</fullName>
        <field>IT_Status__c</field>
        <literalValue>Pending BU Approval</literalValue>
        <name>Case IT Stage to 5 BU Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_IT_Stage_to_In_Dev</fullName>
        <field>IT_Status__c</field>
        <literalValue>In Development</literalValue>
        <name>Case IT Stage to  2 In Dev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_IT_Status_To_Completed</fullName>
        <field>IT_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Case IT Stage to  7 Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_IT_Status_to_Migration</fullName>
        <field>IT_Status__c</field>
        <literalValue>Awaiting Migration</literalValue>
        <name>Case IT Stage to  6 Migration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_IT_Status_to_Testing</fullName>
        <field>IT_Status__c</field>
        <literalValue>Ready for QA</literalValue>
        <name>Case IT Stage to 4 QA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>General_Maint_Requests_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_ODN</fullName>
        <field>OwnerId</field>
        <lookupValue>ODN_General_Account_Maintenance</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner ODN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_RCOE</fullName>
        <field>OwnerId</field>
        <lookupValue>RCOE</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner RCOE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_TAM</fullName>
        <field>OwnerId</field>
        <lookupValue>TAM_Solutions</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner TAM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_to_AR</fullName>
        <description>Account Receivables</description>
        <field>OwnerId</field>
        <lookupValue>Accounts_Receivable</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner to AR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_to_CRMIT</fullName>
        <field>OwnerId</field>
        <lookupValue>ITQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner to CRMIT</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_to_Diversity_Queue</fullName>
        <description>Case_Owner_to_Diversity_Queue</description>
        <field>OwnerId</field>
        <lookupValue>Diversity_Solutions_Ops</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner to Diversity Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_to_IT</fullName>
        <field>OwnerId</field>
        <lookupValue>ITQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner to IT</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_to_Migration</fullName>
        <field>OwnerId</field>
        <lookupValue>ITQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner to Migration</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Record_Type_to_Case</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Support</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Case Record Type to Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Stage_to_Case_Review</fullName>
        <field>Status</field>
        <literalValue>Case Review</literalValue>
        <name>Case Stage to Case Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Update_To_BU</fullName>
        <field>Status</field>
        <literalValue>Business Unit Action</literalValue>
        <name>Case Status To BU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Update_to_IT</fullName>
        <field>Status</field>
        <literalValue>Assigned to IT</literalValue>
        <name>Case Status to IT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_BU_Validation</fullName>
        <field>Status</field>
        <literalValue>BU Validation</literalValue>
        <name>Case Status to BU Validation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_Back_Log</fullName>
        <field>Status</field>
        <literalValue>Backlog</literalValue>
        <name>Case Status to Back Log</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_to_Closed</fullName>
        <field>Status</field>
        <literalValue>Cancelled</literalValue>
        <name>Case Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_obj_Approval_Start_time</fullName>
        <field>Approval_Start_time__c</field>
        <formula>IF( ( ISNULL(Approval_Start_time__c)|| ISBLANK(Approval_Start_time__c)), now(),Approval_Start_time__c )</formula>
        <name>Case obj Approval Start time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ChangeToITCase</fullName>
        <description>Change Ticket to IT case Type ticket</description>
        <field>RecordTypeId</field>
        <lookupValue>IT_Cases</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>ChangeToITCase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Approved_for_Analyst_Assignment</fullName>
        <description>Approved for Analyst Assignment = TRUE</description>
        <field>Approved_for_Analyst_Assignment__c</field>
        <literalValue>1</literalValue>
        <name>Change Approved for Analyst Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_BU_Reviewer_to_Dataloader</fullName>
        <field>IT_BU_Reviewer__c</field>
        <lookupValue>dataloader@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change BU Reviewer to Dataloader</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Queue_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>SA_Recurring_Reports_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Queue Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Changine_Case_Owner_to_Commisioning</fullName>
        <field>OwnerId</field>
        <lookupValue>Channel_Commissions_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Changing Case Owner to Commisioning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Changine_Case_Owner_to_MArketing</fullName>
        <field>OwnerId</field>
        <lookupValue>Channel_Marketing_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Changine Case Owner to MArketing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Changine_Case_Owner_to_Training</fullName>
        <field>OwnerId</field>
        <lookupValue>Channel_Enablement_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Changine Case Owner to Training</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Changing_Case_Owner_to_Supporting</fullName>
        <field>OwnerId</field>
        <lookupValue>Channel_Support_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Changing Case Owner to Supporting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Case</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Commission_Update</fullName>
        <description>Update the owner to channel commission team</description>
        <field>OwnerId</field>
        <lookupValue>Channel_Commissions_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Commission Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Erase_Survey_Alert_Date</fullName>
        <description>Erase Survey Alert Date</description>
        <field>WRF_PS_Alert_Date__c</field>
        <name>Erase Survey Alert Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GT_Owner_to_GT_Admin_Queue</fullName>
        <description>GT Owner to GT Admin Queue</description>
        <field>OwnerId</field>
        <lookupValue>GT_Admin_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>GT Owner to GT Admin Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IT_Impact_Description_Update</fullName>
        <description>Add standard data to Impact Description</description>
        <field>IT_Impact__c</field>
        <formula>Text(Today()) + &quot; Please Deactivate all OAuth Devices under the specified user&quot;</formula>
        <name>IT Impact Description Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Approval_Approved_Date</fullName>
        <description>Timestamp date/time initial approval approved date.</description>
        <field>Approved_Rejected_Date_for_Initial_Apprv__c</field>
        <formula>now()</formula>
        <name>Initial Approval Approved Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Approval_Rejected_Date</fullName>
        <description>Timestamp date/time initial approval rejected date.</description>
        <field>Approved_Rejected_Date_for_Initial_Apprv__c</field>
        <formula>now()</formula>
        <name>Initial Approval Rejected Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Approval_Start_Time</fullName>
        <description>Timestamp date/time initial approval is launched.</description>
        <field>Approval_Start_time__c</field>
        <formula>now()</formula>
        <name>Initial Approval Start Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MakeAssigtoblank</fullName>
        <field>Assign_To__c</field>
        <name>MakeAssigtoblank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Marketing_Update</fullName>
        <description>Update the owner to channel marketing team</description>
        <field>OwnerId</field>
        <lookupValue>Channel_Marketing_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Marketing Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PriorityCritical</fullName>
        <description>Priority to Critical</description>
        <field>Priority</field>
        <literalValue>1-Critical</literalValue>
        <name>PriorityCritical</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Alternate_Item_Request</fullName>
        <description>RT - Alternate Item Request</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Alternate Item Request</literalValue>
        <name>RT - Alternate Item Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Audit_Request</fullName>
        <description>Set Request Type - Audit Request</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Audit Request</literalValue>
        <name>RT -Audit Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Contract_Extension</fullName>
        <description>Set RT - Contract Extension</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Contract Extension</literalValue>
        <name>RT - Contract Extension</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_GARP</fullName>
        <field>WRF_Request_Type__c</field>
        <literalValue>GARP</literalValue>
        <name>RT - GARP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_GPO</fullName>
        <description>&quot;New Customer - GPO - 
TCPN, NIPA, Amerinet, Premier, MedAssets, US Communities, Chamber, Other&quot;</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>GPO</literalValue>
        <name>RT - GPO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Hosted_Catalog_Creation_Update</fullName>
        <field>WRF_Request_Type__c</field>
        <literalValue>Hosted Catalog Creation/Update</literalValue>
        <name>RT - Hosted Catalog Creation/Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Private_Brand_Comparison_Only</fullName>
        <description>Request Type - Private Brand Comparison Only</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Comparison Private Brand</literalValue>
        <name>RT-Private Brand Comparison Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Proprietary_Item_Setup</fullName>
        <description>RT - Proprietary Item Setup</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Proprietary Item Setup</literalValue>
        <name>RT - Proprietary Item Setup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_to_IT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>IT_Cases</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type to IT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reject_Status_Open</fullName>
        <description>#01624389</description>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>Reject Status Update Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejected_Date</fullName>
        <field>Approved_Rejected_Date_for_Initial_Apprv__c</field>
        <formula>NOW()</formula>
        <name>Rejected Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Next_ApproverId</fullName>
        <field>Next_ApproverId__c</field>
        <name>Remove Next ApproverId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Notify_Requestor</fullName>
        <description>Reset Notify Requestor</description>
        <field>Notify_Requester__c</field>
        <literalValue>0</literalValue>
        <name>Reset Notify Requestor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Task_Notification</fullName>
        <field>Task_Notification__c</field>
        <formula>&quot;N&quot;</formula>
        <name>Reset Task Notification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RevertEmailTriggerFlag</fullName>
        <field>Notify_Requester__c</field>
        <literalValue>0</literalValue>
        <name>RevertEmailTriggerFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Route_to_SCOE_Escalations_Queue</fullName>
        <description>Update Support (Case) Owner - SCOE Escalations</description>
        <field>OwnerId</field>
        <lookupValue>SCOE_Escalations</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Route to SCOE Escalations Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Route_to_eCommerce</fullName>
        <field>OwnerId</field>
        <lookupValue>eCommerce_Field_Support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Route to eCommerce</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SalesOp_Case_Status_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>SalesOp Case Status Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Operations</fullName>
        <field>OwnerId</field>
        <lookupValue>L3_Support_Queue_SalesOps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner SalesOps Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_to_BSD_Pricing</fullName>
        <field>OwnerId</field>
        <lookupValue>BSD_Pricing</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Send to BSD Pricing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Action_Taken_to_Cancelled</fullName>
        <description>Set Action Taken to Cancelled</description>
        <field>IT_Action_Taken__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Set Action Taken to Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approv_Status_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Approv. Status=Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approv_Status_Recalled</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approval Recalled</literalValue>
        <name>Set Approv. Status=Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approv_Status_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set Approv. Status=Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approv_Status_to_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending Approval</literalValue>
        <name>Set Approv. Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Auto_Close_Date_for_Account_Maint</fullName>
        <description>Set Auto Close Date for Account Maint.</description>
        <field>Auto_Close_Date__c</field>
        <formula>Today() + 5</formula>
        <name>Set Auto Close Date for Account Maint.</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Owner_to_Non_Code_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>TechSales_NonCode</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set Case Owner to Non-Code Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Compliance_Action_Date</fullName>
        <field>Compliance_Mgr_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set Compliance Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_DSM_Action_Date</fullName>
        <field>DSM_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set DSM Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Director_Finance_Action_Date</fullName>
        <field>Finance_Dir_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set Director Finance Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Finance_Action_Date</fullName>
        <field>Finance_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set Finance Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Next_WRF_CPM_Approval_Start_Time</fullName>
        <description>Set Next WRF CPM Approval Start Time</description>
        <field>Current_Approval_Start__c</field>
        <formula>IF(ISPICKVAL(Approval_Status__c, &apos;Pending Approval&apos;), 
BLANKVALUE(SVP_Action_Date__c, 
BLANKVALUE(Field_Sales_VP_Action_Date__c, 
BLANKVALUE(Finance_Dir_Action_Date__c, 
BLANKVALUE(VP_Sales_Ops_Action_Date__c, 
BLANKVALUE(RVP_Action_Date__c, 
BLANKVALUE(Sr_Strategy_Dir_Action_Date__c, 
BLANKVALUE(Finance_Action_Date__c, 
BLANKVALUE(Public_Sector_VP_Action_Date__c, 
BLANKVALUE(RSD_Action_Date__c, 
BLANKVALUE(Strategy_Director_Action_Date__c, 
BLANKVALUE(DSM_Action_Date__c, 
BLANKVALUE(Compliance_Mgr_Action_Date__c, WRF_Date_CPM_Launched__c) 
))))))))))), NULL)</formula>
        <name>Set Next WRF CPM Approval Start Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Next_WRF_CPM_approver</fullName>
        <description>Set Next WRF CPM approver</description>
        <field>Current_Approver__c</field>
        <formula>IF(ISPICKVAL(Approval_Status__c, &apos;Pending Approval&apos;), 
IF( ((NOT(ISBLANK(Compliance_Mgr__c))) &amp;&amp; ISBLANK(Compliance_Mgr_Action_Date__c)), &apos;Compliance Mgr&apos;, 
IF( ((NOT(ISBLANK(DSM__c))) &amp;&amp; ISBLANK(DSM_Action_Date__c) ), &apos;DSM&apos;, 
IF( ((NOT(ISBLANK(Strategy_Director__c))) &amp;&amp; ISBLANK(Strategy_Director_Action_Date__c) ), &apos;Strategy Director&apos;, 
IF( ((NOT(ISBLANK(Regional_Dir__c))) &amp;&amp; ISBLANK(RSD_Action_Date__c) ), &apos;Regional Dir&apos;, 
IF( ((NOT(ISBLANK(Public_Sector_VP__c))) &amp;&amp; ISBLANK(Public_Sector_VP_Action_Date__c) ), &apos;Public Sector VP&apos;, 
IF( ((WRF_Finance__c) &amp;&amp; ISBLANK(Finance_Action_Date__c)), &apos;Finance&apos;, 
IF( ((NOT(ISBLANK(Sr_Strategy_Director__c))) &amp;&amp; ISBLANK(Sr_Strategy_Dir_Action_Date__c) ), &apos;Sr Strategy Director&apos;, 
IF( ((NOT(ISBLANK(Regional_VP__c))) &amp;&amp; ISBLANK(RVP_Action_Date__c) ), &apos;Regional VP&apos;, 
IF( ((NOT(ISBLANK(VP_Sales_Ops__c))) &amp;&amp; ISBLANK(VP_Sales_Ops_Action_Date__c) ), &apos;VP Sales Ops&apos;, 
IF( ((NOT(ISBLANK(Director_Finance__c))) &amp;&amp; ISBLANK(Finance_Dir_Action_Date__c) ), &apos;Director Finance&apos;, 
IF( ((NOT(ISBLANK(Field_Sales_VP__c))) &amp;&amp; ISBLANK(Field_Sales_VP_Action_Date__c) ), &apos;Field Sales VP&apos;, 
IF( ((NOT(ISBLANK(Sr_Vice_President__c))) &amp;&amp; ISBLANK(SVP_Action_Date__c) ), &apos;Sr Vice President&apos;, 
NULL)))))))))))), NULL)</formula>
        <name>Set Next WRF CPM approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Notify_Requestor_Flag</fullName>
        <description>Set Notify Requestor Flag</description>
        <field>Notify_Requester__c</field>
        <literalValue>1</literalValue>
        <name>Set Notify Requestor Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Priority</fullName>
        <description>Set Priority</description>
        <field>Priority</field>
        <literalValue>3-Medium</literalValue>
        <name>Set Priority</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Public_Sector_VP_Action_Date</fullName>
        <description>Set Public Sector VP Action Date</description>
        <field>Public_Sector_VP_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set Public Sector VP Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RCOE_Request_Owner</fullName>
        <description>Set RCOE Request Owner</description>
        <field>OwnerId</field>
        <lookupValue>RCOE</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set RCOE Request Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RSD_Action_Date</fullName>
        <field>RSD_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set RSD Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Catalog_Update</fullName>
        <description>Set RT - Catalog Update</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Catalog Update</literalValue>
        <name>Set RT - Catalog Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Contract_Amendment</fullName>
        <description>Set RT - Contract Amendment</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Contract Amendment</literalValue>
        <name>Set RT - Contract Amendment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Contract_Renewal</fullName>
        <description>Set RT - Contract Renewal</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Contract Renewal</literalValue>
        <name>Set RT - Contract Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Core_Creation</fullName>
        <description>Set RT - Core Creation</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Core Creation</literalValue>
        <name>Set RT - Core Creation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Core_Review</fullName>
        <description>Set RT - Core Review</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Core Review</literalValue>
        <name>Set RT - Core Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Customer_Needs_Service_Only_WITO</fullName>
        <description>Set RT - Customer Needs Service Only (WITO)</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Customer Needs Service Only (WITO)</literalValue>
        <name>Set RT - Customer Needs Service Only (WI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Deviated_Cost_Analysis</fullName>
        <description>RT - Deviated Cost Analysis</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Deviated Cost Analysis</literalValue>
        <name>Set RT - Deviated Cost Analysis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Equipment_Buy_Lease_Add</fullName>
        <description>Set RT - Equipment Buy/Lease/Add</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Equipment Buy/Lease/Add</literalValue>
        <name>Set RT - Equipment Buy/Lease/Add</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Information_CPM_Only</fullName>
        <description>Set RT - Information CPM Only</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Informational CPM Only</literalValue>
        <name>Set RT - Information CPM Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Legal_Contract_Review</fullName>
        <description>Set RT Legal/Contract Review</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Legal/Contract Review</literalValue>
        <name>Set RT Legal/Contract Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_MPS_Strategy_Assistance</fullName>
        <description>Set RT - MPS Strategy Assistance</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>MPS Strategy Assistance</literalValue>
        <name>Set RT - MPS Strategy Assistance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_New_Customer_GPO_RFP</fullName>
        <description>&quot;New Customer - GPO RFP -
TCPN, NIPA, Amerinet, Premier, MedAssets, US Communities, Chamber, Other&quot;</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>GPO RFP</literalValue>
        <name>Set RT &quot;New Customer - GPO RFP -</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_No_Pricing_Form_Compl_NDA_RFI</fullName>
        <description>Set RT - No Pricing (Form Compl/NDA/RFI)</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Pricing (Bid/RFP/Quote)</literalValue>
        <name>Set RT - No Pricing (Form Compl/NDA/RFI)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Software_Installation</fullName>
        <description>Set RT Software Installation</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Software Installation and/or Implementation</literalValue>
        <name>Set RT Software Installation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RT_Update_Expired_CPM</fullName>
        <description>Set RT - Update Expired CPM</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Update Expired CPM</literalValue>
        <name>Set RT - Update Expired CPM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_RVP_Action_Date</fullName>
        <field>RVP_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set RVP Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Request_Type_Merchant_Sales_Bid</fullName>
        <description>Set Request Type - Merchant Sales Bid</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Merchant Sales Bid</literalValue>
        <name>Set Request Type - Merchant Sales Bid</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SVP_Action_Date</fullName>
        <field>SVP_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set SVP Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sr_Strategy_Dir_Action_Date</fullName>
        <field>Sr_Strategy_Dir_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set Sr Strategy Dir Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Strategy_Dir_Action_Date</fullName>
        <field>Strategy_Director_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set Strategy Dir Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Survey_Alert_Date</fullName>
        <description>Set Survey Alert Date</description>
        <field>WRF_PS_Alert_Date__c</field>
        <formula>now() + 20</formula>
        <name>Set Survey Alert Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_VP_Field_Sales_Action_Date</fullName>
        <field>Field_Sales_VP_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set VP Field Sales Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_VP_Sales_Ops_Action_Date</fullName>
        <field>VP_Sales_Ops_Action_Date__c</field>
        <formula>Now()</formula>
        <name>Set VP Sales Ops Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Assign_Date</fullName>
        <field>WRF_Date_Time_Assigned__c</field>
        <formula>Now()</formula>
        <name>Set WRF Assign Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Auto_Close_Date</fullName>
        <field>Auto_Close_Date__c</field>
        <formula>Today() + 30</formula>
        <name>Set WRF Auto Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Awaiting_Info_Date</fullName>
        <field>WRF_Date_Time_Awaiting_Info__c</field>
        <formula>Now()</formula>
        <name>Set WRF Awaiting Info Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_CPM_Completed_Date</fullName>
        <field>WRF_Date_CPM_Completed__c</field>
        <formula>Now()</formula>
        <name>Set WRF CPM Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_CPM_Launch_Date</fullName>
        <field>WRF_Date_CPM_Launched__c</field>
        <formula>Now()</formula>
        <name>Set WRF CPM Launch Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Case_Owner</fullName>
        <description>Set WRF Case Owner</description>
        <field>OwnerId</field>
        <lookupValue>Work_Request_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Set WRF Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Case_Review</fullName>
        <field>WRF_Date_Time_Case_Review__c</field>
        <formula>Now()</formula>
        <name>Set WRF Case Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Clear_Auto_Close_Date</fullName>
        <field>Auto_Close_Date__c</field>
        <name>Set WRF Clear Auto Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Clear_Field_Action_Date</fullName>
        <field>Field_Action_Date__c</field>
        <name>Set WRF Clear Field Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Description</fullName>
        <description>Set WRF Description</description>
        <field>Description</field>
        <formula>IF((ISNULL(ParentId) || ISBLANK(ParentId)),&quot;&quot;,&quot;Revisit - &quot;) &amp; ACCT_Name__c &amp; &quot; - &quot; &amp; TEXT(WRF_Request_Type__c) &amp; &quot; - &quot; &amp; CaseNumber</formula>
        <name>Set WRF Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Field_Action_Date</fullName>
        <field>Field_Action_Date__c</field>
        <formula>Today()</formula>
        <name>Set WRF Field Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_RT_Automatic_Toner_Replenishme</fullName>
        <description>Set WRF RT - Automatic Toner Replenishment (ATR)</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Automatic Toner Replenishment (ATR)</literalValue>
        <name>Set WRF RT - Automatic Toner Replenishme</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_RT_MPS_Assessment</fullName>
        <description>Set WRF RT - MPS Assessment</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>MPS Assessment</literalValue>
        <name>Set WRF RT - MPS Assessment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_RT_MPS_Quote</fullName>
        <description>Set WRF RT - MPS Quote</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>MPS Quote</literalValue>
        <name>Set WRF RT - MPS Quote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_RT_Other_MPS</fullName>
        <description>Set WRF RT - Other MPS</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Other MPS</literalValue>
        <name>Set WRF RT - Other MPS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_RT_Pricing_Bid_RFP_Quote</fullName>
        <description>Set WRF RT - Pricing (Bid/RFP/Quote)</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Pricing (Bid/RFP/Quote)</literalValue>
        <name>Set WRF RT - Pricing (Bid/RFP/Quote)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Reason_to_No_Field_Response</fullName>
        <description>Set WRF Reason to No Field Response</description>
        <field>Reason</field>
        <literalValue>No Field Response</literalValue>
        <name>Set WRF Reason to No Field Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Req_Type_Request_for_Information</fullName>
        <description>Set WRF Request Type - Request for Information</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Request for Information</literalValue>
        <name>Set WRF Req Type Request for Information</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_Comparison_Green</fullName>
        <description>Set WRF Request Type - Comparison Green</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Comparison Green</literalValue>
        <name>Set WRF Request Type - Comparison Green</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_Conversion_to_Pri</fullName>
        <description>Set WRF Request Type - Conversion to Pricing Strategy</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>PS - Customer Conversion</literalValue>
        <name>Set WRF Request Type - Conversion to Pri</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_FCO</fullName>
        <description>Set Request Type - Form Completion Only</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Form Completion Only</literalValue>
        <name>Set WRF Request Type FCO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_Full_Account_Revi</fullName>
        <description>Set WRF Request Type - Full Account Review</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Full Account Review</literalValue>
        <name>Set WRF Request Type - Full Account Revi</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_New_Agreement</fullName>
        <description>Set WRF Request Type - New Agreement</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>New Agreement</literalValue>
        <name>Set WRF Request Type - New Agreement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_New_Contract</fullName>
        <description>Set WRF Request Type - New Contract</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>New Contract</literalValue>
        <name>Set WRF Request Type - New Contract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_Official_RFP_RFQ</fullName>
        <description>Set WRF Request Type - Official RFP/RFQ</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Official RFP/RFQ</literalValue>
        <name>Set WRF Request Type - Official RFP/RFQ</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_Other_Product_Line</fullName>
        <description>Set WRF Request Type - Other Product Line</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Other Product Line</literalValue>
        <name>Set WRF Request Type - Other Product Lin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_PS_NC</fullName>
        <description>Set WRF Request Type - Pricing Strategy - New Contract</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>PS - New Contract</literalValue>
        <name>Set WRF Request Type - Pricing Strategy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_PS_NPP</fullName>
        <description>Set WRF Request Type - Pricing Strategy - New Prospect Pricing</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>PS - Pricing</literalValue>
        <name>Set WRF Request Type - Pricing Strategy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_Pricing_Only</fullName>
        <description>Set WRF Request Type - Pricing Only</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>Pricing Only</literalValue>
        <name>Set WRF Request Type - Pricing Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Request_Type_Pricing_Strategy</fullName>
        <description>Set WRF Request Type -Pricing Strategy - Formal Bid/RFP</description>
        <field>WRF_Request_Type__c</field>
        <literalValue>PS - RFP/RFQ</literalValue>
        <name>Set WRF Request Type -Pricing Strategy -</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Subject</fullName>
        <field>Subject</field>
        <formula>IF((ISNULL(ParentId) || ISBLANK(ParentId)),&quot;&quot;,&quot;Revisit - &quot;) &amp; ACCT_Name__c &amp; &quot; - &quot; &amp; TEXT(WRF_Request_Type__c) &amp; &quot; - &quot; &amp; CaseNumber</formula>
        <name>Set WRF Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Survey_Date</fullName>
        <description>Set WRF Survey Date</description>
        <field>WRF_PS_Survey_Date__c</field>
        <formula>now()</formula>
        <name>Set WRF Survey Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Subject_Upd_4_Terms</fullName>
        <description>Account Name and  Request Type</description>
        <field>Subject</field>
        <formula>Account.Name + &quot; - &quot; + TEXT(WRF_Request_Type__c)</formula>
        <name>Subject Upd 4 Terms</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SupportType_field_updte</fullName>
        <field>Support_Type__c</field>
        <literalValue>Seismic</literalValue>
        <name>SupportType field updte</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Owner_ISOSUPOORT_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>ISOSUPPORT</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Support Owner ISOSUPOORT Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Owner_to_General_Maint_Requests</fullName>
        <description>To create support owner to General Maintenance</description>
        <field>OwnerId</field>
        <lookupValue>General_Maint_Requests_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Support Owner to General Maint Requests</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Owner_to_L1</fullName>
        <field>OwnerId</field>
        <lookupValue>L1_Sales_Admin_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Support Owner to L1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Owner_to_L2</fullName>
        <field>OwnerId</field>
        <lookupValue>L2_Support_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Support Owner to L2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Owner_to_L3_Pricing</fullName>
        <field>OwnerId</field>
        <lookupValue>L3_Support_Queue_Pricing</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Support Owner to L3 Pricing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Owner_to_L3_SalesOps</fullName>
        <field>OwnerId</field>
        <lookupValue>L3_Support_Queue_SalesOps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Support Owner to L3 SalesOps</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Owner_to_L3_WRF</fullName>
        <field>OwnerId</field>
        <lookupValue>L3_Support_Queue_WRF</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Support Owner to L3 WRF</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Owner_to_ODN_Account_Maint</fullName>
        <field>OwnerId</field>
        <lookupValue>ODN_General_Account_Maintenance</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Support Owner to ODN Account Maint</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Status_Awaiting_Info</fullName>
        <description>Support Status = Awaiting Info</description>
        <field>Status</field>
        <literalValue>Awaiting Information</literalValue>
        <name>Support Status = Awaiting Info</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Status_Cancelled</fullName>
        <description>Support Status = Cancelled</description>
        <field>Status</field>
        <literalValue>Cancelled</literalValue>
        <name>Support Status = Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Status_New</fullName>
        <description>Support Status = New</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Support Status = New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Status_to_BU</fullName>
        <field>Status</field>
        <literalValue>Business Unit Action</literalValue>
        <name>Support Status to BU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Sub_Type</fullName>
        <field>Support_Sub_Type__c</field>
        <name>Support Sub Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Sub_Type_c_update</fullName>
        <description>Support_Sub_Type__c field update</description>
        <field>Support_Sub_Type__c</field>
        <name>Support_Sub_Type__c update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Type</fullName>
        <field>Support_Type__c</field>
        <literalValue>ISO</literalValue>
        <name>Support Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Type_to_Canada_Sales_Admins</fullName>
        <description>Support Type to Canada Sales Admins</description>
        <field>Support_Type__c</field>
        <literalValue>Canada Sales Admin</literalValue>
        <name>Support Type to Canada Sales Admins</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Support_Update</fullName>
        <description>Update the owner to channel support team</description>
        <field>OwnerId</field>
        <lookupValue>Channel_Support_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Support Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Training_update</fullName>
        <description>Update the owner to channel enablement team</description>
        <field>OwnerId</field>
        <lookupValue>Channel_Enablement_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Training update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UnCkeckNotify</fullName>
        <field>Notify_Requester__c</field>
        <literalValue>0</literalValue>
        <name>UnCkeckNotify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Current_Appover3</fullName>
        <field>Current_Approver__c</field>
        <formula>AM_Approver4__c</formula>
        <name>Update Current Appover</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Current_Approval</fullName>
        <field>Current_Approver__c</field>
        <formula>AM_Approver2__c</formula>
        <name>Update Current Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Current_Approval1</fullName>
        <field>Current_Approver__c</field>
        <formula>AM_Approver3__c</formula>
        <name>Update Current Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Current_Approver2</fullName>
        <field>Current_Approver__c</field>
        <formula>AM_Approver3__c</formula>
        <name>Update Current Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Description_for_AR_Requests</fullName>
        <field>Description</field>
        <formula>Support_Requester__r.FirstName  + &quot; &quot; + Support_Requester__r.LastName + &quot; is requesting &quot; + Text(WRF_Request_Type__c) + &quot; for Account [&quot; +  Account.Name + &quot;].&quot;</formula>
        <name>Update Description for AR Requests</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_GT_Case_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GT_Level_1_Support_queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update GT Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_Global_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Global_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner Global Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_CT_Implementation</fullName>
        <description>Customer Transition Implementation</description>
        <field>OwnerId</field>
        <lookupValue>Customer_Transition_Implementation</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to CT Implementation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_ISOSupport_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>L3_Support_Queue_SalesOps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to ISOSupport Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_SalesOps_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>L3_Support_Queue_SalesOps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner to SalesOps Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sprint_Completed_Date</fullName>
        <field>IT_Sprint_Complete_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Sprint Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subject</fullName>
        <description>Update subject to include Support Type, SubType and Acct</description>
        <field>Subject</field>
        <formula>Text(Support_Type__c) + &apos; &apos; +  Text(Support_Sub_Type__c)  + &apos; &apos; +  Support_Requester__r.FirstName + &apos; &apos; + Support_Requester__r.LastName</formula>
        <name>Update Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Support_Type_2_Deployment</fullName>
        <description>Update Support Type 2 Deployment</description>
        <field>Support_Type__c</field>
        <literalValue>Deployment</literalValue>
        <name>Update Support Type 2 Deployment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_fields_from_Backlog_to_InProgress</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Update fields from Backlog to InProgress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_owner_SPC_Processing_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SPC_Processing_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update owner SPC Processing Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_owner_Savo_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Savo_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update owner Savo Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_Deployment_Queue</fullName>
        <description>Update to Deployment Queue</description>
        <field>OwnerId</field>
        <lookupValue>Deployment_Team</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update to Deployment Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_GT_Report_Queue</fullName>
        <description>Once create this record should go to the GT Report Queue</description>
        <field>OwnerId</field>
        <lookupValue>GT_Report_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update to GT Report Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_HCL_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>SA_Reports_Adhoc_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update to HCL Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WRF_Requestor_Email</fullName>
        <field>Requestor_Email_2__c</field>
        <formula>WRF_Requestor__r.Email</formula>
        <name>WRF Requestor Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_IT_Date</fullName>
        <field>IT_Assigned_Date__c</field>
        <formula>Now()</formula>
        <name>update IT Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updaterecordtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>IT_Cases</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>updaterecordtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Account Maintenance Email Notification</fullName>
        <actions>
            <name>Send_Email_Notification_when_the_case_closed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <description>Send email to the support requester when the case status is closed and record type is Account Maintenance</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Acct Maint SLA Receipt</fullName>
        <actions>
            <name>Notify_Case_Receipt</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and  not  (( 2 or 3 ) and 4 )</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>CMS Access,Vendavo Access,Grandparent Creation or Maintenance,Parent to Grandparent move,Child to Parent move,Change Rep on Grandparent,Add/Remove Customer Core List,Update Custom NCC,Net Pricer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>&quot;Core Creation, Revision, or Deletes&quot;,Pricing Question,Turn off Universal Pricing,Change Current NCC on Account,Request a Core Icon</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.What_category_does_your_request_fall_int__c</field>
            <operation>equals</operation>
            <value>CMS/Vendavo User Access,Grandparent/Parent Setup or Moves,Pricing Maintenance</value>
        </criteriaItems>
        <description>SLA receipt to Sales Rep of expected turn-around time.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Approved for Analyst Assignment</fullName>
        <actions>
            <name>Approved_for_Analyst_Assignment_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Proprietary Item Setup,No Pricing (Form Completion/NDA/RFI),&quot;Form Completion (NDA, W-9, Vendor, etc)&quot;,Legal - New Agreement,Legal - Modify Existing Agreement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Alternate Item Request,Core Creation,Deviated Cost Analysis,Hosted Catalog Creation/Update,MPS Strategy Assistance,MPS Assessment,MPS Quote,Other MPS,Automatic Toner Replenishment (ATR),Equipment Buy/Lease/Add,Equipment Buy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Service &amp; Supplies Only (WITO),Equipment Lease,OP Margin Management</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <description>Automatically marks &apos;Approved for Analyst Assignment&apos; as True if it meets the criteria below...</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign Case Owner to Commisioning</fullName>
        <actions>
            <name>Changine_Case_Owner_to_Commisioning</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordtypeName__c =&apos;Channel Partner&apos;,Via_Partner_Community__c=TRUE,ISPICKVAL(Department__c,&apos;Commissioning&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assign Case Owner to Marketing</fullName>
        <actions>
            <name>Changine_Case_Owner_to_MArketing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordtypeName__c =&apos;Channel Partner&apos;,Via_Partner_Community__c=TRUE,ISPICKVAL(Department__c,&apos;Marketing&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assign Case Owner to Support team</fullName>
        <actions>
            <name>Changing_Case_Owner_to_Supporting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordtypeName__c =&apos;Channel Partner&apos;,Via_Partner_Community__c=TRUE,OR(ISPICKVAL(Department__c,&apos;Portal Technical Issues&apos;),ISPICKVAL(Department__c,&apos;Sales Support&apos;),ISPICKVAL(Department__c,&apos;General Questions&apos;)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assign Case Owner to Training</fullName>
        <actions>
            <name>Changine_Case_Owner_to_Training</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordtypeName__c =&apos;Channel Partner&apos;,Via_Partner_Community__c=TRUE,ISPICKVAL(Department__c,&apos;Training&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assign to Business_IT</fullName>
        <actions>
            <name>AssigtoBusiness</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MakeAssigtoblank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support,IT Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Assign_To__c</field>
            <operation>equals</operation>
            <value>Business Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Lost Device</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Assign to Deployment Queue</fullName>
        <actions>
            <name>Update_Support_Type_2_Deployment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_to_Deployment_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Deployment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Change Customer Segmentation Code</value>
        </criteriaItems>
        <description>Assign to Deployment Queue</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assign to IT Person</fullName>
        <actions>
            <name>Primary_Assignment</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support,IT Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IT_Assignment__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Assign to IT_Buss</fullName>
        <actions>
            <name>Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>AssigntoBlank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AssigntoIT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support,IT Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Assign_To__c</field>
            <operation>equals</operation>
            <value>IT Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Salesprism</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Assign to Transition Calendar Owner</fullName>
        <actions>
            <name>AssignMumford</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Transition</value>
        </criteriaItems>
        <description>This rule is set to assign all Work Requests with a Reason of &quot;Transition&quot; to go to Rich Mumford -- Change to Monica Arbaleaz</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Auto Cancel Account Maintenance Case</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>notEqual</operation>
            <value>General Migration Questions,Assign Implementation Manager</value>
        </criteriaItems>
        <description>Auto Cancel Account Maintenance Case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Account_Maint_Requestor_Auto_Close_Notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Set_Action_Taken_to_Cancelled</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_WRF_Reason_to_No_Field_Response</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Support_Status_Cancelled</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>BSD Acct Maint SLA Receipt</fullName>
        <actions>
            <name>BSD_Acct_Maint_SLA_Receipt</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND(  2  or 3 )AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>CMS Access,Vendavo Access,Grandparent Creation or Maintenance,Parent to Grandparent move,Change Rep on Grandparent,Add/Remove Customer Core List,Update Custom NCC,Net Pricer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>&quot;Core Creation, Revision, or Deletes&quot;,Pricing Question,Turn off Universal Pricing,Change Current NCC on Account,Request a Core Icon</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.What_category_does_your_request_fall_int__c</field>
            <operation>equals</operation>
            <value>CMS/Vendavo User Access,Grandparent/Parent Setup or Moves,Pricing Maintenance</value>
        </criteriaItems>
        <description>SLA receipt to Sales Rep of expected turn-around time.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Backlog Notification</fullName>
        <actions>
            <name>Send_Email_to_Requester</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Requester__c</field>
            <operation>notEqual</operation>
            <value>Salesforce,Jeffrey Miller,Melissa Lopez,Indra Varada,Carol Wilkie,Mohamad Elkhatib,Francisco Peleato,Raji Mathew</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,Backlog</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Completed Notification for Sales Ops</fullName>
        <actions>
            <name>Case_Completed_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 3) AND 2 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.IT_BU_Reviewer__c</field>
            <operation>equals</operation>
            <value>Michael Houng</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Outside_Support_Rep__c</field>
            <operation>equals</operation>
            <value>Michael Houng</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>SalesOps Queue</value>
        </criteriaItems>
        <description>Email notification to the support requester when a case is closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Notify IT Assignee</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.IT_Assignment__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Change Custom NCC Request to BSD Pricing</fullName>
        <actions>
            <name>BSD_pricing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Change Current NCC on Account,General Migration Questions</value>
        </criteriaItems>
        <description>When the request type= Change Custom NCC and General Migration Questions on Account, change support owner to BSD pricing</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Change Rep on Grandparent Request to BSD Pricing</fullName>
        <actions>
            <name>Send_to_BSD_Pricing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Change Rep on Grandparent</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close case After 30 Days of WRF Task Completion</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.All_Task_Closed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Close_Case</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Communities Invoice Confirmation</fullName>
        <actions>
            <name>Communities_Invoice_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>AM Communities</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Portal Request</value>
        </criteriaItems>
        <description>Communities v2 - Template for Invoice Form Confirmation</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification - Fast Track in IT Queue</fullName>
        <actions>
            <name>Automatic_email_for_fasttrack</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Email notification that is sent when new Fast Track tickets are received in the IT Queue.</description>
        <formula>ISCHANGED( OwnerId ) &amp;&amp;  Owner:Queue.QueueName == &apos;IT Queue&apos; &amp;&amp;  ISPICKVAL( IT_Track__c ,&apos;Fast Track&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification - Prod Fix in IT Queue</fullName>
        <actions>
            <name>Email_will_trigger_when_a_Production_Fix_ticket_is_moved_to_the_IT_Queue</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Email notification that is sent when new Production Fix tickets are received in the IT Queue.</description>
        <formula>ISCHANGED( OwnerId ) &amp;&amp;  Owner:Queue.QueueName == &apos;IT Queue&apos; &amp;&amp;  ISPICKVAL( IT_Track__c ,&apos;Production Fix&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email to Case %3A Requester Notification</fullName>
        <actions>
            <name>Email_to_Case_Requestor_Response_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Requester__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>Enterprise Support</value>
        </criteriaItems>
        <description>New email response for new cases that are only created by email-to-case, that originate from the Sales.Admin@officedepot.com and Salesforce@officedepot.com mail boxes</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Email to Case %3A Requester Notification for Deployment  Request</fullName>
        <actions>
            <name>Email_Email_to_Deployment_Case_Requestor_Response</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Deployment Team</value>
        </criteriaItems>
        <description>New email response for new Deployment cases that are only created by email-to-case, that originate from the Deployment@officedepot.com</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GT Closed Case</fullName>
        <actions>
            <name>GT_Closed_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GT Implementation,GT Legal Review,GT Rebate Inquiries,GT Cross Reference Task,GT Bid Cost,GT Pricing &amp; Proposal Request,GT Report Request,GT Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.AM_Assigned_To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Status Closed notification to support requester</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GT In Progress Case</fullName>
        <actions>
            <name>GT_Send_Notification_to_Support_Requester</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GT Implementation,GT Legal Review,GT Rebate Inquiries,GT Cross Reference Task,GT Bid Cost,GT Pricing &amp; Proposal Request,GT Report Request,GT Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.AM_Assigned_To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Status In Progress notification to the Requester</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GT New Case Creation</fullName>
        <actions>
            <name>GT_Send_Notification_to_Assigned_To</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GT Implementation,GT Legal Review,GT Rebate Inquiries,GT Cross Reference Task,GT Bid Cost,GT Pricing &amp; Proposal Request,GT Report Request,GT Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.AM_Assigned_To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Status New notification to the  Assigned To User</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lost Device Attributes 1</fullName>
        <actions>
            <name>LostDevice_Critical_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Add_Task_Classification</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AssigntoIT</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Change_BU_Reviewer_to_Dataloader</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Lost Device</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IT_Classification__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Change Classification to Task, Add Impact Description and Change BU Reviewer to &quot;Dataloader&quot;.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ODN Account Maint Queue</fullName>
        <actions>
            <name>Support_Owner_to_ODN_Account_Maint</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Related_Account_Record_Type__c</field>
            <operation>equals</operation>
            <value>Customer (OfficeMax)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <description>Route Clicktools account maintenance support tickets to ODN Account Maint Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ODS Account Maint Request Queue</fullName>
        <actions>
            <name>Support_Owner_to_General_Maint_Requests</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <description>Route Clicktools account maintenance support tickets to General Maint Request Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PRM Email Notification On Case Closed</fullName>
        <actions>
            <name>PRM_Email_Notification_On_Case_Closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Channel Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PRM Email Notification On Case Creation</fullName>
        <actions>
            <name>PRM_Email_Notification_On_Case_Creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Channel Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PRM case routing to Commission team</fullName>
        <actions>
            <name>Commission_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Channel Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Department__c</field>
            <operation>equals</operation>
            <value>Commissioning</value>
        </criteriaItems>
        <description>All the cases from Partner community are directed to channel commission  team</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PRM case routing to marketing team</fullName>
        <actions>
            <name>Marketing_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Channel Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Department__c</field>
            <operation>equals</operation>
            <value>Marketing</value>
        </criteriaItems>
        <description>All the cases from Partner community are directed to channel marketing team</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PRM case routing to support team</fullName>
        <actions>
            <name>Support_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Channel Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Department__c</field>
            <operation>contains</operation>
            <value>Portal Technical Issues,Sales Support,General Questions</value>
        </criteriaItems>
        <description>All the cases from Partner community are directed to channel support team</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PRM case routing to training team</fullName>
        <actions>
            <name>Training_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Channel Portal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Department__c</field>
            <operation>equals</operation>
            <value>Training</value>
        </criteriaItems>
        <description>All the cases from Partner community are directed to channel enablement team</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Partner Case default queue</fullName>
        <actions>
            <name>Assigned_Partner_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Case</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Production Issues to be InProgress</fullName>
        <actions>
            <name>Update_fields_from_Backlog_to_InProgress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.IT_Environment__c</field>
            <operation>equals</operation>
            <value>Production</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Backlog</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Cases,Support</value>
        </criteriaItems>
        <description>Production Issues to be InProgress</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RCOE Auto Reply</fullName>
        <actions>
            <name>RCOE_Auto_Reply</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Cases,Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>RCOE Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Type__c</field>
            <operation>equals</operation>
            <value>Business Reviews,Reports</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rebate Request - Rebate %28Compliance Team Only%29</fullName>
        <actions>
            <name>Send_an_email_to_complianceadmin_rebates_officedepot_com</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Rebate Creation - Complex</value>
        </criteriaItems>
        <description>Notification to complianceadmin-rebates@officedepot.com when ticket assigned to rebate queue</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Rebate Request Notification</fullName>
        <actions>
            <name>Rebate_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Rebate Creation - Complex,Rebate Revision - Complex</value>
        </criteriaItems>
        <description>Notification to bsd.customerrebates@officedepot.com when ticket assigned to rebate queue</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Request Type</fullName>
        <actions>
            <name>Approved_for_Analyst_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_RFP_RFQ__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>When request type is blank, automatically check Approved for Analyst Assignment</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Requester Notification</fullName>
        <actions>
            <name>Notify_Case_Creator</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UnCkeckNotify</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 and ((2 and 3) OR (4 and 5)) and 6 and !7</booleanFilter>
        <criteriaItems>
            <field>Case.Notify_Requester__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Requester__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Email,Lost Device</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed,Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Requester__c</field>
            <operation>notContain</operation>
            <value>Salesforce</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SCOE Cases</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RequesterReviewClosed72</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>SalesOps Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SalesOps_Status__c</field>
            <operation>equals</operation>
            <value>Requester Review</value>
        </criteriaItems>
        <description>Close the case after 72 hrs of no action once we place the ticket.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Alert_for_Requestor72</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>SalesOp_Case_Status_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Requestor Region</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Cases,Support</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Route to AR</fullName>
        <actions>
            <name>Account_Request_Support_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Case_Owner_to_AR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Subject_Upd_4_Terms</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Description_for_AR_Requests</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Early Pay Discount Terms Requests,Extended Payment Terms Requests</value>
        </criteriaItems>
        <description>Routing Extended Terms and Early Discount to the AR Queue</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Route to Account Maint</fullName>
        <actions>
            <name>Case_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>General Maint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <description>Route to Account Maint</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Route to Customer Transition Implemention Queue</fullName>
        <actions>
            <name>Update_Owner_to_CT_Implementation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Request Implementation Manager</value>
        </criteriaItems>
        <description>When the request type = Request Implementation change support owner to Customer Transition Implementation</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Route to Diversity Ops</fullName>
        <actions>
            <name>Case_Owner_to_Diversity_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Diversity Email,Partner Email</value>
        </criteriaItems>
        <description>Route to Diversity Ops</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Route to Global Support Queue</fullName>
        <actions>
            <name>Update_Owner_Global_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Global Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Route to ISOSupport</fullName>
        <actions>
            <name>Support_Sub_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Support_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Owner_to_ISOSupport_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>ISOSupport</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <description>Route email to case support ticket to SalesOps Queue when received from ISOSalesforce@officedepot.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Route to ODN Account Maint</fullName>
        <actions>
            <name>Case_Owner_ODN</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>ODN General Maint</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <description>Route to ODN Account Maint</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Route to RCOE</fullName>
        <actions>
            <name>Case_Owner_RCOE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>RCOE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <description>Route to RCOE Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Route to SA Recurring Reports Queue</fullName>
        <actions>
            <name>Change_Queue_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>do-not-reply@officemax.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>do-not-reply@officedepot.com</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Route to SA Reports Adhoc Queue</fullName>
        <actions>
            <name>Update_to_HCL_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>SA Reports Adhoc</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Route to SPC Processing</fullName>
        <actions>
            <name>Update_owner_SPC_Processing_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>SPC Processing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <description>Route to SPC Processing</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Route to Salesprism Queue</fullName>
        <actions>
            <name>Update_Owner_to_SalesOps_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Salesprism</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Route to Savo Queue</fullName>
        <actions>
            <name>Update_owner_Savo_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Savo</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Route to TAM Solutions Queue</fullName>
        <actions>
            <name>Case_Owner_TAM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Route to TAM Solutions Queue</description>
        <formula>(   ISNEW()  &amp;&amp;  text(Origin)==&apos;TAM Solutions&apos;  )   ||  (   ISCHANGED(Origin)  &amp;&amp; text(PRIORVALUE(Origin)) !=&apos;TAM Solutions&apos; &amp;&amp;      text(Origin)==&apos;TAM Solutions&apos;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Route to eCommerce</fullName>
        <actions>
            <name>Route_to_eCommerce</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>eCommerce – Field Support</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SCOE Case Assigned To Notification</fullName>
        <actions>
            <name>SCOE_Email_Alert_when_case_is_assigned_field_Assigned_To</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SCOE Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.AM_Assigned_To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Finance,Channel Partner,GT Legal Review,BSD Training,GT Admin Request,Enterprise Support,Workspace Interiors,GT Rebate Inquiries,GT FSA,GT Bid Cost,GT Sales Support,GT Implementation,GT Cross Reference Task,GT Pricing &amp; Proposal Request,Deployment Reques</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CPD New Opportunities,CPD General Support,CPD K12 Support,CPD Site Maintenance</value>
        </criteriaItems>
        <description>Send a notification on cases where assigned to field is populated. Used for SCOE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SCOE%3A FINANCE Send Case Closed Notification</fullName>
        <actions>
            <name>Finance_SCOE_Closed_case_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Finance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>IT Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>AM Communities,BSD Training,SalesOps - Pricing Compliance,Partner Case,eCommerce – Field Support,IT Release,GT Report Request,IT Cases,Work Request,Support,Account Maintenance,GT Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Route Case Closed Email to support requester from User</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SCOE%3A Internal Notification</fullName>
        <actions>
            <name>SCOE_Auto_Notification_on_Internal_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SCOE Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>IT Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Requester__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>SCOE Case creation notification to Support Requester (scoe button or support tab)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SCOE%3A Routing Case to SCOE Escalations Queue</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND  3</booleanFilter>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email,SCOE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SCOE Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>SCOE Escalations</value>
        </criteriaItems>
        <description>Route Email to Case to Escalations Queue from business.solutions@officedepot.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SCOE%3A Send Case Closed Notification</fullName>
        <actions>
            <name>Case_Closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SCOE Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>IT Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>AM Communities,BSD Training,SalesOps - Pricing Compliance,Partner Case,eCommerce – Field Support,IT Release,GT Report Request,IT Cases,Work Request,Support,Account Maintenance,GT Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Route Case Closed Email to support requester from business.solutions@officedepot.com</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Sales Operations - Pricing Compliance</fullName>
        <actions>
            <name>SalesOps_Pricing_Compliance_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SalesOps_Support_Requestor_Pricing_Compliance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SalesOps - Pricing Compliance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>SalesOps - Pricing Compliance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Cancelled</value>
        </criteriaItems>
        <description>Notify Support Requestor of Case submitted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Seismic field update</fullName>
        <actions>
            <name>SupportType_field_updte</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Support_Sub_Type_c_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Seismic</value>
        </criteriaItems>
        <description>to update support type field when an email to case is created from seismic</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Account Maint%2E Requestor Cancelled Notification</fullName>
        <actions>
            <name>Send_Account_Maint_Requestor_Cancelled_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Auto_Close_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Auto_Close_Date__c</field>
            <operation>notEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Send Account Maint. Requestor Cancelled Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Account Maint%2E Requestor Close Notification</fullName>
        <actions>
            <name>Send_Account_Maint_Requestor_Close_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>notEqual</operation>
            <value>Child to Parent move</value>
        </criteriaItems>
        <description>Send Account Maint. Requestor Close Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Account Maint%2E Requestor Close Notification for Child to Parent Move</fullName>
        <actions>
            <name>Send_Account_Maint_Requestor_Close_Notification_for_Child_to_Parent_Move</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Child to Parent move</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Account Maint%2E Requestor New Case Notification for Child to Parent Move</fullName>
        <actions>
            <name>Send_Account_Maint_Requestor_New_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Child to Parent move</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Email To Rep</fullName>
        <actions>
            <name>Rep_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>RevertEmailTriggerFlag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Notify_Requester__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Supplier</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Email for Acct Maint - Awaiting Info</fullName>
        <actions>
            <name>Send_Requestor_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Notify_Requestor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Hours_Awtng_Info_Current__c</field>
            <operation>greaterOrEqual</operation>
            <value>48</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Notify_Requester__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Send Email for Acct Maint - Awaiting Info</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Field Post Survey Email after 21 day of closure</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_PS_Alert_Date__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_PS_Survey_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Pricing_Analyst__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Send Field Post Survey Email after 21 day of closure</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Post_Survey_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send RCOE Requestor Close Notification</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>RCOE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Send RCOE Requestor CloseNotification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send RCOE Requestor Notification</fullName>
        <actions>
            <name>Send_Email_Alert_to_RCOE_Email_INbox</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_RCOE_Request_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>RCOE</value>
        </criteriaItems>
        <description>Send RCOE Requestor Notification</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SendEmailToWRFRequestor</fullName>
        <actions>
            <name>EmailAlertToWRFRequestor</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer (OfficeMax)</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set AccMaint Auto Close No Field Reponse</fullName>
        <actions>
            <name>Send_Account_Maint_Requestor_Auto_Close_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Support_Status_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Auto_Close_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Auto_Close_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IT_Action_Taken__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason</field>
            <operation>equals</operation>
            <value>No Field Response</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Default fields for Account Maint</fullName>
        <actions>
            <name>Set_Priority</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set Default fields for Account Maint</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Order Case Support Owner</fullName>
        <actions>
            <name>Set_Case_Owner_to_Non_Code_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordtypeName__c</field>
            <operation>equals</operation>
            <value>Order Case</value>
        </criteriaItems>
        <description>Set Tech Sales order case support owner to TechSales - NonCode so that the case is sent to OracleCX.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set RT - ATR for US Office Supplies</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_RT_Automatic_Toner_Replenishme</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Automatic Toner Replenishment (ATR),Help pricing and setting up Automatic To</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <description>Set RT - ATR for US Office Supplies</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Auto Close Date</fullName>
        <actions>
            <name>Set_WRF_Auto_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Auto Close No Field Reponse</fullName>
        <actions>
            <name>WRF_Autoclose_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Auto_Close_Date__c</field>
            <operation>lessOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Auto_Close_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF CPM Next Approver and Start Time</fullName>
        <actions>
            <name>Set_Next_WRF_CPM_Approval_Start_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Next_WRF_CPM_approver</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Approval_Status__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set WRF CPM Next Approver and Start Time</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Clear Auto Close Date</fullName>
        <actions>
            <name>Set_WRF_Clear_Auto_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Clear Field Action Date</fullName>
        <actions>
            <name>Set_WRF_Clear_Field_Action_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Field Action Date</fullName>
        <actions>
            <name>Set_WRF_Field_Action_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Field Email</fullName>
        <actions>
            <name>WRF_Field_Action_Reminder</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Notify_Requestor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Field_Notification__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Notify_Requester__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Owner</fullName>
        <actions>
            <name>Set_WRF_Case_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <description>Set WRF Owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF RT - Automatic Toner Replenishment %28ATR%29</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_RT_Automatic_Toner_Replenishme</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>Formal RFP/RFQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>Managed Print Services (MPS)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MPS_Request_Type__c</field>
            <operation>equals</operation>
            <value>Automatic Toner Replenishment (ATR)</value>
        </criteriaItems>
        <description>Set WRF RT - Automatic Toner Replenishment (ATR)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF RT - Customer Needs Service Only %28WITO%29</fullName>
        <actions>
            <name>Set_RT_Customer_Needs_Service_Only_WITO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>Managed Print Services (MPS)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MPS_Request_Type__c</field>
            <operation>equals</operation>
            <value>Customer Needs Service Only (WITO)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>Formal RFP/RFQ</value>
        </criteriaItems>
        <description>Set WRF RT - Customer Needs Service Only (WITO)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF RT - Equipment Buy%2FLease%2FAdd</fullName>
        <actions>
            <name>Set_RT_Equipment_Buy_Lease_Add</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>Managed Print Services (MPS)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MPS_Request_Type__c</field>
            <operation>equals</operation>
            <value>Equipment Buy/Lease/Add</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>Formal RFP/RFQ</value>
        </criteriaItems>
        <description>Set WRF RT - Equipment Buy/Lease/Add</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF RT - Legal%2FContract Review</fullName>
        <actions>
            <name>Set_RT_Legal_Contract_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>Managed Print Services (MPS)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MPS_Request_Type__c</field>
            <operation>equals</operation>
            <value>Legal/Contract Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>Formal RFP/RFQ</value>
        </criteriaItems>
        <description>Set WRF RT - Legal/Contract Review</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF RT - MPS Assessment</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_RT_MPS_Assessment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>Formal RFP/RFQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>Managed Print Services (MPS)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MPS_Request_Type__c</field>
            <operation>equals</operation>
            <value>MPS Assessment</value>
        </criteriaItems>
        <description>Set WRF RT - MPS Assessment</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF RT - MPS Quote</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_RT_MPS_Quote</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>Formal RFP/RFQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>Managed Print Services (MPS)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MPS_Request_Type__c</field>
            <operation>equals</operation>
            <value>MPS Quote</value>
        </criteriaItems>
        <description>Set WRF RT - MPS Quote</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF RT - Other MPS</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_RT_Other_MPS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>Formal RFP/RFQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>Managed Print Services (MPS)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MPS_Request_Type__c</field>
            <operation>equals</operation>
            <value>Other MPS</value>
        </criteriaItems>
        <description>Set WRF RT - Other MPS</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF RT - Software Installation and%2For ATR Implementation MPS</fullName>
        <actions>
            <name>Set_RT_Software_Installation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>Managed Print Services (MPS)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>startsWith</operation>
            <value>Software Installation and/or Impl</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MPS_Request_Type__c</field>
            <operation>equals</operation>
            <value>Software Installation and/or Implementation</value>
        </criteriaItems>
        <description>Set WRF RT - Software Installation and/or ATR Implementation MPS</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF RT - Software Installation and%2For ATR Implementation for US Office Supplies</fullName>
        <actions>
            <name>Set_RT_Software_Installation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>startsWith</operation>
            <value>Software Installation and/or Impl</value>
        </criteriaItems>
        <description>Set WRF RT - Software Installation and/or ATR Implementation
 for US Office Supplies</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Alternate Item Request</fullName>
        <actions>
            <name>RT_Alternate_Item_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Alternate Item Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type3__c</field>
            <operation>equals</operation>
            <value>Alternate Item Request</value>
        </criteriaItems>
        <description>Set WRF Request Type - Alternate Item Request</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Audit Request</fullName>
        <actions>
            <name>RT_Audit_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Audit Request</value>
        </criteriaItems>
        <description>Set WRF Request Type - Audit Request</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Catalog Update</fullName>
        <actions>
            <name>Set_RT_Catalog_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Catalog Update</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <description>Set WRF Request Type - Catalog Update</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Comparison Green</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_Comparison_Green</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Green Comparison Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type3__c</field>
            <operation>equals</operation>
            <value>Green Comparison Only</value>
        </criteriaItems>
        <description>Set WRF Request Type - Comparison Green</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - ComparisonPrivate Brand</fullName>
        <actions>
            <name>RT_Private_Brand_Comparison_Only</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Private Brand Comparison Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type3__c</field>
            <operation>equals</operation>
            <value>Private Brand Comparison Only</value>
        </criteriaItems>
        <description>Set WRF Request Type - ComparisonPrivate Brand</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Contract Amendment</fullName>
        <actions>
            <name>Set_RT_Contract_Amendment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Amendment</value>
        </criteriaItems>
        <description>Set WRF Request Type  - Contract Amendment</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Contract Extension</fullName>
        <actions>
            <name>RT_Contract_Extension</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Extension</value>
        </criteriaItems>
        <description>Set WRF Request Type  - Contract Extension</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Contract Renewal</fullName>
        <actions>
            <name>Set_RT_Contract_Renewal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Renewal</value>
        </criteriaItems>
        <description>Set WRF Request Type  - Contract Renewal</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Conversion to Pricing Strategy</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_Conversion_to_Pri</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Conversion to Pricing Strategy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <description>Set WRF Request Type - Conversion to Pricing Strategy</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Core Creation</fullName>
        <actions>
            <name>Set_RT_Core_Creation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Core Creation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <description>Set WRF Request Type - Core Creation</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Core Review</fullName>
        <actions>
            <name>Set_RT_Core_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Core Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <description>Set WRF Request Type - Core Review</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Deviated Cost Analysis</fullName>
        <actions>
            <name>Set_RT_Deviated_Cost_Analysis</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Deviated Cost Analysis</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <description>Set WRF Request Type - Deviated Cost Analysis</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Form Completion Only</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_FCO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Form Completion - I just need a customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner,Tech Depot</value>
        </criteriaItems>
        <description>Set WRF Request Type - Form Completion Only</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Full Account Review</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_Full_Account_Revi</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Full Account Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <description>Set WRF Request Type - Full Account Review</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - GARP</fullName>
        <actions>
            <name>RT_GARP</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Global Account Remediation Process(GARP)</value>
        </criteriaItems>
        <description>Set WRF Request Type - GARP</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - GPO</fullName>
        <actions>
            <name>RT_GPO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>New Pricing and/or Written Agreement,GPO Comparison</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prcng_Optns__c</field>
            <operation>excludes</operation>
            <value>Standalone (Custom - No Program)</value>
        </criteriaItems>
        <description>Set WRF Request Type  - GPO - 
TCPN, NIPA, Amerinet, Premier, MedAssets, US Communities, Chamber, Other</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - GPO RFP</fullName>
        <actions>
            <name>Set_RT_New_Customer_GPO_RFP</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Formal RFP/RFQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prcng_Optns__c</field>
            <operation>excludes</operation>
            <value>Standalone (Custom - No Program)</value>
        </criteriaItems>
        <description>Set RT  - &quot;New Customer - GPO RFP -
TCPN, NIPA, Amerinet, Premier, MedAssets, US Communities, Chamber, Other&quot;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Hosted Catalog Creation%2FUpdate</fullName>
        <actions>
            <name>RT_Hosted_Catalog_Creation_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Hosted Catalog Creation/Update</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <description>Set WRF Request Type - Hosted Catalog Creation/Update</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Information CPM Only</fullName>
        <actions>
            <name>Set_RT_Information_CPM_Only</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Informational CPM Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <description>Set WRF Request Type - Information CPM Only</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - MPS Strategy Assistance</fullName>
        <actions>
            <name>Set_RT_MPS_Strategy_Assistance</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>Formal RFP/RFQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>Managed Print Services (MPS)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.MPS_Request_Type__c</field>
            <operation>equals</operation>
            <value>MPS Strategy Assistance</value>
        </criteriaItems>
        <description>Set WRF Request Type - MPS Strategy Assistance</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Merchant Sales Bid</fullName>
        <actions>
            <name>Set_Request_Type_Merchant_Sales_Bid</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>startsWith</operation>
            <value>Need Merchandising/Strategy help</value>
        </criteriaItems>
        <description>Set WRF Request Type - Merchant Sales Bid</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - New Agreement</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_New_Agreement</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>New Written Agreement</value>
        </criteriaItems>
        <description>Set WRF Request Type - New Agreement</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - New Contract</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_New_Contract</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>New Pricing and/or Written Agreement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prcng_Strtgy__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Written_Agreement__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Set WRF Request Type - New Contract</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Official RFP%2FRFQ</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_Official_RFP_RFQ</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Formal RFP/RFQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prcng_Strtgy__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Set WRF Request Type - Official RFP/RFQ</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Pricing %28Bid%2FRFP%2FQuote%29</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_RT_Pricing_Bid_RFP_Quote</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DUP_Acct_Type__c</field>
            <operation>equals</operation>
            <value>Current Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_RFP_RFQ__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Set WRF Request Type - Pricing (Bid/RFP/Quote)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Pricing %28Bid%2FRFP%2FQuote%29 - MPS</fullName>
        <actions>
            <name>Set_RT_No_Pricing_Form_Compl_NDA_RFI</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>Managed Print Services (MPS)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_RFP_RFQ__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <description>Set WRF Request Type -Pricing (Bid/RFP/Quote) - MPS</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Pricing Only</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_Pricing_Only</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>New Pricing and/or Written Agreement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prcng_Strtgy__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Written_Agreement__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Set WRF Request Type - Pricing Only</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Pricing Strategy - New Contract</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_PS_NC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>New Pricing and/or Written Agreement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prcng_Strtgy__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Written_Agreement__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Set WRF Request Type - Pricing Strategy - New Contract</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Pricing Strategy - New Prospect Pricing</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_PS_NPP</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>New Pricing and/or Written Agreement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prcng_Strtgy__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Written_Agreement__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Set WRF Request Type - Pricing Strategy - New Prospect Pricing</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Proprietary Item Setup</fullName>
        <actions>
            <name>RT_Proprietary_Item_Setup</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Proprietary Item Setup</value>
        </criteriaItems>
        <description>Set WRF Request Type - Proprietary Item Setup</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Request for Information</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Req_Type_Request_for_Information</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>RFI -  The customer needs information to</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner,Tech Depot</value>
        </criteriaItems>
        <description>Set WRF Request Type - Request for Information</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type - Update Expired CPM</fullName>
        <actions>
            <name>Set_RT_Update_Expired_CPM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Update Expired CPM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <description>Set WRF Request Type - Update Expired CPM</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type -CA%2FTech Depot%2FMPS%2FCPD%2FCBS%2FFurniture</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_Other_Product_Line</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND ((2 AND 3) OR (4 AND 5 AND 6 AND 2)) AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>US Office Supplies/Paper/Toner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>Tech Depot</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
            <value>Form Completion - I just need a customer,RFI -  The customer needs information to</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>includes</operation>
            <value>Tech Depot</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>excludes</operation>
            <value>Managed Print Services (MPS)</value>
        </criteriaItems>
        <description>Set WRF Request Type -CA/Tech Depot/MPS/CPD/CBS/Furniture</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Request Type -Pricing Strategy - Formal Bid%2FRFP</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Request_Type_Pricing_Strategy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Formal RFP/RFQ</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prod_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Prcng_Strtgy__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Set WRF Request Type -Pricing Strategy - Formal Bid/RFP</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Reset Subject and Descr when Request Type Change</fullName>
        <actions>
            <name>Set_WRF_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request,Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Reset Subject and Descr when Request Type Change</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Survey Alert Date and Send alert on Completion</fullName>
        <actions>
            <name>Send_Requestor_Email_about_Closure_and_Survey</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Survey_Alert_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>Set WRF Survey Alert Date and Send alert on Completion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set WRF Survey Date</fullName>
        <actions>
            <name>Erase_Survey_Alert_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Survey_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_PS_Overall__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Set WRF Survey Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Critical Notification</fullName>
        <actions>
            <name>Critical_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.IT_Business_Impact__c</field>
            <operation>equals</operation>
            <value>Business Interruption</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>1-Critical</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Level 1</fullName>
        <actions>
            <name>Support_Owner_to_L1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND (8 AND 9) AND 10 AND 11</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalate_Level_3__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Review__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.InsideSupportRep__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Outside_Support_Rep__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.L3_Support_Rep__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Global Support,Lost Device</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
            <value>do-not-reply@officemax.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
            <value>do-not-reply@officedepot.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Is_Owner_Queue__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>Enterprise Support</value>
        </criteriaItems>
        <description>Routes Email to Case support Tickets to Support level 1 Queue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Level 1 On Create</fullName>
        <actions>
            <name>Support_Owner_to_L1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND (8 OR 9) AND 10</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalate_Level_3__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Review__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.InsideSupportRep__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Outside_Support_Rep__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.L3_Support_Rep__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Global Support,Lost Device</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
            <value>do-not-reply@officemax.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
            <value>do-not-reply@officedepot.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Is_Owner_Queue__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Support Level 2</fullName>
        <actions>
            <name>Support_Owner_to_L2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalate_Level_3__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Review__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.L3_Support_Rep__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.InsideSupportRep__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Level 3 Pricing</fullName>
        <actions>
            <name>Support_Owner_to_L3_Pricing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalate_Level_3__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Type__c</field>
            <operation>equals</operation>
            <value>Pricing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Sub_Type__c</field>
            <operation>equals</operation>
            <value>Pricing Self Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.L3_Support_Rep__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Level 3 SalesOps</fullName>
        <actions>
            <name>Support_Owner_to_L3_SalesOps</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalate_Level_3__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Type__c</field>
            <operation>notEqual</operation>
            <value>Pricing,WRF</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Sub_Type__c</field>
            <operation>notEqual</operation>
            <value>Pricing Self Service,WRF</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.L3_Support_Rep__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Lost Device</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Level 3 WRF</fullName>
        <actions>
            <name>Support_Owner_to_L3_WRF</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalate_Level_3__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Type__c</field>
            <operation>equals</operation>
            <value>WRF</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Sub_Type__c</field>
            <operation>equals</operation>
            <value>WRF</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Owner ISOSUPPORT Queue</fullName>
        <actions>
            <name>Support_Owner_ISOSUPOORT_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Inside Sales</value>
        </criteriaItems>
        <description>Support owner routed to ISOSUPPORT queue for Inside Sales profile.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Support Status to BU</fullName>
        <actions>
            <name>Case_Status_Update_To_BU</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Support_Status_to_BU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalate_Level_3__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Status to Case Review</fullName>
        <actions>
            <name>Case_Stage_to_Case_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Escalate_Level_3__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Review__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support Type P%26P Tools</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Support_Type__c</field>
            <operation>equals</operation>
            <value>P&amp;P Tools</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Support to IT Cases</fullName>
        <actions>
            <name>updaterecordtype</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(OR (OwnerId ==&apos;00GE0000000U4VA&apos;,OwnerId ==&apos;00GE0000000U7Uv&apos;),  $RecordType.Name ==&apos;Support&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update GT Admin Owner</fullName>
        <actions>
            <name>GT_Owner_to_GT_Admin_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Support_Type_to_Canada_Sales_Admins</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GT Admin Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>GT Admins</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update GT Case Owner</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GT Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>GT Admins,GT Alberta,GT BC,GT Eastern,GT Manitoba,GT Ontario,GT Saskatchewan</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_GT_Case_Owner</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update GT Email Request to GT Report Queue</fullName>
        <actions>
            <name>Update_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_to_GT_Report_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GT Report Request</value>
        </criteriaItems>
        <description>Send an Email notification to reportrequests@grandandtoy.com when a GT Report Request recordtype support case is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update IT Assigndate</fullName>
        <actions>
            <name>update_IT_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 and 3</booleanFilter>
        <criteriaItems>
            <field>Case.IT_Assigned_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>contains</operation>
            <value>IT Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>IT Cases,Support</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Sprint Completed Date when Sprint is Completed</fullName>
        <actions>
            <name>Update_Sprint_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR( AND(ISNEW(),INCLUDES(IT_Sprint_Numb__c , &quot;Completed Sprint&quot;),ISBLANK(IT_Sprint_Complete_Date__c )) , AND(ISCHANGED(IT_Sprint_Numb__c), INCLUDES(IT_Sprint_Numb__c , &quot;Completed Sprint&quot;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WRF - Auto Confirmation of Request</fullName>
        <actions>
            <name>WRF_Confirmation_Email_to_Requestor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>notEqual</operation>
            <value>Transition</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
            <value>margin.support@officedepot.com</value>
        </criteriaItems>
        <description>This will send an email to the requestor of a WRF automatically</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WRF - Set Awaiting Info Status Date</fullName>
        <actions>
            <name>Set_Notify_Requestor_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Awaiting_Info_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 )AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Information</value>
        </criteriaItems>
        <description>WRF - Set Awaiting Info Status Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WRF - Set Case Review Status Date</fullName>
        <actions>
            <name>Set_WRF_Case_Review</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 ) AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Case Review</value>
        </criteriaItems>
        <description>WRF - Set Case Review Status Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WRF - Set Open Status Date</fullName>
        <actions>
            <name>Set_WRF_Assign_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 ) AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <description>WRF - Set Open Status Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WRF CBFS%7CBeverage</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_ODP_Solutions__c</field>
            <operation>includes</operation>
            <value>Beverage Service Agreement,Cleaning Breakroom Facility Svcs (CBFS)</value>
        </criteriaItems>
        <description>Notification of a WRF created with an Adjacency.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WRF CPD</fullName>
        <actions>
            <name>WRF_Adjacency_CPD</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_ODP_Solutions__c</field>
            <operation>includes</operation>
            <value>Copy Print Depot</value>
        </criteriaItems>
        <description>Notification of a WRF created with an Adjacency.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WRF Email to Account Owner</fullName>
        <actions>
            <name>CT_Email_Alert_Notification_Upon_WRF_Creation_Account_Owner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Transition</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WRF Furniture</fullName>
        <actions>
            <name>WRF_Adjacency_Furniture</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_ODP_Solutions__c</field>
            <operation>includes</operation>
            <value>Project Furniture</value>
        </criteriaItems>
        <description>Notification of a WRF created with an Adjacency.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WRF Initial Approval Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Approved_for_Analyst_Assignment__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Approval_Status__c</field>
            <operation>equals</operation>
            <value>Pending Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Regional_Dir__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>WRF_Initial_Approval_Reminder</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WRF MPS</fullName>
        <actions>
            <name>WRF_Adjacency_MPS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_ODP_Solutions__c</field>
            <operation>includes</operation>
            <value>Managed Print Services</value>
        </criteriaItems>
        <description>Notification of a WRF created with an Adjacency.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WRF Pricing Task Notif</fullName>
        <actions>
            <name>WRF_Assessment_Email_to_Sales_Rep_DSM_and_MD</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_Task_Notification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Task_Notification__c</field>
            <operation>contains</operation>
            <value>P</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed,Cancelled</value>
        </criteriaItems>
        <description>confirmation email to be sent to Rep, DSM and MD for WRFs submitted to pricing.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WRF Receipt Notification %26 Attachment Req</fullName>
        <actions>
            <name>WRF_Requestor_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Workspace Interiors%3A Send Email to Assigned to and Requester</fullName>
        <actions>
            <name>Email_Alert_to_Requester</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Workspace_Interiors_Support_Assigned_to_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordtypeName__c</field>
            <operation>equals</operation>
            <value>Workspace Interiors</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.AM_Assigned_To__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ZeroTasksWRFAutoClosed</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Total_WRF_Tasks__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Total_WRF_Tasks_Remaining__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New,Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Approval_Status__c</field>
            <operation>notEqual</operation>
            <value>Pending Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>notEqual</operation>
            <value>ODN Rebate Entry</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_Status_to_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Primary_Assignment</fullName>
        <assignedTo>odsfa.odsfaodsfa@officedepot.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>New</status>
        <subject>Primary Assignment</subject>
    </tasks>
</Workflow>
