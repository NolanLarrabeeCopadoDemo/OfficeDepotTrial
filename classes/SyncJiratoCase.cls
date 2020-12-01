global class SyncJiratoCase {

    @InvocableMethod(label = 'Sync Jira to Case' description = 'Sync to Case.')
    public static void syncCase(List<Id> jiraCaseList) {
        List<Case> newcases = new List<Case>();
        List<Case> updateCases = new List<Case>();
        List<Jira_Case__c> jclistupsert = new List<Jira_Case__c>();
        List<Jira_Case__c> jclist = new List<Jira_Case__c>();
        List<String> jirauserids = new List<String>();
        List<String> casenums = new List<String>();
       Map<String, Jira_Case__c> jiramap = new Map<String, Jira_Case__c>();
       Map<id, Jira_Case__c> uatJiramap = new Map<id, Jira_Case__c>();
        Map<String, Id> Jira2SFUser = new Map<String, Id>();
        Map<String, Id> CaseNum2id = new Map<String, Id>();


  Schema.DescribeSobjectResult cs = Schema.SobjectType.Case;
  Map<String, schema.RecordtypeInfo> CaseRecType = cs.getRecordTypeInfosByName();
  Id itCaseRecTypeId = CaseRecType.get('IT Cases').getRecordTypeId();

    System.debug('jiraCaseList size '+jiraCaseList.size());
    
    Map<String, id> queMap = new Map<String, id>(); 
    for(Group gp : [select Id, DeveloperName from Group where Type = 'Queue' ])
        {
                queMap.put(gp.DeveloperName, gp.id);
        }
        
        
        for(Jira_Case__c s :[SELECT Id, summary__c, Case__c, EpicLink__c,Sprint_Name__c,business_needed_by__c, Jira_source_status__c,Jira2CasePriority__c,IssueType_to_Classification__c, Components__c, Description__c, Case__r.CaseNumber, Jira_ID__c, assigne__c, priority__c, Issue_Type__c, Found_In__c, Labels__c, Bug_Environment__c, Case_Stage__c,reporterkey__c,Case_Number__c from Jira_Case__c WHERE id = :jiraCaseList]) {

            jiramap.put(s.Jira_ID__c,s);
            jirauserids.add(s.reporterkey__c);
            casenums.add(s.Case_Number__c);
            jclist.add(s);
            System.debug('casenums  '+s.Case_Number__c +'  reporterkey__c   '+s.reporterkey__c );
        }

   for (User bu: [select id,jira_User__c from user where jira_User__c =:jirauserids])
   {
       Jira2SFUser.put(bu.jira_User__c,bu.id);
       System.debug('bu.jira_User__c  '+bu.jira_User__c+'  bu.id   '+bu.id );
   }
        for (Case  ca: [select id,CaseNumber from Case where CaseNumber =:casenums])
   {
       CaseNum2id.put(ca.CaseNumber,ca.id);

        System.debug('ca.CaseNumber  '+ca.CaseNumber+'  ca.id)   '+ca.id );
   }
        
    for(Jira_Case__c s :jclist) {
     System.debug( ' inside Jira_Case__c  ');
            Case c = new Case();
            String source_status = s.Jira_source_status__c ;
            
            if(s.Case_Stage__c == 'Development') {
                        
                        c.OwnerId = queMap.get('ITQueue');
                    } 
                    else  {
                        c.OwnerId = queMap.get('L3_Support_Queue_SalesOps');     
                    }
            switch on source_status {
                when 'Closed' {
                    if(s.Case_Stage__c == 'Development') {
                        uatJiramap.put(s.Case__c, s);
                        c.IT_Status__c = 'In UAT';
                        c.status = 'In progress';
                    } 
                    else if(s.Case_Stage__c == 'UAT') {
                        c.IT_Status__c = 'Completed';
                        c.status = 'Closed';
                    }
                }
                when 'Requested' {
                    if(s.Case_Stage__c == 'Development') {
                        c.IT_Status__c = 'Not Started';
                        c.status = 'New';
                    }
                    else if(s.Case_Stage__c == 'UAT') {
                        c.IT_Status__c = 'In UAT';
                        c.status = 'In progress';
                    }
                    System.debug('when block 5 and 6');
                }
                when 'Open' {
                    System.debug('when block 7');
                    if(s.Case_Stage__c == 'Development') {
                        c.IT_Status__c = 'Assign';
                        c.status = 'New';
                    }
                    else if(s.Case_Stage__c == 'UAT') {
                        c.IT_Status__c = 'In UAT';
                        c.status = 'In progress';
                    }
                    
                }
                when 'In Progress' {
                    if(s.Case_Stage__c == 'Development') {
                        c.IT_Status__c = 'In Development';
                        c.status = 'In progress';
                    }
                    else if(s.Case_Stage__c == 'UAT') {
                        c.IT_Status__c = 'In UAT';
                        c.status = 'In progress';
                    }

                }
                when 'Pending test' {
                    System.debug('when block 7');
                    if(s.Case_Stage__c == 'Development') {
                        c.IT_Status__c = 'In QA';
                        c.status = 'In progress';
                    } 
                    else if(s.Case_Stage__c == 'UAT') {
                        c.IT_Status__c = 'In UAT';
                        c.status = 'In progress';

                    }
                }
                when 'Awaiting Migration to Production' {
                    System.debug('when block 7');
                    if(s.Case_Stage__c == 'UAT') {
                        c.IT_Status__c = 'Awaiting Prod Migration';
                        c.status = 'In progress';
                    }
                    
                }


                when else {
                    System.debug('default');
                }
            }              
        System.debug('s.Case_Number__c '+s.Case_Number__c );
            if(s.Case_Number__c !=null && s.Case_Number__c !='')
            {
                if(CaseNum2id.get(s.Case_Number__c) != null)
                {
                    s.Case__c=CaseNum2id.get(s.Case_Number__c);
                    System.debug('s.c2c '+CaseNum2id.get(s.Case_Number__c));

                }

            }
            if(s.reporterkey__c !=null)
            {
                if( Jira2SFUser.get(s.reporterkey__c)!=null){
                c.IT_BU_Reviewer__c=  Jira2SFUser.get(s.reporterkey__c);
                }
            }
            c.RecordTypeId = itCaseRecTypeId;
            c.Origin = 'Internal';
            c.Subject = s.summary__c;
            c.Priority = s.Jira2CasePriority__c;
            c.Description = s.Description__c;
            c.IT_Classification__c = s.IssueType_to_Classification__c;
            c.IT_Environment__c = 'Production';
            c.SPRINT_NAME__c = s.Jira_ID__c;
            c.Agile_Stage__c =s.Sprint_Name__c;
            if(s.Components__c!=null && s.Components__c!='' )
                c.Jira_Component__c=s.Components__c;
            c.IT_Production_Date__c=s.business_needed_by__c;
            if(s.Case__c != null) {
                c.id = s.Case__c;
                
                updateCases.add(c);
            } else {
                
                newcases.add(c);

            }

        }


        if(newcases.size() > 0) {
            insert newcases;

            for(Case c :newcases) {
                Jira_Case__c jc = jiramap.get(c.SPRINT_NAME__c);
                
                jc.Case__c = c.id;
                jc.Jira_Sync_Status__c='ADDED_NEWCASE';
                jclistupsert.add(jc);
            }
        }

        if(updateCases.size() > 0) {
            update updateCases;
            for(Case c :updateCases) {
            Jira_Case__c jc = jiramap.get(c.SPRINT_NAME__c);
                jc.Case__c = c.id;
                jc.Jira_Sync_Status__c='UPDATED_CASE';
                jclistupsert.add(jc);
            }
        }



        if(uatJiramap.size()>0)
        {
            List<Jira_Case__c> newUatJiras =  new List<Jira_Case__c>();
            List<Jira_Case__c> updateUatJiras =  new List<Jira_Case__c>(); 
            List<Id> uatCaseExistList = new  List<Id>();
              Map<id, Jira_Case__c> uatExistsJiramap = new Map<id, Jira_Case__c>();
            for(Jira_Case__c jira_uat : [SELECT Id, summary__c, Case__c, EpicLink__c, Jira_source_status__c, Components__c, Description__c, Case__r.CaseNumber, Jira_ID__c, assigne__c, priority__c, Issue_Type__c, Found_In__c, Labels__c, Bug_Environment__c, Case_Stage__c from Jira_Case__c WHERE Case_Stage__c = 'UAT' and Case__c = :uatJiramap.keyset()])
            {
                uatCaseExistList.add(jira_uat.case__c);
                uatExistsJiramap.put(jira_uat.case__c,jira_uat);
            }
             for (Id caseid : uatJiramap.keyset())
             {
                 
                     Jira_Case__c old_jc = uatJiramap.get(caseid);
                     Jira_Case__c new_jc =  new Jira_Case__c();
                

                    if(uatCaseExistList.contains(caseid))
                 {
                     new_jc=uatExistsJiramap.get(caseid);
                    new_jc.Linked_Jira_key__c    =  old_jc.Jira_ID__c;
                    new_jc.summary__c=old_jc.summary__c;
                    new_jc.Case__c=old_jc.Case__c;
                     new_jc.EpicLink__c= old_jc.EpicLink__c; 
                     new_jc.Components__c = old_jc.Components__c;
                    new_jc.Description__c=  old_jc.Description__c;
                     new_jc.priority__c = old_jc.priority__c;
                     new_jc.Issue_Type__c = old_jc.Issue_Type__c;
                     new_jc.Found_In__c = old_jc.Found_In__c;
                     new_jc.Labels__c = old_jc.Labels__c;
                     new_jc.Bug_Environment__c = old_jc.Bug_Environment__c;
                     new_jc.Jira_source_status__c = 'Requested';
                     new_jc.Case_Stage__c ='UAT';
                      new_jc.Jira_Sync_Status__c='CREATE_NEW_UAT';
                    updateUatJiras.add(new_jc);
                 }
                 else
                 {
                    new_jc.summary__c=old_jc.summary__c ;
                     new_jc.Linked_Jira_key__c    =  old_jc.Jira_ID__c;
                    new_jc.Case__c=old_jc.Case__c;
                     new_jc.EpicLink__c= old_jc.EpicLink__c; 
                     new_jc.Components__c = old_jc.Components__c;
                    new_jc.Description__c=  old_jc.Description__c;
                     new_jc.priority__c = old_jc.priority__c;
                     new_jc.Issue_Type__c = old_jc.Issue_Type__c;
                     new_jc.Found_In__c = old_jc.Found_In__c;
                     new_jc.Labels__c = old_jc.Labels__c;
                     new_jc.Bug_Environment__c = old_jc.Bug_Environment__c;
                     new_jc.Jira_source_status__c = 'Requested';
                     new_jc.Case_Stage__c ='UAT';
                     new_jc.linked_Jira_Case__c =old_jc.id;
                     new_jc.Jira_Sync_Status__c='CREATE_NEW_UAT';                  

                    newUatJiras.add(new_jc);
                 }

             }
             if(newUatJiras.size()>0) 
             {
                 insert newUatJiras;
             }  
            if(updateUatJiras.size()>0) 
             {
                 update updateUatJiras;
             }  
        }
        
        if(jclistupsert.size() > 0) {
            update jclistupsert ;
        }

    }
}