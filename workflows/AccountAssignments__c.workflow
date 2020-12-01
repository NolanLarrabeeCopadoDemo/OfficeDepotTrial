<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Truncate_the_Entity_ID</fullName>
        <field>Entity_Id__c</field>
        <formula>LEFT( Entity_Id__c, 8)</formula>
        <name>Truncate the Entity_ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_ProspectID</fullName>
        <field>Entity_Id__c</field>
        <formula>AccountId__c</formula>
        <name>Update ProspectID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Validate Entity_Id%5F%5Fc</fullName>
        <actions>
            <name>Truncate_the_Entity_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>There is a possibility of getting the Entity_Id__c as XXXXXXXX-000001 so we need to truncate the -000001</description>
        <formula>IF((AccountType__c == &apos;A&apos; &amp;&amp; ISPICKVAL(Entity_Type__c,&apos;CUSTOMER&apos;) ), true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Validate Entity_Id%5F%5Fc_Prospect</fullName>
        <actions>
            <name>Update_ProspectID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Copy  Account Id  to Entity ID when Entity Type =&apos;Prospect&apos; and Account Type =&apos;A&apos;</description>
        <formula>IF((AccountType__c == &apos;A&apos; &amp;&amp; ISPICKVAL(Entity_Type__c,&apos;PROSPECT&apos;) ), true, false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
