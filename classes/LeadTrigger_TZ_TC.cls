@isTest
private class LeadTrigger_TZ_TC {
    
    static testMethod void tzExistingProviderAttributesUpdatedTest() {
        RecordType tzRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Tech_Zone'];
        
        Lead ld1 = new Lead(LastName='ld1', Company='ld1', Zip__c='11111', Existing_Provider_Monthly_Spend__c=10,
                            Existing_Provider_Name__c='a', Existing_Provider_Renewal_Date__c=Date.today().addDays(1),
                            Existing_Provider_Satisfaction__c='Neutral', RecordTypeId=tzRecordType.Id);
        insert ld1;
        Lead ld2 = new Lead(LastName='ld2', Company='ld2', Zip__c='11111', Existing_Provider_Monthly_Spend__c=10,
                            Existing_Provider_Name__c='a', Existing_Provider_Renewal_Date__c=Date.today().addDays(1),
                            Existing_Provider_Satisfaction__c='Neutral', RecordTypeId=tzRecordType.Id);
        insert ld2;
        Lead ld3 = new Lead(LastName='ld3', Company='ld3', Zip__c='11111', Existing_Provider_Monthly_Spend__c=10,
                            Existing_Provider_Name__c='a', Existing_Provider_Renewal_Date__c=Date.today().addDays(1),
                            Existing_Provider_Satisfaction__c='Neutral', RecordTypeId=tzRecordType.Id);
        insert ld3;
        Lead ld4 = new Lead(LastName='ld4', Company='ld4', Zip__c='11111', Existing_Provider_Monthly_Spend__c=10,
                            Existing_Provider_Name__c='a', Existing_Provider_Renewal_Date__c=Date.today().addDays(1),
                            Existing_Provider_Satisfaction__c='Neutral', RecordTypeId=tzRecordType.Id);
        insert ld4;
        Lead ld5 = new Lead(LastName='ld5', Company='ld5', Zip__c='11111', Existing_Provider_Monthly_Spend__c=10,
                            Existing_Provider_Name__c='a', Existing_Provider_Renewal_Date__c=Date.today().addDays(1),
                            Existing_Provider_Satisfaction__c='Neutral', RecordTypeId=tzRecordType.Id);
        insert ld5;
        
        List<Lead> leadsToUpdate = new List<Lead>();
        ld1.Existing_Provider_Monthly_Spend__c = 15;
        leadsToUpdate.add(ld1);
        ld2.Existing_Provider_Name__c = 'b';
        leadsToUpdate.add(ld2);
        ld3.Existing_Provider_Renewal_Date__c = Date.today().addDays(2);
        leadsToUpdate.add(ld3);
        ld4.Existing_Provider_Satisfaction__c = 'Satisfied';
        leadsToUpdate.add(ld4);
        leadsToUpdate.add(ld5);
        
        Test.startTest();
        update leadsToUpdate;
        Test.stopTest();
        
        ld1 = [SELECT Id, Existing_Provider_Last_Updated_Date__c FROM Lead WHERE Id =: ld1.Id];
        ld2 = [SELECT Id, Existing_Provider_Last_Updated_Date__c FROM Lead WHERE Id =: ld2.Id];
        ld3 = [SELECT Id, Existing_Provider_Last_Updated_Date__c FROM Lead WHERE Id =: ld3.Id];
        ld4 = [SELECT Id, Existing_Provider_Last_Updated_Date__c FROM Lead WHERE Id =: ld4.Id];
        ld5 = [SELECT Id, Existing_Provider_Last_Updated_Date__c FROM Lead WHERE Id =: ld5.Id];
        
        System.assertEquals(Date.today(), ld1.Existing_Provider_Last_Updated_Date__c);
        System.assertEquals(Date.today(), ld2.Existing_Provider_Last_Updated_Date__c);
        System.assertEquals(Date.today(), ld3.Existing_Provider_Last_Updated_Date__c);
        System.assertEquals(Date.today(), ld4.Existing_Provider_Last_Updated_Date__c);
        System.assertEquals(null, ld5.Existing_Provider_Last_Updated_Date__c);
    }
    
    static testMethod void tzSetBDRField() {
        RecordType tzRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Lead' AND DeveloperName = 'Tech_Zone'];
        List<User> owners = MyUtilsDataFactory.makeUsers(2);
        Profile bdrProfile = [SELECT Id FROM Profile WHERE Name LIKE 'TZ BDR%'];
        Profile nonBdrProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        owners[0].ProfileId = bdrProfile.Id;
        owners[1].ProfileId = nonBdrProfile.Id;
        insert owners;
        
        List<Lead> leadsToInsert = new List<Lead>();
        Lead insert1 = new Lead(LastName='insert1', Company='insert1', Zip__c='11111', OwnerId=owners[0].Id, RecordTypeId=tzRecordType.Id);
        leadsToInsert.add(insert1);
        
        List<Lead> leadsToUpdate = new List<Lead>();
        Lead update1 = new Lead(LastName='update1', Company='update1', Zip__c='11111', OwnerId=owners[1].Id, RecordTypeId=tzRecordType.Id);
        insert update1;
        update1.OwnerId = owners[0].Id;
        leadsToUpdate.add(update1);
        Lead update2 = new Lead(LastName='update2', Company='update2', Zip__c='11111', OwnerId=owners[0].Id, RecordTypeId=tzRecordType.Id);
        insert update2;
        update2.OwnerId = owners[1].Id;
        update2.Status = 'New';
        leadsToUpdate.add(update2);
        
        Test.startTest();
        insert leadsToInsert;
        update leadsToUpdate;
        Test.stopTest();
        
        insert1 = [SELECT Id, BDR__c FROM Lead WHERE Id =: insert1.Id];
        update1 = [SELECT Id, BDR__c FROM Lead WHERE Id =: update1.Id];
        update2 = [SELECT Id, BDR__c FROM Lead WHERE Id =: update2.Id];
        
        System.assertEquals(owners[0].Id, insert1.BDR__c);
        System.assertEquals(owners[0].Id, update1.BDR__c);
        System.assertEquals(null, update2.BDR__c);
    }
}