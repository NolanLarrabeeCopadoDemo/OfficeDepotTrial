//This class is called from BeforeInsertTransitionLaunch Trigger
public class TransitionLaunchCls
{
    Map<String,Customer_transition__C>MapTranId = new Map<String,Customer_transition__C>();
    Map<String,Id>MapParentId = new Map<String,Id>();
    List<Transition_Launch__c> transList = new List<Transition_Launch__c>();
    Set<String> listId= new Set<String>();

    public List<Transition_Launch__c> tranLaunchMethod(List< Customer_transition__C> cust,List< Transition_Launch__c> allInputCT)
    {
        if(cust != null && cust.size() > 0 && allInputCT != null && allInputCT.size() > 0)
        {
            for(Customer_transition__C custRec: cust)
            {
            MapTranId.put(custRec.OMX_Primary_Key__c ,custRec);
            if(  custRec.Parent_Transition_ID__r.Customer_Transition_Type__c == 'Parent')
            {
                   MapParentId.put(custRec.OMX_Primary_Key__c ,custRec.Parent_Transition_ID__c );
                   if(custRec.Parent_Transition_ID__c!=null && custRec.Parent_Transition_ID__r.Ready_for_Mod1__c==false)
                   {                  
                          if (!listId.contains(custRec.Parent_Transition_ID__r.OMX_Primary_Key__c))
                          {
                              Transition_Launch__c  trans = new Transition_Launch__c ();
                              trans.OMX_Key__c  =custRec.Parent_Transition_ID__r.OMX_Primary_Key__c ;
                              trans.TYpe__c='Parent';
                              trans.Status__c='Submit';
                              transList.add(trans );
                              listId.add(custRec.Parent_Transition_ID__r.OMX_Primary_Key__c);
                           }   
                      
                   }
            }
            }   
            
            for(Transition_Launch__c  rec : allInputCT)
            {   
             if(MapTranId.get(rec.OMX_Key__c).Customer_Transition_Type__c=='Parent')
             rec.TYpe__c='Parent';
             if(MapTranId.get(rec.OMX_Key__c).Customer_Transition_Type__c=='Grandparent' ||MapTranId.get(rec.OMX_Key__c).Customer_Transition_Type__c=='Great Grandparent') 
             rec.adderror('Cannot Launch Grand Parent or Great Grand Parent');
                 
             rec.Customer_Transition__c= MapTranId.get(rec.OMX_Key__c).Id;
             rec.Parent_Customer_Transition__c=MapParentId.get(rec.OMX_Key__c);
            }
            
             if(transList.size()>0)
             return transList;
        }
        return null;
    }

}