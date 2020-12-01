trigger OpportunityTeamMemberafterInsert on OpportunityTeamMember (after insert) {
   // Update Opportunity if an ILC member is added as TeamMember 
   Set<Id> oppId= new Set<Id>();
   List<Opportunity> updateList= new List<Opportunity> ();
   for(OpportunityTeamMember  rec: Trigger.new){
   // checking if the user is an ILC Rep
       if(rec.Is_ILC_Rep__c==true  
       //&&  rec.TeamMemberRole=='Team Member'
       ){
         if(!oppId.contains(rec.OpportunityId ))
         oppId.add(rec.OpportunityId);
       }
   }
   if(oppId.size()>0){
      for( Id recId :oppId){
        Opportunity recNew = new Opportunity();
        recNew.Id=recId ;
        recNew.K12_Team__C=true;
        updateList.add(recNew );
      }
     update updateList;
   }
}