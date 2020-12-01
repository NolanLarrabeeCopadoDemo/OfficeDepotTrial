public class process_jira_webhook {

public static void processData(String webhookBody )


  {
      

      

      Map<String, Object> m =    (Map<String, Object>)      JSON.deserializeUntyped(webhookBody);
        System.debug('vv: '+m.get('timestamp'));
        System.debug('issue: '+m.get('issue'));
         Map<String, String> dataMap = new Map<String, String> (); 
        dataMap.put('webhookevent',m.get('webhookEvent')+'');      
     Map<String, Object> issue = (Map<String, Object>)m.get('issue');
     
     // now loop through our customer attributes.
     for (String issueattribute : issue.keyset()) {
         // handle response
         //System.debug('========> ' + issueAttribute + ' = ' +   issue.get(issueAttribute));
          if(issueattribute == 'key')
          {
          String issueKey=issue.get(issueattribute).toString();
          dataMap.put('issueKey',issue.get(issueattribute).toString());
          System.debug('========> ' + issueAttribute + ' = ' +   dataMap.get('issueKey'));
          
          }
         if(issueAttribute == 'fields')
         {
              Map<String, Object> fieldattributes = (Map<String, Object>) issue.get('fields');
               for (String fieldAttname : fieldattributes.keyset()) {  
                               
                   System.debug('===fieldattributes=====> ' + fieldAttname );
                   if(fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null')
                       System.debug('fieldattributes: ' + fieldAttname+' --> ' +  fieldattributes.get(fieldAttname) );
                   
                    if(fieldAttname == 'customfield_10700' && (fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null'))
                   {   
                       dataMap.put('epicKey', fieldattributes.get(fieldAttname).toString());
                       System.debug('========> epicKey' + ' = ' +   dataMap.get('epicKey'));
                   }
                   
                    if(fieldAttname == 'customfield_16618' && (fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null') )
                   {   
                       dataMap.put('vendorcase', fieldattributes.get(fieldAttname).toString());
                       System.debug('========> vendorcase' + ' = ' +   dataMap.get('vendorcase'));
                   }
                    if(fieldAttname == 'customfield_16622' && (fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null') )
                   {   
                       dataMap.put('vendorlastupdatedt', fieldattributes.get(fieldAttname).toString());
                       System.debug('========> vendorlastupdatedt customfield_16622' + ' = ' +   dataMap.get('vendorlastupdatedt'));
                   }
                   
                   
                    
                   if(fieldAttname == 'customfield_16608' && (fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null'))
                   {   
                       dataMap.put('businessneededby', fieldattributes.get(fieldAttname).toString());
                       System.debug('========> businessneededby' + ' = ' +   dataMap.get('businessneededby'));
                   }
                     if((fieldAttname == 'updated' || fieldAttname == 'created' || fieldAttname == 'description' || (fieldAttname == 'summary')) && (fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null'))
                   {   
                       dataMap.put(fieldAttname, fieldattributes.get(fieldAttname).toString());
                       System.debug('========> ' + fieldAttname + ' = ' +   dataMap.get(fieldAttname));
                   }
                   
                    if(fieldAttname == 'customfield_10004' && (fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null') )
                   {   
                       dataMap.put('stortypoints', fieldattributes.get(fieldAttname)+'');
                       System.debug('========> stortypoints ' + fieldAttname + ' = ' +   dataMap.get('stortypoints'));
                   }
                    if(fieldAttname == 'customfield_10901' && (fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null') )
                   {   
                       dataMap.put('bugenvironment',  CnvrtToValue(  (Object)fieldattributes.get(fieldAttname), 'value'));
                       System.debug('========> bugenvironment ' + fieldAttname + ' = ' +   dataMap.get('bugenvironment'));
                   }
                    if(fieldAttname == 'customfield_16100' && (fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null') )
                   {   
                       dataMap.put('clarityProject',  CnvrtToValue(  (Object)fieldattributes.get(fieldAttname), 'value'));
                       System.debug('========> clarityProject ' + fieldAttname + ' = ' +   dataMap.get('clarityProject'));
                   }
                    if(fieldAttname == 'customfield_10900' && (fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null') )
                   {   
                       dataMap.put('foundin',  CnvrtToValue(  (Object)fieldattributes.get(fieldAttname), 'value'));
                       System.debug('========> foundin ' + fieldAttname + ' = ' +   dataMap.get('foundin'));
                   }
        
                   
                   if(fieldAttname == 'components'  && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null')
                   {                          
                         dataMap.put(fieldAttname,CnvrtToList((list<Object>)fieldattributes.get('components'), 'name'));
                         System.debug('========> ' + fieldAttname + ' = ' +   dataMap.get(fieldAttname));
                       
                   }
                   if(fieldAttname == 'customfield_14700' && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null')
                    
                   {        dataMap.put('testrequirments',  CnvrtToList(  (list<Object>)fieldattributes.get('customfield_14700'), 'name'));
                         System.debug('========> testrequirments' + fieldAttname + ' = ' +   dataMap.get('testrequirments'));
                   }
                    if(fieldAttname == 'customfield_10007' && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null')
                    
                    
                   {
                       
                         dataMap.put('sprint', CnvrtToListspcllast(  (list<Object>)fieldattributes.get('customfield_10007'), 'name'));

                         System.debug('========> sprint ' + fieldAttname + ' = ' +   dataMap.get('sprint'));
                   }
                   
                   
                   
                   if( fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null' && (fieldAttname == 'status' || fieldAttname == 'issuetype' || fieldAttname == 'priority' || fieldAttname == 'project'))
                   {        dataMap.put(fieldAttname,  CnvrtToValue(  (Object)fieldattributes.get(fieldAttname), 'name'));
                           System.debug('========> ' + fieldAttname + ' = ' +   dataMap.get(fieldAttname));
                         
                   }
                    if(fieldAttname == 'project' && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null')
                   {        dataMap.put('projectkey',  CnvrtToValue(  (Object)fieldattributes.get('project'), 'key'));
                   System.debug('========> projectkey:  ' + fieldAttname + ' = ' +   dataMap.get('projectkey'));
                         
                   }
                   
                   if(fieldAttname == 'customfield_16607' && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null')
                   {                          
                        
                        
                        dataMap.put('detectedrelease',CnvrtToListStr(  (list<Object>)fieldattributes.get('customfield_16607')));
                        System.debug('========>detectedrelease ' + fieldAttname + ' = ' +   dataMap.get('detectedrelease'));
                   }
                     if(fieldAttname == 'customfield_16615' && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null')
                   {                          
                        
                        
                        dataMap.put('vendorname',CnvrtToListStr(  (list<Object>)fieldattributes.get('customfield_16615')));
                        System.debug('========>vendorname ' + fieldAttname + ' = ' +   dataMap.get('vendorname'));
                   }
                   
                   
                   if(fieldAttname == 'customfield_16620' && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null')
                   {                          
                        
                        
                        dataMap.put('vendorstatus',CnvrtToListStr(  (list<Object>)fieldattributes.get('customfield_16620')));
                        System.debug('========>vendorstatus ' + fieldAttname + ' = ' +   dataMap.get('vendorstatus'));
                   }
                   if(fieldAttname == 'customfield_16503' && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null')
                   {                          
                        
                        
                        dataMap.put('scheduledrelease',CnvrtToListStr(  (list<Object>)fieldattributes.get('customfield_16503')));
                        System.debug('========>scheduledrelease ' + fieldAttname + ' = ' +   dataMap.get('scheduledrelease'));
                   }
                   
                   
                   if(fieldAttname == 'labels' && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null')
                   {                          
                       
                    
                    dataMap.put('labels',CnvrtToListStr(  (list<Object>)fieldattributes.get('labels')));
                    System.debug('========> ' + fieldAttname + ' = ' +   dataMap.get(fieldAttname));
                   
                        
                   }
                   
                  if(fieldAttname == 'customfield_16502' && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null') 
                   {
                   dataMap.put('application',  CnvrtToValue(  (Object)fieldattributes.get(fieldAttname), 'value'));
                    System.debug('========> application: ' + fieldAttname + ' :  = ' +   dataMap.get('application'));
                    }
                   if(fieldAttname == 'customfield_17726' && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null') 
                   {
                   dataMap.put('issuesubtype',  CnvrtToValue(  (Object)fieldattributes.get(fieldAttname), 'value'));
                    System.debug('========> issuesubtype: ' + fieldAttname + ' :  = ' +   dataMap.get('issuesubtype'));
                    }  
                    
                    if((fieldAttname == 'creator'  || fieldAttname == 'assignee' || fieldAttname == 'user' ||fieldAttname == 'reporter') && fieldattributes.get(fieldAttname) != null && fieldattributes.get(fieldAttname)+'' != 'null')
                   {
                   dataMap.put(fieldAttname+'id',  CnvrtToValue(  (Object)fieldattributes.get(fieldAttname), 'accountId'));
                    System.debug('========> : ' + fieldAttname + 'id :  = ' +   dataMap.get(fieldAttname+'id'));
                    dataMap.put(fieldAttname+'key',  CnvrtToValue(  (Object)fieldattributes.get(fieldAttname), 'key'));
                    System.debug('========> : ' + fieldAttname + 'key :  = ' +   dataMap.get(fieldAttname+'key'));
                    
                    }
                         
               }
         }
         
     }
     
     if(m.get('comment') != null)
     {
     
     Map<String, Object> comment = (Map<String, Object>)m.get('comment'); 
        for (String attribute : comment.keyset()) {
        
         if((attribute == 'id' || attribute == 'body'|| attribute == 'created' || attribute == 'updated'  )&& comment.get(attribute) != null && comment.get(attribute)+'' != 'null')
                   {   
                       dataMap.put('comment_'+attribute, comment.get(attribute).toString());
                       System.debug('========> comment_'+attribute+ ' = ' +   dataMap.get('comment_'+attribute));
                   }
                   
                   
         if(attribute == 'updateAuthor' && comment.get(attribute) != null && comment.get(attribute)+'' != 'null' )      {    
                    dataMap.put('comment_'+attribute,  CnvrtToValue(  (Object)comment.get(attribute), 'displayName'));
                    System.debug('========> :comment_'+attribute + ':  = ' +   dataMap.get('comment_'+attribute));
                   }
        }
     
     }
        
       if (dataMap.get('webhookevent') == 'comment_created' || dataMap.get('webhookevent') == 'comment_updated' || dataMap.get('webhookevent') == 'comment_deleted')
       {
          System.debug('action comment');
           syncJiraCaseComment(dataMap);
       }
       else
       {
        syncJiraCase(dataMap);
        }
  
    }
    
     public static String CnvrtToValue( Object obj, String attr)
    {
        
                        String l_consol='';
 
                            Map<String, Object> compAttbrs = (Map<String, Object>) obj;
                           for (String compAttbr : compAttbrs.keyset()) {
                                if(compAttbr==attr)
                                {
                                   l_consol=l_consol+compAttbrs.get(attr);
                                }
                            }
                        
                         
                        
                       
                      System.debug('===l_consol=====> ' + l_consol );  
                   return l_consol;
    
    }
    
    public static String CnvrtToList( list<Object> clist, String attr)
    {
        
                        String l_consol='';
 
                        for (Object component:clist)
                        {
                          if(l_consol !='')
                          {
                           l_consol=l_consol+';';
                          }
                           Map<String, Object> compAttbrs = (Map<String, Object>) component;
                           for (String compAttbr : compAttbrs.keyset()) {
                                if(compAttbr==attr)
                                {
                                   l_consol=l_consol+compAttbrs.get(attr).toString();
                                }
                            }
                        
                         
                        }
                       
                      System.debug('===l_consol=====> ' + l_consol );  
                   return l_consol;
    
    }
    
     public static String CnvrtToListStr( list<Object> clist)
    {
        
                        String l_consol='';
 
                        for (Object component:clist)
                        {
                          if(l_consol !='')
                          {
                           l_consol=l_consol+';';
                          }
                                   l_consol=l_consol+component.toString();
                            
                        
                         
                        }
                       
                      System.debug('===l_consol=====> ' + l_consol );  
                   return l_consol;
    
    }
    
     public static String CnvrtToListspcl( list<Object> clist, String attr)
    {
        
                        String l_consol='';
 
                        for (Object component:clist)
                        {
                          if(l_consol !='')
                          {
                           l_consol=l_consol+';';
                          }
                          String x= component.toString();
                       
                        
                        
                                   l_consol=l_consol+x.Substring(x.indexof('name=')+5,x.indexof(',goal='));
                        
                         
                        }
                       
                      System.debug('===l_consol=====> ' + l_consol );  
                   return l_consol;
    
    }
    

    public static String CnvrtToListspcllast( list<Object> clist, String attr)
    {
        
                        String l_consol='';
 
                        for (Object component:clist)
                        {
                         
                           List<String> lstSplitStr = component.toString().split(',');
                            for (String splitStr :lstSplitStr)
                            {
                               if(splitStr.indexof('name=') >-1)
                                   {
                                        l_consol =splitStr.remove('name=') ;
                                    }
                              }
                        
                        
                         
                        }
                       
                      System.debug('===l_consol=====> ' + l_consol );  
                   return l_consol;
    
    }
    public static void syncJiraCase(  Map<String, String> caseMap)
    {
    
      System.debug('Inside Sync jiraCase '  );   
      String issuekey= caseMap.get('issueKey');
      List<Jira_Case__c> jclist = new List<Jira_Case__c>();
      Jira_Case__c  jc = new Jira_Case__c();
      
      
      
     // :[ SELECT Id, Case__c,
       
       jc.Jira_ID__c =issuekey;
       jc.Bug_Environment__c= 'Production'; 
       System.debug('Inside Sync jc.Bug_Environment__c ' +jc.Bug_Environment__c ); 
       if(caseMap.get('summary') !='' && caseMap.get('summary') != null)
           jc.summary__c = caseMap.get('summary').unescapeHtml4(); 
       if(caseMap.get('assigneekey') !='')
           jc.assigne__c = caseMap.get('assigneekey'); 
       if(caseMap.get('priority') !='')
           jc.priority__c= caseMap.get('priority'); 
       if(caseMap.get('epicKey') !='')
           jc.EpicLink__c= caseMap.get('epicKey'); 
       if(caseMap.get('components') !='')
           jc.Components__c = caseMap.get('components'); 
       if(caseMap.get('description') !='')
           jc.Description__c = caseMap.get('description').unescapeHtml4();
       if(caseMap.get('issuetype') !='')
           jc.Issue_Type__c= caseMap.get('issuetype'); 
       if(caseMap.get('foundin') !='')
           jc.Found_In__c = caseMap.get('foundin'); 
           
           
       if(caseMap.get('labels') !='')
           jc.Labels__c= caseMap.get('labels'); 
       if(caseMap.get('bugenvironment') !='' && caseMap.get('bugenvironment') != null){
            jc.Bug_Environment__c= caseMap.get('bugenvironment'); 
            System.debug('Inside Syncbugenvironment ' + caseMap.get('bugenvironment') ); 
       }
       if(caseMap.get('clarityProject') !='' && caseMap.get('clarityProject') != null){
            jc.clarityProject__c= caseMap.get('clarityProject'); 
            System.debug('Inside clarityProject ' + caseMap.get('clarityProject') ); 
       }
       
       if(caseMap.get('sprint') !=null)
            jc.Sprint_Name__c = caseMap.get('sprint'); 
       if(caseMap.get('userkey') !='')
            jc.Requested_By__c = caseMap.get('userkey'); 
       if(caseMap.get('reporterid') !='' && caseMap.get('reporterid') != null)
            jc.reporterkey__c = caseMap.get('reporterid'); 
       if(caseMap.get('status') !='')
            jc.Jira_source_status__c = caseMap.get('status'); 
       if(caseMap.get('businessneededby') !='' && caseMap.get('businessneededby') !=null)
       {
           jc.business_needed_by__c =Date.valueOf(caseMap.get('businessneededby') ) ;
       }
        if(caseMap.get('vendorcase') !='' && caseMap.get('vendorcase') !=null)
       {
           jc.Case_Number__c =caseMap.get('vendorcase')  ;
       }
       
            jc.Jira_Sync_Status__c='RECEIVED_FROM_JIRA';

      if( jc.Bug_Environment__c =='Production'  && (jc.Issue_Type__c=='Task' || jc.Issue_Type__c== 'Story' || jc.Issue_Type__c==  'Bug' ) )      
      {
      jclist.add(jc);
       System.debug('Inside Sync add to list '  );  
      }
      try {
        upsert jclist Jira_ID__c;  // This line upserts the jiracase list 
           } catch (DmlException e) {
        System.debug(e.getMessage());
    } 
      
    }
    
    public static  void syncJiraCaseComment(  Map<String, String> caseMap)
    {
    System.debug('inside comment');
    String issuekey= caseMap.get('issueKey');
    String comment_id= caseMap.get('comment_id');
    String com_body= caseMap.get('comment_body');
    String com_updated= caseMap.get('comment_updated');
    String updateAuthor= caseMap.get('comment_updateAuthor');
    String comm_new= com_body +'\n';
    comm_new+= '\n';
    comm_new+='@jiraCommentid#:'+comment_id+'#jiraCommentid@' +'\n';
    comm_new+='@jiraIssuekey#:'+issuekey+'#jiraIssuekey@' +'\n';
    comm_new+='@updatedBy#: '+ updateAuthor +'#updatedBy@' ;
    
    
    if(com_body.indexOf('@sfupdatedBy#:') != -1 )
            {
              String sf_updt=  com_body.Substring(com_body.indexOf('@sfupdatedBy#:')+14,com_body.indexof('#sfupdatedBy@'));
              
              
              comm_new = comm_new.replace('@sfupdatedBy#:'+sf_updt+'#sfupdatedBy@','');
              
              }
              
              
    if(com_body.indexOf('@sfCommentid#:') != -1 )
            {
              String sf_id=  com_body.Substring(com_body.indexOf('@sfCommentid#:')+14,com_body.indexof('#sfCommentid@'));
              
              CaseComment cc = [select id,CommentBody from CaseComment where id =:sf_id];
              comm_new = comm_new.replace('@sfCommentid#:'+sf_id+'#sfCommentid@','');
              cc.CommentBody=comm_new;
               update cc;
              }
              else{
      List<Jira_Case__c> jc_list= [select id,Case__c,Jira_ID__c from Jira_Case__c where Jira_ID__c =:issuekey];
      Boolean newcommment = true;
      
      for (CaseComment cc: [ SELECT Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById from CaseComment where ParentId =:jc_list[0].Case__c])
      {
          if(cc.CommentBody.indexOf('@jiraCommentid#:') != -1 )
            {
              String comm_id=  cc.CommentBody.Substring(cc.CommentBody.indexOf('@jiraCommentid#:')+16,cc.CommentBody.indexof('#jiraCommentid@'));
              if(comm_id==comment_id)
              {
               cc.CommentBody=comm_new;
               update cc;
               newcommment=false;
              }
            }
          
      }
      
        if(newcommment)
        {
            CaseComment cc = new CaseComment();
            cc.CommentBody =comm_new;
            cc.ParentId=jc_list[0].Case__c;
            insert cc;
        }
    }
    }
}