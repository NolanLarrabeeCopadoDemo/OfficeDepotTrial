// Class to Cascade status

public class CT_CascadeStatus {
    public Map<Id,String> mapCTidrec;
           public void CT_CascadeStatusmethod (Map<Id,String> mapCTidrec) {
           List <Customer_Transition__c> custupdate= new List <Customer_Transition__c> ();
              List <Customer_Transition__c> cust=[select Id ,status__C, Customer_Disposition__c ,Written_Agreement_ID__c 
              from Customer_Transition__c  where Written_Agreement_ID__c in: mapCTidrec.keySet()  and Ready_for_Mod1__c=false
              and Customer_Loss__c=false];
             
                   for(  Customer_Transition__c custRec :cust){
                      Customer_Transition__c  custNew= new Customer_Transition__c (Id=custRec .Id);
                        custNew.Customer_Disposition__c =mapCTidrec.get(custRec.Written_Agreement_ID__c );
                        if(custNew.Customer_Disposition__c=='Customer going to RFP')
                        custNew.status__C='Awaiting RFP';
                        custNew.Related_WRF_Case__c=null;
                        custupdate.add(custNew);
                   }
                   if(custupdate.size()>0)
                   update custupdate;
                     
          }
          
          public void CT_CascadeOMXExtensionComplete(List <Id> custId) {
              List <Customer_Transition__c> custupdate= new List <Customer_Transition__c> ();                     
              List <Customer_Transition__c> cust=[select Id ,status__C, Customer_Disposition__c ,Written_Agreement_ID__c 
              from Customer_Transition__c  where Written_Agreement_ID__c in: custId  and Ready_for_Mod1__c=false
              and Customer_Loss__c=false];
             
                   for(  Customer_Transition__c custRec :cust){
                      Customer_Transition__c  custNew= new Customer_Transition__c (Id=custRec.Id);
                        custNew.status__C='ReScheduled';
                        custNew.Related_WRF_Case__c=null;
                        custNew.Contract_Extension_Complete__c=true;
                        custNew.Customer_Disposition__c=null;
                        custNew.Customer_Review_Completion_Date__c=System.Today();
                        custupdate.add(custNew);
                   }
                   if(custupdate.size()>0)
                   update custupdate;
                     
          }
    
    }