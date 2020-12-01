<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>KeyPopulate</fullName>
        <field>BlockduplicateEntries__c</field>
        <formula>batchId__c+Owning_Customer_ID2__c+CoreList_ID__c+SKU__c</formula>
        <name>KeyPopulate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Avoid Duplicate Entries</fullName>
        <actions>
            <name>KeyPopulate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
