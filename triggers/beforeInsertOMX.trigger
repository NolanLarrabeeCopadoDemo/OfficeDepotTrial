trigger beforeInsertOMX on Account (before Insert) {
     //Account Service Production Fix
    Set<ID> resp = new Set<ID>();
    resp = Util.bizBoxRTIdsByObject('Account');
    
    //Story#01514722 - Below Piece of code is used to skip RecordType (Tech Zone)
   /* for(Account a: trigger.new)
    {
        if(util.checkRT('Account').contains(a.recordtypeId))
            return;
    }*/
    public static boolean bypassbeforeomx = false;
   
    if (Trigger.New != null) {
 for (Account myAccount: Trigger.new) {
  //if (Util.bizBoxRTIdsByObject('Account').contains(myAccount.RecordTypeId)) {
       if (resp.contains(myAccount.RecordTypeId)) {
   return;
  }
 }

}
  if (!bypassbeforeomx)
  {
    ID currUserId = UserInfo.getUserId();
    Map<String,boolean> dormantExists = new Map<String,boolean>();
    //user u = [select id,username from user where id=:currUserId];
                String userName = UserInfo.getUserName();

    Set<String> omxKeys = new Set<String>();
    for (account a: trigger.new) {
       if (a.omx_primary_key__c != null && a.omx_primary_key__c != '')
         omxKeys.add(a.omx_primary_key__c);
    }
    if (omxKeys.size() > 0)
    {
      for (Account_Dormant__c ad: [select accountExtension__r.omx_primary_key__c from account_dormant__c 
                                 where accountExtension__r.omx_primary_key__c = :omxKeys] )
      {
       dormantExists.put(ad.accountExtension__r.omx_primary_key__c,true);
      }
    }
    
    if (!dormantExists.isEmpty())
    {
     for (account a: trigger.new) {
        //if (u.username.contains('dataloadernorth@officedepot.com') && a.omx_primary_key__c != null) {
         if (userName.contains('dataloadernorth@officedepot.com') && a.omx_primary_key__c != null) {
          if (dormantExists.containskey(a.omx_primary_key__c))
             a.addError('Record Exists in Dormant Object');
         }
      }
    }
    bypassbeforeomx = true;
  }
}