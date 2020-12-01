/*
  (c) 2014 Appirio, Inc.
  Universal Trigger Event Handler for Account_Profile_Staging__c
  8 Jun 2015     Ben Lorenz          Created
*/

trigger AccountProfileStagingEvents on Account_Profile_Staging__c (before insert, before update, before delete,
                                                                   after insert, after update, after delete, after undelete) {
  accountProfileStagingEventHandler apseh = new accountProfileStagingEventHandler(trigger.new, trigger.old, trigger.newMap, trigger.oldMap);
  List<Account_Profile_Staging__c> recId= new List<Account_Profile_Staging__c>();
  if (Trigger.isBefore){
    if (Trigger.isInsert) {  //BEFORE INSERT
    } else if (Trigger.isUpdate) {  //BEFORE UPDATE
    } else if (Trigger.isDelete) {  // BEFORE DELETE
    }
  } else {
    if (Trigger.isInsert) {  // AFTER INSERT
      for (Account_Profile_Staging__c  rec:Trigger.New){
      Account_Profile_Staging__c  recNew = new Account_Profile_Staging__c (Id= rec.Id);
      recId.add(recNew );    
      }
      apseh.upsertTaxStatus();
    } else if (Trigger.isUpdate) {  // AFTER UPDATE
    } else if (Trigger.isDelete) {  // AFTER DELETE
    } else if (Trigger.isUndelete) {  // AFTER UNDELETE
    }
  }
  //Logic added to delete after Inserting account Profile records as part of data cleansing project
  if (trigger.isafter && Trigger.isInsert && recId.size()>0  ){
      delete(recId);
    }
    
}