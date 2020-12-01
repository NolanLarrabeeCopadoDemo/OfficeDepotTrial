public class AddUser {
//functionality to remove users from group
public static void removefromGroup(List<User> users){
List <CollaborationGroupMember>  listToDelete = new List<CollaborationGroupMember> ();
try{
listToDelete = [Select MemberId from CollaborationGroupMember where MemberId =:users];
delete listToDelete;
}
catch(Exception e){}
}

@future
public static void insertMember (List<Id> users, String groupId){
  List<CollaborationGroupMember>listGroupMember =new List<CollaborationGroupMember>();  
  for(integer i=0;i<users.size();i++){
            CollaborationGroupMember gm= new CollaborationGroupMember (); 
            gm.CollaborationGroupId=groupId;
            gm.MemberId= users[i];
            listGroupMember.add(gm);
 }
 if(listGroupMember .size()>0)
 insert listGroupMember;

}

public static void AddToGroups(List<User> users)
    {
      List<Id > listGroupMemberId = new List<Id >();
           List<Id > listGroupMemberall = new List<Id >();
        for (User user : users) 
        {   
            integer flag = 0;
            for (BSD_Reps_Ids__c item : BSD_Reps_Ids__c.getAll().values()) {
            if (user.profileId == item.BSD_Profile_Ids__c)
            flag = 1;
         }
          
           if(flag == 1)    
          { 
          listGroupMemberId.add(user.Id);
           }  
                              
      
               
            integer flagallbsd = 0;
            for (All_BSD_Reps_Ids__c item : All_BSD_Reps_Ids__c.getAll().values()) 
            {
                if (user.profileId == item.All_BSD_Ids__c)
                flagallbsd = 1;
             }
           if(flagallbsd == 1 )
          { 
            listGroupMemberall.add(user.Id);
            System.debug('gm added to list');
          }  
                         
                      
        }          
                    
 System.debug('before insert');
 if(  listGroupMemberId.size()>0){
 insertmember(listGroupMemberId,System.Label.BSD_Reps); 
 }
  if(  listGroupMemberall.size()>0){
 insertmember(listGroupMemberall,System.Label.All_BSD_Memebers); 
 
 }


    }

}