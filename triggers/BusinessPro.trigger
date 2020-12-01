trigger BusinessPro on Account (after Insert) {
    
     //Account Service Production Fix
    Set<ID> resp = new Set<ID>();
    resp = Util.bizBoxRTIdsByObject('Account');
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
    for(Account a: trigger.new)
    {
        //if(util.checkRT('Account').contains(a.recordtypeId))
        if(resp.contains(a.recordtypeId))
            return;
    }
    Recordtype rtype = [select id from recordtype where sobjecttype='Account' and recordtype.name = 'Customer (Business Pro)' limit 1];
   list<business_pro_owner__c> bproUpd = new list<business_pro_owner__c>();
   for (account a:Trigger.new) {
     if (a.recordtypeid == rtype.id) {
       business_pro_owner__c bo = new business_pro_owner__c();
       bo.account__c = a.id;
       bo.BusinessPro__c = a.ownerid;
       bo.start_date__c = system.today();
       bo.iscurrent__c = true;
       bproUpd.add(bo);
     }
   }
   
   database.insert(bproUpd,false);

}