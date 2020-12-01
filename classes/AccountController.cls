public with sharing class AccountController {
    @AuraEnabled
    public static List<Org__C> findAll(Id OrgId) {
        String org = orgId;
        system.debug('orgstring'+org);
        System.debug('&&&&&&OrgId'+OrgId);
        List<Org__C> top_accts= new List<Org__C>();
        Set<id> orgSet = new Set<id> ();
        Set<Id> parent_acc_ids = new Set<Id>();
        //get ParentId's of the current Org Id
        if(org.substring(0,3)=='001'){
            Account ac = [select id,org__C from Account where id=:org];
            Org__C orgRec=[select Id, Parent_Org__C ,Parent_Org__r.Parent_Org__C,Parent_Org__r.Parent_Org__r.Parent_Org__C from Org__C 
                           where Id=:ac.org__C];
            system.debug('orgRec1'+orgRec);
            if(orgRec.Parent_Org__C  !=null)
                top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__C];
            //else
                //top_accts=[ Select Id, Business_name__C from Org__C where Id=:ac.org__C];
            
            System.debug('&&&&&&top_accts'+top_accts);
            if(top_accts.size()>0)
          orgset.add(top_accts[0].id);
             if(orgRec!=null)
              orgset.add(orgRec.id);
            
        
                    system.debug('orgSet...............'+orgSet);
                
            
        }
        else
        {
               system.debug('loop2');
            Org__C orgRec=[select Id, Parent_Org__C ,Parent_Org__r.Parent_Org__C,Parent_Org__r.Parent_Org__r.Parent_Org__C from Org__C 
                           where Id=:org];
            if(orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C  !=null)
                top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__r.Parent_Org__C];
            else if(orgRec.Parent_Org__r.Parent_Org__C!=null)
                top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__r.Parent_Org__C];
            else if(orgRec.Parent_Org__C!=null)
                top_accts=[ Select Id, Business_name__C from Org__C where Id=:orgRec.Parent_Org__C];
            else
                top_accts=[ Select Id, Business_name__C from Org__C where Id=:org];
            
            System.debug('&&&&&&top_accts'+top_accts);
            
            for (Org__C a : top_accts) {
                orgSet.add(a.Id);
                
                parent_acc_ids.add(a.Id);
            }
            
            while (parent_acc_ids.size() > 0) {
                Map<Id,Org__C> subordinate_accounts =
                    new Map<Id,Org__C>([
                        SELECT Id, Parent_Org__c, Business_Name__c
                        FROM Org__c
                        WHERE Parent_Org__c IN :parent_acc_ids
                    ]);
                
                
                parent_acc_ids = subordinate_accounts.keySet();
                
                for (Org__C acc : subordinate_accounts.values()) {
                    if(!orgSet.contains(acc.Id))             
                        orgSet.add(acc.Id);
                    
                    
                }
            }   
        }
        system.debug('orgSet...............'+orgSet);
        return [SELECT id, name,business_name__C, Location__Latitude__s, Location__Longitude__s
                FROM Org__C
                WHERE  Id in :orgSet and 
                Location__Latitude__s != NULL AND Location__Longitude__s != NULL
                LIMIT 50];
    }
    
    
}