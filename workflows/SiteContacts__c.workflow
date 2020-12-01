<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Site_Contact_Field</fullName>
        <field>Duplicate_Site_Contact__c</field>
        <formula>CASESAFEID(Account__c)&amp;CASESAFEID(Contact__c)</formula>
        <name>Update Site Contact Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Duplicate Site Contact Field Update</fullName>
        <actions>
            <name>Update_Site_Contact_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WF used to update filed to avoid duplicate account and contact</description>
        <formula>AND( NOT(ISBLANK(Account__c )),NOT(ISBLANK( Contact__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
