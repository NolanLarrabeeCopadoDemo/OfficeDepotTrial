public class LatticePlaysTriggers { 

    public static void beforeInsert(List<Lattice_Play__c> triggerNew) {            
        // global vars
        integer listCount = triggerNew.size();     
        List<string> accIds = new List<string>();
        Map<Id,Account> accsMap = new Map<Id,Account>();     
        
        // determine inbound list size      
        system.debug('inbound list count = ' + listCount);             
        
        for (Lattice_Play__c p : triggerNew) {
            // pop map
            accIds.add(p.Account_Id__c);
        }
        
        // get related accounts map
        List<Account> accounts = [SELECT Id, Coupon_flag__c, Account_level_email_permission_flag__c, Legal_Flag__c, RecordType.Name, 
                                  Related_Account__c, Related_Account__r.Legal_Flag__c, Related_Account__r.Account_level_email_permission_flag__c,
                                  Related_Account__r.Coupon_flag__c
                                  FROM Account 
                                  WHERE id IN :accIds];
        
        for (Account acc : accounts) {
            if (acc != null) {
                system.debug('| SUCCESS | Account Exists | ');
                accsMap.put(acc.Id, acc);
            }else {
                system.debug('| ERROR | Account Does Not Exist | Id= ' + acc.id);
            }  
        }      
        
        // handle flag lookups from accounts map
        for (Lattice_Play__c p : triggerNew) {
            Account a = accsMap.get(p.Account_Id__c);
            
            // Handle missing accounts in UAT
            if (a == null) {
                continue;
            }

            // Assign header account
            if (a.RecordType.Name == 'Customer') {
                p.Header_Account__c = a.Id;
                
                // Assign variables from header
                if (a.Coupon_flag__c != null) {
                    p.Offer_Flag__c = a.Coupon_flag__c;
                }
                else {
                    p.Offer_Flag__c = 'N';
                }
                
                if (a.Account_level_email_permission_flag__c != null) {
                    p.Opt_In_Out_Flag__c = a.Account_level_email_permission_flag__c;
                }
                else {
                    p.Opt_In_Out_Flag__c = 'N';
                }
                
                if (a.Legal_Flag__c != null) {
                    p.Legal_WA_Flag__c = a.Legal_Flag__c;
                }
            }
            else if (a.RecordType.Name == 'Site') {
                p.Header_Account__c = a.Related_Account__c;
                
                // Assign variables from header
                if (a.Related_Account__r.Coupon_flag__c != null) {
                    p.Offer_Flag__c = a.Related_Account__r.Coupon_flag__c;
                }
                else {
                    p.Offer_Flag__c = 'N';
                }
                
                if (a.Related_Account__r.Account_level_email_permission_flag__c != null) {
                    p.Opt_In_Out_Flag__c = a.Related_Account__r.Account_level_email_permission_flag__c;
                }
                else {
                    p.Opt_In_Out_Flag__c = 'N';
                }
                
                if (a.Related_Account__r.Legal_Flag__c != null) {
                    p.Legal_WA_Flag__c = a.Related_Account__r.Legal_Flag__c;
                }
            }       
        }  
    }      
}