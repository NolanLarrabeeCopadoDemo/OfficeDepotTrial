trigger UpdateOwner on Coaching__c (before update, before insert) {
    
    list<ID> uids = new list<ID>();
    Map<ID,Boolean> managers = new Map<ID,Boolean>();
    Map<id,id> userToMgr = new Map<id,id>();
    Map<id,id> userToMMgr = new Map<id,id>();
    
    for (coaching__c c:Trigger.new) {
       uids.add(c.sales_rep__c);
    }
     system.debug('List ids before for loop'+uids);
    for (user u:[select id,managerid from user where IsCoachingUser__c ='true' and Manager.id IN :uids ]) {
    system.debug('Manager Ids In for Loop'+u.managerid);
        if (!managers.containskey(u.managerid))
           managers.put(u.managerid,true);
    }
    

    for (user u:[select id,managerid,manager.managerid from user where ID = :uids and (manager.isactive=true or manager.manager.isactive=true)]) {
          userToMgr.put(u.id,u.managerid);
          userToMMgr.put(u.id,u.manager.managerid);
    }

    for(Coaching__c c: Trigger.New){
       
      if (managers.containsKey(c.sales_rep__c))
          c.ownerid=c.sales_Rep__c;
       else { 
         if (userToMgr.containskey(c.sales_rep__c))
          c.ownerid=userToMgr.get(c.sales_rep__c);
         else if (userToMMgr.containsKey(c.sales_rep__c))
          c.ownerid=userToMMgr.get(c.sales_rep__c);
         else
          c.Ownerid = c.Sales_Rep__c;
       
        //c.Name__c = c.Sales_Rep__r.Name;
        }
    }
}