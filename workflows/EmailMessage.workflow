<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EmailTriggerFlag</fullName>
        <field>Is_This_A_New_Agreement__c</field>
        <literalValue>Yes</literalValue>
        <name>EmailTriggerFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ReOpen_Case</fullName>
        <description>Change Status of Case to Open</description>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>ReOpen Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Update</fullName>
        <description>Change status to In Progress if the criteria is met</description>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_to_In_Progress</fullName>
        <description>Change Case Status to &quot;In Progress&quot;</description>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Status to &quot;In Progress&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Incoming Email from Support Requestor for SOPS cases</fullName>
        <actions>
            <name>Status_to_In_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>00825758 - Awaiting Information - SOPS Case Management
Incoming Email from Support Requestor for SOPS case management</description>
        <formula>Text(Parent.Status) = &apos;Awaiting Information&apos; &amp;&amp; Incoming = true &amp;&amp; FromAddress = Parent.Support_Requester__r.Email &amp;&amp; Parent.Owner:Queue.QueueName = &apos;SalesOps Queue&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Open Closed Case When Email Comes In</fullName>
        <actions>
            <name>ReOpen_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed,Case Review,Awaiting Information</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Maintenance</value>
        </criteriaItems>
        <description>Open Closed Case When Email Comes In</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RepNotification</fullName>
        <actions>
            <name>EmailTriggerFlag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Supplier</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SCOE Reopen Case</fullName>
        <actions>
            <name>Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Case Review,Awaiting Information,Backlog,Closed,Cancelled,Pending Award,Pending Approval,On Hold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SCOE Cases</value>
        </criteriaItems>
        <description>SCOE Cases will reopen when user emails business.solutions if the case is any status except New, Open &amp; In Progress</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
