trigger afterInsertTriggerOppTracking on Opportunity_Tracking_History__c (after insert) {
// Insert the ILC Reps in the custom object 
List<Opportunity_Team_Member_History__c > insertList = new List<Opportunity_Team_Member_History__c > ();
    for(Opportunity_Tracking_History__c  rec: trigger.new){
      //if(rec.Is_ILC_Team_Owned__c==true  && rec.Opportunity_Team_Member__c!=null){
           if(rec.Opportunity_Team_Member__c!=null){
           List<String > str= rec.Opportunity_Team_Member__c.split(',');
           for( String s :str){
           Opportunity_Team_Member_History__c newRec= new Opportunity_Team_Member_History__c();
           newrec.Opportunity_Tracking_History__c=rec.Id;
           newrec.User__c=s;
           newrec.Fiscal_Month__c=rec.Fiscal_Month__c;
           newrec.type__C=rec.type__C;
           newrec.Summary_Stage__c =rec.Summary_Stage__c ;
           newrec.Fiscal_Year__c=rec.Fiscal_Year__c;
           newrec.Opportunity__C=rec.Opportunity__C;
           insertList .add(newRec);
          }
      
      }
    }
   if(insertList .size()>0)
   insert insertList ;
}