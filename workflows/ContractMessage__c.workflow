<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>ContractMsg</fullName>
        <apiVersion>26.0</apiVersion>
        <endpointUrl>https://alliance.officedepot.com/soa-infra/services/cdh_rt/CreateMPSContractSFDCReqABCS/creatempscontractsfdcreqabcsbpel_client_ep</endpointUrl>
        <fields>Contract_Type__c</fields>
        <fields>Id</fields>
        <fields>OraclePartyId__c</fields>
        <fields>SalesPersonId__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>soa_connection@officedepot.com</integrationUser>
        <name>ContractMsg</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>MPSContract</fullName>
        <actions>
            <name>ContractMsg</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
