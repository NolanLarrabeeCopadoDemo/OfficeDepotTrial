trigger userRoleChange on User (before update, before insert, after update) {

   String REP_VAR = ' Rep';
    //story#01514722 to skip TZ profiles
    set<Id> pflId = new set<Id>();
    for(user u : trigger.new){
        pflId.add(u.ProfileId);
    }
     Map<string,Profile> userToProfileMap = new Map<string,profile>();
    
    for(profile p : [select id,name from profile where id IN :pflId]){
        userToProfileMap.put(p.name, p);
    }
  
    Map<ID,TZ_Profile_User__mdt > customMetaDataMap = new Map<ID,TZ_Profile_User__mdt>([select label from TZ_Profile_User__mdt]);
    
    for(TZ_Profile_User__mdt TZProfile :customMetaDataMap.values()){
        if(userToProfileMap.containsKey(TZProfile.label)){ 
            return; 
        }
    }
     
//skipping TZ profiles ends here
   //Collecting available Roles - Begins
   Map<string,ID> role_name_to_id = new Map<string,ID> ();
   Map<ID,String> role_id_to_name = new Map<ID,String> ();
   Map<String,role_details__c> role_to_detail_map = new Map<String,role_details__c> ();
   
   For (userrole rl : [SELECT NAME, ID FROM userrole]) {
     role_name_to_id.put(rl.name,rl.id);
     role_id_to_name.put(rl.id,rl.name);
   }
     
   For (role_details__c rl:[select id,role__c,region__c,district__c,market__c from role_details__c])
     role_to_detail_map.put(rl.role__c,rl);
   
   //Collecting available Roles - Ends
   
   // Building Map for Manager Changes and Role Changes - Begins
   Map<id,user> manager_changes_map = new Map<id,user> ();
   Map<ID,user> user_role_changes_map = new Map<ID,User> ();
   
   For (user u: Trigger.New){
    if (Trigger.isupdate) {
      if (trigger.oldMap.get(u.id).managerid != u.managerid && u.managerid <> null)
         manager_changes_map.put(u.id,u);
         
         system.debug('=======48=========='+trigger.oldMap.get(u.id).userroleid+'======='+u.userroleid);
      if (trigger.oldMap.get(u.id).userroleid <> u.userroleid && u.userroleid <> null)
         user_role_changes_map.put(u.id,u);
    }
    else {
      if (u.managerid <> null)
        manager_changes_map.put(u.id,u);
      if (u.userroleid <> null)
        user_role_changes_map.put(u.id,u);
    }
   }
   
   // Building Map for Manager and Role Changes - Ends
   
   //Capture Role changes and Populate Region, District, Market - Begins
   if (trigger.isbefore) {
     
     Map<ID,string> user_to_role_before = new Map<ID,String> ();

     for (user u:trigger.new) {
        user_to_role_before.put(u.id,role_id_to_name.get(u.userroleid));
     }
    
       
     For (user u: trigger.new) {
       if (user_role_changes_map.containskey(u.id)) {
         if (user_to_role_before.containskey(u.id)) {
           if (role_to_detail_map.containskey(user_to_role_before.get(u.id))) {
                  u.market__c = role_to_detail_map.get(user_to_role_before.get(u.id)).market__c;
                  u.region__c = role_to_detail_map.get(user_to_role_before.get(u.id)).region__c;
                  u.district__c = role_to_detail_map.get(user_to_role_before.get(u.id)).district__c;
           }
         }
       }
     }
     
   }
   //Capture Role changes and Populate Region, District, Market - Ends
   
   //Cascading Mananager Role Changes to Reporting Hierarchy - Begins
   /*
   if (trigger.isafter) {
     
    
     list<user> users_upd = new list<user> ();
     
      Map<ID,User> role_changes_for_users = new Map<ID,User> ();  
       for (user u: [SELECT ID,userrole.name,manager.userrole.name from user where 
       
        managerid = :user_role_changes_map.keyset()]) {// managerId !=null and 

        role_changes_for_users.put(u.id,u);
      }
      system.debug('===========user_role_changes_map========'+user_role_changes_map.keyset());
     for (user u: [SELECT ID,manager.userrole.name,profileId from user where managerid !=null and manager.userroleid!=null and managerid = :user_role_changes_map.keyset()]) {
       if (role_to_detail_map.containskey(u.manager.userrole.name)) {
         if (role_to_detail_map.containskey(u.manager.userrole.name)) { 
           if (role_to_detail_map.get(u.manager.userrole.name).region__c <> null && role_to_detail_map.get(u.manager.userrole.name).market__c <> null && role_to_detail_map.get(u.manager.userrole.name).district__c <> null) {
               u.region__c = role_to_detail_map.get(u.manager.userrole.name).region__c;
               u.market__c = role_to_detail_map.get(u.manager.userrole.name).market__c;
               u.district__c = role_to_detail_map.get(u.manager.userrole.name).district__c;
               if (role_name_to_id.containskey(role_to_detail_map.get(u.manager.userrole.name).role__c + REP_VAR)){               
                    String profileId=u.ProfileId;
                    profileId=profileId.substring(0,15);

                    if (profileId != label.Profile_Id_Chatter_Free_User) {
                        u.userroleid = role_name_to_id.get(role_to_detail_map.get(u.manager.userrole.name).role__c + REP_VAR);
                    }
               }
               users_upd.add(u);
           }
          }   
        }
     }
       update users_upd;
   }
   */
   //Cascading Mananager Role Changes to Reporting Hierarchy - Ends
   
   
   // Capture Manager Changes - Begins
   
   if (trigger.isbefore)
   {
   
   list<ID> managerIDs = new list<ID> ();
   Map <ID,Role_Details__c> manager_rmd_map = new Map<ID,Role_Details__c> ();
   
   For (user u: Manager_changes_map.values())
    managerIDs.add(u.managerid);

     
   For (user u: [SELECT ID,userrole.name from user where id = :managerIDs]) {
     if (role_to_detail_map.containskey(u.userrole.name))
       manager_rmd_map.put(u.id,role_to_detail_map.get(u.userrole.name));
   }
   
   For (user u: Trigger.New) {
     if (manager_changes_map.containskey(u.id)) {
       if(manager_rmd_map.containskey(u.managerid)) {
          if (manager_rmd_map.get(u.managerid).region__c <> null && manager_rmd_map.get(u.managerid).Market__c <> null && manager_rmd_map.get(u.managerid).District__c <> null) {
                   u.region__c = manager_rmd_map.get(u.managerid).region__c;
                   u.market__c = manager_rmd_map.get(u.managerid).Market__c;
                   u.district__c = manager_rmd_map.get(u.managerid).District__c;
                   if (role_name_to_id.containskey(manager_rmd_map.get(u.managerid).role__c + REP_VAR)) {
                       System.debug('---HERE');
                       String profileId=u.ProfileId;
                       profileId=profileId.substring(0,15);
                       if (profileId != label.Profile_Id_Chatter_Free_User) {
                           u.userroleid = role_name_to_id.get(manager_rmd_map.get(u.managerid).role__c + REP_VAR);
                       }
                   }
          }
       }
     }
         
   }
  }
   // Capture Manager Changes - Ends
   
}