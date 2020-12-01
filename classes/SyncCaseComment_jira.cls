global class SyncCaseComment_jira {

    @InvocableMethod(label = 'Sync Case comment to Jira comment' description = 'Sync Case comment to Jira comment')public static void synctoJiraComment(List<Id> commentList) {
        syncCommentfields(commentList);
    }

    @future(callout = true)WebService static void syncCommentfields(List<Id> commentList) {
        //Modify these variables:
        
    String      jiraURL= 'callout:JIRA';
        Map<Id, Id> CCtoCase_map = new Map<Id, Id>();
        Map<Id, List<Id>> CasetoCC_map = new Map<Id, list<Id>>();
        Map<Id, String> CasetoIssueKey_map = new Map<Id, String>();
        List<id> caseList = new List<id>();

        for (CaseComment cc :[SELECT Id, ParentId from CaseComment where id = :commentList]) {
            //  List<id> ccidlist= CasetoCC_map.get(cc.ParentId);
            //   ccidlist.add(cc.id);
            //   CasetoCC_map.put(cc.ParentId,ccidlist );
            caseList.add(cc.ParentId);
        }


        List<Jira_Case__c> updJiraList = new List<Jira_Case__c>();

        for(Jira_Case__c s :[SELECT Id, Jira_ID__c, Case__c from Jira_Case__c WHERE Jira_ID__c != null and Case__c = :caseList]) {

            CasetoIssueKey_map.put(s.Case__c, s.Jira_ID__c);
        }


        for (CaseComment cc :[SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById, LastModifiedBy.name from CaseComment where id = :commentList]) {
            String endpoint = jiraURL + '/rest/api/3/issue/';
            String issuekey = CasetoIssueKey_map.get(cc.ParentId);
            String method = 'POST';
            String cc_comm = cc.CommentBody;
            if(cc.CommentBody.indexOf('@jiraIssuekey#:') !=-1) {
                issuekey= cc.CommentBody.Substring(cc.CommentBody.indexOf('@jiraIssuekey#:') +15, cc.CommentBody.indexof('#jiraIssuekey@'));

                cc_comm = cc_comm.replace('@jiraIssuekey#:' + issuekey + '#jiraIssuekey@', '');


            }

            endpoint+= issuekey + '/comment/';
            if(cc.CommentBody.indexOf('@jiraCommentid#:') !=-1) {
                String comm_id = cc.CommentBody.Substring(cc.CommentBody.indexOf('@jiraCommentid#:') +16, cc.CommentBody.indexof('#jiraCommentid@'));

                cc_comm = cc_comm.replace('@jiraCommentid#:' + comm_id + '#jiraCommentid@', '');

                endpoint+= comm_id + '/';
                method= 'PUT';
            } 
            if(cc.CommentBody.indexOf('@updatedBy#:') !=-1) {
                String updtby = cc.CommentBody.Substring(cc.CommentBody.indexOf('@updatedBy#:') +12, cc.CommentBody.indexof('#updatedBy@'));

                cc_comm = cc_comm.replace('@updatedBy#:' + updtby + '#updatedBy@', '');


            }


            cc_comm+= '\n @sfCommentid#:' + cc.id + '#sfCommentid@';
            cc_comm+= '\n @sfupdatedBy#:' + cc.LastModifiedBy.name + '#sfupdatedBy@';


            cc_comm= cc_comm.replaceAll('\n', '\\\\n');
            cc_comm= cc_comm.replaceAll('\r', '');
            //Construct HTTP request and response
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();

            
            req.setHeader('Content-Type', 'application/json');


            //Construct Endpoint
            System.debug('endpoint : ' + endpoint);
            //Set Method and Endpoint and Body
            req.setMethod(method);
            req.setEndpoint(endpoint);

            req.setBody('{ "body": { "type": "doc", "version": 1, "content": [{  "type": "paragraph", "content": [ { "text": "' + cc_comm + '", "type": "text" } ] }   ]  }}');
            try {
                //Send endpoint to JIRA
                if(!Test.isRunningTest()) {
                    res = http.send(req);
                }
                System.debug('resp : ' + res.getBody());
                String br = res.getBody();



                // Jira_json.BasicResponse result = jira_json.parseBR(br);

                // s.Jira_ID__c= result.key;
                // updJiraList.add(s);
            } catch(System.CalloutException e) {
                System.debug('ERROR:' + e);

            }
        }
        try{
            //   update updJiraList;
        } 
        catch(Exception e) {
            System.debug('ERROR:' + e);
        }


    }
}