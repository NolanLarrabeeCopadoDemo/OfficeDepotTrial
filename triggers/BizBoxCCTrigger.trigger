/* Trigger used load the Lead Stagging Table and get the status reported back. */
trigger BizBoxCCTrigger on CompuCom_BBOX_Lead__c (after insert) {

// List used to update CompuCom_BBOX_Lead__c  with status 
List<CompuCom_BBOX_Lead__c > cblupdlst = new  List<CompuCom_BBOX_Lead__c >();
//map to get all CompuCom_BBOX_Lead__c with id 
Map <id,CompuCom_BBOX_Lead__c > blmap = new Map <id,CompuCom_BBOX_Lead__c > ();


// pull all leads inserted from compucom that are queued  
List<CompuCom_BBOX_Lead__c > cclead = [SELECT Id, First_Name__c, Last_Name__c, Company__c, Phone__c, Email__c, Discovery_Notes__c, Store_Associate_Name__c, Store_Associate_ID__c, Store_Number__c from CompuCom_BBOX_Lead__c  WHERE Id IN:Trigger.newMap.keySet() and (Status__c = 'Queued' or Status__c = '' )];

// insert comucom leads to leads stagging
    List<LeadStaging__c >  leadStgngInsrtLst= new  List<LeadStaging__c>();
       for (CompuCom_BBOX_Lead__c bl: cclead ) {
         blmap.put(bl.id,bl);
         LeadStaging__c  ls= new LeadStaging__c() ; 
         ls.First_Name__c = bl.First_Name__c;
         ls.Last_Name__c = bl.Last_Name__c;
         ls.Company__c= bl.Company__c;
         ls.Phone__c= bl.Phone__c;
         ls.Email__c= bl.Email__c;
         ls.additional_Info__c=  bl.Discovery_Notes__c;
         ls.employee_First_Name__c=   bl.Store_Associate_Name__c;
         ls.employee_ID__c=    bl.Store_Associate_ID__c;
         ls.Store_Number__c=      bl.Store_Number__c; 
         ls.ExternalRefID__c = bl.id;
         ls.Source__c = 'TechZone-CompUCom';

    leadStgngInsrtLst.add(ls);
    }  
    
    insert leadStgngInsrtLst;

// get all LeadStaging ids that got created  
    set<id> insrtlst = new set<id>();
    for(LeadStaging__c  ls:leadStgngInsrtLst)
    {          
         insrtlst.add(ls.id);
    }
    
    
// update the status and message back to the compucom_lead object.
    
    for(LeadStaging__c  ls:[ select id ,Status__c,StatusMessage__c,ExternalRefID__c  from LeadStaging__c   where id in :insrtlst ])
    {
       CompuCom_BBOX_Lead__c bl= blmap.get(ls.ExternalRefID__c);
       System.debug('Status__c' + ls.Status__c);
       bl.Status__c ='Error';
       bl.Status__c =ls.Status__c;
       bl.Status_Message__c =ls.StatusMessage__c ;
       cblupdlst.add(bl);
    }
    
    Update cblupdlst;
    
}