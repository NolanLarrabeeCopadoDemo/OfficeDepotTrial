trigger goal_after_update_insert on GOAL__c (after insert,after update) {

list<String> empIDs = new list<String>();
Map<String,coaching__c> coachMap = new Map<String,coaching__c>();
list<Coaching__c> coachUpd = new list<Coaching__c>();

For (Goal__c g:Trigger.new) {
  empIDs.add(g.Employee_ID__c);
}

for (Coaching__c c: [select id,OD_Employee_ID__r.OD_Employee_ID__c,Sales_Rep__r.OD_Employee_ID__c,Yearly_Goal__c,Goal_YTD__c,Sales_YTD__c from coaching__c 
                     where Sales_Rep__r.OD_Employee_ID__c = :empIDs]) {
     coachMap.put(c.Sales_Rep__r.OD_Employee_ID__c,c);                
}

 if (coachMap.size() > 0) {
  for (Goal__c g: Trigger.new) {
   if (g.employee_id__c != null) {
     if (coachMap.containsKey(g.employee_id__c)) {
        coaching__c c = coachMap.get(g.employee_id__c);
        c.Yearly_Goal__c = g.Annual_Sales_Goal__c;
        c.Goal_YTD__c = g.Sales_Goal__c;
        c.Sales_YTD__c = g.Sales_Actual__c;
        coachUpd.add(c);
     }
   }
  }
 }
 
 Database.update(coachUpd,false);
 
  
}