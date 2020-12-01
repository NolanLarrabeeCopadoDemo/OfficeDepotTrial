public class Mod5BillToKeyClass {

public void Mod5BillToKeyClassMethod(Set<ID> custTransId, List<Customer_Transition__c> trgCTList )
    {

     Map<Id,String> maphiersplit= new Map<Id,String>();
     Id Site = Schema.SObjectType.Customer_Transition_Dtls__c.getRecordTypeInfosByName().get('Sites').getRecordTypeId();
     List<Customer_Transition_Dtls__c> CTDtls= new  List<Customer_Transition_Dtls__c> ();
    set<String> omx = new set<String>();

       
   // get the transition detail records where Billing code is B  
   if(custTransId.size()>0){
   
   for(Split_Account_Detail__c split: [select Id,Master_Account__c from Split_Account_Detail__c where Customer_Transition__c in:custTransId  and
     (NEW_BILL_TO_OMX_CONSIGNEE__c='' or NEW_BILL_TO_OMX_CONSIGNEE__c=null)]){
       if(!omx.contains(split.Master_Account__c ))
       omx.add(split.Master_Account__c);
     }
     
   
   
              CTDtls = [Select id, Customer_Transition_ID__c,Customer_Transition_ID__r.Id,omx_primary_key__C,
              Account_ID__r.Primary_BillTo__C 
              from Customer_Transition_Dtls__c 
              where Customer_Transition_ID__c IN :custTransId  and
              
               ( Ship_2_Bill_2_Code__c ='B' or  Ship_2_Bill_2_Code__c ='SB' ) and
               AOPS_Flag__c ='Y' and 
                recordtypeId=:Site  order by Account_ID__r.Primary_BillTo__C   desc];
                         
               for(Customer_Transition_Dtls__c CTD:CTDtls )
               {                     
                            if(!maphiersplit.containsKey(CTD.Customer_Transition_ID__r.Id))
                            maphiersplit.put(CTD.Customer_Transition_ID__r.Id,CTD.omx_primary_key__C);
                         
                 
               }
       
       }
     
              for (Customer_Transition__c CT : trgCTList)
              {                 
                            if ((!maphiersplit.isEmpty()) && (maphiersplit.size()>0) && (maphiersplit.containsKey(CT.Id))){
                             if(!omx.contains(CT.omx_primary_key__C ))
                             CT.Bill_To_Key__c  = maphiersplit.get(CT.Id);
                            
                            }
                             
             }
    }
}