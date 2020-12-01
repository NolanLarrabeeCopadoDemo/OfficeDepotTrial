global class ACE_QuaterlyProcess_LockPreviousBatch implements database.Batchable<Sobject> 
{
    public String acequery ;  
    //global Map<String,Ace_Customer_Core_Changes__c> map_aceCore;
    global String batchId = '1';
    
    global ACE_QuaterlyProcess_LockPreviousBatch( String testMode ) {
        this.testMode = testMode;
    }
    
    global String testMode;
    
    global ACE_QuaterlyProcess_LockPreviousBatch()
    {
 
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    { 
       // list<ACE_Settings__c> desettings =[SELECT Id, Name, BatchName__c from ACE_Settings__c limit 1];
       // if(desettings[0]!= null)
       //     this.batchId = desettings[0].BatchName__c;

       this.batchId = testmode; 
       this.acequery  = 'SELECT Id,Name, batchId__c,Record_Lock__c ' 
                       +' from ACE_Customer_Price_Changes__c where batchId__c =\''+batchId+'\''  ;
                       
        return Database.getQueryLocator(acequery);
    }
    
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {      
        List<ACE_Customer_Price_Changes__c> lCustPriceChanges = new List<ACE_Customer_Price_Changes__c>();
        lCustPriceChanges  = scope;
        
        for(ACE_Customer_Price_Changes__c ace : lCustPriceChanges)
        {
            ace.Record_Lock__c = true;
        }
            
        if(lCustPriceChanges != null)
            update lCustPriceChanges;    
            
    }
    
    global void finish(Database.BatchableContext BC)
    {
       System.debug('Completed Processing.... ACE Quaterly Batch Id :'+batchId) ;
    }
}