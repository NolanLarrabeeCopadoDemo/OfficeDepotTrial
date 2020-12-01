<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_Account_Owner_of_CompuCom_Referral</fullName>
        <description>Notify Account Owner of CompuCom Referral</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EXTERNAL_Partner_Templates/Notify_Account_Owner_of_CC_Referral</template>
    </alerts>
</Workflow>
