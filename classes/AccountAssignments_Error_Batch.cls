/***
Description: This Is a batch Apex program. Scope of this is the AccountAssignment__c object records with 'Error' or 'Partial Processed' status.
             This class is to try processing records which errored out or just got partially processed earlier as by this time some errors may have been rectified.

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


Created By: Sunil Bansal
Created Date: 02-May-2012

Modified By:
Modified Date:

Modify Reason:
**/
global class AccountAssignments_Error_Batch implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    
    // below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select Id, AccountId__c, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c, Status__c, Error_Message__c '
                            +' from AccountAssignments__c where Status__c = \'Error\' OR Status__c = \'Partially Processed\'';
    

    /* Default Constructor*/
    global AccountAssignments_Error_Batch()
    {
    }
    
    /*This costructor is called from the Batch Schedule mathod*/
    global AccountAssignments_Error_Batch(String query)
    {
        System.debug('QUEERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
    }
    
    /* This method prepares the scope of the batch programbased on the query result and send the records count email before processing*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        /*****Send email before processing*********/
        // need to comment below code which send out emai for record counts, as it is failing because we more than 50000 rows and 
        // it is throwing Governor limits execption, even if bring teh count low tomorrow, it may grow up and then again we see the issue
        // if we need the email thing we need to do it in some other job or leave it
/*
        Integer errorCount = [Select count() from AccountAssignments__c where Status__c = 'Error'];
        Integer partialCount = [Select count() from AccountAssignments__c where Status__c = 'Partially Processed'];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{'sunil.bansal@wipro.com','ankur.pradhan@wipro.com','prasad.devar@officedepot.com'});
        String Bdy = 'Count before Processing';
        Bdy = Bdy+ '\n\nError Count = '+errorCount;
        Bdy = Bdy+ '\nPartial Processed Count = '+partialCount;
        mail.setPlainTextBody(Bdy);
        mail.setSubject('Before process: Error count email');
        //mail.setInReplyTo('sunil.bansal@wipro.com');
        mail.setReplyTo('sunil.bansal@wipro.com');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        */
        /**************/
        System.debug('QUERY IS ====='+strQuery);
        return Database.getQueryLocator(strQuery);
    }
    
    /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {

        List<AccountAssignments__c> lstAssignments = scope;
        Set<String> setEmpIds = new Set<String>(); // this set to store OD employee Id to select user records
        Set<String> setAccountIds = new Set<String>(); // Acocunts Ids from the Assignments Batch
        Set<String> setSiteIds = new Set<String>(); // Site Ids from the Assignments Batch
        Set<String> setPartyIds = new Set<String>(); // Party Ids from the Assignments Batch
        Set<String> setPartySiteIds = new Set<String>(); // Party Site Ids from the Assignments Batch
        Set<String> setAopsCustIds = new Set<String>(); // AOPS Cust Ids from the Assignments Batch
        Set<String> setAopsSeqIds = new Set<String>(); // AOPS Seq Ids from the Assignments Batch
        //Set<String> setRoleRelatedIds = new Set<String>(); // set of Role related ids

        try
        {
            // loop on the batch scope        
            for(AccountAssignments__c objAssignment: lstAssignments)
            {
                // If by chance AccounId__c field is null or blank, skip the record
                if(objAssignment.AccountId__c != null && objAssignment.AccountId__c != '')
                {
/*                  if(objAssignment.AccountType__c == 'A') // Account record so Account Id
                        setAccountIds.add(objAssignment.AccountId__c);
        
                    if(objAssignment.AccountType__c == 'S') // Site record so Site Id
                        setSiteIds.add(objAssignment.AccountId__c); */

/*                  if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'PROSPECT') // Prospect Account record so Account Id
                        setPartyIds.add(objAssignment.AccountId__c);
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'PROSPECT') //Prospect  Site record so Site Id
                        setPartySiteIds.add(objAssignment.AccountId__c);
                    if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'CUSTOMER') // Customer Account record so Account Id
                        setAopsCustIds.add(objAssignment.AccountId__c);
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'CUSTOMER') //Customer Site record so Site Id
                        setAopsSeqIds.add(objAssignment.AccountId__c); */

                    if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'PROSPECT') // Prospect Account record so Party Id of Account
                        setPartyIds.add(objAssignment.Entity_Id__c);
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'PROSPECT') //Prospect Site record so Party Site Id of Account
                        setPartySiteIds.add(objAssignment.Entity_Id__c);
                    if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'CUSTOMER') // Customer Account record so AOPS cust id of Account
                        setAopsCustIds.add(objAssignment.Entity_Id__c);
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'CUSTOMER') //Customer Site record so AOPS seq Id of Account
                        setAopsSeqIds.add(objAssignment.Entity_Id__c);

    /*                // Sales Person Id, to be set on Account record
                    if(objAssignment.PrimaryEmpRole__c != null && objAssignment.PrimaryEmpRole__c != '')
                        setRoleRelatedIds.add(objAssignment.PrimaryEmpRole__c);
    */                
                    //Add Primary rep Id to the Set 
                    if(objAssignment.PrimaryEmpId__c != null && objAssignment.PrimaryEmpId__c != '')
                        setEmpIds.add(objAssignment.PrimaryEmpId__c);
                    
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
    /*
                    // add Overlay Rep's Role related Id to the set
                    if(objAssignment.OverlayEmpRole1__c != null && objAssignment.OverlayEmpRole1__c != '')
                        setRoleRelatedIds.add(objAssignment.OverlayEmpRole1__c);
                    if(objAssignment.OverlayEmpRole2__c != null && objAssignment.OverlayEmpRole2__c != '')
                        setRoleRelatedIds.add(objAssignment.OverlayEmpRole2__c);
                    if(objAssignment.OverlayEmpRole3__c != null && objAssignment.OverlayEmpRole3__c != '')
                        setRoleRelatedIds.add(objAssignment.OverlayEmpRole3__c);
                    if(objAssignment.OverlayEmpRole4__c != null && objAssignment.OverlayEmpRole4__c != '')
                        setRoleRelatedIds.add(objAssignment.OverlayEmpRole4__c);
                    if(objAssignment.OverlayEmpRole5__c != null && objAssignment.OverlayEmpRole5__c != '')
                        setRoleRelatedIds.add(objAssignment.OverlayEmpRole5__c);
    */
                }// if(objAssignment.AccountId__c != null && objAssignment.AccountId__c != '')
            }//for(AccountAssignments__c objAssignment: lstAssignments)
    /*
            Map<String,Sales_Person__c> mapId2SalesPersons = new Map<String,Sales_Person__c>();
            
            System.debug('::: salesRepKeys:::'+setRoleRelatedIds);
            for(Sales_Person__c sRep: [select id, Role_Relate_Id__c From Sales_Person__c  where Role_Relate_Id__c in :setRoleRelatedIds]) 
            {
                mapId2SalesPersons.put(sRep.Role_Relate_Id__c,sRep);
            }
    */      
            //List<User> lstAllReps = [select id, OD_Employee_ID__c from User where OD_Employee_ID__c in :setEmpIds];
            Map<String, User> mapEmpId2User = new Map<String, User>(); // Map to store OD employee Id as Key and User record as value
            // query Active Users and create map with OD EMployee Id as Key
            for(User usr: [select id, OD_Employee_ID__c from User where OD_Employee_ID__c in :setEmpIds and isActive = true])
            {
                mapEmpId2User.put(usr.OD_Employee_ID__c, usr);
            }
            
            // 
//          Map<ID, Account> mapAccounts = new Map<ID, Account>([select id, ownerId, RecordTypeId, Oracle_Party_Id__c, Oracle_Party_Site_Id__c from Account where Oracle_Party_Id__c in : setAccountIds OR Oracle_Party_Site_Id__c in :setSiteIds]);
            Map<ID, Account> mapAccounts = new Map<ID, Account>([select id, ownerId, RecordTypeId, Oracle_Party_Id__c, Oracle_Party_Site_Id__c, AOPS_Cust_Id__c, AOPS_Seq_ID__c from Account where Oracle_Party_Id__c in : setPartyIds OR Oracle_Party_Site_Id__c in :setPartySiteIds OR AOPS_Cust_Id__c in :setAopsCustIds OR AOPS_Seq_ID__c in :setAopsSeqIds ]);
            
//          Map<String, Account> mapAccId2Account = new map<String, Account>(); // so easy to find Account record based on AccountID
//          Map<String, Account> mapSiteId2Account = new map<String, Account>();// so easy to find Account record based on SiteID
            Map<String, Account> mapPartyId2Account = new map<String, Account>(); // so easy to find Account record based on PartyID
            Map<String, Account> mapPartySiteId2Account = new map<String, Account>();// so easy to find Account record based on PartySiteID
            Map<String, Account> mapCustId2Account = new map<String, Account>(); // so easy to find Account record based on AOPS Cust Id
            Map<String, Account> mapSeqId2Account = new map<String, Account>();// so easy to find Account record based on AOPS Seq Id

            for(Account acc: mapAccounts.values())
            {
/*              if(acc.Oracle_Party_ID__c != null && acc.Oracle_Party_ID__c != '')
                    mapAccId2Account.put(acc.Oracle_Party_ID__c, acc);
                if(acc.Oracle_Party_Site_Id__c != null && acc.Oracle_Party_Site_Id__c != '')
                    mapSiteId2Account.put(acc.Oracle_Party_Site_Id__c, acc); */
                    
                if(acc.Oracle_Party_ID__c != null && acc.Oracle_Party_ID__c != '')
                    mapPartyId2Account.put(acc.Oracle_Party_ID__c, acc);
                if(acc.Oracle_Party_Site_Id__c != null && acc.Oracle_Party_Site_Id__c != '')
                    mapPartySiteId2Account.put(acc.Oracle_Party_Site_Id__c, acc);
                if(acc.AOPS_Cust_Id__c != null && acc.AOPS_Cust_Id__c != '')
                    mapCustId2Account.put(acc.AOPS_Cust_Id__c, acc);
                if(acc.AOPS_Seq_ID__c != null && acc.AOPS_Seq_ID__c != '')
                    mapSeqId2Account.put(acc.AOPS_Seq_ID__c, acc);
            }
            
            List<Account> accountOwnerUpdate = new List<Account>(); // List fo Accounts for which Account Owner is getting updated by Primary Rep
            Map<Id, Map<Id, AccountTeamMember>> acctId2UserTeamMap = new Map<Id, Map<Id, AccountTeamMember>>(); // map of Account Id as key & map of UserId/ AccountTeamMember
            
            List<AccountAssignments__c> updateAssignments = new List<AccountAssignments__c>(); // List to hold assigment records to update status
            Map<Id,Id> accIdOwnerIdMap = new Map<Id,Id>();
             
            for(AccountAssignments__c objAssignment: lstAssignments)
            {
                String strErrorMessage = '';
                Account acct;
                // If by chance AccounId__c field is null or blank, skip the record
                if(objAssignment.AccountId__c != null && objAssignment.AccountId__c != '')
                {
                    System.debug('ENTITY ID  ==='+objAssignment.Entity_Id__c);
/*                  if(objAssignment.AccountType__c == 'A')
                        acct = mapAccId2Account.get(objAssignment.AccountId__c);
        
                    if(objAssignment.AccountType__c == 'S')
                        acct = mapSiteId2Account.get(objAssignment.AccountId__c);
*/
                    if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'PROSPECT') // Prospect Account record so Account Id
                        acct = mapPartyId2Account.get(objAssignment.Entity_Id__c);
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'PROSPECT') //Prospect  Site record so Site Id
                        acct = mapPartySiteId2Account.get(objAssignment.Entity_Id__c);
                    if(objAssignment.AccountType__c == 'A' && objAssignment.Entity_Type__c == 'CUSTOMER') // Customer Account record so Account Id
                        acct = mapCustId2Account.get(objAssignment.Entity_Id__c);
                    else if(objAssignment.AccountType__c == 'S' && objAssignment.Entity_Type__c == 'CUSTOMER') //Customer Site record so Site Id
                        acct = mapSeqId2Account.get(objAssignment.Entity_Id__c);
    
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
                            System.debug('ACCOUNT OWNER Id ==='+acct.OwnerId);
                            System.debug('PRIMARY REP Id ==='+empUser.Id);
                            if(acct.OwnerId != empUser.Id)
                            {
                                acct.OwnerId = empUser.Id;
    /*                          Sales_Person__c sPerson;
                                if(objAssignment.PrimaryEmpRole__c != null && objAssignment.PrimaryEmpRole__c != '')
                                    sPerson = mapId2SalesPersons.get(objAssignment.PrimaryEmpRole__c);
                                
                                if(sPerson != null)
                                    acct.Sales_PersonID__c = sPerson.Id;
                                else
                                    strErrorMessage += ' '+'Not able to find Sales Person Id for Primary Rep Role Related Id '+objAssignment.PrimaryEmpRole__c+'.';
    */
                                // add to list for account to update owner id
                                accountOwnerUpdate.add(acct);   
                            }
                        }
                        else
                            strErrorMessage += ' '+'Account Owner was not updated as not able to find User record for Primary Rep Id '+objAssignment.PrimaryEmpId__c+', user may be inactive.';
                        
                        strErrorMessage += ' '+overlayTeamRep(1, acct.Id, objAssignment.OverlayEmpID1__c, objAssignment.OverlayEmpRole1__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(2, acct.Id, objAssignment.OverlayEmpID2__c, objAssignment.OverlayEmpRole2__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(3, acct.Id, objAssignment.OverlayEmpID3__c, objAssignment.OverlayEmpRole3__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(4, acct.Id, objAssignment.OverlayEmpID4__c, objAssignment.OverlayEmpRole4__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(5, acct.Id, objAssignment.OverlayEmpID5__c, objAssignment.OverlayEmpRole5__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(6, acct.Id, objAssignment.OverlayEmpID6__c, objAssignment.OverlayEmpRole6__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(7, acct.Id, objAssignment.OverlayEmpID7__c, objAssignment.OverlayEmpRole7__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(8, acct.Id, objAssignment.OverlayEmpID8__c, objAssignment.OverlayEmpRole8__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(9, acct.Id, objAssignment.OverlayEmpID9__c, objAssignment.OverlayEmpRole9__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(10, acct.Id, objAssignment.OverlayEmpID10__c, objAssignment.OverlayEmpRole10__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(11, acct.Id, objAssignment.OverlayEmpID11__c, objAssignment.OverlayEmpRole11__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(12, acct.Id, objAssignment.OverlayEmpID12__c, objAssignment.OverlayEmpRole12__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(13, acct.Id, objAssignment.OverlayEmpID13__c, objAssignment.OverlayEmpRole13__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(14, acct.Id, objAssignment.OverlayEmpID14__c, objAssignment.OverlayEmpRole14__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
                        strErrorMessage += ' '+overlayTeamRep(15, acct.Id, objAssignment.OverlayEmpID15__c, objAssignment.OverlayEmpRole15__c, mapEmpId2User, acctId2UserTeamMap, objAssignment.PrimaryEmpId__c);
    
                    }
                    else
                    {
                        if(objAssignment.AccountType__c == 'A')
                            strErrorMessage += ' '+'Not able to find SFDC Account record for AccuntId '+objAssignment.AccountId__c+'.';
                        else
                            strErrorMessage += ' '+'Not able to find SFDC Account record for SiteId '+objAssignment.AccountId__c+'.';
                    }
                }
                
                strErrorMessage = strErrorMessage.trim();
                System.debug('ERROR IF ANY == '+strErrorMessage);
                if(strErrorMessage.trim() == '')
                    objAssignment.Status__c = 'Processed';
                else
                {
                    strErrorMessage = String.valueOf(System.today())+':- '+strErrorMessage; // to capture message date
                    objAssignment.Error_Message__c = strErrorMessage+'\n';
                    if(acct != null && acctId2UserTeamMap.get(acct.Id) != null && acctId2UserTeamMap.get(acct.Id).size() > 0)
                        objAssignment.Status__c = 'Partially Processed';
                    else
                        objAssignment.Status__c = 'Error';
                }
                updateAssignments.add(objAssignment);
            }
            
            //Delete Account Team Members for Accounts
            List<AccountTeamMember> listOldAccountTeam = [Select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel 
                                                     From AccountTeamMember where AccountId in :mapAccounts.keySet()];
            
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
            for(Id accId: acctId2UserTeamMap.keySet())
            {
                Id oldOwnerId = accIdOwnerIdMap.get(accId);
                Map<Id, AccountTeamMember> newATMMap = acctId2UserTeamMap.get(accId);
                Map<Id, AccountTeamMember> oldATMMap = mapAccntId2TeamDelete.get(accId);
                if(oldATMMap != null)
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
                    newATM2Insert.addAll(newATMMap.values());
                }
            }
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
    }
    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
    	// do nothing
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
            errorMessage += 'Not able to find User record for Overlay Rep' +repNo+ ' Id '+overlayEmpId+', user may be inactive.';
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
        String strQuery = '';
        AccountAssignments_Error_Batch assignBatch = new AccountAssignments_Error_Batch(strQuery);
        database.executebatch(assignBatch, 500);
        
        try
        {
//            DateTime dt = DateTime.Now();
//            String currentDay = dt.format('E'); 
//            Map<String, Keyvalue_Map_CS__c> keyValueMap = Keyvalue_Map_CS__c.getAll();
//            String runDay = keyValueMap.get('AccountAssignmentCleanOnDay').Data_Value__c;
//            if(currentDay == runDay || currentDay == runDay.subString(0,3))
//            {
                String strCleanQuery = '';
                AccountAssignments_Clean_Batch cleanBatch = new AccountAssignments_Clean_Batch(strCleanQuery);
                database.executebatch(cleanBatch, 2000);
//            }
        }
        catch(Exception ex)
        {
            System.debug('WHY ERROR CAME here = '+ex.getMessage());
            Util.LOG('AccountAssignments_Clean_Schedule.execute', -1, ex.getMessage());
        }
        
    } 


}