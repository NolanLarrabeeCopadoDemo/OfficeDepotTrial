<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_when_referral_comes_in_by_contact</fullName>
        <ccEmails>shravya.channamadhavuni@officedepot.com</ccEmails>
        <description>Email alert when referral comes in by contact</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRF_Templates/Email_notification_to_employee_who_referred_a_contact</template>
    </alerts>
    <rules>
        <fullName>Email alert when Referral has been created by contact</fullName>
        <actions>
            <name>Email_alert_when_referral_comes_in_by_contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Third_Party_Referrals__c.Employee_Name__c</field>
            <operation>notEqual</operation>
            <value>Null</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
