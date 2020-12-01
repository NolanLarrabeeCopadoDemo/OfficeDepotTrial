<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Total_Cost</fullName>
        <field>Total_Cost__c</field>
        <formula>Cost__c * Quantity</formula>
        <name>Set Total Cost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Set Total Cost</fullName>
        <actions>
            <name>Set_Total_Cost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED( Cost__c ) || ISCHANGED( Quantity )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
