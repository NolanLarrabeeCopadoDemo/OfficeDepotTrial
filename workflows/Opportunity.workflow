<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_for_UnAssigned_New_Tech_Quote_Opportunities</fullName>
        <ccEmails>techsolutions@officedepot.com</ccEmails>
        <ccEmails>chris.reda@officedepot.com</ccEmails>
        <description>Email for UnAssigned New Tech Quote Opportunities</description>
        <protected>false</protected>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunities_Notice/New_Non_Assigned_quote</template>
    </alerts>
    <alerts>
        <fullName>Email_for_the_New_Opportunity_Upload</fullName>
        <description>Email for the New Opportunity Upload</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>OD_SPC/ATR</template>
    </alerts>
    <alerts>
        <fullName>Notify_Account_Owner</fullName>
        <description>Notify Account Owner</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EXTERNAL_Partner_Templates/Notify_Rep_of_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Open_Opportunities_Need_Action</fullName>
        <ccEmails>michael.houng@officedepot.com</ccEmails>
        <description>Open Opportunities Need Action</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/WRF_Manager_Notification</template>
    </alerts>
    <alerts>
        <fullName>Open_Opportunities_Need_Actions</fullName>
        <ccEmails>michael.houng@officedepot.com</ccEmails>
        <description>Open Opportunities Need Actions</description>
        <protected>false</protected>
        <recipients>
            <recipient>ContractDivision</recipient>
            <type>roleSubordinates</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/WRF_Manager_Notification</template>
    </alerts>
    <alerts>
        <fullName>Opp_Closed_won_deal_alert</fullName>
        <ccEmails>smbprojects@compucom.com</ccEmails>
        <ccEmails>dealdesk@ps.compucom.com</ccEmails>
        <description>Opp: Closed won deal alert (exec+managers)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>US</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <recipients>
            <recipient>andrew.smith@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mary.krotzer@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>steve.upton@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomas.mcmillan@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>BDR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Win_Announcement</template>
    </alerts>
    <alerts>
        <fullName>Opp_Closed_won_deal_alert_managers</fullName>
        <ccEmails>smbprojects@compucom.com</ccEmails>
        <ccEmails>dealdesk@ps.compucom.com</ccEmails>
        <description>Opp: Closed won deal alert (managers)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>Solution_Architects</recipient>
            <type>roleSubordinatesInternal</type>
        </recipients>
        <recipients>
            <recipient>andrew.smith@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>mary.krotzer@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>steve.upton@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomas.mcmillan@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>BDR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/Win_Announcement</template>
    </alerts>
    <alerts>
        <fullName>Opp_Notify_new_owner</fullName>
        <description>Opp: Notify new owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>andrew.smith@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Emails/New_Opportunity_Assigned</template>
    </alerts>
    <alerts>
        <fullName>PRM_Email_Notification_to_Partner_of_Closed_Lost_Oppty</fullName>
        <description>PRM Email Notification to Partner of Closed Lost Oppty</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Sub_Agent_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/PRM_Email_Notification_to_Partner_of_Closed_Lost_Oppty</template>
    </alerts>
    <alerts>
        <fullName>PRM_Email_Notification_to_Partner_upon_Conversion_of_Lead_to_Opportunity</fullName>
        <description>PRM Email Notification to Partner upon Conversion of Lead to Opportunity</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Sub_Agent_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/PRM_Email_Notification_to_Partner_upon_Conversion_of_Lead_to_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>PRM_Partner_Deal_Opportunity_being_Won</fullName>
        <description>PRM Partner Deal Opportunity being Won</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Sub_Agent_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/PRM_Email_Notification_to_Partner_upon_a_Partner_Deal_Opportunity_being_Won</template>
    </alerts>
    <alerts>
        <fullName>Tech_Depot_New_Quote_Submitted</fullName>
        <ccEmails>Chris.reda@officedepot.com</ccEmails>
        <description>Tech Depot - New Quote Submitted</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunities_Notice/New_Technology_Quote</template>
    </alerts>
    <fieldUpdates>
        <fullName>Amount</fullName>
        <field>Amount</field>
        <formula>Amount_CAD__c /Value( $Label.Exchange_Rate)</formula>
        <name>Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Date</fullName>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Opp</fullName>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Close Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Comm_Forecast</fullName>
        <field>Committed_Forecast__c</field>
        <formula>Committed_Forecast_CAD__c /Value( $Label.Exchange_Rate)</formula>
        <name>Comm Forecast</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Increment_Push_Counter_Field</fullName>
        <description>Increment the Push Counter by 1</description>
        <field>Push_Counter__c</field>
        <formula>IF( 
ISNULL( Push_Counter__c ), 
1, 
Push_Counter__c + 1 
)</formula>
        <name>Increment Push Counter Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Open_Opp_if_more_than_0_100</fullName>
        <field>Status__c</field>
        <literalValue>Open</literalValue>
        <name>Open Opp if more than 0/100</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Date_Today</fullName>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>Update Closed Date Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Amount_CAD</fullName>
        <field>Amount_CAD__c</field>
        <formula>Amount</formula>
        <name>Update Opportunity Amount (CAD)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Previous_Stage</fullName>
        <description>Updates the prior stage when the opportunity stage changes.</description>
        <field>Previous_Stage__c</field>
        <formula>TEXT(PRIORVALUE(StageName))</formula>
        <name>Update Previous Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Advising</fullName>
        <field>StageName</field>
        <literalValue>Advising</literalValue>
        <name>Update Stage to Advising</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>ATR- Emails</fullName>
        <actions>
            <name>Email_for_the_New_Opportunity_Upload</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Opportuntity Uploads</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Amount</fullName>
        <actions>
            <name>Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>Amount_CAD__c &gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Close Opp if Stage is 0%2F100</fullName>
        <actions>
            <name>Close_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won,Lost,Walkaway,Duplicate/Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Status__c</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Opportunity (Tech-Zone)</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Comm Forecast</fullName>
        <actions>
            <name>Comm_Forecast</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>Committed_Forecast_CAD__c &gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GT Opp Closed Won</fullName>
        <actions>
            <name>Update_Closed_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordTypeId = &apos;012E000000093Jv&apos; &amp;&amp; Text(StageName) = &apos;Close&apos; &amp;&amp; ISCHANGED(StageName)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Notification to Account Owner</fullName>
        <actions>
            <name>Notify_Account_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.LeadSource</field>
            <operation>equals</operation>
            <value>BSD NET</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Product__c</field>
            <operation>equals</operation>
            <value>Tech</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>notEqual</operation>
            <value>Salesforce</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Opportunity (Tech-Zone)</value>
        </criteriaItems>
        <description>Notification to Account Owner when TSR Rep creates an Opportunity for a technology quote.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Close Date when Lost</fullName>
        <actions>
            <name>Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Lost</value>
        </criteriaItems>
        <description>Populates the Close Date when an Opportunity is Lost.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Prior StageName Value</fullName>
        <actions>
            <name>Update_Previous_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will show the prior value of the StageName field.</description>
        <formula>AND(ISCHANGED(StageName), NOT(ISBLANK(TEXT(StageName))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Push Counter</fullName>
        <actions>
            <name>Increment_Push_Counter_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Increment the Push Counter field by 1</description>
        <formula>AND(IF( CloseDate &gt; PRIORVALUE( CloseDate ), IF (MONTH(CloseDate) &lt;&gt; MONTH(PRIORVALUE( CloseDate )) , TRUE, FALSE), FALSE), RecordType.Name &lt;&gt; &apos;Opportunity (Tech-Zone)&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TZ Opportunity Changed to Closed %28any%29</fullName>
        <actions>
            <name>Update_Closed_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>CONTAINS( RecordType.DeveloperName , &apos;Tech_Zone&apos;)   &amp;&amp; ISCHANGED( StageName ) &amp;&amp; IsClosed  &amp;&amp; NOT( PRIORVALUE( IsClosed ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Technology Quote - New</fullName>
        <actions>
            <name>Tech_Depot_New_Quote_Submitted</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product__c</field>
            <operation>equals</operation>
            <value>Tech</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LeadSource</field>
            <operation>equals</operation>
            <value>BSDNETquote</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Opportunity (Tech-Zone)</value>
        </criteriaItems>
        <description>Triggers Email Alert to opportunity owner of a new technology quote from BSD or GMILL</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Technology Quote - New Unassigned</fullName>
        <actions>
            <name>Email_for_UnAssigned_New_Tech_Quote_Opportunities</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product__c</field>
            <operation>equals</operation>
            <value>Tech</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.LeadSource</field>
            <operation>equals</operation>
            <value>BSDNETquote</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.OwnerId</field>
            <operation>contains</operation>
            <value>Salesforce</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Opportunity (Tech-Zone)</value>
        </criteriaItems>
        <description>Triggers Email Alert to opportunity owner of a new technology quote from BSD or GMILL and the owner is not assigned</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Technology Quote -update persue to advising</fullName>
        <actions>
            <name>Update_Stage_to_Advising</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Pursue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Opportunity (Tech-Zone)</value>
        </criteriaItems>
        <description>Technology Quote -update persue to advising</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Amount %28CAD%29 from its OLI</fullName>
        <actions>
            <name>Update_Opportunity_Amount_CAD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Amount)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
