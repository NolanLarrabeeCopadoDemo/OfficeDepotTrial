/**************************************************************
* This is use to test scenarios related to CaseMessageDispatch which is part Dispatch and the Single Ticketing project.
*
* @author Adam Albright, adam.albright@officedepot.com
* @since 2020-01-17
*/

@IsTest
public without sharing class CaseMessageDispatch_TC {


    static User soa_connection_user = [SELECT Id, Name FROM User WHERE Name='Soa Connection'];
    static Map<String, Schema.RecordTypeInfo> case_recordtype_developername_map = Schema.Case.getSObjectType().getDescribe().getRecordTypeInfosByDeveloperName();
    static List<Case_Message_Route__mdt>  message_routes = [
        SELECT 
            Id, 
            Queue_Developer_Name__c, 
            Remote_Destination__c, 
            Remote_Destination_Id__c 
        FROM Case_Message_Route__mdt
    ];

    
    public class CaseMessageDispatchMock implements HttpCalloutMock {
        Integer req_status = 201;
        public CaseMessageDispatchMock(){}
        public CaseMessageDispatchMock(Integer req_status){
            this.req_status = req_status;
        }

        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(this.req_status);
            return response;
        }
    }

    @IsTest
    static void run_case_message_dispatch_validation(){
        Test.startTest();
        try {
            new CaseMessageDispatch().validate();
        } catch (QueryException e) {
            insert new Dispatch_Setting__c(
                Name='CaseMessageDispatch',
                Dispatch_Query__c = 'SELECT Account_Number__c, Attachment_Id__c, Case_Comment_Id__c, Case_Message_Action__c, Case_Message_Destination__c, Case__c, CreatedDate, FirstName__c, Freshdesk_Id__c, Freshdesk_Queue__c, Freshdesk_Type__c, Id, LastName__c, Name, OracleCX_Id__c, OracleCX_Queue__c, Phone__c, User_Email__c, Case_Message_Status__c, User__c FROM Case_Message__c WHERE CreatedDate=today AND ',
                Remote_URL__c = 'https://localhost',
                Headers__c = '{"Content-Type": "application/xml"}',
                Order_By_Field_API_Name__c = 'CreatedDate',
                Order_Direction__c='DESC',
                Status_Field_API_Name__c='Case_Message_Status__c',
                Chain__c=false
            );
            new CaseMessageDispatch().validate();
        }
        Test.stopTest();
    }

    @IsTest
    static void test_that_case_messages_get_processed(){
        Set<String> freshdesk_queue_names = new Set<String>();
        Set<String> ocx_queue_names = new Set<String>();
        for(Case_Message_Route__mdt route: message_routes)
            if(route.Remote_Destination__c == 'FRESHDESK')
                freshdesk_queue_names.add(route.Queue_Developer_Name__c);
            else if(route.Remote_Destination__c == 'ORACLECX')
                ocx_queue_names.add(route.Queue_Developer_Name__c);


        List<Group> freshdesk_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :freshdesk_queue_names];
        List<Group> ocx_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :ocx_queue_names];


        List<Case> test_cases = new List<Case>{
            new Case(
                Subject='Some Test Case',
                Description='This is a big test description.',
                LastModifiedById = UserInfo.getUserId(),
                Remote_Destination__c = 'FRESHDESK',
                Freshdesk_Id__c = 2,
                OwnerId = freshdesk_groups[0].Id,
                RecordTypeId = case_recordtype_developername_map.get('Support').getRecordTypeId()
            ),
            new Case(
                Subject='Some Test Case',
                Description='This is a big test description.',
                LastModifiedById = UserInfo.getUserId(),
                Remote_Destination__c = 'ORACLECX',
                OracleCX_Id__c = 3,
                OwnerId = ocx_groups[0].Id,
                RecordTypeId = case_recordtype_developername_map.get('Support').getRecordTypeId() // Gotta set this, or messages are not created. 
            )
        };

        insert new Dispatch_Setting__c(
            Name='CaseMessageDispatch',
            Dispatch_Query__c = 'SELECT Account_Number__c, Attachment_Id__c, Case_Comment_Id__c, Case_Message_Action__c, Case_Message_Destination__c, Case__c, CreatedDate, FirstName__c, Freshdesk_Id__c, Freshdesk_Queue__c, Freshdesk_Type__c, Id, LastName__c, Name, OracleCX_Id__c, OracleCX_Queue__c, Phone__c, User_Email__c, Case_Message_Status__c, User__c FROM Case_Message__c WHERE CreatedDate=today AND ',
            Remote_URL__c = 'https://localhost',
            Headers__c = '{"Content-Type": "application/xml"}',
            Order_By_Field_API_Name__c = 'CreatedDate',
            Order_Direction__c='DESC',
            Status_Field_API_Name__c='Case_Message_Status__c',
            Chain__c=false
        );

        TriggerHandler.bypass('CaseMessageTriggerHandler');
        insert test_cases;

        Test.setMock(HttpCalloutMock.class, new CaseMessageDispatchMock());
        Test.startTest();
    
        List<Case_Message__c> messages = [SELECT Id, Case_Message_Status__c FROM Case_Message__c];
        System.assert(messages.size() == 2, 'Messages did not get generated.');
        for (Case_Message__c msg: messages){
            System.assert(msg.Case_Message_Status__c == 'NEW');
        }

        System.enqueueJob(new CaseMessageDispatch());

        Test.stopTest();
        TriggerHandler.clearBypass('CaseMessageTriggerHandler');
        List<Case_Message__c> processed_messages = [SELECT Id, Case_Message_Status__c FROM Case_Message__c WHERE Case_Message_Status__c = 'PROCESSED'];
        List<Case_Message__c> new_messages = [SELECT Id, Case_Message_Status__c FROM Case_Message__c WHERE Case_Message_Status__c = 'NEW'];

        System.assert(processed_messages.size() == 1, 'Expected 1 record, Got ' + processed_messages);
        System.assert(new_messages.size() == 1, 'Expected 1 record, Got ' + new_messages);
    }

    @IsTest
    static void test_that_case_messages_get_failed(){
        Set<String> freshdesk_queue_names = new Set<String>();
        Set<String> ocx_queue_names = new Set<String>();
        for(Case_Message_Route__mdt route: message_routes)
            if(route.Remote_Destination__c == 'FRESHDESK')
                freshdesk_queue_names.add(route.Queue_Developer_Name__c);
            else if(route.Remote_Destination__c == 'ORACLECX')
                ocx_queue_names.add(route.Queue_Developer_Name__c);


        List<Group> freshdesk_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :freshdesk_queue_names];
        List<Group> ocx_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :ocx_queue_names];


        List<Case> test_cases = new List<Case>{
            new Case(
                Subject='Some Test Case',
                Description='This is a big test description.',
                LastModifiedById = UserInfo.getUserId(),
                Remote_Destination__c = 'FRESHDESK',
                Freshdesk_Id__c = 2,
                OwnerId = freshdesk_groups[0].Id,
                RecordTypeId = case_recordtype_developername_map.get('Support').getRecordTypeId()
            ),
            new Case(
                Subject='Some Test Case',
                Description='This is a big test description.',
                LastModifiedById = UserInfo.getUserId(),
                Remote_Destination__c = 'ORACLECX',
                OracleCX_Id__c = 3,
                OwnerId = ocx_groups[0].Id,
                RecordTypeId = case_recordtype_developername_map.get('Support').getRecordTypeId() // Gotta set this, or messages are not created. 
            )
        };

        insert new Dispatch_Setting__c(
            Name='CaseMessageDispatch',
            Dispatch_Query__c = 'SELECT Account_Number__c, Attachment_Id__c, Case_Comment_Id__c, Case_Message_Action__c, Case_Message_Destination__c, Case__c, CreatedDate, FirstName__c, Freshdesk_Id__c, Freshdesk_Queue__c, Freshdesk_Type__c, Id, LastName__c, Name, OracleCX_Id__c, OracleCX_Queue__c, Phone__c, User_Email__c, Case_Message_Status__c, User__c FROM Case_Message__c WHERE CreatedDate=today AND ',
            Remote_URL__c = 'https://localhost',
            Headers__c = '{"Content-Type": "application/xml"}',
            Order_By_Field_API_Name__c = 'CreatedDate',
            Order_Direction__c='DESC',
            Status_Field_API_Name__c='Case_Message_Status__c',
            Chain__c=false
        );
        
        TriggerHandler.bypass('CaseMessageTriggerHandler');
        insert test_cases;

        Test.setMock(HttpCalloutMock.class, new CaseMessageDispatchMock(500));
        Test.startTest();
    
        List<Case_Message__c> messages = [SELECT Id, Case_Message_Status__c FROM Case_Message__c];
        System.assert(messages.size() == 2, 'Messages did not get generated.');
        for (Case_Message__c msg: messages){
            System.assert(msg.Case_Message_Status__c == 'NEW');
        }

        System.enqueueJob(new CaseMessageDispatch());

        Test.stopTest();
        TriggerHandler.clearBypass('CaseMessageTriggerHandler');
        List<Case_Message__c> failed_messages = [SELECT Id, Case_Message_Status__c FROM Case_Message__c WHERE Case_Message_Status__c = 'FAILED'];
        List<Case_Message__c> new_messages = [SELECT Id, Case_Message_Status__c FROM Case_Message__c WHERE Case_Message_Status__c = 'NEW'];

        System.assert(failed_messages.size() == 1, 'Expected 1 record, Got ' + failed_messages);
        System.assert(new_messages.size() == 1, 'Expected 1 record, Got ' + new_messages);
    }
}