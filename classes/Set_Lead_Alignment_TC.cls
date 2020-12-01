@isTest
private class Set_Lead_Alignment_TC {
    
    // Create Alignments and Assignment Settings.
    @TestSetup
    static void makeData(){
        TAV4__Geo_Container__c geoContainer = new TAV4__Geo_Container__c(Name='geo', TAV4__Account_Lookup_Field__c='Zip__c',
        							TAV4__Identifier_Length__c=5, TAV4__Lead_Lookup_Field__c='Zip__c', TAV4__Prefix__c='ZIP');
        insert geoContainer;
        
        List<TAV4__Alignment__c> alignments = new List<TAV4__Alignment__c>();
        TAV4__Alignment__c alignment1 = new TAV4__Alignment__c(Name='alignment1', TAV4__Geo_Container__c=geoContainer.Id);
        alignments.add(alignment1);
        TAV4__Alignment__c alignment2 = new TAV4__Alignment__c(Name='alignment2', TAV4__Geo_Container__c=geoContainer.Id);
        alignments.add(alignment2);
        TAV4__Alignment__c alignment3 = new TAV4__Alignment__c(Name='alignment3', TAV4__Geo_Container__c=geoContainer.Id);
        alignments.add(alignment3);
        TAV4__Alignment__c ownerAlignment = new TAV4__Alignment__c(Name='ownerAlignment', TAV4__Geo_Container__c=geoContainer.Id);
        alignments.add(ownerAlignment);
        TAV4__Alignment__c triageAlignment = new TAV4__Alignment__c(Name='Lead Triage', TAV4__Geo_Container__c=geoContainer.Id);
        alignments.add(triageAlignment);
        insert alignments;

        System.debug(LoggingLevel.DEBUG, 'My Alignments' + alignments);

        List<Lead_Assignment_Setting__c> settings = new List<Lead_Assignment_Setting__c>();
        Lead_Assignment_Setting__c setting1 = new Lead_Assignment_Setting__c(Name='setting1',
                        Alignment__c=alignment1.Id, Min_WCW__c=10, Max_WCW__c=20, Priority__c=1);
        settings.add(setting1);
        Lead_Assignment_Setting__c setting2 = new Lead_Assignment_Setting__c(Name='setting2',
                        Alignment__c=alignment2.Id, Min_WCW__c=21, Max_WCW__c=30, Priority__c=3);
        settings.add(setting2);
        Lead_Assignment_Setting__c setting3 = new Lead_Assignment_Setting__c(Name='setting3',
                        Alignment__c=alignment3.Id, Min_WCW__c=25, Max_WCW__c=35, Priority__c=2);
        settings.add(setting3);
        Lead_Assignment_Setting__c ownerSetting = new Lead_Assignment_Setting__c(Name='ownerSetting',
                        Alignment__c=ownerAlignment.Id, Min_WCW__c=100, Max_WCW__c=150, Priority__c=4);
        settings.add(ownerSetting);
        Lead_Assignment_Setting__c triageSetting = new Lead_Assignment_Setting__c(Name='triageSetting',
                        Alignment__c=triageAlignment.Id, Min_WCW__c=151, Max_WCW__c=200, Priority__c=5, Assign_To_Lead_Triage__c=true);
        settings.add(triageSetting);
        insert settings;

        System.debug(LoggingLevel.DEBUG, 'My Settings' + settings);

        List<User> usrs = MyUtilsDataFactory.makeUsers(1);
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        usrs[0].profileId = p.Id;
        usrs[0].Title = 'Software Engineer, IT';
        usrs[0].LastName = 'alignmentUser';
        insert usrs;
    }

    // Test a basic insert, Lead should be given Alignment 1.
    @isTest
    static void testInsert1() {
        Lead lead1 = new Lead(LastName='lead1', Company='lead1', WCW_Count__c=10, Auto_Assign__c=false);

        Test.startTest();
        insert lead1;
        Test.stopTest();

        lead1 = [SELECT Id, TAV4__Alignment__c FROM Lead WHERE Name = 'lead1'];
        TAV4__Alignment__c alignment1 = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'alignment1'];
        
        System.assertEquals(alignment1.Id, lead1.TAV4__Alignment__c);
    }
    
    // Test insert with conflicting Settings, should take the one with better Priority, Alignment 3.
    @isTest
    static void testInsert2() {
        Lead lead2 = new Lead(LastName='lead2', Company='lead2', WCW_Count__c=27, Auto_Assign__c=false);
        
        Test.startTest();
        insert lead2;
        Test.stopTest();
        
        lead2 = [SELECT Id, TAV4__Alignment__c FROM Lead WHERE Name = 'lead2'];
        TAV4__Alignment__c alignment3 = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'alignment3'];
        
        System.assertEquals(alignment3.Id, lead2.TAV4__Alignment__c);
    }
    
    // Test insert where the Lead doesn't meet any of the Settings' criteria, Alignment should be null.
    @isTest
    static void testInsert3() {
        Lead lead3 = new Lead(LastName='lead3', Company='lead3', WCW_Count__c=5, Auto_Assign__c=false);
        
        Test.startTest();
        insert lead3;
        Test.stopTest();
        
        lead3 = [SELECT Id, TAV4__Alignment__c FROM Lead WHERE Name = 'lead3'];
        
        System.assertEquals(null, lead3.TAV4__Alignment__c);
    }
    
    // Test an update, final Alignment should be Alignment 1.
    @isTest
    static void testUpdate1() {
        Lead lead4 = new Lead(LastName='lead4', Company='lead4', WCW_Count__c=36, Auto_Assign__c=false);
        insert lead4;
        
        lead4.WCW_Count__c = 20;
        
        Test.startTest();
        update lead4;
        Test.stopTest();
        
        lead4 = [SELECT Id, TAV4__Alignment__c FROM Lead WHERE Name = 'lead4'];
        TAV4__Alignment__c alignment1 = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'alignment1'];
        
        System.assertEquals(alignment1.Id, lead4.TAV4__Alignment__c);
    }
    
    // Test an update where Setting should be chosen with better Priority, should be Alignment 3.
    @isTest
    static void testUpdate2() {
        Lead lead5 = new Lead(LastName='lead5', Company='lead5', WCW_Count__c=15, Auto_Assign__c=false);
        insert lead5;
        
        lead5.WCW_Count__c = 30;
        
        Test.startTest();
        update lead5;
        Test.stopTest();
        
        lead5 = [SELECT Id, TAV4__Alignment__c FROM Lead WHERE Name = 'lead5'];
        TAV4__Alignment__c alignment3 = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'alignment3'];
        
        System.assertEquals(alignment3.Id, lead5.TAV4__Alignment__c);
    }
    
    // Test update where Lead doesn't meet the criteria for any Settings, Alignment should be null.
    @isTest
    static void testUpdate3() {
        Lead lead6 = new Lead(LastName='lead6', Company='lead6', WCW_Count__c=15, Auto_Assign__c=false);
        insert lead6;
        
        lead6.WCW_Count__c = 1;
        
        Test.startTest();
        update lead6;
        Test.stopTest();
        
        lead6 = [SELECT Id, TAV4__Alignment__c FROM Lead WHERE Name = 'lead6'];
        
        System.assertEquals(null, lead6.TAV4__Alignment__c);
    }


    // The below Tests test Lead Owner assignment.
    //////////////////////////////////////////////////////////////////////////////////////////////////////

    // Test insert where Lead Triage Assignment Setting is selected and Auto Assign is on, Owner should be Lead Triage Queue, Alignment should be Lead Triage.
    @isTest
    static void testInsertTriageSetting() {
        Lead lead7 = new Lead(LastName='lead7', Company='lead7', WCW_Count__c=200, Auto_Assign__c=true);

        Test.startTest();
        insert lead7;
        Test.stopTest();

        lead7 = [SELECT Id, TAV4__Alignment__c, OwnerId FROM Lead WHERE Name = 'lead7'];
        QueueSobject leadTriageQueue = [SELECT Id, QueueId FROM QueueSobject WHERE SObjectType = 'Lead' AND Queue.Name = 'Lead Triage' LIMIT 1];
        TAV4__Alignment__c triageAlignment = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'Lead Triage'];
        
        System.assertEquals(leadTriageQueue.QueueId, lead7.OwnerId);
        System.assertEquals(triageAlignment.Id, lead7.TAV4__Alignment__c);
    }

    // Test insert where regular alignment is used but no Sales Area is found and Auto Assign is on,
    // Owner should be Lead Triage Queue, Alignment should be Lead Triage.
    @isTest
    static void testInsertNoSalesArea() {
        Lead lead8 = new Lead(LastName='lead8', Company='lead8', WCW_Count__c=150, Auto_Assign__c=true);

        Test.startTest();
        insert lead8;
        Test.stopTest();

        lead8 = [SELECT Id, TAV4__Alignment__c, OwnerId FROM Lead WHERE Name = 'lead8'];
        QueueSobject leadTriageQueue = [SELECT Id, QueueId FROM QueueSobject WHERE SObjectType = 'Lead' AND Queue.Name = 'Lead Triage' LIMIT 1];
        TAV4__Alignment__c triageAlignment = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'Lead Triage'];
        
        System.assertEquals(leadTriageQueue.QueueId, lead8.OwnerId);
        System.assertEquals(triageAlignment.Id, lead8.TAV4__Alignment__c);
    }

    // Test insert where Auto Assign is off, Owner should be same one assigned, Alignment should be the same as original.
    @isTest
    static void testInsertNoAutoAssign() {
        User usr = [SELECT Id FROM User WHERE LastName = 'alignmentUser'];
        Lead lead9 = new Lead(LastName='lead9', Company='lead9', WCW_Count__c=150, Auto_Assign__c=false, OwnerId=usr.Id);

        Test.startTest();
        insert lead9;
        Test.stopTest();

        lead9 = [SELECT Id, TAV4__Alignment__c, OwnerId FROM Lead WHERE Name = 'lead9'];
        TAV4__Alignment__c ownerAlignment = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'ownerAlignment'];
        
        System.assertEquals(usr.Id, lead9.OwnerId);
        System.assertEquals(ownerAlignment.Id, lead9.TAV4__Alignment__c);
    }

    // Test insert where Auto Assign is off and Owner is set to Lead Triage Queue, Owner should remain Lead Triage Queue, Alignment should be Lead Triage.
    @isTest
    static void testInsertNoAutoAssignLeadTriage() {
        QueueSobject leadTriageQueue = [SELECT Id, QueueId FROM QueueSobject WHERE SObjectType = 'Lead' AND Queue.Name = 'Lead Triage' LIMIT 1];
        Lead lead10 = new Lead(LastName='lead10', Company='lead10', WCW_Count__c=150, Auto_Assign__c=false, OwnerId=leadTriageQueue.QueueId);

        Test.startTest();
        insert lead10;
        Test.stopTest();

        lead10 = [SELECT Id, TAV4__Alignment__c, OwnerId FROM Lead WHERE Name = 'lead10'];
        TAV4__Alignment__c triageAlignment = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'Lead Triage'];
        
        System.assertEquals(leadTriageQueue.QueueId, lead10.OwnerId);
        System.assertEquals(triageAlignment.Id, lead10.TAV4__Alignment__c);
    }

    // Test update where Lead Triage Assignment Setting is selected and Auto Assign is on, Owner should be Lead Triage Queue, Alignment should be Lead Triage.
    @isTest
    static void testUpdateTriageSetting() {
        Lead lead11 = new Lead(LastName='lead11', Company='lead11', WCW_Count__c=150, Auto_Assign__c=false);
        insert lead11;

        lead11 = [SELECT Id, Auto_Assign__c, WCW_Count__c FROM Lead WHERE Name = 'lead11'];
        lead11.Auto_Assign__c = true;
        lead11.WCW_Count__c = 200;

        Test.startTest();
        update lead11;
        Test.stopTest();

        lead11 = [SELECT Id, TAV4__Alignment__c, OwnerId FROM Lead WHERE Name = 'lead11'];
        QueueSobject leadTriageQueue = [SELECT Id, QueueId FROM QueueSobject WHERE SObjectType = 'Lead' AND Queue.Name = 'Lead Triage' LIMIT 1];
        TAV4__Alignment__c triageAlignment = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'Lead Triage'];
        
        System.assertEquals(leadTriageQueue.QueueId, lead11.OwnerId);
        System.assertEquals(triageAlignment.Id, lead11.TAV4__Alignment__c);
    }

    // Test update where regular alignment is used but no Sales Area is found and Auto Assign is on,
    // Owner should be Lead Triage Queue, Alignment should be Lead Triage.
    @isTest
    static void testUpdateNoSalesArea() {
        Lead lead12 = new Lead(LastName='lead12', Company='lead12', WCW_Count__c=150, Auto_Assign__c=false);
        insert lead12;

        lead12 = [SELECT Id, Auto_Assign__c FROM Lead WHERE Name = 'lead12'];
        lead12.Auto_Assign__c = true;

        Test.startTest();
        update lead12;
        Test.stopTest();

        lead12 = [SELECT Id, TAV4__Alignment__c, OwnerId FROM Lead WHERE Name = 'lead12'];
        QueueSobject leadTriageQueue = [SELECT Id, QueueId FROM QueueSobject WHERE SObjectType = 'Lead' AND Queue.Name = 'Lead Triage' LIMIT 1];
        TAV4__Alignment__c triageAlignment = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'Lead Triage'];
        
        System.assertEquals(leadTriageQueue.QueueId, lead12.OwnerId);
        System.assertEquals(triageAlignment.Id, lead12.TAV4__Alignment__c);
    }

    // Test update where Auto Assign is off, Owner should be same one assigned, Alignment should be same as original.
    @isTest
    static void testUpdateNoAutoAssign() {
        User usr = [SELECT Id FROM User WHERE LastName = 'alignmentUser'];
        Lead lead13 = new Lead(LastName='lead13', Company='lead13', WCW_Count__c=150, Auto_Assign__c=false, OwnerId=usr.Id);
        insert lead13;

        Test.startTest();
        update lead13;
        Test.stopTest();

        lead13 = [SELECT Id, TAV4__Alignment__c, OwnerId FROM Lead WHERE Name = 'lead13'];
        TAV4__Alignment__c ownerAlignment = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'ownerAlignment'];
        
        System.assertEquals(usr.Id, lead13.OwnerId);
        System.assertEquals(ownerAlignment.Id, lead13.TAV4__Alignment__c);
    }

    // Test insert where Auto Assign is off and Owner is set to Lead Triage Queue, Owner should remain Lead Triage Queue, Alignment should be Lead Triage.
    @isTest
    static void testUpdateNoAutoAssignLeadTriage() {
        QueueSobject leadTriageQueue = [SELECT Id, QueueId FROM QueueSobject WHERE SObjectType = 'Lead' AND Queue.Name = 'Lead Triage' LIMIT 1];
        Lead lead14 = new Lead(LastName='lead14', Company='lead14', WCW_Count__c=150, Auto_Assign__c=false);
        insert lead14;

        lead14 = [SELECT Id, OwnerId FROM Lead WHERE Name = 'lead14'];
        lead14.OwnerId = leadTriageQueue.QueueId;

        Test.startTest();
        update lead14;
        Test.stopTest();

        lead14 = [SELECT Id, TAV4__Alignment__c, OwnerId FROM Lead WHERE Name = 'lead14'];
        TAV4__Alignment__c triageAlignment = [SELECT Id FROM TAV4__Alignment__c WHERE Name = 'Lead Triage'];
        
        System.assertEquals(leadTriageQueue.QueueId, lead14.OwnerId);
        System.assertEquals(triageAlignment.Id, lead14.TAV4__Alignment__c);
    }
}