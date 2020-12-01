trigger populateAcctLookup on Reassignment_Queue__c (after insert) {
   List<Account> acUpd = new list<Account>();
   for (Reassignment_Queue__c q: Trigger.new) {
     Account a = new Account(ID=q.account__c);
     a.Assignment_status__c = q.id;
     acUpd.add(a);
   }
   update acUpd;
}