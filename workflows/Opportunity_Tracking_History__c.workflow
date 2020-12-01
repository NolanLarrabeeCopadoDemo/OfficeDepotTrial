<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Pillar_Key</fullName>
        <field>Pillar_Key__c</field>
        <formula>Opportunity_Owner__r.Id+&apos;-&apos;+ Pillar__c+
&apos;-&apos;+Fiscal_Month__c</formula>
        <name>Update Pillar Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Populate Pillar Key</fullName>
        <actions>
            <name>Update_Pillar_Key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Pillar__c!=null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
