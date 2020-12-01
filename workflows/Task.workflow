<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Dispcodeplan</fullName>
        <field>Disposition_Code__c</field>
        <literalValue>Plan and Engage</literalValue>
        <name>Dispcodeplan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lattice_Product_Category</fullName>
        <field>Product_Category__c</field>
        <formula>IF(CONTAINS( upper(( Subject )) , &apos;CLEANING&apos;) || CONTAINS( upper(( Subject )) , &apos;BREAK ROOM&apos;), &apos;CBS&apos;, IF(CONTAINS( upper(( Subject )) , &apos;TECHNOLOGY&apos;) , &apos;TECHNOLOGY&apos;, IF(CONTAINS( upper(( Subject )) , &apos;FURNITURE&apos;) , &apos;FURNITURE&apos;, IF(CONTAINS( upper(( Subject )) , &apos;OFFICE PRODUCTS&apos;) , &apos;SUPPLIES&apos;, &apos;NA&apos;) ) ) )</formula>
        <name>Lattice Product Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Rel</fullName>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Sales Rel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sales_Rel_Exec</fullName>
        <field>Disposition_Code__c</field>
        <literalValue>Execute</literalValue>
        <name>Sales Rel Exec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Cisco_Webex_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Cisco_Webex</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Cisco Webex Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Completed_Date_of_Tasks</fullName>
        <field>WRF_Task_Complete_Dt__c</field>
        <formula>NOW()</formula>
        <name>Set Completed Date of Tasks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Await_Action_Date_to_Blank</fullName>
        <description>Set WRF Await Action Date to Blank</description>
        <field>WRF_Task_Await_Action_Dt__c</field>
        <name>Set WRF Task Await Action Date to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_Await_Action_Date</fullName>
        <description>Set WRF Task Await Action Date</description>
        <field>WRF_Task_Await_Action_Dt__c</field>
        <formula>Now()</formula>
        <name>Set WRF Task Await Action Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_Complete_Date_to_Blank</fullName>
        <field>WRF_Task_Complete_Dt__c</field>
        <name>Set WRF Task Complete Date to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_Completion_Date</fullName>
        <description>Set WRF Task Completion Date</description>
        <field>WRF_Task_Complete_Dt__c</field>
        <formula>Now()</formula>
        <name>Set WRF Task Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_Final_Review_Date</fullName>
        <description>Set WRF Task Final Review Date</description>
        <field>WRF_Task_Final_Review_Dt__c</field>
        <formula>Now()</formula>
        <name>Set WRF Task Final Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_Final_Review_Date_to_Blank</fullName>
        <field>WRF_Task_Final_Review_Dt__c</field>
        <name>Set WRF Task Final Review Date to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_In_Progress_Date</fullName>
        <description>Set WRF Task In Progress Date</description>
        <field>WRF_Task_In_Progress_Dt__c</field>
        <formula>Now()</formula>
        <name>Set WRF Task In Progress Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_In_Progress_Dateto_Blank</fullName>
        <description>Set WRF Task In Progress Dateto Blank</description>
        <field>WRF_Task_In_Progress_Dt__c</field>
        <name>Set WRF Task In Progress Date to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_Status_Complete</fullName>
        <description>Set WRF Task Status Complete</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Set WRF Task Status Complete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_Team_Review_Date</fullName>
        <description>Set WRF Task Team Review Date</description>
        <field>WRF_Task_Team_Review_Dt__c</field>
        <formula>Now()</formula>
        <name>Set WRF Task Team Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_Team_Review_Date_to_Blank</fullName>
        <field>WRF_Task_Team_Review_Dt__c</field>
        <name>Set WRF Task Team Review Date to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_Under_Review_Date</fullName>
        <description>Set WRF Task Under Review Date</description>
        <field>WRF_Task_Under_Review_Dt__c</field>
        <formula>Now()</formula>
        <name>Set WRF Task Under Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WRF_Task_Under_Review_Date_to_Blank</fullName>
        <field>WRF_Task_Under_Review_Dt__c</field>
        <name>Set WRF Task Under Review Date to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transcera_A_Dlvry_issues_Disp_Code</fullName>
        <field>Disposition_Code__c</field>
        <literalValue>Delivery issues</literalValue>
        <name>Transcera - A-Dlvry issues Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transcera_S_Other_Call_Disp</fullName>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transcera - S-Other Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Acct_Closed_Call_Disp</fullName>
        <description>2742:A-Acct Closed</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Acct Closed Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Acct_Closed_Disp_Code</fullName>
        <description>2742:A-Acct Closed</description>
        <field>Disposition_Code__c</field>
        <literalValue>Account or Shipto Closed</literalValue>
        <name>Transera - A-Acct Closed Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Acct_Maint_Call_Disp</fullName>
        <description>2755:A-Acct Maint</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Acct Maint Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Acct_Maint_Disp_Code</fullName>
        <description>2755:A-Acct Maint</description>
        <field>Disposition_Code__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Acct Maint Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Billing_issue_Call_Disp</fullName>
        <description>2756:A-Billing issue</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Billing issue Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Billing_issue_Disp_Code</fullName>
        <description>2756:A-Billing issue</description>
        <field>Disposition_Code__c</field>
        <literalValue>Billing issues</literalValue>
        <name>Transera - A-Billing issue Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Dlvry_issues_Call_Disp</fullName>
        <description>2760:A-Dlvry issues</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Dlvry issues Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Do_Not_Call_Call_Disp</fullName>
        <description>2738:A-Do Not Call</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Do Not Call Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Do_Not_Call_Disp_Code</fullName>
        <description>2738:A-Do Not Call</description>
        <field>Disposition_Code__c</field>
        <literalValue>Do Not Call (DNC)</literalValue>
        <name>Transera - A-Do Not Call Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Dupe_Acct_Call_Disp</fullName>
        <description>2744:A-Dupe Acct</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Dupe Acct Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Dupe_Acct_Disp_Code</fullName>
        <description>2744:A-Dupe Acct</description>
        <field>Disposition_Code__c</field>
        <literalValue>Duplicate Account or Shipto</literalValue>
        <name>Transera - A-Dupe Acct Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Ecom_Ordering_Call_Disp</fullName>
        <description>2749:S-Ecom Ordering</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Ecom Ordering Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Ecom_Ordering_Disp_Code</fullName>
        <description>2749:S-Ecom Ordering</description>
        <field>Disposition_Code__c</field>
        <literalValue>Ecommerce Ordering (BSDNet)</literalValue>
        <name>Transera - A-Ecom Ordering Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Follow_Up_Call_Disp</fullName>
        <description>2759:A-Follow-Up</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Follow-Up Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Follow_Up_Disp_Code</fullName>
        <description>2759:A-Follow-Up</description>
        <field>Disposition_Code__c</field>
        <literalValue>Follow-Up Required</literalValue>
        <name>Transera - A-Follow-Up Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Lang_Barrier_Call_Disp</fullName>
        <description>2736:A-Lang Barrier</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Lang Barrier Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Lang_Barrier_Disp_Code</fullName>
        <description>2736:A-Lang Barrier</description>
        <field>Disposition_Code__c</field>
        <literalValue>Language Barrier</literalValue>
        <name>Transera - A-Lang Barrier Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Left_VMail_Call_Disp</fullName>
        <description>2972:A-Left VMail</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Left VMail Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Left_VMail_Disp_Code</fullName>
        <description>2972:A-Left VMail</description>
        <field>Disposition_Code__c</field>
        <literalValue>Left Voice Mail</literalValue>
        <name>Transera - A-Left VMail Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_No_Answer_Call_Disp</fullName>
        <description>2973:A-No Answer</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A - No Answer Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_No_Answer_Disp_Code</fullName>
        <description>2973:A-No Answer</description>
        <field>Disposition_Code__c</field>
        <literalValue>No Answer</literalValue>
        <name>Transera - A - No Answer Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Not_Mine_Call_Disp</fullName>
        <description>2733:A-Not Mine</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Not Mine Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Not_Mine_Disp_Code</fullName>
        <description>2733:A-Not Mine</description>
        <field>Disposition_Code__c</field>
        <literalValue>Does not belong to me</literalValue>
        <name>Transera - A-Not Mine Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Other_Call_Disp</fullName>
        <description>2754:A-Other</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Other Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Other_Disp_Code</fullName>
        <description>2754:A-Other</description>
        <field>Disposition_Code__c</field>
        <literalValue>Other</literalValue>
        <name>Transera - A-Other Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Pricing_issue_Call_Disp</fullName>
        <description>2761:A-Pricing issue</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Pricing issue Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Pricing_issue_Disp_Code</fullName>
        <description>2761:A-Pricing issue</description>
        <field>Disposition_Code__c</field>
        <literalValue>Pricing issues</literalValue>
        <name>Transera -  A-Pricing issue Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Product_issue_Call_Disp</fullName>
        <description>2758:A-Product issue</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera -  A-Product issue Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Product_issue_Disp_Code</fullName>
        <description>2758:A-Product issue</description>
        <field>Disposition_Code__c</field>
        <literalValue>Product issues</literalValue>
        <name>Transera -  A-Product issue Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Returns_issue_Call_Disp</fullName>
        <description>2757:A-Returns issue</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Returns issue Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Returns_issue_Disp_Code</fullName>
        <description>2757:A-Returns issue</description>
        <field>Disposition_Code__c</field>
        <literalValue>Returns issues</literalValue>
        <name>Transera - A-Returns issue Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Wrong_Number_Call_Disp</fullName>
        <description>2740:A-Wrong Number</description>
        <field>Call_Disposition__c</field>
        <literalValue>Account Maintenance</literalValue>
        <name>Transera - A-Wrong Number Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_A_Wrong_Number_Disp_Code</fullName>
        <description>2740:A-Wrong Number</description>
        <field>Disposition_Code__c</field>
        <literalValue>Wrong Number</literalValue>
        <name>Transera - A-Wrong Number Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Beverage_Qte_Disp</fullName>
        <description>3314:Beverage Quote</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Beverage Qte Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Beverage_Qte_Disp_Code</fullName>
        <description>3314:Beverage Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Beverage Quote</literalValue>
        <name>Transera-CE-Beverage Qte Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Breakroom_Qte_Disp</fullName>
        <description>3315:Break room Quote</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Breakroom Qte Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Breakroom_Qte_Disp_Code</fullName>
        <description>3315:Break room Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Breakroom Quote</literalValue>
        <name>Transera-CE-Breakroom Qte Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Cleaning_Qte_Disp</fullName>
        <description>3313:Cleaning Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Cleaning Quote</literalValue>
        <name>Transera-CE-Cleaning Qte Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Cleaning_Qte_Disp_Code</fullName>
        <description>3313:Cleaning Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Cleaning Quote</literalValue>
        <name>Transera-CE-Cleaning Qte Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_CopyPrint_Disp</fullName>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera - CE - CopyPrint Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_CopyPrint_Disp_Code</fullName>
        <field>Disposition_Code__c</field>
        <literalValue>Copy/Print Job Quotes</literalValue>
        <name>Transera - CE - CopyPrint Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Custom_Stamps_Disp</fullName>
        <description>3303:Custom Stamps Quote</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Custom Stamps Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Custom_Stamps_Disp_Code</fullName>
        <description>3303:Custom Stamps Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Custom Stamps Quote</literalValue>
        <name>Transera-CE-Custom Stamps Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_CustomerService_Disp</fullName>
        <description>3311:Customer Service Issue</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-CustomerService Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_CustomerService_Disp_Code</fullName>
        <description>3311:Customer Service Issue</description>
        <field>Disposition_Code__c</field>
        <literalValue>Customer Service Issue</literalValue>
        <name>Transera-CE-CustomerService Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Installation_Assem_Disp</fullName>
        <description>3304:Installation-Assembly Quote</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Installation Assem Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Installation_Assem_Disp_Code</fullName>
        <description>3304:Installation-Assembly Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Installation/Assembly Quote</literalValue>
        <name>Transera-CE-Installation Assem Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Inventory_Inq_Disp</fullName>
        <description>3309:Inventory Inquiry</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Inventory Inq Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Inventory_Inq_Disp_Code</fullName>
        <description>3309:Inventory Inquiry</description>
        <field>Disposition_Code__c</field>
        <literalValue>Inventory Inquiry</literalValue>
        <name>Transera-CE-Inventory Inq Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_NonCode_Qte_Disp</fullName>
        <description>3302:Non-Code Quote</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-NonCode Qte Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_NonCode_Qte_Disp_Code</fullName>
        <description>3302:Non-Code Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Non-Code Quote</literalValue>
        <name>Transera-CE-NonCode Qte Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Order_Placement_Disp</fullName>
        <description>3312:Order Placement</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Order Placement Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Order_Placement_Disp_Code</fullName>
        <description>3312:Order Placement</description>
        <field>Disposition_Code__c</field>
        <literalValue>Order Placement</literalValue>
        <name>Transera-CE-Order Placement Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Proj_Large_Furn_Disp</fullName>
        <description>3306:Project - Large Furn Quote</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Proj Large Furn Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Proj_Large_Furn_DispCode</fullName>
        <description>3306:Project - Large Furn Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Project - Large Furn Quote</literalValue>
        <name>Transera-CE-Proj Large Furn DispCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Proj_Small_Furn_Disp</fullName>
        <description>3305:Project - Small Furn Quote</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Proj Small Furn Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Proj_Small_Furn_Disp_Code</fullName>
        <description>3305:Project - Small Furn Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Project - Small Furn Quote</literalValue>
        <name>Transera-CE-Proj Small Furn Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Promotional_Prod_Qte_Disp</fullName>
        <description>3299:Promotional Products Quote</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Promotional Prod Qte Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Promotional_Prod_Qte_Disp_Co</fullName>
        <description>3299:Promotional Products Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Promotional Products Quote</literalValue>
        <name>Transera-CE-Promotional Prod Qte Disp Co</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Question_Disp</fullName>
        <description>3310:Question</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Question Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Question_Disp_Code</fullName>
        <description>3310:Question</description>
        <field>Disposition_Code__c</field>
        <literalValue>Question</literalValue>
        <name>Transera-CE-Question Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Space_Planning_Disp</fullName>
        <description>3316:Space Planning</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Space Planning Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Space_Planning_Disp_Code</fullName>
        <description>3316:Space Planning</description>
        <field>Disposition_Code__c</field>
        <literalValue>Space Planning</literalValue>
        <name>Transera-CE-Space Planning Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Stationary_Qte_Disp</fullName>
        <description>3300:Stationary Quote</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Stationary Qte Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Stationary_Qte_Disp_Code</fullName>
        <description>3300:Stationary Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Stationary Quote</literalValue>
        <name>Transera-CE-Stationary Qte Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Tech_Qte_Disp</fullName>
        <description>3308:Technology Quote</description>
        <field>Call_Disposition__c</field>
        <literalValue>Category Expert</literalValue>
        <name>Transera-CE-Tech Qte Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_CE_Tech_Qte_Disp_Code</fullName>
        <description>3308:Technology Quote</description>
        <field>Disposition_Code__c</field>
        <literalValue>Technology Quote</literalValue>
        <name>Transera-CE-Tech Qte Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_P_A_to_B</fullName>
        <description>2970:P-A to B</description>
        <field>Disposition_Code__c</field>
        <literalValue>Option A to Option B</literalValue>
        <name>Transera - P-A to B Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_P_A_to_B_Call_Disp</fullName>
        <description>2970:P-A to B</description>
        <field>Call_Disposition__c</field>
        <literalValue>Pricing Maintenance</literalValue>
        <name>Transera - P-A to B Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_P_ODRP_to_Price_A_Call_Disp</fullName>
        <description>2969:P-ODRP to Price A</description>
        <field>Call_Disposition__c</field>
        <literalValue>Pricing Maintenance</literalValue>
        <name>Transera - P-ODRP to Price A Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_P_ODRP_to_Price_A_Disp</fullName>
        <description>2969:P-ODRP to Price A</description>
        <field>Disposition_Code__c</field>
        <literalValue>ODRP to Option A</literalValue>
        <name>Transera - P-ODRP to Price A Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_P_Old_To_Price_A_Call_Disp</fullName>
        <field>Call_Disposition__c</field>
        <literalValue>Pricing Maintenance</literalValue>
        <name>Transera - P-Old To Price A Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_P_Old_To_Price_A_Disp_Code</fullName>
        <description>2968:P-Old To Price A</description>
        <field>Disposition_Code__c</field>
        <literalValue>Old to Option A</literalValue>
        <name>Transera - P-Old To Price A Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_P_Prc_Escalation_Call_Disp</fullName>
        <description>2971:P-Prc Escalation</description>
        <field>Call_Disposition__c</field>
        <literalValue>Pricing Maintenance</literalValue>
        <name>Transera - P - Prc Escalation Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_P_Prc_Escalation_Disp_Code</fullName>
        <description>2971:P-Prc Escalation</description>
        <field>Disposition_Code__c</field>
        <literalValue>Pricing escalation</literalValue>
        <name>Transera - P - Prc Escalation Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_P_Promo_Comp_Disp</fullName>
        <description>3292:P-Promo Complaint</description>
        <field>Call_Disposition__c</field>
        <literalValue>Pricing Maintenance</literalValue>
        <name>Transera - P-Promo Comp. Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_P_Promo_Complaint_Disp_Code</fullName>
        <description>Task: Call Resultequals3292:P-Promo Complaint</description>
        <field>Disposition_Code__c</field>
        <literalValue>Complaint – promo not matching</literalValue>
        <name>Transera - P - Promo Complaint Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Appt_Secured</fullName>
        <description>2975:S-Appt Secured</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S - Appt Secured</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Appt_Secured_Disp_Code</fullName>
        <description>3287:S- Appt Secured</description>
        <field>Disposition_Code__c</field>
        <literalValue>Appt Secured</literalValue>
        <name>Transera - S - Appt Secured Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Bus_Review_Call_Disp</fullName>
        <description>2747:S-Bus Review</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S-Bus Review Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Bus_Review_Disp_Code</fullName>
        <description>2747:S-Bus Review</description>
        <field>Disposition_Code__c</field>
        <literalValue>Business Review</literalValue>
        <name>Transera - S-Bus Review Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Campaigns_Call_Disp</fullName>
        <description>2750:S-Campaigns</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S-Campaigns Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Campaigns_Disp_Code</fullName>
        <description>2750:S-Campaigns</description>
        <field>Disposition_Code__c</field>
        <literalValue>Promotions/Campaigns</literalValue>
        <name>Transera - S-Campaigns Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Conversion_Call_Disp</fullName>
        <description>2743:S-Conversion</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S-Conversion Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Conversion_Disp_Code</fullName>
        <description>2743:S-Conversion</description>
        <field>Disposition_Code__c</field>
        <literalValue>Conversion call</literalValue>
        <name>Transera - S-Conversion Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Execute</fullName>
        <description>3291:S-Execute</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S-Execute</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Execute_Disp_Code</fullName>
        <description>3291:S-Execute</description>
        <field>Disposition_Code__c</field>
        <literalValue>Execute</literalValue>
        <name>Transera - S-Execute Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Initial_Approach_Disp</fullName>
        <description>3288:S-Initial Approach</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S-Initial Approach Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Initial_Approach_Disp_Code</fullName>
        <description>3288:S-Initial Approach</description>
        <field>Disposition_Code__c</field>
        <literalValue>Initial Approach</literalValue>
        <name>Transera - S-Initial Approach Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Introduction_Call_Disp</fullName>
        <description>2741:S-Introduction</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera -  S-Introduction - Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Introduction_Disp_Code</fullName>
        <description>2741:S-Introduction</description>
        <field>Disposition_Code__c</field>
        <literalValue>Introduction</literalValue>
        <name>Transera -  S-Introduction - Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Negotiate_Finalize_Disp</fullName>
        <description>3290:S-Negotiation Finalize</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S-Negotiate Finalize Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Negotiate_Finalize_Disp_Cod</fullName>
        <description>3290:S-Negotiation Finalize</description>
        <field>Disposition_Code__c</field>
        <literalValue>Negotiate &amp; Finalize</literalValue>
        <name>Transera - S-Negotiate Finalize Disp Cod</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Other_Disp_Code</fullName>
        <description>2753:S-Other</description>
        <field>Disposition_Code__c</field>
        <literalValue>Other</literalValue>
        <name>Transera - S-Other Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Placed_Order_Call_Disp</fullName>
        <description>2748:S-Placed Order</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S-Placed Order Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Placed_Order_Disp_Code</fullName>
        <description>2748:S-Placed Order</description>
        <field>Disposition_Code__c</field>
        <literalValue>Placed Order</literalValue>
        <name>Transera - S-Placed Order Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Presentation_Disp</fullName>
        <description>3289:S-Presentation</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S-Presentation Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Presentation_Disp_Code</fullName>
        <description>3289:S-Presentation</description>
        <field>Disposition_Code__c</field>
        <literalValue>Presentation</literalValue>
        <name>Transera - S-Presentation Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Pricing_Call_Disp</fullName>
        <description>2752:S-Pricing</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S-Pricing Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Pricing_Disp_Code</fullName>
        <description>2752:S-Pricing</description>
        <field>Disposition_Code__c</field>
        <literalValue>Pricing Programs</literalValue>
        <name>Transera - S-Pricing Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Procurement_Call_Disp</fullName>
        <description>2751:S-Procurement</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S-Procurement Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Procurement_Disp_Code</fullName>
        <description>2751:S-Procurement</description>
        <field>Disposition_Code__c</field>
        <literalValue>Procurement</literalValue>
        <name>Transera - S-Procurement Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Retention_Call_Disp</fullName>
        <description>2745:S-Retention</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera -  S-Retention Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_Retention_Disp_Code</fullName>
        <description>2745:S-Retention</description>
        <field>Disposition_Code__c</field>
        <literalValue>Retention call</literalValue>
        <name>Transera -  S-Retention Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_SOW_Call_Disp</fullName>
        <description>2746:S-SOW</description>
        <field>Call_Disposition__c</field>
        <literalValue>Sales Related</literalValue>
        <name>Transera - S-SOW Call Disp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_S_SOW_Disp_Code</fullName>
        <description>2746:S-SOW</description>
        <field>Disposition_Code__c</field>
        <literalValue>Share of Wallet</literalValue>
        <name>Transera -  S-SOW Disp Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_Set_Inbound</fullName>
        <field>Task_Type__c</field>
        <literalValue>Inbound Call</literalValue>
        <name>Transera -- Set Inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Transera_Set_Outbound</fullName>
        <field>Task_Type__c</field>
        <literalValue>Outbound Call</literalValue>
        <name>Transera -- Set Outbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ciscocjs__Contact_Type_Mapping</fullName>
        <field>ciscocjs__Contact_Type__c</field>
        <name>Contact Type Mapping</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>dispTtype</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Inside_Sales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>dispTtype</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>dispcdplan</fullName>
        <field>Call_Disposition__c</field>
        <literalValue>Pricing Maintenance</literalValue>
        <name>dispcdplan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Lattice Personalization - Product Category Assignment</fullName>
        <actions>
            <name>Lattice_Product_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Disposition_Code__c</field>
            <operation>contains</operation>
            <value>salesPRISM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Task (Tech-Zone)</value>
        </criteriaItems>
        <description>Workflow rule to populate the correct value in the &quot;Product Category&quot; field based on the Task Subject content - only for &apos;SalesPrism&apos; type tasks for the Lattice Personalization project.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Cisco Webex Record Type</fullName>
        <actions>
            <name>Set_Cisco_Webex_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.TaskSubtype</field>
            <operation>equals</operation>
            <value>Call</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Tasks Completed Date</fullName>
        <actions>
            <name>Set_Completed_Date_of_Tasks</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.WRF_Task_Complete_Dt__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Task (Tech-Zone)</value>
        </criteriaItems>
        <description>Set Tasks Completed Date to Today&apos;s date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A - No Answer</fullName>
        <actions>
            <name>Transera_A_No_Answer_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_No_Answer_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2973:A-No Answer</value>
        </criteriaItems>
        <description>2973:A-No Answer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Acct Closed</fullName>
        <actions>
            <name>Transera_A_Acct_Closed_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Acct_Closed_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2742:A-Acct Closed</value>
        </criteriaItems>
        <description>2742:A-Acct Closed</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Acct Maint</fullName>
        <actions>
            <name>Transera_A_Acct_Maint_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Acct_Maint_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2755:A-Acct Maint</value>
        </criteriaItems>
        <description>2755:A-Acct Maint</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Billing issue</fullName>
        <actions>
            <name>Transera_A_Billing_issue_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Billing_issue_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2756:A-Billing issue</value>
        </criteriaItems>
        <description>2756:A-Billing issue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Dlvry issues</fullName>
        <actions>
            <name>Transcera_A_Dlvry_issues_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Dlvry_issues_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2760:A-Dlvry issues</value>
        </criteriaItems>
        <description>2760:A-Dlvry issues</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Do Not Call</fullName>
        <actions>
            <name>Transera_A_Do_Not_Call_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Do_Not_Call_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2738:A-Do Not Call</value>
        </criteriaItems>
        <description>2738:A-Do Not Call</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Dupe Acct</fullName>
        <actions>
            <name>Transera_A_Dupe_Acct_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Dupe_Acct_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2744:A-Dupe Acct</value>
        </criteriaItems>
        <description>2744:A-Dupe Acct</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Ecom Ordering</fullName>
        <actions>
            <name>Transera_A_Ecom_Ordering_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Ecom_Ordering_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2749:A-Ecomm Ordering</value>
        </criteriaItems>
        <description>2749:S-Ecom Ordering</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Follow-Up</fullName>
        <actions>
            <name>Transera_A_Follow_Up_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Follow_Up_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2759:A-Follow-Up</value>
        </criteriaItems>
        <description>2759:A-Follow-Up</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Lang Barrier</fullName>
        <actions>
            <name>Transera_A_Lang_Barrier_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Lang_Barrier_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2736:A-Lang Barrier</value>
        </criteriaItems>
        <description>2736:A-Lang Barrier</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Left VMail</fullName>
        <actions>
            <name>Transera_A_Left_VMail_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Left_VMail_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2972:A-Left VMail</value>
        </criteriaItems>
        <description>2972:A-Left VMail</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Not Mine</fullName>
        <actions>
            <name>Transera_A_Not_Mine_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Not_Mine_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2733:A-Not Mine</value>
        </criteriaItems>
        <description>2733:A-Not Mine</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Other</fullName>
        <actions>
            <name>Transera_A_Other_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Other_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2754:A-Other</value>
        </criteriaItems>
        <description>2754:A-Other</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Pricing issue</fullName>
        <actions>
            <name>Transera_A_Pricing_issue_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Pricing_issue_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2761:A-Pricing issue</value>
        </criteriaItems>
        <description>2761:A-Pricing issue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Product issue</fullName>
        <actions>
            <name>Transera_A_Product_issue_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Product_issue_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2758:A-Product issue</value>
        </criteriaItems>
        <description>2758:A-Product issue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Returns issue</fullName>
        <actions>
            <name>Transera_A_Returns_issue_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Returns_issue_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2757:A-Returns issue</value>
        </criteriaItems>
        <description>2757:A-Returns issue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - A-Wrong Number</fullName>
        <actions>
            <name>Transera_A_Wrong_Number_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_A_Wrong_Number_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2740:A-Wrong Number</value>
        </criteriaItems>
        <description>2740:A-Wrong Number</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - P-A to B</fullName>
        <actions>
            <name>Transera_P_A_to_B</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_P_A_to_B_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2970:P-A to B</value>
        </criteriaItems>
        <description>2970:P-A to B</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - P-ODRP to Price A</fullName>
        <actions>
            <name>Transera_P_ODRP_to_Price_A_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_P_ODRP_to_Price_A_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2969:P-ODRP to Price A</value>
        </criteriaItems>
        <description>2969:P-ODRP to Price A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - P-Old To Price A</fullName>
        <actions>
            <name>Transera_P_Old_To_Price_A_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_P_Old_To_Price_A_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2968:P-Old To Price A</value>
        </criteriaItems>
        <description>2968:P-Old To Price A</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - P-Prc Escalation</fullName>
        <actions>
            <name>Transera_P_Prc_Escalation_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_P_Prc_Escalation_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2971:P-Prc Escalation</value>
        </criteriaItems>
        <description>2971:P-Prc Escalation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - P-Promo Complaint</fullName>
        <actions>
            <name>Transera_P_Promo_Comp_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_P_Promo_Complaint_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3292:P-Promo Complaint</value>
        </criteriaItems>
        <description>3292:P-Promo Complaint</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Appt Secured</fullName>
        <actions>
            <name>Transera_S_Appt_Secured</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Appt_Secured_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3287:S- Appt Secured</value>
        </criteriaItems>
        <description>2975:S-Appt Secured</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Bus Review</fullName>
        <actions>
            <name>Transera_S_Bus_Review_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Bus_Review_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2747:S-Bus Review</value>
        </criteriaItems>
        <description>2747:S-Bus Review</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Campaigns</fullName>
        <actions>
            <name>Transera_S_Campaigns_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Campaigns_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2750:S-Campaigns</value>
        </criteriaItems>
        <description>2750:S-Campaigns</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Conversion</fullName>
        <actions>
            <name>Transera_S_Conversion_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Conversion_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2743:S-Conversion</value>
        </criteriaItems>
        <description>2743:S-Conversion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Execute</fullName>
        <actions>
            <name>Transera_S_Execute</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Execute_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3291:S-Execute</value>
        </criteriaItems>
        <description>3291:S-Execute</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Initial Approach</fullName>
        <actions>
            <name>Transera_S_Initial_Approach_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Initial_Approach_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3288:S-Initial Approach</value>
        </criteriaItems>
        <description>3288:S-Initial Approach</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Introduction</fullName>
        <actions>
            <name>Transera_S_Introduction_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Introduction_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2741:S-Introduction</value>
        </criteriaItems>
        <description>2741:S-Introduction</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Negotiate Finalize</fullName>
        <actions>
            <name>Transera_S_Negotiate_Finalize_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Negotiate_Finalize_Disp_Cod</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3290:S-Negotiation Finalize</value>
        </criteriaItems>
        <description>3290:S-Negotiation Finalize</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Other</fullName>
        <actions>
            <name>Transcera_S_Other_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Other_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2753:S-Other</value>
        </criteriaItems>
        <description>2753:S-Other</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Placed Order</fullName>
        <actions>
            <name>Transera_S_Placed_Order_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Placed_Order_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2748:S-Placed Order</value>
        </criteriaItems>
        <description>2748:S-Placed Order</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Presentation</fullName>
        <actions>
            <name>Transera_S_Presentation_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Presentation_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3289:S-Presentation</value>
        </criteriaItems>
        <description>3289:S-Presentation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Pricing</fullName>
        <actions>
            <name>Transera_S_Pricing_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Pricing_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2752:S-Pricing</value>
        </criteriaItems>
        <description>2752:S-Pricing</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Procurement</fullName>
        <actions>
            <name>Transera_S_Procurement_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Procurement_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2751:S-Procurement</value>
        </criteriaItems>
        <description>2751:S-Procurement</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-Retention</fullName>
        <actions>
            <name>Transera_S_Retention_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_Retention_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2745:S-Retention</value>
        </criteriaItems>
        <description>2745:S-Retention</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - S-SOW</fullName>
        <actions>
            <name>Transera_S_SOW_Call_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_S_SOW_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2746:S-SOW</value>
        </criteriaItems>
        <description>2746:S-SOW</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera - Sales</fullName>
        <actions>
            <name>Sales_Rel</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sales_Rel_Exec</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2594:Sales</value>
        </criteriaItems>
        <description>2594:Sales</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera -- Set Inbound</fullName>
        <actions>
            <name>Transera_Set_Inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallType</field>
            <operation>equals</operation>
            <value>Inbound</value>
        </criteriaItems>
        <description>Set Task Type to Inbound</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Transera -- Set Outbound</fullName>
        <actions>
            <name>Transera_Set_Outbound</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallType</field>
            <operation>equals</operation>
            <value>Outbound</value>
        </criteriaItems>
        <description>Set Task Type to Outbound</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Transera -Plan and Engage</fullName>
        <actions>
            <name>Dispcodeplan</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>dispTtype</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>dispcdplan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>2734:P-Plan and Engage</value>
        </criteriaItems>
        <description>2734:P-Plan and Engage</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Beverage Qte</fullName>
        <actions>
            <name>Transera_CE_Beverage_Qte_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Beverage_Qte_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3314:Beverage Quote</value>
        </criteriaItems>
        <description>3314:Beverage Quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Breakroom Qte</fullName>
        <actions>
            <name>Transera_CE_Breakroom_Qte_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Breakroom_Qte_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3315:Break room Quote</value>
        </criteriaItems>
        <description>3315:Break room Quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Cleaning Qte</fullName>
        <actions>
            <name>Transera_CE_Cleaning_Qte_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Cleaning_Qte_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3313:Cleaning Quote</value>
        </criteriaItems>
        <description>3313:Cleaning Quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-CopyPrint</fullName>
        <actions>
            <name>Transera_CE_CopyPrint_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_CopyPrint_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3301:CopyPrint Job Quotes</value>
        </criteriaItems>
        <description>3301:CopyPrint Job Quotes</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Custom Stamps</fullName>
        <actions>
            <name>Transera_CE_Custom_Stamps_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Custom_Stamps_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3303:Custom Stamps Quote</value>
        </criteriaItems>
        <description>3303:Custom Stamps Quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-CustomerService</fullName>
        <actions>
            <name>Transera_CE_CustomerService_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_CustomerService_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3311:Customer Service Issue</value>
        </criteriaItems>
        <description>3311:Customer Service Issue</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Installation Assem</fullName>
        <actions>
            <name>Transera_CE_Installation_Assem_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Installation_Assem_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3304:Installation-Assembly Quote</value>
        </criteriaItems>
        <description>3304:Installation-Assembly Quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Inventory Inq</fullName>
        <actions>
            <name>Transera_CE_Inventory_Inq_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Inventory_Inq_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3309:Inventory Inquiry</value>
        </criteriaItems>
        <description>3309:Inventory Inquiry</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-NonCode Quote</fullName>
        <actions>
            <name>Transera_CE_NonCode_Qte_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_NonCode_Qte_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3302:Non-Code Quote</value>
        </criteriaItems>
        <description>3302:Non-Code Quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Order Placement</fullName>
        <actions>
            <name>Transera_CE_Order_Placement_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Order_Placement_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3312:Order Placement</value>
        </criteriaItems>
        <description>3312:Order Placement</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Proj Large Furn</fullName>
        <actions>
            <name>Transera_CE_Proj_Large_Furn_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Proj_Large_Furn_DispCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3306:Project - Large Furn Quote</value>
        </criteriaItems>
        <description>3306:Project - Large Furn Quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Proj Small Furn</fullName>
        <actions>
            <name>Transera_CE_Proj_Small_Furn_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Proj_Small_Furn_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3305:Project - Small Furn Quote</value>
        </criteriaItems>
        <description>3305:Project - Small Furn Quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Promotional Prod Qte</fullName>
        <actions>
            <name>Transera_CE_Promotional_Prod_Qte_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Promotional_Prod_Qte_Disp_Co</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3299:Promotional Products Quote</value>
        </criteriaItems>
        <description>3299:Promotional Products Quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Question</fullName>
        <actions>
            <name>Transera_CE_Question_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Question_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3310:Question</value>
        </criteriaItems>
        <description>3310:Question</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Space Planning</fullName>
        <actions>
            <name>Transera_CE_Space_Planning_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Space_Planning_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3316:Space Planning</value>
        </criteriaItems>
        <description>3316:Space Planning</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Stationary Qte</fullName>
        <actions>
            <name>Transera_CE_Stationary_Qte_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Stationary_Qte_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3300:Stationary Quote</value>
        </criteriaItems>
        <description>3300:Stationary Quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Transera-CE-Tech Qte</fullName>
        <actions>
            <name>Transera_CE_Tech_Qte_Disp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Transera_CE_Tech_Qte_Disp_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.CallDisposition</field>
            <operation>equals</operation>
            <value>3308:Technology Quote</value>
        </criteriaItems>
        <description>3308:Technology Quote</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WRF%3A Set Status Complete When no action is required</fullName>
        <actions>
            <name>Set_WRF_Task_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Status_Complete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.No_Action_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set Status Complete When no action is required</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WRF%3A Set WRF Task Await Action Date</fullName>
        <actions>
            <name>Set_WRF_Task_Await_Action_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Awaiting Action</value>
        </criteriaItems>
        <description>Set WRF Task Await Action Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WRF%3A Set WRF Task Completion Date</fullName>
        <actions>
            <name>Set_WRF_Await_Action_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Set WRF Task Completion Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WRF%3A Set WRF Task Final Review Date</fullName>
        <actions>
            <name>Set_WRF_Await_Action_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Complete_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Final_Review_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Final Review</value>
        </criteriaItems>
        <description>Set WRF Task Final Review Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WRF%3A Set WRF Task In Progress Date</fullName>
        <actions>
            <name>Set_WRF_Task_Complete_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Final_Review_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_In_Progress_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>In Progress</value>
        </criteriaItems>
        <description>Set WRF Task In Progress Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WRF%3A Set WRF Task Status Dates to Blank</fullName>
        <actions>
            <name>Set_WRF_Task_Complete_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Final_Review_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_In_Progress_Dateto_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Team_Review_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Under_Review_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Not Started</value>
        </criteriaItems>
        <description>Set WRF Task Status Dates to Blank</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WRF%3A Set WRF Task Team Review Date</fullName>
        <actions>
            <name>Set_WRF_Task_Complete_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Final_Review_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_In_Progress_Dateto_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Team_Review_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Team Review</value>
        </criteriaItems>
        <description>Set WRF Task Team Review Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WRF%3A Set WRF Task Under Review Date</fullName>
        <actions>
            <name>Set_WRF_Task_Complete_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Final_Review_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_In_Progress_Dateto_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Team_Review_Date_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WRF_Task_Under_Review_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Work Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Under Review</value>
        </criteriaItems>
        <description>Set WRF Task Under Review Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ciscocjs__Contact Type Mapping</fullName>
        <actions>
            <name>ciscocjs__Contact_Type_Mapping</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
