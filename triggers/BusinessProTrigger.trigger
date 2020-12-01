trigger BusinessProTrigger on Contact (before insert) {
        //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    for(Contact c: trigger.new)
    {
        if(util.checkRT('Contact').contains(c.recordtypeId))
            return;
    }
          // added for ticket 01474559
       if (Trigger.New != null) {
         for (Contact myCont: Trigger.new) {
          if (Util.bizBoxRTIdsByObject('Contact').contains(myCont.RecordTypeId)) {
           return;
          }
         }
        }

   Set<String> loyNum = new Set<String>();
   Map<String,Account> loyAcct = new Map<String,Account>();
   
   list<BusinessProSetup__mdt> bproSetup = [select ContactTriggerUser__c,AccountRecordType__c,AccountRetURL__c,ContactRecordType__c,LeadRecordType__c,noOverrideEditURL__c,OpportunityRecordType__c,PublicGroupName__c from BusinessProSetup__mdt limit 1];
   
  if (bproSetup.size() > 0) { 
   if (userInfo.getUserID() == bproSetup[0].ContactTriggerUser__c) {
  
   RecordType r = [select id from recordType where sobjecttype='Contact' and name=:bproSetup[0].ContactRecordType__c];
   
   for (contact c:Trigger.new) {
      if (c.loyalty_number__c != null)
         loyNum.add(c.loyalty_number__c);
   }
   
   for (account a:[select id,loyatly_number__c from account where recordtype.name=:bproSetup[0].AccountRecordType__c and loyatly_number__C=:loyNum]) {
       loyAcct.put(a.loyatly_number__c,a);
   }
   
   for (contact c:Trigger.new) {
    if (c.loyalty_number__c != null) {
      if (loyAcct.containskey(c.loyalty_number__c)) {
        c.AccountId=loyAcct.get(c.loyalty_number__c).id;
        c.Recordtypeid = r.id; 
      }
      else {
       c.addError('Related BusinessPro Account Does Not Exist');
      }
     }
   } 
 
 }  
  }   
}