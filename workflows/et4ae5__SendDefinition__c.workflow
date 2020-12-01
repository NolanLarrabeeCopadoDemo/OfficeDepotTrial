<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>et4ae5__EmailSendStatus</fullName>
        <description>Send Email Notification of Completed Send</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>et4ae5__ExactTarget/et4ae5__ETSendDone</template>
    </alerts>
    <alerts>
        <fullName>et4ae5__SendFailed</fullName>
        <description>Send Email Notification of Failed Send</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>et4ae5__ExactTarget/et4ae5__ETSendDone</template>
    </alerts>
    <fieldUpdates>
        <fullName>et4ae5__DelayedSend</fullName>
        <field>et4ae5__TriggerDelayedSend__c</field>
        <literalValue>1</literalValue>
        <name>DelayedSend</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__FailBackupWorkflow</fullName>
        <field>et4ae5__SendStatus__c</field>
        <literalValue>Failed</literalValue>
        <name>FailBackupWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>true</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__FailBackupWorkflowM</fullName>
        <field>et4ae5__Messages__c</field>
        <formula>$Label.et4ae5__errornores</formula>
        <name>FailBackupWorkflowM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__PopulateBackupWorkflow</fullName>
        <field>et4ae5__BackupWorkflow__c</field>
        <formula>IF(ISBLANK(et4ae5__Scheduled_Date_Time__c), now()+(1/96), IF(now()&gt;et4ae5__Scheduled_Date_Time__c,now()+(1/96),et4ae5__Scheduled_Date_Time__c+(1/96)))</formula>
        <name>PopulateBackupWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__SendClassFrom</fullName>
        <field>et4ae5__FromEmail__c</field>
        <formula>et4ae5__FromAddress__c</formula>
        <name>SendClassFrom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__SendComplete</fullName>
        <field>et4ae5__SendStatus__c</field>
        <literalValue>Completed</literalValue>
        <name>SendComplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__SendStatusDateTime</fullName>
        <field>et4ae5__Status_Date_Time__c</field>
        <formula>now()</formula>
        <name>SendStatusDateTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__SetConversationId</fullName>
        <field>et4ae5__ConversationId__c</field>
        <formula>$Organization.Id+Id</formula>
        <name>SetConversationId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__TrackingAsOfSD</fullName>
        <field>et4ae5__Tracking_As_Of__c</field>
        <formula>LastModifiedDate</formula>
        <name>TrackingAsOfSD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>et4ae5__UnpopulateBackupWorkflow</fullName>
        <field>et4ae5__BackupWorkflow__c</field>
        <name>UnpopulateBackupWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>BackupWorkflow</fullName>
        <active>true</active>
        <criteriaItems>
            <field>et4ae5__SendDefinition__c.et4ae5__BackupWorkflow__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>et4ae5__UnpopulateBackupWorkflow</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>et4ae5__SendDefinition__c.et4ae5__BackupWorkflow__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ScheduledSend</fullName>
        <active>true</active>
        <criteriaItems>
            <field>et4ae5__SendDefinition__c.et4ae5__Scheduled_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>et4ae5__DelayedSend</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>et4ae5__SendDefinition__c.et4ae5__Scheduled_Date_Time__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>et4ae5__FailBackupWorkflow</fullName>
        <actions>
            <name>et4ae5__FailBackupWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>et4ae5__FailBackupWorkflowM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>       NOT( et4ae5__Split_Send__c )       &amp;&amp;       (       !ISPICKVAL(et4ae5__SendStatus__c,&quot;Failed&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Completed&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Canceled&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Fail&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Complete&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Cancel&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Cancelled&quot;)    &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Deleted&quot;)  &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Paused&quot;)    &amp;&amp;         !et4ae5__TrackingOnly__c         &amp;&amp;         ISBLANK(et4ae5__BackupWorkflow__c)         &amp;&amp;         NOT         (         IF         (         ISBLANK(et4ae5__Scheduled_Date_Time__c),         (NOW()-(1/2))&lt;et4ae5__Created_Date_Time__c,         (NOW()-(1/2))&lt;et4ae5__Scheduled_Date_Time__c         ||         et4ae5__HasBeenQueued__c         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Pending Tracking Subscription&quot;)         )         )       )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__PopulateBackupWorkflow</fullName>
        <actions>
            <name>et4ae5__PopulateBackupWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>!ISPICKVAL(et4ae5__SendStatus__c,&quot;Failed&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Completed&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Canceled&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Fail&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Complete&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Cancel&quot;)         &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Cancelled&quot;)      &amp;&amp;         !ISPICKVAL(et4ae5__SendStatus__c,&quot;Deleted&quot;)     &amp;&amp;       ! et4ae5__TrackingOnly__c       &amp;&amp;       ISBLANK( et4ae5__BackupWorkflow__c )       &amp;&amp;       (       IF       (       ISBLANK(et4ae5__Scheduled_Date_Time__c) ,       ( NOW()-(1/2) ) &lt;  et4ae5__Created_Date_Time__c ,       ( NOW()-(1/2) ) &lt;  et4ae5__Scheduled_Date_Time__c       )       ||       et4ae5__HasBeenQueued__c       ||       et4ae5__Split_Send__c       )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__SendClassFrom</fullName>
        <actions>
            <name>et4ae5__SendClassFrom</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( et4ae5__FromAddress__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__SendComplete</fullName>
        <actions>
            <name>et4ae5__EmailSendStatus</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>et4ae5__SendComplete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>et4ae5__SendDefinition__c.et4ae5__SendStatus__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__SendFailed</fullName>
        <actions>
            <name>et4ae5__SendFailed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(et4ae5__Send_Status_View__c = &apos;Fail&apos; ||  et4ae5__Send_Status_View__c = &apos;Failed&apos; ||  et4ae5__Send_Status_View__c = &apos;Error&apos; ||  et4ae5__Send_Status_View__c = &apos;Errored&apos; ||  et4ae5__Send_Status_View__c = &apos;Canceled&apos; ||  et4ae5__Send_Status_View__c = &apos;Deleted&apos; ||  et4ae5__Send_Status_View__c = &apos;Paused&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__SendStatusDateTime</fullName>
        <actions>
            <name>et4ae5__SendStatusDateTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( et4ae5__SendStatus__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__SetConversationId</fullName>
        <actions>
            <name>et4ae5__SetConversationId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT( CONTAINS( et4ae5__ConversationId__c , &quot;v3_&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>et4ae5__TrackingAsOfSD</fullName>
        <actions>
            <name>et4ae5__TrackingAsOfSD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(et4ae5__NumberofExistingUndeliverables__c) || ISCHANGED(et4ae5__NumberofExistingUnsubscribes__c) || ISCHANGED(et4ae5__NumberofHardBounces__c) || ISCHANGED(et4ae5__NumberofSoftBounces__c) || ISCHANGED(et4ae5__NumberofSubscribersForwardingEmail__c) || ISCHANGED(et4ae5__NumberofTotalOpens__c) || ISCHANGED(et4ae5__NumberofUniqueClicks__c) || ISCHANGED(et4ae5__NumberofUniqueOpens__c) || ISCHANGED(et4ae5__NumberSent__c) || ISCHANGED(et4ae5__NumberUnsubscribed__c) || ISCHANGED(et4ae5__NumberofTotalClicks__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
