trigger CalculateRemainingHours on agf__ADM_Task__c (before insert, before update) {
    for (agf__ADM_Task__c t : Trigger.New) {
        try {
            double remaining = t.agf__Starting_Hours__c - t.agf__Actual_Hours__c;
            
            if (remaining < 0 || t.agf__Status__c == 'Completed') {
                remaining = 0;
            }
            
            t.agf__Hours_Remaining__c = remaining; 
        } catch (Exception e) { }
    }
}