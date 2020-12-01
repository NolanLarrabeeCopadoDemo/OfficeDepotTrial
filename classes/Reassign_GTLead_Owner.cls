global class Reassign_GTLead_Owner implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    public String BusinessHours_Id;    
    public string DEFAULT_USER = 'salesforce';
    
    
    public List<User> lstDefaultUser = new List<User>();        
    
    //Below are for test class
    //public Datetime dateday = datetime.newinstance(system.now().year(),system.today().month(),system.today().day());
    //public string day = dateday.format('EEEE');
    public Long hoursSinceLastModifiedUsedForTestClass = 50;
    //public Datetime changeownerdate;
    
    //private String DEFAULT_QUERY = 'Select id,New_Date_time__c,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,CreatedDate, Lead_Age__c, Owner.UserRole.Name from lead where Status=\'Open\' and (LeadSource=\'BSD NET\' OR LeadSource=\'Customer Service\' OR LeadSource=\'Web Lead\' OR LeadSource=\'Store Lead\' OR LeadSource =: BSD_AUTO_ACCOUNT_SETUP) and (Industry!=\'Government\' or Industry!=\'Education/Schools\') AND Lead_Age__c >= 1 AND Owner.UserRole.Name !=: USERROLE_ISO_BDR_REPS AND Owner.Name !=: QUEUE_LEADS_REASSIGNED_AFTER_72_HOURS';
    private String DEFAULT_QUERY = 'Select id,New_Date_time__c,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,CreatedDate, Lead_Age__c, Owner.UserRole.Name from lead where Status=\'Open\' and recordtype.DeveloperName = \'Lead_Canada\' and Lead_72_Hr_Counter__c < 2 and WCW_Count__c > 100';
    
    
    
    global Reassign_GTLead_Owner()
    {
        list<businesshours> bh = [select id,Name,IsDefault from businesshours where IsDefault = true];
        BusinessHours_Id = bh[0].id;
        system.debug('constructor1: BusinessHours_Id-->'+BusinessHours_Id);
        
        this.strQuery = DEFAULT_QUERY;
        system.debug('strQuery:'+ strQuery);
    }
    
    global Reassign_GTLead_Owner(string query)
    {
        list<businesshours> bh = [select id,Name,IsDefault from businesshours where IsDefault = true];
        BusinessHours_Id = bh[0].id;
        system.debug('constructor2:BusinessHours_Id-->'+BusinessHours_Id);
        
        if(query != null && query != ''){system.debug('query is not null');
                                         this.strQuery = query;}
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    /*This method will change the owner date skipping the weekends*/
    /*public void changeOwnerDate(){
        if(day == 'Monday' || day == 'Tuesday' || day == 'Wednesday'){
          changeownerdate = system.now()-5;  //This is in addition to the checkmoddate for the owner to change.
        }
        else if(day == 'Thursday' || day == 'Friday'){
          changeownerdate = system.now()-3; //This is in addition to the checkmoddate for the owner to change.
        }
    }*/
    
    public Long gethrssincelastModified( Datetime LastModified)
    {
        Long  Hours_since_lastModifed = BusinessHours.diff (BusinessHours_Id, LastModified, System.now()) / 1000 / 60 / 60;
        
        if(Test.isRunningTest())
            Hours_since_lastModifed = hoursSinceLastModifiedUsedForTestClass ;                   
         
        return Hours_since_lastModifed;
    }
    
    /* This method prepares the scope of the batch programbased on the query result*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.debug('Executing Database.QueryLocator start');
        return Database.getQueryLocator(strQuery);
    }
    
    /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        system.debug('Started execute()....');
        List<Lead> updatelead= new List<Lead>();
        List<Lead> listlead=scope;
        
        for(Lead lead_alias:listlead)
        {
            system.debug('Lead1:' + lead_alias);
            System.debug('Lead id:'+ lead_alias.id + ' Lead Status:'+lead_alias.Status+' Lead ownerid:'+lead_alias.ownerid
                        + ' Lead zip:' + lead_alias.zip__c + ' Lead CreatedDate:' + lead_alias.CreatedDate + ' Lead New_Date_time__c:' + lead_alias.New_Date_time__c);
            
            lstDefaultUser = [select Id from User where lastname = :DEFAULT_USER AND IsActive = true Limit 1];
            
            DateTime modifiedDate;
            /*if(lead_alias.CreatedDate < lead_alias.New_Date_time__c)
                modifiedDate =  lead_alias.CreatedDate;
            else
                modifiedDate = lead_alias.New_Date_time__c;*/
            
            /*if(lead_alias.New_Date_time__c != null)            
            	modifiedDate = lead_alias.New_Date_time__c;            
            else
                modifiedDate =  lead_alias.CreatedDate;*/
            
            if( lead_alias.New_Date_time__c != null && 
           (lead_alias.CreatedDate == lead_alias.New_Date_time__c || lead_alias.CreatedDate < lead_alias.New_Date_time__c) )
                modifiedDate =  lead_alias.New_Date_time__c;           
            else 
                modifiedDate = lead_alias.CreatedDate;                                            
            system.debug('modifiedDate:'+modifiedDate);
            
            list <user> CurrentUser = [select id, manager.id from user where isactive=true and id =: lead_alias.ownerid and  manager.isactive = true Limit 1];
            
            system.debug('CurrentUser.size():' + CurrentUser.size());
            system.debug('gethrssincelastModified(modifiedDate):' + gethrssincelastModified(modifiedDate));
            
                       
            if(lstDefaultUser[0].id != lead_alias.ownerid && CurrentUser.size() == 1) 
            { 
                
                system.debug('CurrentUser.id:'+ CurrentUser[0].id + ' CurrentUser.manager.id:'+ CurrentUser[0].manager.id +
                             + ' lead_alias.Previous_User__c:' + lead_alias.Previous_User__c +
                ' Lead_72_Hr_Counter__c:' + lead_alias.Lead_72_Hr_Counter__c + ' gethrssincelastModified(modifiedDate):'
                            + gethrssincelastModified(modifiedDate));                              
                
                if((gethrssincelastModified(modifiedDate) > 48  && gethrssincelastModified(modifiedDate) < 72 && lead_alias.Lead_72_Hr_Counter__c == 0 ))
                {   
                    system.debug('Crossed 48 hrs but less than 72..........');                	
                    lead_alias.Lead_72_Hr_Counter__c = 1;                                               
                    lead_alias.Previous_User__c = CurrentUser[0].id;
                    lead_alias.ownerid= CurrentUser[0].Manager.id;
                    //lead_alias.Lead_72_Hr_Assigned_Date__C=System.now();
                    updatelead.add(lead_alias);  
                }
                //logcally this is > 72 (24 rs from level1 assignment)                   
                else if (gethrssincelastModified(modifiedDate) > 24  && lead_alias.Lead_72_Hr_Counter__c == 1.0) 
            	{ 
                    system.debug('Crossed 72 hrs......................');               	                    
                    lead_alias.Lead_72_Hr_Counter__c = 2;                                               
                    lead_alias.Previous_User__c = CurrentUser[0].id;
                    lead_alias.ownerid= CurrentUser[0].Manager.id;
					lead_alias.Lead_72_Hr_Assigned_Date__C=System.now();                                                                            
                    updatelead.add(lead_alias); 
            	}
                //to set the old data
                else if(gethrssincelastModified(modifiedDate) > 72  && lead_alias.Lead_72_Hr_Counter__c == 0)
                {
                    
                    system.debug('Crossed 72 hrs......but old data................');               	                    
                    lead_alias.Lead_72_Hr_Counter__c = 1;
                    lead_alias.Previous_User__c = CurrentUser[0].id;
                    lead_alias.ownerid= CurrentUser[0].Manager.id;
					lead_alias.Lead_72_Hr_Assigned_Date__C=System.now();                                                                            
                    updatelead.add(lead_alias); 
                }
                
            }
            
            system.debug('Ending execute()....');
            system.debug('updatelead list size():' + updatelead.size());
            
        }//end of for
        
        if(updatelead.size()>0)
        {
            //decimal i =1/0;
            update updatelead;
        }
    }
   
    
    /**This method must be there to implement Schedulable interface **/
    global void execute(SchedulableContext sc)
    {
        String strquery = 'Select id,New_Date_time__c,Lead_72_Hour_Reassignment__c,Lead_72_Hr_Assigned_Date__C,Lead_72_Hr_Counter__c,Zip__c,Industry,Industry_Code__c,lastmodifieddate,Status,LeadSource,Change_Owner__c,ownerid,Send_Email_To_Owner__c,Previous_User__c,Send_Email_To_Previous_Owner__c,CreatedDate, Lead_Age__c, Owner.UserRole.Name from lead where Status=\'Open\' and recordtype.DeveloperName = \'Lead_Canada\' and Lead_72_Hr_Counter__c < 2 and WCW_Count__c > 100';
        
        Reassign_GTLead_Owner assignBatch1 = new Reassign_GTLead_Owner(strQuery);
        database.executebatch(assignBatch1, 10);
    }
    
     
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        
    }
    
}