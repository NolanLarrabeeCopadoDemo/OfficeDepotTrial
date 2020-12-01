<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Resend_Prospect_Data</fullName>
        <field>Republish__c</field>
        <name>Resend Prospect Data</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Prospect_Message</fullName>
        <apiVersion>23.0</apiVersion>
        <endpointUrl>https://alliance.officedepot.com/soa-infra/services/cdh_rt/SFDCProspectWrapper/sfdcprospectwrapper_client_ep</endpointUrl>
        <fields>Id</fields>
        <fields>Split_Flag__c</fields>
        <fields>Work_Indicator__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>soa_connection@officedepot.com</integrationUser>
        <name>Prospect Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Prospect Message</fullName>
        <actions>
            <name>Resend_Prospect_Data</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Prospect_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Sends the message for creation of prospect in ebiz.</description>
        <formula>OR (ISPICKVAL(Message_Complete__c,&apos;NP&apos;) , ISPICKVAL(Republish__c,&apos;Resend&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
