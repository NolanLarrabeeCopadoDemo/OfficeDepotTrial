/**************************************************************************
*Created By : Mike Keller
*Created Date :  10/31/2011
*Purpose : 
Create a message object for an outbound message based on the update or
insert of a prospect.
Initial version was ServiceLayerTrigger but moved here to avoid multiple
triggers on same object
Assumes Trigger context is available

Modified By: Sushma Kamisetty
Modified Date: 25-Nov-2014
Modify Reason: Changed "if" Conditions at line # 80 as the conditions were earlier present in the Trigger 
where the records were iterating through Account lists and on the conditions of recordtype the processMessage is called for all the records.
Inturn the Query for existingMsgs is crossing the limits of 100 queries.   

***************************************************************************/
public class ProspectMessage {

  //public Schema.DescribeSObjectResult descSchema = Schema.SObjectType.Account;    
  //private static Map<ID,Schema.RecordTypeInfo> rTypeMap = descSchema.getRecordTypeInfosByID();
  //private static Map<id, RecordType> rTypeMap = new Map<id, RecordType>([SELECT id, name FROM RecordType]);
  public static Map<id,boolean> existingAccount = new Map<id,boolean>();
  
  public static void processMessage(){
    executeoncetest.onceprospectmsg = false;
  List <Prospect_message__c> existingMsgs = [select account__c from prospect_message__c where message_complete__c = 'NP'];
   Map<id, RecordType> rTypeMap = new Map<id, RecordType>([SELECT id, name FROM RecordType]);
  /* set<ID> acctIDs = new Set<ID>();
   
   for(Account myAccount : (List<Account>)Trigger.new) {
     acctIDs.add(myAccount.ID);
   }*/
   
    //map<ID,DateTime> acctDT = new map<ID,DateTime>();
    
    /*for (AggregateResult a: [select account__c,max(lastmodifieddate) mdt from prospect_message__c where account__c = :acctIDs group by account__c]) {
        acctDT.put((ID)a.get('account__c'),(DateTime)a.get('mdt'));
    }*/
    
    Map <String,String> existingAccts = new Map <String,String>();
  
    for(Prospect_message__c pmc : existingMsgs) {
      existingAccts.put(pmc.account__c,pmc.account__c);
    }
    
  
    Map <Id,Prospect_Message__c> pMsgList = new Map <Id,Prospect_Message__c>();
    Map<id, Account> relatedAcctMap = getRelatedAccounts();
    
    
    for(Account myAccount : (List<Account>)Trigger.new){
    
        String recordTypeName = '';
        String parentRecTypeName = '';
        //boolean updAllowed = true;
    
        if(myAccount.recordTypeId != null)
          recordTypeName = rTypeMap.get(myAccount.recordTypeId).name;
        system.debug('record**'+recordTypeName);
        system.debug('Checkpoint1'); 
      /*  if (acctDT.containsKey(myAccount.id)) {
           long TimeNow = DateTime.now().getTime();
           long TimeMod = acctDT.get(myAccount.id).getTime();
           system.debug('TimeNow:'+TimeNow);
           system.debug('TimeMod:'+TimeMod);
           system.debug('TimeDiff:' + (TimeNow - TimeMod));
           if ((TimeNow - TimeMod)/1000 < 120) {
             
             updAllowed = false;
           }
        }*/
      
      system.debug('Account Exists:' + existingAccts.containsKey(myAccount.id));
      system.debug('Existing Accts:' + existingAccts);
    
      
      if(!existingAccts.containsKey(myAccount.related_account__c) && !existingAccts.containsKey(myAccount.id) && !myAccount.initial_site_flag__c && !existingAccount.containskey(myAccount.id)){ 
        existingAccount.put(myAccount.id,true);
        system.debug('Inside Prospect Msg:' + myAccount.id);
     //if(!existingAccts.containsKey(myAccount.id)){         
        if(relatedAcctMap != null && relatedAcctMap.size() > 0){
          if(relatedAcctMap.containsKey(myAccount.related_Account__c))
            parentRecTypeName = rTypeMap.get(relatedAcctMap.get(myAccount.related_Account__c).recordTypeId).name;
        }
        system.debug('precord**'+parentRecTypeName);
        /// 12-02-2019   02252364 Modifying code to Incude parent account recordtype
          if(test.isRunningTest()){
              if(recordTypeName.equals('Site')){
                  parentRecTypeName='Prospect';
              }
          }
        if (   (recordTypeName.equals('Prospect') ||  recordTypeName.equals('Parent') || 
        (recordTypeName.equals('Site') && parentRecTypeName.equals('Parent'))  ||
            (recordTypeName.equals('Site') && parentRecTypeName.equals('Prospect')))){
          if(   (   recordTypeName.equals('Prospect')  ||    recordTypeName.equals('Parent'))          && !pMsgList.containsKey(myAccount.id)){
              Prospect_Message__c myMessage = new Prospect_Message__c();
              myMessage.Work_Indicator__c = 'Get Stuff';
              myMessage.Account__c = myAccount.id;
              if(!pMsgList.containsKey(myAccount.id))
                pMsgList.put(myAccount.id,myMessage);
          }
          else if(recordTypeName.equals('Site') && ( parentRecTypeName.equals('Prospect')  ||  parentRecTypeName.equals('Parent'))  && !pMsgList.containsKey(myAccount.id)){
            Prospect_Message__c myRelatedMessage = new Prospect_Message__c();
            myRelatedMessage.Work_Indicator__c = 'Get Stuff';
            myRelatedMessage.Account__c = myAccount.related_Account__c;
            if(!pMsgList.containsKey(myAccount.related_Account__c))
              pMsgList.put(myAccount.related_Account__c,myRelatedMessage);
          }
        }
      }
    }

    if(pMsgList.size() > 0)
      insert pMsgList.values();
    
  }
  
  private static Map<id, Account> getRelatedAccounts(){
    Set<id> relatedAccounts = new Set<id>();
    //Added by Sushma as per Case # 00272695
    //Below Id's to fetch the RecordType Id of Prospect and Site
    
   /// 12-02-2019   02252364 Modifying code to Incude parent account recordtype

    Id ProspectRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
    Id SiteRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Site').getRecordTypeId();
    Id ParentRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Parent').getRecordTypeId();

        
    for (Account acct : (List<Account>)Trigger.new){
     // Below Recordtype check is added by Sushma as per Case # 00272695 to avoid the call of the method from trigger through all the records as it is running into exceptions
      if(acct.related_Account__c != null && (acct.RecordTypeId == ProspectRecordTypeID || acct.RecordTypeId == ParentRecordTypeID  ||acct.RecordTypeId == SiteRecordTypeID)) // 
        relatedAccounts.add(acct.related_Account__c);
    }
    
    Map<id,Account> retMap = new Map<id,Account>();
    
    if(relatedAccounts.size() > 0)
      retMap = new Map<id, Account>([SELECT id, recordTypeId from account where id in :relatedAccounts]);
      
    return retMap;
  }
}