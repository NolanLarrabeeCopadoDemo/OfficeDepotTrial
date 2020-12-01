<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_File_Sent_for_Review</fullName>
        <description>Email: File Sent for Review</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/File_Sent_for_Review</template>
    </alerts>
    <alerts>
        <fullName>Email_File_Sent_for_Review2</fullName>
        <description>Email: File Sent for Review</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/File_Sent_for_Review</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_for_Disposition_Code_Rebate</fullName>
        <ccEmails>complianceadmin-.rebates@officedepot.com</ccEmails>
        <description>Email Notification for Disposition Code Rebate</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/WRF_Exisiting_WRF_Open</template>
    </alerts>
    <alerts>
        <fullName>Email_Pricing_Task_Completed</fullName>
        <description>Email: Pricing Task Completed</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Pricing_Task_Complete</template>
    </alerts>
    <alerts>
        <fullName>New_WRF_Task_Remediation</fullName>
        <ccEmails>Lifecycle.Remediation@officedepot.com</ccEmails>
        <description>New WRF Task Remediation</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>New_WRF_Task_Transition</fullName>
        <ccEmails>customertransitionrequests@officedepot.com</ccEmails>
        <description>New WRF Task Transition</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Notify_WRF_Creator_on_Complete</fullName>
        <description>Notify WRF Creator on Complete</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/WRF_Task_Complete_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_to_B2B_eContent</fullName>
        <ccEmails>ec.customcatalogs@officedepot.com</ccEmails>
        <description>Send Email Notification to B2B eContent</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_to_OD_N_Team</fullName>
        <ccEmails>hqworkplace.pricing@officedepot.com</ccEmails>
        <description>Send Email to OD N Team</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/OD_N_WRF_Tasks</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_Audit</fullName>
        <ccEmails>BSDAudits@officedepot.com</ccEmails>
        <description>Send Task Notification Audit</description>
        <protected>false</protected>
        <recipients>
            <recipient>492245@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_BSD_Finance</fullName>
        <ccEmails>BSDFinance.ContractDivision@officedepot.com</ccEmails>
        <description>Send Task Notification BSD Finance</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_Bids</fullName>
        <ccEmails>Pricing.Acquisition@officedepot.com</ccEmails>
        <description>Send Task Notification Bids</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_CBFS</fullName>
        <ccEmails>CBFSTEAM@officedepot.com</ccEmails>
        <description>Send Task Notification CBFS</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_CCLR</fullName>
        <ccEmails>CCLR@officedepot.com</ccEmails>
        <description>Send Task Notification CCLR</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_Contract_Development</fullName>
        <ccEmails>condev@officedepot.com</ccEmails>
        <description>Send Task Notification Contract Development</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_Contract_Lifecycle</fullName>
        <ccEmails>Contract.Lifecycle@officedepot.com</ccEmails>
        <description>Send Task Notification Contract Lifecycle</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_Cross_Reference_Team</fullName>
        <ccEmails>CrossRef@officedepot.com</ccEmails>
        <description>Send Task Notification Cross Reference Team</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_GT_Contract_Development</fullName>
        <ccEmails>legalreview@grandandtoy.com</ccEmails>
        <description>Send Task Notification GT Contract Development</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_Global_Implementation</fullName>
        <ccEmails>istrans@officedepot.com</ccEmails>
        <description>Send Task Notification Global Implementation</description>
        <protected>false</protected>
        <senderType>DefaultWorkflowUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_HCL</fullName>
        <ccEmails>od.bsdsupport@hcl.in</ccEmails>
        <description>Send Task Notification HCL</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_Pricing_Acquisition</fullName>
        <ccEmails>pricingacq.life@officedepot.com</ccEmails>
        <description>Send Task Notification Pricing Acquisition</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_Public_GPO</fullName>
        <ccEmails>publicsec.bids@officedepot.com</ccEmails>
        <description>Send Task Notification Public/GPO</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_Regional_Sales_Support</fullName>
        <description>Send Task Notification Regional Sales Support</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales_Admin</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_Remediation</fullName>
        <ccEmails>lifecycle.remediation@officedepot.com</ccEmails>
        <description>Send Task Notification Remediation</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_to_BSD_Pricing</fullName>
        <ccEmails>BSDHostedCatalog@officedepot.com</ccEmails>
        <description>Send Task Notification to BSD Pricing</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_to_BSD_Pricing_Inbox</fullName>
        <ccEmails>bsdhostedcatalog@officedepot.com</ccEmails>
        <description>Send Task Notification to BSD Pricing Inbox</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_to_MPS</fullName>
        <ccEmails>odgomps@officedepot.com</ccEmails>
        <description>Send Task Notification to MPS</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_to_MPS_Assessment</fullName>
        <ccEmails>mps.evaluation@officedepot.com</ccEmails>
        <description>Send Task Notification to MPS Assessment</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_to_MPS_Group</fullName>
        <ccEmails>managedprint.solutions@officedepot.com</ccEmails>
        <description>Send Task Notification to MPS Group</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_to_Pricing</fullName>
        <ccEmails>field-contracts@officedepot.com</ccEmails>
        <description>Send Task Notification to Pricing</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>Send_Task_Notification_to_WRF_Assignee</fullName>
        <description>Send Task Notification to WRF Assignee</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <alerts>
        <fullName>WRF_Extend_current_OMX_Agreement_Rebates</fullName>
        <description>WRF_Extend current OMX Agreement_Rebates</description>
        <protected>false</protected>
        <recipients>
            <field>Notification_Group__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>sfdc-support@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>WRF_Templates/Work_Request_Task</template>
    </alerts>
    <fieldUpdates>
        <fullName>Clear_Await_Action_Date</fullName>
        <field>Awaiting_Action_Date__c</field>
        <name>Clear Await Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assign_toGT_Contract_Development</fullName>
        <field>Assigned_To__c</field>
        <name>Default Assign toGT Contract Development</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assign_to_B2B_eContent</fullName>
        <field>Assigned_To__c</field>
        <lookupValue>203711@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Assign to B2B eContent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assign_to_Leader_MPS</fullName>
        <field>Assigned_To__c</field>
        <lookupValue>592214@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Assign to Leader MPS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assign_to_Leader_MPS_Assessment</fullName>
        <field>Assigned_To__c</field>
        <lookupValue>278274@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Assign to Leader MPS Assessment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assignment_to_Creator_Audit</fullName>
        <field>Assigned_To__c</field>
        <lookupValue>492245@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Assignment to Creator - Audit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assignment_to_Creator_Bids</fullName>
        <description>Clear Default Assignment to - Bids</description>
        <field>Assigned_To__c</field>
        <name>Default Assignment to Creator - Bids</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assignment_to_Creator_CrossRef</fullName>
        <field>Assigned_To__c</field>
        <name>Default Assignment to Creator - CrossRef</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assignment_to_Creator_HCL</fullName>
        <field>Assigned_To__c</field>
        <lookupValue>754238@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Assignment to Creator - HCL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assignment_to_Creator_PrcngAcq</fullName>
        <description>Updates &apos;Assigned To&apos; field on WRF Task</description>
        <field>Assigned_To__c</field>
        <name>Default Assignment to Creator - PrcngAcq</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assignment_to_Creator_Publ_GPO</fullName>
        <description>Default Assignment to Creator - Public/GPO</description>
        <field>Assigned_To__c</field>
        <name>Default Assignment to Creator - Publ/GPO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assignment_to_Creator_RSS</fullName>
        <field>Assigned_To__c</field>
        <lookupValue>100066@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Assignment to Creator - RSS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Assignment_to_Creator_Remedtn</fullName>
        <description>Default Assignment to Creator - Remediation</description>
        <field>Assigned_To__c</field>
        <name>Default Assignment to Creator - Remedtn</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Audit_Assign_to_Leader_ConDev</fullName>
        <field>Assigned_To__c</field>
        <lookupValue>264261@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Audit Assign to Leader ConDev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Audit_Assign_to_Leader_ConLifeCy</fullName>
        <field>Assigned_To__c</field>
        <name>Default Audit Assign to Leader ConLifeCy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Audit_Assign_to_Leader_Finance</fullName>
        <field>Assigned_To__c</field>
        <name>Default Audit Assign to Leader Finance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Audit_Assign_to_Leader_Implement</fullName>
        <field>Assigned_To__c</field>
        <name>Default Audit Assign to Leader Implement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Audit_Assign_to_Leader_Legal</fullName>
        <field>Assigned_To__c</field>
        <lookupValue>571931@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Audit Assign to Leader Legal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Audit_Assigned_To_Leader_CCLR</fullName>
        <field>Assigned_To__c</field>
        <lookupValue>571931@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Default Audit Assigned To Leader CCLR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Review_Date_to_Blank</fullName>
        <field>Final_Review_Date__c</field>
        <name>Final Review Date to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>In_Progress_Date_to_Blank</fullName>
        <field>In_Progress_Date__c</field>
        <name>In Progress Date to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previously_Assigned</fullName>
        <field>Previously_Assigned_To__c</field>
        <formula>PRIORVALUE(Assigned_To_Name__c)</formula>
        <name>Previously Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previously_Assigned_2</fullName>
        <field>Previously_Assigned_To_B__c</field>
        <formula>PRIORVALUE(Assigned_To_Name__c)</formula>
        <name>Previously Assigned 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previously_Assigned_Date</fullName>
        <field>Previously_Assigned_Date__c</field>
        <formula>NOW()</formula>
        <name>Previously Assigned Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previously_Assigned_Date_B</fullName>
        <field>Previously_Assigned_to_Date_2__c</field>
        <formula>NOW()</formula>
        <name>Previously Assigned Date 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_Group_Email</fullName>
        <field>Send_Group_Email__c</field>
        <literalValue>1</literalValue>
        <name>Send Group Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_To_Group_Email</fullName>
        <field>Send_Group_Email__c</field>
        <literalValue>1</literalValue>
        <name>Send To Group Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Await_Action_Date</fullName>
        <field>Awaiting_Action_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Await Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Final_Review_Date</fullName>
        <field>Final_Review_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Final Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_Complete</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Set Status Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Task_Completion_Date</fullName>
        <field>WRF_Task_Complete_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Task Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Task_In_Progress_Date</fullName>
        <field>In_Progress_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Task In Progress Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Team_Review_Date</fullName>
        <field>Team_Review_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Team Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Under_Review_Date</fullName>
        <field>Under_Review_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Under Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Task_Complete_Date_to_Blank</fullName>
        <field>WRF_Task_Complete_Date__c</field>
        <name>Task Complete Date to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Team_Review_Date_to_Blank</fullName>
        <field>Team_Review_Date__c</field>
        <name>Team Review Date to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Under_Review_Date_to_Blank</fullName>
        <field>Under_Review_Date__c</field>
        <name>Under Review Date to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>24 Hours Past File Sent for Review</fullName>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.File_Sent_for_Review__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Email to Pricing Analyst to follow up and/or close subtask</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_File_Sent_for_Review2</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Assignment Group%3A Transition</fullName>
        <actions>
            <name>New_WRF_Task_Transition</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assignment_to_Creator_Remedtn</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Transition Team</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>notEqual</operation>
            <value>Transition</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to B2B eContent</fullName>
        <actions>
            <name>Send_Email_Notification_to_B2B_eContent</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assign_to_B2B_eContent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Disposition_Code__c</field>
            <operation>equals</operation>
            <value>3rd Party Catalog</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>B2B eContent</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to BSD Pricing</fullName>
        <actions>
            <name>Send_Task_Notification_to_BSD_Pricing_Inbox</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_To_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>BSD Pricing</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to GT Contract Development</fullName>
        <actions>
            <name>Send_Task_Notification_GT_Contract_Development</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assign_toGT_Contract_Development</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>GT Contract Development</value>
        </criteriaItems>
        <description>Default Assign to GT Contract Development</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader Audits</fullName>
        <actions>
            <name>Send_Task_Notification_Audit</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assignment_to_Creator_Audit</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Audits</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader BSD Pricing</fullName>
        <actions>
            <name>Send_Task_Notification_to_BSD_Pricing</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>BSD Pricing</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader Bids</fullName>
        <actions>
            <name>Send_Task_Notification_Bids</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assignment_to_Creator_Bids</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Bids</value>
        </criteriaItems>
        <description>Default Assign to Leader Bids</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader ConDev</fullName>
        <actions>
            <name>Send_Task_Notification_Contract_Development</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Audit_Assign_to_Leader_ConDev</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Contract Development</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>WRF Task</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader ConLifeCyc</fullName>
        <actions>
            <name>Send_Task_Notification_Contract_Lifecycle</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Audit_Assign_to_Leader_ConLifeCy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Contract Life Cycle</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader Cross Reference Team</fullName>
        <actions>
            <name>Send_Task_Notification_Cross_Reference_Team</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assignment_to_Creator_CrossRef</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Cross Reference</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.Disposition_Code__c</field>
            <operation>equals</operation>
            <value>Cross Reference</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader Finance</fullName>
        <actions>
            <name>Send_Task_Notification_BSD_Finance</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Audit_Assign_to_Leader_Finance</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Finance</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader HCL</fullName>
        <actions>
            <name>Send_Task_Notification_HCL</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assignment_to_Creator_HCL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>HCL</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader Implementation</fullName>
        <actions>
            <name>Send_Task_Notification_Global_Implementation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Audit_Assign_to_Leader_Implement</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Implementation</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>WRF Task</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader Legal</fullName>
        <actions>
            <name>Send_Task_Notification_CCLR</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Audit_Assign_to_Leader_Legal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Legal</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader Lifecycle%2FRemediation</fullName>
        <actions>
            <name>Send_Task_Notification_Remediation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assignment_to_Creator_Remedtn</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Lifecycle/Remediation</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>WRF Task</value>
        </criteriaItems>
        <description>Default Assign to Leader Lifecycle/Remediation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader MPS</fullName>
        <actions>
            <name>Send_Task_Notification_to_MPS</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assign_to_Leader_MPS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>MPS</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader MPS Assessment</fullName>
        <actions>
            <name>Send_Task_Notification_to_MPS_Assessment</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assign_to_Leader_MPS_Assessment</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>MPS Assessment</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader Pricing Acquisition</fullName>
        <actions>
            <name>Send_Task_Notification_Pricing_Acquisition</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assignment_to_Creator_PrcngAcq</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Pricing Acquisition</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader Public%2FGPO</fullName>
        <actions>
            <name>Send_Task_Notification_Public_GPO</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assignment_to_Creator_Publ_GPO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Public/GPO</value>
        </criteriaItems>
        <description>Default Assign to Leader Public/GPO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Assign to Leader RSS</fullName>
        <actions>
            <name>Send_Task_Notification_Regional_Sales_Support</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assignment_to_Creator_RSS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Regional Sales Support</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Email to CBFS Assignment Group</fullName>
        <actions>
            <name>Send_Task_Notification_CBFS</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Send_Group_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 4) AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>CBFS</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>WRF Sub Task</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>WRF Task</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.Disposition_Code__c</field>
            <operation>equals</operation>
            <value>CBFS</value>
        </criteriaItems>
        <description>An email is sent to cbfsteam@officedepot.com when a WRF task is created under assignment group - CBFS.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Email to Field Contracts Assignment Group</fullName>
        <actions>
            <name>Send_Task_Notification_to_Pricing</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 3) AND (2 OR 4)</booleanFilter>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Field Contracts</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>WRF Task</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.Disposition_Code__c</field>
            <operation>equals</operation>
            <value>Deviated Cost Core Build</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>WRF Sub Task</value>
        </criteriaItems>
        <description>An email is sent to field-contracts@officedepot.com when a WRF task is created under assignment group - Field Contracts.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default Email to MPS Pricing</fullName>
        <actions>
            <name>Send_Task_Notification_to_MPS_Group</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>MPS Pricing</value>
        </criteriaItems>
        <description>Case 00961907</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email First Assignee</fullName>
        <actions>
            <name>Send_Task_Notification_to_WRF_Assignee</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Group Assign</fullName>
        <actions>
            <name>Send_Task_Notification_to_WRF_Assignee</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND (NOT(ISPICKVAL(Assignment_Group__c, &quot;&quot;)),                      ISCHANGED(Assigned_To__c)         )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Email Notification for Rebate</fullName>
        <actions>
            <name>Email_Notification_for_Disposition_Code_Rebate</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Disposition_Code__c</field>
            <operation>equals</operation>
            <value>Rebates</value>
        </criteriaItems>
        <description>Send an email notifications to complianceadmin-.rebates@officedepot.com, when a &quot;Rabates&quot; disposition code is created or edited</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Task Assignee</fullName>
        <actions>
            <name>Send_Task_Notification_to_WRF_Assignee</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(ISPICKVAL(Assignment_Group__c,&quot;&quot; ),ISPICKVAL(Assignment_Group__c,&quot;OD N Pricing/Bids/Remediation&quot; )),            ISCHANGED(Assigned_To__c),NOT(ISNEW())         )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Extend current OMX Agreement_Rebates</fullName>
        <actions>
            <name>WRF_Extend_current_OMX_Agreement_Rebates</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>equals</operation>
            <value>Transition</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.Notification_Group__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Remediation Task</fullName>
        <actions>
            <name>New_WRF_Task_Remediation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Default_Assignment_to_Creator_Remedtn</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>Lifecycle/Remediation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.WRF_Request_Type__c</field>
            <operation>notEqual</operation>
            <value>Transition</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify WRF Task Creator on Complete</fullName>
        <actions>
            <name>Notify_WRF_Creator_on_Complete</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) and 3 and 4</booleanFilter>
        <criteriaItems>
            <field>WRF_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.No_Action_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.CreatedById</field>
            <operation>notEqual</operation>
            <value>Salesforce</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.CreatedById</field>
            <operation>notEqual</operation>
            <value>Odsfa Odsfa</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OD N WRF Tasks</fullName>
        <actions>
            <name>Send_Email_to_OD_N_Team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Assignment_Group__c</field>
            <operation>equals</operation>
            <value>OD N Pricing/Bids/Remediation</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Previously Assigned</fullName>
        <actions>
            <name>Previously_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Previously_Assigned_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Assigned_To__c ),          LEN( Previously_Assigned_To__c ) &lt; 2 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Previously Assigned 2</fullName>
        <actions>
            <name>Previously_Assigned_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Previously_Assigned_Date_B</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Assigned_To__c ),          LEN( Previously_Assigned_To__c ) &gt; 2,          LEN( Previously_Assigned_To_B__c) &lt; 2 )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pricing Task Completed</fullName>
        <actions>
            <name>Email_Pricing_Task_Completed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.Task_Type__c</field>
            <operation>equals</operation>
            <value>Pricing/CPM,Pricing/CPM Revisit</value>
        </criteriaItems>
        <criteriaItems>
            <field>WRF_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Await Action Date</fullName>
        <actions>
            <name>Set_Await_Action_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WRF_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Action</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Completion Date</fullName>
        <actions>
            <name>Set_Task_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WRF_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Final Review Date</fullName>
        <actions>
            <name>Set_Final_Review_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WRF_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>Final Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set In Progress Date</fullName>
        <actions>
            <name>Set_Task_In_Progress_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WRF_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Status Complete When No Action Required</fullName>
        <actions>
            <name>Set_Status_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Task_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WRF_Task__c.No_Action_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Status Dates to Blank</fullName>
        <actions>
            <name>Final_Review_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>In_Progress_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Task_Complete_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Team_Review_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Under_Review_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WRF_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>Not Started</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Team Review Date</fullName>
        <actions>
            <name>Set_Team_Review_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WRF_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>Team Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Under Review Date</fullName>
        <actions>
            <name>Set_Under_Review_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>WRF_Task__c.Status__c</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
