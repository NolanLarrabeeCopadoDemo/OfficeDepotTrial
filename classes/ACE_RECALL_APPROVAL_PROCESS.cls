public Class ACE_RECALL_APPROVAL_PROCESS
{
    public static void ACERecallMethod(Set<ID> sIDs)
    {
        List<ProcessInstance> lProcessInstance = [SELECT Id, TargetObject.Name, TargetObjectID, TargetObject.Type, (SELECT Id, ActorID,Actor.email, Actor.Name FROM WorkItems) FROM ProcessInstance WHERE  Status = 'Pending' AND IsDeleted = False and TargetObjectID in:sIDs];
        List<Approval.ProcessWorkItemRequest> pwrList = new List<Approval.ProcessWorkItemRequest>();
        for(ProcessInstance p : lProcessInstance)
        {
           for(ProcessInstanceWorkitem WI : P.WorkItems) 
              {
                Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();  
                pwr.setComments('Auto rejected by system');
                pwr.setWorkItemId(wi.id);
                pwr.setAction('Reject'); 
                pwrList.add(pwr);     
              }     
        }
        
        if(pwrList != null)
            List<Approval.ProcessResult> pr = Approval.process(pwrList);
    }
    
    public static void ACEApprRejMethodBulk(list<ID> recID,String Comment,String Type)
    {
        List<ProcessInstance> lProcessInstance = [SELECT Id, TargetObject.Name, TargetObjectID, TargetObject.Type, (SELECT Id, ActorID,Actor.email, Actor.Name FROM WorkItems) FROM ProcessInstance WHERE  Status = 'Pending' AND IsDeleted = False and TargetObjectID =:recID];
        List<Approval.ProcessWorkItemRequest> pwrList = new List<Approval.ProcessWorkItemRequest>();
        system.debug('Comments:' + comment);
        for(ProcessInstance p : lProcessInstance)
        {
           for(ProcessInstanceWorkitem WI : P.WorkItems) 
              {
                Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();  
                pwr.setComments(Comment);
                pwr.setWorkItemId(wi.id);
                pwr.setAction(Type); 
                pwrList.add(pwr);     
              } 
              
           
        }
        
         if(pwrList != null)
            List<Approval.ProcessResult> pr = Approval.process(pwrList);
    }
    
    public static void ACEApprRejMethod(ID recID,String Comment,String Type)
    {
        List<ProcessInstance> lProcessInstance = [SELECT Id, TargetObject.Name, TargetObjectID, TargetObject.Type, (SELECT Id, ActorID,Actor.email, Actor.Name FROM WorkItems) FROM ProcessInstance WHERE  Status = 'Pending' AND IsDeleted = False and TargetObjectID =:recID];
        List<Approval.ProcessWorkItemRequest> pwrList = new List<Approval.ProcessWorkItemRequest>();
        system.debug('Comments:' + comment);
        for(ProcessInstance p : lProcessInstance)
        {
           for(ProcessInstanceWorkitem WI : P.WorkItems) 
              {
                Approval.ProcessWorkItemRequest pwr = new Approval.ProcessWorkItemRequest();  
                pwr.setComments(Comment);
                pwr.setWorkItemId(wi.id);
                pwr.setAction(Type); 
                pwrList.add(pwr);     
              }     
        }
        
        if(pwrList != null)
            List<Approval.ProcessResult> pr = Approval.process(pwrList);
    }
    
}