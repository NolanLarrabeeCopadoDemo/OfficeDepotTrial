trigger CaseEmailEvents on EmailMessage (after insert) {

  if (Util.bypassTriggers('CaseEmailEvents')) {
    Util.DEBUG('Bypassing trigger CaseEmailEvents');
    return;
  }

  /* If an email is received on a closed case with record type of IT Case or Support then the case
     needs to be re-opened with status 'In Progress'
  */
  Schema.DescribeSobjectResult c = Schema.SobjectType.Case;
  Map<String,schema.RecordtypeInfo> CaseRecType = c.getRecordTypeInfosByName();
  Id supCaseRecTypeId = CaseRecType.get('Support').getRecordTypeId();
  Id itCaseRecTypeId = CaseRecType.get('IT Cases').getRecordTypeId();  

  // Case Related Variables
  List <Case> caseList = new List <Case>();
  List <Case> updateCaseList = new List <Case>();
  Set<Id> casesid = new Set<Id>();

  for (EmailMessage thisEmail : Trigger.new){
    // If a new email is received on the case then add the case to the list
    if(thisEmail.ParentId != null &&  String.valueOf(thisEmail.ParentId).startsWith('500') && thisEmail.status == '0')
    {   
      casesid.add(thisEmail.ParentId);
    }
  }

  caseList = [select Id ,casenumber ,IT_Assignment__c,IT_BU_Reviewer__c,Support_Requester__c, subject,recordtypeid,status  from case where Id in :casesid];

  for (Case thisCase : caseList){
    // Re-Open Closed Cases with record type of IT Case or Support Only
    if((thisCase.recordtypeid == supCaseRecTypeId || thisCase.recordtypeid== itCaseRecTypeId) && thisCase.Status=='Closed')
    {
       // thisCase.Status got changed by Mohamad for case 00253759. Status change from 'In Progress' to 'Case Review'.
      thisCase.Status='Case Review';
      updateCaseList.add(thisCase);
    }
  }
  
  // If the update list is not empty then update the cases to re-open
  if(updateCaseList.size() > 0)
    update updateCaseList;
  
}