/**************************************************************************
*Trigger : User_emailWhenRoleChanged
*Purpose : When the custom field IsRoleChanged is changed on User,notifies a master user for the changes
           on all users that underwent the change 
****************************************************************************/
trigger User_emailWhenRoleChanged on User (before insert, after insert,before update, after update) {
 //public integer i = executeoncetest.executeonce;
system.debug('executeoncetest.executeonce>>>>>'+executeoncetest.executeonce);
if(executeoncetest.executeonce == 0){ 
  // Create a set of all the unique active Manager Ids
  executeoncetest.executeonce = + 1;

  Set<id> mgrIds = new Set<id>();
  
  for (User mgr: [SELECT managerId from User Where managerId != null and managerId in :Trigger.new and isactive = true]) {
    mgrIds.add(mgr.managerId);
  }     
  
  Map <Id,User> MapMgr = new Map <Id,User> ();
  // Put all the managers in to the map
  for (User u: [SELECT ID from User Where id in :mgrIds]) {
    MapMgr.put(u.Id, u);
  }

  for(User user :Trigger.New) {
    // Set the default timezone if blank
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) { 
      if (user.TimeZoneSidKey == null || user.TimeZoneSidKey == '')
        user.TimeZoneSidKey = 'America/New_York';
        
      // For new Managers always set role changed 
      if ((Trigger.isInsert) && (MapMgr.get(user.Id) != null)) 
        user.isRoleChanged__c = true; 
        
      // Capture Previous Title and Manager Ids for Updates
      if (Trigger.isUpdate) {
        // Get the old snapshot of the user record
        User oldRecord = Trigger.oldMap.get(user.Id);        
        // Set role changed if title or manager changed for user
        if (((user.Title != oldRecord.Title) || (user.ManagerId != oldRecord.ManagerId)) && (MapMgr.get(user.Id) != null)) 
          user.isRoleChanged__c = true; 
        // Populate previous title if title changed
        if (user.Title != oldRecord.Title) 
          user.Previous_Title__c = oldRecord.Title; 
          
        // Populate previous manager if manager changed
        if (user.ManagerId != oldRecord.ManagerId) 
          user.Previous_Manager__c = oldRecord.Manager__c;           
      }
    }
  }
 }
}