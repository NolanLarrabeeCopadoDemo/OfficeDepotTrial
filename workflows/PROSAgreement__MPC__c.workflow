<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PROSAgreement__Update_Mass_Price_Change_Amendment_Date</fullName>
        <field>PROSAgreement__Amendment_Date_UI__c</field>
        <formula>DATEVALUE( PROSAgreement__Amendment_Date__c )</formula>
        <name>Update Mass Price Change Amendment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PROSAgreement__Update_Mass_Price_Change_Name</fullName>
        <field>Name</field>
        <formula>&quot;MassPriceChange - &quot;  &amp;   TEXT(  DATEVALUE( PROSAgreement__Requested_Time__c ) )</formula>
        <name>Update Mass Price Change Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PROSAgreement__Update Mass Price Change Amendment Date</fullName>
        <actions>
            <name>PROSAgreement__Update_Mass_Price_Change_Amendment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISBLANK( PROSAgreement__Amendment_Date_UI__c )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PROSAgreement__Update Mass Price Change Name</fullName>
        <actions>
            <name>PROSAgreement__Update_Mass_Price_Change_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PROSAgreement__MPC__c.Name</field>
            <operation>notContain</operation>
            <value>MassPriceChange</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
