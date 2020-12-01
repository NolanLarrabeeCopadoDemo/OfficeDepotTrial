@isTest
public with sharing class SingleTicketingCaseManagement_Test {


    static Id case_id;
    static User soa_connection_user = [SELECT Id, Name FROM User WHERE Name='Soa Connection'];
    static Id support_recordtype_id  = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('SCOE').getRecordTypeId();

    static List<Case_Message_Route__mdt>  message_routes = [
            SELECT 
                Id, 
                Queue_Developer_Name__c, 
                Remote_Destination__c, 
                Remote_Destination_Id__c 
            FROM Case_Message_Route__mdt
        ];

    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 14 October 2019
    * @description Create Some Cases and case messages to go with the generated cases.
    */
    @TestSetup
    static void makeData(){
        RecordType rtCust   = [SELECT Id FROM RecordType WHERE sObjectType = 'Case' AND Name = 'Work Request'];
        Case c = new Case(recordtypeid=rtCust.Id, IT_BU_Reviewer__c =soa_connection_user.Id );
        insert c;
    }


    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 14 October 2019
    * @description For cases last modified someone other than SOA Connection, generate Case_Messages if the remote destination is set in the case.
    * User__c on Case_Messages should be the OwnerId on the case at the time of generation.
    * Case_Message_Action__c on case message should match what is passed in the action argument of the function.
    * Case_Message_Status__c should be NEW.
    */
    @isTest
    static void test_create_outbound_case_message(){
        
        Set<String> freshdesk_queue_names = new Set<String>();
        Set<String> ocx_queue_names = new Set<String>();
        for(Case_Message_Route__mdt route: message_routes)
            if(route.Remote_Destination__c == 'FRESHDESK')
                freshdesk_queue_names.add(route.Queue_Developer_Name__c);
            else if(route.Remote_Destination__c == 'ORACLECX')
                ocx_queue_names.add(route.Queue_Developer_Name__c);


        List<Group> freshdesk_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :freshdesk_queue_names];
        List<Group> ocx_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :ocx_queue_names];

        List<Id> my_case_ids = MyUtils.generate_id_list('Case', 1);
        Case test_case = new Case(
            Id = my_case_ids[0],
            Subject='Some Test Case',
            Description='This is a big test description.',
            LastModifiedById = soa_connection_user.Id,
            CreatedById = UserInfo.getUserId(),
            Remote_Destination__c = 'FRESHDESK',
            OwnerId = freshdesk_groups[0].Id,
            IT_BU_Reviewer__c =soa_connection_user.Id,
            RecordTypeId = support_recordtype_id
        );

        Case no_destination_test_case = new Case(
            Id = my_case_ids[0],
            Subject='Some Test Case',
            Description='This is a big test description.',
            LastModifiedById = null,
            CreatedById = UserInfo.getUserId(),
            Remote_Destination__c = null,
            IT_BU_Reviewer__c =soa_connection_user.Id,
            RecordTypeId = support_recordtype_id
        );

        Case generate_freshdesk_test_case = new Case(
            Id = my_case_ids[0],
            Subject='Some Test Case',
            Description='This is a big test description.',
            LastModifiedById = UserInfo.getUserId(),
            CreatedById = UserInfo.getUserId(),
            Remote_Destination__c = 'FRESHDESK',
            OwnerId = freshdesk_groups[0].Id,
            IT_BU_Reviewer__c =soa_connection_user.Id,
            RecordTypeId = support_recordtype_id
            
        );

        Case generate_oraclecx_test_case = new Case(
            Id = my_case_ids[0],
            Subject='Some Test Case',
            Description='This is a big test description.',
            LastModifiedById = UserInfo.getUserId(),
            CreatedById = UserInfo.getUserId(),
            Remote_Destination__c = 'ORACLECX',
            OwnerId = ocx_groups[0].Id,
            IT_BU_Reviewer__c =soa_connection_user.Id,
            RecordTypeId = support_recordtype_id
        );

        Test.startTest();
        // Scenario - Case with LastModifiedBy Soa Conection And remote Destination Set, Do not generate message.

        List<Case_Message__c> result = SingleTicketingCaseManagement.create_outbound_case_message(new Map<Id, Case>{test_case.Id => test_case}, 'CREATED');
        System.assert(result.size() == 0);

        // Scenario - Case without Remote Destination Set, Do not generate message.
        result = SingleTicketingCaseManagement.create_outbound_case_message(new Map<Id, Case>{no_destination_test_case.Id => no_destination_test_case}, 'CREATED');
        System.assert(result.size() == 0);

        // Scenario - Case with remote destination set to FRESHDESK and LastModified is not SOA, generate message.
        result = SingleTicketingCaseManagement.create_outbound_case_message(new Map<Id, Case>{generate_freshdesk_test_case.Id => generate_freshdesk_test_case}, 'CREATED');
        System.assert(result.size() == 1);
        System.assertEquals('FRESHDESK', result[0].Case_Message_Destination__c);
        System.assert(result[0].Case_Message_Action__c == 'CREATED');
        System.assert(result[0].Case__c == generate_freshdesk_test_case.Id);

        // Scenario - Case with remote destination set to ORACLECX and LastModified is not SOA, generate message.
        result = SingleTicketingCaseManagement.create_outbound_case_message(new Map<Id, Case>{generate_oraclecx_test_case.Id => generate_oraclecx_test_case}, 'CREATED');
        System.assert(result.size() == 1);
        // Check for OCX Fields on case message.
        System.assert(result.size() == 1);
        System.assertEquals('ORACLECX', result[0].Case_Message_Destination__c);
        System.assert(result[0].Case_Message_Action__c == 'CREATED');
        System.assert(result[0].Case__c == generate_oraclecx_test_case.Id);


        Test.stopTest();
    }


    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 14 October 2019
    * @description For attachments related to cases getting sent to the outbound system, test that messages are generated correctly.
    * The Case_Message_Action__c should be update and Case_Message_Status__c should be HOLDING.
    * User__c should be the Id of the case Owner.
    */
    @isTest
    static void test_create_outbound_case_message_attachment(){

        
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
                LastModifiedById = soa_connection_user.Id,
                Remote_Destination__c = 'FRESHDESK',
                Freshdesk_Id__c = 2,
                OwnerId = freshdesk_groups[0].Id,
                IT_BU_Reviewer__c =soa_connection_user.Id,
                RecordTypeId = support_recordtype_id
            ),
            new Case(
                Subject='Some Test Case',
                Description='This is a big test description.',
                LastModifiedById = UserInfo.getUserId(),
                Remote_Destination__c = 'FRESHDESK',
                Freshdesk_Id__c = 3,
                OwnerId = freshdesk_groups[0].Id,
                IT_BU_Reviewer__c =soa_connection_user.Id,
                RecordTypeId = support_recordtype_id
                
            )
        };

        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new JIRAWebserviceMock());
        TriggerHandler.bypass('AttachmentTriggerHandler');
        TriggerHandler.bypass('CaseTriggerHandler');
        insert test_cases;

        List<Attachment> my_attachments = new List<Attachment>{
            new Attachment(
                Name='Test Attachment 1',
                Body = Blob.valueOf('c29pbWUgdGV4dA=='),
                Description='Some Text',
                CreatedById = soa_connection_user.Id,
                ParentId=test_cases[0].Id
            ),
            new Attachment(
                Name='Test Attachment 2',
                Body = Blob.valueOf('c29pbWUgdGV4dA=='),
                Description='Some Text',
                CreatedById = UserInfo.getUserId(),
                ParentId=test_cases[1].Id
            )
        };
        Test.SetMock(HttpCallOutMock.class, new JIRACommentsWSMock());
        insert my_attachments;

        TriggerHandler.clearBypass('AttachmentTriggerHandler');
        TriggerHandler.clearBypass('CaseTriggerHandler');
        // Scenario - Attachment Created by user other than SOA Connection should generate a case message if the parent is a case being synced to a remote system.
        List<Case_Message__c> my_messages = SingleTicketingCaseManagement.create_outbound_case_message_attachment(
            new Map<Id, Attachment>{
                my_attachments[0].Id=>my_attachments[0]
            }
        );

        System.assert(my_messages.size()==0, 'SOA Connection User should not generate messages.');

        // Scenario - Attachment Created by SOA Connection should not generate a case message regardless of remote destination.

        my_messages = SingleTicketingCaseManagement.create_outbound_case_message_attachment(
            new Map<Id, Attachment>{
                my_attachments[1].Id=>my_attachments[1]
            }
        );

        System.assert(my_messages.size()==1, 'Non-SOA Connection User should generate messages.');
        Test.stopTest();
    }


    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 14 October 2019
    * @description For case comments related to cases getting sent to the outbound system, test that messages are generated correctly.
    * The Case_Message_Action__c should be update and Case_Message_Status__c should be HOLDING.
    * User__c should be the Id of the case Owner.
    */
    @isTest
    static void test_create_outbound_case_message_comment(){

                
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
                LastModifiedById = soa_connection_user.Id,
                Remote_Destination__c = 'FRESHDESK',
                Freshdesk_Id__c = 2,
                OwnerId = freshdesk_groups[0].Id,
                IT_BU_Reviewer__c =soa_connection_user.Id,
                RecordTypeId = support_recordtype_id
            ),
            new Case(
                Subject='Some Test Case',
                Description='This is a big test description.',
                LastModifiedById = UserInfo.getUserId(),
                Remote_Destination__c = 'FRESHDESK',
                Freshdesk_Id__c = 3,
                OwnerId = freshdesk_groups[0].Id,
                IT_BU_Reviewer__c =soa_connection_user.Id,
                RecordTypeId = support_recordtype_id
            )
        };

        System.debug(LoggingLevel.INFO, 'Cases: ' + test_cases);


        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new JIRAWebserviceMock());
        TriggerHandler.bypass('CaseCommentTriggerHandler');
        TriggerHandler.bypass('CaseTriggerHandler');
        insert test_cases;


        List<CaseComment> my_casecomments = new List<CaseComment>{
            new CaseComment(
                CommentBody = 'Made by SOA',
                CreatedById = soa_connection_user.Id,
                ParentId=test_cases[0].Id
            ),
            new CaseComment(
                CommentBody = 'Not by SOA',
                CreatedById = UserInfo.getUserId(),
                ParentId=test_cases[1].Id
            )
        };
        Test.SetMock(HttpCallOutMock.class, new JIRACommentsWSMock());
        insert my_casecomments;

        TriggerHandler.clearBypass('CaseCommentTriggerHandler');
        TriggerHandler.clearBypass('CaseTriggerHandler');
        // Scenario - CaseComment Created by user other than SOA Connection should generate a case message if the parent is a case being synced to a remote system.
        List<Case_Message__c> my_messages = SingleTicketingCaseManagement.create_outbound_case_message_comment(
            new Map<Id, CaseComment>{
                my_casecomments[0].Id=>my_casecomments[0]
            }
        );

        System.assert(my_messages.size()==0, 'SOA Connection User should not generate messages.');

        // Scenario - CaseComment Created by SOA Connection should not generate a case message regardless of remote destination.
        my_messages = SingleTicketingCaseManagement.create_outbound_case_message_comment(
            new Map<Id, CaseComment>{
                my_casecomments[1].Id=>my_casecomments[1]
            }
        );

        System.assert(my_messages.size()==1, 'Non-SOA Connection User should generate messages.');
    }

    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 14 October 2019
    * @description Given a list of case comment Schemas, new CaseComments should be generated.
    */
    @isTest
    static void test_update_case_comments_with_external_ids(){


                
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
                LastModifiedById = soa_connection_user.Id,
                Remote_Destination__c = 'FRESHDESK',
                Freshdesk_Id__c = 2,
                OwnerId = freshdesk_groups[0].Id,
                IT_BU_Reviewer__c =soa_connection_user.Id,
                RecordTypeId = support_recordtype_id
            ),
            new Case(
                Subject='Some Test Case',
                Description='This is a big test description.',
                LastModifiedById = UserInfo.getUserId(),
                Remote_Destination__c = 'ORACLECX',
                OracleCX_Id__c = 3,
                OwnerId = ocx_groups[0].Id,
                IT_BU_Reviewer__c =soa_connection_user.Id,
                RecordTypeId = support_recordtype_id
            )
        };

        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new JIRAWebserviceMock());
        TriggerHandler.bypass('CaseCommentTriggerHandler');
        TriggerHandler.bypass('CaseTriggerHandler');
        insert test_cases;


        // Scenario - Generate CaseComment with a FreshDesk Id Passed.
        List<CaseComment> my_comments = SingleTicketingCaseManagement.update_case_comments_with_external_ids(
            new List<CaseCommentSchema>{
                new CaseCommentSchema('<?xml version="1.0" encoding="UTF-8"?>' +
                    '<CaseComment>' +
                        '<case_id></case_id>' +
                        '<freshdesk_id>2</freshdesk_id>' +
                        '<oracle_cx_id></oracle_cx_id>' +
                        '<comment_payload_base64>SGVybGxvIQ==</comment_payload_base64>' +
                    '</CaseComment>')
            }
        );
        System.assert(my_comments.size()==1, 'Message should be generated linked to Freshdesk Case');

        // Scenario - Generate CaseComment with a OracleCX Id Passed.
        my_comments = SingleTicketingCaseManagement.update_case_comments_with_external_ids(
            new List<CaseCommentSchema>{
                new CaseCommentSchema('<?xml version="1.0" encoding="UTF-8"?>' +
                    '<CaseComment>' +
                        '<case_id></case_id>' +
                        '<freshdesk_id></freshdesk_id>' +
                        '<oraclecx_id>3</oraclecx_id>' +
                        '<comment_payload_base64>SGVybGxvIQ==</comment_payload_base64>' +
                    '</CaseComment>')
            }
        );
        System.assert(my_comments.size()==1, 'Message should be generated linked to OCX Case, got ' + my_comments);

        // Scenario - Generate CaseComment with a SalesForce Id Passed.
        my_comments = SingleTicketingCaseManagement.update_case_comments_with_external_ids(
            new List<CaseCommentSchema>{
                new CaseCommentSchema('<?xml version="1.0" encoding="UTF-8"?>' +
                    '<CaseComment>' +
                        '<case_id>' + test_cases[0].Id + '</case_id>' +
                        '<freshdesk_id></freshdesk_id>' +
                        '<oracle_cx_id></oracle_cx_id>' +
                        '<comment_payload_base64>SGVybGxvIQ==</comment_payload_base64>' +
                    '</CaseComment>')
            }
        );
        System.assert(my_comments.size()==1, 'Message should be generated linked to Salesforce Case, got ' + my_comments);

        TriggerHandler.clearBypass('CaseCommentTriggerHandler');
        TriggerHandler.clearBypass('CaseTriggerHandler');
        Test.stopTest();
    }

    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 17 October 2019
    * @description 
    * @scenario - With a map of Queue Names to Destinations, ensure the destination on the generated message is correct.
    * The Case_Message_Route__mdt is used to store the routes.
    */
    @isTest
    static void test_case_destination_assignment(){

        TriggerHandler.bypass('CaseCommentTriggerHandler');
        TriggerHandler.bypass('CaseTriggerHandler');

        Map<String, String> developer_names_to_destinations = new Map<String, String>();
        Map<String, String> group_ids_to_destinations = new Map<String, String>();
        Set<String> freshdesk_queue_names = new Set<String>();
        Set<String> ocx_queue_names = new Set<String>();
        for(Case_Message_Route__mdt route: message_routes){
            if(route.Remote_Destination__c == 'FRESHDESK')
                freshdesk_queue_names.add(route.Queue_Developer_Name__c);
            else if(route.Remote_Destination__c == 'ORACLECX')
                ocx_queue_names.add(route.Queue_Developer_Name__c);
            developer_names_to_destinations.put(route.Queue_Developer_Name__c, route.Remote_Destination_Id__c);
        }
            
        
        List<Group> freshdesk_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :freshdesk_queue_names];
        List<Group> ocx_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :ocx_queue_names];

        for(Group my_group: freshdesk_groups)
            group_ids_to_destinations.put(my_group.Id, developer_names_to_destinations.get(my_group.DeveloperName));
        for(Group my_group: ocx_groups)
            group_ids_to_destinations.put(my_group.Id, developer_names_to_destinations.get(my_group.DeveloperName));


        
        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new JIRAWebserviceMock());
        List<Case> my_test_cases = new List<Case>{
            new Case(
                Remote_Destination__c='FRESHDESK',
                Subject='A sad test case T_T',
                Description='Some test description.',
                OwnerId = freshdesk_groups[0].Id,
                CreatedById = UserInfo.getUserId(),
                IT_BU_Reviewer__c =soa_connection_user.Id
            ),
            new Case(
                Remote_Destination__c='ORACLECX',
                Subject='A sad test case T_T',
                Description='Some test description.',
                OwnerId=ocx_groups[0].Id,
                CreatedById = UserInfo.getUserId(),
                IT_BU_Reviewer__c =soa_connection_user.Id
            )
        };
        insert my_test_cases;


        // Create a Case and Case Message to be sent out. Run the process. It should change the message status from NEW
        // to SUBMITTED.

        Map<Id, Case> case_id_to_case =  new Map<Id, Case>{
            my_test_cases[0].Id => my_test_cases[0],
            my_test_cases[1].Id => my_test_cases[1]
        };

        List<Case_Message__c> my_messages = SingleTicketingCaseManagement.create_outbound_case_message(
            case_id_to_case,
            'CREATED');

        System.debug(my_messages);
        my_messages = SingleTicketingCaseManagement.update_queue_developer_name_on_case_message(my_messages, case_id_to_case);
        my_messages = SingleTicketingCaseManagement.update_remote_id_on_case_message(my_messages, message_routes);
        
        for(Integer i = 0; i< my_messages.size(); i++){
            if(my_messages[i].Case_Message_Destination__c == 'ORACLECX'){
                System.assertEquals(group_ids_to_destinations.get(case_id_to_case.get(my_messages[i].Case__c).OwnerId), my_messages[i].Oraclecx_Queue__c);
            } else if(my_messages[i].Case_Message_Destination__c == 'FRESHDESK'){
                System.assertEquals(group_ids_to_destinations.get(case_id_to_case.get(my_messages[i].Case__c).OwnerId), my_messages[i].Freshdesk_Queue__c);
            }
        }
        Test.stopTest();
        TriggerHandler.clearBypass('CaseCommentTriggerHandler');
        TriggerHandler.clearBypass('CaseTriggerHandler');
    }


    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 17 October 2019
    * @description 
    * @scenario - With a map of Queue Names to Destinations, ensure the destination on the generated message is correct.
    * The Case_Message_Route__mdt is used to store the routes.
    */
    @isTest
    static void test_case_message_driver(){

        TriggerHandler.bypass('CaseCommentTriggerHandler');
        TriggerHandler.bypass('CaseTriggerHandler');


        Set<String> freshdesk_queue_names = new Set<String>();
        Set<String> ocx_queue_names = new Set<String>();
        for(Case_Message_Route__mdt route: message_routes)
            if(route.Remote_Destination__c == 'FRESHDESK')
                freshdesk_queue_names.add(route.Queue_Developer_Name__c);
            else if(route.Remote_Destination__c == 'ORACLECX')
                ocx_queue_names.add(route.Queue_Developer_Name__c);


        List<Group> freshdesk_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :freshdesk_queue_names];
        List<Group> ocx_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :ocx_queue_names];

        
        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new JIRAWebserviceMock());
        List<Case> my_test_cases = new List<Case>{
            new Case(
                Remote_Destination__c='FRESHDESK',
                Subject='A sad test case T_T',
                Description='Some test description.',
                OwnerId=freshdesk_groups[0].Id,
                CreatedById = UserInfo.getUserId(),
                IT_BU_Reviewer__c =soa_connection_user.Id,
                RecordTypeId = support_recordtype_id
            ),
            new Case(
                Remote_Destination__c='ORACLECX',
                Subject='A sad test case T_T',
                Description='Some test description.',
                OwnerId=ocx_groups[0].Id,
                CreatedById = UserInfo.getUserId(),
                IT_BU_Reviewer__c =soa_connection_user.Id,
                RecordTypeId = support_recordtype_id
            )
        };
        insert my_test_cases;
        Map<Id, Case> case_id_to_case =  new Map<Id, Case>{
            my_test_cases[0].Id => my_test_cases[0],
            my_test_cases[1].Id => my_test_cases[1]
        };

        List<Case_Message__c> my_messages = SingleTicketingCaseManagement.create_outbound_case_message(
            case_id_to_case,
            'CREATED');

        System.debug(my_messages);
        my_messages = SingleTicketingCaseManagement.case_message_driver(my_messages);
        Test.stopTest();

        TriggerHandler.clearBypass('CaseCommentTriggerHandler');
        TriggerHandler.clearBypass('CaseTriggerHandler');
    }

    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 17 October 2019
    * @description Creates a case and then starts the Case Message Dispact Job from the case Message Trigger.
    * @scenario - With a map of Queue Names to Destinations, ensure the destination on the generated message is correct.
    * The Case_Message_Route__mdt is used to store the routes.
    */
    @isTest
    static void test_case_message_dispatch_job(){

        TriggerHandler.bypass('CaseCommentTriggerHandler');
        TriggerHandler.bypass('CaseTriggerHandler');


        Set<String> freshdesk_queue_names = new Set<String>();
        Set<String> ocx_queue_names = new Set<String>();
        for(Case_Message_Route__mdt route: message_routes)
            if(route.Remote_Destination__c == 'FRESHDESK')
                freshdesk_queue_names.add(route.Queue_Developer_Name__c);
            else if(route.Remote_Destination__c == 'ORACLECX')
                ocx_queue_names.add(route.Queue_Developer_Name__c);


        List<Group> freshdesk_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :freshdesk_queue_names];
        List<Group> ocx_groups = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName IN :ocx_queue_names];

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

        List<Case> my_test_cases = new List<Case>{
            new Case(
                Remote_Destination__c='FRESHDESK',
                Subject='A sad test case T_T',
                Description='Some test description.',
                OwnerId=freshdesk_groups[0].Id,
                CreatedById = UserInfo.getUserId(),
                IT_BU_Reviewer__c =soa_connection_user.Id
            )
        };
        Test.SetMock(HttpCallOutMock.class, new JIRAWebserviceMock());
        insert my_test_cases;

        Test.setMock( HttpCalloutMock.class, new CaseMessageDispatch_TC.CaseMessageDispatchMock());
        Test.startTest();

        Map<Id, Case> case_id_to_case =  new Map<Id, Case>{
            my_test_cases[0].Id => my_test_cases[0]
        };

        List<Case_Message__c> my_messages = SingleTicketingCaseManagement.create_outbound_case_message(
            case_id_to_case,
            'CREATED');

        System.debug(my_messages);
        my_messages = SingleTicketingCaseManagement.case_message_driver(my_messages);
        insert my_messages;
        Test.stopTest();
        List<Case_Message__c> processed_messages = [SELECT Id, Case_Message_Status__c FROM Case_Message__c];


        System.assert(processed_messages.size() == 1, 'Expected 1 record, Got ' + processed_messages);
        System.assert(processed_messages[0].Case_Message_Status__c == 'PROCESSED', 'Expected PROCESSED record, Got ' + processed_messages[0].Case_Message_Status__c);

        TriggerHandler.clearBypass('CaseCommentTriggerHandler');
        TriggerHandler.clearBypass('CaseTriggerHandler');
    }

    /* To cover CaseTriggerHandler
     * 
     * */
    @isTest
    static void fetchCases() {
        makeData();
    }
}