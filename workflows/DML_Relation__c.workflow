<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>New_Request</fullName>
        <field>NewRequest__c</field>
        <literalValue>0</literalValue>
        <name>New Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_CUSTOMERID</fullName>
        <description>Populate CUSTOMERID__c value</description>
        <field>CUSTOMERID__c</field>
        <formula>Customer_ID__c</formula>
        <name>Populate CUSTOMERID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProcessNew_Requests</fullName>
        <field>ProcessNew_Request__c</field>
        <literalValue>1</literalValue>
        <name>ProcessNew Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Start_Date_Field_Update</fullName>
        <field>Effective_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>Start Date Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Checkbox Update</fullName>
        <active>false</active>
        <criteriaItems>
            <field>DML_Relation__c.NewRequest__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Request</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>ProcessNew_Requests</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>DML_Relation__c.New_start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Populate CUSTOMERID</fullName>
        <actions>
            <name>Populate_CUSTOMERID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DML_Relation__c.CUSTOMERID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This workflow run when CUSTOMERID__c field value is blank and populate the value for CUSTOMERID__c.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Start Date WF</fullName>
        <actions>
            <name>Start_Date_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DML_Relation__c.Effective_Start_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
