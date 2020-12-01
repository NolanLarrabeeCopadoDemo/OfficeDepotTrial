/*
-- +========================================================================================+
-- | Office Depot                                                                           |
-- +========================================================================================+
-- | Name : TaskEvents                                                                      |
-- |                                                                                        |
-- | Description : When a task is completed assign a call date                              |
-- | when the rep is supposed to contact the customer again.                                |
-- |                                                                                        |
-- |Change History:                                                                         |
-- |----------------------------------------------------------------------------------------|
-- |                                                                                        |
-- |Version Date Author Remarks                                                             |
-- |------- ----------- --------------- ----------------------------------------------------|
-- |1   14-Sep-2011 Mike Keller Initial Version                                             |
-- |1.1 02-Dec-2011 Kishore Jena Added Price Escltn. email logic                            |
-- |1.2 26-Apr-2012 Kishore Jena Added logic to count total tasks and closed tasks for cases|
-- |1.3 20-Aug-2012 Prasad Devar Added logic for Support cases re structure
-- |1.4 05-April-2013 Wipro Offshore Added Completed Date filter in line 84                 |
-- |1.5 24-JULY-2013 Wipro Offshore has removed all SOQL query againist RecordType object   |
-- +========================================================================================+
*/
// Modified  - S-401328- commented code body to remove inactive trigger from coverage class
trigger TaskEvents on Task (after delete, after insert, after undelete, 
after update, before delete, before insert, before update) {
/*  
System.Debug('Trigger start');
if (Util.bypassTriggers('TaskEvents')) {
Util.DEBUG('Bypassing trigger TaskEvents');
return;
} */
/* Objective 1: Fire trigger on before insert, and Task Type is null and Call Disposition is null
** Added on 12-8-2011 - The purpose of this is to set the task type and call disposition fields for any emails
** that get sent out of salesforce. Currently the "Send Email" button on the activity related list creates 
** a standard task but the layout is not editable and workflow field updates will not work.
*/


/*Map<id,case> maptaskcase = new Map<id,case>();
List<Task> newTasks = new List<Task>();


Schema.DescribeSobjectResult r = Schema.SobjectType.Task;
Schema.DescribeSobjectResult c = Schema.SobjectType.Case;
Map<String,schema.RecordtypeInfo> TskRecType = r.getRecordTypeInfosByName();
Map<String,schema.RecordtypeInfo> CaseRecType = c.getRecordTypeInfosByName();
Id supTskRecTypeid = TskRecType.get('Support Task').getRecordTypeId();
Id supCaseRecTypeId = CaseRecType.get('Support').getRecordTypeId();
Id itCaseRecTypeId = CaseRecType.get('IT Cases').getRecordTypeId(); 
if(Trigger.isBefore && !Trigger.isDelete ) {
//RecordType supTskRecType=[select id from recordtype where name = 'Support Task'];


List <Case> updateCaseList = new List <Case>();
for(Task task: Trigger.New){
if(task.recordtypeid !=supTskRecTypeid && task.Task_Type__c == null && task.Call_Disposition__c == null && task.CallDurationInSeconds == null&& Trigger.isInsert){
task.Disposition_Code__c = 'Email';
task.Task_Type__c = 'Email'; 
task.Call_Disposition__c = 'Email'; 
} 

}


} 

if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter){
System.Debug('Entered');
List <Account> acctList = new List <Account>();
List <Account> updateAcctList = new List <Account>();
List <Cadence__c> cadenceList = [SELECT Lifecycle_Stage__c, Cadence__c from cadence__c];
Map <String,Decimal> cadenceMap = new Map <String,Decimal>();
List <Id> acctIds = new List <Id>();
Map <Id,Date> contactDate = new Map <Id,Date>();
List<Task> lstPriceEscalatedTasks = new List<Task>();
//RecordType inSalesRecType = [select id from recordtype where name = 'Inside Sales'];
//RecordType siteRecType = [select id from recordtype where name = 'Site'];
//RecordType supTskRecType=[select id from recordtype where name = 'Support Task'];
Schema.DescribeSobjectResult ar = Schema.SobjectType.Account;
Map<String,schema.RecordtypeInfo> AccRecType = ar.getRecordTypeInfosByName(); */

//*************************(Prototype)Functionality of Chatter Feed for Offshore team when they complete one task***************//
   
//*******************End of chatter feed functionality*******************//
/*Id inSalesRecTypeId =TskRecType.get('Inside Sales').getRecordTypeId();
Id siteRecTypeId = AccRecType.get('Site').getRecordTypeId();
Id supTskRecType=TskRecType.get('Support Task').getRecordTypeId();



// Case Related Variables
List <Case> caseList = new List <Case>();
List <Case> updateCaseList = new List <Case>();
List <Id> caseIds = new List <Id>();

for (Cadence__c lclCadence : cadenceList){
cadenceMap.put(lclCadence.Lifecycle_Stage__c,lclCadence.Cadence__c);
}
Set<Id> casesid = new Set<Id>();
for (Task thisTask : Trigger.new)
{
    

    if(thisTask.whatId != null &&  String.valueOf(thisTask.whatId).startsWith('500') &&  thisTask.recordtypeid ==supTskRecTypeid )
    {   
        casesid.add(thisTask.whatId);
    }
}
 
for(case taskcaseList : [select Id ,casenumber ,IT_Assignment__c,IT_BU_Reviewer__c,Support_Requester__c,IT_Production_Date__c, subject  from case where Id in :casesid])
{
    maptaskcase.put(taskcaseList.id,taskcaseList);
}
//and ( recordtypeid = :itCaseRecTypeId   ) -- this functionality is for all type of cases. Email should be added as Comments for all type of case including IT , WRF , Acc Maint 
for (Task thisTask : Trigger.new){
    List<CaseComment > newNotes = new List<CaseComment >();

if(thisTask.whatId != null &&
   String.valueOf(thisTask.whatId).startsWith('500') &&
  thisTask.recordtypeid ==supTskRecTypeid )
{

// Added Suppot case logic
//caseList = [select Id ,casenumber ,IT_Assignment__c,IT_BU_Reviewer__c,Support_Requester__c, subject  from case where Id= :thisTask.whatId];
//&& thisTask.WRF_Task_Complete_Dt__c!=null -- commented the code back due to the 40532

integer exec = executeoncetest.execount;
    system.debug(exec + '^^^' + maptaskcase.size());
if(thisTask.status=='Completed'  && maptaskcase.size()>0 && exec==0 )
   {
 // on Complition of task add comments to case
       CaseComment nt= new CaseComment ();
       nt.ParentId = thisTask.whatId;
       String comment;
       String action;
       String outcome;
       String description;
       
       if(thisTask.description!=null && thisTask.description!='')
       {
            description = thisTask.description;
       }
       else{
       description = '';
       }
       if(thisTask.Action__c!=null && thisTask.Action__c!='')
       {
           action = thisTask.Action__c;
       }
       else{
       action = '';
       }
       if(thisTask.Outcome__c!=null && thisTask.Outcome__c!='')
       {
            outcome = thisTask.Outcome__c;
       }
       else{
       outcome = '';
       }
          
       comment='Action: '+action+'\nOutcome: '+outcome+'\nTask Comment: '+description;
            if(comment.length()>3500)
                          nt.CommentBody = comment.substring(0,3500);
                    else
           nt.CommentBody =  comment;
       
       if(nt.CommentBody != null && nt.CommentBody != '')
       newNotes.add(nt);
       exec++;
       executeoncetest.execount = exec;
   System.Debug('completed2')    ;
// based on the outcome create additional/followup tasks.


         Task act = new Task();
         Date dt = date.valueof(maptaskcase.get(thisTask.whatid).IT_Production_Date__c);
         String prodDate='';
         if(dt!=null){
         prodDate = dt.format();
         System.Debug('dt@@@'+dt);
         System.Debug('prodDate@@@'+prodDate);
         }
        boolean flag= true;
                String subject = '#'+maptaskcase.get(thisTask.whatid).casenumber+' ';
            if(thisTask.Outcome__c!='No Action Required' && thisTask.Outcome__c!='' && thisTask.Outcome__c!=null){    
            if(thisTask.action__c == 'Development' && thisTask.Task_Type__C=='IT') 
            {
                system.debug('If11111'); 
                act.Task_Type__C='Business';
                act.ownerId = maptaskcase.get(thisTask.whatid).IT_BU_Reviewer__c;
                act.action__c = 'Validation';
                act.activitydate = system.today().adddays(2);
                maptaskcase.get(thisTask.whatid).ownerId=System.Label.SalesOps_Queue;
            }
            // Added by Subhro for Case# - 00161051 
            else if(thisTask.outcome__c == 'Rejected' && thisTask.Action__c=='Validation' && thisTask.Task_Type__C=='Business')
            {
                system.debug('If333333');
                act.Task_Type__C='IT';
                act.ownerId = maptaskcase.get(thisTask.whatid).IT_Assignment__c ;
                act.action__c = 'Development';  
                act.activitydate = system.today().adddays(2);
                maptaskcase.get(thisTask.whatid).ownerId=System.Label.IT_Queue;
            } 
            else if(thisTask.outcome__c == 'Approved' && thisTask.Action__c=='Validation' && thisTask.Task_Type__C=='Business' && maptaskcase.get(thisTask.whatid).IT_Production_Date__c!=null) 
            {
                act.Task_Type__C='IT';
                act.ownerId = maptaskcase.get(thisTask.whatid).IT_Assignment__c ;
                act.action__c = 'Migration';  
                act.activitydate = system.today().adddays(2);
                Subject += act.action__c+' - '+maptaskcase.get(thisTask.whatid).subject+ ' - Production Date : ' + prodDate;
                if(subject.length()>230)
                      subject = subject.substring(0,230);
                act.Subject =  subject;
                maptaskcase.get(thisTask.whatid).ownerId=System.Label.IT_Queue;
            }
            else if(thisTask.Action__c== 'Migration' && thisTask.Task_Type__C=='IT')
            {
                system.debug('If44444');
                act.Task_Type__C='Business';
                act.ownerId = maptaskcase.get(thisTask.whatid).IT_BU_Reviewer__c ;
                act.action__c = 'Migration Validation';  
                act.activitydate = system.today().adddays(2);
                maptaskcase.get(thisTask.whatid).ownerId=System.Label.SalesOps_Queue;
            }
            //End case # - 00161051     
            else if(thisTask.action__c == 'Migration Validation' && thisTask.Task_Type__C=='Business' && thisTask.outcome__c == 'Rejected')
            {   //Case # 00348608
                system.debug('If222222'); 
                act.Task_Type__C='IT'; 
                act.ownerId = maptaskcase.get(thisTask.whatid).IT_Assignment__c ; 
                act.action__c = 'Migration';
                act.activitydate = system.today().adddays(2);
                //Subject = #[Case #] [Action] - [Subject of Case] [Production Date]
                 Subject += act.action__c+' - '+maptaskcase.get(thisTask.whatid).subject+ ' - Production Date : ' + prodDate;
                //subject= act.action__c+', '+ maptaskcase.get(thisTask.whatid).subject;
                if(subject.length()>230)
                      subject = subject.substring(0,230);
                act.Subject =  subject;
                maptaskcase.get(thisTask.whatid).ownerId=System.Label.IT_Queue;
             }   
            }*/
            /*else
            { 
                act.Task_Type__C='Other';
                act.ownerId = maptaskcase.get(thisTask.whatid).Support_Requester__c ;
            }*/
            /*if(act.subject==null || act.subject==''){
            subject += act.action__c+' - '+ maptaskcase.get(thisTask.whatid).subject;
                if(subject.length()>230)
                      subject = subject.substring(0,230);
                act.Subject =  subject;
                }
                act.Status = 'New';
                act.whatId = maptaskcase.get(thisTask.whatid).id;
        if(thisTask.outcome__c != 'Need More Info(Rep)')
                    act.recordtypeid =supTskRecTypeid;
        if(act.OwnerId != null)            
            newTasks.add(act);
            
        system.debug('newTasks-->'+newTasks);    
        if(newTasks.size() > 0) insert newTasks;
        if(newNotes.size() > 0) insert newNotes;
        caselist.add(maptaskcase.values());
        if(caselist.size() > 0 && executeoncetest.updateTaskCase)
        {
            executeoncetest.updateTaskCase=false;
            update caselist;
        }
    }
}


//only get Inside sales task with call disposition of 'Sales Related' that are closed and are attached to accounts
if(thisTask.recordTypeId == inSalesRecTypeId && 
thisTask.Call_Disposition__c == 'Sales Related' &&
thisTask.Status == 'Completed' &&
thisTask.whatId != null &&
String.valueOf(thisTask.whatId).startsWith('001'))
acctIds.add(thisTask.whatId);

//only for tasks related to cases total number of tasks and closed tasks needs to be counted and updated
if(thisTask.whatId != null &&
   String.valueOf(thisTask.whatId).startsWith('500')
  )
caseIds.add(thisTask.whatId);

// Check if the task is account related and email needs to be sent for Price Escalation
if(IsPriceEscalated(thisTask))
SendEmail(thisTask); 
}


system.debug('acctIds ::::::::'+acctIds );
acctList = [select id, recordTypeid, stage__c, Cadence_Call_Date__c, Cadence_Call_Date_Override__c, 
Cadence_Call_Date_Override_Value__c, Site_Primary_Contact__r.id, Site_Contact2__r.id,
Site_Contact3__r.id, Site_Contact4__r.id, Site_Contact5__r.id, Site_Contact6__r.id
from account 
where id in :acctIds ];
for(Account lclAcct : acctList){
Date tempDate = System.today();
if(lclAcct.cadence_call_date_override__c && lclAcct.cadence_call_date_override_value__c != null)
tempDate = tempDate.addDays(lclAcct.cadence_call_date_override_value__c.intValue());
else if(lclAcct.stage__c != null && lclAcct.stage__c != '')
tempDate = tempDate.addDays(cadenceMap.get(lclAcct.stage__c).intValue());
else
tempDate = tempDate.addDays(cadenceMap.get('SOW').intValue());

lclAcct.Cadence_Call_Date__c = tempDate;
updateAcctList.add(lclAcct);

if(lclAcct.RecordTypeId == siteRecTypeId){
if(lclAcct.Site_Primary_Contact__r.id != null)
contactDate.put(lclAcct.Site_Primary_Contact__r.id,tempDate);
if(lclAcct.Site_Contact2__r.id != null)
contactDate.put(lclAcct.Site_Contact2__r.id,tempDate);
if(lclAcct.Site_Contact3__r.id != null)
contactDate.put(lclAcct.Site_Contact3__r.id,tempDate);
if(lclAcct.Site_Contact4__r.id != null)
contactDate.put(lclAcct.Site_Contact4__r.id,tempDate);
if(lclAcct.Site_Contact5__r.id != null)
contactDate.put(lclAcct.Site_Contact5__r.id,tempDate);
if(lclAcct.Site_Contact6__r.id != null)
contactDate.put(lclAcct.Site_Contact6__r.id,tempDate);
}
}
system.debug('contactDate:::::'+ contactDate);
acctList = [select id, recordTypeid, stage__c, Cadence_Call_Date__c, Cadence_Call_Date_Override__c, 
Cadence_Call_Date_Override_Value__c, Site_Primary_Contact__r.id, Site_Contact2__r.id,
Site_Contact3__r.id, Site_Contact4__r.id, Site_Contact5__r.id, Site_Contact6__r.id
from account 
where recordTypeid = :siteRecTypeId and
id not in :acctIds and
(Site_Primary_Contact__r.id in :contactDate.keySet() or
Site_Contact2__r.id in :contactDate.keySet() or
Site_Contact3__r.id in :contactDate.keySet() or
Site_Contact4__r.id in :contactDate.keySet() or
Site_Contact5__r.id in :contactDate.keySet() or
Site_Contact6__r.id in :contactDate.keySet())];

for(Account lclSite : acctList){
if(contactDate.containsKey(lclSite.Site_Primary_Contact__r.id))
lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Primary_Contact__r.id);
else if(contactDate.containsKey(lclSite.Site_Contact2__r.id))
lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Contact2__r.id);
else if(contactDate.containsKey(lclSite.Site_Contact3__r.id))
lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Contact3__r.id);
else if(contactDate.containsKey(lclSite.Site_Contact4__r.id))
lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Contact4__r.id);
else if(contactDate.containsKey(lclSite.Site_Contact5__r.id))
lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Contact5__r.id);
else if(contactDate.containsKey(lclSite.Site_Contact6__r.id))
lclSite.Cadence_Call_Date__c = contactDate.get(lclSite.Site_Contact6__r.id);

updateAcctList.add(lclSite);
}

if(updateAcctList.size() > 0)
update updateAcctList;

//Case related summary field update logic
system.debug('caseIds ::::::::'+caseIds );
caseList = [select id, recordTypeid, Total_Tasks__c, Total_Completed_Tasks__c from case where id in :caseIds ];

for(Case lclCase : caseList){
  integer lcltskcount = 0;
  AggregateResult[] groupedresults  = [select count(id) totaltasks from task where whatid = :lclCase.Id 
                                       and Task_Type__c != 'Email'
                                      ];
  lcltskcount = integer.valueof(groupedresults[0].get('totaltasks'));
  lclCase.Total_Tasks__c = lcltskcount;
  
  groupedresults = [select count(id) closedtasks from task where whatid = :lclCase.Id and
                    status = 'Completed' and Task_Type__c != 'Email'
                   ];
  lcltskcount = integer.valueof(groupedresults[0].get('closedtasks')); 
  lclCase.Total_Completed_Tasks__c = lcltskcount;

  updateCaseList.add(lclCase);

  
}
if(updateCaseList.size() > 0 && executeoncetest.updateTaskCase1)
{
    executeoncetest.updateTaskCase1=false;
    update updateCaseList;
}
}*/
/* New code for  feed item */
/*if(Trigger.IsBefore && (Trigger.IsInsert || Trigger.IsUpdate))
{

List<FeedItem> feedItems ;
Map<ID,User> userMap = new Map<ID,User>(); //This is our user map
for(User u:[SELECT ID, Name FROM User WHERE Name LIKE 'JAsmeet%' OR  Name LIKE 'monika .karamchandani%' OR Name LIKE 'Guha Anand%' OR Name LIKE 'SubhraJyoti%' OR Name LIKE 'Mohit Bansal%' OR Name LIKE 'Niraj Sinh%' OR Name LIKE 'Sushma%'     ])
{
    usermap.put(U.Id,u);
    System.Debug('map check'+u);
}
        
        if(Trigger.IsInsert)
        {
        feedItems = new List<FeedItem>();
        //feedItems = new List<FeedItem>();
        for (Task t : Trigger.new) {
            if (t.WhatId != null && t.status =='completed' && (UserMap.get(t.OwnerId) !=null )) 
            {
                System.Debug('entered Insert');
                FeedItem fitem = new FeedItem();
                fitem.type = 'LinkPost';
                fitem.ParentId = t.WhatId;
                fitem.LinkUrl = '/' + t.id; //This is the url to take the user to the activity
                fitem.Title = 'Offshore Updates';  //This is the title that displays for the LinkUrl
    
                //Get the user by checking the userMap we created earlier
                System.Debug('usr check'+t.ownerId);
                System.Debug('usr check2'+userMap.get(t.ownerId));
                User assignedTo = userMap.get(t.ownerId);
    
                fitem.Body = ((Trigger.isInsert) ? 'New' : 'Updated') + ' Activity ' + ((t.ActivityDate != null) ? t.ActivityDate.format() :'')
                            + '\nAssigned To: ' + ((assignedTo != null) ? assignedTo.name : 'Unknown')
                            + '\nSubject: ' + t.Subject
                            + '\nStatus: ' + t.Status
                            + '\nActual LOE: '+t.Actual_LOE__c;
                           // + '\nRelated To: '+fitem.ParentId;
                        //'\nAssigned To: ' + ((assignedTo != null) ? assignedTo.name : 'Unknown')
                feedItems.add(fitem);
                system.debug('feed items insert'+feedItems);
                //feedItems.clear();
            }
        }
    }
    
        if(Trigger.IsUpdate) 
        {
            feedItems = new List<FeedItem>();
            for (Task t : Trigger.new) {
            System.Debug('entered Update');
            System.Debug('Old MAp'+ Trigger.OldMap.get(t.id).status);
            System.debug('user check 2'+UserMap.get(t.OwnerId));
            if (t.WhatId != null && t.status =='completed' && Trigger.OldMap.get(t.id).status !='completed' && (UserMap.get(t.OwnerId) != null )) {
                
                System.Debug('entered status');
                FeedItem fitem = new FeedItem();
                fitem.type = 'LinkPost';
                fitem.ParentId = t.WhatId;
                fitem.LinkUrl = '/' + t.id; //This is the url to take the user to the activity
                fitem.Title = 'Offshore Updates';  //This is the title that displays for the LinkUrl
    
                //Get the user by checking the userMap we created earlier
                System.Debug('usr check'+t.ownerId);
                System.Debug('usr check2'+userMap.get(t.ownerId));
                User assignedTo = userMap.get(t.ownerId);
    
                fitem.Body = ((Trigger.isInsert) ? 'New' : 'Updated') + ' Activity ' + ((t.ActivityDate != null) ? t.ActivityDate.format() :'')
                            + '\nAssigned To: ' + ((assignedTo != null) ? assignedTo.name : 'Unknown')
                            + '\nSubject: ' + t.Subject
                            + '\nStatus: ' + t.Status
                            + '\nActual LOE: '+t.Actual_LOE__c;
                           // + '\nRelated To: '+fitem.ParentId;
                        //'\nAssigned To: ' + ((assignedTo != null) ? assignedTo.name : 'Unknown')
                feedItems.add(fitem);
                system.debug('feed items update'+feedItems);
                
            }
        }
        
    }   
    System.Debug('Check Size'+ feedItems.size());
    if (feedItems.size() > 0 && executeoncetest.executeonce == 0) {
        executeoncetest.executeonce = 1;
        //Database.insert(feedItems,false); //notice the false value. This will allow some to fail if Chatter isn't available on that object
        Insert feedItems;
    }
      
}

//======================================================================//
//Send Email Method
//======================================================================//
private void SendEmail(Task paramTask) { 
String emailBody = '';
Account lclAccount = [select id, name, AOPS_Cust_Id__c from account where id = :paramTask.whatId];
User lclUser = [select ManagerId, name, Manager.Email from user where id = :paramTask.ownerId]; 

String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();

emailBody += 'Pricing Escalation - Acct: ' + lclAccount.AOPS_Cust_Id__c + '-->' + lclAccount.name + ' '; 
emailBody += (paramTask.Description == null?(paramTask.Subject == null?'':paramTask.Subject):paramTask.Description) + '\n';

emailBody += '\n------------------------------------------------------------------------------------------------------\n\n';

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setSubject((paramTask.Description == null?(paramTask.Subject == null?'':paramTask.Subject):paramTask.Description));
mail.setSenderDisplayName('Automated Email Notification');
mail.setUseSignature(false);

String[] toAddresses = new String[] {'officedepotinsidesales@officedepot.com'}; 

// Send to Manager email if present
if (lclUser.Manager.Email != null)
toAddresses.add(lclUser.Manager.Email);

mail.setToAddresses(toAddresses);
mail.setPlainTextBody(emailBody);

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
}

//========================================================================//
//Method to Check if the Task has been created/updated for Price Escalation
//=========================================================================//
private Boolean IsPriceEscalated(Task paramTask) {
Boolean escalated = false; 
// Task has to be account related and dispositioned for Pricing Maintenance for escalation
if ((paramTask.Call_Disposition__c == 'Pricing Maintenance') && (paramTask.Disposition_Code__c == 'Pricing escalation') &&
(paramTask.whatId != null) && (String.valueOf(paramTask.whatId).startsWith('001'))&& (paramTask.ownerId != null)
) {
// In case of new records set true
if (Trigger.isInsert)
escalated = true;
else {
// Get the before snapshot of the task in case of an update
Task oldTask = Trigger.oldMap.get(paramTask.Id);
//One of 2 fields has been Changed to a different value
if (oldTask.Call_Disposition__c != paramTask.Call_Disposition__c || 
oldTask.Disposition_Code__c != paramTask.Disposition_Code__c
) 
escalated = true;
else
escalated = false;
}
} 
else 
escalated = false;

return escalated;
}*/

}