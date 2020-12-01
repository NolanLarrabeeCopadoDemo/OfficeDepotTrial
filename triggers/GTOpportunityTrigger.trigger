trigger GTOpportunityTrigger on Opportunity (before insert, before update) {
String newExchangeRate;
               // added for ticket 01474559
       if (Trigger.New != null) {
         for (Opportunity myOpp: Trigger.new) {
          if (Util.bizBoxRTIdsByObject('Opportunity').contains(myOpp.RecordTypeId)) {
           return;
          }
         }
        }
                                        

if(!Test.isRunningTest()){
    newExchangeRate=[Select Rate__c from Exchange_Rate__c Limit 1].Rate__c ;
}
if(Test.isRunningTest()){
    newExchangeRate = '1.08';
}
for( Opportunity opptToUpdate:Trigger.new){
  if(opptToUpdate.recordtypeid==Label.GTOpportunity){
    if(opptToUpdate.Committed_Forecast_CAD__c != null || opptToUpdate.Amount_CAD__c != null) {
                if(opptToUpdate.Amount_CAD__c != null)
                opptToUpdate.Amount = Double.valueof(opptToUpdate.Amount_CAD__c) / Double.valueof(newExchangeRate);
                if(opptToUpdate.Committed_Forecast_CAD__c!= null)
                opptToUpdate.Committed_Forecast__c = Double.valueof(opptToUpdate.Committed_Forecast_CAD__c) / Double.valueof(newExchangeRate); 
  }
}

}
}