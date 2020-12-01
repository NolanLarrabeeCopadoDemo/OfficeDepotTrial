<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>salesprism__External_ID_Update</fullName>
        <field>salesprism__External_ID__c</field>
        <formula>salesprism__Account_ID__r.Id</formula>
        <name>External ID Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>salesprism__Unique_ID_Update</fullName>
        <field>salesprism__Unique_ID__c</field>
        <formula>salesprism__Account_ID__r.Id</formula>
        <name>Unique ID Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>salesprism__salesPRISM_Details_Unique_Rule</fullName>
        <actions>
            <name>salesprism__Unique_ID_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>salesprism__Account_ID__r.Id &lt;&gt; null</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
