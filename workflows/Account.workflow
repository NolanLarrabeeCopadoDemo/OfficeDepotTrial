<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_for_Failed_Account_Setups</fullName>
        <description>Email for Failed Account Setups</description>
        <protected>false</protected>
        <recipients>
            <recipient>526588@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>573141@officedepot.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AccountSetup_Emails/Minimum_Order_Value</template>
    </alerts>
    <alerts>
        <fullName>Send_a_Email_to_Rep_on_Customer_Creation</fullName>
        <ccEmails>ODGOMPS@officedepot.com</ccEmails>
        <description>Send a Email to Rep on Customer Creation</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>AccountSetup_Emails/MPS_Account_Setup</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Clear_TZ_Deduplication_ID</fullName>
        <field>Setup_URL1__c</field>
        <name>Account Clear TZ Deduplication ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Potential</fullName>
        <field>Est_Spend__c</field>
        <formula>Est_Spend_CAD__c /Value( $Label.Exchange_Rate)</formula>
        <name>Account Potential</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_TZ_Deduplication_ID</fullName>
        <field>Setup_URL1__c</field>
        <formula>&apos;Tech-Zone&apos;</formula>
        <name>Account Set TZ Deduplication ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Existing_Provider_Last_Updated_Date</fullName>
        <field>Existing_Provider_Last_Updated_Date__c</field>
        <formula>today()</formula>
        <name>Existing Provider Last Updated Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Great_Grandparent_Hierarchy</fullName>
        <description>When  Recordtype is &quot;Great Grandparent&quot;  update Hierarchy Type to &quot;GG&quot;</description>
        <field>Hierarchy__c</field>
        <formula>&quot;GG&quot;</formula>
        <name>Great Grandparent Hierarchy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_Terms_Credit_Card</fullName>
        <field>Payment_Term__c</field>
        <literalValue>Credit Card</literalValue>
        <name>Payment Terms Credit Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_Site_Flag_To_False</fullName>
        <field>Primary_Site__c</field>
        <literalValue>0</literalValue>
        <name>Primary Site Flag To False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_Site_Flag_To_True</fullName>
        <field>Primary_Site__c</field>
        <literalValue>1</literalValue>
        <name>Primary Site Flag To True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetHeaderRecordAccess</fullName>
        <field>Header_Record_Access__c</field>
        <literalValue>0</literalValue>
        <name>SetHeaderRecordAccess</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetPreviousOwner</fullName>
        <field>Previous_Owner_ID__c</field>
        <formula>PRIORVALUE(OwnerId)</formula>
        <name>SetPreviousOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Customer_Setup_Completed_Date</fullName>
        <field>Customer_Setup_Completed__c</field>
        <formula>Now()</formula>
        <name>Set Customer Setup Completed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Customer_Setup_Requested_Date</fullName>
        <field>Customer_Setup_Requested__c</field>
        <formula>Now()</formula>
        <name>Set Customer Setup Requested Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Type_to_Customer</fullName>
        <field>Type</field>
        <literalValue>Customer</literalValue>
        <name>Set Type to Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Type_to_Prospect</fullName>
        <field>Type</field>
        <literalValue>Prospect</literalValue>
        <name>Set Type to Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Type_to_Site</fullName>
        <field>Type</field>
        <literalValue>Site</literalValue>
        <name>Set Type to Site</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_account_level_to_header</fullName>
        <field>Account_Level__c</field>
        <literalValue>Header</literalValue>
        <name>Set account level to header</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_account_level_to_site</fullName>
        <field>Account_Level__c</field>
        <literalValue>Site</literalValue>
        <name>Set account level to site</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_hierarchy_Type_GrandParent</fullName>
        <field>Hierarchy__c</field>
        <formula>&quot;GP&quot;</formula>
        <name>Update hierarchy Type GrandParent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_segment_north</fullName>
        <field>Segment__c</field>
        <literalValue>Small &lt; $40K</literalValue>
        <name>Update segment north</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_to_Recordtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Parent</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update to Recordtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>clear_Impl_Mgr</fullName>
        <field>Implementation_Manager__c</field>
        <name>clear Impl Mgr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>iSellLiveMatch__iSell_LiveRecordMatching_Account_OM</fullName>
        <apiVersion>22.0</apiVersion>
        <description>AccountOSOM Outbound Message used for LiveMatching</description>
        <endpointUrl>https://isell4crm.onesource.com/Web/Register/AccountNotificationService.asmx</endpointUrl>
        <fields>BillingCity</fields>
        <fields>BillingCountry</fields>
        <fields>BillingPostalCode</fields>
        <fields>BillingState</fields>
        <fields>BillingStreet</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>Phone</fields>
        <fields>ShippingCity</fields>
        <fields>ShippingCountry</fields>
        <fields>ShippingPostalCode</fields>
        <fields>ShippingState</fields>
        <fields>ShippingStreet</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>zzz593684@officedepot.com</integrationUser>
        <name>iSell_LiveRecordMatching_Account_OM</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Account  Grandparent</fullName>
        <actions>
            <name>Update_hierarchy_Type_GrandParent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>GrandParent</value>
        </criteriaItems>
        <description>When  record-type is Grandparent&quot;  update Hierarchy Type to &quot;GP&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account Clear TZ Dedup ID</fullName>
        <actions>
            <name>Account_Clear_TZ_Deduplication_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clears the deduplication ID when a record is not Tech-Zone and has an ID.</description>
        <formula>NOT(CONTAINS(RecordType.DeveloperName, &apos;Tech_Zone&apos;))  &amp;&amp; Setup_URL1__c = &apos;Tech-Zone&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account Great Grandparent</fullName>
        <actions>
            <name>Great_Grandparent_Hierarchy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Great Grandparent</value>
        </criteriaItems>
        <description>When  record-type is &quot;Great Grandparent&quot;  update Hierarchy Type to &quot;GG&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Account Potential</fullName>
        <actions>
            <name>Account_Potential</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Est_Spend_CAD__c &gt; 0  &amp;&amp;  (!CONTAINS(RecordType.Name,&apos;(Tech-Zone)&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Set TZ Dedup ID</fullName>
        <actions>
            <name>Account_Set_TZ_Deduplication_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the deduplication ID on Tech-Zone accounts. Used by duplicate matching rules to identify Tech-Zone accounts since record type name is unavailable in conditions.</description>
        <formula>CONTAINS(RecordType.DeveloperName, &apos;Tech_Zone&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AccountHeaderAccess</fullName>
        <actions>
            <name>SetHeaderRecordAccess</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SetPreviousOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow enables site owner to edit account. A batch process picks up the changes.</description>
        <formula>(RecordTypeId == &apos;012E00000008dTcIAI&apos; || RecordTypeId == &apos;012E00000008dTc&apos;) &amp;&amp; ISCHANGED( OwnerId ) &amp;&amp; NOT( ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Clear Impl Mgr For GP</fullName>
        <actions>
            <name>clear_Impl_Mgr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF ((RecordType.Name  == &apos;GrandParent&apos;  || RecordType.Name  == &apos;Great Grandparent&apos; )&amp;&amp;  Implementation_Manager__c != null,true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DNBi Declined Credit Card Only</fullName>
        <actions>
            <name>Payment_Terms_Credit_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.DNBI_CREDIT_OUTCOME__c</field>
            <operation>equals</operation>
            <value>Declined</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <description>If DNBi credit outcome is &quot;Declined&quot; then Payment Terms should only allow &quot;Credit Card&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email on Account Setup</fullName>
        <actions>
            <name>Send_a_Email_to_Rep_on_Customer_Creation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send a Email to Rep when the Account Setup is completed.</description>
        <formula>IF((RecordType.DeveloperName=&apos;Customer&apos;) &amp;&amp; ISCHANGED( RecordTypeId ) &amp;&amp; ISPICKVAL(Primary_Product__c, &apos;MPS&apos;) , true, false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Failed Account Setup</fullName>
        <actions>
            <name>Email_for_Failed_Account_Setups</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Account_Setup_Request_Status__c</field>
            <operation>contains</operation>
            <value>Failed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Prospect (Tech-Zone),Customer (Tech-Zone)</value>
        </criteriaItems>
        <description>email notification when an account setup gets transmitted and returns with a failed setup</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>GP_GGP_Salesrepid_owner_update</fullName>
        <active>false</active>
        <formula>IF ((RecordType.Name  == &apos;GrandParent&apos;  || RecordType.Name  == &apos;Great Grandparent&apos; )&amp;&amp;  Sales_PersonID__c != null,true,false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Invalid north segments to small%3C40k</fullName>
        <actions>
            <name>Update_segment_north</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Segment__c</field>
            <operation>equals</operation>
            <value>SBAR,NONETL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Prospect (Tech-Zone),Customer (Tech-Zone)</value>
        </criteriaItems>
        <description>Switches segments SBAR and NONETL on north accounts to &quot;Small &lt; $40K&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Parent Account</fullName>
        <actions>
            <name>Update_to_Recordtype</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is a temporary fix for the issue where the Account Service Batch sets the Record Type to Customer indiscriminately. If hierarchy type is P, Aops Id is not null, Record Type is Customer and the criteria was not met before update Record Type to Parent</description>
        <formula>Hierarchy__c =&apos;P&apos; &amp;&amp; AOPS_Cust_Id__c !=null &amp;&amp; RecordType_Name__c = &apos;Customer&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate account level from record type %28header%29</fullName>
        <actions>
            <name>Set_account_level_to_header</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>contains</operation>
            <value>Account Setup Requested,Customer,Prospect</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate account level from record type %28site%29</fullName>
        <actions>
            <name>Set_account_level_to_site</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>contains</operation>
            <value>Site</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Customer %28GT%29 Setup Completed Date</fullName>
        <actions>
            <name>Set_Customer_Setup_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer (GT)</value>
        </criteriaItems>
        <description>Sets the Account Setup Completed Date when the AOPS sends completed file back into system and updates the account recordtype changes to &quot;Customer GT&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Customer Setup Completed Date</fullName>
        <actions>
            <name>Set_Customer_Setup_Completed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <description>Sets the Account Setup Completed Date when the AOPS sends completed file back into system and updates the account recordtype changes to &quot;Customer&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Customer Setup Requested Date</fullName>
        <actions>
            <name>Set_Customer_Setup_Requested_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Setup Requested</value>
        </criteriaItems>
        <description>Sets the Account Setup Requested Date when a user completes the survey and submits.  Fires off of when account recordtype changes to &quot;Account Setup Requested&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Primary Site Flag To False</fullName>
        <actions>
            <name>Primary_Site_Flag_To_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will set the primary site flag to false based on the aops seq Id</description>
        <formula>AOPS_Seq_ID__c &lt;&gt; Null &amp;&amp; (!CONTAINS(RIGHT(AOPS_Seq_ID__c, 6),&apos;-00001&apos;)) &amp;&amp; Primary_Site__c = True</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Primary Site Flag To True</fullName>
        <actions>
            <name>Primary_Site_Flag_To_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will set the primary site flag to true based on the aops seq Id.</description>
        <formula>CONTAINS(RIGHT(AOPS_Seq_ID__c, 6),&apos;-00001&apos;) &amp;&amp; Primary_Site__c &lt;&gt; True</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Type to Customer</fullName>
        <actions>
            <name>Set_Type_to_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <description>Set Recordtype for use on Opportunity Object.  (Cannot bring in standard account recordtype field in formulas - limitation)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Type to Prospect</fullName>
        <actions>
            <name>Set_Type_to_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect,Account Setup Requested</value>
        </criteriaItems>
        <description>Set Recordtype for use on Opportunity Object.  (Cannot bring in standard account recordtype field in formulas - limitation)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Type to Site</fullName>
        <actions>
            <name>Set_Type_to_Site</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Site</value>
        </criteriaItems>
        <description>Set Recordtype for use on Opportunity Object.  (Cannot bring in standard account recordtype field in formulas - limitation)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TZ%3A Account%3A Existing provider attributes updated Back To SetupHelp</fullName>
        <actions>
            <name>Existing_Provider_Last_Updated_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>CONTAINS(RecordType.DeveloperName , &apos;Tech_Zone&apos;) &amp;&amp;
(ISCHANGED(Existing_Provider_Monthly_Spend__c) || ISCHANGED(Existing_Provider_Name__c) || ISCHANGED(Existing_Provider_Renewal_Date__c) || ISCHANGED(Existing_Provider_Satisfaction__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Technology_K_12</fullName>
        <assignedTo>415271@officedepot.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Account.Tech_Last_Order__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>New</status>
        <subject>Technology K-12</subject>
    </tasks>
</Workflow>
