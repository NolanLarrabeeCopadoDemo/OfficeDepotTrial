<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_approver_for_Pending_ReAssignment_Approvals</fullName>
        <description>Alert approver for Pending ReAssignment Approvals</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Pending_Reassignment_Approval</template>
    </alerts>
    <rules>
        <fullName>Alert approver for Pending ReAssignment Approvals</fullName>
        <actions>
            <name>Alert_approver_for_Pending_ReAssignment_Approvals</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Pending_ReAssignment_Approvals__c.User_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
