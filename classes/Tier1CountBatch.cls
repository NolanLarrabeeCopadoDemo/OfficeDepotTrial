// Case 00949712 
// 03/15/17
// Counts the amount of Child transition records flagged as 'Tier 1' and updates their parents, grandparents, greatgrandparents with the number

global class Tier1CountBatch implements Database.Batchable<sObject>,Schedulable {
    private string DEFAULT_QUERY = 'SELECT id, Customer_Transition_Type2__c, Tier_1__c FROM Customer_Transition__c';
  //  private string ParentRecordsQuery = 'SELECT id, Customer_Transition_Type2__c FROM Customer_Transition__c WHERE Customer_Transition_Type2__c = \'Parent\' OR Customer_Transition_Type2__c = \'Grandparent\' OR Customer_Transition_Type2__c = \'Great Grandparent\'';
  //  public String CHILD_QUERY = 'SELECT Count(id) AS cnt,  Parent_Transition_ID__c  as ParentTrnsID FROM Customer_Transition__c WHERE Tier_1__c = TRUE AND Customer_Transition_Type2__c = \'Child\' group by Parent_Transition_ID__c';  
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(DEFAULT_QUERY);
        //return Database.getQueryLocator(ParentRecordsQuery);
    }
    
    global void execute(SchedulableContext sc)
    {
     //Batch size set for each iteration
     integer batch_size = 200;
     Tier1CountBatch tbatch = new Tier1CountBatch();     
     database.executebatch(tbatch,batch_size); 
     
    }
    
    global void execute(Database.BatchableContext bc, sObject[] scope) {
        List<Customer_Transition__c> scope2 = scope;
        Map<ID,Decimal> hierCounts = new map<ID,Decimal>();
        
        
        //GGP
        for (AggregateResult a : [SELECT count(id) total, Parent_Transition_ID__r.Parent_Transition_ID__r.Parent_Transition_ID__c ggp from Customer_Transition__c 
            WHERE Parent_Transition_ID__r.Parent_Transition_ID__r.Parent_Transition_ID__c =: scope AND Tier_1__c = true group by Parent_Transition_ID__r.Parent_Transition_ID__r.Parent_Transition_ID__c]) {
                    hierCounts.put((ID)a.get('ggp'), (Decimal)a.get('total'));
                }
        //GP
        for (AggregateResult a : [SELECT count(id) total, Parent_Transition_ID__r.Parent_Transition_ID__c gp from Customer_Transition__c
                WHERE Parent_Transition_ID__r.Parent_Transition_ID__c =: scope AND Tier_1__c = true GROUP BY Parent_Transition_ID__r.Parent_Transition_ID__c]) {
            hierCounts.put((ID)a.get('gp'), (Decimal)a.get('total'));
        }
        //P
        for (AggregateResult a : [SELECT count(id) total, Parent_Transition_ID__c p from Customer_Transition__c
                WHERE Parent_Transition_ID__c =: scope AND Tier_1__c = true GROUP BY Parent_Transition_ID__c]) {
            hierCounts.put((ID)a.get('p'), (Decimal)a.get('total'));
        }
        
        for (Customer_Transition__c c : scope2){
            if (hierCounts.containsKey(c.id)) {
                c.No_of_Tier_1_Child_Accts__c = hierCounts.get(c.id);
            } else {
                c.No_of_Tier_1_Child_Accts__c = 0;
            }
        }
        
        Database.UPDATE(scope2,false);
    }
    
    global void finish(Database.BatchableContext bc)
    {
        // not required
    }
}