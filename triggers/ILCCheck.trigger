trigger ILCCheck on Instructional_Lead_Consultant__c (after insert,after update) {
List<user> usrlist= new List<user>();
List<user> updateuserlist = new List<user>();
Set<id> ids = new Set<Id>();

for(Instructional_Lead_Consultant__c ILC : trigger.new)
{ids.add(ILC.User__c);

}
usrlist= [select id,Is_ILC_Rep__c from user where id IN :ids];

for(user u : usrlist)
{
u.Is_ILC_Rep__c =true;
updateuserlist.add(u);
}
 if(updateuserlist.size()>0)
 {
 
 update updateuserlist;
 
 }
 
}