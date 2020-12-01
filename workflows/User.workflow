<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GPO_Email_Alert_for_Public</fullName>
        <description>GPO Email Alert for Public</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>salesforce@officedepot.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>EXTERNAL_Communities_Templates/GPO_Send_Immediate_SuccessRegEmail_Public</template>
    </alerts>
    <fieldUpdates>
        <fullName>Lattice_User_Role_Update</fullName>
        <description>Lattice User</description>
        <field>Lattice_User__c</field>
        <literalValue>0</literalValue>
        <name>Lattice User Role Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_isCoachingUser_Field</fullName>
        <field>IsCoachingUser__c</field>
        <formula>&apos;true&apos;</formula>
        <name>Update isCoachingUser Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Lattice User Role Deactivation</fullName>
        <actions>
            <name>Lattice_User_Role_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.IsActive</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Whenever a user is inactivated, this will unselect/release their Lattice License</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populating isCoachingUser field based on usertype</fullName>
        <actions>
            <name>Update_isCoachingUser_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.UserType</field>
            <operation>equals</operation>
            <value>Standard</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
