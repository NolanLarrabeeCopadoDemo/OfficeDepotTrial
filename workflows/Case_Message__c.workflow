<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Case_Message</fullName>
        <apiVersion>46.0</apiVersion>
        <description>The Case messages used to sync data between Freshdesk and OracleCX via EAI</description>
        <endpointUrl>https://api.officedepot.io/services/case-upsert-service/eaiapi/SalesForceCreateCaseServices?token=123456789abcde</endpointUrl>
        <fields>Account_Number__c</fields>
        <fields>Attachment_Id__c</fields>
        <fields>Case_Comment_Id__c</fields>
        <fields>Case_Message_Action__c</fields>
        <fields>Case_Message_Destination__c</fields>
        <fields>Case__c</fields>
        <fields>CreatedDate</fields>
        <fields>FirstName__c</fields>
        <fields>Freshdesk_Id__c</fields>
        <fields>Freshdesk_Queue__c</fields>
        <fields>Freshdesk_Type__c</fields>
        <fields>Id</fields>
        <fields>LastName__c</fields>
        <fields>Name</fields>
        <fields>OracleCX_Id__c</fields>
        <fields>OracleCX_Queue__c</fields>
        <fields>Phone__c</fields>
        <fields>User_Email__c</fields>
        <fields>User__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>soa_connection@officedepot.com</integrationUser>
        <name>Case Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Dispatch Case Message OBM</fullName>
        <actions>
            <name>Case_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case_Message__c.Case_Message_Status__c</field>
            <operation>equals</operation>
            <value>NEW</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case_Message__c.Case_Message_Status__c</field>
            <operation>equals</operation>
            <value>RESUBMIT</value>
        </criteriaItems>
        <description>Sends the Outbound Case Message to EAI</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Post Case Message</fullName>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case_Message__c.Case_Message_Action__c</field>
            <operation>equals</operation>
            <value>CREATED</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case_Message__c.Case_Message_Action__c</field>
            <operation>equals</operation>
            <value>UPDATED</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
