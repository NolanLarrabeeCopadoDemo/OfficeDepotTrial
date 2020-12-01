/***
Description: This Is a batch Apex program. Scope of this is the AccountAssignment__c object records with 'Open' status.
Functionality of the Batch program is:
1. Primary Rep on the Assigment record is set as Owner of the Acocunt record.
2. Matching and Active User records are querried for the Overlay Rep Ids
3. It is assumed/confirmed that Assignment record have latest Acocunt Team, if user is already on the Account Team but not in this Assignment record that user will be removed from the Account Team.
   Also if User is present already on Account team but role has changed then old team member is removed and new team member is inserted.
4. If at least one User record is not found for Overlay Rep on teh Assignment record, teh status of assignment record is set as 'Error'.
5. if one or more matching/ Active user record not foudn for amongst Overlay Reps on Assoignment record then status of Assignment record is set as 'Partially Processed'.
6. If Active Matching user record  found for all Overlay reps on assignment record, then status is set as  'Processed'.
7. Numeric 'Role Related Id' is set as 'Role' on the Account Team Member for Overlay Rep.
8.   

This single class implemnets both interfaces Batchable and Schedulable.
Description: The Scope of this AccountTeamAssignment Object for Grand & Toy recordtype.

Created By: Wipro
Created Date: 29-07-2014

  
**/
global class GT_AccAssignment_Batch implements database.Batchable<Sobject>, Schedulable
{
    private Integer inactiveEmpCount = 0;
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    
    // below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c,Status__c, Error_Message__c'
                            +' from AccountAssignments__c where Status__c = \'Open\' and RecordTypeId =\''+Label.Account_Assignment_GT+'\' and createddate >= yesterday';     
    

    /* Default Constructor*/
    global GT_AccAssignment_Batch()
    {
    }
    
    /*This costructor is called from the Batch Schedule mathod*/
    global GT_AccAssignment_Batch(String query)
    {
        System.debug('QUEERY IS---->'+query);
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
        //Record the Error's found - New Code
        String BatchId = BC.getJobId();
        System.debug('BatchID @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+BatchId);
        Map<String,Schema.RecordTypeInfo> ErrorTrackerRecType = Schema.SObjectType.ErrorTracker__c.getRecordTypeInfosByName();
        String ErrorRecordId = ErrorTrackerRecType.get('Assignment').getRecordTypeId();
        String ErrorCode = '';
        
        list<ErrorTracker__c> lError = [SELECT Id, Name, RecordTypeId,  BatchId__c, Customer_Failure__c, Customer_Site_Failure__c, Ispurged__c, Prospect_Failure__c, Prospect_Site_Failure__c, UserId__c, O_Customer_Failure__c, O_Customer_Site_Failure__c, O_Prospect_Failure__c, O_Prospect_Site_Failure__c from ErrorTracker__c where recordTypeId =:ErrorRecordId and BatchId__c =:BatchId];
        Map<String, ErrorTracker__c> mapErrorTracker =  new Map<String, ErrorTracker__c>();
        for(ErrorTracker__c e :lError){
            mapErrorTracker.put(e.UserId__c , e);
        }
        

        List<AccountAssignments__c> lstAssignments = scope;
        Set<String> GT_Entityid= new Set<String>();
        Set<String> setRoleRelatedIds = new Set<String>(); // set of Role related ids
        Set<String> setEmpIds = new Set<String>(); // this set to store OD employee Id to select user records
        /*
        Set<String> setAccountIds = new Set<String>(); // Acocunts Ids from the Assignments Batch
        Set<String> setSiteIds = new Set<String>(); // Site Ids from the Assignments Batch
        Set<String> setPartyIds = new Set<String>(); // Party Ids from the Assignments Batch
        Set<String> setPartySiteIds = new Set<String>(); // Party Site Ids from the Assignments Batch
        Set<String> setAopsCustIds = new Set<String>(); // AOPS Cust Ids from the Assignments Batch
        Set<String> setAopsSeqIds = new Set<String>(); // AOPS Seq Ids from the Assignments Batch       
        Set<string> entityid_no_change = new Set<string> ();// set of entity id in which there is no change of assignment*/
        
        try
        {
            // loop on the batch scope   
            for(AccountAssignments__c objAssignment: lstAssignments)
            {
                
                // If by chance AccounId__c field is null or blank, skip the record
                if(objAssignment.Entity_Id__c != null && objAssignment.Entity_Id__c != '')
                {

                    GT_Entityid.add(objAssignment.Entity_Id__c);
                    /*if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'PROSPECT'){ // Prospect Account record so Party Id of Account
                        setPartyIds.add(objAssignment.Entity_Id__c);
                        
                    }
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'PROSPECT'){ //Prospect Site record so Party Site Id of Account
                        setPartySiteIds.add(objAssignment.Entity_Id__c);
                        
                    }
                    if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'CUSTOMER') {// Customer Account record so AOPS cust id of Account
                        setAopsCustIds.add(objAssignment.Entity_Id__c);
                        
                    }
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'CUSTOMER'){ //Customer Site record so AOPS seq Id of Account
                        setAopsSeqIds.add(objAssignment.Entity_Id__c);
                        
                    }*/

                    // Sales Person Id, to be set on Account record
                    //if(objAssignment.PrimaryEmpRole__c != null && objAssignment.PrimaryEmpRole__c != '')
                        //setRoleRelatedIds.add(objAssignment.PrimaryEmpRole__c);
                    
                    //Add Primary rep Id to the Set 
                    if(objAssignment.PrimaryEmpId__c != null && objAssignment.PrimaryEmpId__c != '')
                    {
                        setEmpIds.add(objAssignment.PrimaryEmpId__c);
                        setRoleRelatedIds.add(objAssignment.PrimaryEmpId__c);
                    }
                    for(Integer k =1;k<=30;k++){                            
                        String Obj_OverlayEMPID = 'OverlayEmpID'+k+'__c';
                        if((objAssignment.get(Obj_OverlayEMPID) != null) &&(objAssignment.get(Obj_OverlayEMPID) != '')){
                            setEmpIds.add(String.valueOf(objAssignment.get(Obj_OverlayEMPID)));                                   
                        }                        
                    }
                        
                    
                   /* Replace the Below code with Above For Loop - Mohan 
                   // Add Overlay rep Id to the set
                    if(objAssignment.OverlayEmpID1__c != null && objAssignment.OverlayEmpID1__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID1__c);
                    if(objAssignment.OverlayEmpID2__c != null && objAssignment.OverlayEmpID2__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID2__c);
                    if(objAssignment.OverlayEmpID3__c != null && objAssignment.OverlayEmpID3__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID3__c);
                    if(objAssignment.OverlayEmpID4__c != null && objAssignment.OverlayEmpID4__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID4__c);
                    if(objAssignment.OverlayEmpID5__c != null && objAssignment.OverlayEmpID5__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID5__c);
                    if(objAssignment.OverlayEmpID6__c != null && objAssignment.OverlayEmpID6__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID6__c);                
                    if(objAssignment.OverlayEmpID7__c != null && objAssignment.OverlayEmpID7__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID7__c);                
                    if(objAssignment.OverlayEmpID8__c != null && objAssignment.OverlayEmpID8__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID8__c);                
                    if(objAssignment.OverlayEmpID9__c != null && objAssignment.OverlayEmpID9__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID9__c);                
                    if(objAssignment.OverlayEmpID10__c != null && objAssignment.OverlayEmpID10__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID10__c);                
                    if(objAssignment.OverlayEmpID11__c != null && objAssignment.OverlayEmpID11__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID11__c);                
                    if(objAssignment.OverlayEmpID12__c != null && objAssignment.OverlayEmpID12__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID12__c);                
                    if(objAssignment.OverlayEmpID13__c != null && objAssignment.OverlayEmpID13__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID13__c);                
                    if(objAssignment.OverlayEmpID14__c != null && objAssignment.OverlayEmpID14__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID14__c);                
                    if(objAssignment.OverlayEmpID15__c != null && objAssignment.OverlayEmpID15__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID15__c);
                        
                    if(objAssignment.OverlayEmpID16__c != null && objAssignment.OverlayEmpID16__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID16__c);
                    if(objAssignment.OverlayEmpID17__c != null && objAssignment.OverlayEmpID17__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID17__c);
                    if(objAssignment.OverlayEmpID18__c != null && objAssignment.OverlayEmpID18__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID18__c);
                    if(objAssignment.OverlayEmpID19__c != null && objAssignment.OverlayEmpID19__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID19__c);
                    if(objAssignment.OverlayEmpID20__c != null && objAssignment.OverlayEmpID20__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID20__c);
                    if(objAssignment.OverlayEmpID21__c != null && objAssignment.OverlayEmpID21__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID21__c);                
                    if(objAssignment.OverlayEmpID22__c != null && objAssignment.OverlayEmpID22__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID22__c);                
                    if(objAssignment.OverlayEmpID23__c != null && objAssignment.OverlayEmpID23__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID23__c);                
                    if(objAssignment.OverlayEmpID24__c != null && objAssignment.OverlayEmpID24__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID24__c);                
                    if(objAssignment.OverlayEmpID25__c != null && objAssignment.OverlayEmpID25__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID25__c);                
                    if(objAssignment.OverlayEmpID26__c != null && objAssignment.OverlayEmpID26__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID26__c);                
                    if(objAssignment.OverlayEmpID27__c != null && objAssignment.OverlayEmpID27__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID27__c);                
                    if(objAssignment.OverlayEmpID28__c != null && objAssignment.OverlayEmpID28__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID28__c);                
                    if(objAssignment.OverlayEmpID29__c != null && objAssignment.OverlayEmpID29__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID29__c);                
                    if(objAssignment.OverlayEmpID30__c != null && objAssignment.OverlayEmpID30__c != '')
                        setEmpIds.add(objAssignment.OverlayEmpID30__c); 
                                     
                    */
                }// if(objAssignment.Entity_Id__c != null && objAssignment.Entity_Id__c != '')
            }//for(AccountAssignments__c objAssignment: lstAssignments)
    
            Map<String,Sales_Person__c> mapId2SalesPersons = new Map<String,Sales_Person__c>();
            
            System.debug('::: salesRepKeys:::'+setRoleRelatedIds);
            for(Sales_Person__c sRep: [select id, Role_Relate_Id__c,ODP_Employee_Id__c From Sales_Person__c  where ODP_Employee_Id__c in :setRoleRelatedIds and IsActive__c=true and Primary__c=true]) 
            {
                mapId2SalesPersons.put(sRep.ODP_Employee_Id__c,sRep);
            }
          
            //List<User> lstAllReps = [select id, OD_Employee_ID__c from User where OD_Employee_ID__c in :setEmpIds];
            Map<String, User> mapEmpId2User = new Map<String, User>(); // Map to store OD employee Id as Key and User record as value
            // query Active Users and create map with OD EMployee Id as Key
            for(User usr: [select id, OD_Employee_ID__c from User where OD_Employee_ID__c in :setEmpIds and isActive = true])
            {
                mapEmpId2User.put(usr.OD_Employee_ID__c, usr);
            }
            
            // 
//          Map<ID, Account> mapAccounts = new Map<ID, Account>([select id, ownerId, RecordTypeId, Oracle_Party_Id__c, Oracle_Party_Site_Id__c from Account where Oracle_Party_Id__c in : setAccountIds OR Oracle_Party_Site_Id__c in :setSiteIds]);
            /*Map<ID, Account> mapAccounts = new Map<ID, Account>([select id,Sales_PersonID__c, 
            ownerId, RecordTypeId, Oracle_Party_Id__c, Oracle_Party_Site_Id__c, 
            AOPS_Cust_Id__c, AOPS_Seq_ID__c from Account where
            Oracle_Party_Id__c in : setPartyIds OR Oracle_Party_Site_Id__c in :setPartySiteIds OR 
            AOPS_Cust_Id__c in :setAopsCustIds OR AOPS_Seq_ID__c in :setAopsSeqIds ]);*/
            
            //modified for Canada
            
            Map<ID, Account> mapAccounts = new Map<ID, Account>([select id,Sales_PersonID__c, 
            ownerId, RecordTypeId, OMX_Primary_Key__c from Account where
            OMX_Primary_Key__c in : GT_Entityid  ]);
            
                 
            
//          Map<String, Account> mapAccId2Account = new map<String, Account>(); // so easy to find Account record based on AccountID
//          Map<String, Account> mapSiteId2Account = new map<String, Account>();// so easy to find Account record based on SiteID
            /*Map<String, Account> mapPartyId2Account = new map<String, Account>(); // so easy to find Account record based on PartyID
            Map<String, Account> mapPartySiteId2Account = new map<String, Account>();// so easy to find Account record based on PartySiteID
            Map<String, Account> mapCustId2Account = new map<String, Account>(); // so easy to find Account record based on AOPS Cust Id
            Map<String, Account> mapSeqId2Account = new map<String, Account>();// so easy to find Account record based on AOPS Seq Id*/
            Map<String,Account> GT_AccountAndOMXKey = new Map<String,Account>();

            for(Account acc: mapAccounts.values())
            {
/*              if(acc.Oracle_Party_ID__c != null && acc.Oracle_Party_ID__c != '')
                    mapAccId2Account.put(acc.Oracle_Party_ID__c, acc);
                if(acc.Oracle_Party_Site_Id__c != null && acc.Oracle_Party_Site_Id__c != '')
                    mapSiteId2Account.put(acc.Oracle_Party_Site_Id__c, acc); */
                    
                    
                 //changed for Canada   
                if(acc.OMX_Primary_Key__c != null && acc.OMX_Primary_Key__c != '')
                {
                    GT_AccountAndOMXKey.put(acc.OMX_Primary_Key__c, acc);
                }
                    //mapPartyId2Account.put(acc.OMX_Primary_Key__c, acc);
                    
                    
                    
               /* if(acc.Oracle_Party_Site_Id__c != null && acc.Oracle_Party_Site_Id__c != '')
                    mapPartySiteId2Account.put(acc.Oracle_Party_Site_Id__c, acc);
                if(acc.AOPS_Cust_Id__c != null && acc.AOPS_Cust_Id__c != '')
                    mapCustId2Account.put(acc.AOPS_Cust_Id__c, acc);
                if(acc.AOPS_Seq_ID__c != null && acc.AOPS_Seq_ID__c != '')
                    mapSeqId2Account.put(acc.AOPS_Seq_ID__c, acc);*/
            }
            
            List<Account> accountOwnerUpdate = new List<Account>(); // List fo Accounts for which Account Owner is getting updated by Primary Rep
            Map<Id, Map<Id, AccountTeamMember>> acctId2UserTeamMap = new Map<Id, Map<Id, AccountTeamMember>>(); // map of Account Id as key & map of UserId/ AccountTeamMember
            
            List<AccountAssignments__c> updateAssignments = new List<AccountAssignments__c>(); // List to hold assigment records to update status
            Map<Id,Id> accIdOwnerIdMap = new Map<Id,Id>();
             
            for(AccountAssignments__c objAssignment: lstAssignments)
            {
                inactiveEmpCount = 1;
                String strErrorMessage = '';
                String recType='';
                Account acct;
                // If by chance AccounId__c field is null or blank, skip the record
                if(objAssignment.Entity_Id__c != null && objAssignment.Entity_Id__c != '')
                {
                    System.debug('ENTITY ID  ==='+objAssignment.Entity_Id__c);

                    /*if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'PROSPECT'){ // Prospect Account record so Account Id
                        acct = mapPartyId2Account.get(objAssignment.Entity_Id__c);
                        recType = 'P';
                    }
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'PROSPECT'){ //Prospect  Site record so Site Id
                        acct = mapPartySiteId2Account.get(objAssignment.Entity_Id__c);
                        recType = 'PS';
                    }
                    if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'CUSTOMER'){ // Customer Account record so Account Id
                        acct = mapCustId2Account.get(objAssignment.Entity_Id__c);
                        recType = 'C';
                    }
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'CUSTOMER'){ //Customer Site record so Site Id
                        acct = mapSeqId2Account.get(objAssignment.Entity_Id__c);
                        recType = 'CS';
                    }*/
                    if(objAssignment.Entity_Id__c!=null)
                    {
                        acct= GT_AccountAndOMXKey.get(objAssignment.Entity_Id__c);
                    }
                        
                    //System.debug('The account is---->'+acct);
                  //objAssignment.status__c= 'TEST'; 
                    if(acct != null)
                    {
                        accIdOwnerIdMap.put(acct.id, acct.OwnerId); // new code to avoid deleting old accocunt owner share record
                        // Sales Person Id, to be set on Account record
                        
                        //Add Primary rep Id to the Set 
                        User empUser;
                        System.debug('PRIMARY Rep Id ==='+objAssignment.PrimaryEmpId__c);
                        if(objAssignment.PrimaryEmpId__c != null && objAssignment.PrimaryEmpId__c != '')
                            empUser = mapEmpId2User.get(objAssignment.PrimaryEmpId__c);
                        
                        if(empUser != null)
                        {
                        system.debug('@@@@----'+mapId2SalesPersons.get(objAssignment.PrimaryEmpId__c));
                         if(mapId2SalesPersons.get(objAssignment.PrimaryEmpId__c) != null)   
                            {
                            system.debug('@@@@----'+acct.OwnerId+'@@@@----'+empUser.Id+'@@@@----'+acct.Sales_PersonID__c+'@@@@----'+(mapId2SalesPersons.get(objAssignment.PrimaryEmpId__c).id));
                            if(acct.OwnerId != empUser.Id || acct.Sales_PersonID__c != mapId2SalesPersons.get(objAssignment.PrimaryEmpId__c).id)
                            {
                                acct.OwnerId = empUser.Id;
                              Sales_Person__c sPerson;
                                if(objAssignment.PrimaryEmpId__c != null && objAssignment.PrimaryEmpId__c != '')
                                    sPerson = mapId2SalesPersons.get(objAssignment.PrimaryEmpId__c);
                                
                                if(sPerson != null)
                                    acct.Sales_PersonID__c = sPerson.Id;
                                else{
                                    
                                    strErrorMessage += ' '+'Not able to find Sales Person Id for Primary Employee Id '+objAssignment.PrimaryEmpId__c+'.';
                                    /* Error Codes - Mohan*/
                                    if(mapErrorTracker.get(objAssignment.PrimaryEmpId__c) != null){
                                        if(recType =='P'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Prospect_Failure__c++;}
                                        if(recType =='PS'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Prospect_Site_Failure__c++;}
                                        if(recType =='CS'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Customer_Site_Failure__c++;}
                                        if(recType =='C'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Customer_Failure__c++;}
                                        }
                                    else{
                                        ErrorTracker__c e = new ErrorTracker__c();
                                        e.RecordTypeId = ErrorRecordId;
                                        e.BatchId__c = BatchId;
                                        e.UserId__c = objAssignment.PrimaryEmpId__c;
                                        if(recType =='P'){e.Prospect_Failure__c=1;}
                                        if(recType =='PS'){e.Prospect_Site_Failure__c=1;}
                                        if(recType =='CS'){e.Customer_Site_Failure__c=1;}
                                        if(recType =='C'){e.Customer_Failure__c=1;}                                      
                                        mapErrorTracker.put(objAssignment.PrimaryEmpId__c,e);
                                    }
                                    /* End Error Codes - Mohan*/
                                
                                }
                                // add to list for account to update owner id
                                accountOwnerUpdate.add(acct);   
                            }
                            }
                            else 
                            {
                               strErrorMessage += ' '+'Not able to find Sales Person Id for Primary Employee Id '+objAssignment.PrimaryEmpId__c+'.';
                               /* Error Codes - Mohan*/
                                    if(mapErrorTracker.get(objAssignment.PrimaryEmpId__c) != null){
                                            if(recType =='P'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Prospect_Failure__c++;}
                                            if(recType =='PS'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Prospect_Site_Failure__c++;}
                                            if(recType =='CS'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Customer_Site_Failure__c++;}
                                            if(recType =='C'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Customer_Failure__c++;}
                                    }
                                    else{
                                        ErrorTracker__c e = new ErrorTracker__c();
                                        e.RecordTypeId = ErrorRecordId;
                                        e.BatchId__c = BatchId;
                                        e.UserId__c = objAssignment.PrimaryEmpId__c;
                                        if(recType =='P'){e.Prospect_Failure__c=1;}
                                        if(recType =='PS'){e.Prospect_Site_Failure__c=1;}
                                        if(recType =='CS'){e.Customer_Site_Failure__c=1;}
                                        if(recType =='C'){e.Customer_Failure__c=1;} 
                                        mapErrorTracker.put(objAssignment.PrimaryEmpId__c,e);
                                    }
                                    /* End Error Codes - Mohan*/
                            }
                        }
                        else{
                            strErrorMessage += ' '+'Account Owner was not updated as not able to find User record for Primary Rep Id '+objAssignment.PrimaryEmpId__c+', user may be inactive.';
                                    /* Error Codes - Mohan*/
                                    if(mapErrorTracker.get(objAssignment.PrimaryEmpId__c) != null){
                                        if(recType =='P'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Prospect_Failure__c++;}
                                        if(recType =='PS'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Prospect_Site_Failure__c++;}
                                        if(recType =='CS'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Customer_Site_Failure__c++;}
                                        if(recType =='C'){mapErrorTracker.get(objAssignment.PrimaryEmpId__c).Customer_Failure__c++;}
                                    }
                                    else{
                                        ErrorTracker__c e = new ErrorTracker__c();
                                        e.RecordTypeId = ErrorRecordId;
                                        e.BatchId__c = BatchId;
                                        e.UserId__c = objAssignment.PrimaryEmpId__c;
                                        if(recType =='P'){e.Prospect_Failure__c=1;}
                                        if(recType =='PS'){e.Prospect_Site_Failure__c=1;}
                                        if(recType =='CS'){e.Customer_Site_Failure__c=1;}
                                        if(recType =='C'){e.Customer_Failure__c=1;} 
                                        mapErrorTracker.put(objAssignment.PrimaryEmpId__c,e);
                                    }
                                    /* End Error Codes - Mohan*/
                        }
                        String strErrorMessage1 = '';
                        
                        List<Overlay> oOverlayLst = new List<Overlay>();
                        //Creating the List for Further USE
                        for(Integer i =1;i<=30;i++){
                            
                            String OverlayEMPID = 'OverlayEmpID'+i+'__c';
                            String OverlayRoleID = 'OverlayEmpRole'+i+'__c';
                            
                            if((objAssignment.get(OverlayEMPID) != null) &&(objAssignment.get(OverlayEMPID) != '')){
                                Overlay oOverlay = new Overlay();
                                oOverlay.Sequence = i;
                                oOverlay.oEMPID =  String.valueOf(objAssignment.get(OverlayEMPID));
                                oOverlay.oEMPROLE = String.valueOf(objAssignment.get(OverlayRoleID));
                                oOverlayLst.add(oOverlay);
                            }
                        
                        }
                        
                        for(Integer p =0;p<oOverlayLst.size();p++){
                            String e = checkAndAddOverlay(objAssignment, oOverlayLst[p].Sequence, acct.Id, oOverlayLst[p].oEMPID,  oOverlayLst[p].oEMPROLE, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                            if(e.trim() != ''){
                                strErrorMessage1 += ' '+e;
                                //Error with this overlay so record It
                                /* Error Codes - Mohan*/
                                    if(mapErrorTracker.get(oOverlayLst[p].oEMPID) != null){
                                        if(recType =='P'){mapErrorTracker.get(oOverlayLst[p].oEMPID).O_Prospect_Failure__c++;}
                                        if(recType =='PS'){mapErrorTracker.get(oOverlayLst[p].oEMPID).O_Prospect_Site_Failure__c++;}
                                        if(recType =='CS'){mapErrorTracker.get(oOverlayLst[p].oEMPID).O_Customer_Site_Failure__c++;}
                                        if(recType =='C'){mapErrorTracker.get(oOverlayLst[p].oEMPID).O_Customer_Failure__c++;}
                                    }
                                    else{
                                        ErrorTracker__c et = new ErrorTracker__c();
                                        et.RecordTypeId = ErrorRecordId;
                                        et.BatchId__c = BatchId;
                                        et.UserId__c = oOverlayLst[p].oEMPID;
                                        if(recType =='P'){et.O_Prospect_Failure__c=1;}
                                        if(recType =='PS'){et.O_Prospect_Site_Failure__c=1;}
                                        if(recType =='CS'){et.O_Customer_Site_Failure__c=1;}
                                        if(recType =='C'){et.O_Customer_Failure__c=1;} 
                                        mapErrorTracker.put(oOverlayLst[p].oEMPID,et);
                                    }
                                    /* End Error Codes - Mohan*/
                                
                                
                            }
                        }
                        
                        /*
                        Replace the Below Code with above For Loop - Mohan
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 1, acct.Id, objAssignment.OverlayEmpID1__c, objAssignment.OverlayEmpRole1__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);                                              
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 2, acct.Id, objAssignment.OverlayEmpID2__c, objAssignment.OverlayEmpRole2__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 3, acct.Id, objAssignment.OverlayEmpID3__c, objAssignment.OverlayEmpRole3__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 4, acct.Id, objAssignment.OverlayEmpID4__c, objAssignment.OverlayEmpRole4__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 5, acct.Id, objAssignment.OverlayEmpID5__c, objAssignment.OverlayEmpRole5__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 6, acct.Id, objAssignment.OverlayEmpID6__c, objAssignment.OverlayEmpRole6__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 7, acct.Id, objAssignment.OverlayEmpID7__c, objAssignment.OverlayEmpRole7__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 8, acct.Id, objAssignment.OverlayEmpID8__c, objAssignment.OverlayEmpRole8__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 9, acct.Id, objAssignment.OverlayEmpID9__c, objAssignment.OverlayEmpRole9__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 10, acct.Id, objAssignment.OverlayEmpID10__c, objAssignment.OverlayEmpRole10__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 11, acct.Id, objAssignment.OverlayEmpID11__c, objAssignment.OverlayEmpRole11__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 12, acct.Id, objAssignment.OverlayEmpID12__c, objAssignment.OverlayEmpRole12__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 13, acct.Id, objAssignment.OverlayEmpID13__c, objAssignment.OverlayEmpRole13__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 14, acct.Id, objAssignment.OverlayEmpID14__c, objAssignment.OverlayEmpRole14__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 15, acct.Id, objAssignment.OverlayEmpID15__c, objAssignment.OverlayEmpRole15__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 16, acct.Id, objAssignment.OverlayEmpID16__c, objAssignment.OverlayEmpRole16__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 17, acct.Id, objAssignment.OverlayEmpID17__c, objAssignment.OverlayEmpRole17__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 18, acct.Id, objAssignment.OverlayEmpID18__c, objAssignment.OverlayEmpRole18__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 19, acct.Id, objAssignment.OverlayEmpID19__c, objAssignment.OverlayEmpRole19__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 20, acct.Id, objAssignment.OverlayEmpID20__c, objAssignment.OverlayEmpRole20__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 21, acct.Id, objAssignment.OverlayEmpID21__c, objAssignment.OverlayEmpRole21__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 22, acct.Id, objAssignment.OverlayEmpID22__c, objAssignment.OverlayEmpRole22__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 23, acct.Id, objAssignment.OverlayEmpID23__c, objAssignment.OverlayEmpRole23__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 24, acct.Id, objAssignment.OverlayEmpID24__c, objAssignment.OverlayEmpRole24__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 25, acct.Id, objAssignment.OverlayEmpID25__c, objAssignment.OverlayEmpRole25__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 26, acct.Id, objAssignment.OverlayEmpID26__c, objAssignment.OverlayEmpRole26__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 27, acct.Id, objAssignment.OverlayEmpID27__c, objAssignment.OverlayEmpRole27__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 28, acct.Id, objAssignment.OverlayEmpID28__c, objAssignment.OverlayEmpRole28__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 29, acct.Id, objAssignment.OverlayEmpID29__c, objAssignment.OverlayEmpRole29__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage1 += ' '+checkAndAddOverlay(objAssignment, 30, acct.Id, objAssignment.OverlayEmpID30__c, objAssignment.OverlayEmpRole30__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                       */

                       if(strErrorMessage1.trim() != '')
                            strErrorMessage1 = ' Not able to find User record for Overlay Rep, user may be inactive.';
                        strErrorMessage = strErrorMessage + strErrorMessage1;
   
                    }
                    else
                    {
                    
                        strErrorMessage += ' '+'Not able to find SFDC Account record for Entity Id.';
                        
                    }
                }
                
                strErrorMessage = strErrorMessage.trim();
                System.debug('ERROR IF ANY == '+strErrorMessage);
                
                //populate the Account ID into the Lookup field -- mohan --10834
                if(acct != null){
                    System.debug('11111');
                    objAssignment.Account__c = acct.Id;
                }
                
                
                if(strErrorMessage.trim() == '')
                {
                    
                    objAssignment.Status__c = 'Processed';
                    objAssignment.Error_Message__c = '';
                    objAssignment.Error_Type__c = '';

                }    
                else
                {
                    
                    objAssignment.Error_Message__c = strErrorMessage+'\n';
                    
                    if(acct != null && acctId2UserTeamMap.get(acct.Id) != null && acctId2UserTeamMap.get(acct.Id).size() > 0)
                    {
                        System.debug('33333');
                        objAssignment.Status__c = 'Partially Processed';
                        //added the error type
                        objAssignment.Error_Type__c='USER-ERROR';
                    }    
                    else
                    {
                        System.debug('44444');
                        objAssignment.Status__c = 'Error';
                        //added the error type
                       objAssignment.Error_Type__c='CUSTOMER-ERROR';
                    }    
                }
                updateAssignments.add(objAssignment);
            }
            
            //Delete Account Team Members for Accounts
            List<AccountTeamMember> listOldAccountTeam = [Select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel 
                                                     From AccountTeamMember where AccountId in :mapAccounts.keySet()];
            
            System.debug('old account team===== '+listOldAccountTeam );                                         
            
            Map<id, Map<Id,AccountTeamMember>> mapAccntId2TeamDelete = new Map<Id, Map<Id,AccountTeamMember>>();
            
            // Loop and store Account Id as key and UserId/ ATM as Value similar to new Account team map storage
            for(AccountTeamMember atm: listOldAccountTeam)
            {
                Map<Id, AccountTeamMember> atmMap;
                if(mapAccntId2TeamDelete.containsKey(atm.AccountId))
                    atmMap = mapAccntId2TeamDelete.get(atm.AccountId);
                else
                    atmMap = new Map<Id,AccountTeamMember>();
                
                atmMap.put(atm.UserId, atm);
                mapAccntId2TeamDelete.put(atm.AccountId, atmMap);
            }
            
            List<AccountTeamMember> newATM2Insert = new List<AccountTeamMember>();
            List<AccountTeamMember> oldATM2Delete = new List<AccountTeamMember>();
            
            // below logic to compare old and new team for an Account, to delete old team member if not in new team and add new team member to team
//            for(Id accId: acctId2UserTeamMap.keySet()) 
            for(Id accId: mapAccounts.keySet())
            {
                Id oldOwnerId = accIdOwnerIdMap.get(accId);
                Map<Id, AccountTeamMember> newATMMap = acctId2UserTeamMap.get(accId);
                Map<Id, AccountTeamMember> oldATMMap = mapAccntId2TeamDelete.get(accId);
                System.Debug('New ATM Map-----'+newATMMap);
                System.Debug('Old ATM Map-----'+oldATMMap);
                if(oldATMMap != null)
                {
                    if(newATMMap != null)
                    {
                        for(AccountTeamMember newATM: newATMMap.values())
                        {
                            if(oldATMMap.containskey(newATM.UserId) && oldATMMap.get(newATM.UserId).TeamMemberRole == newATM.TeamMemberRole)
                            {
    //                            newATMMap.remove(newATM.UserId);
                            }
                            else
                            {
                                newATM2Insert.add(newATM);
                            }
                        }
                        // to remove old team member if not in new team
                        for(AccountTeamMember oldATM: oldATMMap.values())
                        {
                            // this is to avoid deleting Old owner Id, as it should delete automatically when Owner changed, this is extra check
                            if(oldOwnerId == oldATM.UserId)
                                continue;
                                
                            if(!newATMMap.containskey(oldATM.UserId))
                                oldATM2Delete.add(oldATM);             
    
                            if(newATMMap.containskey(oldATM.UserId) && newATMMap.get(oldATM.UserId).TeamMemberRole != oldATM.TeamMemberRole)
                                oldATM2Delete.add(oldATM); 
                        }
                    }
                    else
                    {
                        if(oldATMMap!=null)
                        {
                            oldATM2Delete.addAll(oldATMMap.values());
                        }    
                    }
                }
                else
                {
                    if(newATMMap!=null)
                    {
                        newATM2Insert.addAll(newATMMap.values());
                    }    
                }
            }
            System.debug('List of new atm@@@@@@'+newATM2Insert);
            System.debug('List of old atm@@@@@@'+oldATM2Delete);
            //create share records for new Account team.
            List<AccountShare> accShareList = new List<AccountShare>();
            for(AccountTeamMember atm: newATM2Insert)
            {
                AccountShare accShare = new AccountShare();
                accShare.AccountId = atm.accountId;
                accShare.UserOrGroupId = atm.UserId;
                accShare.AccountAccessLevel = 'Edit';
                accShare.OpportunityAccessLevel = 'Edit';
                accShareList.add(accShare);
            }
            System.debug('ACCOUNT SHARE SIZE =='+accShareList.size());
            System.debug('ACCOUNT TEAM SIZE =='+newATM2Insert.size());
            
            // for team members which are getting deleted, delete their Share records as well to remove visibility of accounts
            List<AccountShare> listOldAccountShares = [Select Id, AccountId, UserOrGroupId From AccountShare where AccountId in :mapAccounts.keySet()];
            
            
            Map<Id, Map<Id, AccountShare>> mapAccount2UserShare = new  Map<Id, Map<Id, AccountShare>>(); 
            for(AccountShare accShare: listOldAccountShares)
            {
                Id oldOwnerId = accIdOwnerIdMap.get(accShare.AccountId);
                if(accShare.UserOrGroupId == oldOwnerId)// this is to avoid deleting old owners share record as it should delete automatically, this is extra check
                    continue;
                Map<Id, AccountShare> mapUserShare;
                if(mapAccount2UserShare.containsKey(accShare.AccountId))
                    mapUserShare = mapAccount2UserShare.get(accShare.AccountId);
                else
                    mapUserShare = new Map<Id,AccountShare>();
                

                mapUserShare.put(accShare.UserOrGroupId, accShare);
                
                mapAccount2UserShare.put(accShare.AccountId, mapUserShare);
                // write code to generate map
            }
            
            List<AccountShare> listAccountShares2Delete = new List<AccountShare>();
            for(AccountTeamMember atm: oldATM2Delete)
            {
                Map<Id, AccountShare> mapUserShare = mapAccount2UserShare.get(atm.AccountId);
                if(mapUserShare != null && mapUserShare.containsKey(atm.UserId))
                    listAccountShares2Delete.add(mapUserShare.get(atm.UserId));
            }
            
            //////To update the assignment where there is no change
            /*for(AccountAssignments__c objAssignment: lstAssignments)
            {
                for (string entity:entityid_no_change)
                {   if(entity==objAssignment.Entity_Id__c)
                    {
                        objAssignment.Status__c='Error';
                        objAssignment.Error_Message__c='No processing required';
                        updateAssignments.add(objAssignment);
                    }
                }   
            }*/
            
            if(accountOwnerUpdate.size() > 0)
                update accountOwnerUpdate;
            if(listAccountShares2Delete != null && listAccountShares2Delete.size() > 0)
                delete listAccountShares2Delete;
            if(oldATM2Delete != null && oldATM2Delete.size() > 0)
                delete oldATM2Delete;
            if(accShareList != null && accShareList.size() > 0)
                insert accShareList;
            if(newATM2Insert != null && newATM2Insert.size() > 0)
                insert newATM2Insert;

            if(updateAssignments != null && updateAssignments.size() > 0)
                update updateAssignments;
                
            
            
        }
        catch(Exception ex)
        {
            System.debug('WHY ERROR CAME here = '+ex.getMessage());
            Util.LOG('AccountAssignments_Batch.execute', -1, ex.getMessage());
        }
/*
        // delete whole old account team                                         
        if(atmDeleteList != null & atmDeleteList.size() > 0) 
        {
            System.debug(':: teamDeletes:::'+atmDeleteList);
         
            Database.Deleteresult[] dlResult = Database.delete(atmDeleteList);
            Integer rCounter = 0;
            for(Database.Deleteresult dr:dlResult)
            {
                if(!dr.isSuccess())
                {
                    Database.Error err = dr.getErrors()[0];
                    //resp.sfdcErrors.add('Account Id ::'+teamDeletes.get(rCounter).AccountId+'::::Delete Account TeamMember ErrorMssage::'+err.getMessage());
                }
                rCounter++;
            }
        }
  */   
  
  
      upsert mapErrorTracker.values();
     
        
    }
    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        // not required
    }
    
   

    private String checkAndAddOverlay(AccountAssignments__c objAssignment, Integer repNo, Id accntId, String overlayEmpId, String empRoleId, Map<String, User> mapRep2User, Map<Id, Map<Id, AccountTeamMember>> acctId2TeamMap, String primaryRepId)
    {
        String errorMessage = overlayTeamRep(repNo, accntId, overlayEmpId, empRoleId, mapRep2User, acctId2TeamMap, primaryRepId);
        if(errorMessage != '')
        {
            if(inactiveEmpCount == 1)
                objAssignment.Inactive_Emp_Id_1__c = overlayEmpId;
            else if(inactiveEmpCount == 2)
                objAssignment.Inactive_Emp_Id_2__c = overlayEmpId;
            else if(inactiveEmpCount == 3)
                objAssignment.Inactive_Emp_Id_3__c = overlayEmpId;
            else if(inactiveEmpCount == 4)
                objAssignment.Inactive_Emp_Id_4__c = overlayEmpId;
            else if(inactiveEmpCount == 5)
                objAssignment.Inactive_Emp_Id_5__c = overlayEmpId;
            else if(inactiveEmpCount == 6)
                objAssignment.Inactive_Emp_Id_Rest__c = overlayEmpId;
            else if(inactiveEmpCount > 6)
                objAssignment.Inactive_Emp_Id_Rest__c = objAssignment.Inactive_Emp_Id_Rest__c + ';' +overlayEmpId;
            
            inactiveEmpCount++;
        }
        return errorMessage;
    }

  
    /*
        This method is to find matching Active user record and create Account Team Member object record
    */
    private String overlayTeamRep(Integer repNo, Id accntId, String overlayEmpId, String empRoleId, Map<String, User> mapRep2User, Map<Id, Map<Id, AccountTeamMember>> acctId2TeamMap, String primaryRepId)
    {
        System.debug('OVERLAY Rep Id '+repNo+ ' ==='+overlayEmpId);
        String errorMessage = '';
        if(overlayEmpId == null || overlayEmpId == '' || primaryRepId == overlayEmpId) // if owner is same as overlay rep, overlay rep cannot be added
            return errorMessage;
        User empUser;
        AccountTeamMember atm;
        if(overlayEmpId != null && overlayEmpId != '')
            empUser = mapRep2User.get(overlayEmpId);
                
        if(empUser != null)
        {
            Map<Id, AccountTeamMember> atmMap;
            if(acctId2TeamMap.containsKey(accntId))
                atmMap = acctId2TeamMap.get(accntId);
            else
                atmMap = new Map<Id, AccountTeamMember>();
            
            atm = new AccountTeamMember();
            atm.AccountId = accntId;
            atm.UserId = empUser.Id;
/*          Sales_Person__c sPerson;
            if(empRoleId != null && empRoleId != '')
                sPerson = mapId2SalesPersons.get(empRoleId);
            
            if(sPerson != null)
                atm.TeamMemberRole = sPerson.Role_Relate_Id__c;
            else
            {
                atm.TeamMemberRole = 'Overlay';
                errorMessage += 'Not able to find Sales Person Id for Overlay Rep' +repNo+ ' Role Related Id '+empRoleId+'.';
            }
*/          
            if(empRoleId != null && empRoleId != '')
                atm.TeamMemberRole = empRoleId;
            else
                atm.TeamMemberRole = 'Overlay';
            atmMap.put(empUser.Id, atm);
            acctId2TeamMap.put(accntId, atmMap);
        }
        else
            errorMessage += 'Not able to find User record for Overlay Rep, user may be inactive.';
        /*
        if(atm != null)
        {
            AccountShare accShare = new AccountShare();
            accShare.AccountId = accntId;
            accShare.UserOrGroupId = empUser.id;
            accShare.AccountAccessLevel = 'Edit';
            accShare.OpportunityAccessLevel = 'Edit';
        }
        */
        return errorMessage;
    }

    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
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
                            +' from AccountAssignments__c where Status__c = \'Open\'  and RecordTypeId =\''+Label.Account_Assignment_GT+'\' and createddate >= yesterday ';
        GT_AccAssignment_Batch assignBatch1 = new GT_AccAssignment_Batch (strQuery);
        database.executebatch(assignBatch1, 100);


/*        strQuery = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c, Status__c, Error_Message__c '
                            +' from AccountAssignments__c where Status__c = \'Open\' and (Name Like \'%8\' OR Name Like \'%9\')';
        AccountAssignments_Batch assignBatch5 = new AccountAssignments_Batch(strQuery);
        database.executebatch(assignBatch5, 500);
*/

    } 
    
    public class Overlay{
        public Integer Sequence;
        public String oEMPID;
        public String oEMPROLE;
    }


}