<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_To_customer_Tech_Sales</fullName>
        <description>Email alert To customer Tech Sales</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Quote/Send_Quote_To_customer</template>
    </alerts>
    <alerts>
        <fullName>Notify_Quote_Opp_Owner_of_Approval</fullName>
        <description>Notify Quote/Opp Owner of Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Request_Emails/Quote_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Quote_Opp_Owner_of_Rejection</fullName>
        <description>Notify Quote/Opp Owner of Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Request_Emails/Quote_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_Unassigned_Quote</fullName>
        <ccEmails>techdepotaustin@officedepot.com</ccEmails>
        <ccEmails>khaled.ziadeh@officedepot.com</ccEmails>
        <description>Notify Unassigned Quote</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Opportunities_Notice/New_Non_Assigned_quote</template>
    </alerts>
    <fieldUpdates>
        <fullName>DSM_Update_to_Approved</fullName>
        <field>DSM_Approval1__c</field>
        <literalValue>Approved</literalValue>
        <name>DSM Update to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DSM_Update_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>DSM Update to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Disallow_Internal_Approval</fullName>
        <field>Internal_Approval_Allowed__c</field>
        <literalValue>0</literalValue>
        <name>Disallow Internal Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mark_As_Approved</fullName>
        <field>Internal_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Mark As Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mark_As_Submitted</fullName>
        <field>Internal_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Mark As Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pricing_Dir_Update_to_Approved</fullName>
        <field>Pricing_Dir_Approval1__c</field>
        <literalValue>Approved</literalValue>
        <name>Pricing Dir. Update to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pricing_Dir_Update_to_Rejected</fullName>
        <field>Pricing_Dir_Approval1__c</field>
        <literalValue>Rejected</literalValue>
        <name>Pricing Dir. Update to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Status_updated_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved by OD</literalValue>
        <name>Quote Status updated to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_Status_updated_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected by Customer</literalValue>
        <name>Quote Status updated to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RSD_Update_to_Approved</fullName>
        <field>RSD_Approval1__c</field>
        <literalValue>Approved</literalValue>
        <name>RSD Update to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RSD_Update_to_Rejected</fullName>
        <field>RSD_Approval1__c</field>
        <literalValue>Rejected</literalValue>
        <name>RSD Update to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Approver_1</fullName>
        <field>Approver_1__c</field>
        <name>Remove Approver 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Approver_2</fullName>
        <field>Approver_2__c</field>
        <name>Remove Approver 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Approver_3</fullName>
        <field>Approver_3__c</field>
        <name>Remove Approver 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Approver_4</fullName>
        <field>Approver_4__c</field>
        <name>Remove Approver 4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Approver_5</fullName>
        <field>Approver_5__c</field>
        <name>Remove Approver 5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Approver_6</fullName>
        <field>Approver_6__c</field>
        <name>Remove Approver 6</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Approver_7</fullName>
        <field>Approver_7__c</field>
        <name>Remove Approver 7</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Approver_8</fullName>
        <field>Approver_8__c</field>
        <name>Remove Approver 8</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Procurement</fullName>
        <field>Procurement__c</field>
        <literalValue>0</literalValue>
        <name>Remove Procurement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status</fullName>
        <field>Status</field>
        <literalValue>Customer Review Complete</literalValue>
        <name>Set Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_In_Review</fullName>
        <field>Status</field>
        <literalValue>In Review By OD</literalValue>
        <name>Set Status In Review</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_To_Blank</fullName>
        <field>Internal_Approval_Status__c</field>
        <name>Set Status To Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update_to_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved by OD</literalValue>
        <name>Status Update to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updating_status_of_quote_for_tech_sales</fullName>
        <field>Status</field>
        <literalValue>Customer Review Complete</literalValue>
        <name>Updating status of quote for tech sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_URL</fullName>
        <field>GoToQuote__c</field>
        <formula>&quot;https://officedepot.lightning.force.com/lightning/r/Quote/&quot;+Id+ &quot;/view&quot;</formula>
        <name>update URL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Send email to Customer Tech Sales</fullName>
        <actions>
            <name>Email_alert_To_customer_Tech_Sales</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Quote.Sent_For_Customer_Approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Tech Sales Temporary -To update the status field based on internal approval</fullName>
        <actions>
            <name>Updating_status_of_quote_for_tech_sales</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Quote.RecordTypeId</field>
            <operation>equals</operation>
            <value>Non Code (Tech)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Quote.Internal_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Un Assigned Quote</fullName>
        <actions>
            <name>Notify_Unassigned_Quote</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>DUPLICATE workflow</description>
        <formula>AND(IF(Opportunity.Owner.Username = &quot;salesforce@officedepot.com&quot;,true,false),IF(RecordType.Name = &quot;Tech&quot;, true, false))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Quote URL for Lightnig</fullName>
        <actions>
            <name>update_URL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
