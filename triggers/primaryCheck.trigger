trigger primaryCheck on Contact (after insert,after update) {
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




//--------------------------------------------//
  // To Bypass trigger code on certain condition
  //-------------------------------------------//
  if (Util.bypassTriggers('primaryCheck')) {
    Util.DEBUG('Bypassing trigger primaryCheck');
      return;
  }

list<ID> acctIDs = new list<ID>();
list <contact> cont = new list<contact> ();
list<ID> contIDs = new list<ID> ();
ID acctID;

For (contact c: trigger.new)
  if (c.Primary_Contact__c)
    contIDs.add(c.id);

cont = [select account.id from contact where id in :contIDs];

for (contact c:cont)
 acctIDs.add(c.account.id);
list<contact> cntcts = new list<contact> ();

if (acctIDs.size() > 0) {
  cntcts = [SELECT ID from contact where account.id = :acctIDs and primary_contact__c = true and (not ID in :Trigger.newMap.keySet())];
}
  
for (contact c:cntcts) {
 c.primary_contact__c = false;
}
  update cntcts; 
 }