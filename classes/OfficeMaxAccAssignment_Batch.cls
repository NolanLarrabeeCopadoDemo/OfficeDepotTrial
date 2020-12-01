/*
Description: The Scope of this AccountTeamAssignment Object for OfficeMax recordtype.
This batch will add overlays to the Account.

Created By: Subhrajyoti
Created Date: 14-Mar-2014

Modified By: Sushma Kamisetty
Modified Date: 10th July 2014
Modify Reason: createddate filter is added in the Default_Query to avoid the aborting of batch which is due to query running longer than 2 minutes as per case # 206686

Modified By: Sushma Kamisetty
Modified Date: 18-Jul-2014
Modify Reason: Changed DML statements to database method DML statements.   
*/
global class OfficeMaxAccAssignment_Batch implements database.Batchable<Sobject>, Schedulable
{
    public String strQuery; //this variable used to set query from test class or from shceduler if required
    // below is set a default query in case not set in test class or in scheduler
    private String DEFAULT_QUERY = 'Select Id, AccountId__c,RecordType.Name, AccountType__c, Entity_Type__c, Entity_Id__c, PrimaryEmpId__c, PrimaryEmpRole__c, ' 
                            +' OverlayEmpID1__c, OverlayEmpID2__c, OverlayEmpID3__c, OverlayEmpID4__c, OverlayEmpID5__c, OverlayEmpID6__c, OverlayEmpID7__c, OverlayEmpID8__c,' 
                            +' OverlayEmpID9__c, OverlayEmpID10__c, OverlayEmpID11__c, OverlayEmpID12__c, OverlayEmpID13__c, OverlayEmpID14__c, OverlayEmpID15__c,' 
                            +' OverlayEmpID16__c, OverlayEmpID17__c, OverlayEmpID18__c, OverlayEmpID19__c, OverlayEmpID20__c, OverlayEmpID21__c, OverlayEmpID22__c, OverlayEmpID23__c,' 
                            +' OverlayEmpID24__c, OverlayEmpID25__c, OverlayEmpID26__c, OverlayEmpID27__c, OverlayEmpID28__c, OverlayEmpID29__c, OverlayEmpID30__c,' 
                            +' OverlayEmpRole1__c, OverlayEmpRole2__c, OverlayEmpRole3__c, OverlayEmpRole4__c, OverlayEmpRole5__c, OverlayEmpRole6__c, '
                            +' OverlayEmpRole7__c, OverlayEmpRole8__c, OverlayEmpRole9__c, OverlayEmpRole10__c, OverlayEmpRole11__c, OverlayEmpRole12__c,' 
                            +' OverlayEmpRole13__c, OverlayEmpRole14__c, OverlayEmpRole15__c,OverlayEmpRole16__c, OverlayEmpRole17__c, OverlayEmpRole18__c, OverlayEmpRole19__c, OverlayEmpRole20__c,'
                            +' OverlayEmpRole21__c, OverlayEmpRole22__c, OverlayEmpRole23__c, OverlayEmpRole24__c, OverlayEmpRole25__c, OverlayEmpRole26__c, OverlayEmpRole27__c,'
                            +' OverlayEmpRole28__c, OverlayEmpRole29__c, OverlayEmpRole30__c,Status__c, Error_Message__c'
                            +' from AccountAssignments__c where Status__c != \'Processed\' and RecordType.Name =\'OfficeMax\' and createddate >= yesterday';     

    /* Default Constructor*/
    global OfficeMaxAccAssignment_Batch()
    {
    }
    
    /*This costructor is called from the Batch Schedule mathod*/
    global OfficeMaxAccAssignment_Batch(String query)
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
        List<AccountAssignments__c> lstAssignments = scope;
        Set<String> entityid= new Set<String>();// to fetch Accounts(Customers and Sites) based on entityid.
        Set<String> OverlayEmployeeid= new Set<String>();// to fetch users based on overlayempid.
        Map<String,Schema.RecordTypeInfo> AccountRecType = Schema.SObjectType.Account.getRecordTypeInfosByName();
        
        // loop on the batch scope 
        for(AccountAssignments__c objAssignment: lstAssignments)
        {
            // If by chance AccounId__c field is null or blank, skip the record
            if(objAssignment.Entity_Id__c != null && objAssignment.Entity_Id__c != '')  
            {
              //  entityid.add(objAssignment.Entity_Id__c);
              entityid.add(objAssignment.AccountId__c);
                //Add overlay repids to set
                for(Integer k =1;k<=30;k++)
                {                            
                    String Obj_OverlayEMPID = 'OverlayEmpID'+k+'__c';
                    if((objAssignment.get(Obj_OverlayEMPID) != null) &&(objAssignment.get(Obj_OverlayEMPID) != ''))
                    {
                        OverlayEmployeeid.add(String.valueOf(objAssignment.get(Obj_OverlayEMPID)));                                   
                    }                        
                }
            }
        }
        Set<Id> headerids= new Set<Id>();
        Map<ID, Account> mapAccounts = new Map<ID, Account>([select id,OMX_Primary_Key__c,RecordTypeId from Account where OMX_Primary_Key__c IN: entityid]);
        Map<Id, Map<Id, AccountTeamMember>> acctId2UserTeamMap = new Map<Id, Map<Id, AccountTeamMember>>(); // map of Account Id as key & map of UserId/ AccountTeamMember
        List<AccountAssignments__c> updateAssignments = new List<AccountAssignments__c>(); // List to hold assigment records to update status
        Map<String,Account> MapofOMXPrimarykeyAccount = new Map<String,Account>();
        Map<Id,Id> MapofHeaderandSiteID= new Map<Id,Id>();
        Set<Id> primarysiteid= new Set<Id>();
        Map<Id,Id> mapofSiteandOwner= new Map<Id,Id>();
        for(Account acc:mapAccounts.values())
        {
            if(acc.recordtypeid== AccountRecType.get('Customer (OfficeMax)').getRecordTypeId())
            {
                headerids.add(acc.id);
            }
            MapofOMXPrimarykeyAccount.put(acc.OMX_Primary_Key__c,acc);
        }
        for(Account primarysite:[Select id,OMX_Primary_Key__c,Recordtypeid,Related_Account__c,Primary_Site__c,Ownerid from Account where Related_Account__c IN: headerids and Primary_Site__c=:true])
        {
            primarysiteid.add(primarysite.id);
            mapofSiteandOwner.put(primarysite.id,primarysite.Ownerid);
            MapofHeaderandSiteID.put(primarysite.Related_Account__c,primarysite.id);
        }
        Map<String,User> mapEmpId2User= new Map<String,User>();
        for(User u1:[select id,OMX_Rep_Number__c from User where OMX_Rep_Number__c IN: OverlayEmployeeid and isActive = true])
        {
            mapEmpId2User.put(u1.OMX_Rep_Number__c,u1);
        }
        
        for(AccountAssignments__c objAssignment: lstAssignments)
        {
            String strErrorMessage = '';
            Account Acct= new Account();
            if(objAssignment.Entity_Id__c != null && objAssignment.Entity_Id__c != '')
            {
               // Acct = MapofOMXPrimarykeyAccount.get(objAssignment.Entity_Id__c);
               Acct = MapofOMXPrimarykeyAccount.get(objAssignment.AccountId__c);
                if(Acct!=null)
                {
                    String strErrorMessage1 = '';                
                    List<Overlay> oOverlayLst = new List<Overlay>();
                    //Creating the List for Further USE
                    for(Integer i =1;i<=30;i++)
                    {                            
                        String OverlayEMPID = 'OverlayEmpID'+i+'__c';
                        String OverlayRoleID = 'OverlayEmpRole'+i+'__c';                            
                        if((objAssignment.get(OverlayEMPID) != null) &&(objAssignment.get(OverlayEMPID) != ''))
                        {
                             Overlay oOverlay = new Overlay();
                             oOverlay.Sequence = i;
                             oOverlay.oEMPID =  String.valueOf(objAssignment.get(OverlayEMPID));
                             oOverlay.oEMPROLE = String.valueOf(objAssignment.get(OverlayRoleID));
                             oOverlayLst.add(oOverlay);
                        }                        
                    } 
                    for(Integer p =0;p<oOverlayLst.size();p++)
                    {
                        String e = checkAndAddOverlay(objAssignment, oOverlayLst[p].Sequence, acct.Id, oOverlayLst[p].oEMPID,  oOverlayLst[p].oEMPROLE, mapEmpId2User, acctId2UserTeamMap);
                        if(e.trim() != '')
                        {
                            strErrorMessage1 += ' '+e;
                        }
                    } 
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
            if(acct != null)
            {
                System.debug('11111');
                objAssignment.Account__c = acct.Id;
            }
            if(strErrorMessage.trim() == '')
            {                    
                objAssignment.Status__c = 'Processed';                  
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
       //  for(Id accId: acctId2UserTeamMap.keySet()) 
            for(Id accId: mapAccounts.keySet())
            {
                //Id oldOwnerId = accIdOwnerIdMap.get(accId);
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
                                 //newATMMap.remove(newATM.UserId);
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
                            //if(oldOwnerId == oldATM.UserId)
                                //continue;
                                
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
                //Id oldOwnerId = accIdOwnerIdMap.get(accShare.AccountId);
                //if(accShare.UserOrGroupId == oldOwnerId)// this is to avoid deleting old owners share record as it should delete automatically, this is extra check
                    //continue;
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
            
            if(listAccountShares2Delete != null && listAccountShares2Delete.size() > 0)
                Database.delete(listAccountShares2Delete,false);
            if(oldATM2Delete != null && oldATM2Delete.size() > 0)
                Database.delete(oldATM2Delete,false);
            if(accShareList != null && accShareList.size() > 0)
                Database.insert(accShareList,false);
            if(newATM2Insert != null && newATM2Insert.size() > 0)
                Database.insert(newATM2Insert,false);
            if(updateAssignments != null && updateAssignments.size() > 0)
                Database.update(updateAssignments,false); 
                
        /*Copy the ATM of a header record into the primary Site of that header */
        List<AccountTeamMember> insertsiteATM=new List<AccountTeamMember>();
        List<AccountShare> insertsiteaccshare= new List<AccountShare>();
        for(AccountTeamMember fetchheaderATM:[Select Id, AccountId, UserId, TeamMemberRole, AccountAccessLevel From AccountTeamMember where AccountId in : headerids])
        {
            Id Primarysite=MapofHeaderandSiteID.get(fetchheaderATM.AccountId);
            if(Primarysite!=null)
            {
                AccountTeamMember primarysiteATM= new AccountTeamMember();
                primarysiteATM.AccountId= Primarysite;
                primarysiteATM.UserId= fetchheaderATM.UserId;
                primarysiteATM.TeamMemberRole= fetchheaderATM.TeamMemberRole;
                insertsiteATM.add(primarysiteATM);
                
                AccountShare primarysiteaccShare = new AccountShare();
                primarysiteaccShare.AccountId = Primarysite;
                primarysiteaccShare.UserOrGroupId = fetchheaderATM.UserId;
                primarysiteaccShare.AccountAccessLevel = 'Edit';
                primarysiteaccShare.OpportunityAccessLevel = 'Edit';
                insertsiteaccshare.add(primarysiteaccShare);
                
            }
        }
        List<AccountTeamMember> deletesiteATM= new List<AccountTeamMember>();
        for(AccountTeamMember delATM_alias:[Select id,AccountId, UserId, TeamMemberRole, AccountAccessLevel from AccountTeamMember where AccountId in: primarysiteid])
        {
            Id siteOwnerid=mapofSiteandOwner.get(delATM_alias.accountid);
            if(siteOwnerid!=null && siteOwnerid==delATM_alias.UserId)
                continue;
            deletesiteATM.add(delATM_alias);
            
        }
        List<AccountShare> deletesiteaccshare= new List<AccountShare>();
        for(AccountShare delAccShare:[Select id,UserOrGroupId,AccountId from AccountShare where AccountId in: primarysiteid])
        {
           Id siteOwnerid=mapofSiteandOwner.get(delAccShare.accountid); 
           String identufyuserOrgroup= delAccShare.UserOrGroupId;
           system.debug('siteOwnerid-->'+siteOwnerid);
           if(siteOwnerid!=null && siteOwnerid==delAccShare.UserOrGroupId)
               continue;
           if(identufyuserOrgroup.startswith('00G'))
               continue;    
           deletesiteaccshare.add(delAccShare);
        }
        system.debug('deletesiteaccshare-->'+deletesiteaccshare);
        if(deletesiteaccshare!=null && deletesiteaccshare.size()>0)
            Database.delete(deletesiteaccshare,false);
        if(deletesiteATM!=null && deletesiteATM.size()>0)
            Database.delete(deletesiteATM,false);
        if(insertsiteaccshare!=null && insertsiteaccshare.size()>0)
            Database.insert(insertsiteaccshare,false);
        if(insertsiteATM!=null && insertsiteATM.size()>0)
            Database.insert(insertsiteATM,false);           
                
    }
     /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        
    }
     
     /*   This method must be there to implement Schedulable interface */
    
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        OfficeMaxAccAssignment_Batch assignBatch = new OfficeMaxAccAssignment_Batch(strQuery);
        database.executebatch(assignBatch, 500);
    }
    private String checkAndAddOverlay(AccountAssignments__c objAssignment, Integer repNo, Id accntId, String overlayEmpId, String empRoleId, Map<String, User> mapRep2User, Map<Id, Map<Id, AccountTeamMember>> acctId2TeamMap)
    {
        String errorMessage = overlayTeamRep(repNo, accntId, overlayEmpId, empRoleId, mapRep2User, acctId2TeamMap); 
        return errorMessage;
    }  
    /*
        This method is to find matching Active user record and create Account Team Member object record
    */
    private String overlayTeamRep(Integer repNo, Id accntId, String overlayEmpId, String empRoleId, Map<String, User> mapRep2User, Map<Id, Map<Id, AccountTeamMember>> acctId2TeamMap)
    {
        System.debug('OVERLAY Rep Id '+repNo+ ' ==='+overlayEmpId);
        String errorMessage = '';
        if(overlayEmpId == null || overlayEmpId == '') 
            return errorMessage;
        User empUser;
        AccountTeamMember atm;
        if(overlayEmpId != null && overlayEmpId != '')
            empUser = mapRep2User.get(overlayEmpId);
        system.debug('The overlay user-->'+empUser);        
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
          /*   Subro this code was not there i just added it and commented the line bellow */
              if(empRoleId != null && empRoleId != '')
                atm.TeamMemberRole = empRoleId;
            else
                atm.TeamMemberRole = 'Overlay';
          
          
          //  atm.TeamMemberRole = 'Overlay';
            atmMap.put(empUser.Id, atm);
            acctId2TeamMap.put(accntId, atmMap);
        }
        else
            errorMessage += 'Not able to find User record for Overlay Rep, user may be inactive.';
       
        system.debug('errorMessage-->'+errorMessage);
        return errorMessage;
    }
  
    public class Overlay
    {
        public Integer Sequence;
        public String oEMPID;
        public String oEMPROLE;
    }
}