<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contact_Clear_TZ_Deduplication_ID</fullName>
        <field>Latest_opt_decision_source__c</field>
        <name>Contact Clear TZ Deduplication ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Set_TZ_Deduplication_ID</fullName>
        <field>Latest_opt_decision_source__c</field>
        <formula>&apos;Tech-Zone&apos;</formula>
        <name>Contact Set TZ Deduplication ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GT_Update_Email_Permission_Flag</fullName>
        <field>Email_permission_flag__c</field>
        <formula>&quot;Yes&quot;</formula>
        <name>GT Update Email Permission Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phone1Type</fullName>
        <field>Phone_Type1__c</field>
        <literalValue>Other</literalValue>
        <name>Phone1Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Phone1Upd</fullName>
        <field>Phone1_Rep__c</field>
        <formula>Phone</formula>
        <name>Phone1Upd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PhoneUpd</fullName>
        <field>Phone</field>
        <formula>Phone1_Rep__c</formula>
        <name>PhoneUpd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RecordType_to_MDR_Contact</fullName>
        <description>Update RecordType to MDR Contact</description>
        <field>RecordTypeId</field>
        <lookupValue>MDR_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RecordType to MDR Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EmailConcatenationField</fullName>
        <field>Email_Concatenation__c</field>
        <formula>Email1__c + &quot;,&quot; + Email2__c + &quot;,&quot; + Email3__c</formula>
        <name>Set EmailConcatenationField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Email_Modified_Date</fullName>
        <field>Email_Modified_Date__c</field>
        <formula>now()</formula>
        <name>Set Email Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_Source_As_SFDC</fullName>
        <field>Contact_Source__c</field>
        <formula>&quot;SFDC&quot;</formula>
        <name>Update Contact Source As SFDC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_GT_Contact_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>GT_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update GT Contact RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Capture Email Changes</fullName>
        <actions>
            <name>Set_Email_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow captures email changes.</description>
        <formula>AND(IF(OR(AND(ISNEW(),Email &lt;&gt; null), PRIORVALUE( Email ) &lt;&gt; Email) , true, false), RecordType.Name &lt;&gt; &apos;Contact (Tech-Zone)&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact Clear TZ Dedup ID</fullName>
        <actions>
            <name>Contact_Clear_TZ_Deduplication_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clears the deduplication ID when a record is not Tech-Zone and has an ID.</description>
        <formula>NOT(CONTAINS(RecordType.DeveloperName, &apos;Tech_Zone&apos;))  &amp;&amp; Latest_opt_decision_source__c = &apos;Tech-Zone&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact Set TZ Dedup ID</fullName>
        <actions>
            <name>Contact_Set_TZ_Deduplication_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the deduplication ID on Tech-Zone contacts. Used by duplicate matching rules to identify Tech-Zone contacts since record type name is unavailable in conditions.</description>
        <formula>CONTAINS(RecordType.DeveloperName, &apos;Tech_Zone&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CopyPhone1toPhone</fullName>
        <actions>
            <name>PhoneUpd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(ISCHANGED(Phone1_Rep__c),AND( ISNEW() , NOT(ISBLANK(Phone1_Rep__c)))) , RecordType.Name &lt;&gt; &apos;Contact (Tech-Zone)&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CopyPhonetoPhone1</fullName>
        <actions>
            <name>Phone1Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Phone1Upd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(OR(AND(ISCHANGED(Phone), OR(ISNULL(Phone1_Rep__c), ISBLANK(Phone1_Rep__c))),AND(ISNEW(),NOT(ISBLANK(Phone)),OR(ISNULL(Phone1_Rep__c), ISBLANK(Phone1_Rep__c)))), RecordType.Name &lt;&gt; &apos;Contact (Tech-Zone)&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GT Update Email Permission Flag</fullName>
        <actions>
            <name>GT_Update_Email_Permission_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>GT Contact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email_permission_flag__c</field>
            <operation>equals</operation>
            <value>Y</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MDR RT Switch</fullName>
        <actions>
            <name>RecordType_to_MDR_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Prod Fix: 00826531</description>
        <formula>(MDR_Contact__c &lt;&gt; null &amp;&amp; RecordType.Name = &apos;Contact(US)&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MaintainEmailConcatenationField</fullName>
        <actions>
            <name>Set_EmailConcatenationField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISNEW() || ISCHANGED(Email1__c) || ISCHANGED(Email2__c) || ISCHANGED(Email3__c)) &amp;&amp; (NOT(ISBLANK(Email1__c)) || NOT(ISBLANK(Email2__c)) || NOT(ISBLANK(Email3__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Contact Source As SFDC</fullName>
        <actions>
            <name>Update_Contact_Source_As_SFDC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>GT Contact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.CreatedById</field>
            <operation>notEqual</operation>
            <value>Odsfa Odsfa,Dataloader</value>
        </criteriaItems>
        <description>Update Contact Source As SFDC</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update GT Contact RecordType</fullName>
        <actions>
            <name>Update_GT_Contact_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Contact.OMX_Primary_Key__c</field>
            <operation>contains</operation>
            <value>-GT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Contact_Source__c</field>
            <operation>equals</operation>
            <value>MAX</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
