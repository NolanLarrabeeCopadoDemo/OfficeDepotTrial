<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_AutoApprove7thDay</fullName>
        <field>Autoapprove7thDay__c</field>
        <literalValue>1</literalValue>
        <name>Update AutoApprove7thDay</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Update Autoapprove7thDay</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Reassignment_Queue__c.Status__c</field>
            <operation>equals</operation>
            <value>Pending Approval</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_AutoApprove7thDay</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Reassignment_Queue__c.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
