/***
Description: This Batch is to relink Contacts with GPO.
Created By: prasad Devar    
Created Date: 24-Apr-15
*/
Global class GPO_Contact_Linking_Batch implements database.Batchable<Sobject>,Schedulable,Database.AllowsCallouts
{
    public String strQuery;
    public String accountid;
  
    private String DEFAULT_QUERY  = 'SELECT Id, Account__c, Activated__c,LastModifiedDate from GPO_Group__c';
    /* Default Constructor*/
    global GPO_Contact_Linking_Batch ()
    {
        this.strQuery = DEFAULT_QUERY;
    }
    /*This costructor is called from the Batch Schedule method*/
    global GPO_Contact_Linking_Batch (String query)
    {
        //System.debug('QUERY IS---->'+query);
        if(query != null && query != '')
            this.strQuery = query;
        else
            this.strQuery = DEFAULT_QUERY;
            
            
            System.debug('&&&&&&&&&&&&&&&&&&&&&&strQuery '+strQuery );
    }
    /* This method prepares the scope of the batch program based on the query result */
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
      System.debug('&&&&&&&&&&&&&&&&&&&&&&Inside strQuery '+strQuery );
    
        return Database.getQueryLocator(strQuery);
    }
    /* This method processes query result in batches */
    global void execute(Database.BatchableContext BC, SObject[] scope)
    {
        List<GPO_Group__c> listGpoAccts = scope; 
        
        
        Set<Id> listAcctids = new Set<Id>();
        Set<Id> listActiveAcctids = new Set<Id>();
        List<Id> listInactiveAcctids = new List<Id>();
        List<Id> listLevel2Acctids = new List<Id>();
        List<Id> listLevel3Acctids = new List<Id>();
        List<Id> listLevel4Acctids = new List<Id>();
        Map<Id, List<Id>> mapHirList = new Map<Id, List<Id>>();
        Map<Id, List<Contact>> mapConctList = new Map<Id, List<Contact>>();
        
         for(GPO_Group__c accalias:[SELECT Id, Account__c, Activated__c,LastModifiedDate from GPO_Group__c] ) 
        {
        System.debug('GPO adding acct' +accalias.Account__c);
        listAcctids.add(accalias.Account__c);
        
        if(accalias.Activated__c)
            {
                listActiveAcctids.add(accalias.Account__c);
                System.debug(accalias.Account__c +' : Active id');
            }
        else{
                listInactiveAcctids.add(accalias.Account__c);
                 System.debug(accalias.Account__c +' : in Active id');
            }
        }
       // 1st level down
       for(Account act :[select id ,parentId from account where parentId = :listAcctids]  ) 
        {
           List<Id> accts = new list<Id>();
           if(mapHirList.get(act.parentId)!=null)
             accts=mapHirList.get(act.parentId);
           accts.add(act.id);
            mapHirList.put(act.parentId,accts);
            listLevel2Acctids.add(act.id);
            listAcctids.add(act.id);
            
        }
        // 2nd level down
         for(Account act :[select id ,parentId from account where parentId = :listLevel2Acctids]  ) 
        {
              List<Id> accts = new list<Id>();
               if(mapHirList.get(act.parentId)!=null)
           accts=mapHirList.get(act.parentId);
           accts.add(act.id);
            mapHirList.put(act.parentId,accts);
            listLevel3Acctids.add(act.id);
             listAcctids.add(act.id);
            
        }
        // 3rd level down
         for(Account act :[select id ,parentId from account where parentId = :listLevel3Acctids]  ) 
        {
              List<Id> accts = new list<Id>();
               if(mapHirList.get(act.parentId)!=null)
                   accts=mapHirList.get(act.parentId);
           accts.add(act.id);
            mapHirList.put(act.parentId,accts);
            listLevel4Acctids.add(act.id);
             listAcctids.add(act.id);
        }
        
        
         for(contact conct :[SELECT Id,AccountId, GPO_Community__c from contact  where AccountId = :listAcctids]  ) 
        {
              List<Contact> concts = new list<Contact>();
               if(mapConctList.get(conct.AccountId) != null)
                   concts=mapConctList.get(conct.AccountId);
           concts.add(conct);
            mapConctList.put(conct.AccountId,concts);
     
            
        }
        
        List<Contact> updtcnctList = new List<Contact>();
        // process GPOS
        for (id x:listActiveAcctids)
                                System.debug(' comp '+ x);
         for(GPO_Group__c accalias:listGpoAccts ) 
         {
           System.debug('GPO processing acct' +accalias.Account__c);
            if( mapConctList.get(accalias.Account__c)!=null)
           for(Contact cx: mapConctList.get(accalias.Account__c))
               {
                     System.debug('GPO main contacts' +accalias.Account__c);
                        cx.GPO_Community__c =accalias.Account__c;
                        updtcnctList.add(cx);
               }
               
           if (mapHirList.get(accalias.Account__c)!=null)   
              {   
               System.debug('GPO inside Hirarchy' +accalias.Account__c);   
                  for(Id act:mapHirList.get(accalias.Account__c))
                     {
                         System.debug('GPO inside Hirarchy parent :' +accalias.Account__c +'Child ' +act );
                         
                        if(!listActiveAcctids.contains(act))
                          {
                             System.debug('GPO processing Hirarchy parent :' +accalias.Account__c +'Child ' +act );  
                            if( mapConctList.get(act)!=null)
                            for(Contact c: mapConctList.get(act))
                            { 
                                System.debug('GPO processing Conatct Hirarchy parent :' +accalias.Account__c +'Child ' +act +'Contact'+ c.id ); 
                                c.GPO_Community__c =accalias.Account__c;
                                updtcnctList.add(c);
                             }
                             
                             //level2
                               if (mapHirList.get(act)!=null)
                              for(Id act2:mapHirList.get(act))
                                 {
                                  System.debug('GPO inside Hirarchy Level2 parent :' +accalias.Account__c +'Child ' +act2 );
                             
                                      if(!listActiveAcctids.contains(act2))
                                      {
                                         System.debug('GPO processing Hirarchy Level2 parent :' +accalias.Account__c +'Child ' +act2 ); 
                                          if( mapConctList.get(act2)!=null)
                                          for(Contact c1: mapConctList.get(act2))
                                            {
                                                System.debug('GPO processing Conatct Hirarchy Level2 parent :' +accalias.Account__c +'Child ' +act2 +'Contact'+ c1.id ); 
                                                c1.GPO_Community__c =accalias.Account__c;
                                                updtcnctList.add(c1);
                                             }
                                               // level 4
                                               if (mapHirList.get(act2)!=null)
                                              for(Id act3:mapHirList.get(act2))
                                                 {
                                                      System.debug('GPO inside Hirarchy Level3 parent :' +accalias.Account__c +'Child ' +act3 );
                                                      if(!listActiveAcctids.contains(act3))
                                                      {
                                                           System.debug('GPO processing Hirarchy Level3 parent :' +accalias.Account__c +'Child ' +act3 ); 
                                                             if( mapConctList.get(act3)!=null)
                                                          for(Contact c2: mapConctList.get(act3))
                                                            {
                                                                System.debug('GPO processing Conatct Hirarchy Level3 parent :' +accalias.Account__c +'Child ' +act3 +'Contact'+ c2.id ); 
                                                                   c2.GPO_Community__c =accalias.Account__c;
                                                                updtcnctList.add(c2);
                                                             }
                                                       }
                                                    }
                                       }
                                    }
                            
                         }
                          
                     }
                }
        
        
         }
         List<Contact> updt =  new List<Contact>() ;
        System.debug(' for Contact ');
        Set<contact> supt = new Set<Contact>() ;
        supt.addAll(updtcnctList);
           updt.addAll(supt);

        for(contact c:[select id,GPO_Community__c from contact where GPO_Community__c <> null])
        {   
          System.debug(' for Contact '+c.id);
          Boolean flag = true;
            for( contact uc:updt )
            {
             System.debug(' Against for Contact '+uc.id);
             
             if (uc.id==c.id)
             {
                flag =false;
             }
            }
          
              if(flag)
              {
                c.GPO_Community__c = null;
                updt.add(c);
              }
        }
        
        update updt ;
  }
    
    /* This method is to execute to relase some resources if any*/
    global void finish(Database.BatchableContext BC)
    {
    
                        

    }
    /**
        This method must be there to implement Schedulable interface
    **/
    global void execute(SchedulableContext sc)
    {
        //String strQuery1 = 'SELECT Id, AccountId, GPO_Community__c from contact where GPO_Community__c <> null ';
        
        String strQuery = 'SELECT Id, Account__c, Activated__c,LastModifiedDate from GPO_Group__c';
       
        GPO_Contact_Linking_Batch linkBatch = new GPO_Contact_Linking_Batch (strQuery);
  
        database.executebatch(linkBatch , 2000);
        
    } 
  
}