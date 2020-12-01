@IsTest
private class LeadOwnerAssignmentReminder_Batch_TC {
    
    @TestSetup
    static void setup() {
        // Retrieve the reminder settings.
        Reminder_Settings__mdt reminderSettings = [SELECT Id, Email_Template_Name_1__c, Email_Template_Name_2__c, Interval_Length_1__c,
                            Interval_Length_2__c, Interval_Unit__c, Record_Types__c, Alternate_Record_Types__c
                            FROM Reminder_Settings__mdt WHERE Label = 'Lead Reminders'];
        
        // Set times for each test lead to subtract from the current time
        DateTime testHours1 = DateTime.now();
        DateTime testHours2 = DateTime.now();

        switch on reminderSettings.Interval_Unit__c {
            when 'Business Days' {
                testHours1 = Utils_Time.subtractBusinessDays(testHours1, reminderSettings.Interval_Length_1__c.intValue());
                testHours2 = Utils_Time.subtractBusinessDays(testHours2, reminderSettings.Interval_Length_2__c.intValue());
            } when 'Days' {
                testHours1 = testHours1.addDays(-1 * reminderSettings.Interval_Length_1__c.intValue());
                testHours2 = testHours2.addDays(-1 * reminderSettings.Interval_Length_2__c.intValue());
            } when 'Hours' {
                testHours1 = testHours1.addHours(-1 * reminderSettings.Interval_Length_1__c.intValue());
                testHours2 = testHours2.addHours(-1 * reminderSettings.Interval_Length_2__c.intValue());
            } when 'Minutes' {
                testHours1 = testHours1.addMinutes(-1 * reminderSettings.Interval_Length_1__c.intValue());
                testHours2 = testHours2.addMinutes(-1 * reminderSettings.Interval_Length_2__c.intValue());
            }
        }
        
        // Create at test user.
        List<User> usrs = MyUtilsDataFactory.makeUsers(13);
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
        userSetting.Job_Code_Level__c = 'VP';
        insert userSetting;
        
        // Get a record type to use for the leads.
        Id recordTypeId = null;
        List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Lead'];
        for(RecordType rType : recordTypes) {
            if(reminderSettings.Record_Types__c.split(',').contains(rType.Name) &&
                            reminderSettings.Alternate_Record_Types__c.split(',').contains(rType.Name) == false) {
                recordTypeId = rType.Id;
                break;
            }
        }
        
        // Create the test leads.
        List <Lead> lds = new List<Lead>();
        
        Lead ld1 = new Lead();
        ld1.LastName = 'testlead1';
        ld1.Zip__c = '11111';
        ld1.Company = 'testcompany1';
        ld1.Status = 'Open';
        ld1.LeadSource = 'BSD NET';
        ld1.RecordTypeId = recordTypeId;
        ld1.OwnerId = owner.Id;
        ld1.Auto_Assign__c = false;
        lds.add(ld1);
        
        Lead ld2 = new Lead();
        ld2.LastName = 'testlead2';
        ld2.Zip__c = '11111';
        ld2.Company = 'testcompany2';
        ld2.Status = 'Open';
        ld2.LeadSource = 'BSD NET';
        ld2.RecordTypeId = recordTypeId;
        ld2.OwnerId = owner.Id;
        ld2.Auto_Assign__c = false;
        lds.add(ld2);
        
        Lead ld3 = new Lead();
        ld3.LastName = 'testlead3';
        ld3.Zip__c = '11111';
        ld3.Company = 'testcompany3';
        ld3.Status = 'Open';
        ld3.LeadSource = 'BSD NET';
        ld3.RecordTypeId = recordTypeId;
        ld3.OwnerId = owner.Id;
        ld3.Auto_Assign__c = false;
        lds.add(ld3);
        
        Lead ld4 = new Lead();
        ld4.LastName = 'testlead4';
        ld4.Zip__c = '11111';
        ld4.Company = 'testcompany4';
        ld4.Status = 'Open';
        ld4.LeadSource = 'BSD NET';
        ld4.RecordTypeId = recordTypeId;
        ld4.OwnerId = owner2.Id;
        ld4.Auto_Assign__c = false;
        ld4.Email_Notification_Off__c = True; // Note that an email should still be sent for this lead, since the owner is not Data Loader.
        lds.add(ld4);
        
        Lead ld5 = new Lead();
        ld5.LastName = 'testlead5';
        ld5.Zip__c = '11111';
        ld5.Company = 'testcompany5';
        ld5.Status = 'Open';
        ld5.LeadSource = 'BSD NET';
        ld5.RecordTypeId = recordTypeId;
        ld5.OwnerId = owner3.Id; // Note that an email should not be sent for this lead.
        ld5.Auto_Assign__c = false;
        lds.add(ld5);
        
        insert lds;
        
        lds[0].Owner_Modified_Date__c = testHours1; // ld1 will have an Owner Modified Date within the interval.
        lds[1].Owner_Modified_Date__c = testHours2; // ld2 will have an Owner Modified Date after the interval.
        lds[3].Owner_Modified_Date__c = testHours1; // ld4 will have an Owner Modified Date within the interval.
        lds[4].Owner_Modified_Date__c = testHours1; // ld5 will have an Owner Modified Date within the interval.
        
        update lds;
        
        // Set up data for bulk test.
        List<User> userSet2 = new List<User>();
        for(Integer i = 3; i < 13; i++) {
            usrs[i].profileId = p.Id;
            usrs[i].Title = 'Software Engineer, IT';
            usrs[i].LastName = 'TestUser1340' + i;
            userSet2.add(usrs[i]);
        }
        insert userSet2;
        
        List <Lead> loadTestLeads = new List<Lead>();
        for(Integer i = 0; i < 10; i++) {        
            Lead ld = new Lead();
            ld.LastName = 'testlead6' + i;
            ld.Zip__c = '11111';
            ld.Company = 'testcompany1';
            ld.Status = 'Open';
            ld.LeadSource = 'Store Lead';
            ld.RecordTypeId = recordTypeId;
            ld.OwnerId = userSet2[i].Id;
            ld.Auto_Assign__c = false;
            loadTestLeads.add(ld);
        }
        insert loadTestLeads;
        
        for(Lead ld : loadTestLeads) {
            ld.Owner_Modified_Date__c = testHours1;
        }
        update loadTestLeads;
    }
    
    @IsTest
    static void testOwnerReassignment() {
        Reminder_Settings__mdt reminderSettings = [SELECT Id, Should_Reassign__c, Alternate_RT_Should_Reassign__c FROM Reminder_Settings__mdt WHERE Label = 'Lead Reminders'];

        User owner = [SELECT Id FROM User WHERE LastName = 'TestUser1342'];
        User owner2 = [SELECT Id FROM User WHERE LastName = 'TestUser1343'];
        User owner3 = [SELECT Id FROM User WHERE LastName = 'TestUser1344'];
        
        // Run the code.
        Test.startTest();
        LeadOwnerAssignmentReminder_Batch loab = new LeadOwnerAssignmentReminder_Batch();
        Database.executeBatch(loab);
        Test.stopTest();
        
        // Check results.
        if(reminderSettings.Should_Reassign__c == true) {
            System.assertEquals(13, LeadOwnerAssignmentReminder_Batch.emailsSent, 'Ensure the correct number of emails were sent.');
        } else {
            System.assertEquals(12, LeadOwnerAssignmentReminder_Batch.emailsSent, 'Ensure the correct number of emails were sent.');
        }
        
        Lead updatedLd1 = [SELECT Id, OwnerId FROM Lead WHERE LastName = 'testlead1'];
        System.assertEquals(owner.Id, updatedLd1.OwnerId, 'Lead 1 OwnerId should not change.');
        
        Lead updatedLd2 = [SELECT Id, OwnerId FROM Lead WHERE LastName = 'testlead2'];
        if(reminderSettings.Should_Reassign__c == true) {
            QueueSobject leadTriageQueue = [SELECT Id, QueueId FROM QueueSobject WHERE SobjectType = 'Lead' AND Queue.Name = 'Leads Reassigned After 72 Hours' LIMIT 1];
            System.assertEquals(leadTriageQueue.QueueId, updatedLd2.OwnerId, 'Lead 2 OwnerId should change to Lead Triage Queue Id.');
        } else {
            System.assertEquals(owner.Id, updatedLd2.OwnerId);
        }
        
        Lead updatedLd3 = [SELECT Id, OwnerId FROM Lead WHERE LastName = 'testlead3'];
        System.assertEquals(owner.Id, updatedLd3.OwnerId, 'Lead 3 OwnerId should not change.');
        
        Lead updatedLd4 = [SELECT Id, OwnerId FROM Lead WHERE LastName = 'testlead4'];
        System.assertEquals(owner2.Id, updatedLd4.OwnerId, 'Lead 4 OwnerId should not change.');
        
        Lead updatedLd5 = [SELECT Id, OwnerId FROM Lead WHERE LastName = 'testlead5'];
        System.assertEquals(owner3.Id, updatedLd5.OwnerId, 'Lead 5 OwnerId should not change.');
    }
    
    @IsTest
    static void testCreateQuery() {
        LeadOwnerAssignmentReminder_Batch loab = new LeadOwnerAssignmentReminder_Batch();
        
        List<RecordType> recordTypes = [SELECT Id, Name FROM RecordType WHERE sObjectType = 'Lead'];
        
        // Test 1
        String recordTypeString = recordTypes[0].Name + ',' + recordTypes[1].Name;
        
        String result = loab.createQuery(recordTypeString);
        System.assertEquals('SELECT Id, Owner_Modified_Date__c, Status, Email_Notification_Off__c, LeadSource, OwnerId, CreatedById, Owner.Email, Owner.Title, RecordType.Name FROM Lead ' +
                            'WHERE Owner_Modified_Date__c >= LAST_N_DAYS:7 AND Status=\'Open\' AND Owner.Type = \'User\' AND (RecordTypeId = \'' +
                            recordTypes[0].Id + '\' OR RecordTypeId = \'' + recordTypes[1].Id + '\')', result, 'Should create query for multiple values for each criteria.');
        
        // Test 2
        recordTypeString = recordTypes[0].Name + ' , ' + recordTypes[1].Name;
        
        result = loab.createQuery(recordTypeString);
        System.assertEquals('SELECT Id, Owner_Modified_Date__c, Status, Email_Notification_Off__c, LeadSource, OwnerId, CreatedById, Owner.Email, Owner.Title, RecordType.Name FROM Lead ' +
                            'WHERE Owner_Modified_Date__c >= LAST_N_DAYS:7 AND Status=\'Open\' AND Owner.Type = \'User\' AND (RecordTypeId = \'' +
                            recordTypes[0].Id + '\' OR RecordTypeId = \'' + recordTypes[1].Id + '\')', result, 'Should create query and remove extra whitespace.');
        
        // Test 3
        recordTypeString = recordTypes[0].Name;
        
        result = loab.createQuery(recordTypeString);
        System.assertEquals('SELECT Id, Owner_Modified_Date__c, Status, Email_Notification_Off__c, LeadSource, OwnerId, CreatedById, Owner.Email, Owner.Title, RecordType.Name FROM Lead ' +
                            'WHERE Owner_Modified_Date__c >= LAST_N_DAYS:7 AND Status=\'Open\' AND Owner.Type = \'User\' AND (RecordTypeId = \'' +
                            recordTypes[0].Id + '\')', result, 'Should create query with one value for each criteria.');
        
        // Test 4
        recordTypeString = '';
        
        result = loab.createQuery(recordTypeString);
        System.assertEquals('SELECT Id, Owner_Modified_Date__c, Status, Email_Notification_Off__c, LeadSource, OwnerId, CreatedById, Owner.Email, Owner.Title, RecordType.Name FROM Lead ' +
                            'WHERE Owner_Modified_Date__c >= LAST_N_DAYS:7 AND Status=\'Open\' AND Owner.Type = \'User\'', result, 'Should create query with blank string for each criteria.');
        
        // Test 5
        recordTypeString = null;
        
        result = loab.createQuery(recordTypeString);
        System.assertEquals('SELECT Id, Owner_Modified_Date__c, Status, Email_Notification_Off__c, LeadSource, OwnerId, CreatedById, Owner.Email, Owner.Title, RecordType.Name FROM Lead ' +
                            'WHERE Owner_Modified_Date__c >= LAST_N_DAYS:7 AND Status=\'Open\' AND Owner.Type = \'User\'', result, 'Should create query with null for each criteria.');
    }
}