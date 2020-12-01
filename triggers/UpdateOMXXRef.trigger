trigger UpdateOMXXRef on Sales_Person__c (after insert, after update) {
 Map<Id,String> SalesPersontoUserMap = new Map<Id,String> ();
  For (Sales_Person__c s: Trigger.New){
   if (Trigger.isupdate) {
      if (trigger.oldMap.get(s.id).OMX_Rep_ID__c != s.OMX_Rep_ID__c && s.OMX_Rep_ID__c <> null)
         SalesPersontoUserMap.put(s.User__c,s.OMX_Rep_ID__c);
    
    }
    else {
      if (s.OMX_Rep_ID__c <> null)
         SalesPersontoUserMap.put(s.User__c,s.OMX_Rep_ID__c);
    }
  }
  
  List <User> ul = new List <User>();
  // Moved out query from loop, Story S-346417, Rahul Chitkara
  Map<Id,User> userMap = new Map<Id,User>([select id,OMX_Rep_Number__c from user where Id in : SalesPersontoUserMap.keySet() ]);
  User r;
  for (Id userid : SalesPersontoUserMap.keySet()){
  	if(userMap.containsKey(userId)){
  		//User r=    [select id,OMX_Rep_Number__c from user where id= :userid];
        r= userMap.get(userid);  
        String spid= SalesPersontoUserMap.get(userid);
        if(r.OMX_Rep_Number__c<> spid)
         {
          r.OMX_Rep_Number__c = spid;
          ul.add(r);
         }
  	}   
  }
       update ul; 
  
  
}