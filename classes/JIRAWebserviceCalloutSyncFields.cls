global class JIRAWebserviceCalloutSyncFields {

    @InvocableMethod(label = 'Create Jira' description = 'Create Jira from Case.') public static void createJira(List<Id> jiraCaseList) {

        syncfields(jiraCaseList);

    }


    @future(callout = true) WebService static void syncfields(List<Id> jiraCaseList) {
        //Modify these variables:

        String      jiraURL = 'callout:JIRA';





        List<Jira_Case__c> updJiraList = new List<Jira_Case__c>();

        for(Jira_Case__c s :[SELECT Id, summary__c, Case__c, JiraEpickLink__c, Jira_UAT_Backlog_id__c,Linked_Jira_key__c, Case_Stage__c, reporterkey__c, Components__c, Description__c, Case__r.CaseNumber, Case__r.IT_BU_Reviewer__r.jira_User__c, Jira_ID__c, assigne__c, priority__c, Issue_Type__c, Found_In__c, Labels__c, Bug_Environment__c, Issue_type_code__c, componentid__c,jiraClarityProject__c from Jira_Case__c WHERE id = :jiraCaseList]) {
            String req_body = '{  "fields": { ';
            String c_summary = (String) s.summary__c;
            String c_description = (String) s.Description__c;
            String c_caseNumber = (String) s.Case__r.CaseNumber;
            //c_summary= c_summary.replaceAll('\n', '\\\\n');
        //  c_summary= c_summary.replaceAll('\r', '');
        //  c_description= c_description.replaceAll('\n', '\\\\n');
        //  c_description= c_description.replaceAll('\r', '');
        //c_summary=c_summary.escapeEcmaScript()
            c_summary=c_summary.escapeJava();
            c_description=c_description.escapeJava();

            String lblcnv = '';
            if(s.Labels__c != null) {
                for(String str :s.Labels__c.split(';')) {
                    String lstr = '"' + str + '"';
                    lblcnv = lblcnv + lstr + ',';
                }
            } else {
                lblcnv= '"' + 'CSM_Dashboard' + '"';
            }
            if(s.Case__r.IT_BU_Reviewer__r.jira_User__c != null && s.Case__r.IT_BU_Reviewer__r.jira_User__c != '')
                req_body+= ' "reporter": { "accountId": "' + s.Case__r.IT_BU_Reviewer__r.jira_User__c + '"  }, ';
            if(s.Jira_ID__c == null) {
                req_body+= ' "summary":"';
                if(s.Case_Stage__c != 'UAT') {
                    req_body+= c_caseNumber + ' - ';
                }
                req_body+= c_summary + '", ';

                req_body+= ' "description": { "version": 1, "type": "doc",  "content": [  {   "type": "paragraph",       "content": [   {"type": "text",  "text": "' + c_description + '"}]   }]}, ';

                req_body+= ' "labels": ' + '[' + lblcnv.removeEnd(',') + ']' + ',';

                req_body+= ' "components": [ { "id": "' + s.componentid__c + '"  }],';
                req_body+= ' "project": { "id": "18101" }, ';
                req_body+= ' "customfield_16618": "' + c_caseNumber + '" ,';
                req_body+= ' "customfield_10700": "' + s.JiraEpickLink__c + '", ';
                req_body+= ' "customfield_16100":{"value":"'+s.jiraClarityProject__c+'"}, ';
                if(s.Case_Stage__c == 'UAT' || s.Issue_type_code__C == '1' ) {
                    req_body+= ' "customfield_10007": ' + s.Jira_UAT_Backlog_id__c + ' , ';
                }
                
            }
                if(s.Issue_type_code__C == '1')
            {
                req_body+= ' "customfield_10900": { "value": "' + s.Found_In__c + '" }, ';
                req_body+= ' "customfield_10901": { "value": "' + s.Bug_Environment__c + '" }, ';
            }
            req_body+= ' "issuetype": {  "id": "' + s.Issue_type_code__c + '"  } ';
        

            req_body+= '}';




            if(s.Linked_Jira_key__c != null && s.Linked_Jira_key__c != '') {
                req_body+= ', "update":{ "issuelinks":[ { "add":{ "type":{ "name":"Relates", "inward":"relates to", "outward":"relates to" }, "outwardIssue":{ "key":"' + s.Linked_Jira_key__c + '" } } } ] }';
            }

            req_body+= '}';

            system.debug('req_body ' + req_body);
            // String c_priority = (String) s.get('priority__c');
            
            system.debug('req_body dd ' + req_body);

            //Construct HTTP request and response
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();

            //Construct Authorization and Content header
            req.setHeader('Content-Type', 'application/json');

            String method = 'POST';
            //Construct Endpoint
            String endpoint = jiraURL + '/rest/api/3/issue/';
            if(s.Jira_ID__c != null) {
                endpoint = endpoint + s.Jira_ID__c;

                method= 'PUT';
            }
            //Set Method and Endpoint and Body
            req.setMethod(method);
            req.setEndpoint(endpoint);
            req.setBody(req_body);
            try {
                res = http.send(req);
                System.debug('resp : ' + res.getBody());
                String br = res.getBody();
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(br);
                System.debug('vv: ' + result.get('key'));

                s.Jira_ID__c = result.get('key').toString(); // result.key;
                s.Jira_Sync_Status__c = 'SENT_TO_JIRA';
                updJiraList.add(s);
            } catch(System.CalloutException e) {
                System.debug('ERROR:' + e);

            }catch(Exception e) {
                System.debug('ERROR:' + e);

            }
        }
        try{
            update updJiraList;
        } 
        catch(Exception e) {
            System.debug('ERROR:' + e);
        }


    }
}