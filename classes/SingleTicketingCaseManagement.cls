public without sharing class SingleTicketingCaseManagement {
    class SingleTicketingException extends Exception{}
    
    //static User soa_connection_user = [SELECT Id, Name FROM User WHERE Name='Soa Connection' LIMIT 1];
    Static Id soa_connection_userid =(Id)label.SOA_Connection;
    static List<Case_Message_Route__mdt>  message_routes = [
        SELECT 
        Id, 
        Queue_Developer_Name__c, 
        Remote_Destination__c, 
        Remote_Destination_Id__c,
        Freshdesk_Type__c,
        Product_Type__c //added on 1/22
        FROM Case_Message_Route__mdt
    ];
    
    public static void createOutboundCaseMessages(Map<Id,Case> mapOfCases,String actionName) {
        List<Case_Message__c> new_messages = SingleTicketingCaseManagement.create_outbound_case_message(mapOfCases, actionName);
        insert new_messages;
    }
    public static void updateOutboundCaseMessages(Map<Id,Case> CasesToBUpdtd,Map<Id,Case> OldCasesBeforeUpdate) {
        List<Case_Message__c> new_messages = SingleTicketingCaseManagement.create_outbound_case_message_update_driver(CasesToBUpdtd, OldCasesBeforeUpdate);
        upsert new_messages;        
    }
    public static void update_remote_destination(List<Case> new_cases){
        Map<String, Case_Message_Route__mdt> queue_developername_map = new Map<String, Case_Message_Route__mdt>();
        for(Case_Message_Route__mdt route: message_routes)
            queue_developername_map.put(route.Queue_Developer_Name__c, route);
        
        Map<Id, Group> my_group_map = new Map<Id, Group>([
            SELECT 
            Id,
            DeveloperName
            FROM Group 
            WHERE DeveloperName IN :queue_developername_map.keySet()
        ]);
        
        
        for(Case my_case: new_cases)
            if(my_group_map.keySet().contains(my_case.OwnerId))
            my_case.Remote_Destination__c = queue_developername_map.get(my_group_map.get(my_case.OwnerId).DeveloperName).Remote_Destination__c;
        
    }
    
    
    public static Map<Id, Case> filter_cases_by_field_difference(Map<Id, Case> new_case_map, Map<Id, Case> old_case_map, String field_name){
        Map<Id, Case> return_case_map = new Map<Id, Case>();
        for(Id case_id: new_case_map.keySet()){
            if(old_case_map.get(case_id).get(field_name) != new_case_map.get(case_id).get(field_name))
                return_case_map.put(case_id, new_case_map.get(case_id));
        }
        return return_case_map;
    }
    
    
    public static Map<Id, Case> filter_cases_by_queue_id_set(Map<Id, Case> case_map, Set<Id> queue_id_set){
        Map<Id, Case> return_case_map = new Map<Id, Case>();
        for(Id case_id: case_map.keySet()){
            if(queue_id_set.contains(case_map.get(case_id).OwnerId))
                return_case_map.put(case_id, case_map.get(case_id));
        }
        return return_case_map;
    }
    
    /**************************************************************
    * Wrapper function for handling the collection of relevant data for each piece of Case_Message__c generation and updates. 
    * @author Adam Albright, adam.albright@officedepot.com
    * @since 2020-01-17
    */
    public static List<Case_Message__c> create_outbound_case_message_update_driver(Map<Id, Case> new_case_map, Map<Id, Case> old_case_map){        
        
        // Get queues we care about. 
        Map<String, Case_Message_Route__mdt> queue_developername_map = new Map<String, Case_Message_Route__mdt>();
        for(Case_Message_Route__mdt route: message_routes)
            queue_developername_map.put(route.Queue_Developer_Name__c, route);
        
        Map<Id, Group> my_group_map = new Map<Id, Group>([
            SELECT 
            Id,
            DeveloperName
            FROM Group 
            WHERE DeveloperName IN :queue_developername_map.keySet()
        ]);
        
        // Get newly escalated cases.
        Map<Id, Case> newly_escalated_cases = filter_cases_by_queue_id_set(filter_cases_by_field_difference(new_case_map, old_case_map, 'OwnerId'), my_group_map.keySet());
        
        // Get the set of cases that now have new remote ids, so we can update holding messages. 
        Map<Id, Case> new_freshdesk_id_retrieved = filter_cases_by_field_difference(new_case_map, old_case_map, 'Freshdesk_Id__c');
        Map<Id, Case> new_oraclecx_id_retrieved = filter_cases_by_field_difference(new_case_map, old_case_map, 'OracleCX_Id__c');

        Set<Id> new_remote_ids_set = new Set<Id>();
        new_remote_ids_set.addAll(new_freshdesk_id_retrieved.keySet());
        new_remote_ids_set.addAll(new_oraclecx_id_retrieved.keySet());


        Map<Id, Case> updated_cases = new Map<Id, Case>();
        for(Case my_case: new_case_map.values()){
            if(! newly_escalated_cases.keySet().contains(my_case.Id)){
                updated_cases.put(my_case.Id, my_case);
            }
        }

        
        updated_cases = filter_cases_by_queue_id_set(updated_cases, my_group_map.keySet());
        
        List<Case_Message__c> my_messages = create_outbound_case_message( newly_escalated_cases, 'CREATED');
        my_messages.addAll(create_outbound_case_message( updated_cases, 'UPDATED'));
        my_messages.addAll(update_holding_messages(new_oraclecx_id_retrieved, new_freshdesk_id_retrieved));
        return my_messages;
    }

    /**************************************************************
    * When a case has the remote id updated, this function finds holding case_messages and changes their status to new. When the 
    * Sataus is set to new, it is sent to the external system. 
    * @author Adam Albright, adam.albright@officedepot.com
    * @since 2020-03-20
    */
    public static List<Case_Message__c> update_holding_messages(Map<Id, Case> new_oraclecx_id_retrieved, Map<Id, Case> new_freshdesk_id_retrieved){
        Map<Id, Case>  updated_case_ids = new Map<Id, Case>();
        updated_case_ids.putAll(new_oraclecx_id_retrieved);
        updated_case_ids.putAll(new_freshdesk_id_retrieved);
        List<Case_Message__c> messages_to_update = new List<Case_Message__c>([
            SELECT Id, Case_Message_Status__c, Case__c, Freshdesk_Id__c, OracleCX_Id__c FROM Case_Message__c WHERE Case__c IN :updated_case_ids.keySet() AND Case_Message_Status__c = 'HOLDING'
        ]);
        for (Case_Message__c my_message: messages_to_update){
            my_message.Case_Message_Status__c = 'NEW';
            my_message.Freshdesk_Id__c = updated_case_ids.get(my_message.Case__c).Freshdesk_Id__c;
            my_message.OracleCX_Id__c = String.valueOf(integer.valueof(updated_case_ids.get(my_message.Case__c).OracleCX_Id__c));
        }
            
        
        return messages_to_update;
    }
    
    
    /**************************************************************
    * Base function for creating outbound case messages. When cases are created or edited to be owned by a queue being 
    * synced to an external system, generate case messages to be sent to the extarnal system.
    * @author Adam Albright, adam.albright@officedepot.com
    * @since 2020-01-17
    */
    public static List<Case_Message__c> create_outbound_case_message(Map<Id, Case> new_case_map, String action){
        List<Case_Message__c> my_case_messages = new List<Case_Message__c>();
        Set<Id> case_ids_to_dispatch = new Set<Id>();
        Set<Id> user_ids = new Set<Id>();
        Set<Id> account_ids = new Set<Id>();
        Map<String, Case_Message_Route__mdt> queue_developername_map = new Map<String, Case_Message_Route__mdt>();
        for(Case_Message_Route__mdt route: message_routes)
            queue_developername_map.put(route.Queue_Developer_Name__c, route);
        
        Map<Id, Group> my_group_map = new Map<Id, Group>([
            SELECT 
            Id,
            DeveloperName
            FROM Group 
            WHERE DeveloperName IN :queue_developername_map.keySet()
        ]);
        
        for (Case my_case: new_case_map.values()){
            if(my_case.LastModifiedById == soa_connection_userid)
                continue;
            
            if(my_group_map.keySet().contains(my_case.OwnerId)){
                case_ids_to_dispatch.add(my_case.Id);
                user_ids.add(my_case.CreatedById);
                account_ids.add(my_case.AccountId);
            }
        }
        if (case_ids_to_dispatch.isEmpty())
            return my_case_messages;
        
        Map<Id, User> case_users = new Map<Id, User>([SELECT Id, Name, FirstName, LastName, Phone, MobilePhone, Email FROM User WHERE Id IN :user_ids]);
        Map<Id, Account> case_accounts = new Map<Id, Account>([SELECT Id, Cust_Id__c FROM Account WHERE Id IN :account_ids]);
        for (Id my_case_id: case_ids_to_dispatch){
            Case my_case = new_case_map.get(my_case_id);
            String remote_destination = queue_developername_map.get(my_group_map.get(my_case.OwnerId).DeveloperName).Remote_Destination__c;
            String freshdesk_type = queue_developername_map.get(my_group_map.get(my_case.OwnerId).DeveloperName).Freshdesk_Type__c;
            String product_type = queue_developername_map.get(my_group_map.get(my_case.OwnerId).DeveloperName).Product_Type__c; //Added on 1/22
            String phone = (
                case_users.get(my_case.CreatedById).Phone == null ? 
                case_users.get(my_case.CreatedById).MobilePhone: case_users.get(my_case.CreatedById).Phone
            );
            Case_Message__c my_message = new Case_Message__c(
                Case__c = my_case.Id,
                Case_Message_Action__c = action,
                Case_Message_Destination__c = remote_destination,
                User__c = my_case.CreatedById,
                Case_Message_Status__c = (action == 'CREATED' ? 'NEW' : get_message_status(my_case)), //Case_Message_Status__c = 'NEW'; Rajendra- updated value for field Case_Message_Status__c as per Jira ticket 02859338
                Freshdesk_Id__c = my_case.Freshdesk_Id__c,
                OracleCX_Id__c = String.valueOf(integer.valueOf(my_case.OracleCX_Id__c)),
                Phone__c = (phone == null ? '000-000-0000': phone.replace(' ', '-')),
                User_Email__c = case_users.get(my_case.CreatedById).Email,
                FirstName__c = case_users.get(my_case.CreatedById).FirstName,
                LastName__c = case_users.get(my_case.CreatedById).LastName,
                Freshdesk_Type__c = freshdesk_type,
                Product_Type__c = product_type //Added on 1/22
            );
            
            if(case_accounts.containsKey(my_case.AccountId))
                my_message.Account_Number__c = case_accounts.get(my_case.AccountId).Cust_Id__c;
            
            if(remote_destination == 'FRESHDESK')
                my_message.Freshdesk_Queue__c = queue_developername_map.get(my_group_map.get(my_case.OwnerId).DeveloperName).Remote_Destination_Id__c;
            else if(remote_destination == 'ORACLECX') {
                my_message.OracleCX_Queue__c = queue_developername_map.get(my_group_map.get(my_case.OwnerId).DeveloperName).Remote_Destination_Id__c;
            }
            
            my_case_messages.add(my_message);
        }
        
        return my_case_messages;
    }
    
    /**************************************************************
    * Gets the status of the message based on the state of the case external field ids, Freshdesk_Id__c and OracleCX_Id__c
    * @author Adam Albright, adam.albright@officedepot.com
    * @since 2020-01-17
    */
    static String get_message_status(Case my_outbound_case){
        if (my_outbound_case.Remote_Destination__c == 'FRESHDESK' && my_outbound_case.Freshdesk_Id__c != null )
            return 'NEW';
        if (my_outbound_case.Remote_Destination__c == 'ORACLECX' && my_outbound_case.OracleCX_Id__c != null )
            return 'NEW';
        return 'HOLDING';
        
    }

    /**************************************************************
    * Creates outbound case messages when attachments are added to a case being synced with an external system.
    * If the case has not yet recieved an external system id, it will be setup with a holding status. 
    * @author Adam Albright, adam.albright@officedepot.com
    * @since 2020-01-17
    */
    public static List<Case_Message__c> create_outbound_case_message_attachment(Map<Id, Attachment> new_attachment_map){
        
        Set<Id> parent_id_set = new Set<Id>();
        List<Case_Message__c> my_case_messages = new List<Case_Message__c>();
        
        for(Attachment my_attachment: new_attachment_map.values()){
            if(my_attachment.CreatedById == soa_connection_userid)
                continue;
            parent_id_set.add(my_attachment.ParentId);
            
        }
        
        Map<String, Case_Message_Route__mdt> queue_developername_map = new Map<String, Case_Message_Route__mdt>();
        for(Case_Message_Route__mdt route: message_routes)
            queue_developername_map.put(route.Queue_Developer_Name__c, route);
        
        Map<Id, Group> my_group_map = new Map<Id, Group>([
            SELECT 
            Id,
            DeveloperName
            FROM Group 
            WHERE DeveloperName IN :queue_developername_map.keySet()
        ]);
        
        Map<Id, Case> id_to_case_map = new Map<Id, Case>(
            [
                SELECT 
                Id, 
                Remote_Destination__c,
                OwnerId,
                Freshdesk_Id__c,
                OracleCx_Id__c,
                CreatedById,
                Account.Cust_ID__c
                FROM Case 
                WHERE Id 
                IN :parent_id_set AND Remote_Destination__c != null AND OwnerId IN :my_group_map.keySet()
            ]
        );
        
        if (id_to_case_map.isEmpty())
            return my_case_messages;
        
        for(Attachment my_attachment: new_attachment_map.values()){
            if (id_to_case_map.keySet().contains(my_attachment.ParentId)){
                Case my_case = id_to_case_map.get(my_attachment.ParentId);
                Case_Message__c my_message = new Case_Message__c(
                    Case__c = my_attachment.ParentId,
                    Attachment_Id__c = my_attachment.Id,
                    Freshdesk_Id__c = my_case.Freshdesk_Id__c,
                    OracleCX_Id__c = String.valueOf(integer.valueOf(my_case.OracleCX_Id__c)),
                    Case_Message_Action__c = 'UPDATED',
                    Case_Message_Destination__c = my_case.Remote_Destination__c,
                    User__c = my_case.CreatedById,
                    Case_Message_Status__c = get_message_status(my_case),
                    User_Email__c = UserInfo.getUserEmail(),
                    FirstName__c = UserInfo.getFirstName(),
                    LastName__c = UserInfo.getLastName(),
                    Account_Number__c = my_case.Account.Cust_ID__c
                    
                );
                
                if(my_case.Remote_Destination__c == 'FRESHDESK')
                    my_message.Freshdesk_Queue__c = queue_developername_map.get(my_group_map.get(my_case.OwnerId).DeveloperName).Remote_Destination_Id__c;
                else if(my_case.Remote_Destination__c == 'ORACLECX') 
                    my_message.OracleCX_Queue__c = queue_developername_map.get(my_group_map.get(my_case.OwnerId).DeveloperName).Remote_Destination_Id__c;
                
                my_case_messages.add(
                    my_message  
                );
            }
        }
        return my_case_messages;
    }
    
    
    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 17 October 2019
    * @description Generates an outbound message based on the new CaseComments.
    * @param 
    */
    public static  List<Case_Message__c> create_outbound_case_message_comment(Map<Id, CaseComment> new_comment_map){
        
        Set<Id> parent_id_set = new Set<Id>();
        List<Case_Message__c> my_case_messages = new List<Case_Message__c>();
        
        for(CaseComment my_comment: new_comment_map.values()){
            if(my_comment.CreatedById == soa_connection_userid){
                continue;
            }
            parent_id_set.add(my_comment.ParentId);
        }

        System.debug('Is the debugger just broken...' +parent_id_set );
        System.debug('Is the debugger just broken...' +parent_id_set.size() );
        
        Map<String, Case_Message_Route__mdt> queue_developername_map = new Map<String, Case_Message_Route__mdt>();
        for(Case_Message_Route__mdt route: message_routes)
            queue_developername_map.put(route.Queue_Developer_Name__c, route);
        
        System.debug('Is the debugger just broken...' +queue_developername_map );
        Map<Id, Group> my_group_map = new Map<Id, Group>([
            SELECT 
            Id,
            DeveloperName
            FROM Group 
            WHERE DeveloperName IN :queue_developername_map.keySet()
        ]);
        
        Map<Id, Case> id_to_case_map = new Map<Id, Case>(
            [
                SELECT 
                Id, 
                Remote_Destination__c,
                OwnerId,
                Freshdesk_Id__c,
                OracleCx_Id__c,
                CreatedById,
                Account.Cust_ID__c
                FROM Case 
                WHERE Id 
                IN :parent_id_set AND Remote_Destination__c != null AND OwnerId IN :my_group_map.keySet()
            ]
        );
        System.debug(LoggingLevel.INFO, my_group_map.keySet());
        
        if (id_to_case_map.isEmpty())
            return my_case_messages;
        
        for(CaseComment my_comment: new_comment_map.values()){
            if(my_comment.CreatedById == soa_connection_userid)
                continue;
            
            if (id_to_case_map.keySet().contains(my_comment.ParentId)){
                Case my_case = id_to_case_map.get(my_comment.ParentId);
                Case_Message__c my_message = new Case_Message__c(
                    Case__c = my_comment.ParentId,
                    Case_Message_Action__c = 'UPDATED',
                    Case_Message_Destination__c = my_case.Remote_Destination__c,
                    User__c = my_case.CreatedById,
                    Case_Comment_Id__c = my_comment.Id,
                    Freshdesk_Id__c = my_case.Freshdesk_Id__c,
                    OracleCX_Id__c = String.valueOf(integer.valueOf(my_case.OracleCX_Id__c)),
                    Case_Message_Status__c = get_message_status(my_case),
                    User_Email__c = UserInfo.getUserEmail(),
                    FirstName__c = UserInfo.getFirstName(),
                    LastName__c = UserInfo.getLastName(),
                    Account_Number__c = my_case.Account.Cust_ID__c
                );
                
                if(my_case.Remote_Destination__c == 'FRESHDESK')
                    my_message.Freshdesk_Queue__c = queue_developername_map.get(my_group_map.get(my_case.OwnerId).DeveloperName).Remote_Destination_Id__c;
                else if(my_case.Remote_Destination__c == 'ORACLECX') 
                    my_message.OracleCX_Queue__c = queue_developername_map.get(my_group_map.get(my_case.OwnerId).DeveloperName).Remote_Destination_Id__c;
                
                my_case_messages.add(
                    my_message  
                );
            }
        }
        
        return my_case_messages;
    }
    
    
    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 01 October 2019
    * @description Given a list of case comments from the CaseCommentWebservice, find the related cases and post the cooents to the cases. 
    * @param case_comments List of comments to add. 
    */
    public static List<CaseComment> update_case_comments_with_external_ids(List<CaseCommentSchema> case_comments){
        Map<String, String> result_map = new Map<String, String>();
        Set<Integer> freshdesk_id_set = new Set<Integer>();
        Set<Integer> oracle_cx_id_set = new Set<Integer>();
        Map<Integer, Id> freshdesk_id_to_case_id_map = new Map<Integer, Id>();
        Map<Integer, Id> oraclecx_id_to_case_id_map = new Map<Integer, Id>();
        Set<Id> salseforce_case_ids = new Set<Id>();
        List<CaseComment> final_case_comments = new List<CaseComment>();
        
        for(CaseCommentSchema comment: case_comments){
            if(comment.freshdesk_id != null && comment.oraclecx_id == null )
                freshdesk_id_set.add((Integer) comment.freshdesk_id);
            
            else if(comment.freshdesk_id == null && comment.oraclecx_id != null)
                oracle_cx_id_set.add((Integer) comment.oraclecx_id);
            
            else if(String.isNotBlank(comment.case_id))
                salseforce_case_ids.add((Id) comment.case_id);
        }
        
        for(Case my_case: [
            SELECT 
            Id,
            Freshdesk_Id__c, 
            OracleCX_Id__c,
            Remote_Destination__c,
            CreatedById,
            Account.Cust_ID__c
            FROM CASE 
            WHERE Freshdesk_Id__c IN :freshdesk_id_set 
            OR OracleCX_Id__c IN :oracle_cx_id_set 
            OR Id IN :salseforce_case_ids
        ]
           ){
               if(my_case.Freshdesk_Id__c != null)
                   freshdesk_id_to_case_id_map.put((Integer) my_case.Freshdesk_Id__c, my_case.Id);
               
               if(my_case.OracleCX_Id__c != null)
                   oraclecx_id_to_case_id_map.put((Integer) my_case.OracleCX_Id__c, my_case.Id);
               
               salseforce_case_ids.add(my_case.Id);
               System.debug(my_case);
           }
        
        for(CaseCommentSchema comment: case_comments){
            if(comment.freshdesk_id != null && freshdesk_id_to_case_id_map.keySet().contains(comment.freshdesk_id)){
                final_case_comments.add(
                    new CaseComment(
                        ParentId = freshdesk_id_to_case_id_map.get((Integer) comment.freshdesk_id),
                        CommentBody = EncodingUtil.base64Decode(comment.comment_payload_base64).toString()
                    )
                );
            } else if(comment.oraclecx_id != null && oraclecx_id_to_case_id_map.keySet().contains(comment.oraclecx_id)){
                final_case_comments.add(
                    new CaseComment(
                        ParentId = oraclecx_id_to_case_id_map.get((Integer) comment.oraclecx_id),
                        CommentBody = EncodingUtil.base64Decode(comment.comment_payload_base64).toString()
                    )
                );
            } else if (String.isNotBlank(comment.case_id) && salseforce_case_ids.contains(comment.case_id)){
                final_case_comments.add(
                    new CaseComment(
                        ParentId = comment.case_id,
                        CommentBody = EncodingUtil.base64Decode(comment.comment_payload_base64).toString()
                    )
                );
            }
        }
        
        return final_case_comments;
    }
    
    
    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 17 October 2019
    * @description Populate the Queue name on the message in the trigger context.
    */
    @TestVisible
    public static List<Case_Message__c> update_queue_developer_name_on_case_message(List<Case_Message__c> my_messages, Map<Id,Case> case_id_to_case_map){
        Map<Id, String> queue_ids_to_developer_names = new Map<Id, String>();
        
        Map<Id, List<Case_Message__c>> case_ids_to_case_messages = new Map<Id, List<Case_Message__c>>();
        
        // Get the Accociate Cases
        for(Case_Message__c message: my_messages)
            if(case_ids_to_case_messages.keySet().contains(message.Case__c))
            case_ids_to_case_messages.get(message.Case__c).add(message);
        else {
            case_ids_to_case_messages.put(message.Case__c, new List<Case_Message__c>{message});
        }
        
        // Map<Id,Case> my_cases = new Map<Id,Case>([SELECT Id, OwnerId, Remote_Destination__c FROM Case WHERE Id IN :case_ids_to_case_messages.keySet()]);
        
        // Get the Queues Associated With the cases
        for(Case my_case: case_id_to_case_map.values())
            if(String.valueOf(my_case.OwnerId).startsWith('00G'))
            queue_ids_to_developer_names.put(my_case.OwnerId, '');
        
        List<Group> my_queues = [SELECT Id, DeveloperName FROM Group WHERE Type='Queue' AND Id IN :queue_ids_to_developer_names.keySet()];
        
        for(Group queue: my_queues)
            queue_ids_to_developer_names.put(queue.Id, queue.DeveloperName);
        
        
        // Populate the queue developer names on the Case Messages. 
        for(Case_Message__c message: my_messages)
            if(queue_ids_to_developer_names.keySet().contains(case_id_to_case_map.get(message.Case__c).OwnerId))
            message.Queue_Developer_Name__c = queue_ids_to_developer_names.get(case_id_to_case_map.get(message.Case__c).OwnerId);
        
        if(Test.isRunningTest()){
            System.debug('My Queues:' + my_queues);
            System.debug('My Messages: ' + my_messages);
        }   
        
        
        return my_messages;
    }
    
    
    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 17 October 2019
    * @description Update the remote Id field on the case message based on the Case_Message_Route__mdt metadata.
    */
    @TestVisible
    static List<Case_Message__c> update_remote_id_on_case_message(List<Case_Message__c> case_message_list, List<Case_Message_Route__mdt> message_routes){
        if(case_message_list.isEmpty())
            throw new SingleTicketingException('The Case Message List is empty.');
        
        if(message_routes.isEmpty())
            throw new SingleTicketingException('No routes have been setup in Case_Message_Route__mdt');
        
        for(Case_Message__c message: case_message_list){
            System.debug(message);
            message.recalculateFormulas();
            System.debug('After Recalculate: ' + message);
            if(String.isNotBlank(message.Queue_Developer_Name__c))
                for(Case_Message_Route__mdt route: message_routes){
                    System.debug(route);
                    if(route.Queue_Developer_Name__c == message.Queue_Developer_Name__c){
                        if(route.Remote_Destination__c == 'FRESHDESK')
                            message.Freshdesk_Queue__c = route.Remote_Destination_Id__c;
                        else 
                            message.OracleCX_Queue__c = route.Remote_Destination_Id__c;
                        break;
                    }
                }
        }
        
        return case_message_list;
    }
    
    /*******************************************************************************************************
    * @author Adam Albright, adam.albright@officedepot.com, 18 October 2019
    * @description Case MEssage Drivver runs the case message generation process. With a list of case messages, it retrieves all the required data to dispatch the messages.
    */
    public static List<Case_Message__c> case_message_driver(List<Case_Message__c> case_messages){
        // Get the routes. 
        List<Case_Message_Route__mdt> message_routes = [
            SELECT 
            Id, 
            Queue_Developer_Name__c, 
            Remote_Destination__c, 
            Remote_Destination_Id__c 
            FROM Case_Message_Route__mdt
        ];
        
        Map<Id, Case> case_id_to_case_map = new Map<Id,Case>();
        
        for (Case_Message__c case_message: case_messages){
            case_id_to_case_map.put(case_message.Case__c, null);
        }
        
        case_id_to_case_map = new Map<Id,Case>([SELECT Id, OwnerId, Remote_Destination__c FROM Case WHERE Id IN :case_id_to_case_map.keySet()]);
        
        case_messages = update_queue_developer_name_on_case_message(case_messages, case_id_to_case_map);
        case_messages = update_remote_id_on_case_message(case_messages, message_routes);
        
        return case_messages;
        
    }

    /**************************************************************
    * Starts the CaseMessageDispatch jobs if it is not already started.  Typically called after insert and after update. 
    * @author Adam Albright, adam.albright@officedepot.com
    * @since 2020-01-17
    */
    public static void start_case_message_job(){
        ApexClass my_quable_class = [SELECT Id, Name FROM ApexClass WHERE Name='CaseMessageDispatch' LIMIT 1];
        List<AsyncApexJob> case_message_job =  [
            SELECT 
                Id,
                Status
            FROM AsyncApexJob WHERE Status IN ('Queued', 'Preparing', 'Processing') AND ApexClassId =: my_quable_class.Id LIMIT 1
        ];

        System.debug(case_message_job);

        if (case_message_job.isEmpty())
            System.enqueueJob(new CaseMessageDispatch());
    }
}