/***
Description: Ony one quote can be in Accpted status under an Opportunity. When a quote is set to status as 'Accepted by Customer', then a check needs to be made to to see if any other quote under Opportunity already has status as 'Accepted by Customer'.
If it does, then an error message needs to be thrown.

Created By: Sunil Bansal
Created on : 19-Jun-2012


****/
trigger OnQuote_IU on Quote (before insert, before update) 
{
    Set<id> opptyIds = new Set<id>();
    for(Quote q: Trigger.New)
    {
        if(q.Status == 'Accepted by Customer' && q.OpportunityId != null)
            opptyIds.add(q.OpportunityId);
    }
    
    Map<Id, Quote> OpptyIdQuoteMap = new Map<Id, Quote>();
    for(Quote qot: [Select id, OpportunityId, Status from quote where OpportunityId in :opptyIds and Status = 'Accepted by Customer'])
    {
        OpptyIdQuoteMap.put(qot.OpportunityId, qot);
    }
    
    for(Quote q: Trigger.New)
    {
        if(q.Status == 'Accepted by Customer' && OpptyIdQuoteMap.containsKey(q.OpportunityId))
        {
            if(Trigger.isInsert)
                 q.addError('Another Quote under the parent Opportunity already has status as \'Accepted by Customer\', only one Quote can have status as \'Accepted by Customer\' under parent Opportunity');
            else if(Trigger.isUpdate && q.Id != OpptyIdQuoteMap.get(q.OpportunityId).Id)
                q.addError('Another Quote under the parent Opportunity already has status as \'Accepted by Customer\', only one Quote can have status as \'Accepted by Customer\' under parent Opportunity');
        }
    }
}