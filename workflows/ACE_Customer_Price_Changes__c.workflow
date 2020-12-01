<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Account_Owner</fullName>
        <description>Email Account Owner</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Customer_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Account_Owner2</fullName>
        <description>Email Account Owner</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Customer_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Account_Owner_Callback</fullName>
        <description>Email Account Owner Callback</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Customer_Callback</template>
    </alerts>
    <alerts>
        <fullName>Email_Date_Acceptance2</fullName>
        <description>Email Date Acceptance2</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Date_Change_Approval2</template>
    </alerts>
    <alerts>
        <fullName>Email_Date_Acceptance3</fullName>
        <description>Email Date Acceptance3</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Date_Change_Approval2</template>
    </alerts>
    <alerts>
        <fullName>Email_Date_Exception1</fullName>
        <description>Email Date Exception1</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Date_Change_Approval2</template>
    </alerts>
    <alerts>
        <fullName>Email_Date_Rejection1</fullName>
        <description>Email Date Rejection1</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Date_Change_Rejection2</template>
    </alerts>
    <alerts>
        <fullName>Email_Date_Rejection2</fullName>
        <description>Email Date Rejection2</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Date_Change_Rejection2</template>
    </alerts>
    <alerts>
        <fullName>Email_Date_Rejection3</fullName>
        <description>Email Date Rejection3</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Date_Change_Rejection2</template>
    </alerts>
    <alerts>
        <fullName>Email_Notify_Failure</fullName>
        <description>Email Notify Failure</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Customer_Email_Delivery_Failure</template>
    </alerts>
    <alerts>
        <fullName>Remediation_Acceptance</fullName>
        <description>Remediation Acceptance</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Remediation_Change_Acceptance</template>
    </alerts>
    <alerts>
        <fullName>Remediation_Rejection</fullName>
        <description>Remediation Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Remediation_Change_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Unlock_Approval</fullName>
        <description>Unlock Approval</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Unlock_Change_Approval</template>
    </alerts>
    <alerts>
        <fullName>Unlock_Reject</fullName>
        <description>Unlock Reject</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Unlock_Change_Rejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Type_Update</fullName>
        <description>Makes Approval Type to null</description>
        <field>Approval_Type__c</field>
        <name>Approval Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_Record_Unlock</fullName>
        <field>Record_Unlock__c</field>
        <literalValue>1</literalValue>
        <name>Check Record Unlock</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Rep_Date_on_Recall</fullName>
        <field>Sales_Price_Change_Effective_Date_Rep__c</field>
        <name>Clear Rep Date on Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Rep_Date_on_Reject</fullName>
        <field>Sales_Price_Change_Effective_Date_Rep__c</field>
        <name>Clear Rep Date on Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Proposed_to_Approved</fullName>
        <field>Sales_Price_Change_Effective_Date_Approv__c</field>
        <formula>Sales_Price_Change_Effective_Date_Rep__c</formula>
        <name>Copy Proposed to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Proposed_to_Min</fullName>
        <field>Sales_Price_Change_Effective_Date_Min__c</field>
        <formula>Sales_Price_Change_Effective_Date_Rep__c</formula>
        <name>Copy Proposed to Min</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Proposed_to_Min2</fullName>
        <field>Sales_Price_Change_Effective_Date_Min__c</field>
        <formula>Sales_Price_Change_Effective_Date_Rep__c</formula>
        <name>Copy Proposed to Min</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Proposed_to_Min3</fullName>
        <field>Sales_Price_Change_Effective_Date_Min__c</field>
        <formula>Sales_Price_Change_Effective_Date_Rep__c</formula>
        <name>Copy Proposed to Min</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Imp_status_Upd3</fullName>
        <field>Implementation_Status__c</field>
        <formula>&quot;Recalled&quot;</formula>
        <name>Imp status Upd3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Implementation_Code_Recall</fullName>
        <field>Implementation_Status_Code__c</field>
        <formula>&quot;SCH&quot;</formula>
        <name>Implementation Code Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Implementation_Code_SCH_App</fullName>
        <field>Implementation_Status_Code__c</field>
        <formula>&quot;SCH&quot;</formula>
        <name>Implementation Code SCH App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Implementation_Code_SCH_PEN</fullName>
        <description>implementation status code to SCH-PEN</description>
        <field>Implementation_Status_Code__c</field>
        <formula>&quot;SCH-PEN&quot;</formula>
        <name>Implementation Code - SCH-PEN</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Implementation_Code_SCH_Rej</fullName>
        <field>Implementation_Status_Code__c</field>
        <formula>&quot;SCH&quot;</formula>
        <name>Implementation Code SCH Rej</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L1_End_Date_Approval</fullName>
        <field>L1_Mgr_Approval_End_Date__c</field>
        <formula>Now()</formula>
        <name>L1 End Date Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L1_End_Date_Rejection</fullName>
        <field>L1_Mgr_Approval_End_Date__c</field>
        <formula>Now()</formula>
        <name>L1 End Date Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L1_Start_Date</fullName>
        <field>L1_Mgr_Approval_Start_Date__c</field>
        <formula>now()</formula>
        <name>L1 Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L1_Start_Date2</fullName>
        <field>L1_Mgr_Approval_Start_Date__c</field>
        <formula>now()</formula>
        <name>L1 Start Date2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L2_End_Date_Approval</fullName>
        <field>L2_Mgr_Approval_End_Date__c</field>
        <formula>now()</formula>
        <name>L2 End Date Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L2_End_Date_Rejection</fullName>
        <field>L2_Mgr_Approval_End_Date__c</field>
        <formula>now()</formula>
        <name>L2 End Date Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L2_Start_Date_Approval</fullName>
        <field>L2_Mgr_Approval_Start_Date__c</field>
        <formula>now()</formula>
        <name>L2 Start Date Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L3_End_Date_Approval</fullName>
        <field>L3_Mgr_Approval_End_Date__c</field>
        <formula>now()</formula>
        <name>L3 End Date Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L3_End_Date_Rejection</fullName>
        <field>L3_Mgr_Approval_End_Date__c</field>
        <formula>now()</formula>
        <name>L3 End Date Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L3_Start_Date_Approval</fullName>
        <field>L3_Mgr_Approval_Start_Date__c</field>
        <formula>now()</formula>
        <name>L3 Start Date Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lock_Record_for_Exception_Submission</fullName>
        <field>Exception_Date_Lock__c</field>
        <literalValue>1</literalValue>
        <name>Lock Record for Exception Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Delay_Days</fullName>
        <field>Previous_Exception_Days__c</field>
        <formula>IF( NOT( ISNULL( Previous_Exception_Days__c ) ) , ( Previous_Exception_Days__c + Current_Exception_Days__c ), Current_Exception_Days__c)</formula>
        <name>Previous Delay Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Delay_Days2</fullName>
        <field>Previous_Exception_Days__c</field>
        <formula>IF( NOT( ISNULL( Previous_Exception_Days__c ) ) , ( Previous_Exception_Days__c + Current_Exception_Days__c ), Current_Exception_Days__c)</formula>
        <name>Previous Delay Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Delay_Days3</fullName>
        <field>Previous_Exception_Days__c</field>
        <formula>IF( NOT( ISNULL( Previous_Exception_Days__c ) ) , ( Previous_Exception_Days__c + Current_Exception_Days__c ), Current_Exception_Days__c)</formula>
        <name>Previous Delay Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Impact</fullName>
        <field>Previous_Exception_Impact__c</field>
        <formula>IF( NOT( ISNULL( Previous_Exception_Impact__c ) ) , ( Previous_Exception_Impact__c + OD_Revenue_Impact__c ), OD_Revenue_Impact__c)</formula>
        <name>Previous Impact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Impact2</fullName>
        <field>Previous_Exception_Impact__c</field>
        <formula>IF( NOT( ISNULL( Previous_Exception_Impact__c ) ) , ( Previous_Exception_Impact__c + OD_Revenue_Impact__c ), OD_Revenue_Impact__c)</formula>
        <name>Previous Impact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Previous_Impact3</fullName>
        <field>Previous_Exception_Impact__c</field>
        <formula>IF( NOT( ISNULL( Previous_Exception_Impact__c ) ) , ( Previous_Exception_Impact__c + OD_Revenue_Impact__c ), OD_Revenue_Impact__c)</formula>
        <name>Previous Impact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Unlock_Status_Approved</fullName>
        <field>Record_Unlock_Status__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Record Unlock Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Unlock_Status_Pending</fullName>
        <field>Record_Unlock_Status__c</field>
        <formula>&quot;Pending&quot;</formula>
        <name>Record Unlock Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Unlock_Status_Recall</fullName>
        <field>Record_Unlock_Status__c</field>
        <formula>&quot;Recalled&quot;</formula>
        <name>Record Unlock Status Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Unlock_Status_Reject</fullName>
        <field>Record_Unlock_Status__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Record Unlock Status Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remediation_End_Date_Update</fullName>
        <field>Remediation_End_Date__c</field>
        <formula>TODAY()</formula>
        <name>Remediation End Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remediation_Start_Date_Update</fullName>
        <field>Remediation_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>Remediation Start Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Schdeule_Reminder</fullName>
        <field>Reschduled_For_Reminder__c</field>
        <literalValue>0</literalValue>
        <name>Reset Schdeule Reminder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Schdeule_Reminder2</fullName>
        <field>Reschduled_For_Reminder__c</field>
        <literalValue>0</literalValue>
        <name>Reset Schdeule Reminder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Schdeule_Reminder3</fullName>
        <field>Reschduled_For_Reminder__c</field>
        <literalValue>0</literalValue>
        <name>Reset Schdeule Reminder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Approved</fullName>
        <field>Approval_Satus__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Pending</fullName>
        <field>Approval_Satus__c</field>
        <formula>&quot;Pending&quot;</formula>
        <name>Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Pending2</fullName>
        <field>Approval_Satus__c</field>
        <formula>&quot;Pending&quot;</formula>
        <name>Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Pending3</fullName>
        <field>Approval_Satus__c</field>
        <formula>&quot;Pending&quot;</formula>
        <name>Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Recalled</fullName>
        <field>Approval_Satus__c</field>
        <formula>&quot;&quot;</formula>
        <name>Status Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Rejected</fullName>
        <field>Approval_Satus__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unlock_Date_Exception_On_Approve</fullName>
        <field>Exception_Date_Lock__c</field>
        <literalValue>0</literalValue>
        <name>Unlock Date Exception On Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unlock_Date_Exception_On_Recall</fullName>
        <field>Exception_Date_Lock__c</field>
        <literalValue>0</literalValue>
        <name>Unlock Date Exception On Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unlock_Date_Exception_On_Reject</fullName>
        <field>Exception_Date_Lock__c</field>
        <literalValue>0</literalValue>
        <name>Unlock Date Exception On Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unlock_Record_On_Approve</fullName>
        <field>Record_Lock__c</field>
        <literalValue>0</literalValue>
        <name>Unlock Record On Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_vendavo_date</fullName>
        <field>Update_Vendavo_Date__c</field>
        <literalValue>1</literalValue>
        <name>update vendavo date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>vendavo_update_date</fullName>
        <field>Update_Vendavo_Date__c</field>
        <literalValue>1</literalValue>
        <name>vendavo update date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ACE Customer Approval</fullName>
        <actions>
            <name>Email_Account_Owner2</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>update_vendavo_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Customer_Response__c),TEXT(Customer_Response__c) == &apos;Approved&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ACE Remediation Approval</fullName>
        <actions>
            <name>Remediation_Acceptance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>IF(PRIORVALUE( Remedy_Status__c ) &lt;&gt; Remedy_Status__c &amp;&amp; Remedy_Status__c == &apos;Approved&apos;,true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ACE Remediation Rejection</fullName>
        <actions>
            <name>Remediation_Rejection</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>IF(PRIORVALUE( Remedy_Status__c ) &lt;&gt; Remedy_Status__c &amp;&amp; Remedy_Status__c == &apos;Rejected&apos;,true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Call Back</fullName>
        <actions>
            <name>Email_Account_Owner_Callback</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>vendavo_update_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Customer_Response__c)==&apos;Call Me&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Notify Failure</fullName>
        <actions>
            <name>Email_Notify_Failure</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( Notification_Status_Code__c) , Notification_Status_Code__c == &apos;NOTIFY-FAILED&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Remediation End Date</fullName>
        <actions>
            <name>Remediation_End_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( ISCHANGED(Remediation_Hold__c) , Remediation_Hold__c = False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Remediation Start Date</fullName>
        <actions>
            <name>Remediation_Start_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR( AND( ISCHANGED(IsRemediation__c) ,Customer__r.Remediation_Required__c=true), AND( ISCHANGED( Remediation_Hold__c ) ,Remediation_Hold__c=true))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
