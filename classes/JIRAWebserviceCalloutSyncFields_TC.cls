@ isTest
private class JIRAWebserviceCalloutSyncFields_TC {

    private static testMethod void doTest() {
        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new JIRAWebserviceMock());

        Case c = new Case(RecordTypeId = '012E00000008dWdIAI', 
                            Status= 'New', 
                            Origin= 'Internal', 
                            Subject= 'Test Case 1', 
                            Priority = '3-Medium', 
                            Description= 'Case 1', 
                            IT_BU_Reviewer__c = '005E0000003ccDFIAY', 
                            IT_Classification__c = 'Enhancement', 
                            // IT_Priority__c ='3-Medium',
                            IT_Status__c = 'Assign', 
                            //IT_Production_Date__c =2020-01-26,
                            IT_Environment__c = 'Production', 
                            SPRINT_NAME__c= 'NAIT-120674', 
                            Jira_Label__c= 'CSM-Dashboard', 
                            Jira_Component__c = 'Sales Enablement (Disrupters)');
        insert c;


        Jira_Case__c jc = new Jira_Case__c(summary__c = 'prasad test', 
                                              Case__c= c.id, 
                                              EpicLink__c= 'NAIT-120447', 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120674', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard', 
                                              Bug_Environment__c= 'Production');


        insert jc;

        JIRAWebserviceCalloutSyncFields.syncfields(New Id [] { 
                                                   jc.id });

        Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }

        private static testMethod void doTest2() {
        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new JIRAWebserviceMock());

        Case c = new Case(RecordTypeId = '012E00000008dWdIAI', 
                            Status= 'New', 
                            Origin= 'Internal', 
                            Subject= 'Test Case 1', 
                            Priority = '3-Medium', 
                            Description= 'Case 1', 
                            IT_BU_Reviewer__c = '005E0000003ccDFIAY', 
                            IT_Classification__c = 'Enhancement', 
                            // IT_Priority__c ='3-Medium',
                            IT_Status__c = 'Assign', 
                            //IT_Production_Date__c =2020-01-26,
                            IT_Environment__c = 'Production', 
                            SPRINT_NAME__c= 'NAIT-120674', 
                            Jira_Label__c= 'CSM-Dashboard', 
                            Jira_Component__c = 'Sales Enablement (Disrupters)');
        insert c;


        Jira_Case__c jc = new Jira_Case__c(summary__c = 'prasad test', 
                                              Case__c= c.id, 
                                              EpicLink__c= 'NAIT-120447', 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard', 
                                              Bug_Environment__c= 'Production');


        insert jc;

        JIRAWebserviceCalloutSyncFields.syncfields(New Id [] { 
                                                   jc.id });

        Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }
}