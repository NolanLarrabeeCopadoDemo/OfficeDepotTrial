// Class to write the flow of Disposition
public class CT_TriggerFlow{  
    
    List<Id> ParentId = new   List<Id>();
    List<Customer_transition__C> writtenList = new  List<Customer_transition__C>();
    date mydate = date.parse('07/01/2016');
    Map<Id,Customer_Transition__c> mapList= new  Map<Id,Customer_Transition__c>();
    public void CT_TriggerFlow(List<Customer_Transition__c> currentRecords) {
    //get Parent Ids
       for( Customer_Transition__c cust: currentRecords){       
       if(cust.omx_primary_key__C!= null){
        if( !(cust.omx_primary_key__C.contains('-'))){
            system.debug('&&&'+cust.Name+'%%%'+cust.Parent_Transition_ID__r.name); 
            if( cust.Parent_Transition_ID__c!=null)
             ParentId.add(cust.Parent_Transition_ID__c);  
             else{
                 if (cust.Review_Start_Date__c== null){
                 cust.Review_Start_Date__c=mydate;
                 cust.status__c='Scheduled';
                 }
             }
          }
         }    
       }
       if(ParentId.size()>0){
       System.debug('&&&&&&&&ParentId'+ParentId);
       writtenList=[Select account__c,Id,Review_Start_Date__c from Customer_Transition__c where Id in :ParentId and 
      Written_Agreement_ID__c=null];
         if(writtenList.size()>0){
            for(  Customer_Transition__c custRec: writtenList)
            mapList.put(custRec.Id,custRec);
         
         }
         // Update the written agreement Level
            for( Customer_Transition__c cust: currentRecords){
                    if( cust.Parent_Transition_ID__c!=null  &&  !(cust.omx_primary_key__C.contains('-'))){
                    
                           System.debug('&&&&&&&&cust.Parent_Transition_ID__c'+cust.Parent_Transition_ID__c);
        
                         if( mapList.get(cust.Parent_Transition_ID__c) !=null){
                                Customer_transition__C custRec =new Customer_transition__C();
                                custRec= mapList.get(cust.Parent_Transition_ID__c);
                                if (cust.Written_Agreement_ID__c== null){
                                cust.Written_Agreement_ID__c=custRec.Id;
                                cust.Written_Agreement__c=true;
                                }
                                cust.Review_Start_Date__c=custRec.Review_Start_Date__c;
                                cust.status__c='Scheduled';
                                
                         }
                         else{                 
                           cust.Review_Start_Date__c=mydate;
                           cust.status__c='Scheduled';
                         }
                      
        
                    }    
            }
       }
    
    }
 }