global class AccountAssignments implements database.Batchable<Sobject>, Schedulable

{ 
    Integer BatchSize = 500;
    Integer UserNumber = 1;
     public String strQueryac;
     
    /* Default Constructor*/
    global AccountAssignments(){
        System.debug('Default Constructor Called');
         this.BatchSize = ReadBatchSize();
         this.UserNumber = ReadUserNumber();
         //changeUserStatus();
         //restErrorHandler();
          this.strQueryac = 'select id from account limit 1';
    }
    /*This costructor is called from the Batch Schedule mathod*/
    global AccountAssignments(String query){
        System.debug('Constructor B Called');
        System.debug('QUEERY IS---->'+query);
        this.BatchSize = ReadBatchSize();
        this.UserNumber = ReadUserNumber();
        //restErrorHandler();
         this.strQueryac = 'select id from account limit 1';
       
    }
    
    
    global Integer ReadUserNumber(){ 
        list<Admin_Config__c> ac = [SELECT  id, ActivateUserCount__c from Admin_Config__c];
        return integer.valueof(ac[0].ActivateUserCount__c);
    }

    global Integer ReadBatchSize(){
        list<Admin_Config__c> ac = [SELECT  id, BatchSize__c from Admin_Config__c];
        return integer.valueof(ac[0].BatchSize__c);
    }

    
      global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        //System.debug('EXECUTE A is Called');
        //launchAccountAssignmentBatches();
    }
    
    /* This method prepares the scope of the batch programbased on the query result*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
     
       return Database.getQueryLocator(strQueryac);
    }
    

    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        // not required
    }
    
    global Set<Id> DeactivateUsers(){
        Set<Id> ActivateByBatchYesterday = new Set<Id>(); // Activate by Batch Yesterday - Deactivate It first      
        for(User u : [select Id, ActivatedbyBatch__c, IsActive from user where ActivatedbyBatch__c = true ]){
            //u.IsActive = false;
            //u.ActivatedbyBatch__c = false;
            ActivateByBatchYesterday.add(u.id);
        }
        return ActivateByBatchYesterday;
    }
 
    
    
    
    global Set<Id> ActivateUsersToday(){
        Set<Id> ToActivate = new Set<Id>();// Qualifing Users to get activated today
        /* ===============Activate the Users for Todays Batch ===========================*/
            Map<String,Schema.RecordTypeInfo> ErrorTrackerRecType = Schema.SObjectType.ErrorTracker__c.getRecordTypeInfosByName();
        Set<String> SetEmpIds = new Set<String>();
        String ErrorRecordId = ErrorTrackerRecType.get('Assignment').getRecordTypeId();
        Map<String, ErrorTracker__c> UniqueEMPMAP = new Map<String, ErrorTracker__c>();
        for(ErrorTracker__c et:[SELECT Id,UserId__c,Ispurged__c from ErrorTracker__c where recordTypeId =:ErrorRecordId and Ispurged__c = false ]){     // for last day's purged records.
            if(UniqueEMPMAP.get(et.UserId__c) == null ) {
                UniqueEMPMAP.put(et.UserId__c, et);
            }
        }
        
        list<Admin_Config__c> ac = [SELECT  id, ActivateUserCount__c from Admin_Config__c];        
        Integer Ucount = integer.valueof(ac[0].ActivateUserCount__c);
        //ReadUserNumber(); // This should be variable coming from custom Settings
        String A = 'SELECT  UserId__c,  Sum(Customer_Failure__c) CF , SUM(Customer_Site_Failure__c) SF,  SUM(Prospect_Failure__c) PF, Sum(Prospect_Site_Failure__c) PSF, Sum(O_Customer_Failure__c) OCF, SUM(O_Customer_Site_Failure__c) OSF,  SUM(O_Prospect_Failure__c) OPF, Sum(O_Prospect_Site_Failure__c) OPSF from ErrorTracker__c where IsPurged__c = false  GROUP BY UserId__c order by SUM(O_Customer_Site_Failure__c) DESC';
        List<sObject> OE = Database.query(A +' limit '+Ucount);
        Set<String> uEMPID = new Set<String>();
        for(Integer E =0;E<OE.size();E++){           
            uEMPID.add(String.ValueOf(OE[E].get('UserId__c')));
        }
        List<User> userlist_Inactive = new List<User>();
        if(uEMPID.size()>0){
            userlist_Inactive = [Select Id, ActivatedbyBatch__c,OD_Employee_ID__c, IsActive from User where IsActive=false and OD_Employee_ID__c IN :uEMPID ];
        }

        for(User USR: userlist_Inactive){
            //USR.IsActive = true;
            //USR.ActivatedbyBatch__c = true;
            //ActivateByBatchYesterday.add(USR);
            ToActivate.add(USR.Id);
        }
        
        return ToActivate;
    
    
    }
    
    @future 
   static void USERSSTATUSUPDATE(Set<Id> userstobeDeActivated_S, Set<Id> UsertobeActivatedTodat_S){
       System.debug('FUTURE===userstobeDeActivated_S '+userstobeDeActivated_S .size());
       System.debug('FUTURE===UsertobeActivatedTodat_S'+UsertobeActivatedTodat_S.size());
       
       //Deactivating the Yesterday Activated users
       if(userstobeDeActivated_S.size()>0){
            List<User> deactivate_lst = [select Id,ActivatedbyBatch__c, IsActive from user where Id in :userstobeDeActivated_S];
            if(deactivate_lst.size()>0){
                for(User u : deactivate_lst){
                    u.IsActive = false;
                    u.ActivatedbyBatch__c = false;
                }
            }
            System.debug('FUTURE TOUPDATE===deactivate_lst'+deactivate_lst.size());
            update deactivate_lst;
            
        }
        //Activate for Today's Batch
        if(UsertobeActivatedTodat_S.size()>0){
            List<User> activate_lst = [select Id,ActivatedbyBatch__c, IsActive from user where Id in :UsertobeActivatedTodat_S];
            if(activate_lst.size()>0){
                for(User ua : activate_lst){
                    ua.IsActive = true;
                    ua.ActivatedbyBatch__c = true;
                }
            }
            System.debug('FUTURE TOUPDATE===activate_lst'+activate_lst.size());
            update activate_lst;
            
        }
        
   }
   
   global void  restErrorHandler(){
        Map<String,Schema.RecordTypeInfo> ErrorTrackerRecType = Schema.SObjectType.ErrorTracker__c.getRecordTypeInfosByName();
        String ErrorRecordId = ErrorTrackerRecType.get('Assignment').getRecordTypeId();
        list<ErrorTracker__c> lError = [SELECT Id,Ispurged__c from ErrorTracker__c where recordTypeId =:ErrorRecordId and Ispurged__c = false ];
        for(ErrorTracker__c e :lError ){
            e.Ispurged__c = true;
        }
        update lError;

    }

    global void execute(SchedulableContext sc){

       Set<Id> userstobeDeActivated_S =  DeactivateUsers();
       Set<Id> UsertobeActivatedTodat_S = ActivateUsersToday();
       System.debug('EXECUTE===userstobeDeActivated_S '+userstobeDeActivated_S .size());
       System.debug('EXECUTE===UsertobeActivatedTodat_S'+UsertobeActivatedTodat_S.size());
       if(!Test.isRunningTest()){
           USERSSTATUSUPDATE(userstobeDeActivated_S, UsertobeActivatedTodat_S);
       } 
       
       restErrorHandler();

        String strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,'
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c, Status__c, Error_Message__c '
                            +' from AccountAssignments__c where  Status__c != \'Processed\'    and (Name Like \'%0\' OR Name Like \'%1\' )';
        AccountAssignments_Batch assignBatch1 = new AccountAssignments_Batch(strQuery);
        database.executebatch(assignBatch1, BatchSize);

        strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,'
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c, Status__c, Error_Message__c '
                            +' from AccountAssignments__c where  Status__c != \'Processed\'   and (Name Like \'%3\' OR Name Like \'%4\')';
        AccountAssignments_Batch assignBatch2 = new AccountAssignments_Batch(strQuery);
        database.executebatch(assignBatch2, BatchSize);
        strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,'
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c, Status__c, Error_Message__c '
                            +' from AccountAssignments__c where  Status__c != \'Processed\'    and (Name Like \'%6\' OR Name Like \'%7\')';
        AccountAssignments_Batch assignBatch3 = new AccountAssignments_Batch(strQuery);
        database.executebatch(assignBatch3, BatchSize);
        strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,'
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c, Status__c, Error_Message__c '
                            +' from AccountAssignments__c where  Status__c != \'Processed\'   and (Name Like \'%8\' OR Name Like \'%9\')';
        AccountAssignments_Batch assignBatch4 = new AccountAssignments_Batch(strQuery);
        database.executebatch(assignBatch4, BatchSize);
          strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,'
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c, Status__c, Error_Message__c '
                            +' from AccountAssignments__c where  Status__c != \'Processed\'    and (Name Like \'%2\' OR Name Like \'%5\')';
        AccountAssignments_Batch assignBatch5 = new AccountAssignments_Batch(strQuery);
        database.executebatch(assignBatch5, BatchSize);
  

    } 
    
 
    
    
}