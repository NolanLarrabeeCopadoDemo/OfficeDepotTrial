public class opportunitydealShare {

 public static void shareOpportunitywithPartner(list<Opportunity> opp,Map<id,Opportunity> oldMap) {
        Map<ID,ID> opptoUser = new Map<ID,ID>();
        list<Opportunity> opptoUpdate = new list<Opportunity>();
        Map<ID,ID> contacttoUser = new Map<ID,ID>();
        //ID dealId = Schema.SobjectType.Lead.getRecordTypeInfosByName().get('Lead (Deals)').getRecordTypeId();
        for (Opportunity o: opp) {
          system.debug('oldMap-->' + oldMap);
          if (oldMap != null)
          {
            if (o.ownerid != oldMap.get(o.id).ownerid || o.Partner_Sub_Agent_Contact__c != oldMap.get(o.id).Partner_Sub_Agent_Contact__c) {
                if (o.Partner_Sub_Agent_Contact__c != null) {
                  opptoUpdate.add(o);
                  contacttoUser.put(o.Partner_Sub_Agent_Contact__c,null);
                  
                }
            }
          }
          else if (o.Partner_Sub_Agent_Contact__c != null) {
               opptoUpdate.add(o);
               contacttoUser.put(o.Partner_Sub_Agent_Contact__c,null);
          }
        }
        
        for (user u: [select id,ContactId from user where ContactId=:contacttoUser.keyset()]) {
            contacttoUser.put(u.contactid,u.id); 
        }

        
        for (Opportunity o:opptoUpdate) {
                if (contacttoUser.containskey(o.Partner_Sub_Agent_Contact__c)) {
                    opptoUser.put(o.id,contacttoUser.get(o.Partner_Sub_Agent_Contact__c));
                    
                }
        }
        
        Map<Id, Id> oppsToGroups = SharingUtils.getMasterAccountGroupsForOpportunities(opptoUpdate);  
        
        List<opportunityShare> osList = new list<opportunityShare>();
        List<OpportunityShare> sharesToDelete = new List<OpportunityShare>();
        
        if (opptoUser.size() > 0) {
          for (Opportunity od : opptoUpdate) {
            Id partnerUserId = opptoUser.get(od.Id);
            if (partnerUserId != null && od.ownerid != partnerUserId)  {
                opportunityShare os = new opportunityShare();
                os.opportunityId = od.id;
                os.UserOrGroupId = partnerUserId; 
                os.opportunityAccessLevel = 'Read';
                os.Rowcause = Schema.leadShare.RowCause.Manual;
                osList.add(os);
            }
            Id groupId = oppsToGroups.get(od.Id);
            if (groupId != null) { 
                OpportunityShare os = new OpportunityShare();
                os.OpportunityId = od.id;
                os.UserOrGroupId = groupId; 
                os.OpportunityAccessLevel = 'Read'; 
                os.Rowcause = Schema.OpportunityShare.RowCause.Manual;
                osList.add(os);
            }
             
            if (oldMap != null && od.ownerid == oldMap.get(od.id).ownerid) {
                List<OpportunityShare> existingShares = [select Id from OpportunityShare where OpportunityId =: od.Id and RowCause = 'Manual'];
                sharesToDelete.addAll(existingShares);    
            }
        }
        if (sharesToDelete.size() > 0) {
             Database.delete(sharesToDelete);
        }  
            
        if (osList.size() > 0)
            Database.insert(osList);
        }
    }

}