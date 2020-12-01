// This trigger is to clear the K12 ILC team field based on deletion of ILC Team Member
trigger OpportunityTeamMemberafterdelete on OpportunityTeamMember (after delete) {
Set<Id> oppId= new Set<Id> ();
Set<Id> oppMemberId= new Set<Id> ();
List<Opportunity> OppList = new List<Opportunity> ();
  for(  OpportunityTeamMember rec: Trigger.Old){
      if(rec.Is_ILC_Rep__c==true){
        if(! oppId.contains(rec.OpportunityId))
        oppId.add(rec.OpportunityId);
      }
   }  
   if( oppId.size()>0){
   List<OpportunityTeamMember > memberList= [ select OpportunityId  from OpportunityTeamMember  where 
   OpportunityId in:oppId  and Is_ILC_Rep__c=true];
      for( OpportunityTeamMember recNew :memberList){if(! oppMemberId.contains(recNew.OpportunityId)) oppMemberId.add(recNew.OpportunityId);           
         }
        for(  Id recId :oppId){
              if(! oppMemberId.contains(recId)){
                 Opportunity opp= new Opportunity ();
                 opp.Id= recId;
                 opp.K12_Team__C=false;
                 OppList.add(opp);
              }
        }
        if(OppList.size()>0)
        update OppList;
   }
}