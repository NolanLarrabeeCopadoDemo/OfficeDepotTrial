Public Class DOA_Approval_Rejcted_Handler
{
    Public Static void isBeforeUpdate(List<CameleonCPQ__QxQuote__c > NewProsQuotes,Map<Id,CameleonCPQ__QxQuote__c > OldProsQuotes)
    {
        Set<Id> PQids=New Set<Id>();
        for(CameleonCPQ__QxQuote__c  Q:NewProsQuotes)
        {
            if(  (Q.DOA_Approval_Status__c=='Rejected'&&OldProsQuotes.get(Q.id).DOA_Approval_Status__c!='Rejected')||
            (Q.DOA_Approval_Status__c=='Approved'&&OldProsQuotes.get(Q.id).DOA_Approval_Status__c!='Approved')
            )
                 if (Q.Approval_Rejection_Comments__c!='Auto Approved')
                 PQids.add(Q.id);
        }
        
         if (!PQids.isEmpty())  
         {
           Set<Id> processInstanceIds = new Set<Id>{};
            for (CameleonCPQ__QxQuote__c  CPI: [SELECT (SELECT ID
                                              FROM ProcessInstances
                                              ORDER BY CreatedDate DESC
                                              LIMIT 1)
                                      FROM CameleonCPQ__QxQuote__c  
                                      WHERE ID IN :PQids])
                {
                    if(!CPI.ProcessInstances.isempty())
                    processInstanceIds.add(CPI.ProcessInstances[0].Id);
                }
         
         if(!processInstanceIds.isempty())
         {
         Map<Id,String> mComents=New Map<Id,String>();
            for (ProcessInstance pi : [SELECT TargetObjectId,
                                           (SELECT Id, StepStatus, Comments 
                                            FROM Steps
                                            ORDER BY CreatedDate DESC
                                            LIMIT 1 )
                                       FROM ProcessInstance
                                       WHERE Id IN :processInstanceIds
                                       ORDER BY CreatedDate DESC])
                    {
                         if(!pi.Steps.isempty())
                         mComents.put(pi.TargetObjectId,pi.Steps[0].Comments);
                         
                    }
            
                  for(CameleonCPQ__QxQuote__c  Q: NewProsQuotes)
                  {
                         if(mComents.containskey(Q.id))
                         {
                              Q.Approval_Rejection_Comments__c=mComents.get(Q.id);
                              Q.Approved_By_Rejected_By__c=Q.LastModifiedById;
                         }
                  }
             }
          }        
    }
}