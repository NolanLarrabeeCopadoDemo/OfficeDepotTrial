//after undelete,after delete, -- No foot prints for delete
trigger CaseTrigger on Case (after insert,  after update,  before insert, before update, before delete) {
    if (Util.bypassTriggers('CaseEvents')) {
        return;
    }  
  //Start - Added by Najma Ateeq for Story #S-377005
  //Case cse = [select id ,WRF_Request_Type__c from case where id = '500f0000006fnEC'];
  //system.debug(LoggingLevel.Info,'@@cse ' +cse );
  //Connor Flynn S-404758 Start Commenting out consolidated mehtods, uncommenting old way

//    CaseManagement handler = new CaseManagement(trigger.new, trigger.old, trigger.newMap, trigger.oldMap); 
//system.debug(LoggingLevel.Info,'triggerNewList 123 ' +trigger.new);
    
//    if(Trigger.isBefore && Trigger.isInsert)
//        handler.onBeforeInsert();
//    if(Trigger.isBefore && Trigger.isUpdate)
//        handler.onBeforeUpdate();
//    if(Trigger.isAfter && Trigger.isInsert)
//        handler.onAfterInsert();
//    if(Trigger.isAfter && Trigger.isUpdate)
//        handler.onAfterUpdate();
//    if(Trigger.isBefore && Trigger.isDelete)
//        handler.onBeforeDelete();


  //End - Added by Najma Ateeq for Story #S-377005
  /* commented by Najma Ateeq for Story #S-377005 */

    // Common actions to be taken for insert and update
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        
        // Assign Account Extension
        List<Id> acctIds = new List<Id>();

        for (Case c : Trigger.new) {
            Id acctId = c.AccountId;
            
            if (acctId != null) {
                acctIds.add(acctId);
            }
        }
        
        Map<Id, Id> accountIdToExtensionId = (new AccountExtensionHelper()).getAccountExtensionIds(acctIds); 

        for (Case c : Trigger.new) {
            Id acctId = c.AccountId;
            c.Account_Extension_Id__c = accountIdToExtensionId.get(acctId);
        }
    }

  //Connor Flynn
  if(Trigger.isBefore && Trigger.isInsert){
    //CaseManagement.wrfFindRelatedParties(Trigger.new);    //Commented by Purnima for case - 00183263
    //Added by Jyoti for Story S-407215
    CaseManagement.setITStatus(Trigger.new, trigger.oldMap, true);
  }
  //End 
  //Start - Added by Jyoti for Story S-407215
  if(Trigger.isBefore && Trigger.isUpdate){    
    CaseManagement.setITStatus(Trigger.new, trigger.oldMap, false);
  }
  //End Story S-407215
  
 public integer exe;
if(executeoncetest.CallAgainCase){ 
System.debug('==============START===================') ;
System.debug('BEFORE:::  '+Trigger.isBefore);
System.debug('AFTER::: '+Trigger.isAfter);
System.debug('INSERT @@@@@@@'+Trigger.IsInsert);
System.debug('UPDATE @@@@@@@'+Trigger.IsUpdate );
System.debug('=============END===================') ;
 //if(executeoncetest.executeonce<=3){
 
  Boolean isWRF = false;
  Boolean isSupport = false;
  Boolean isAccountMaintanance = false;
  Map<String,Schema.RecordTypeInfo> CaseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName();
  Map<String,Schema.RecordTypeInfo> TaskRecType = Schema.SObjectType.Task.getRecordTypeInfosByName();
  Map<String,Schema.RecordTypeInfo> slarectype = Schema.SObjectType.Case_SLA__c.getRecordTypeInfosByName();
  Set<String> DupAccId = new Set<String>();
  Set<String> RelatedCaseNum= new Set<String>();
  Set<String> RequestorUser= new Set<String>();
  Map<String,List<Account>> map_list_acc = new Map<String,List<Account>>();
  Map<String,List<Account>> map_list_pros= new Map<String,List<Account>>();
  Map<String,List<Case>> map_list_case= new Map<String,List<Case>>();
  Map<String,List<User>> map_list_user= new Map<String,List<User>>();
  List<Case> Diversity_WRFs= new List<Case>();
  Set<ID> set_accountid = new Set<ID>();
  Set<Id> case_ids = new Set<Id>();
  Set<Id> KPICaseid= new Set<Id>();
  Map<Id,Record_History__c> updaterecordhis = new Map<Id,Record_History__c>();
  Set<String> SetWebEmail= new Set<String>();
  Map<String,User> MapofEmailandUser= new Map<String,User>();
  //Id WorkQueueId = [select Id from Group where Name = 'Work Request Queue' and Type = 'Queue'][0].id;
  Id CustOMX = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer (OfficeMax)').getRecordTypeId();   // Added for Support Ticket: 00660249 
  Id supportCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support').getRecordTypeId();

if (Trigger.IsInsert || Trigger.IsUpdate) {
    
    // Production Fix #00809579 - Early Pay Discount Terms NOT WORKING in SFDC
    if (executeoncetest.executeCaseApproval && Trigger.isAfter) {
        System.debug('executeoncetest.executeCaseApproval AND Trigger.isAfter');
            
        for (Case c : Trigger.New) {
            // Prevent recursive approval process submissions (approved or rejected should not trigger another approval process)
            if (c.RecordTypeId == supportCaseId && c.Regional_VP__c != null && c.Approval_Status__c != 'Approved' && c.Approval_Status__c != 'Rejected') {
                System.debug('c.RecordTypeId == supportCaseId AND c.Regional_VP__c != null AND c.Approval_Status__c != Approved AND c.Approval_Status__c != Rejected');
                
                Approval.ProcessSubmitRequest approvProcess = new Approval.ProcessSubmitRequest();
                approvProcess.setObjectId(c.Id);
                approvProcess.setSubmitterId(c.WRF_Requestor__c);
                    
                if (c.WRF_Request_Type__c == 'Extended Payment Terms Requests') {
                    System.debug('c.WRF_Request_Type__c == Extended Payment Terms Requests');
                    executeoncetest.executeCaseApproval = false;
    
                    approvProcess.setProcessDefinitionNameOrId('Extended_Terms_Current');
                    approvProcess.setComments('Approval for Extended Payment Terms.');
                    Approval.process(approvProcess);
                }
                else if (c.WRF_Request_Type__c == 'Early Pay Discount Terms Requests') {
                    System.debug('c.WRF_Request_Type__c == Early Pay Discount Terms Requests');
                    executeoncetest.executeCaseApproval = false;
    
                    approvProcess.setProcessDefinitionNameOrId('Early_Pay_Discount_Request_Current');
                    approvProcess.setComments('Approval for Early Pay Discount.');
                    Approval.process(approvProcess);
                }
            }
        }
    }
    // End Production Fix #00809579 - Early Pay Discount Terms NOT WORKING in SFDC
    
    for (Case c : Trigger.New) {
       if (c.recordTypeId == CaseRecType.get('Work Request').getRecordTypeId()){
           isWRF = true;     
           //Support Ticket: 00660249 Begin:    
           if(Trigger.isInsert && Trigger.isAfter && c.WRF_Request_Type__c == 'Transition' && 
              c.Diversity_Account__c == True && c.Account_RecordtypeId__C == CustOMX){  
               Diversity_WRFs.add(c);
               System.Debug('WRF Case:' + c);
                  
           }
           if(Trigger.isUpdate && Trigger.isAfter) {
               IF(Trigger.OldMap.get(c.id).WRF_Request_Type__c == 'Pricing (Bid/RFP/Quote)' && 
                  c.WRF_Request_Type__c == 'Transition' && c.Diversity_Account__c == True && 
                  c.WRF_Link_to_RFP__c =='Yes' && c.Account_RecordtypeId__C == CustOMX){    
                      Diversity_WRFs.add(c);
                      System.Debug('WRF Case:' + c);
                  }
           }
           //Support Ticket: 00660249 End:
       }
       if (((c.recordTypeId == CaseRecType.get('Account Maintenance').getRecordTypeId()) && (c.origin == 'ODN General Maint' || c.origin == 'General Maint')) || // Added for Ticket 00674983
           (c.recordTypeId == CaseRecType.get('Support').getRecordTypeId())||
           (c.recordTypeId == CaseRecType.get('IT Cases').getRecordTypeId()) ||
          (c.recordTypeId == CaseRecType.get('Partner Case').getRecordTypeId()) && (c.origin == 'Partner Email')) /* Added for Ticket 00694816 */   {
           isSupport = true;
       }

       //Connor Flynn S-437498 (00801298) Adding custom setting
       Set<String> originSet = new Set<String>();
       for(Case_Origin_Value__mdt tmpSetting : [Select Id,  CaseTrigger__c, Origin_Value__c From Case_Origin_Value__mdt Where CaseTrigger__c = true]){
        if(tmpSetting.CaseTrigger__c){
          originSet.add(tmpSetting.Origin_Value__c);
        }
       }

      //Jeffrey Timor Tickets -> 00559236, 00540402, & 00561494 Added lines 67, 49, 50, & 51 - 58
       if(((c.recordTypeId == CaseRecType.get(Constants.SUPPORT).getRecordTypeId()) || 
           (c.recordTypeId == CaseRecType.get(Constants.PARTNER_CASE).getRecordTypeId()) || // Added for Ticket 00694816
           //(c.recordTypeId == CaseRecType.get('eCommerce – Field Support').getRecordTypeId()) || 
           (CaseRecType.containsKey(Constants.ECOMMERCE_FIELD_SUPPORT) && c.recordTypeId == CaseRecType.get(Constants.ECOMMERCE_FIELD_SUPPORT).getRecordTypeId()) ||
           (c.recordTypeId == CaseRecType.get(Constants.GT_CASES).getRecordTypeId()) ||
          (c.recordTypeId == CaseRecType.get(Constants.ACCOUNT_MAINTENANCE).getRecordTypeId()) // Added for Ticket 00674983
          ) && originSet.contains(c.Origin) &&

          //(c.Origin=='GT Alberta' || 
          // c.Origin=='GT Eastern' || 
          // c.Origin=='GT Ontario' || 
          // c.Origin=='GT Manitoba' || 
          // c.Origin=='GT BC' || 
          // c.Origin=='GT Saskatchewan' ||
          // c.Origin== 'SPC Processing' || // Added for Ticket 00674983
          // c.Origin=='GT Admins' || 
          // c.Origin=='Deployment' || // Added for Ticket 00694096
          // c.Origin=='eComm Email' || 
          // c.Origin== 'ODN General Maint' || // Added for Ticket 00674983
          // c.Origin== 'General Maint' || // Added for Ticket 00674983
          // c.Origin=='Global Support' || 
          // c.Origin== 'Email' || 
          // c.Origin== 'Savo' || 
          // c.Origin== 'RCOE' ||  // Added for Ticket 00683436
          // c.Origin== 'Partner Email' || // Added for Ticket 00694816
          // c.Origin== 'Diversity Email' ||  // Added for Ticket 00694816
          // c.Origin== 'TAM Solutions' ||  // Added for Ticket 00758381
          // c.Origin== 'Salesprism') && 
          //Connor Flynn S-437498 (00801298) End
          Trigger.IsBefore && 
          Trigger.IsInsert) // Mohamad added c.Origin=='Global Support' to the condition per fast track 00302861 and c.Origin== 'Savo' per fast track 00304991
       {
           if(c.SuppliedEmail != null)
               isSupport = true;
               SetWebEmail.add(c.SuppliedEmail);
       }
       
        if ((c.recordTypeId == CaseRecType.get('Account Maintenance').getRecordTypeId() 
            && c.origin <> 'ODN General Maint' && c.origin <> 'General Maint')  // Added for Ticket 00674983
           ){
          
            isAccountMaintanance = true; 
            if(c.accountid!= null){set_accountid.add(c.accountid);}           
        }
        
        if((c.recordTypeId == CaseRecType.get('Account Maintenance').getRecordTypeId() 
            && c.origin <> 'General Maint' && c.origin <> 'ODN General Maint') // Added for Ticket 00674983
           || (c.recordTypeId != CaseRecType.get('Work Request').getRecordTypeId())){
            if(c.DUP_Acct_ID__c!= null){DupAccid.add(c.DUP_Acct_ID__c);}
            if(c.Related_Case_Number__c!=null){RelatedCaseNum.add(c.Related_Case_Number__c);}
            if(c.DUP_Requestor_ID__c!= null){RequestorUser.add(c.DUP_Requestor_ID__c);}
            case_ids.add(c.id);
        }
        if(((c.recordTypeId == CaseRecType.get('Work Request').getRecordTypeId()) || (c.recordTypeId == CaseRecType.get('Account Maintenance').getRecordTypeId())) &&
           (c.id != null) 
          ) 
        {
            KPICaseid.add(c.id);
        }
        
  }
    //Support Ticket: 00660249 Begin:       
         IF(Diversity_WRFs.size() > 0 ) {
             WRFTaskManagement.WRF_Dvrsty_Tsk_Create(Diversity_WRFs);
         }
    //Support Ticket: 00660249 End:       
}  
if(Trigger.Isdelete && trigger.IsBefore)
{
    CaseManagement.beforedeletemethod();   
}

//START NSHARP 3.31.16 RELEASE
if(Trigger.isBefore && Trigger.isInsert){
    CaseManagement.updRVP(trigger.new);     //updated by Purnima for case - 00183263
}
if(Trigger.isAfter && Trigger.isUpdate){
    CaseManagement.onAfterUpdate();
// Support Ticket - 00730056 - Start 
    CaseManagement.updUserHierarchy();
// Support Ticket - 00730056 - End
}
//END NSHARP 3.31.16


  system.debug('Trigger new case ids-->'+case_ids);
//*****************Populating MAPS for WRF || AccountMaintanance***************
if(Trigger.IsInsert || Trigger.IsUpdate)
{
if(isWRF || isAccountMaintanance){
          for(Case nc:(List<case>)Trigger.New){
            if(nc.DUP_Acct_ID__c!= null){DupAccid.add(nc.DUP_Acct_ID__c);}
            if(nc.Related_Case_Number__c!=null){RelatedCaseNum.add(nc.Related_Case_Number__c);}
            if(nc.DUP_Requestor_ID__c!= null){RequestorUser.add(nc.DUP_Requestor_ID__c);}
        }
          system.debug('The Set Size -->'+KPICaseid.Size());
          if (KPICaseid.Size() > 0) {
            for(Record_History__c rec:[Select id,Start_Date__c,End_Date__c,Approver__c,No_of_Hours__c,Case__c,WRF_Task__c from Record_History__c where Case__c in:KPICaseid and Start_Date__c!=null and End_Date__c=null and WRF_Task__c=null] )
             {
                 system.debug('The query returned-->'+rec);
                 updaterecordhis.put(rec.Case__c,rec);
             }
          }
        list<Account> CustList1 = new  list<Account> ();
        if(DupAccid.size()>0)
        CustList1= [SELECT id,name,AOPS_Cust_Id__c from account where AOPS_Cust_Id__c in: DupAccid and type = 'Customer'];
        
        if(CustList1.size()>0){
        for(Account acc:CustList1){
          List<Account> acc1 = new List<Account>();
          if(map_list_acc.containskey(acc.AOPS_Cust_Id__c)){
              acc1=map_list_acc.get(acc.AOPS_Cust_Id__c);         
              map_list_acc.remove(acc.AOPS_Cust_Id__c);
              acc1.add(acc);
              map_list_acc.put(acc.AOPS_Cust_Id__c,acc1);              
          }else{
              acc1.add(acc);
              map_list_acc.put(acc.AOPS_Cust_Id__c,acc1);             
          }
        } 
        }
        
        list<Account> PrspctList1= new List<Account>();
        if(DupAccid.size()>0)
        PrspctList1 = [SELECT id, name,Oracle_Party_Id__c from account where Oracle_Party_Id__c in: DupAccid 
        and type = 'Prospect']; 
        if(PrspctList1.size()>0){
        for(Account acc:PrspctList1){
          List<Account> acc2 = new List<Account>();
          if(map_list_pros.containskey(acc.Oracle_Party_Id__c)){
              acc2=map_list_acc.get(acc.Oracle_Party_Id__c);              
              map_list_pros.remove(acc.AOPS_Cust_Id__c);
              acc2.add(acc);
              map_list_pros.put(acc.Oracle_Party_Id__c,acc2);              
          }else{
              acc2.add(acc);
              map_list_pros.put(acc.Oracle_Party_Id__c,acc2);             
          }
        }
        }
        
        list<Case> CaseList1= new List<Case>();
        if( RelatedCaseNum.size()>0)
        CaseList1= [SELECT id,Related_Case_Number__c,CaseNumber from case where CaseNumber in: RelatedCaseNum];
        if(CaseList1.size()>0){
        for(Case cs:CaseList1){
          List<Case> cs1=new List<Case>();
          if(map_list_case.containskey(cs.CaseNumber)){
              cs1=map_list_case.get(cs.CaseNumber);              
              map_list_case.remove(cs.CaseNumber);
              cs1.add(cs);
              map_list_case.put(cs.CaseNumber,cs1);              
          }else{
              cs1.add(cs);
              map_list_case.put(cs.CaseNumber,cs1);              
          }
        }
        }
        
        list<User> UserList1= new List<User>();
        if(RequestorUser.size()>0)
        UserList1  = [SELECT id,OD_Employee_ID__c from User where OD_Employee_ID__c in:RequestorUser];
        if(UserList1.size()>0){
        for(User us:UserList1){
          List<User> us1=new List<User>();
          if(map_list_user.containskey(us.OD_Employee_ID__c)){
              us1=map_list_user.get(us.OD_Employee_ID__c);             
              map_list_user.remove(us.OD_Employee_ID__c);
              us1.add(us);
              map_list_user.put(us.OD_Employee_ID__c,us1);              
          }else{
              us1.add(us);
              map_list_user.put(us.OD_Employee_ID__c,us1);             
          }
        }
       } 
        
} 
}
 //*****************END Populating MAPS for WRF || AccountMaintanance*************** 

 
  if(isWRF){
      CaseManagement.WRFCASES(map_list_acc ,map_list_pros, map_list_case, map_list_user,updaterecordhis);
  }
  if(isAccountMaintanance){
      CaseManagement.ACCOUNTMAINTANANCE(map_list_acc ,map_list_pros, map_list_case, map_list_user, set_accountid,case_ids,updaterecordhis);
  }
  if(isSupport){
   
       //Map<ID,Profile> ProfileMap = new Map<ID,Profile>([SELECT Id,Name FROM Profile ]);
       Map<Id,Profile> ProfileMap = new Map<id,profile>([SELECT Id,Name FROM Profile where UserLicenseId
         in (SELECT Id FROM UserLicense where name!='Customer Community Login')]);
         
         
      List<QueueSobject> qlist = [Select Id, Queue.Name, Queue.ID from QueueSobject];
       Map<String,QueueSobject > qmap = new Map<String,QueueSobject >();
       for(QueueSobject q :qlist){
           qmap.put(q.Queue.Name,q); 
       }
       
       
       if(Trigger.IsInsert && Trigger.IsBefore)
       {
           for(User u:[Select id,email ,profileId   from user where email IN: SetWebEmail ])
           {
           
               if(MapofEmailandUser.containskey(u.email)){
                        if(ProfileMap.containsKey (u.profileId )) 
                        MapofEmailandUser.put(u.email,u);

               }
               else{
               MapofEmailandUser.put(u.email,u);
               }
           }
       }
      System.Debug('Calling Support'); 
      CaseManagement.SUPPORT(ProfileMap,qmap,MapofEmailandUser);
  }
  
  /*
    for(Case c:Trigger.New)
    {
    
        if((c.recordTypeId == CaseRecType.get('Work Request').getRecordTypeId()) &&(Trigger.isBefore) &&(Trigger.isUpdate ||Trigger.isInsert))
        {
            c.ownerid ='00GE0000000U5pIMAS';//WorkQueueId; 
        }
        if((c.recordTypeId == CaseRecType.get('Account Maintenance').getRecordTypeId()) &&(Trigger.isBefore)&&(Trigger.isInsert) &&(c.WRF_Request_Type__c!=null))
        {
            c.Priority='3-Medium';
            CaseManagement.fieldUpdates(c);
        }
        if((c.recordTypeId == CaseRecType.get('Account Maintenance').getRecordTypeId()||(c.recordTypeId == CaseRecType.get('Work Request').getRecordTypeId())) &&(Trigger.isBefore)&&(Trigger.isInsert||Trigger.isUpdate)&&(c.WRF_Request_Type__c!=null))
        {
            CaseManagement.fieldUpdates(c);
        }
    }
  */
  
 //exe = executeoncetest.executeonce;
 //exe = exe+1;
 //executeoncetest.executeonce=exe;

 // }//Code that has to be removed Later
    }//check for executeoncetest.CallAgainCase
}