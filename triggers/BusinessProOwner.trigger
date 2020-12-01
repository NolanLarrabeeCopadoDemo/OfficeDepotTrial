trigger BusinessProOwner on Business_Pro_Owner__c (before insert) {

   if (Trigger.isBefore && Trigger.isInsert) {
      
      list<ID> acctIDs = new list<ID>();
      Map<ID,Business_Pro_Owner__c> bproMap = new Map<ID,Business_Pro_Owner__c>();
      list<Business_Pro_Owner__c> bproUpd = new list<Business_Pro_Owner__c>();
      list<account> acctUpd = new list<Account>();
      
      for (Business_Pro_Owner__c b:Trigger.new) {
         acctIDs.add(b.account__c);
         bproMap.put(b.account__c,b);
      }
      
      for (Business_Pro_Owner__c b:[select id,end_date__c,start_date__c,isCurrent__c,account__c from business_pro_owner__c where account__c=:acctIDs and isCurrent__c=true]) {
          b.end_date__c = bproMap.get(b.account__c).start_date__c;
          b.isCurrent__c = false;
          bproUpd.add(b);
      }
      
      for (Account a:[select id,ownerID,Sales_PersonID__c from account where id=:acctIDs]) {
         system.debug('$$$'+bproMap.get(a.id).BusinessPro__c);
         a.ownerID = bproMap.get(a.id).BusinessPro__c;
         acctUpd.add(a);
      }
      
      update bproUpd;
      update acctUpd;
      
   }

}