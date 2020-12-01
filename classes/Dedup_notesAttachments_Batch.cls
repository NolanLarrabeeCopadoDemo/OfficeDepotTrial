global class Dedup_notesAttachments_Batch implements database.Batchable<Sobject>, Schedulable
{

private String DEFAULT_QUERY = 'select id,Original_Account_ID__c,AccountExtension__c,Notes_Attachment_Created__c from Account_Dormant__c where Notes_Attachment_Created__c=false';
public String strQuery;


    
global Dedup_notesAttachments_Batch (String query)
{
        
         if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
}

global Database.QueryLocator start(Database.BatchableContext BC)
{            
        System.debug(' Query ===== = '+strQuery );
        return Database.getQueryLocator(strQuery );
}

 global void execute(Database.BatchableContext BC, SObject[] scope)
    {
      list<Account_Dormant__c> ad = scope;
      list<Note> noteUpd = new list<Note>();
      list<Attachment> attachmentUpd = new list<Attachment>();
      Map<ID,ID> acIDs = new Map<ID,ID>();
      
      for (Account_Dormant__c d: ad)
         acIDs.put(d.Original_Account_ID__c,d.id);
     
      for (note n:[select id,ParentId,Body,Title from Note where ParentID = :acIDs.keySet()]) {
          note nc = new note();
          nc.Parentid = acIDs.get(n.ParentId);
          nc.Title = n.Title;
          nc.Body = n.Body;
          noteUpd.add(nc);
      }
      
      for (Attachment a: [select id,ParentId,Body,ContentType,IsPartnerShared,Name from attachment where ParentId=:acIDs.keySet()]) {
  
               attachment ac = new attachment();
               ac.Parentid = acIDs.get(a.ParentId);
               ac.Name = a.Name;
               ac.ContentType = a.ContentType;
               //ac.isPartnerShared = a.isPartnerShared;
               ac.Body = a.Body;
               attachmentUpd.add(ac);
       
       }
       
       Database.UpsertResult[] noteResults = Database.upsert(noteUpd,false);
       Database.UpsertResult[] attachmentResults = Database.upsert(attachmentUpd,false);
       
       list<ID> newNoteIDs = new List<ID>();
       list<ID> newAttachmentIDs = new list<ID>();
       
       for (Database.UpsertResult r:noteResults ) {
          if (r.isSuccess())
           newNoteIDs.add(r.getID());
       }
       
       for (Database.UpsertResult r:attachmentResults  ) {
          if (r.isSuccess())
           newAttachmentIDs.add(r.getID());
       }
       
       Map<ID,boolean> NdormantSuccessIDs = new Map<ID,Boolean>();
       Map<ID,boolean> AdormantSuccessIDs = new Map<ID,Boolean>();
    
       
       for (Note n : [select ParentID from note where id=:newNoteIDs]) {
          NdormantSuccessIDs.put(n.ParentID,true);
       }
       
       for (Attachment a : [select ParentID from attachment where id=:newAttachmentIDs]) {
          AdormantSuccessIDs.put(a.ParentID,true);
       }
       
       list<Account_Dormant__c> dUpd = new list<Account_Dormant__c>();
       For (Account_Dormant__c d:ad) {
          if (NdormantSuccessIDs.containsKey(d.id) || AdormantSuccessIDs.containsKey(d.id)) {
              d.Notes_Attachment_Created__c = true;
              dUpd.add(d);
           }
       }
 
        Database.update(dUpd,false);
    }
    
 global void finish(Database.BatchableContext BC)
    {
        
    }
    
    global void execute(SchedulableContext sc)
    {
      integer batch_size = 100;
      String strQuery =''; 
        Dedup_notesAttachments_Batch  accBatch = new Dedup_notesAttachments_Batch (strQuery );
            database.executebatch(accBatch,500);    
    }

}