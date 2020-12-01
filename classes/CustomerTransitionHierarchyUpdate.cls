// This will update a flag in customer trasition wich will call teh trigger to update Parent
public class CustomerTransitionHierarchyUpdate{
    public static void updateHierarchy(Set<Id> accId){
     List<Customer_Transition__c> custTran= [ Select Id from Customer_Transition__c where Account__c in :accId ];
       for(  integer i=0;i<custTran.size();i++){
           custTran[i].updateHierachy__c=true;
       }
       if(custTran.size()>0)
       update custTran;
             
    }  
    //update Trigger SalesRep Change   Support 00484614
     public static void updateTRiggerSalesRep(Set<Id> accId){
     List<Customer_Transition__c> custTran= [ Select Id from Customer_Transition__c where
      Account__c in :accId  and Trigger_SalesRep_Change__c=true];
       for(  integer i=0;i<custTran.size();i++){
           custTran[i].Trigger_SalesRep_Change__c=false;
       }
       if(custTran.size()>0)
       update custTran;
             
    }  
 }