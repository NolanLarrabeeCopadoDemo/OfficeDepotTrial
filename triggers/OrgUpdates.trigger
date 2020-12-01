trigger OrgUpdates on Account (before update) {
// If there is an Org change update checkbox to true to get triggered by batch class
   for(Account rec : Trigger.new){
          if ( (rec.Org__C != trigger.oldMap.get(rec.id).org__C)  && rec.Org__C  !=null)
          rec.OrgChildUpdate__C= true;

   }
}