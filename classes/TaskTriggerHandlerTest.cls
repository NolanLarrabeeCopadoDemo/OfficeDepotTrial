// Appirio 2015 
// Universal trigger handler for Task object
//
// NBOCK - Original - S-364742 - consolidates updateSupportCase, updateLeadonTaskUpdate and TaskEvents triggers
// NBOCK - Modified - S-377010 - 2.5.2016 - update IT Status on case related to Task when task is in progress

@istest
private class TaskTriggerHandlerTest {
    static testMethod void testTrigger() {
        //create test data
        Cadence__c cad = new Cadence__c(Name = 'Loyalty', Cadence__c = 30, Lifecycle_Stage__c = 'LOY');
        insert cad;

        Id uId = UserInfo.getUserId();
        Case tc = new Case();
        tc.OwnerId = uId;
        tc.IT_BU_Reviewer__c = uId;
        insert tc;

        Task tt = new Task();
        tt.Task_Type__c = 'Business';
        tt.Action__c = 'Migration Validation';
        tt.WhatId = tc.Id;
        tt.Outcome__c = 'Rejected';
        tt.Status = 'Completed';
        tt.Description = 'Test';
        Test.startTest();
            insert tt;
            //NBOCK - S-377010 - added to increase coverage
            tt.Outcome__c = 'Approved';
            update tt;
        Test.stopTest();
    }
    static testMethod void testTrigger2() {
        //create test data
        Cadence__c cad = new Cadence__c(Name = 'Loyalty', Cadence__c = 30, Lifecycle_Stage__c = 'LOY');
        insert cad;

        Id uId = UserInfo.getUserId();
        Case tc = new Case();
        tc.OwnerId = uId;
        tc.IT_BU_Reviewer__c = uId;
        insert tc;

        Task tt = new Task();
        tt.Task_Type__c = 'IT';
        tt.Action__c = 'Development';
        tt.WhatId = tc.Id;
        tt.Outcome__c = 'Approved';
        tt.Status = 'Completed';
        tt.Description = 'Test';
        Test.startTest();
            insert tt;
        Test.stopTest();
    }
    static testMethod void testTrigger3() {
        //create test data
        Cadence__c cad = new Cadence__c(Name = 'Loyalty', Cadence__c = 30, Lifecycle_Stage__c = 'LOY');
        insert cad;

        Id uId = UserInfo.getUserId();
        Case tc = new Case();
        tc.OwnerId = uId;
        tc.IT_BU_Reviewer__c = uId;
        tc.IT_Production_Date__c = System.Today();
        insert tc;

        Task tt = new Task();
        tt.Task_Type__c = 'Business';
        tt.Action__c = 'Validation';
        tt.WhatId = tc.Id;
        tt.Outcome__c = 'Rejected';
        tt.Status = 'Completed';
        Test.startTest();
            insert tt;
        Test.stopTest();
    }
    static testMethod void testTrigger4() {
        //create test data
        Schema.DescribeSobjectResult r = Schema.SobjectType.Task;
        Map<String,schema.RecordtypeInfo> TskRecType = r.getRecordTypeInfosByName();
        Id inSalesRecTypeId =TskRecType.get('Inside Sales').getRecordTypeId();

        Cadence__c cad = new Cadence__c(Name = 'Loyalty', Cadence__c = 30, Lifecycle_Stage__c = 'SOW');
        insert cad;

        Id uId = UserInfo.getUserId();
        Account testAcc = new Account();
        testAcc.Name = 'Test Account Task Triggers';
        testAcc.OwnerId = uId;
        insert testAcc;

        Task tt = new Task();
        tt.RecordTypeId = inSalesRecTypeId;
        tt.Call_Disposition__c = 'Sales Related';
        tt.Status = 'Completed';
        tt.Task_Type__c = 'Business';
        tt.Action__c = 'Validation';
        tt.WhatId = testAcc.Id;
        Test.startTest();
            insert tt;
        Test.stopTest();
    }

    static testMethod void testTrigger5() {
        //create test data
        Cadence__c cad = new Cadence__c(Name = 'Loyalty', Cadence__c = 30, Lifecycle_Stage__c = 'LOY');
        insert cad;

        Id uId = UserInfo.getUserId();
        Case tc = new Case();
        tc.OwnerId = uId;
        tc.IT_BU_Reviewer__c = uId;
        tc.IT_Production_Date__c = Date.Today();
        insert tc;

        Task tt = new Task();
        tt.Task_Type__c = 'IT';
        tt.Action__c = 'Migration';
        tt.WhatId = tc.Id;
        Test.startTest();
            insert tt;
        Test.stopTest();
    }

    static testMethod void testTrigger6() {
        //create test data
        Schema.DescribeSobjectResult r = Schema.SobjectType.Task;
        Map<String,schema.RecordtypeInfo> TskRecType = r.getRecordTypeInfosByName();
        Id inSalesRecTypeId =TskRecType.get('Inside Sales').getRecordTypeId();

        Cadence__c cad = new Cadence__c(Name = 'Loyalty', Cadence__c = 30, Lifecycle_Stage__c = 'SOW');
        insert cad;

        Id uId = UserInfo.getUserId();
        Account testAcc = new Account();
        testAcc.Name = 'Test Account Task Triggers';
        testAcc.OwnerId = uId;
        insert testAcc;

        Task tt = new Task();
        tt.RecordTypeId = inSalesRecTypeId;
        tt.Call_Disposition__c = 'Pricing Maintenance';
        tt.Disposition_Code__c = 'Pricing Escalation';
        tt.Status = 'Completed';
        tt.Task_Type__c = 'Business';
        tt.Action__c = 'Validation';
        tt.WhatId = testAcc.Id;
        tt.OwnerId = uId;
        Test.startTest();
            insert tt;
        Test.stopTest();
    }
    //NBOCK - S-377010 - added to increase coverage
    static testMethod void testTrigger7() {
        //create test data
        Cadence__c cad = new Cadence__c(Name = 'Loyalty', Cadence__c = 30, Lifecycle_Stage__c = 'LOY');
        insert cad;

        Id uId = UserInfo.getUserId();
        Case tc = new Case();
        tc.OwnerId = uId;
        tc.IT_BU_Reviewer__c = uId;
        tc.IT_Production_Date__c = System.Today();
        insert tc;

        Task tt = new Task();
        tt.Task_Type__c = 'Business';
        tt.Action__c = 'Validation';
        tt.WhatId = tc.Id;
        tt.Outcome__c = 'Approved';
        tt.Status = 'Completed';
        Test.startTest();
            insert tt;
        Test.stopTest();
    }
    //Added by Najma Ateeq for Story #S-377014
    static testMethod void TestSendEmailToTaskOwner(){
        Case tc = new Case();
        tc.OwnerId = UserInfo.getUserId();
        tc.IT_BU_Reviewer__c = UserInfo.getUserId();
        tc.IT_Production_Date__c = Date.Today();
        //Added by Najam Ateeq for Story S-377012
        tc.IT_Environment__c = 'Production';
        tc.IT_Classification__c = 'Enhancement';
        tc.IT_Track__c = 'Fast Track';
        //End -     Added by Najam Ateeq for Story S-377012
        insert tc;
        
        Task tt = new Task();
        tt.Call_Disposition__c = 'Pricing Maintenance';
        tt.Disposition_Code__c = 'Pricing Escalation';
        tt.Status = 'Completed';
        tt.Task_Type__c = 'Business';
        tt.Action__c = 'Validation';
        tt.WhatId = tc.Id;
        tt.OwnerId = UserInfo.getUserId();
        //NBOCK - S-377010 - added to increase coverage
        tt.From_Case_Tasking_Process__c = true;
        
        // updated for the story #S-418606 (00716996) #START
        tt.subject = 'test subject'; 
        tt.IT_TASK_TYPE__c = 'Design';
        tt.WRF_Task_Complete_Dt__c = Date.today();
        // updated for the story #S-418606 (00716996) #END
        
        Test.startTest();
            insert tt;
        Test.stopTest();
    }
    //End - Added by Najma Ateeq for Story #S-377014
    //NBOCK - S-377010 - 2.5.2016 start
    /*
    static testMethod void testUpdateCaseITStatus() {
        //create test data
        Cadence__c cad = new Cadence__c(Name = 'Loyalty', Cadence__c = 30, Lifecycle_Stage__c = 'LOY');
        insert cad;

        Id uId = UserInfo.getUserId();
        Case tc = new Case();
        tc.OwnerId = uId;
        tc.IT_BU_Reviewer__c = uId;
        insert tc;

        Task tt = new Task();
        tt.Task_Type__c = 'IT';
        tt.Action__c = 'Other';
        tt.WhatId = tc.Id;
        tt.Status = 'New';
        tt.IT_Task_Type__c = Label.STDesign;
        tt.Subject = Label.STDesign;
        insert tt;

        Test.startTest();
            tt.Status = Label.STInProgress;
            update tt;
            //System.assertEquals(Label.STInDesign, [SELECT Id, IT_Status__c FROM Case WHERE Id = :tc.Id LIMIT 1].IT_Status__c);

            tt.IT_Task_Type__c = Label.STBuild;
            tt.Subject = Label.STBuild;
            update tt;
            //System.assertEquals(Label.STInDevelopment, [SELECT Id, IT_Status__c FROM Case WHERE Id = :tc.Id LIMIT 1].IT_Status__c);

            tt.IT_Task_Type__c = Label.STCodeReview;
            tt.Subject = Label.STCodeReview;
            update tt;
            //System.assertEquals(Label.STInCodeReview, [SELECT Id, IT_Status__c FROM Case WHERE Id = :tc.Id LIMIT 1].IT_Status__c);

            tt.IT_Task_Type__c = Label.STUATMigration;
            tt.Subject = Label.STUATMigration;
            update tt;
            //System.assertEquals(Label.STAwaitingUATMigration, [SELECT Id, IT_Status__c FROM Case WHERE Id = :tc.Id LIMIT 1].IT_Status__c);
        Test.stopTest();
    }
    
     Commented for the story #S-418606 (00716996) #START
        static testMethod void testUpdateCaseITStatus2() {
        //create test data
        Cadence__c cad = new Cadence__c(Name = 'Loyalty', Cadence__c = 30, Lifecycle_Stage__c = 'LOY');
        insert cad;

        Id uId = UserInfo.getUserId();
        Case tc = new Case();
        tc.OwnerId = uId;
        tc.IT_BU_Reviewer__c = uId;
        insert tc;

        Task tt = new Task();
        tt.Task_Type__c = 'IT';
        tt.Action__c = 'Other';
        tt.WhatId = tc.Id;
        tt.Status = 'New';
        tt.IT_Task_Type__c = Label.STDesign;
        tt.Subject = Label.STDesign;
        insert tt;

        Test.startTest();
            tt.Status = Label.STInProgress;
            tt.IT_Task_Type__c = Label.STQA;
            tt.Subject = Label.STQA;
            update tt;
            System.assertEquals(Label.STInQA, [SELECT Id, IT_Status__c FROM Case WHERE Id = :tc.Id LIMIT 1].IT_Status__c);

            tt.IT_Task_Type__c = Label.STUAT;
            tt.Subject = Label.STUAT;
            update tt;
            System.assertEquals(Label.STInUAT, [SELECT Id, IT_Status__c FROM Case WHERE Id = :tc.Id LIMIT 1].IT_Status__c);

            tt.IT_Task_Type__c = Label.STUAT;
            tt.Subject = Label.STUAT;
            tt.Status = Label.STComplete;
            update tt;
            System.assertEquals(Label.STAwaitingProdMigration, [SELECT Id, IT_Status__c FROM Case WHERE Id = :tc.Id LIMIT 1].IT_Status__c);
                      
            
        Test.stopTest();
    }
    
    Commented for the story #S-418606 (00716996) #END */
    
        //NBOCK - S-377010 - 2.5.2016 end
        
        //Start - Added for Story S-407212
    static testMethod void testUpdateCaseITStatus3() {
        //create test data
        Cadence__c cad = new Cadence__c(Name = 'Loyalty', Cadence__c = 30, Lifecycle_Stage__c = 'LOY');
        insert cad;

        Id uId = UserInfo.getUserId();
        Case tc = new Case();
        tc.OwnerId = uId;
        tc.IT_BU_Reviewer__c = uId;
        insert tc;

        Task tt = new Task();
        tt.Task_Type__c = 'IT';
        tt.Action__c = 'Other';
        tt.WhatId = tc.Id;
        tt.Status = 'New';
        tt.IT_Task_Type__c = Label.STDesign;
        tt.Subject = Label.STDesign;
        insert tt;

        Test.startTest();
            tt.IT_Task_Type__c = Label.STARBRequired;
            tt.Subject = Label.STARBRequired;
            tt.Status = Label.STInProgress;
            update tt;
            //System.assertEquals(Label.STInARB, [SELECT Id, IT_Status__c FROM Case WHERE Id = :tc.Id LIMIT 1].IT_Status__c);
            
            tt.IT_Task_Type__c = Label.STUsability;
            tt.Subject = Label.STUsability;
            update tt;
            //System.assertEquals(Label.STInUsability, [SELECT Id, IT_Status__c FROM Case WHERE Id = :tc.Id LIMIT 1].IT_Status__c);
        Test.stopTest();    
    }       
    //End - Story S-407212
        
        // Added by Mohit Batwada for S-386208 //
        
        static testMethod void testProductionDateBlank(){
                Case tc = new Case();
                tc.OwnerId = UserInfo.getUserId();
                tc.IT_BU_Reviewer__c = UserInfo.getUserId();
                tc.IT_Environment__c = 'Production';
                tc.IT_Classification__c = 'Enhancement';
                tc.IT_Track__c = 'Fast Track';
                insert tc;
                
                Task tt = new Task();
                tt.Call_Disposition__c = 'Pricing Maintenance';
                tt.Disposition_Code__c = 'Pricing Escalation';
                tt.Status = 'Completed';
                tt.Task_Type__c = 'Business';
                tt.Action__c = 'Validation';
                tt.outcome__c = 'Approved';
                tt.WhatId = tc.Id;
                tt.OwnerId = UserInfo.getUserId();
                tt.From_Case_Tasking_Process__c = true;
                Test.startTest();
                try{
              insert tt;
            }
            catch(Exception e){
              Boolean expectedExceptionThrown =  e.getMessage().contains('A Production Date is required to complete') ? true : false;
              system.assertEquals(expectedExceptionThrown,true);       
            } 
                Test.stopTest();
        }
        
        static testMethod void testProductionDateNotBlank(){
            Case tc = new Case();
            tc.OwnerId = UserInfo.getUserId();
            tc.IT_BU_Reviewer__c = UserInfo.getUserId();
            tc.IT_Production_Date__c = Date.Today();
            insert tc;
            
            Task tt = new Task();
            tt.Call_Disposition__c = 'Pricing Maintenance';
            tt.Disposition_Code__c = 'Pricing Escalation';
            tt.Status = 'Completed';
            tt.Task_Type__c = 'Business';
            tt.Action__c = 'Validation';
            tt.outcome__c = 'Approved';
            tt.WhatId = tc.Id;
            tt.OwnerId = UserInfo.getUserId();
            tt.From_Case_Tasking_Process__c = true;
            Test.startTest();
              insert tt;
       
            //List<Task> taskLst = [select Id, Action__c from Task where WhatId =: tc.Id ];
            //system.assertEquals('Validation',taskLst.get(0).Action__c);
            Test.stopTest();
        }
        // End //

        //START NSHARP S-423438 7.1.2016
        /*static testMethod void testUatUpdate(){
            Case tc = new Case();
            tc.OwnerId = UserInfo.getUserId();
            tc.IT_BU_Reviewer__c = UserInfo.getUserId();
            tc.IT_Production_Date__c = Date.Today();
            insert tc;

            Task tt = new Task();
            tt.Call_Disposition__c = 'Pricing Maintenance';
            tt.Disposition_Code__c = 'Pricing Escalation';
            tt.Status = 'Completed';
            tt.Task_Type__c = 'Business';
            tt.Action__c = 'Validation';
            tt.outcome__c = 'Approved';
            tt.WhatId = tc.Id;
            tt.OwnerId = UserInfo.getUserId();
            tt.From_Case_Tasking_Process__c = true;
            tt.IT_TASK_TYPE__c = 'UAT';
            insert tt;

            tt.OwnerId = [Select Id FROM User WHERE IsActive=true LIMIT 1].Id;
            update tt;

        }*/
        //END NSHARP S-423438 7.1.2016
}