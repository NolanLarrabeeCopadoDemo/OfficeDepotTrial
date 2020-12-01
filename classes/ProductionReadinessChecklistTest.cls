// 
// (c) 2015 Appirio, Inc.
//
// **Handler for ProductionReadinessChecklistTest 
//
// August 23 2016    Connor Flynn      Original     S-434794 OD(0786936)

@isTest
private class ProductionReadinessChecklistTest {
    
    static List<Task> setupData(String status, Case c1){
        List<Task> taskList = new List<Task>();

        Task codeReview = new Task();
        codeReview.IT_TASK_TYPE__c = CONSTANTS.CODE_REVIEW;
        codeReview.Status = status;
        codeReview.WhatId = c1.Id;
        taskList.add(codeReview);

        Task qa = new Task();
        qa.IT_TASK_TYPE__c = CONSTANTS.QA;
        qa.Status = status;
        qa.WhatId = c1.Id;
        taskList.add(qa);

        Task uat = new Task();
        uat.IT_TASK_TYPE__c = CONSTANTS.UAT;
        uat.Status = status;
        uat.WhatId = c1.Id;
        taskList.add(uat);

        return taskList;
    }

    @isTest static void redTest(){
        Case c1 = new Case();
        c1.QA_Not_Required__c = false;
        insert c1;


        List<Task> taskList = setupData('Cancelled', c1);
        insert taskList;

        

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(c1);
        ProductionReadinessChecklistController ctrl = new ProductionReadinessChecklistController(sc);

        System.assertEquals(ctrl.productionDateAddedGreen, true);
        System.assertEquals(ctrl.productionDateAddedRed, false);

        System.assertEquals(ctrl.codeReviewCompletedGreen, false);
        System.assertEquals(ctrl.codeReviewCompletedYellow, true);
        System.assertEquals(ctrl.codeReviewCompletedRed, false);

        System.assertEquals(ctrl.qaCompletedGreen, false);
        System.assertEquals(ctrl.qaCompletedYellow, true);
        System.assertEquals(ctrl.qaCompletedRed, false);

        System.assertEquals(ctrl.qaTestScriptsOrCasesGreen, false);
        System.assertEquals(ctrl.qaTestScriptsOrCasesRed, true);

        System.assertEquals(ctrl.uatCompletedGreen, false);
        System.assertEquals(ctrl.uatCompletedYellow, true);
        System.assertEquals(ctrl.uatCompletedRed, false);

        System.assertEquals(ctrl.manifestItemsAddedGreen, false);
        System.assertEquals(ctrl.manifestItemsAddedRed, true);

        System.assertEquals(ctrl.color, 'Red');

        Test.stopTest();
    }
    
    @isTest static void yellowTest(){
        Case c1 = new Case();
        c1.IT_Production_Date__c = System.Today().addDays(8);
        c1.QA_Not_Required__c = false;
        insert c1;

        List<Task> taskList = setupData('Completed', c1);
        for(Task tmpTask : taskList){
            if(tmpTask.IT_TASK_TYPE__c == CONSTANTS.CODE_REVIEW){
                tmpTask.Status = 'Cancelled';
            } else if(tmpTask.IT_TASK_TYPE__c == CONSTANTS.UAT){
                tmpTask.Status = 'Cancelled';
            } 
        }
        insert taskList;

        SFDC_Test_Case__c tc = new SFDC_Test_Case__c();
        tc.Support_Case__c = c1.Id;
        insert tc;

        Manifest_Items__c mi = new Manifest_Items__c();
        mi.Support_Case__c = c1.Id;
        insert mi;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(c1);
        ProductionReadinessChecklistController ctrl = new ProductionReadinessChecklistController(sc);
        

        System.assertEquals(ctrl.productionDateAddedGreen, true);
        System.assertEquals(ctrl.productionDateAddedRed, false);

        System.assertEquals(ctrl.codeReviewCompletedGreen, false);
        System.assertEquals(ctrl.codeReviewCompletedYellow, true);
        System.assertEquals(ctrl.codeReviewCompletedRed, false);

        System.assertEquals(ctrl.qaCompletedGreen, true);
        System.assertEquals(ctrl.qaCompletedYellow, false);
        System.assertEquals(ctrl.qaCompletedRed, false);

        System.assertEquals(ctrl.qaTestScriptsOrCasesGreen, true);
        System.assertEquals(ctrl.qaTestScriptsOrCasesRed, false);

        System.assertEquals(ctrl.uatCompletedGreen, false);
        System.assertEquals(ctrl.uatCompletedYellow, true);
        System.assertEquals(ctrl.uatCompletedRed, false);

        System.assertEquals(ctrl.manifestItemsAddedGreen, true);
        System.assertEquals(ctrl.manifestItemsAddedRed, false);

        System.assertEquals(ctrl.color, 'Yellow');
        Test.stopTest();
    }

    @isTest static void greenTest(){
        Case c1 = new Case();
        c1.IT_Production_Date__c = System.Today().addDays(8);
        c1.QA_Not_Required__c = false;
        insert c1;

        List<Task> taskList = setupData('Completed', c1);
        insert taskList;

        SFDC_Test_Case__c tc = new SFDC_Test_Case__c();
        tc.Support_Case__c = c1.Id;
        insert tc;

        Manifest_Items__c mi = new Manifest_Items__c();
        mi.Support_Case__c = c1.Id;
        insert mi;

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(c1);
        ProductionReadinessChecklistController ctrl = new ProductionReadinessChecklistController(sc);
        
        System.assertEquals(ctrl.codeReviewCompletedGreen, true);
        System.assertEquals(ctrl.codeReviewCompletedYellow, false);
        System.assertEquals(ctrl.codeReviewCompletedRed, false);

        System.assertEquals(ctrl.qaCompletedGreen, true);
        System.assertEquals(ctrl.qaCompletedYellow, false);
        System.assertEquals(ctrl.qaCompletedRed, false);

        System.assertEquals(ctrl.uatCompletedGreen, true);
        System.assertEquals(ctrl.uatCompletedYellow, false);
        System.assertEquals(ctrl.uatCompletedRed, false);

        System.assertEquals(ctrl.color, 'Green');

        User testName = ctrl.qaCompletedBy;
        testName = ctrl.codeReviewCompletedBy;
        testName = ctrl.uatCompletedBy;
        Test.stopTest();
    }
}