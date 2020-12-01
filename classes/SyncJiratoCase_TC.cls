@ isTest
private class SyncJiratoCase_TC {

    private static testMethod void doTest1() {
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
                                              Jira_source_status__c='Requested',
                                              Case_Stage__c = 'Development',
                                              Bug_Environment__c= 'Production');


        insert jc;

        SyncJiratoCase.syncCase(New Id [] {  jc.id });

    

    /*      switch on source_status {
                when 'Closed' {
                    if(s.Case_Stage__c == 'Development') {

                when 'In Progress' {
                    if(s.Case_Stage__c == 'Development') {
                        c.IT_Status__c = 'In Development';
                        c.status = 'In progress';
                    }
                    else if(s.Case_Stage__c == 'UAT') {
                        c.IT_Status__c = 'In UAT';
                        c.status = 'In progress';
                    }

                }
                when 'Pending test' {
                    System.debug('when block 7');
                    if(s.Case_Stage__c == 'Development') {
                        c.IT_Status__c = 'In QA';
                        c.status = 'In progress';
                    } 
                    else if(s.Case_Stage__c == 'UAT') {
                        c.IT_Status__c = 'In UAT';
                        c.status = 'In progress';

                    }
                }
                when 'Awaiting Migration to Production' {
                    System.debug('when block 7');
                    if(s.Case_Stage__c == 'UAT') {
                        c.IT_Status__c = 'Awaiting Prod Migration';
                        c.status = 'In progress';
                    }
                    
                }


                when else {
                    System.debug('default');
                }
            }              
*/
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

                Jira_Case__c jc1 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'Development',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='Requested',
                                              Bug_Environment__c= 'Production');


        insert jc1;

        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc1.id });

    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }

private static testMethod void doTest3() {
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

Jira_Case__c jc2 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Case__c= c.id, 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'UAT',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='Requested',
                                              Bug_Environment__c= 'Production');


        insert jc2;

        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc2.id });


                                                    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }

    private static testMethod void doTest4() {
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

Jira_Case__c jc2 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Case__c= c.id, 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'Development',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='Closed',
                                              Bug_Environment__c= 'Production');


        insert jc2;

        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc2.id });


                                                    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }
    private static testMethod void doTest5() {
        Test.startTest();
        Test.SetMock(HttpCallOutMock.class, new JIRAWebserviceMock());

        Case c = new Case(RecordTypeId = '012E00000008dWdIAI', 
                            Status= 'New', 
                            Origin= 'Internal', 
                            Subject= 'Test Case 1', 
                            Priority = '3-Medium', 
                            Description= 'Case 1', 
                            //IT_BU_Reviewer__c = '005E0000003ccDFIAY', 
                            IT_Classification__c = 'Enhancement', 
                            // IT_Priority__c ='3-Medium',
                         //   IT_Status__c = 'Assign', 
                            //IT_Production_Date__c =2020-01-26,
                            IT_Environment__c = 'Production', 
                            SPRINT_NAME__c= 'NAIT-120674', 
                            Jira_Label__c= 'CSM-Dashboard', 
                            Jira_Component__c = 'Sales Enablement (Disrupters)');
        insert c;

Jira_Case__c jc2 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Case__c= c.id, 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'UAT',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='Requested',
                                              Bug_Environment__c= 'Production');


        insert jc2;
Jira_Case__c jc3 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Case__c= c.id, 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'Development',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='Closed',
                                              Bug_Environment__c= 'Production');


        insert jc3;
        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc3.id });


                                                    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }


      private static testMethod void doTest6() {
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

Jira_Case__c jc2 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Case__c= c.id, 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'Development',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='Open',
                                              Bug_Environment__c= 'Production');


        insert jc2;

        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc2.id });


                                                    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }



       private static testMethod void doTest7() {
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

Jira_Case__c jc2 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Case__c= c.id, 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'UAT',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='Open',
                                              Bug_Environment__c= 'Production');


        insert jc2;

        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc2.id });


                                                    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }




    
      private static testMethod void doTest8() {
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

Jira_Case__c jc2 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Case__c= c.id, 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'Development',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='In Progress',
                                              Bug_Environment__c= 'Production');


        insert jc2;

        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc2.id });


                                                    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }



       private static testMethod void doTest9() {
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

Jira_Case__c jc2 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Case__c= c.id, 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'UAT',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='In Progress',
                                              Bug_Environment__c= 'Production');


        insert jc2;

        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc2.id });


                                                    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }

     private static testMethod void doTest10() {
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

Jira_Case__c jc2 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Case__c= c.id, 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'Development',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='Pending test',
                                              Bug_Environment__c= 'Production');


        insert jc2;

        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc2.id });


                                                    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }



       private static testMethod void doTest11() {
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

Jira_Case__c jc2 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Case__c= c.id, 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'UAT',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='Pending test',
                                              Bug_Environment__c= 'Production');


        insert jc2;

        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc2.id });


                                                    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }


     private static testMethod void doTest12() {
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

Jira_Case__c jc2 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Case__c= c.id, 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'Development',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='Awaiting Migration to Production',
                                              Bug_Environment__c= 'Production');


        insert jc2;

        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc2.id });


                                                    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }



       private static testMethod void doTest13() {
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

Jira_Case__c jc2 = new Jira_Case__c(summary__c = 'prasad test', 
                                             
                                              EpicLink__c= 'NAIT-120447', 
                                              Case__c= c.id, 
                                              Components__c= 'Sales Enablement (Disrupters)', 
                                              Description__c= 'prasad test', 
                                              Jira_ID__c= 'NAIT-120675', 
                                              priority__c= '3-Medium', 
                                              Issue_Type__c= 'Story', 
                                              Case_Stage__c = 'UAT',
                                              Found_In__c= 'Production', 
                                              Labels__c= 'CSM_Dashboard',                                              
                                              Jira_source_status__c='Awaiting Migration to Production',
                                              Bug_Environment__c= 'Production');


        insert jc2;

        SyncJiratoCase.syncCase(New Id [] { 
                                                   jc2.id });


                                                    Test.stopTest();

        // l = [Select OwnerID From Lead where ID = :l.id];
        // system.assertEquals(WHATYOUEXPECT, l.OwnerID);

    }


}