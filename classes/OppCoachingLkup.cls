global class OppCoachingLkup implements database.Batchable<Sobject>, Schedulable 
{ 
  public String DEFAULT_QUERY= 'select id,Coaching__c,ownerid,owner.isActive from opportunity where status__c=\'Open\'';
  public String strQuery;
  global OppCoachingLkup ()
  {
       RecordType r=[select id from recordType where sobjecttype='Opportunity' and developerName='Field_Sales_US'];
       this.strQuery = DEFAULT_QUERY + ' and RecordTypeId=\''+r.id+'\'';
        
  }
  
   global OppCoachingLkup(String query)
    {
        //getCustSettings();
        System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else{
            //conditioncheck();
            this.strQuery = DEFAULT_QUERY;
            RecordType r=[select id from recordType where sobjecttype='Opportunity' and developerName='Field_Sales_US'];
            this.strQuery = DEFAULT_QUERY + ' and RecordTypeId=\''+r.id+'\'';
        }
    }
    
     /*Start Method*/
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(strQuery); 
    }
  
  global void execute(Database.BatchableContext BC, SObject[] scope){
      list<Opportunity> oppL = scope;
      list<Opportunity> oppUpd = new list<Opportunity>();
      list<ID> oppId = new list<ID>();
      Map<ID,ID> userToCoachingMap = new Map<ID,ID>();
      Map<ID,ID> pOwnerIDMap = new Map<ID,ID>();
      Map<ID,ID> tOwnerIDMap = new Map<ID,ID>();
      set<ID> uIDs = new set<ID>();
      
      for (Opportunity o: oppL) {
        oppid.add(o.id);
        //if (o.owner.isActive)
        // pOwnerIDMap.put(o.id,o.ownerId); 
      }
      
      for (opportunity o:[select id,account.ownerid from opportunity where id=:oppid and account.owner.isactive=true])
         pOwnerIDMap.put(o.id,o.account.ownerId);
      /*
      for (opportunityTeamMember otm:[SELECT id,user.short_title__c,userId,user.isActive,OpportunityId from OpportunityTeamMember where OpportunityId=:oppid and user.isActive=true
                                     and user.short_title__c in ('ESDM','MSDM')])   
      {
          tOwnerIDMap.put(otm.OpportunityId,otm.userId);
      }
      */
      for (ID i:pOwnerIDMap.values())
         uiDs.add(i);
      /*
      for (ID i:tOwnerIDmAP.values())
         uiDs.add(i);
      */ 
      for (coaching__c c:[select sales_rep__c,id from coaching__c where sales_rep__c=:uIDs]) {
          userToCoachingMap.put(c.sales_rep__c,c.id);
      }
      
      for (Opportunity o:oppL) {
          /*
          Boolean coachingFound=false;
          
          if (tOwnerIDMap.containsKey(o.id)) {
              if (userToCoachingMap.containsKey(tOwnerIDMap.get(o.id))) {
                  o.coaching__c=userToCoachingMap.get(tOwnerIDMap.get(o.id));
                  coachingFound=true;
              }
          }
          */
         // if (!coachingFound) {
             if (pOwnerIDMap.containsKey(o.id)) {
               if (userToCoachingMap.containsKey(pOwnerIDMap.get(o.id))) {
                  o.coaching__c=userToCoachingMap.get(pOwnerIDMap.get(o.id));
                  OppUpd.add(o);
                 // coachingFound=true;
               }
             }
          //}
          
          //if (coachingFound)
            
          
       }//end of for
       
       //If coachingFound is false then do nothing (Going by what is in the sprint story#01057712 : "If the opportunity owner is inactive and there is no team member to meet the criteria, the 'Coaching__c' value would remain unchanged ")
        if (OppUpd.size() > 0 ){
            database.update(OppUpd,false);
        }
      }
  
   global void execute(SchedulableContext sc){
        //String strQuery = '';
        OppCoachingLkup opp = new OppCoachingLkup();
        database.executebatch(opp, 100);
        
        //System.abortJob(sc.getTriggerID());
        
  }
  
  global void finish(Database.BatchableContext BC){
  }
  
  
}