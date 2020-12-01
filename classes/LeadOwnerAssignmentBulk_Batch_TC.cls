@isTest
private class LeadOwnerAssignmentBulk_Batch_TC {
    
    @testSetup
    static void setup() {
        // Create at test user.
        List<User> usrs = MyUtilsDataFactory.makeUsers(23);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        usrs[0].profileId = p.Id;
        usrs[0].Title = 'Software Engineer, IT';
        usrs[0].LastName = 'TestUser1342';
        usrs[1].profileId = p.Id;
        usrs[1].Title = 'Software Engineer, IT';
        usrs[1].LastName = 'TestUser1343';
        usrs[2].profileId = p.Id;
        usrs[2].Title = 'USTST:123456:Test Title, IT';
        usrs[2].LastName = 'TestUser1344';
        List<User> userSet1 = new List<User> {usrs[0], usrs[1], usrs[2]};
        insert userSet1;
        User owner = userSet1[0];
        User owner2 = userSet1[1];
        User owner3 = userSet1[2];
        
        // Add entry to User Setting for owner 3.
        User_Setting__c userSetting = new User_Setting__c();
        userSetting.Name = 'USTST:123456:';
        userSetting.Job_Code_Level__c = 'President';
        insert userSetting;
        
        // Create the test leads.
        List <Lead> lds = new List<Lead>();
        
        Lead ld1 = new Lead();
        ld1.LastName = 'testlead1';
        ld1.Zip__c = '11111';
        ld1.Company = 'testcompany1';
        ld1.Status = 'Open';
        ld1.OwnerId = owner.Id;
        ld1.Auto_Assign__c = false;
        ld1.Send_Lead_Notification_Email__c = True; // Email should be sent for this lead.
        lds.add(ld1);
        
        Lead ld2 = new Lead();
        ld2.LastName = 'testlead2';
        ld2.Zip__c = '11111';
        ld2.Company = 'testcompany2';
        ld2.Status = 'Open';
        ld2.Auto_Assign__c = false;
        ld2.OwnerId = owner.Id; // Same owner as ld1, so only one email will be sent for these 2 leads.
        ld2.Send_Lead_Notification_Email__c = True;
        lds.add(ld2);
        
        Lead ld3 = new Lead(); // Note that the Send Notification Email flag is not set for this lead.
        ld3.LastName = 'testlead3';
        ld3.Zip__c = '11111';
        ld3.Company = 'testcompany3';
        ld3.Status = 'Open';
        ld3.OwnerId = owner2.Id;
        ld3.Auto_Assign__c = false;
        lds.add(ld3);
        
        Lead ld4 = new Lead();
        ld4.LastName = 'testlead4';
        ld4.Zip__c = '11111';
        ld4.Company = 'testcompany4';
        ld4.Status = 'Open';
        ld4.Auto_Assign__c = false;
        ld4.OwnerId = owner3.Id; // Note that a notification shouldn't be sent for this user.
        ld4.Send_Lead_Notification_Email__c = True;
        lds.add(ld4);
        
        insert lds;
        
        // Create another 20 Leads with different owners to load test.
        List<User> userSet2 = new List<User>();
        for(Integer i = 3; i < 23; i++) {
            usrs[i].profileId = p.Id;
            usrs[i].Title = 'Software Engineer, IT';
            usrs[i].LastName = 'loadTestUser1344';
            userSet2.add(usrs[i]);
        }
        insert userSet2;
        
        List<Lead> loadTestLeads = new List<Lead>();
        for(Integer i = 3; i < 23; i++) {
            Lead ld = new Lead();
            ld.LastName = 'loadTestLead';
            ld.Zip__c = '11111';
            ld.Company = 'testcompany1';
            ld.Status = 'Open';
            ld.OwnerId = usrs[i].Id;
            ld.Auto_Assign__c = false;
            ld.Send_Lead_Notification_Email__c = True; // Email should be sent for this lead.
            loadTestLeads.add(ld);
        }
        insert loadTestleads;
        
        List<Lead> testLeads = [SELECT Id, Owner.Email, Owner.Title FROM Lead WHERE Owner.Type = 'User' AND Send_Lead_Notification_Email__c = True];
        System.debug(testLeads.size());
    }
    
    static testMethod void testLeadCheck() {
        // Run the code.
        Test.startTest();
        LeadOwnerAssignmentBulk_Batch loaicb = new LeadOwnerAssignmentBulk_Batch();
        Database.executeBatch(loaicb);
        Test.stopTest();
        
        // Check results.
        System.assertEquals(21, LeadOwnerAssignmentBulk_Batch.emailsSent, 'Ensure the correct number of emails were sent.');
        
        Lead ld2 = [SELECT Id, Send_Lead_Notification_Email__c FROM Lead WHERE LastName = 'testlead2'];
        System.assertEquals(False, ld2.Send_Lead_Notification_Email__c, 'ld2 Send Notification flag should be False.');
        
        Lead ld3 = [SELECT Id, Send_Lead_Notification_Email__c FROM Lead WHERE LastName = 'testlead3'];
        System.assertEquals(False, ld3.Send_Lead_Notification_Email__c, 'ld3 Send Notification flag should be False.');
        
        Lead ld4 = [SELECT Id, Send_Lead_Notification_Email__c FROM Lead WHERE LastName = 'testlead4'];
        System.assertEquals(False, ld4.Send_Lead_Notification_Email__c, 'ld4 Send Notification flag should be False.');
    }
}