<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AlertWrittenCoreRequest</fullName>
        <ccEmails>customertransitionrequests@officedepot.com</ccEmails>
        <description>Alert Written Core Request</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Customer_TransitionWrittenCoreRequest</template>
    </alerts>
    <alerts>
        <fullName>CT_Auto_Redirect_Email_Alert</fullName>
        <description>CT Auto Redirect Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_AutoRedirect</template>
    </alerts>
    <alerts>
        <fullName>CT_CBFS_Email_Alert</fullName>
        <ccEmails>cbfscustmigration@officedepot.com</ccEmails>
        <description>CT CBFS Email Alert</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_CBFS_Rep_Adj_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_CPD_Email_Alert</fullName>
        <ccEmails>cpd.migration@officedepot.com</ccEmails>
        <description>CT CPD Email Alert</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_CPD_Rep_Adj_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_DNS_Sent_Email_Alert</fullName>
        <description>CT DNS Sent Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_DNS_by_ODS</template>
    </alerts>
    <alerts>
        <fullName>CT_DocMan_Email_Alert</fullName>
        <ccEmails>cpd.migration@officedepot.com</ccEmails>
        <description>CT DocMan Email Alert</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_DocMan_Rep_Adj_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_Email_Alert_Notification_Upon_WRF_Creation</fullName>
        <description>CT Email Alert Notification Upon WRF Creation</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/Customer_Transition_Rep_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_Furniture_Email_Alert</fullName>
        <ccEmails>WorkspaceMigrationAlerts@officedepot.com</ccEmails>
        <description>CT Furniture Email Alert</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_Furn_Rep_Adj_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_Green_Email_Alert</fullName>
        <ccEmails>greenspendtarget@officedepot.com</ccEmails>
        <description>CT Green Email Alert</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_Green_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_Inclusions_Exclusions_Email_Alert</fullName>
        <description>CT Inclusions/Exclusions Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Customer_Transition_Emails/CT_Inclusions_Exclusions_Rep_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_MPS_Email_Alert</fullName>
        <ccEmails>ManagedPrint.Solutions@officedepot.com</ccEmails>
        <description>CT MPS Email Alert</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_MPS_Rep_Adj_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_Prop_Item_Email_Alert</fullName>
        <ccEmails>PROPRIETARY@OFFICEDEPOT.COM</ccEmails>
        <description>CT Proprietary Item Email Alert</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_Prop_Item_Rep_Adj_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_RCC_Email_Alert</fullName>
        <description>CT RCC Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_RCC_Rep_Adj_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_Tech_Email_Alert</fullName>
        <ccEmails>techcustmigration@officedepot.com</ccEmails>
        <description>CT Tech Email Alert</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_Tech_Rep_Adj_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_Tech_On_Line_Email_Alert</fullName>
        <ccEmails>techcustmigration@officedepot.com</ccEmails>
        <description>CT Tech &amp; On Line Email Alert</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_Tech_On_Line_Rep_Adjacency_Email</template>
    </alerts>
    <alerts>
        <fullName>CT_Tier1_Email_Alert</fullName>
        <description>CT Tier1 Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>113529@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_Tier1_Rep_Adj_Email</template>
    </alerts>
    <alerts>
        <fullName>Dispostion_Alert_Non_Written_Customer_Requests_Earlier_Transition_Date</fullName>
        <ccEmails>BSD-PRICING@officedepot.com</ccEmails>
        <description>Dispostion Alert Non Written - Customer Requests Earlier Transition Date</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Calendar_Event/Non_Written_Agreement_Rep_Customer_Disposition</template>
    </alerts>
    <alerts>
        <fullName>Dispostion_Alert_Written_Customer_Requests_Earlier_Transition_Date</fullName>
        <ccEmails>CustomerTransitionRequests@officedepot.com</ccEmails>
        <description>Dispostion Alert Written - Customer Requests Earlier Transition Date</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Calendar_Event/Written_Agreement_Rep_Customer_Disposition</template>
    </alerts>
    <alerts>
        <fullName>Email_to_sc_bsdaccts_officedepot_com</fullName>
        <ccEmails>sc.bsdaccts@officedepot.com</ccEmails>
        <description>Email to sc.bsdaccts@officedepot.com</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Calendar_Event/CT_SC_Go_Live_Changed</template>
    </alerts>
    <alerts>
        <fullName>NOT_MY_CUSTOMER_Alert_Sales_Repweek1</fullName>
        <description>NOT MY CUSTOMER Alert Sales Rep 1st week</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Disposition_Not_my_Customer_Manager</template>
    </alerts>
    <alerts>
        <fullName>NOT_MY_CUSTOMER_Alert_Sales_Repweek2</fullName>
        <description>NOT MY CUSTOMER Alert Sales Rep  2nd week</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Managers_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Disposition_Not_my_Customer_Managers_Manager</template>
    </alerts>
    <alerts>
        <fullName>NOT_MY_CUSTOMER_Alert_Sales_Repweek3</fullName>
        <description>NOT MY CUSTOMER Alert Sales Rep  3rd week</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Managers_Managers_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Disposition_Not_my_Customer_Managers_Managers_Manager</template>
    </alerts>
    <fieldUpdates>
        <fullName>Capture_Prior_Go_Live_date</fullName>
        <field>Prior_Customer_Go_Live__c</field>
        <formula>PRIORVALUE(Customer_Go_Live_Target_Date__c)</formula>
        <name>Capture Prior Go-Live date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DNS_Update</fullName>
        <field>DNS_Status_Confirmed__c</field>
        <literalValue>1</literalValue>
        <name>DNS Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flip_Status_2_Account_Redirected</fullName>
        <description>Flip Status 2 Account Redirected</description>
        <field>Status__c</field>
        <literalValue>Auto Redirected</literalValue>
        <name>Flip Status 2 Account Redirected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OMAX_Account_Date</fullName>
        <field>OMX_Account_Closed__c</field>
        <formula>TODAY()</formula>
        <name>OMAX Account Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Account_Splitting_Required_Date</fullName>
        <field>Account_Splitting_Required_Date__c</field>
        <formula>today()</formula>
        <name>Populate Account Splitting Required Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Final_Split_decision_date</fullName>
        <field>Account_Splitting_Required_Date__c</field>
        <formula>today()</formula>
        <name>Populate Final Split decision date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Ready_for_Mod5_By</fullName>
        <field>Ready_for_Mod_5_By__c</field>
        <formula>LastModifiedBy.FirstName+&apos; &apos;+ LastModifiedBy.LastName</formula>
        <name>Populate Ready for Mod5 By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Ready_for_Mod_5_Date</fullName>
        <field>Ready_for_Mod_5_Date__c</field>
        <formula>Today()</formula>
        <name>Populate Ready for Mod 5 Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Split_Decision_By</fullName>
        <field>Split_Decision_By__c</field>
        <formula>LastModifiedBy.FirstName+&apos; &apos;+ LastModifiedBy.LastName</formula>
        <name>Populate Split Decision By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Split_Decision_By_Field</fullName>
        <field>Split_Decision_By__c</field>
        <formula>LastModifiedBy.FirstName+&apos; &apos;+ LastModifiedBy.LastName</formula>
        <name>Populate Split Decision By Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Process_Extension_Development</fullName>
        <field>Status__c</field>
        <literalValue>Extension/Development</literalValue>
        <name>Process Extension/Development</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Revert_Redirect_Stopped</fullName>
        <field>Redirect_Turned_OFF__c</field>
        <literalValue>0</literalValue>
        <name>Revert Redirect Stopped</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change_Build_OOP</fullName>
        <field>Status__c</field>
        <literalValue>Built OOP</literalValue>
        <name>Status Change Build OOP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Change_to_Transition_Complete</fullName>
        <field>Status__c</field>
        <literalValue>Transition Complete</literalValue>
        <name>Status Change to Transition Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Upd_Sched</fullName>
        <description>Review Start Date recieves a value and the Status Fields update to &quot;Scheduled&quot;</description>
        <field>Status__c</field>
        <literalValue>Scheduled</literalValue>
        <name>Status_Upd_Sched</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_to_Awaiting_Disposition</fullName>
        <description>Status Update to Awaiting Disposition</description>
        <field>Status__c</field>
        <literalValue>Awaiting Disposition</literalValue>
        <name>Status Update to Awaiting Disposition</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Upd_RecordType_Hide</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Hide</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Upd_RecordType_Hide</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Upd_Recordtype_Show</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Record_Type_CT</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Upd_Recordtype_Show</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_AOPS_Id</fullName>
        <field>AOPS_ID__c</field>
        <formula>Account__r.AOPS_Cust_Id__c</formula>
        <name>Update AOPS Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_A_D</fullName>
        <field>Status__c</field>
        <literalValue>Agreement/Development</literalValue>
        <name>Update_A/D</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjacency_Log_1</fullName>
        <description>Updates Adjacency Log with 1</description>
        <field>Adjacency_Notifications_Log__c</field>
        <formula>Adjacency_Notifications_Log__c + &quot;1&quot;</formula>
        <name>Update Adjacency Log 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjacency_Log_A</fullName>
        <description>Update Adjacency Log A for AutoRedirect</description>
        <field>Adjacency_Notifications_Log__c</field>
        <formula>Adjacency_Notifications_Log__c + &quot;A&quot;</formula>
        <name>Update Adjacency Log A</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjacency_Log_B</fullName>
        <description>Updates Adjacency Log with B for CBFS</description>
        <field>Adjacency_Notifications_Log__c</field>
        <formula>Adjacency_Notifications_Log__c + &quot;B&quot;</formula>
        <name>Update Adjacency Log B</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjacency_Log_C</fullName>
        <description>Updates Adjacency Log with C for CPD</description>
        <field>Adjacency_Notifications_Log__c</field>
        <formula>Adjacency_Notifications_Log__c + &quot;C&quot;</formula>
        <name>Update Adjacency Log C</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjacency_Log_F</fullName>
        <field>Adjacency_Notifications_Log__c</field>
        <formula>Adjacency_Notifications_Log__c + &quot;F&quot;</formula>
        <name>Update Adjacency Log F</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjacency_Log_G</fullName>
        <description>Updates Adjacency Log with G</description>
        <field>Adjacency_Notifications_Log__c</field>
        <formula>Adjacency_Notifications_Log__c + &quot;G&quot;</formula>
        <name>Update Adjacency Log G</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjacency_Log_M</fullName>
        <description>Updates Adjacency Log with M for MPS</description>
        <field>Adjacency_Notifications_Log__c</field>
        <formula>Adjacency_Notifications_Log__c + &quot;M&quot;</formula>
        <name>Update Adjacency Log M</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjacency_Log_P</fullName>
        <description>Updates Adjacency Log with P</description>
        <field>Adjacency_Notifications_Log__c</field>
        <formula>Adjacency_Notifications_Log__c + &quot;P&quot;</formula>
        <name>Update Adjacency Log P</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjacency_Log_R</fullName>
        <description>Update Adjacency Log to R for RCC</description>
        <field>Adjacency_Notifications_Log__c</field>
        <formula>Adjacency_Notifications_Log__c + &quot;R&quot;</formula>
        <name>Update Adjacency Log R</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Adjacency_Log_T</fullName>
        <description>Updates Adjacency Log to T for Technology</description>
        <field>Adjacency_Notifications_Log__c</field>
        <formula>Adjacency_Notifications_Log__c + &quot;T&quot;</formula>
        <name>Update Adjacency Log T</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Admin_Close</fullName>
        <field>Status__c</field>
        <literalValue>Administrative Close</literalValue>
        <name>Update_Admin_Close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Assessment</fullName>
        <field>Status__c</field>
        <literalValue>Assessment</literalValue>
        <name>Update_Assessment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Audit_2</fullName>
        <field>Status__c</field>
        <literalValue>Audit 2</literalValue>
        <name>Update_Audit_2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Building</fullName>
        <field>Status__c</field>
        <literalValue>Building</literalValue>
        <name>Update_Building</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Completed</fullName>
        <field>Status__c</field>
        <literalValue>Transition Complete</literalValue>
        <name>Update_Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Final_Split_Decision_Date</fullName>
        <field>Account_Splitting_Required_Date__c</field>
        <name>Update Final Split Decision Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Launched_By</fullName>
        <field>Launched_By__c</field>
        <formula>LastModifiedBy.FirstName+&apos; &apos;+LastModifiedBy.LastName</formula>
        <name>Update Launched By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Launched_Date</fullName>
        <field>Launched_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Launched Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Launched_OMX_ID</fullName>
        <field>Launched_OMX_ID__c</field>
        <formula>Account__r.OMX_Primary_Key__c</formula>
        <name>Update Launched OMX ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_LossCustomer</fullName>
        <description>Updated to Customer Loss</description>
        <field>Status__c</field>
        <literalValue>Loss of Customer</literalValue>
        <name>Update_LossCustomer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Split_Decision_By</fullName>
        <field>Split_Decision_By__c</field>
        <name>Update Split Decision By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_UnSched</fullName>
        <field>Status__c</field>
        <literalValue>UnScheduled</literalValue>
        <name>Update_UnSched</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updated_Launched</fullName>
        <field>Status__c</field>
        <literalValue>Launched</literalValue>
        <name>Updated_Launched</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updated_ReSched</fullName>
        <field>Status__c</field>
        <literalValue>ReScheduled</literalValue>
        <name>Updated_ReSched</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>t1</fullName>
        <field>Redirect_Turned_OFF__c</field>
        <literalValue>0</literalValue>
        <name>t1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>t2</fullName>
        <field>DNS_Status_Confirmed__c</field>
        <literalValue>1</literalValue>
        <name>t2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Alert CT Written Core Request</fullName>
        <actions>
            <name>AlertWrittenCoreRequest</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>CT_00674130Alert</description>
        <formula>AND(ISPICKVAL( Status__c ,&apos;On Deck&apos;) ,Written_Agreement__c=true, Local_Core__c =  true, ISPICKVAL(Written_Agreement_Custom_Core_Request__c ,&apos;&apos;),OR( Customer_Transition_Type2__c =&apos;Child&apos;, Customer_Transition_Type2__c=&apos;Standalone&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AlertWrittenCoreRequest</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Custom AutoRedirect Notification</fullName>
        <actions>
            <name>CT_Auto_Redirect_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_A</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>Auto Redirected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>A</value>
        </criteriaItems>
        <description>This notification goes out at AutoRedirect  = True</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom CBFS Notification</fullName>
        <actions>
            <name>CT_CBFS_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_B</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.CBFS__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>Launched</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>B</value>
        </criteriaItems>
        <description>This notification goes out at &quot;Launched&quot; status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom CPD %2B Docman Notification</fullName>
        <actions>
            <name>CT_DocMan_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_C</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.DocMan__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>On Deck</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>C</value>
        </criteriaItems>
        <description>This notification goes out at &quot;On Deck&quot; status</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Custom CPD Notification</fullName>
        <actions>
            <name>CT_CPD_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_C</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.CPD__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>On Deck</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>C</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.DocMan__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This notification goes out at &quot;On Deck&quot; status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom DNS Sent Notification</fullName>
        <actions>
            <name>CT_DNS_Sent_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.DNS_Status_Confirmed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This notification goes out at DNS Sent = True</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom Furn Notification</fullName>
        <actions>
            <name>CT_Furniture_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_F</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Furniture__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>Launched</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>F</value>
        </criteriaItems>
        <description>This notification goes out at &quot;Launched&quot; status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom Green Notification</fullName>
        <actions>
            <name>CT_Green_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_G</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Green_Spend__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>G</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>On Deck,Awaiting Disposition</value>
        </criteriaItems>
        <description>This notification goes out at a Green Spend Checkbox is true.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom Inclusions%2FExclusions Notification</fullName>
        <actions>
            <name>CT_Inclusions_Exclusions_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Inclusion_Exclusion_Requirements__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>Launched</value>
        </criteriaItems>
        <description>This notification goes out at &quot;Launched&quot; status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom MPS Notification</fullName>
        <actions>
            <name>CT_MPS_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_M</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.MPS__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>On Deck</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>M</value>
        </criteriaItems>
        <description>This notification goes out at &quot;On Deck&quot; status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom Proprietary Item Notification</fullName>
        <actions>
            <name>CT_Prop_Item_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_P</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Proprietary_Item_Setup_Needed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>On Deck</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>P</value>
        </criteriaItems>
        <description>This notification goes out at &quot;On Deck&quot; status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom RCC Notification</fullName>
        <actions>
            <name>CT_RCC_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_R</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Retail_Connect__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>Launched</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>R</value>
        </criteriaItems>
        <description>This notification goes out at &quot;Launched&quot; status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom Tech %26 On Line Notification</fullName>
        <actions>
            <name>CT_Tech_On_Line_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_T</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Channel_Online_Technology__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>Launched</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>T</value>
        </criteriaItems>
        <description>This notification goes out at &quot;Launched&quot; status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom Tech Notification</fullName>
        <actions>
            <name>CT_Tech_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_T</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Technology__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>Launched</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>T</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Channel_Online_Technology__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This notification goes out at &quot;Launched&quot; status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Custom Tier 1 Notification</fullName>
        <actions>
            <name>CT_Tier1_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Adjacency_Log_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Tier_1__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Disposition</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Adjacency_Notifications_Log__c</field>
            <operation>notContain</operation>
            <value>1</value>
        </criteriaItems>
        <description>This notification goes out Status Reads &quot;Awaiting Disposition&quot;.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Dispostion Alert Non Written - Customer Requests Earlier Transition Date</fullName>
        <actions>
            <name>Dispostion_Alert_Non_Written_Customer_Requests_Earlier_Transition_Date</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Customer_Disposition__c  )   &amp;&amp; text(Customer_Disposition__c )==&apos;Customer Requests Earlier Transition Date&apos; &amp;&amp; (Written_Agreement_Customer_No__c ==null || Written_Agreement_Customer_No__c ==&apos;&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Dispostion Alert Written - Customer Requests Earlier Transition Date</fullName>
        <actions>
            <name>Dispostion_Alert_Written_Customer_Requests_Earlier_Transition_Date</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Customer_Disposition__c  )   &amp;&amp; text(Customer_Disposition__c )==&apos;Customer Requests Earlier Transition Date&apos; &amp;&amp; Written_Agreement_Customer_No__c !=&apos;&apos;  &amp;&amp; Written_Agreement_Customer_No__c !=null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Go Live Date Changed%2FEntered</fullName>
        <actions>
            <name>Email_to_sc_bsdaccts_officedepot_com</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Capture_Prior_Go_Live_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Send an email when Go Live Date is Changed or Entered.</description>
        <formula>ISCHANGED(Customer_Go_Live_Target_Date__c) &amp;&amp; !ISBLANK(Customer_Go_Live_Target_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Mod 5 - Populate Account Splitting Required Date</fullName>
        <actions>
            <name>Populate_Account_Splitting_Required_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Split_Decision_By</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Final_Split_Decision__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>When Final Split Decision is Yes then Populate Account Splitting Required Date with today&apos;s date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mod 5 - Populate Ready for Mod 5 Details</fullName>
        <actions>
            <name>Populate_Ready_for_Mod5_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Ready_for_Mod_5_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Ready_For_Mod_5__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mod 5 - Populate Split Decision By and Final Split decision date</fullName>
        <actions>
            <name>Populate_Final_Split_decision_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Split_Decision_By_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Final_Split_Decision__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <description>Populate Split Decision By and Final Split decision date when Final Split Decision Set to No</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mod 5 - Status Change to Build ODP</fullName>
        <actions>
            <name>Status_Change_Build_OOP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Manual_AOPS_account__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Transitioned_Outside_of_Process__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Change the status to Build ODP when AOPS Transition ID not null and Transitioned Outside of Process is true.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mod2 Auto Redirect Non Dual</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Ready_to_order__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.DUAL_Account_Yes_No__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Redirect_Turned_OFF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>OMAX_Account_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Status_Change_to_Transition_Complete</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Ready_to_Order_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Mod2 Change Status and OMX Acc Tran Date</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Customer_Transition__c.Redirect_Turned_OFF_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Redirect_Turned_OFF__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>OMAX_Account_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Status_Change_to_Transition_Complete</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Redirect_Turned_OFF_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Mod2-Dual Account - Estimated Closed Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.DUAL_Account_Yes_No__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Estimated_OMX_Acct_Close__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Ready_to_order__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Redirect_Turned_OFF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Flagging an account as a dual will require that a value for the Estimated OMX Close Date is populated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Flip_Status_2_Account_Redirected</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Estimated_OMX_Acct_Close__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>DNS_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Estimated_OMX_Acct_Close__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>OMAX_Account_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Status_Change_to_Transition_Complete</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Estimated_OMX_Acct_Close__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Mod2_Update DNS on Automatic Redirect Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Automatic_Redirect__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Dual_Account_Comments__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Updating DNS Status Confirmed when Automatic Redirect Date is 14 days after automatic redirect occurs.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DNS_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Automatic_Redirect__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Mod5 Update Split Fields</fullName>
        <actions>
            <name>Update_Final_Split_Decision_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Split_Decision_By</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>text(Final_Split_Decision__c) ==&apos;&apos;|| text(Final_Split_Decision__c )==&apos;No&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NOT MY CUSTOMER Alert Sales Rep</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Customer_Transition__c.Trigger_SalesRep_Change__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NOT_MY_CUSTOMER_Alert_Sales_Repweek2</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Trigger_SalesRep_Change_Date__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>NOT_MY_CUSTOMER_Alert_Sales_Repweek3</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Trigger_SalesRep_Change_Date__c</offsetFromField>
            <timeLength>21</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>NOT_MY_CUSTOMER_Alert_Sales_Repweek1</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Trigger_SalesRep_Change_Date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Process Extension%2FDevelopment</fullName>
        <actions>
            <name>Process_Extension_Development</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Extension_in_Development__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Process_Administrative_Close</fullName>
        <actions>
            <name>Update_Admin_Close</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Once the &quot;Administrative Close&quot; checkbox on Milestone 4 is checked true, update the status to &quot;Administrative Close&quot;</description>
        <formula>ischanged(Administrative_Close__c) &amp;&amp; 
Administrative_Close__c==true &amp;&amp; 
Ready_for_Mod1__c == false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Process_Agree</fullName>
        <actions>
            <name>Update_A_D</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Agreement_Development__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Customer_Transition_Complete__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Ready_for_Mod1__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Administrative Close,Loss of Customer</value>
        </criteriaItems>
        <description>Once the &quot;Agreement in Development&quot; checkbox on Milestone 2 is checked true, update the status to &quot;Agreement/Development&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Process_Assessment</fullName>
        <actions>
            <name>Update_Assessment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Non_WA_in_Assessment__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Once the &quot;Non-WA in Assessment&quot; checkbox on Milestone 2 is checked true, update the status to &quot;Assessment&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Process_Audit_2</fullName>
        <actions>
            <name>Update_Audit_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Ready_for_audit_2__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Once the &quot;Ready for Audit 2&quot; checkbox on Milestone 4 is checked true, update the status to &quot;Audit 2&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Process_Building</fullName>
        <actions>
            <name>Update_Building</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Manual_Build_Underway__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Once the &quot;Manual Build Underway&quot; checkbox on Milestone 3 is checked true, update the status to &quot;Building&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Process_Completed</fullName>
        <actions>
            <name>Update_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Customer_Transition_Complete__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Process_Customer_Loss</fullName>
        <actions>
            <name>Update_LossCustomer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Once the &quot;Customer Loss&quot; checkbox on Milestone 4 is checked true, update the status to &quot;Customer Loss&quot;</description>
        <formula>ischanged(Customer_Loss__c) &amp;&amp; 
Customer_Loss__c==true &amp;&amp; 
Ready_for_Mod1__c == false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Process_Launched</fullName>
        <actions>
            <name>Update_Launched_By</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Launched_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Launched_OMX_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Updated_Launched</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Ready_for_Mod1__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Customer_Transition_Complete__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Once the &quot;Ready for Account Setup/Mod 1&quot; checkbox on Milestone 3 is checked true, update the status to &quot;Launched&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Process_UnScheduled</fullName>
        <actions>
            <name>Update_UnSched</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Review_Start_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Recordtype Rule Hide</fullName>
        <actions>
            <name>Upd_RecordType_Hide</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Customer_Transition__c.Review_Start_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Recordtype Rule Show</fullName>
        <actions>
            <name>Upd_Recordtype_Show</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Customer_Transition__c.Review_Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Revert Redirect Stopped</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Redirect_Turned_OFF__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DNS_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Revert_Redirect_Stopped</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Estimated_OMX_Acct_Close__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Revert Redirect Stopped_test</fullName>
        <actions>
            <name>t1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>t2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Customer_Transition__c.Redirect_Turned_OFF__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Status ReSchedule to Awaiting Disposition Child</fullName>
        <active>true</active>
        <description>Changing Customer Transition record&apos;s Status to Awaiting Disposition.
28 days before Review start Date</description>
        <formula>text(Status__c)==&apos;ReScheduled&apos; &amp;&amp; Ready_for_Mod1__c == false &amp;&amp; Written_Agreement_Customer_No__c!=null  &amp;&amp; IsWritten_Parent__c!=&apos;Y&apos; &amp;&amp; Customer_Transition_Complete__c==false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Status_Update_to_Awaiting_Disposition</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Review_Start_Date__c</offsetFromField>
            <timeLength>-28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Status ReSchedule to Awaiting Disposition Parent</fullName>
        <active>true</active>
        <description>Changing Customer Transition record&apos;s Status to Awaiting Disposition.
28 days before Review start Date</description>
        <formula>text(Status__c)==&apos;ReScheduled&apos; &amp;&amp; Ready_for_Mod1__c == false &amp;&amp; Written_Agreement_Customer_No__c!=null &amp;&amp; IsWritten_Parent__c=&apos;Y&apos; &amp;&amp; Customer_Transition_Complete__c==false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CT_Email_Alert_Notification_Upon_WRF_Creation</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Status_Update_to_Awaiting_Disposition</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Review_Start_Date__c</offsetFromField>
            <timeLength>-28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Status Schedule to Awaiting Disposition Child</fullName>
        <active>true</active>
        <description>Changing Customer Transition record&apos;s Status to Awaiting Disposition.
28 days before Review start Date</description>
        <formula>text(Status__c)==&apos;Scheduled&apos; &amp;&amp; Ready_for_Mod1__c == false &amp;&amp; Written_Agreement_Customer_No__c!=null  &amp;&amp; IsWritten_Parent__c!=&apos;Y&apos; &amp;&amp; Customer_Transition_Complete__c==false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Status_Update_to_Awaiting_Disposition</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Review_Start_Date__c</offsetFromField>
            <timeLength>-28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Status Schedule to Awaiting Disposition Parent</fullName>
        <active>true</active>
        <description>Changing Customer Transition record&apos;s Status to Awaiting Disposition.
28 days before Review start Date</description>
        <formula>text(Status__c)==&apos;Scheduled&apos; &amp;&amp; Ready_for_Mod1__c == false &amp;&amp; Written_Agreement_Customer_No__c!=null  &amp;&amp; IsWritten_Parent__c=&apos;Y&apos; &amp;&amp; Customer_Transition_Complete__c==false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CT_Email_Alert_Notification_Upon_WRF_Creation</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Status_Update_to_Awaiting_Disposition</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Review_Start_Date__c</offsetFromField>
            <timeLength>-28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Transition Complete on Redirection Stoppe</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.IsRedirectStopped__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>OMAX_Account_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Status_Change_to_Transition_Complete</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Customer_Transition__c.Estimated_OMX_Acct_Close__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update AOPS Id</fullName>
        <actions>
            <name>Update_AOPS_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.AOPS_Assigned_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Workflow to update OMX fields when status is launched</fullName>
        <actions>
            <name>Update_Launched_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Launched_OMX_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Customer_Transition__c.Status__c</field>
            <operation>equals</operation>
            <value>Launched</value>
        </criteriaItems>
        <criteriaItems>
            <field>Customer_Transition__c.Launched_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Workflow will update the Launched OMX Id and date when Status changed to Launched</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
