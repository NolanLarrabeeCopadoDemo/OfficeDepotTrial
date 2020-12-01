trigger PopulateKey on Opportunity_Team_Member_History__c (before insert) {

List<Id> oppId= new List<Id>();
//get current fiscal month

//get current year
    String currYear=String.valueOf(System.Today().Year());
    String currentMonth;
// get the records that need to have a PLS Key
  for(Opportunity_Team_Member_History__c rec :Trigger.new){
     if( rec.Summary_Stage__c !=null && rec.Type__c=='WatsonStageChange' ){
       currentMonth =rec.fiscal_month__C;
       oppId.add(rec.Opportunity__c );
     } 
  }
  //get the records with PLS Key
  Map<String,string > newMap = new Map<String,string > ();
  
  List<Opportunity_Team_Member_History__c > recList=[select Opportunity__r.Id,Opportunity__c,key__C,user__C,Summary_Stage__c ,type__c,
  Fiscal_Month__c from Opportunity_Team_Member_History__c where 
  key__C!=null and type__c='WatsonStageChange' and fiscal_month__C=:currentMonth  and fiscal_year__C=:currYear
  and Opportunity__c  in :oppId];
  for(Opportunity_Team_Member_History__c recNew : recList){
    string key=recNew.Opportunity__r.Id+'-'+recNew.key__C;
    newMap.put(key,recNew.Id);
  }
  
  
  // get the records that need to have a PLS Key
  for(Opportunity_Team_Member_History__c rec :Trigger.new){
     if( rec.Summary_Stage__c !=null && rec.Type__c=='WatsonStageChange' ){
         string key=rec.Opportunity__c+'-'+rec.user__C+'-'+rec.Summary_Stage__c+'-'+currentMonth  ; 
         if(!  ( newMap.containsKey(key)))
         rec.key__C=rec.user__C+'-'+rec.Summary_Stage__c+'-'+currentMonth;
         } 
  }

  
  
}