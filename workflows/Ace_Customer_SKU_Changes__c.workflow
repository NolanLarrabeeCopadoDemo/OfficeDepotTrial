<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Email_Price1</fullName>
        <description>Approval Email Price1</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Price_Change_Approval2</template>
    </alerts>
    <alerts>
        <fullName>Approval_Email_Price2</fullName>
        <description>Approval Email Price2</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Price_Change_Approval2</template>
    </alerts>
    <alerts>
        <fullName>Approval_Email_Price3</fullName>
        <description>Approval Email Price3</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Price_Change_Approval2</template>
    </alerts>
    <alerts>
        <fullName>Price_Reject_Email1</fullName>
        <description>Price Reject Email1</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Price_Change_Rejection2</template>
    </alerts>
    <alerts>
        <fullName>Price_Reject_Email2</fullName>
        <description>Price Reject Email2</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Price_Change_Rejection2</template>
    </alerts>
    <alerts>
        <fullName>Price_Reject_Email3</fullName>
        <description>Price Reject Email3</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>EXTERNAL_ACE_Templates/Price_Change_Rejection2</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved</fullName>
        <field>Approval_status__c</field>
        <formula>&quot;Approved&quot;</formula>
        <name>Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_User_Price_to_Approved_Price</fullName>
        <field>Approved_Proposed_Price__c</field>
        <formula>Proposed_Price__c</formula>
        <name>Copy User Price to Approved Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L1_End_Date_Approval</fullName>
        <description>L1 End Date Approval</description>
        <field>L1_Mgr_Approval_End_Date__c</field>
        <formula>NOW()</formula>
        <name>L1 End Date Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L1_End_Date_Rejection</fullName>
        <description>L1 End Date Rejection</description>
        <field>L1_Mgr_Approval_End_Date__c</field>
        <formula>NOW()</formula>
        <name>L1 End Date Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L1_Start_Date</fullName>
        <description>L1 Start Date</description>
        <field>L1_Mgr_Approval_Start_Date__c</field>
        <formula>NOW()</formula>
        <name>L1 Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L2_End_Date_Approval</fullName>
        <description>L2 End Date Approval</description>
        <field>L2_Mgr_Approval_End_Date__c</field>
        <formula>NOW()</formula>
        <name>L2 End Date Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L2_End_Date_Rejection</fullName>
        <description>L2 End Date Rejection</description>
        <field>L2_Mgr_Approval_End_Date__c</field>
        <formula>NOW()</formula>
        <name>L2 End Date Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L2_Start_Date_Approval</fullName>
        <description>L2 Start Date Approval</description>
        <field>L2_Mgr_Approval_Start_Date__c</field>
        <formula>NOW()</formula>
        <name>L2 Start Date Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L3_End_Date_Approval</fullName>
        <description>L3 End Date Approval</description>
        <field>L3_Mgr_Approval_End_Date__c</field>
        <formula>NOW()</formula>
        <name>L3 End Date Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L3_End_Date_Rejection</fullName>
        <description>L3 End Date Rejection</description>
        <field>L3_Mgr_Approval_End_Date__c</field>
        <formula>NOW()</formula>
        <name>L3 End Date Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>L3_Start_Date_Approval</fullName>
        <description>L3 Start Date Approval</description>
        <field>L3_Mgr_Approval_Start_Date__c</field>
        <formula>NOW()</formula>
        <name>L3 Start Date Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pending_for_Approval</fullName>
        <field>Approval_status__c</field>
        <formula>&quot;Pending&quot;</formula>
        <name>Pending for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Lock</fullName>
        <description>Record Locked = true</description>
        <field>Record_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Record_Lock</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Unlock</fullName>
        <field>Record_Locked__c</field>
        <literalValue>0</literalValue>
        <name>Record Unlock</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Recall</fullName>
        <field>Approval_status__c</field>
        <formula>&quot;&quot;</formula>
        <name>Status Recall</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Rejected</fullName>
        <field>Approval_status__c</field>
        <formula>&quot;Rejected&quot;</formula>
        <name>Status_Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateVendavoDate</fullName>
        <field>Vendavo_Update_Date__c</field>
        <formula>Now()</formula>
        <name>UpdateVendavoDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_Price_Change</fullName>
        <field>Customer_Price_Change__c</field>
        <formula>Ace_Customer_Core_Changes__r.ACE_Customer_Price_Changes__c</formula>
        <name>Update Customer Price Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Previous_Exception_Impact1</fullName>
        <field>Previous_Exception_Impact__c</field>
        <formula>IF( NOT( ISNULL( Previous_Exception_Impact__c ) ) , ( Previous_Exception_Impact__c + Price_Exception_Revenue_Impact__c ), Price_Exception_Revenue_Impact__c)</formula>
        <name>Update Previous Exception Impact1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_ACE_SKU_Changes_ID</fullName>
        <field>ACE_SKU_Changes_ID__c</field>
        <formula>VALUE(ACE_SKU_Changes_ID1__c  )</formula>
        <name>update ACE_SKU_Changes_ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>SetVendavoUpdateDate</fullName>
        <actions>
            <name>UpdateVendavoDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(PROCESSING_ALLOWED__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Customer Price Change</fullName>
        <actions>
            <name>Update_Customer_Price_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Ace_Customer_Core_Changes__c!=null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>update seq Number for export</fullName>
        <actions>
            <name>update_ACE_SKU_Changes_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Ace_Customer_SKU_Changes__c.ACE_SKU_Changes_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
