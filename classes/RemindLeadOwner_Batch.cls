global class RemindLeadOwner_Batch implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    public Datetime checkmoddate=system.now()-2;
    public Datetime dateday = datetime.newinstance(system.now().year(),system.today().month(),system.today().day());
    public string day = dateday.format('EEEE');
    public Datetime changeownerdate;
    public Long hoursSinceLastModifiedUsedForTestClass = 50;
    
   // public Datetime changeownerdate=system.now()-3;//This is in addition to the checkmoddate for the owner to change.
    public Datetime checkleadmod1=system.now()-1;
    public Datetime checkleadmod= checkleadmod1.addHours(2);
    public string DEFAULT_USER = 'salesforce';
    public List<User> lstDefaultUser = new List<User>(); 
    //START S-343740 [Hemant 8/25/2015]
    //public List<QueueSobject> assigntoQueue= new List<QueueSobject>();
    public Map<String, Id> assigntoQueueMap= new Map<String, Id>();
    public String USERROLE_ISO_BDR_REPS = 'ISO-BDR Reps';
    private Integer LEAD_AGE_COUNT = 3;
    public String QUEUE_LEAD_TRIAGE = 'Lead Triage';
    public String QUEUE_LEADS_REASSIGNED_AFTER_72_HOURS = 'Leads Reassigned After 72 Hours';
    //END S-343740
    //Added for Story S-410485
    public String BSD_AUTO_ACCOUNT_SETUP = 'BSD Auto Account Setup';
    public String BusinessHours_Id;     
    public ID bizboxRecordType= Schema.SobjectType.Lead.getRecordTypeInfosByName().get('Lead (BizBox)').getRecordTypeId();
    public ID partnerRecordType = Schema.SobjectType.Lead.getRecordTypeInfosByName().get('Lead (Partner)').getRecordTypeId();
     //Story#01514727 - Below Piece of code is used to skip RecordType (Tech Zone)
    public ID TechZoneRecordType = Schema.SobjectType.Lead.getRecordTypeInfosByName().get('Lead (Tech-Zone)').getRecordTypeId();
    // below is set a default query in case not set in test class or in scheduler
    //S-343863 [Hemant 8/27/2015] - Replace Time_of_non_API_User_Modification__c with CreatedDate
    //private String DEFAULT_QUERY = 'Select id,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,Time_of_non_API_User_Modification__c from lead where Status=\'Open\' and (LeadSource=\'BSD NET\' OR LeadSource=\'Customer Service\' OR LeadSource=\'Web Lead\' OR LeadSource=\'Store Lead\') and (Industry!=\'Government\' or Industry!=\'Education/Schools\') and Time_of_non_API_User_Modification__c != null';//Added last condition to query by Najma Ateeq for Case # 00126834
    //Start Case# 00138831 Nimisha Prashant [14-12-2015] Updated Entry crteria to work for Lead Age >=1 instead of Lead Age >=2
      //private String DEFAULT_QUERY = 'Select id,New_Date_time__c,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,CreatedDate, Lead_Age__c, Owner.UserRole.Name from lead where Status=\'Open\' and (LeadSource=\'BSD NET\' OR LeadSource=\'Customer Service\' OR LeadSource=\'Web Lead\' OR LeadSource=\'Store Lead\') and (Industry!=\'Government\' or Industry!=\'Education/Schools\') AND Lead_Age__c >= 2 AND Owner.UserRole.Name !=: USERROLE_ISO_BDR_REPS AND Owner.Name !=: QUEUE_LEADS_REASSIGNED_AFTER_72_HOURS';
      //Added LeadSource =  'BSD Auto Account Setup' condition for Story S-410485
      private String DEFAULT_QUERY = 'Select id,New_Date_time__c,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,CreatedDate, Lead_Age__c, Owner.UserRole.Name, RecordTypeId from lead where Status=\'Open\' and RecordTypeId !=: bizboxRecordType AND RecordTypeId !=: partnerRecordType AND RecordTypeId !=: TechZoneRecordType AND (LeadSource=\'BSD NET\' OR LeadSource=\'Customer Service\' OR LeadSource=\'Web Lead\' OR LeadSource=\'Store Lead\' OR LeadSource =: BSD_AUTO_ACCOUNT_SETUP) and (Industry!=\'Government\' or Industry!=\'Education/Schools\') AND Lead_Age__c >= 1 AND Owner.UserRole.Name !=: USERROLE_ISO_BDR_REPS AND Owner.Name !=: QUEUE_LEADS_REASSIGNED_AFTER_72_HOURS';
    //End Case# 00138831
    /* Default Constructor*/
    global RemindLeadOwner_Batch()
    {
    }
    
    global RemindLeadOwner_Batch(String query)
    {
        list<businesshours> bh = [select id,Name,IsDefault from businesshours where IsDefault = true];
        BusinessHours_Id = bh[0].id;
        
        //changeOwnerDate();
        /*System.debug('QUEERY IS---->'+query);
        system.debug('checkmoddate-->'+checkmoddate);
        system.debug('checkleadmod-->'+checkleadmod+' checkleadmod1-->'+checkleadmod1);
        system.debug('changeownerdate-->'+changeownerdate);*/
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    /*This method will change the owner date skipping the weekends*/
    public void changeOwnerDate(){
        if(day == 'Monday' || day == 'Tuesday' || day == 'Wednesday'){
          changeownerdate = system.now()-5;  //This is in addition to the checkmoddate for the owner to change.
        }
        else if(day == 'Thursday' || day == 'Friday'){
          changeownerdate = system.now()-3; //This is in addition to the checkmoddate for the owner to change.
        }
    }
    
    public Long gethrssincelastModified( Datetime LastModified){
        Long  Hours_since_lastModifed = BusinessHours.diff (BusinessHours_Id, LastModified, System.now()) / 1000 / 60 / 60;
        
        if(Test.isRunningTest()){
            Hours_since_lastModifed = hoursSinceLastModifiedUsedForTestClass ;
            
        }
        
        return Hours_since_lastModifed;
    }
    
    /* This method prepares the scope of the batch programbased on the query result*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(strQuery);
    }
    
    /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        List<Lead> listlead=scope;
        /*System.Debug('Scope check'+Scope);
        System.Debug('CheckModdat'+checkmoddate);*/
        Set<Id> leadids= new Set<Id>();
        //Set<Id> activeuser= new Set<Id>();
        Map<Id, User> mapActiveUser = null;
        List<Lead> updatelead= new List<Lead>();
        Set<String> leadzipcode= new Set<String>();
        Map<String,Assignment_Rule__c> mapassignmentrule= new Map<String,Assignment_Rule__c>();
        lstDefaultUser = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1];
        //START S-343740 [Hemant 8/25/2015] - Assign Leads to Queue - Leads Reassigned After 72 Hours
        //assigntoQueue= [Select Id, SobjectType, QueueId, Queue.Name, Queue.email from QueueSobject where SobjectType = 'Lead' and Queue.Name='Lead Triage'];
        assigntoQueueMap= new Map<String, Id>();
        for(QueueSobject ldQueue : [Select Id, SobjectType, QueueId, Queue.Name, Queue.email from QueueSobject
                        where SobjectType = 'Lead' 
                        AND (Queue.Name=: QUEUE_LEAD_TRIAGE
                        OR Queue.Name=: QUEUE_LEADS_REASSIGNED_AFTER_72_HOURS)]){
            assigntoQueueMap.put(ldQueue.Queue.Name, ldQueue.QueueId);
        }
        //END S-343740
        /*for(User u:[Select id,isactive from user where isactive=true])
        {
            activeuser.add(u.id);
        }*/
        Map<Id,Profile> profileIds = new Map<id,profile>([SELECT Id,UserLicenseId FROM Profile where UserLicenseId  in (SELECT Id FROM UserLicense where name ='Salesforce')]);
        mapActiveUser = new Map<Id, User>([Select id,isactive from user where isactive=true and profileId in:profileIds.Keyset()]);

        for(Lead lead_alias:listlead)
        {
        
       // System.debug('&&&&&&&&&&&&&&&&&&&&&lead_alias'+  lead_alias );
        
            leadids.add(lead_alias.id);
            if(lead_alias.Zip__c!=null && lead_alias.Zip__c!='')
            {
               String zipCode = lead_alias.zip__c;
               if(zipCode.length()>5)
                   leadzipcode.add(zipCode.substring(0,5));
               else
                   leadzipcode.add(zipCode);
            }
            
        }
        //To fetch the latest modified Assignment rule based on zip And WCW Count in the range of 1to19
        for(Assignment_Rule__c rule : [select Zip_Code__c,Industry_Group__c,WCW_Count__c ,User__c FROM Assignment_Rule__c where Zip_Code__c IN :leadzipcode and WCW_Count__c=:'1to19' and Industry_Group__c =null order by lastmodifieddate desc])
        {
            //Generating unique key for Zip and Industry code not null for wcw count='1to19'
            //if(rule.Zip_Code__c!=null && rule.Industry_Group__c!=null)
              //  mapassignmentrule.put(rule.Zip_Code__c+rule.Industry_Group__c,rule);
            //Generating unique key for Zip not null and Industry code null for wcw count='1to19'    
            //else 
            if(rule.Zip_Code__c!=null)
                mapassignmentrule.put(rule.Zip_Code__c,rule); 
        }
        //System.debug('mapassignmentrule-->'+mapassignmentrule);
     
        //To take all the notes associated with a lead
       
        for(Lead lead_alias:listlead)
        {
        
        //System.debug('&&&&&&&&&&'+lead_alias.Status+'&&&&&&&&&'+lead_alias.Status+'&&&&&&&&'+lead_alias.industry);
            //Extra check
            //Added LeadSource =  'BSD Auto Account Setup' condition for Story S-410485
            if(String.valueof(lead_alias.ownerid).startswith('005')  && lead_alias.Status=='Open' && (lead_alias.LeadSource=='BSD NET' || lead_alias.LeadSource=='Customer Service' || lead_alias.LeadSource=='Web Lead' || lead_alias.LeadSource=='Store Lead' || lead_alias.LeadSource == BSD_AUTO_ACCOUNT_SETUP)&&(lead_alias.Industry !='Government')&& (lead_alias.Industry !='Education/Schools'))// (String.valueof(lead_alias.ownerid).startswith('005') added by ankush for case 00140740
            {
           System.debug('ChangeOwner@@@'+lead_alias.Change_Owner__c+'LastMod@@@'+(gethrssincelastModified(lead_alias.CreatedDate))+'OwnerID@@@'+String.valueof(lead_alias.ownerid));
            
                //START S-343740 [Hemant 8/25/2015] - Assign Leads to Queue - Leads Reassigned After 72 Hours
                //START Case# 00138831 [Nimisha 11/04/2015] - Updated condition to check for business hour spent from the Creation Date instead of Lead Age
                //if(lead_alias.Lead_Age__c >= LEAD_AGE_COUNT && assigntoQueueMap.containsKey(QUEUE_LEADS_REASSIGNED_AFTER_72_HOURS)){
                //added "String.valueof(lead_alias.ownerid).startswith('005') && lstDefaultUser[0].id!=lead_alias.ownerid" condition in following if condition by Jyoti for case 00140740 
                 DateTime modifiedDate;
                if(lead_alias.New_Date_time__c != null){
                    modifiedDate = lead_alias.New_Date_time__c;
                }
                else
                   modifiedDate =  lead_alias.CreatedDate;
                
                if(gethrssincelastModified(modifiedDate) > 72  && assigntoQueueMap.containsKey(QUEUE_LEADS_REASSIGNED_AFTER_72_HOURS) && String.valueof(lead_alias.ownerid).startswith('005') && lstDefaultUser[0].id!=lead_alias.ownerid){   //New_Date_time__c added by Ankush for case 00140740
                //END Case# 00138831  
                        lead_alias.ownerid= assigntoQueueMap.get(QUEUE_LEADS_REASSIGNED_AFTER_72_HOURS);
                        //Start Case# 00138831 Nimisha Prashant [14-12-2015] Shifting code from 24 hr process 
                        if(lead_alias.Lead_72_Hr_Assigned_Date__C==null)
                          lead_alias.Lead_72_Hr_Assigned_Date__C=System.now();
                        if(lead_alias.Lead_72_Hr_Counter__c==null){
                          lead_alias.Lead_72_Hr_Counter__c=0;
                        }
                        lead_alias.Lead_72_Hr_Counter__c=lead_alias.Lead_72_Hr_Counter__c+1;
                        lead_alias.Lead_72_Hour_Reassignment__c=true;
                        //End Case# 00138831 
                        
                    updatelead.add(lead_alias);
                }
                //END S-343740 - added else for below condition
                //S-343863 [Hemant 8/27/2015] - Replace Time_of_non_API_User_Modification__c with CreatedDate
                //else if((lead_alias.Change_Owner__c == false) &&  (gethrssincelastModified(lead_alias.Time_of_non_API_User_Modification__c) > 48)&& String.valueof(lead_alias.ownerid).startswith('005') && lstDefaultUser[0].id!=lead_alias.ownerid)//Passed Time_of_non_API_User_Modification__c field to the gethrssincelastModified function by Najma Ateeq for Case # 00126834
                else if((lead_alias.Change_Owner__c == false) &&  (gethrssincelastModified(lead_alias.CreatedDate) > 48) && (gethrssincelastModified(lead_alias.CreatedDate) < 72) && String.valueof(lead_alias.ownerid).startswith('005') && lstDefaultUser[0].id!=lead_alias.ownerid)
                {
                //    System.debug('Email to owner of lead and Send Email to owner field true');
                    lead_alias.Send_Email_To_Owner__c=true;
                    lead_alias.Change_Owner__c=true;
                    lead_alias.Lead_72_Hour_Reassignment__c=false;
                    updatelead.add(lead_alias);
                }
                else 
                {
                    //S-343863 [Hemant 8/27/2015] - Replace Time_of_non_API_User_Modification__c with CreatedDate
                    system.debug('lead_alias.lastmodifieddate-->'+lead_alias.CreatedDate+' owner-->'+String.valueof(lead_alias.ownerid)); 
                    system.debug('&&&&&&&&hrs'+    gethrssincelastModified(lead_alias.CreatedDate));               
                    
                    //if((lead_alias.Change_Owner__c==true) && (String.valueof(lead_alias.ownerid).startswith('005') && lstDefaultUser[0].id!=lead_alias.ownerid) && (gethrssincelastModified(lead_alias.Time_of_non_API_User_Modification__c) > 24) )//Passed Time_of_non_API_User_Modification__c field to the gethrssincelastModified function by Najma Ateeq for Case # 00126834
                    if((lead_alias.Change_Owner__c==true) && (String.valueof(lead_alias.ownerid).startswith('005') && lstDefaultUser[0].id!=lead_alias.ownerid) && (gethrssincelastModified(lead_alias.CreatedDate) > 24) && (gethrssincelastModified(lead_alias.CreatedDate) < 72) )
                    {
                    
                    //    system.debug('Change the owner and Send Email to owner field false');
                    //    system.debug('Previous owner-->'+lead_alias.ownerid);
                        lead_alias.Previous_User__c=lead_alias.ownerid;
                        //*****Owner Assignment logic*****//
                        string key=null;
                        String zipCode;
                        if(lead_alias.Zip__c!=null)
                        {
                            zipCode = lead_alias.zip__c;
                            if(zipCode.length()>5)
                                zipCode =zipCode.substring(0,5);
                        } 
                        //Setting key of lead to match the key of assignment rule.   
                        //if(lead_alias.Zip__c!=null && lead_alias.Industry_Code__c!=null)
                           // key=zipCode+lead_alias.Industry_Code__c;
                        //else 
                        if(lead_alias.Zip__c!=null) 
                            key=zipCode;
                        //System.debug('The key on lead-->'+key);    
                        Assignment_Rule__c assignruleobj=mapassignmentrule.get(key);    
                        if(assignruleobj!=null)
                        {
                          //  system.debug('If');
                            if(assignruleobj.user__c!=null)
                            {
                                //if(activeuser.contains(assignruleobj.user__c)) 
                                if(mapActiveUser.containsKey(assignruleobj.user__c))
                                    lead_alias.ownerid= assignruleobj.user__c;
                                else
                                    //lead_alias.ownerid= assigntoQueue[0].QueueId; //S-343740 [Hemant 8/25/2015] - using map for queue
                                    if(assigntoQueueMap.containsKey(QUEUE_LEAD_TRIAGE)){
                                                        lead_alias.ownerid= assigntoQueueMap.get(QUEUE_LEAD_TRIAGE);
                                                      }
                            }
                            else
                                //lead_alias.ownerid= assigntoQueue[0].QueueId;//S-343740 [Hemant 8/25/2015] - using map for queue
                                if(assigntoQueueMap.containsKey(QUEUE_LEAD_TRIAGE)){
                                  lead_alias.ownerid= assigntoQueueMap.get(QUEUE_LEAD_TRIAGE);
                                }
                        }
                        else
                        {
                         //  system.debug('Else');
                           //lead_alias.ownerid= assigntoQueue[0].QueueId;//S-343740 [Hemant 8/25/2015] - using map for queue
                            if(assigntoQueueMap.containsKey(QUEUE_LEAD_TRIAGE)){
                              lead_alias.ownerid= assigntoQueueMap.get(QUEUE_LEAD_TRIAGE);
                            } 
                        }                       
                       // system.debug('New Owner-->'+lead_alias.ownerid);
                        lead_alias.Send_Email_To_Previous_Owner__c=true;
                       //Start Case# 00138831 Nimisha Prashant [14-12-2015] Shifting code to 72 hr process 
                       /*
                        if(lead_alias.Lead_72_Hr_Assigned_Date__C==null)
                        lead_alias.Lead_72_Hr_Assigned_Date__C=System.now();
                        if(lead_alias.Lead_72_Hr_Counter__c==null){
                        lead_alias.Lead_72_Hr_Counter__c=0;}
                      //  System.debug('&&&&&&&&&&&&&&&&before'+lead_alias.Lead_72_Hr_Counter__c);
                        lead_alias.Lead_72_Hr_Counter__c=lead_alias.Lead_72_Hr_Counter__c+1;
                      //   System.debug('&&&&&&&&&&&&&&&&after'+lead_alias.Lead_72_Hr_Counter__c);
                        lead_alias.Lead_72_Hour_Reassignment__c=true;
                        */
                        //End Case# 00138831 
                        lead_alias.Change_Owner__c=false;
                        updatelead.add(lead_alias);
                    }
                    else
                    {
                       /* if(lead_alias.Change_Owner__c==true)
                        {
                            //This else is added because if the related records of lead are modified then the field should be false.
                            system.debug('Make the Send Email to owner field false.');
                            lead_alias.Change_Owner__c = false;
                            updatelead.add(lead_alias);
                        }*/
                    }
                    
                }
            } 
        }
        if(updatelead.size()>0)
        {
            update updatelead;
        }
    }
      /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        // String strquery = 'Select id,New_Date_time__c,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,CreatedDate, Lead_Age__c, Owner.UserRole.Name from lead where Status=\'Open\' and (LeadSource=\'BSD NET\' OR LeadSource=\'Customer Service\' OR LeadSource=\'Web Lead\' OR LeadSource=\'Store Lead\' OR LeadSource =: BSD_AUTO_ACCOUNT_SETUP) and (Industry!=\'Government\' or Industry!=\'Education/Schools\') AND Lead_Age__c >= 1 AND Owner.UserRole.Name !=: USERROLE_ISO_BDR_REPS AND Owner.Name !=: QUEUE_LEADS_REASSIGNED_AFTER_72_HOURS';
        // Adding Changes for Case 01442425
        String strquery = 'Select id,New_Date_time__c,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,CreatedDate, Lead_Age__c, Owner.UserRole.Name, RecordTypeId from lead where Status=\'Open\' and RecordTypeId !=: bizboxRecordType  and RecordTypeId !=: TechZoneRecordType AND (LeadSource=\'BSD NET\' OR LeadSource=\'Customer Service\' OR LeadSource=\'Web Lead\' OR LeadSource=\'Store Lead\' OR LeadSource =: BSD_AUTO_ACCOUNT_SETUP) and (Industry!=\'Government\' or Industry!=\'Education/Schools\') AND Lead_Age__c >= 1 AND Owner.UserRole.Name !=: USERROLE_ISO_BDR_REPS AND Owner.Name !=: QUEUE_LEADS_REASSIGNED_AFTER_72_HOURS';
        RemindLeadOwner_Batch assignBatch1 = new RemindLeadOwner_Batch(strQuery);
        database.executebatch(assignBatch1, 100);
    }
}