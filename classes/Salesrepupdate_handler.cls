public class Salesrepupdate_handler 
{
   
   Public Static Void AccOwner(List<CameleonCPQ__QxQuote__c> CPQList)
    {
        system.debug('Sales rep update class is called');
        Set<String> AcNames = New Set<String>();
        Set<Id> OppIds= New Set<Id>();

        FOR(CameleonCPQ__QxQuote__c A : CPQList)
        {
            IF(A.CameleonCPQ__AccountId__c!= null)
                AcNames.Add(A.CameleonCPQ__AccountId__c);
            else if(A.OpportunityId__c!=null)
                OppIds.add(A.OpportunityId__c);

        }
                
        if(!OppIds.isEmpty())
            
        {
           
            Map<Id,opportunity>  mAccoownerId1 =New Map<Id,opportunity>([Select Id,account.ownerId from opportunity where Id=: OppIds]);

            FOR(CameleonCPQ__QxQuote__c A : CPQList)
            {
                IF(A.CameleonCPQ__AccountId__c== null)
                    A.Sales_Rep__c=mAccoownerId1.get(A.OpportunityId__c).account.ownerId;
                 system.debug('opportunity list is not empty'+mAccoownerId1.get(A.OpportunityId__c).account.ownerId);
           
              }
        }
        
        if(!AcNames.isEmpty())
        {
            Map<Id,Account>  mAccoownerId =New Map<Id,Account>([Select Id,ownerId from Account where Id=: AcNames]);

            FOR(CameleonCPQ__QxQuote__c A : CPQList)
            {
                IF(A.CameleonCPQ__AccountId__c!= null)
                    A.Sales_Rep__c=mAccoownerId.get(A.CameleonCPQ__AccountId__c).ownerId;
                                 system.debug('Account list is not empty'+mAccoownerId.get(A.CameleonCPQ__AccountId__c).ownerId);

           
              }
       }

       
    }
    
    //Method to Create Task for Rep when Customer request to be Contacted
    Public Static Void Taskfrrep(List<CameleonCPQ__QxQuote__c> CPQList,Map<Id,CameleonCPQ__QxQuote__c> OldRecs)
{
    List <Task> TaskList = new List<Task>();
    //set<Id> ProsIds=new set<Id>();
       for (CameleonCPQ__QxQuote__c Pro: CPQList)
     {
         
         // checking if status changed
      if(Pro.Customer_Approval_Status__c!=OldRecs.get(Pro.id).Customer_Approval_Status__c && Pro.Customer_Approval_Status__c=='Requested to be Contacted')          
         {   
             //Added by Ramakant sul as existing code was giving error when Sales Rep is Not Populated
             //Code Starts here
             if(Pro.Sales_Rep__c != null){
                Task tsk = new Task(subject='Customer Requested to be Contacted',OwnerId= Pro.Sales_Rep__c,WhatId=Pro.id,ActivityDate=system.today().adddays(7));                 
                TaskList.add(tsk);
             }else {
                Task tskWithQuoteOwnerAsOwner = new Task(subject='Customer Requested to be Contacted',OwnerId= Pro.OwnerId,WhatId=Pro.id,ActivityDate=system.today().adddays(7));                 
                TaskList.add(tskWithQuoteOwnerAsOwner);    
             }
             //Code ends here 
          }
     }
     insert TaskList;
}
    public static void createSCOEParent(List<CameleonCPQ__QxQuote__c>  lstOfNewTrigger) {
        List<Case> lstOfCases = new List<Case>();
        Id ScoeRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCOE Cases').getRecordTypeId();
        for(CameleonCPQ__QxQuote__c pro:lstOfNewTrigger) {
           lstOfCases.add(new Case(AccountId = pro.CameleonCPQ__AccountId__c, Pros_Quote_Link__c = System.Label.Quote_URL + pro.Id + '/view' ,Pros_Quote_ID__c = pro.Quote_Number__c ,WRF_Requestor__c=pro.OwnerId,New_Request__c = 'Change of Parent on Quote-' + pro.Quote_Number__c + '-' + pro.Name, Subject='Change of Parent on Quote-' + pro.Quote_Number__c + '-' + pro.Name,Description='Parent',Ownerid='00GE0000000uSg0',SCOE_Issue_Type__c = 'BSD Pricing', Recordtypeid = ScoeRT  , WRF_Request_Type__c='Child to Parent move'));
         
        }
               system.debug('the case is inserted'+lstOfCases);

        insert lstOfCases; 
    }
    public static void createSCOEGrandParent(List<CameleonCPQ__QxQuote__c>  lstOfNewTrigger) {
        List<Case> lstOfCases = new List<Case>();
        Id ScoeRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCOE Cases').getRecordTypeId();
           for(CameleonCPQ__QxQuote__c pro:lstOfNewTrigger) {
        lstOfCases.add(new Case(AccountId = pro.CameleonCPQ__AccountId__c,  Pros_Quote_Link__c = System.Label.Quote_URL + pro.Id + '/view' ,Pros_Quote_ID__c = pro.Quote_Number__c, WRF_Requestor__c=pro.OwnerId,New_Request__c = pro.CameleonCPQ__AccountId__r.Name+','+pro.CameleonCPQ__AccountId__r.AOPS_Cust_Id__c+','+pro.Grandparent__r.Name+','+pro.Grandparent__r.AOPS_Cust_Id__c,Subject='Change of Grand Parent on-'+ pro.Quote_Number__c + '-' + pro.Name,Description='Grand Parent',Ownerid='00GE0000000uSg0',SCOE_Issue_Type__c = 'BSD Pricing', Recordtypeid= ScoeRT  , WRF_Request_Type__c='Parent to Grandparent move'));
           }
        system.debug('the case is inserted'+lstOfCases);

        insert lstOfCases; 
    }
    public static void createSCOEGreatGrandParent(List<CameleonCPQ__QxQuote__c>  lstOfNewTrigger) {
        List<Case> lstOfCases = new List<Case>();
        Id ScoeRT = Schema.SObjectType.Case.getRecordTypeInfosByName().get('SCOE Cases').getRecordTypeId();
         for(CameleonCPQ__QxQuote__c pro:lstOfNewTrigger) {
        lstOfCases.add(new Case(AccountId = pro.CameleonCPQ__AccountId__c,  Pros_Quote_Link__c = System.Label.Quote_URL + pro.Id + '/view' ,Pros_Quote_ID__c = pro.Quote_Number__c, WRF_Requestor__c=pro.OwnerId,New_Request__c = pro.CameleonCPQ__AccountId__r.Name+','+pro.CameleonCPQ__AccountId__r.AOPS_Cust_Id__c+','+pro.Great_Grandparent__r.Name+','+pro.Great_Grandparent__r.AOPS_Cust_Id__c,Subject='Change of Great Grand Parent on Quote-' + pro.Quote_Number__c + '-' + pro.Name,Description='Great Grand Parent',Ownerid='00GE0000000uSg0',SCOE_Issue_Type__c = 'BSD Pricing', Recordtypeid= ScoeRT  , WRF_Request_Type__c='Grandparent to Great Grandparent Move'));
         }system.debug('the case is inserted'+lstOfCases);

        insert lstOfCases; 
    }
    public static void approvalProcessPros() {
        ProcessInstanceWorkitem p = [select ActorId from ProcessInstanceWorkitem ] ;
        system.debug('the process is'+p);
    }
}