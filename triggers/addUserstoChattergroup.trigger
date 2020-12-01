trigger addUserstoChattergroup on User (after insert, after update) {

    
     List<User> removeList = new List<User>();
      List<User> userList = new List<User>();
     
   for( User user : Trigger.new) {   
     if(Trigger.isInsert)
      userList.add(user); 
    
    
    if(Trigger.isupdate)
    {       
         
        if(user.isactive != trigger.oldMap.get(user.Id).isactive  &&  user.isactive==false)
        {
        removeList .add(user); 
        }
           
    }
  }
    //calling method for Inactivation
    if(removeList.size()>0)
    AddUser.removefromGroup(removeList);
    //calling method for Insert/update
    if(userList .size()>0)
     AddUser.AddToGroups(userList );
   
 }