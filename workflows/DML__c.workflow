<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>DML_Director_ID</fullName>
        <field>DML_Director_ID__c</field>
        <formula>Decision_Maker_Rep__r.ExtIDSalesPerson__c</formula>
        <name>DML Director ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DecisionMakerIdUpd</fullName>
        <field>DECISION_MAKER_ID__c</field>
        <formula>IF(ISBLANK(DECISION_MAKER_ID__c) ,Name,DECISION_MAKER_ID__c)</formula>
        <name>DecisionMakerIdUpd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EffectiveStartDateUpd</fullName>
        <field>Effective_Start_Date__c</field>
        <formula>IF(ISBLANK(Effective_Start_Date__c),TODAY(), Effective_Start_Date__c)</formula>
        <name>EffectiveStartDateUpd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Requests</fullName>
        <field>NewRequest__c</field>
        <literalValue>0</literalValue>
        <name>New Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProcessNew_Request</fullName>
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
            <field>DML__c.NewRequest__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>New_Requests</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>ProcessNew_Request</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>DML__c.Proposed_Effective_Start_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DML Auto field Update</fullName>
        <actions>
            <name>DecisionMakerIdUpd</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>EffectiveStartDateUpd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2)</booleanFilter>
        <criteriaItems>
            <field>DML__c.DECISION_MAKER_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>DML__c.Effective_Start_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DML Director ID field update</fullName>
        <actions>
            <name>DML_Director_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DML__c.DML_Director_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
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
            <field>DML__c.Effective_Start_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
