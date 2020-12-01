/*
Created by: Subhrajyoti
Created Date: 17-Aug-2012
Created Reason: Case # 6378 ( To default Customer LifeCycle on Opportunity from Account while creating new Opportunity, if Customer Lifecycle on Opportunity is blank)

**** Test coverage is covered by Pricingmain_tc class *****
Modified NBOCK - 12.4.2015 - S-366881 - Commented code to prevent inactive trigger from counting against coverage
*/

//Modified by Nisa for S-374376 [Case#00589591] on 1/23/2016 added "before update" event
trigger Opportunity_Insert on Opportunity (before insert, after update, before update)
{
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    for(Opportunity o: trigger.new)
    {
        if(util.checkRT('Opportunity').contains(o.recordtypeId))
            return;
    }
    // added for ticket 01474559
       if (Trigger.New != null) {
         for (Opportunity myOpp: Trigger.new) {
          if (Util.bizBoxRTIdsByObject('Opportunity').contains(myOpp.RecordTypeId)) {
           return;
          }
         }
        }


  public Id currentUser = UserInfo.getUserId();
  public Id profileId = UserInfo.getProfileId();
  String SysAdmin = System.Label.System_Administrator_ID; //Code added case#01255040
  String SysAdmin2 = System.Label.System_Administrator_2_ID; //Code added case#01255040


  public String recordTypeId = schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get(Label.PLOC_Opportunity_RecordType) != null?schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get(Label.PLOC_Opportunity_RecordType).getRecordTypeId():null;
  List<PermissionSetAssignment> psa = [Select PermissionSet.Name, PermissionSetId, Id, AssigneeId
            From PermissionSetAssignment
            Where PermissionSet.Name = 'PLOC_Opportunity_Stage'
            and
            AssigneeId =: currentUser ];

  /*List<Profile> p = [Select id, Name from Profile
            Where id=:profileId and
            //// Name in : PLOC_Opp_Stage_Access__c.getAll().keyset()];
           (Name = 'System Administrator' or   Name = 'System Administrator 2')];*/

    for (Opportunity opp : Trigger.new){
    
    //Code modified case#01255040 [ remove p.size() > 0) ]
    if(psa.size()>0 || profileId == SysAdmin || profileId == SysAdmin2){
      if((opp.Product_Subtype__c == 'PLOC (Assigned)' || opp.Product_Subtype__c == 'PLOC (ILC Identified)') &&
      (opp.PLOC_Opportunity_Stage__c == '' || opp.PLOC_Opportunity_Stage__c == null) &&
      opp.RecordTypeId == recordTypeId){

        (opp).addError(Label.PLOC_Opportunity_Error);
      }

    }else{

      if((opp.Product_Subtype__c == 'PLOC (Assigned)' || opp.Product_Subtype__c == 'PLOC (ILC Identified)') &&
      (opp.PLOC_Opportunity_Stage__c == '' || opp.PLOC_Opportunity_Stage__c == null) &&
      opp.RecordTypeId == recordTypeId){

        (opp).addError(Label.PLOC_Opportunity_Access_Error);
      }

    }


    }

 //End S-374376 [Case#00589591]
  /*Static ID mpsTech = '012E00000008yDTIAY';
  // Code added case#00138374 starts
    Map<ID,ID> acc_Profile_Map = new Map<ID,ID> ();
  // Code added case#00138374 ends

  // Set the default customer lifecycle on opportunity
  if (Trigger.isInsert) {

    Set<ID> ids= new Set<ID>();
    Set<ID> accids = new Set<ID>();

    for(Opportunity opp:Trigger.New)
    {
        accids.add(opp.AccountID);

        if(opp.Customer_Lifecycle__c==null)
        {
            if(opp.AccountID!=null)
            {
                ids.add(opp.AccountID);
            }
        }
    }
    Map<Id, Account> id_Acc_Map = new Map<Id, Account>([Select id,Customer_Lifecycle__c from Account where id in:ids]);

    // Code added case#00138374 starts
    system.debug('AccountIDs' + ids);
     For (Account_Profile__c ap: [SELECT account__c,ID from account_profile__c where account__c in :accids and recordtypeid = :mpsTech])
       acc_profile_map.put(ap.account__c,ap.id);
    // Code added case#00138374 ends


    for(Opportunity opp:Trigger.New)
    {
        // Code added case#00138374 starts
        system.debug('Profile Map:' + acc_profile_map);
        system.debug('Product' + opp.product__c);
        system.debug('ContainsKey:' + acc_profile_map.containskey(opp.AccountID));
           if (acc_profile_map.containskey(opp.AccountID) && (opp.product__c == 'MPS' || opp.product__c == 'Tech')) {

             opp.Account_Profile__c = acc_profile_map.get(opp.AccountID);
           }
        // Code added case#00138374 ends
        if(opp.Customer_Lifecycle__c==null)
        {
            if(opp.AccountID != null)
            {
                opp.Customer_Lifecycle__c = id_Acc_Map.get(opp.Accountid).Customer_Lifecycle__c;
            }
        }
    }
  }

  // Set the default Stage for all WRF tasks associated with opportunity
  if (Trigger.isUpdate) {
    Map<Id, Opportunity> Oppty_Map = new Map<Id, Opportunity>();
    List<WRF_Task__c> lstRelatedTasks = new List<WRF_Task__c>();
    Set<Id> accid= new Set<Id>();

    // Get all the opportunity ids which are won or lost
    for(Opportunity opp:Trigger.New)
    {
        // Get the old Snapshot of the record
        Opportunity oldOppty = Trigger.oldMap.get(opp.Id);

        if ((opp.stagename != oldOppty.stagename) &&
            (opp.stagename == '100%-Won' || opp.stagename == '0%-Lost' || opp.stagename =='90%-Execute')
           )
          Oppty_Map.put(opp.id,opp);
          accid.add(opp.Accountid);
    }

    // Code added case#00138374 starts
     For (Account_Profile__c ap: [SELECT account__c,ID from account_profile__c where account__c in :accid and recordtypeid = :mpsTech])
       acc_profile_map.put(ap.account__c,ap.id);
    // Code added case#00138374 ends

    // Fetch and Update the WRF Task stage based on opportunity stage
    List<WRF_Task__c> checkduplicateowner = new List<WRF_Task__c>();
    Boolean checkduplicate=false;
    Set<Id> CaseAccountId= New Set<Id>();
    List<Messaging.SingleEmailMessage> mails= new List<Messaging.SingleEmailMessage>();
    //Map<Id,Account> oppAccount= new Map<Id,Account>([Select id, name from Account where id in: accid]);
    List<WRF_Task__c> lstAllWrfTasks = [select id,Parent_WRF_Task__c,Task_Type__c,status__c,WRF_Stage__c,Disposition_Code__c,recordtype.name ,WRF__c,WRF__r.WRF_Opportunity__c,WRF__r.Status,Assigned_To__c,WRF__r.CaseNumber,WRF__r.WRF_Request_Type__c,WRF__r.Subject,WRF__r.WRF_Requestor_Name__c,WRF__r.Accountid from WRF_Task__c where WRF__r.WRF_Opportunity__c IN :Oppty_Map.keySet() or Parent_WRF_Task__r.WRF__r.WRF_Opportunity__c IN :Oppty_Map.keySet()];
    system.debug('The all wrftasks are-->'+lstAllWrfTasks);
    for(WRF_Task__c tsk1:lstAllWrfTasks)
    {
        CaseAccountId.add(tsk1.WRF__r.Accountid);
    }
    Map<Id,Account> CaseAccount= new Map<Id,Account>([Select id,name from account where id in:CaseAccountId]);
    Map<Id,User> wrfowner= new Map<Id,User>([Select id,name,email from user where isActive=true]);
    List<WRF_Task__c> lstParentTasks = new List<WRF_Task__c>();
    Map<Id,WRF_Task__c> MapParentSubTask = new Map<Id,WRF_Task__c>();
    Map<Id,WRF_Task__c> MapNoParentUpdate = new Map<Id,WRF_Task__c>();
    EmailTemplate sendemailTemplate=[SELECT Id, Subject, HtmlValue, Body FROM EmailTemplate WHERE Name = 'Opportunity Closing Notification'];
    if(executeoncetest.oppemailsend)
    {
        for(WRF_Task__c tsk:lstAllWrfTasks)
        {
            //Functionality to send mail to all wrf owner's when opportunity is 90%,100% or 0%
            if((tsk.Disposition_Code__c=='Bids' || tsk.Disposition_Code__c=='Public/GPO') && tsk.status__c!='Completed' && tsk.WRF__r.Status!='Closed' && tsk.WRF__r.Status!='Cancelled')
            {
                //System.debug('assigned to'+tsk.Assigned_To__c+'---->Casenumber-->'+tsk.WRF__c);
                for(WRF_Task__c dupcheck:checkduplicateowner)
                {
                    //system.debug('the four values are-->'+dupcheck.WRF__c+' '+tsk.WRF__c+' '+dupcheck.Assigned_To__c+' '+tsk.Assigned_To__c);
                    if(dupcheck.WRF__c==tsk.WRF__c && dupcheck.Assigned_To__c==tsk.Assigned_To__c)
                    {
                        checkduplicate=true;
                        break;
                    }
                }

                if(checkduplicate==false)
                {
                    String useremail = wrfowner.get(tsk.Assigned_To__c).email;
                    Opportunity opp1= Oppty_Map.get(tsk.WRF__r.WRF_Opportunity__c);
                    Account Caseacc= CaseAccount.get(tsk.WRF__r.Accountid);
                    String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + opp1.Id;
                    String CaseRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + tsk.WRF__r.Id;
                    String Subject= sendemailTemplate.Subject;
                    String ReplacedSubject= (tsk.WRF__r.Subject==null)?Subject.replace('{!Case.Subject}',''):Subject.replace('{!Case.Subject}',tsk.WRF__r.Subject);
                    String HTMLBody= sendemailTemplate.HtmlValue;
                    String Replacedbody=(tsk.WRF__r.CaseNumber==null)?HTMLBody.replace('{!Case.CaseNumber}',''):HTMLBody.replace('{!Case.CaseNumber}',tsk.WRF__r.CaseNumber);
                    Replacedbody=(tsk.WRF__r.WRF_Request_Type__c==null)?Replacedbody.replace('{!Case.WRF_Request_Type__c}',''):Replacedbody.replace('{!Case.WRF_Request_Type__c}',tsk.WRF__r.WRF_Request_Type__c);
                    Replacedbody=(Caseacc.name==null)?Replacedbody.replace('{!Case.Account}',''):Replacedbody.replace('{!Case.Account}',Caseacc.name);
                    Replacedbody=(tsk.WRF__r.WRF_Requestor_Name__c==null)?Replacedbody.replace('{!Case.WRF_Requestor_Name__c}',''):Replacedbody.replace('{!Case.WRF_Requestor_Name__c}',tsk.WRF__r.WRF_Requestor_Name__c);
                    Replacedbody=(CaseRecordURL==null)?Replacedbody.replaceFirst('Click Here',''):Replacedbody.replaceFirst('Click Here',CaseRecordURL);
                    Replacedbody=(fullRecordURL==null)?Replacedbody.replace('Click Here',''):Replacedbody.replace('Click Here',fullRecordURL);
                    Replacedbody=(opp1.stagename==null)?Replacedbody.replace('{!Opportunity.StageName}',''):Replacedbody.replace('{!Opportunity.StageName}',opp1.stagename);
                    system.debug('Replacedbody'+Replacedbody);
                    //Account oppacc=oppAccount.get(opp1.Accountid);
                    User OppOwner= wrfowner.get(opp1.Ownerid);
                    checkduplicateowner.add(tsk);
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage() ;
                    String[] toAddresses = new String[]{useremail};
                    mail.setToAddresses(toAddresses );
                    //mail.setSubject('Opportunity Stage Changes');
                    mail.setSubject(ReplacedSubject);
                    mail.setHtmlBody(Replacedbody);
                    //mail.setHtmlBody('Hi,<br></br><br></br>Account - <b>'+oppacc.name+'</b><br></br>Opportunity Owner - <b>'+OppOwner.Name+'</b><br></br>Link to the Opportunity - '+fullRecordURL+'<br></br>Stage - <b>'+opp1.stagename+'</b><br></br>The Support Number - <b>'+tsk.WRF__r.CaseNumber+'</b><br></br>Request Type - <b>'+tsk.WRF__r.WRF_Request_Type__c+'</b><br></br><br></br>Thanks,<br></br><b>Office depot Team.</b>');
                    mail.setTargetObjectId(tsk.Assigned_To__c);


                    mail.setSaveAsActivity(false);
                    mails.add(mail);
                    System.debug('Send a mail'+useremail+'---->Casenumber-->'+tsk.WRF__c);
                }
                checkduplicate=false;
            }
            //End
            if((tsk.recordtype.name=='WRF Task')&&((tsk.Disposition_Code__c=='Bids')||(tsk.Disposition_Code__c=='Public/GPO')) && ((tsk.status__c!='Completed')||(tsk.status__c!='Cancelled')))
               lstParentTasks.add(tsk);
            if((tsk.recordtype.name=='WRF Sub Task') && (tsk.status__c=='Completed') &&(tsk.Task_Type__c=='Pricing Implementation'))
            {
                if((!MapParentSubTask.ContainsKey(tsk.Parent_WRF_Task__c)) &&(!MapNoParentUpdate.containsKey(tsk.Parent_WRF_Task__c)))
                {
                    MapParentSubTask.put(tsk.Parent_WRF_Task__c,tsk );
                }
            }
            else if((tsk.recordtype.name=='WRF Sub Task') && (tsk.status__c!='Completed') &&(tsk.Task_Type__c=='Pricing Implementation'))
            {
                System.debug('--------'+tsk.id);
                if(!MapNoParentUpdate.ContainsKey(tsk.Parent_WRF_Task__c))
                {
                    MapNoParentUpdate.put(tsk.Parent_WRF_Task__c,tsk );
                }
                if(MapParentSubTask.ContainsKey(tsk.Parent_WRF_Task__c))
                {
                    MapParentSubTask.remove(tsk.Parent_WRF_Task__c);

                }
            }
            else if((tsk.recordtype.name=='WRF Sub Task')&&(tsk.Task_Type__c!='Pricing Implementation') && (!MapNoParentUpdate.containsKey(tsk.Parent_WRF_Task__c)))
            {
                if(!MapParentSubTask.ContainsKey(tsk.Parent_WRF_Task__c))
                {
                   // MapParentSubTask.put(tsk.Parent_WRF_Task__c,tsk );
                     MapParentSubTask.remove(tsk.Parent_WRF_Task__c);
                }

            }
        }
    }
    executeoncetest.oppemailsend=false;
    Messaging.sendEmail(mails);
    checkduplicateowner.clear();

    System.debug('----MAP DATA---'+MapParentSubTask);
    for(WRF_Task__c wrftask : lstParentTasks) {
      String lclStage = Oppty_Map.get(wrftask.WRF__r.WRF_Opportunity__c).stagename;
      if ((lclStage == '100%-Won') &&(MapParentSubTask.get(wrftask.id)!=null))
      {
        wrftask.WRF_Stage__c = 'Won';
      }
      else if (lclStage == '0%-Lost')
        wrftask.WRF_Stage__c = 'Lost';
      lstRelatedTasks.add(wrftask);
    }

    // Update the WRF Tasks
    if(lstRelatedTasks.size() > 0) update lstRelatedTasks;

  }*/

}