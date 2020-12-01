// 
// (c) 2011 Appirio, Inc., Office Depot, Inc
//
// Upsert a list of sales rep assignment information. 
//
// Review Status:  @DRAFT
//
// 2011-07-12     Mike Keller      Initial Version
// 2011-08-23     Joe Krutulis     Completely New Version to Support AccountTeamMember logic
// 2011-09-08     Joe Krutulis     converted key from numeric to string
// 2011-09-13     Virendra         Basic governor quota Info return to Client,DataBase methods for DML operations to get individual error  
// 2011-09-16     Virendra         Updates to process new CSV file format.
// 2011-09-20     Virendra         Added Temp  AssignmentStatus properties to review the time spent on process ( be remove ) 
// 2011-09-29     Virendra         Changed Field for salesPerson Id and Value update for Overlayes sales id
//
//
/*** To Run this Service from the Apex Console:
    String stat = AssignmentService.updateAssignments(new List<AssignmentService.Assignment>());
    Util.DEBUG('' + stat);
***/

global class AssignmentService{

  public class AssignmentServiceException extends Exception {}

  global class Assignment {
    webservice String typeFlag;
    webservice String siteId;
    webservice String primaryRepId;
    webservice String accountId;
    webservice String salesPersonId;
    webservice List<OverlayRep> overlayReps;
  }
  
  global class OverlayRep{
    webservice String overlayRepId;
    webservice String overlayRepRole;   
  } 
  
  global class AssignmentStatus {
    webservice String responseCode;
    webservice String message;
    webservice List<SiteStatus> siteSatus; 
    webservice String dmlStatementInfo;
    webservice String cpuTime;
    webservice String callouts;
    webservice String dmlRows;
    webservice List<String> sfdcErrors;
    //TODO: remove below properties it's just to review the time taken in process
    webservice String creatinAccountSiteOverlayMapsTime;
    webservice String retriveUsersForAccountandSites;
    webservice String retriveAccountToUpdateOwner;
    webservice String updateAccountSitesOwner;
    webservice String teamMemberDeleteTime;
    webservice String teamMemberDeleteCount;
    webservice String accountTeamShareCreationTime;
    webservice String accountTeamCreationTime;
    webservice String accountShareCreationTime;
  }

  global class SiteStatus {
    webservice String siteId;
    webservice String responseCode;
    webservice String message;
  }



  webservice static AssignmentStatus updateAssignments(List<Assignment> assignments){
    AssignmentStatus resp = new AssignmentStatus(); 
    try{
      DateTime startTime =  System.now();
      resp.responseCode = '1';  
      resp.updateAccountSitesOwner = '';
      resp.teamMemberDeleteTime = '';
      resp.teamMemberDeleteCount = '';
      resp.accountTeamShareCreationTime = '';
      resp.accountTeamCreationTime = '';
      resp.accountShareCreationTime = '';
      updateAssignmentsImpl(assignments,resp);
      DateTime endTime =    System.now();  
      Long dTime = (endTime.getTime()-startTime.getTime());
      resp.message = ''+(dTime / 1000.0);
      //throw new AssignmentServiceException('updateAssignments interface defined, but service is not implemented.');
    }catch (Exception e) {
      resp.responseCode = '-1';
      Util.LOG('AssignmentService.updateAssignments', -1, e.getMessage());
      resp.message = e.getMessage();
    }
     resp.dmlStatementInfo = Limits.getDmlStatements()+' DML Statements Executed Out Of '+ Limits.getLimitDmlStatements();
     resp.cpuTime = Limits.getCpuTime()+' CPU time (in milliseconds) accumulated Out Of '+ Limits.getLimitCpuTime();
     resp.callouts = Limits.getCallouts()+' Web service statements that have been processed Out Of '+ Limits.getLimitCallouts();
     resp.dmlRows = String.valueOf(Limits.getDmlRows());//+' DML Rows have been processed Out Of '+ Limits.getLimitDmlRows();
    return resp;
  }


  public static void updateAssignmentsImpl(List<Assignment> assignments,AssignmentStatus resp) {
    // Collect the primary Rep Ids, overlay rep Ids.
    // Rep Ids will link to a particular SF User.  The inbound
    // ids are referred to as "Keys"
    
    Set<String> primaryRepKeys = new Set<String>();
    List<OverlayRep> overlayRepKeys = new List<OverlayRep>();
    resp.sfdcErrors = new List<String>();
    // Collect the Primary Account Ids, and Site ids
    // Sites are a record type of accounts
    Set<String> accountKeys = new Set<String>();
    Set<String> siteKeys = new Set<String>();
    Set<String> salesRepKeys = new Set<String>();
    
    Database.DMLOptions dlo = new Database.DMLOptions();
    dlo.optAllOrNone = false;
    // Iterate over incoming Assignment Records and their overlay collections
    // to gather the user and account keys needed for this txn
    try{
       Double k = 0.0;
       Datetime stime = System.now();
       for (Assignment a: assignments) {
          primaryRepKeys.add(a.primaryRepId);
          if (a.overlayReps != null) {
            overlayRepKeys.addAll(a.overLayReps);
          }
          if (a.siteId != null && a.siteId != '') {
            siteKeys.add(a.siteId);
          }else if (a.accountId != null && a.accountId != '') {
            accountKeys.add(a.accountId);
          }
          if(a.salesPersonId != null && a.salesPersonId !=''){
            salesRepKeys.add(a.salesPersonId);
          }
       }
    
       Set<String> allRepKeys = new Set<String>();
       allRepKeys.addAll(primaryRepKeys);
       for(OverlayRep ovrRep:overlayRepKeys){
          allRepKeys.add(ovrRep.overlayRepId);  
       }
        Datetime etime = System.now();
        Long dTime = (eTime.getTime()-sTime.getTime());
        resp.creatinAccountSiteOverlayMapsTime = ''+(dTime / 1000.0);
        
        // Map All Rep Ids to SFDC User Object Ids;
        Map<String, User> key2User = new Map<String, User>();
        Map<Id, User> id2User = new Map<Id, User>();
        Map<String,Id> idSalesPersons = new Map<String,Id>();
        
        /* Sales Rep Keys relies on ExtIDSalesPerson__c, we are moving away from this field and using the Role_Relate_Id__c 
         * Updated by Ritesh
        for (Sales_Person__c sRep: [select id, ExtIDSalesPerson__c From Sales_Person__c  where ExtIDSalesPerson__c in :salesRepKeys]) {
          idSalesPersons.put(sRep.ExtIDSalesPerson__c,sRep.Id);
        }
        */
        
        //New code, added by Ritesh , assuming the new field in place
        System.debug('::: salesRepKeys:::'+salesRepKeys);
        for (Sales_Person__c sRep: [select id, Role_Relate_Id__c From Sales_Person__c  where Role_Relate_Id__c in :salesRepKeys]) {
          idSalesPersons.put(sRep.Role_Relate_Id__c,sRep.Id);
        }
        
        
        stime = system.now();
        for (User u: [select id, OD_Employee_ID__c from user where OD_Employee_ID__c in :allRepKeys]) {
          primaryRepKeys.remove(u.OD_Employee_ID__c);
          allRepKeys.remove(u.OD_Employee_ID__c);
          key2User.put(u.OD_Employee_ID__c, u);
          id2User.put(u.id, u);
        }
        
        
        etime = System.now();
        dTime = (eTime.getTime()-sTime.getTime());
        resp.retriveUsersForAccountandSites = ''+(dTime / 1000.0);
        System.debug('::: id2User::'+id2User);
        
        // @TODO: Record any unmapped user ids to generate error messages -- JoeK
    
        Map<String, Account> siteKey2Account = new Map<String, Account>();
        Map<String, Account> primary2Account = new Map<String, Account>();
        //Below id2AccountMap Commented(Not populated anywhere and used to getAccountTeamMember) -=-Virendra
        //Map<id, Account> id2Account = new Map<id, Account>();
        
        List<id> id2Account = new List<id>();
    
        System.debug(':::Accounts Key :'+accountKeys);
        System.debug('::: siteKeys :::'+siteKeys);

        stime = system.now();
        for (Account acct : [select id, ownerId, RecordTypeId, Oracle_Party_Id__c, Oracle_Party_Site_Id__c 
                               from Account
                              where Oracle_Party_Id__c in : accountKeys 
                                 or Oracle_Party_Site_Id__c in :siteKeys ]) {
            id2Account.add(acct.id);
                                                
            if (acct.Oracle_Party_ID__c != null) {
              primary2Account.put(acct.Oracle_Party_Id__c, acct);
            } else {
              siteKey2Account.put(acct.Oracle_Party_Site_Id__c, acct);
            }
        }
        
        etime = System.now();
        dTime = (eTime.getTime()-sTime.getTime());
        resp.retriveAccountToUpdateOwner = ''+(dTime / 1000.0);
        
        //System.debug(':::siteKey2Account::'+siteKey2Account);
        //System.debug('::: primary2Account::'+primary2Account);
        // First change owners on all accounts if the primary rep Id is present to trigger any sharing
        // side effects, since when we change owners we disrupt custom sharing objects
        // @TODO:  Do the side effects of changing owner happen on update -- or do they occur at the
        // end of the transaction?  -- JoeK
        List<Account> updateOwnerIds = new List<Account>();
        Map<Id,Account> updateAccountsOwner = new Map<Id,Account>(); 
        stime = system.now();
        for (Assignment a: assignments) {
          if (a.primaryRepId != null && a.primaryRepId != '' && a.accountId != null && a.accountId != '') {
            Account acct = primary2Account.get(a.accountId);
            Id newUserId = null;
            Id salesPersonId = null;
            if(key2User.containsKey(a.primaryRepId))
               newUserId = key2User.get(a.primaryRepId).id;
            
            if(idSalesPersons.containsKey(a.salesPersonId))
               salesPersonId = idSalesPersons.get(a.salesPersonId);
               
            boolean isAddToMap = false;   
            if (newUserId != null && acct != null && newUserId != acct.ownerid) {
              acct.ownerId = newUserId;
              isAddToMap = true;
              acct.Sales_PersonID__c = salesPersonId;
              //updateAccountsOwner.put(acct.Id,acct);
              //updateOwnerIds.add(acct);
            }
            //system.debug('::: a.overlayReps::'+a.overlayReps);
            if(newUserId != null && acct != null && a.overlayReps != null){
                String overlayRepRoles = '';
                for(OverlayRep ovRep : a.overlayReps) {
                    overlayRepRoles+=ovRep.overlayRepRole+',';
                }
                
                if(overlayRepRoles!=null && overlayRepRoles.contains(',')){
                    overlayRepRoles = overlayRepRoles.substring(0,overlayRepRoles.length()-1);
                }
                //System.debug('11:::overlayRepIds::'+overlayRepIds);
                acct.Overlay_Sales_IDs__c = overlayRepRoles;
                acct.Sales_PersonID__c = salesPersonId;
                isAddToMap = true;
            }
            if(isAddToMap){
               //System.debug(':::11Update AccountAdded  :::'); 
               updateAccountsOwner.put(acct.Id,acct);
            }
          }
          
          //Code added for the Account of type Site 
          if (a.primaryRepId != null && a.primaryRepId != '' && a.siteId != null && a.siteId != '') {
            Account acct = siteKey2Account.get(a.siteId);
            Id newUserId = null;
            Id salesPersonId = null;
            
            if(key2User.containsKey(a.primaryRepId))
               newUserId = key2User.get(a.primaryRepId).id;
    
            if(idSalesPersons.containsKey(a.salesPersonId))
               salesPersonId = idSalesPersons.get(a.salesPersonId);
               
            boolean isAddToMap = false;                  
            if (newUserId != null && acct != null && newUserId != acct.ownerid) {
              acct.ownerId = newUserId;
              acct.Sales_PersonID__c = salesPersonId;
              isAddToMap = true;
              //updateAccountsOwner.put(acct.Id,acct);  
              //updateOwnerIds.add(acct);
            }
            
             if(newUserId != null && acct != null && a.overlayReps != null){
                String overlayRepRoles = '';
                for(OverlayRep ovRep : a.overlayReps) {
                    overlayRepRoles+=ovRep.overlayRepRole+',';
                }
                if(overlayRepRoles!=null && overlayRepRoles.contains(',')){
                    overlayRepRoles = overlayRepRoles.substring(0,overlayRepRoles.length()-1);
                }
                //System.debug('22:::overlayRepIds::'+overlayRepIds);
                acct.Overlay_Sales_IDs__c = overlayRepRoles;
                acct.Sales_PersonID__c = salesPersonId;
                isAddToMap = true;
             }
             if(isAddToMap){
                //System.debug(':::22Update AccountAdded  :::');
                updateAccountsOwner.put(acct.Id,acct);  
             }
          }
        }
        
        if(updateAccountsOwner != null && updateAccountsOwner.size() > 0) {
          for(String aId:updateAccountsOwner.keySet()){
            updateOwnerIds.add(updateAccountsOwner.get(aId));
          } 
          Database.SaveResult[] saveR = Database.update(updateOwnerIds,dlo);
          Integer acctCounter =0;
           for(Database.SaveResult sr:saveR){
              if(!sr.isSuccess()){
                 Database.Error err = sr.getErrors()[0];
                 resp.sfdcErrors.add('Account Id ::'+updateOwnerIds.get(acctCounter).Id+'::::ErrorMssage::'+err.getMessage());
              }
              acctCounter++;
          } 
        }
        etime = System.now();
        dTime = (eTime.getTime()-sTime.getTime());
        resp.updateAccountSitesOwner =  ''+(dTime / 1000.0);
        // Retrieve existing account team records for deletion;  UserId & Accounts
        // are not updateable per API spec;  for now, we won't try any recycling assuming that users will
        // generally all be changing for an account
        
        //As TeamMemberRole is as per the csv Data
        /*List<AccountTeamMember> teamDeletes = [select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel 
                                               from AccountTeamMember 
                                               where AccountId in :id2Account.keySet() 
                                               and TeamMemberRole = 'Overlay' ];*/
        List<AccountTeamMember> teamDeletes = [select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel 
                                               from AccountTeamMember 
                                               where AccountId in :id2Account];
                                                                                              
        if (teamDeletes != null & teamDeletes.size() > 0) {
          System.debug(':: teamDeletes:::'+teamDeletes);
          stime=System.now();
          
          Database.Deleteresult[] dlResult = Database.delete(teamDeletes);
          Integer rCounter = 0;
          for(Database.Deleteresult dr:dlResult){
              if(!dr.isSuccess()){
                 Database.Error err = dr.getErrors()[0];
                 resp.sfdcErrors.add('Account Id ::'+teamDeletes.get(rCounter).AccountId+'::::Delete Account TeamMember ErrorMssage::'+err.getMessage());
              }
               rCounter++;
          }
          etime = System.now();
          dTime = (eTime.getTime()-sTime.getTime());
          resp.teamMemberDeleteTime  = ''+(dTime / 1000.0);
          resp.teamMemberDeleteCount = ''+teamDeletes.size();
          
         /* rCounter = 0;
          Database.Emptyrecyclebinresult [] emptyRcResult = Database.emptyRecycleBin(teamDeletes);
          for(Database.Emptyrecyclebinresult er:emptyRcResult){
              rCounter++; 
              if(!er.isSuccess()){
                 Database.Error err = er.getErrors()[0];
                 resp.sfdcErrors.add('Account Id ::'+teamDeletes.get(rCounter).AccountId+'::::Empty RecycleBin ErrorMssage::'+err.getMessage());
              }
          }
          
          resp.teamMemberDeleteTime += '\\nAfter Empty Recycle :::: End Time ::'+System.now();
          */
        }else{
            resp.teamMemberDeleteTime = ' No Team Member Available For This Batch';
        }
    
        //Verifyied : ON Changing the account owner related AccountShare and OpportunityShare will automtically deleted 
        //No need to write code for delete  --Virendra
       /* List<AccountShare> shareDeletes = new List<AccountShare>();
        for (AccountShare s : [select id from AccountShare where AccountId in :id2Account.keySet()]) {
          // @TODO: are we really removing all shares or is this conditional?  -- JoeK
          shareDeletes.add(s);
        }
        if(shareDeletes != null & shareDeletes.size() > 0) {
          delete shareDeletes;
          Database.emptyRecycleBin(shareDeletes);
        }*/
        
        // For each assignment record, Create an AccountTeamMember Record and also an AccountShare record for 
        // each of the overlay users.
        List<AccountTeamMember> newTeamMembers = new List<AccountTeamMember>();
        List<AccountShare> newShares = new List<AccountShare>();
        
        stime = System.now();
        resp.accountTeamShareCreationTime = '';
        for (Assignment a: assignments) {
        Id accountId;
      //    if (a.siteId != null && a.siteId != '') {  ** not used any more
      //Based on the type of account fetch the account id to add account team
       if (a.typeFlag == 'S') {
          String siteKey = a.siteId;
          if(siteKey2Account.containsKey(siteKey))
          {
             accountId = siteKey2Account.get(siteKey).id;
           } 
          } else
          	{ String acctKey = a.accountId; if(primary2Account.containsKey(acctKey))
          		{
           		  accountId = primary2Account.get(acctKey).id;
           }	 }
      if (accountId != null && a.overlayReps != null) {
              for (OverlayRep ovRep : a.overlayReps) {
                User u = key2user.get(ovRep.overlayRepId);
                if (u != null) {
                  AccountTeamMember member = new AccountTeamMember();
                  member.AccountId = accountId;
                  member.UserId = u.id;
                  // This field is apparently legacy not required for AccountTeamMember? -- JoeK
                  //member.AccountAccessLevel = 'Edit';
                  if(ovRep.overlayRepRole != null && ovRep.overlayRepRole !='')
                     member.TeamMemberRole = ovRep.overlayRepRole;
                  else 
                     member.TeamMemberRole = 'Overlay';
                  newTeamMembers.add(member);
                  
                  AccountShare share = new AccountShare();
                  share.AccountId = accountId;
                  share.UserOrGroupId = u.id;
                  share.AccountAccessLevel = 'Edit';
                  // @TODO: Does the following really work or do we have to create an Opp share too? -- JoeK
                  //        Seems to create a opportunityShare record automatically - Ritesh   
                  // @TODO: What happens if we change owner of an opportunity?
                  share.OpportunityAccessLevel = 'Edit';
                  //       OpportunityShare Created with RowCause='ImplicitChild' And OpportunityAccess='Edit' 
                  //       Confirmed with  OWD Settings on Account::Public ReadOnly and Opportunity::Public ReadOnly - Virendra
                  newShares.add(share);
                  
         //       }
         //     }
            }
           }
          }
        }
        
       etime = system.now();  
       dTime = (etime.getTime()-stime.getTime());
       resp.accountTeamShareCreationTime += ''+(dTime / 1000.0); 
       
        stime = System.now();
        Integer rCounter = 0;
        if(newTeamMembers.size() > 0) {
           System.debug('::Before insert team Members :::');
           Database.SaveResult[] svResult  = Database.insert(newTeamMembers,dlo);
           for(Database.SaveResult sr:svResult){
              if(newTeamMembers.size()==rCounter)
                  break;
              if(!sr.isSuccess()){
                 Database.Error err = sr.getErrors()[0];
                 resp.sfdcErrors.add('Account Id ::'+newTeamMembers.get(rCounter).AccountId+':::New TeamMember:ErrorMssage::'+err.getMessage());
              }
              rCounter++;
           }
         }else{
           resp.accountTeamCreationTime += '\nNo Match Found For TeamMembers ';
         }
         etime = system.now();  
         dTime = (etime.getTime()-stime.getTime());
         resp.accountTeamCreationTime +=''+(dTime / 1000.0);
         
         stime = System.now();
         rCounter = 0;
         if (newShares.size() > 0) {
           System.debug('::Before insert team Share :::');
           Database.SaveResult[] svResult  = Database.insert(newShares,dlo);
           for(Database.SaveResult sr:svResult){
             if(!sr.isSuccess()){
               
                if(newShares.size()==rCounter)
                  break;
                Database.Error err = sr.getErrors()[0];
                resp.sfdcErrors.add('Account Id ::'+newShares.get(rCounter).AccountId+'::::New AccountShare ErrorMssage::'+err.getMessage());
                 rCounter++;
             }
           }
         }else{
           resp.accountShareCreationTime += '\nNo Match Found AccountShare ';
         }
        etime = system.now();  
        dTime = (etime.getTime()-stime.getTime());
        resp.accountShareCreationTime += ''+(dTime / 1000.0); 
    }catch(Exception ex){
        throw new AssignmentServiceException(ex.getMessage());
    }
  }

}