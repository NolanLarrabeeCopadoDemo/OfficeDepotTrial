trigger PopulatePLSKey on Opportunity_Tracking_History__c (before insert) {
List<Id> oppId= new List<Id>();
//get current fiscal month

//get current year
    String currYear=String.valueOf(System.Today().Year());
    String currentMonth;
// get the records that need to have a PLS Key
  for(Opportunity_Tracking_History__c  rec :Trigger.new){
     if( rec.Summary_Stage__c !=null && rec.Type__c=='WatsonStageChange' && rec.LaterChange__C==true){
       currentMonth =rec.fiscal_month__C;
       oppId.add(rec.Opportunity__c );
     } 
  }
  //get the records with PLS Key
  Map<String,string > newMap = new Map<String,string > ();
  
  List<Opportunity_Tracking_History__c> recList=[select Opportunity__r.Id,pls_key__C,Opportunity_Owner__r.Id,Summary_Stage__c ,
  Fiscal_Month__c from Opportunity_Tracking_History__c where 
  pls_key__C!=null and type__c='WatsonStageChange' and fiscal_month__C=:currentMonth  and fiscal_year__C=:currYear
  and Opportunity__c  in :oppId];
  for(Opportunity_Tracking_History__c recNew : recList){
    string key=recNew.Opportunity__r.Id+'-'+recNew.pls_key__C;
    newMap.put(key,recNew.Id);
  }
  
  
  // get the records that need to have a PLS Key
  for(Opportunity_Tracking_History__c  rec :Trigger.new){
     if( rec.Summary_Stage__c !=null && rec.Type__c=='WatsonStageChange' && rec.LaterChange__C==true){
         string key=rec.Opportunity__c+'-'+rec.Opportunity_Owner__c+'-'+rec.Summary_Stage__c+'-'+currentMonth  ; 
         if(!  ( newMap.containsKey(key)))
         rec.pls_key__C=rec.Opportunity_Owner__c+'-'+rec.Summary_Stage__c+'-'+currentMonth;
         } 
  }

  
  
}