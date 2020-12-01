<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ACE_Email_Notification_to_User_on_PriceChanges</fullName>
        <description>ACE Email Notification to User on PriceChanges</description>
        <protected>false</protected>
        <recipients>
            <field>UserEmail__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>margin.support@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EXTERNAL_ACE_Templates/ACE_Rep_Notification</template>
    </alerts>
    <rules>
        <fullName>ACE_PC_EmailNotification</fullName>
        <actions>
            <name>ACE_Email_Notification_to_User_on_PriceChanges</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
