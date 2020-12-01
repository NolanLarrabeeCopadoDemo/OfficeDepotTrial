<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DocuSign_Notification_Lifecycle_Team</fullName>
        <ccEmails>suelair.riveron@officedepot.com;</ccEmails>
        <ccEmails>Contract.lifecycle@officedepot.com</ccEmails>
        <description>DocuSign Notification - Lifecycle Team</description>
        <protected>false</protected>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Contract_Lifecycle/Completed_DocuSign_notification</template>
    </alerts>
    <rules>
        <fullName>DocuSign Envelope Completed</fullName>
        <actions>
            <name>DocuSign_Notification_Lifecycle_Team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>dsfs__DocuSign_Status__c.dsfs__Envelope_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>DocuSign Completed - Send notification to Contract Lifecylce team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
