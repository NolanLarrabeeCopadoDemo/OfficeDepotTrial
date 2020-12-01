<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Marketing_Cloud_Default_Status</fullName>
        <field>Marketing_Cloud_Status__c</field>
        <literalValue>No Action</literalValue>
        <name>Set Marketing Cloud Default Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Default Marketing Cloud Status</fullName>
        <actions>
            <name>Set_Marketing_Cloud_Default_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CCPA_Action__c.Key_Name__c</field>
            <operation>notEqual</operation>
            <value>EMAIL</value>
        </criteriaItems>
        <criteriaItems>
            <field>CCPA_Action__c.Key_Name__c</field>
            <operation>notEqual</operation>
            <value>PHONE</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
