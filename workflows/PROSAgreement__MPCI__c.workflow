<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PROSAgreement__Update_Mass_Price_Change_Item_Name</fullName>
        <field>Name</field>
        <formula>IF( ISBLANK( PROSAgreement__Contract__c ) ,  PROSAgreement__AgreementRecordName__c , 
PROSAgreement__ContractName__c)  &amp; &quot; - MassPrice - &quot; &amp; TEXT( DATEVALUE(  PROSAgreement__MassPriceChange__r.PROSAgreement__Requested_Time__c  ) )</formula>
        <name>Update Mass Price Change Item Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PROSAgreement__Update Mass Price Change Item Name</fullName>
        <actions>
            <name>PROSAgreement__Update_Mass_Price_Change_Item_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PROSAgreement__MPCI__c.Name</field>
            <operation>notContain</operation>
            <value>MassPrice</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
