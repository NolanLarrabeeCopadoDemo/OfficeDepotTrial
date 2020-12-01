public class DMLRelationController {


    static Map<String, Id> case_record_type_name_to_id_map = ODCommonUtilityMethods.getRecordTypeDeveloperNameToId('Case');

    class DMLRelationException extends Exception{}

    public class DMLRelatedData {
        @AuraEnabled
        public List < DML_Relation__c > DMLList { get; set; }

        @AuraEnabled
        public Integer countDml { get; set; }

        @AuraEnabled
        public Integer page { get; set; }
        
        public DMLRelatedData(List < DML_Relation__c > DMLList, Integer countDml, Integer page ) {
            
            this.DMLList = DMLList;
            this.countDml = countDml;
            this.page = page;
        }
    }
    /*code change for NAIT-133025* by Himanshu */
      @AuraEnabled        
   	 public static List<String> getPickListValuesIntoList(){
        List<String> pickListValuesList = new List<String>();
        Schema.DescribeFieldResult fieldResult = DML__c.Segment_Override__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
            System.debug('Values in Rating are: '+pickListValuesList);
        }     
        return pickListValuesList;
    }
    
/*
    @AuraEnabled
    public static List <Case> getDMLApprovalData() {
        List <Case> dml_cases = [ 
            SELECT 
                Id, 
                CaseNumber, 
                Subject, 
                CreatedDate, 
                Support_Sub_Type__c, 
                Account__c, 
                Account.Id,
                Related_DML_Number__c, 
                Account.Related_DML__r.Id, 
                Account.Related_DML__r.DECISION_MAKER_NM__c,
                Account.AOPS_Cust_Id__c, 
                L1_Support_Rep_Name__c, 
                Account.Related_DML__c, 
                Status,
                Support_Requester__r.name, 
                Outside_Support_Rep__r.Name, 
                Support_Requestor_Manager__c 
            FROM Case
            WHERE (
                Support_Sub_Type__c = 'New DML Exception' 
                AND Support_Type__c = 'Deployment'
                ) 
            AND isClosed = false 
            AND Account.Related_DML__c != null 
            AND Account.Related_DML__r.Status__c = 'Draft' ORDER BY CreatedDate DESC
        ];

        return dml_cases;
    }*/
    //Start - Sandesh Ganjare
    //Pagination for DML Approval data
    @AuraEnabled
    public static CasePagerWrapper getDMLApprovalData(Integer pageNumber ,Integer recordToDisply) {
        Integer pageSize = recordToDisply;
        Integer offset = (pageNumber - 1) * pageSize;                   
        // create a instance of wrapper class.
        CasePagerWrapper objWrapper =  new CasePagerWrapper();
        // set the pageSize,Page(Number), total records and case List(using OFFSET)   
            
            objWrapper.total = [
                                    SELECT count() 
                                    FROM Case WHERE (
                                        Support_Sub_Type__c = 'New DML Exception' 
                                        AND Support_Type__c = 'Deployment'
                                        ) 
                                    AND isClosed = false 
                                    AND Account.Related_DML__c != null 
                                    AND Account.Related_DML__r.Status__c = 'Draft'
                                ];
            objWrapper.cases = [ 
                                SELECT 
                                    Id, 
                                    CaseNumber, 
                                    Subject, 
                                    CreatedDate, 
                                    Support_Sub_Type__c, 
                                    Account__c, 
                                    Account.Id,
                                    Related_DML_Number__c, 
                                    Account.Related_DML__r.Id, 
                                    Account.Related_DML__r.DECISION_MAKER_NM__c,
                                    Account.AOPS_Cust_Id__c, 
                                    L1_Support_Rep_Name__c, 
                                    Account.Related_DML__c, 
                                    Status,
                                    Support_Requester__r.name, 
                                    Outside_Support_Rep__r.Name, 
                                    Support_Requestor_Manager__c 
                                FROM Case
                                WHERE (
                                    Support_Sub_Type__c = 'New DML Exception' 
                                    AND Support_Type__c = 'Deployment'
                                    ) 
                                AND isClosed = false 
                                AND Account.Related_DML__c != null 
                                AND Account.Related_DML__r.Status__c = 'Draft' ORDER BY CreatedDate DESC LIMIT :recordToDisply OFFSET :offset
                            ];
            objWrapper.pageSize = pageSize;
            objWrapper.page = pageNumber;
        System.debug('objWrapper==>'+objWrapper);
        // return the wrapper class instance .
        return objWrapper;
    }

    // create a wrapper class with @AuraEnabled Properties    
    public class CasePagerWrapper {
        @AuraEnabled public Integer pageSize {get;set;}
        @AuraEnabled public Integer page {get;set;}
        @AuraEnabled public Integer total {get;set;}
        @AuraEnabled public List<Case> cases {get;set;}
    }
    //Start - Sandesh Ganjare


    @AuraEnabled
    public static CasePagerWrapper processDMLApproval(String InputData, Integer pageNumber ,Integer recordToDisply){
        Savepoint sp = Database.setSavepoint();
        try {
            return process_dml_approvals(InputData, pageNumber, recordToDisply);
        } catch (DMLRelationException e){
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());
        } catch (Exception e){
            Database.rollback(sp);
            throw new AuraHandledException('An un revoverable error occured. Please create a ticket with IT.');
        }
    }

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com, 12 September 2019
     * @description On a dml approval, create a dml_relation between the account, and the dml. The Related DML on the account should be cleared. 
     * @param String json_case_id_list: A json string representing a list of Case Ids.
     */
    @TestVisible
    static CasePagerWrapper process_dml_approvals(String json_case_id_list, Integer pageNumber ,Integer recordToDisply) {

        if (String.isBlank(json_case_id_list) || json_case_id_list == '[]'){
            throw new DMLRelationException('No Case Ids recieved.');
        }

        List < String > case_id_list = (List <String> ) JSON.deserialize(json_case_id_list, List < String > .class);

        List <Case> dml_cases = new List <Case> ();
        List <Case> case_approval_list = [
            SELECT 
                Account.Related_DML__c, 
                Status, 
                AccountId
            FROM Case
            WHERE Id IN :case_id_list
            ];

        if (case_approval_list.isEmpty())
            return getDMLApprovalData(pageNumber, recordToDisply);
            //return case_approval_list;

        Set < Id > related_account_id_set = new Set <Id>();
        for (Case caseRec: case_approval_list) {
            related_account_id_set.add(caseRec.accountId);
        }


        if (related_account_id_set.isEmpty())
            return getDMLApprovalData(pageNumber, recordToDisply);
            //return case_approval_list;

        //Set the effective end date of old dml relations to yesterday.
        List < DML_Relation__c > old_dml_relation_list = [
            SELECT
                Id, 
                Effective_End_Date__c 
            FROM DML_Relation__c 
            WHERE Account__c IN :related_account_id_set 
            AND (
                Effective_End_Date__c >= today 
                OR Effective_End_Date__c = null
                )
        ];
        
        // Set the effective date of old relations to yesterday. 
        for (DML_Relation__c rec: old_dml_relation_list)
            rec.Effective_End_Date__c = System.today() - 1;
    
        List<DML_Relation__c> dml_relation_upsert_list = new List <DML_Relation__c> (old_dml_relation_list);
        List<DML__c> update_dml_list = new List <DML__c> ();
        List<Account> accounts_related_dml_list = new List<Account>();
        // Close the related cases and create the new dml relations.
        for (Case my_case: case_approval_list) {
            my_case.status = 'Closed';
            my_case.RecordTypeId = case_record_type_name_to_id_map.get('Deployment Request');

            update_dml_list.add(
                new DML__c(
                    Id = my_case.Account.Related_DML__c,
                    Status__c =  'Approved'
                )
            );

            dml_relation_upsert_list.add(
                new DML_Relation__c(
                    DML__c = my_case.Account.Related_DML__c,
                    Account__c = my_case.AccountId,
                    Effective_Start_Date__c = System.today()
                )
            );
            accounts_related_dml_list.add(new Account(
                Id = my_case.Account.Id,
                Related_DML__c = null
            ));
        }

        if (case_approval_list.size() > 0){
            update case_approval_list;
        }

        if (update_dml_list.size() > 0){
            update update_dml_list;
        }

        if (dml_relation_upsert_list.size() > 0){
            upsert dml_relation_upsert_list;
        }

        /*dml_cases =
        [
            SELECT 
                Id, 
                CaseNumber, 
                subject, 
                CreatedDate, 
                Support_Sub_Type__c, 
                Account__c, 
                Account.Id,
                Related_DML_Number__c, 
                Account.Related_DML__r.Id, 
                Account.Related_DML__r.DECISION_MAKER_NM__c,
                Account.AOPS_Cust_Id__c, 
                L1_Support_Rep_Name__c, 
                Account.Related_DML__c, 
                Status,
                Support_Requester__r.Name,
                Outside_Support_Rep__r.Name, 
                Support_Requestor_Manager__c 
            FROM Case
            WHERE Support_Sub_Type__c = 'New DML Exception'
            AND Support_Type__c = 'Deployment'
            AND isclosed = false 
            AND Account.Related_DML__c != null
            AND Account.Related_DML__r.Status__c = 'Draft'
            ORDER BY CreatedDate DESC
        ];
        
        return dml_cases;*/

        return getDMLApprovalData(pageNumber, recordToDisply);
    }


    @AuraEnabled
    public static CasePagerWrapper processDMLRejection(String InputData, String Notes, Integer pageNumber ,Integer recordToDisply){
        Savepoint sp = Database.setSavepoint();

        try {
            return process_dml_rejections(InputData, Notes, pageNumber , recordToDisply);
        } catch (DMLRelationException e){
            Database.rollback(sp);
            throw new AuraHandledException(e.getMessage());
        } catch (Exception e){
            Database.rollback(sp);
            throw new AuraHandledException('An un revoverable error occured. Please create a ticket with IT.');
        }
    }


    @AuraEnabled
    public static CasePagerWrapper process_dml_rejections(String case_id_list, String Notes, Integer pageNumber ,Integer recordToDisply) {
         
        List <String> CaseId = (List < String > ) JSON.deserialize(case_id_list, List < String > .class);

        List <DML__c> update_dml_list = new List < DML__c > ();

        List <Case> case_rejection_list = [SELECT Account.Related_DML__c, status, AccountId FROM Case WHERE Id IN :CaseId];
        List < Id > dml_id_list = new List < Id > ();
        List < CaseComment > newNotes = new List < CaseComment > ();

        for (Case rec: case_rejection_list) {
            dml_id_list.add(rec.Account.Related_DML__c);
            rec.status = 'Closed';
            rec.RecordTypeId = case_record_type_name_to_id_map.get('Deployment Request');
            rec.Comments = Notes;

            DML__c newrec = new DML__c(
                Id = rec.Account.Related_DML__c,
                Status__c = 'Rejected',
                Notes__c = Notes,
                Effective_End_Date__c = System.today()
            );

            update_dml_list.add(newrec);
        }

        if (case_rejection_list.size() > 0){
            update case_rejection_list;
        }

        if (update_dml_list.size() > 0){
            update update_dml_list;
        }

        if (newNotes.size() > 0){
            insert newNotes;
        }

        /*List <Case> dml_cases =
        [
            SELECT 
                Id, 
                CaseNumber, 
                Subject, 
                CreatedDate, 
                Support_Sub_Type__c, 
                Account__c, 
                Account.Id,
                Related_DML_Number__c, 
                Account.Related_DML__r.Id, 
                Account.Related_DML__r.DECISION_MAKER_NM__c,
                Account.AOPS_Cust_Id__c, 
                L1_Support_Rep_Name__c, 
                Account.Related_DML__c, 
                Status,
                Support_Requester__r.name, 
                Outside_Support_Rep__r.Name, 
                Support_Requestor_Manager__c 
            FROM Case
            WHERE Support_Sub_Type__c = 'New DML Exception'
            AND Support_Type__c = 'Deployment'
            AND isclosed = false 
            AND Account.Related_DML__c != null 
            AND Account.Related_DML__r.Status__c = 'Draft' 
            ORDER BY CreatedDate DESC
        ];

        return dml_cases;*/
        return getDMLApprovalData(pageNumber, recordToDisply);
    }

    //Commented below code as it is find out to be unused // Sandesh Ganjare - Pune Team
    /*static Set<DML_Relation__c> filterByFieldValue(List<DML_Relation__c> my_dml_list, Set<DML_Relation__c> final_dml_relation_set, String field_name, Set<String> filter_values){

        for (DML_Relation__c my_dml_relation: my_dml_list){
            System.debug(LoggingLevel.INFO, 'Field Output is:' + (String) my_dml_relation.get(field_name));
            if (filter_values.contains(((String) my_dml_relation.get(field_name)).toLowerCase() )){
                final_dml_relation_set.add(my_dml_relation);
            }
        }
        return final_dml_relation_set;
    }

    
    static Set<DML_Relation__c> filterByStringCSV(List<DML_Relation__c> my_dml_list, Set<DML_Relation__c> final_dml_relation_set, String field_name, String comma_seperated_values){
        if (String.isBlank(comma_seperated_values)){
            System.debug(LoggingLevel.WARN, 'No Filter Criteria Specified for: ' + field_name);
            return final_dml_relation_set;
        }

        Set<String> filter_set = new Set<String>();
        for(String value: comma_seperated_values.split(',')){
            filter_set.add(value.trim().toLowerCase());
        }
        return filterByFieldValue(my_dml_list, final_dml_relation_set, field_name, filter_set);

    }*/
    // End 

    @AuraEnabled
    public static DMLRelatedData getDMLRelationData(
        List<String> customer_id_list, 
        List<String> parent_id_list, 
        List<String> dml_id_list,
        String dml_name, 
        List<String> sales_rep_id_list, 
        List<String> grandparent_id_list,
        List<String> duns_number_list,
        Integer pageNumber,
        Integer recordToDisply
    ){
        try{
            //List<String> customer_id_list = (List<String>) JSON.deserialize(customer_id_list_json, List<String>.class);
            // List<String> parent_id_list = (List<String>) JSON.deserialize(parent_id_list_json, List<String>.class);
            // List<String> dml_id_list = (List<String>) JSON.deserialize(dml_id_list_json, List<String>.class);
            // List<String> sales_rep_id_list = (List<String>) JSON.deserialize(sales_rep_id_list_json, List<String>.class);
            // List<String> grandparent_id_list = (List<String>) JSON.deserialize(grandparent_id_list_json, List<String>.class);
            // List<String> duns_number_list = (List<String>) JSON.deserialize(duns_number_list_json, List<String>.class);
            
            return retrieve_dml_data(customer_id_list, parent_id_list, dml_id_list, dml_name, sales_rep_id_list, grandparent_id_list, duns_number_list, pageNumber, recordToDisply);
        } catch (DMLRelationException e) {
            throw new AuraHandledException('Something Broke, please reach out to IT.');
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, e.getStackTraceString());
            throw new AuraHandledException('Something Really Broke, please reach out to IT.');
        }

    }

    static DMLRelatedData retrieve_dml_data(
        List<String> customer_id_list, 
        List<String> parent_id_list, 
        List<String> dml_id_list,
        String dml_name, 
        List<String> sales_rep_id_list, 
        List<String> grandparent_id_list,
        List<String> duns_number_list,
        Integer pageNumber,
        Integer recordToDisply
    ){
        Integer offset = (pageNumber - 1) * recordToDisply;
        List<Query.Condition> my_conditions = new List<Query.Condition>();
        
        if (!customer_id_list.isEmpty()) {
            my_conditions.add(Query.conditionIn('CUSTOMERID__c', customer_id_list));
        }
        if (!parent_id_list.isEmpty()) {
            my_conditions.add(Query.conditionIn('Parent_Id__c', parent_id_list));
        }
        if (!dml_id_list.isEmpty()) {
            my_conditions.add(Query.conditionIn('DML_ID__c', dml_id_list));
        }
        if (!grandparent_id_list.isEmpty()) {
            my_conditions.add(Query.conditionIn('GrandParent_Id__c', grandparent_id_list));
        }
        if (!duns_number_list.isEmpty()) {
            my_conditions.add(Query.conditionIn('Org_Duns_Number__c', duns_number_list));
        }
        if (!sales_rep_id_list.isEmpty()) {
            my_conditions.add(Query.conditionIn('DML_RepID__c', sales_rep_id_list));
        }
        if (String.isNotBlank(dml_name)) {
            my_conditions.add(Query.conditionLike('Decision_Maker_Name__c', dml_name.toLowerCase()));
        }
        
        System.debug('my_conditions ==>'+my_conditions);
        List<DML_Relation__c> relationsSize =
            new Query('DML_Relation__c').
            selectFields('Id,DMLFormula__c,DateFormula__c,SalesRepFormula__c,DML_Segment_Formula__c,Teaming_SalesRepFormula__c,Org_Name__c,CUSTOMERID__c,Parent_Id__c,DECISIONMAKERID__c,DML_ID__c,Customer_Name__c,RecordType__c,Effective_Start_Date__c,Decision_Maker_Name__c,DML_RepID__c,GrandParent_Id__c,Org_Duns_Number__c,Parent_Name__c,GrandParent_Name__c').
            addCondition(Query.doAnd(my_conditions)).run();

        Integer total = (relationsSize != null && relationsSize.size() > 0) ? relationsSize.size() : 0; 

        List<DML_Relation__c> relations =
            new Query('DML_Relation__c').
            selectFields('Id,DMLFormula__c,DateFormula__c,SalesRepFormula__c,DML_Segment_Formula__c,Teaming_SalesRepFormula__c,Org_Name__c,CUSTOMERID__c,Parent_Id__c,DECISIONMAKERID__c,DML_ID__c,Customer_Name__c,RecordType__c,Effective_Start_Date__c,Decision_Maker_Name__c,DML_RepID__c,GrandParent_Id__c,Org_Duns_Number__c,Parent_Name__c,GrandParent_Name__c').
            addCondition(Query.doAnd(my_conditions)).
            setLimit(recordToDisply).
            setOffset(offset).run();

        return new DMLRelatedData(relations, total , pageNumber);
    }


    @AuraEnabled
    public static Map <String, List<Object>> processDMLRelationData(String InputData, String newDMLId, String DateVal){
        try {
            return process_dml_relation_data(InputData, newDMLId, DateVal);
        } catch (DMLRelationException e){
            throw new AuraHandledException(e.getMessage());
        } catch (Exception e){
            throw new AuraHandledException('An unexpected error occured, please reach out to IT.');
        }
    }


    static Map <String, List<Object>> process_dml_relation_data(String dml_id_list_json_string, String new_dml_id, String date_value) {
        List < String > dml_id_list = (List <String>) System.JSON.deserialize(dml_id_list_json_string, List <String>.class);
        List<DML_Relation__c> dml_relations_to_update = [
            SELECT 
                Id, 
                DML_Segment_Formula__c, 
                Teaming_SalesRepFormula__c, 
                SalesRepFormula__c, 
                DMLFormula__c, 
                Org_Name__c, 
                CUSTOMERID__c, 
                Parent_Id__c, 
                DECISIONMAKERID__c, 
                Effective_Start_Date__c,
                DateFormula__c, 
                Effective_End_Date__c, 
                DML_RepID__c, 
                Decision_Maker_Name__c, 
                GrandParent_Id__c, 
                Org_Duns_Number__c, 
                Customer_Name__c, 
                RecordType__c, 
                DML_ID__c, 
                Parent_Name__c, 
                GrandParent_Name__c  
            FROM DML_Relation__c
            WHERE Id IN :dml_id_list
        ];

        for (DML_Relation__c dml_relation: dml_relations_to_update) {
            if (String.isNotBlank(new_dml_id)) {
                dml_relation.New_DML__c = new_dml_id;
            }
            if (String.isNotBlank(date_value)) {
                dml_relation.New_start_Date__c = Date.valueOf(date_value);
            }
            dml_relation.NewRequest__c = true;
            dml_relation.ProcessNew_Request__c =true;
            dml_relation.Requested_By__c = UserInfo.getUserId();
        }

        return update_dml_relations(dml_relations_to_update, true);
    }


    @AuraEnabled
    public static List < DML_Relation__c > processDMLRelationDataSalesRep(
        String InputData, 
        String newDMLId,
        String Segment, 
        String newDMLIdVal,
        String ProposedDate,
		String Segmentoverride,
		String segmentoverridereason) {
        try {
            return process_dml_relation_data_for_salesrep(InputData, newDMLId, Segment, newDMLIdVal, ProposedDate,Segmentoverride,segmentoverridereason);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    static List < DML_Relation__c > process_dml_relation_data_for_salesrep(
        String dml_id_list_json_string, 
        String newDMLId,
        String Segment, 
        String newDMLIdVal,
        String ProposedDate,
		String Segmentoverride,
		String segmentoverridereason) {
        
        List <String> dml_id_list = (List <String> ) JSON.deserialize(dml_id_list_json_string, List < String > .class);
        List <DML_Relation__c> update_dml_list = [
            SELECT 
                Effective_End_Date__c, 
                CUSTOMERID__c, 
                Account__c, 
                DML__C 
            FROM DML_Relation__c 
            WHERE Id IN :dml_id_list
        ];
        List < DML_Relation__c > dml_insert_list = new List < DML_Relation__c > ();
        List < DML_Relation__c > DMLInsertshowList = new List < DML_Relation__c > ();
        System.debug('update_dml_list=>'+update_dml_list);
        Set < Id > DMLIDs = new Set < Id > ();

        for (DML_Relation__c rec: update_dml_list) {
            if (rec.DML__C != null) DMLIDs.add(rec.DML__C);
        }
        List < DML__c > updateDMLListnew = [
            SELECT 
                Id, Proposed_DML_Sales_Rep_ID__c, Proposed_Segment__c, Proposed_DML_Teaming_Rep_ID__c,Proposed_Effective_Start_Date__c,
                DECISION_MAKER_SEGMENT__c, 
                Decision_Maker_Rep__c,Segment_Override_Reason__c,Segment_Override__c
            FROM DML__c 
            WHERE Id IN :DMLIDs
        ];
        System.debug('updateDMLListnew=>'+updateDMLListnew);
        if (DMLIDs.size() > 0) {

            for (DML__C dmlrec: updateDMLListnew) {
                dmlrec.Proposed_DML_Sales_Rep_ID__c = (String.isNotBlank(newDMLId) ? newDMLId: dmlrec.Proposed_DML_Sales_Rep_ID__c);
                dmlrec.Proposed_Segment__c = (String.isNotBlank(Segment) ? Segment: dmlrec.Proposed_Segment__c);
                dmlrec.Proposed_DML_Teaming_Rep_ID__c = (String.isNotBlank(newDMLIdVal) ? newDMLIdVal: dmlrec.Proposed_DML_Teaming_Rep_ID__c);
                dmlrec.Proposed_Effective_Start_Date__c = (String.isNotBlank(ProposedDate) ? Date.valueOf(ProposedDate): dmlrec.Proposed_Effective_Start_Date__c);
				dmlrec.Segment_Override_Reason__c = (String.isNotBlank(segmentoverridereason) ? segmentoverridereason: dmlrec.Segment_Override_Reason__c);
				dmlrec.Segment_Override__c = (String.isNotBlank(Segmentoverride) ? Segmentoverride: dmlrec.Segment_Override__c);
                dmlrec.NewRequest__c = true;
                dmlrec.ProcessNew_Request__c =true; //DML Update Sandesh
            }
        }
        System.debug('updateDMLListnew=>'+updateDMLListnew);
        if (updateDMLListnew.size() > 0){
            update updateDMLListnew;
        }

        DMLInsertshowList =
        [
            SELECT 
                Id,
                Org_Name__c, 
                CUSTOMERID__c, 
                Parent_Id__c, 
                DECISIONMAKERID__c, 
                Effective_Start_Date__c,
                DML_Segment_Formula__c, 
                Teaming_SalesRepFormula__c, 
                SalesRepFormula__c, 
                DMLFormula__c,
                DateFormula__c,
                Effective_End_Date__c, 
                DML_RepID__c, 
                Decision_Maker_Name__c, 
                GrandParent_Id__c, 
                Org_Duns_Number__c,
                Customer_Name__c, 
                RecordType__c, 
                DML_ID__c, 
                Parent_Name__c,
                GrandParent_Name__c 
            FROM DML_Relation__c WHERE
            Id IN :dml_id_list
        ];
        System.debug('DMLInsertshowList=>'+DMLInsertshowList);
        return DMLInsertshowList;
    }


    @AuraEnabled
    public static Map <String, List < Object >> processDMLRelationDate(
        String InputData, 
        String newDMLId,
        String DateVal) {
        DMLRelationTriggerHandler.executeTrigger = false;
        List <String> dml_id_list = (List < String > ) JSON.deserialize(InputData, List < String > .class);
        List <DML_Relation__c> update_dml_relation_list =
            [
                SELECT Id,
                Org_Name__c, 
                CUSTOMERID__c, 
                Parent_Id__c, 
                DECISIONMAKERID__c, 
                Effective_Start_Date__c,
                DML_Segment_Formula__c, 
                Teaming_SalesRepFormula__c, 
                SalesRepFormula__c, 
                DMLFormula__c,
                DateFormula__c,
                Effective_End_Date__c, 
                DML_RepID__c, 
                Decision_Maker_Name__c, 
                GrandParent_Id__c, 
                Org_Duns_Number__c,
                Customer_Name__c, 
                RecordType__c, 
                DML_ID__c, 
                Parent_Name__c,
                GrandParent_Name__c,
                Account__c
                FROM DML_Relation__c WHERE Id IN :dml_id_list
            ];

        List < DML_Relation__c > dml_insert_list = new List < DML_Relation__c > ();
        List < DML_Relation__c > DMLInsertshowList = new List < DML_Relation__c > ();
        Map < String, List < DML_Relation__c > > MapList = new Map < String, List < DML_Relation__c > > ();

        for (DML_Relation__c rec: update_dml_relation_list) {

            rec.New_DML__c = (String.isNotBlank(newDMLId) ? newDMLId: rec.New_DML__c);
            if (String.isNotBlank(DateVal))
                rec.New_start_Date__c = Date.valueOf(DateVal);
            
            rec.NewRequest__c = true;
            rec.ProcessNew_Request__c = true; //DML Updated //Sandesh
            rec.Requested_By__c = UserInfo.getUserId();
        }

        return update_dml_relations(update_dml_relation_list, false);
    }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com, 12 September 2019
     * @description Used to represent a failed dml update.
     */
    class DMLRelationUpdateFailedResult {
        DML_Relation__c dml_relation;
        String[] error;
        DMLRelationUpdateFailedResult(DML_Relation__c dml_relation, Database.Error[] errors){
            this.dml_relation = dml_relation;
            for(Database.Error err: errors)
                this.error.add(err.getMessage());
        }
    }


    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com, 12 September 2019
     * @description Used to update lists of DML Relations and return a map with the successes and failures
     * @param List<DML_Relation__c> my_dml_relations: The list of DML_Relations to update
     * @return Returns a map with the successful and fails dml relation updates. 
     */
    static Map<String, List<Object>> update_dml_relations(List<DML_Relation__c> my_dml_relations, Boolean all_or_none){
        Map < String, List < Object >> result_map = new Map < String,List < Object >> {
            'success'=> new List<DML_Relation__c>(), 
            'error' =>  new List<DMLRelationUpdateFailedResult>()
            };

        if(my_dml_relations.isEmpty())
            return result_map;

        Savepoint sp = Database.setSavepoint();
        Database.DMLOptions options = new Database.DMLOptions();
        options.OptAllOrNone = all_or_none;
        try {
            Database.SaveResult[] srList = Database.update(my_dml_relations, options);
            for (Integer i = 0; i < srList.size(); i++) {
                if (srList[i].isSuccess()) { 
                    result_map.get('success').add(my_dml_relations[i]);
                } else {
                    result_map.get('error').add(new DMLRelationUpdateFailedResult(my_dml_relations[i], srList[i].getErrors()));
                }
            }
            return result_map;
        } catch (Exception e) {
            Database.rollback(sp);
            throw new DMLRelationException(e.getMessage());
        }
    }


    @AuraEnabled
    public static String processDMLData(string newDMLId) {
        DML__C update_dml_list = [
            SELECT 
                Status__C 
            FROM DML__C 
            WHERE Id = :newDMLId];
            
        return ((update_dml_list.Status__c == 'Draft' || update_dml_list.Status__c == 'Rejected') ? 'ERROR': 'SUCCESS');
    }


    @AuraEnabled
    public static List < DML_Relation_History__c > getDMLRelationHistory(string DMLRelId) {
        return [
            SELECT 
                Id, 
                DML_ID__c, 
                CUSTOMERID__c, 
                Effective_Start_Date__c, 
                Effective_End_Date__c,
                DML_Relationship__c 
            FROM DML_Relation_History__c 
            WHERE DML_Relationship__c = :DMLRelId
        ];
    }
    static List<DML_Relation__c> populate_dml_relation_account_info(List<DML_Relation__c> dml_relation_list){
        Set<String> customer_ids = new Set<String>();

        for (DML_Relation__c my_dml_relation: dml_relation_list){
            if(String.isNotBlank(my_dml_relation.CUSTOMERID__c)){
                customer_ids.add(my_dml_relation.CUSTOMERID__c.trim());
            }
        }

        Map<String, Account> customer_id_to_account_id_map = new Map<String, Account>();
        for(Account my_account: [
            SELECT 
                Id, 
                AOPS_Cust_Id__c,
                Org__c
            FROM Account
            WHERE AOPS_Cust_Id__c IN :customer_ids
        ]){
            customer_id_to_account_id_map.put(my_account.AOPS_Cust_Id__c, my_account);
        }

        for (DML_Relation__c my_dml_relation: dml_relation_list){
            if(customer_id_to_account_id_map.containsKey(my_dml_relation.CUSTOMERID__c)){
                my_dml_relation.Account__c = customer_id_to_account_id_map.get(my_dml_relation.CUSTOMERID__c).Id;
                my_dml_relation.Org__c = customer_id_to_account_id_map.get(my_dml_relation.CUSTOMERID__c).Org__c;
            }
        }

        return dml_relation_list;

    }


    static List<DML_Relation__c> populate_dml_relation_dml_id(List<DML_Relation__c> dml_relation_list){
        Set<String> decision_maker_ids = new Set<String>();

        for (DML_Relation__c my_dml_relation: dml_relation_list){
            if(String.isNotBlank(my_dml_relation.DECISIONMAKERID__c)){
                decision_maker_ids.add(my_dml_relation.DECISIONMAKERID__c.trim());
            }
        }

        Set<Id> decision_maker_id_set = new Set<Id>();
        for(DML__c my_dml: [
            SELECT 
                Id
            FROM DML__c
            WHERE Id IN :decision_maker_ids
        ]){
            decision_maker_id_set.add(my_dml.Id);
        }

        for (DML_Relation__c my_dml: dml_relation_list){
            if(decision_maker_id_set.contains(my_dml.DECISIONMAKERID__c)){
                my_dml.DML__c = my_dml.DECISIONMAKERID__c;
            }
        }

        return dml_relation_list;

    }

    // DMLRelationTriggerHandler Trigger Helper Methods

    /*******************************************************************************************************
     * @author Adam Albright, adam.albright@officedepot.com, 10 September 2019
     * @description Associates an account to a dml
     * @param List<DML_Relation__c> dml_relation_list: A list of DML_Relations with Ids.
     */
    public static void AssociateAccountid(List<DML_Relation__c> dml_relation_list )
    {
        List<String> customer_id_list = new List<String>();
        List<String> decision_maker_id_list = new List<String>();
        List<Id> account_id_list = new List<Id>();
        List<Id> dml_id_list = new List<Id>();

        dml_relation_list = populate_dml_relation_account_info(dml_relation_list);
        dml_relation_list = populate_dml_relation_dml_id(dml_relation_list);


        Map<String, Account> customer_id_to_account = new Map<String, Account>();
        Map<Id, Account> id_to_account_map = new Map<Id, Account>();
        Map<Id, Account> id_to_account_map_for_org = new Map<Id, Account>();


        for (Account Acc:
             [
                SELECT 
                    Id, 
                    Org__c,
                    AOPS_Cust_Id__c 
                FROM Account 
                WHERE AOPS_Cust_Id__c IN :customer_id_list OR Id IN :account_id_list
            ])
        {
            if (String.isNotBlank(Acc.AOPS_Cust_Id__c)) {
                customer_id_to_account.put(Acc.AOPS_Cust_Id__c, Acc);
                id_to_account_map.put(Acc.Id, Acc);
            }
            id_to_account_map_for_org.put(Acc.Id, Acc);
        }
    }


    // What are using these?
    // What does this function do?
    public static void EffectiveEnddate(List<DML_Relation__c> dml_relation_list )
    {
        Map<String, DML_Relation__c> dml_id_map = new Map<String, DML_Relation__c>();
        List <String> CustID = new List <String>();
        List <Id> accId= new List <Id>();

        for (DML_Relation__c dml_relation : dml_relation_list) {
            if (dml_relation.CUSTOMERID__c != null)
                CustID.add(dml_relation.CUSTOMERID__c);
            if (dml_relation.Account__c != null)
                accId.add(dml_relation.Account__c);
        }

        Date current_datetime = System.today();

        for (DML_Relation__c my_dml_reation :
             [SELECT Id, Effective_End_Date__c, CUSTOMERID__c, Account__c FROM DML_Relation__c WHERE
                  (CUSTOMERID__c = : CustID OR Account__c =:accId ) AND
                  (Effective_End_Date__c= null OR Effective_End_Date__c >=  :current_datetime) ]) {

            if (  my_dml_reation.CUSTOMERID__c != null) {
                if (!dml_id_map.Containskey(my_dml_reation.CUSTOMERID__c))
                    dml_id_map.put(my_dml_reation.CUSTOMERID__c, my_dml_reation );
            }

            if (my_dml_reation.Account__c != null) {
                if (!dml_id_map.Containskey(my_dml_reation.Account__c ))
                    dml_id_map.put(my_dml_reation.Account__c, my_dml_reation );
            }
        }

        if (!dml_id_map.isempty()) {
            for (DML_Relation__c dml_relation : dml_relation_list) {
                if (dml_id_map.containskey(dml_relation.CUSTOMERID__c)  ||
                    dml_id_map.containskey(dml_relation.Account__c))
                    dml_relation.adderror('Already active exist with this customer');
            }
        }
    }

    // To Remove????
    //Code to remove related DML field on Account IN case of Prospect
    public static List<Account> set_accounts_related_dml_to_null(List<DML_Relation__c> dml_relation_list )
    {
        Set<Id> account_id_set = new Set<Id> ();
        
        for (DML_Relation__c d:dml_relation_list)
        {
            if (d.Account__c != null)
            {
                account_id_set.add(d.Account__c);
            }
        }

        List<Account> account_list_to_update = [
            SELECT 
                Id, 
                Related_DML__c 
            FROM Account 
            WHERE Id IN :account_id_set 
            AND Related_DML__c != null
        ];

        if (account_list_to_update.isEmpty())
            return account_list_to_update;

        for (Account rec :account_list_to_update) {
            rec.Related_DML__c=null;
        }
        return account_list_to_update;
    }


    // Trigger helper function. 
    public static void DMLRHistoryPopulate(Map < Id, DML_Relation__c > NewMap, Map<Id, DML_Relation__c> oldMap )
    {
        List<DML_Relation_History__c> DMLHistoryInsertList = new List<DML_Relation_History__c>();
        List<DML_Relation__c> dml_relation_list = new List<DML_Relation__c>();
        for (String DrecStr: NewMap.keyset())
        {
            if (NewMap.get(DrecStr).ProcessNew_Request__c == true)
            {
                DML_Relation__c Drec = new DML_Relation__c(
                    Id = NewMap.get(DrecStr).Id,
                    DML__c = NewMap.get(DrecStr).New_DML__c,
                    Effective_Start_Date__c = NewMap.get(DrecStr).New_start_Date__c,
                    ProcessNew_Request__c = false,
                    New_DML__c = null,
                    New_start_Date__c = null
                );

                DML_Relation_History__c DHistoryRec = new DML_Relation_History__c(
                    Account__c = oldMap.get(Drec.Id).Account__c,
                    CUSTOMERID__c = oldMap.get(Drec.Id).CUSTOMERID__c,
                    DML__c = oldMap.get(Drec.Id).DML__c,
                    DML_Relation_Modified_By__c = oldMap.get(Drec.Id).Requested_By__c,
                    DML_Relationship__c = oldMap.get(Drec.Id).Id,
                    Effective_End_Date__c = oldMap.get(Drec.Id).Effective_End_Date__c,
                    Effective_Start_Date__c = oldMap.get(Drec.Id).Effective_Start_Date__c
                );

                DMLHistoryInsertList.add(DHistoryRec);
                Drec.Effective_End_Date__c = null;
                dml_relation_list.add(Drec);
            }
        }
        Savepoint sp = Database.setSavepoint();
        try {
            if (!dml_relation_list.isEmpty())
                update dml_relation_list;
            if (!DMLHistoryInsertList.isEmpty())
                insert DMLHistoryInsertList;
        } catch (Exception e) {
            Database.rollback(sp);
            throw new DMLRelationException(e.getMessage());
        }

    }
}