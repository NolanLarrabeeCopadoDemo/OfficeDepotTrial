//
// (c) Appirio Inc. 2015
//
//
// Author    Jai Gupta    May 27 2015
// Modified  Luke SLEVIN  S-347755 8.31.2015
// Modified  Nicole Bock S-377000 2.9.2016
// Generic trigger to be used for all the events | Handler class: AccountEventHandler
//
//
trigger AccountEvents on Account (before insert,before update,after insert,after update,before delete,after delete,after undelete) {
    //Pros Related code start
    If(Trigger.isBefore)
      {
          if(trigger.isInsert)
            SalesrepNotNullHelper.BeforeInsert(trigger.new);
            
           if(trigger.isUpdate)
              SalesrepNotNullHelper.BeforeUpdate(trigger.new,trigger.oldmap);
      }
    If(Trigger.isAfter)
      {
          if(trigger.isUpdate){
             Pros_handler.createaccountsetup(trigger.new,trigger.oldmap);
              }
          if(trigger.isInsert){
             createDMLRelationshipRecord.createDMLRelationship(trigger.new);
              }
      }
    //Pros Related code end
    //Account Service Production Fix
    Set<ID> resp = new Set<ID>();
    resp = Util.bizBoxRTIdsByObject('Account');
    
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    //Nicole Bock S-377000 - add ed Test.isRunningTest to allow for coverage
    if (Trigger.New != null) {
 for (Account myAccount: Trigger.new) {
  //if (Util.bizBoxRTIdsByObject('Account').contains(myAccount.RecordTypeId)&&util.checkRT('Account').contains(myAccount.recordtypeId)) {
  if (resp.contains(myAccount.RecordTypeId)) {
   return;
  }
 }

}
    if (executeoncetest.notTriggered_AccountEvents_before || executeoncetest.notTriggered_AccountEvents_after || Test.isRunningTest()) {
        if (Trigger.isBefore) {
            executeoncetest.notTriggered_AccountEvents_before = false;
        }
        else { // Trigger.ifAfter
            executeoncetest.notTriggered_AccountEvents_after = false;
        }
    
        AccountEventHandler handler = new AccountEventHandler(Trigger.isExecuting, Trigger.size);
    
        if(Trigger.isInsert && Trigger.isBefore){
        }
        else if(Trigger.isInsert && Trigger.isAfter){
    
        }
        else if(Trigger.isUpdate && Trigger.isBefore){
            //LSLEVIN S-347755 8.31.2015 Start
            for(Account myAccount : Trigger.new)
            {
                if(Util.bizBoxRTIdsByObject('Account').contains(myAccount.RecordTypeId)){
                    return;
                }
            }
            handler.sendToAccountSetup(Trigger.new,Trigger.oldMap);
            //LSLEVIN S-347755 8.31.2015 Stop
        }
        else if(Trigger.isUpdate && Trigger.isAfter){
    
        }
        else if(Trigger.isDelete && Trigger.isBefore){
    
        }
        else if(Trigger.isDelete && Trigger.isAfter){
    
        }
        else if(Trigger.isUnDelete){
    
        }
    }
}