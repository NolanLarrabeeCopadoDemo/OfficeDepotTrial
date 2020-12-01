@IsTest
private class User_Job_Code_Level_Batch_TC {

    @TestSetup
    static void makeData(){
        List<User> usrs = [SELECT Id, LastName, Title, Job_Code_Level__c FROM User
                            WHERE IsActive = true AND Profile.Name = 'Field Sales' LIMIT 5];

        usrs[0].LastName = 'User_Job_Code_Level_Batch_1';
        usrs[0].Title = 'USBSD:111111:';
        usrs[0].Job_Code_Level__c = null;
        usrs[1].LastName = 'User_Job_Code_Level_Batch_2';
        usrs[1].Title = 'USBSD:222222:';
        usrs[1].Job_Code_Level__c = null;
        usrs[2].LastName = 'User_Job_Code_Level_Batch_3';
        usrs[2].Title = 'USBSD:333333:';
        usrs[2].Job_Code_Level__c = null;
        usrs[3].LastName = 'User_Job_Code_Level_Batch_4';
        usrs[3].Title = 'USBSD:444444:';
        usrs[3].Job_Code_Level__c = null;
        usrs[4].LastName = 'User_Job_Code_Level_Batch_5';
        usrs[4].Title = 'USBSD:444444:';
        usrs[4].Job_Code_Level__c = 'SVP';
        update usrs;
    }
    
    @IsTest
    static void testBatchAllUsersUpdated() {
        User_Setting__c userSetting1 = new User_Setting__c(Name='USBSD:111111:', Job_Code_Level__c='Manager');
        User_Setting__c userSetting2 = new User_Setting__c(Name='USBSD:222222:', Job_Code_Level__c='Director');
        User_Setting__c userSetting3 = new User_Setting__c(Name='USBSD:333333:', Job_Code_Level__c='Senior Director');
        User_Setting__c userSetting4 = new User_Setting__c(Name='USBSD:444444:', Job_Code_Level__c='VP');
        insert new List<User_Setting__c> { userSetting1, userSetting2, userSetting3, userSetting4 };

        Test.startTest();
        String query = 'SELECT Id, Title, Job_Code_Level__c FROM User WHERE IsActive = true AND Title != null AND LastName LIKE \'User_Job_Code_Level_Batch_%\'';
        Database.executeBatch(new User_Job_Code_Level_Batch(query), 6);
        Test.stopTest();

        User user1 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_1'];
        User user2 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_2'];
        User user3 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_3'];
        User user4 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_4'];
        User user5 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_5'];
        System.assertEquals('Manager', user1.Job_Code_Level__c);
        System.assertEquals('Director', user2.Job_Code_Level__c);
        System.assertEquals('Senior Director', user3.Job_Code_Level__c);
        System.assertEquals('VP', user4.Job_Code_Level__c);
        System.assertEquals('VP', user5.Job_Code_Level__c);
    }

    @IsTest
    static void testBatchSomeUsersNotUpdated() {
        User_Setting__c userSetting1 = new User_Setting__c(Name='USBSD:111111:', Job_Code_Level__c='Manager');
        User_Setting__c userSetting2 = new User_Setting__c(Name='USBSD:222222:', Job_Code_Level__c='Director');
        User_Setting__c userSetting3 = new User_Setting__c(Name='USBSD:888888:', Job_Code_Level__c='Senior Director');
        insert new List<User_Setting__c> { userSetting1, userSetting2, userSetting3 };

        Test.startTest();
        String query = 'SELECT Id, Title, Job_Code_Level__c FROM User WHERE IsActive = true AND Title != null AND LastName LIKE \'User_Job_Code_Level_Batch_%\'';
        Database.executeBatch(new User_Job_Code_Level_Batch(query), 5);
        Test.stopTest();

        User user1 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_1'];
        User user2 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_2'];
        User user3 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_3'];
        User user4 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_4'];
        User user5 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_5'];
        System.assertEquals('Manager', user1.Job_Code_Level__c);
        System.assertEquals('Director', user2.Job_Code_Level__c);
        System.assertEquals(null, user3.Job_Code_Level__c);
        System.assertEquals(null, user4.Job_Code_Level__c);
        System.assertEquals('SVP', user5.Job_Code_Level__c);
    }

    @IsTest
    static void testBatchNoUsersUpdated() {
        User_Setting__c userSetting1 = new User_Setting__c(Name='USBSD:777777:', Job_Code_Level__c='Manager');
        User_Setting__c userSetting2 = new User_Setting__c(Name='USBSD:888888:', Job_Code_Level__c='Director');
        User_Setting__c userSetting3 = new User_Setting__c(Name='USBSD:999999:', Job_Code_Level__c='Senior Director');
        insert new List<User_Setting__c> { userSetting1, userSetting2, userSetting3 };

        Test.startTest();
        String query = 'SELECT Id, Title, Job_Code_Level__c FROM User WHERE IsActive = true AND Title != null AND LastName LIKE \'User_Job_Code_Level_Batch_%\'';
        Database.executeBatch(new User_Job_Code_Level_Batch(query), 5);
        Test.stopTest();

        User user1 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_1'];
        User user2 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_2'];
        User user3 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_3'];
        User user4 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_4'];
        User user5 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_5'];
        System.assertEquals(null, user1.Job_Code_Level__c);
        System.assertEquals(null, user2.Job_Code_Level__c);
        System.assertEquals(null, user3.Job_Code_Level__c);
        System.assertEquals(null, user4.Job_Code_Level__c);
        System.assertEquals('SVP', user5.Job_Code_Level__c);
    }

    @IsTest
    static void testBatchUserTitleWithoutJobCode() {

        List<User> usrs = [SELECT Id, LastName, Title, username FROM User
                            WHERE IsActive = true AND Profile.Name = 'Field Sales'
                            AND (NOT LastName LIKE 'User_Job_Code_Level_Batch%') LIMIT 1];

        usrs[0].LastName = 'User_Job_Code_Level_Batch_6';
        usrs[0].Title = 'Test';
        usrs[0].username = 'test1234@officedepot.com';
        usrs[0].Job_Code_Level__c = null;
        update usrs;

        Test.startTest();
        // For some reason, Test.startTest() stopped preventing the MIXED_DML_OPERATION error. So System.runAs was added.
        System.runAs(usrs[0]) {
            User_Setting__c userSetting1 = new User_Setting__c(Name='USBSD:111111:', Job_Code_Level__c='Manager');
            User_Setting__c userSetting2 = new User_Setting__c(Name='USBSD:222222:', Job_Code_Level__c='Director');
            User_Setting__c userSetting3 = new User_Setting__c(Name='USBSD:333333:', Job_Code_Level__c='Senior Director');
            User_Setting__c userSetting4 = new User_Setting__c(Name='USBSD:444444:', Job_Code_Level__c='VP');
            insert new List<User_Setting__c> { userSetting1, userSetting2, userSetting3, userSetting4 };
            String query = 'SELECT Id, Title, Job_Code_Level__c FROM User WHERE IsActive = true AND Title != null AND LastName LIKE \'User_Job_Code_Level_Batch_%\'';
            Database.executeBatch(new User_Job_Code_Level_Batch(query), 6);
        }
        Test.stopTest();

        User user1 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_1'];
        User user2 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_2'];
        User user3 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_3'];
        User user4 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_4'];
        User user5 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_5'];
        User user6 = [SELECT Id, Job_Code_Level__c FROM User WHERE LastName = 'User_Job_Code_Level_Batch_6'];
        System.assertEquals('Manager', user1.Job_Code_Level__c);
        System.assertEquals('Director', user2.Job_Code_Level__c);
        System.assertEquals('Senior Director', user3.Job_Code_Level__c);
        System.assertEquals('VP', user4.Job_Code_Level__c);
        System.assertEquals('VP', user5.Job_Code_Level__c);
        System.assertEquals(null, user6.Job_Code_Level__c);
    }

}