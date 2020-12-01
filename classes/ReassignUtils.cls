public class ReassignUtils {

  public static String REASSIGN_NOT_ALLOWED='Reassignment is not Valid';
  public static String MISSING_SP_ID='SalesPerson ID Does Not Exist';
  public static String MANAGER_NOT_FOUND='Manager Is Either Inactive or Does Not Exist';
  public static String REASSIGN_PENDING='Another Reassignment for this Account is Pending Approval';
  public static String NO_ACTIVE_SALES_REP='No Active SalesRep Exists';
  public static String QUEUE_NOT_VALID='Request Does Not Have A Valid Approval/Rejection Status';
  public static String NO_APP_REJ_AUTHORITY='User Does Not Have Approval/Rejection Authority';
  public static String NO_REASSIGN_PERMISSION='You do not have the Permission to Reassign Prospects';
  public static boolean BYPASSVALIDATION=false;
  public boolean isAdmin {get;set;}

  public ProspectReassignment__mdt ReassignMetadata;

  public class ReassignData {
    public ID AccountID;
    public ID toUserID;
    public String status_code;
    public String status_msg;
  }

    public ReassignUtils() {
    executeoncetest.onceprospectmsg=false;
        ReassignMetadata = new ProspectReassignment__mdt();
            for (ProspectReassignment__mdt pm:[SELECT Id,Approval_error_Link__c, Error_Report_link__c, User_Access_Title__c,Reassignment_Types__C from ProspectReassignment__mdt limit 1]) {
            ReassignMetadata = pm;
        }

       isAdmin = false;

        for (groupMember g:[SELECT Id, UserOrGroupId from groupMember where group.name='ReAssignment Admin' and UserOrGroupId=:userInfo.getUserId()])
            isAdmin = true;

    }

  public class AppRejData {
    public ID QueueID;
    public String status_code;
    public String status_msg;
  }

  list<ReassignData> response;
  list<AppRejData> AppRejResponse;


  public boolean getIsAdmin() {
  return isAdmin;
  }


  public boolean ReassignAllowed() {
      list<String> shortTitles=new list<String>();

      if (isAdmin)
        return true;

      if (ReassignMetaData.User_Access_Title__c != null) {
          String[] stitles = ReassignMetaData.User_Access_Title__c.split(',');
          //for (String s:stitles)
          shortTitles.addAll(stitles);
       list<user> u = [Select id from user where id=:userInfo.getUserId() and Short_Title__c=:shortTitles];
          if (u.size() == 0)
              return false;


      }

      return true;
  }

  public boolean appRejAllowed(ID Approver) {
      if (approver != userInfo.getUserId())
        return false;
      else
        return true;
  }

  public list<user> getUserHier() {
        list<ID> tmplist = new list<ID> ();
        list<user> lUserList = new list<user> ();
        User lusr = [select id from user where id = :userInfo.getUserId()];
        lUserList.add(lusr);
        tmplist.add(UserInfo.getUserid());


        system.debug('Call to code UserList');
        While (!tmplist.isEmpty())
        {
             list<user> ulist = [SELECT ID from user where manager.id = :tmplist];
             system.debug('Hier Query Executed');
             tmplist.clear();
             For (User u : ulist) {
                tmplist.add(u.id);
                lUserList.add(u);
             }
        }

        return lUserList;
  }

  public list<ReassignData> ReassignAccounts(list<ReassignData> siteReq) {

      executeoncetest.onceprospectmsg=false;
      ID RequestorID = userInfo.getUserId();
      system.debug('Current Requestor:' + RequestorID);
      system.debug('Site Req:'+siteReq);
      Map<ID,boolean> reqHier = new Map<ID,boolean>();
      list<ReassignData> approvedAccts = new list<ReassignData>();
      list<ReassignData> notApprovedAccts = new list<ReassignData>();
      response = new list<ReassignData>();

      //Build Current ownerMap for Requested Accounts
      list<ID> accountIDs = new list<ID>();
      for (ReassignData r:siteReq)
        accountIDs.add(r.AccountID);
      Map<ID,ID> currentOwnerMap = new Map<ID,ID> ();
      for (Account a:[select id,ownerid from account where id = :accountIDs])
        currentOwnerMap.put(a.id,a.ownerId);
      //Modified By Vipul Jain for story#442656 (00771958 - Prospect Reassignment- Open Permission for Unassigned Prospects) on 4 October,2016
      Map<ID, String> ownerNameMap = New Map<ID, String>();
      for (User u:[select id,Name from User where id IN :currentOwnerMap.values()])
        ownerNameMap.put(u.id,u.Name);

      Set<String> prospectOrgOwnerSet = new Set<String>();
      for(ProspectOriginalOwner__mdt prospectOrgOwnerList: [Select MasterLabel,DeveloperName from ProspectOriginalOwner__mdt]){
        String MasterLabel = prospectOrgOwnerList.MasterLabel;
        MasterLabel = MasterLabel.toUpperCase();
        prospectOrgOwnerSet.add(MasterLabel);
      }
      //END - Vipul Jain for story#442656 (00771958 - Prospect Reassignment- Open Permission for Unassigned Prospects) on 4 October,2016
      //Build UserHierarchy Map
      For (User u: getUserHier()) {
        reqHier.put(u.id,true);
      }

      Map<ID,Reassignment_Queue__c> pendingReassignmentMap = new Map<ID,Reassignment_Queue__c>();
      for(Reassignment_Queue__c q:[select id,account__c from reassignment_queue__c where account__c=:accountIDs and status__c = 'Pending Approval'])
         pendingReassignmentMap.put(q.Account__c,q);

      //Validate Reassignment
      for (ReassignData r:siteReq) {
         if (isReassignValid(currentOwnerMap.get(r.AccountID),r.toUserID,reqHier) && !pendingReassignmentMap.containsKey(r.AccountID)) {
              system.debug('Current Owner:'+currentOwnerMap.get(r.AccountID));
              system.debug('Account:'+ r.AccountID);
              //Modified By Vipul Jain for story#442656 (00771958 - Prospect Reassignment- Open Permission for Unassigned Prospects)
              //                            Modified below use of 'isApprovalRequired' method, on 4 October,2016
              if (isApprovalRequired(currentOwnerMap.get(r.AccountID),r.toUserID,reqHier,ownerNameMap.get(currentOwnerMap.get(r.AccountID)),prospectOrgOwnerSet)) {
                //END -Vipul
                 notApprovedAccts.add(r);
              }
              else {
                ApprovedAccts.add(r);
              }
              r.status_code='S';

         }
         else {
            r.status_code='E';

            if (!isReassignValid(currentOwnerMap.get(r.AccountID),r.toUserID,reqHier))
             r.status_msg=REASSIGN_NOT_ALLOWED;
            else {
             r.status_msg=REASSIGN_PENDING;
            }

            response.add(r);
         }
      }

      AutoApprove(ApprovedAccts);

      submitApproval(notApprovedAccts,currentOwnerMap);

      return response;
  }

      public boolean isReassignValid(ID OldOwner,ID newOwner, Map<ID,boolean> reqHier) {
          system.debug('Request Hierarchy:'+reqHier);
          system.debug('new Owner:'+newOwner);
          system.debug('containkey:'+reqHier.containsKey(newOwner));

          if (isAdmin)
             return true;

          if (!reqHier.containsKey(newOwner))
            return false;
          else
            return true;
      }

      //Modified By Vipul Jain for story#442656 (00771958 - Prospect Reassignment- Open Permission for Unassigned Prospects) on 4 October,2016
      public boolean isApprovalRequired(ID OldOwner,ID newOwner, Map<ID,boolean> reqHier, String userName,Set<String> prospectOrgOwnerSet) {

          Boolean Flag= true;
          String uname = userName.toUpperCase();
          if(prospectOrgOwnerSet.contains(uname))
             Flag =false;


          if(!Flag)
            return false;
          //END - Vipul story#442656 (00771958 - Prospect Reassignment- Open Permission for Unassigned Prospects) on 4 October,2016
          if (isAdmin)
            return false;

          if (!reqHier.containsKey(oldOwner) && reqHier.containskey(newOwner))
            return true;
          else
            return false;
      }

      public void AutoApprove(list<ReassignData> accts) {
         list<ID> uids = new list<ID>();
         Map<ID,ID> spIDs = new Map<ID,ID>();
         list<Account> acUpd = new list<Account>();
         list<Account> sUpd = new list<Account>();
         list<Reassignment_Queue__c> rqUpd = new list<Reassignment_Queue__c>();
         Map<ID,ReassignData> acMap = new Map<ID,ReassignData>();

         for (ReassignData r:accts) {
           uids.add(r.toUserID);
           acMap.put(r.AccountID,r);
        }

        Map<ID,ID> accToSite = new Map<ID,ID>();
        for (account a:[select related_account__c,id from account where related_account__c=:acMap.keySet() and Primary_Site__c=true])
           accToSite.put(a.related_account__c,a.id);


         for (sales_person__c s: [select id,user__c from sales_person__c where user__c=:uids and isactive__c=true and primary__c=true])
           spIDs.put(s.user__c,s.id);

         for (ReassignData r:accts) {
           if (spIDs.containsKey(r.toUserID)) {
              Account a = new Account(id=r.Accountid);
              a.ownerid=r.toUserID;
              a.Sales_PersonID__c = spIDs.get(r.toUserID);
           if (accToSite.containsKey(r.Accountid)) {
                   Account s = new Account(id=accToSite.get(r.Accountid));
                   s.OwnerId = r.toUserID;
                   s.Sales_PersonID__c = spIDs.get(r.toUserID);
                   sUpd.add(s);
            }
              acUpd.add(a);
           }
           else {
               r.status_code='E';
               r.status_msg=MISSING_SP_ID;
               response.add(r);
               Reassignment_Queue__c rq = new Reassignment_Queue__c();
               rq.Account__c = r.AccountID;
               rq.Requestor__c = UserInfo.getUserid();
               rq.New_Owner__c = r.touserID;
               rq.Approver__c = UserInfo.getUserid();
               rq.Status__c = 'Failed';
               rq.status_message__C = MISSING_SP_ID;
               rqUpd.add(rq);
           }
         }

         list<Database.saveResult> aResult = Database.Update(acUpd,false);
         list<Database.saveResult> aResultsites = Database.Update(sUpd,false);
         system.debug('DB SaveResult:'+aResult);
         //for (Database.saveResult sr:aResult) {
           for (integer i=0;i<aResult.size();i++) {
            system.debug('Result Account ID:'+ acUpd[i].ID);

            if (aResult[i].isSuccess()) {
               ReassignData rd=acMap.get(acUpd[i].id);
               rd.status_code='S';
               Reassignment_Queue__c rq = new Reassignment_Queue__c();
               rq.Account__c = rd.AccountID;
               rq.Requestor__c = UserInfo.getUserid();
               rq.New_Owner__c = rd.touserID;
               rq.Approver__c = UserInfo.getUserid();
               rq.Status__c = 'Auto Approved';
               rq.Approve_Reject_Date__c = system.now();
               rqUpd.add(rq);
               response.add(rd);
            }
            else {
                  ReassignData rd=acMap.get(acUpd[i].id);
                  ReassignData rderror=new ReassignData();
                  rderror.status_code='E';
                  Reassignment_Queue__c rq = new Reassignment_Queue__c();
                  rq.Account__c = rd.AccountID;
                  rq.Requestor__c = UserInfo.getUserid();
                  rq.New_Owner__c = rd.touserID;
                  rq.Approver__c = UserInfo.getUserid();
                  rq.Status__c = 'Failed';

                if (aResult[i].getErrors().size() > 0) {
                   rderror.status_msg=aResult[i].getErrors()[0].getMessage();
                   rq.status_message__C = MISSING_SP_ID;
                }
                else {
                   rderror.status_msg='Unexpected Error During Update';
                   rq.status_message__C = 'Unexpected Error During Update';
                }
                   rqUpd.add(rq);
                   response.add(rderror);
            }

         }

          list<Database.saveResult> rqResult = Database.Insert(rqUpd,false);


      }

      public void submitApproval(list<ReassignData> accts,Map<ID,ID> currentOwnerMap) {
          Map<ID,ReassignData> acMap = new Map<ID,ReassignData>();
          list<Reassignment_Queue__c> qUpd = new list<Reassignment_Queue__c>();
          Map<ID,ID> usertoMgrMap = new Map<ID,ID>();

          For(user u:[select id,managerid from user where id=:currentOwnerMap.values() and managerid !=null and manager.isactive=true]) {
            usertoMgrMap.put(u.id,u.managerid);
          }
          system.debug('Deepak1:'+usertoMgrMap);
          system.debug('Deepak2:'+currentOwnerMap);
          for (ReassignData r:accts) {
           acMap.put(r.AccountID,r);
          }

          for (ReassignData r:accts) {
            if (usertoMgrMap.containsKey(currentOwnerMap.get(r.AccountId))) {
               Reassignment_Queue__c rq = new Reassignment_Queue__c();
               rq.Account__c = r.AccountID;
               rq.Requestor__c = UserInfo.getUserid();
               rq.New_Owner__c = r.touserID;
               rq.Approver__c = usertoMgrMap.get(currentOwnerMap.get(r.AccountId));
               rq.Status__c = 'Pending Approval';
               qUpd.add(rq);
            }
            else {
                r.status_code = 'E';
                r.status_msg=MANAGER_NOT_FOUND;
                response.add(r);

                Reassignment_Queue__c rq = new Reassignment_Queue__c();
                rq.Account__c = r.AccountID;
                rq.Requestor__c = UserInfo.getUserid();
                rq.New_Owner__c = r.touserID;
                //rq.Approver__c = UserInfo.getUserid();
                rq.Status__c = 'Failed';
                rq.status_message__C = MANAGER_NOT_FOUND;
                qUpd.add(rq);
            }
          }

         list<Database.saveResult> aResult = Database.insert(qUpd,false);
         //for (Database.saveResult sr:aResult) {
           for (integer i=0;i<aResult.size();i++) {
            ReassignData rd=acMap.get(qUpd[i].Account__c);
            if (qUpd[i].status__c == 'Pending Approval') {
              if (aResult[i].isSuccess()) {
                rd.status_code='S';
              }
              else {
                  rd.status_code='E';
                  if (aResult[i].getErrors().size() > 0)
                   rd.status_msg=aResult[i].getErrors()[0].getMessage();
                  else
                   rd.status_msg='Unexpected Error During Update';
              }
              response.add(rd);
            }
         }
      }


     public list<AppRejData> ApproveRej(list<ID> QueueID,String type) {
        AppRejResponse = new list<AppRejData>();
        list<ID> uIDs = new list<ID>();
        Map<ID,Reassignment_Queue__c> IDtoQueueMap = new Map<ID,Reassignment_Queue__c>();
        Map<ID,ID> spIDs = new Map<ID,ID>();
        list<Account> acUpd = new list<Account>();
        list<Account> sUpd = new list<Account>();

        list<Reassignment_Queue__c> rq = [select id,account__c,Approver__c,Approve_Reject_Date__c,Status__c,New_Owner__c,New_Owner__r.isactive from reassignment_queue__c where id=:QueueID ];

        if (type=='A') {
           list<ID> accIDs = new list<ID>();
           for(Reassignment_Queue__c q:rq) {
             uIDs.add(q.New_Owner__c);
             IDtoQueueMap.put(q.ID,q);
             accIDs.add(q.Account__c);
           }

           Map<ID,ID> accToSite = new Map<ID,ID>();
           for (account a:[select related_account__c,id from account where related_account__c=:accIds and Primary_Site__c=true])
             accToSite.put(a.related_account__c,a.id);

           for (sales_person__c s: [select id,user__c from sales_person__c where user__c=:uids and isactive__c=true and primary__c=true])
            spIDs.put(s.user__c,s.id);


            For (ID I:QueueID) {
              AppRejData ar = new AppRejData();
              ar.QueueID = I;
              Reassignment_Queue__c r = IDtoQueueMap.get(I);


              if (!AppRejAllowed(r.Approver__c) && BYPASSVALIDATION == FALSE) {
                 ar.status_code = 'E';
                 ar.status_msg=NO_APP_REJ_AUTHORITY;
              }
              else if (r.status__c != 'Pending Approval') {
                ar.status_code = 'E';
                ar.status_msg=NO_ACTIVE_SALES_REP;
              }
              else if (r.New_Owner__r.isactive) {
                if (spIDs.containsKey(r.New_Owner__c)) {

                 Account a= new Account(id=r.Account__c);
                 a.ownerID = r.New_Owner__c;
                 a.Sales_PersonID__c = spIDs.get(r.New_Owner__c);
                 acUpd.add(a);

                 if (accToSite.containsKey(r.Account__c)) {
                    Account s = new Account(id=accToSite.get(r.Account__c));
                    s.ownerID = r.New_Owner__c;
                    s.Sales_PersonID__c = spIDs.get(r.New_Owner__c);
                    sUpd.add(s);
                 }

                 r.status__c = 'Approved';
                 r.Approve_Reject_Date__c = system.now();
                 r.Autoapprove7thDay__c=false;
                 ar.status_code = 'S';
                 AppRejResponse.add(ar);

                }
                else {
                //failed
                ar.status_code = 'E';
                ar.status_msg=MISSING_SP_ID;
                r.status__c = 'Failed';
                r.Status_Message__c = MISSING_SP_ID;
                r.Autoapprove7thDay__c=false;

                }
              }
              else {
                //failed
                ar.status_code = 'E';
                ar.status_msg=NO_ACTIVE_SALES_REP;
                r.status__c = 'Failed';
                r.Status_Message__c = NO_ACTIVE_SALES_REP;
                r.Autoapprove7thDay__c=false;

              }
               AppRejResponse.add(ar);
            }
             list<Database.saveResult> aResult = Database.update(acUpd,false);
             list<Database.saveResult> aResults = Database.update(sUpd,false);

        }
        else if (type=='R') {
          for(Reassignment_Queue__c r: rq) {
            AppRejData ar = new AppRejData();
            r.status__c = 'Rejected';
            r.Approve_Reject_Date__c = system.now();
            r.Autoapprove7thDay__c=false;
            ar.status_code = 'S';
            AppRejResponse.add(ar);
          }
        }
        else if (type=='C') {
          for(Reassignment_Queue__c r: rq) {
            AppRejData ar = new AppRejData();
            r.status__c = 'Cancelled';
            r.Autoapprove7thDay__c=false;

            //r.Approve_Reject_Date__c = system.now();
            ar.status_code = 'S';
            AppRejResponse.add(ar);
          }
        }
        else {
        }



        if (type=='C')
            list<Database.deleteResult> qResultd = Database.delete(rq,false);
        else
         list<Database.saveResult> qResult = Database.update(rq,false);

        return AppRejResponse;

      }

}