trigger setRessaignOpportunity on User (Before Update) {

Set <id> mgrs = new Set <id>();
map<id,user> mapmanager = new map<id,user>();
for (User u: trigger.new) {
mgrs.add(u.id);
}
for(user u: [select id, Managerid, isManager__c from User where isactive = true and Managerid in : mgrs and isCoachingUser__c = 'True']){
mapmanager.put(u.Managerid,u);
}
     for (User u: trigger.new) {
      //if ((Trigger.oldmap.get(u.id).isactive != u.isactive && u.isactive == false) || Trigger.oldmap.get(u.id).UserRoleId != u.UserRoleId)
     
     User m = mapmanager.get(u.id);
      if(m!= null)
         u.isManager__c = true;
         else 
         u.isManager__c = false;
   }
   
   // System.debug('Logged in USER::::::::::::::::::'+UserInfo.getUserId()+' == 005E00000023ms4IAA');
//005E0000000nAh9IAE -- ODSFA ID


if(UserInfo.getUserId() == '005E0000000nAh9IAE') {
    Util.DEBUG('Bypassing User Trigger As the user is ODSFA');
    return;
}

   for (User u: trigger.new) {
      //if ((Trigger.oldmap.get(u.id).isactive != u.isactive && u.isactive == false) || Trigger.oldmap.get(u.id).UserRoleId != u.UserRoleId)
      if ((Trigger.oldmap.get(u.id).isactive != u.isactive && u.isactive == false))
        u.Reassgin_Opportunity__c = 'NP';
      else if ((Trigger.oldmap.get(u.id).isactive != u.isactive && u.isactive == true))
        u.Reassgin_Opportunity__c = 'C';
   }
   
 
}