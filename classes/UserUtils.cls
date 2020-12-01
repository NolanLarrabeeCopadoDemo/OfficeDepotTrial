public with sharing class UserUtils {
   
    public static Set<ID> getAllmyReportees(Id userId){
        Set<Id> users = new Set<Id>(); 
        users.add(userId);
         Set<Id> templist = getAllReportees(users);
         for(id a:templist){
            users.add(a);
         }
         do {
            templist = getAllReportees(templist);
            for(id a:templist){
                users.add(a);
            }
      System.debug('Callaaaa'+templist.size());
        } while (templist.size() > 0);
         
        return users; 
         
    }
    public static Set<Id> getAllReportees(Set<Id> userId){
        Set<Id> u = new Set<Id>();
        for(user ou:[select Id from User where isactive = true and ManagerId = :userId]){
            u.add(ou.Id);
        }
        return u;
        
    }
    
}