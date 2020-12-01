public class TOOPProcess{
    private List<OfficeMax_OfficeDepot_CrossReference__c > toopList;
    Set<String>omxlist= new Set<String>();
    List<Customer_transition__C> cust= new List<Customer_transition__C>();
    List<Customer_transition__C> custUpdate= new List<Customer_transition__C>();

    
    public void updateTOOP(List<OfficeMax_OfficeDepot_CrossReference__c > toopList) {
            for(OfficeMax_OfficeDepot_CrossReference__c  rec:toopList){
               if(rec.Source__c=='O'){
               if(!omxlist.contains(rec.OMX_Key__c))
               omxlist.add(rec.OMX_Key__c);
               }
            }
             if(  omxlist.size()>0){
             cust=[Select Id,status__C from Customer_transition__C where omx_primary_key__C in:omxlist and Ready_for_Mod1__c=false and Customer_Transition_Complete__c=false];
                 for(Customer_transition__C  custRec: cust){
                 Customer_transition__C custNew= new Customer_transition__C (Id=custRec.Id);
                    
                    //Start Changes for Case No 00585281 
                    
                    custNew.status__C='TOOP'; // Uncheck the line case 00834176
                    
                    custNew.Override_TOOP__c = true;
                     //End Changes for Case No 00585281
                    custUpdate.add(custNew);
                 }
                 if(custUpdate.size()>0)
                 update custUpdate;
             }     
    }
    }