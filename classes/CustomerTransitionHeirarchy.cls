global class CustomerTransitionHeirarchy implements database.Batchable<Sobject>,Schedulable
{
    public String strQuery;
    public CustomerTransitionHeirarchy(String query)
    {
        String DEFAULT_QUERY = 'SELECT id,Account__r.parentID, Account__c,Parent_Transition_ID__c FROM Customer_Transition__c';
        
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;

    }
     
    public CustomerTransitionHeirarchy()
    {
    } 
     
    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        String strQuery = '';
        CustomerTransitionHeirarchy ct = new CustomerTransitionHeirarchy (strQuery);
        database.executebatch(ct, 100);
        
    } 
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
      //  String sID = 'a2YM0000000KLjJMAW';
      //  String StrQuery = 'SELECT id,Account__r.parentID, Account__c,Parent_Transition_ID__c FROM Customer_Transition__c';
        System.debug('QUERY IS ====='+ strQuery);
        return Database.getQueryLocator(strQuery);
    }
    
    
    
    /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        List<Customer_Transition__c> lCustTrans = new List<Customer_Transition__c>();
        List<Customer_Transition__c> lCustTransUpd = new List<Customer_Transition__c>();
        lCustTrans = scope;
        
        Set<ID> sAccountIDs = new Set<ID>();
        if(lCustTrans != null)
        {
            for(Customer_Transition__c a : lCustTrans )
                sAccountIDs.add(a.Account__r.parentID);    
            
            if(sAccountIDs != null)
            {
                Map<ID,Customer_Transition__c> m_cust = new Map<ID,Customer_Transition__c>();
                for(Customer_Transition__c ct :[Select id,Account__c,Account__r.parentID, name,Parent_Transition_ID__c from Customer_Transition__c where Account__c =:sAccountIDs])
                    m_cust.put(ct.Account__c, ct);
                
                for(Customer_Transition__c a : lCustTrans )
                {
                    a.Parent_Transition_ID__c = null;
                    if(a.Account__r.parentID != null)
                    {
                        if(m_cust.get(a.Account__r.parentID) != null)
                            a.Parent_Transition_ID__c = m_cust.get(a.Account__r.parentID).id;
                    }   
                    lCustTransUpd.add(a);  
                }
            }
        }
        
        if(lCustTransUpd != null)
            update lCustTransUpd;
            
        
    }
    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
        // do nothing
    }
    
  
   

}