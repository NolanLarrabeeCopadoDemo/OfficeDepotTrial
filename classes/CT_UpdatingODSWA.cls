public class CT_UpdatingODSWA
{
List<Customer_Transition__c > CTList = new List<Customer_Transition__c >();
public void updatingODSWA(set<Id> CTids){
    if(CTids.size()>0){
    system.debug('----'+CTids);
    CTList = [select id,ODS_WA_EXECUTED__c
      from Customer_Transition__c where Written_Agreement_ID__c =: CTids];
    for(Customer_Transition__c c : CTList ){
        c.ODS_WA_EXECUTED__c=true;
    }
    }
    if(CTList.size()>0)
    update CTList ;  
    

}

}