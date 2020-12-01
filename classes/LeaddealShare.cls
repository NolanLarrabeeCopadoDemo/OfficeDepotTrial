public class LeaddealShare {
        
        public static void shareLeadwithPartner(List<Lead> leads,Map<Id,Lead> oldMap) {
        Map<ID,ID> leadtoUser = new Map<ID,ID>();
        list<lead> leadstoUpdate = new List<lead>();
        Map<ID,ID> contacttoUser = new Map<ID,ID>();
        Id dealId = Schema.SobjectType.Lead.getRecordTypeInfosByName().get('Lead (Deals)').getRecordTypeId();
        for (Lead l: leads) {
            if (oldMap == null || l.ownerid != oldMap.get(l.id).ownerid || l.Partner_Sub_Agent_Contact__c != oldMap.get(l.id).Partner_Sub_Agent_Contact__c) {
               if (l.Partner_Sub_Agent_Contact__c != null) {
                  system.debug('adding lead to update'); 
                  leadstoUpdate.add(l);
                  contacttoUser.put(l.Partner_Sub_Agent_Contact__c,null);
                }
            }
        }
        
        for (user u: [select id,ContactId from user where ContactId=:contacttoUser.keyset()]) {
            contacttoUser.put(u.contactid,u.id); 
        }
        
        for (lead l:leadstoUpdate) {
                if (contacttoUser.containskey(l.Partner_Sub_Agent_Contact__c)) {
                    leadtoUser.put(l.id,contacttoUser.get(l.Partner_Sub_Agent_Contact__c));
                    
                }
        }
        
        Map<Id, Id> leadsToGroups = SharingUtils.getMasterAccountGroupsForLeads(leadsToUpdate);  
                
        list<leadShare> lsList = new list<leadShare>();
        List<LeadShare> sharesToDelete = new List<LeadShare>(); 
                
        if (leadtoUser.size() > 0) {
          for (lead ld : leadstoUpdate) {
            Id partnerUserId = leadtoUser.get(ld.Id); 
            If (partnerUserId != null && ld.ownerid != partnerUserId) {
                leadShare ls = new leadShare();
                ls.leadId = ld.id;
                ls.UserOrGroupId = partnerUserId; 
                ls.LeadAccessLevel = 'Read';
                ls.Rowcause = Schema.leadShare.RowCause.Manual;
                lsList.add(ls);
            }
              
            Id groupId = leadsToGroups.get(ld.Id);
            if (groupId != null) { 
                leadShare ls = new leadShare();
                ls.leadId = ld.id;
                ls.UserOrGroupId = groupId; 
                ls.LeadAccessLevel = 'Read';
                ls.Rowcause = Schema.leadShare.RowCause.Manual;
                lsList.add(ls);
            }
            
            if (oldMap != null && ld.ownerid == oldMap.get(ld.id).ownerid) {
                List<LeadShare> existingShares = [select Id from LeadShare where LeadId =: ld.Id and RowCause = 'Manual'];
                sharesToDelete.addAll(existingShares);   
            }
          }
        }
        
        if (sharesToDelete.size() > 0) {
             Database.delete(sharesToDelete);
        }  
         
        if (lsList.size() > 0) {
             Database.insert(lsList);
        }
        
        
    }
    
    public static void setDealDefaults (list<lead> leads) {
        
        list<user> u = [select id,contactid,contact.accountid,contact.account.ownerid from user where id=:UserInfo.getUserId() limit 1];
        ID dealId = Schema.SobjectType.Lead.getRecordTypeInfosByName().get('Lead (Deals)').getRecordTypeId();
        for (lead l : leads) {
             
            if (l.RecordTypeId == dealId) {
                
                if (l.first_name__c != null && l.first_name__c != '')
                    l.firstName=l.first_name__c;
                if (l.last_name__c != null && l.last_name__c != '') {
                    l.lastName=l.last_name__c;
                    
                }
                
                if (u.size() > 0) {
                    if (u[0].contact != null) {
                        l.Sub_Agent__c=u[0].contact.accountid;
                        l.Partner_Sub_Agent_Contact__c = u[0].contactid;
                        l.Channel_Account_Manager__c = u[0].contact.account.ownerid; 
                        l.leadsource = 'TZ: Channel Partner';
                    }
                }
                
                
            }
        }
    }
}