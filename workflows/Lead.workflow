<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Bizbox_Leadership_email</fullName>
        <description>Bizbox Leadership email</description>
        <protected>false</protected>
        <recipients>
            <recipient>728744@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>xx506090@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>xxx503276@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>zzz795789@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Lead_Responses/BBOXLead_Assignment_Template</template>
    </alerts>
    <alerts>
        <fullName>Deal_Email</fullName>
        <description>Deal Email</description>
        <protected>false</protected>
        <recipients>
            <field>Partner_Sub_Agent_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>Channel_Account_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/PRM_Partner_Lead_Registration_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>EmailLeadOwner</fullName>
        <description>Email Lead Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Responses/Lead_Assigned_Initial_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Lead_Owner_for_CANADA</fullName>
        <description>Email Lead Owner for CANADA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Lead_Assignment_Email_Template_For_CANADA1</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_Amy_Regan</fullName>
        <description>Email alert to Amy Regan</description>
        <protected>false</protected>
        <recipients>
            <recipient>mary.krotzer@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/Email_alert_to_CAMS_when_a_lead_comes_in_based_on_regions</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_Andy_oggs</fullName>
        <description>Email alert to Andy oggs</description>
        <protected>false</protected>
        <recipients>
            <recipient>mary.krotzer@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/Email_alert_to_CAMS_when_a_lead_comes_in_based_on_regions</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_Gilbert_Davis</fullName>
        <description>Email alert to Gilbert Davis</description>
        <protected>false</protected>
        <recipients>
            <recipient>mary.krotzer@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/Email_alert_to_CAMS_when_a_lead_comes_in_based_on_regions</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_Kathryn_Smith</fullName>
        <description>Email alert to Kathryn Smith</description>
        <protected>false</protected>
        <recipients>
            <recipient>mary.krotzer@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/Email_alert_to_CAMS_when_a_lead_comes_in_based_on_regions</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_to_Stephen_Flynn</fullName>
        <description>Email alert to Stephen Flynn</description>
        <protected>false</protected>
        <recipients>
            <recipient>mary.krotzer@compucom.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/Email_alert_to_CAMS_when_a_lead_comes_in_based_on_regions</template>
    </alerts>
    <alerts>
        <fullName>GTEmailLeadOwner</fullName>
        <description>GT Email Lead Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Responses/GT_Lead_Assigned_Initial_Notification</template>
    </alerts>
    <alerts>
        <fullName>GT_Web_Leads_Email_Notification</fullName>
        <description>GT Web Leads Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Responses/GT_Leads_Assignment_Template</template>
    </alerts>
    <alerts>
        <fullName>Generate_email_to_customer_upon_creation_of_Lead</fullName>
        <description>Generate email to customer upon creation of Lead.</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EXTERNAL_Customer_Contacts/Lead_to_Customer_Template</template>
    </alerts>
    <alerts>
        <fullName>Notify_Lead_Owner_change</fullName>
        <description>Notify Lead Owner change</description>
        <protected>false</protected>
        <recipients>
            <field>Previous_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/BSD_72hrs_template</template>
    </alerts>
    <alerts>
        <fullName>PRM_email_upon_Approval_of_Partner_Deal</fullName>
        <description>PRM email upon Approval of Partner Deal</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/PRM_Email_Notification_to_Partner_upon_Approval_or_Rejection_of_Partner_Deal</template>
    </alerts>
    <alerts>
        <fullName>Partner_Application_Response</fullName>
        <description>Partner Application Response</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>partnernoreply@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PRM_Templates/PRM_Partner_Application_Response_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Remind_Lead_Owner</fullName>
        <description>Remind Lead Owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Remind_Lead_Owner_48hrs</template>
    </alerts>
    <fieldUpdates>
        <fullName>Assign_to_Quentin_Brooks</fullName>
        <field>OwnerId</field>
        <lookupValue>725418@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Assign to Quentin Brooks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_Notification_Off_Flag</fullName>
        <description>Set this flag to false (if it is true) after 1hr of lead update</description>
        <field>Email_Notification_Off__c</field>
        <literalValue>0</literalValue>
        <name>Email_Notification_Off_Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_RecordTypeCanada</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Lead_Canada</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Field RecordTypeCanada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Amount</fullName>
        <field>Amount__c</field>
        <formula>Amount_CAD__c /value( $Label.Exchange_Rate)</formula>
        <name>Lead Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Clear_TZ_Deduplication_ID</fullName>
        <field>SFGA__CorrelationID__c</field>
        <name>Lead Clear TZ Deduplication ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Format_Phone_Number</fullName>
        <field>Phone</field>
        <formula>IF( 
LEN(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE( Phone , &quot;.&quot;, &apos;&apos;),&quot;-&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;))= 11, 
&quot;(&quot;&amp; 
MID(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(  Phone , &quot;.&quot;, &apos;&apos;),&quot;-&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;),2,3)&amp; 
&quot;) &quot;&amp; 
MID(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(  Phone , &quot;.&quot;, &apos;&apos;),&quot;-&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;),5,3)&amp; 
&quot;-&quot;&amp; 
MID(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(  Phone , &quot;.&quot;, &apos;&apos;),&quot;-&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;),8,4), 
&quot;(&quot;&amp; 
MID(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(  Phone , &quot;.&quot;, &apos;&apos;),&quot;-&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;),1,3)&amp; 
&quot;) &quot;&amp; 
MID(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(  Phone , &quot;.&quot;, &apos;&apos;),&quot;-&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;),4,3)&amp; 
&quot;-&quot;&amp; 
MID(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(  Phone , &quot;.&quot;, &apos;&apos;),&quot;-&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;),7,4) 
)</formula>
        <name>Lead Format Phone Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Salesgenie_remove_industry</fullName>
        <field>Industry</field>
        <name>Lead - Salesgenie - remove industry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Set_TZ_Case_Safe_ID</fullName>
        <field>Lead_ID_Case_Safe__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>Lead Set TZ Case Safe ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Set_TZ_Deduplication_ID</fullName>
        <field>SFGA__CorrelationID__c</field>
        <formula>&apos;Tech-Zone&apos;</formula>
        <name>Lead Set TZ Deduplication ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Override_Duplicate_Check_owne</fullName>
        <field>Override_Duplicate_Check_ownerid__c</field>
        <formula>OwnerId</formula>
        <name>Populate 	 Override Duplicate Check owne</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_DateTime_of_non_API_User_Update</fullName>
        <field>Time_of_non_API_User_Modification__c</field>
        <name>Reset DateTime of non API User Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Route_to_BP_Pro_User</fullName>
        <description>7/19/16 -&gt; Heather Kinley</description>
        <field>OwnerId</field>
        <lookupValue>612228@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Route to BP Pro User</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_DateTime_of_non_API_User_Update</fullName>
        <field>Time_of_non_API_User_Modification__c</field>
        <formula>NOW()</formula>
        <name>Set DateTime of non API User Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Owner_Modified_Date</fullName>
        <field>Owner_Modified_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Owner Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Send_Notification_Flag</fullName>
        <field>Send_Lead_Notification_Email__c</field>
        <literalValue>1</literalValue>
        <name>Set Send Notification Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WCW_Count_to_Zero</fullName>
        <field>WCW_Count__c</field>
        <formula>0</formula>
        <name>Set WCW Count to Zero</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_Status_Change_to_In_Triage</fullName>
        <field>Sub_Status__c</field>
        <literalValue>In Triage</literalValue>
        <name>Sub Status Change to In Triage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Substatus</fullName>
        <field>Sub_Status__c</field>
        <literalValue>Creating Account</literalValue>
        <name>Substatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Turn_Off_Email_Notification_Off_Flag</fullName>
        <field>Email_Notification_Off__c</field>
        <literalValue>0</literalValue>
        <name>Turn Off Email Notification Off Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Send_Email_To_Previous_Owner</fullName>
        <field>Send_Email_To_Previous_Owner__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Send Email To Previous Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Send_Email_field</fullName>
        <field>Send_Email_To_Owner__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Send Email field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateChangeOwnerFlag</fullName>
        <field>Change_Owner__c</field>
        <literalValue>0</literalValue>
        <name>UpdateChangeOwnerFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_72_Hour_Reassignment</fullName>
        <field>Lead_72_Hour_Reassignment__c</field>
        <literalValue>0</literalValue>
        <name>Update Lead 72 Hour Reassignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_To_Lead_Triage_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Lead_Triage</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Owner To Lead Triage Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_To_MarketoSync</fullName>
        <field>OwnerId</field>
        <lookupValue>marketo@officedepot.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Owner To MarketoSync</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Recordtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Lead_Canada</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Recordtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_company_name</fullName>
        <field>Company</field>
        <formula>Account__r.Name</formula>
        <name>Update company name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_assignemnt</fullName>
        <field>OwnerId</field>
        <lookupValue>Lead_Triage</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>update assignemnt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateownertoladtriage</fullName>
        <field>OwnerId</field>
        <lookupValue>Lead_Triage</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>updateownertoladtriage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>iSellLiveMatch__iSell_LiveRecordMatching_Lead_OM</fullName>
        <apiVersion>22.0</apiVersion>
        <description>iSell_LiveRecordMatching_Lead_OM Outbound Message used for LiveMatching</description>
        <endpointUrl>https://isell4crm.onesource.com/Web/Register/LeadNotificationService.asmx</endpointUrl>
        <fields>City</fields>
        <fields>Company</fields>
        <fields>Country</fields>
        <fields>Id</fields>
        <fields>Phone</fields>
        <fields>PostalCode</fields>
        <fields>State</fields>
        <fields>Street</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>zzz593684@officedepot.com</integrationUser>
        <name>iSell_LiveRecordMatching_Lead_OM</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Business Pro Direct-to-Flex</fullName>
        <actions>
            <name>Route_to_BP_Pro_User</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Page_Source__c</field>
            <operation>equals</operation>
            <value>direct-to-flex</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (BizBox),Lead (Tech-Zone)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (Partner)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CAD Amount</fullName>
        <actions>
            <name>Lead_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( Amount_CAD__c &gt; 0, RecordType.DeveloperName != &apos;Lead_BizBox&apos;, RecordType.DeveloperName != &apos;Lead_Partner&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Canada Web Leads</fullName>
        <actions>
            <name>Field_RecordTypeCanada</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Owner_To_Lead_Triage_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Grand and Toy Web Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (Tech-Zone)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Converted Lead Substatus</fullName>
        <actions>
            <name>Substatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Converted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (BizBox)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (Partner)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (Tech-Zone)</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Default WCW Count</fullName>
        <actions>
            <name>Set_WCW_Count_to_Zero</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNULL(WCW_Count__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Customer Lead</fullName>
        <actions>
            <name>Generate_email_to_customer_upon_creation_of_Lead</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web Lead,Web,Store Lead,BSD NET</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>System Administrator API</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (BizBox),Lead (Partner),Lead (Tech-Zone)</value>
        </criteriaItems>
        <description>Generate email to customers upon creation of Lead</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Intial Assign Prospects %26 Inactive Customers to lead triage</fullName>
        <actions>
            <name>update_assignemnt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Lead.Related_Account_Status__c</field>
            <operation>equals</operation>
            <value>Inactive Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Related_Account_Status__c</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lead (US)</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead Assignment Bulk Modified</fullName>
        <actions>
            <name>Set_Send_Notification_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>$User.LastName = &apos;Dataloader&apos; &amp;&amp; BEGINS(OwnerId , &apos;005&apos;) &amp;&amp; CreatedById &lt;&gt; OwnerId &amp;&amp; Email_Notification_Off__c &lt;&gt; TRUE &amp;&amp; (ISNEW() || ISCHANGED(OwnerId))  &amp;&amp; (ISBLANK(Owner:User.Title) = TRUE || (CONTAINS(Owner:User.Title, &apos;VP&apos;) &lt;&gt; TRUE &amp;&amp; CONTAINS(Owner:User.Title, &apos;President&apos;) &lt;&gt; TRUE &amp;&amp; CONTAINS(Owner:User.Title, &apos;CEO&apos;) &lt;&gt; TRUE))  &amp;&amp; ((RecordType.Name = &apos;Lead (US)&apos; &amp;&amp; (TEXT(LeadSource) = &apos;Store Lead&apos; || TEXT(LeadSource) = &apos;BSD NET&apos;)) || RecordType.Name = &apos;Lead (Canada)&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Assignment GT Initial Notification</fullName>
        <actions>
            <name>GTEmailLeadOwner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify sales reps when leads are assigned to them</description>
        <formula>(ISNEW() || ISCHANGED(OwnerId))  &amp;&amp; $User.LastName &lt;&gt; &apos;Dataloader&apos; &amp;&amp; BEGINS(OwnerId , &apos;005&apos;) &amp;&amp; CreatedById &lt;&gt; OwnerId  &amp;&amp; (ISBLANK(Owner:User.Title) = TRUE || (CONTAINS(Owner:User.Title, &apos;VP&apos;) &lt;&gt; TRUE &amp;&amp; CONTAINS(Owner:User.Title, &apos;President&apos;) &lt;&gt; TRUE &amp;&amp; CONTAINS(Owner:User.Title, &apos;CEO&apos;) &lt;&gt; TRUE))  &amp;&amp; RecordType.Name = &apos;Lead (Canada)&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Assignment Initial Notification</fullName>
        <actions>
            <name>EmailLeadOwner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify sales reps when leads are assigned to them</description>
        <formula>(ISNEW() || ISCHANGED(OwnerId))  &amp;&amp; $User.LastName &lt;&gt; &apos;Dataloader&apos; &amp;&amp; BEGINS(OwnerId , &apos;005&apos;) &amp;&amp; CreatedById &lt;&gt; OwnerId  &amp;&amp; (TEXT(LeadSource) = &apos;Store Lead&apos; || TEXT(LeadSource) = &apos;BSD NET&apos;)  &amp;&amp; (ISBLANK(Owner:User.Title) = TRUE || (CONTAINS(Owner:User.Title, &apos;VP&apos;) &lt;&gt; TRUE &amp;&amp; CONTAINS(Owner:User.Title, &apos;President&apos;) &lt;&gt; TRUE &amp;&amp; CONTAINS(Owner:User.Title, &apos;CEO&apos;) &lt;&gt; TRUE))  &amp;&amp; RecordType.Name = &apos;Lead (US)&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Assignment Owner Modified</fullName>
        <actions>
            <name>Set_Owner_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Assignment Turn Off Lead Notification Off Flag</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Email_Notification_Off__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Turn_Off_Email_Notification_Off_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Lead Clear TZ Dedup ID</fullName>
        <actions>
            <name>Lead_Clear_TZ_Deduplication_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clears the deduplication ID when a record is not Tech-Zone and has an ID.</description>
        <formula>NOT(CONTAINS(RecordType.DeveloperName, &apos;Tech_Zone&apos;)) &amp;&amp; SFGA__CorrelationID__c = &apos;Tech-Zone&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead In Triage</fullName>
        <actions>
            <name>Sub_Status_Change_to_In_Triage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( (Owner:Queue.Id = &apos;00GE0000000umec&apos;),  (ISPICKVAL(Status, &quot;Open&quot;)), RecordType.DeveloperName != &apos;Lead_BizBox&apos;, RecordType.DeveloperName != &apos;Lead_Partner&apos; )&amp;&amp; (!CONTAINS(RecordType.Name,&apos;(Tech-Zone)&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead In salesforce to Triage</fullName>
        <actions>
            <name>updateownertoladtriage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND ((OwnerId = &apos;005E0000000lNbV&apos;), ( ISPICKVAL(Status, &quot;Open&quot;)|| ISPICKVAL(Status, &quot;New&quot;)) ,RecordTypeId =&apos;012E000000093HI&apos;   ,                !(ISPICKVAL(LeadSource, &quot;Grand and Toy Web Lead&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Phone Number Updated</fullName>
        <actions>
            <name>Lead_Format_Phone_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Formats the phone number to mimic how a phone number would be formatted by Salesforce in Classic and saved in the database (LEX does not auto format phone numbers in the DB).</description>
        <formula>AND(  NOT(  AND(  LEN(Phone) == 14,  LEFT(Phone,1) == &apos;(&apos;,  ISNUMBER(LEFT(RIGHT(Phone,13),3)),  LEFT(RIGHT(Phone,10),1) == &apos;)&apos;,  LEFT(RIGHT(Phone,9),1) == &apos; &apos;,  ISNUMBER(LEFT(RIGHT(Phone,8),3)),  LEFT(RIGHT(Phone,5),1) == &apos;-&apos;,  ISNUMBER(RIGHT(Phone,4))  )  ),  ISNUMBER(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(Phone , &quot;.&quot;, &apos;&apos;),&quot;-&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;)),  OR(  LEN(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(Phone ,&quot;.&quot;,&apos;&apos;),&quot;-&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;))=10,  AND(  LEN(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(Phone,&quot;.&quot;,&apos;&apos;),&quot;-&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;))=11,  LEFT(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(Phone ,&quot;.&quot;,&apos;&apos;),&quot;-&quot;,&quot;&quot;),&quot;+&quot;,&quot;&quot;),1)=&quot;1&quot;  )  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Range 1-19 WCW Count</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Lead.WCW_Count__c</field>
            <operation>lessThan</operation>
            <value>20</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Web Lead,Web,Store Lead,BSD NET</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (BizBox),Lead (Partner)</value>
        </criteriaItems>
        <description>Send an email to Lead for range 1-19 WCW Count</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Set TZ Dedup ID</fullName>
        <actions>
            <name>Lead_Set_TZ_Case_Safe_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Set_TZ_Deduplication_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the deduplication ID on Tech-Zone leads.  Used by duplicate matching rules to identify Tech-Zone leads since record type name is unavailable in conditions.  Also sets case safe lead ID.</description>
        <formula>CONTAINS(RecordType.DeveloperName, &apos;Tech_Zone&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LeadAssignmentNotification</fullName>
        <actions>
            <name>EmailLeadOwner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND( OR(ISNEW(),ISCHANGED(OwnerId)), OwnerId &lt;&gt; CreatedById, RecordType.DeveloperName != &apos;Lead_BizBox&apos;, RecordType.DeveloperName != &apos;Lead_Partner&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LeadAssignmentNotificationBizbox</fullName>
        <actions>
            <name>Bizbox_Leadership_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Rule to send the notifications when Lead gets created for BIZ BOX  to leadership team</description>
        <formula>RecordType.DeveloperName == &apos;Lead_BizBox&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LeadAssignmentNotificationForCAN</fullName>
        <actions>
            <name>Email_Lead_Owner_for_CANADA</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordType.DeveloperName != &apos;Lead_BizBox&apos;, RecordType.DeveloperName != &apos;Lead_Partner&apos;, RecordType.DeveloperName != &apos;Lead_Deals&apos;, RecordType.Name &lt;&gt; &apos;Lead (Tech-Zone)&apos; , OR( ISNEW(), AND(ISCHANGED( OwnerId ),ISPICKVAL(Country__c,&quot;CAN&quot;)) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LeadAssignment_Email_Notification_Off</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Email_Notification_Off__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (BizBox)</value>
        </criteriaItems>
        <description>Rule to set the Email_Notification_Off to &apos;false&apos; after 1hr of lead update.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Notification_Off_Flag</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead.LastModifiedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Marketo Canada Leads</fullName>
        <actions>
            <name>Update_Owner_To_MarketoSync</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Recordtype</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Marketo</value>
        </criteriaItems>
        <description>This rule is created under supoort #02464703</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Notify owner change</fullName>
        <actions>
            <name>Notify_Lead_Owner_change</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Reset_DateTime_of_non_API_User_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_Send_Email_To_Previous_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Send_Email_To_Previous_Owner__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (BizBox),Lead (Partner),Lead (Tech-Zone)</value>
        </criteriaItems>
        <description>Notify owner change if the lead was not worked for  72 hours.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Owner Assignment - Chamber</fullName>
        <actions>
            <name>Assign_to_Quentin_Brooks</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>BSD NET</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Page_Source__c</field>
            <operation>equals</operation>
            <value>chamber</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (BizBox),Lead (Partner),Lead (Tech-Zone)</value>
        </criteriaItems>
        <description>to change lead owner to Quentin Brooks while lead source equals BSD Net &amp; Lead Page Source equals chamber</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PRM Email upon Approval of Partner Deal</fullName>
        <actions>
            <name>PRM_email_upon_Approval_of_Partner_Deal</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>RecordType.DeveloperName == &apos;Tech_Zone&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Partner Application Response</fullName>
        <actions>
            <name>Partner_Application_Response</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lead (Partner)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Partner Registration Form</value>
        </criteriaItems>
        <description>Email sent to Partner upon application</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Partner Lead Registration</fullName>
        <actions>
            <name>Deal_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lead (Deals)</value>
        </criteriaItems>
        <description>Email sent to Partner upon deal registration</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate lead owner on account based on custom field</fullName>
        <actions>
            <name>Populate_Override_Duplicate_Check_owne</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (BizBox),Lead (Partner),Lead (Tech-Zone)</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Remind Lead Owner</fullName>
        <actions>
            <name>Remind_Lead_Owner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Uncheck_Send_Email_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Send_Email_To_Owner__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (BizBox),Lead (Partner),Lead (Tech-Zone)</value>
        </criteriaItems>
        <description>Remind Lead Owner if the lead is not worked for 48 hrs</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Salesgenie - remove industry</fullName>
        <actions>
            <name>Lead_Salesgenie_remove_industry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>Salesgenie.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Lead (BizBox),Lead (Partner),Lead (Tech-Zone)</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set DateTime of non API User Update</fullName>
        <actions>
            <name>Set_DateTime_of_non_API_User_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( $Setup.API_Profile_User_List__c.Run_Rule__c,  ISPICKVAL(Status , &quot;Open&quot;),  OR(ISPICKVAL(LeadSource,&quot;BSD NET&quot;),ISPICKVAL(LeadSource,&quot;Customer Service&quot;),ISPICKVAL(LeadSource,&quot;Web Lead&quot;),ISPICKVAL(LeadSource,&quot;Store Lead&quot;)),  OR(NOT(ISPICKVAL(Industry,&quot;Government&quot;)),NOT(ISPICKVAL(Industry,&quot;Education/Schools&quot;))), RecordType.DeveloperName != &apos;Lead_BizBox&apos;, RecordType.DeveloperName != &apos;Lead_Partner&apos;, (RecordType.Name &lt;&gt; &apos;Lead (Tech-Zone)&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead 72 Hour Reassignment</fullName>
        <actions>
            <name>Update_Lead_72_Hour_Reassignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( LastModifiedBy.Alias != &apos;oodsf&apos;, Lead_72_Hour_Reassignment__c == true, RecordType.DeveloperName != &apos;Lead_BizBox&apos;, RecordType.DeveloperName != &apos;Lead_Partner&apos;, RecordType.Name &lt;&gt; &apos;Lead (Tech-Zone)&apos;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update company name</fullName>
        <actions>
            <name>Update_company_name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update company name from attached Account</description>
        <formula>IF( AND(Account__c != null, Company != null) , true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateChangeOwnerFlag</fullName>
        <actions>
            <name>UpdateChangeOwnerFlag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( LastModifiedBy.Alias != &apos;oodsf&apos;, Change_Owner__c ==true,  RecordType.DeveloperName != &apos;Lead_BizBox&apos;, RecordType.DeveloperName != &apos;Lead_Partner&apos;, RecordType.Name &lt;&gt; &apos;Lead (Tech-Zone)&apos;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
