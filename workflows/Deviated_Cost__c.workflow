<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Deviated_Cost_30_Day_Expiration_Notification</fullName>
        <ccEmails>bigdealrequests@officedepot.com</ccEmails>
        <description>Deviated Cost 30 Day Expiration Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Deviated_Costs/Deviated_Cost_30_Day_Expiration_Notification</template>
    </alerts>
    <alerts>
        <fullName>Deviated_Cost_60_Day_Expiration_Notification</fullName>
        <ccEmails>bigdealrequests@officedepot.com</ccEmails>
        <description>Deviated Cost 60 Day Expiration Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Deviated_Costs/Deviated_Cost_60_Day_Expiration_Notification</template>
    </alerts>
    <alerts>
        <fullName>Deviated_Cost_90_Day_Expiration_Notification</fullName>
        <ccEmails>bigdealrequests@officedepot.com</ccEmails>
        <description>Deviated Cost 90 Day Expiration Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Deviated_Costs/Deviated_Cost_90_Day_Expiration_Notification</template>
    </alerts>
    <alerts>
        <fullName>Deviated_Cost_Creation_Automated_Email</fullName>
        <description>Deviated Cost Creation Automated Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Deviated_Costs/Deviated_Cost_Creation_Notification</template>
    </alerts>
    <alerts>
        <fullName>Deviated_Cost_Expired</fullName>
        <ccEmails>bigdealrequests@officedepot.com</ccEmails>
        <description>Deviated Cost Expired</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Deviated_Costs/Deviated_Cost_Expiration_Notification</template>
    </alerts>
    <alerts>
        <fullName>Deviated_Cost_Renewal_Notification</fullName>
        <ccEmails>bigdealrequests@officedepot.com</ccEmails>
        <ccEmails>suelair.riveron@officedepot.com</ccEmails>
        <description>Deviated Cost Renewal Notification</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Deviated_Costs/Deviated_Cost_Renewal_Notification</template>
    </alerts>
    <rules>
        <fullName>Deviated Cost 30 Day Expiration Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Deviated_Cost__c.Active_Alerts__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Deviated_Cost__c.Deal_Status__c</field>
            <operation>notEqual</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Deviated_Cost__c.Deal_Status__c</field>
            <operation>notEqual</operation>
            <value>Lost</value>
        </criteriaItems>
        <description>Notify Record Owner (Account Owner) if Deviated Cost Program is set to expire within 30 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deviated_Cost_30_Day_Expiration_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Deviated_Cost__c.End_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Deviated Cost 60 Day Expiration Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Deviated_Cost__c.Active_Alerts__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Deviated_Cost__c.Deal_Status__c</field>
            <operation>notEqual</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Deviated_Cost__c.Deal_Status__c</field>
            <operation>notEqual</operation>
            <value>Lost</value>
        </criteriaItems>
        <description>Notify Record Owner (Account Owner) if Deviated Cost Program is set to expire within 60 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deviated_Cost_60_Day_Expiration_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Deviated_Cost__c.End_Date__c</offsetFromField>
            <timeLength>-60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Deviated Cost 90 Day Expiration Notification</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Deviated_Cost__c.Active_Alerts__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Deviated_Cost__c.Deal_Status__c</field>
            <operation>notEqual</operation>
            <value>Expired</value>
        </criteriaItems>
        <criteriaItems>
            <field>Deviated_Cost__c.Deal_Status__c</field>
            <operation>notEqual</operation>
            <value>Lost</value>
        </criteriaItems>
        <description>Notify Record Owner (Account Owner) if Deviated Cost Program is set to expire within 90 days</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deviated_Cost_90_Day_Expiration_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Deviated_Cost__c.End_Date__c</offsetFromField>
            <timeLength>-90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Deviated Cost Creation Notification</fullName>
        <actions>
            <name>Deviated_Cost_Creation_Automated_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Deviated_Cost__c.Exclude_from_Alerts__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Automated email to notify Record Owner (Account Owner) of new Deviated Cost Agreements</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Deviated Cost Expiration Notification</fullName>
        <actions>
            <name>Deviated_Cost_Expired</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify Record Owner (Account Owner) if Deviated Cost Program has expired.</description>
        <formula>AND(ISPICKVAL(Rep_Disposition__c, &quot;No Extension - Deal Ended&quot;),Exclude_from_Alerts__c = FALSE)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deviated Cost Renewal Notification</fullName>
        <actions>
            <name>Deviated_Cost_Renewal_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Deviated_Cost__c.Rep_Disposition__c</field>
            <operation>equals</operation>
            <value>Extension Granted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Deviated_Cost__c.Exclude_from_Alerts__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Notify Record Owner (Account Owner) if Deviated Cost Program has been renewed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
