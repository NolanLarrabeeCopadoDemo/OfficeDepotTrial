@IsTest
public class OpportunityDealShareTest {

    static testMethod void testShareLeadwithPartner() {
        
        Profile p = [select Id, name from Profile where UserType = 'PowerPartner' limit 1];
        String userName = 'xyz@officedepot.com';
        String email = userName;
        String [] name = userName.split('@');
        
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs(thisUser) {
            
            Group grp = new Group();
            grp.name = 'Master Account Share';
            insert grp; 
            
            Account masterAccount = new Account(Name='master account'); 
            masterAccount.Sharing_Group__c = 'Master Account Share'; 
            insert masterAccount; 
            	    
            Recordtype rtPartner = [Select id, Sobjecttype from recordtype where name = 'Partner' and Sobjecttype = 'Account']; 
            Account acc = new Account(Name='Test Account');
            acc.RecordTypeId = rtPartner.Id; 
            acc.ParentId = masterAccount.Id; 
            insert acc; 
                
            Contact con = new Contact(LastName='userName', AccountId = acc.Id);
            insert con; 
            
            Contact con2 = new Contact(LastName='userName2', AccountId = acc.Id);
            insert con2; 
                        
            User partnerUser = 
                new User(Username = userName, FirstName = name[1], LastName = name[0], Alias = name[0], CommunityNickname = userName, LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', Profileid = p.id, LanguageLocaleKey = 'en_US');
            partnerUser.email = email;
            partnerUser.ContactId = con.id;
            partnerUser.IsActive = true;
            partnerUser.TimeZoneSidKey = 'America/Los_Angeles';
            insert partnerUser;
            
            Id RTId = Schema.SobjectType.Lead.getRecordTypeInfosByName().get('Lead (Deals)').getRecordTypeId();  
            Opportunity opp = new Opportunity(); 
			opp.Name = 'Test';             
            opp.StageName = 'Prospecting'; 
            opp.CloseDate = Date.today().addDays(1); 
            opp.Partner_Sub_Agent_Account__c = acc.Id;
            opp.Partner_Sub_Agent_Contact__c = con.id;
            system.debug('opp '+ opp);
            insert opp;
            
            List<OpportunityShare> oppShares =
                [Select UserOrGroupId, RowCause, OpportunityId, OpportunityAccessLevel, Id From OpportunityShare
                 where OpportunityId =: opp.Id]; 
            system.debug('shares: ' + oppShares); 
            system.assert(oppShares.size() == 3, '3 share records retrieved'); 
            boolean groupShareFound = false;
            boolean ownerShareFound = false; 
            for (OpportunityShare share : oppShares) {
                if (share.UserOrGroupId == grp.Id) 
                    groupShareFound = true; 
                if (share.UserOrGroupId == partnerUser.Id) 
                    ownerShareFound = true; 
            }
            system.assert(groupShareFound, 'Group Share Found');
            system.assert(ownerShareFound, 'Owner Share Found'); 
                        
            opp.Partner_Sub_Agent_Contact__c = con2.id; 
            update opp; 
            
            oppShares =
                [Select UserOrGroupId, RowCause, OpportunityId, OpportunityAccessLevel, Id From OpportunityShare
                 where OpportunityId =: opp.Id]; 
            
            system.debug('shares: ' + oppShares); 
            system.assert(oppShares.size() > 0, 'Share records retrieved');  
            
        }        
    }
}