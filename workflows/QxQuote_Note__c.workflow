<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Request_for_quote_update_Email_alert</fullName>
        <description>Request for quote update - Email alert</description>
        <protected>false</protected>
        <recipients>
            <field>Pricing_Analyst_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Pricing_Analyst__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Request_for_Quote_Update_ET</template>
    </alerts>
    <rules>
        <fullName>Request for quote update</fullName>
        <actions>
            <name>Request_for_quote_update_Email_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
