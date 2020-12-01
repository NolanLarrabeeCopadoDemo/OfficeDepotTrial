@isTest
private class Medallia_Batch_TC {
    
    @TestSetup
    static void setup(){
        // mf1 and mf2
        Contact c1 = new Contact();
        c1.LastName = 'contact1';
        c1.Medallia_Opted_Out__c = false;
        c1.Email = 'test@test.com';
        insert c1;

        // mf3 and mf4
        Contact c2 = new Contact();
        c2.LastName = 'contact2';
        c2.Medallia_Opted_Out__c = false;
        c2.Email = 'test2@test2.com';
        insert c2;

        Medallia_Feedback__c mf1 = new Medallia_Feedback__c();
        mf1.Name = 'feedback1';
        mf1.Record_Status__c = 'Opted Out';
        mf1.Contact_Id__c = c1.Id;
        insert mf1;

        Medallia_Feedback__c mf2 = new Medallia_Feedback__c();
        mf2.Name = 'feedback2';
        mf2.Record_Status__c = 'Delivery bounced (Hard bounce)';
        mf2.Contact_Email__c = 'different@test.com';
        mf2.Contact_Id__c = c1.Id;
        mf2.Email_Update_Status__c = false;
        insert mf2;

        Medallia_Feedback__c mf3 = new Medallia_Feedback__c();
        mf3.Name = 'feedback3';
        mf3.Record_Status__c = 'Delivery bounced (Hard bounce)';
        mf3.Contact_Email__c = 'test2@test2.com';
        mf3.Contact_Id__c = c2.Id;
        mf3.Email_Update_Status__c = false;
        insert mf3;

        Medallia_Feedback__c mf4 = new Medallia_Feedback__c();
        mf4.Name = 'feedback4';
        mf4.Record_Status__c = 'Completed';
        mf4.Contact_Email__c = 'different@test.com';
        mf4.Contact_Id__c = c2.Id;
        mf4.Email_Update_Status__c = false;
        insert mf4;
    }

    static testMethod void test() {
        Test.startTest();
        Medallia_Batch mb = new Medallia_Batch();
        Database.executeBatch(mb);
        Test.stopTest();

        // Opted Out should be true because of the record status on mf1.
        Contact c1 = [SELECT Id, Medallia_Opted_Out__c FROM Contact WHERE LastName = 'contact1'];
        System.assertEquals(true, c1.Medallia_Opted_Out__c);

        // Email update status should be true because the record status is Delivery bounced (Hard bounce) and the email has
        // been updated (is different on the Contact).
        Medallia_Feedback__c mf2 = [SELECT Id, Email_Update_Status__c FROM Medallia_Feedback__c WHERE Name = 'feedback2'];
        System.assertEquals(true, mf2.Email_Update_Status__c);

        // Opted Out should be false because neither mf3 or mf4 have Opted out as their Record Status.
        Contact c2 = [SELECT Id, Medallia_Opted_Out__c FROM Contact WHERE LastName = 'contact2'];
        System.assertEquals(false, c2.Medallia_Opted_Out__c);

        // Email Update Status should be false because the email is the same on the Contact.
        Medallia_Feedback__c mf3 = [SELECT Id, Email_Update_Status__c FROM Medallia_Feedback__c WHERE Name = 'feedback3'];
        System.assertEquals(false, mf3.Email_Update_Status__c);

        // Email Update Status should be false because the Record Status is Completed.
        Medallia_Feedback__c mf4 = [SELECT Id, Email_Update_Status__c FROM Medallia_Feedback__c WHERE Name = 'feedback4'];
        System.assertEquals(false, mf4.Email_Update_Status__c);
    }
}