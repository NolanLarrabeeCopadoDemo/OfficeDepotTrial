global class ProcessLegacyData_Batch implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    // below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select id,N_Body__c,OMX_primary_key__c,N_Legacy_Created_Date__c,N_ISPRIVATE__c,N_ParentId__c,N_ParentId_Type__c,N_Title__c,T_CallType__c ,T_ReminderDateTime__c ,T_RecurrenceDayOfMonth__c ,T_Subject__c ,T_CallDurationInSeconds__c ,T_RecurrenceTimeZoneSidKey__c ,T_CallObject__c ,LastModifiedByName__c ,LastModifiedDate__c ,T_CallDisposition__c ,T_IsRecurrence__c ,T_RecurrenceDayOfWeekMask__c ,T_IsReminderSet__c ,createdDate__c ,T_Status__c ,T_RecurrenceInterval__c ,T_RecurrenceInstance__c ,T_ActivityDate__c ,T_RecurrenceType__c ,T_RecurrenceEndDateOnly__c ,T_RecurrenceMonthOfYear__c ,T_RecurrenceStartDateOnly__c ,CreatedByName__c ,T_Priority__c ,E_Description__c , T_WhoId_Type__c,T_WhoId__c,T_WhatId__c,T_WhatId_Type__c,OwnerRepNumber__c,SFDC_ID__c  from Legacy_Delta__c where status__c =\'Open\' and SFDC_ID__c=null';
    public String OrgID;
    /* Default Constructor*/
    global ProcessLegacyData_Batch()
    {
    }
    
    global ProcessLegacyData_Batch(String query)
    {
         this.OrgID = UserInfo.getOrganizationId();
        //System.debug('QUEERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    /* This method prepares the scope of the batch programbased on the query result*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('QUERY IS ====='+strQuery);
        return Database.getQueryLocator(strQuery);
    }
    
     /* This method processes query result in batches */
     global void execute(Database.BatchableContext BC, SObject[] scope)
    {
            List<Legacy_Delta__c> listAssignment=scope;
            List<Legacy_Delta__c> noterecs = new List<Legacy_Delta__c>();
            List<Legacy_Delta__c> taskrecs=new List<Legacy_Delta__c>();
            
            for(Legacy_Delta__c deltarec: listAssignment)
            {
            if(deltarec.N_ParentId__c!='' && deltarec.N_ParentId__c!=null)
            noterecs.add(deltarec);
            if((deltarec.T_Whoid__c!='' && deltarec.T_Whoid__c!=null) || (deltarec.T_Whatid__c!='' && deltarec.T_Whatid__c!=null))
            taskrecs.add(deltarec);
            }
            
            if(noterecs.size()>0)
            {
            processNotes(noterecs);
            }
            if(taskrecs.size()>0)
            {
            processTask(taskrecs);
            }
            
    }
    
    public void processNotes(List<Legacy_Delta__c> Notes_list){
   
        Map<String,Set<String>> PrimaryKeyMap = new Map<String,Set<String>>(); 
        Map<String,String> ODKeyMap = new Map<String,String>();
        Set<String> RepNumber = new Set<String>();
        Map<String,User> oOwnermap = new  Map<String,User>();
        Map<String,list<Legacy_Delta__c>> map_tobeCreated = new Map<String,list<Legacy_Delta__c>>();
        List<Legacy_Delta__c> toupdateBack = new list<Legacy_Delta__c>();
        Map<id,Legacy_Delta__c> m_toupdateBack = new map<id,Legacy_Delta__c>();
        
        for(Legacy_Delta__c s :Notes_list){
            if(s.N_ParentId_Type__c != null && s.N_ParentId__c!= null){
                if(!(PrimaryKeyMap.containsKey(s.N_ParentId_Type__c))){
                    Set<String> pKey = new Set<String>();
                    PrimaryKeyMap.put(s.N_ParentId_Type__c,pKey);
                }
                PrimaryKeyMap.get(s.N_ParentId_Type__c).add(s.N_ParentId__c);
                RepNumber.add(s.OwnerRepNumber__c);
            }             
        }
         
        oOwnermap = PopulateOwner(RepNumber);
        
        System.debug('LIST SIZE'+PrimaryKeyMap.size());
        if(PrimaryKeyMap.size()>0){
            for(String key: PrimaryKeyMap.keySet()){
               Set<String> p = PrimaryKeyMap.get(key);
               String queryStr = 'SELECT Id,OMX_Primary_key__c FROM '+key+' where OMX_Primary_key__c =:p';
               System.debug('@@@@@@@@@@@@@@@@@'+queryStr );               
                for(Sobject so : Database.query(queryStr)){
                   ODKeyMap.put(String.ValueOf(so.get('OMX_Primary_key__c')) ,String.ValueOf(so.get('id')));
                }
               
            }
        }
        
         
        List<Note> NotesTobeCreated = New List<Note>();
        for(Legacy_Delta__c ld :Notes_list){
            if(ODKeyMap.get(ld.N_ParentId__c) != null){
                 Note n = new Note();
                 n.ParentId = ODKeyMap.get(ld.N_ParentId__c);
                 n.Title = ld.N_Title__c;
                 n.IsPrivate = ld.N_ISPRIVATE__c;
                 n.BODY = 'Legacy Created Date : '+ld.N_Legacy_Created_Date__c+ '\n' +ld.N_Body__c;
                 if(oOwnermap.get(ld.OwnerRepNumber__c)!= null){
                     n.OwnerID = oOwnermap.get(ld.OwnerRepNumber__c).Id;
                 }else{
                     if(OrgID == '00DM00000014EKNMA2'){
                     //UAT
                     n.OwnerID = '005M000000509M2'; //Salesforce DataloaderNorth[UAT]; 005E0000005UuiP - Salesforce DataloaderNorth[Prod]
                     }else{ //Production
                         n.OwnerID = '005E0000005UuiP';
                     }
                 }
                 NotesTobeCreated.add(n);
                 
                 if(!map_tobeCreated.containsKey(ODKeyMap.get(ld.N_ParentId__c)))
                 {
                     List<Legacy_Delta__c> lRec = new List<Legacy_Delta__c>();
                     lrec.add(ld);
                     map_tobeCreated.put(ODKeyMap.get(ld.N_ParentId__c),lRec); 
                 }
                 else
                 {
                     List<Legacy_Delta__c> lRec = new List<Legacy_Delta__c>();
                     lRec = map_tobeCreated.get(ODKeyMap.get(ld.N_ParentId__c));
                     lrec.add(ld);
                     map_tobeCreated.remove(ODKeyMap.get(ld.N_ParentId__c)); 
                     map_tobeCreated.put(ODKeyMap.get(ld.N_ParentId__c),lRec); 
                 }
                 
                 // map_tobeCreated.put(ODKeyMap.get(ld.N_ParentId__c),ld); 
                 
            }
         
        }
        try{
        
        if(NotesTobeCreated.size() >0){
            Database.insert(NotesTobeCreated,false); 
            system.debug('NotesTobeCreated>>>>>>>>>>'+NotesTobeCreated);        
           for(Note nc:NotesTobeCreated)
           {
               if(nc.get('id') != '')
               {
                  List<Legacy_Delta__c> l_cm = map_tobeCreated.get(nc.ParentId);
                  for(Legacy_Delta__c cm : l_cm )
                  {
                      cm.SFDC_ID__c = String.valueOf(nc.get('id'));
                      cm.status__c = 'Processed'; // Added by Sushma
                      
                      if(!m_toupdateBack.containsKey(cm.id))
                          m_toupdateBack.put(cm.id,cm);
                     // else
                     // {
                     //      m_toupdateBack.remove(cm.id);
                     //      m_toupdateBack.put(cm.id,cm);
                     //  }
                  } 
                 // toupdateBack.add(cm); 
                                    
               }
            
           }
           system.debug('toupdateBack>>>>>>'+toupdateBack);
           // update toupdateBack;
           Database.update(m_toupdateBack.values(),False);
        }
        }catch(Exception e){System.debug('###################'+e);}
          
    }

    public void processTask(List<Legacy_Delta__c> Tasks_list){
    
        Map<String,Set<String>> PrimarywhatidMap = new Map<String,Set<String>>(); 
        Map<String,Set<String>> PrimarywhoidMap = new Map<String,Set<String>>(); 
        Map<String,String> ODwhatKeyMap = new Map<String,String>();
        Map<String,String> ODwhoKeyMap = new Map<String,String>();
        Set<String> RepNumber = new Set<String>();
        Map<String,User> oOwnermap = new  Map<String,User>();
        Map<String,list<Legacy_Delta__c>> map_tobeCreatedWhatId = new Map<String,list<Legacy_Delta__c>>();
        Map<String,list<Legacy_Delta__c>> map_tobeCreatedWhoId = new Map<String,list<Legacy_Delta__c>>();
        list<Legacy_Delta__c> toupdateBack = new list<Legacy_Delta__c>();
        Map<id,Legacy_Delta__c> m_toupdateBack = new map<id,Legacy_Delta__c>();
        
        for(Legacy_Delta__c s :Tasks_list){
            if(s.T_WhatId_Type__c != null && s.T_WhatId__c!= null){
                if(!(PrimarywhatidMap.containsKey(s.T_WhatId_Type__c))){
                    Set<String> pKey = new Set<String>();
                    PrimarywhatidMap.put(s.T_WhatId_Type__c,pKey);
                }
                PrimarywhatidMap.get(s.T_WhatId_Type__c).add(s.T_WhatId__c);
            }             
            if(s.T_WhoId_Type__c != null && s.T_WhoId__c!= null){
                if(!(PrimarywhoidMap.containsKey(s.T_WhoId_Type__c))){
                    Set<String> pKey = new Set<String>();
                    PrimarywhoidMap.put(s.T_WhoId_Type__c,pKey);
                }
                PrimarywhoidMap.get(s.T_WhoId_Type__c).add(s.T_WhoId__c);
            }             
               system.debug('s.OwnerRepNumber__c>>>>>>'+s.OwnerRepNumber__c);
               if(s.OwnerRepNumber__c!=''&& s.OwnerRepNumber__c!=null)
                RepNumber.add(s.OwnerRepNumber__c);
        }
         
        oOwnermap = PopulateOwner(RepNumber);

        if(PrimarywhatidMap.size()>0){
            for(String key: PrimarywhatidMap.keySet()){
                Set<String> p = PrimarywhatidMap.get(key);
               String queryStr = 'SELECT Id,OMX_Primary_key__c FROM '+key+' where OMX_Primary_key__c =:p';               
                for(Sobject so : Database.query(queryStr)){
                   ODwhatKeyMap.put(String.ValueOf(so.get('OMX_Primary_key__c')) ,String.ValueOf(so.get('id')));
                }   
            }
        }
        if(PrimarywhoidMap.size()>0){
            for(String key: PrimarywhoidMap.keySet()){
                Set<String> p = PrimarywhoidMap.get(key);
               String queryStr = 'SELECT Id,OMX_Primary_key__c FROM '+key+' where OMX_Primary_key__c =:p';               
                for(Sobject so : Database.query(queryStr)){
                   ODwhoKeyMap.put(String.ValueOf(so.get('OMX_Primary_key__c')) ,String.ValueOf(so.get('id')));
                }   
            }
            system.debug('ODwhoKeyMap>>>>>'+ODwhoKeyMap);
        }
        
         
        List<Task> TasksTobeCreated = New List<Task>();
        for(Legacy_Delta__c ld :Tasks_list){
                 Task n = new Task();
            if(ODwhatKeyMap.get(ld.T_WhatId__c) != null){
                 n.WhatId = ODwhatKeyMap.get(ld.T_WhatId__c);
                 }
                 system.debug('ODwhoKeyMap.get(ld.T_WhoId__c)>>>>'+ODwhoKeyMap.get(ld.T_WhoId__c));
            if(ODwhoKeyMap.get(ld.T_WhoId__c) != null){
                 n.WhoId = ODwhoKeyMap.get(ld.T_WhoId__c);
                 }
                n.Subject = ld.T_Subject__c;
                n.CallType=ld.T_CallType__c ;
                n.ReminderDateTime= ld.T_ReminderDateTime__c ;
                n.RecurrenceDayOfMonth=integer.valueof(ld.T_RecurrenceDayOfMonth__c) ;
                n.Subject=ld.T_Subject__c ;
                n.CallDurationInSeconds=integer.valueof(ld.T_CallDurationInSeconds__c) ;
                n.RecurrenceTimeZoneSidKey=ld.T_RecurrenceTimeZoneSidKey__c ;
                n.CallObject=ld.T_CallObject__c ;
                n.Legacy_LastModifiedBy__c=ld.LastModifiedByName__c ;
                n.Legacy_LastModifiedDate__c=ld.LastModifiedDate__c ;
                n.CallDisposition=ld.T_CallDisposition__c ;
                n.IsRecurrence=ld.T_IsRecurrence__c ;
                n.RecurrenceDayOfWeekMask=integer.valueof(ld.T_RecurrenceDayOfWeekMask__c) ;
                n.IsReminderSet=ld.T_IsReminderSet__c ;
                n.Legacy_CreatedDate__c=ld.createdDate__c ;
                n.Status=ld.T_Status__c ;
                n.RecurrenceInterval=integer.valueof(ld.T_RecurrenceInterval__c) ;
                n.RecurrenceInstance=ld.T_RecurrenceInstance__c ;
                n.ActivityDate=ld.T_ActivityDate__c ;
                n.RecurrenceType=ld.T_RecurrenceType__c ;
                n.RecurrenceEndDateOnly=ld.T_RecurrenceEndDateOnly__c ;
                n.RecurrenceMonthOfYear=ld.T_RecurrenceMonthOfYear__c ;
                n.RecurrenceStartDateOnly=ld.T_RecurrenceStartDateOnly__c ;
                n.Legacy_CreatedBy__c=ld.CreatedByName__c ;
                n.Priority=ld.T_Priority__c ;
                n.Description=ld.E_Description__c ; 
                n.OMX_Primary_Key__c = ld.OMX_primary_key__c;                      
                 if(oOwnermap.get(ld.OwnerRepNumber__c)!= null){
                     n.OwnerID = oOwnermap.get(ld.OwnerRepNumber__c).Id;
                 }else{
                 System.debug('Default Owner');
                     n.OwnerID = '005M000000509M2'; //Salesforce DataloaderNorth
                 system.debug('n.OwnerID>>>>>>>>'+n.OwnerID);
                 }
                 TasksTobeCreated.add(n);
                 system.debug('TasksTobeCreated>>>>>>>'+TasksTobeCreated);
                if(ld.T_WhatId__c!='' && ld.T_WhatId__c!=null){
                // map_tobeCreatedWhatId.put(ODwhatKeyMap.get(ld.T_WhatId__c),ld); 
                 if(!map_tobeCreatedWhatId.containsKey(ODwhatKeyMap.get(ld.T_WhatId__c)))
                 {
                     List<Legacy_Delta__c> lRec = new List<Legacy_Delta__c>();
                     lrec.add(ld);
                     map_tobeCreatedWhatId.put(ODwhatKeyMap.get(ld.T_WhatId__c),lRec); 
                 }
                 else
                 {
                     List<Legacy_Delta__c> lRec = new List<Legacy_Delta__c>();
                     lRec = map_tobeCreatedWhatId.get(ODwhatKeyMap.get(ld.T_WhatId__c));
                     lrec.add(ld);
                     map_tobeCreatedWhatId.remove(ODwhatKeyMap.get(ld.T_WhatId__c)); 
                     map_tobeCreatedWhatId.put(ODwhatKeyMap.get(ld.T_WhatId__c),lRec); 
                 }
                }
                 else{
                 System.debug('entered else');
                 system.debug('<<<<<<<<ld.T_WhoId__c>>>>>>>>'+ld.T_WhoId__c);
                 if(ld.T_WhoId__c!='' && ld.T_WhoId__c!=null)
                 {
                 system.debug('ODwhoKeyMap.get(ld.T_WhoId__c)>>>>>>'+ODwhoKeyMap.get(ld.T_WhoId__c));
                 //map_tobeCreatedWhoId.put(ODwhoKeyMap.get(ld.T_WhoId__c),ld);
                 if(!map_tobeCreatedWhoId.containsKey(ODwhoKeyMap.get(ld.T_WhoId__c)))
                 {
                     List<Legacy_Delta__c> lRec = new List<Legacy_Delta__c>();
                     lrec.add(ld);
                     map_tobeCreatedWhoId.put(ODwhoKeyMap.get(ld.T_WhoId__c),lRec);
                     system.debug('map_tobeCreatedWhoId>>>>>>>>>>>'+map_tobeCreatedWhoId.get(ODwhoKeyMap.get(ld.T_WhoId__c))); 
                 }
                 else
                 {
                     List<Legacy_Delta__c> lRec = new List<Legacy_Delta__c>();
                     lRec = map_tobeCreatedWhoId.get(ODwhoKeyMap.get(ld.T_WhoId__c));
                     lrec.add(ld);
                     map_tobeCreatedWhoId.remove(ODwhoKeyMap.get(ld.T_WhoId__c)); 
                     map_tobeCreatedWhoId.put(ODwhoKeyMap.get(ld.T_WhoId__c),lRec); 
                     system.debug('map_tobeCreatedWhoId in else>>>>>>>>>>>'+map_tobeCreatedWhoId.get(ODwhoKeyMap.get(ld.T_WhoId__c))); 
                 }

                 System.debug('<<<<map_tobeCreatedWhoId.get(ld.T_WhoId__c)>>>>>>'+map_tobeCreatedWhoId.get(ODwhoKeyMap.get(ld.T_WhoId__c)));
                 }
                }                
                 
            
         
        }
        try{
            if(TasksTobeCreated.size() >0){
            system.debug('>>>>>'+TasksTobeCreated);
                Database.insert(TasksTobeCreated,false); 
               // Legacy_Delta__c cm = new Legacy_Delta__c();         
               for(Task tc:TasksTobeCreated)
               {
                      system.debug('tc'+tc.get('id'));
                if(tc.get('id')!=''){
                    System.debug('tc.get(WhatId)>>'+tc.get('WhatId')+'tc.get(WhoId)>>'+tc.get('WhoId'));
                 if(tc.get('WhatId')!='' && tc.get('WhatId')!= null){
                      //cm = map_tobeCreatedWhatId.get(tc.WhatId);
                   List<Legacy_Delta__c> l_cm = map_tobeCreatedWhatId.get(tc.WhatId);
                  for(Legacy_Delta__c cm : l_cm )
                  {
                      if(!m_toupdateBack.containsKey(cm.id))
                          m_toupdateBack.put(cm.id,cm);
                      else
                      {
                           m_toupdateBack.remove(cm.id);
                           m_toupdateBack.put(cm.id,cm);
                       }
                  } 
                }
                  
                 else{
                 system.debug('entering else');
                 system.debug('WhoId>>>>>>>>>>'+tc.get('WhoId'));
                 if(tc.get('WhoId')!='' && tc.get('WhoId')!=null)
                 {
                    //  cm = map_tobeCreatedWhoId.get(tc.WhoId);
                    system.debug('map_tobeCreatedWhoId.get(tc.WhoId)>>>>>>>>>>>'+map_tobeCreatedWhoId.get(tc.WhoId));
                  List<Legacy_Delta__c> l_cm = map_tobeCreatedWhoId.get(tc.WhoId);
                  if(l_cm!=null)
                  {
                      for(Legacy_Delta__c cm : l_cm)
                      {
                          if(!m_toupdateBack.containsKey(cm.id))
                              m_toupdateBack.put(cm.id,cm);
                          else
                          {
                               m_toupdateBack.remove(cm.id);
                               m_toupdateBack.put(cm.id,cm);
                          }
                       } 
                   }
                  }
                     system.debug('map_tobeCreatedWhoId.get(tc.WhoId)>>>'+map_tobeCreatedWhoId.get(tc.WhoId));
                     }
                 
                      system.debug('sfdc id'+String.valueOf(tc.get('id')));
                      
                      //toupdateBack.add(cm); 
                   }
               }
               //update toupdateBack;
               Database.update( m_toupdateBack.values(),false);
            }
        }catch(Exception e){System.debug('There is an Exception:: '+e);}

    }
        
    

    public Map<String,User> PopulateOwner(Set<String> RepNo){
        Map<String,User> OwnerMap = new Map<String,User>();
        for(User u :[select Id,Name,OMX_Rep_Number__c from user where OMX_Rep_Number__c in :RepNo]){
            OwnerMap.put(u.OMX_Rep_Number__c, u);  
        }        
        return OwnerMap;
    }

    
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
    /**
    This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
    String strquery = 'Select id,N_Body__c,OMX_primary_key__c,N_ISPRIVATE__c,N_Legacy_Created_Date__c,N_ParentId__c,N_ParentId_Type__c,N_Title__c,T_CallType__c ,T_ReminderDateTime__c ,T_RecurrenceDayOfMonth__c ,T_Subject__c ,T_CallDurationInSeconds__c ,T_RecurrenceTimeZoneSidKey__c ,T_CallObject__c ,LastModifiedByName__c ,LastModifiedDate__c ,T_CallDisposition__c ,T_IsRecurrence__c ,T_RecurrenceDayOfWeekMask__c ,T_IsReminderSet__c ,createdDate__c ,T_Status__c ,T_RecurrenceInterval__c ,T_RecurrenceInstance__c ,T_ActivityDate__c ,T_RecurrenceType__c ,T_RecurrenceEndDateOnly__c ,T_RecurrenceMonthOfYear__c ,T_RecurrenceStartDateOnly__c ,CreatedByName__c ,T_Priority__c ,E_Description__c , T_WhoId_Type__c,T_WhoId__c,T_WhatId__c,T_WhatId_Type__c,OwnerRepNumber__c,SFDC_ID__c  from Legacy_Delta__c where status__c =\'Open\' and SFDC_ID__c=null';
    ProcessLegacyData_Batch assignBatch1 = new ProcessLegacyData_Batch(strQuery);
    database.executebatch(assignBatch1, 1000);
    }
}